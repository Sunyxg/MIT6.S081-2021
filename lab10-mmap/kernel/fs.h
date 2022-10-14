// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO  1   // root i-number
#define BSIZE 1024  // block size

// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint magic;        // Must be FSMAGIC  
  uint size;         // Size of file system image (blocks) //文件系统大小（有多少block）
  uint nblocks;      // Number of data blocks //数据块的数量
  uint ninodes;      // Number of inodes. //i节点的数量
  uint nlog;         // Number of log blocks //日志块的数量
  uint logstart;     // Block number of first log block //第一个日志快的起始块号
  uint inodestart;   // Block number of first inode block //第一个i节点起始块号
  uint bmapstart;    // Block number of first free map block //第一个位图块块号
};

#define FSMAGIC 0x10203040

#define NDIRECT 12
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// On-disk inode structure //sizeof(struct) dinode = 64bytes
struct dinode {
  short type;           // File type  //文件的类型
  short major;          // Major device number (T_DEVICE only)
  short minor;          // Minor device number (T_DEVICE only)
  short nlink;          // Number of links to inode in file system //文件的link数
  uint size;            // Size of file (bytes) //文件数据有多少个字节
  uint addrs[NDIRECT+1];   // Data block addresses //文件数据地址
};



// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode)) //每个block有多少inode (1024/64) = 16

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart) //计算inode i 位于第几个inode block

// Bitmap bits per block
#define BPB           (BSIZE*8) //每个block有多少个bit (1024*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart) //计算block b 属于哪个位图block

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14

// 目录项的结构 
struct dirent {
  ushort inum; //目录或文件对应inode在磁盘上的引导，即是第几个inode
  char name[DIRSIZ]; //目录或文件的名字字符串
};

