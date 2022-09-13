#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/param.h"


//echo hello too | xargs echo bye
//输出： bye hello too 


int main(int argc , char *argv[])
{
    sleep(10);
    char buf[64];
    char *xargv[MAXARG];
    int xargc = 0;
    //获得前一个命令的标准化输出作为标准化输入
    read(0, buf, sizeof(buf));

    //获得自己的命令行参数
    for(int i = 1; i < argc; i++)
    {
        xargv[xargc] = argv[i];
        xargc++;
    } 

    //执行后一个命令
    char *p = buf;
    int pid;
    for(int i = 0; i < sizeof(buf); i++)
    {
        if(buf[i] == '\n')
        {
            if((pid = fork())==0)
            {
                buf[i] = '\0';
                xargv[xargc] = p;
                xargc++;
                xargv[xargc] = 0;
                xargc++;
                exec(xargv[0],xargv);
                exit(0);
            }
            else{
                p = &buf[i+1];
                wait(0);
            }
        }
    }
    wait(0);
    exit(0);
}