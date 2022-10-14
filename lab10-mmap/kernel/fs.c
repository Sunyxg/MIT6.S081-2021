// File system implementation.  Five layers:
//   + Blocks: allocator for raw disk blocks.
//   + Log: crash recovery for multi-step updates.
//   + Files: inode allocator, reading, writing, metadata.
//   + Directories: inode with special contents (list of other inodes!)
//   + Names: paths like /usr/rtm/xv6/fs.c for convenient naming.
//
// This file contains the low-level file system manipulation
// routines.  The (higher-level) system call implementations
// are in sysfile.c.

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"
#include "fs.h"
#include "buf.h"
#include "file.h"
#include "fcntl.h"

#define min(a, b) ((a) < (b) ? (a) : (b))
// there should be one superblock per disk device, but we run with
// only one device
struct superblock sb; 

// Read the super block.
// 读取superblock内容到bcache中
static void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
}

// 文件系统初始化，读取superblock，并初始化log系统
void
fsinit(int dev) {
  readsb(dev, &sb);
  if(sb.magic != FSMAGIC)
    panic("invalid file system");
  initlog(dev, &sb);
}

// Zero a block.
// 将磁盘中第bno个块的数据置0
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
  memset(bp->data, 0, BSIZE);
  log_write(bp);
  brelse(bp);
}

// Blocks.

// Allocate a zeroed disk block.
// 分配磁盘数据块，并将相应位图置1，返回block块的索引号
static uint
balloc(uint dev) 
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb)); //读取第block所在位图的信息
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // 判断位图中指示的第bi个block是否为空
        bp->data[bi/8] |= m;  // Mark block in use. 标记位图中第bi个block已经被使用
        log_write(bp); //
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}

// Free a disk block.
// 释放磁盘数据块，将相应位图清零
static void
bfree(int dev, uint b)
{
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
  log_write(bp);
  brelse(bp);
}

// Inodes.
//
// An inode describes a single unnamed file.
// The inode disk structure holds metadata: the file's type,
// its size, the number of links referring to it, and the
// list of blocks holding the file's content.
//
// The inodes are laid out sequentially on disk at
// sb.startinode. Each inode has a number, indicating its
// position on the disk.
//
// The kernel keeps a table of in-use inodes in memory
// to provide a place for synchronizing access
// to inodes used by multiple processes. The in-memory
// inodes include book-keeping information that is
// not stored on disk: ip->ref and ip->valid.
//
// An inode and its in-memory representation go through a
// sequence of states before they can be used by the
// rest of the file system code.
//
// * Allocation: an inode is allocated if its type (on disk)
//   is non-zero. ialloc() allocates, and iput() frees if
//   the reference and link counts have fallen to zero.
//
// * Referencing in table: an entry in the inode table
//   is free if ip->ref is zero. Otherwise ip->ref tracks
//   the number of in-memory pointers to the entry (open
//   files and current directories). iget() finds or
//   creates a table entry and increments its ref; iput()
//   decrements ref.
//
// * Valid: the information (type, size, &c) in an inode
//   table entry is only correct when ip->valid is 1.
//   ilock() reads the inode from
//   the disk and sets ip->valid, while iput() clears
//   ip->valid if ip->ref has fallen to zero.
//
// * Locked: file system code may only examine and modify
//   the information in an inode and its content if it
//   has first locked the inode.
//
// Thus a typical sequence is:
//   ip = iget(dev, inum)
//   ilock(ip)
//   ... examine and modify ip->xxx ...
//   iunlock(ip)
//   iput(ip)
//
// ilock() is separate from iget() so that system calls can
// get a long-term reference to an inode (as for an open file)
// and only lock it for short periods (e.g., in read()).
// The separation also helps avoid deadlock and races during
// pathname lookup. iget() increments ip->ref so that the inode
// stays in the table and pointers to it remain valid.
//
// Many internal file system functions expect the caller to
// have locked the inodes involved; this lets callers create
// multi-step atomic operations.
//
// The itable.lock spin-lock protects the allocation of itable
// entries. Since ip->ref indicates whether an entry is free,
// and ip->dev and ip->inum indicate which i-node an entry
// holds, one must hold itable.lock while using any of those fields.
//
// An ip->lock sleep-lock protects all ip-> fields other than ref,
// dev, and inum.  One must hold ip->lock in order to
// read or write that inode's ip->valid, ip->size, ip->type, &c.

// inode在内存中对应的缓存块（itable）
struct {
  struct spinlock lock;
  struct inode inode[NINODE];
} itable;

// 初始化inode缓存区的锁
void
iinit()
{
  int i = 0;
  
  initlock(&itable.lock, "itable");
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&itable.inode[i].lock, "inode");
  }
}

static struct inode* iget(uint dev, uint inum);

// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
// 从磁盘中申请一个空的dinode，并返回对应的inode指针
struct inode*
ialloc(uint dev, short type)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb)); //读取第inum个结点的位置
    dip = (struct dinode*)bp->data + inum%IPB; //获得该结点的地址
    if(dip->type == 0){  //判断dinode是否为空
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum); //返回其在缓存中对应的inode形式
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}

// Copy a modified in-memory inode to disk.
// Must be called after every change to an ip->xxx field
// that lives on disk.
// Caller must hold ip->lock.
// 将内存中的inode信息写入到磁盘中对应的dinode
void
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
}

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
// 在内存的inode缓存区中查找未使用的inode块
static struct inode*
iget(uint dev, uint inum)
{
  struct inode *ip, *empty;

  acquire(&itable.lock);

  // 如果该dinode在内存中已缓存
  empty = 0;
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++; // 引用加1
      release(&itable.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // 记录itable中空闲的inode.
      empty = ip;
  }

  // Recycle an inode entry.
  if(empty == 0)
    panic("iget: no inodes");

  // 该dinode在内存中没有缓存，将记录的空闲inode作为其缓存
  // 初始化inode，还未从磁盘中读取dinode数据，所以valid为0
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&itable.lock);

  return ip;
}


// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
// 增加inode的引用
struct inode*
idup(struct inode *ip)
{
  acquire(&itable.lock);
  ip->ref++;
  release(&itable.lock);
  return ip;
}

// Lock the given inode.
// Reads the inode from disk if necessary.
// 将磁盘上的dinode信息同步到缓存的inode中并加锁
void
ilock(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}

// Unlock the given inode.
// inode解锁
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
}

// Drop a reference to an in-memory inode.
// If that was the last reference, the inode table entry can
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
// 释放一个inode的引用
// 如果ref==0且nlink==0，则通过itrunc()释放掉这个inode与dinode
void
iput(struct inode *ip)
{
  acquire(&itable.lock);

  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.

    // ip->ref == 1 means no other process can have ip locked,
    // so this acquiresleep() won't block (or deadlock).
    acquiresleep(&ip->lock);

    release(&itable.lock);

    itrunc(ip);
    ip->type = 0;
    iupdate(ip);
    ip->valid = 0;

    releasesleep(&ip->lock);

    acquire(&itable.lock);
  }

  ip->ref--;
  release(&itable.lock);
}

// Common idiom: unlock, then put.
// inode解锁并减少引用
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
}

// Inode content
//
// The content (data) associated with each inode is stored
// in blocks on the disk. The first NDIRECT block numbers
// are listed in ip->addrs[].  The next NINDIRECT blocks are
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// 获取inode中的第n块data block的地址
// 如果地址不存在，则调用balloc分配一个data block
static uint
bmap(struct inode *ip, uint bn)
{
  uint addr, *a;
  struct buf *bp;
  // bn为直接索引
  if(bn < NDIRECT){
    // 如果第bn个索引指向的块还未分配，则分配，否则返回块号
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }

  // bn为间接索引
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    // 如果间接索引所在的块还未分配，分配
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    //读取一级索引块
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}

// Truncate inode (discard contents).
// Caller must hold ip->lock.
// 释放inode中指向的data block
void
itrunc(struct inode *ip)
{
  int i, j;
  struct buf *bp;
  uint *a;
  
  //direct block直接释放
  for(i = 0; i < NDIRECT; i++){
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  //indirect block的释放
  if(ip->addrs[NDIRECT]){
    // 读取一级索引块
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    // 释放一级索引指向的块
    for(j = 0; j < NINDIRECT; j++){
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
    // 释放一级索引块
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  //将释放完的inode更新到dinode中
  ip->size = 0;
  iupdate(ip);
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
  st->dev = ip->dev;
  st->ino = ip->inum;
  st->type = ip->type;
  st->nlink = ip->nlink;
  st->size = ip->size;
}

// Read data from inode.
// Caller must hold ip->lock.
// If user_dst==1, then dst is a user virtual address;
// otherwise, dst is a kernel address.
// 读inode的数据区 
// off, 表示读取的位置相对于起始位置的偏移。
// n, 要读取的字节数
// dst, 目的缓存区
int
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;
  
  // 如果开始读取的位置超过文件末尾，如果读取的字节数是负数
  if(off > ip->size || off + n < off)
    return 0;
  // 最多只能读取到ip->size
  if(off + n > ip->size)
    n = ip->size - off;

  // tot已经读取的字符数，off读取到的位置的偏移
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
  }
  return tot;
}

// Write data to inode.
// Caller must hold ip->lock.
// If user_src==1, then src is a user virtual address;
// otherwise, src is a kernel address.
// Returns the number of bytes successfully written.
// If the return value is less than the requested n,
// there was an error of some kind.
// 写inode的数据区，会改变inode的大小（size）
int
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
      brelse(bp);
      break;
    }
    log_write(bp);
    brelse(bp);
  }
  
  // 如果写的过程超出了inode的大小，则需要更新inode的大小
  if(off > ip->size)
    ip->size = off;

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);

  return tot;
}



// Directories
// 目录项名称匹配
int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
}

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
// 在给定的目录的inode下，查找指定的目录项。
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
  uint off, inum;
  struct dirent de;

  // 判断文件类型是否为目录
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    // 读取dp指向的目录文件，每次读一个目录项
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    // 0代表没有内容，为空目录项跳过（root inode为1）
    if(de.inum == 0)
      continue;
    // 判断当前目录项名称是否与查找目录项相同
    if(namecmp(name, de.name) == 0){
      // entry matches path element
      // 使用poff记录目录项在当前目录中的偏移
      if(poff)
        *poff = off;
      inum = de.inum;
      // 返回匹配的目录项的inode
      return iget(dp->dev, inum);
    }
  }

  return 0;
}


// Write a new directory entry (name, inum) into the directory dp.
// 在给定的目录的inode下，增加一个目录项
int
dirlink(struct inode *dp, char *name, uint inum)
{
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  // 检查如果要添加目录已经存在则返回-1
  if((ip = dirlookup(dp, name, 0)) != 0){
    // dirlookup调用iget使引用数加1，所以调用iput使引用数减1
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  // 在给定目录中寻找一个空的目录项
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  // 拷贝创建目录项的名称与inode索引
  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  // 将该目录项写进dp指向的目录文件中
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");

  return 0;
}



// Paths

// Copy the next path element from path into name.
// Return a pointer to the element following the copied one.
// The returned path has no leading slashes,
// so the caller can check *path=='\0' to see if the name is the last one.
// If no name to remove, return 0.
//
// Examples:
//   skipelem("a/bb/c", name) = "bb/c", setting name = "a"
//   skipelem("///a//bb", name) = "bb", setting name = "a"
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
// 调用一次解析一个头部的文件名放在 name 中，返回剩下的路径。
static char*
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/') // 跳过'/'
    path++;
  if(*path == 0) // 路径为空
    return 0;

  s = path; // 跳过'/'且不为空的路径名
  // path继续向后移，剥出最前面的目录名
  while(*path != '/' && *path != 0)
    path++;
  len = path - s; // 记录该目录名的长度

  // 将该目录名复制给name
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  // 继续跳过'/'
  while(*path == '/')
    path++;
  
  return path; // 返回剩下的路径
}

// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
// 
static struct inode*
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/') //绝对路径
    ip = iget(ROOTDEV, ROOTINO); //读取根目录
  else             //相对路径
    ip = idup(myproc()->cwd);    //读取当前工作目录


  while((path = skipelem(path, name)) != 0){
    ilock(ip);

    // 判断文件是否为目录项
    if(ip->type != T_DIR){
      iunlockput(ip);
      return 0;
    }

    // 如果要返回父结点，且剩余路径为空，则返回当前节点
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    // 查询下一级目录
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    // 当前目录指向下一个，然后while循环，直到解析到最后
    iunlockput(ip);
    ip = next;
  }

  if(nameiparent){
    iput(ip);
    return 0;
  }
  
  return ip;
}


// 返回给定路径的inode
struct inode*
namei(char *path)
{
  char name[DIRSIZ];
  return namex(path, 0, name);
}


// 返回给定路径的inode的上一层inode
struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
}


int mmap_handler(int va, int cause){

  struct proc *p = myproc();
  int num;
  struct vam v;
  for(num = 0; num < MAXVAM; num++){
    v = p->vams[num];
    printf(" nums : %d, valid: %d \n",num,v.valid);
    if(v.valid && (va >= v.begin && va < v.begin+v.len ))
    {
      char *mem = kalloc();
      memset(mem, 0, PGSIZE);
    
      int pte_flags = PTE_U;
      if(v.prot & PROT_READ) pte_flags |= PTE_R;
      if(v.prot & PROT_WRITE) pte_flags |= PTE_W;
      if(v.prot & PROT_EXEC) pte_flags |= PTE_X;

      if(mappages(p->pagetable, PGROUNDDOWN(va), PGSIZE, (uint64)mem, pte_flags) != 0) {
        kfree(mem);
        printf("no mmap");
        return -1;
      }

      struct file *f = v.f;
      ilock(f->ip);
      int offset = v.offset + PGROUNDDOWN(va) - v.begin;

      int read_num = readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
      if(read_num == 0) {
        iunlock(f->ip);
        kfree(mem);
        printf("read no");
        return -1;
      }
      iunlock(f->ip);

      
      return 0;
    }
  }
  if(num == MAXVAM)
  {
    printf("no match");
  }
  
  return -1;
}