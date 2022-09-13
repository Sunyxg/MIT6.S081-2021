#define READ 0
#define WRITE 1

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int args , char *argv[])
{
    int pp2c[2],pc2p[2],pid;
    char p2c[64],c2p[64];

    pipe(pp2c);
    pipe(pc2p);
    if ((pid = fork())<0)
    {
        printf("fork error\n");
        exit(1);
    }
    else if(pid == 0){
        close(pp2c[WRITE]);
        close(pc2p[READ]);

        read(pp2c[READ],p2c,sizeof(p2c));
        printf("%d: received %s\n" , getpid(), p2c);
        close(pp2c[READ]);

        write(pc2p[WRITE],"pong",4);
        close(pc2p[WRITE]);
        
        exit(0);
    }
    else{
        close(pp2c[READ]);
        close(pc2p[WRITE]);

        write(pp2c[WRITE],"ping",4);
        close(pp2c[WRITE]);

        read(pc2p[READ],c2p,sizeof(c2p));
        printf("%d: received %s\n" , getpid(), c2p);
        close(pc2p[READ]);
        wait(0);
        exit(0);
    }


}