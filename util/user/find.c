#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  return buf;
}

int recur(char *path)
{
    char *buf = fmtname(path);
    if(buf[0] == '.'&& buf[1] == '\0')
    {
        return 0;
    }
    else if (buf[0] == '.'&& buf[1] == '.'&& buf[2] == '\0')
    {
        return 0;
    }
    else{
        return 1;
    }
}

void
findf(char *path,char *fle)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  

  switch(st.type){
  case T_FILE:

    if(strcmp(fmtname(path), fle) == 0)
    {
      printf("%s\n" , path);
    }
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("ls: cannot stat %s\n", buf);
        continue;
      }
      
      if(recur(buf))
      {
        findf(buf,fle);
      }
      
    }
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{

  if(argc < 2){
    printf("find error");
    exit(1);
  }
  if(argc == 2)
  {
    findf(".",argv[1]);
  }
  else
  {
    for(int i=2; i<argc; i++)
    {
      findf(argv[1], argv[i]);
      printf("\n");
    }

  }
  exit(0);
}
