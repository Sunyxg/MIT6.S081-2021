#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"

// Simple logging that allows concurrent FS system calls.
//
// A log transaction contains the updates of multiple FS system
// calls. The logging system only commits when there are
// no FS system calls active. Thus there is never
// any reasoning required about whether a commit might
// write an uncommitted system call's updates to disk.
//
// A system call should call begin_op()/end_op() to mark
// its start and end. Usually begin_op() just increments
// the count of in-progress FS system calls and returns.
// But if it thinks the log is close to running out, it
// sleeps until the last outstanding end_op() commits.
//
// The log is a physical re-do log containing disk blocks.
// The on-disk log format:
//   header block, containing block #s for block A, B, C, ...
//   block A
//   block B
//   block C
//   ...
// Log appends are synchronous.

// Contents of the header block, used for both the on-disk header block
// and to keep track in memory of logged block# before commit.
// 磁盘log区中的第一个block，记录了当前保存在log区的block数和其对应的索引值
struct logheader {
  int n;
  int block[LOGSIZE];
};

// 保存log区的属性信息，以及log header的缓存映射
struct log {
  struct spinlock lock;
  int start; // log区在磁盘上的起始block
  int size; // log区总的block数目
  int outstanding; // 当前正在使用LOG机制的文件系统调用数目(目的是别超过了LOG系统总容量)
  int committing;  // 标记是否处于log的commit过程
  int dev;
  struct logheader lh; //磁盘log header在内存中的映射
};
struct log log;

static void recover_from_log(void);
static void commit();

// 初始化log系统
void
initlog(int dev, struct superblock *sb)
{
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");
  
  // 根据superblock载入log区基本信息
  initlock(&log.lock, "log");
  log.start = sb->logstart;
  log.size = sb->nlog;
  log.dev = dev;

  //如果存在log缓存，进行数据恢复
  recover_from_log();
}

// Copy committed blocks from log to their home location
// 将commited的log数据转移到他们实际所在的block
static void
install_trans(int recovering)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst(在buffer cache中复制)
    bwrite(dbuf);  // write dst to disk 从bcache写到磁盘
    if(recovering == 0)
      bunpin(dbuf);
    brelse(lbuf);
    brelse(dbuf);
  }
}

// Read the log header from disk into the in-memory log header
// 读取logheader
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  
  //如果bcache中log.lh.n 与 磁盘上lh->n相等，更新bcache中log内容
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
}

// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
// 写入logheader
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;

  //如果bcache中log.lh.n 与 磁盘上lh->n相等，更新磁盘上log内容
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
  brelse(buf);
}


// 数据恢复函数
static void
recover_from_log(void)
{
  // 将log中内容复制到他们实际所在的block
  read_head();
  install_trans(1); // if committed, copy from log to disk

  // 清除log
  log.lh.n = 0;
  write_head(); // clear the log
}

// called at the start of each FS system call.
// 使用文件系统调用起始判断
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    // 如果log区处于committing状态，则睡眠等待
    if(log.committing){
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // 判断当前的log剩余空间是否不足， 如果是，睡眠等待。
      sleep(&log, &log.lock);
    } else {
      // 增加正在使用的文件系统调用的计数
      log.outstanding += 1;
      release(&log.lock);
      break;
    }
  }
}

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
// 使用文件系统调用之后执行
// 减少正在使用的文件系统调用的计数
// 并唤醒正在等待的文件系统调用
void
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  
  // 判断只有当前没有文件系统调用执行时才允许commit
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);

  //执行commit, 并唤醒正在等待的文件系统调用
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}

// Copy modified blocks from cache to log.
// 将数据从buffer cache写入log区
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from);
    brelse(to);
  }
}

// log由内存写入到磁盘的事务级处理
static void
commit()
{
  if (log.lh.n > 0) {
    //把所有修改后的操作写入到log块中(注意：log是实际在硬盘上存在的区域)
    write_log();     // Write modified blocks from cache to log

    //在这一步之前崩溃，所有的log块的写入会丢失
    //把log块(内存)的元信息写入log块(disk)上
    write_head();    // Write header to disk -- the real commit

    //复制log中所有数据到实际的区域
    install_trans(0); // Now install writes to home locations

    
    //清空内存中log块元信息的数据信息
    log.lh.n = 0;
    //在这一步之前崩溃，下次开机会重新复制log块的信息
    write_head();    // Erase the transaction from the log
  }
}

// Caller has modified b->data and is done with the buffer.
// Record the block number and pin in the cache by increasing refcnt.
// commit()/write_log() will do the disk write.
//
// log_write() replaces bwrite(); a typical use is:
//   bp = bread(...)
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
// log机制下的写磁盘操作，将bcache内容写入到磁盘中(替代bwrite())
// 将需要写入磁盘的bcache添加到logheader中
// 真正的写磁盘操作在end_op()的commit()函数中实现
void
log_write(struct buf *b)
{
  int i;

  acquire(&log.lock);
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  // 判断要写入的bcache是否位于log中
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorption
      break;
  }
  
  // 在logheader中记录要写入log的bcache
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    log.lh.n++;
  }
  release(&log.lock);
}

