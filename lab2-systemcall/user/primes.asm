
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fk_new>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void fk_new(int *left)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int right[2], pid , out , a ;

    int n = read(left[READ], &out , sizeof(int));
   c:	4611                	li	a2,4
   e:	fd440593          	addi	a1,s0,-44
  12:	4108                	lw	a0,0(a0)
  14:	00000097          	auipc	ra,0x0
  18:	422080e7          	jalr	1058(ra) # 436 <read>
    if(n == 0)
  1c:	e919                	bnez	a0,32 <fk_new+0x32>
    {
        close(left[READ]);
  1e:	4088                	lw	a0,0(s1)
  20:	00000097          	auipc	ra,0x0
  24:	426080e7          	jalr	1062(ra) # 446 <close>
        exit(0);
  28:	4501                	li	a0,0
  2a:	00000097          	auipc	ra,0x0
  2e:	3f4080e7          	jalr	1012(ra) # 41e <exit>
    }
   
    printf ("prime %d \n", out);
  32:	fd442583          	lw	a1,-44(s0)
  36:	00001517          	auipc	a0,0x1
  3a:	91250513          	addi	a0,a0,-1774 # 948 <malloc+0xe4>
  3e:	00000097          	auipc	ra,0x0
  42:	768080e7          	jalr	1896(ra) # 7a6 <printf>
    pipe (right);
  46:	fd840513          	addi	a0,s0,-40
  4a:	00000097          	auipc	ra,0x0
  4e:	3e4080e7          	jalr	996(ra) # 42e <pipe>
    if((pid = fork()) < 0)
  52:	00000097          	auipc	ra,0x0
  56:	3c4080e7          	jalr	964(ra) # 416 <fork>
  5a:	04054563          	bltz	a0,a4 <fk_new+0xa4>
    {
        printf("prime : fock error\n");
        exit(1);
    }
    else if(pid > 0)
  5e:	08a05063          	blez	a0,de <fk_new+0xde>
    {
        close(right[READ]);
  62:	fd842503          	lw	a0,-40(s0)
  66:	00000097          	auipc	ra,0x0
  6a:	3e0080e7          	jalr	992(ra) # 446 <close>
        while (read(left[READ], &a , sizeof(int)) > 0)
  6e:	4611                	li	a2,4
  70:	fd040593          	addi	a1,s0,-48
  74:	4088                	lw	a0,0(s1)
  76:	00000097          	auipc	ra,0x0
  7a:	3c0080e7          	jalr	960(ra) # 436 <read>
  7e:	04a05063          	blez	a0,be <fk_new+0xbe>
        {
            if((a % out) == 0)
  82:	fd042783          	lw	a5,-48(s0)
  86:	fd442703          	lw	a4,-44(s0)
  8a:	02e7e7bb          	remw	a5,a5,a4
  8e:	d3e5                	beqz	a5,6e <fk_new+0x6e>
            {
                continue;
            }
            else{
                write(right[WRITE], &a, sizeof(int));
  90:	4611                	li	a2,4
  92:	fd040593          	addi	a1,s0,-48
  96:	fdc42503          	lw	a0,-36(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	3a4080e7          	jalr	932(ra) # 43e <write>
  a2:	b7f1                	j	6e <fk_new+0x6e>
        printf("prime : fock error\n");
  a4:	00001517          	auipc	a0,0x1
  a8:	8b450513          	addi	a0,a0,-1868 # 958 <malloc+0xf4>
  ac:	00000097          	auipc	ra,0x0
  b0:	6fa080e7          	jalr	1786(ra) # 7a6 <printf>
        exit(1);
  b4:	4505                	li	a0,1
  b6:	00000097          	auipc	ra,0x0
  ba:	368080e7          	jalr	872(ra) # 41e <exit>
            }
        }
        close(right[WRITE]);
  be:	fdc42503          	lw	a0,-36(s0)
  c2:	00000097          	auipc	ra,0x0
  c6:	384080e7          	jalr	900(ra) # 446 <close>
        wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	35a080e7          	jalr	858(ra) # 426 <wait>
        exit(0);
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	348080e7          	jalr	840(ra) # 41e <exit>
    }
    else{
        close(right[WRITE]);
  de:	fdc42503          	lw	a0,-36(s0)
  e2:	00000097          	auipc	ra,0x0
  e6:	364080e7          	jalr	868(ra) # 446 <close>
        fk_new(right);
  ea:	fd840513          	addi	a0,s0,-40
  ee:	00000097          	auipc	ra,0x0
  f2:	f12080e7          	jalr	-238(ra) # 0 <fk_new>

00000000000000f6 <main>:
        exit(0);
    }
}

int main(int args, char *argv[])
{
  f6:	7179                	addi	sp,sp,-48
  f8:	f406                	sd	ra,40(sp)
  fa:	f022                	sd	s0,32(sp)
  fc:	ec26                	sd	s1,24(sp)
  fe:	1800                	addi	s0,sp,48
    int p[2], pid;
    pipe(p);
 100:	fd840513          	addi	a0,s0,-40
 104:	00000097          	auipc	ra,0x0
 108:	32a080e7          	jalr	810(ra) # 42e <pipe>

    if((pid = fork()) < 0)
 10c:	00000097          	auipc	ra,0x0
 110:	30a080e7          	jalr	778(ra) # 416 <fork>
 114:	06054163          	bltz	a0,176 <main+0x80>
    {
        printf("fock error\n");
        exit(1);
    }
    else if(pid > 0)
 118:	06a05c63          	blez	a0,190 <main+0x9a>
    {
        close(p[READ]);
 11c:	fd842503          	lw	a0,-40(s0)
 120:	00000097          	auipc	ra,0x0
 124:	326080e7          	jalr	806(ra) # 446 <close>
        for (int i = 2; i<36 ; i++)
 128:	4789                	li	a5,2
 12a:	fcf42a23          	sw	a5,-44(s0)
 12e:	02300493          	li	s1,35
        {
            write(p[WRITE], &i , sizeof(int));
 132:	4611                	li	a2,4
 134:	fd440593          	addi	a1,s0,-44
 138:	fdc42503          	lw	a0,-36(s0)
 13c:	00000097          	auipc	ra,0x0
 140:	302080e7          	jalr	770(ra) # 43e <write>
        for (int i = 2; i<36 ; i++)
 144:	fd442783          	lw	a5,-44(s0)
 148:	2785                	addiw	a5,a5,1
 14a:	0007871b          	sext.w	a4,a5
 14e:	fcf42a23          	sw	a5,-44(s0)
 152:	fee4d0e3          	bge	s1,a4,132 <main+0x3c>
        }
        close(p[WRITE]);
 156:	fdc42503          	lw	a0,-36(s0)
 15a:	00000097          	auipc	ra,0x0
 15e:	2ec080e7          	jalr	748(ra) # 446 <close>
        wait(0);
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	2c2080e7          	jalr	706(ra) # 426 <wait>
        exit(0);
 16c:	4501                	li	a0,0
 16e:	00000097          	auipc	ra,0x0
 172:	2b0080e7          	jalr	688(ra) # 41e <exit>
        printf("fock error\n");
 176:	00000517          	auipc	a0,0x0
 17a:	7ea50513          	addi	a0,a0,2026 # 960 <malloc+0xfc>
 17e:	00000097          	auipc	ra,0x0
 182:	628080e7          	jalr	1576(ra) # 7a6 <printf>
        exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	296080e7          	jalr	662(ra) # 41e <exit>
    }
    else{
        close(p[WRITE]);
 190:	fdc42503          	lw	a0,-36(s0)
 194:	00000097          	auipc	ra,0x0
 198:	2b2080e7          	jalr	690(ra) # 446 <close>
        fk_new(p);
 19c:	fd840513          	addi	a0,s0,-40
 1a0:	00000097          	auipc	ra,0x0
 1a4:	e60080e7          	jalr	-416(ra) # 0 <fk_new>

00000000000001a8 <strcpy>:
#include "user/user.h"

//将字符串t的值复制给字符串s
char*
strcpy(char *s, const char *t)
{
 1a8:	1141                	addi	sp,sp,-16
 1aa:	e422                	sd	s0,8(sp)
 1ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ae:	87aa                	mv	a5,a0
 1b0:	0585                	addi	a1,a1,1
 1b2:	0785                	addi	a5,a5,1
 1b4:	fff5c703          	lbu	a4,-1(a1)
 1b8:	fee78fa3          	sb	a4,-1(a5)
 1bc:	fb75                	bnez	a4,1b0 <strcpy+0x8>
    ;
  return os;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strcmp>:

//把p所指向的字符串和q所指向的字符串进行比较
int
strcmp(const char *p, const char *q)
{
 1c4:	1141                	addi	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb91                	beqz	a5,1e2 <strcmp+0x1e>
 1d0:	0005c703          	lbu	a4,0(a1)
 1d4:	00f71763          	bne	a4,a5,1e2 <strcmp+0x1e>
    p++, q++;
 1d8:	0505                	addi	a0,a0,1
 1da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	fbe5                	bnez	a5,1d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e2:	0005c503          	lbu	a0,0(a1)
}
 1e6:	40a7853b          	subw	a0,a5,a0
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strlen>:

//从内存的某个位置（可以是字符串开头，中间某个位置，甚至是某个不确定的内存区域）开始扫描，直到碰到第一个字符串结束符 \0 为止，然后返回计数器值（长度不包含 \0 ）
uint
strlen(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cf91                	beqz	a5,216 <strlen+0x26>
 1fc:	0505                	addi	a0,a0,1
 1fe:	87aa                	mv	a5,a0
 200:	4685                	li	a3,1
 202:	9e89                	subw	a3,a3,a0
 204:	00f6853b          	addw	a0,a3,a5
 208:	0785                	addi	a5,a5,1
 20a:	fff7c703          	lbu	a4,-1(a5)
 20e:	fb7d                	bnez	a4,204 <strlen+0x14>
    ;
  return n;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret
  for(n = 0; s[n]; n++)
 216:	4501                	li	a0,0
 218:	bfe5                	j	210 <strlen+0x20>

000000000000021a <memset>:

//复制字符 c（一个无符号字符）到参数 str 所指向的字符串的前 n 个字符
void*
memset(void *dst, int c, uint n)
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst; //将指针dst强制转换为char型指针
  int i;
  for(i = 0; i < n; i++){
 220:	ce09                	beqz	a2,23a <memset+0x20>
 222:	87aa                	mv	a5,a0
 224:	fff6071b          	addiw	a4,a2,-1
 228:	1702                	slli	a4,a4,0x20
 22a:	9301                	srli	a4,a4,0x20
 22c:	0705                	addi	a4,a4,1
 22e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 230:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 234:	0785                	addi	a5,a5,1
 236:	fee79de3          	bne	a5,a4,230 <memset+0x16>
  }
  return dst;
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret

0000000000000240 <strchr>:


char*
strchr(const char *s, char c)
{
 240:	1141                	addi	sp,sp,-16
 242:	e422                	sd	s0,8(sp)
 244:	0800                	addi	s0,sp,16
  for(; *s; s++)
 246:	00054783          	lbu	a5,0(a0)
 24a:	cb99                	beqz	a5,260 <strchr+0x20>
    if(*s == c)
 24c:	00f58763          	beq	a1,a5,25a <strchr+0x1a>
  for(; *s; s++)
 250:	0505                	addi	a0,a0,1
 252:	00054783          	lbu	a5,0(a0)
 256:	fbfd                	bnez	a5,24c <strchr+0xc>
      return (char*)s;
  return 0;
 258:	4501                	li	a0,0
}
 25a:	6422                	ld	s0,8(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  return 0;
 260:	4501                	li	a0,0
 262:	bfe5                	j	25a <strchr+0x1a>

0000000000000264 <gets>:

char*
gets(char *buf, int max)
{
 264:	711d                	addi	sp,sp,-96
 266:	ec86                	sd	ra,88(sp)
 268:	e8a2                	sd	s0,80(sp)
 26a:	e4a6                	sd	s1,72(sp)
 26c:	e0ca                	sd	s2,64(sp)
 26e:	fc4e                	sd	s3,56(sp)
 270:	f852                	sd	s4,48(sp)
 272:	f456                	sd	s5,40(sp)
 274:	f05a                	sd	s6,32(sp)
 276:	ec5e                	sd	s7,24(sp)
 278:	1080                	addi	s0,sp,96
 27a:	8baa                	mv	s7,a0
 27c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27e:	892a                	mv	s2,a0
 280:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 282:	4aa9                	li	s5,10
 284:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 286:	89a6                	mv	s3,s1
 288:	2485                	addiw	s1,s1,1
 28a:	0344d863          	bge	s1,s4,2ba <gets+0x56>
    cc = read(0, &c, 1);
 28e:	4605                	li	a2,1
 290:	faf40593          	addi	a1,s0,-81
 294:	4501                	li	a0,0
 296:	00000097          	auipc	ra,0x0
 29a:	1a0080e7          	jalr	416(ra) # 436 <read>
    if(cc < 1)
 29e:	00a05e63          	blez	a0,2ba <gets+0x56>
    buf[i++] = c;
 2a2:	faf44783          	lbu	a5,-81(s0)
 2a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2aa:	01578763          	beq	a5,s5,2b8 <gets+0x54>
 2ae:	0905                	addi	s2,s2,1
 2b0:	fd679be3          	bne	a5,s6,286 <gets+0x22>
  for(i=0; i+1 < max; ){
 2b4:	89a6                	mv	s3,s1
 2b6:	a011                	j	2ba <gets+0x56>
 2b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ba:	99de                	add	s3,s3,s7
 2bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c0:	855e                	mv	a0,s7
 2c2:	60e6                	ld	ra,88(sp)
 2c4:	6446                	ld	s0,80(sp)
 2c6:	64a6                	ld	s1,72(sp)
 2c8:	6906                	ld	s2,64(sp)
 2ca:	79e2                	ld	s3,56(sp)
 2cc:	7a42                	ld	s4,48(sp)
 2ce:	7aa2                	ld	s5,40(sp)
 2d0:	7b02                	ld	s6,32(sp)
 2d2:	6be2                	ld	s7,24(sp)
 2d4:	6125                	addi	sp,sp,96
 2d6:	8082                	ret

00000000000002d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d8:	1101                	addi	sp,sp,-32
 2da:	ec06                	sd	ra,24(sp)
 2dc:	e822                	sd	s0,16(sp)
 2de:	e426                	sd	s1,8(sp)
 2e0:	e04a                	sd	s2,0(sp)
 2e2:	1000                	addi	s0,sp,32
 2e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e6:	4581                	li	a1,0
 2e8:	00000097          	auipc	ra,0x0
 2ec:	176080e7          	jalr	374(ra) # 45e <open>
  if(fd < 0)
 2f0:	02054563          	bltz	a0,31a <stat+0x42>
 2f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f6:	85ca                	mv	a1,s2
 2f8:	00000097          	auipc	ra,0x0
 2fc:	17e080e7          	jalr	382(ra) # 476 <fstat>
 300:	892a                	mv	s2,a0
  close(fd);
 302:	8526                	mv	a0,s1
 304:	00000097          	auipc	ra,0x0
 308:	142080e7          	jalr	322(ra) # 446 <close>
  return r;
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	64a2                	ld	s1,8(sp)
 314:	6902                	ld	s2,0(sp)
 316:	6105                	addi	sp,sp,32
 318:	8082                	ret
    return -1;
 31a:	597d                	li	s2,-1
 31c:	bfc5                	j	30c <stat+0x34>

000000000000031e <atoi>:

//将参数s所指向字符串转换为一个整数
int
atoi(const char *s)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 324:	00054603          	lbu	a2,0(a0)
 328:	fd06079b          	addiw	a5,a2,-48
 32c:	0ff7f793          	andi	a5,a5,255
 330:	4725                	li	a4,9
 332:	02f76963          	bltu	a4,a5,364 <atoi+0x46>
 336:	86aa                	mv	a3,a0
  n = 0;
 338:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 33a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 33c:	0685                	addi	a3,a3,1
 33e:	0025179b          	slliw	a5,a0,0x2
 342:	9fa9                	addw	a5,a5,a0
 344:	0017979b          	slliw	a5,a5,0x1
 348:	9fb1                	addw	a5,a5,a2
 34a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34e:	0006c603          	lbu	a2,0(a3)
 352:	fd06071b          	addiw	a4,a2,-48
 356:	0ff77713          	andi	a4,a4,255
 35a:	fee5f1e3          	bgeu	a1,a4,33c <atoi+0x1e>
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  n = 0;
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <atoi+0x40>

0000000000000368 <memmove>:

//将vsrc开始后n个字符复制到从vdst开始的位置
void*
memmove(void *vdst, const void *vsrc, int n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 36e:	02b57663          	bgeu	a0,a1,39a <memmove+0x32>
    while(n-- > 0)
 372:	02c05163          	blez	a2,394 <memmove+0x2c>
 376:	fff6079b          	addiw	a5,a2,-1
 37a:	1782                	slli	a5,a5,0x20
 37c:	9381                	srli	a5,a5,0x20
 37e:	0785                	addi	a5,a5,1
 380:	97aa                	add	a5,a5,a0
  dst = vdst;
 382:	872a                	mv	a4,a0
      *dst++ = *src++;
 384:	0585                	addi	a1,a1,1
 386:	0705                	addi	a4,a4,1
 388:	fff5c683          	lbu	a3,-1(a1)
 38c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 390:	fee79ae3          	bne	a5,a4,384 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 394:	6422                	ld	s0,8(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret
    dst += n;
 39a:	00c50733          	add	a4,a0,a2
    src += n;
 39e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3a0:	fec05ae3          	blez	a2,394 <memmove+0x2c>
 3a4:	fff6079b          	addiw	a5,a2,-1
 3a8:	1782                	slli	a5,a5,0x20
 3aa:	9381                	srli	a5,a5,0x20
 3ac:	fff7c793          	not	a5,a5
 3b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b2:	15fd                	addi	a1,a1,-1
 3b4:	177d                	addi	a4,a4,-1
 3b6:	0005c683          	lbu	a3,0(a1)
 3ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3be:	fee79ae3          	bne	a5,a4,3b2 <memmove+0x4a>
 3c2:	bfc9                	j	394 <memmove+0x2c>

00000000000003c4 <memcmp>:


int
memcmp(const void *s1, const void *s2, uint n)
{
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e422                	sd	s0,8(sp)
 3c8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ca:	ca05                	beqz	a2,3fa <memcmp+0x36>
 3cc:	fff6069b          	addiw	a3,a2,-1
 3d0:	1682                	slli	a3,a3,0x20
 3d2:	9281                	srli	a3,a3,0x20
 3d4:	0685                	addi	a3,a3,1
 3d6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	0005c703          	lbu	a4,0(a1)
 3e0:	00e79863          	bne	a5,a4,3f0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3e4:	0505                	addi	a0,a0,1
    p2++;
 3e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e8:	fed518e3          	bne	a0,a3,3d8 <memcmp+0x14>
  }
  return 0;
 3ec:	4501                	li	a0,0
 3ee:	a019                	j	3f4 <memcmp+0x30>
      return *p1 - *p2;
 3f0:	40e7853b          	subw	a0,a5,a4
}
 3f4:	6422                	ld	s0,8(sp)
 3f6:	0141                	addi	sp,sp,16
 3f8:	8082                	ret
  return 0;
 3fa:	4501                	li	a0,0
 3fc:	bfe5                	j	3f4 <memcmp+0x30>

00000000000003fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3fe:	1141                	addi	sp,sp,-16
 400:	e406                	sd	ra,8(sp)
 402:	e022                	sd	s0,0(sp)
 404:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 406:	00000097          	auipc	ra,0x0
 40a:	f62080e7          	jalr	-158(ra) # 368 <memmove>
}
 40e:	60a2                	ld	ra,8(sp)
 410:	6402                	ld	s0,0(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret

0000000000000416 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 416:	4885                	li	a7,1
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <exit>:
.global exit
exit:
 li a7, SYS_exit
 41e:	4889                	li	a7,2
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <wait>:
.global wait
wait:
 li a7, SYS_wait
 426:	488d                	li	a7,3
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 42e:	4891                	li	a7,4
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <read>:
.global read
read:
 li a7, SYS_read
 436:	4895                	li	a7,5
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <write>:
.global write
write:
 li a7, SYS_write
 43e:	48c1                	li	a7,16
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <close>:
.global close
close:
 li a7, SYS_close
 446:	48d5                	li	a7,21
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <kill>:
.global kill
kill:
 li a7, SYS_kill
 44e:	4899                	li	a7,6
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <exec>:
.global exec
exec:
 li a7, SYS_exec
 456:	489d                	li	a7,7
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <open>:
.global open
open:
 li a7, SYS_open
 45e:	48bd                	li	a7,15
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 466:	48c5                	li	a7,17
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 46e:	48c9                	li	a7,18
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 476:	48a1                	li	a7,8
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <link>:
.global link
link:
 li a7, SYS_link
 47e:	48cd                	li	a7,19
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 486:	48d1                	li	a7,20
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 48e:	48a5                	li	a7,9
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <dup>:
.global dup
dup:
 li a7, SYS_dup
 496:	48a9                	li	a7,10
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 49e:	48ad                	li	a7,11
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4a6:	48b1                	li	a7,12
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ae:	48b5                	li	a7,13
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4b6:	48b9                	li	a7,14
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <trace>:
.global trace
trace:
 li a7, SYS_trace
 4be:	48d9                	li	a7,22
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 4c6:	48dd                	li	a7,23
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ce:	1101                	addi	sp,sp,-32
 4d0:	ec06                	sd	ra,24(sp)
 4d2:	e822                	sd	s0,16(sp)
 4d4:	1000                	addi	s0,sp,32
 4d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4da:	4605                	li	a2,1
 4dc:	fef40593          	addi	a1,s0,-17
 4e0:	00000097          	auipc	ra,0x0
 4e4:	f5e080e7          	jalr	-162(ra) # 43e <write>
}
 4e8:	60e2                	ld	ra,24(sp)
 4ea:	6442                	ld	s0,16(sp)
 4ec:	6105                	addi	sp,sp,32
 4ee:	8082                	ret

00000000000004f0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	7139                	addi	sp,sp,-64
 4f2:	fc06                	sd	ra,56(sp)
 4f4:	f822                	sd	s0,48(sp)
 4f6:	f426                	sd	s1,40(sp)
 4f8:	f04a                	sd	s2,32(sp)
 4fa:	ec4e                	sd	s3,24(sp)
 4fc:	0080                	addi	s0,sp,64
 4fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 500:	c299                	beqz	a3,506 <printint+0x16>
 502:	0805c863          	bltz	a1,592 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 506:	2581                	sext.w	a1,a1
  neg = 0;
 508:	4881                	li	a7,0
 50a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 50e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 510:	2601                	sext.w	a2,a2
 512:	00000517          	auipc	a0,0x0
 516:	46650513          	addi	a0,a0,1126 # 978 <digits>
 51a:	883a                	mv	a6,a4
 51c:	2705                	addiw	a4,a4,1
 51e:	02c5f7bb          	remuw	a5,a1,a2
 522:	1782                	slli	a5,a5,0x20
 524:	9381                	srli	a5,a5,0x20
 526:	97aa                	add	a5,a5,a0
 528:	0007c783          	lbu	a5,0(a5)
 52c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 530:	0005879b          	sext.w	a5,a1
 534:	02c5d5bb          	divuw	a1,a1,a2
 538:	0685                	addi	a3,a3,1
 53a:	fec7f0e3          	bgeu	a5,a2,51a <printint+0x2a>
  if(neg)
 53e:	00088b63          	beqz	a7,554 <printint+0x64>
    buf[i++] = '-';
 542:	fd040793          	addi	a5,s0,-48
 546:	973e                	add	a4,a4,a5
 548:	02d00793          	li	a5,45
 54c:	fef70823          	sb	a5,-16(a4)
 550:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 554:	02e05863          	blez	a4,584 <printint+0x94>
 558:	fc040793          	addi	a5,s0,-64
 55c:	00e78933          	add	s2,a5,a4
 560:	fff78993          	addi	s3,a5,-1
 564:	99ba                	add	s3,s3,a4
 566:	377d                	addiw	a4,a4,-1
 568:	1702                	slli	a4,a4,0x20
 56a:	9301                	srli	a4,a4,0x20
 56c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 570:	fff94583          	lbu	a1,-1(s2)
 574:	8526                	mv	a0,s1
 576:	00000097          	auipc	ra,0x0
 57a:	f58080e7          	jalr	-168(ra) # 4ce <putc>
  while(--i >= 0)
 57e:	197d                	addi	s2,s2,-1
 580:	ff3918e3          	bne	s2,s3,570 <printint+0x80>
}
 584:	70e2                	ld	ra,56(sp)
 586:	7442                	ld	s0,48(sp)
 588:	74a2                	ld	s1,40(sp)
 58a:	7902                	ld	s2,32(sp)
 58c:	69e2                	ld	s3,24(sp)
 58e:	6121                	addi	sp,sp,64
 590:	8082                	ret
    x = -xx;
 592:	40b005bb          	negw	a1,a1
    neg = 1;
 596:	4885                	li	a7,1
    x = -xx;
 598:	bf8d                	j	50a <printint+0x1a>

000000000000059a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59a:	7119                	addi	sp,sp,-128
 59c:	fc86                	sd	ra,120(sp)
 59e:	f8a2                	sd	s0,112(sp)
 5a0:	f4a6                	sd	s1,104(sp)
 5a2:	f0ca                	sd	s2,96(sp)
 5a4:	ecce                	sd	s3,88(sp)
 5a6:	e8d2                	sd	s4,80(sp)
 5a8:	e4d6                	sd	s5,72(sp)
 5aa:	e0da                	sd	s6,64(sp)
 5ac:	fc5e                	sd	s7,56(sp)
 5ae:	f862                	sd	s8,48(sp)
 5b0:	f466                	sd	s9,40(sp)
 5b2:	f06a                	sd	s10,32(sp)
 5b4:	ec6e                	sd	s11,24(sp)
 5b6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b8:	0005c903          	lbu	s2,0(a1)
 5bc:	18090f63          	beqz	s2,75a <vprintf+0x1c0>
 5c0:	8aaa                	mv	s5,a0
 5c2:	8b32                	mv	s6,a2
 5c4:	00158493          	addi	s1,a1,1
  state = 0;
 5c8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ca:	02500a13          	li	s4,37
      if(c == 'd'){
 5ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5d2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5d6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5da:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5de:	00000b97          	auipc	s7,0x0
 5e2:	39ab8b93          	addi	s7,s7,922 # 978 <digits>
 5e6:	a839                	j	604 <vprintf+0x6a>
        putc(fd, c);
 5e8:	85ca                	mv	a1,s2
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	ee2080e7          	jalr	-286(ra) # 4ce <putc>
 5f4:	a019                	j	5fa <vprintf+0x60>
    } else if(state == '%'){
 5f6:	01498f63          	beq	s3,s4,614 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5fa:	0485                	addi	s1,s1,1
 5fc:	fff4c903          	lbu	s2,-1(s1)
 600:	14090d63          	beqz	s2,75a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 604:	0009079b          	sext.w	a5,s2
    if(state == 0){
 608:	fe0997e3          	bnez	s3,5f6 <vprintf+0x5c>
      if(c == '%'){
 60c:	fd479ee3          	bne	a5,s4,5e8 <vprintf+0x4e>
        state = '%';
 610:	89be                	mv	s3,a5
 612:	b7e5                	j	5fa <vprintf+0x60>
      if(c == 'd'){
 614:	05878063          	beq	a5,s8,654 <vprintf+0xba>
      } else if(c == 'l') {
 618:	05978c63          	beq	a5,s9,670 <vprintf+0xd6>
      } else if(c == 'x') {
 61c:	07a78863          	beq	a5,s10,68c <vprintf+0xf2>
      } else if(c == 'p') {
 620:	09b78463          	beq	a5,s11,6a8 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 624:	07300713          	li	a4,115
 628:	0ce78663          	beq	a5,a4,6f4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62c:	06300713          	li	a4,99
 630:	0ee78e63          	beq	a5,a4,72c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 634:	11478863          	beq	a5,s4,744 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 638:	85d2                	mv	a1,s4
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e92080e7          	jalr	-366(ra) # 4ce <putc>
        putc(fd, c);
 644:	85ca                	mv	a1,s2
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	e86080e7          	jalr	-378(ra) # 4ce <putc>
      }
      state = 0;
 650:	4981                	li	s3,0
 652:	b765                	j	5fa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 654:	008b0913          	addi	s2,s6,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000b2583          	lw	a1,0(s6)
 660:	8556                	mv	a0,s5
 662:	00000097          	auipc	ra,0x0
 666:	e8e080e7          	jalr	-370(ra) # 4f0 <printint>
 66a:	8b4a                	mv	s6,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b771                	j	5fa <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	008b0913          	addi	s2,s6,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000b2583          	lw	a1,0(s6)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e72080e7          	jalr	-398(ra) # 4f0 <printint>
 686:	8b4a                	mv	s6,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	bf85                	j	5fa <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 68c:	008b0913          	addi	s2,s6,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000b2583          	lw	a1,0(s6)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e56080e7          	jalr	-426(ra) # 4f0 <printint>
 6a2:	8b4a                	mv	s6,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	bf91                	j	5fa <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6a8:	008b0793          	addi	a5,s6,8
 6ac:	f8f43423          	sd	a5,-120(s0)
 6b0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	8556                	mv	a0,s5
 6ba:	00000097          	auipc	ra,0x0
 6be:	e14080e7          	jalr	-492(ra) # 4ce <putc>
  putc(fd, 'x');
 6c2:	85ea                	mv	a1,s10
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	e08080e7          	jalr	-504(ra) # 4ce <putc>
 6ce:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d0:	03c9d793          	srli	a5,s3,0x3c
 6d4:	97de                	add	a5,a5,s7
 6d6:	0007c583          	lbu	a1,0(a5)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	df2080e7          	jalr	-526(ra) # 4ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e4:	0992                	slli	s3,s3,0x4
 6e6:	397d                	addiw	s2,s2,-1
 6e8:	fe0914e3          	bnez	s2,6d0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6ec:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b721                	j	5fa <vprintf+0x60>
        s = va_arg(ap, char*);
 6f4:	008b0993          	addi	s3,s6,8
 6f8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6fc:	02090163          	beqz	s2,71e <vprintf+0x184>
        while(*s != 0){
 700:	00094583          	lbu	a1,0(s2)
 704:	c9a1                	beqz	a1,754 <vprintf+0x1ba>
          putc(fd, *s);
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	dc6080e7          	jalr	-570(ra) # 4ce <putc>
          s++;
 710:	0905                	addi	s2,s2,1
        while(*s != 0){
 712:	00094583          	lbu	a1,0(s2)
 716:	f9e5                	bnez	a1,706 <vprintf+0x16c>
        s = va_arg(ap, char*);
 718:	8b4e                	mv	s6,s3
      state = 0;
 71a:	4981                	li	s3,0
 71c:	bdf9                	j	5fa <vprintf+0x60>
          s = "(null)";
 71e:	00000917          	auipc	s2,0x0
 722:	25290913          	addi	s2,s2,594 # 970 <malloc+0x10c>
        while(*s != 0){
 726:	02800593          	li	a1,40
 72a:	bff1                	j	706 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 72c:	008b0913          	addi	s2,s6,8
 730:	000b4583          	lbu	a1,0(s6)
 734:	8556                	mv	a0,s5
 736:	00000097          	auipc	ra,0x0
 73a:	d98080e7          	jalr	-616(ra) # 4ce <putc>
 73e:	8b4a                	mv	s6,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bd65                	j	5fa <vprintf+0x60>
        putc(fd, c);
 744:	85d2                	mv	a1,s4
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	d86080e7          	jalr	-634(ra) # 4ce <putc>
      state = 0;
 750:	4981                	li	s3,0
 752:	b565                	j	5fa <vprintf+0x60>
        s = va_arg(ap, char*);
 754:	8b4e                	mv	s6,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	b54d                	j	5fa <vprintf+0x60>
    }
  }
}
 75a:	70e6                	ld	ra,120(sp)
 75c:	7446                	ld	s0,112(sp)
 75e:	74a6                	ld	s1,104(sp)
 760:	7906                	ld	s2,96(sp)
 762:	69e6                	ld	s3,88(sp)
 764:	6a46                	ld	s4,80(sp)
 766:	6aa6                	ld	s5,72(sp)
 768:	6b06                	ld	s6,64(sp)
 76a:	7be2                	ld	s7,56(sp)
 76c:	7c42                	ld	s8,48(sp)
 76e:	7ca2                	ld	s9,40(sp)
 770:	7d02                	ld	s10,32(sp)
 772:	6de2                	ld	s11,24(sp)
 774:	6109                	addi	sp,sp,128
 776:	8082                	ret

0000000000000778 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 778:	715d                	addi	sp,sp,-80
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e010                	sd	a2,0(s0)
 782:	e414                	sd	a3,8(s0)
 784:	e818                	sd	a4,16(s0)
 786:	ec1c                	sd	a5,24(s0)
 788:	03043023          	sd	a6,32(s0)
 78c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	8622                	mv	a2,s0
 796:	00000097          	auipc	ra,0x0
 79a:	e04080e7          	jalr	-508(ra) # 59a <vprintf>
}
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6161                	addi	sp,sp,80
 7a4:	8082                	ret

00000000000007a6 <printf>:

void
printf(const char *fmt, ...)
{
 7a6:	711d                	addi	sp,sp,-96
 7a8:	ec06                	sd	ra,24(sp)
 7aa:	e822                	sd	s0,16(sp)
 7ac:	1000                	addi	s0,sp,32
 7ae:	e40c                	sd	a1,8(s0)
 7b0:	e810                	sd	a2,16(s0)
 7b2:	ec14                	sd	a3,24(s0)
 7b4:	f018                	sd	a4,32(s0)
 7b6:	f41c                	sd	a5,40(s0)
 7b8:	03043823          	sd	a6,48(s0)
 7bc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	00840613          	addi	a2,s0,8
 7c4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c8:	85aa                	mv	a1,a0
 7ca:	4505                	li	a0,1
 7cc:	00000097          	auipc	ra,0x0
 7d0:	dce080e7          	jalr	-562(ra) # 59a <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6125                	addi	sp,sp,96
 7da:	8082                	ret

00000000000007dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7dc:	1141                	addi	sp,sp,-16
 7de:	e422                	sd	s0,8(sp)
 7e0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	00000797          	auipc	a5,0x0
 7ea:	1aa7b783          	ld	a5,426(a5) # 990 <freep>
 7ee:	a805                	j	81e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f0:	4618                	lw	a4,8(a2)
 7f2:	9db9                	addw	a1,a1,a4
 7f4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	6318                	ld	a4,0(a4)
 7fc:	fee53823          	sd	a4,-16(a0)
 800:	a091                	j	844 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 802:	ff852703          	lw	a4,-8(a0)
 806:	9e39                	addw	a2,a2,a4
 808:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 80a:	ff053703          	ld	a4,-16(a0)
 80e:	e398                	sd	a4,0(a5)
 810:	a099                	j	856 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x40>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x50>
{
 81c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x36>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059713          	slli	a4,a1,0x20
 836:	9301                	srli	a4,a4,0x20
 838:	0712                	slli	a4,a4,0x4
 83a:	9736                	add	a4,a4,a3
 83c:	fae60ae3          	beq	a2,a4,7f0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 844:	4790                	lw	a2,8(a5)
 846:	02061713          	slli	a4,a2,0x20
 84a:	9301                	srli	a4,a4,0x20
 84c:	0712                	slli	a4,a4,0x4
 84e:	973e                	add	a4,a4,a5
 850:	fae689e3          	beq	a3,a4,802 <free+0x26>
  } else
    p->s.ptr = bp;
 854:	e394                	sd	a3,0(a5)
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	12f73d23          	sd	a5,314(a4) # 990 <freep>
}
 85e:	6422                	ld	s0,8(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret

0000000000000864 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 864:	7139                	addi	sp,sp,-64
 866:	fc06                	sd	ra,56(sp)
 868:	f822                	sd	s0,48(sp)
 86a:	f426                	sd	s1,40(sp)
 86c:	f04a                	sd	s2,32(sp)
 86e:	ec4e                	sd	s3,24(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
 876:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 878:	02051493          	slli	s1,a0,0x20
 87c:	9081                	srli	s1,s1,0x20
 87e:	04bd                	addi	s1,s1,15
 880:	8091                	srli	s1,s1,0x4
 882:	0014899b          	addiw	s3,s1,1
 886:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 888:	00000517          	auipc	a0,0x0
 88c:	10853503          	ld	a0,264(a0) # 990 <freep>
 890:	c515                	beqz	a0,8bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	02977f63          	bgeu	a4,s1,8d4 <malloc+0x70>
 89a:	8a4e                	mv	s4,s3
 89c:	0009871b          	sext.w	a4,s3
 8a0:	6685                	lui	a3,0x1
 8a2:	00d77363          	bgeu	a4,a3,8a8 <malloc+0x44>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b0:	00000917          	auipc	s2,0x0
 8b4:	0e090913          	addi	s2,s2,224 # 990 <freep>
  if(p == (char*)-1)
 8b8:	5afd                	li	s5,-1
 8ba:	a88d                	j	92c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8bc:	00000797          	auipc	a5,0x0
 8c0:	0dc78793          	addi	a5,a5,220 # 998 <base>
 8c4:	00000717          	auipc	a4,0x0
 8c8:	0cf73623          	sd	a5,204(a4) # 990 <freep>
 8cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d2:	b7e1                	j	89a <malloc+0x36>
      if(p->s.size == nunits)
 8d4:	02e48b63          	beq	s1,a4,90a <malloc+0xa6>
        p->s.size -= nunits;
 8d8:	4137073b          	subw	a4,a4,s3
 8dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8de:	1702                	slli	a4,a4,0x20
 8e0:	9301                	srli	a4,a4,0x20
 8e2:	0712                	slli	a4,a4,0x4
 8e4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ea:	00000717          	auipc	a4,0x0
 8ee:	0aa73323          	sd	a0,166(a4) # 990 <freep>
      return (void*)(p + 1);
 8f2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8f6:	70e2                	ld	ra,56(sp)
 8f8:	7442                	ld	s0,48(sp)
 8fa:	74a2                	ld	s1,40(sp)
 8fc:	7902                	ld	s2,32(sp)
 8fe:	69e2                	ld	s3,24(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	6121                	addi	sp,sp,64
 908:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	e118                	sd	a4,0(a0)
 90e:	bff1                	j	8ea <malloc+0x86>
  hp->s.size = nu;
 910:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 914:	0541                	addi	a0,a0,16
 916:	00000097          	auipc	ra,0x0
 91a:	ec6080e7          	jalr	-314(ra) # 7dc <free>
  return freep;
 91e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 922:	d971                	beqz	a0,8f6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 924:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 926:	4798                	lw	a4,8(a5)
 928:	fa9776e3          	bgeu	a4,s1,8d4 <malloc+0x70>
    if(p == freep)
 92c:	00093703          	ld	a4,0(s2)
 930:	853e                	mv	a0,a5
 932:	fef719e3          	bne	a4,a5,924 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 936:	8552                	mv	a0,s4
 938:	00000097          	auipc	ra,0x0
 93c:	b6e080e7          	jalr	-1170(ra) # 4a6 <sbrk>
  if(p == (char*)-1)
 940:	fd5518e3          	bne	a0,s5,910 <malloc+0xac>
        return 0;
 944:	4501                	li	a0,0
 946:	bf45                	j	8f6 <malloc+0x92>
