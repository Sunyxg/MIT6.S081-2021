
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test2();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00001517          	auipc	a0,0x1
  14:	ca850513          	addi	a0,a0,-856 # cb8 <buf>
  18:	00001097          	auipc	ra,0x1
  1c:	a9e080e7          	jalr	-1378(ra) # ab6 <statistics>
  20:	02a05b63          	blez	a0,56 <ntas+0x56>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  24:	03d00593          	li	a1,61
  28:	00001517          	auipc	a0,0x1
  2c:	c9050513          	addi	a0,a0,-880 # cb8 <buf>
  30:	00000097          	auipc	ra,0x0
  34:	38e080e7          	jalr	910(ra) # 3be <strchr>
  n = atoi(c+2);
  38:	0509                	addi	a0,a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	462080e7          	jalr	1122(ra) # 49c <atoi>
  42:	84aa                	mv	s1,a0
  if(print)
  44:	02091363          	bnez	s2,6a <ntas+0x6a>
    printf("%s", buf);
  return n;
}
  48:	8526                	mv	a0,s1
  4a:	60e2                	ld	ra,24(sp)
  4c:	6442                	ld	s0,16(sp)
  4e:	64a2                	ld	s1,8(sp)
  50:	6902                	ld	s2,0(sp)
  52:	6105                	addi	sp,sp,32
  54:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  56:	00001597          	auipc	a1,0x1
  5a:	aea58593          	addi	a1,a1,-1302 # b40 <statistics+0x8a>
  5e:	4509                	li	a0,2
  60:	00001097          	auipc	ra,0x1
  64:	886080e7          	jalr	-1914(ra) # 8e6 <fprintf>
  68:	bf75                	j	24 <ntas+0x24>
    printf("%s", buf);
  6a:	00001597          	auipc	a1,0x1
  6e:	c4e58593          	addi	a1,a1,-946 # cb8 <buf>
  72:	00001517          	auipc	a0,0x1
  76:	ade50513          	addi	a0,a0,-1314 # b50 <statistics+0x9a>
  7a:	00001097          	auipc	ra,0x1
  7e:	89a080e7          	jalr	-1894(ra) # 914 <printf>
  82:	b7d9                	j	48 <ntas+0x48>

0000000000000084 <test1>:

void test1(void)
{
  84:	7179                	addi	sp,sp,-48
  86:	f406                	sd	ra,40(sp)
  88:	f022                	sd	s0,32(sp)
  8a:	ec26                	sd	s1,24(sp)
  8c:	e84a                	sd	s2,16(sp)
  8e:	e44e                	sd	s3,8(sp)
  90:	1800                	addi	s0,sp,48
  void *a, *a1;
  int n, m;
  printf("start test1\n");  
  92:	00001517          	auipc	a0,0x1
  96:	ac650513          	addi	a0,a0,-1338 # b58 <statistics+0xa2>
  9a:	00001097          	auipc	ra,0x1
  9e:	87a080e7          	jalr	-1926(ra) # 914 <printf>
  m = ntas(0);
  a2:	4501                	li	a0,0
  a4:	00000097          	auipc	ra,0x0
  a8:	f5c080e7          	jalr	-164(ra) # 0 <ntas>
  ac:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  ae:	00000097          	auipc	ra,0x0
  b2:	4e6080e7          	jalr	1254(ra) # 594 <fork>
    if(pid < 0){
  b6:	06054463          	bltz	a0,11e <test1+0x9a>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  ba:	cd3d                	beqz	a0,138 <test1+0xb4>
    int pid = fork();
  bc:	00000097          	auipc	ra,0x0
  c0:	4d8080e7          	jalr	1240(ra) # 594 <fork>
    if(pid < 0){
  c4:	04054d63          	bltz	a0,11e <test1+0x9a>
    if(pid == 0){
  c8:	c925                	beqz	a0,138 <test1+0xb4>
      exit(-1);
    }
  }

  for(int i = 0; i < NCHILD; i++){
    wait(0);
  ca:	4501                	li	a0,0
  cc:	00000097          	auipc	ra,0x0
  d0:	4d8080e7          	jalr	1240(ra) # 5a4 <wait>
  d4:	4501                	li	a0,0
  d6:	00000097          	auipc	ra,0x0
  da:	4ce080e7          	jalr	1230(ra) # 5a4 <wait>
  }
  printf("test1 results:\n");
  de:	00001517          	auipc	a0,0x1
  e2:	aaa50513          	addi	a0,a0,-1366 # b88 <statistics+0xd2>
  e6:	00001097          	auipc	ra,0x1
  ea:	82e080e7          	jalr	-2002(ra) # 914 <printf>
  n = ntas(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <ntas>
  if(n-m < 10) 
  f8:	9d05                	subw	a0,a0,s1
  fa:	47a5                	li	a5,9
  fc:	08a7c863          	blt	a5,a0,18c <test1+0x108>
    printf("test1 OK\n");
 100:	00001517          	auipc	a0,0x1
 104:	a9850513          	addi	a0,a0,-1384 # b98 <statistics+0xe2>
 108:	00001097          	auipc	ra,0x1
 10c:	80c080e7          	jalr	-2036(ra) # 914 <printf>
  else
    printf("test1 FAIL\n");
}
 110:	70a2                	ld	ra,40(sp)
 112:	7402                	ld	s0,32(sp)
 114:	64e2                	ld	s1,24(sp)
 116:	6942                	ld	s2,16(sp)
 118:	69a2                	ld	s3,8(sp)
 11a:	6145                	addi	sp,sp,48
 11c:	8082                	ret
      printf("fork failed");
 11e:	00001517          	auipc	a0,0x1
 122:	a4a50513          	addi	a0,a0,-1462 # b68 <statistics+0xb2>
 126:	00000097          	auipc	ra,0x0
 12a:	7ee080e7          	jalr	2030(ra) # 914 <printf>
      exit(-1);
 12e:	557d                	li	a0,-1
 130:	00000097          	auipc	ra,0x0
 134:	46c080e7          	jalr	1132(ra) # 59c <exit>
{
 138:	6961                	lui	s2,0x18
 13a:	6a090913          	addi	s2,s2,1696 # 186a0 <__BSS_END__+0x169d8>
        *(int *)(a+4) = 1;
 13e:	4985                	li	s3,1
        a = sbrk(4096);
 140:	6505                	lui	a0,0x1
 142:	00000097          	auipc	ra,0x0
 146:	4e2080e7          	jalr	1250(ra) # 624 <sbrk>
 14a:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 14c:	01352223          	sw	s3,4(a0) # 1004 <buf+0x34c>
        a1 = sbrk(-4096);
 150:	757d                	lui	a0,0xfffff
 152:	00000097          	auipc	ra,0x0
 156:	4d2080e7          	jalr	1234(ra) # 624 <sbrk>
        if (a1 != a + 4096) {
 15a:	6785                	lui	a5,0x1
 15c:	94be                	add	s1,s1,a5
 15e:	00951a63          	bne	a0,s1,172 <test1+0xee>
      for(i = 0; i < N; i++) {
 162:	397d                	addiw	s2,s2,-1
 164:	fc091ee3          	bnez	s2,140 <test1+0xbc>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	00000097          	auipc	ra,0x0
 16e:	432080e7          	jalr	1074(ra) # 59c <exit>
          printf("wrong sbrk\n");
 172:	00001517          	auipc	a0,0x1
 176:	a0650513          	addi	a0,a0,-1530 # b78 <statistics+0xc2>
 17a:	00000097          	auipc	ra,0x0
 17e:	79a080e7          	jalr	1946(ra) # 914 <printf>
          exit(-1);
 182:	557d                	li	a0,-1
 184:	00000097          	auipc	ra,0x0
 188:	418080e7          	jalr	1048(ra) # 59c <exit>
    printf("test1 FAIL\n");
 18c:	00001517          	auipc	a0,0x1
 190:	a1c50513          	addi	a0,a0,-1508 # ba8 <statistics+0xf2>
 194:	00000097          	auipc	ra,0x0
 198:	780080e7          	jalr	1920(ra) # 914 <printf>
}
 19c:	bf95                	j	110 <test1+0x8c>

000000000000019e <countfree>:
//
// countfree() from usertests.c
//
int
countfree()
{
 19e:	7179                	addi	sp,sp,-48
 1a0:	f406                	sd	ra,40(sp)
 1a2:	f022                	sd	s0,32(sp)
 1a4:	ec26                	sd	s1,24(sp)
 1a6:	e84a                	sd	s2,16(sp)
 1a8:	e44e                	sd	s3,8(sp)
 1aa:	e052                	sd	s4,0(sp)
 1ac:	1800                	addi	s0,sp,48
  uint64 sz0 = (uint64)sbrk(0);
 1ae:	4501                	li	a0,0
 1b0:	00000097          	auipc	ra,0x0
 1b4:	474080e7          	jalr	1140(ra) # 624 <sbrk>
 1b8:	8a2a                	mv	s4,a0
  int n = 0;
 1ba:	4481                	li	s1,0

  while(1){
    uint64 a = (uint64) sbrk(4096);
    if(a == 0xffffffffffffffff){
 1bc:	597d                	li	s2,-1
      break;
    }
    // modify the memory to make sure it's really allocated.
    *(char *)(a + 4096 - 1) = 1;
 1be:	4985                	li	s3,1
    uint64 a = (uint64) sbrk(4096);
 1c0:	6505                	lui	a0,0x1
 1c2:	00000097          	auipc	ra,0x0
 1c6:	462080e7          	jalr	1122(ra) # 624 <sbrk>
    if(a == 0xffffffffffffffff){
 1ca:	01250863          	beq	a0,s2,1da <countfree+0x3c>
    *(char *)(a + 4096 - 1) = 1;
 1ce:	6785                	lui	a5,0x1
 1d0:	953e                	add	a0,a0,a5
 1d2:	ff350fa3          	sb	s3,-1(a0) # fff <buf+0x347>
    n += 1;
 1d6:	2485                	addiw	s1,s1,1
  while(1){
 1d8:	b7e5                	j	1c0 <countfree+0x22>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1da:	4501                	li	a0,0
 1dc:	00000097          	auipc	ra,0x0
 1e0:	448080e7          	jalr	1096(ra) # 624 <sbrk>
 1e4:	40aa053b          	subw	a0,s4,a0
 1e8:	00000097          	auipc	ra,0x0
 1ec:	43c080e7          	jalr	1084(ra) # 624 <sbrk>
  return n;
}
 1f0:	8526                	mv	a0,s1
 1f2:	70a2                	ld	ra,40(sp)
 1f4:	7402                	ld	s0,32(sp)
 1f6:	64e2                	ld	s1,24(sp)
 1f8:	6942                	ld	s2,16(sp)
 1fa:	69a2                	ld	s3,8(sp)
 1fc:	6a02                	ld	s4,0(sp)
 1fe:	6145                	addi	sp,sp,48
 200:	8082                	ret

0000000000000202 <test2>:

void test2() {
 202:	715d                	addi	sp,sp,-80
 204:	e486                	sd	ra,72(sp)
 206:	e0a2                	sd	s0,64(sp)
 208:	fc26                	sd	s1,56(sp)
 20a:	f84a                	sd	s2,48(sp)
 20c:	f44e                	sd	s3,40(sp)
 20e:	f052                	sd	s4,32(sp)
 210:	ec56                	sd	s5,24(sp)
 212:	e85a                	sd	s6,16(sp)
 214:	e45e                	sd	s7,8(sp)
 216:	e062                	sd	s8,0(sp)
 218:	0880                	addi	s0,sp,80
  int free0 = countfree();
 21a:	00000097          	auipc	ra,0x0
 21e:	f84080e7          	jalr	-124(ra) # 19e <countfree>
 222:	8a2a                	mv	s4,a0
  int free1;
  int n = (PHYSTOP-KERNBASE)/PGSIZE;
  printf("start test2\n");  
 224:	00001517          	auipc	a0,0x1
 228:	99450513          	addi	a0,a0,-1644 # bb8 <statistics+0x102>
 22c:	00000097          	auipc	ra,0x0
 230:	6e8080e7          	jalr	1768(ra) # 914 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 234:	6621                	lui	a2,0x8
 236:	85d2                	mv	a1,s4
 238:	00001517          	auipc	a0,0x1
 23c:	99050513          	addi	a0,a0,-1648 # bc8 <statistics+0x112>
 240:	00000097          	auipc	ra,0x0
 244:	6d4080e7          	jalr	1748(ra) # 914 <printf>
  if(n - free0 > 1000) {
 248:	67a1                	lui	a5,0x8
 24a:	414787bb          	subw	a5,a5,s4
 24e:	3e800713          	li	a4,1000
 252:	02f74163          	blt	a4,a5,274 <test2+0x72>
    printf("test2 FAILED: cannot allocate enough memory");
    exit(-1);
  }
  for (int i = 0; i < 50; i++) {
    free1 = countfree();
 256:	00000097          	auipc	ra,0x0
 25a:	f48080e7          	jalr	-184(ra) # 19e <countfree>
 25e:	892a                	mv	s2,a0
  for (int i = 0; i < 50; i++) {
 260:	4981                	li	s3,0
 262:	03200a93          	li	s5,50
    if(i % 10 == 9)
 266:	4ba9                	li	s7,10
 268:	4b25                	li	s6,9
      printf(".");
 26a:	00001c17          	auipc	s8,0x1
 26e:	9bec0c13          	addi	s8,s8,-1602 # c28 <statistics+0x172>
 272:	a01d                	j	298 <test2+0x96>
    printf("test2 FAILED: cannot allocate enough memory");
 274:	00001517          	auipc	a0,0x1
 278:	98450513          	addi	a0,a0,-1660 # bf8 <statistics+0x142>
 27c:	00000097          	auipc	ra,0x0
 280:	698080e7          	jalr	1688(ra) # 914 <printf>
    exit(-1);
 284:	557d                	li	a0,-1
 286:	00000097          	auipc	ra,0x0
 28a:	316080e7          	jalr	790(ra) # 59c <exit>
      printf(".");
 28e:	8562                	mv	a0,s8
 290:	00000097          	auipc	ra,0x0
 294:	684080e7          	jalr	1668(ra) # 914 <printf>
    if(free1 != free0) {
 298:	032a1263          	bne	s4,s2,2bc <test2+0xba>
  for (int i = 0; i < 50; i++) {
 29c:	0019849b          	addiw	s1,s3,1
 2a0:	0004899b          	sext.w	s3,s1
 2a4:	03598c63          	beq	s3,s5,2dc <test2+0xda>
    free1 = countfree();
 2a8:	00000097          	auipc	ra,0x0
 2ac:	ef6080e7          	jalr	-266(ra) # 19e <countfree>
 2b0:	892a                	mv	s2,a0
    if(i % 10 == 9)
 2b2:	0374e4bb          	remw	s1,s1,s7
 2b6:	ff6491e3          	bne	s1,s6,298 <test2+0x96>
 2ba:	bfd1                	j	28e <test2+0x8c>
      printf("test2 FAIL:  %d  losing pages %d    %d\n", i,free0,free1);
 2bc:	86ca                	mv	a3,s2
 2be:	8652                	mv	a2,s4
 2c0:	85ce                	mv	a1,s3
 2c2:	00001517          	auipc	a0,0x1
 2c6:	96e50513          	addi	a0,a0,-1682 # c30 <statistics+0x17a>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	64a080e7          	jalr	1610(ra) # 914 <printf>
      exit(-1);
 2d2:	557d                	li	a0,-1
 2d4:	00000097          	auipc	ra,0x0
 2d8:	2c8080e7          	jalr	712(ra) # 59c <exit>
    }
  }
  printf("\ntest2 OK\n");  
 2dc:	00001517          	auipc	a0,0x1
 2e0:	97c50513          	addi	a0,a0,-1668 # c58 <statistics+0x1a2>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	630080e7          	jalr	1584(ra) # 914 <printf>
}
 2ec:	60a6                	ld	ra,72(sp)
 2ee:	6406                	ld	s0,64(sp)
 2f0:	74e2                	ld	s1,56(sp)
 2f2:	7942                	ld	s2,48(sp)
 2f4:	79a2                	ld	s3,40(sp)
 2f6:	7a02                	ld	s4,32(sp)
 2f8:	6ae2                	ld	s5,24(sp)
 2fa:	6b42                	ld	s6,16(sp)
 2fc:	6ba2                	ld	s7,8(sp)
 2fe:	6c02                	ld	s8,0(sp)
 300:	6161                	addi	sp,sp,80
 302:	8082                	ret

0000000000000304 <main>:
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  test1();
 30c:	00000097          	auipc	ra,0x0
 310:	d78080e7          	jalr	-648(ra) # 84 <test1>
  test2();
 314:	00000097          	auipc	ra,0x0
 318:	eee080e7          	jalr	-274(ra) # 202 <test2>
  exit(0);
 31c:	4501                	li	a0,0
 31e:	00000097          	auipc	ra,0x0
 322:	27e080e7          	jalr	638(ra) # 59c <exit>

0000000000000326 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 326:	1141                	addi	sp,sp,-16
 328:	e422                	sd	s0,8(sp)
 32a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 32c:	87aa                	mv	a5,a0
 32e:	0585                	addi	a1,a1,1
 330:	0785                	addi	a5,a5,1
 332:	fff5c703          	lbu	a4,-1(a1)
 336:	fee78fa3          	sb	a4,-1(a5) # 7fff <__BSS_END__+0x6337>
 33a:	fb75                	bnez	a4,32e <strcpy+0x8>
    ;
  return os;
}
 33c:	6422                	ld	s0,8(sp)
 33e:	0141                	addi	sp,sp,16
 340:	8082                	ret

0000000000000342 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 342:	1141                	addi	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cb91                	beqz	a5,360 <strcmp+0x1e>
 34e:	0005c703          	lbu	a4,0(a1)
 352:	00f71763          	bne	a4,a5,360 <strcmp+0x1e>
    p++, q++;
 356:	0505                	addi	a0,a0,1
 358:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 35a:	00054783          	lbu	a5,0(a0)
 35e:	fbe5                	bnez	a5,34e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 360:	0005c503          	lbu	a0,0(a1)
}
 364:	40a7853b          	subw	a0,a5,a0
 368:	6422                	ld	s0,8(sp)
 36a:	0141                	addi	sp,sp,16
 36c:	8082                	ret

000000000000036e <strlen>:

uint
strlen(const char *s)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e422                	sd	s0,8(sp)
 372:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 374:	00054783          	lbu	a5,0(a0)
 378:	cf91                	beqz	a5,394 <strlen+0x26>
 37a:	0505                	addi	a0,a0,1
 37c:	87aa                	mv	a5,a0
 37e:	4685                	li	a3,1
 380:	9e89                	subw	a3,a3,a0
 382:	00f6853b          	addw	a0,a3,a5
 386:	0785                	addi	a5,a5,1
 388:	fff7c703          	lbu	a4,-1(a5)
 38c:	fb7d                	bnez	a4,382 <strlen+0x14>
    ;
  return n;
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  for(n = 0; s[n]; n++)
 394:	4501                	li	a0,0
 396:	bfe5                	j	38e <strlen+0x20>

0000000000000398 <memset>:

void*
memset(void *dst, int c, uint n)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 39e:	ce09                	beqz	a2,3b8 <memset+0x20>
 3a0:	87aa                	mv	a5,a0
 3a2:	fff6071b          	addiw	a4,a2,-1
 3a6:	1702                	slli	a4,a4,0x20
 3a8:	9301                	srli	a4,a4,0x20
 3aa:	0705                	addi	a4,a4,1
 3ac:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3b2:	0785                	addi	a5,a5,1
 3b4:	fee79de3          	bne	a5,a4,3ae <memset+0x16>
  }
  return dst;
}
 3b8:	6422                	ld	s0,8(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <strchr>:

char*
strchr(const char *s, char c)
{
 3be:	1141                	addi	sp,sp,-16
 3c0:	e422                	sd	s0,8(sp)
 3c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3c4:	00054783          	lbu	a5,0(a0)
 3c8:	cb99                	beqz	a5,3de <strchr+0x20>
    if(*s == c)
 3ca:	00f58763          	beq	a1,a5,3d8 <strchr+0x1a>
  for(; *s; s++)
 3ce:	0505                	addi	a0,a0,1
 3d0:	00054783          	lbu	a5,0(a0)
 3d4:	fbfd                	bnez	a5,3ca <strchr+0xc>
      return (char*)s;
  return 0;
 3d6:	4501                	li	a0,0
}
 3d8:	6422                	ld	s0,8(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret
  return 0;
 3de:	4501                	li	a0,0
 3e0:	bfe5                	j	3d8 <strchr+0x1a>

00000000000003e2 <gets>:

char*
gets(char *buf, int max)
{
 3e2:	711d                	addi	sp,sp,-96
 3e4:	ec86                	sd	ra,88(sp)
 3e6:	e8a2                	sd	s0,80(sp)
 3e8:	e4a6                	sd	s1,72(sp)
 3ea:	e0ca                	sd	s2,64(sp)
 3ec:	fc4e                	sd	s3,56(sp)
 3ee:	f852                	sd	s4,48(sp)
 3f0:	f456                	sd	s5,40(sp)
 3f2:	f05a                	sd	s6,32(sp)
 3f4:	ec5e                	sd	s7,24(sp)
 3f6:	1080                	addi	s0,sp,96
 3f8:	8baa                	mv	s7,a0
 3fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3fc:	892a                	mv	s2,a0
 3fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 400:	4aa9                	li	s5,10
 402:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 404:	89a6                	mv	s3,s1
 406:	2485                	addiw	s1,s1,1
 408:	0344d863          	bge	s1,s4,438 <gets+0x56>
    cc = read(0, &c, 1);
 40c:	4605                	li	a2,1
 40e:	faf40593          	addi	a1,s0,-81
 412:	4501                	li	a0,0
 414:	00000097          	auipc	ra,0x0
 418:	1a0080e7          	jalr	416(ra) # 5b4 <read>
    if(cc < 1)
 41c:	00a05e63          	blez	a0,438 <gets+0x56>
    buf[i++] = c;
 420:	faf44783          	lbu	a5,-81(s0)
 424:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 428:	01578763          	beq	a5,s5,436 <gets+0x54>
 42c:	0905                	addi	s2,s2,1
 42e:	fd679be3          	bne	a5,s6,404 <gets+0x22>
  for(i=0; i+1 < max; ){
 432:	89a6                	mv	s3,s1
 434:	a011                	j	438 <gets+0x56>
 436:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 438:	99de                	add	s3,s3,s7
 43a:	00098023          	sb	zero,0(s3)
  return buf;
}
 43e:	855e                	mv	a0,s7
 440:	60e6                	ld	ra,88(sp)
 442:	6446                	ld	s0,80(sp)
 444:	64a6                	ld	s1,72(sp)
 446:	6906                	ld	s2,64(sp)
 448:	79e2                	ld	s3,56(sp)
 44a:	7a42                	ld	s4,48(sp)
 44c:	7aa2                	ld	s5,40(sp)
 44e:	7b02                	ld	s6,32(sp)
 450:	6be2                	ld	s7,24(sp)
 452:	6125                	addi	sp,sp,96
 454:	8082                	ret

0000000000000456 <stat>:

int
stat(const char *n, struct stat *st)
{
 456:	1101                	addi	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	e426                	sd	s1,8(sp)
 45e:	e04a                	sd	s2,0(sp)
 460:	1000                	addi	s0,sp,32
 462:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 464:	4581                	li	a1,0
 466:	00000097          	auipc	ra,0x0
 46a:	176080e7          	jalr	374(ra) # 5dc <open>
  if(fd < 0)
 46e:	02054563          	bltz	a0,498 <stat+0x42>
 472:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 474:	85ca                	mv	a1,s2
 476:	00000097          	auipc	ra,0x0
 47a:	17e080e7          	jalr	382(ra) # 5f4 <fstat>
 47e:	892a                	mv	s2,a0
  close(fd);
 480:	8526                	mv	a0,s1
 482:	00000097          	auipc	ra,0x0
 486:	142080e7          	jalr	322(ra) # 5c4 <close>
  return r;
}
 48a:	854a                	mv	a0,s2
 48c:	60e2                	ld	ra,24(sp)
 48e:	6442                	ld	s0,16(sp)
 490:	64a2                	ld	s1,8(sp)
 492:	6902                	ld	s2,0(sp)
 494:	6105                	addi	sp,sp,32
 496:	8082                	ret
    return -1;
 498:	597d                	li	s2,-1
 49a:	bfc5                	j	48a <stat+0x34>

000000000000049c <atoi>:

int
atoi(const char *s)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e422                	sd	s0,8(sp)
 4a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a2:	00054603          	lbu	a2,0(a0)
 4a6:	fd06079b          	addiw	a5,a2,-48
 4aa:	0ff7f793          	andi	a5,a5,255
 4ae:	4725                	li	a4,9
 4b0:	02f76963          	bltu	a4,a5,4e2 <atoi+0x46>
 4b4:	86aa                	mv	a3,a0
  n = 0;
 4b6:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4b8:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ba:	0685                	addi	a3,a3,1
 4bc:	0025179b          	slliw	a5,a0,0x2
 4c0:	9fa9                	addw	a5,a5,a0
 4c2:	0017979b          	slliw	a5,a5,0x1
 4c6:	9fb1                	addw	a5,a5,a2
 4c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4cc:	0006c603          	lbu	a2,0(a3)
 4d0:	fd06071b          	addiw	a4,a2,-48
 4d4:	0ff77713          	andi	a4,a4,255
 4d8:	fee5f1e3          	bgeu	a1,a4,4ba <atoi+0x1e>
  return n;
}
 4dc:	6422                	ld	s0,8(sp)
 4de:	0141                	addi	sp,sp,16
 4e0:	8082                	ret
  n = 0;
 4e2:	4501                	li	a0,0
 4e4:	bfe5                	j	4dc <atoi+0x40>

00000000000004e6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4e6:	1141                	addi	sp,sp,-16
 4e8:	e422                	sd	s0,8(sp)
 4ea:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ec:	02b57663          	bgeu	a0,a1,518 <memmove+0x32>
    while(n-- > 0)
 4f0:	02c05163          	blez	a2,512 <memmove+0x2c>
 4f4:	fff6079b          	addiw	a5,a2,-1
 4f8:	1782                	slli	a5,a5,0x20
 4fa:	9381                	srli	a5,a5,0x20
 4fc:	0785                	addi	a5,a5,1
 4fe:	97aa                	add	a5,a5,a0
  dst = vdst;
 500:	872a                	mv	a4,a0
      *dst++ = *src++;
 502:	0585                	addi	a1,a1,1
 504:	0705                	addi	a4,a4,1
 506:	fff5c683          	lbu	a3,-1(a1)
 50a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 50e:	fee79ae3          	bne	a5,a4,502 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 512:	6422                	ld	s0,8(sp)
 514:	0141                	addi	sp,sp,16
 516:	8082                	ret
    dst += n;
 518:	00c50733          	add	a4,a0,a2
    src += n;
 51c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 51e:	fec05ae3          	blez	a2,512 <memmove+0x2c>
 522:	fff6079b          	addiw	a5,a2,-1
 526:	1782                	slli	a5,a5,0x20
 528:	9381                	srli	a5,a5,0x20
 52a:	fff7c793          	not	a5,a5
 52e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 530:	15fd                	addi	a1,a1,-1
 532:	177d                	addi	a4,a4,-1
 534:	0005c683          	lbu	a3,0(a1)
 538:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 53c:	fee79ae3          	bne	a5,a4,530 <memmove+0x4a>
 540:	bfc9                	j	512 <memmove+0x2c>

0000000000000542 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 542:	1141                	addi	sp,sp,-16
 544:	e422                	sd	s0,8(sp)
 546:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 548:	ca05                	beqz	a2,578 <memcmp+0x36>
 54a:	fff6069b          	addiw	a3,a2,-1
 54e:	1682                	slli	a3,a3,0x20
 550:	9281                	srli	a3,a3,0x20
 552:	0685                	addi	a3,a3,1
 554:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 556:	00054783          	lbu	a5,0(a0)
 55a:	0005c703          	lbu	a4,0(a1)
 55e:	00e79863          	bne	a5,a4,56e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 562:	0505                	addi	a0,a0,1
    p2++;
 564:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 566:	fed518e3          	bne	a0,a3,556 <memcmp+0x14>
  }
  return 0;
 56a:	4501                	li	a0,0
 56c:	a019                	j	572 <memcmp+0x30>
      return *p1 - *p2;
 56e:	40e7853b          	subw	a0,a5,a4
}
 572:	6422                	ld	s0,8(sp)
 574:	0141                	addi	sp,sp,16
 576:	8082                	ret
  return 0;
 578:	4501                	li	a0,0
 57a:	bfe5                	j	572 <memcmp+0x30>

000000000000057c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 57c:	1141                	addi	sp,sp,-16
 57e:	e406                	sd	ra,8(sp)
 580:	e022                	sd	s0,0(sp)
 582:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 584:	00000097          	auipc	ra,0x0
 588:	f62080e7          	jalr	-158(ra) # 4e6 <memmove>
}
 58c:	60a2                	ld	ra,8(sp)
 58e:	6402                	ld	s0,0(sp)
 590:	0141                	addi	sp,sp,16
 592:	8082                	ret

0000000000000594 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 594:	4885                	li	a7,1
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <exit>:
.global exit
exit:
 li a7, SYS_exit
 59c:	4889                	li	a7,2
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5a4:	488d                	li	a7,3
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5ac:	4891                	li	a7,4
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <read>:
.global read
read:
 li a7, SYS_read
 5b4:	4895                	li	a7,5
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <write>:
.global write
write:
 li a7, SYS_write
 5bc:	48c1                	li	a7,16
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <close>:
.global close
close:
 li a7, SYS_close
 5c4:	48d5                	li	a7,21
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5cc:	4899                	li	a7,6
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5d4:	489d                	li	a7,7
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <open>:
.global open
open:
 li a7, SYS_open
 5dc:	48bd                	li	a7,15
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5e4:	48c5                	li	a7,17
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ec:	48c9                	li	a7,18
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5f4:	48a1                	li	a7,8
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <link>:
.global link
link:
 li a7, SYS_link
 5fc:	48cd                	li	a7,19
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 604:	48d1                	li	a7,20
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 60c:	48a5                	li	a7,9
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <dup>:
.global dup
dup:
 li a7, SYS_dup
 614:	48a9                	li	a7,10
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 61c:	48ad                	li	a7,11
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 624:	48b1                	li	a7,12
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 62c:	48b5                	li	a7,13
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 634:	48b9                	li	a7,14
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63c:	1101                	addi	sp,sp,-32
 63e:	ec06                	sd	ra,24(sp)
 640:	e822                	sd	s0,16(sp)
 642:	1000                	addi	s0,sp,32
 644:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 648:	4605                	li	a2,1
 64a:	fef40593          	addi	a1,s0,-17
 64e:	00000097          	auipc	ra,0x0
 652:	f6e080e7          	jalr	-146(ra) # 5bc <write>
}
 656:	60e2                	ld	ra,24(sp)
 658:	6442                	ld	s0,16(sp)
 65a:	6105                	addi	sp,sp,32
 65c:	8082                	ret

000000000000065e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65e:	7139                	addi	sp,sp,-64
 660:	fc06                	sd	ra,56(sp)
 662:	f822                	sd	s0,48(sp)
 664:	f426                	sd	s1,40(sp)
 666:	f04a                	sd	s2,32(sp)
 668:	ec4e                	sd	s3,24(sp)
 66a:	0080                	addi	s0,sp,64
 66c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 66e:	c299                	beqz	a3,674 <printint+0x16>
 670:	0805c863          	bltz	a1,700 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 674:	2581                	sext.w	a1,a1
  neg = 0;
 676:	4881                	li	a7,0
 678:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 67c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 67e:	2601                	sext.w	a2,a2
 680:	00000517          	auipc	a0,0x0
 684:	5f050513          	addi	a0,a0,1520 # c70 <digits>
 688:	883a                	mv	a6,a4
 68a:	2705                	addiw	a4,a4,1
 68c:	02c5f7bb          	remuw	a5,a1,a2
 690:	1782                	slli	a5,a5,0x20
 692:	9381                	srli	a5,a5,0x20
 694:	97aa                	add	a5,a5,a0
 696:	0007c783          	lbu	a5,0(a5)
 69a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 69e:	0005879b          	sext.w	a5,a1
 6a2:	02c5d5bb          	divuw	a1,a1,a2
 6a6:	0685                	addi	a3,a3,1
 6a8:	fec7f0e3          	bgeu	a5,a2,688 <printint+0x2a>
  if(neg)
 6ac:	00088b63          	beqz	a7,6c2 <printint+0x64>
    buf[i++] = '-';
 6b0:	fd040793          	addi	a5,s0,-48
 6b4:	973e                	add	a4,a4,a5
 6b6:	02d00793          	li	a5,45
 6ba:	fef70823          	sb	a5,-16(a4)
 6be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6c2:	02e05863          	blez	a4,6f2 <printint+0x94>
 6c6:	fc040793          	addi	a5,s0,-64
 6ca:	00e78933          	add	s2,a5,a4
 6ce:	fff78993          	addi	s3,a5,-1
 6d2:	99ba                	add	s3,s3,a4
 6d4:	377d                	addiw	a4,a4,-1
 6d6:	1702                	slli	a4,a4,0x20
 6d8:	9301                	srli	a4,a4,0x20
 6da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6de:	fff94583          	lbu	a1,-1(s2)
 6e2:	8526                	mv	a0,s1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	f58080e7          	jalr	-168(ra) # 63c <putc>
  while(--i >= 0)
 6ec:	197d                	addi	s2,s2,-1
 6ee:	ff3918e3          	bne	s2,s3,6de <printint+0x80>
}
 6f2:	70e2                	ld	ra,56(sp)
 6f4:	7442                	ld	s0,48(sp)
 6f6:	74a2                	ld	s1,40(sp)
 6f8:	7902                	ld	s2,32(sp)
 6fa:	69e2                	ld	s3,24(sp)
 6fc:	6121                	addi	sp,sp,64
 6fe:	8082                	ret
    x = -xx;
 700:	40b005bb          	negw	a1,a1
    neg = 1;
 704:	4885                	li	a7,1
    x = -xx;
 706:	bf8d                	j	678 <printint+0x1a>

0000000000000708 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 708:	7119                	addi	sp,sp,-128
 70a:	fc86                	sd	ra,120(sp)
 70c:	f8a2                	sd	s0,112(sp)
 70e:	f4a6                	sd	s1,104(sp)
 710:	f0ca                	sd	s2,96(sp)
 712:	ecce                	sd	s3,88(sp)
 714:	e8d2                	sd	s4,80(sp)
 716:	e4d6                	sd	s5,72(sp)
 718:	e0da                	sd	s6,64(sp)
 71a:	fc5e                	sd	s7,56(sp)
 71c:	f862                	sd	s8,48(sp)
 71e:	f466                	sd	s9,40(sp)
 720:	f06a                	sd	s10,32(sp)
 722:	ec6e                	sd	s11,24(sp)
 724:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 726:	0005c903          	lbu	s2,0(a1)
 72a:	18090f63          	beqz	s2,8c8 <vprintf+0x1c0>
 72e:	8aaa                	mv	s5,a0
 730:	8b32                	mv	s6,a2
 732:	00158493          	addi	s1,a1,1
  state = 0;
 736:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 738:	02500a13          	li	s4,37
      if(c == 'd'){
 73c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 740:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 744:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 748:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74c:	00000b97          	auipc	s7,0x0
 750:	524b8b93          	addi	s7,s7,1316 # c70 <digits>
 754:	a839                	j	772 <vprintf+0x6a>
        putc(fd, c);
 756:	85ca                	mv	a1,s2
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	ee2080e7          	jalr	-286(ra) # 63c <putc>
 762:	a019                	j	768 <vprintf+0x60>
    } else if(state == '%'){
 764:	01498f63          	beq	s3,s4,782 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 768:	0485                	addi	s1,s1,1
 76a:	fff4c903          	lbu	s2,-1(s1)
 76e:	14090d63          	beqz	s2,8c8 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 772:	0009079b          	sext.w	a5,s2
    if(state == 0){
 776:	fe0997e3          	bnez	s3,764 <vprintf+0x5c>
      if(c == '%'){
 77a:	fd479ee3          	bne	a5,s4,756 <vprintf+0x4e>
        state = '%';
 77e:	89be                	mv	s3,a5
 780:	b7e5                	j	768 <vprintf+0x60>
      if(c == 'd'){
 782:	05878063          	beq	a5,s8,7c2 <vprintf+0xba>
      } else if(c == 'l') {
 786:	05978c63          	beq	a5,s9,7de <vprintf+0xd6>
      } else if(c == 'x') {
 78a:	07a78863          	beq	a5,s10,7fa <vprintf+0xf2>
      } else if(c == 'p') {
 78e:	09b78463          	beq	a5,s11,816 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 792:	07300713          	li	a4,115
 796:	0ce78663          	beq	a5,a4,862 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79a:	06300713          	li	a4,99
 79e:	0ee78e63          	beq	a5,a4,89a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7a2:	11478863          	beq	a5,s4,8b2 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a6:	85d2                	mv	a1,s4
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e92080e7          	jalr	-366(ra) # 63c <putc>
        putc(fd, c);
 7b2:	85ca                	mv	a1,s2
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e86080e7          	jalr	-378(ra) # 63c <putc>
      }
      state = 0;
 7be:	4981                	li	s3,0
 7c0:	b765                	j	768 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7c2:	008b0913          	addi	s2,s6,8
 7c6:	4685                	li	a3,1
 7c8:	4629                	li	a2,10
 7ca:	000b2583          	lw	a1,0(s6)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e8e080e7          	jalr	-370(ra) # 65e <printint>
 7d8:	8b4a                	mv	s6,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b771                	j	768 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	008b0913          	addi	s2,s6,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000b2583          	lw	a1,0(s6)
 7ea:	8556                	mv	a0,s5
 7ec:	00000097          	auipc	ra,0x0
 7f0:	e72080e7          	jalr	-398(ra) # 65e <printint>
 7f4:	8b4a                	mv	s6,s2
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	bf85                	j	768 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 7fa:	008b0913          	addi	s2,s6,8
 7fe:	4681                	li	a3,0
 800:	4641                	li	a2,16
 802:	000b2583          	lw	a1,0(s6)
 806:	8556                	mv	a0,s5
 808:	00000097          	auipc	ra,0x0
 80c:	e56080e7          	jalr	-426(ra) # 65e <printint>
 810:	8b4a                	mv	s6,s2
      state = 0;
 812:	4981                	li	s3,0
 814:	bf91                	j	768 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 816:	008b0793          	addi	a5,s6,8
 81a:	f8f43423          	sd	a5,-120(s0)
 81e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 822:	03000593          	li	a1,48
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	e14080e7          	jalr	-492(ra) # 63c <putc>
  putc(fd, 'x');
 830:	85ea                	mv	a1,s10
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e08080e7          	jalr	-504(ra) # 63c <putc>
 83c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 83e:	03c9d793          	srli	a5,s3,0x3c
 842:	97de                	add	a5,a5,s7
 844:	0007c583          	lbu	a1,0(a5)
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	df2080e7          	jalr	-526(ra) # 63c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 852:	0992                	slli	s3,s3,0x4
 854:	397d                	addiw	s2,s2,-1
 856:	fe0914e3          	bnez	s2,83e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 85a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 85e:	4981                	li	s3,0
 860:	b721                	j	768 <vprintf+0x60>
        s = va_arg(ap, char*);
 862:	008b0993          	addi	s3,s6,8
 866:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 86a:	02090163          	beqz	s2,88c <vprintf+0x184>
        while(*s != 0){
 86e:	00094583          	lbu	a1,0(s2)
 872:	c9a1                	beqz	a1,8c2 <vprintf+0x1ba>
          putc(fd, *s);
 874:	8556                	mv	a0,s5
 876:	00000097          	auipc	ra,0x0
 87a:	dc6080e7          	jalr	-570(ra) # 63c <putc>
          s++;
 87e:	0905                	addi	s2,s2,1
        while(*s != 0){
 880:	00094583          	lbu	a1,0(s2)
 884:	f9e5                	bnez	a1,874 <vprintf+0x16c>
        s = va_arg(ap, char*);
 886:	8b4e                	mv	s6,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	bdf9                	j	768 <vprintf+0x60>
          s = "(null)";
 88c:	00000917          	auipc	s2,0x0
 890:	3dc90913          	addi	s2,s2,988 # c68 <statistics+0x1b2>
        while(*s != 0){
 894:	02800593          	li	a1,40
 898:	bff1                	j	874 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 89a:	008b0913          	addi	s2,s6,8
 89e:	000b4583          	lbu	a1,0(s6)
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	d98080e7          	jalr	-616(ra) # 63c <putc>
 8ac:	8b4a                	mv	s6,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	bd65                	j	768 <vprintf+0x60>
        putc(fd, c);
 8b2:	85d2                	mv	a1,s4
 8b4:	8556                	mv	a0,s5
 8b6:	00000097          	auipc	ra,0x0
 8ba:	d86080e7          	jalr	-634(ra) # 63c <putc>
      state = 0;
 8be:	4981                	li	s3,0
 8c0:	b565                	j	768 <vprintf+0x60>
        s = va_arg(ap, char*);
 8c2:	8b4e                	mv	s6,s3
      state = 0;
 8c4:	4981                	li	s3,0
 8c6:	b54d                	j	768 <vprintf+0x60>
    }
  }
}
 8c8:	70e6                	ld	ra,120(sp)
 8ca:	7446                	ld	s0,112(sp)
 8cc:	74a6                	ld	s1,104(sp)
 8ce:	7906                	ld	s2,96(sp)
 8d0:	69e6                	ld	s3,88(sp)
 8d2:	6a46                	ld	s4,80(sp)
 8d4:	6aa6                	ld	s5,72(sp)
 8d6:	6b06                	ld	s6,64(sp)
 8d8:	7be2                	ld	s7,56(sp)
 8da:	7c42                	ld	s8,48(sp)
 8dc:	7ca2                	ld	s9,40(sp)
 8de:	7d02                	ld	s10,32(sp)
 8e0:	6de2                	ld	s11,24(sp)
 8e2:	6109                	addi	sp,sp,128
 8e4:	8082                	ret

00000000000008e6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8e6:	715d                	addi	sp,sp,-80
 8e8:	ec06                	sd	ra,24(sp)
 8ea:	e822                	sd	s0,16(sp)
 8ec:	1000                	addi	s0,sp,32
 8ee:	e010                	sd	a2,0(s0)
 8f0:	e414                	sd	a3,8(s0)
 8f2:	e818                	sd	a4,16(s0)
 8f4:	ec1c                	sd	a5,24(s0)
 8f6:	03043023          	sd	a6,32(s0)
 8fa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8fe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 902:	8622                	mv	a2,s0
 904:	00000097          	auipc	ra,0x0
 908:	e04080e7          	jalr	-508(ra) # 708 <vprintf>
}
 90c:	60e2                	ld	ra,24(sp)
 90e:	6442                	ld	s0,16(sp)
 910:	6161                	addi	sp,sp,80
 912:	8082                	ret

0000000000000914 <printf>:

void
printf(const char *fmt, ...)
{
 914:	711d                	addi	sp,sp,-96
 916:	ec06                	sd	ra,24(sp)
 918:	e822                	sd	s0,16(sp)
 91a:	1000                	addi	s0,sp,32
 91c:	e40c                	sd	a1,8(s0)
 91e:	e810                	sd	a2,16(s0)
 920:	ec14                	sd	a3,24(s0)
 922:	f018                	sd	a4,32(s0)
 924:	f41c                	sd	a5,40(s0)
 926:	03043823          	sd	a6,48(s0)
 92a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 92e:	00840613          	addi	a2,s0,8
 932:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 936:	85aa                	mv	a1,a0
 938:	4505                	li	a0,1
 93a:	00000097          	auipc	ra,0x0
 93e:	dce080e7          	jalr	-562(ra) # 708 <vprintf>
}
 942:	60e2                	ld	ra,24(sp)
 944:	6442                	ld	s0,16(sp)
 946:	6125                	addi	sp,sp,96
 948:	8082                	ret

000000000000094a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 94a:	1141                	addi	sp,sp,-16
 94c:	e422                	sd	s0,8(sp)
 94e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 950:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 954:	00000797          	auipc	a5,0x0
 958:	35c7b783          	ld	a5,860(a5) # cb0 <freep>
 95c:	a805                	j	98c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 95e:	4618                	lw	a4,8(a2)
 960:	9db9                	addw	a1,a1,a4
 962:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	6318                	ld	a4,0(a4)
 96a:	fee53823          	sd	a4,-16(a0)
 96e:	a091                	j	9b2 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 970:	ff852703          	lw	a4,-8(a0)
 974:	9e39                	addw	a2,a2,a4
 976:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 978:	ff053703          	ld	a4,-16(a0)
 97c:	e398                	sd	a4,0(a5)
 97e:	a099                	j	9c4 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	6398                	ld	a4,0(a5)
 982:	00e7e463          	bltu	a5,a4,98a <free+0x40>
 986:	00e6ea63          	bltu	a3,a4,99a <free+0x50>
{
 98a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	fed7fae3          	bgeu	a5,a3,980 <free+0x36>
 990:	6398                	ld	a4,0(a5)
 992:	00e6e463          	bltu	a3,a4,99a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	fee7eae3          	bltu	a5,a4,98a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 99a:	ff852583          	lw	a1,-8(a0)
 99e:	6390                	ld	a2,0(a5)
 9a0:	02059713          	slli	a4,a1,0x20
 9a4:	9301                	srli	a4,a4,0x20
 9a6:	0712                	slli	a4,a4,0x4
 9a8:	9736                	add	a4,a4,a3
 9aa:	fae60ae3          	beq	a2,a4,95e <free+0x14>
    bp->s.ptr = p->s.ptr;
 9ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b2:	4790                	lw	a2,8(a5)
 9b4:	02061713          	slli	a4,a2,0x20
 9b8:	9301                	srli	a4,a4,0x20
 9ba:	0712                	slli	a4,a4,0x4
 9bc:	973e                	add	a4,a4,a5
 9be:	fae689e3          	beq	a3,a4,970 <free+0x26>
  } else
    p->s.ptr = bp;
 9c2:	e394                	sd	a3,0(a5)
  freep = p;
 9c4:	00000717          	auipc	a4,0x0
 9c8:	2ef73623          	sd	a5,748(a4) # cb0 <freep>
}
 9cc:	6422                	ld	s0,8(sp)
 9ce:	0141                	addi	sp,sp,16
 9d0:	8082                	ret

00000000000009d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d2:	7139                	addi	sp,sp,-64
 9d4:	fc06                	sd	ra,56(sp)
 9d6:	f822                	sd	s0,48(sp)
 9d8:	f426                	sd	s1,40(sp)
 9da:	f04a                	sd	s2,32(sp)
 9dc:	ec4e                	sd	s3,24(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
 9e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e6:	02051493          	slli	s1,a0,0x20
 9ea:	9081                	srli	s1,s1,0x20
 9ec:	04bd                	addi	s1,s1,15
 9ee:	8091                	srli	s1,s1,0x4
 9f0:	0014899b          	addiw	s3,s1,1
 9f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f6:	00000517          	auipc	a0,0x0
 9fa:	2ba53503          	ld	a0,698(a0) # cb0 <freep>
 9fe:	c515                	beqz	a0,a2a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a02:	4798                	lw	a4,8(a5)
 a04:	02977f63          	bgeu	a4,s1,a42 <malloc+0x70>
 a08:	8a4e                	mv	s4,s3
 a0a:	0009871b          	sext.w	a4,s3
 a0e:	6685                	lui	a3,0x1
 a10:	00d77363          	bgeu	a4,a3,a16 <malloc+0x44>
 a14:	6a05                	lui	s4,0x1
 a16:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1e:	00000917          	auipc	s2,0x0
 a22:	29290913          	addi	s2,s2,658 # cb0 <freep>
  if(p == (char*)-1)
 a26:	5afd                	li	s5,-1
 a28:	a88d                	j	a9a <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a2a:	00001797          	auipc	a5,0x1
 a2e:	28e78793          	addi	a5,a5,654 # 1cb8 <base>
 a32:	00000717          	auipc	a4,0x0
 a36:	26f73f23          	sd	a5,638(a4) # cb0 <freep>
 a3a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a3c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a40:	b7e1                	j	a08 <malloc+0x36>
      if(p->s.size == nunits)
 a42:	02e48b63          	beq	s1,a4,a78 <malloc+0xa6>
        p->s.size -= nunits;
 a46:	4137073b          	subw	a4,a4,s3
 a4a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4c:	1702                	slli	a4,a4,0x20
 a4e:	9301                	srli	a4,a4,0x20
 a50:	0712                	slli	a4,a4,0x4
 a52:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a54:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a58:	00000717          	auipc	a4,0x0
 a5c:	24a73c23          	sd	a0,600(a4) # cb0 <freep>
      return (void*)(p + 1);
 a60:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a64:	70e2                	ld	ra,56(sp)
 a66:	7442                	ld	s0,48(sp)
 a68:	74a2                	ld	s1,40(sp)
 a6a:	7902                	ld	s2,32(sp)
 a6c:	69e2                	ld	s3,24(sp)
 a6e:	6a42                	ld	s4,16(sp)
 a70:	6aa2                	ld	s5,8(sp)
 a72:	6b02                	ld	s6,0(sp)
 a74:	6121                	addi	sp,sp,64
 a76:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a78:	6398                	ld	a4,0(a5)
 a7a:	e118                	sd	a4,0(a0)
 a7c:	bff1                	j	a58 <malloc+0x86>
  hp->s.size = nu;
 a7e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a82:	0541                	addi	a0,a0,16
 a84:	00000097          	auipc	ra,0x0
 a88:	ec6080e7          	jalr	-314(ra) # 94a <free>
  return freep;
 a8c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a90:	d971                	beqz	a0,a64 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a92:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a94:	4798                	lw	a4,8(a5)
 a96:	fa9776e3          	bgeu	a4,s1,a42 <malloc+0x70>
    if(p == freep)
 a9a:	00093703          	ld	a4,0(s2)
 a9e:	853e                	mv	a0,a5
 aa0:	fef719e3          	bne	a4,a5,a92 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 aa4:	8552                	mv	a0,s4
 aa6:	00000097          	auipc	ra,0x0
 aaa:	b7e080e7          	jalr	-1154(ra) # 624 <sbrk>
  if(p == (char*)-1)
 aae:	fd5518e3          	bne	a0,s5,a7e <malloc+0xac>
        return 0;
 ab2:	4501                	li	a0,0
 ab4:	bf45                	j	a64 <malloc+0x92>

0000000000000ab6 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 ab6:	7179                	addi	sp,sp,-48
 ab8:	f406                	sd	ra,40(sp)
 aba:	f022                	sd	s0,32(sp)
 abc:	ec26                	sd	s1,24(sp)
 abe:	e84a                	sd	s2,16(sp)
 ac0:	e44e                	sd	s3,8(sp)
 ac2:	e052                	sd	s4,0(sp)
 ac4:	1800                	addi	s0,sp,48
 ac6:	8a2a                	mv	s4,a0
 ac8:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 aca:	4581                	li	a1,0
 acc:	00000517          	auipc	a0,0x0
 ad0:	1bc50513          	addi	a0,a0,444 # c88 <digits+0x18>
 ad4:	00000097          	auipc	ra,0x0
 ad8:	b08080e7          	jalr	-1272(ra) # 5dc <open>
  if(fd < 0) {
 adc:	04054263          	bltz	a0,b20 <statistics+0x6a>
 ae0:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 ae2:	4481                	li	s1,0
 ae4:	03205063          	blez	s2,b04 <statistics+0x4e>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 ae8:	4099063b          	subw	a2,s2,s1
 aec:	009a05b3          	add	a1,s4,s1
 af0:	854e                	mv	a0,s3
 af2:	00000097          	auipc	ra,0x0
 af6:	ac2080e7          	jalr	-1342(ra) # 5b4 <read>
 afa:	00054563          	bltz	a0,b04 <statistics+0x4e>
      break;
    }
    i += n;
 afe:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 b00:	ff24c4e3          	blt	s1,s2,ae8 <statistics+0x32>
  }
  close(fd);
 b04:	854e                	mv	a0,s3
 b06:	00000097          	auipc	ra,0x0
 b0a:	abe080e7          	jalr	-1346(ra) # 5c4 <close>
  return i;
}
 b0e:	8526                	mv	a0,s1
 b10:	70a2                	ld	ra,40(sp)
 b12:	7402                	ld	s0,32(sp)
 b14:	64e2                	ld	s1,24(sp)
 b16:	6942                	ld	s2,16(sp)
 b18:	69a2                	ld	s3,8(sp)
 b1a:	6a02                	ld	s4,0(sp)
 b1c:	6145                	addi	sp,sp,48
 b1e:	8082                	ret
      fprintf(2, "stats: open failed\n");
 b20:	00000597          	auipc	a1,0x0
 b24:	17858593          	addi	a1,a1,376 # c98 <digits+0x28>
 b28:	4509                	li	a0,2
 b2a:	00000097          	auipc	ra,0x0
 b2e:	dbc080e7          	jalr	-580(ra) # 8e6 <fprintf>
      exit(1);
 b32:	4505                	li	a0,1
 b34:	00000097          	auipc	ra,0x0
 b38:	a68080e7          	jalr	-1432(ra) # 59c <exit>
