
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"


int main(int args , char *argv[])
{
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	1100                	addi	s0,sp,160
    int pp2c[2],pc2p[2],pid;
    char p2c[64],c2p[64];

    pipe(pp2c);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	3d0080e7          	jalr	976(ra) # 3dc <pipe>
    pipe(pc2p);
  14:	fe040513          	addi	a0,s0,-32
  18:	00000097          	auipc	ra,0x0
  1c:	3c4080e7          	jalr	964(ra) # 3dc <pipe>
    if ((pid = fork())<0)
  20:	00000097          	auipc	ra,0x0
  24:	3a4080e7          	jalr	932(ra) # 3c4 <fork>
  28:	08054463          	bltz	a0,b0 <main+0xb0>
    {
        printf("fork error\n");
        exit(1);
    }
    else if(pid == 0){
  2c:	ed59                	bnez	a0,ca <main+0xca>
        close(pp2c[WRITE]);
  2e:	fec42503          	lw	a0,-20(s0)
  32:	00000097          	auipc	ra,0x0
  36:	3c2080e7          	jalr	962(ra) # 3f4 <close>
        close(pc2p[READ]);
  3a:	fe042503          	lw	a0,-32(s0)
  3e:	00000097          	auipc	ra,0x0
  42:	3b6080e7          	jalr	950(ra) # 3f4 <close>

        read(pp2c[READ],p2c,sizeof(p2c));
  46:	04000613          	li	a2,64
  4a:	fa040593          	addi	a1,s0,-96
  4e:	fe842503          	lw	a0,-24(s0)
  52:	00000097          	auipc	ra,0x0
  56:	392080e7          	jalr	914(ra) # 3e4 <read>
        printf("%d: received %s\n" , getpid(), p2c);
  5a:	00000097          	auipc	ra,0x0
  5e:	3f2080e7          	jalr	1010(ra) # 44c <getpid>
  62:	85aa                	mv	a1,a0
  64:	fa040613          	addi	a2,s0,-96
  68:	00001517          	auipc	a0,0x1
  6c:	8a050513          	addi	a0,a0,-1888 # 908 <malloc+0xf6>
  70:	00000097          	auipc	ra,0x0
  74:	6e4080e7          	jalr	1764(ra) # 754 <printf>
        close(pp2c[READ]);
  78:	fe842503          	lw	a0,-24(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	378080e7          	jalr	888(ra) # 3f4 <close>

        write(pc2p[WRITE],"pong",4);
  84:	4611                	li	a2,4
  86:	00001597          	auipc	a1,0x1
  8a:	89a58593          	addi	a1,a1,-1894 # 920 <malloc+0x10e>
  8e:	fe442503          	lw	a0,-28(s0)
  92:	00000097          	auipc	ra,0x0
  96:	35a080e7          	jalr	858(ra) # 3ec <write>
        close(pc2p[WRITE]);
  9a:	fe442503          	lw	a0,-28(s0)
  9e:	00000097          	auipc	ra,0x0
  a2:	356080e7          	jalr	854(ra) # 3f4 <close>
        
        exit(0);
  a6:	4501                	li	a0,0
  a8:	00000097          	auipc	ra,0x0
  ac:	324080e7          	jalr	804(ra) # 3cc <exit>
        printf("fork error\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	84850513          	addi	a0,a0,-1976 # 8f8 <malloc+0xe6>
  b8:	00000097          	auipc	ra,0x0
  bc:	69c080e7          	jalr	1692(ra) # 754 <printf>
        exit(1);
  c0:	4505                	li	a0,1
  c2:	00000097          	auipc	ra,0x0
  c6:	30a080e7          	jalr	778(ra) # 3cc <exit>
    }
    else{
        close(pp2c[READ]);
  ca:	fe842503          	lw	a0,-24(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	326080e7          	jalr	806(ra) # 3f4 <close>
        close(pc2p[WRITE]);
  d6:	fe442503          	lw	a0,-28(s0)
  da:	00000097          	auipc	ra,0x0
  de:	31a080e7          	jalr	794(ra) # 3f4 <close>

        write(pp2c[WRITE],"ping",4);
  e2:	4611                	li	a2,4
  e4:	00001597          	auipc	a1,0x1
  e8:	84458593          	addi	a1,a1,-1980 # 928 <malloc+0x116>
  ec:	fec42503          	lw	a0,-20(s0)
  f0:	00000097          	auipc	ra,0x0
  f4:	2fc080e7          	jalr	764(ra) # 3ec <write>
        close(pp2c[WRITE]);
  f8:	fec42503          	lw	a0,-20(s0)
  fc:	00000097          	auipc	ra,0x0
 100:	2f8080e7          	jalr	760(ra) # 3f4 <close>

        read(pc2p[READ],c2p,sizeof(c2p));
 104:	04000613          	li	a2,64
 108:	f6040593          	addi	a1,s0,-160
 10c:	fe042503          	lw	a0,-32(s0)
 110:	00000097          	auipc	ra,0x0
 114:	2d4080e7          	jalr	724(ra) # 3e4 <read>
        printf("%d: received %s\n" , getpid(), c2p);
 118:	00000097          	auipc	ra,0x0
 11c:	334080e7          	jalr	820(ra) # 44c <getpid>
 120:	85aa                	mv	a1,a0
 122:	f6040613          	addi	a2,s0,-160
 126:	00000517          	auipc	a0,0x0
 12a:	7e250513          	addi	a0,a0,2018 # 908 <malloc+0xf6>
 12e:	00000097          	auipc	ra,0x0
 132:	626080e7          	jalr	1574(ra) # 754 <printf>
        close(pc2p[READ]);
 136:	fe042503          	lw	a0,-32(s0)
 13a:	00000097          	auipc	ra,0x0
 13e:	2ba080e7          	jalr	698(ra) # 3f4 <close>
        wait(0);
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	290080e7          	jalr	656(ra) # 3d4 <wait>
        exit(0);
 14c:	4501                	li	a0,0
 14e:	00000097          	auipc	ra,0x0
 152:	27e080e7          	jalr	638(ra) # 3cc <exit>

0000000000000156 <strcpy>:
#include "user/user.h"

//将字符串t的值复制给字符串s
char*
strcpy(char *s, const char *t)
{
 156:	1141                	addi	sp,sp,-16
 158:	e422                	sd	s0,8(sp)
 15a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15c:	87aa                	mv	a5,a0
 15e:	0585                	addi	a1,a1,1
 160:	0785                	addi	a5,a5,1
 162:	fff5c703          	lbu	a4,-1(a1)
 166:	fee78fa3          	sb	a4,-1(a5)
 16a:	fb75                	bnez	a4,15e <strcpy+0x8>
    ;
  return os;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strcmp>:

//把p所指向的字符串和q所指向的字符串进行比较
int
strcmp(const char *p, const char *q)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cb91                	beqz	a5,190 <strcmp+0x1e>
 17e:	0005c703          	lbu	a4,0(a1)
 182:	00f71763          	bne	a4,a5,190 <strcmp+0x1e>
    p++, q++;
 186:	0505                	addi	a0,a0,1
 188:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbe5                	bnez	a5,17e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 190:	0005c503          	lbu	a0,0(a1)
}
 194:	40a7853b          	subw	a0,a5,a0
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret

000000000000019e <strlen>:

//从内存的某个位置（可以是字符串开头，中间某个位置，甚至是某个不确定的内存区域）开始扫描，直到碰到第一个字符串结束符 \0 为止，然后返回计数器值（长度不包含 \0 ）
uint
strlen(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e422                	sd	s0,8(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf91                	beqz	a5,1c4 <strlen+0x26>
 1aa:	0505                	addi	a0,a0,1
 1ac:	87aa                	mv	a5,a0
 1ae:	4685                	li	a3,1
 1b0:	9e89                	subw	a3,a3,a0
 1b2:	00f6853b          	addw	a0,a3,a5
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff7c703          	lbu	a4,-1(a5)
 1bc:	fb7d                	bnez	a4,1b2 <strlen+0x14>
    ;
  return n;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	addi	sp,sp,16
 1c2:	8082                	ret
  for(n = 0; s[n]; n++)
 1c4:	4501                	li	a0,0
 1c6:	bfe5                	j	1be <strlen+0x20>

00000000000001c8 <memset>:

//复制字符 c（一个无符号字符）到参数 str 所指向的字符串的前 n 个字符
void*
memset(void *dst, int c, uint n)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst; //将指针dst强制转换为char型指针
  int i;
  for(i = 0; i < n; i++){
 1ce:	ce09                	beqz	a2,1e8 <memset+0x20>
 1d0:	87aa                	mv	a5,a0
 1d2:	fff6071b          	addiw	a4,a2,-1
 1d6:	1702                	slli	a4,a4,0x20
 1d8:	9301                	srli	a4,a4,0x20
 1da:	0705                	addi	a4,a4,1
 1dc:	972a                	add	a4,a4,a0
    cdst[i] = c;
 1de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e2:	0785                	addi	a5,a5,1
 1e4:	fee79de3          	bne	a5,a4,1de <memset+0x16>
  }
  return dst;
}
 1e8:	6422                	ld	s0,8(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <strchr>:


char*
strchr(const char *s, char c)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f4:	00054783          	lbu	a5,0(a0)
 1f8:	cb99                	beqz	a5,20e <strchr+0x20>
    if(*s == c)
 1fa:	00f58763          	beq	a1,a5,208 <strchr+0x1a>
  for(; *s; s++)
 1fe:	0505                	addi	a0,a0,1
 200:	00054783          	lbu	a5,0(a0)
 204:	fbfd                	bnez	a5,1fa <strchr+0xc>
      return (char*)s;
  return 0;
 206:	4501                	li	a0,0
}
 208:	6422                	ld	s0,8(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  return 0;
 20e:	4501                	li	a0,0
 210:	bfe5                	j	208 <strchr+0x1a>

0000000000000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	711d                	addi	sp,sp,-96
 214:	ec86                	sd	ra,88(sp)
 216:	e8a2                	sd	s0,80(sp)
 218:	e4a6                	sd	s1,72(sp)
 21a:	e0ca                	sd	s2,64(sp)
 21c:	fc4e                	sd	s3,56(sp)
 21e:	f852                	sd	s4,48(sp)
 220:	f456                	sd	s5,40(sp)
 222:	f05a                	sd	s6,32(sp)
 224:	ec5e                	sd	s7,24(sp)
 226:	1080                	addi	s0,sp,96
 228:	8baa                	mv	s7,a0
 22a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	892a                	mv	s2,a0
 22e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 230:	4aa9                	li	s5,10
 232:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 234:	89a6                	mv	s3,s1
 236:	2485                	addiw	s1,s1,1
 238:	0344d863          	bge	s1,s4,268 <gets+0x56>
    cc = read(0, &c, 1);
 23c:	4605                	li	a2,1
 23e:	faf40593          	addi	a1,s0,-81
 242:	4501                	li	a0,0
 244:	00000097          	auipc	ra,0x0
 248:	1a0080e7          	jalr	416(ra) # 3e4 <read>
    if(cc < 1)
 24c:	00a05e63          	blez	a0,268 <gets+0x56>
    buf[i++] = c;
 250:	faf44783          	lbu	a5,-81(s0)
 254:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 258:	01578763          	beq	a5,s5,266 <gets+0x54>
 25c:	0905                	addi	s2,s2,1
 25e:	fd679be3          	bne	a5,s6,234 <gets+0x22>
  for(i=0; i+1 < max; ){
 262:	89a6                	mv	s3,s1
 264:	a011                	j	268 <gets+0x56>
 266:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 268:	99de                	add	s3,s3,s7
 26a:	00098023          	sb	zero,0(s3)
  return buf;
}
 26e:	855e                	mv	a0,s7
 270:	60e6                	ld	ra,88(sp)
 272:	6446                	ld	s0,80(sp)
 274:	64a6                	ld	s1,72(sp)
 276:	6906                	ld	s2,64(sp)
 278:	79e2                	ld	s3,56(sp)
 27a:	7a42                	ld	s4,48(sp)
 27c:	7aa2                	ld	s5,40(sp)
 27e:	7b02                	ld	s6,32(sp)
 280:	6be2                	ld	s7,24(sp)
 282:	6125                	addi	sp,sp,96
 284:	8082                	ret

0000000000000286 <stat>:

int
stat(const char *n, struct stat *st)
{
 286:	1101                	addi	sp,sp,-32
 288:	ec06                	sd	ra,24(sp)
 28a:	e822                	sd	s0,16(sp)
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	1000                	addi	s0,sp,32
 292:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 294:	4581                	li	a1,0
 296:	00000097          	auipc	ra,0x0
 29a:	176080e7          	jalr	374(ra) # 40c <open>
  if(fd < 0)
 29e:	02054563          	bltz	a0,2c8 <stat+0x42>
 2a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a4:	85ca                	mv	a1,s2
 2a6:	00000097          	auipc	ra,0x0
 2aa:	17e080e7          	jalr	382(ra) # 424 <fstat>
 2ae:	892a                	mv	s2,a0
  close(fd);
 2b0:	8526                	mv	a0,s1
 2b2:	00000097          	auipc	ra,0x0
 2b6:	142080e7          	jalr	322(ra) # 3f4 <close>
  return r;
}
 2ba:	854a                	mv	a0,s2
 2bc:	60e2                	ld	ra,24(sp)
 2be:	6442                	ld	s0,16(sp)
 2c0:	64a2                	ld	s1,8(sp)
 2c2:	6902                	ld	s2,0(sp)
 2c4:	6105                	addi	sp,sp,32
 2c6:	8082                	ret
    return -1;
 2c8:	597d                	li	s2,-1
 2ca:	bfc5                	j	2ba <stat+0x34>

00000000000002cc <atoi>:

//将参数s所指向字符串转换为一个整数
int
atoi(const char *s)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e422                	sd	s0,8(sp)
 2d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d2:	00054603          	lbu	a2,0(a0)
 2d6:	fd06079b          	addiw	a5,a2,-48
 2da:	0ff7f793          	andi	a5,a5,255
 2de:	4725                	li	a4,9
 2e0:	02f76963          	bltu	a4,a5,312 <atoi+0x46>
 2e4:	86aa                	mv	a3,a0
  n = 0;
 2e6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 2e8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 2ea:	0685                	addi	a3,a3,1
 2ec:	0025179b          	slliw	a5,a0,0x2
 2f0:	9fa9                	addw	a5,a5,a0
 2f2:	0017979b          	slliw	a5,a5,0x1
 2f6:	9fb1                	addw	a5,a5,a2
 2f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fc:	0006c603          	lbu	a2,0(a3)
 300:	fd06071b          	addiw	a4,a2,-48
 304:	0ff77713          	andi	a4,a4,255
 308:	fee5f1e3          	bgeu	a1,a4,2ea <atoi+0x1e>
  return n;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
  n = 0;
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <atoi+0x40>

0000000000000316 <memmove>:

//将vsrc开始后n个字符复制到从vdst开始的位置
void*
memmove(void *vdst, const void *vsrc, int n)
{
 316:	1141                	addi	sp,sp,-16
 318:	e422                	sd	s0,8(sp)
 31a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31c:	02b57663          	bgeu	a0,a1,348 <memmove+0x32>
    while(n-- > 0)
 320:	02c05163          	blez	a2,342 <memmove+0x2c>
 324:	fff6079b          	addiw	a5,a2,-1
 328:	1782                	slli	a5,a5,0x20
 32a:	9381                	srli	a5,a5,0x20
 32c:	0785                	addi	a5,a5,1
 32e:	97aa                	add	a5,a5,a0
  dst = vdst;
 330:	872a                	mv	a4,a0
      *dst++ = *src++;
 332:	0585                	addi	a1,a1,1
 334:	0705                	addi	a4,a4,1
 336:	fff5c683          	lbu	a3,-1(a1)
 33a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33e:	fee79ae3          	bne	a5,a4,332 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 342:	6422                	ld	s0,8(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret
    dst += n;
 348:	00c50733          	add	a4,a0,a2
    src += n;
 34c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34e:	fec05ae3          	blez	a2,342 <memmove+0x2c>
 352:	fff6079b          	addiw	a5,a2,-1
 356:	1782                	slli	a5,a5,0x20
 358:	9381                	srli	a5,a5,0x20
 35a:	fff7c793          	not	a5,a5
 35e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 360:	15fd                	addi	a1,a1,-1
 362:	177d                	addi	a4,a4,-1
 364:	0005c683          	lbu	a3,0(a1)
 368:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36c:	fee79ae3          	bne	a5,a4,360 <memmove+0x4a>
 370:	bfc9                	j	342 <memmove+0x2c>

0000000000000372 <memcmp>:


int
memcmp(const void *s1, const void *s2, uint n)
{
 372:	1141                	addi	sp,sp,-16
 374:	e422                	sd	s0,8(sp)
 376:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 378:	ca05                	beqz	a2,3a8 <memcmp+0x36>
 37a:	fff6069b          	addiw	a3,a2,-1
 37e:	1682                	slli	a3,a3,0x20
 380:	9281                	srli	a3,a3,0x20
 382:	0685                	addi	a3,a3,1
 384:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 386:	00054783          	lbu	a5,0(a0)
 38a:	0005c703          	lbu	a4,0(a1)
 38e:	00e79863          	bne	a5,a4,39e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 392:	0505                	addi	a0,a0,1
    p2++;
 394:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 396:	fed518e3          	bne	a0,a3,386 <memcmp+0x14>
  }
  return 0;
 39a:	4501                	li	a0,0
 39c:	a019                	j	3a2 <memcmp+0x30>
      return *p1 - *p2;
 39e:	40e7853b          	subw	a0,a5,a4
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  return 0;
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <memcmp+0x30>

00000000000003ac <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e406                	sd	ra,8(sp)
 3b0:	e022                	sd	s0,0(sp)
 3b2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b4:	00000097          	auipc	ra,0x0
 3b8:	f62080e7          	jalr	-158(ra) # 316 <memmove>
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c4:	4885                	li	a7,1
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3cc:	4889                	li	a7,2
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d4:	488d                	li	a7,3
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3dc:	4891                	li	a7,4
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <read>:
.global read
read:
 li a7, SYS_read
 3e4:	4895                	li	a7,5
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <write>:
.global write
write:
 li a7, SYS_write
 3ec:	48c1                	li	a7,16
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <close>:
.global close
close:
 li a7, SYS_close
 3f4:	48d5                	li	a7,21
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fc:	4899                	li	a7,6
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <exec>:
.global exec
exec:
 li a7, SYS_exec
 404:	489d                	li	a7,7
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <open>:
.global open
open:
 li a7, SYS_open
 40c:	48bd                	li	a7,15
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 414:	48c5                	li	a7,17
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41c:	48c9                	li	a7,18
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 424:	48a1                	li	a7,8
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <link>:
.global link
link:
 li a7, SYS_link
 42c:	48cd                	li	a7,19
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 434:	48d1                	li	a7,20
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43c:	48a5                	li	a7,9
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <dup>:
.global dup
dup:
 li a7, SYS_dup
 444:	48a9                	li	a7,10
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44c:	48ad                	li	a7,11
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 454:	48b1                	li	a7,12
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45c:	48b5                	li	a7,13
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 464:	48b9                	li	a7,14
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <trace>:
.global trace
trace:
 li a7, SYS_trace
 46c:	48d9                	li	a7,22
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 474:	48dd                	li	a7,23
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47c:	1101                	addi	sp,sp,-32
 47e:	ec06                	sd	ra,24(sp)
 480:	e822                	sd	s0,16(sp)
 482:	1000                	addi	s0,sp,32
 484:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 488:	4605                	li	a2,1
 48a:	fef40593          	addi	a1,s0,-17
 48e:	00000097          	auipc	ra,0x0
 492:	f5e080e7          	jalr	-162(ra) # 3ec <write>
}
 496:	60e2                	ld	ra,24(sp)
 498:	6442                	ld	s0,16(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret

000000000000049e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49e:	7139                	addi	sp,sp,-64
 4a0:	fc06                	sd	ra,56(sp)
 4a2:	f822                	sd	s0,48(sp)
 4a4:	f426                	sd	s1,40(sp)
 4a6:	f04a                	sd	s2,32(sp)
 4a8:	ec4e                	sd	s3,24(sp)
 4aa:	0080                	addi	s0,sp,64
 4ac:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ae:	c299                	beqz	a3,4b4 <printint+0x16>
 4b0:	0805c863          	bltz	a1,540 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b4:	2581                	sext.w	a1,a1
  neg = 0;
 4b6:	4881                	li	a7,0
 4b8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4bc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4be:	2601                	sext.w	a2,a2
 4c0:	00000517          	auipc	a0,0x0
 4c4:	47850513          	addi	a0,a0,1144 # 938 <digits>
 4c8:	883a                	mv	a6,a4
 4ca:	2705                	addiw	a4,a4,1
 4cc:	02c5f7bb          	remuw	a5,a1,a2
 4d0:	1782                	slli	a5,a5,0x20
 4d2:	9381                	srli	a5,a5,0x20
 4d4:	97aa                	add	a5,a5,a0
 4d6:	0007c783          	lbu	a5,0(a5)
 4da:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4de:	0005879b          	sext.w	a5,a1
 4e2:	02c5d5bb          	divuw	a1,a1,a2
 4e6:	0685                	addi	a3,a3,1
 4e8:	fec7f0e3          	bgeu	a5,a2,4c8 <printint+0x2a>
  if(neg)
 4ec:	00088b63          	beqz	a7,502 <printint+0x64>
    buf[i++] = '-';
 4f0:	fd040793          	addi	a5,s0,-48
 4f4:	973e                	add	a4,a4,a5
 4f6:	02d00793          	li	a5,45
 4fa:	fef70823          	sb	a5,-16(a4)
 4fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 502:	02e05863          	blez	a4,532 <printint+0x94>
 506:	fc040793          	addi	a5,s0,-64
 50a:	00e78933          	add	s2,a5,a4
 50e:	fff78993          	addi	s3,a5,-1
 512:	99ba                	add	s3,s3,a4
 514:	377d                	addiw	a4,a4,-1
 516:	1702                	slli	a4,a4,0x20
 518:	9301                	srli	a4,a4,0x20
 51a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 51e:	fff94583          	lbu	a1,-1(s2)
 522:	8526                	mv	a0,s1
 524:	00000097          	auipc	ra,0x0
 528:	f58080e7          	jalr	-168(ra) # 47c <putc>
  while(--i >= 0)
 52c:	197d                	addi	s2,s2,-1
 52e:	ff3918e3          	bne	s2,s3,51e <printint+0x80>
}
 532:	70e2                	ld	ra,56(sp)
 534:	7442                	ld	s0,48(sp)
 536:	74a2                	ld	s1,40(sp)
 538:	7902                	ld	s2,32(sp)
 53a:	69e2                	ld	s3,24(sp)
 53c:	6121                	addi	sp,sp,64
 53e:	8082                	ret
    x = -xx;
 540:	40b005bb          	negw	a1,a1
    neg = 1;
 544:	4885                	li	a7,1
    x = -xx;
 546:	bf8d                	j	4b8 <printint+0x1a>

0000000000000548 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 548:	7119                	addi	sp,sp,-128
 54a:	fc86                	sd	ra,120(sp)
 54c:	f8a2                	sd	s0,112(sp)
 54e:	f4a6                	sd	s1,104(sp)
 550:	f0ca                	sd	s2,96(sp)
 552:	ecce                	sd	s3,88(sp)
 554:	e8d2                	sd	s4,80(sp)
 556:	e4d6                	sd	s5,72(sp)
 558:	e0da                	sd	s6,64(sp)
 55a:	fc5e                	sd	s7,56(sp)
 55c:	f862                	sd	s8,48(sp)
 55e:	f466                	sd	s9,40(sp)
 560:	f06a                	sd	s10,32(sp)
 562:	ec6e                	sd	s11,24(sp)
 564:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 566:	0005c903          	lbu	s2,0(a1)
 56a:	18090f63          	beqz	s2,708 <vprintf+0x1c0>
 56e:	8aaa                	mv	s5,a0
 570:	8b32                	mv	s6,a2
 572:	00158493          	addi	s1,a1,1
  state = 0;
 576:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 578:	02500a13          	li	s4,37
      if(c == 'd'){
 57c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 580:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 584:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 588:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 58c:	00000b97          	auipc	s7,0x0
 590:	3acb8b93          	addi	s7,s7,940 # 938 <digits>
 594:	a839                	j	5b2 <vprintf+0x6a>
        putc(fd, c);
 596:	85ca                	mv	a1,s2
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	ee2080e7          	jalr	-286(ra) # 47c <putc>
 5a2:	a019                	j	5a8 <vprintf+0x60>
    } else if(state == '%'){
 5a4:	01498f63          	beq	s3,s4,5c2 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5a8:	0485                	addi	s1,s1,1
 5aa:	fff4c903          	lbu	s2,-1(s1)
 5ae:	14090d63          	beqz	s2,708 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5b2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5b6:	fe0997e3          	bnez	s3,5a4 <vprintf+0x5c>
      if(c == '%'){
 5ba:	fd479ee3          	bne	a5,s4,596 <vprintf+0x4e>
        state = '%';
 5be:	89be                	mv	s3,a5
 5c0:	b7e5                	j	5a8 <vprintf+0x60>
      if(c == 'd'){
 5c2:	05878063          	beq	a5,s8,602 <vprintf+0xba>
      } else if(c == 'l') {
 5c6:	05978c63          	beq	a5,s9,61e <vprintf+0xd6>
      } else if(c == 'x') {
 5ca:	07a78863          	beq	a5,s10,63a <vprintf+0xf2>
      } else if(c == 'p') {
 5ce:	09b78463          	beq	a5,s11,656 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5d2:	07300713          	li	a4,115
 5d6:	0ce78663          	beq	a5,a4,6a2 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5da:	06300713          	li	a4,99
 5de:	0ee78e63          	beq	a5,a4,6da <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 5e2:	11478863          	beq	a5,s4,6f2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e6:	85d2                	mv	a1,s4
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	e92080e7          	jalr	-366(ra) # 47c <putc>
        putc(fd, c);
 5f2:	85ca                	mv	a1,s2
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e86080e7          	jalr	-378(ra) # 47c <putc>
      }
      state = 0;
 5fe:	4981                	li	s3,0
 600:	b765                	j	5a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 602:	008b0913          	addi	s2,s6,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000b2583          	lw	a1,0(s6)
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e8e080e7          	jalr	-370(ra) # 49e <printint>
 618:	8b4a                	mv	s6,s2
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b771                	j	5a8 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b0913          	addi	s2,s6,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000b2583          	lw	a1,0(s6)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	e72080e7          	jalr	-398(ra) # 49e <printint>
 634:	8b4a                	mv	s6,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	bf85                	j	5a8 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 63a:	008b0913          	addi	s2,s6,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000b2583          	lw	a1,0(s6)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	e56080e7          	jalr	-426(ra) # 49e <printint>
 650:	8b4a                	mv	s6,s2
      state = 0;
 652:	4981                	li	s3,0
 654:	bf91                	j	5a8 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 656:	008b0793          	addi	a5,s6,8
 65a:	f8f43423          	sd	a5,-120(s0)
 65e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 662:	03000593          	li	a1,48
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e14080e7          	jalr	-492(ra) # 47c <putc>
  putc(fd, 'x');
 670:	85ea                	mv	a1,s10
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	e08080e7          	jalr	-504(ra) # 47c <putc>
 67c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	03c9d793          	srli	a5,s3,0x3c
 682:	97de                	add	a5,a5,s7
 684:	0007c583          	lbu	a1,0(a5)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	df2080e7          	jalr	-526(ra) # 47c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 692:	0992                	slli	s3,s3,0x4
 694:	397d                	addiw	s2,s2,-1
 696:	fe0914e3          	bnez	s2,67e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 69a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b721                	j	5a8 <vprintf+0x60>
        s = va_arg(ap, char*);
 6a2:	008b0993          	addi	s3,s6,8
 6a6:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6aa:	02090163          	beqz	s2,6cc <vprintf+0x184>
        while(*s != 0){
 6ae:	00094583          	lbu	a1,0(s2)
 6b2:	c9a1                	beqz	a1,702 <vprintf+0x1ba>
          putc(fd, *s);
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	dc6080e7          	jalr	-570(ra) # 47c <putc>
          s++;
 6be:	0905                	addi	s2,s2,1
        while(*s != 0){
 6c0:	00094583          	lbu	a1,0(s2)
 6c4:	f9e5                	bnez	a1,6b4 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6c6:	8b4e                	mv	s6,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bdf9                	j	5a8 <vprintf+0x60>
          s = "(null)";
 6cc:	00000917          	auipc	s2,0x0
 6d0:	26490913          	addi	s2,s2,612 # 930 <malloc+0x11e>
        while(*s != 0){
 6d4:	02800593          	li	a1,40
 6d8:	bff1                	j	6b4 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6da:	008b0913          	addi	s2,s6,8
 6de:	000b4583          	lbu	a1,0(s6)
 6e2:	8556                	mv	a0,s5
 6e4:	00000097          	auipc	ra,0x0
 6e8:	d98080e7          	jalr	-616(ra) # 47c <putc>
 6ec:	8b4a                	mv	s6,s2
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bd65                	j	5a8 <vprintf+0x60>
        putc(fd, c);
 6f2:	85d2                	mv	a1,s4
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	d86080e7          	jalr	-634(ra) # 47c <putc>
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b565                	j	5a8 <vprintf+0x60>
        s = va_arg(ap, char*);
 702:	8b4e                	mv	s6,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	b54d                	j	5a8 <vprintf+0x60>
    }
  }
}
 708:	70e6                	ld	ra,120(sp)
 70a:	7446                	ld	s0,112(sp)
 70c:	74a6                	ld	s1,104(sp)
 70e:	7906                	ld	s2,96(sp)
 710:	69e6                	ld	s3,88(sp)
 712:	6a46                	ld	s4,80(sp)
 714:	6aa6                	ld	s5,72(sp)
 716:	6b06                	ld	s6,64(sp)
 718:	7be2                	ld	s7,56(sp)
 71a:	7c42                	ld	s8,48(sp)
 71c:	7ca2                	ld	s9,40(sp)
 71e:	7d02                	ld	s10,32(sp)
 720:	6de2                	ld	s11,24(sp)
 722:	6109                	addi	sp,sp,128
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	00000097          	auipc	ra,0x0
 748:	e04080e7          	jalr	-508(ra) # 548 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6161                	addi	sp,sp,80
 752:	8082                	ret

0000000000000754 <printf>:

void
printf(const char *fmt, ...)
{
 754:	711d                	addi	sp,sp,-96
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e40c                	sd	a1,8(s0)
 75e:	e810                	sd	a2,16(s0)
 760:	ec14                	sd	a3,24(s0)
 762:	f018                	sd	a4,32(s0)
 764:	f41c                	sd	a5,40(s0)
 766:	03043823          	sd	a6,48(s0)
 76a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	00840613          	addi	a2,s0,8
 772:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 776:	85aa                	mv	a1,a0
 778:	4505                	li	a0,1
 77a:	00000097          	auipc	ra,0x0
 77e:	dce080e7          	jalr	-562(ra) # 548 <vprintf>
}
 782:	60e2                	ld	ra,24(sp)
 784:	6442                	ld	s0,16(sp)
 786:	6125                	addi	sp,sp,96
 788:	8082                	ret

000000000000078a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78a:	1141                	addi	sp,sp,-16
 78c:	e422                	sd	s0,8(sp)
 78e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 790:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 794:	00000797          	auipc	a5,0x0
 798:	1bc7b783          	ld	a5,444(a5) # 950 <freep>
 79c:	a805                	j	7cc <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 79e:	4618                	lw	a4,8(a2)
 7a0:	9db9                	addw	a1,a1,a4
 7a2:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a6:	6398                	ld	a4,0(a5)
 7a8:	6318                	ld	a4,0(a4)
 7aa:	fee53823          	sd	a4,-16(a0)
 7ae:	a091                	j	7f2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b0:	ff852703          	lw	a4,-8(a0)
 7b4:	9e39                	addw	a2,a2,a4
 7b6:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7b8:	ff053703          	ld	a4,-16(a0)
 7bc:	e398                	sd	a4,0(a5)
 7be:	a099                	j	804 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c0:	6398                	ld	a4,0(a5)
 7c2:	00e7e463          	bltu	a5,a4,7ca <free+0x40>
 7c6:	00e6ea63          	bltu	a3,a4,7da <free+0x50>
{
 7ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	fed7fae3          	bgeu	a5,a3,7c0 <free+0x36>
 7d0:	6398                	ld	a4,0(a5)
 7d2:	00e6e463          	bltu	a3,a4,7da <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	fee7eae3          	bltu	a5,a4,7ca <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7da:	ff852583          	lw	a1,-8(a0)
 7de:	6390                	ld	a2,0(a5)
 7e0:	02059713          	slli	a4,a1,0x20
 7e4:	9301                	srli	a4,a4,0x20
 7e6:	0712                	slli	a4,a4,0x4
 7e8:	9736                	add	a4,a4,a3
 7ea:	fae60ae3          	beq	a2,a4,79e <free+0x14>
    bp->s.ptr = p->s.ptr;
 7ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f2:	4790                	lw	a2,8(a5)
 7f4:	02061713          	slli	a4,a2,0x20
 7f8:	9301                	srli	a4,a4,0x20
 7fa:	0712                	slli	a4,a4,0x4
 7fc:	973e                	add	a4,a4,a5
 7fe:	fae689e3          	beq	a3,a4,7b0 <free+0x26>
  } else
    p->s.ptr = bp;
 802:	e394                	sd	a3,0(a5)
  freep = p;
 804:	00000717          	auipc	a4,0x0
 808:	14f73623          	sd	a5,332(a4) # 950 <freep>
}
 80c:	6422                	ld	s0,8(sp)
 80e:	0141                	addi	sp,sp,16
 810:	8082                	ret

0000000000000812 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 812:	7139                	addi	sp,sp,-64
 814:	fc06                	sd	ra,56(sp)
 816:	f822                	sd	s0,48(sp)
 818:	f426                	sd	s1,40(sp)
 81a:	f04a                	sd	s2,32(sp)
 81c:	ec4e                	sd	s3,24(sp)
 81e:	e852                	sd	s4,16(sp)
 820:	e456                	sd	s5,8(sp)
 822:	e05a                	sd	s6,0(sp)
 824:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 826:	02051493          	slli	s1,a0,0x20
 82a:	9081                	srli	s1,s1,0x20
 82c:	04bd                	addi	s1,s1,15
 82e:	8091                	srli	s1,s1,0x4
 830:	0014899b          	addiw	s3,s1,1
 834:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 836:	00000517          	auipc	a0,0x0
 83a:	11a53503          	ld	a0,282(a0) # 950 <freep>
 83e:	c515                	beqz	a0,86a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	02977f63          	bgeu	a4,s1,882 <malloc+0x70>
 848:	8a4e                	mv	s4,s3
 84a:	0009871b          	sext.w	a4,s3
 84e:	6685                	lui	a3,0x1
 850:	00d77363          	bgeu	a4,a3,856 <malloc+0x44>
 854:	6a05                	lui	s4,0x1
 856:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85e:	00000917          	auipc	s2,0x0
 862:	0f290913          	addi	s2,s2,242 # 950 <freep>
  if(p == (char*)-1)
 866:	5afd                	li	s5,-1
 868:	a88d                	j	8da <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 86a:	00000797          	auipc	a5,0x0
 86e:	0ee78793          	addi	a5,a5,238 # 958 <base>
 872:	00000717          	auipc	a4,0x0
 876:	0cf73f23          	sd	a5,222(a4) # 950 <freep>
 87a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 880:	b7e1                	j	848 <malloc+0x36>
      if(p->s.size == nunits)
 882:	02e48b63          	beq	s1,a4,8b8 <malloc+0xa6>
        p->s.size -= nunits;
 886:	4137073b          	subw	a4,a4,s3
 88a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 88c:	1702                	slli	a4,a4,0x20
 88e:	9301                	srli	a4,a4,0x20
 890:	0712                	slli	a4,a4,0x4
 892:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 894:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 898:	00000717          	auipc	a4,0x0
 89c:	0aa73c23          	sd	a0,184(a4) # 950 <freep>
      return (void*)(p + 1);
 8a0:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8a4:	70e2                	ld	ra,56(sp)
 8a6:	7442                	ld	s0,48(sp)
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	7902                	ld	s2,32(sp)
 8ac:	69e2                	ld	s3,24(sp)
 8ae:	6a42                	ld	s4,16(sp)
 8b0:	6aa2                	ld	s5,8(sp)
 8b2:	6b02                	ld	s6,0(sp)
 8b4:	6121                	addi	sp,sp,64
 8b6:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8b8:	6398                	ld	a4,0(a5)
 8ba:	e118                	sd	a4,0(a0)
 8bc:	bff1                	j	898 <malloc+0x86>
  hp->s.size = nu;
 8be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c2:	0541                	addi	a0,a0,16
 8c4:	00000097          	auipc	ra,0x0
 8c8:	ec6080e7          	jalr	-314(ra) # 78a <free>
  return freep;
 8cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8d0:	d971                	beqz	a0,8a4 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	fa9776e3          	bgeu	a4,s1,882 <malloc+0x70>
    if(p == freep)
 8da:	00093703          	ld	a4,0(s2)
 8de:	853e                	mv	a0,a5
 8e0:	fef719e3          	bne	a4,a5,8d2 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 8e4:	8552                	mv	a0,s4
 8e6:	00000097          	auipc	ra,0x0
 8ea:	b6e080e7          	jalr	-1170(ra) # 454 <sbrk>
  if(p == (char*)-1)
 8ee:	fd5518e3          	bne	a0,s5,8be <malloc+0xac>
        return 0;
 8f2:	4501                	li	a0,0
 8f4:	bf45                	j	8a4 <malloc+0x92>
