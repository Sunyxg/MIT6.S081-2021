#define READ 0
#define WRITE 1

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void fk_new(int *left)
{
    int right[2], pid , out , a ;

    int n = read(left[READ], &out , sizeof(int));
    if(n == 0)
    {
        close(left[READ]);
        exit(0);
    }
   
    printf ("prime %d \n", out);
    pipe (right);
    if((pid = fork()) < 0)
    {
        printf("prime : fock error\n");
        exit(1);
    }
    else if(pid > 0)
    {
        close(right[READ]);
        while (read(left[READ], &a , sizeof(int)) > 0)
        {
            if((a % out) == 0)
            {
                continue;
            }
            else{
                write(right[WRITE], &a, sizeof(int));
            }
        }
        close(right[WRITE]);
        wait(0);
        exit(0);
    }
    else{
        close(right[WRITE]);
        fk_new(right);
        exit(0);
    }
}

int main(int args, char *argv[])
{
    int p[2], pid;
    pipe(p);

    if((pid = fork()) < 0)
    {
        printf("fock error\n");
        exit(1);
    }
    else if(pid > 0)
    {
        close(p[READ]);
        for (int i = 2; i<36 ; i++)
        {
            write(p[WRITE], &i , sizeof(int));
        }
        close(p[WRITE]);
        wait(0);
        exit(0);
    }
    else{
        close(p[WRITE]);
        fk_new(p);
        exit(0);
    }

}