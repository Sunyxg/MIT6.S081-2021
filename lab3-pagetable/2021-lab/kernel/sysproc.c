#include "types.h"
#include "riscv.h"
#include "param.h"
#include "defs.h"
#include "date.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"


uint64
sys_exit(void)
{
  int n;
  if(argint(0, &n) < 0)
    return -1;
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{ 
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  if(argaddr(0, &p) < 0)
    return -1;
  return wait(p);
}

uint64
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
  // lab pgtbl: your code here.
  struct proc *p = myproc();
  pte_t *pte;
  int n;
  unsigned int msk = 0;
  uint64 base, mask;
  if(argint(1, &n) < 0 || argaddr(0, &base) < 0 || argaddr(2, &mask) < 0)
    return -1;
  if((n<0)||(n>32))
    return -1;
  int a = n;
  //base : the starting virtual address of the first user page to check
  //n :  the number of pages to check
  // pte = walk(p->pagetable, base, 0);
  // printf("hi  n = %d base = %p \n", n , *pte);
  while(n--)
  {
    pte = walk(p->pagetable, base, 0);
    if((*pte & PTE_A))
    {
      msk = (msk) | (1<<(a-n-1));
      *pte = (*pte)&(~PTE_A);
    }
    base += PGSIZE;
  }
  // printf("hi  n = %d base = %p  %p \n", n , *pte , msk);
  // vmprint(p->pagetable);
  if(copyout(p->pagetable, mask, (char *)&msk, sizeof(msk)) < 0)
      return -1;

  return 0;
}
#endif

uint64
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

