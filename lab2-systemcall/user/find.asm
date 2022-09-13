
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	372080e7          	jalr	882(ra) # 382 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
    ;
  p++;
  36:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3a:	8526                	mv	a0,s1
  3c:	00000097          	auipc	ra,0x0
  40:	346080e7          	jalr	838(ra) # 382 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	00a7fa63          	bgeu	a5,a0,5c <fmtname+0x5c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  return buf;
}
  4c:	8526                	mv	a0,s1
  4e:	70a2                	ld	ra,40(sp)
  50:	7402                	ld	s0,32(sp)
  52:	64e2                	ld	s1,24(sp)
  54:	6942                	ld	s2,16(sp)
  56:	69a2                	ld	s3,8(sp)
  58:	6145                	addi	sp,sp,48
  5a:	8082                	ret
  memmove(buf, p, strlen(p));
  5c:	8526                	mv	a0,s1
  5e:	00000097          	auipc	ra,0x0
  62:	324080e7          	jalr	804(ra) # 382 <strlen>
  66:	00001997          	auipc	s3,0x1
  6a:	b0a98993          	addi	s3,s3,-1270 # b70 <buf.1112>
  6e:	0005061b          	sext.w	a2,a0
  72:	85a6                	mv	a1,s1
  74:	854e                	mv	a0,s3
  76:	00000097          	auipc	ra,0x0
  7a:	484080e7          	jalr	1156(ra) # 4fa <memmove>
  memset(buf+strlen(p), '\0', DIRSIZ-strlen(p));
  7e:	8526                	mv	a0,s1
  80:	00000097          	auipc	ra,0x0
  84:	302080e7          	jalr	770(ra) # 382 <strlen>
  88:	0005091b          	sext.w	s2,a0
  8c:	8526                	mv	a0,s1
  8e:	00000097          	auipc	ra,0x0
  92:	2f4080e7          	jalr	756(ra) # 382 <strlen>
  96:	1902                	slli	s2,s2,0x20
  98:	02095913          	srli	s2,s2,0x20
  9c:	4639                	li	a2,14
  9e:	9e09                	subw	a2,a2,a0
  a0:	4581                	li	a1,0
  a2:	01298533          	add	a0,s3,s2
  a6:	00000097          	auipc	ra,0x0
  aa:	306080e7          	jalr	774(ra) # 3ac <memset>
  return buf;
  ae:	84ce                	mv	s1,s3
  b0:	bf71                	j	4c <fmtname+0x4c>

00000000000000b2 <recur>:

int recur(char *path)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
    char *buf = fmtname(path);
  ba:	00000097          	auipc	ra,0x0
  be:	f46080e7          	jalr	-186(ra) # 0 <fmtname>
    if(buf[0] == '.'&& buf[1] == '\0')
  c2:	00054683          	lbu	a3,0(a0)
  c6:	02e00713          	li	a4,46
  ca:	00e68763          	beq	a3,a4,d8 <recur+0x26>
    else if (buf[0] == '.'&& buf[1] == '.'&& buf[2] == '\0')
    {
        return 0;
    }
    else{
        return 1;
  ce:	4505                	li	a0,1
    }
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  d8:	87aa                	mv	a5,a0
    if(buf[0] == '.'&& buf[1] == '\0')
  da:	00154703          	lbu	a4,1(a0)
        return 0;
  de:	4501                	li	a0,0
    if(buf[0] == '.'&& buf[1] == '\0')
  e0:	db65                	beqz	a4,d0 <recur+0x1e>
    else if (buf[0] == '.'&& buf[1] == '.'&& buf[2] == '\0')
  e2:	02e00693          	li	a3,46
        return 1;
  e6:	4505                	li	a0,1
    else if (buf[0] == '.'&& buf[1] == '.'&& buf[2] == '\0')
  e8:	fed714e3          	bne	a4,a3,d0 <recur+0x1e>
  ec:	0027c503          	lbu	a0,2(a5)
        return 1;
  f0:	00a03533          	snez	a0,a0
  f4:	bff1                	j	d0 <recur+0x1e>

00000000000000f6 <findf>:

void
findf(char *path,char *fle)
{
  f6:	d9010113          	addi	sp,sp,-624
  fa:	26113423          	sd	ra,616(sp)
  fe:	26813023          	sd	s0,608(sp)
 102:	24913c23          	sd	s1,600(sp)
 106:	25213823          	sd	s2,592(sp)
 10a:	25313423          	sd	s3,584(sp)
 10e:	25413023          	sd	s4,576(sp)
 112:	23513c23          	sd	s5,568(sp)
 116:	1c80                	addi	s0,sp,624
 118:	892a                	mv	s2,a0
 11a:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
 11c:	4581                	li	a1,0
 11e:	00000097          	auipc	ra,0x0
 122:	4d2080e7          	jalr	1234(ra) # 5f0 <open>
 126:	06054663          	bltz	a0,192 <findf+0x9c>
 12a:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
 12c:	d9840593          	addi	a1,s0,-616
 130:	00000097          	auipc	ra,0x0
 134:	4d8080e7          	jalr	1240(ra) # 608 <fstat>
 138:	06054863          	bltz	a0,1a8 <findf+0xb2>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
 13c:	da041783          	lh	a5,-608(s0)
 140:	0007869b          	sext.w	a3,a5
 144:	4705                	li	a4,1
 146:	08e68b63          	beq	a3,a4,1dc <findf+0xe6>
 14a:	4709                	li	a4,2
 14c:	00e69d63          	bne	a3,a4,166 <findf+0x70>
  case T_FILE:

    if(strcmp(fmtname(path), fle) == 0)
 150:	854a                	mv	a0,s2
 152:	00000097          	auipc	ra,0x0
 156:	eae080e7          	jalr	-338(ra) # 0 <fmtname>
 15a:	85ce                	mv	a1,s3
 15c:	00000097          	auipc	ra,0x0
 160:	1fa080e7          	jalr	506(ra) # 356 <strcmp>
 164:	c135                	beqz	a0,1c8 <findf+0xd2>
      }
      
    }
    break;
  }
  close(fd);
 166:	8526                	mv	a0,s1
 168:	00000097          	auipc	ra,0x0
 16c:	470080e7          	jalr	1136(ra) # 5d8 <close>
}
 170:	26813083          	ld	ra,616(sp)
 174:	26013403          	ld	s0,608(sp)
 178:	25813483          	ld	s1,600(sp)
 17c:	25013903          	ld	s2,592(sp)
 180:	24813983          	ld	s3,584(sp)
 184:	24013a03          	ld	s4,576(sp)
 188:	23813a83          	ld	s5,568(sp)
 18c:	27010113          	addi	sp,sp,624
 190:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 192:	864a                	mv	a2,s2
 194:	00001597          	auipc	a1,0x1
 198:	94c58593          	addi	a1,a1,-1716 # ae0 <malloc+0xea>
 19c:	4509                	li	a0,2
 19e:	00000097          	auipc	ra,0x0
 1a2:	76c080e7          	jalr	1900(ra) # 90a <fprintf>
    return;
 1a6:	b7e9                	j	170 <findf+0x7a>
    fprintf(2, "ls: cannot stat %s\n", path);
 1a8:	864a                	mv	a2,s2
 1aa:	00001597          	auipc	a1,0x1
 1ae:	94e58593          	addi	a1,a1,-1714 # af8 <malloc+0x102>
 1b2:	4509                	li	a0,2
 1b4:	00000097          	auipc	ra,0x0
 1b8:	756080e7          	jalr	1878(ra) # 90a <fprintf>
    close(fd);
 1bc:	8526                	mv	a0,s1
 1be:	00000097          	auipc	ra,0x0
 1c2:	41a080e7          	jalr	1050(ra) # 5d8 <close>
    return;
 1c6:	b76d                	j	170 <findf+0x7a>
      printf("%s\n" , path);
 1c8:	85ca                	mv	a1,s2
 1ca:	00001517          	auipc	a0,0x1
 1ce:	92650513          	addi	a0,a0,-1754 # af0 <malloc+0xfa>
 1d2:	00000097          	auipc	ra,0x0
 1d6:	766080e7          	jalr	1894(ra) # 938 <printf>
 1da:	b771                	j	166 <findf+0x70>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1dc:	854a                	mv	a0,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	1a4080e7          	jalr	420(ra) # 382 <strlen>
 1e6:	2541                	addiw	a0,a0,16
 1e8:	20000793          	li	a5,512
 1ec:	00a7fb63          	bgeu	a5,a0,202 <findf+0x10c>
      printf("ls: path too long\n");
 1f0:	00001517          	auipc	a0,0x1
 1f4:	92050513          	addi	a0,a0,-1760 # b10 <malloc+0x11a>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	740080e7          	jalr	1856(ra) # 938 <printf>
      break;
 200:	b79d                	j	166 <findf+0x70>
    strcpy(buf, path);
 202:	85ca                	mv	a1,s2
 204:	dc040513          	addi	a0,s0,-576
 208:	00000097          	auipc	ra,0x0
 20c:	132080e7          	jalr	306(ra) # 33a <strcpy>
    p = buf+strlen(buf);
 210:	dc040513          	addi	a0,s0,-576
 214:	00000097          	auipc	ra,0x0
 218:	16e080e7          	jalr	366(ra) # 382 <strlen>
 21c:	02051913          	slli	s2,a0,0x20
 220:	02095913          	srli	s2,s2,0x20
 224:	dc040793          	addi	a5,s0,-576
 228:	993e                	add	s2,s2,a5
    *p++ = '/';
 22a:	00190a13          	addi	s4,s2,1
 22e:	02f00793          	li	a5,47
 232:	00f90023          	sb	a5,0(s2)
        printf("ls: cannot stat %s\n", buf);
 236:	00001a97          	auipc	s5,0x1
 23a:	8c2a8a93          	addi	s5,s5,-1854 # af8 <malloc+0x102>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 23e:	4641                	li	a2,16
 240:	db040593          	addi	a1,s0,-592
 244:	8526                	mv	a0,s1
 246:	00000097          	auipc	ra,0x0
 24a:	382080e7          	jalr	898(ra) # 5c8 <read>
 24e:	47c1                	li	a5,16
 250:	f0f51be3          	bne	a0,a5,166 <findf+0x70>
      if(de.inum == 0)
 254:	db045783          	lhu	a5,-592(s0)
 258:	d3fd                	beqz	a5,23e <findf+0x148>
      memmove(p, de.name, DIRSIZ);
 25a:	4639                	li	a2,14
 25c:	db240593          	addi	a1,s0,-590
 260:	8552                	mv	a0,s4
 262:	00000097          	auipc	ra,0x0
 266:	298080e7          	jalr	664(ra) # 4fa <memmove>
      p[DIRSIZ] = 0;
 26a:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 26e:	d9840593          	addi	a1,s0,-616
 272:	dc040513          	addi	a0,s0,-576
 276:	00000097          	auipc	ra,0x0
 27a:	1f4080e7          	jalr	500(ra) # 46a <stat>
 27e:	02054163          	bltz	a0,2a0 <findf+0x1aa>
      if(recur(buf))
 282:	dc040513          	addi	a0,s0,-576
 286:	00000097          	auipc	ra,0x0
 28a:	e2c080e7          	jalr	-468(ra) # b2 <recur>
 28e:	d945                	beqz	a0,23e <findf+0x148>
        findf(buf,fle);
 290:	85ce                	mv	a1,s3
 292:	dc040513          	addi	a0,s0,-576
 296:	00000097          	auipc	ra,0x0
 29a:	e60080e7          	jalr	-416(ra) # f6 <findf>
 29e:	b745                	j	23e <findf+0x148>
        printf("ls: cannot stat %s\n", buf);
 2a0:	dc040593          	addi	a1,s0,-576
 2a4:	8556                	mv	a0,s5
 2a6:	00000097          	auipc	ra,0x0
 2aa:	692080e7          	jalr	1682(ra) # 938 <printf>
        continue;
 2ae:	bf41                	j	23e <findf+0x148>

00000000000002b0 <main>:

int
main(int argc, char *argv[])
{
 2b0:	7139                	addi	sp,sp,-64
 2b2:	fc06                	sd	ra,56(sp)
 2b4:	f822                	sd	s0,48(sp)
 2b6:	f426                	sd	s1,40(sp)
 2b8:	f04a                	sd	s2,32(sp)
 2ba:	ec4e                	sd	s3,24(sp)
 2bc:	e852                	sd	s4,16(sp)
 2be:	e456                	sd	s5,8(sp)
 2c0:	0080                	addi	s0,sp,64

  if(argc < 2){
 2c2:	4785                	li	a5,1
 2c4:	04a7d463          	bge	a5,a0,30c <main+0x5c>
 2c8:	89aa                	mv	s3,a0
 2ca:	8a2e                	mv	s4,a1
    printf("find error");
    exit(1);
  }
  if(argc == 2)
 2cc:	4789                	li	a5,2
 2ce:	01058913          	addi	s2,a1,16
  {
    findf(".",argv[1]);
  }
  else
  {
    for(int i=2; i<argc; i++)
 2d2:	4489                	li	s1,2
    {
      findf(argv[1], argv[i]);
      printf("\n");
 2d4:	00001a97          	auipc	s5,0x1
 2d8:	86ca8a93          	addi	s5,s5,-1940 # b40 <malloc+0x14a>
  if(argc == 2)
 2dc:	04f50563          	beq	a0,a5,326 <main+0x76>
      findf(argv[1], argv[i]);
 2e0:	00093583          	ld	a1,0(s2)
 2e4:	008a3503          	ld	a0,8(s4)
 2e8:	00000097          	auipc	ra,0x0
 2ec:	e0e080e7          	jalr	-498(ra) # f6 <findf>
      printf("\n");
 2f0:	8556                	mv	a0,s5
 2f2:	00000097          	auipc	ra,0x0
 2f6:	646080e7          	jalr	1606(ra) # 938 <printf>
    for(int i=2; i<argc; i++)
 2fa:	2485                	addiw	s1,s1,1
 2fc:	0921                	addi	s2,s2,8
 2fe:	ff34c1e3          	blt	s1,s3,2e0 <main+0x30>
    }

  }
  exit(0);
 302:	4501                	li	a0,0
 304:	00000097          	auipc	ra,0x0
 308:	2ac080e7          	jalr	684(ra) # 5b0 <exit>
    printf("find error");
 30c:	00001517          	auipc	a0,0x1
 310:	81c50513          	addi	a0,a0,-2020 # b28 <malloc+0x132>
 314:	00000097          	auipc	ra,0x0
 318:	624080e7          	jalr	1572(ra) # 938 <printf>
    exit(1);
 31c:	4505                	li	a0,1
 31e:	00000097          	auipc	ra,0x0
 322:	292080e7          	jalr	658(ra) # 5b0 <exit>
    findf(".",argv[1]);
 326:	658c                	ld	a1,8(a1)
 328:	00001517          	auipc	a0,0x1
 32c:	81050513          	addi	a0,a0,-2032 # b38 <malloc+0x142>
 330:	00000097          	auipc	ra,0x0
 334:	dc6080e7          	jalr	-570(ra) # f6 <findf>
 338:	b7e9                	j	302 <main+0x52>

000000000000033a <strcpy>:
#include "user/user.h"

//将字符串t的值复制给字符串s
char*
strcpy(char *s, const char *t)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 340:	87aa                	mv	a5,a0
 342:	0585                	addi	a1,a1,1
 344:	0785                	addi	a5,a5,1
 346:	fff5c703          	lbu	a4,-1(a1)
 34a:	fee78fa3          	sb	a4,-1(a5)
 34e:	fb75                	bnez	a4,342 <strcpy+0x8>
    ;
  return os;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strcmp>:

//把p所指向的字符串和q所指向的字符串进行比较
int
strcmp(const char *p, const char *q)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cb91                	beqz	a5,374 <strcmp+0x1e>
 362:	0005c703          	lbu	a4,0(a1)
 366:	00f71763          	bne	a4,a5,374 <strcmp+0x1e>
    p++, q++;
 36a:	0505                	addi	a0,a0,1
 36c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 36e:	00054783          	lbu	a5,0(a0)
 372:	fbe5                	bnez	a5,362 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 374:	0005c503          	lbu	a0,0(a1)
}
 378:	40a7853b          	subw	a0,a5,a0
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strlen>:

//从内存的某个位置（可以是字符串开头，中间某个位置，甚至是某个不确定的内存区域）开始扫描，直到碰到第一个字符串结束符 \0 为止，然后返回计数器值（长度不包含 \0 ）
uint
strlen(const char *s)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cf91                	beqz	a5,3a8 <strlen+0x26>
 38e:	0505                	addi	a0,a0,1
 390:	87aa                	mv	a5,a0
 392:	4685                	li	a3,1
 394:	9e89                	subw	a3,a3,a0
 396:	00f6853b          	addw	a0,a3,a5
 39a:	0785                	addi	a5,a5,1
 39c:	fff7c703          	lbu	a4,-1(a5)
 3a0:	fb7d                	bnez	a4,396 <strlen+0x14>
    ;
  return n;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  for(n = 0; s[n]; n++)
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <strlen+0x20>

00000000000003ac <memset>:

//复制字符 c（一个无符号字符）到参数 str 所指向的字符串的前 n 个字符
void*
memset(void *dst, int c, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst; //将指针dst强制转换为char型指针
  int i;
  for(i = 0; i < n; i++){
 3b2:	ce09                	beqz	a2,3cc <memset+0x20>
 3b4:	87aa                	mv	a5,a0
 3b6:	fff6071b          	addiw	a4,a2,-1
 3ba:	1702                	slli	a4,a4,0x20
 3bc:	9301                	srli	a4,a4,0x20
 3be:	0705                	addi	a4,a4,1
 3c0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c6:	0785                	addi	a5,a5,1
 3c8:	fee79de3          	bne	a5,a4,3c2 <memset+0x16>
  }
  return dst;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <strchr>:


char*
strchr(const char *s, char c)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	cb99                	beqz	a5,3f2 <strchr+0x20>
    if(*s == c)
 3de:	00f58763          	beq	a1,a5,3ec <strchr+0x1a>
  for(; *s; s++)
 3e2:	0505                	addi	a0,a0,1
 3e4:	00054783          	lbu	a5,0(a0)
 3e8:	fbfd                	bnez	a5,3de <strchr+0xc>
      return (char*)s;
  return 0;
 3ea:	4501                	li	a0,0
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <strchr+0x1a>

00000000000003f6 <gets>:

char*
gets(char *buf, int max)
{
 3f6:	711d                	addi	sp,sp,-96
 3f8:	ec86                	sd	ra,88(sp)
 3fa:	e8a2                	sd	s0,80(sp)
 3fc:	e4a6                	sd	s1,72(sp)
 3fe:	e0ca                	sd	s2,64(sp)
 400:	fc4e                	sd	s3,56(sp)
 402:	f852                	sd	s4,48(sp)
 404:	f456                	sd	s5,40(sp)
 406:	f05a                	sd	s6,32(sp)
 408:	ec5e                	sd	s7,24(sp)
 40a:	1080                	addi	s0,sp,96
 40c:	8baa                	mv	s7,a0
 40e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 410:	892a                	mv	s2,a0
 412:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 414:	4aa9                	li	s5,10
 416:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 418:	89a6                	mv	s3,s1
 41a:	2485                	addiw	s1,s1,1
 41c:	0344d863          	bge	s1,s4,44c <gets+0x56>
    cc = read(0, &c, 1);
 420:	4605                	li	a2,1
 422:	faf40593          	addi	a1,s0,-81
 426:	4501                	li	a0,0
 428:	00000097          	auipc	ra,0x0
 42c:	1a0080e7          	jalr	416(ra) # 5c8 <read>
    if(cc < 1)
 430:	00a05e63          	blez	a0,44c <gets+0x56>
    buf[i++] = c;
 434:	faf44783          	lbu	a5,-81(s0)
 438:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43c:	01578763          	beq	a5,s5,44a <gets+0x54>
 440:	0905                	addi	s2,s2,1
 442:	fd679be3          	bne	a5,s6,418 <gets+0x22>
  for(i=0; i+1 < max; ){
 446:	89a6                	mv	s3,s1
 448:	a011                	j	44c <gets+0x56>
 44a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 44c:	99de                	add	s3,s3,s7
 44e:	00098023          	sb	zero,0(s3)
  return buf;
}
 452:	855e                	mv	a0,s7
 454:	60e6                	ld	ra,88(sp)
 456:	6446                	ld	s0,80(sp)
 458:	64a6                	ld	s1,72(sp)
 45a:	6906                	ld	s2,64(sp)
 45c:	79e2                	ld	s3,56(sp)
 45e:	7a42                	ld	s4,48(sp)
 460:	7aa2                	ld	s5,40(sp)
 462:	7b02                	ld	s6,32(sp)
 464:	6be2                	ld	s7,24(sp)
 466:	6125                	addi	sp,sp,96
 468:	8082                	ret

000000000000046a <stat>:

int
stat(const char *n, struct stat *st)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	e426                	sd	s1,8(sp)
 472:	e04a                	sd	s2,0(sp)
 474:	1000                	addi	s0,sp,32
 476:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 478:	4581                	li	a1,0
 47a:	00000097          	auipc	ra,0x0
 47e:	176080e7          	jalr	374(ra) # 5f0 <open>
  if(fd < 0)
 482:	02054563          	bltz	a0,4ac <stat+0x42>
 486:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 488:	85ca                	mv	a1,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	17e080e7          	jalr	382(ra) # 608 <fstat>
 492:	892a                	mv	s2,a0
  close(fd);
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	142080e7          	jalr	322(ra) # 5d8 <close>
  return r;
}
 49e:	854a                	mv	a0,s2
 4a0:	60e2                	ld	ra,24(sp)
 4a2:	6442                	ld	s0,16(sp)
 4a4:	64a2                	ld	s1,8(sp)
 4a6:	6902                	ld	s2,0(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret
    return -1;
 4ac:	597d                	li	s2,-1
 4ae:	bfc5                	j	49e <stat+0x34>

00000000000004b0 <atoi>:

//将参数s所指向字符串转换为一个整数
int
atoi(const char *s)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b6:	00054603          	lbu	a2,0(a0)
 4ba:	fd06079b          	addiw	a5,a2,-48
 4be:	0ff7f793          	andi	a5,a5,255
 4c2:	4725                	li	a4,9
 4c4:	02f76963          	bltu	a4,a5,4f6 <atoi+0x46>
 4c8:	86aa                	mv	a3,a0
  n = 0;
 4ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ce:	0685                	addi	a3,a3,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb1                	addw	a5,a5,a2
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	0006c603          	lbu	a2,0(a3)
 4e4:	fd06071b          	addiw	a4,a2,-48
 4e8:	0ff77713          	andi	a4,a4,255
 4ec:	fee5f1e3          	bgeu	a1,a4,4ce <atoi+0x1e>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x40>

00000000000004fa <memmove>:

//将vsrc开始后n个字符复制到从vdst开始的位置
void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57663          	bgeu	a0,a1,52c <memmove+0x32>
    while(n-- > 0)
 504:	02c05163          	blez	a2,526 <memmove+0x2c>
 508:	fff6079b          	addiw	a5,a2,-1
 50c:	1782                	slli	a5,a5,0x20
 50e:	9381                	srli	a5,a5,0x20
 510:	0785                	addi	a5,a5,1
 512:	97aa                	add	a5,a5,a0
  dst = vdst;
 514:	872a                	mv	a4,a0
      *dst++ = *src++;
 516:	0585                	addi	a1,a1,1
 518:	0705                	addi	a4,a4,1
 51a:	fff5c683          	lbu	a3,-1(a1)
 51e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 522:	fee79ae3          	bne	a5,a4,516 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret
    dst += n;
 52c:	00c50733          	add	a4,a0,a2
    src += n;
 530:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 532:	fec05ae3          	blez	a2,526 <memmove+0x2c>
 536:	fff6079b          	addiw	a5,a2,-1
 53a:	1782                	slli	a5,a5,0x20
 53c:	9381                	srli	a5,a5,0x20
 53e:	fff7c793          	not	a5,a5
 542:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 544:	15fd                	addi	a1,a1,-1
 546:	177d                	addi	a4,a4,-1
 548:	0005c683          	lbu	a3,0(a1)
 54c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 550:	fee79ae3          	bne	a5,a4,544 <memmove+0x4a>
 554:	bfc9                	j	526 <memmove+0x2c>

0000000000000556 <memcmp>:


int
memcmp(const void *s1, const void *s2, uint n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 55c:	ca05                	beqz	a2,58c <memcmp+0x36>
 55e:	fff6069b          	addiw	a3,a2,-1
 562:	1682                	slli	a3,a3,0x20
 564:	9281                	srli	a3,a3,0x20
 566:	0685                	addi	a3,a3,1
 568:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 56a:	00054783          	lbu	a5,0(a0)
 56e:	0005c703          	lbu	a4,0(a1)
 572:	00e79863          	bne	a5,a4,582 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 576:	0505                	addi	a0,a0,1
    p2++;
 578:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 57a:	fed518e3          	bne	a0,a3,56a <memcmp+0x14>
  }
  return 0;
 57e:	4501                	li	a0,0
 580:	a019                	j	586 <memcmp+0x30>
      return *p1 - *p2;
 582:	40e7853b          	subw	a0,a5,a4
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
  return 0;
 58c:	4501                	li	a0,0
 58e:	bfe5                	j	586 <memcmp+0x30>

0000000000000590 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 590:	1141                	addi	sp,sp,-16
 592:	e406                	sd	ra,8(sp)
 594:	e022                	sd	s0,0(sp)
 596:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 598:	00000097          	auipc	ra,0x0
 59c:	f62080e7          	jalr	-158(ra) # 4fa <memmove>
}
 5a0:	60a2                	ld	ra,8(sp)
 5a2:	6402                	ld	s0,0(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret

00000000000005a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a8:	4885                	li	a7,1
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b0:	4889                	li	a7,2
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b8:	488d                	li	a7,3
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c0:	4891                	li	a7,4
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <read>:
.global read
read:
 li a7, SYS_read
 5c8:	4895                	li	a7,5
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <write>:
.global write
write:
 li a7, SYS_write
 5d0:	48c1                	li	a7,16
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <close>:
.global close
close:
 li a7, SYS_close
 5d8:	48d5                	li	a7,21
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e0:	4899                	li	a7,6
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e8:	489d                	li	a7,7
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <open>:
.global open
open:
 li a7, SYS_open
 5f0:	48bd                	li	a7,15
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f8:	48c5                	li	a7,17
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 600:	48c9                	li	a7,18
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 608:	48a1                	li	a7,8
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <link>:
.global link
link:
 li a7, SYS_link
 610:	48cd                	li	a7,19
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 618:	48d1                	li	a7,20
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 620:	48a5                	li	a7,9
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <dup>:
.global dup
dup:
 li a7, SYS_dup
 628:	48a9                	li	a7,10
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 630:	48ad                	li	a7,11
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 638:	48b1                	li	a7,12
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 640:	48b5                	li	a7,13
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 648:	48b9                	li	a7,14
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <trace>:
.global trace
trace:
 li a7, SYS_trace
 650:	48d9                	li	a7,22
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 658:	48dd                	li	a7,23
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 660:	1101                	addi	sp,sp,-32
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	addi	s0,sp,32
 668:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 66c:	4605                	li	a2,1
 66e:	fef40593          	addi	a1,s0,-17
 672:	00000097          	auipc	ra,0x0
 676:	f5e080e7          	jalr	-162(ra) # 5d0 <write>
}
 67a:	60e2                	ld	ra,24(sp)
 67c:	6442                	ld	s0,16(sp)
 67e:	6105                	addi	sp,sp,32
 680:	8082                	ret

0000000000000682 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 682:	7139                	addi	sp,sp,-64
 684:	fc06                	sd	ra,56(sp)
 686:	f822                	sd	s0,48(sp)
 688:	f426                	sd	s1,40(sp)
 68a:	f04a                	sd	s2,32(sp)
 68c:	ec4e                	sd	s3,24(sp)
 68e:	0080                	addi	s0,sp,64
 690:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 692:	c299                	beqz	a3,698 <printint+0x16>
 694:	0805c863          	bltz	a1,724 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 698:	2581                	sext.w	a1,a1
  neg = 0;
 69a:	4881                	li	a7,0
 69c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6a2:	2601                	sext.w	a2,a2
 6a4:	00000517          	auipc	a0,0x0
 6a8:	4ac50513          	addi	a0,a0,1196 # b50 <digits>
 6ac:	883a                	mv	a6,a4
 6ae:	2705                	addiw	a4,a4,1
 6b0:	02c5f7bb          	remuw	a5,a1,a2
 6b4:	1782                	slli	a5,a5,0x20
 6b6:	9381                	srli	a5,a5,0x20
 6b8:	97aa                	add	a5,a5,a0
 6ba:	0007c783          	lbu	a5,0(a5)
 6be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6c2:	0005879b          	sext.w	a5,a1
 6c6:	02c5d5bb          	divuw	a1,a1,a2
 6ca:	0685                	addi	a3,a3,1
 6cc:	fec7f0e3          	bgeu	a5,a2,6ac <printint+0x2a>
  if(neg)
 6d0:	00088b63          	beqz	a7,6e6 <printint+0x64>
    buf[i++] = '-';
 6d4:	fd040793          	addi	a5,s0,-48
 6d8:	973e                	add	a4,a4,a5
 6da:	02d00793          	li	a5,45
 6de:	fef70823          	sb	a5,-16(a4)
 6e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6e6:	02e05863          	blez	a4,716 <printint+0x94>
 6ea:	fc040793          	addi	a5,s0,-64
 6ee:	00e78933          	add	s2,a5,a4
 6f2:	fff78993          	addi	s3,a5,-1
 6f6:	99ba                	add	s3,s3,a4
 6f8:	377d                	addiw	a4,a4,-1
 6fa:	1702                	slli	a4,a4,0x20
 6fc:	9301                	srli	a4,a4,0x20
 6fe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 702:	fff94583          	lbu	a1,-1(s2)
 706:	8526                	mv	a0,s1
 708:	00000097          	auipc	ra,0x0
 70c:	f58080e7          	jalr	-168(ra) # 660 <putc>
  while(--i >= 0)
 710:	197d                	addi	s2,s2,-1
 712:	ff3918e3          	bne	s2,s3,702 <printint+0x80>
}
 716:	70e2                	ld	ra,56(sp)
 718:	7442                	ld	s0,48(sp)
 71a:	74a2                	ld	s1,40(sp)
 71c:	7902                	ld	s2,32(sp)
 71e:	69e2                	ld	s3,24(sp)
 720:	6121                	addi	sp,sp,64
 722:	8082                	ret
    x = -xx;
 724:	40b005bb          	negw	a1,a1
    neg = 1;
 728:	4885                	li	a7,1
    x = -xx;
 72a:	bf8d                	j	69c <printint+0x1a>

000000000000072c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 72c:	7119                	addi	sp,sp,-128
 72e:	fc86                	sd	ra,120(sp)
 730:	f8a2                	sd	s0,112(sp)
 732:	f4a6                	sd	s1,104(sp)
 734:	f0ca                	sd	s2,96(sp)
 736:	ecce                	sd	s3,88(sp)
 738:	e8d2                	sd	s4,80(sp)
 73a:	e4d6                	sd	s5,72(sp)
 73c:	e0da                	sd	s6,64(sp)
 73e:	fc5e                	sd	s7,56(sp)
 740:	f862                	sd	s8,48(sp)
 742:	f466                	sd	s9,40(sp)
 744:	f06a                	sd	s10,32(sp)
 746:	ec6e                	sd	s11,24(sp)
 748:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 74a:	0005c903          	lbu	s2,0(a1)
 74e:	18090f63          	beqz	s2,8ec <vprintf+0x1c0>
 752:	8aaa                	mv	s5,a0
 754:	8b32                	mv	s6,a2
 756:	00158493          	addi	s1,a1,1
  state = 0;
 75a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 75c:	02500a13          	li	s4,37
      if(c == 'd'){
 760:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 764:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 768:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 76c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 770:	00000b97          	auipc	s7,0x0
 774:	3e0b8b93          	addi	s7,s7,992 # b50 <digits>
 778:	a839                	j	796 <vprintf+0x6a>
        putc(fd, c);
 77a:	85ca                	mv	a1,s2
 77c:	8556                	mv	a0,s5
 77e:	00000097          	auipc	ra,0x0
 782:	ee2080e7          	jalr	-286(ra) # 660 <putc>
 786:	a019                	j	78c <vprintf+0x60>
    } else if(state == '%'){
 788:	01498f63          	beq	s3,s4,7a6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 78c:	0485                	addi	s1,s1,1
 78e:	fff4c903          	lbu	s2,-1(s1)
 792:	14090d63          	beqz	s2,8ec <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 796:	0009079b          	sext.w	a5,s2
    if(state == 0){
 79a:	fe0997e3          	bnez	s3,788 <vprintf+0x5c>
      if(c == '%'){
 79e:	fd479ee3          	bne	a5,s4,77a <vprintf+0x4e>
        state = '%';
 7a2:	89be                	mv	s3,a5
 7a4:	b7e5                	j	78c <vprintf+0x60>
      if(c == 'd'){
 7a6:	05878063          	beq	a5,s8,7e6 <vprintf+0xba>
      } else if(c == 'l') {
 7aa:	05978c63          	beq	a5,s9,802 <vprintf+0xd6>
      } else if(c == 'x') {
 7ae:	07a78863          	beq	a5,s10,81e <vprintf+0xf2>
      } else if(c == 'p') {
 7b2:	09b78463          	beq	a5,s11,83a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7b6:	07300713          	li	a4,115
 7ba:	0ce78663          	beq	a5,a4,886 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7be:	06300713          	li	a4,99
 7c2:	0ee78e63          	beq	a5,a4,8be <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7c6:	11478863          	beq	a5,s4,8d6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ca:	85d2                	mv	a1,s4
 7cc:	8556                	mv	a0,s5
 7ce:	00000097          	auipc	ra,0x0
 7d2:	e92080e7          	jalr	-366(ra) # 660 <putc>
        putc(fd, c);
 7d6:	85ca                	mv	a1,s2
 7d8:	8556                	mv	a0,s5
 7da:	00000097          	auipc	ra,0x0
 7de:	e86080e7          	jalr	-378(ra) # 660 <putc>
      }
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	b765                	j	78c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7e6:	008b0913          	addi	s2,s6,8
 7ea:	4685                	li	a3,1
 7ec:	4629                	li	a2,10
 7ee:	000b2583          	lw	a1,0(s6)
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e8e080e7          	jalr	-370(ra) # 682 <printint>
 7fc:	8b4a                	mv	s6,s2
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b771                	j	78c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 802:	008b0913          	addi	s2,s6,8
 806:	4681                	li	a3,0
 808:	4629                	li	a2,10
 80a:	000b2583          	lw	a1,0(s6)
 80e:	8556                	mv	a0,s5
 810:	00000097          	auipc	ra,0x0
 814:	e72080e7          	jalr	-398(ra) # 682 <printint>
 818:	8b4a                	mv	s6,s2
      state = 0;
 81a:	4981                	li	s3,0
 81c:	bf85                	j	78c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 81e:	008b0913          	addi	s2,s6,8
 822:	4681                	li	a3,0
 824:	4641                	li	a2,16
 826:	000b2583          	lw	a1,0(s6)
 82a:	8556                	mv	a0,s5
 82c:	00000097          	auipc	ra,0x0
 830:	e56080e7          	jalr	-426(ra) # 682 <printint>
 834:	8b4a                	mv	s6,s2
      state = 0;
 836:	4981                	li	s3,0
 838:	bf91                	j	78c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 83a:	008b0793          	addi	a5,s6,8
 83e:	f8f43423          	sd	a5,-120(s0)
 842:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 846:	03000593          	li	a1,48
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	e14080e7          	jalr	-492(ra) # 660 <putc>
  putc(fd, 'x');
 854:	85ea                	mv	a1,s10
 856:	8556                	mv	a0,s5
 858:	00000097          	auipc	ra,0x0
 85c:	e08080e7          	jalr	-504(ra) # 660 <putc>
 860:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 862:	03c9d793          	srli	a5,s3,0x3c
 866:	97de                	add	a5,a5,s7
 868:	0007c583          	lbu	a1,0(a5)
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	df2080e7          	jalr	-526(ra) # 660 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 876:	0992                	slli	s3,s3,0x4
 878:	397d                	addiw	s2,s2,-1
 87a:	fe0914e3          	bnez	s2,862 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 87e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 882:	4981                	li	s3,0
 884:	b721                	j	78c <vprintf+0x60>
        s = va_arg(ap, char*);
 886:	008b0993          	addi	s3,s6,8
 88a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 88e:	02090163          	beqz	s2,8b0 <vprintf+0x184>
        while(*s != 0){
 892:	00094583          	lbu	a1,0(s2)
 896:	c9a1                	beqz	a1,8e6 <vprintf+0x1ba>
          putc(fd, *s);
 898:	8556                	mv	a0,s5
 89a:	00000097          	auipc	ra,0x0
 89e:	dc6080e7          	jalr	-570(ra) # 660 <putc>
          s++;
 8a2:	0905                	addi	s2,s2,1
        while(*s != 0){
 8a4:	00094583          	lbu	a1,0(s2)
 8a8:	f9e5                	bnez	a1,898 <vprintf+0x16c>
        s = va_arg(ap, char*);
 8aa:	8b4e                	mv	s6,s3
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	bdf9                	j	78c <vprintf+0x60>
          s = "(null)";
 8b0:	00000917          	auipc	s2,0x0
 8b4:	29890913          	addi	s2,s2,664 # b48 <malloc+0x152>
        while(*s != 0){
 8b8:	02800593          	li	a1,40
 8bc:	bff1                	j	898 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8be:	008b0913          	addi	s2,s6,8
 8c2:	000b4583          	lbu	a1,0(s6)
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	d98080e7          	jalr	-616(ra) # 660 <putc>
 8d0:	8b4a                	mv	s6,s2
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	bd65                	j	78c <vprintf+0x60>
        putc(fd, c);
 8d6:	85d2                	mv	a1,s4
 8d8:	8556                	mv	a0,s5
 8da:	00000097          	auipc	ra,0x0
 8de:	d86080e7          	jalr	-634(ra) # 660 <putc>
      state = 0;
 8e2:	4981                	li	s3,0
 8e4:	b565                	j	78c <vprintf+0x60>
        s = va_arg(ap, char*);
 8e6:	8b4e                	mv	s6,s3
      state = 0;
 8e8:	4981                	li	s3,0
 8ea:	b54d                	j	78c <vprintf+0x60>
    }
  }
}
 8ec:	70e6                	ld	ra,120(sp)
 8ee:	7446                	ld	s0,112(sp)
 8f0:	74a6                	ld	s1,104(sp)
 8f2:	7906                	ld	s2,96(sp)
 8f4:	69e6                	ld	s3,88(sp)
 8f6:	6a46                	ld	s4,80(sp)
 8f8:	6aa6                	ld	s5,72(sp)
 8fa:	6b06                	ld	s6,64(sp)
 8fc:	7be2                	ld	s7,56(sp)
 8fe:	7c42                	ld	s8,48(sp)
 900:	7ca2                	ld	s9,40(sp)
 902:	7d02                	ld	s10,32(sp)
 904:	6de2                	ld	s11,24(sp)
 906:	6109                	addi	sp,sp,128
 908:	8082                	ret

000000000000090a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 90a:	715d                	addi	sp,sp,-80
 90c:	ec06                	sd	ra,24(sp)
 90e:	e822                	sd	s0,16(sp)
 910:	1000                	addi	s0,sp,32
 912:	e010                	sd	a2,0(s0)
 914:	e414                	sd	a3,8(s0)
 916:	e818                	sd	a4,16(s0)
 918:	ec1c                	sd	a5,24(s0)
 91a:	03043023          	sd	a6,32(s0)
 91e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 922:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 926:	8622                	mv	a2,s0
 928:	00000097          	auipc	ra,0x0
 92c:	e04080e7          	jalr	-508(ra) # 72c <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6161                	addi	sp,sp,80
 936:	8082                	ret

0000000000000938 <printf>:

void
printf(const char *fmt, ...)
{
 938:	711d                	addi	sp,sp,-96
 93a:	ec06                	sd	ra,24(sp)
 93c:	e822                	sd	s0,16(sp)
 93e:	1000                	addi	s0,sp,32
 940:	e40c                	sd	a1,8(s0)
 942:	e810                	sd	a2,16(s0)
 944:	ec14                	sd	a3,24(s0)
 946:	f018                	sd	a4,32(s0)
 948:	f41c                	sd	a5,40(s0)
 94a:	03043823          	sd	a6,48(s0)
 94e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 952:	00840613          	addi	a2,s0,8
 956:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 95a:	85aa                	mv	a1,a0
 95c:	4505                	li	a0,1
 95e:	00000097          	auipc	ra,0x0
 962:	dce080e7          	jalr	-562(ra) # 72c <vprintf>
}
 966:	60e2                	ld	ra,24(sp)
 968:	6442                	ld	s0,16(sp)
 96a:	6125                	addi	sp,sp,96
 96c:	8082                	ret

000000000000096e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 96e:	1141                	addi	sp,sp,-16
 970:	e422                	sd	s0,8(sp)
 972:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 974:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 978:	00000797          	auipc	a5,0x0
 97c:	1f07b783          	ld	a5,496(a5) # b68 <freep>
 980:	a805                	j	9b0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 982:	4618                	lw	a4,8(a2)
 984:	9db9                	addw	a1,a1,a4
 986:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 98a:	6398                	ld	a4,0(a5)
 98c:	6318                	ld	a4,0(a4)
 98e:	fee53823          	sd	a4,-16(a0)
 992:	a091                	j	9d6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 994:	ff852703          	lw	a4,-8(a0)
 998:	9e39                	addw	a2,a2,a4
 99a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 99c:	ff053703          	ld	a4,-16(a0)
 9a0:	e398                	sd	a4,0(a5)
 9a2:	a099                	j	9e8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e7e463          	bltu	a5,a4,9ae <free+0x40>
 9aa:	00e6ea63          	bltu	a3,a4,9be <free+0x50>
{
 9ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	fed7fae3          	bgeu	a5,a3,9a4 <free+0x36>
 9b4:	6398                	ld	a4,0(a5)
 9b6:	00e6e463          	bltu	a3,a4,9be <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ba:	fee7eae3          	bltu	a5,a4,9ae <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9be:	ff852583          	lw	a1,-8(a0)
 9c2:	6390                	ld	a2,0(a5)
 9c4:	02059713          	slli	a4,a1,0x20
 9c8:	9301                	srli	a4,a4,0x20
 9ca:	0712                	slli	a4,a4,0x4
 9cc:	9736                	add	a4,a4,a3
 9ce:	fae60ae3          	beq	a2,a4,982 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9d6:	4790                	lw	a2,8(a5)
 9d8:	02061713          	slli	a4,a2,0x20
 9dc:	9301                	srli	a4,a4,0x20
 9de:	0712                	slli	a4,a4,0x4
 9e0:	973e                	add	a4,a4,a5
 9e2:	fae689e3          	beq	a3,a4,994 <free+0x26>
  } else
    p->s.ptr = bp;
 9e6:	e394                	sd	a3,0(a5)
  freep = p;
 9e8:	00000717          	auipc	a4,0x0
 9ec:	18f73023          	sd	a5,384(a4) # b68 <freep>
}
 9f0:	6422                	ld	s0,8(sp)
 9f2:	0141                	addi	sp,sp,16
 9f4:	8082                	ret

00000000000009f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9f6:	7139                	addi	sp,sp,-64
 9f8:	fc06                	sd	ra,56(sp)
 9fa:	f822                	sd	s0,48(sp)
 9fc:	f426                	sd	s1,40(sp)
 9fe:	f04a                	sd	s2,32(sp)
 a00:	ec4e                	sd	s3,24(sp)
 a02:	e852                	sd	s4,16(sp)
 a04:	e456                	sd	s5,8(sp)
 a06:	e05a                	sd	s6,0(sp)
 a08:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a0a:	02051493          	slli	s1,a0,0x20
 a0e:	9081                	srli	s1,s1,0x20
 a10:	04bd                	addi	s1,s1,15
 a12:	8091                	srli	s1,s1,0x4
 a14:	0014899b          	addiw	s3,s1,1
 a18:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a1a:	00000517          	auipc	a0,0x0
 a1e:	14e53503          	ld	a0,334(a0) # b68 <freep>
 a22:	c515                	beqz	a0,a4e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a26:	4798                	lw	a4,8(a5)
 a28:	02977f63          	bgeu	a4,s1,a66 <malloc+0x70>
 a2c:	8a4e                	mv	s4,s3
 a2e:	0009871b          	sext.w	a4,s3
 a32:	6685                	lui	a3,0x1
 a34:	00d77363          	bgeu	a4,a3,a3a <malloc+0x44>
 a38:	6a05                	lui	s4,0x1
 a3a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a42:	00000917          	auipc	s2,0x0
 a46:	12690913          	addi	s2,s2,294 # b68 <freep>
  if(p == (char*)-1)
 a4a:	5afd                	li	s5,-1
 a4c:	a88d                	j	abe <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a4e:	00000797          	auipc	a5,0x0
 a52:	13278793          	addi	a5,a5,306 # b80 <base>
 a56:	00000717          	auipc	a4,0x0
 a5a:	10f73923          	sd	a5,274(a4) # b68 <freep>
 a5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a64:	b7e1                	j	a2c <malloc+0x36>
      if(p->s.size == nunits)
 a66:	02e48b63          	beq	s1,a4,a9c <malloc+0xa6>
        p->s.size -= nunits;
 a6a:	4137073b          	subw	a4,a4,s3
 a6e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a70:	1702                	slli	a4,a4,0x20
 a72:	9301                	srli	a4,a4,0x20
 a74:	0712                	slli	a4,a4,0x4
 a76:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a78:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a7c:	00000717          	auipc	a4,0x0
 a80:	0ea73623          	sd	a0,236(a4) # b68 <freep>
      return (void*)(p + 1);
 a84:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a88:	70e2                	ld	ra,56(sp)
 a8a:	7442                	ld	s0,48(sp)
 a8c:	74a2                	ld	s1,40(sp)
 a8e:	7902                	ld	s2,32(sp)
 a90:	69e2                	ld	s3,24(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6aa2                	ld	s5,8(sp)
 a96:	6b02                	ld	s6,0(sp)
 a98:	6121                	addi	sp,sp,64
 a9a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a9c:	6398                	ld	a4,0(a5)
 a9e:	e118                	sd	a4,0(a0)
 aa0:	bff1                	j	a7c <malloc+0x86>
  hp->s.size = nu;
 aa2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa6:	0541                	addi	a0,a0,16
 aa8:	00000097          	auipc	ra,0x0
 aac:	ec6080e7          	jalr	-314(ra) # 96e <free>
  return freep;
 ab0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ab4:	d971                	beqz	a0,a88 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab8:	4798                	lw	a4,8(a5)
 aba:	fa9776e3          	bgeu	a4,s1,a66 <malloc+0x70>
    if(p == freep)
 abe:	00093703          	ld	a4,0(s2)
 ac2:	853e                	mv	a0,a5
 ac4:	fef719e3          	bne	a4,a5,ab6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ac8:	8552                	mv	a0,s4
 aca:	00000097          	auipc	ra,0x0
 ace:	b6e080e7          	jalr	-1170(ra) # 638 <sbrk>
  if(p == (char*)-1)
 ad2:	fd5518e3          	bne	a0,s5,aa2 <malloc+0xac>
        return 0;
 ad6:	4501                	li	a0,0
 ad8:	bf45                	j	a88 <malloc+0x92>
