
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	c8478793          	addi	a5,a5,-892 # 80005ce0 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e1878793          	addi	a5,a5,-488 # 80000ebe <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	b04080e7          	jalr	-1276(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	3ba080e7          	jalr	954(ra) # 800024e0 <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	7aa080e7          	jalr	1962(ra) # 800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	b76080e7          	jalr	-1162(ra) # 80000cc4 <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7119                	addi	sp,sp,-128
    80000170:	fc86                	sd	ra,120(sp)
    80000172:	f8a2                	sd	s0,112(sp)
    80000174:	f4a6                	sd	s1,104(sp)
    80000176:	f0ca                	sd	s2,96(sp)
    80000178:	ecce                	sd	s3,88(sp)
    8000017a:	e8d2                	sd	s4,80(sp)
    8000017c:	e4d6                	sd	s5,72(sp)
    8000017e:	e0da                	sd	s6,64(sp)
    80000180:	fc5e                	sd	s7,56(sp)
    80000182:	f862                	sd	s8,48(sp)
    80000184:	f466                	sd	s9,40(sp)
    80000186:	f06a                	sd	s10,32(sp)
    80000188:	ec6e                	sd	s11,24(sp)
    8000018a:	0100                	addi	s0,sp,128
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8aae                	mv	s5,a1
    80000190:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	69a50513          	addi	a0,a0,1690 # 80011830 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a72080e7          	jalr	-1422(ra) # 80000c10 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	68a48493          	addi	s1,s1,1674 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	89a6                	mv	s3,s1
    800001b0:	00011917          	auipc	s2,0x11
    800001b4:	71890913          	addi	s2,s2,1816 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001bc:	4da9                	li	s11,10
  while(n > 0){
    800001be:	07405863          	blez	s4,8000022e <consoleread+0xc0>
    while(cons.r == cons.w){
    800001c2:	0984a783          	lw	a5,152(s1)
    800001c6:	09c4a703          	lw	a4,156(s1)
    800001ca:	02f71463          	bne	a4,a5,800001f2 <consoleread+0x84>
      if(myproc()->killed){
    800001ce:	00002097          	auipc	ra,0x2
    800001d2:	84a080e7          	jalr	-1974(ra) # 80001a18 <myproc>
    800001d6:	591c                	lw	a5,48(a0)
    800001d8:	e7b5                	bnez	a5,80000244 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001da:	85ce                	mv	a1,s3
    800001dc:	854a                	mv	a0,s2
    800001de:	00002097          	auipc	ra,0x2
    800001e2:	04a080e7          	jalr	74(ra) # 80002228 <sleep>
    while(cons.r == cons.w){
    800001e6:	0984a783          	lw	a5,152(s1)
    800001ea:	09c4a703          	lw	a4,156(s1)
    800001ee:	fef700e3          	beq	a4,a5,800001ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f2:	0017871b          	addiw	a4,a5,1
    800001f6:	08e4ac23          	sw	a4,152(s1)
    800001fa:	07f7f713          	andi	a4,a5,127
    800001fe:	9726                	add	a4,a4,s1
    80000200:	01874703          	lbu	a4,24(a4)
    80000204:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000208:	079c0663          	beq	s8,s9,80000274 <consoleread+0x106>
    cbuf = c;
    8000020c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	f8f40613          	addi	a2,s0,-113
    80000216:	85d6                	mv	a1,s5
    80000218:	855a                	mv	a0,s6
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	270080e7          	jalr	624(ra) # 8000248a <either_copyout>
    80000222:	01a50663          	beq	a0,s10,8000022e <consoleread+0xc0>
    dst++;
    80000226:	0a85                	addi	s5,s5,1
    --n;
    80000228:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000022a:	f9bc1ae3          	bne	s8,s11,800001be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	60250513          	addi	a0,a0,1538 # 80011830 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	a8e080e7          	jalr	-1394(ra) # 80000cc4 <release>

  return target - n;
    8000023e:	414b853b          	subw	a0,s7,s4
    80000242:	a811                	j	80000256 <consoleread+0xe8>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	addi	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	a78080e7          	jalr	-1416(ra) # 80000cc4 <release>
        return -1;
    80000254:	557d                	li	a0,-1
}
    80000256:	70e6                	ld	ra,120(sp)
    80000258:	7446                	ld	s0,112(sp)
    8000025a:	74a6                	ld	s1,104(sp)
    8000025c:	7906                	ld	s2,96(sp)
    8000025e:	69e6                	ld	s3,88(sp)
    80000260:	6a46                	ld	s4,80(sp)
    80000262:	6aa6                	ld	s5,72(sp)
    80000264:	6b06                	ld	s6,64(sp)
    80000266:	7be2                	ld	s7,56(sp)
    80000268:	7c42                	ld	s8,48(sp)
    8000026a:	7ca2                	ld	s9,40(sp)
    8000026c:	7d02                	ld	s10,32(sp)
    8000026e:	6de2                	ld	s11,24(sp)
    80000270:	6109                	addi	sp,sp,128
    80000272:	8082                	ret
      if(n < target){
    80000274:	000a071b          	sext.w	a4,s4
    80000278:	fb777be3          	bgeu	a4,s7,8000022e <consoleread+0xc0>
        cons.r--;
    8000027c:	00011717          	auipc	a4,0x11
    80000280:	64f72623          	sw	a5,1612(a4) # 800118c8 <cons+0x98>
    80000284:	b76d                	j	8000022e <consoleread+0xc0>

0000000080000286 <consputc>:
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e406                	sd	ra,8(sp)
    8000028a:	e022                	sd	s0,0(sp)
    8000028c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028e:	10000793          	li	a5,256
    80000292:	00f50a63          	beq	a0,a5,800002a6 <consputc+0x20>
    uartputc_sync(c);
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	564080e7          	jalr	1380(ra) # 800007fa <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	552080e7          	jalr	1362(ra) # 800007fa <uartputc_sync>
    800002b0:	02000513          	li	a0,32
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	546080e7          	jalr	1350(ra) # 800007fa <uartputc_sync>
    800002bc:	4521                	li	a0,8
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	53c080e7          	jalr	1340(ra) # 800007fa <uartputc_sync>
    800002c6:	bfe1                	j	8000029e <consputc+0x18>

00000000800002c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c8:	1101                	addi	sp,sp,-32
    800002ca:	ec06                	sd	ra,24(sp)
    800002cc:	e822                	sd	s0,16(sp)
    800002ce:	e426                	sd	s1,8(sp)
    800002d0:	e04a                	sd	s2,0(sp)
    800002d2:	1000                	addi	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d6:	00011517          	auipc	a0,0x11
    800002da:	55a50513          	addi	a0,a0,1370 # 80011830 <cons>
    800002de:	00001097          	auipc	ra,0x1
    800002e2:	932080e7          	jalr	-1742(ra) # 80000c10 <acquire>

  switch(c){
    800002e6:	47d5                	li	a5,21
    800002e8:	0af48663          	beq	s1,a5,80000394 <consoleintr+0xcc>
    800002ec:	0297ca63          	blt	a5,s1,80000320 <consoleintr+0x58>
    800002f0:	47a1                	li	a5,8
    800002f2:	0ef48763          	beq	s1,a5,800003e0 <consoleintr+0x118>
    800002f6:	47c1                	li	a5,16
    800002f8:	10f49a63          	bne	s1,a5,8000040c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fc:	00002097          	auipc	ra,0x2
    80000300:	23a080e7          	jalr	570(ra) # 80002536 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00011517          	auipc	a0,0x11
    80000308:	52c50513          	addi	a0,a0,1324 # 80011830 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	9b8080e7          	jalr	-1608(ra) # 80000cc4 <release>
}
    80000314:	60e2                	ld	ra,24(sp)
    80000316:	6442                	ld	s0,16(sp)
    80000318:	64a2                	ld	s1,8(sp)
    8000031a:	6902                	ld	s2,0(sp)
    8000031c:	6105                	addi	sp,sp,32
    8000031e:	8082                	ret
  switch(c){
    80000320:	07f00793          	li	a5,127
    80000324:	0af48e63          	beq	s1,a5,800003e0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	00011717          	auipc	a4,0x11
    8000032c:	50870713          	addi	a4,a4,1288 # 80011830 <cons>
    80000330:	0a072783          	lw	a5,160(a4)
    80000334:	09872703          	lw	a4,152(a4)
    80000338:	9f99                	subw	a5,a5,a4
    8000033a:	07f00713          	li	a4,127
    8000033e:	fcf763e3          	bltu	a4,a5,80000304 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000342:	47b5                	li	a5,13
    80000344:	0cf48763          	beq	s1,a5,80000412 <consoleintr+0x14a>
      consputc(c);
    80000348:	8526                	mv	a0,s1
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	f3c080e7          	jalr	-196(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000352:	00011797          	auipc	a5,0x11
    80000356:	4de78793          	addi	a5,a5,1246 # 80011830 <cons>
    8000035a:	0a07a703          	lw	a4,160(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a023          	sw	a3,160(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00011797          	auipc	a5,0x11
    80000384:	5487a783          	lw	a5,1352(a5) # 800118c8 <cons+0x98>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00011717          	auipc	a4,0x11
    80000398:	49c70713          	addi	a4,a4,1180 # 80011830 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00011497          	auipc	s1,0x11
    800003a8:	48c48493          	addi	s1,s1,1164 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	01874703          	lbu	a4,24(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	ebc080e7          	jalr	-324(ra) # 80000286 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a04a783          	lw	a5,160(s1)
    800003d6:	09c4a703          	lw	a4,156(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00011717          	auipc	a4,0x11
    800003e4:	45070713          	addi	a4,a4,1104 # 80011830 <cons>
    800003e8:	0a072783          	lw	a5,160(a4)
    800003ec:	09c72703          	lw	a4,156(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00011717          	auipc	a4,0x11
    800003fa:	4cf72d23          	sw	a5,1242(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fe:	10000513          	li	a0,256
    80000402:	00000097          	auipc	ra,0x0
    80000406:	e84080e7          	jalr	-380(ra) # 80000286 <consputc>
    8000040a:	bded                	j	80000304 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040c:	ee048ce3          	beqz	s1,80000304 <consoleintr+0x3c>
    80000410:	bf21                	j	80000328 <consoleintr+0x60>
      consputc(c);
    80000412:	4529                	li	a0,10
    80000414:	00000097          	auipc	ra,0x0
    80000418:	e72080e7          	jalr	-398(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041c:	00011797          	auipc	a5,0x11
    80000420:	41478793          	addi	a5,a5,1044 # 80011830 <cons>
    80000424:	0a07a703          	lw	a4,160(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a023          	sw	a3,160(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000440:	00011797          	auipc	a5,0x11
    80000444:	48c7a623          	sw	a2,1164(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	48050513          	addi	a0,a0,1152 # 800118c8 <cons+0x98>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	f5e080e7          	jalr	-162(ra) # 800023ae <wakeup>
    80000458:	b575                	j	80000304 <consoleintr+0x3c>

000000008000045a <consoleinit>:

void
consoleinit(void)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000462:	00008597          	auipc	a1,0x8
    80000466:	bae58593          	addi	a1,a1,-1106 # 80008010 <etext+0x10>
    8000046a:	00011517          	auipc	a0,0x11
    8000046e:	3c650513          	addi	a0,a0,966 # 80011830 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	70e080e7          	jalr	1806(ra) # 80000b80 <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	330080e7          	jalr	816(ra) # 800007aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00021797          	auipc	a5,0x21
    80000486:	52e78793          	addi	a5,a5,1326 # 800219b0 <devsw>
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	ce470713          	addi	a4,a4,-796 # 8000016e <consoleread>
    80000492:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000494:	00000717          	auipc	a4,0x0
    80000498:	c5870713          	addi	a4,a4,-936 # 800000ec <consolewrite>
    8000049c:	ef98                	sd	a4,24(a5)
}
    8000049e:	60a2                	ld	ra,8(sp)
    800004a0:	6402                	ld	s0,0(sp)
    800004a2:	0141                	addi	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a6:	7179                	addi	sp,sp,-48
    800004a8:	f406                	sd	ra,40(sp)
    800004aa:	f022                	sd	s0,32(sp)
    800004ac:	ec26                	sd	s1,24(sp)
    800004ae:	e84a                	sd	s2,16(sp)
    800004b0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b2:	c219                	beqz	a2,800004b8 <printint+0x12>
    800004b4:	08054663          	bltz	a0,80000540 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b8:	2501                	sext.w	a0,a0
    800004ba:	4881                	li	a7,0
    800004bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c2:	2581                	sext.w	a1,a1
    800004c4:	00008617          	auipc	a2,0x8
    800004c8:	b7c60613          	addi	a2,a2,-1156 # 80008040 <digits>
    800004cc:	883a                	mv	a6,a4
    800004ce:	2705                	addiw	a4,a4,1
    800004d0:	02b577bb          	remuw	a5,a0,a1
    800004d4:	1782                	slli	a5,a5,0x20
    800004d6:	9381                	srli	a5,a5,0x20
    800004d8:	97b2                	add	a5,a5,a2
    800004da:	0007c783          	lbu	a5,0(a5)
    800004de:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e2:	0005079b          	sext.w	a5,a0
    800004e6:	02b5553b          	divuw	a0,a0,a1
    800004ea:	0685                	addi	a3,a3,1
    800004ec:	feb7f0e3          	bgeu	a5,a1,800004cc <printint+0x26>

  if(sign)
    800004f0:	00088b63          	beqz	a7,80000506 <printint+0x60>
    buf[i++] = '-';
    800004f4:	fe040793          	addi	a5,s0,-32
    800004f8:	973e                	add	a4,a4,a5
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x8e>
    8000050a:	fd040793          	addi	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	addi	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addiw	a4,a4,-1
    8000051a:	1702                	slli	a4,a4,0x20
    8000051c:	9301                	srli	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	d60080e7          	jalr	-672(ra) # 80000286 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	addi	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7c>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	addi	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf9d                	j	800004bc <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	addi	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	addi	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	3807ae23          	sw	zero,924(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    8000055c:	00008517          	auipc	a0,0x8
    80000560:	abc50513          	addi	a0,a0,-1348 # 80008018 <etext+0x18>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	b5250513          	addi	a0,a0,-1198 # 800080c8 <digits+0x88>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00009717          	auipc	a4,0x9
    8000058c:	a6f72c23          	sw	a5,-1416(a4) # 80009000 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	addi	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	addi	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	32cdad83          	lw	s11,812(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	addi	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	16050263          	beqz	a0,80000744 <printf+0x1b2>
    800005e4:	4481                	li	s1,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b13          	li	s6,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00008b97          	auipc	s7,0x8
    800005f4:	a50b8b93          	addi	s7,s7,-1456 # 80008040 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	2d650513          	addi	a0,a0,726 # 800118d8 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	606080e7          	jalr	1542(ra) # 80000c10 <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00008517          	auipc	a0,0x8
    80000618:	a1450513          	addi	a0,a0,-1516 # 80008028 <etext+0x28>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	c62080e7          	jalr	-926(ra) # 80000286 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2485                	addiw	s1,s1,1
    8000062e:	009a07b3          	add	a5,s4,s1
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050763          	beqz	a0,80000744 <printf+0x1b2>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2485                	addiw	s1,s1,1
    80000640:	009a07b3          	add	a5,s4,s1
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000064c:	cfe5                	beqz	a5,80000744 <printf+0x1b2>
    switch(c){
    8000064e:	05678a63          	beq	a5,s6,800006a2 <printf+0x110>
    80000652:	02fb7663          	bgeu	s6,a5,8000067e <printf+0xec>
    80000656:	09978963          	beq	a5,s9,800006e8 <printf+0x156>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79863          	bne	a5,a4,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	addi	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e32080e7          	jalr	-462(ra) # 800004a6 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	0b578263          	beq	a5,s5,80000722 <printf+0x190>
    80000682:	0b879663          	bne	a5,s8,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0e080e7          	jalr	-498(ra) # 800004a6 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bd0080e7          	jalr	-1072(ra) # 80000286 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	bc4080e7          	jalr	-1084(ra) # 80000286 <consputc>
    800006ca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c9d793          	srli	a5,s3,0x3c
    800006d0:	97de                	add	a5,a5,s7
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	bb0080e7          	jalr	-1104(ra) # 80000286 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0992                	slli	s3,s3,0x4
    800006e0:	397d                	addiw	s2,s2,-1
    800006e2:	fe0915e3          	bnez	s2,800006cc <printf+0x13a>
    800006e6:	b799                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	0007b903          	ld	s2,0(a5)
    800006f8:	00090e63          	beqz	s2,80000714 <printf+0x182>
      for(; *s; s++)
    800006fc:	00094503          	lbu	a0,0(s2)
    80000700:	d515                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b84080e7          	jalr	-1148(ra) # 80000286 <consputc>
      for(; *s; s++)
    8000070a:	0905                	addi	s2,s2,1
    8000070c:	00094503          	lbu	a0,0(s2)
    80000710:	f96d                	bnez	a0,80000702 <printf+0x170>
    80000712:	bf29                	j	8000062c <printf+0x9a>
        s = "(null)";
    80000714:	00008917          	auipc	s2,0x8
    80000718:	90c90913          	addi	s2,s2,-1780 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000071c:	02800513          	li	a0,40
    80000720:	b7cd                	j	80000702 <printf+0x170>
      consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b62080e7          	jalr	-1182(ra) # 80000286 <consputc>
      break;
    8000072c:	b701                	j	8000062c <printf+0x9a>
      consputc('%');
    8000072e:	8556                	mv	a0,s5
    80000730:	00000097          	auipc	ra,0x0
    80000734:	b56080e7          	jalr	-1194(ra) # 80000286 <consputc>
      consputc(c);
    80000738:	854a                	mv	a0,s2
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b4c080e7          	jalr	-1204(ra) # 80000286 <consputc>
      break;
    80000742:	b5ed                	j	8000062c <printf+0x9a>
  if(locking)
    80000744:	020d9163          	bnez	s11,80000766 <printf+0x1d4>
}
    80000748:	70e6                	ld	ra,120(sp)
    8000074a:	7446                	ld	s0,112(sp)
    8000074c:	74a6                	ld	s1,104(sp)
    8000074e:	7906                	ld	s2,96(sp)
    80000750:	69e6                	ld	s3,88(sp)
    80000752:	6a46                	ld	s4,80(sp)
    80000754:	6aa6                	ld	s5,72(sp)
    80000756:	6b06                	ld	s6,64(sp)
    80000758:	7be2                	ld	s7,56(sp)
    8000075a:	7c42                	ld	s8,48(sp)
    8000075c:	7ca2                	ld	s9,40(sp)
    8000075e:	7d02                	ld	s10,32(sp)
    80000760:	6de2                	ld	s11,24(sp)
    80000762:	6129                	addi	sp,sp,192
    80000764:	8082                	ret
    release(&pr.lock);
    80000766:	00011517          	auipc	a0,0x11
    8000076a:	17250513          	addi	a0,a0,370 # 800118d8 <pr>
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	556080e7          	jalr	1366(ra) # 80000cc4 <release>
}
    80000776:	bfc9                	j	80000748 <printf+0x1b6>

0000000080000778 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000778:	1101                	addi	sp,sp,-32
    8000077a:	ec06                	sd	ra,24(sp)
    8000077c:	e822                	sd	s0,16(sp)
    8000077e:	e426                	sd	s1,8(sp)
    80000780:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000782:	00011497          	auipc	s1,0x11
    80000786:	15648493          	addi	s1,s1,342 # 800118d8 <pr>
    8000078a:	00008597          	auipc	a1,0x8
    8000078e:	8ae58593          	addi	a1,a1,-1874 # 80008038 <etext+0x38>
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	3ec080e7          	jalr	1004(ra) # 80000b80 <initlock>
  pr.locking = 1;
    8000079c:	4785                	li	a5,1
    8000079e:	cc9c                	sw	a5,24(s1)
}
    800007a0:	60e2                	ld	ra,24(sp)
    800007a2:	6442                	ld	s0,16(sp)
    800007a4:	64a2                	ld	s1,8(sp)
    800007a6:	6105                	addi	sp,sp,32
    800007a8:	8082                	ret

00000000800007aa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e406                	sd	ra,8(sp)
    800007ae:	e022                	sd	s0,0(sp)
    800007b0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b2:	100007b7          	lui	a5,0x10000
    800007b6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ba:	f8000713          	li	a4,-128
    800007be:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c2:	470d                	li	a4,3
    800007c4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007cc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007d0:	469d                	li	a3,7
    800007d2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007da:	00008597          	auipc	a1,0x8
    800007de:	87e58593          	addi	a1,a1,-1922 # 80008058 <digits+0x18>
    800007e2:	00011517          	auipc	a0,0x11
    800007e6:	11650513          	addi	a0,a0,278 # 800118f8 <uart_tx_lock>
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	396080e7          	jalr	918(ra) # 80000b80 <initlock>
}
    800007f2:	60a2                	ld	ra,8(sp)
    800007f4:	6402                	ld	s0,0(sp)
    800007f6:	0141                	addi	sp,sp,16
    800007f8:	8082                	ret

00000000800007fa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
    80000804:	84aa                	mv	s1,a0
  push_off();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	3be080e7          	jalr	958(ra) # 80000bc4 <push_off>

  if(panicked){
    8000080e:	00008797          	auipc	a5,0x8
    80000812:	7f27a783          	lw	a5,2034(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000816:	10000737          	lui	a4,0x10000
  if(panicked){
    8000081a:	c391                	beqz	a5,8000081e <uartputc_sync+0x24>
    for(;;)
    8000081c:	a001                	j	8000081c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000822:	0ff7f793          	andi	a5,a5,255
    80000826:	0207f793          	andi	a5,a5,32
    8000082a:	dbf5                	beqz	a5,8000081e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000082c:	0ff4f793          	andi	a5,s1,255
    80000830:	10000737          	lui	a4,0x10000
    80000834:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	42c080e7          	jalr	1068(ra) # 80000c64 <pop_off>
}
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084a:	00008797          	auipc	a5,0x8
    8000084e:	7ba7a783          	lw	a5,1978(a5) # 80009004 <uart_tx_r>
    80000852:	00008717          	auipc	a4,0x8
    80000856:	7b672703          	lw	a4,1974(a4) # 80009008 <uart_tx_w>
    8000085a:	08f70263          	beq	a4,a5,800008de <uartstart+0x94>
{
    8000085e:	7139                	addi	sp,sp,-64
    80000860:	fc06                	sd	ra,56(sp)
    80000862:	f822                	sd	s0,48(sp)
    80000864:	f426                	sd	s1,40(sp)
    80000866:	f04a                	sd	s2,32(sp)
    80000868:	ec4e                	sd	s3,24(sp)
    8000086a:	e852                	sd	s4,16(sp)
    8000086c:	e456                	sd	s5,8(sp)
    8000086e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000870:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000874:	00011a17          	auipc	s4,0x11
    80000878:	084a0a13          	addi	s4,s4,132 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000087c:	00008497          	auipc	s1,0x8
    80000880:	78848493          	addi	s1,s1,1928 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000884:	00008997          	auipc	s3,0x8
    80000888:	78498993          	addi	s3,s3,1924 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000088c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000890:	0ff77713          	andi	a4,a4,255
    80000894:	02077713          	andi	a4,a4,32
    80000898:	cb15                	beqz	a4,800008cc <uartstart+0x82>
    int c = uart_tx_buf[uart_tx_r];
    8000089a:	00fa0733          	add	a4,s4,a5
    8000089e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008a2:	2785                	addiw	a5,a5,1
    800008a4:	41f7d71b          	sraiw	a4,a5,0x1f
    800008a8:	01b7571b          	srliw	a4,a4,0x1b
    800008ac:	9fb9                	addw	a5,a5,a4
    800008ae:	8bfd                	andi	a5,a5,31
    800008b0:	9f99                	subw	a5,a5,a4
    800008b2:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b4:	8526                	mv	a0,s1
    800008b6:	00002097          	auipc	ra,0x2
    800008ba:	af8080e7          	jalr	-1288(ra) # 800023ae <wakeup>
    
    WriteReg(THR, c);
    800008be:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008c2:	409c                	lw	a5,0(s1)
    800008c4:	0009a703          	lw	a4,0(s3)
    800008c8:	fcf712e3          	bne	a4,a5,8000088c <uartstart+0x42>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	addi	sp,sp,64
    800008dc:	8082                	ret
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008f2:	00011517          	auipc	a0,0x11
    800008f6:	00650513          	addi	a0,a0,6 # 800118f8 <uart_tx_lock>
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	316080e7          	jalr	790(ra) # 80000c10 <acquire>
  if(panicked){
    80000902:	00008797          	auipc	a5,0x8
    80000906:	6fe7a783          	lw	a5,1790(a5) # 80009000 <panicked>
    8000090a:	c391                	beqz	a5,8000090e <uartputc+0x2e>
    for(;;)
    8000090c:	a001                	j	8000090c <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000090e:	00008717          	auipc	a4,0x8
    80000912:	6fa72703          	lw	a4,1786(a4) # 80009008 <uart_tx_w>
    80000916:	0017079b          	addiw	a5,a4,1
    8000091a:	41f7d69b          	sraiw	a3,a5,0x1f
    8000091e:	01b6d69b          	srliw	a3,a3,0x1b
    80000922:	9fb5                	addw	a5,a5,a3
    80000924:	8bfd                	andi	a5,a5,31
    80000926:	9f95                	subw	a5,a5,a3
    80000928:	00008697          	auipc	a3,0x8
    8000092c:	6dc6a683          	lw	a3,1756(a3) # 80009004 <uart_tx_r>
    80000930:	04f69263          	bne	a3,a5,80000974 <uartputc+0x94>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000934:	00011a17          	auipc	s4,0x11
    80000938:	fc4a0a13          	addi	s4,s4,-60 # 800118f8 <uart_tx_lock>
    8000093c:	00008497          	auipc	s1,0x8
    80000940:	6c848493          	addi	s1,s1,1736 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000944:	00008917          	auipc	s2,0x8
    80000948:	6c490913          	addi	s2,s2,1732 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000094c:	85d2                	mv	a1,s4
    8000094e:	8526                	mv	a0,s1
    80000950:	00002097          	auipc	ra,0x2
    80000954:	8d8080e7          	jalr	-1832(ra) # 80002228 <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000958:	00092703          	lw	a4,0(s2)
    8000095c:	0017079b          	addiw	a5,a4,1
    80000960:	41f7d69b          	sraiw	a3,a5,0x1f
    80000964:	01b6d69b          	srliw	a3,a3,0x1b
    80000968:	9fb5                	addw	a5,a5,a3
    8000096a:	8bfd                	andi	a5,a5,31
    8000096c:	9f95                	subw	a5,a5,a3
    8000096e:	4094                	lw	a3,0(s1)
    80000970:	fcf68ee3          	beq	a3,a5,8000094c <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000974:	00011497          	auipc	s1,0x11
    80000978:	f8448493          	addi	s1,s1,-124 # 800118f8 <uart_tx_lock>
    8000097c:	9726                	add	a4,a4,s1
    8000097e:	01370c23          	sb	s3,24(a4)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000982:	00008717          	auipc	a4,0x8
    80000986:	68f72323          	sw	a5,1670(a4) # 80009008 <uart_tx_w>
      uartstart();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	ec0080e7          	jalr	-320(ra) # 8000084a <uartstart>
      release(&uart_tx_lock);
    80000992:	8526                	mv	a0,s1
    80000994:	00000097          	auipc	ra,0x0
    80000998:	330080e7          	jalr	816(ra) # 80000cc4 <release>
}
    8000099c:	70a2                	ld	ra,40(sp)
    8000099e:	7402                	ld	s0,32(sp)
    800009a0:	64e2                	ld	s1,24(sp)
    800009a2:	6942                	ld	s2,16(sp)
    800009a4:	69a2                	ld	s3,8(sp)
    800009a6:	6a02                	ld	s4,0(sp)
    800009a8:	6145                	addi	sp,sp,48
    800009aa:	8082                	ret

00000000800009ac <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ac:	1141                	addi	sp,sp,-16
    800009ae:	e422                	sd	s0,8(sp)
    800009b0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009b2:	100007b7          	lui	a5,0x10000
    800009b6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ba:	8b85                	andi	a5,a5,1
    800009bc:	cb91                	beqz	a5,800009d0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009be:	100007b7          	lui	a5,0x10000
    800009c2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009c6:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009ca:	6422                	ld	s0,8(sp)
    800009cc:	0141                	addi	sp,sp,16
    800009ce:	8082                	ret
    return -1;
    800009d0:	557d                	li	a0,-1
    800009d2:	bfe5                	j	800009ca <uartgetc+0x1e>

00000000800009d4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009de:	54fd                	li	s1,-1
    int c = uartgetc();
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	fcc080e7          	jalr	-52(ra) # 800009ac <uartgetc>
    if(c == -1)
    800009e8:	00950763          	beq	a0,s1,800009f6 <uartintr+0x22>
      break;
    consoleintr(c);
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	8dc080e7          	jalr	-1828(ra) # 800002c8 <consoleintr>
  while(1){
    800009f4:	b7f5                	j	800009e0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009f6:	00011497          	auipc	s1,0x11
    800009fa:	f0248493          	addi	s1,s1,-254 # 800118f8 <uart_tx_lock>
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	210080e7          	jalr	528(ra) # 80000c10 <acquire>
  uartstart();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	e42080e7          	jalr	-446(ra) # 8000084a <uartstart>
  release(&uart_tx_lock);
    80000a10:	8526                	mv	a0,s1
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	2b2080e7          	jalr	690(ra) # 80000cc4 <release>
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6105                	addi	sp,sp,32
    80000a22:	8082                	ret

0000000080000a24 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	e04a                	sd	s2,0(sp)
    80000a2e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a30:	03451793          	slli	a5,a0,0x34
    80000a34:	ebb9                	bnez	a5,80000a8a <kfree+0x66>
    80000a36:	84aa                	mv	s1,a0
    80000a38:	00025797          	auipc	a5,0x25
    80000a3c:	5c878793          	addi	a5,a5,1480 # 80026000 <end>
    80000a40:	04f56563          	bltu	a0,a5,80000a8a <kfree+0x66>
    80000a44:	47c5                	li	a5,17
    80000a46:	07ee                	slli	a5,a5,0x1b
    80000a48:	04f57163          	bgeu	a0,a5,80000a8a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a4c:	6605                	lui	a2,0x1
    80000a4e:	4585                	li	a1,1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	2bc080e7          	jalr	700(ra) # 80000d0c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a58:	00011917          	auipc	s2,0x11
    80000a5c:	ed890913          	addi	s2,s2,-296 # 80011930 <kmem>
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	1ae080e7          	jalr	430(ra) # 80000c10 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	24e080e7          	jalr	590(ra) # 80000cc4 <release>
}
    80000a7e:	60e2                	ld	ra,24(sp)
    80000a80:	6442                	ld	s0,16(sp)
    80000a82:	64a2                	ld	s1,8(sp)
    80000a84:	6902                	ld	s2,0(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret
    panic("kfree");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	5d650513          	addi	a0,a0,1494 # 80008060 <digits+0x20>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	ab6080e7          	jalr	-1354(ra) # 80000548 <panic>

0000000080000a9a <freerange>:
{
    80000a9a:	7179                	addi	sp,sp,-48
    80000a9c:	f406                	sd	ra,40(sp)
    80000a9e:	f022                	sd	s0,32(sp)
    80000aa0:	ec26                	sd	s1,24(sp)
    80000aa2:	e84a                	sd	s2,16(sp)
    80000aa4:	e44e                	sd	s3,8(sp)
    80000aa6:	e052                	sd	s4,0(sp)
    80000aa8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aaa:	6785                	lui	a5,0x1
    80000aac:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000ab0:	94aa                	add	s1,s1,a0
    80000ab2:	757d                	lui	a0,0xfffff
    80000ab4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab6:	94be                	add	s1,s1,a5
    80000ab8:	0095ee63          	bltu	a1,s1,80000ad4 <freerange+0x3a>
    80000abc:	892e                	mv	s2,a1
    kfree(p);
    80000abe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	6985                	lui	s3,0x1
    kfree(p);
    80000ac2:	01448533          	add	a0,s1,s4
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f5e080e7          	jalr	-162(ra) # 80000a24 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94ce                	add	s1,s1,s3
    80000ad0:	fe9979e3          	bgeu	s2,s1,80000ac2 <freerange+0x28>
}
    80000ad4:	70a2                	ld	ra,40(sp)
    80000ad6:	7402                	ld	s0,32(sp)
    80000ad8:	64e2                	ld	s1,24(sp)
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
    80000ae0:	6145                	addi	sp,sp,48
    80000ae2:	8082                	ret

0000000080000ae4 <kinit>:
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aec:	00007597          	auipc	a1,0x7
    80000af0:	57c58593          	addi	a1,a1,1404 # 80008068 <digits+0x28>
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	e3c50513          	addi	a0,a0,-452 # 80011930 <kmem>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	084080e7          	jalr	132(ra) # 80000b80 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b04:	45c5                	li	a1,17
    80000b06:	05ee                	slli	a1,a1,0x1b
    80000b08:	00025517          	auipc	a0,0x25
    80000b0c:	4f850513          	addi	a0,a0,1272 # 80026000 <end>
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	f8a080e7          	jalr	-118(ra) # 80000a9a <freerange>
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret

0000000080000b20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b20:	1101                	addi	sp,sp,-32
    80000b22:	ec06                	sd	ra,24(sp)
    80000b24:	e822                	sd	s0,16(sp)
    80000b26:	e426                	sd	s1,8(sp)
    80000b28:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2a:	00011497          	auipc	s1,0x11
    80000b2e:	e0648493          	addi	s1,s1,-506 # 80011930 <kmem>
    80000b32:	8526                	mv	a0,s1
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	0dc080e7          	jalr	220(ra) # 80000c10 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c885                	beqz	s1,80000b6e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00011517          	auipc	a0,0x11
    80000b46:	dee50513          	addi	a0,a0,-530 # 80011930 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	178080e7          	jalr	376(ra) # 80000cc4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	1b2080e7          	jalr	434(ra) # 80000d0c <memset>
  return (void*)r;
}
    80000b62:	8526                	mv	a0,s1
    80000b64:	60e2                	ld	ra,24(sp)
    80000b66:	6442                	ld	s0,16(sp)
    80000b68:	64a2                	ld	s1,8(sp)
    80000b6a:	6105                	addi	sp,sp,32
    80000b6c:	8082                	ret
  release(&kmem.lock);
    80000b6e:	00011517          	auipc	a0,0x11
    80000b72:	dc250513          	addi	a0,a0,-574 # 80011930 <kmem>
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	14e080e7          	jalr	334(ra) # 80000cc4 <release>
  if(r)
    80000b7e:	b7d5                	j	80000b62 <kalloc+0x42>

0000000080000b80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b80:	1141                	addi	sp,sp,-16
    80000b82:	e422                	sd	s0,8(sp)
    80000b84:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b86:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b88:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8c:	00053823          	sd	zero,16(a0)
}
    80000b90:	6422                	ld	s0,8(sp)
    80000b92:	0141                	addi	sp,sp,16
    80000b94:	8082                	ret

0000000080000b96 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b96:	411c                	lw	a5,0(a0)
    80000b98:	e399                	bnez	a5,80000b9e <holding+0x8>
    80000b9a:	4501                	li	a0,0
  return r;
}
    80000b9c:	8082                	ret
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba8:	6904                	ld	s1,16(a0)
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	e52080e7          	jalr	-430(ra) # 800019fc <mycpu>
    80000bb2:	40a48533          	sub	a0,s1,a0
    80000bb6:	00153513          	seqz	a0,a0
}
    80000bba:	60e2                	ld	ra,24(sp)
    80000bbc:	6442                	ld	s0,16(sp)
    80000bbe:	64a2                	ld	s1,8(sp)
    80000bc0:	6105                	addi	sp,sp,32
    80000bc2:	8082                	ret

0000000080000bc4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc4:	1101                	addi	sp,sp,-32
    80000bc6:	ec06                	sd	ra,24(sp)
    80000bc8:	e822                	sd	s0,16(sp)
    80000bca:	e426                	sd	s1,8(sp)
    80000bcc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bce:	100024f3          	csrr	s1,sstatus
    80000bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bdc:	00001097          	auipc	ra,0x1
    80000be0:	e20080e7          	jalr	-480(ra) # 800019fc <mycpu>
    80000be4:	5d3c                	lw	a5,120(a0)
    80000be6:	cf89                	beqz	a5,80000c00 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be8:	00001097          	auipc	ra,0x1
    80000bec:	e14080e7          	jalr	-492(ra) # 800019fc <mycpu>
    80000bf0:	5d3c                	lw	a5,120(a0)
    80000bf2:	2785                	addiw	a5,a5,1
    80000bf4:	dd3c                	sw	a5,120(a0)
}
    80000bf6:	60e2                	ld	ra,24(sp)
    80000bf8:	6442                	ld	s0,16(sp)
    80000bfa:	64a2                	ld	s1,8(sp)
    80000bfc:	6105                	addi	sp,sp,32
    80000bfe:	8082                	ret
    mycpu()->intena = old;
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	dfc080e7          	jalr	-516(ra) # 800019fc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c08:	8085                	srli	s1,s1,0x1
    80000c0a:	8885                	andi	s1,s1,1
    80000c0c:	dd64                	sw	s1,124(a0)
    80000c0e:	bfe9                	j	80000be8 <push_off+0x24>

0000000080000c10 <acquire>:
{
    80000c10:	1101                	addi	sp,sp,-32
    80000c12:	ec06                	sd	ra,24(sp)
    80000c14:	e822                	sd	s0,16(sp)
    80000c16:	e426                	sd	s1,8(sp)
    80000c18:	1000                	addi	s0,sp,32
    80000c1a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	fa8080e7          	jalr	-88(ra) # 80000bc4 <push_off>
  if(holding(lk))
    80000c24:	8526                	mv	a0,s1
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	f70080e7          	jalr	-144(ra) # 80000b96 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c2e:	4705                	li	a4,1
  if(holding(lk))
    80000c30:	e115                	bnez	a0,80000c54 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c32:	87ba                	mv	a5,a4
    80000c34:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c38:	2781                	sext.w	a5,a5
    80000c3a:	ffe5                	bnez	a5,80000c32 <acquire+0x22>
  __sync_synchronize();
    80000c3c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c40:	00001097          	auipc	ra,0x1
    80000c44:	dbc080e7          	jalr	-580(ra) # 800019fc <mycpu>
    80000c48:	e888                	sd	a0,16(s1)
}
    80000c4a:	60e2                	ld	ra,24(sp)
    80000c4c:	6442                	ld	s0,16(sp)
    80000c4e:	64a2                	ld	s1,8(sp)
    80000c50:	6105                	addi	sp,sp,32
    80000c52:	8082                	ret
    panic("acquire");
    80000c54:	00007517          	auipc	a0,0x7
    80000c58:	41c50513          	addi	a0,a0,1052 # 80008070 <digits+0x30>
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	8ec080e7          	jalr	-1812(ra) # 80000548 <panic>

0000000080000c64 <pop_off>:

void
pop_off(void)
{
    80000c64:	1141                	addi	sp,sp,-16
    80000c66:	e406                	sd	ra,8(sp)
    80000c68:	e022                	sd	s0,0(sp)
    80000c6a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c6c:	00001097          	auipc	ra,0x1
    80000c70:	d90080e7          	jalr	-624(ra) # 800019fc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c78:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7a:	e78d                	bnez	a5,80000ca4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c7c:	5d3c                	lw	a5,120(a0)
    80000c7e:	02f05b63          	blez	a5,80000cb4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c82:	37fd                	addiw	a5,a5,-1
    80000c84:	0007871b          	sext.w	a4,a5
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb09                	bnez	a4,80000c9c <pop_off+0x38>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3d450513          	addi	a0,a0,980 # 80008078 <digits+0x38>
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	89c080e7          	jalr	-1892(ra) # 80000548 <panic>
    panic("pop_off");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3dc50513          	addi	a0,a0,988 # 80008090 <digits+0x50>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	88c080e7          	jalr	-1908(ra) # 80000548 <panic>

0000000080000cc4 <release>:
{
    80000cc4:	1101                	addi	sp,sp,-32
    80000cc6:	ec06                	sd	ra,24(sp)
    80000cc8:	e822                	sd	s0,16(sp)
    80000cca:	e426                	sd	s1,8(sp)
    80000ccc:	1000                	addi	s0,sp,32
    80000cce:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	ec6080e7          	jalr	-314(ra) # 80000b96 <holding>
    80000cd8:	c115                	beqz	a0,80000cfc <release+0x38>
  lk->cpu = 0;
    80000cda:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cde:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ce2:	0f50000f          	fence	iorw,ow
    80000ce6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	f7a080e7          	jalr	-134(ra) # 80000c64 <pop_off>
}
    80000cf2:	60e2                	ld	ra,24(sp)
    80000cf4:	6442                	ld	s0,16(sp)
    80000cf6:	64a2                	ld	s1,8(sp)
    80000cf8:	6105                	addi	sp,sp,32
    80000cfa:	8082                	ret
    panic("release");
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	39c50513          	addi	a0,a0,924 # 80008098 <digits+0x58>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	844080e7          	jalr	-1980(ra) # 80000548 <panic>

0000000080000d0c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d0c:	1141                	addi	sp,sp,-16
    80000d0e:	e422                	sd	s0,8(sp)
    80000d10:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d12:	ce09                	beqz	a2,80000d2c <memset+0x20>
    80000d14:	87aa                	mv	a5,a0
    80000d16:	fff6071b          	addiw	a4,a2,-1
    80000d1a:	1702                	slli	a4,a4,0x20
    80000d1c:	9301                	srli	a4,a4,0x20
    80000d1e:	0705                	addi	a4,a4,1
    80000d20:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d22:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d26:	0785                	addi	a5,a5,1
    80000d28:	fee79de3          	bne	a5,a4,80000d22 <memset+0x16>
  }
  return dst;
}
    80000d2c:	6422                	ld	s0,8(sp)
    80000d2e:	0141                	addi	sp,sp,16
    80000d30:	8082                	ret

0000000080000d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d38:	ca05                	beqz	a2,80000d68 <memcmp+0x36>
    80000d3a:	fff6069b          	addiw	a3,a2,-1
    80000d3e:	1682                	slli	a3,a3,0x20
    80000d40:	9281                	srli	a3,a3,0x20
    80000d42:	0685                	addi	a3,a3,1
    80000d44:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d46:	00054783          	lbu	a5,0(a0)
    80000d4a:	0005c703          	lbu	a4,0(a1)
    80000d4e:	00e79863          	bne	a5,a4,80000d5e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d56:	fed518e3          	bne	a0,a3,80000d46 <memcmp+0x14>
  }

  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	a019                	j	80000d62 <memcmp+0x30>
      return *s1 - *s2;
    80000d5e:	40e7853b          	subw	a0,a5,a4
}
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret
  return 0;
    80000d68:	4501                	li	a0,0
    80000d6a:	bfe5                	j	80000d62 <memcmp+0x30>

0000000080000d6c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d72:	00a5f963          	bgeu	a1,a0,80000d84 <memmove+0x18>
    80000d76:	02061713          	slli	a4,a2,0x20
    80000d7a:	9301                	srli	a4,a4,0x20
    80000d7c:	00e587b3          	add	a5,a1,a4
    80000d80:	02f56563          	bltu	a0,a5,80000daa <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d84:	fff6069b          	addiw	a3,a2,-1
    80000d88:	ce11                	beqz	a2,80000da4 <memmove+0x38>
    80000d8a:	1682                	slli	a3,a3,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	0685                	addi	a3,a3,1
    80000d90:	96ae                	add	a3,a3,a1
    80000d92:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d94:	0585                	addi	a1,a1,1
    80000d96:	0785                	addi	a5,a5,1
    80000d98:	fff5c703          	lbu	a4,-1(a1)
    80000d9c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000da0:	fed59ae3          	bne	a1,a3,80000d94 <memmove+0x28>

  return dst;
}
    80000da4:	6422                	ld	s0,8(sp)
    80000da6:	0141                	addi	sp,sp,16
    80000da8:	8082                	ret
    d += n;
    80000daa:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dac:	fff6069b          	addiw	a3,a2,-1
    80000db0:	da75                	beqz	a2,80000da4 <memmove+0x38>
    80000db2:	02069613          	slli	a2,a3,0x20
    80000db6:	9201                	srli	a2,a2,0x20
    80000db8:	fff64613          	not	a2,a2
    80000dbc:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000dbe:	17fd                	addi	a5,a5,-1
    80000dc0:	177d                	addi	a4,a4,-1
    80000dc2:	0007c683          	lbu	a3,0(a5)
    80000dc6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dca:	fec79ae3          	bne	a5,a2,80000dbe <memmove+0x52>
    80000dce:	bfd9                	j	80000da4 <memmove+0x38>

0000000080000dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e406                	sd	ra,8(sp)
    80000dd4:	e022                	sd	s0,0(sp)
    80000dd6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f94080e7          	jalr	-108(ra) # 80000d6c <memmove>
}
    80000de0:	60a2                	ld	ra,8(sp)
    80000de2:	6402                	ld	s0,0(sp)
    80000de4:	0141                	addi	sp,sp,16
    80000de6:	8082                	ret

0000000080000de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000de8:	1141                	addi	sp,sp,-16
    80000dea:	e422                	sd	s0,8(sp)
    80000dec:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dee:	ce11                	beqz	a2,80000e0a <strncmp+0x22>
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf89                	beqz	a5,80000e0e <strncmp+0x26>
    80000df6:	0005c703          	lbu	a4,0(a1)
    80000dfa:	00f71a63          	bne	a4,a5,80000e0e <strncmp+0x26>
    n--, p++, q++;
    80000dfe:	367d                	addiw	a2,a2,-1
    80000e00:	0505                	addi	a0,a0,1
    80000e02:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e04:	f675                	bnez	a2,80000df0 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e06:	4501                	li	a0,0
    80000e08:	a809                	j	80000e1a <strncmp+0x32>
    80000e0a:	4501                	li	a0,0
    80000e0c:	a039                	j	80000e1a <strncmp+0x32>
  if(n == 0)
    80000e0e:	ca09                	beqz	a2,80000e20 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e10:	00054503          	lbu	a0,0(a0)
    80000e14:	0005c783          	lbu	a5,0(a1)
    80000e18:	9d1d                	subw	a0,a0,a5
}
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret
    return 0;
    80000e20:	4501                	li	a0,0
    80000e22:	bfe5                	j	80000e1a <strncmp+0x32>

0000000080000e24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e422                	sd	s0,8(sp)
    80000e28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e2a:	872a                	mv	a4,a0
    80000e2c:	8832                	mv	a6,a2
    80000e2e:	367d                	addiw	a2,a2,-1
    80000e30:	01005963          	blez	a6,80000e42 <strncpy+0x1e>
    80000e34:	0705                	addi	a4,a4,1
    80000e36:	0005c783          	lbu	a5,0(a1)
    80000e3a:	fef70fa3          	sb	a5,-1(a4)
    80000e3e:	0585                	addi	a1,a1,1
    80000e40:	f7f5                	bnez	a5,80000e2c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e42:	00c05d63          	blez	a2,80000e5c <strncpy+0x38>
    80000e46:	86ba                	mv	a3,a4
    *s++ = 0;
    80000e48:	0685                	addi	a3,a3,1
    80000e4a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e4e:	fff6c793          	not	a5,a3
    80000e52:	9fb9                	addw	a5,a5,a4
    80000e54:	010787bb          	addw	a5,a5,a6
    80000e58:	fef048e3          	bgtz	a5,80000e48 <strncpy+0x24>
  return os;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e68:	02c05363          	blez	a2,80000e8e <safestrcpy+0x2c>
    80000e6c:	fff6069b          	addiw	a3,a2,-1
    80000e70:	1682                	slli	a3,a3,0x20
    80000e72:	9281                	srli	a3,a3,0x20
    80000e74:	96ae                	add	a3,a3,a1
    80000e76:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e78:	00d58963          	beq	a1,a3,80000e8a <safestrcpy+0x28>
    80000e7c:	0585                	addi	a1,a1,1
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	fff5c703          	lbu	a4,-1(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	fb65                	bnez	a4,80000e78 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e8a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <strlen>:

int
strlen(const char *s)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e9a:	00054783          	lbu	a5,0(a0)
    80000e9e:	cf91                	beqz	a5,80000eba <strlen+0x26>
    80000ea0:	0505                	addi	a0,a0,1
    80000ea2:	87aa                	mv	a5,a0
    80000ea4:	4685                	li	a3,1
    80000ea6:	9e89                	subw	a3,a3,a0
    80000ea8:	00f6853b          	addw	a0,a3,a5
    80000eac:	0785                	addi	a5,a5,1
    80000eae:	fff7c703          	lbu	a4,-1(a5)
    80000eb2:	fb7d                	bnez	a4,80000ea8 <strlen+0x14>
    ;
  return n;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eba:	4501                	li	a0,0
    80000ebc:	bfe5                	j	80000eb4 <strlen+0x20>

0000000080000ebe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ebe:	1141                	addi	sp,sp,-16
    80000ec0:	e406                	sd	ra,8(sp)
    80000ec2:	e022                	sd	s0,0(sp)
    80000ec4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	b26080e7          	jalr	-1242(ra) # 800019ec <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ece:	00008717          	auipc	a4,0x8
    80000ed2:	13e70713          	addi	a4,a4,318 # 8000900c <started>
  if(cpuid() == 0){
    80000ed6:	c139                	beqz	a0,80000f1c <main+0x5e>
    while(started == 0)
    80000ed8:	431c                	lw	a5,0(a4)
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	dff5                	beqz	a5,80000ed8 <main+0x1a>
      ;
    __sync_synchronize();
    80000ede:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee2:	00001097          	auipc	ra,0x1
    80000ee6:	b0a080e7          	jalr	-1270(ra) # 800019ec <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1cc50513          	addi	a0,a0,460 # 800080b8 <digits+0x78>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	69e080e7          	jalr	1694(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	0d8080e7          	jalr	216(ra) # 80000fd4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	7ae080e7          	jalr	1966(ra) # 800026b2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	e14080e7          	jalr	-492(ra) # 80005d20 <plicinithart>
  }

  scheduler();        
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	034080e7          	jalr	52(ra) # 80001f48 <scheduler>
    consoleinit();
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	53e080e7          	jalr	1342(ra) # 8000045a <consoleinit>
    printfinit();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	854080e7          	jalr	-1964(ra) # 80000778 <printfinit>
    printf("\n");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	19c50513          	addi	a0,a0,412 # 800080c8 <digits+0x88>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	65e080e7          	jalr	1630(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	16450513          	addi	a0,a0,356 # 800080a0 <digits+0x60>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	64e080e7          	jalr	1614(ra) # 80000592 <printf>
    printf("\n");
    80000f4c:	00007517          	auipc	a0,0x7
    80000f50:	17c50513          	addi	a0,a0,380 # 800080c8 <digits+0x88>
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	63e080e7          	jalr	1598(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	b88080e7          	jalr	-1144(ra) # 80000ae4 <kinit>
    kvminit();       // create kernel page table
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	314080e7          	jalr	788(ra) # 80001278 <kvminit>
    kvminithart();   // turn on paging
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	068080e7          	jalr	104(ra) # 80000fd4 <kvminithart>
    procinit();      // process table
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	9a8080e7          	jalr	-1624(ra) # 8000191c <procinit>
    trapinit();      // trap vectors
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	70e080e7          	jalr	1806(ra) # 8000268a <trapinit>
    trapinithart();  // install kernel trap vector
    80000f84:	00001097          	auipc	ra,0x1
    80000f88:	72e080e7          	jalr	1838(ra) # 800026b2 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	d7e080e7          	jalr	-642(ra) # 80005d0a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	d8c080e7          	jalr	-628(ra) # 80005d20 <plicinithart>
    binit();         // buffer cache
    80000f9c:	00002097          	auipc	ra,0x2
    80000fa0:	f24080e7          	jalr	-220(ra) # 80002ec0 <binit>
    iinit();         // inode cache
    80000fa4:	00002097          	auipc	ra,0x2
    80000fa8:	5b4080e7          	jalr	1460(ra) # 80003558 <iinit>
    fileinit();      // file table
    80000fac:	00003097          	auipc	ra,0x3
    80000fb0:	552080e7          	jalr	1362(ra) # 800044fe <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	e74080e7          	jalr	-396(ra) # 80005e28 <virtio_disk_init>
    userinit();      // first user process
    80000fbc:	00001097          	auipc	ra,0x1
    80000fc0:	d26080e7          	jalr	-730(ra) # 80001ce2 <userinit>
    __sync_synchronize();
    80000fc4:	0ff0000f          	fence
    started = 1;
    80000fc8:	4785                	li	a5,1
    80000fca:	00008717          	auipc	a4,0x8
    80000fce:	04f72123          	sw	a5,66(a4) # 8000900c <started>
    80000fd2:	b789                	j	80000f14 <main+0x56>

0000000080000fd4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fd4:	1141                	addi	sp,sp,-16
    80000fd6:	e422                	sd	s0,8(sp)
    80000fd8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	0367b783          	ld	a5,54(a5) # 80009010 <kernel_pagetable>
    80000fe2:	83b1                	srli	a5,a5,0xc
    80000fe4:	577d                	li	a4,-1
    80000fe6:	177e                	slli	a4,a4,0x3f
    80000fe8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fea:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  sfence_vma();
}
    80000ff2:	6422                	ld	s0,8(sp)
    80000ff4:	0141                	addi	sp,sp,16
    80000ff6:	8082                	ret

0000000080000ff8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ff8:	7139                	addi	sp,sp,-64
    80000ffa:	fc06                	sd	ra,56(sp)
    80000ffc:	f822                	sd	s0,48(sp)
    80000ffe:	f426                	sd	s1,40(sp)
    80001000:	f04a                	sd	s2,32(sp)
    80001002:	ec4e                	sd	s3,24(sp)
    80001004:	e852                	sd	s4,16(sp)
    80001006:	e456                	sd	s5,8(sp)
    80001008:	e05a                	sd	s6,0(sp)
    8000100a:	0080                	addi	s0,sp,64
    8000100c:	84aa                	mv	s1,a0
    8000100e:	89ae                	mv	s3,a1
    80001010:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001012:	57fd                	li	a5,-1
    80001014:	83e9                	srli	a5,a5,0x1a
    80001016:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001018:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000101a:	04b7f263          	bgeu	a5,a1,8000105e <walk+0x66>
    panic("walk");
    8000101e:	00007517          	auipc	a0,0x7
    80001022:	0b250513          	addi	a0,a0,178 # 800080d0 <digits+0x90>
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	522080e7          	jalr	1314(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000102e:	060a8663          	beqz	s5,8000109a <walk+0xa2>
    80001032:	00000097          	auipc	ra,0x0
    80001036:	aee080e7          	jalr	-1298(ra) # 80000b20 <kalloc>
    8000103a:	84aa                	mv	s1,a0
    8000103c:	c529                	beqz	a0,80001086 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000103e:	6605                	lui	a2,0x1
    80001040:	4581                	li	a1,0
    80001042:	00000097          	auipc	ra,0x0
    80001046:	cca080e7          	jalr	-822(ra) # 80000d0c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000104a:	00c4d793          	srli	a5,s1,0xc
    8000104e:	07aa                	slli	a5,a5,0xa
    80001050:	0017e793          	ori	a5,a5,1
    80001054:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001058:	3a5d                	addiw	s4,s4,-9
    8000105a:	036a0063          	beq	s4,s6,8000107a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000105e:	0149d933          	srl	s2,s3,s4
    80001062:	1ff97913          	andi	s2,s2,511
    80001066:	090e                	slli	s2,s2,0x3
    80001068:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000106a:	00093483          	ld	s1,0(s2)
    8000106e:	0014f793          	andi	a5,s1,1
    80001072:	dfd5                	beqz	a5,8000102e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001074:	80a9                	srli	s1,s1,0xa
    80001076:	04b2                	slli	s1,s1,0xc
    80001078:	b7c5                	j	80001058 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000107a:	00c9d513          	srli	a0,s3,0xc
    8000107e:	1ff57513          	andi	a0,a0,511
    80001082:	050e                	slli	a0,a0,0x3
    80001084:	9526                	add	a0,a0,s1
}
    80001086:	70e2                	ld	ra,56(sp)
    80001088:	7442                	ld	s0,48(sp)
    8000108a:	74a2                	ld	s1,40(sp)
    8000108c:	7902                	ld	s2,32(sp)
    8000108e:	69e2                	ld	s3,24(sp)
    80001090:	6a42                	ld	s4,16(sp)
    80001092:	6aa2                	ld	s5,8(sp)
    80001094:	6b02                	ld	s6,0(sp)
    80001096:	6121                	addi	sp,sp,64
    80001098:	8082                	ret
        return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7ed                	j	80001086 <walk+0x8e>

000000008000109e <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    8000109e:	1101                	addi	sp,sp,-32
    800010a0:	ec06                	sd	ra,24(sp)
    800010a2:	e822                	sd	s0,16(sp)
    800010a4:	e426                	sd	s1,8(sp)
    800010a6:	1000                	addi	s0,sp,32
    800010a8:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010aa:	1552                	slli	a0,a0,0x34
    800010ac:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    800010b0:	4601                	li	a2,0
    800010b2:	00008517          	auipc	a0,0x8
    800010b6:	f5e53503          	ld	a0,-162(a0) # 80009010 <kernel_pagetable>
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	f3e080e7          	jalr	-194(ra) # 80000ff8 <walk>
  if(pte == 0)
    800010c2:	cd09                	beqz	a0,800010dc <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    800010c4:	6108                	ld	a0,0(a0)
    800010c6:	00157793          	andi	a5,a0,1
    800010ca:	c38d                	beqz	a5,800010ec <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    800010cc:	8129                	srli	a0,a0,0xa
    800010ce:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    800010d0:	9526                	add	a0,a0,s1
    800010d2:	60e2                	ld	ra,24(sp)
    800010d4:	6442                	ld	s0,16(sp)
    800010d6:	64a2                	ld	s1,8(sp)
    800010d8:	6105                	addi	sp,sp,32
    800010da:	8082                	ret
    panic("kvmpa");
    800010dc:	00007517          	auipc	a0,0x7
    800010e0:	ffc50513          	addi	a0,a0,-4 # 800080d8 <digits+0x98>
    800010e4:	fffff097          	auipc	ra,0xfffff
    800010e8:	464080e7          	jalr	1124(ra) # 80000548 <panic>
    panic("kvmpa");
    800010ec:	00007517          	auipc	a0,0x7
    800010f0:	fec50513          	addi	a0,a0,-20 # 800080d8 <digits+0x98>
    800010f4:	fffff097          	auipc	ra,0xfffff
    800010f8:	454080e7          	jalr	1108(ra) # 80000548 <panic>

00000000800010fc <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010fc:	715d                	addi	sp,sp,-80
    800010fe:	e486                	sd	ra,72(sp)
    80001100:	e0a2                	sd	s0,64(sp)
    80001102:	fc26                	sd	s1,56(sp)
    80001104:	f84a                	sd	s2,48(sp)
    80001106:	f44e                	sd	s3,40(sp)
    80001108:	f052                	sd	s4,32(sp)
    8000110a:	ec56                	sd	s5,24(sp)
    8000110c:	e85a                	sd	s6,16(sp)
    8000110e:	e45e                	sd	s7,8(sp)
    80001110:	0880                	addi	s0,sp,80
    80001112:	8aaa                	mv	s5,a0
    80001114:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001116:	777d                	lui	a4,0xfffff
    80001118:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000111c:	167d                	addi	a2,a2,-1
    8000111e:	00b609b3          	add	s3,a2,a1
    80001122:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001126:	893e                	mv	s2,a5
    80001128:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000112c:	6b85                	lui	s7,0x1
    8000112e:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001132:	4605                	li	a2,1
    80001134:	85ca                	mv	a1,s2
    80001136:	8556                	mv	a0,s5
    80001138:	00000097          	auipc	ra,0x0
    8000113c:	ec0080e7          	jalr	-320(ra) # 80000ff8 <walk>
    80001140:	c51d                	beqz	a0,8000116e <mappages+0x72>
    if(*pte & PTE_V)
    80001142:	611c                	ld	a5,0(a0)
    80001144:	8b85                	andi	a5,a5,1
    80001146:	ef81                	bnez	a5,8000115e <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001148:	80b1                	srli	s1,s1,0xc
    8000114a:	04aa                	slli	s1,s1,0xa
    8000114c:	0164e4b3          	or	s1,s1,s6
    80001150:	0014e493          	ori	s1,s1,1
    80001154:	e104                	sd	s1,0(a0)
    if(a == last)
    80001156:	03390863          	beq	s2,s3,80001186 <mappages+0x8a>
    a += PGSIZE;
    8000115a:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000115c:	bfc9                	j	8000112e <mappages+0x32>
      panic("remap");
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f8250513          	addi	a0,a0,-126 # 800080e0 <digits+0xa0>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3e2080e7          	jalr	994(ra) # 80000548 <panic>
      return -1;
    8000116e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001170:	60a6                	ld	ra,72(sp)
    80001172:	6406                	ld	s0,64(sp)
    80001174:	74e2                	ld	s1,56(sp)
    80001176:	7942                	ld	s2,48(sp)
    80001178:	79a2                	ld	s3,40(sp)
    8000117a:	7a02                	ld	s4,32(sp)
    8000117c:	6ae2                	ld	s5,24(sp)
    8000117e:	6b42                	ld	s6,16(sp)
    80001180:	6ba2                	ld	s7,8(sp)
    80001182:	6161                	addi	sp,sp,80
    80001184:	8082                	ret
  return 0;
    80001186:	4501                	li	a0,0
    80001188:	b7e5                	j	80001170 <mappages+0x74>

000000008000118a <walkaddr>:
  if(va >= MAXVA)
    8000118a:	57fd                	li	a5,-1
    8000118c:	83e9                	srli	a5,a5,0x1a
    8000118e:	00b7f463          	bgeu	a5,a1,80001196 <walkaddr+0xc>
    return 0;
    80001192:	4501                	li	a0,0
}
    80001194:	8082                	ret
{
    80001196:	7179                	addi	sp,sp,-48
    80001198:	f406                	sd	ra,40(sp)
    8000119a:	f022                	sd	s0,32(sp)
    8000119c:	ec26                	sd	s1,24(sp)
    8000119e:	e84a                	sd	s2,16(sp)
    800011a0:	e44e                	sd	s3,8(sp)
    800011a2:	1800                	addi	s0,sp,48
    800011a4:	892a                	mv	s2,a0
    800011a6:	84ae                	mv	s1,a1
  pte = walk(pagetable, va, 0);
    800011a8:	4601                	li	a2,0
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	e4e080e7          	jalr	-434(ra) # 80000ff8 <walk>
  if(pte ==0 || (*pte & PTE_V) == 0){
    800011b2:	c509                	beqz	a0,800011bc <walkaddr+0x32>
    800011b4:	611c                	ld	a5,0(a0)
    800011b6:	0017f713          	andi	a4,a5,1
    800011ba:	ef25                	bnez	a4,80001232 <walkaddr+0xa8>
    if(is_lazy(va))
    800011bc:	8526                	mv	a0,s1
    800011be:	00001097          	auipc	ra,0x1
    800011c2:	426080e7          	jalr	1062(ra) # 800025e4 <is_lazy>
    800011c6:	87aa                	mv	a5,a0
      return 0;
    800011c8:	4501                	li	a0,0
    if(is_lazy(va))
    800011ca:	eb81                	bnez	a5,800011da <walkaddr+0x50>
}
    800011cc:	70a2                	ld	ra,40(sp)
    800011ce:	7402                	ld	s0,32(sp)
    800011d0:	64e2                	ld	s1,24(sp)
    800011d2:	6942                	ld	s2,16(sp)
    800011d4:	69a2                	ld	s3,8(sp)
    800011d6:	6145                	addi	sp,sp,48
    800011d8:	8082                	ret
      char *mem = kalloc();
    800011da:	00000097          	auipc	ra,0x0
    800011de:	946080e7          	jalr	-1722(ra) # 80000b20 <kalloc>
    800011e2:	89aa                	mv	s3,a0
        return 0;
    800011e4:	4501                	li	a0,0
      if (mem ==0)
    800011e6:	fe0983e3          	beqz	s3,800011cc <walkaddr+0x42>
        memset(mem,0,PGSIZE);
    800011ea:	6605                	lui	a2,0x1
    800011ec:	4581                	li	a1,0
    800011ee:	854e                	mv	a0,s3
    800011f0:	00000097          	auipc	ra,0x0
    800011f4:	b1c080e7          	jalr	-1252(ra) # 80000d0c <memset>
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U) != 0)
    800011f8:	4779                	li	a4,30
    800011fa:	86ce                	mv	a3,s3
    800011fc:	6605                	lui	a2,0x1
    800011fe:	75fd                	lui	a1,0xfffff
    80001200:	8de5                	and	a1,a1,s1
    80001202:	854a                	mv	a0,s2
    80001204:	00000097          	auipc	ra,0x0
    80001208:	ef8080e7          	jalr	-264(ra) # 800010fc <mappages>
    8000120c:	c901                	beqz	a0,8000121c <walkaddr+0x92>
          kfree(mem);
    8000120e:	854e                	mv	a0,s3
    80001210:	00000097          	auipc	ra,0x0
    80001214:	814080e7          	jalr	-2028(ra) # 80000a24 <kfree>
          return 0 ;
    80001218:	4501                	li	a0,0
    8000121a:	bf4d                	j	800011cc <walkaddr+0x42>
        pte = walk(pagetable, va, 0);
    8000121c:	4601                	li	a2,0
    8000121e:	85a6                	mv	a1,s1
    80001220:	854a                	mv	a0,s2
    80001222:	00000097          	auipc	ra,0x0
    80001226:	dd6080e7          	jalr	-554(ra) # 80000ff8 <walk>
        return PTE2PA(*pte);
    8000122a:	6108                	ld	a0,0(a0)
    8000122c:	8129                	srli	a0,a0,0xa
    8000122e:	0532                	slli	a0,a0,0xc
    80001230:	bf71                	j	800011cc <walkaddr+0x42>
  if((*pte & PTE_U) == 0)
    80001232:	0107f513          	andi	a0,a5,16
    80001236:	d959                	beqz	a0,800011cc <walkaddr+0x42>
  pa = PTE2PA(*pte);
    80001238:	00a7d513          	srli	a0,a5,0xa
    8000123c:	0532                	slli	a0,a0,0xc
  return pa;
    8000123e:	b779                	j	800011cc <walkaddr+0x42>

0000000080001240 <kvmmap>:
{
    80001240:	1141                	addi	sp,sp,-16
    80001242:	e406                	sd	ra,8(sp)
    80001244:	e022                	sd	s0,0(sp)
    80001246:	0800                	addi	s0,sp,16
    80001248:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    8000124a:	86ae                	mv	a3,a1
    8000124c:	85aa                	mv	a1,a0
    8000124e:	00008517          	auipc	a0,0x8
    80001252:	dc253503          	ld	a0,-574(a0) # 80009010 <kernel_pagetable>
    80001256:	00000097          	auipc	ra,0x0
    8000125a:	ea6080e7          	jalr	-346(ra) # 800010fc <mappages>
    8000125e:	e509                	bnez	a0,80001268 <kvmmap+0x28>
}
    80001260:	60a2                	ld	ra,8(sp)
    80001262:	6402                	ld	s0,0(sp)
    80001264:	0141                	addi	sp,sp,16
    80001266:	8082                	ret
    panic("kvmmap");
    80001268:	00007517          	auipc	a0,0x7
    8000126c:	e8050513          	addi	a0,a0,-384 # 800080e8 <digits+0xa8>
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	2d8080e7          	jalr	728(ra) # 80000548 <panic>

0000000080001278 <kvminit>:
{
    80001278:	1101                	addi	sp,sp,-32
    8000127a:	ec06                	sd	ra,24(sp)
    8000127c:	e822                	sd	s0,16(sp)
    8000127e:	e426                	sd	s1,8(sp)
    80001280:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    80001282:	00000097          	auipc	ra,0x0
    80001286:	89e080e7          	jalr	-1890(ra) # 80000b20 <kalloc>
    8000128a:	00008797          	auipc	a5,0x8
    8000128e:	d8a7b323          	sd	a0,-634(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    80001292:	6605                	lui	a2,0x1
    80001294:	4581                	li	a1,0
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	a76080e7          	jalr	-1418(ra) # 80000d0c <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000129e:	4699                	li	a3,6
    800012a0:	6605                	lui	a2,0x1
    800012a2:	100005b7          	lui	a1,0x10000
    800012a6:	10000537          	lui	a0,0x10000
    800012aa:	00000097          	auipc	ra,0x0
    800012ae:	f96080e7          	jalr	-106(ra) # 80001240 <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800012b2:	4699                	li	a3,6
    800012b4:	6605                	lui	a2,0x1
    800012b6:	100015b7          	lui	a1,0x10001
    800012ba:	10001537          	lui	a0,0x10001
    800012be:	00000097          	auipc	ra,0x0
    800012c2:	f82080e7          	jalr	-126(ra) # 80001240 <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    800012c6:	4699                	li	a3,6
    800012c8:	6641                	lui	a2,0x10
    800012ca:	020005b7          	lui	a1,0x2000
    800012ce:	02000537          	lui	a0,0x2000
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	f6e080e7          	jalr	-146(ra) # 80001240 <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800012da:	4699                	li	a3,6
    800012dc:	00400637          	lui	a2,0x400
    800012e0:	0c0005b7          	lui	a1,0xc000
    800012e4:	0c000537          	lui	a0,0xc000
    800012e8:	00000097          	auipc	ra,0x0
    800012ec:	f58080e7          	jalr	-168(ra) # 80001240 <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012f0:	00007497          	auipc	s1,0x7
    800012f4:	d1048493          	addi	s1,s1,-752 # 80008000 <etext>
    800012f8:	46a9                	li	a3,10
    800012fa:	80007617          	auipc	a2,0x80007
    800012fe:	d0660613          	addi	a2,a2,-762 # 8000 <_entry-0x7fff8000>
    80001302:	4585                	li	a1,1
    80001304:	05fe                	slli	a1,a1,0x1f
    80001306:	852e                	mv	a0,a1
    80001308:	00000097          	auipc	ra,0x0
    8000130c:	f38080e7          	jalr	-200(ra) # 80001240 <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001310:	4699                	li	a3,6
    80001312:	4645                	li	a2,17
    80001314:	066e                	slli	a2,a2,0x1b
    80001316:	8e05                	sub	a2,a2,s1
    80001318:	85a6                	mv	a1,s1
    8000131a:	8526                	mv	a0,s1
    8000131c:	00000097          	auipc	ra,0x0
    80001320:	f24080e7          	jalr	-220(ra) # 80001240 <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001324:	46a9                	li	a3,10
    80001326:	6605                	lui	a2,0x1
    80001328:	00006597          	auipc	a1,0x6
    8000132c:	cd858593          	addi	a1,a1,-808 # 80007000 <_trampoline>
    80001330:	04000537          	lui	a0,0x4000
    80001334:	157d                	addi	a0,a0,-1
    80001336:	0532                	slli	a0,a0,0xc
    80001338:	00000097          	auipc	ra,0x0
    8000133c:	f08080e7          	jalr	-248(ra) # 80001240 <kvmmap>
}
    80001340:	60e2                	ld	ra,24(sp)
    80001342:	6442                	ld	s0,16(sp)
    80001344:	64a2                	ld	s1,8(sp)
    80001346:	6105                	addi	sp,sp,32
    80001348:	8082                	ret

000000008000134a <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000134a:	715d                	addi	sp,sp,-80
    8000134c:	e486                	sd	ra,72(sp)
    8000134e:	e0a2                	sd	s0,64(sp)
    80001350:	fc26                	sd	s1,56(sp)
    80001352:	f84a                	sd	s2,48(sp)
    80001354:	f44e                	sd	s3,40(sp)
    80001356:	f052                	sd	s4,32(sp)
    80001358:	ec56                	sd	s5,24(sp)
    8000135a:	e85a                	sd	s6,16(sp)
    8000135c:	e45e                	sd	s7,8(sp)
    8000135e:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001360:	03459793          	slli	a5,a1,0x34
    80001364:	e795                	bnez	a5,80001390 <uvmunmap+0x46>
    80001366:	8a2a                	mv	s4,a0
    80001368:	892e                	mv	s2,a1
    8000136a:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000136c:	0632                	slli	a2,a2,0xc
    8000136e:	00b609b3          	add	s3,a2,a1
      // panic("uvmunmap: walk");
      continue;
    if((*pte & PTE_V) == 0)
      // panic("uvmunmap: not mapped");
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80001372:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001374:	6a85                	lui	s5,0x1
    80001376:	0535e963          	bltu	a1,s3,800013c8 <uvmunmap+0x7e>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000137a:	60a6                	ld	ra,72(sp)
    8000137c:	6406                	ld	s0,64(sp)
    8000137e:	74e2                	ld	s1,56(sp)
    80001380:	7942                	ld	s2,48(sp)
    80001382:	79a2                	ld	s3,40(sp)
    80001384:	7a02                	ld	s4,32(sp)
    80001386:	6ae2                	ld	s5,24(sp)
    80001388:	6b42                	ld	s6,16(sp)
    8000138a:	6ba2                	ld	s7,8(sp)
    8000138c:	6161                	addi	sp,sp,80
    8000138e:	8082                	ret
    panic("uvmunmap: not aligned");
    80001390:	00007517          	auipc	a0,0x7
    80001394:	d6050513          	addi	a0,a0,-672 # 800080f0 <digits+0xb0>
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	1b0080e7          	jalr	432(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    800013a0:	00007517          	auipc	a0,0x7
    800013a4:	d6850513          	addi	a0,a0,-664 # 80008108 <digits+0xc8>
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	1a0080e7          	jalr	416(ra) # 80000548 <panic>
      uint64 pa = PTE2PA(*pte);
    800013b0:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800013b2:	00c79513          	slli	a0,a5,0xc
    800013b6:	fffff097          	auipc	ra,0xfffff
    800013ba:	66e080e7          	jalr	1646(ra) # 80000a24 <kfree>
    *pte = 0;
    800013be:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013c2:	9956                	add	s2,s2,s5
    800013c4:	fb397be3          	bgeu	s2,s3,8000137a <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013c8:	4601                	li	a2,0
    800013ca:	85ca                	mv	a1,s2
    800013cc:	8552                	mv	a0,s4
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	c2a080e7          	jalr	-982(ra) # 80000ff8 <walk>
    800013d6:	84aa                	mv	s1,a0
    800013d8:	d56d                	beqz	a0,800013c2 <uvmunmap+0x78>
    if((*pte & PTE_V) == 0)
    800013da:	611c                	ld	a5,0(a0)
    800013dc:	0017f713          	andi	a4,a5,1
    800013e0:	d36d                	beqz	a4,800013c2 <uvmunmap+0x78>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013e2:	3ff7f713          	andi	a4,a5,1023
    800013e6:	fb770de3          	beq	a4,s7,800013a0 <uvmunmap+0x56>
    if(do_free){
    800013ea:	fc0b0ae3          	beqz	s6,800013be <uvmunmap+0x74>
    800013ee:	b7c9                	j	800013b0 <uvmunmap+0x66>

00000000800013f0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013f0:	1101                	addi	sp,sp,-32
    800013f2:	ec06                	sd	ra,24(sp)
    800013f4:	e822                	sd	s0,16(sp)
    800013f6:	e426                	sd	s1,8(sp)
    800013f8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013fa:	fffff097          	auipc	ra,0xfffff
    800013fe:	726080e7          	jalr	1830(ra) # 80000b20 <kalloc>
    80001402:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001404:	c519                	beqz	a0,80001412 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001406:	6605                	lui	a2,0x1
    80001408:	4581                	li	a1,0
    8000140a:	00000097          	auipc	ra,0x0
    8000140e:	902080e7          	jalr	-1790(ra) # 80000d0c <memset>
  return pagetable;
}
    80001412:	8526                	mv	a0,s1
    80001414:	60e2                	ld	ra,24(sp)
    80001416:	6442                	ld	s0,16(sp)
    80001418:	64a2                	ld	s1,8(sp)
    8000141a:	6105                	addi	sp,sp,32
    8000141c:	8082                	ret

000000008000141e <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    8000141e:	7179                	addi	sp,sp,-48
    80001420:	f406                	sd	ra,40(sp)
    80001422:	f022                	sd	s0,32(sp)
    80001424:	ec26                	sd	s1,24(sp)
    80001426:	e84a                	sd	s2,16(sp)
    80001428:	e44e                	sd	s3,8(sp)
    8000142a:	e052                	sd	s4,0(sp)
    8000142c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000142e:	6785                	lui	a5,0x1
    80001430:	04f67863          	bgeu	a2,a5,80001480 <uvminit+0x62>
    80001434:	8a2a                	mv	s4,a0
    80001436:	89ae                	mv	s3,a1
    80001438:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	6e6080e7          	jalr	1766(ra) # 80000b20 <kalloc>
    80001442:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001444:	6605                	lui	a2,0x1
    80001446:	4581                	li	a1,0
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	8c4080e7          	jalr	-1852(ra) # 80000d0c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001450:	4779                	li	a4,30
    80001452:	86ca                	mv	a3,s2
    80001454:	6605                	lui	a2,0x1
    80001456:	4581                	li	a1,0
    80001458:	8552                	mv	a0,s4
    8000145a:	00000097          	auipc	ra,0x0
    8000145e:	ca2080e7          	jalr	-862(ra) # 800010fc <mappages>
  memmove(mem, src, sz);
    80001462:	8626                	mv	a2,s1
    80001464:	85ce                	mv	a1,s3
    80001466:	854a                	mv	a0,s2
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	904080e7          	jalr	-1788(ra) # 80000d6c <memmove>
}
    80001470:	70a2                	ld	ra,40(sp)
    80001472:	7402                	ld	s0,32(sp)
    80001474:	64e2                	ld	s1,24(sp)
    80001476:	6942                	ld	s2,16(sp)
    80001478:	69a2                	ld	s3,8(sp)
    8000147a:	6a02                	ld	s4,0(sp)
    8000147c:	6145                	addi	sp,sp,48
    8000147e:	8082                	ret
    panic("inituvm: more than a page");
    80001480:	00007517          	auipc	a0,0x7
    80001484:	ca050513          	addi	a0,a0,-864 # 80008120 <digits+0xe0>
    80001488:	fffff097          	auipc	ra,0xfffff
    8000148c:	0c0080e7          	jalr	192(ra) # 80000548 <panic>

0000000080001490 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001490:	1101                	addi	sp,sp,-32
    80001492:	ec06                	sd	ra,24(sp)
    80001494:	e822                	sd	s0,16(sp)
    80001496:	e426                	sd	s1,8(sp)
    80001498:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000149a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000149c:	00b67d63          	bgeu	a2,a1,800014b6 <uvmdealloc+0x26>
    800014a0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014a2:	6785                	lui	a5,0x1
    800014a4:	17fd                	addi	a5,a5,-1
    800014a6:	00f60733          	add	a4,a2,a5
    800014aa:	767d                	lui	a2,0xfffff
    800014ac:	8f71                	and	a4,a4,a2
    800014ae:	97ae                	add	a5,a5,a1
    800014b0:	8ff1                	and	a5,a5,a2
    800014b2:	00f76863          	bltu	a4,a5,800014c2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014b6:	8526                	mv	a0,s1
    800014b8:	60e2                	ld	ra,24(sp)
    800014ba:	6442                	ld	s0,16(sp)
    800014bc:	64a2                	ld	s1,8(sp)
    800014be:	6105                	addi	sp,sp,32
    800014c0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014c2:	8f99                	sub	a5,a5,a4
    800014c4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014c6:	4685                	li	a3,1
    800014c8:	0007861b          	sext.w	a2,a5
    800014cc:	85ba                	mv	a1,a4
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	e7c080e7          	jalr	-388(ra) # 8000134a <uvmunmap>
    800014d6:	b7c5                	j	800014b6 <uvmdealloc+0x26>

00000000800014d8 <uvmalloc>:
  if(newsz < oldsz)
    800014d8:	0ab66163          	bltu	a2,a1,8000157a <uvmalloc+0xa2>
{
    800014dc:	7139                	addi	sp,sp,-64
    800014de:	fc06                	sd	ra,56(sp)
    800014e0:	f822                	sd	s0,48(sp)
    800014e2:	f426                	sd	s1,40(sp)
    800014e4:	f04a                	sd	s2,32(sp)
    800014e6:	ec4e                	sd	s3,24(sp)
    800014e8:	e852                	sd	s4,16(sp)
    800014ea:	e456                	sd	s5,8(sp)
    800014ec:	0080                	addi	s0,sp,64
    800014ee:	8aaa                	mv	s5,a0
    800014f0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014f2:	6985                	lui	s3,0x1
    800014f4:	19fd                	addi	s3,s3,-1
    800014f6:	95ce                	add	a1,a1,s3
    800014f8:	79fd                	lui	s3,0xfffff
    800014fa:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014fe:	08c9f063          	bgeu	s3,a2,8000157e <uvmalloc+0xa6>
    80001502:	894e                	mv	s2,s3
    mem = kalloc();
    80001504:	fffff097          	auipc	ra,0xfffff
    80001508:	61c080e7          	jalr	1564(ra) # 80000b20 <kalloc>
    8000150c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000150e:	c51d                	beqz	a0,8000153c <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001510:	6605                	lui	a2,0x1
    80001512:	4581                	li	a1,0
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	7f8080e7          	jalr	2040(ra) # 80000d0c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    8000151c:	4779                	li	a4,30
    8000151e:	86a6                	mv	a3,s1
    80001520:	6605                	lui	a2,0x1
    80001522:	85ca                	mv	a1,s2
    80001524:	8556                	mv	a0,s5
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	bd6080e7          	jalr	-1066(ra) # 800010fc <mappages>
    8000152e:	e905                	bnez	a0,8000155e <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001530:	6785                	lui	a5,0x1
    80001532:	993e                	add	s2,s2,a5
    80001534:	fd4968e3          	bltu	s2,s4,80001504 <uvmalloc+0x2c>
  return newsz;
    80001538:	8552                	mv	a0,s4
    8000153a:	a809                	j	8000154c <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000153c:	864e                	mv	a2,s3
    8000153e:	85ca                	mv	a1,s2
    80001540:	8556                	mv	a0,s5
    80001542:	00000097          	auipc	ra,0x0
    80001546:	f4e080e7          	jalr	-178(ra) # 80001490 <uvmdealloc>
      return 0;
    8000154a:	4501                	li	a0,0
}
    8000154c:	70e2                	ld	ra,56(sp)
    8000154e:	7442                	ld	s0,48(sp)
    80001550:	74a2                	ld	s1,40(sp)
    80001552:	7902                	ld	s2,32(sp)
    80001554:	69e2                	ld	s3,24(sp)
    80001556:	6a42                	ld	s4,16(sp)
    80001558:	6aa2                	ld	s5,8(sp)
    8000155a:	6121                	addi	sp,sp,64
    8000155c:	8082                	ret
      kfree(mem);
    8000155e:	8526                	mv	a0,s1
    80001560:	fffff097          	auipc	ra,0xfffff
    80001564:	4c4080e7          	jalr	1220(ra) # 80000a24 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001568:	864e                	mv	a2,s3
    8000156a:	85ca                	mv	a1,s2
    8000156c:	8556                	mv	a0,s5
    8000156e:	00000097          	auipc	ra,0x0
    80001572:	f22080e7          	jalr	-222(ra) # 80001490 <uvmdealloc>
      return 0;
    80001576:	4501                	li	a0,0
    80001578:	bfd1                	j	8000154c <uvmalloc+0x74>
    return oldsz;
    8000157a:	852e                	mv	a0,a1
}
    8000157c:	8082                	ret
  return newsz;
    8000157e:	8532                	mv	a0,a2
    80001580:	b7f1                	j	8000154c <uvmalloc+0x74>

0000000080001582 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001582:	7179                	addi	sp,sp,-48
    80001584:	f406                	sd	ra,40(sp)
    80001586:	f022                	sd	s0,32(sp)
    80001588:	ec26                	sd	s1,24(sp)
    8000158a:	e84a                	sd	s2,16(sp)
    8000158c:	e44e                	sd	s3,8(sp)
    8000158e:	e052                	sd	s4,0(sp)
    80001590:	1800                	addi	s0,sp,48
    80001592:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001594:	84aa                	mv	s1,a0
    80001596:	6905                	lui	s2,0x1
    80001598:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000159a:	4985                	li	s3,1
    8000159c:	a821                	j	800015b4 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000159e:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800015a0:	0532                	slli	a0,a0,0xc
    800015a2:	00000097          	auipc	ra,0x0
    800015a6:	fe0080e7          	jalr	-32(ra) # 80001582 <freewalk>
      pagetable[i] = 0;
    800015aa:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800015ae:	04a1                	addi	s1,s1,8
    800015b0:	03248163          	beq	s1,s2,800015d2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015b4:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015b6:	00f57793          	andi	a5,a0,15
    800015ba:	ff3782e3          	beq	a5,s3,8000159e <freewalk+0x1c>
    } else if(pte & PTE_V){
    800015be:	8905                	andi	a0,a0,1
    800015c0:	d57d                	beqz	a0,800015ae <freewalk+0x2c>
      panic("freewalk: leaf");
    800015c2:	00007517          	auipc	a0,0x7
    800015c6:	b7e50513          	addi	a0,a0,-1154 # 80008140 <digits+0x100>
    800015ca:	fffff097          	auipc	ra,0xfffff
    800015ce:	f7e080e7          	jalr	-130(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    800015d2:	8552                	mv	a0,s4
    800015d4:	fffff097          	auipc	ra,0xfffff
    800015d8:	450080e7          	jalr	1104(ra) # 80000a24 <kfree>
}
    800015dc:	70a2                	ld	ra,40(sp)
    800015de:	7402                	ld	s0,32(sp)
    800015e0:	64e2                	ld	s1,24(sp)
    800015e2:	6942                	ld	s2,16(sp)
    800015e4:	69a2                	ld	s3,8(sp)
    800015e6:	6a02                	ld	s4,0(sp)
    800015e8:	6145                	addi	sp,sp,48
    800015ea:	8082                	ret

00000000800015ec <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015ec:	1101                	addi	sp,sp,-32
    800015ee:	ec06                	sd	ra,24(sp)
    800015f0:	e822                	sd	s0,16(sp)
    800015f2:	e426                	sd	s1,8(sp)
    800015f4:	1000                	addi	s0,sp,32
    800015f6:	84aa                	mv	s1,a0
  if(sz > 0)
    800015f8:	e999                	bnez	a1,8000160e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015fa:	8526                	mv	a0,s1
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	f86080e7          	jalr	-122(ra) # 80001582 <freewalk>
}
    80001604:	60e2                	ld	ra,24(sp)
    80001606:	6442                	ld	s0,16(sp)
    80001608:	64a2                	ld	s1,8(sp)
    8000160a:	6105                	addi	sp,sp,32
    8000160c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000160e:	6605                	lui	a2,0x1
    80001610:	167d                	addi	a2,a2,-1
    80001612:	962e                	add	a2,a2,a1
    80001614:	4685                	li	a3,1
    80001616:	8231                	srli	a2,a2,0xc
    80001618:	4581                	li	a1,0
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	d30080e7          	jalr	-720(ra) # 8000134a <uvmunmap>
    80001622:	bfe1                	j	800015fa <uvmfree+0xe>

0000000080001624 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001624:	ca4d                	beqz	a2,800016d6 <uvmcopy+0xb2>
{
    80001626:	715d                	addi	sp,sp,-80
    80001628:	e486                	sd	ra,72(sp)
    8000162a:	e0a2                	sd	s0,64(sp)
    8000162c:	fc26                	sd	s1,56(sp)
    8000162e:	f84a                	sd	s2,48(sp)
    80001630:	f44e                	sd	s3,40(sp)
    80001632:	f052                	sd	s4,32(sp)
    80001634:	ec56                	sd	s5,24(sp)
    80001636:	e85a                	sd	s6,16(sp)
    80001638:	e45e                	sd	s7,8(sp)
    8000163a:	0880                	addi	s0,sp,80
    8000163c:	8aaa                	mv	s5,a0
    8000163e:	8b2e                	mv	s6,a1
    80001640:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001642:	4481                	li	s1,0
    80001644:	a029                	j	8000164e <uvmcopy+0x2a>
    80001646:	6785                	lui	a5,0x1
    80001648:	94be                	add	s1,s1,a5
    8000164a:	0744fa63          	bgeu	s1,s4,800016be <uvmcopy+0x9a>
    if((pte = walk(old, i, 0)) == 0)
    8000164e:	4601                	li	a2,0
    80001650:	85a6                	mv	a1,s1
    80001652:	8556                	mv	a0,s5
    80001654:	00000097          	auipc	ra,0x0
    80001658:	9a4080e7          	jalr	-1628(ra) # 80000ff8 <walk>
    8000165c:	d56d                	beqz	a0,80001646 <uvmcopy+0x22>
      // panic("uvmcopy: pte should exist");
      continue;
    if((*pte & PTE_V) == 0)
    8000165e:	6118                	ld	a4,0(a0)
    80001660:	00177793          	andi	a5,a4,1
    80001664:	d3ed                	beqz	a5,80001646 <uvmcopy+0x22>
      // panic("uvmcopy: page not present");
      continue;
    pa = PTE2PA(*pte);
    80001666:	00a75593          	srli	a1,a4,0xa
    8000166a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000166e:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	4ae080e7          	jalr	1198(ra) # 80000b20 <kalloc>
    8000167a:	89aa                	mv	s3,a0
    8000167c:	c515                	beqz	a0,800016a8 <uvmcopy+0x84>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000167e:	6605                	lui	a2,0x1
    80001680:	85de                	mv	a1,s7
    80001682:	fffff097          	auipc	ra,0xfffff
    80001686:	6ea080e7          	jalr	1770(ra) # 80000d6c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000168a:	874a                	mv	a4,s2
    8000168c:	86ce                	mv	a3,s3
    8000168e:	6605                	lui	a2,0x1
    80001690:	85a6                	mv	a1,s1
    80001692:	855a                	mv	a0,s6
    80001694:	00000097          	auipc	ra,0x0
    80001698:	a68080e7          	jalr	-1432(ra) # 800010fc <mappages>
    8000169c:	d54d                	beqz	a0,80001646 <uvmcopy+0x22>
      kfree(mem);
    8000169e:	854e                	mv	a0,s3
    800016a0:	fffff097          	auipc	ra,0xfffff
    800016a4:	384080e7          	jalr	900(ra) # 80000a24 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016a8:	4685                	li	a3,1
    800016aa:	00c4d613          	srli	a2,s1,0xc
    800016ae:	4581                	li	a1,0
    800016b0:	855a                	mv	a0,s6
    800016b2:	00000097          	auipc	ra,0x0
    800016b6:	c98080e7          	jalr	-872(ra) # 8000134a <uvmunmap>
  return -1;
    800016ba:	557d                	li	a0,-1
    800016bc:	a011                	j	800016c0 <uvmcopy+0x9c>
  return 0;
    800016be:	4501                	li	a0,0
}
    800016c0:	60a6                	ld	ra,72(sp)
    800016c2:	6406                	ld	s0,64(sp)
    800016c4:	74e2                	ld	s1,56(sp)
    800016c6:	7942                	ld	s2,48(sp)
    800016c8:	79a2                	ld	s3,40(sp)
    800016ca:	7a02                	ld	s4,32(sp)
    800016cc:	6ae2                	ld	s5,24(sp)
    800016ce:	6b42                	ld	s6,16(sp)
    800016d0:	6ba2                	ld	s7,8(sp)
    800016d2:	6161                	addi	sp,sp,80
    800016d4:	8082                	ret
  return 0;
    800016d6:	4501                	li	a0,0
}
    800016d8:	8082                	ret

00000000800016da <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016da:	1141                	addi	sp,sp,-16
    800016dc:	e406                	sd	ra,8(sp)
    800016de:	e022                	sd	s0,0(sp)
    800016e0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016e2:	4601                	li	a2,0
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	914080e7          	jalr	-1772(ra) # 80000ff8 <walk>
  if(pte == 0)
    800016ec:	c901                	beqz	a0,800016fc <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016ee:	611c                	ld	a5,0(a0)
    800016f0:	9bbd                	andi	a5,a5,-17
    800016f2:	e11c                	sd	a5,0(a0)
}
    800016f4:	60a2                	ld	ra,8(sp)
    800016f6:	6402                	ld	s0,0(sp)
    800016f8:	0141                	addi	sp,sp,16
    800016fa:	8082                	ret
    panic("uvmclear");
    800016fc:	00007517          	auipc	a0,0x7
    80001700:	a5450513          	addi	a0,a0,-1452 # 80008150 <digits+0x110>
    80001704:	fffff097          	auipc	ra,0xfffff
    80001708:	e44080e7          	jalr	-444(ra) # 80000548 <panic>

000000008000170c <copyout>:
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  while(len > 0){
    8000170c:	c6bd                	beqz	a3,8000177a <copyout+0x6e>
{
    8000170e:	715d                	addi	sp,sp,-80
    80001710:	e486                	sd	ra,72(sp)
    80001712:	e0a2                	sd	s0,64(sp)
    80001714:	fc26                	sd	s1,56(sp)
    80001716:	f84a                	sd	s2,48(sp)
    80001718:	f44e                	sd	s3,40(sp)
    8000171a:	f052                	sd	s4,32(sp)
    8000171c:	ec56                	sd	s5,24(sp)
    8000171e:	e85a                	sd	s6,16(sp)
    80001720:	e45e                	sd	s7,8(sp)
    80001722:	e062                	sd	s8,0(sp)
    80001724:	0880                	addi	s0,sp,80
    80001726:	8b2a                	mv	s6,a0
    80001728:	8c2e                	mv	s8,a1
    8000172a:	8a32                	mv	s4,a2
    8000172c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000172e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001730:	6a85                	lui	s5,0x1
    80001732:	a015                	j	80001756 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001734:	9562                	add	a0,a0,s8
    80001736:	0004861b          	sext.w	a2,s1
    8000173a:	85d2                	mv	a1,s4
    8000173c:	41250533          	sub	a0,a0,s2
    80001740:	fffff097          	auipc	ra,0xfffff
    80001744:	62c080e7          	jalr	1580(ra) # 80000d6c <memmove>

    len -= n;
    80001748:	409989b3          	sub	s3,s3,s1
    src += n;
    8000174c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000174e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001752:	02098263          	beqz	s3,80001776 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001756:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000175a:	85ca                	mv	a1,s2
    8000175c:	855a                	mv	a0,s6
    8000175e:	00000097          	auipc	ra,0x0
    80001762:	a2c080e7          	jalr	-1492(ra) # 8000118a <walkaddr>
    if(pa0 == 0)
    80001766:	cd01                	beqz	a0,8000177e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001768:	418904b3          	sub	s1,s2,s8
    8000176c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000176e:	fc99f3e3          	bgeu	s3,s1,80001734 <copyout+0x28>
    80001772:	84ce                	mv	s1,s3
    80001774:	b7c1                	j	80001734 <copyout+0x28>
  }
  return 0;
    80001776:	4501                	li	a0,0
    80001778:	a021                	j	80001780 <copyout+0x74>
    8000177a:	4501                	li	a0,0
}
    8000177c:	8082                	ret
      return -1;
    8000177e:	557d                	li	a0,-1
}
    80001780:	60a6                	ld	ra,72(sp)
    80001782:	6406                	ld	s0,64(sp)
    80001784:	74e2                	ld	s1,56(sp)
    80001786:	7942                	ld	s2,48(sp)
    80001788:	79a2                	ld	s3,40(sp)
    8000178a:	7a02                	ld	s4,32(sp)
    8000178c:	6ae2                	ld	s5,24(sp)
    8000178e:	6b42                	ld	s6,16(sp)
    80001790:	6ba2                	ld	s7,8(sp)
    80001792:	6c02                	ld	s8,0(sp)
    80001794:	6161                	addi	sp,sp,80
    80001796:	8082                	ret

0000000080001798 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001798:	c6bd                	beqz	a3,80001806 <copyin+0x6e>
{
    8000179a:	715d                	addi	sp,sp,-80
    8000179c:	e486                	sd	ra,72(sp)
    8000179e:	e0a2                	sd	s0,64(sp)
    800017a0:	fc26                	sd	s1,56(sp)
    800017a2:	f84a                	sd	s2,48(sp)
    800017a4:	f44e                	sd	s3,40(sp)
    800017a6:	f052                	sd	s4,32(sp)
    800017a8:	ec56                	sd	s5,24(sp)
    800017aa:	e85a                	sd	s6,16(sp)
    800017ac:	e45e                	sd	s7,8(sp)
    800017ae:	e062                	sd	s8,0(sp)
    800017b0:	0880                	addi	s0,sp,80
    800017b2:	8b2a                	mv	s6,a0
    800017b4:	8a2e                	mv	s4,a1
    800017b6:	8c32                	mv	s8,a2
    800017b8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017ba:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017bc:	6a85                	lui	s5,0x1
    800017be:	a015                	j	800017e2 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017c0:	9562                	add	a0,a0,s8
    800017c2:	0004861b          	sext.w	a2,s1
    800017c6:	412505b3          	sub	a1,a0,s2
    800017ca:	8552                	mv	a0,s4
    800017cc:	fffff097          	auipc	ra,0xfffff
    800017d0:	5a0080e7          	jalr	1440(ra) # 80000d6c <memmove>

    len -= n;
    800017d4:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017d8:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017da:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017de:	02098263          	beqz	s3,80001802 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    800017e2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017e6:	85ca                	mv	a1,s2
    800017e8:	855a                	mv	a0,s6
    800017ea:	00000097          	auipc	ra,0x0
    800017ee:	9a0080e7          	jalr	-1632(ra) # 8000118a <walkaddr>
    if(pa0 == 0)
    800017f2:	cd01                	beqz	a0,8000180a <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    800017f4:	418904b3          	sub	s1,s2,s8
    800017f8:	94d6                	add	s1,s1,s5
    if(n > len)
    800017fa:	fc99f3e3          	bgeu	s3,s1,800017c0 <copyin+0x28>
    800017fe:	84ce                	mv	s1,s3
    80001800:	b7c1                	j	800017c0 <copyin+0x28>
  }
  return 0;
    80001802:	4501                	li	a0,0
    80001804:	a021                	j	8000180c <copyin+0x74>
    80001806:	4501                	li	a0,0
}
    80001808:	8082                	ret
      return -1;
    8000180a:	557d                	li	a0,-1
}
    8000180c:	60a6                	ld	ra,72(sp)
    8000180e:	6406                	ld	s0,64(sp)
    80001810:	74e2                	ld	s1,56(sp)
    80001812:	7942                	ld	s2,48(sp)
    80001814:	79a2                	ld	s3,40(sp)
    80001816:	7a02                	ld	s4,32(sp)
    80001818:	6ae2                	ld	s5,24(sp)
    8000181a:	6b42                	ld	s6,16(sp)
    8000181c:	6ba2                	ld	s7,8(sp)
    8000181e:	6c02                	ld	s8,0(sp)
    80001820:	6161                	addi	sp,sp,80
    80001822:	8082                	ret

0000000080001824 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001824:	c6c5                	beqz	a3,800018cc <copyinstr+0xa8>
{
    80001826:	715d                	addi	sp,sp,-80
    80001828:	e486                	sd	ra,72(sp)
    8000182a:	e0a2                	sd	s0,64(sp)
    8000182c:	fc26                	sd	s1,56(sp)
    8000182e:	f84a                	sd	s2,48(sp)
    80001830:	f44e                	sd	s3,40(sp)
    80001832:	f052                	sd	s4,32(sp)
    80001834:	ec56                	sd	s5,24(sp)
    80001836:	e85a                	sd	s6,16(sp)
    80001838:	e45e                	sd	s7,8(sp)
    8000183a:	0880                	addi	s0,sp,80
    8000183c:	8a2a                	mv	s4,a0
    8000183e:	8b2e                	mv	s6,a1
    80001840:	8bb2                	mv	s7,a2
    80001842:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001844:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001846:	6985                	lui	s3,0x1
    80001848:	a035                	j	80001874 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000184a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000184e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001850:	0017b793          	seqz	a5,a5
    80001854:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001858:	60a6                	ld	ra,72(sp)
    8000185a:	6406                	ld	s0,64(sp)
    8000185c:	74e2                	ld	s1,56(sp)
    8000185e:	7942                	ld	s2,48(sp)
    80001860:	79a2                	ld	s3,40(sp)
    80001862:	7a02                	ld	s4,32(sp)
    80001864:	6ae2                	ld	s5,24(sp)
    80001866:	6b42                	ld	s6,16(sp)
    80001868:	6ba2                	ld	s7,8(sp)
    8000186a:	6161                	addi	sp,sp,80
    8000186c:	8082                	ret
    srcva = va0 + PGSIZE;
    8000186e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001872:	c8a9                	beqz	s1,800018c4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001874:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001878:	85ca                	mv	a1,s2
    8000187a:	8552                	mv	a0,s4
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	90e080e7          	jalr	-1778(ra) # 8000118a <walkaddr>
    if(pa0 == 0)
    80001884:	c131                	beqz	a0,800018c8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001886:	41790833          	sub	a6,s2,s7
    8000188a:	984e                	add	a6,a6,s3
    if(n > max)
    8000188c:	0104f363          	bgeu	s1,a6,80001892 <copyinstr+0x6e>
    80001890:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001892:	955e                	add	a0,a0,s7
    80001894:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80001898:	fc080be3          	beqz	a6,8000186e <copyinstr+0x4a>
    8000189c:	985a                	add	a6,a6,s6
    8000189e:	87da                	mv	a5,s6
      if(*p == '\0'){
    800018a0:	41650633          	sub	a2,a0,s6
    800018a4:	14fd                	addi	s1,s1,-1
    800018a6:	9b26                	add	s6,s6,s1
    800018a8:	00f60733          	add	a4,a2,a5
    800018ac:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800018b0:	df49                	beqz	a4,8000184a <copyinstr+0x26>
        *dst = *p;
    800018b2:	00e78023          	sb	a4,0(a5)
      --max;
    800018b6:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800018ba:	0785                	addi	a5,a5,1
    while(n > 0){
    800018bc:	ff0796e3          	bne	a5,a6,800018a8 <copyinstr+0x84>
      dst++;
    800018c0:	8b42                	mv	s6,a6
    800018c2:	b775                	j	8000186e <copyinstr+0x4a>
    800018c4:	4781                	li	a5,0
    800018c6:	b769                	j	80001850 <copyinstr+0x2c>
      return -1;
    800018c8:	557d                	li	a0,-1
    800018ca:	b779                	j	80001858 <copyinstr+0x34>
  int got_null = 0;
    800018cc:	4781                	li	a5,0
  if(got_null){
    800018ce:	0017b793          	seqz	a5,a5
    800018d2:	40f00533          	neg	a0,a5
}
    800018d6:	8082                	ret

00000000800018d8 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800018d8:	1101                	addi	sp,sp,-32
    800018da:	ec06                	sd	ra,24(sp)
    800018dc:	e822                	sd	s0,16(sp)
    800018de:	e426                	sd	s1,8(sp)
    800018e0:	1000                	addi	s0,sp,32
    800018e2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018e4:	fffff097          	auipc	ra,0xfffff
    800018e8:	2b2080e7          	jalr	690(ra) # 80000b96 <holding>
    800018ec:	c909                	beqz	a0,800018fe <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800018ee:	749c                	ld	a5,40(s1)
    800018f0:	00978f63          	beq	a5,s1,8000190e <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800018f4:	60e2                	ld	ra,24(sp)
    800018f6:	6442                	ld	s0,16(sp)
    800018f8:	64a2                	ld	s1,8(sp)
    800018fa:	6105                	addi	sp,sp,32
    800018fc:	8082                	ret
    panic("wakeup1");
    800018fe:	00007517          	auipc	a0,0x7
    80001902:	86250513          	addi	a0,a0,-1950 # 80008160 <digits+0x120>
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	c42080e7          	jalr	-958(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    8000190e:	4c98                	lw	a4,24(s1)
    80001910:	4785                	li	a5,1
    80001912:	fef711e3          	bne	a4,a5,800018f4 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001916:	4789                	li	a5,2
    80001918:	cc9c                	sw	a5,24(s1)
}
    8000191a:	bfe9                	j	800018f4 <wakeup1+0x1c>

000000008000191c <procinit>:
{
    8000191c:	715d                	addi	sp,sp,-80
    8000191e:	e486                	sd	ra,72(sp)
    80001920:	e0a2                	sd	s0,64(sp)
    80001922:	fc26                	sd	s1,56(sp)
    80001924:	f84a                	sd	s2,48(sp)
    80001926:	f44e                	sd	s3,40(sp)
    80001928:	f052                	sd	s4,32(sp)
    8000192a:	ec56                	sd	s5,24(sp)
    8000192c:	e85a                	sd	s6,16(sp)
    8000192e:	e45e                	sd	s7,8(sp)
    80001930:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001932:	00007597          	auipc	a1,0x7
    80001936:	83658593          	addi	a1,a1,-1994 # 80008168 <digits+0x128>
    8000193a:	00010517          	auipc	a0,0x10
    8000193e:	01650513          	addi	a0,a0,22 # 80011950 <pid_lock>
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	23e080e7          	jalr	574(ra) # 80000b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000194a:	00010917          	auipc	s2,0x10
    8000194e:	41e90913          	addi	s2,s2,1054 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001952:	00007b97          	auipc	s7,0x7
    80001956:	81eb8b93          	addi	s7,s7,-2018 # 80008170 <digits+0x130>
      uint64 va = KSTACK((int) (p - proc));
    8000195a:	8b4a                	mv	s6,s2
    8000195c:	00006a97          	auipc	s5,0x6
    80001960:	6a4a8a93          	addi	s5,s5,1700 # 80008000 <etext>
    80001964:	040009b7          	lui	s3,0x4000
    80001968:	19fd                	addi	s3,s3,-1
    8000196a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000196c:	00016a17          	auipc	s4,0x16
    80001970:	dfca0a13          	addi	s4,s4,-516 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    80001974:	85de                	mv	a1,s7
    80001976:	854a                	mv	a0,s2
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	208080e7          	jalr	520(ra) # 80000b80 <initlock>
      char *pa = kalloc();
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	1a0080e7          	jalr	416(ra) # 80000b20 <kalloc>
    80001988:	85aa                	mv	a1,a0
      if(pa == 0)
    8000198a:	c929                	beqz	a0,800019dc <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    8000198c:	416904b3          	sub	s1,s2,s6
    80001990:	848d                	srai	s1,s1,0x3
    80001992:	000ab783          	ld	a5,0(s5)
    80001996:	02f484b3          	mul	s1,s1,a5
    8000199a:	2485                	addiw	s1,s1,1
    8000199c:	00d4949b          	slliw	s1,s1,0xd
    800019a0:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019a4:	4699                	li	a3,6
    800019a6:	6605                	lui	a2,0x1
    800019a8:	8526                	mv	a0,s1
    800019aa:	00000097          	auipc	ra,0x0
    800019ae:	896080e7          	jalr	-1898(ra) # 80001240 <kvmmap>
      p->kstack = va;
    800019b2:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    800019b6:	16890913          	addi	s2,s2,360
    800019ba:	fb491de3          	bne	s2,s4,80001974 <procinit+0x58>
  kvminithart();
    800019be:	fffff097          	auipc	ra,0xfffff
    800019c2:	616080e7          	jalr	1558(ra) # 80000fd4 <kvminithart>
}
    800019c6:	60a6                	ld	ra,72(sp)
    800019c8:	6406                	ld	s0,64(sp)
    800019ca:	74e2                	ld	s1,56(sp)
    800019cc:	7942                	ld	s2,48(sp)
    800019ce:	79a2                	ld	s3,40(sp)
    800019d0:	7a02                	ld	s4,32(sp)
    800019d2:	6ae2                	ld	s5,24(sp)
    800019d4:	6b42                	ld	s6,16(sp)
    800019d6:	6ba2                	ld	s7,8(sp)
    800019d8:	6161                	addi	sp,sp,80
    800019da:	8082                	ret
        panic("kalloc");
    800019dc:	00006517          	auipc	a0,0x6
    800019e0:	79c50513          	addi	a0,a0,1948 # 80008178 <digits+0x138>
    800019e4:	fffff097          	auipc	ra,0xfffff
    800019e8:	b64080e7          	jalr	-1180(ra) # 80000548 <panic>

00000000800019ec <cpuid>:
{
    800019ec:	1141                	addi	sp,sp,-16
    800019ee:	e422                	sd	s0,8(sp)
    800019f0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019f2:	8512                	mv	a0,tp
}
    800019f4:	2501                	sext.w	a0,a0
    800019f6:	6422                	ld	s0,8(sp)
    800019f8:	0141                	addi	sp,sp,16
    800019fa:	8082                	ret

00000000800019fc <mycpu>:
mycpu(void) {
    800019fc:	1141                	addi	sp,sp,-16
    800019fe:	e422                	sd	s0,8(sp)
    80001a00:	0800                	addi	s0,sp,16
    80001a02:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001a04:	2781                	sext.w	a5,a5
    80001a06:	079e                	slli	a5,a5,0x7
}
    80001a08:	00010517          	auipc	a0,0x10
    80001a0c:	f6050513          	addi	a0,a0,-160 # 80011968 <cpus>
    80001a10:	953e                	add	a0,a0,a5
    80001a12:	6422                	ld	s0,8(sp)
    80001a14:	0141                	addi	sp,sp,16
    80001a16:	8082                	ret

0000000080001a18 <myproc>:
myproc(void) {
    80001a18:	1101                	addi	sp,sp,-32
    80001a1a:	ec06                	sd	ra,24(sp)
    80001a1c:	e822                	sd	s0,16(sp)
    80001a1e:	e426                	sd	s1,8(sp)
    80001a20:	1000                	addi	s0,sp,32
  push_off();
    80001a22:	fffff097          	auipc	ra,0xfffff
    80001a26:	1a2080e7          	jalr	418(ra) # 80000bc4 <push_off>
    80001a2a:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001a2c:	2781                	sext.w	a5,a5
    80001a2e:	079e                	slli	a5,a5,0x7
    80001a30:	00010717          	auipc	a4,0x10
    80001a34:	f2070713          	addi	a4,a4,-224 # 80011950 <pid_lock>
    80001a38:	97ba                	add	a5,a5,a4
    80001a3a:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a3c:	fffff097          	auipc	ra,0xfffff
    80001a40:	228080e7          	jalr	552(ra) # 80000c64 <pop_off>
}
    80001a44:	8526                	mv	a0,s1
    80001a46:	60e2                	ld	ra,24(sp)
    80001a48:	6442                	ld	s0,16(sp)
    80001a4a:	64a2                	ld	s1,8(sp)
    80001a4c:	6105                	addi	sp,sp,32
    80001a4e:	8082                	ret

0000000080001a50 <forkret>:
{
    80001a50:	1141                	addi	sp,sp,-16
    80001a52:	e406                	sd	ra,8(sp)
    80001a54:	e022                	sd	s0,0(sp)
    80001a56:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a58:	00000097          	auipc	ra,0x0
    80001a5c:	fc0080e7          	jalr	-64(ra) # 80001a18 <myproc>
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	264080e7          	jalr	612(ra) # 80000cc4 <release>
  if (first) {
    80001a68:	00007797          	auipc	a5,0x7
    80001a6c:	d887a783          	lw	a5,-632(a5) # 800087f0 <first.1664>
    80001a70:	eb89                	bnez	a5,80001a82 <forkret+0x32>
  usertrapret();
    80001a72:	00001097          	auipc	ra,0x1
    80001a76:	c58080e7          	jalr	-936(ra) # 800026ca <usertrapret>
}
    80001a7a:	60a2                	ld	ra,8(sp)
    80001a7c:	6402                	ld	s0,0(sp)
    80001a7e:	0141                	addi	sp,sp,16
    80001a80:	8082                	ret
    first = 0;
    80001a82:	00007797          	auipc	a5,0x7
    80001a86:	d607a723          	sw	zero,-658(a5) # 800087f0 <first.1664>
    fsinit(ROOTDEV);
    80001a8a:	4505                	li	a0,1
    80001a8c:	00002097          	auipc	ra,0x2
    80001a90:	a4c080e7          	jalr	-1460(ra) # 800034d8 <fsinit>
    80001a94:	bff9                	j	80001a72 <forkret+0x22>

0000000080001a96 <allocpid>:
allocpid() {
    80001a96:	1101                	addi	sp,sp,-32
    80001a98:	ec06                	sd	ra,24(sp)
    80001a9a:	e822                	sd	s0,16(sp)
    80001a9c:	e426                	sd	s1,8(sp)
    80001a9e:	e04a                	sd	s2,0(sp)
    80001aa0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001aa2:	00010917          	auipc	s2,0x10
    80001aa6:	eae90913          	addi	s2,s2,-338 # 80011950 <pid_lock>
    80001aaa:	854a                	mv	a0,s2
    80001aac:	fffff097          	auipc	ra,0xfffff
    80001ab0:	164080e7          	jalr	356(ra) # 80000c10 <acquire>
  pid = nextpid;
    80001ab4:	00007797          	auipc	a5,0x7
    80001ab8:	d4078793          	addi	a5,a5,-704 # 800087f4 <nextpid>
    80001abc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001abe:	0014871b          	addiw	a4,s1,1
    80001ac2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001ac4:	854a                	mv	a0,s2
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	1fe080e7          	jalr	510(ra) # 80000cc4 <release>
}
    80001ace:	8526                	mv	a0,s1
    80001ad0:	60e2                	ld	ra,24(sp)
    80001ad2:	6442                	ld	s0,16(sp)
    80001ad4:	64a2                	ld	s1,8(sp)
    80001ad6:	6902                	ld	s2,0(sp)
    80001ad8:	6105                	addi	sp,sp,32
    80001ada:	8082                	ret

0000000080001adc <proc_pagetable>:
{
    80001adc:	1101                	addi	sp,sp,-32
    80001ade:	ec06                	sd	ra,24(sp)
    80001ae0:	e822                	sd	s0,16(sp)
    80001ae2:	e426                	sd	s1,8(sp)
    80001ae4:	e04a                	sd	s2,0(sp)
    80001ae6:	1000                	addi	s0,sp,32
    80001ae8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001aea:	00000097          	auipc	ra,0x0
    80001aee:	906080e7          	jalr	-1786(ra) # 800013f0 <uvmcreate>
    80001af2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001af4:	c121                	beqz	a0,80001b34 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001af6:	4729                	li	a4,10
    80001af8:	00005697          	auipc	a3,0x5
    80001afc:	50868693          	addi	a3,a3,1288 # 80007000 <_trampoline>
    80001b00:	6605                	lui	a2,0x1
    80001b02:	040005b7          	lui	a1,0x4000
    80001b06:	15fd                	addi	a1,a1,-1
    80001b08:	05b2                	slli	a1,a1,0xc
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	5f2080e7          	jalr	1522(ra) # 800010fc <mappages>
    80001b12:	02054863          	bltz	a0,80001b42 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001b16:	4719                	li	a4,6
    80001b18:	05893683          	ld	a3,88(s2)
    80001b1c:	6605                	lui	a2,0x1
    80001b1e:	020005b7          	lui	a1,0x2000
    80001b22:	15fd                	addi	a1,a1,-1
    80001b24:	05b6                	slli	a1,a1,0xd
    80001b26:	8526                	mv	a0,s1
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	5d4080e7          	jalr	1492(ra) # 800010fc <mappages>
    80001b30:	02054163          	bltz	a0,80001b52 <proc_pagetable+0x76>
}
    80001b34:	8526                	mv	a0,s1
    80001b36:	60e2                	ld	ra,24(sp)
    80001b38:	6442                	ld	s0,16(sp)
    80001b3a:	64a2                	ld	s1,8(sp)
    80001b3c:	6902                	ld	s2,0(sp)
    80001b3e:	6105                	addi	sp,sp,32
    80001b40:	8082                	ret
    uvmfree(pagetable, 0);
    80001b42:	4581                	li	a1,0
    80001b44:	8526                	mv	a0,s1
    80001b46:	00000097          	auipc	ra,0x0
    80001b4a:	aa6080e7          	jalr	-1370(ra) # 800015ec <uvmfree>
    return 0;
    80001b4e:	4481                	li	s1,0
    80001b50:	b7d5                	j	80001b34 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b52:	4681                	li	a3,0
    80001b54:	4605                	li	a2,1
    80001b56:	040005b7          	lui	a1,0x4000
    80001b5a:	15fd                	addi	a1,a1,-1
    80001b5c:	05b2                	slli	a1,a1,0xc
    80001b5e:	8526                	mv	a0,s1
    80001b60:	fffff097          	auipc	ra,0xfffff
    80001b64:	7ea080e7          	jalr	2026(ra) # 8000134a <uvmunmap>
    uvmfree(pagetable, 0);
    80001b68:	4581                	li	a1,0
    80001b6a:	8526                	mv	a0,s1
    80001b6c:	00000097          	auipc	ra,0x0
    80001b70:	a80080e7          	jalr	-1408(ra) # 800015ec <uvmfree>
    return 0;
    80001b74:	4481                	li	s1,0
    80001b76:	bf7d                	j	80001b34 <proc_pagetable+0x58>

0000000080001b78 <proc_freepagetable>:
{
    80001b78:	1101                	addi	sp,sp,-32
    80001b7a:	ec06                	sd	ra,24(sp)
    80001b7c:	e822                	sd	s0,16(sp)
    80001b7e:	e426                	sd	s1,8(sp)
    80001b80:	e04a                	sd	s2,0(sp)
    80001b82:	1000                	addi	s0,sp,32
    80001b84:	84aa                	mv	s1,a0
    80001b86:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b88:	4681                	li	a3,0
    80001b8a:	4605                	li	a2,1
    80001b8c:	040005b7          	lui	a1,0x4000
    80001b90:	15fd                	addi	a1,a1,-1
    80001b92:	05b2                	slli	a1,a1,0xc
    80001b94:	fffff097          	auipc	ra,0xfffff
    80001b98:	7b6080e7          	jalr	1974(ra) # 8000134a <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b9c:	4681                	li	a3,0
    80001b9e:	4605                	li	a2,1
    80001ba0:	020005b7          	lui	a1,0x2000
    80001ba4:	15fd                	addi	a1,a1,-1
    80001ba6:	05b6                	slli	a1,a1,0xd
    80001ba8:	8526                	mv	a0,s1
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	7a0080e7          	jalr	1952(ra) # 8000134a <uvmunmap>
  uvmfree(pagetable, sz);
    80001bb2:	85ca                	mv	a1,s2
    80001bb4:	8526                	mv	a0,s1
    80001bb6:	00000097          	auipc	ra,0x0
    80001bba:	a36080e7          	jalr	-1482(ra) # 800015ec <uvmfree>
}
    80001bbe:	60e2                	ld	ra,24(sp)
    80001bc0:	6442                	ld	s0,16(sp)
    80001bc2:	64a2                	ld	s1,8(sp)
    80001bc4:	6902                	ld	s2,0(sp)
    80001bc6:	6105                	addi	sp,sp,32
    80001bc8:	8082                	ret

0000000080001bca <freeproc>:
{
    80001bca:	1101                	addi	sp,sp,-32
    80001bcc:	ec06                	sd	ra,24(sp)
    80001bce:	e822                	sd	s0,16(sp)
    80001bd0:	e426                	sd	s1,8(sp)
    80001bd2:	1000                	addi	s0,sp,32
    80001bd4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001bd6:	6d28                	ld	a0,88(a0)
    80001bd8:	c509                	beqz	a0,80001be2 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001bda:	fffff097          	auipc	ra,0xfffff
    80001bde:	e4a080e7          	jalr	-438(ra) # 80000a24 <kfree>
  p->trapframe = 0;
    80001be2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001be6:	68a8                	ld	a0,80(s1)
    80001be8:	c511                	beqz	a0,80001bf4 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001bea:	64ac                	ld	a1,72(s1)
    80001bec:	00000097          	auipc	ra,0x0
    80001bf0:	f8c080e7          	jalr	-116(ra) # 80001b78 <proc_freepagetable>
  p->pagetable = 0;
    80001bf4:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bf8:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bfc:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001c00:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001c04:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c08:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001c0c:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001c10:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001c14:	0004ac23          	sw	zero,24(s1)
}
    80001c18:	60e2                	ld	ra,24(sp)
    80001c1a:	6442                	ld	s0,16(sp)
    80001c1c:	64a2                	ld	s1,8(sp)
    80001c1e:	6105                	addi	sp,sp,32
    80001c20:	8082                	ret

0000000080001c22 <allocproc>:
{
    80001c22:	1101                	addi	sp,sp,-32
    80001c24:	ec06                	sd	ra,24(sp)
    80001c26:	e822                	sd	s0,16(sp)
    80001c28:	e426                	sd	s1,8(sp)
    80001c2a:	e04a                	sd	s2,0(sp)
    80001c2c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c2e:	00010497          	auipc	s1,0x10
    80001c32:	13a48493          	addi	s1,s1,314 # 80011d68 <proc>
    80001c36:	00016917          	auipc	s2,0x16
    80001c3a:	b3290913          	addi	s2,s2,-1230 # 80017768 <tickslock>
    acquire(&p->lock);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	fd0080e7          	jalr	-48(ra) # 80000c10 <acquire>
    if(p->state == UNUSED) {
    80001c48:	4c9c                	lw	a5,24(s1)
    80001c4a:	cf81                	beqz	a5,80001c62 <allocproc+0x40>
      release(&p->lock);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	fffff097          	auipc	ra,0xfffff
    80001c52:	076080e7          	jalr	118(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c56:	16848493          	addi	s1,s1,360
    80001c5a:	ff2492e3          	bne	s1,s2,80001c3e <allocproc+0x1c>
  return 0;
    80001c5e:	4481                	li	s1,0
    80001c60:	a0b9                	j	80001cae <allocproc+0x8c>
  p->pid = allocpid();
    80001c62:	00000097          	auipc	ra,0x0
    80001c66:	e34080e7          	jalr	-460(ra) # 80001a96 <allocpid>
    80001c6a:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c6c:	fffff097          	auipc	ra,0xfffff
    80001c70:	eb4080e7          	jalr	-332(ra) # 80000b20 <kalloc>
    80001c74:	892a                	mv	s2,a0
    80001c76:	eca8                	sd	a0,88(s1)
    80001c78:	c131                	beqz	a0,80001cbc <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c7a:	8526                	mv	a0,s1
    80001c7c:	00000097          	auipc	ra,0x0
    80001c80:	e60080e7          	jalr	-416(ra) # 80001adc <proc_pagetable>
    80001c84:	892a                	mv	s2,a0
    80001c86:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c88:	c129                	beqz	a0,80001cca <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c8a:	07000613          	li	a2,112
    80001c8e:	4581                	li	a1,0
    80001c90:	06048513          	addi	a0,s1,96
    80001c94:	fffff097          	auipc	ra,0xfffff
    80001c98:	078080e7          	jalr	120(ra) # 80000d0c <memset>
  p->context.ra = (uint64)forkret;
    80001c9c:	00000797          	auipc	a5,0x0
    80001ca0:	db478793          	addi	a5,a5,-588 # 80001a50 <forkret>
    80001ca4:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ca6:	60bc                	ld	a5,64(s1)
    80001ca8:	6705                	lui	a4,0x1
    80001caa:	97ba                	add	a5,a5,a4
    80001cac:	f4bc                	sd	a5,104(s1)
}
    80001cae:	8526                	mv	a0,s1
    80001cb0:	60e2                	ld	ra,24(sp)
    80001cb2:	6442                	ld	s0,16(sp)
    80001cb4:	64a2                	ld	s1,8(sp)
    80001cb6:	6902                	ld	s2,0(sp)
    80001cb8:	6105                	addi	sp,sp,32
    80001cba:	8082                	ret
    release(&p->lock);
    80001cbc:	8526                	mv	a0,s1
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	006080e7          	jalr	6(ra) # 80000cc4 <release>
    return 0;
    80001cc6:	84ca                	mv	s1,s2
    80001cc8:	b7dd                	j	80001cae <allocproc+0x8c>
    freeproc(p);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	efe080e7          	jalr	-258(ra) # 80001bca <freeproc>
    release(&p->lock);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	fee080e7          	jalr	-18(ra) # 80000cc4 <release>
    return 0;
    80001cde:	84ca                	mv	s1,s2
    80001ce0:	b7f9                	j	80001cae <allocproc+0x8c>

0000000080001ce2 <userinit>:
{
    80001ce2:	1101                	addi	sp,sp,-32
    80001ce4:	ec06                	sd	ra,24(sp)
    80001ce6:	e822                	sd	s0,16(sp)
    80001ce8:	e426                	sd	s1,8(sp)
    80001cea:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	f36080e7          	jalr	-202(ra) # 80001c22 <allocproc>
    80001cf4:	84aa                	mv	s1,a0
  initproc = p;
    80001cf6:	00007797          	auipc	a5,0x7
    80001cfa:	32a7b123          	sd	a0,802(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cfe:	03400613          	li	a2,52
    80001d02:	00007597          	auipc	a1,0x7
    80001d06:	afe58593          	addi	a1,a1,-1282 # 80008800 <initcode>
    80001d0a:	6928                	ld	a0,80(a0)
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	712080e7          	jalr	1810(ra) # 8000141e <uvminit>
  p->sz = PGSIZE;
    80001d14:	6785                	lui	a5,0x1
    80001d16:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d18:	6cb8                	ld	a4,88(s1)
    80001d1a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d1e:	6cb8                	ld	a4,88(s1)
    80001d20:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d22:	4641                	li	a2,16
    80001d24:	00006597          	auipc	a1,0x6
    80001d28:	45c58593          	addi	a1,a1,1116 # 80008180 <digits+0x140>
    80001d2c:	15848513          	addi	a0,s1,344
    80001d30:	fffff097          	auipc	ra,0xfffff
    80001d34:	132080e7          	jalr	306(ra) # 80000e62 <safestrcpy>
  p->cwd = namei("/");
    80001d38:	00006517          	auipc	a0,0x6
    80001d3c:	45850513          	addi	a0,a0,1112 # 80008190 <digits+0x150>
    80001d40:	00002097          	auipc	ra,0x2
    80001d44:	1c4080e7          	jalr	452(ra) # 80003f04 <namei>
    80001d48:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d4c:	4789                	li	a5,2
    80001d4e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d50:	8526                	mv	a0,s1
    80001d52:	fffff097          	auipc	ra,0xfffff
    80001d56:	f72080e7          	jalr	-142(ra) # 80000cc4 <release>
}
    80001d5a:	60e2                	ld	ra,24(sp)
    80001d5c:	6442                	ld	s0,16(sp)
    80001d5e:	64a2                	ld	s1,8(sp)
    80001d60:	6105                	addi	sp,sp,32
    80001d62:	8082                	ret

0000000080001d64 <growproc>:
{
    80001d64:	1101                	addi	sp,sp,-32
    80001d66:	ec06                	sd	ra,24(sp)
    80001d68:	e822                	sd	s0,16(sp)
    80001d6a:	e426                	sd	s1,8(sp)
    80001d6c:	e04a                	sd	s2,0(sp)
    80001d6e:	1000                	addi	s0,sp,32
    80001d70:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d72:	00000097          	auipc	ra,0x0
    80001d76:	ca6080e7          	jalr	-858(ra) # 80001a18 <myproc>
    80001d7a:	892a                	mv	s2,a0
  sz = p->sz;
    80001d7c:	652c                	ld	a1,72(a0)
    80001d7e:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d82:	00904f63          	bgtz	s1,80001da0 <growproc+0x3c>
  } else if(n < 0){
    80001d86:	0204cc63          	bltz	s1,80001dbe <growproc+0x5a>
  p->sz = sz;
    80001d8a:	1602                	slli	a2,a2,0x20
    80001d8c:	9201                	srli	a2,a2,0x20
    80001d8e:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d92:	4501                	li	a0,0
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6902                	ld	s2,0(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001da0:	9e25                	addw	a2,a2,s1
    80001da2:	1602                	slli	a2,a2,0x20
    80001da4:	9201                	srli	a2,a2,0x20
    80001da6:	1582                	slli	a1,a1,0x20
    80001da8:	9181                	srli	a1,a1,0x20
    80001daa:	6928                	ld	a0,80(a0)
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	72c080e7          	jalr	1836(ra) # 800014d8 <uvmalloc>
    80001db4:	0005061b          	sext.w	a2,a0
    80001db8:	fa69                	bnez	a2,80001d8a <growproc+0x26>
      return -1;
    80001dba:	557d                	li	a0,-1
    80001dbc:	bfe1                	j	80001d94 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dbe:	9e25                	addw	a2,a2,s1
    80001dc0:	1602                	slli	a2,a2,0x20
    80001dc2:	9201                	srli	a2,a2,0x20
    80001dc4:	1582                	slli	a1,a1,0x20
    80001dc6:	9181                	srli	a1,a1,0x20
    80001dc8:	6928                	ld	a0,80(a0)
    80001dca:	fffff097          	auipc	ra,0xfffff
    80001dce:	6c6080e7          	jalr	1734(ra) # 80001490 <uvmdealloc>
    80001dd2:	0005061b          	sext.w	a2,a0
    80001dd6:	bf55                	j	80001d8a <growproc+0x26>

0000000080001dd8 <fork>:
{
    80001dd8:	7179                	addi	sp,sp,-48
    80001dda:	f406                	sd	ra,40(sp)
    80001ddc:	f022                	sd	s0,32(sp)
    80001dde:	ec26                	sd	s1,24(sp)
    80001de0:	e84a                	sd	s2,16(sp)
    80001de2:	e44e                	sd	s3,8(sp)
    80001de4:	e052                	sd	s4,0(sp)
    80001de6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001de8:	00000097          	auipc	ra,0x0
    80001dec:	c30080e7          	jalr	-976(ra) # 80001a18 <myproc>
    80001df0:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001df2:	00000097          	auipc	ra,0x0
    80001df6:	e30080e7          	jalr	-464(ra) # 80001c22 <allocproc>
    80001dfa:	c175                	beqz	a0,80001ede <fork+0x106>
    80001dfc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dfe:	04893603          	ld	a2,72(s2)
    80001e02:	692c                	ld	a1,80(a0)
    80001e04:	05093503          	ld	a0,80(s2)
    80001e08:	00000097          	auipc	ra,0x0
    80001e0c:	81c080e7          	jalr	-2020(ra) # 80001624 <uvmcopy>
    80001e10:	04054863          	bltz	a0,80001e60 <fork+0x88>
  np->sz = p->sz;
    80001e14:	04893783          	ld	a5,72(s2)
    80001e18:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001e1c:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001e20:	05893683          	ld	a3,88(s2)
    80001e24:	87b6                	mv	a5,a3
    80001e26:	0589b703          	ld	a4,88(s3)
    80001e2a:	12068693          	addi	a3,a3,288
    80001e2e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e32:	6788                	ld	a0,8(a5)
    80001e34:	6b8c                	ld	a1,16(a5)
    80001e36:	6f90                	ld	a2,24(a5)
    80001e38:	01073023          	sd	a6,0(a4)
    80001e3c:	e708                	sd	a0,8(a4)
    80001e3e:	eb0c                	sd	a1,16(a4)
    80001e40:	ef10                	sd	a2,24(a4)
    80001e42:	02078793          	addi	a5,a5,32
    80001e46:	02070713          	addi	a4,a4,32
    80001e4a:	fed792e3          	bne	a5,a3,80001e2e <fork+0x56>
  np->trapframe->a0 = 0;
    80001e4e:	0589b783          	ld	a5,88(s3)
    80001e52:	0607b823          	sd	zero,112(a5)
    80001e56:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001e5a:	15000a13          	li	s4,336
    80001e5e:	a03d                	j	80001e8c <fork+0xb4>
    freeproc(np);
    80001e60:	854e                	mv	a0,s3
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	d68080e7          	jalr	-664(ra) # 80001bca <freeproc>
    release(&np->lock);
    80001e6a:	854e                	mv	a0,s3
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	e58080e7          	jalr	-424(ra) # 80000cc4 <release>
    return -1;
    80001e74:	54fd                	li	s1,-1
    80001e76:	a899                	j	80001ecc <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e78:	00002097          	auipc	ra,0x2
    80001e7c:	718080e7          	jalr	1816(ra) # 80004590 <filedup>
    80001e80:	009987b3          	add	a5,s3,s1
    80001e84:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001e86:	04a1                	addi	s1,s1,8
    80001e88:	01448763          	beq	s1,s4,80001e96 <fork+0xbe>
    if(p->ofile[i])
    80001e8c:	009907b3          	add	a5,s2,s1
    80001e90:	6388                	ld	a0,0(a5)
    80001e92:	f17d                	bnez	a0,80001e78 <fork+0xa0>
    80001e94:	bfcd                	j	80001e86 <fork+0xae>
  np->cwd = idup(p->cwd);
    80001e96:	15093503          	ld	a0,336(s2)
    80001e9a:	00002097          	auipc	ra,0x2
    80001e9e:	878080e7          	jalr	-1928(ra) # 80003712 <idup>
    80001ea2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea6:	4641                	li	a2,16
    80001ea8:	15890593          	addi	a1,s2,344
    80001eac:	15898513          	addi	a0,s3,344
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	fb2080e7          	jalr	-78(ra) # 80000e62 <safestrcpy>
  pid = np->pid;
    80001eb8:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001ebc:	4789                	li	a5,2
    80001ebe:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001ec2:	854e                	mv	a0,s3
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	e00080e7          	jalr	-512(ra) # 80000cc4 <release>
}
    80001ecc:	8526                	mv	a0,s1
    80001ece:	70a2                	ld	ra,40(sp)
    80001ed0:	7402                	ld	s0,32(sp)
    80001ed2:	64e2                	ld	s1,24(sp)
    80001ed4:	6942                	ld	s2,16(sp)
    80001ed6:	69a2                	ld	s3,8(sp)
    80001ed8:	6a02                	ld	s4,0(sp)
    80001eda:	6145                	addi	sp,sp,48
    80001edc:	8082                	ret
    return -1;
    80001ede:	54fd                	li	s1,-1
    80001ee0:	b7f5                	j	80001ecc <fork+0xf4>

0000000080001ee2 <reparent>:
{
    80001ee2:	7179                	addi	sp,sp,-48
    80001ee4:	f406                	sd	ra,40(sp)
    80001ee6:	f022                	sd	s0,32(sp)
    80001ee8:	ec26                	sd	s1,24(sp)
    80001eea:	e84a                	sd	s2,16(sp)
    80001eec:	e44e                	sd	s3,8(sp)
    80001eee:	e052                	sd	s4,0(sp)
    80001ef0:	1800                	addi	s0,sp,48
    80001ef2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ef4:	00010497          	auipc	s1,0x10
    80001ef8:	e7448493          	addi	s1,s1,-396 # 80011d68 <proc>
      pp->parent = initproc;
    80001efc:	00007a17          	auipc	s4,0x7
    80001f00:	11ca0a13          	addi	s4,s4,284 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001f04:	00016997          	auipc	s3,0x16
    80001f08:	86498993          	addi	s3,s3,-1948 # 80017768 <tickslock>
    80001f0c:	a029                	j	80001f16 <reparent+0x34>
    80001f0e:	16848493          	addi	s1,s1,360
    80001f12:	03348363          	beq	s1,s3,80001f38 <reparent+0x56>
    if(pp->parent == p){
    80001f16:	709c                	ld	a5,32(s1)
    80001f18:	ff279be3          	bne	a5,s2,80001f0e <reparent+0x2c>
      acquire(&pp->lock);
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	fffff097          	auipc	ra,0xfffff
    80001f22:	cf2080e7          	jalr	-782(ra) # 80000c10 <acquire>
      pp->parent = initproc;
    80001f26:	000a3783          	ld	a5,0(s4)
    80001f2a:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	fffff097          	auipc	ra,0xfffff
    80001f32:	d96080e7          	jalr	-618(ra) # 80000cc4 <release>
    80001f36:	bfe1                	j	80001f0e <reparent+0x2c>
}
    80001f38:	70a2                	ld	ra,40(sp)
    80001f3a:	7402                	ld	s0,32(sp)
    80001f3c:	64e2                	ld	s1,24(sp)
    80001f3e:	6942                	ld	s2,16(sp)
    80001f40:	69a2                	ld	s3,8(sp)
    80001f42:	6a02                	ld	s4,0(sp)
    80001f44:	6145                	addi	sp,sp,48
    80001f46:	8082                	ret

0000000080001f48 <scheduler>:
{
    80001f48:	711d                	addi	sp,sp,-96
    80001f4a:	ec86                	sd	ra,88(sp)
    80001f4c:	e8a2                	sd	s0,80(sp)
    80001f4e:	e4a6                	sd	s1,72(sp)
    80001f50:	e0ca                	sd	s2,64(sp)
    80001f52:	fc4e                	sd	s3,56(sp)
    80001f54:	f852                	sd	s4,48(sp)
    80001f56:	f456                	sd	s5,40(sp)
    80001f58:	f05a                	sd	s6,32(sp)
    80001f5a:	ec5e                	sd	s7,24(sp)
    80001f5c:	e862                	sd	s8,16(sp)
    80001f5e:	e466                	sd	s9,8(sp)
    80001f60:	1080                	addi	s0,sp,96
    80001f62:	8792                	mv	a5,tp
  int id = r_tp();
    80001f64:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f66:	00779c13          	slli	s8,a5,0x7
    80001f6a:	00010717          	auipc	a4,0x10
    80001f6e:	9e670713          	addi	a4,a4,-1562 # 80011950 <pid_lock>
    80001f72:	9762                	add	a4,a4,s8
    80001f74:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f78:	00010717          	auipc	a4,0x10
    80001f7c:	9f870713          	addi	a4,a4,-1544 # 80011970 <cpus+0x8>
    80001f80:	9c3a                	add	s8,s8,a4
      if(p->state == RUNNABLE) {
    80001f82:	4a89                	li	s5,2
        c->proc = p;
    80001f84:	079e                	slli	a5,a5,0x7
    80001f86:	00010b17          	auipc	s6,0x10
    80001f8a:	9cab0b13          	addi	s6,s6,-1590 # 80011950 <pid_lock>
    80001f8e:	9b3e                	add	s6,s6,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f90:	00015a17          	auipc	s4,0x15
    80001f94:	7d8a0a13          	addi	s4,s4,2008 # 80017768 <tickslock>
    int nproc = 0;
    80001f98:	4c81                	li	s9,0
    80001f9a:	a8a1                	j	80001ff2 <scheduler+0xaa>
        p->state = RUNNING;
    80001f9c:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80001fa0:	009b3c23          	sd	s1,24(s6)
        swtch(&c->context, &p->context);
    80001fa4:	06048593          	addi	a1,s1,96
    80001fa8:	8562                	mv	a0,s8
    80001faa:	00000097          	auipc	ra,0x0
    80001fae:	676080e7          	jalr	1654(ra) # 80002620 <swtch>
        c->proc = 0;
    80001fb2:	000b3c23          	sd	zero,24(s6)
      release(&p->lock);
    80001fb6:	8526                	mv	a0,s1
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	d0c080e7          	jalr	-756(ra) # 80000cc4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fc0:	16848493          	addi	s1,s1,360
    80001fc4:	01448d63          	beq	s1,s4,80001fde <scheduler+0x96>
      acquire(&p->lock);
    80001fc8:	8526                	mv	a0,s1
    80001fca:	fffff097          	auipc	ra,0xfffff
    80001fce:	c46080e7          	jalr	-954(ra) # 80000c10 <acquire>
      if(p->state != UNUSED) {
    80001fd2:	4c9c                	lw	a5,24(s1)
    80001fd4:	d3ed                	beqz	a5,80001fb6 <scheduler+0x6e>
        nproc++;
    80001fd6:	2985                	addiw	s3,s3,1
      if(p->state == RUNNABLE) {
    80001fd8:	fd579fe3          	bne	a5,s5,80001fb6 <scheduler+0x6e>
    80001fdc:	b7c1                	j	80001f9c <scheduler+0x54>
    if(nproc <= 2) {   // only init and sh exist
    80001fde:	013aca63          	blt	s5,s3,80001ff2 <scheduler+0xaa>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fe2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fe6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fea:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fee:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ff2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ff6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ffa:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001ffe:	89e6                	mv	s3,s9
    for(p = proc; p < &proc[NPROC]; p++) {
    80002000:	00010497          	auipc	s1,0x10
    80002004:	d6848493          	addi	s1,s1,-664 # 80011d68 <proc>
        p->state = RUNNING;
    80002008:	4b8d                	li	s7,3
    8000200a:	bf7d                	j	80001fc8 <scheduler+0x80>

000000008000200c <sched>:
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	e44e                	sd	s3,8(sp)
    80002018:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	9fe080e7          	jalr	-1538(ra) # 80001a18 <myproc>
    80002022:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	b72080e7          	jalr	-1166(ra) # 80000b96 <holding>
    8000202c:	c93d                	beqz	a0,800020a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	00010717          	auipc	a4,0x10
    80002038:	91c70713          	addi	a4,a4,-1764 # 80011950 <pid_lock>
    8000203c:	97ba                	add	a5,a5,a4
    8000203e:	0907a703          	lw	a4,144(a5)
    80002042:	4785                	li	a5,1
    80002044:	06f71763          	bne	a4,a5,800020b2 <sched+0xa6>
  if(p->state == RUNNING)
    80002048:	4c98                	lw	a4,24(s1)
    8000204a:	478d                	li	a5,3
    8000204c:	06f70b63          	beq	a4,a5,800020c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002050:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002054:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002056:	efb5                	bnez	a5,800020d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002058:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000205a:	00010917          	auipc	s2,0x10
    8000205e:	8f690913          	addi	s2,s2,-1802 # 80011950 <pid_lock>
    80002062:	2781                	sext.w	a5,a5
    80002064:	079e                	slli	a5,a5,0x7
    80002066:	97ca                	add	a5,a5,s2
    80002068:	0947a983          	lw	s3,148(a5)
    8000206c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000206e:	2781                	sext.w	a5,a5
    80002070:	079e                	slli	a5,a5,0x7
    80002072:	00010597          	auipc	a1,0x10
    80002076:	8fe58593          	addi	a1,a1,-1794 # 80011970 <cpus+0x8>
    8000207a:	95be                	add	a1,a1,a5
    8000207c:	06048513          	addi	a0,s1,96
    80002080:	00000097          	auipc	ra,0x0
    80002084:	5a0080e7          	jalr	1440(ra) # 80002620 <swtch>
    80002088:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000208a:	2781                	sext.w	a5,a5
    8000208c:	079e                	slli	a5,a5,0x7
    8000208e:	97ca                	add	a5,a5,s2
    80002090:	0937aa23          	sw	s3,148(a5)
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret
    panic("sched p->lock");
    800020a2:	00006517          	auipc	a0,0x6
    800020a6:	0f650513          	addi	a0,a0,246 # 80008198 <digits+0x158>
    800020aa:	ffffe097          	auipc	ra,0xffffe
    800020ae:	49e080e7          	jalr	1182(ra) # 80000548 <panic>
    panic("sched locks");
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	0f650513          	addi	a0,a0,246 # 800081a8 <digits+0x168>
    800020ba:	ffffe097          	auipc	ra,0xffffe
    800020be:	48e080e7          	jalr	1166(ra) # 80000548 <panic>
    panic("sched running");
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	0f650513          	addi	a0,a0,246 # 800081b8 <digits+0x178>
    800020ca:	ffffe097          	auipc	ra,0xffffe
    800020ce:	47e080e7          	jalr	1150(ra) # 80000548 <panic>
    panic("sched interruptible");
    800020d2:	00006517          	auipc	a0,0x6
    800020d6:	0f650513          	addi	a0,a0,246 # 800081c8 <digits+0x188>
    800020da:	ffffe097          	auipc	ra,0xffffe
    800020de:	46e080e7          	jalr	1134(ra) # 80000548 <panic>

00000000800020e2 <exit>:
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	ec26                	sd	s1,24(sp)
    800020ea:	e84a                	sd	s2,16(sp)
    800020ec:	e44e                	sd	s3,8(sp)
    800020ee:	e052                	sd	s4,0(sp)
    800020f0:	1800                	addi	s0,sp,48
    800020f2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	924080e7          	jalr	-1756(ra) # 80001a18 <myproc>
    800020fc:	89aa                	mv	s3,a0
  if(p == initproc)
    800020fe:	00007797          	auipc	a5,0x7
    80002102:	f1a7b783          	ld	a5,-230(a5) # 80009018 <initproc>
    80002106:	0d050493          	addi	s1,a0,208
    8000210a:	15050913          	addi	s2,a0,336
    8000210e:	02a79363          	bne	a5,a0,80002134 <exit+0x52>
    panic("init exiting");
    80002112:	00006517          	auipc	a0,0x6
    80002116:	0ce50513          	addi	a0,a0,206 # 800081e0 <digits+0x1a0>
    8000211a:	ffffe097          	auipc	ra,0xffffe
    8000211e:	42e080e7          	jalr	1070(ra) # 80000548 <panic>
      fileclose(f);
    80002122:	00002097          	auipc	ra,0x2
    80002126:	4c0080e7          	jalr	1216(ra) # 800045e2 <fileclose>
      p->ofile[fd] = 0;
    8000212a:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000212e:	04a1                	addi	s1,s1,8
    80002130:	01248563          	beq	s1,s2,8000213a <exit+0x58>
    if(p->ofile[fd]){
    80002134:	6088                	ld	a0,0(s1)
    80002136:	f575                	bnez	a0,80002122 <exit+0x40>
    80002138:	bfdd                	j	8000212e <exit+0x4c>
  begin_op();
    8000213a:	00002097          	auipc	ra,0x2
    8000213e:	fd6080e7          	jalr	-42(ra) # 80004110 <begin_op>
  iput(p->cwd);
    80002142:	1509b503          	ld	a0,336(s3)
    80002146:	00001097          	auipc	ra,0x1
    8000214a:	7c4080e7          	jalr	1988(ra) # 8000390a <iput>
  end_op();
    8000214e:	00002097          	auipc	ra,0x2
    80002152:	042080e7          	jalr	66(ra) # 80004190 <end_op>
  p->cwd = 0;
    80002156:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000215a:	00007497          	auipc	s1,0x7
    8000215e:	ebe48493          	addi	s1,s1,-322 # 80009018 <initproc>
    80002162:	6088                	ld	a0,0(s1)
    80002164:	fffff097          	auipc	ra,0xfffff
    80002168:	aac080e7          	jalr	-1364(ra) # 80000c10 <acquire>
  wakeup1(initproc);
    8000216c:	6088                	ld	a0,0(s1)
    8000216e:	fffff097          	auipc	ra,0xfffff
    80002172:	76a080e7          	jalr	1898(ra) # 800018d8 <wakeup1>
  release(&initproc->lock);
    80002176:	6088                	ld	a0,0(s1)
    80002178:	fffff097          	auipc	ra,0xfffff
    8000217c:	b4c080e7          	jalr	-1204(ra) # 80000cc4 <release>
  acquire(&p->lock);
    80002180:	854e                	mv	a0,s3
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	a8e080e7          	jalr	-1394(ra) # 80000c10 <acquire>
  struct proc *original_parent = p->parent;
    8000218a:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    8000218e:	854e                	mv	a0,s3
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	b34080e7          	jalr	-1228(ra) # 80000cc4 <release>
  acquire(&original_parent->lock);
    80002198:	8526                	mv	a0,s1
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	a76080e7          	jalr	-1418(ra) # 80000c10 <acquire>
  acquire(&p->lock);
    800021a2:	854e                	mv	a0,s3
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	a6c080e7          	jalr	-1428(ra) # 80000c10 <acquire>
  reparent(p);
    800021ac:	854e                	mv	a0,s3
    800021ae:	00000097          	auipc	ra,0x0
    800021b2:	d34080e7          	jalr	-716(ra) # 80001ee2 <reparent>
  wakeup1(original_parent);
    800021b6:	8526                	mv	a0,s1
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	720080e7          	jalr	1824(ra) # 800018d8 <wakeup1>
  p->xstate = status;
    800021c0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800021c4:	4791                	li	a5,4
    800021c6:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    800021ca:	8526                	mv	a0,s1
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	af8080e7          	jalr	-1288(ra) # 80000cc4 <release>
  sched();
    800021d4:	00000097          	auipc	ra,0x0
    800021d8:	e38080e7          	jalr	-456(ra) # 8000200c <sched>
  panic("zombie exit");
    800021dc:	00006517          	auipc	a0,0x6
    800021e0:	01450513          	addi	a0,a0,20 # 800081f0 <digits+0x1b0>
    800021e4:	ffffe097          	auipc	ra,0xffffe
    800021e8:	364080e7          	jalr	868(ra) # 80000548 <panic>

00000000800021ec <yield>:
{
    800021ec:	1101                	addi	sp,sp,-32
    800021ee:	ec06                	sd	ra,24(sp)
    800021f0:	e822                	sd	s0,16(sp)
    800021f2:	e426                	sd	s1,8(sp)
    800021f4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	822080e7          	jalr	-2014(ra) # 80001a18 <myproc>
    800021fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	a10080e7          	jalr	-1520(ra) # 80000c10 <acquire>
  p->state = RUNNABLE;
    80002208:	4789                	li	a5,2
    8000220a:	cc9c                	sw	a5,24(s1)
  sched();
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	e00080e7          	jalr	-512(ra) # 8000200c <sched>
  release(&p->lock);
    80002214:	8526                	mv	a0,s1
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	aae080e7          	jalr	-1362(ra) # 80000cc4 <release>
}
    8000221e:	60e2                	ld	ra,24(sp)
    80002220:	6442                	ld	s0,16(sp)
    80002222:	64a2                	ld	s1,8(sp)
    80002224:	6105                	addi	sp,sp,32
    80002226:	8082                	ret

0000000080002228 <sleep>:
{
    80002228:	7179                	addi	sp,sp,-48
    8000222a:	f406                	sd	ra,40(sp)
    8000222c:	f022                	sd	s0,32(sp)
    8000222e:	ec26                	sd	s1,24(sp)
    80002230:	e84a                	sd	s2,16(sp)
    80002232:	e44e                	sd	s3,8(sp)
    80002234:	1800                	addi	s0,sp,48
    80002236:	89aa                	mv	s3,a0
    80002238:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	7de080e7          	jalr	2014(ra) # 80001a18 <myproc>
    80002242:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002244:	05250663          	beq	a0,s2,80002290 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002248:	fffff097          	auipc	ra,0xfffff
    8000224c:	9c8080e7          	jalr	-1592(ra) # 80000c10 <acquire>
    release(lk);
    80002250:	854a                	mv	a0,s2
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	a72080e7          	jalr	-1422(ra) # 80000cc4 <release>
  p->chan = chan;
    8000225a:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000225e:	4785                	li	a5,1
    80002260:	cc9c                	sw	a5,24(s1)
  sched();
    80002262:	00000097          	auipc	ra,0x0
    80002266:	daa080e7          	jalr	-598(ra) # 8000200c <sched>
  p->chan = 0;
    8000226a:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	a54080e7          	jalr	-1452(ra) # 80000cc4 <release>
    acquire(lk);
    80002278:	854a                	mv	a0,s2
    8000227a:	fffff097          	auipc	ra,0xfffff
    8000227e:	996080e7          	jalr	-1642(ra) # 80000c10 <acquire>
}
    80002282:	70a2                	ld	ra,40(sp)
    80002284:	7402                	ld	s0,32(sp)
    80002286:	64e2                	ld	s1,24(sp)
    80002288:	6942                	ld	s2,16(sp)
    8000228a:	69a2                	ld	s3,8(sp)
    8000228c:	6145                	addi	sp,sp,48
    8000228e:	8082                	ret
  p->chan = chan;
    80002290:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002294:	4785                	li	a5,1
    80002296:	cd1c                	sw	a5,24(a0)
  sched();
    80002298:	00000097          	auipc	ra,0x0
    8000229c:	d74080e7          	jalr	-652(ra) # 8000200c <sched>
  p->chan = 0;
    800022a0:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    800022a4:	bff9                	j	80002282 <sleep+0x5a>

00000000800022a6 <wait>:
{
    800022a6:	715d                	addi	sp,sp,-80
    800022a8:	e486                	sd	ra,72(sp)
    800022aa:	e0a2                	sd	s0,64(sp)
    800022ac:	fc26                	sd	s1,56(sp)
    800022ae:	f84a                	sd	s2,48(sp)
    800022b0:	f44e                	sd	s3,40(sp)
    800022b2:	f052                	sd	s4,32(sp)
    800022b4:	ec56                	sd	s5,24(sp)
    800022b6:	e85a                	sd	s6,16(sp)
    800022b8:	e45e                	sd	s7,8(sp)
    800022ba:	e062                	sd	s8,0(sp)
    800022bc:	0880                	addi	s0,sp,80
    800022be:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800022c0:	fffff097          	auipc	ra,0xfffff
    800022c4:	758080e7          	jalr	1880(ra) # 80001a18 <myproc>
    800022c8:	892a                	mv	s2,a0
  acquire(&p->lock);
    800022ca:	8c2a                	mv	s8,a0
    800022cc:	fffff097          	auipc	ra,0xfffff
    800022d0:	944080e7          	jalr	-1724(ra) # 80000c10 <acquire>
    havekids = 0;
    800022d4:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800022d6:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800022d8:	00015997          	auipc	s3,0x15
    800022dc:	49098993          	addi	s3,s3,1168 # 80017768 <tickslock>
        havekids = 1;
    800022e0:	4a85                	li	s5,1
    havekids = 0;
    800022e2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800022e4:	00010497          	auipc	s1,0x10
    800022e8:	a8448493          	addi	s1,s1,-1404 # 80011d68 <proc>
    800022ec:	a08d                	j	8000234e <wait+0xa8>
          pid = np->pid;
    800022ee:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022f2:	000b0e63          	beqz	s6,8000230e <wait+0x68>
    800022f6:	4691                	li	a3,4
    800022f8:	03448613          	addi	a2,s1,52
    800022fc:	85da                	mv	a1,s6
    800022fe:	05093503          	ld	a0,80(s2)
    80002302:	fffff097          	auipc	ra,0xfffff
    80002306:	40a080e7          	jalr	1034(ra) # 8000170c <copyout>
    8000230a:	02054263          	bltz	a0,8000232e <wait+0x88>
          freeproc(np);
    8000230e:	8526                	mv	a0,s1
    80002310:	00000097          	auipc	ra,0x0
    80002314:	8ba080e7          	jalr	-1862(ra) # 80001bca <freeproc>
          release(&np->lock);
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	9aa080e7          	jalr	-1622(ra) # 80000cc4 <release>
          release(&p->lock);
    80002322:	854a                	mv	a0,s2
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	9a0080e7          	jalr	-1632(ra) # 80000cc4 <release>
          return pid;
    8000232c:	a8a9                	j	80002386 <wait+0xe0>
            release(&np->lock);
    8000232e:	8526                	mv	a0,s1
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	994080e7          	jalr	-1644(ra) # 80000cc4 <release>
            release(&p->lock);
    80002338:	854a                	mv	a0,s2
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	98a080e7          	jalr	-1654(ra) # 80000cc4 <release>
            return -1;
    80002342:	59fd                	li	s3,-1
    80002344:	a089                	j	80002386 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002346:	16848493          	addi	s1,s1,360
    8000234a:	03348463          	beq	s1,s3,80002372 <wait+0xcc>
      if(np->parent == p){
    8000234e:	709c                	ld	a5,32(s1)
    80002350:	ff279be3          	bne	a5,s2,80002346 <wait+0xa0>
        acquire(&np->lock);
    80002354:	8526                	mv	a0,s1
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	8ba080e7          	jalr	-1862(ra) # 80000c10 <acquire>
        if(np->state == ZOMBIE){
    8000235e:	4c9c                	lw	a5,24(s1)
    80002360:	f94787e3          	beq	a5,s4,800022ee <wait+0x48>
        release(&np->lock);
    80002364:	8526                	mv	a0,s1
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	95e080e7          	jalr	-1698(ra) # 80000cc4 <release>
        havekids = 1;
    8000236e:	8756                	mv	a4,s5
    80002370:	bfd9                	j	80002346 <wait+0xa0>
    if(!havekids || p->killed){
    80002372:	c701                	beqz	a4,8000237a <wait+0xd4>
    80002374:	03092783          	lw	a5,48(s2)
    80002378:	c785                	beqz	a5,800023a0 <wait+0xfa>
      release(&p->lock);
    8000237a:	854a                	mv	a0,s2
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	948080e7          	jalr	-1720(ra) # 80000cc4 <release>
      return -1;
    80002384:	59fd                	li	s3,-1
}
    80002386:	854e                	mv	a0,s3
    80002388:	60a6                	ld	ra,72(sp)
    8000238a:	6406                	ld	s0,64(sp)
    8000238c:	74e2                	ld	s1,56(sp)
    8000238e:	7942                	ld	s2,48(sp)
    80002390:	79a2                	ld	s3,40(sp)
    80002392:	7a02                	ld	s4,32(sp)
    80002394:	6ae2                	ld	s5,24(sp)
    80002396:	6b42                	ld	s6,16(sp)
    80002398:	6ba2                	ld	s7,8(sp)
    8000239a:	6c02                	ld	s8,0(sp)
    8000239c:	6161                	addi	sp,sp,80
    8000239e:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    800023a0:	85e2                	mv	a1,s8
    800023a2:	854a                	mv	a0,s2
    800023a4:	00000097          	auipc	ra,0x0
    800023a8:	e84080e7          	jalr	-380(ra) # 80002228 <sleep>
    havekids = 0;
    800023ac:	bf1d                	j	800022e2 <wait+0x3c>

00000000800023ae <wakeup>:
{
    800023ae:	7139                	addi	sp,sp,-64
    800023b0:	fc06                	sd	ra,56(sp)
    800023b2:	f822                	sd	s0,48(sp)
    800023b4:	f426                	sd	s1,40(sp)
    800023b6:	f04a                	sd	s2,32(sp)
    800023b8:	ec4e                	sd	s3,24(sp)
    800023ba:	e852                	sd	s4,16(sp)
    800023bc:	e456                	sd	s5,8(sp)
    800023be:	0080                	addi	s0,sp,64
    800023c0:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    800023c2:	00010497          	auipc	s1,0x10
    800023c6:	9a648493          	addi	s1,s1,-1626 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    800023ca:	4985                	li	s3,1
      p->state = RUNNABLE;
    800023cc:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    800023ce:	00015917          	auipc	s2,0x15
    800023d2:	39a90913          	addi	s2,s2,922 # 80017768 <tickslock>
    800023d6:	a821                	j	800023ee <wakeup+0x40>
      p->state = RUNNABLE;
    800023d8:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    800023dc:	8526                	mv	a0,s1
    800023de:	fffff097          	auipc	ra,0xfffff
    800023e2:	8e6080e7          	jalr	-1818(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800023e6:	16848493          	addi	s1,s1,360
    800023ea:	01248e63          	beq	s1,s2,80002406 <wakeup+0x58>
    acquire(&p->lock);
    800023ee:	8526                	mv	a0,s1
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	820080e7          	jalr	-2016(ra) # 80000c10 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023f8:	4c9c                	lw	a5,24(s1)
    800023fa:	ff3791e3          	bne	a5,s3,800023dc <wakeup+0x2e>
    800023fe:	749c                	ld	a5,40(s1)
    80002400:	fd479ee3          	bne	a5,s4,800023dc <wakeup+0x2e>
    80002404:	bfd1                	j	800023d8 <wakeup+0x2a>
}
    80002406:	70e2                	ld	ra,56(sp)
    80002408:	7442                	ld	s0,48(sp)
    8000240a:	74a2                	ld	s1,40(sp)
    8000240c:	7902                	ld	s2,32(sp)
    8000240e:	69e2                	ld	s3,24(sp)
    80002410:	6a42                	ld	s4,16(sp)
    80002412:	6aa2                	ld	s5,8(sp)
    80002414:	6121                	addi	sp,sp,64
    80002416:	8082                	ret

0000000080002418 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002418:	7179                	addi	sp,sp,-48
    8000241a:	f406                	sd	ra,40(sp)
    8000241c:	f022                	sd	s0,32(sp)
    8000241e:	ec26                	sd	s1,24(sp)
    80002420:	e84a                	sd	s2,16(sp)
    80002422:	e44e                	sd	s3,8(sp)
    80002424:	1800                	addi	s0,sp,48
    80002426:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002428:	00010497          	auipc	s1,0x10
    8000242c:	94048493          	addi	s1,s1,-1728 # 80011d68 <proc>
    80002430:	00015997          	auipc	s3,0x15
    80002434:	33898993          	addi	s3,s3,824 # 80017768 <tickslock>
    acquire(&p->lock);
    80002438:	8526                	mv	a0,s1
    8000243a:	ffffe097          	auipc	ra,0xffffe
    8000243e:	7d6080e7          	jalr	2006(ra) # 80000c10 <acquire>
    if(p->pid == pid){
    80002442:	5c9c                	lw	a5,56(s1)
    80002444:	01278d63          	beq	a5,s2,8000245e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002448:	8526                	mv	a0,s1
    8000244a:	fffff097          	auipc	ra,0xfffff
    8000244e:	87a080e7          	jalr	-1926(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002452:	16848493          	addi	s1,s1,360
    80002456:	ff3491e3          	bne	s1,s3,80002438 <kill+0x20>
  }
  return -1;
    8000245a:	557d                	li	a0,-1
    8000245c:	a829                	j	80002476 <kill+0x5e>
      p->killed = 1;
    8000245e:	4785                	li	a5,1
    80002460:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002462:	4c98                	lw	a4,24(s1)
    80002464:	4785                	li	a5,1
    80002466:	00f70f63          	beq	a4,a5,80002484 <kill+0x6c>
      release(&p->lock);
    8000246a:	8526                	mv	a0,s1
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	858080e7          	jalr	-1960(ra) # 80000cc4 <release>
      return 0;
    80002474:	4501                	li	a0,0
}
    80002476:	70a2                	ld	ra,40(sp)
    80002478:	7402                	ld	s0,32(sp)
    8000247a:	64e2                	ld	s1,24(sp)
    8000247c:	6942                	ld	s2,16(sp)
    8000247e:	69a2                	ld	s3,8(sp)
    80002480:	6145                	addi	sp,sp,48
    80002482:	8082                	ret
        p->state = RUNNABLE;
    80002484:	4789                	li	a5,2
    80002486:	cc9c                	sw	a5,24(s1)
    80002488:	b7cd                	j	8000246a <kill+0x52>

000000008000248a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000248a:	7179                	addi	sp,sp,-48
    8000248c:	f406                	sd	ra,40(sp)
    8000248e:	f022                	sd	s0,32(sp)
    80002490:	ec26                	sd	s1,24(sp)
    80002492:	e84a                	sd	s2,16(sp)
    80002494:	e44e                	sd	s3,8(sp)
    80002496:	e052                	sd	s4,0(sp)
    80002498:	1800                	addi	s0,sp,48
    8000249a:	84aa                	mv	s1,a0
    8000249c:	892e                	mv	s2,a1
    8000249e:	89b2                	mv	s3,a2
    800024a0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024a2:	fffff097          	auipc	ra,0xfffff
    800024a6:	576080e7          	jalr	1398(ra) # 80001a18 <myproc>
  if(user_dst){
    800024aa:	c08d                	beqz	s1,800024cc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800024ac:	86d2                	mv	a3,s4
    800024ae:	864e                	mv	a2,s3
    800024b0:	85ca                	mv	a1,s2
    800024b2:	6928                	ld	a0,80(a0)
    800024b4:	fffff097          	auipc	ra,0xfffff
    800024b8:	258080e7          	jalr	600(ra) # 8000170c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024bc:	70a2                	ld	ra,40(sp)
    800024be:	7402                	ld	s0,32(sp)
    800024c0:	64e2                	ld	s1,24(sp)
    800024c2:	6942                	ld	s2,16(sp)
    800024c4:	69a2                	ld	s3,8(sp)
    800024c6:	6a02                	ld	s4,0(sp)
    800024c8:	6145                	addi	sp,sp,48
    800024ca:	8082                	ret
    memmove((char *)dst, src, len);
    800024cc:	000a061b          	sext.w	a2,s4
    800024d0:	85ce                	mv	a1,s3
    800024d2:	854a                	mv	a0,s2
    800024d4:	fffff097          	auipc	ra,0xfffff
    800024d8:	898080e7          	jalr	-1896(ra) # 80000d6c <memmove>
    return 0;
    800024dc:	8526                	mv	a0,s1
    800024de:	bff9                	j	800024bc <either_copyout+0x32>

00000000800024e0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024e0:	7179                	addi	sp,sp,-48
    800024e2:	f406                	sd	ra,40(sp)
    800024e4:	f022                	sd	s0,32(sp)
    800024e6:	ec26                	sd	s1,24(sp)
    800024e8:	e84a                	sd	s2,16(sp)
    800024ea:	e44e                	sd	s3,8(sp)
    800024ec:	e052                	sd	s4,0(sp)
    800024ee:	1800                	addi	s0,sp,48
    800024f0:	892a                	mv	s2,a0
    800024f2:	84ae                	mv	s1,a1
    800024f4:	89b2                	mv	s3,a2
    800024f6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024f8:	fffff097          	auipc	ra,0xfffff
    800024fc:	520080e7          	jalr	1312(ra) # 80001a18 <myproc>
  if(user_src){
    80002500:	c08d                	beqz	s1,80002522 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002502:	86d2                	mv	a3,s4
    80002504:	864e                	mv	a2,s3
    80002506:	85ca                	mv	a1,s2
    80002508:	6928                	ld	a0,80(a0)
    8000250a:	fffff097          	auipc	ra,0xfffff
    8000250e:	28e080e7          	jalr	654(ra) # 80001798 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002512:	70a2                	ld	ra,40(sp)
    80002514:	7402                	ld	s0,32(sp)
    80002516:	64e2                	ld	s1,24(sp)
    80002518:	6942                	ld	s2,16(sp)
    8000251a:	69a2                	ld	s3,8(sp)
    8000251c:	6a02                	ld	s4,0(sp)
    8000251e:	6145                	addi	sp,sp,48
    80002520:	8082                	ret
    memmove(dst, (char*)src, len);
    80002522:	000a061b          	sext.w	a2,s4
    80002526:	85ce                	mv	a1,s3
    80002528:	854a                	mv	a0,s2
    8000252a:	fffff097          	auipc	ra,0xfffff
    8000252e:	842080e7          	jalr	-1982(ra) # 80000d6c <memmove>
    return 0;
    80002532:	8526                	mv	a0,s1
    80002534:	bff9                	j	80002512 <either_copyin+0x32>

0000000080002536 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002536:	715d                	addi	sp,sp,-80
    80002538:	e486                	sd	ra,72(sp)
    8000253a:	e0a2                	sd	s0,64(sp)
    8000253c:	fc26                	sd	s1,56(sp)
    8000253e:	f84a                	sd	s2,48(sp)
    80002540:	f44e                	sd	s3,40(sp)
    80002542:	f052                	sd	s4,32(sp)
    80002544:	ec56                	sd	s5,24(sp)
    80002546:	e85a                	sd	s6,16(sp)
    80002548:	e45e                	sd	s7,8(sp)
    8000254a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000254c:	00006517          	auipc	a0,0x6
    80002550:	b7c50513          	addi	a0,a0,-1156 # 800080c8 <digits+0x88>
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	03e080e7          	jalr	62(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000255c:	00010497          	auipc	s1,0x10
    80002560:	96448493          	addi	s1,s1,-1692 # 80011ec0 <proc+0x158>
    80002564:	00015917          	auipc	s2,0x15
    80002568:	35c90913          	addi	s2,s2,860 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000256c:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000256e:	00006997          	auipc	s3,0x6
    80002572:	c9298993          	addi	s3,s3,-878 # 80008200 <digits+0x1c0>
    printf("%d %s %s", p->pid, state, p->name);
    80002576:	00006a97          	auipc	s5,0x6
    8000257a:	c92a8a93          	addi	s5,s5,-878 # 80008208 <digits+0x1c8>
    printf("\n");
    8000257e:	00006a17          	auipc	s4,0x6
    80002582:	b4aa0a13          	addi	s4,s4,-1206 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002586:	00006b97          	auipc	s7,0x6
    8000258a:	cbab8b93          	addi	s7,s7,-838 # 80008240 <states.1704>
    8000258e:	a00d                	j	800025b0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002590:	ee06a583          	lw	a1,-288(a3)
    80002594:	8556                	mv	a0,s5
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	ffc080e7          	jalr	-4(ra) # 80000592 <printf>
    printf("\n");
    8000259e:	8552                	mv	a0,s4
    800025a0:	ffffe097          	auipc	ra,0xffffe
    800025a4:	ff2080e7          	jalr	-14(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025a8:	16848493          	addi	s1,s1,360
    800025ac:	03248163          	beq	s1,s2,800025ce <procdump+0x98>
    if(p->state == UNUSED)
    800025b0:	86a6                	mv	a3,s1
    800025b2:	ec04a783          	lw	a5,-320(s1)
    800025b6:	dbed                	beqz	a5,800025a8 <procdump+0x72>
      state = "???";
    800025b8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025ba:	fcfb6be3          	bltu	s6,a5,80002590 <procdump+0x5a>
    800025be:	1782                	slli	a5,a5,0x20
    800025c0:	9381                	srli	a5,a5,0x20
    800025c2:	078e                	slli	a5,a5,0x3
    800025c4:	97de                	add	a5,a5,s7
    800025c6:	6390                	ld	a2,0(a5)
    800025c8:	f661                	bnez	a2,80002590 <procdump+0x5a>
      state = "???";
    800025ca:	864e                	mv	a2,s3
    800025cc:	b7d1                	j	80002590 <procdump+0x5a>
  }
}
    800025ce:	60a6                	ld	ra,72(sp)
    800025d0:	6406                	ld	s0,64(sp)
    800025d2:	74e2                	ld	s1,56(sp)
    800025d4:	7942                	ld	s2,48(sp)
    800025d6:	79a2                	ld	s3,40(sp)
    800025d8:	7a02                	ld	s4,32(sp)
    800025da:	6ae2                	ld	s5,24(sp)
    800025dc:	6b42                	ld	s6,16(sp)
    800025de:	6ba2                	ld	s7,8(sp)
    800025e0:	6161                	addi	sp,sp,80
    800025e2:	8082                	ret

00000000800025e4 <is_lazy>:

int is_lazy(uint64 va)
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84aa                	mv	s1,a0
  if((va < myproc()->sz) && (va > PGROUNDDOWN(myproc()->trapframe->sp)))
    800025f0:	fffff097          	auipc	ra,0xfffff
    800025f4:	428080e7          	jalr	1064(ra) # 80001a18 <myproc>
    800025f8:	653c                	ld	a5,72(a0)
  {
    return 1;
  }
  return 0;
    800025fa:	4501                	li	a0,0
  if((va < myproc()->sz) && (va > PGROUNDDOWN(myproc()->trapframe->sp)))
    800025fc:	00f4e763          	bltu	s1,a5,8000260a <is_lazy+0x26>
}
    80002600:	60e2                	ld	ra,24(sp)
    80002602:	6442                	ld	s0,16(sp)
    80002604:	64a2                	ld	s1,8(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret
  if((va < myproc()->sz) && (va > PGROUNDDOWN(myproc()->trapframe->sp)))
    8000260a:	fffff097          	auipc	ra,0xfffff
    8000260e:	40e080e7          	jalr	1038(ra) # 80001a18 <myproc>
    80002612:	6d3c                	ld	a5,88(a0)
    80002614:	7b9c                	ld	a5,48(a5)
    80002616:	757d                	lui	a0,0xfffff
    80002618:	8d7d                	and	a0,a0,a5
    return 1;
    8000261a:	00953533          	sltu	a0,a0,s1
    8000261e:	b7cd                	j	80002600 <is_lazy+0x1c>

0000000080002620 <swtch>:
    80002620:	00153023          	sd	ra,0(a0) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80002624:	00253423          	sd	sp,8(a0)
    80002628:	e900                	sd	s0,16(a0)
    8000262a:	ed04                	sd	s1,24(a0)
    8000262c:	03253023          	sd	s2,32(a0)
    80002630:	03353423          	sd	s3,40(a0)
    80002634:	03453823          	sd	s4,48(a0)
    80002638:	03553c23          	sd	s5,56(a0)
    8000263c:	05653023          	sd	s6,64(a0)
    80002640:	05753423          	sd	s7,72(a0)
    80002644:	05853823          	sd	s8,80(a0)
    80002648:	05953c23          	sd	s9,88(a0)
    8000264c:	07a53023          	sd	s10,96(a0)
    80002650:	07b53423          	sd	s11,104(a0)
    80002654:	0005b083          	ld	ra,0(a1)
    80002658:	0085b103          	ld	sp,8(a1)
    8000265c:	6980                	ld	s0,16(a1)
    8000265e:	6d84                	ld	s1,24(a1)
    80002660:	0205b903          	ld	s2,32(a1)
    80002664:	0285b983          	ld	s3,40(a1)
    80002668:	0305ba03          	ld	s4,48(a1)
    8000266c:	0385ba83          	ld	s5,56(a1)
    80002670:	0405bb03          	ld	s6,64(a1)
    80002674:	0485bb83          	ld	s7,72(a1)
    80002678:	0505bc03          	ld	s8,80(a1)
    8000267c:	0585bc83          	ld	s9,88(a1)
    80002680:	0605bd03          	ld	s10,96(a1)
    80002684:	0685bd83          	ld	s11,104(a1)
    80002688:	8082                	ret

000000008000268a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000268a:	1141                	addi	sp,sp,-16
    8000268c:	e406                	sd	ra,8(sp)
    8000268e:	e022                	sd	s0,0(sp)
    80002690:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002692:	00006597          	auipc	a1,0x6
    80002696:	bd658593          	addi	a1,a1,-1066 # 80008268 <states.1704+0x28>
    8000269a:	00015517          	auipc	a0,0x15
    8000269e:	0ce50513          	addi	a0,a0,206 # 80017768 <tickslock>
    800026a2:	ffffe097          	auipc	ra,0xffffe
    800026a6:	4de080e7          	jalr	1246(ra) # 80000b80 <initlock>
}
    800026aa:	60a2                	ld	ra,8(sp)
    800026ac:	6402                	ld	s0,0(sp)
    800026ae:	0141                	addi	sp,sp,16
    800026b0:	8082                	ret

00000000800026b2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800026b2:	1141                	addi	sp,sp,-16
    800026b4:	e422                	sd	s0,8(sp)
    800026b6:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800026b8:	00003797          	auipc	a5,0x3
    800026bc:	59878793          	addi	a5,a5,1432 # 80005c50 <kernelvec>
    800026c0:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800026c4:	6422                	ld	s0,8(sp)
    800026c6:	0141                	addi	sp,sp,16
    800026c8:	8082                	ret

00000000800026ca <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800026ca:	1141                	addi	sp,sp,-16
    800026cc:	e406                	sd	ra,8(sp)
    800026ce:	e022                	sd	s0,0(sp)
    800026d0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800026d2:	fffff097          	auipc	ra,0xfffff
    800026d6:	346080e7          	jalr	838(ra) # 80001a18 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800026de:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026e0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    800026e4:	00005617          	auipc	a2,0x5
    800026e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800026ec:	00005697          	auipc	a3,0x5
    800026f0:	91468693          	addi	a3,a3,-1772 # 80007000 <_trampoline>
    800026f4:	8e91                	sub	a3,a3,a2
    800026f6:	040007b7          	lui	a5,0x4000
    800026fa:	17fd                	addi	a5,a5,-1
    800026fc:	07b2                	slli	a5,a5,0xc
    800026fe:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002700:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002704:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002706:	180026f3          	csrr	a3,satp
    8000270a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000270c:	6d38                	ld	a4,88(a0)
    8000270e:	6134                	ld	a3,64(a0)
    80002710:	6585                	lui	a1,0x1
    80002712:	96ae                	add	a3,a3,a1
    80002714:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002716:	6d38                	ld	a4,88(a0)
    80002718:	00000697          	auipc	a3,0x0
    8000271c:	13868693          	addi	a3,a3,312 # 80002850 <usertrap>
    80002720:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002722:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002724:	8692                	mv	a3,tp
    80002726:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002728:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000272c:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002730:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002734:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002738:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000273a:	6f18                	ld	a4,24(a4)
    8000273c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002740:	692c                	ld	a1,80(a0)
    80002742:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80002744:	00005717          	auipc	a4,0x5
    80002748:	94c70713          	addi	a4,a4,-1716 # 80007090 <userret>
    8000274c:	8f11                	sub	a4,a4,a2
    8000274e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80002750:	577d                	li	a4,-1
    80002752:	177e                	slli	a4,a4,0x3f
    80002754:	8dd9                	or	a1,a1,a4
    80002756:	02000537          	lui	a0,0x2000
    8000275a:	157d                	addi	a0,a0,-1
    8000275c:	0536                	slli	a0,a0,0xd
    8000275e:	9782                	jalr	a5
}
    80002760:	60a2                	ld	ra,8(sp)
    80002762:	6402                	ld	s0,0(sp)
    80002764:	0141                	addi	sp,sp,16
    80002766:	8082                	ret

0000000080002768 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002772:	00015497          	auipc	s1,0x15
    80002776:	ff648493          	addi	s1,s1,-10 # 80017768 <tickslock>
    8000277a:	8526                	mv	a0,s1
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	494080e7          	jalr	1172(ra) # 80000c10 <acquire>
  ticks++;
    80002784:	00007517          	auipc	a0,0x7
    80002788:	89c50513          	addi	a0,a0,-1892 # 80009020 <ticks>
    8000278c:	411c                	lw	a5,0(a0)
    8000278e:	2785                	addiw	a5,a5,1
    80002790:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002792:	00000097          	auipc	ra,0x0
    80002796:	c1c080e7          	jalr	-996(ra) # 800023ae <wakeup>
  release(&tickslock);
    8000279a:	8526                	mv	a0,s1
    8000279c:	ffffe097          	auipc	ra,0xffffe
    800027a0:	528080e7          	jalr	1320(ra) # 80000cc4 <release>
}
    800027a4:	60e2                	ld	ra,24(sp)
    800027a6:	6442                	ld	s0,16(sp)
    800027a8:	64a2                	ld	s1,8(sp)
    800027aa:	6105                	addi	sp,sp,32
    800027ac:	8082                	ret

00000000800027ae <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800027b8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    800027bc:	00074d63          	bltz	a4,800027d6 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    800027c0:	57fd                	li	a5,-1
    800027c2:	17fe                	slli	a5,a5,0x3f
    800027c4:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    800027c6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    800027c8:	06f70363          	beq	a4,a5,8000282e <devintr+0x80>
  }
}
    800027cc:	60e2                	ld	ra,24(sp)
    800027ce:	6442                	ld	s0,16(sp)
    800027d0:	64a2                	ld	s1,8(sp)
    800027d2:	6105                	addi	sp,sp,32
    800027d4:	8082                	ret
     (scause & 0xff) == 9){
    800027d6:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    800027da:	46a5                	li	a3,9
    800027dc:	fed792e3          	bne	a5,a3,800027c0 <devintr+0x12>
    int irq = plic_claim();
    800027e0:	00003097          	auipc	ra,0x3
    800027e4:	578080e7          	jalr	1400(ra) # 80005d58 <plic_claim>
    800027e8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800027ea:	47a9                	li	a5,10
    800027ec:	02f50763          	beq	a0,a5,8000281a <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    800027f0:	4785                	li	a5,1
    800027f2:	02f50963          	beq	a0,a5,80002824 <devintr+0x76>
    return 1;
    800027f6:	4505                	li	a0,1
    } else if(irq){
    800027f8:	d8f1                	beqz	s1,800027cc <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    800027fa:	85a6                	mv	a1,s1
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	a7450513          	addi	a0,a0,-1420 # 80008270 <states.1704+0x30>
    80002804:	ffffe097          	auipc	ra,0xffffe
    80002808:	d8e080e7          	jalr	-626(ra) # 80000592 <printf>
      plic_complete(irq);
    8000280c:	8526                	mv	a0,s1
    8000280e:	00003097          	auipc	ra,0x3
    80002812:	56e080e7          	jalr	1390(ra) # 80005d7c <plic_complete>
    return 1;
    80002816:	4505                	li	a0,1
    80002818:	bf55                	j	800027cc <devintr+0x1e>
      uartintr();
    8000281a:	ffffe097          	auipc	ra,0xffffe
    8000281e:	1ba080e7          	jalr	442(ra) # 800009d4 <uartintr>
    80002822:	b7ed                	j	8000280c <devintr+0x5e>
      virtio_disk_intr();
    80002824:	00004097          	auipc	ra,0x4
    80002828:	9f2080e7          	jalr	-1550(ra) # 80006216 <virtio_disk_intr>
    8000282c:	b7c5                	j	8000280c <devintr+0x5e>
    if(cpuid() == 0){
    8000282e:	fffff097          	auipc	ra,0xfffff
    80002832:	1be080e7          	jalr	446(ra) # 800019ec <cpuid>
    80002836:	c901                	beqz	a0,80002846 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002838:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    8000283c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000283e:	14479073          	csrw	sip,a5
    return 2;
    80002842:	4509                	li	a0,2
    80002844:	b761                	j	800027cc <devintr+0x1e>
      clockintr();
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	f22080e7          	jalr	-222(ra) # 80002768 <clockintr>
    8000284e:	b7ed                	j	80002838 <devintr+0x8a>

0000000080002850 <usertrap>:
{
    80002850:	7179                	addi	sp,sp,-48
    80002852:	f406                	sd	ra,40(sp)
    80002854:	f022                	sd	s0,32(sp)
    80002856:	ec26                	sd	s1,24(sp)
    80002858:	e84a                	sd	s2,16(sp)
    8000285a:	e44e                	sd	s3,8(sp)
    8000285c:	e052                	sd	s4,0(sp)
    8000285e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002860:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002864:	1007f793          	andi	a5,a5,256
    80002868:	e7a5                	bnez	a5,800028d0 <usertrap+0x80>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000286a:	00003797          	auipc	a5,0x3
    8000286e:	3e678793          	addi	a5,a5,998 # 80005c50 <kernelvec>
    80002872:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002876:	fffff097          	auipc	ra,0xfffff
    8000287a:	1a2080e7          	jalr	418(ra) # 80001a18 <myproc>
    8000287e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002880:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002882:	14102773          	csrr	a4,sepc
    80002886:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002888:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000288c:	47a1                	li	a5,8
    8000288e:	04f71f63          	bne	a4,a5,800028ec <usertrap+0x9c>
    if(p->killed)
    80002892:	591c                	lw	a5,48(a0)
    80002894:	e7b1                	bnez	a5,800028e0 <usertrap+0x90>
    p->trapframe->epc += 4;
    80002896:	6cb8                	ld	a4,88(s1)
    80002898:	6f1c                	ld	a5,24(a4)
    8000289a:	0791                	addi	a5,a5,4
    8000289c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000289e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800028a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028a6:	10079073          	csrw	sstatus,a5
    syscall();
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	38c080e7          	jalr	908(ra) # 80002c36 <syscall>
  if(p->killed)
    800028b2:	589c                	lw	a5,48(s1)
    800028b4:	12079263          	bnez	a5,800029d8 <usertrap+0x188>
  usertrapret();
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	e12080e7          	jalr	-494(ra) # 800026ca <usertrapret>
}
    800028c0:	70a2                	ld	ra,40(sp)
    800028c2:	7402                	ld	s0,32(sp)
    800028c4:	64e2                	ld	s1,24(sp)
    800028c6:	6942                	ld	s2,16(sp)
    800028c8:	69a2                	ld	s3,8(sp)
    800028ca:	6a02                	ld	s4,0(sp)
    800028cc:	6145                	addi	sp,sp,48
    800028ce:	8082                	ret
    panic("usertrap: not from user mode");
    800028d0:	00006517          	auipc	a0,0x6
    800028d4:	9c050513          	addi	a0,a0,-1600 # 80008290 <states.1704+0x50>
    800028d8:	ffffe097          	auipc	ra,0xffffe
    800028dc:	c70080e7          	jalr	-912(ra) # 80000548 <panic>
      exit(-1);
    800028e0:	557d                	li	a0,-1
    800028e2:	00000097          	auipc	ra,0x0
    800028e6:	800080e7          	jalr	-2048(ra) # 800020e2 <exit>
    800028ea:	b775                	j	80002896 <usertrap+0x46>
  } else if((which_dev = devintr()) != 0){
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	ec2080e7          	jalr	-318(ra) # 800027ae <devintr>
    800028f4:	892a                	mv	s2,a0
    800028f6:	ed71                	bnez	a0,800029d2 <usertrap+0x182>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028f8:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15 || r_scause() == 13){
    800028fc:	47bd                	li	a5,15
    800028fe:	00f70763          	beq	a4,a5,8000290c <usertrap+0xbc>
    80002902:	14202773          	csrr	a4,scause
    80002906:	47b5                	li	a5,13
    80002908:	08f71b63          	bne	a4,a5,8000299e <usertrap+0x14e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000290c:	143029f3          	csrr	s3,stval
    if((va < p->sz) && (va > PGROUNDDOWN(p->trapframe->sp))){
    80002910:	64bc                	ld	a5,72(s1)
    80002912:	00f9f863          	bgeu	s3,a5,80002922 <usertrap+0xd2>
    80002916:	6cbc                	ld	a5,88(s1)
    80002918:	7b98                	ld	a4,48(a5)
    8000291a:	77fd                	lui	a5,0xfffff
    8000291c:	8ff9                	and	a5,a5,a4
    8000291e:	0137ed63          	bltu	a5,s3,80002938 <usertrap+0xe8>
      p->killed = 1;
    80002922:	4785                	li	a5,1
    80002924:	d89c                	sw	a5,48(s1)
      printf("lazy alloc illegal va\n");
    80002926:	00006517          	auipc	a0,0x6
    8000292a:	9ba50513          	addi	a0,a0,-1606 # 800082e0 <states.1704+0xa0>
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	c64080e7          	jalr	-924(ra) # 80000592 <printf>
    80002936:	bfb5                	j	800028b2 <usertrap+0x62>
      mem = kalloc();
    80002938:	ffffe097          	auipc	ra,0xffffe
    8000293c:	1e8080e7          	jalr	488(ra) # 80000b20 <kalloc>
    80002940:	8a2a                	mv	s4,a0
      if (mem ==0)
    80002942:	c139                	beqz	a0,80002988 <usertrap+0x138>
        memset(mem,0,PGSIZE);
    80002944:	6605                	lui	a2,0x1
    80002946:	4581                	li	a1,0
    80002948:	ffffe097          	auipc	ra,0xffffe
    8000294c:	3c4080e7          	jalr	964(ra) # 80000d0c <memset>
        if(mappages(p->pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U) != 0)
    80002950:	4779                	li	a4,30
    80002952:	86d2                	mv	a3,s4
    80002954:	6605                	lui	a2,0x1
    80002956:	75fd                	lui	a1,0xfffff
    80002958:	00b9f5b3          	and	a1,s3,a1
    8000295c:	68a8                	ld	a0,80(s1)
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	79e080e7          	jalr	1950(ra) # 800010fc <mappages>
    80002966:	d531                	beqz	a0,800028b2 <usertrap+0x62>
          kfree(mem);
    80002968:	8552                	mv	a0,s4
    8000296a:	ffffe097          	auipc	ra,0xffffe
    8000296e:	0ba080e7          	jalr	186(ra) # 80000a24 <kfree>
          p->killed = 1;
    80002972:	4785                	li	a5,1
    80002974:	d89c                	sw	a5,48(s1)
          printf("lazy alloc cannot map\n");
    80002976:	00006517          	auipc	a0,0x6
    8000297a:	95250513          	addi	a0,a0,-1710 # 800082c8 <states.1704+0x88>
    8000297e:	ffffe097          	auipc	ra,0xffffe
    80002982:	c14080e7          	jalr	-1004(ra) # 80000592 <printf>
    80002986:	b735                	j	800028b2 <usertrap+0x62>
        printf("lazy alloc no memery\n");
    80002988:	00006517          	auipc	a0,0x6
    8000298c:	92850513          	addi	a0,a0,-1752 # 800082b0 <states.1704+0x70>
    80002990:	ffffe097          	auipc	ra,0xffffe
    80002994:	c02080e7          	jalr	-1022(ra) # 80000592 <printf>
        p->killed = 1;
    80002998:	4785                	li	a5,1
    8000299a:	d89c                	sw	a5,48(s1)
    8000299c:	a83d                	j	800029da <usertrap+0x18a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000299e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800029a2:	5c90                	lw	a2,56(s1)
    800029a4:	00006517          	auipc	a0,0x6
    800029a8:	95450513          	addi	a0,a0,-1708 # 800082f8 <states.1704+0xb8>
    800029ac:	ffffe097          	auipc	ra,0xffffe
    800029b0:	be6080e7          	jalr	-1050(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029b8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800029bc:	00006517          	auipc	a0,0x6
    800029c0:	96c50513          	addi	a0,a0,-1684 # 80008328 <states.1704+0xe8>
    800029c4:	ffffe097          	auipc	ra,0xffffe
    800029c8:	bce080e7          	jalr	-1074(ra) # 80000592 <printf>
    p->killed = 1;
    800029cc:	4785                	li	a5,1
    800029ce:	d89c                	sw	a5,48(s1)
    800029d0:	a029                	j	800029da <usertrap+0x18a>
  if(p->killed)
    800029d2:	589c                	lw	a5,48(s1)
    800029d4:	cb81                	beqz	a5,800029e4 <usertrap+0x194>
    800029d6:	a011                	j	800029da <usertrap+0x18a>
    800029d8:	4901                	li	s2,0
    exit(-1);
    800029da:	557d                	li	a0,-1
    800029dc:	fffff097          	auipc	ra,0xfffff
    800029e0:	706080e7          	jalr	1798(ra) # 800020e2 <exit>
  if(which_dev == 2)
    800029e4:	4789                	li	a5,2
    800029e6:	ecf919e3          	bne	s2,a5,800028b8 <usertrap+0x68>
    yield();
    800029ea:	00000097          	auipc	ra,0x0
    800029ee:	802080e7          	jalr	-2046(ra) # 800021ec <yield>
    800029f2:	b5d9                	j	800028b8 <usertrap+0x68>

00000000800029f4 <kerneltrap>:
{
    800029f4:	7179                	addi	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a02:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a06:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a0a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a0e:	1004f793          	andi	a5,s1,256
    80002a12:	cb85                	beqz	a5,80002a42 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a14:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a18:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a1a:	ef85                	bnez	a5,80002a52 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	d92080e7          	jalr	-622(ra) # 800027ae <devintr>
    80002a24:	cd1d                	beqz	a0,80002a62 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a26:	4789                	li	a5,2
    80002a28:	06f50a63          	beq	a0,a5,80002a9c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a2c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a30:	10049073          	csrw	sstatus,s1
}
    80002a34:	70a2                	ld	ra,40(sp)
    80002a36:	7402                	ld	s0,32(sp)
    80002a38:	64e2                	ld	s1,24(sp)
    80002a3a:	6942                	ld	s2,16(sp)
    80002a3c:	69a2                	ld	s3,8(sp)
    80002a3e:	6145                	addi	sp,sp,48
    80002a40:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a42:	00006517          	auipc	a0,0x6
    80002a46:	90650513          	addi	a0,a0,-1786 # 80008348 <states.1704+0x108>
    80002a4a:	ffffe097          	auipc	ra,0xffffe
    80002a4e:	afe080e7          	jalr	-1282(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a52:	00006517          	auipc	a0,0x6
    80002a56:	91e50513          	addi	a0,a0,-1762 # 80008370 <states.1704+0x130>
    80002a5a:	ffffe097          	auipc	ra,0xffffe
    80002a5e:	aee080e7          	jalr	-1298(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002a62:	85ce                	mv	a1,s3
    80002a64:	00006517          	auipc	a0,0x6
    80002a68:	92c50513          	addi	a0,a0,-1748 # 80008390 <states.1704+0x150>
    80002a6c:	ffffe097          	auipc	ra,0xffffe
    80002a70:	b26080e7          	jalr	-1242(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a78:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002a7c:	00006517          	auipc	a0,0x6
    80002a80:	92450513          	addi	a0,a0,-1756 # 800083a0 <states.1704+0x160>
    80002a84:	ffffe097          	auipc	ra,0xffffe
    80002a88:	b0e080e7          	jalr	-1266(ra) # 80000592 <printf>
    panic("kerneltrap");
    80002a8c:	00006517          	auipc	a0,0x6
    80002a90:	92c50513          	addi	a0,a0,-1748 # 800083b8 <states.1704+0x178>
    80002a94:	ffffe097          	auipc	ra,0xffffe
    80002a98:	ab4080e7          	jalr	-1356(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002a9c:	fffff097          	auipc	ra,0xfffff
    80002aa0:	f7c080e7          	jalr	-132(ra) # 80001a18 <myproc>
    80002aa4:	d541                	beqz	a0,80002a2c <kerneltrap+0x38>
    80002aa6:	fffff097          	auipc	ra,0xfffff
    80002aaa:	f72080e7          	jalr	-142(ra) # 80001a18 <myproc>
    80002aae:	4d18                	lw	a4,24(a0)
    80002ab0:	478d                	li	a5,3
    80002ab2:	f6f71de3          	bne	a4,a5,80002a2c <kerneltrap+0x38>
    yield();
    80002ab6:	fffff097          	auipc	ra,0xfffff
    80002aba:	736080e7          	jalr	1846(ra) # 800021ec <yield>
    80002abe:	b7bd                	j	80002a2c <kerneltrap+0x38>

0000000080002ac0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002ac0:	1101                	addi	sp,sp,-32
    80002ac2:	ec06                	sd	ra,24(sp)
    80002ac4:	e822                	sd	s0,16(sp)
    80002ac6:	e426                	sd	s1,8(sp)
    80002ac8:	1000                	addi	s0,sp,32
    80002aca:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002acc:	fffff097          	auipc	ra,0xfffff
    80002ad0:	f4c080e7          	jalr	-180(ra) # 80001a18 <myproc>
  switch (n) {
    80002ad4:	4795                	li	a5,5
    80002ad6:	0497e163          	bltu	a5,s1,80002b18 <argraw+0x58>
    80002ada:	048a                	slli	s1,s1,0x2
    80002adc:	00006717          	auipc	a4,0x6
    80002ae0:	91470713          	addi	a4,a4,-1772 # 800083f0 <states.1704+0x1b0>
    80002ae4:	94ba                	add	s1,s1,a4
    80002ae6:	409c                	lw	a5,0(s1)
    80002ae8:	97ba                	add	a5,a5,a4
    80002aea:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002aec:	6d3c                	ld	a5,88(a0)
    80002aee:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6105                	addi	sp,sp,32
    80002af8:	8082                	ret
    return p->trapframe->a1;
    80002afa:	6d3c                	ld	a5,88(a0)
    80002afc:	7fa8                	ld	a0,120(a5)
    80002afe:	bfcd                	j	80002af0 <argraw+0x30>
    return p->trapframe->a2;
    80002b00:	6d3c                	ld	a5,88(a0)
    80002b02:	63c8                	ld	a0,128(a5)
    80002b04:	b7f5                	j	80002af0 <argraw+0x30>
    return p->trapframe->a3;
    80002b06:	6d3c                	ld	a5,88(a0)
    80002b08:	67c8                	ld	a0,136(a5)
    80002b0a:	b7dd                	j	80002af0 <argraw+0x30>
    return p->trapframe->a4;
    80002b0c:	6d3c                	ld	a5,88(a0)
    80002b0e:	6bc8                	ld	a0,144(a5)
    80002b10:	b7c5                	j	80002af0 <argraw+0x30>
    return p->trapframe->a5;
    80002b12:	6d3c                	ld	a5,88(a0)
    80002b14:	6fc8                	ld	a0,152(a5)
    80002b16:	bfe9                	j	80002af0 <argraw+0x30>
  panic("argraw");
    80002b18:	00006517          	auipc	a0,0x6
    80002b1c:	8b050513          	addi	a0,a0,-1872 # 800083c8 <states.1704+0x188>
    80002b20:	ffffe097          	auipc	ra,0xffffe
    80002b24:	a28080e7          	jalr	-1496(ra) # 80000548 <panic>

0000000080002b28 <fetchaddr>:
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
    80002b34:	84aa                	mv	s1,a0
    80002b36:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b38:	fffff097          	auipc	ra,0xfffff
    80002b3c:	ee0080e7          	jalr	-288(ra) # 80001a18 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002b40:	653c                	ld	a5,72(a0)
    80002b42:	02f4f863          	bgeu	s1,a5,80002b72 <fetchaddr+0x4a>
    80002b46:	00848713          	addi	a4,s1,8
    80002b4a:	02e7e663          	bltu	a5,a4,80002b76 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b4e:	46a1                	li	a3,8
    80002b50:	8626                	mv	a2,s1
    80002b52:	85ca                	mv	a1,s2
    80002b54:	6928                	ld	a0,80(a0)
    80002b56:	fffff097          	auipc	ra,0xfffff
    80002b5a:	c42080e7          	jalr	-958(ra) # 80001798 <copyin>
    80002b5e:	00a03533          	snez	a0,a0
    80002b62:	40a00533          	neg	a0,a0
}
    80002b66:	60e2                	ld	ra,24(sp)
    80002b68:	6442                	ld	s0,16(sp)
    80002b6a:	64a2                	ld	s1,8(sp)
    80002b6c:	6902                	ld	s2,0(sp)
    80002b6e:	6105                	addi	sp,sp,32
    80002b70:	8082                	ret
    return -1;
    80002b72:	557d                	li	a0,-1
    80002b74:	bfcd                	j	80002b66 <fetchaddr+0x3e>
    80002b76:	557d                	li	a0,-1
    80002b78:	b7fd                	j	80002b66 <fetchaddr+0x3e>

0000000080002b7a <fetchstr>:
{
    80002b7a:	7179                	addi	sp,sp,-48
    80002b7c:	f406                	sd	ra,40(sp)
    80002b7e:	f022                	sd	s0,32(sp)
    80002b80:	ec26                	sd	s1,24(sp)
    80002b82:	e84a                	sd	s2,16(sp)
    80002b84:	e44e                	sd	s3,8(sp)
    80002b86:	1800                	addi	s0,sp,48
    80002b88:	892a                	mv	s2,a0
    80002b8a:	84ae                	mv	s1,a1
    80002b8c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b8e:	fffff097          	auipc	ra,0xfffff
    80002b92:	e8a080e7          	jalr	-374(ra) # 80001a18 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002b96:	86ce                	mv	a3,s3
    80002b98:	864a                	mv	a2,s2
    80002b9a:	85a6                	mv	a1,s1
    80002b9c:	6928                	ld	a0,80(a0)
    80002b9e:	fffff097          	auipc	ra,0xfffff
    80002ba2:	c86080e7          	jalr	-890(ra) # 80001824 <copyinstr>
  if(err < 0)
    80002ba6:	00054763          	bltz	a0,80002bb4 <fetchstr+0x3a>
  return strlen(buf);
    80002baa:	8526                	mv	a0,s1
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	2e8080e7          	jalr	744(ra) # 80000e94 <strlen>
}
    80002bb4:	70a2                	ld	ra,40(sp)
    80002bb6:	7402                	ld	s0,32(sp)
    80002bb8:	64e2                	ld	s1,24(sp)
    80002bba:	6942                	ld	s2,16(sp)
    80002bbc:	69a2                	ld	s3,8(sp)
    80002bbe:	6145                	addi	sp,sp,48
    80002bc0:	8082                	ret

0000000080002bc2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	1000                	addi	s0,sp,32
    80002bcc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	ef2080e7          	jalr	-270(ra) # 80002ac0 <argraw>
    80002bd6:	c088                	sw	a0,0(s1)
  return 0;
}
    80002bd8:	4501                	li	a0,0
    80002bda:	60e2                	ld	ra,24(sp)
    80002bdc:	6442                	ld	s0,16(sp)
    80002bde:	64a2                	ld	s1,8(sp)
    80002be0:	6105                	addi	sp,sp,32
    80002be2:	8082                	ret

0000000080002be4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	e426                	sd	s1,8(sp)
    80002bec:	1000                	addi	s0,sp,32
    80002bee:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bf0:	00000097          	auipc	ra,0x0
    80002bf4:	ed0080e7          	jalr	-304(ra) # 80002ac0 <argraw>
    80002bf8:	e088                	sd	a0,0(s1)
  return 0;
}
    80002bfa:	4501                	li	a0,0
    80002bfc:	60e2                	ld	ra,24(sp)
    80002bfe:	6442                	ld	s0,16(sp)
    80002c00:	64a2                	ld	s1,8(sp)
    80002c02:	6105                	addi	sp,sp,32
    80002c04:	8082                	ret

0000000080002c06 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002c06:	1101                	addi	sp,sp,-32
    80002c08:	ec06                	sd	ra,24(sp)
    80002c0a:	e822                	sd	s0,16(sp)
    80002c0c:	e426                	sd	s1,8(sp)
    80002c0e:	e04a                	sd	s2,0(sp)
    80002c10:	1000                	addi	s0,sp,32
    80002c12:	84ae                	mv	s1,a1
    80002c14:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002c16:	00000097          	auipc	ra,0x0
    80002c1a:	eaa080e7          	jalr	-342(ra) # 80002ac0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002c1e:	864a                	mv	a2,s2
    80002c20:	85a6                	mv	a1,s1
    80002c22:	00000097          	auipc	ra,0x0
    80002c26:	f58080e7          	jalr	-168(ra) # 80002b7a <fetchstr>
}
    80002c2a:	60e2                	ld	ra,24(sp)
    80002c2c:	6442                	ld	s0,16(sp)
    80002c2e:	64a2                	ld	s1,8(sp)
    80002c30:	6902                	ld	s2,0(sp)
    80002c32:	6105                	addi	sp,sp,32
    80002c34:	8082                	ret

0000000080002c36 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002c36:	1101                	addi	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	e426                	sd	s1,8(sp)
    80002c3e:	e04a                	sd	s2,0(sp)
    80002c40:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c42:	fffff097          	auipc	ra,0xfffff
    80002c46:	dd6080e7          	jalr	-554(ra) # 80001a18 <myproc>
    80002c4a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c4c:	05853903          	ld	s2,88(a0)
    80002c50:	0a893783          	ld	a5,168(s2)
    80002c54:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c58:	37fd                	addiw	a5,a5,-1
    80002c5a:	4751                	li	a4,20
    80002c5c:	00f76f63          	bltu	a4,a5,80002c7a <syscall+0x44>
    80002c60:	00369713          	slli	a4,a3,0x3
    80002c64:	00005797          	auipc	a5,0x5
    80002c68:	7a478793          	addi	a5,a5,1956 # 80008408 <syscalls>
    80002c6c:	97ba                	add	a5,a5,a4
    80002c6e:	639c                	ld	a5,0(a5)
    80002c70:	c789                	beqz	a5,80002c7a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002c72:	9782                	jalr	a5
    80002c74:	06a93823          	sd	a0,112(s2)
    80002c78:	a839                	j	80002c96 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c7a:	15848613          	addi	a2,s1,344
    80002c7e:	5c8c                	lw	a1,56(s1)
    80002c80:	00005517          	auipc	a0,0x5
    80002c84:	75050513          	addi	a0,a0,1872 # 800083d0 <states.1704+0x190>
    80002c88:	ffffe097          	auipc	ra,0xffffe
    80002c8c:	90a080e7          	jalr	-1782(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c90:	6cbc                	ld	a5,88(s1)
    80002c92:	577d                	li	a4,-1
    80002c94:	fbb8                	sd	a4,112(a5)
  }
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	64a2                	ld	s1,8(sp)
    80002c9c:	6902                	ld	s2,0(sp)
    80002c9e:	6105                	addi	sp,sp,32
    80002ca0:	8082                	ret

0000000080002ca2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002ca2:	1101                	addi	sp,sp,-32
    80002ca4:	ec06                	sd	ra,24(sp)
    80002ca6:	e822                	sd	s0,16(sp)
    80002ca8:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002caa:	fec40593          	addi	a1,s0,-20
    80002cae:	4501                	li	a0,0
    80002cb0:	00000097          	auipc	ra,0x0
    80002cb4:	f12080e7          	jalr	-238(ra) # 80002bc2 <argint>
    return -1;
    80002cb8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002cba:	00054963          	bltz	a0,80002ccc <sys_exit+0x2a>
  exit(n);
    80002cbe:	fec42503          	lw	a0,-20(s0)
    80002cc2:	fffff097          	auipc	ra,0xfffff
    80002cc6:	420080e7          	jalr	1056(ra) # 800020e2 <exit>
  return 0;  // not reached
    80002cca:	4781                	li	a5,0
}
    80002ccc:	853e                	mv	a0,a5
    80002cce:	60e2                	ld	ra,24(sp)
    80002cd0:	6442                	ld	s0,16(sp)
    80002cd2:	6105                	addi	sp,sp,32
    80002cd4:	8082                	ret

0000000080002cd6 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002cd6:	1141                	addi	sp,sp,-16
    80002cd8:	e406                	sd	ra,8(sp)
    80002cda:	e022                	sd	s0,0(sp)
    80002cdc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002cde:	fffff097          	auipc	ra,0xfffff
    80002ce2:	d3a080e7          	jalr	-710(ra) # 80001a18 <myproc>
}
    80002ce6:	5d08                	lw	a0,56(a0)
    80002ce8:	60a2                	ld	ra,8(sp)
    80002cea:	6402                	ld	s0,0(sp)
    80002cec:	0141                	addi	sp,sp,16
    80002cee:	8082                	ret

0000000080002cf0 <sys_fork>:

uint64
sys_fork(void)
{
    80002cf0:	1141                	addi	sp,sp,-16
    80002cf2:	e406                	sd	ra,8(sp)
    80002cf4:	e022                	sd	s0,0(sp)
    80002cf6:	0800                	addi	s0,sp,16
  return fork();
    80002cf8:	fffff097          	auipc	ra,0xfffff
    80002cfc:	0e0080e7          	jalr	224(ra) # 80001dd8 <fork>
}
    80002d00:	60a2                	ld	ra,8(sp)
    80002d02:	6402                	ld	s0,0(sp)
    80002d04:	0141                	addi	sp,sp,16
    80002d06:	8082                	ret

0000000080002d08 <sys_wait>:

uint64
sys_wait(void)
{
    80002d08:	1101                	addi	sp,sp,-32
    80002d0a:	ec06                	sd	ra,24(sp)
    80002d0c:	e822                	sd	s0,16(sp)
    80002d0e:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002d10:	fe840593          	addi	a1,s0,-24
    80002d14:	4501                	li	a0,0
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	ece080e7          	jalr	-306(ra) # 80002be4 <argaddr>
    80002d1e:	87aa                	mv	a5,a0
    return -1;
    80002d20:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002d22:	0007c863          	bltz	a5,80002d32 <sys_wait+0x2a>
  return wait(p);
    80002d26:	fe843503          	ld	a0,-24(s0)
    80002d2a:	fffff097          	auipc	ra,0xfffff
    80002d2e:	57c080e7          	jalr	1404(ra) # 800022a6 <wait>
}
    80002d32:	60e2                	ld	ra,24(sp)
    80002d34:	6442                	ld	s0,16(sp)
    80002d36:	6105                	addi	sp,sp,32
    80002d38:	8082                	ret

0000000080002d3a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002d3a:	7179                	addi	sp,sp,-48
    80002d3c:	f406                	sd	ra,40(sp)
    80002d3e:	f022                	sd	s0,32(sp)
    80002d40:	ec26                	sd	s1,24(sp)
    80002d42:	e84a                	sd	s2,16(sp)
    80002d44:	1800                	addi	s0,sp,48
  int addr;
  int n;
  struct proc *p = myproc();
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	cd2080e7          	jalr	-814(ra) # 80001a18 <myproc>
    80002d4e:	84aa                	mv	s1,a0
  if(argint(0, &n) < 0)
    80002d50:	fdc40593          	addi	a1,s0,-36
    80002d54:	4501                	li	a0,0
    80002d56:	00000097          	auipc	ra,0x0
    80002d5a:	e6c080e7          	jalr	-404(ra) # 80002bc2 <argint>
    80002d5e:	02054f63          	bltz	a0,80002d9c <sys_sbrk+0x62>
    return -1;
  addr = p->sz;
    80002d62:	64bc                	ld	a5,72(s1)
    80002d64:	0007891b          	sext.w	s2,a5
  if(n<0)
    80002d68:	fdc42603          	lw	a2,-36(s0)
    80002d6c:	00064b63          	bltz	a2,80002d82 <sys_sbrk+0x48>
    else{
      p->sz = uvmdealloc(p->pagetable, addr, addr + n);
    }
  }else
  {
    p->sz = p->sz + n;
    80002d70:	963e                	add	a2,a2,a5
    80002d72:	e4b0                	sd	a2,72(s1)
  }
  
  // if(growproc(n) < 0)
  //   return -1;
  return addr;
    80002d74:	854a                	mv	a0,s2
}
    80002d76:	70a2                	ld	ra,40(sp)
    80002d78:	7402                	ld	s0,32(sp)
    80002d7a:	64e2                	ld	s1,24(sp)
    80002d7c:	6942                	ld	s2,16(sp)
    80002d7e:	6145                	addi	sp,sp,48
    80002d80:	8082                	ret
    if((addr+n)<0)
    80002d82:	0126063b          	addw	a2,a2,s2
      return -1;
    80002d86:	557d                	li	a0,-1
    if((addr+n)<0)
    80002d88:	fe0647e3          	bltz	a2,80002d76 <sys_sbrk+0x3c>
      p->sz = uvmdealloc(p->pagetable, addr, addr + n);
    80002d8c:	85ca                	mv	a1,s2
    80002d8e:	68a8                	ld	a0,80(s1)
    80002d90:	ffffe097          	auipc	ra,0xffffe
    80002d94:	700080e7          	jalr	1792(ra) # 80001490 <uvmdealloc>
    80002d98:	e4a8                	sd	a0,72(s1)
    80002d9a:	bfe9                	j	80002d74 <sys_sbrk+0x3a>
    return -1;
    80002d9c:	557d                	li	a0,-1
    80002d9e:	bfe1                	j	80002d76 <sys_sbrk+0x3c>

0000000080002da0 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002da0:	7139                	addi	sp,sp,-64
    80002da2:	fc06                	sd	ra,56(sp)
    80002da4:	f822                	sd	s0,48(sp)
    80002da6:	f426                	sd	s1,40(sp)
    80002da8:	f04a                	sd	s2,32(sp)
    80002daa:	ec4e                	sd	s3,24(sp)
    80002dac:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002dae:	fcc40593          	addi	a1,s0,-52
    80002db2:	4501                	li	a0,0
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	e0e080e7          	jalr	-498(ra) # 80002bc2 <argint>
    return -1;
    80002dbc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002dbe:	06054563          	bltz	a0,80002e28 <sys_sleep+0x88>
  acquire(&tickslock);
    80002dc2:	00015517          	auipc	a0,0x15
    80002dc6:	9a650513          	addi	a0,a0,-1626 # 80017768 <tickslock>
    80002dca:	ffffe097          	auipc	ra,0xffffe
    80002dce:	e46080e7          	jalr	-442(ra) # 80000c10 <acquire>
  ticks0 = ticks;
    80002dd2:	00006917          	auipc	s2,0x6
    80002dd6:	24e92903          	lw	s2,590(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002dda:	fcc42783          	lw	a5,-52(s0)
    80002dde:	cf85                	beqz	a5,80002e16 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002de0:	00015997          	auipc	s3,0x15
    80002de4:	98898993          	addi	s3,s3,-1656 # 80017768 <tickslock>
    80002de8:	00006497          	auipc	s1,0x6
    80002dec:	23848493          	addi	s1,s1,568 # 80009020 <ticks>
    if(myproc()->killed){
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	c28080e7          	jalr	-984(ra) # 80001a18 <myproc>
    80002df8:	591c                	lw	a5,48(a0)
    80002dfa:	ef9d                	bnez	a5,80002e38 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002dfc:	85ce                	mv	a1,s3
    80002dfe:	8526                	mv	a0,s1
    80002e00:	fffff097          	auipc	ra,0xfffff
    80002e04:	428080e7          	jalr	1064(ra) # 80002228 <sleep>
  while(ticks - ticks0 < n){
    80002e08:	409c                	lw	a5,0(s1)
    80002e0a:	412787bb          	subw	a5,a5,s2
    80002e0e:	fcc42703          	lw	a4,-52(s0)
    80002e12:	fce7efe3          	bltu	a5,a4,80002df0 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002e16:	00015517          	auipc	a0,0x15
    80002e1a:	95250513          	addi	a0,a0,-1710 # 80017768 <tickslock>
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	ea6080e7          	jalr	-346(ra) # 80000cc4 <release>
  return 0;
    80002e26:	4781                	li	a5,0
}
    80002e28:	853e                	mv	a0,a5
    80002e2a:	70e2                	ld	ra,56(sp)
    80002e2c:	7442                	ld	s0,48(sp)
    80002e2e:	74a2                	ld	s1,40(sp)
    80002e30:	7902                	ld	s2,32(sp)
    80002e32:	69e2                	ld	s3,24(sp)
    80002e34:	6121                	addi	sp,sp,64
    80002e36:	8082                	ret
      release(&tickslock);
    80002e38:	00015517          	auipc	a0,0x15
    80002e3c:	93050513          	addi	a0,a0,-1744 # 80017768 <tickslock>
    80002e40:	ffffe097          	auipc	ra,0xffffe
    80002e44:	e84080e7          	jalr	-380(ra) # 80000cc4 <release>
      return -1;
    80002e48:	57fd                	li	a5,-1
    80002e4a:	bff9                	j	80002e28 <sys_sleep+0x88>

0000000080002e4c <sys_kill>:

uint64
sys_kill(void)
{
    80002e4c:	1101                	addi	sp,sp,-32
    80002e4e:	ec06                	sd	ra,24(sp)
    80002e50:	e822                	sd	s0,16(sp)
    80002e52:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002e54:	fec40593          	addi	a1,s0,-20
    80002e58:	4501                	li	a0,0
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	d68080e7          	jalr	-664(ra) # 80002bc2 <argint>
    80002e62:	87aa                	mv	a5,a0
    return -1;
    80002e64:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002e66:	0007c863          	bltz	a5,80002e76 <sys_kill+0x2a>
  return kill(pid);
    80002e6a:	fec42503          	lw	a0,-20(s0)
    80002e6e:	fffff097          	auipc	ra,0xfffff
    80002e72:	5aa080e7          	jalr	1450(ra) # 80002418 <kill>
}
    80002e76:	60e2                	ld	ra,24(sp)
    80002e78:	6442                	ld	s0,16(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret

0000000080002e7e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002e7e:	1101                	addi	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	e426                	sd	s1,8(sp)
    80002e86:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002e88:	00015517          	auipc	a0,0x15
    80002e8c:	8e050513          	addi	a0,a0,-1824 # 80017768 <tickslock>
    80002e90:	ffffe097          	auipc	ra,0xffffe
    80002e94:	d80080e7          	jalr	-640(ra) # 80000c10 <acquire>
  xticks = ticks;
    80002e98:	00006497          	auipc	s1,0x6
    80002e9c:	1884a483          	lw	s1,392(s1) # 80009020 <ticks>
  release(&tickslock);
    80002ea0:	00015517          	auipc	a0,0x15
    80002ea4:	8c850513          	addi	a0,a0,-1848 # 80017768 <tickslock>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	e1c080e7          	jalr	-484(ra) # 80000cc4 <release>
  return xticks;
}
    80002eb0:	02049513          	slli	a0,s1,0x20
    80002eb4:	9101                	srli	a0,a0,0x20
    80002eb6:	60e2                	ld	ra,24(sp)
    80002eb8:	6442                	ld	s0,16(sp)
    80002eba:	64a2                	ld	s1,8(sp)
    80002ebc:	6105                	addi	sp,sp,32
    80002ebe:	8082                	ret

0000000080002ec0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ec0:	7179                	addi	sp,sp,-48
    80002ec2:	f406                	sd	ra,40(sp)
    80002ec4:	f022                	sd	s0,32(sp)
    80002ec6:	ec26                	sd	s1,24(sp)
    80002ec8:	e84a                	sd	s2,16(sp)
    80002eca:	e44e                	sd	s3,8(sp)
    80002ecc:	e052                	sd	s4,0(sp)
    80002ece:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ed0:	00005597          	auipc	a1,0x5
    80002ed4:	5e858593          	addi	a1,a1,1512 # 800084b8 <syscalls+0xb0>
    80002ed8:	00015517          	auipc	a0,0x15
    80002edc:	8a850513          	addi	a0,a0,-1880 # 80017780 <bcache>
    80002ee0:	ffffe097          	auipc	ra,0xffffe
    80002ee4:	ca0080e7          	jalr	-864(ra) # 80000b80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002ee8:	0001d797          	auipc	a5,0x1d
    80002eec:	89878793          	addi	a5,a5,-1896 # 8001f780 <bcache+0x8000>
    80002ef0:	0001d717          	auipc	a4,0x1d
    80002ef4:	af870713          	addi	a4,a4,-1288 # 8001f9e8 <bcache+0x8268>
    80002ef8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002efc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f00:	00015497          	auipc	s1,0x15
    80002f04:	89848493          	addi	s1,s1,-1896 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002f08:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002f0a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002f0c:	00005a17          	auipc	s4,0x5
    80002f10:	5b4a0a13          	addi	s4,s4,1460 # 800084c0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002f14:	2b893783          	ld	a5,696(s2)
    80002f18:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002f1a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002f1e:	85d2                	mv	a1,s4
    80002f20:	01048513          	addi	a0,s1,16
    80002f24:	00001097          	auipc	ra,0x1
    80002f28:	4b0080e7          	jalr	1200(ra) # 800043d4 <initsleeplock>
    bcache.head.next->prev = b;
    80002f2c:	2b893783          	ld	a5,696(s2)
    80002f30:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002f32:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002f36:	45848493          	addi	s1,s1,1112
    80002f3a:	fd349de3          	bne	s1,s3,80002f14 <binit+0x54>
  }
}
    80002f3e:	70a2                	ld	ra,40(sp)
    80002f40:	7402                	ld	s0,32(sp)
    80002f42:	64e2                	ld	s1,24(sp)
    80002f44:	6942                	ld	s2,16(sp)
    80002f46:	69a2                	ld	s3,8(sp)
    80002f48:	6a02                	ld	s4,0(sp)
    80002f4a:	6145                	addi	sp,sp,48
    80002f4c:	8082                	ret

0000000080002f4e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f4e:	7179                	addi	sp,sp,-48
    80002f50:	f406                	sd	ra,40(sp)
    80002f52:	f022                	sd	s0,32(sp)
    80002f54:	ec26                	sd	s1,24(sp)
    80002f56:	e84a                	sd	s2,16(sp)
    80002f58:	e44e                	sd	s3,8(sp)
    80002f5a:	1800                	addi	s0,sp,48
    80002f5c:	89aa                	mv	s3,a0
    80002f5e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002f60:	00015517          	auipc	a0,0x15
    80002f64:	82050513          	addi	a0,a0,-2016 # 80017780 <bcache>
    80002f68:	ffffe097          	auipc	ra,0xffffe
    80002f6c:	ca8080e7          	jalr	-856(ra) # 80000c10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f70:	0001d497          	auipc	s1,0x1d
    80002f74:	ac84b483          	ld	s1,-1336(s1) # 8001fa38 <bcache+0x82b8>
    80002f78:	0001d797          	auipc	a5,0x1d
    80002f7c:	a7078793          	addi	a5,a5,-1424 # 8001f9e8 <bcache+0x8268>
    80002f80:	02f48f63          	beq	s1,a5,80002fbe <bread+0x70>
    80002f84:	873e                	mv	a4,a5
    80002f86:	a021                	j	80002f8e <bread+0x40>
    80002f88:	68a4                	ld	s1,80(s1)
    80002f8a:	02e48a63          	beq	s1,a4,80002fbe <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f8e:	449c                	lw	a5,8(s1)
    80002f90:	ff379ce3          	bne	a5,s3,80002f88 <bread+0x3a>
    80002f94:	44dc                	lw	a5,12(s1)
    80002f96:	ff2799e3          	bne	a5,s2,80002f88 <bread+0x3a>
      b->refcnt++;
    80002f9a:	40bc                	lw	a5,64(s1)
    80002f9c:	2785                	addiw	a5,a5,1
    80002f9e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fa0:	00014517          	auipc	a0,0x14
    80002fa4:	7e050513          	addi	a0,a0,2016 # 80017780 <bcache>
    80002fa8:	ffffe097          	auipc	ra,0xffffe
    80002fac:	d1c080e7          	jalr	-740(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80002fb0:	01048513          	addi	a0,s1,16
    80002fb4:	00001097          	auipc	ra,0x1
    80002fb8:	45a080e7          	jalr	1114(ra) # 8000440e <acquiresleep>
      return b;
    80002fbc:	a8b9                	j	8000301a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fbe:	0001d497          	auipc	s1,0x1d
    80002fc2:	a724b483          	ld	s1,-1422(s1) # 8001fa30 <bcache+0x82b0>
    80002fc6:	0001d797          	auipc	a5,0x1d
    80002fca:	a2278793          	addi	a5,a5,-1502 # 8001f9e8 <bcache+0x8268>
    80002fce:	00f48863          	beq	s1,a5,80002fde <bread+0x90>
    80002fd2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002fd4:	40bc                	lw	a5,64(s1)
    80002fd6:	cf81                	beqz	a5,80002fee <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fd8:	64a4                	ld	s1,72(s1)
    80002fda:	fee49de3          	bne	s1,a4,80002fd4 <bread+0x86>
  panic("bget: no buffers");
    80002fde:	00005517          	auipc	a0,0x5
    80002fe2:	4ea50513          	addi	a0,a0,1258 # 800084c8 <syscalls+0xc0>
    80002fe6:	ffffd097          	auipc	ra,0xffffd
    80002fea:	562080e7          	jalr	1378(ra) # 80000548 <panic>
      b->dev = dev;
    80002fee:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002ff2:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002ff6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002ffa:	4785                	li	a5,1
    80002ffc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002ffe:	00014517          	auipc	a0,0x14
    80003002:	78250513          	addi	a0,a0,1922 # 80017780 <bcache>
    80003006:	ffffe097          	auipc	ra,0xffffe
    8000300a:	cbe080e7          	jalr	-834(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    8000300e:	01048513          	addi	a0,s1,16
    80003012:	00001097          	auipc	ra,0x1
    80003016:	3fc080e7          	jalr	1020(ra) # 8000440e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000301a:	409c                	lw	a5,0(s1)
    8000301c:	cb89                	beqz	a5,8000302e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000301e:	8526                	mv	a0,s1
    80003020:	70a2                	ld	ra,40(sp)
    80003022:	7402                	ld	s0,32(sp)
    80003024:	64e2                	ld	s1,24(sp)
    80003026:	6942                	ld	s2,16(sp)
    80003028:	69a2                	ld	s3,8(sp)
    8000302a:	6145                	addi	sp,sp,48
    8000302c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000302e:	4581                	li	a1,0
    80003030:	8526                	mv	a0,s1
    80003032:	00003097          	auipc	ra,0x3
    80003036:	f3a080e7          	jalr	-198(ra) # 80005f6c <virtio_disk_rw>
    b->valid = 1;
    8000303a:	4785                	li	a5,1
    8000303c:	c09c                	sw	a5,0(s1)
  return b;
    8000303e:	b7c5                	j	8000301e <bread+0xd0>

0000000080003040 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003040:	1101                	addi	sp,sp,-32
    80003042:	ec06                	sd	ra,24(sp)
    80003044:	e822                	sd	s0,16(sp)
    80003046:	e426                	sd	s1,8(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000304c:	0541                	addi	a0,a0,16
    8000304e:	00001097          	auipc	ra,0x1
    80003052:	45a080e7          	jalr	1114(ra) # 800044a8 <holdingsleep>
    80003056:	cd01                	beqz	a0,8000306e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003058:	4585                	li	a1,1
    8000305a:	8526                	mv	a0,s1
    8000305c:	00003097          	auipc	ra,0x3
    80003060:	f10080e7          	jalr	-240(ra) # 80005f6c <virtio_disk_rw>
}
    80003064:	60e2                	ld	ra,24(sp)
    80003066:	6442                	ld	s0,16(sp)
    80003068:	64a2                	ld	s1,8(sp)
    8000306a:	6105                	addi	sp,sp,32
    8000306c:	8082                	ret
    panic("bwrite");
    8000306e:	00005517          	auipc	a0,0x5
    80003072:	47250513          	addi	a0,a0,1138 # 800084e0 <syscalls+0xd8>
    80003076:	ffffd097          	auipc	ra,0xffffd
    8000307a:	4d2080e7          	jalr	1234(ra) # 80000548 <panic>

000000008000307e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000307e:	1101                	addi	sp,sp,-32
    80003080:	ec06                	sd	ra,24(sp)
    80003082:	e822                	sd	s0,16(sp)
    80003084:	e426                	sd	s1,8(sp)
    80003086:	e04a                	sd	s2,0(sp)
    80003088:	1000                	addi	s0,sp,32
    8000308a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000308c:	01050913          	addi	s2,a0,16
    80003090:	854a                	mv	a0,s2
    80003092:	00001097          	auipc	ra,0x1
    80003096:	416080e7          	jalr	1046(ra) # 800044a8 <holdingsleep>
    8000309a:	c92d                	beqz	a0,8000310c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000309c:	854a                	mv	a0,s2
    8000309e:	00001097          	auipc	ra,0x1
    800030a2:	3c6080e7          	jalr	966(ra) # 80004464 <releasesleep>

  acquire(&bcache.lock);
    800030a6:	00014517          	auipc	a0,0x14
    800030aa:	6da50513          	addi	a0,a0,1754 # 80017780 <bcache>
    800030ae:	ffffe097          	auipc	ra,0xffffe
    800030b2:	b62080e7          	jalr	-1182(ra) # 80000c10 <acquire>
  b->refcnt--;
    800030b6:	40bc                	lw	a5,64(s1)
    800030b8:	37fd                	addiw	a5,a5,-1
    800030ba:	0007871b          	sext.w	a4,a5
    800030be:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800030c0:	eb05                	bnez	a4,800030f0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800030c2:	68bc                	ld	a5,80(s1)
    800030c4:	64b8                	ld	a4,72(s1)
    800030c6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800030c8:	64bc                	ld	a5,72(s1)
    800030ca:	68b8                	ld	a4,80(s1)
    800030cc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800030ce:	0001c797          	auipc	a5,0x1c
    800030d2:	6b278793          	addi	a5,a5,1714 # 8001f780 <bcache+0x8000>
    800030d6:	2b87b703          	ld	a4,696(a5)
    800030da:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030dc:	0001d717          	auipc	a4,0x1d
    800030e0:	90c70713          	addi	a4,a4,-1780 # 8001f9e8 <bcache+0x8268>
    800030e4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030e6:	2b87b703          	ld	a4,696(a5)
    800030ea:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030ec:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030f0:	00014517          	auipc	a0,0x14
    800030f4:	69050513          	addi	a0,a0,1680 # 80017780 <bcache>
    800030f8:	ffffe097          	auipc	ra,0xffffe
    800030fc:	bcc080e7          	jalr	-1076(ra) # 80000cc4 <release>
}
    80003100:	60e2                	ld	ra,24(sp)
    80003102:	6442                	ld	s0,16(sp)
    80003104:	64a2                	ld	s1,8(sp)
    80003106:	6902                	ld	s2,0(sp)
    80003108:	6105                	addi	sp,sp,32
    8000310a:	8082                	ret
    panic("brelse");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	3dc50513          	addi	a0,a0,988 # 800084e8 <syscalls+0xe0>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	434080e7          	jalr	1076(ra) # 80000548 <panic>

000000008000311c <bpin>:

void
bpin(struct buf *b) {
    8000311c:	1101                	addi	sp,sp,-32
    8000311e:	ec06                	sd	ra,24(sp)
    80003120:	e822                	sd	s0,16(sp)
    80003122:	e426                	sd	s1,8(sp)
    80003124:	1000                	addi	s0,sp,32
    80003126:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003128:	00014517          	auipc	a0,0x14
    8000312c:	65850513          	addi	a0,a0,1624 # 80017780 <bcache>
    80003130:	ffffe097          	auipc	ra,0xffffe
    80003134:	ae0080e7          	jalr	-1312(ra) # 80000c10 <acquire>
  b->refcnt++;
    80003138:	40bc                	lw	a5,64(s1)
    8000313a:	2785                	addiw	a5,a5,1
    8000313c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000313e:	00014517          	auipc	a0,0x14
    80003142:	64250513          	addi	a0,a0,1602 # 80017780 <bcache>
    80003146:	ffffe097          	auipc	ra,0xffffe
    8000314a:	b7e080e7          	jalr	-1154(ra) # 80000cc4 <release>
}
    8000314e:	60e2                	ld	ra,24(sp)
    80003150:	6442                	ld	s0,16(sp)
    80003152:	64a2                	ld	s1,8(sp)
    80003154:	6105                	addi	sp,sp,32
    80003156:	8082                	ret

0000000080003158 <bunpin>:

void
bunpin(struct buf *b) {
    80003158:	1101                	addi	sp,sp,-32
    8000315a:	ec06                	sd	ra,24(sp)
    8000315c:	e822                	sd	s0,16(sp)
    8000315e:	e426                	sd	s1,8(sp)
    80003160:	1000                	addi	s0,sp,32
    80003162:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003164:	00014517          	auipc	a0,0x14
    80003168:	61c50513          	addi	a0,a0,1564 # 80017780 <bcache>
    8000316c:	ffffe097          	auipc	ra,0xffffe
    80003170:	aa4080e7          	jalr	-1372(ra) # 80000c10 <acquire>
  b->refcnt--;
    80003174:	40bc                	lw	a5,64(s1)
    80003176:	37fd                	addiw	a5,a5,-1
    80003178:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000317a:	00014517          	auipc	a0,0x14
    8000317e:	60650513          	addi	a0,a0,1542 # 80017780 <bcache>
    80003182:	ffffe097          	auipc	ra,0xffffe
    80003186:	b42080e7          	jalr	-1214(ra) # 80000cc4 <release>
}
    8000318a:	60e2                	ld	ra,24(sp)
    8000318c:	6442                	ld	s0,16(sp)
    8000318e:	64a2                	ld	s1,8(sp)
    80003190:	6105                	addi	sp,sp,32
    80003192:	8082                	ret

0000000080003194 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	e04a                	sd	s2,0(sp)
    8000319e:	1000                	addi	s0,sp,32
    800031a0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800031a2:	00d5d59b          	srliw	a1,a1,0xd
    800031a6:	0001d797          	auipc	a5,0x1d
    800031aa:	cb67a783          	lw	a5,-842(a5) # 8001fe5c <sb+0x1c>
    800031ae:	9dbd                	addw	a1,a1,a5
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	d9e080e7          	jalr	-610(ra) # 80002f4e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800031b8:	0074f713          	andi	a4,s1,7
    800031bc:	4785                	li	a5,1
    800031be:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800031c2:	14ce                	slli	s1,s1,0x33
    800031c4:	90d9                	srli	s1,s1,0x36
    800031c6:	00950733          	add	a4,a0,s1
    800031ca:	05874703          	lbu	a4,88(a4)
    800031ce:	00e7f6b3          	and	a3,a5,a4
    800031d2:	c69d                	beqz	a3,80003200 <bfree+0x6c>
    800031d4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800031d6:	94aa                	add	s1,s1,a0
    800031d8:	fff7c793          	not	a5,a5
    800031dc:	8ff9                	and	a5,a5,a4
    800031de:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800031e2:	00001097          	auipc	ra,0x1
    800031e6:	104080e7          	jalr	260(ra) # 800042e6 <log_write>
  brelse(bp);
    800031ea:	854a                	mv	a0,s2
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	e92080e7          	jalr	-366(ra) # 8000307e <brelse>
}
    800031f4:	60e2                	ld	ra,24(sp)
    800031f6:	6442                	ld	s0,16(sp)
    800031f8:	64a2                	ld	s1,8(sp)
    800031fa:	6902                	ld	s2,0(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret
    panic("freeing free block");
    80003200:	00005517          	auipc	a0,0x5
    80003204:	2f050513          	addi	a0,a0,752 # 800084f0 <syscalls+0xe8>
    80003208:	ffffd097          	auipc	ra,0xffffd
    8000320c:	340080e7          	jalr	832(ra) # 80000548 <panic>

0000000080003210 <balloc>:
{
    80003210:	711d                	addi	sp,sp,-96
    80003212:	ec86                	sd	ra,88(sp)
    80003214:	e8a2                	sd	s0,80(sp)
    80003216:	e4a6                	sd	s1,72(sp)
    80003218:	e0ca                	sd	s2,64(sp)
    8000321a:	fc4e                	sd	s3,56(sp)
    8000321c:	f852                	sd	s4,48(sp)
    8000321e:	f456                	sd	s5,40(sp)
    80003220:	f05a                	sd	s6,32(sp)
    80003222:	ec5e                	sd	s7,24(sp)
    80003224:	e862                	sd	s8,16(sp)
    80003226:	e466                	sd	s9,8(sp)
    80003228:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000322a:	0001d797          	auipc	a5,0x1d
    8000322e:	c1a7a783          	lw	a5,-998(a5) # 8001fe44 <sb+0x4>
    80003232:	cbd1                	beqz	a5,800032c6 <balloc+0xb6>
    80003234:	8baa                	mv	s7,a0
    80003236:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003238:	0001db17          	auipc	s6,0x1d
    8000323c:	c08b0b13          	addi	s6,s6,-1016 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003240:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003242:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003244:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003246:	6c89                	lui	s9,0x2
    80003248:	a831                	j	80003264 <balloc+0x54>
    brelse(bp);
    8000324a:	854a                	mv	a0,s2
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	e32080e7          	jalr	-462(ra) # 8000307e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003254:	015c87bb          	addw	a5,s9,s5
    80003258:	00078a9b          	sext.w	s5,a5
    8000325c:	004b2703          	lw	a4,4(s6)
    80003260:	06eaf363          	bgeu	s5,a4,800032c6 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003264:	41fad79b          	sraiw	a5,s5,0x1f
    80003268:	0137d79b          	srliw	a5,a5,0x13
    8000326c:	015787bb          	addw	a5,a5,s5
    80003270:	40d7d79b          	sraiw	a5,a5,0xd
    80003274:	01cb2583          	lw	a1,28(s6)
    80003278:	9dbd                	addw	a1,a1,a5
    8000327a:	855e                	mv	a0,s7
    8000327c:	00000097          	auipc	ra,0x0
    80003280:	cd2080e7          	jalr	-814(ra) # 80002f4e <bread>
    80003284:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003286:	004b2503          	lw	a0,4(s6)
    8000328a:	000a849b          	sext.w	s1,s5
    8000328e:	8662                	mv	a2,s8
    80003290:	faa4fde3          	bgeu	s1,a0,8000324a <balloc+0x3a>
      m = 1 << (bi % 8);
    80003294:	41f6579b          	sraiw	a5,a2,0x1f
    80003298:	01d7d69b          	srliw	a3,a5,0x1d
    8000329c:	00c6873b          	addw	a4,a3,a2
    800032a0:	00777793          	andi	a5,a4,7
    800032a4:	9f95                	subw	a5,a5,a3
    800032a6:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800032aa:	4037571b          	sraiw	a4,a4,0x3
    800032ae:	00e906b3          	add	a3,s2,a4
    800032b2:	0586c683          	lbu	a3,88(a3)
    800032b6:	00d7f5b3          	and	a1,a5,a3
    800032ba:	cd91                	beqz	a1,800032d6 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800032bc:	2605                	addiw	a2,a2,1
    800032be:	2485                	addiw	s1,s1,1
    800032c0:	fd4618e3          	bne	a2,s4,80003290 <balloc+0x80>
    800032c4:	b759                	j	8000324a <balloc+0x3a>
  panic("balloc: out of blocks");
    800032c6:	00005517          	auipc	a0,0x5
    800032ca:	24250513          	addi	a0,a0,578 # 80008508 <syscalls+0x100>
    800032ce:	ffffd097          	auipc	ra,0xffffd
    800032d2:	27a080e7          	jalr	634(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800032d6:	974a                	add	a4,a4,s2
    800032d8:	8fd5                	or	a5,a5,a3
    800032da:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800032de:	854a                	mv	a0,s2
    800032e0:	00001097          	auipc	ra,0x1
    800032e4:	006080e7          	jalr	6(ra) # 800042e6 <log_write>
        brelse(bp);
    800032e8:	854a                	mv	a0,s2
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	d94080e7          	jalr	-620(ra) # 8000307e <brelse>
  bp = bread(dev, bno);
    800032f2:	85a6                	mv	a1,s1
    800032f4:	855e                	mv	a0,s7
    800032f6:	00000097          	auipc	ra,0x0
    800032fa:	c58080e7          	jalr	-936(ra) # 80002f4e <bread>
    800032fe:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003300:	40000613          	li	a2,1024
    80003304:	4581                	li	a1,0
    80003306:	05850513          	addi	a0,a0,88
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	a02080e7          	jalr	-1534(ra) # 80000d0c <memset>
  log_write(bp);
    80003312:	854a                	mv	a0,s2
    80003314:	00001097          	auipc	ra,0x1
    80003318:	fd2080e7          	jalr	-46(ra) # 800042e6 <log_write>
  brelse(bp);
    8000331c:	854a                	mv	a0,s2
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	d60080e7          	jalr	-672(ra) # 8000307e <brelse>
}
    80003326:	8526                	mv	a0,s1
    80003328:	60e6                	ld	ra,88(sp)
    8000332a:	6446                	ld	s0,80(sp)
    8000332c:	64a6                	ld	s1,72(sp)
    8000332e:	6906                	ld	s2,64(sp)
    80003330:	79e2                	ld	s3,56(sp)
    80003332:	7a42                	ld	s4,48(sp)
    80003334:	7aa2                	ld	s5,40(sp)
    80003336:	7b02                	ld	s6,32(sp)
    80003338:	6be2                	ld	s7,24(sp)
    8000333a:	6c42                	ld	s8,16(sp)
    8000333c:	6ca2                	ld	s9,8(sp)
    8000333e:	6125                	addi	sp,sp,96
    80003340:	8082                	ret

0000000080003342 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003342:	7179                	addi	sp,sp,-48
    80003344:	f406                	sd	ra,40(sp)
    80003346:	f022                	sd	s0,32(sp)
    80003348:	ec26                	sd	s1,24(sp)
    8000334a:	e84a                	sd	s2,16(sp)
    8000334c:	e44e                	sd	s3,8(sp)
    8000334e:	e052                	sd	s4,0(sp)
    80003350:	1800                	addi	s0,sp,48
    80003352:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003354:	47ad                	li	a5,11
    80003356:	04b7fe63          	bgeu	a5,a1,800033b2 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000335a:	ff45849b          	addiw	s1,a1,-12
    8000335e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003362:	0ff00793          	li	a5,255
    80003366:	0ae7e363          	bltu	a5,a4,8000340c <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000336a:	08052583          	lw	a1,128(a0)
    8000336e:	c5ad                	beqz	a1,800033d8 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003370:	00092503          	lw	a0,0(s2)
    80003374:	00000097          	auipc	ra,0x0
    80003378:	bda080e7          	jalr	-1062(ra) # 80002f4e <bread>
    8000337c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000337e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003382:	02049593          	slli	a1,s1,0x20
    80003386:	9181                	srli	a1,a1,0x20
    80003388:	058a                	slli	a1,a1,0x2
    8000338a:	00b784b3          	add	s1,a5,a1
    8000338e:	0004a983          	lw	s3,0(s1)
    80003392:	04098d63          	beqz	s3,800033ec <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80003396:	8552                	mv	a0,s4
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	ce6080e7          	jalr	-794(ra) # 8000307e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800033a0:	854e                	mv	a0,s3
    800033a2:	70a2                	ld	ra,40(sp)
    800033a4:	7402                	ld	s0,32(sp)
    800033a6:	64e2                	ld	s1,24(sp)
    800033a8:	6942                	ld	s2,16(sp)
    800033aa:	69a2                	ld	s3,8(sp)
    800033ac:	6a02                	ld	s4,0(sp)
    800033ae:	6145                	addi	sp,sp,48
    800033b0:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800033b2:	02059493          	slli	s1,a1,0x20
    800033b6:	9081                	srli	s1,s1,0x20
    800033b8:	048a                	slli	s1,s1,0x2
    800033ba:	94aa                	add	s1,s1,a0
    800033bc:	0504a983          	lw	s3,80(s1)
    800033c0:	fe0990e3          	bnez	s3,800033a0 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800033c4:	4108                	lw	a0,0(a0)
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	e4a080e7          	jalr	-438(ra) # 80003210 <balloc>
    800033ce:	0005099b          	sext.w	s3,a0
    800033d2:	0534a823          	sw	s3,80(s1)
    800033d6:	b7e9                	j	800033a0 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800033d8:	4108                	lw	a0,0(a0)
    800033da:	00000097          	auipc	ra,0x0
    800033de:	e36080e7          	jalr	-458(ra) # 80003210 <balloc>
    800033e2:	0005059b          	sext.w	a1,a0
    800033e6:	08b92023          	sw	a1,128(s2)
    800033ea:	b759                	j	80003370 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800033ec:	00092503          	lw	a0,0(s2)
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	e20080e7          	jalr	-480(ra) # 80003210 <balloc>
    800033f8:	0005099b          	sext.w	s3,a0
    800033fc:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003400:	8552                	mv	a0,s4
    80003402:	00001097          	auipc	ra,0x1
    80003406:	ee4080e7          	jalr	-284(ra) # 800042e6 <log_write>
    8000340a:	b771                	j	80003396 <bmap+0x54>
  panic("bmap: out of range");
    8000340c:	00005517          	auipc	a0,0x5
    80003410:	11450513          	addi	a0,a0,276 # 80008520 <syscalls+0x118>
    80003414:	ffffd097          	auipc	ra,0xffffd
    80003418:	134080e7          	jalr	308(ra) # 80000548 <panic>

000000008000341c <iget>:
{
    8000341c:	7179                	addi	sp,sp,-48
    8000341e:	f406                	sd	ra,40(sp)
    80003420:	f022                	sd	s0,32(sp)
    80003422:	ec26                	sd	s1,24(sp)
    80003424:	e84a                	sd	s2,16(sp)
    80003426:	e44e                	sd	s3,8(sp)
    80003428:	e052                	sd	s4,0(sp)
    8000342a:	1800                	addi	s0,sp,48
    8000342c:	89aa                	mv	s3,a0
    8000342e:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003430:	0001d517          	auipc	a0,0x1d
    80003434:	a3050513          	addi	a0,a0,-1488 # 8001fe60 <icache>
    80003438:	ffffd097          	auipc	ra,0xffffd
    8000343c:	7d8080e7          	jalr	2008(ra) # 80000c10 <acquire>
  empty = 0;
    80003440:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003442:	0001d497          	auipc	s1,0x1d
    80003446:	a3648493          	addi	s1,s1,-1482 # 8001fe78 <icache+0x18>
    8000344a:	0001e697          	auipc	a3,0x1e
    8000344e:	4be68693          	addi	a3,a3,1214 # 80021908 <log>
    80003452:	a039                	j	80003460 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003454:	02090b63          	beqz	s2,8000348a <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003458:	08848493          	addi	s1,s1,136
    8000345c:	02d48a63          	beq	s1,a3,80003490 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003460:	449c                	lw	a5,8(s1)
    80003462:	fef059e3          	blez	a5,80003454 <iget+0x38>
    80003466:	4098                	lw	a4,0(s1)
    80003468:	ff3716e3          	bne	a4,s3,80003454 <iget+0x38>
    8000346c:	40d8                	lw	a4,4(s1)
    8000346e:	ff4713e3          	bne	a4,s4,80003454 <iget+0x38>
      ip->ref++;
    80003472:	2785                	addiw	a5,a5,1
    80003474:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    80003476:	0001d517          	auipc	a0,0x1d
    8000347a:	9ea50513          	addi	a0,a0,-1558 # 8001fe60 <icache>
    8000347e:	ffffe097          	auipc	ra,0xffffe
    80003482:	846080e7          	jalr	-1978(ra) # 80000cc4 <release>
      return ip;
    80003486:	8926                	mv	s2,s1
    80003488:	a03d                	j	800034b6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000348a:	f7f9                	bnez	a5,80003458 <iget+0x3c>
    8000348c:	8926                	mv	s2,s1
    8000348e:	b7e9                	j	80003458 <iget+0x3c>
  if(empty == 0)
    80003490:	02090c63          	beqz	s2,800034c8 <iget+0xac>
  ip->dev = dev;
    80003494:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003498:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000349c:	4785                	li	a5,1
    8000349e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800034a2:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    800034a6:	0001d517          	auipc	a0,0x1d
    800034aa:	9ba50513          	addi	a0,a0,-1606 # 8001fe60 <icache>
    800034ae:	ffffe097          	auipc	ra,0xffffe
    800034b2:	816080e7          	jalr	-2026(ra) # 80000cc4 <release>
}
    800034b6:	854a                	mv	a0,s2
    800034b8:	70a2                	ld	ra,40(sp)
    800034ba:	7402                	ld	s0,32(sp)
    800034bc:	64e2                	ld	s1,24(sp)
    800034be:	6942                	ld	s2,16(sp)
    800034c0:	69a2                	ld	s3,8(sp)
    800034c2:	6a02                	ld	s4,0(sp)
    800034c4:	6145                	addi	sp,sp,48
    800034c6:	8082                	ret
    panic("iget: no inodes");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	07050513          	addi	a0,a0,112 # 80008538 <syscalls+0x130>
    800034d0:	ffffd097          	auipc	ra,0xffffd
    800034d4:	078080e7          	jalr	120(ra) # 80000548 <panic>

00000000800034d8 <fsinit>:
fsinit(int dev) {
    800034d8:	7179                	addi	sp,sp,-48
    800034da:	f406                	sd	ra,40(sp)
    800034dc:	f022                	sd	s0,32(sp)
    800034de:	ec26                	sd	s1,24(sp)
    800034e0:	e84a                	sd	s2,16(sp)
    800034e2:	e44e                	sd	s3,8(sp)
    800034e4:	1800                	addi	s0,sp,48
    800034e6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034e8:	4585                	li	a1,1
    800034ea:	00000097          	auipc	ra,0x0
    800034ee:	a64080e7          	jalr	-1436(ra) # 80002f4e <bread>
    800034f2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034f4:	0001d997          	auipc	s3,0x1d
    800034f8:	94c98993          	addi	s3,s3,-1716 # 8001fe40 <sb>
    800034fc:	02000613          	li	a2,32
    80003500:	05850593          	addi	a1,a0,88
    80003504:	854e                	mv	a0,s3
    80003506:	ffffe097          	auipc	ra,0xffffe
    8000350a:	866080e7          	jalr	-1946(ra) # 80000d6c <memmove>
  brelse(bp);
    8000350e:	8526                	mv	a0,s1
    80003510:	00000097          	auipc	ra,0x0
    80003514:	b6e080e7          	jalr	-1170(ra) # 8000307e <brelse>
  if(sb.magic != FSMAGIC)
    80003518:	0009a703          	lw	a4,0(s3)
    8000351c:	102037b7          	lui	a5,0x10203
    80003520:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003524:	02f71263          	bne	a4,a5,80003548 <fsinit+0x70>
  initlog(dev, &sb);
    80003528:	0001d597          	auipc	a1,0x1d
    8000352c:	91858593          	addi	a1,a1,-1768 # 8001fe40 <sb>
    80003530:	854a                	mv	a0,s2
    80003532:	00001097          	auipc	ra,0x1
    80003536:	b3c080e7          	jalr	-1220(ra) # 8000406e <initlog>
}
    8000353a:	70a2                	ld	ra,40(sp)
    8000353c:	7402                	ld	s0,32(sp)
    8000353e:	64e2                	ld	s1,24(sp)
    80003540:	6942                	ld	s2,16(sp)
    80003542:	69a2                	ld	s3,8(sp)
    80003544:	6145                	addi	sp,sp,48
    80003546:	8082                	ret
    panic("invalid file system");
    80003548:	00005517          	auipc	a0,0x5
    8000354c:	00050513          	mv	a0,a0
    80003550:	ffffd097          	auipc	ra,0xffffd
    80003554:	ff8080e7          	jalr	-8(ra) # 80000548 <panic>

0000000080003558 <iinit>:
{
    80003558:	7179                	addi	sp,sp,-48
    8000355a:	f406                	sd	ra,40(sp)
    8000355c:	f022                	sd	s0,32(sp)
    8000355e:	ec26                	sd	s1,24(sp)
    80003560:	e84a                	sd	s2,16(sp)
    80003562:	e44e                	sd	s3,8(sp)
    80003564:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    80003566:	00005597          	auipc	a1,0x5
    8000356a:	ffa58593          	addi	a1,a1,-6 # 80008560 <syscalls+0x158>
    8000356e:	0001d517          	auipc	a0,0x1d
    80003572:	8f250513          	addi	a0,a0,-1806 # 8001fe60 <icache>
    80003576:	ffffd097          	auipc	ra,0xffffd
    8000357a:	60a080e7          	jalr	1546(ra) # 80000b80 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000357e:	0001d497          	auipc	s1,0x1d
    80003582:	90a48493          	addi	s1,s1,-1782 # 8001fe88 <icache+0x28>
    80003586:	0001e997          	auipc	s3,0x1e
    8000358a:	39298993          	addi	s3,s3,914 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    8000358e:	00005917          	auipc	s2,0x5
    80003592:	fda90913          	addi	s2,s2,-38 # 80008568 <syscalls+0x160>
    80003596:	85ca                	mv	a1,s2
    80003598:	8526                	mv	a0,s1
    8000359a:	00001097          	auipc	ra,0x1
    8000359e:	e3a080e7          	jalr	-454(ra) # 800043d4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800035a2:	08848493          	addi	s1,s1,136
    800035a6:	ff3498e3          	bne	s1,s3,80003596 <iinit+0x3e>
}
    800035aa:	70a2                	ld	ra,40(sp)
    800035ac:	7402                	ld	s0,32(sp)
    800035ae:	64e2                	ld	s1,24(sp)
    800035b0:	6942                	ld	s2,16(sp)
    800035b2:	69a2                	ld	s3,8(sp)
    800035b4:	6145                	addi	sp,sp,48
    800035b6:	8082                	ret

00000000800035b8 <ialloc>:
{
    800035b8:	715d                	addi	sp,sp,-80
    800035ba:	e486                	sd	ra,72(sp)
    800035bc:	e0a2                	sd	s0,64(sp)
    800035be:	fc26                	sd	s1,56(sp)
    800035c0:	f84a                	sd	s2,48(sp)
    800035c2:	f44e                	sd	s3,40(sp)
    800035c4:	f052                	sd	s4,32(sp)
    800035c6:	ec56                	sd	s5,24(sp)
    800035c8:	e85a                	sd	s6,16(sp)
    800035ca:	e45e                	sd	s7,8(sp)
    800035cc:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    800035ce:	0001d717          	auipc	a4,0x1d
    800035d2:	87e72703          	lw	a4,-1922(a4) # 8001fe4c <sb+0xc>
    800035d6:	4785                	li	a5,1
    800035d8:	04e7fa63          	bgeu	a5,a4,8000362c <ialloc+0x74>
    800035dc:	8aaa                	mv	s5,a0
    800035de:	8bae                	mv	s7,a1
    800035e0:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035e2:	0001da17          	auipc	s4,0x1d
    800035e6:	85ea0a13          	addi	s4,s4,-1954 # 8001fe40 <sb>
    800035ea:	00048b1b          	sext.w	s6,s1
    800035ee:	0044d593          	srli	a1,s1,0x4
    800035f2:	018a2783          	lw	a5,24(s4)
    800035f6:	9dbd                	addw	a1,a1,a5
    800035f8:	8556                	mv	a0,s5
    800035fa:	00000097          	auipc	ra,0x0
    800035fe:	954080e7          	jalr	-1708(ra) # 80002f4e <bread>
    80003602:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003604:	05850993          	addi	s3,a0,88
    80003608:	00f4f793          	andi	a5,s1,15
    8000360c:	079a                	slli	a5,a5,0x6
    8000360e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003610:	00099783          	lh	a5,0(s3)
    80003614:	c785                	beqz	a5,8000363c <ialloc+0x84>
    brelse(bp);
    80003616:	00000097          	auipc	ra,0x0
    8000361a:	a68080e7          	jalr	-1432(ra) # 8000307e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    8000361e:	0485                	addi	s1,s1,1
    80003620:	00ca2703          	lw	a4,12(s4)
    80003624:	0004879b          	sext.w	a5,s1
    80003628:	fce7e1e3          	bltu	a5,a4,800035ea <ialloc+0x32>
  panic("ialloc: no inodes");
    8000362c:	00005517          	auipc	a0,0x5
    80003630:	f4450513          	addi	a0,a0,-188 # 80008570 <syscalls+0x168>
    80003634:	ffffd097          	auipc	ra,0xffffd
    80003638:	f14080e7          	jalr	-236(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    8000363c:	04000613          	li	a2,64
    80003640:	4581                	li	a1,0
    80003642:	854e                	mv	a0,s3
    80003644:	ffffd097          	auipc	ra,0xffffd
    80003648:	6c8080e7          	jalr	1736(ra) # 80000d0c <memset>
      dip->type = type;
    8000364c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003650:	854a                	mv	a0,s2
    80003652:	00001097          	auipc	ra,0x1
    80003656:	c94080e7          	jalr	-876(ra) # 800042e6 <log_write>
      brelse(bp);
    8000365a:	854a                	mv	a0,s2
    8000365c:	00000097          	auipc	ra,0x0
    80003660:	a22080e7          	jalr	-1502(ra) # 8000307e <brelse>
      return iget(dev, inum);
    80003664:	85da                	mv	a1,s6
    80003666:	8556                	mv	a0,s5
    80003668:	00000097          	auipc	ra,0x0
    8000366c:	db4080e7          	jalr	-588(ra) # 8000341c <iget>
}
    80003670:	60a6                	ld	ra,72(sp)
    80003672:	6406                	ld	s0,64(sp)
    80003674:	74e2                	ld	s1,56(sp)
    80003676:	7942                	ld	s2,48(sp)
    80003678:	79a2                	ld	s3,40(sp)
    8000367a:	7a02                	ld	s4,32(sp)
    8000367c:	6ae2                	ld	s5,24(sp)
    8000367e:	6b42                	ld	s6,16(sp)
    80003680:	6ba2                	ld	s7,8(sp)
    80003682:	6161                	addi	sp,sp,80
    80003684:	8082                	ret

0000000080003686 <iupdate>:
{
    80003686:	1101                	addi	sp,sp,-32
    80003688:	ec06                	sd	ra,24(sp)
    8000368a:	e822                	sd	s0,16(sp)
    8000368c:	e426                	sd	s1,8(sp)
    8000368e:	e04a                	sd	s2,0(sp)
    80003690:	1000                	addi	s0,sp,32
    80003692:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003694:	415c                	lw	a5,4(a0)
    80003696:	0047d79b          	srliw	a5,a5,0x4
    8000369a:	0001c597          	auipc	a1,0x1c
    8000369e:	7be5a583          	lw	a1,1982(a1) # 8001fe58 <sb+0x18>
    800036a2:	9dbd                	addw	a1,a1,a5
    800036a4:	4108                	lw	a0,0(a0)
    800036a6:	00000097          	auipc	ra,0x0
    800036aa:	8a8080e7          	jalr	-1880(ra) # 80002f4e <bread>
    800036ae:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800036b0:	05850793          	addi	a5,a0,88
    800036b4:	40c8                	lw	a0,4(s1)
    800036b6:	893d                	andi	a0,a0,15
    800036b8:	051a                	slli	a0,a0,0x6
    800036ba:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800036bc:	04449703          	lh	a4,68(s1)
    800036c0:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800036c4:	04649703          	lh	a4,70(s1)
    800036c8:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    800036cc:	04849703          	lh	a4,72(s1)
    800036d0:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    800036d4:	04a49703          	lh	a4,74(s1)
    800036d8:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800036dc:	44f8                	lw	a4,76(s1)
    800036de:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036e0:	03400613          	li	a2,52
    800036e4:	05048593          	addi	a1,s1,80
    800036e8:	0531                	addi	a0,a0,12
    800036ea:	ffffd097          	auipc	ra,0xffffd
    800036ee:	682080e7          	jalr	1666(ra) # 80000d6c <memmove>
  log_write(bp);
    800036f2:	854a                	mv	a0,s2
    800036f4:	00001097          	auipc	ra,0x1
    800036f8:	bf2080e7          	jalr	-1038(ra) # 800042e6 <log_write>
  brelse(bp);
    800036fc:	854a                	mv	a0,s2
    800036fe:	00000097          	auipc	ra,0x0
    80003702:	980080e7          	jalr	-1664(ra) # 8000307e <brelse>
}
    80003706:	60e2                	ld	ra,24(sp)
    80003708:	6442                	ld	s0,16(sp)
    8000370a:	64a2                	ld	s1,8(sp)
    8000370c:	6902                	ld	s2,0(sp)
    8000370e:	6105                	addi	sp,sp,32
    80003710:	8082                	ret

0000000080003712 <idup>:
{
    80003712:	1101                	addi	sp,sp,-32
    80003714:	ec06                	sd	ra,24(sp)
    80003716:	e822                	sd	s0,16(sp)
    80003718:	e426                	sd	s1,8(sp)
    8000371a:	1000                	addi	s0,sp,32
    8000371c:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    8000371e:	0001c517          	auipc	a0,0x1c
    80003722:	74250513          	addi	a0,a0,1858 # 8001fe60 <icache>
    80003726:	ffffd097          	auipc	ra,0xffffd
    8000372a:	4ea080e7          	jalr	1258(ra) # 80000c10 <acquire>
  ip->ref++;
    8000372e:	449c                	lw	a5,8(s1)
    80003730:	2785                	addiw	a5,a5,1
    80003732:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003734:	0001c517          	auipc	a0,0x1c
    80003738:	72c50513          	addi	a0,a0,1836 # 8001fe60 <icache>
    8000373c:	ffffd097          	auipc	ra,0xffffd
    80003740:	588080e7          	jalr	1416(ra) # 80000cc4 <release>
}
    80003744:	8526                	mv	a0,s1
    80003746:	60e2                	ld	ra,24(sp)
    80003748:	6442                	ld	s0,16(sp)
    8000374a:	64a2                	ld	s1,8(sp)
    8000374c:	6105                	addi	sp,sp,32
    8000374e:	8082                	ret

0000000080003750 <ilock>:
{
    80003750:	1101                	addi	sp,sp,-32
    80003752:	ec06                	sd	ra,24(sp)
    80003754:	e822                	sd	s0,16(sp)
    80003756:	e426                	sd	s1,8(sp)
    80003758:	e04a                	sd	s2,0(sp)
    8000375a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000375c:	c115                	beqz	a0,80003780 <ilock+0x30>
    8000375e:	84aa                	mv	s1,a0
    80003760:	451c                	lw	a5,8(a0)
    80003762:	00f05f63          	blez	a5,80003780 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003766:	0541                	addi	a0,a0,16
    80003768:	00001097          	auipc	ra,0x1
    8000376c:	ca6080e7          	jalr	-858(ra) # 8000440e <acquiresleep>
  if(ip->valid == 0){
    80003770:	40bc                	lw	a5,64(s1)
    80003772:	cf99                	beqz	a5,80003790 <ilock+0x40>
}
    80003774:	60e2                	ld	ra,24(sp)
    80003776:	6442                	ld	s0,16(sp)
    80003778:	64a2                	ld	s1,8(sp)
    8000377a:	6902                	ld	s2,0(sp)
    8000377c:	6105                	addi	sp,sp,32
    8000377e:	8082                	ret
    panic("ilock");
    80003780:	00005517          	auipc	a0,0x5
    80003784:	e0850513          	addi	a0,a0,-504 # 80008588 <syscalls+0x180>
    80003788:	ffffd097          	auipc	ra,0xffffd
    8000378c:	dc0080e7          	jalr	-576(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003790:	40dc                	lw	a5,4(s1)
    80003792:	0047d79b          	srliw	a5,a5,0x4
    80003796:	0001c597          	auipc	a1,0x1c
    8000379a:	6c25a583          	lw	a1,1730(a1) # 8001fe58 <sb+0x18>
    8000379e:	9dbd                	addw	a1,a1,a5
    800037a0:	4088                	lw	a0,0(s1)
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	7ac080e7          	jalr	1964(ra) # 80002f4e <bread>
    800037aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037ac:	05850593          	addi	a1,a0,88
    800037b0:	40dc                	lw	a5,4(s1)
    800037b2:	8bbd                	andi	a5,a5,15
    800037b4:	079a                	slli	a5,a5,0x6
    800037b6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800037b8:	00059783          	lh	a5,0(a1)
    800037bc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800037c0:	00259783          	lh	a5,2(a1)
    800037c4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800037c8:	00459783          	lh	a5,4(a1)
    800037cc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800037d0:	00659783          	lh	a5,6(a1)
    800037d4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037d8:	459c                	lw	a5,8(a1)
    800037da:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037dc:	03400613          	li	a2,52
    800037e0:	05b1                	addi	a1,a1,12
    800037e2:	05048513          	addi	a0,s1,80
    800037e6:	ffffd097          	auipc	ra,0xffffd
    800037ea:	586080e7          	jalr	1414(ra) # 80000d6c <memmove>
    brelse(bp);
    800037ee:	854a                	mv	a0,s2
    800037f0:	00000097          	auipc	ra,0x0
    800037f4:	88e080e7          	jalr	-1906(ra) # 8000307e <brelse>
    ip->valid = 1;
    800037f8:	4785                	li	a5,1
    800037fa:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037fc:	04449783          	lh	a5,68(s1)
    80003800:	fbb5                	bnez	a5,80003774 <ilock+0x24>
      panic("ilock: no type");
    80003802:	00005517          	auipc	a0,0x5
    80003806:	d8e50513          	addi	a0,a0,-626 # 80008590 <syscalls+0x188>
    8000380a:	ffffd097          	auipc	ra,0xffffd
    8000380e:	d3e080e7          	jalr	-706(ra) # 80000548 <panic>

0000000080003812 <iunlock>:
{
    80003812:	1101                	addi	sp,sp,-32
    80003814:	ec06                	sd	ra,24(sp)
    80003816:	e822                	sd	s0,16(sp)
    80003818:	e426                	sd	s1,8(sp)
    8000381a:	e04a                	sd	s2,0(sp)
    8000381c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000381e:	c905                	beqz	a0,8000384e <iunlock+0x3c>
    80003820:	84aa                	mv	s1,a0
    80003822:	01050913          	addi	s2,a0,16
    80003826:	854a                	mv	a0,s2
    80003828:	00001097          	auipc	ra,0x1
    8000382c:	c80080e7          	jalr	-896(ra) # 800044a8 <holdingsleep>
    80003830:	cd19                	beqz	a0,8000384e <iunlock+0x3c>
    80003832:	449c                	lw	a5,8(s1)
    80003834:	00f05d63          	blez	a5,8000384e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003838:	854a                	mv	a0,s2
    8000383a:	00001097          	auipc	ra,0x1
    8000383e:	c2a080e7          	jalr	-982(ra) # 80004464 <releasesleep>
}
    80003842:	60e2                	ld	ra,24(sp)
    80003844:	6442                	ld	s0,16(sp)
    80003846:	64a2                	ld	s1,8(sp)
    80003848:	6902                	ld	s2,0(sp)
    8000384a:	6105                	addi	sp,sp,32
    8000384c:	8082                	ret
    panic("iunlock");
    8000384e:	00005517          	auipc	a0,0x5
    80003852:	d5250513          	addi	a0,a0,-686 # 800085a0 <syscalls+0x198>
    80003856:	ffffd097          	auipc	ra,0xffffd
    8000385a:	cf2080e7          	jalr	-782(ra) # 80000548 <panic>

000000008000385e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000385e:	7179                	addi	sp,sp,-48
    80003860:	f406                	sd	ra,40(sp)
    80003862:	f022                	sd	s0,32(sp)
    80003864:	ec26                	sd	s1,24(sp)
    80003866:	e84a                	sd	s2,16(sp)
    80003868:	e44e                	sd	s3,8(sp)
    8000386a:	e052                	sd	s4,0(sp)
    8000386c:	1800                	addi	s0,sp,48
    8000386e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003870:	05050493          	addi	s1,a0,80
    80003874:	08050913          	addi	s2,a0,128
    80003878:	a021                	j	80003880 <itrunc+0x22>
    8000387a:	0491                	addi	s1,s1,4
    8000387c:	01248d63          	beq	s1,s2,80003896 <itrunc+0x38>
    if(ip->addrs[i]){
    80003880:	408c                	lw	a1,0(s1)
    80003882:	dde5                	beqz	a1,8000387a <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80003884:	0009a503          	lw	a0,0(s3)
    80003888:	00000097          	auipc	ra,0x0
    8000388c:	90c080e7          	jalr	-1780(ra) # 80003194 <bfree>
      ip->addrs[i] = 0;
    80003890:	0004a023          	sw	zero,0(s1)
    80003894:	b7dd                	j	8000387a <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003896:	0809a583          	lw	a1,128(s3)
    8000389a:	e185                	bnez	a1,800038ba <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000389c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800038a0:	854e                	mv	a0,s3
    800038a2:	00000097          	auipc	ra,0x0
    800038a6:	de4080e7          	jalr	-540(ra) # 80003686 <iupdate>
}
    800038aa:	70a2                	ld	ra,40(sp)
    800038ac:	7402                	ld	s0,32(sp)
    800038ae:	64e2                	ld	s1,24(sp)
    800038b0:	6942                	ld	s2,16(sp)
    800038b2:	69a2                	ld	s3,8(sp)
    800038b4:	6a02                	ld	s4,0(sp)
    800038b6:	6145                	addi	sp,sp,48
    800038b8:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800038ba:	0009a503          	lw	a0,0(s3)
    800038be:	fffff097          	auipc	ra,0xfffff
    800038c2:	690080e7          	jalr	1680(ra) # 80002f4e <bread>
    800038c6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800038c8:	05850493          	addi	s1,a0,88
    800038cc:	45850913          	addi	s2,a0,1112
    800038d0:	a811                	j	800038e4 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    800038d2:	0009a503          	lw	a0,0(s3)
    800038d6:	00000097          	auipc	ra,0x0
    800038da:	8be080e7          	jalr	-1858(ra) # 80003194 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800038de:	0491                	addi	s1,s1,4
    800038e0:	01248563          	beq	s1,s2,800038ea <itrunc+0x8c>
      if(a[j])
    800038e4:	408c                	lw	a1,0(s1)
    800038e6:	dde5                	beqz	a1,800038de <itrunc+0x80>
    800038e8:	b7ed                	j	800038d2 <itrunc+0x74>
    brelse(bp);
    800038ea:	8552                	mv	a0,s4
    800038ec:	fffff097          	auipc	ra,0xfffff
    800038f0:	792080e7          	jalr	1938(ra) # 8000307e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038f4:	0809a583          	lw	a1,128(s3)
    800038f8:	0009a503          	lw	a0,0(s3)
    800038fc:	00000097          	auipc	ra,0x0
    80003900:	898080e7          	jalr	-1896(ra) # 80003194 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003904:	0809a023          	sw	zero,128(s3)
    80003908:	bf51                	j	8000389c <itrunc+0x3e>

000000008000390a <iput>:
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	e426                	sd	s1,8(sp)
    80003912:	e04a                	sd	s2,0(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003918:	0001c517          	auipc	a0,0x1c
    8000391c:	54850513          	addi	a0,a0,1352 # 8001fe60 <icache>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	2f0080e7          	jalr	752(ra) # 80000c10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003928:	4498                	lw	a4,8(s1)
    8000392a:	4785                	li	a5,1
    8000392c:	02f70363          	beq	a4,a5,80003952 <iput+0x48>
  ip->ref--;
    80003930:	449c                	lw	a5,8(s1)
    80003932:	37fd                	addiw	a5,a5,-1
    80003934:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003936:	0001c517          	auipc	a0,0x1c
    8000393a:	52a50513          	addi	a0,a0,1322 # 8001fe60 <icache>
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	386080e7          	jalr	902(ra) # 80000cc4 <release>
}
    80003946:	60e2                	ld	ra,24(sp)
    80003948:	6442                	ld	s0,16(sp)
    8000394a:	64a2                	ld	s1,8(sp)
    8000394c:	6902                	ld	s2,0(sp)
    8000394e:	6105                	addi	sp,sp,32
    80003950:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003952:	40bc                	lw	a5,64(s1)
    80003954:	dff1                	beqz	a5,80003930 <iput+0x26>
    80003956:	04a49783          	lh	a5,74(s1)
    8000395a:	fbf9                	bnez	a5,80003930 <iput+0x26>
    acquiresleep(&ip->lock);
    8000395c:	01048913          	addi	s2,s1,16
    80003960:	854a                	mv	a0,s2
    80003962:	00001097          	auipc	ra,0x1
    80003966:	aac080e7          	jalr	-1364(ra) # 8000440e <acquiresleep>
    release(&icache.lock);
    8000396a:	0001c517          	auipc	a0,0x1c
    8000396e:	4f650513          	addi	a0,a0,1270 # 8001fe60 <icache>
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	352080e7          	jalr	850(ra) # 80000cc4 <release>
    itrunc(ip);
    8000397a:	8526                	mv	a0,s1
    8000397c:	00000097          	auipc	ra,0x0
    80003980:	ee2080e7          	jalr	-286(ra) # 8000385e <itrunc>
    ip->type = 0;
    80003984:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003988:	8526                	mv	a0,s1
    8000398a:	00000097          	auipc	ra,0x0
    8000398e:	cfc080e7          	jalr	-772(ra) # 80003686 <iupdate>
    ip->valid = 0;
    80003992:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003996:	854a                	mv	a0,s2
    80003998:	00001097          	auipc	ra,0x1
    8000399c:	acc080e7          	jalr	-1332(ra) # 80004464 <releasesleep>
    acquire(&icache.lock);
    800039a0:	0001c517          	auipc	a0,0x1c
    800039a4:	4c050513          	addi	a0,a0,1216 # 8001fe60 <icache>
    800039a8:	ffffd097          	auipc	ra,0xffffd
    800039ac:	268080e7          	jalr	616(ra) # 80000c10 <acquire>
    800039b0:	b741                	j	80003930 <iput+0x26>

00000000800039b2 <iunlockput>:
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	1000                	addi	s0,sp,32
    800039bc:	84aa                	mv	s1,a0
  iunlock(ip);
    800039be:	00000097          	auipc	ra,0x0
    800039c2:	e54080e7          	jalr	-428(ra) # 80003812 <iunlock>
  iput(ip);
    800039c6:	8526                	mv	a0,s1
    800039c8:	00000097          	auipc	ra,0x0
    800039cc:	f42080e7          	jalr	-190(ra) # 8000390a <iput>
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6105                	addi	sp,sp,32
    800039d8:	8082                	ret

00000000800039da <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039da:	1141                	addi	sp,sp,-16
    800039dc:	e422                	sd	s0,8(sp)
    800039de:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039e0:	411c                	lw	a5,0(a0)
    800039e2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039e4:	415c                	lw	a5,4(a0)
    800039e6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039e8:	04451783          	lh	a5,68(a0)
    800039ec:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039f0:	04a51783          	lh	a5,74(a0)
    800039f4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039f8:	04c56783          	lwu	a5,76(a0)
    800039fc:	e99c                	sd	a5,16(a1)
}
    800039fe:	6422                	ld	s0,8(sp)
    80003a00:	0141                	addi	sp,sp,16
    80003a02:	8082                	ret

0000000080003a04 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a04:	457c                	lw	a5,76(a0)
    80003a06:	0ed7e963          	bltu	a5,a3,80003af8 <readi+0xf4>
{
    80003a0a:	7159                	addi	sp,sp,-112
    80003a0c:	f486                	sd	ra,104(sp)
    80003a0e:	f0a2                	sd	s0,96(sp)
    80003a10:	eca6                	sd	s1,88(sp)
    80003a12:	e8ca                	sd	s2,80(sp)
    80003a14:	e4ce                	sd	s3,72(sp)
    80003a16:	e0d2                	sd	s4,64(sp)
    80003a18:	fc56                	sd	s5,56(sp)
    80003a1a:	f85a                	sd	s6,48(sp)
    80003a1c:	f45e                	sd	s7,40(sp)
    80003a1e:	f062                	sd	s8,32(sp)
    80003a20:	ec66                	sd	s9,24(sp)
    80003a22:	e86a                	sd	s10,16(sp)
    80003a24:	e46e                	sd	s11,8(sp)
    80003a26:	1880                	addi	s0,sp,112
    80003a28:	8baa                	mv	s7,a0
    80003a2a:	8c2e                	mv	s8,a1
    80003a2c:	8ab2                	mv	s5,a2
    80003a2e:	84b6                	mv	s1,a3
    80003a30:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003a32:	9f35                	addw	a4,a4,a3
    return 0;
    80003a34:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a36:	0ad76063          	bltu	a4,a3,80003ad6 <readi+0xd2>
  if(off + n > ip->size)
    80003a3a:	00e7f463          	bgeu	a5,a4,80003a42 <readi+0x3e>
    n = ip->size - off;
    80003a3e:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a42:	0a0b0963          	beqz	s6,80003af4 <readi+0xf0>
    80003a46:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a48:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a4c:	5cfd                	li	s9,-1
    80003a4e:	a82d                	j	80003a88 <readi+0x84>
    80003a50:	020a1d93          	slli	s11,s4,0x20
    80003a54:	020ddd93          	srli	s11,s11,0x20
    80003a58:	05890613          	addi	a2,s2,88
    80003a5c:	86ee                	mv	a3,s11
    80003a5e:	963a                	add	a2,a2,a4
    80003a60:	85d6                	mv	a1,s5
    80003a62:	8562                	mv	a0,s8
    80003a64:	fffff097          	auipc	ra,0xfffff
    80003a68:	a26080e7          	jalr	-1498(ra) # 8000248a <either_copyout>
    80003a6c:	05950d63          	beq	a0,s9,80003ac6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a70:	854a                	mv	a0,s2
    80003a72:	fffff097          	auipc	ra,0xfffff
    80003a76:	60c080e7          	jalr	1548(ra) # 8000307e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a7a:	013a09bb          	addw	s3,s4,s3
    80003a7e:	009a04bb          	addw	s1,s4,s1
    80003a82:	9aee                	add	s5,s5,s11
    80003a84:	0569f763          	bgeu	s3,s6,80003ad2 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a88:	000ba903          	lw	s2,0(s7)
    80003a8c:	00a4d59b          	srliw	a1,s1,0xa
    80003a90:	855e                	mv	a0,s7
    80003a92:	00000097          	auipc	ra,0x0
    80003a96:	8b0080e7          	jalr	-1872(ra) # 80003342 <bmap>
    80003a9a:	0005059b          	sext.w	a1,a0
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	4ae080e7          	jalr	1198(ra) # 80002f4e <bread>
    80003aa8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003aaa:	3ff4f713          	andi	a4,s1,1023
    80003aae:	40ed07bb          	subw	a5,s10,a4
    80003ab2:	413b06bb          	subw	a3,s6,s3
    80003ab6:	8a3e                	mv	s4,a5
    80003ab8:	2781                	sext.w	a5,a5
    80003aba:	0006861b          	sext.w	a2,a3
    80003abe:	f8f679e3          	bgeu	a2,a5,80003a50 <readi+0x4c>
    80003ac2:	8a36                	mv	s4,a3
    80003ac4:	b771                	j	80003a50 <readi+0x4c>
      brelse(bp);
    80003ac6:	854a                	mv	a0,s2
    80003ac8:	fffff097          	auipc	ra,0xfffff
    80003acc:	5b6080e7          	jalr	1462(ra) # 8000307e <brelse>
      tot = -1;
    80003ad0:	59fd                	li	s3,-1
  }
  return tot;
    80003ad2:	0009851b          	sext.w	a0,s3
}
    80003ad6:	70a6                	ld	ra,104(sp)
    80003ad8:	7406                	ld	s0,96(sp)
    80003ada:	64e6                	ld	s1,88(sp)
    80003adc:	6946                	ld	s2,80(sp)
    80003ade:	69a6                	ld	s3,72(sp)
    80003ae0:	6a06                	ld	s4,64(sp)
    80003ae2:	7ae2                	ld	s5,56(sp)
    80003ae4:	7b42                	ld	s6,48(sp)
    80003ae6:	7ba2                	ld	s7,40(sp)
    80003ae8:	7c02                	ld	s8,32(sp)
    80003aea:	6ce2                	ld	s9,24(sp)
    80003aec:	6d42                	ld	s10,16(sp)
    80003aee:	6da2                	ld	s11,8(sp)
    80003af0:	6165                	addi	sp,sp,112
    80003af2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003af4:	89da                	mv	s3,s6
    80003af6:	bff1                	j	80003ad2 <readi+0xce>
    return 0;
    80003af8:	4501                	li	a0,0
}
    80003afa:	8082                	ret

0000000080003afc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003afc:	457c                	lw	a5,76(a0)
    80003afe:	10d7e763          	bltu	a5,a3,80003c0c <writei+0x110>
{
    80003b02:	7159                	addi	sp,sp,-112
    80003b04:	f486                	sd	ra,104(sp)
    80003b06:	f0a2                	sd	s0,96(sp)
    80003b08:	eca6                	sd	s1,88(sp)
    80003b0a:	e8ca                	sd	s2,80(sp)
    80003b0c:	e4ce                	sd	s3,72(sp)
    80003b0e:	e0d2                	sd	s4,64(sp)
    80003b10:	fc56                	sd	s5,56(sp)
    80003b12:	f85a                	sd	s6,48(sp)
    80003b14:	f45e                	sd	s7,40(sp)
    80003b16:	f062                	sd	s8,32(sp)
    80003b18:	ec66                	sd	s9,24(sp)
    80003b1a:	e86a                	sd	s10,16(sp)
    80003b1c:	e46e                	sd	s11,8(sp)
    80003b1e:	1880                	addi	s0,sp,112
    80003b20:	8baa                	mv	s7,a0
    80003b22:	8c2e                	mv	s8,a1
    80003b24:	8ab2                	mv	s5,a2
    80003b26:	8936                	mv	s2,a3
    80003b28:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b2a:	00e687bb          	addw	a5,a3,a4
    80003b2e:	0ed7e163          	bltu	a5,a3,80003c10 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b32:	00043737          	lui	a4,0x43
    80003b36:	0cf76f63          	bltu	a4,a5,80003c14 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b3a:	0a0b0863          	beqz	s6,80003bea <writei+0xee>
    80003b3e:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b40:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b44:	5cfd                	li	s9,-1
    80003b46:	a091                	j	80003b8a <writei+0x8e>
    80003b48:	02099d93          	slli	s11,s3,0x20
    80003b4c:	020ddd93          	srli	s11,s11,0x20
    80003b50:	05848513          	addi	a0,s1,88
    80003b54:	86ee                	mv	a3,s11
    80003b56:	8656                	mv	a2,s5
    80003b58:	85e2                	mv	a1,s8
    80003b5a:	953a                	add	a0,a0,a4
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	984080e7          	jalr	-1660(ra) # 800024e0 <either_copyin>
    80003b64:	07950263          	beq	a0,s9,80003bc8 <writei+0xcc>
      brelse(bp);
      n = -1;
      break;
    }
    log_write(bp);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	00000097          	auipc	ra,0x0
    80003b6e:	77c080e7          	jalr	1916(ra) # 800042e6 <log_write>
    brelse(bp);
    80003b72:	8526                	mv	a0,s1
    80003b74:	fffff097          	auipc	ra,0xfffff
    80003b78:	50a080e7          	jalr	1290(ra) # 8000307e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b7c:	01498a3b          	addw	s4,s3,s4
    80003b80:	0129893b          	addw	s2,s3,s2
    80003b84:	9aee                	add	s5,s5,s11
    80003b86:	056a7763          	bgeu	s4,s6,80003bd4 <writei+0xd8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b8a:	000ba483          	lw	s1,0(s7)
    80003b8e:	00a9559b          	srliw	a1,s2,0xa
    80003b92:	855e                	mv	a0,s7
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	7ae080e7          	jalr	1966(ra) # 80003342 <bmap>
    80003b9c:	0005059b          	sext.w	a1,a0
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	3ac080e7          	jalr	940(ra) # 80002f4e <bread>
    80003baa:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bac:	3ff97713          	andi	a4,s2,1023
    80003bb0:	40ed07bb          	subw	a5,s10,a4
    80003bb4:	414b06bb          	subw	a3,s6,s4
    80003bb8:	89be                	mv	s3,a5
    80003bba:	2781                	sext.w	a5,a5
    80003bbc:	0006861b          	sext.w	a2,a3
    80003bc0:	f8f674e3          	bgeu	a2,a5,80003b48 <writei+0x4c>
    80003bc4:	89b6                	mv	s3,a3
    80003bc6:	b749                	j	80003b48 <writei+0x4c>
      brelse(bp);
    80003bc8:	8526                	mv	a0,s1
    80003bca:	fffff097          	auipc	ra,0xfffff
    80003bce:	4b4080e7          	jalr	1204(ra) # 8000307e <brelse>
      n = -1;
    80003bd2:	5b7d                	li	s6,-1
  }

  if(n > 0){
    if(off > ip->size)
    80003bd4:	04cba783          	lw	a5,76(s7)
    80003bd8:	0127f463          	bgeu	a5,s2,80003be0 <writei+0xe4>
      ip->size = off;
    80003bdc:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003be0:	855e                	mv	a0,s7
    80003be2:	00000097          	auipc	ra,0x0
    80003be6:	aa4080e7          	jalr	-1372(ra) # 80003686 <iupdate>
  }

  return n;
    80003bea:	000b051b          	sext.w	a0,s6
}
    80003bee:	70a6                	ld	ra,104(sp)
    80003bf0:	7406                	ld	s0,96(sp)
    80003bf2:	64e6                	ld	s1,88(sp)
    80003bf4:	6946                	ld	s2,80(sp)
    80003bf6:	69a6                	ld	s3,72(sp)
    80003bf8:	6a06                	ld	s4,64(sp)
    80003bfa:	7ae2                	ld	s5,56(sp)
    80003bfc:	7b42                	ld	s6,48(sp)
    80003bfe:	7ba2                	ld	s7,40(sp)
    80003c00:	7c02                	ld	s8,32(sp)
    80003c02:	6ce2                	ld	s9,24(sp)
    80003c04:	6d42                	ld	s10,16(sp)
    80003c06:	6da2                	ld	s11,8(sp)
    80003c08:	6165                	addi	sp,sp,112
    80003c0a:	8082                	ret
    return -1;
    80003c0c:	557d                	li	a0,-1
}
    80003c0e:	8082                	ret
    return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	bff1                	j	80003bee <writei+0xf2>
    return -1;
    80003c14:	557d                	li	a0,-1
    80003c16:	bfe1                	j	80003bee <writei+0xf2>

0000000080003c18 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c18:	1141                	addi	sp,sp,-16
    80003c1a:	e406                	sd	ra,8(sp)
    80003c1c:	e022                	sd	s0,0(sp)
    80003c1e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c20:	4639                	li	a2,14
    80003c22:	ffffd097          	auipc	ra,0xffffd
    80003c26:	1c6080e7          	jalr	454(ra) # 80000de8 <strncmp>
}
    80003c2a:	60a2                	ld	ra,8(sp)
    80003c2c:	6402                	ld	s0,0(sp)
    80003c2e:	0141                	addi	sp,sp,16
    80003c30:	8082                	ret

0000000080003c32 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c32:	7139                	addi	sp,sp,-64
    80003c34:	fc06                	sd	ra,56(sp)
    80003c36:	f822                	sd	s0,48(sp)
    80003c38:	f426                	sd	s1,40(sp)
    80003c3a:	f04a                	sd	s2,32(sp)
    80003c3c:	ec4e                	sd	s3,24(sp)
    80003c3e:	e852                	sd	s4,16(sp)
    80003c40:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c42:	04451703          	lh	a4,68(a0)
    80003c46:	4785                	li	a5,1
    80003c48:	00f71a63          	bne	a4,a5,80003c5c <dirlookup+0x2a>
    80003c4c:	892a                	mv	s2,a0
    80003c4e:	89ae                	mv	s3,a1
    80003c50:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c52:	457c                	lw	a5,76(a0)
    80003c54:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c56:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c58:	e79d                	bnez	a5,80003c86 <dirlookup+0x54>
    80003c5a:	a8a5                	j	80003cd2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c5c:	00005517          	auipc	a0,0x5
    80003c60:	94c50513          	addi	a0,a0,-1716 # 800085a8 <syscalls+0x1a0>
    80003c64:	ffffd097          	auipc	ra,0xffffd
    80003c68:	8e4080e7          	jalr	-1820(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003c6c:	00005517          	auipc	a0,0x5
    80003c70:	95450513          	addi	a0,a0,-1708 # 800085c0 <syscalls+0x1b8>
    80003c74:	ffffd097          	auipc	ra,0xffffd
    80003c78:	8d4080e7          	jalr	-1836(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c7c:	24c1                	addiw	s1,s1,16
    80003c7e:	04c92783          	lw	a5,76(s2)
    80003c82:	04f4f763          	bgeu	s1,a5,80003cd0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c86:	4741                	li	a4,16
    80003c88:	86a6                	mv	a3,s1
    80003c8a:	fc040613          	addi	a2,s0,-64
    80003c8e:	4581                	li	a1,0
    80003c90:	854a                	mv	a0,s2
    80003c92:	00000097          	auipc	ra,0x0
    80003c96:	d72080e7          	jalr	-654(ra) # 80003a04 <readi>
    80003c9a:	47c1                	li	a5,16
    80003c9c:	fcf518e3          	bne	a0,a5,80003c6c <dirlookup+0x3a>
    if(de.inum == 0)
    80003ca0:	fc045783          	lhu	a5,-64(s0)
    80003ca4:	dfe1                	beqz	a5,80003c7c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003ca6:	fc240593          	addi	a1,s0,-62
    80003caa:	854e                	mv	a0,s3
    80003cac:	00000097          	auipc	ra,0x0
    80003cb0:	f6c080e7          	jalr	-148(ra) # 80003c18 <namecmp>
    80003cb4:	f561                	bnez	a0,80003c7c <dirlookup+0x4a>
      if(poff)
    80003cb6:	000a0463          	beqz	s4,80003cbe <dirlookup+0x8c>
        *poff = off;
    80003cba:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003cbe:	fc045583          	lhu	a1,-64(s0)
    80003cc2:	00092503          	lw	a0,0(s2)
    80003cc6:	fffff097          	auipc	ra,0xfffff
    80003cca:	756080e7          	jalr	1878(ra) # 8000341c <iget>
    80003cce:	a011                	j	80003cd2 <dirlookup+0xa0>
  return 0;
    80003cd0:	4501                	li	a0,0
}
    80003cd2:	70e2                	ld	ra,56(sp)
    80003cd4:	7442                	ld	s0,48(sp)
    80003cd6:	74a2                	ld	s1,40(sp)
    80003cd8:	7902                	ld	s2,32(sp)
    80003cda:	69e2                	ld	s3,24(sp)
    80003cdc:	6a42                	ld	s4,16(sp)
    80003cde:	6121                	addi	sp,sp,64
    80003ce0:	8082                	ret

0000000080003ce2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ce2:	711d                	addi	sp,sp,-96
    80003ce4:	ec86                	sd	ra,88(sp)
    80003ce6:	e8a2                	sd	s0,80(sp)
    80003ce8:	e4a6                	sd	s1,72(sp)
    80003cea:	e0ca                	sd	s2,64(sp)
    80003cec:	fc4e                	sd	s3,56(sp)
    80003cee:	f852                	sd	s4,48(sp)
    80003cf0:	f456                	sd	s5,40(sp)
    80003cf2:	f05a                	sd	s6,32(sp)
    80003cf4:	ec5e                	sd	s7,24(sp)
    80003cf6:	e862                	sd	s8,16(sp)
    80003cf8:	e466                	sd	s9,8(sp)
    80003cfa:	1080                	addi	s0,sp,96
    80003cfc:	84aa                	mv	s1,a0
    80003cfe:	8b2e                	mv	s6,a1
    80003d00:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d02:	00054703          	lbu	a4,0(a0)
    80003d06:	02f00793          	li	a5,47
    80003d0a:	02f70363          	beq	a4,a5,80003d30 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d0e:	ffffe097          	auipc	ra,0xffffe
    80003d12:	d0a080e7          	jalr	-758(ra) # 80001a18 <myproc>
    80003d16:	15053503          	ld	a0,336(a0)
    80003d1a:	00000097          	auipc	ra,0x0
    80003d1e:	9f8080e7          	jalr	-1544(ra) # 80003712 <idup>
    80003d22:	89aa                	mv	s3,a0
  while(*path == '/')
    80003d24:	02f00913          	li	s2,47
  len = path - s;
    80003d28:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003d2a:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d2c:	4c05                	li	s8,1
    80003d2e:	a865                	j	80003de6 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003d30:	4585                	li	a1,1
    80003d32:	4505                	li	a0,1
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	6e8080e7          	jalr	1768(ra) # 8000341c <iget>
    80003d3c:	89aa                	mv	s3,a0
    80003d3e:	b7dd                	j	80003d24 <namex+0x42>
      iunlockput(ip);
    80003d40:	854e                	mv	a0,s3
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	c70080e7          	jalr	-912(ra) # 800039b2 <iunlockput>
      return 0;
    80003d4a:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d4c:	854e                	mv	a0,s3
    80003d4e:	60e6                	ld	ra,88(sp)
    80003d50:	6446                	ld	s0,80(sp)
    80003d52:	64a6                	ld	s1,72(sp)
    80003d54:	6906                	ld	s2,64(sp)
    80003d56:	79e2                	ld	s3,56(sp)
    80003d58:	7a42                	ld	s4,48(sp)
    80003d5a:	7aa2                	ld	s5,40(sp)
    80003d5c:	7b02                	ld	s6,32(sp)
    80003d5e:	6be2                	ld	s7,24(sp)
    80003d60:	6c42                	ld	s8,16(sp)
    80003d62:	6ca2                	ld	s9,8(sp)
    80003d64:	6125                	addi	sp,sp,96
    80003d66:	8082                	ret
      iunlock(ip);
    80003d68:	854e                	mv	a0,s3
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	aa8080e7          	jalr	-1368(ra) # 80003812 <iunlock>
      return ip;
    80003d72:	bfe9                	j	80003d4c <namex+0x6a>
      iunlockput(ip);
    80003d74:	854e                	mv	a0,s3
    80003d76:	00000097          	auipc	ra,0x0
    80003d7a:	c3c080e7          	jalr	-964(ra) # 800039b2 <iunlockput>
      return 0;
    80003d7e:	89d2                	mv	s3,s4
    80003d80:	b7f1                	j	80003d4c <namex+0x6a>
  len = path - s;
    80003d82:	40b48633          	sub	a2,s1,a1
    80003d86:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003d8a:	094cd463          	bge	s9,s4,80003e12 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d8e:	4639                	li	a2,14
    80003d90:	8556                	mv	a0,s5
    80003d92:	ffffd097          	auipc	ra,0xffffd
    80003d96:	fda080e7          	jalr	-38(ra) # 80000d6c <memmove>
  while(*path == '/')
    80003d9a:	0004c783          	lbu	a5,0(s1)
    80003d9e:	01279763          	bne	a5,s2,80003dac <namex+0xca>
    path++;
    80003da2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003da4:	0004c783          	lbu	a5,0(s1)
    80003da8:	ff278de3          	beq	a5,s2,80003da2 <namex+0xc0>
    ilock(ip);
    80003dac:	854e                	mv	a0,s3
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	9a2080e7          	jalr	-1630(ra) # 80003750 <ilock>
    if(ip->type != T_DIR){
    80003db6:	04499783          	lh	a5,68(s3)
    80003dba:	f98793e3          	bne	a5,s8,80003d40 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003dbe:	000b0563          	beqz	s6,80003dc8 <namex+0xe6>
    80003dc2:	0004c783          	lbu	a5,0(s1)
    80003dc6:	d3cd                	beqz	a5,80003d68 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003dc8:	865e                	mv	a2,s7
    80003dca:	85d6                	mv	a1,s5
    80003dcc:	854e                	mv	a0,s3
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	e64080e7          	jalr	-412(ra) # 80003c32 <dirlookup>
    80003dd6:	8a2a                	mv	s4,a0
    80003dd8:	dd51                	beqz	a0,80003d74 <namex+0x92>
    iunlockput(ip);
    80003dda:	854e                	mv	a0,s3
    80003ddc:	00000097          	auipc	ra,0x0
    80003de0:	bd6080e7          	jalr	-1066(ra) # 800039b2 <iunlockput>
    ip = next;
    80003de4:	89d2                	mv	s3,s4
  while(*path == '/')
    80003de6:	0004c783          	lbu	a5,0(s1)
    80003dea:	05279763          	bne	a5,s2,80003e38 <namex+0x156>
    path++;
    80003dee:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003df0:	0004c783          	lbu	a5,0(s1)
    80003df4:	ff278de3          	beq	a5,s2,80003dee <namex+0x10c>
  if(*path == 0)
    80003df8:	c79d                	beqz	a5,80003e26 <namex+0x144>
    path++;
    80003dfa:	85a6                	mv	a1,s1
  len = path - s;
    80003dfc:	8a5e                	mv	s4,s7
    80003dfe:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003e00:	01278963          	beq	a5,s2,80003e12 <namex+0x130>
    80003e04:	dfbd                	beqz	a5,80003d82 <namex+0xa0>
    path++;
    80003e06:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003e08:	0004c783          	lbu	a5,0(s1)
    80003e0c:	ff279ce3          	bne	a5,s2,80003e04 <namex+0x122>
    80003e10:	bf8d                	j	80003d82 <namex+0xa0>
    memmove(name, s, len);
    80003e12:	2601                	sext.w	a2,a2
    80003e14:	8556                	mv	a0,s5
    80003e16:	ffffd097          	auipc	ra,0xffffd
    80003e1a:	f56080e7          	jalr	-170(ra) # 80000d6c <memmove>
    name[len] = 0;
    80003e1e:	9a56                	add	s4,s4,s5
    80003e20:	000a0023          	sb	zero,0(s4)
    80003e24:	bf9d                	j	80003d9a <namex+0xb8>
  if(nameiparent){
    80003e26:	f20b03e3          	beqz	s6,80003d4c <namex+0x6a>
    iput(ip);
    80003e2a:	854e                	mv	a0,s3
    80003e2c:	00000097          	auipc	ra,0x0
    80003e30:	ade080e7          	jalr	-1314(ra) # 8000390a <iput>
    return 0;
    80003e34:	4981                	li	s3,0
    80003e36:	bf19                	j	80003d4c <namex+0x6a>
  if(*path == 0)
    80003e38:	d7fd                	beqz	a5,80003e26 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e3a:	0004c783          	lbu	a5,0(s1)
    80003e3e:	85a6                	mv	a1,s1
    80003e40:	b7d1                	j	80003e04 <namex+0x122>

0000000080003e42 <dirlink>:
{
    80003e42:	7139                	addi	sp,sp,-64
    80003e44:	fc06                	sd	ra,56(sp)
    80003e46:	f822                	sd	s0,48(sp)
    80003e48:	f426                	sd	s1,40(sp)
    80003e4a:	f04a                	sd	s2,32(sp)
    80003e4c:	ec4e                	sd	s3,24(sp)
    80003e4e:	e852                	sd	s4,16(sp)
    80003e50:	0080                	addi	s0,sp,64
    80003e52:	892a                	mv	s2,a0
    80003e54:	8a2e                	mv	s4,a1
    80003e56:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e58:	4601                	li	a2,0
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	dd8080e7          	jalr	-552(ra) # 80003c32 <dirlookup>
    80003e62:	e93d                	bnez	a0,80003ed8 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e64:	04c92483          	lw	s1,76(s2)
    80003e68:	c49d                	beqz	s1,80003e96 <dirlink+0x54>
    80003e6a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e6c:	4741                	li	a4,16
    80003e6e:	86a6                	mv	a3,s1
    80003e70:	fc040613          	addi	a2,s0,-64
    80003e74:	4581                	li	a1,0
    80003e76:	854a                	mv	a0,s2
    80003e78:	00000097          	auipc	ra,0x0
    80003e7c:	b8c080e7          	jalr	-1140(ra) # 80003a04 <readi>
    80003e80:	47c1                	li	a5,16
    80003e82:	06f51163          	bne	a0,a5,80003ee4 <dirlink+0xa2>
    if(de.inum == 0)
    80003e86:	fc045783          	lhu	a5,-64(s0)
    80003e8a:	c791                	beqz	a5,80003e96 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e8c:	24c1                	addiw	s1,s1,16
    80003e8e:	04c92783          	lw	a5,76(s2)
    80003e92:	fcf4ede3          	bltu	s1,a5,80003e6c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e96:	4639                	li	a2,14
    80003e98:	85d2                	mv	a1,s4
    80003e9a:	fc240513          	addi	a0,s0,-62
    80003e9e:	ffffd097          	auipc	ra,0xffffd
    80003ea2:	f86080e7          	jalr	-122(ra) # 80000e24 <strncpy>
  de.inum = inum;
    80003ea6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eaa:	4741                	li	a4,16
    80003eac:	86a6                	mv	a3,s1
    80003eae:	fc040613          	addi	a2,s0,-64
    80003eb2:	4581                	li	a1,0
    80003eb4:	854a                	mv	a0,s2
    80003eb6:	00000097          	auipc	ra,0x0
    80003eba:	c46080e7          	jalr	-954(ra) # 80003afc <writei>
    80003ebe:	872a                	mv	a4,a0
    80003ec0:	47c1                	li	a5,16
  return 0;
    80003ec2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ec4:	02f71863          	bne	a4,a5,80003ef4 <dirlink+0xb2>
}
    80003ec8:	70e2                	ld	ra,56(sp)
    80003eca:	7442                	ld	s0,48(sp)
    80003ecc:	74a2                	ld	s1,40(sp)
    80003ece:	7902                	ld	s2,32(sp)
    80003ed0:	69e2                	ld	s3,24(sp)
    80003ed2:	6a42                	ld	s4,16(sp)
    80003ed4:	6121                	addi	sp,sp,64
    80003ed6:	8082                	ret
    iput(ip);
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	a32080e7          	jalr	-1486(ra) # 8000390a <iput>
    return -1;
    80003ee0:	557d                	li	a0,-1
    80003ee2:	b7dd                	j	80003ec8 <dirlink+0x86>
      panic("dirlink read");
    80003ee4:	00004517          	auipc	a0,0x4
    80003ee8:	6ec50513          	addi	a0,a0,1772 # 800085d0 <syscalls+0x1c8>
    80003eec:	ffffc097          	auipc	ra,0xffffc
    80003ef0:	65c080e7          	jalr	1628(ra) # 80000548 <panic>
    panic("dirlink");
    80003ef4:	00004517          	auipc	a0,0x4
    80003ef8:	7fc50513          	addi	a0,a0,2044 # 800086f0 <syscalls+0x2e8>
    80003efc:	ffffc097          	auipc	ra,0xffffc
    80003f00:	64c080e7          	jalr	1612(ra) # 80000548 <panic>

0000000080003f04 <namei>:

struct inode*
namei(char *path)
{
    80003f04:	1101                	addi	sp,sp,-32
    80003f06:	ec06                	sd	ra,24(sp)
    80003f08:	e822                	sd	s0,16(sp)
    80003f0a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003f0c:	fe040613          	addi	a2,s0,-32
    80003f10:	4581                	li	a1,0
    80003f12:	00000097          	auipc	ra,0x0
    80003f16:	dd0080e7          	jalr	-560(ra) # 80003ce2 <namex>
}
    80003f1a:	60e2                	ld	ra,24(sp)
    80003f1c:	6442                	ld	s0,16(sp)
    80003f1e:	6105                	addi	sp,sp,32
    80003f20:	8082                	ret

0000000080003f22 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f22:	1141                	addi	sp,sp,-16
    80003f24:	e406                	sd	ra,8(sp)
    80003f26:	e022                	sd	s0,0(sp)
    80003f28:	0800                	addi	s0,sp,16
    80003f2a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f2c:	4585                	li	a1,1
    80003f2e:	00000097          	auipc	ra,0x0
    80003f32:	db4080e7          	jalr	-588(ra) # 80003ce2 <namex>
}
    80003f36:	60a2                	ld	ra,8(sp)
    80003f38:	6402                	ld	s0,0(sp)
    80003f3a:	0141                	addi	sp,sp,16
    80003f3c:	8082                	ret

0000000080003f3e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f3e:	1101                	addi	sp,sp,-32
    80003f40:	ec06                	sd	ra,24(sp)
    80003f42:	e822                	sd	s0,16(sp)
    80003f44:	e426                	sd	s1,8(sp)
    80003f46:	e04a                	sd	s2,0(sp)
    80003f48:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f4a:	0001e917          	auipc	s2,0x1e
    80003f4e:	9be90913          	addi	s2,s2,-1602 # 80021908 <log>
    80003f52:	01892583          	lw	a1,24(s2)
    80003f56:	02892503          	lw	a0,40(s2)
    80003f5a:	fffff097          	auipc	ra,0xfffff
    80003f5e:	ff4080e7          	jalr	-12(ra) # 80002f4e <bread>
    80003f62:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f64:	02c92683          	lw	a3,44(s2)
    80003f68:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f6a:	02d05763          	blez	a3,80003f98 <write_head+0x5a>
    80003f6e:	0001e797          	auipc	a5,0x1e
    80003f72:	9ca78793          	addi	a5,a5,-1590 # 80021938 <log+0x30>
    80003f76:	05c50713          	addi	a4,a0,92
    80003f7a:	36fd                	addiw	a3,a3,-1
    80003f7c:	1682                	slli	a3,a3,0x20
    80003f7e:	9281                	srli	a3,a3,0x20
    80003f80:	068a                	slli	a3,a3,0x2
    80003f82:	0001e617          	auipc	a2,0x1e
    80003f86:	9ba60613          	addi	a2,a2,-1606 # 8002193c <log+0x34>
    80003f8a:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f8c:	4390                	lw	a2,0(a5)
    80003f8e:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f90:	0791                	addi	a5,a5,4
    80003f92:	0711                	addi	a4,a4,4
    80003f94:	fed79ce3          	bne	a5,a3,80003f8c <write_head+0x4e>
  }
  bwrite(buf);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	fffff097          	auipc	ra,0xfffff
    80003f9e:	0a6080e7          	jalr	166(ra) # 80003040 <bwrite>
  brelse(buf);
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	fffff097          	auipc	ra,0xfffff
    80003fa8:	0da080e7          	jalr	218(ra) # 8000307e <brelse>
}
    80003fac:	60e2                	ld	ra,24(sp)
    80003fae:	6442                	ld	s0,16(sp)
    80003fb0:	64a2                	ld	s1,8(sp)
    80003fb2:	6902                	ld	s2,0(sp)
    80003fb4:	6105                	addi	sp,sp,32
    80003fb6:	8082                	ret

0000000080003fb8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fb8:	0001e797          	auipc	a5,0x1e
    80003fbc:	97c7a783          	lw	a5,-1668(a5) # 80021934 <log+0x2c>
    80003fc0:	0af05663          	blez	a5,8000406c <install_trans+0xb4>
{
    80003fc4:	7139                	addi	sp,sp,-64
    80003fc6:	fc06                	sd	ra,56(sp)
    80003fc8:	f822                	sd	s0,48(sp)
    80003fca:	f426                	sd	s1,40(sp)
    80003fcc:	f04a                	sd	s2,32(sp)
    80003fce:	ec4e                	sd	s3,24(sp)
    80003fd0:	e852                	sd	s4,16(sp)
    80003fd2:	e456                	sd	s5,8(sp)
    80003fd4:	0080                	addi	s0,sp,64
    80003fd6:	0001ea97          	auipc	s5,0x1e
    80003fda:	962a8a93          	addi	s5,s5,-1694 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fde:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fe0:	0001e997          	auipc	s3,0x1e
    80003fe4:	92898993          	addi	s3,s3,-1752 # 80021908 <log>
    80003fe8:	0189a583          	lw	a1,24(s3)
    80003fec:	014585bb          	addw	a1,a1,s4
    80003ff0:	2585                	addiw	a1,a1,1
    80003ff2:	0289a503          	lw	a0,40(s3)
    80003ff6:	fffff097          	auipc	ra,0xfffff
    80003ffa:	f58080e7          	jalr	-168(ra) # 80002f4e <bread>
    80003ffe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004000:	000aa583          	lw	a1,0(s5)
    80004004:	0289a503          	lw	a0,40(s3)
    80004008:	fffff097          	auipc	ra,0xfffff
    8000400c:	f46080e7          	jalr	-186(ra) # 80002f4e <bread>
    80004010:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004012:	40000613          	li	a2,1024
    80004016:	05890593          	addi	a1,s2,88
    8000401a:	05850513          	addi	a0,a0,88
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	d4e080e7          	jalr	-690(ra) # 80000d6c <memmove>
    bwrite(dbuf);  // write dst to disk
    80004026:	8526                	mv	a0,s1
    80004028:	fffff097          	auipc	ra,0xfffff
    8000402c:	018080e7          	jalr	24(ra) # 80003040 <bwrite>
    bunpin(dbuf);
    80004030:	8526                	mv	a0,s1
    80004032:	fffff097          	auipc	ra,0xfffff
    80004036:	126080e7          	jalr	294(ra) # 80003158 <bunpin>
    brelse(lbuf);
    8000403a:	854a                	mv	a0,s2
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	042080e7          	jalr	66(ra) # 8000307e <brelse>
    brelse(dbuf);
    80004044:	8526                	mv	a0,s1
    80004046:	fffff097          	auipc	ra,0xfffff
    8000404a:	038080e7          	jalr	56(ra) # 8000307e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000404e:	2a05                	addiw	s4,s4,1
    80004050:	0a91                	addi	s5,s5,4
    80004052:	02c9a783          	lw	a5,44(s3)
    80004056:	f8fa49e3          	blt	s4,a5,80003fe8 <install_trans+0x30>
}
    8000405a:	70e2                	ld	ra,56(sp)
    8000405c:	7442                	ld	s0,48(sp)
    8000405e:	74a2                	ld	s1,40(sp)
    80004060:	7902                	ld	s2,32(sp)
    80004062:	69e2                	ld	s3,24(sp)
    80004064:	6a42                	ld	s4,16(sp)
    80004066:	6aa2                	ld	s5,8(sp)
    80004068:	6121                	addi	sp,sp,64
    8000406a:	8082                	ret
    8000406c:	8082                	ret

000000008000406e <initlog>:
{
    8000406e:	7179                	addi	sp,sp,-48
    80004070:	f406                	sd	ra,40(sp)
    80004072:	f022                	sd	s0,32(sp)
    80004074:	ec26                	sd	s1,24(sp)
    80004076:	e84a                	sd	s2,16(sp)
    80004078:	e44e                	sd	s3,8(sp)
    8000407a:	1800                	addi	s0,sp,48
    8000407c:	892a                	mv	s2,a0
    8000407e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004080:	0001e497          	auipc	s1,0x1e
    80004084:	88848493          	addi	s1,s1,-1912 # 80021908 <log>
    80004088:	00004597          	auipc	a1,0x4
    8000408c:	55858593          	addi	a1,a1,1368 # 800085e0 <syscalls+0x1d8>
    80004090:	8526                	mv	a0,s1
    80004092:	ffffd097          	auipc	ra,0xffffd
    80004096:	aee080e7          	jalr	-1298(ra) # 80000b80 <initlock>
  log.start = sb->logstart;
    8000409a:	0149a583          	lw	a1,20(s3)
    8000409e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800040a0:	0109a783          	lw	a5,16(s3)
    800040a4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800040a6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800040aa:	854a                	mv	a0,s2
    800040ac:	fffff097          	auipc	ra,0xfffff
    800040b0:	ea2080e7          	jalr	-350(ra) # 80002f4e <bread>
  log.lh.n = lh->n;
    800040b4:	4d3c                	lw	a5,88(a0)
    800040b6:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800040b8:	02f05563          	blez	a5,800040e2 <initlog+0x74>
    800040bc:	05c50713          	addi	a4,a0,92
    800040c0:	0001e697          	auipc	a3,0x1e
    800040c4:	87868693          	addi	a3,a3,-1928 # 80021938 <log+0x30>
    800040c8:	37fd                	addiw	a5,a5,-1
    800040ca:	1782                	slli	a5,a5,0x20
    800040cc:	9381                	srli	a5,a5,0x20
    800040ce:	078a                	slli	a5,a5,0x2
    800040d0:	06050613          	addi	a2,a0,96
    800040d4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800040d6:	4310                	lw	a2,0(a4)
    800040d8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800040da:	0711                	addi	a4,a4,4
    800040dc:	0691                	addi	a3,a3,4
    800040de:	fef71ce3          	bne	a4,a5,800040d6 <initlog+0x68>
  brelse(buf);
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	f9c080e7          	jalr	-100(ra) # 8000307e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    800040ea:	00000097          	auipc	ra,0x0
    800040ee:	ece080e7          	jalr	-306(ra) # 80003fb8 <install_trans>
  log.lh.n = 0;
    800040f2:	0001e797          	auipc	a5,0x1e
    800040f6:	8407a123          	sw	zero,-1982(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    800040fa:	00000097          	auipc	ra,0x0
    800040fe:	e44080e7          	jalr	-444(ra) # 80003f3e <write_head>
}
    80004102:	70a2                	ld	ra,40(sp)
    80004104:	7402                	ld	s0,32(sp)
    80004106:	64e2                	ld	s1,24(sp)
    80004108:	6942                	ld	s2,16(sp)
    8000410a:	69a2                	ld	s3,8(sp)
    8000410c:	6145                	addi	sp,sp,48
    8000410e:	8082                	ret

0000000080004110 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004110:	1101                	addi	sp,sp,-32
    80004112:	ec06                	sd	ra,24(sp)
    80004114:	e822                	sd	s0,16(sp)
    80004116:	e426                	sd	s1,8(sp)
    80004118:	e04a                	sd	s2,0(sp)
    8000411a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000411c:	0001d517          	auipc	a0,0x1d
    80004120:	7ec50513          	addi	a0,a0,2028 # 80021908 <log>
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	aec080e7          	jalr	-1300(ra) # 80000c10 <acquire>
  while(1){
    if(log.committing){
    8000412c:	0001d497          	auipc	s1,0x1d
    80004130:	7dc48493          	addi	s1,s1,2012 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004134:	4979                	li	s2,30
    80004136:	a039                	j	80004144 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004138:	85a6                	mv	a1,s1
    8000413a:	8526                	mv	a0,s1
    8000413c:	ffffe097          	auipc	ra,0xffffe
    80004140:	0ec080e7          	jalr	236(ra) # 80002228 <sleep>
    if(log.committing){
    80004144:	50dc                	lw	a5,36(s1)
    80004146:	fbed                	bnez	a5,80004138 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004148:	509c                	lw	a5,32(s1)
    8000414a:	0017871b          	addiw	a4,a5,1
    8000414e:	0007069b          	sext.w	a3,a4
    80004152:	0027179b          	slliw	a5,a4,0x2
    80004156:	9fb9                	addw	a5,a5,a4
    80004158:	0017979b          	slliw	a5,a5,0x1
    8000415c:	54d8                	lw	a4,44(s1)
    8000415e:	9fb9                	addw	a5,a5,a4
    80004160:	00f95963          	bge	s2,a5,80004172 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004164:	85a6                	mv	a1,s1
    80004166:	8526                	mv	a0,s1
    80004168:	ffffe097          	auipc	ra,0xffffe
    8000416c:	0c0080e7          	jalr	192(ra) # 80002228 <sleep>
    80004170:	bfd1                	j	80004144 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004172:	0001d517          	auipc	a0,0x1d
    80004176:	79650513          	addi	a0,a0,1942 # 80021908 <log>
    8000417a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000417c:	ffffd097          	auipc	ra,0xffffd
    80004180:	b48080e7          	jalr	-1208(ra) # 80000cc4 <release>
      break;
    }
  }
}
    80004184:	60e2                	ld	ra,24(sp)
    80004186:	6442                	ld	s0,16(sp)
    80004188:	64a2                	ld	s1,8(sp)
    8000418a:	6902                	ld	s2,0(sp)
    8000418c:	6105                	addi	sp,sp,32
    8000418e:	8082                	ret

0000000080004190 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004190:	7139                	addi	sp,sp,-64
    80004192:	fc06                	sd	ra,56(sp)
    80004194:	f822                	sd	s0,48(sp)
    80004196:	f426                	sd	s1,40(sp)
    80004198:	f04a                	sd	s2,32(sp)
    8000419a:	ec4e                	sd	s3,24(sp)
    8000419c:	e852                	sd	s4,16(sp)
    8000419e:	e456                	sd	s5,8(sp)
    800041a0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800041a2:	0001d497          	auipc	s1,0x1d
    800041a6:	76648493          	addi	s1,s1,1894 # 80021908 <log>
    800041aa:	8526                	mv	a0,s1
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	a64080e7          	jalr	-1436(ra) # 80000c10 <acquire>
  log.outstanding -= 1;
    800041b4:	509c                	lw	a5,32(s1)
    800041b6:	37fd                	addiw	a5,a5,-1
    800041b8:	0007891b          	sext.w	s2,a5
    800041bc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800041be:	50dc                	lw	a5,36(s1)
    800041c0:	efb9                	bnez	a5,8000421e <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041c2:	06091663          	bnez	s2,8000422e <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800041c6:	0001d497          	auipc	s1,0x1d
    800041ca:	74248493          	addi	s1,s1,1858 # 80021908 <log>
    800041ce:	4785                	li	a5,1
    800041d0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041d2:	8526                	mv	a0,s1
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	af0080e7          	jalr	-1296(ra) # 80000cc4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041dc:	54dc                	lw	a5,44(s1)
    800041de:	06f04763          	bgtz	a5,8000424c <end_op+0xbc>
    acquire(&log.lock);
    800041e2:	0001d497          	auipc	s1,0x1d
    800041e6:	72648493          	addi	s1,s1,1830 # 80021908 <log>
    800041ea:	8526                	mv	a0,s1
    800041ec:	ffffd097          	auipc	ra,0xffffd
    800041f0:	a24080e7          	jalr	-1500(ra) # 80000c10 <acquire>
    log.committing = 0;
    800041f4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041f8:	8526                	mv	a0,s1
    800041fa:	ffffe097          	auipc	ra,0xffffe
    800041fe:	1b4080e7          	jalr	436(ra) # 800023ae <wakeup>
    release(&log.lock);
    80004202:	8526                	mv	a0,s1
    80004204:	ffffd097          	auipc	ra,0xffffd
    80004208:	ac0080e7          	jalr	-1344(ra) # 80000cc4 <release>
}
    8000420c:	70e2                	ld	ra,56(sp)
    8000420e:	7442                	ld	s0,48(sp)
    80004210:	74a2                	ld	s1,40(sp)
    80004212:	7902                	ld	s2,32(sp)
    80004214:	69e2                	ld	s3,24(sp)
    80004216:	6a42                	ld	s4,16(sp)
    80004218:	6aa2                	ld	s5,8(sp)
    8000421a:	6121                	addi	sp,sp,64
    8000421c:	8082                	ret
    panic("log.committing");
    8000421e:	00004517          	auipc	a0,0x4
    80004222:	3ca50513          	addi	a0,a0,970 # 800085e8 <syscalls+0x1e0>
    80004226:	ffffc097          	auipc	ra,0xffffc
    8000422a:	322080e7          	jalr	802(ra) # 80000548 <panic>
    wakeup(&log);
    8000422e:	0001d497          	auipc	s1,0x1d
    80004232:	6da48493          	addi	s1,s1,1754 # 80021908 <log>
    80004236:	8526                	mv	a0,s1
    80004238:	ffffe097          	auipc	ra,0xffffe
    8000423c:	176080e7          	jalr	374(ra) # 800023ae <wakeup>
  release(&log.lock);
    80004240:	8526                	mv	a0,s1
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	a82080e7          	jalr	-1406(ra) # 80000cc4 <release>
  if(do_commit){
    8000424a:	b7c9                	j	8000420c <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000424c:	0001da97          	auipc	s5,0x1d
    80004250:	6eca8a93          	addi	s5,s5,1772 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004254:	0001da17          	auipc	s4,0x1d
    80004258:	6b4a0a13          	addi	s4,s4,1716 # 80021908 <log>
    8000425c:	018a2583          	lw	a1,24(s4)
    80004260:	012585bb          	addw	a1,a1,s2
    80004264:	2585                	addiw	a1,a1,1
    80004266:	028a2503          	lw	a0,40(s4)
    8000426a:	fffff097          	auipc	ra,0xfffff
    8000426e:	ce4080e7          	jalr	-796(ra) # 80002f4e <bread>
    80004272:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004274:	000aa583          	lw	a1,0(s5)
    80004278:	028a2503          	lw	a0,40(s4)
    8000427c:	fffff097          	auipc	ra,0xfffff
    80004280:	cd2080e7          	jalr	-814(ra) # 80002f4e <bread>
    80004284:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004286:	40000613          	li	a2,1024
    8000428a:	05850593          	addi	a1,a0,88
    8000428e:	05848513          	addi	a0,s1,88
    80004292:	ffffd097          	auipc	ra,0xffffd
    80004296:	ada080e7          	jalr	-1318(ra) # 80000d6c <memmove>
    bwrite(to);  // write the log
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	da4080e7          	jalr	-604(ra) # 80003040 <bwrite>
    brelse(from);
    800042a4:	854e                	mv	a0,s3
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	dd8080e7          	jalr	-552(ra) # 8000307e <brelse>
    brelse(to);
    800042ae:	8526                	mv	a0,s1
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	dce080e7          	jalr	-562(ra) # 8000307e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800042b8:	2905                	addiw	s2,s2,1
    800042ba:	0a91                	addi	s5,s5,4
    800042bc:	02ca2783          	lw	a5,44(s4)
    800042c0:	f8f94ee3          	blt	s2,a5,8000425c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042c4:	00000097          	auipc	ra,0x0
    800042c8:	c7a080e7          	jalr	-902(ra) # 80003f3e <write_head>
    install_trans(); // Now install writes to home locations
    800042cc:	00000097          	auipc	ra,0x0
    800042d0:	cec080e7          	jalr	-788(ra) # 80003fb8 <install_trans>
    log.lh.n = 0;
    800042d4:	0001d797          	auipc	a5,0x1d
    800042d8:	6607a023          	sw	zero,1632(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042dc:	00000097          	auipc	ra,0x0
    800042e0:	c62080e7          	jalr	-926(ra) # 80003f3e <write_head>
    800042e4:	bdfd                	j	800041e2 <end_op+0x52>

00000000800042e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042e6:	1101                	addi	sp,sp,-32
    800042e8:	ec06                	sd	ra,24(sp)
    800042ea:	e822                	sd	s0,16(sp)
    800042ec:	e426                	sd	s1,8(sp)
    800042ee:	e04a                	sd	s2,0(sp)
    800042f0:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042f2:	0001d717          	auipc	a4,0x1d
    800042f6:	64272703          	lw	a4,1602(a4) # 80021934 <log+0x2c>
    800042fa:	47f5                	li	a5,29
    800042fc:	08e7c063          	blt	a5,a4,8000437c <log_write+0x96>
    80004300:	84aa                	mv	s1,a0
    80004302:	0001d797          	auipc	a5,0x1d
    80004306:	6227a783          	lw	a5,1570(a5) # 80021924 <log+0x1c>
    8000430a:	37fd                	addiw	a5,a5,-1
    8000430c:	06f75863          	bge	a4,a5,8000437c <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004310:	0001d797          	auipc	a5,0x1d
    80004314:	6187a783          	lw	a5,1560(a5) # 80021928 <log+0x20>
    80004318:	06f05a63          	blez	a5,8000438c <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    8000431c:	0001d917          	auipc	s2,0x1d
    80004320:	5ec90913          	addi	s2,s2,1516 # 80021908 <log>
    80004324:	854a                	mv	a0,s2
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	8ea080e7          	jalr	-1814(ra) # 80000c10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    8000432e:	02c92603          	lw	a2,44(s2)
    80004332:	06c05563          	blez	a2,8000439c <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004336:	44cc                	lw	a1,12(s1)
    80004338:	0001d717          	auipc	a4,0x1d
    8000433c:	60070713          	addi	a4,a4,1536 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004340:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004342:	4314                	lw	a3,0(a4)
    80004344:	04b68d63          	beq	a3,a1,8000439e <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    80004348:	2785                	addiw	a5,a5,1
    8000434a:	0711                	addi	a4,a4,4
    8000434c:	fec79be3          	bne	a5,a2,80004342 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004350:	0621                	addi	a2,a2,8
    80004352:	060a                	slli	a2,a2,0x2
    80004354:	0001d797          	auipc	a5,0x1d
    80004358:	5b478793          	addi	a5,a5,1460 # 80021908 <log>
    8000435c:	963e                	add	a2,a2,a5
    8000435e:	44dc                	lw	a5,12(s1)
    80004360:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004362:	8526                	mv	a0,s1
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	db8080e7          	jalr	-584(ra) # 8000311c <bpin>
    log.lh.n++;
    8000436c:	0001d717          	auipc	a4,0x1d
    80004370:	59c70713          	addi	a4,a4,1436 # 80021908 <log>
    80004374:	575c                	lw	a5,44(a4)
    80004376:	2785                	addiw	a5,a5,1
    80004378:	d75c                	sw	a5,44(a4)
    8000437a:	a83d                	j	800043b8 <log_write+0xd2>
    panic("too big a transaction");
    8000437c:	00004517          	auipc	a0,0x4
    80004380:	27c50513          	addi	a0,a0,636 # 800085f8 <syscalls+0x1f0>
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	1c4080e7          	jalr	452(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    8000438c:	00004517          	auipc	a0,0x4
    80004390:	28450513          	addi	a0,a0,644 # 80008610 <syscalls+0x208>
    80004394:	ffffc097          	auipc	ra,0xffffc
    80004398:	1b4080e7          	jalr	436(ra) # 80000548 <panic>
  for (i = 0; i < log.lh.n; i++) {
    8000439c:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    8000439e:	00878713          	addi	a4,a5,8
    800043a2:	00271693          	slli	a3,a4,0x2
    800043a6:	0001d717          	auipc	a4,0x1d
    800043aa:	56270713          	addi	a4,a4,1378 # 80021908 <log>
    800043ae:	9736                	add	a4,a4,a3
    800043b0:	44d4                	lw	a3,12(s1)
    800043b2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800043b4:	faf607e3          	beq	a2,a5,80004362 <log_write+0x7c>
  }
  release(&log.lock);
    800043b8:	0001d517          	auipc	a0,0x1d
    800043bc:	55050513          	addi	a0,a0,1360 # 80021908 <log>
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	904080e7          	jalr	-1788(ra) # 80000cc4 <release>
}
    800043c8:	60e2                	ld	ra,24(sp)
    800043ca:	6442                	ld	s0,16(sp)
    800043cc:	64a2                	ld	s1,8(sp)
    800043ce:	6902                	ld	s2,0(sp)
    800043d0:	6105                	addi	sp,sp,32
    800043d2:	8082                	ret

00000000800043d4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043d4:	1101                	addi	sp,sp,-32
    800043d6:	ec06                	sd	ra,24(sp)
    800043d8:	e822                	sd	s0,16(sp)
    800043da:	e426                	sd	s1,8(sp)
    800043dc:	e04a                	sd	s2,0(sp)
    800043de:	1000                	addi	s0,sp,32
    800043e0:	84aa                	mv	s1,a0
    800043e2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043e4:	00004597          	auipc	a1,0x4
    800043e8:	24c58593          	addi	a1,a1,588 # 80008630 <syscalls+0x228>
    800043ec:	0521                	addi	a0,a0,8
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	792080e7          	jalr	1938(ra) # 80000b80 <initlock>
  lk->name = name;
    800043f6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043fa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043fe:	0204a423          	sw	zero,40(s1)
}
    80004402:	60e2                	ld	ra,24(sp)
    80004404:	6442                	ld	s0,16(sp)
    80004406:	64a2                	ld	s1,8(sp)
    80004408:	6902                	ld	s2,0(sp)
    8000440a:	6105                	addi	sp,sp,32
    8000440c:	8082                	ret

000000008000440e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000440e:	1101                	addi	sp,sp,-32
    80004410:	ec06                	sd	ra,24(sp)
    80004412:	e822                	sd	s0,16(sp)
    80004414:	e426                	sd	s1,8(sp)
    80004416:	e04a                	sd	s2,0(sp)
    80004418:	1000                	addi	s0,sp,32
    8000441a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000441c:	00850913          	addi	s2,a0,8
    80004420:	854a                	mv	a0,s2
    80004422:	ffffc097          	auipc	ra,0xffffc
    80004426:	7ee080e7          	jalr	2030(ra) # 80000c10 <acquire>
  while (lk->locked) {
    8000442a:	409c                	lw	a5,0(s1)
    8000442c:	cb89                	beqz	a5,8000443e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000442e:	85ca                	mv	a1,s2
    80004430:	8526                	mv	a0,s1
    80004432:	ffffe097          	auipc	ra,0xffffe
    80004436:	df6080e7          	jalr	-522(ra) # 80002228 <sleep>
  while (lk->locked) {
    8000443a:	409c                	lw	a5,0(s1)
    8000443c:	fbed                	bnez	a5,8000442e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000443e:	4785                	li	a5,1
    80004440:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004442:	ffffd097          	auipc	ra,0xffffd
    80004446:	5d6080e7          	jalr	1494(ra) # 80001a18 <myproc>
    8000444a:	5d1c                	lw	a5,56(a0)
    8000444c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000444e:	854a                	mv	a0,s2
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	874080e7          	jalr	-1932(ra) # 80000cc4 <release>
}
    80004458:	60e2                	ld	ra,24(sp)
    8000445a:	6442                	ld	s0,16(sp)
    8000445c:	64a2                	ld	s1,8(sp)
    8000445e:	6902                	ld	s2,0(sp)
    80004460:	6105                	addi	sp,sp,32
    80004462:	8082                	ret

0000000080004464 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004464:	1101                	addi	sp,sp,-32
    80004466:	ec06                	sd	ra,24(sp)
    80004468:	e822                	sd	s0,16(sp)
    8000446a:	e426                	sd	s1,8(sp)
    8000446c:	e04a                	sd	s2,0(sp)
    8000446e:	1000                	addi	s0,sp,32
    80004470:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004472:	00850913          	addi	s2,a0,8
    80004476:	854a                	mv	a0,s2
    80004478:	ffffc097          	auipc	ra,0xffffc
    8000447c:	798080e7          	jalr	1944(ra) # 80000c10 <acquire>
  lk->locked = 0;
    80004480:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004484:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004488:	8526                	mv	a0,s1
    8000448a:	ffffe097          	auipc	ra,0xffffe
    8000448e:	f24080e7          	jalr	-220(ra) # 800023ae <wakeup>
  release(&lk->lk);
    80004492:	854a                	mv	a0,s2
    80004494:	ffffd097          	auipc	ra,0xffffd
    80004498:	830080e7          	jalr	-2000(ra) # 80000cc4 <release>
}
    8000449c:	60e2                	ld	ra,24(sp)
    8000449e:	6442                	ld	s0,16(sp)
    800044a0:	64a2                	ld	s1,8(sp)
    800044a2:	6902                	ld	s2,0(sp)
    800044a4:	6105                	addi	sp,sp,32
    800044a6:	8082                	ret

00000000800044a8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800044a8:	7179                	addi	sp,sp,-48
    800044aa:	f406                	sd	ra,40(sp)
    800044ac:	f022                	sd	s0,32(sp)
    800044ae:	ec26                	sd	s1,24(sp)
    800044b0:	e84a                	sd	s2,16(sp)
    800044b2:	e44e                	sd	s3,8(sp)
    800044b4:	1800                	addi	s0,sp,48
    800044b6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800044b8:	00850913          	addi	s2,a0,8
    800044bc:	854a                	mv	a0,s2
    800044be:	ffffc097          	auipc	ra,0xffffc
    800044c2:	752080e7          	jalr	1874(ra) # 80000c10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044c6:	409c                	lw	a5,0(s1)
    800044c8:	ef99                	bnez	a5,800044e6 <holdingsleep+0x3e>
    800044ca:	4481                	li	s1,0
  release(&lk->lk);
    800044cc:	854a                	mv	a0,s2
    800044ce:	ffffc097          	auipc	ra,0xffffc
    800044d2:	7f6080e7          	jalr	2038(ra) # 80000cc4 <release>
  return r;
}
    800044d6:	8526                	mv	a0,s1
    800044d8:	70a2                	ld	ra,40(sp)
    800044da:	7402                	ld	s0,32(sp)
    800044dc:	64e2                	ld	s1,24(sp)
    800044de:	6942                	ld	s2,16(sp)
    800044e0:	69a2                	ld	s3,8(sp)
    800044e2:	6145                	addi	sp,sp,48
    800044e4:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044e6:	0284a983          	lw	s3,40(s1)
    800044ea:	ffffd097          	auipc	ra,0xffffd
    800044ee:	52e080e7          	jalr	1326(ra) # 80001a18 <myproc>
    800044f2:	5d04                	lw	s1,56(a0)
    800044f4:	413484b3          	sub	s1,s1,s3
    800044f8:	0014b493          	seqz	s1,s1
    800044fc:	bfc1                	j	800044cc <holdingsleep+0x24>

00000000800044fe <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044fe:	1141                	addi	sp,sp,-16
    80004500:	e406                	sd	ra,8(sp)
    80004502:	e022                	sd	s0,0(sp)
    80004504:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004506:	00004597          	auipc	a1,0x4
    8000450a:	13a58593          	addi	a1,a1,314 # 80008640 <syscalls+0x238>
    8000450e:	0001d517          	auipc	a0,0x1d
    80004512:	54250513          	addi	a0,a0,1346 # 80021a50 <ftable>
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	66a080e7          	jalr	1642(ra) # 80000b80 <initlock>
}
    8000451e:	60a2                	ld	ra,8(sp)
    80004520:	6402                	ld	s0,0(sp)
    80004522:	0141                	addi	sp,sp,16
    80004524:	8082                	ret

0000000080004526 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004526:	1101                	addi	sp,sp,-32
    80004528:	ec06                	sd	ra,24(sp)
    8000452a:	e822                	sd	s0,16(sp)
    8000452c:	e426                	sd	s1,8(sp)
    8000452e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004530:	0001d517          	auipc	a0,0x1d
    80004534:	52050513          	addi	a0,a0,1312 # 80021a50 <ftable>
    80004538:	ffffc097          	auipc	ra,0xffffc
    8000453c:	6d8080e7          	jalr	1752(ra) # 80000c10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004540:	0001d497          	auipc	s1,0x1d
    80004544:	52848493          	addi	s1,s1,1320 # 80021a68 <ftable+0x18>
    80004548:	0001e717          	auipc	a4,0x1e
    8000454c:	4c070713          	addi	a4,a4,1216 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    80004550:	40dc                	lw	a5,4(s1)
    80004552:	cf99                	beqz	a5,80004570 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004554:	02848493          	addi	s1,s1,40
    80004558:	fee49ce3          	bne	s1,a4,80004550 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000455c:	0001d517          	auipc	a0,0x1d
    80004560:	4f450513          	addi	a0,a0,1268 # 80021a50 <ftable>
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	760080e7          	jalr	1888(ra) # 80000cc4 <release>
  return 0;
    8000456c:	4481                	li	s1,0
    8000456e:	a819                	j	80004584 <filealloc+0x5e>
      f->ref = 1;
    80004570:	4785                	li	a5,1
    80004572:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004574:	0001d517          	auipc	a0,0x1d
    80004578:	4dc50513          	addi	a0,a0,1244 # 80021a50 <ftable>
    8000457c:	ffffc097          	auipc	ra,0xffffc
    80004580:	748080e7          	jalr	1864(ra) # 80000cc4 <release>
}
    80004584:	8526                	mv	a0,s1
    80004586:	60e2                	ld	ra,24(sp)
    80004588:	6442                	ld	s0,16(sp)
    8000458a:	64a2                	ld	s1,8(sp)
    8000458c:	6105                	addi	sp,sp,32
    8000458e:	8082                	ret

0000000080004590 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004590:	1101                	addi	sp,sp,-32
    80004592:	ec06                	sd	ra,24(sp)
    80004594:	e822                	sd	s0,16(sp)
    80004596:	e426                	sd	s1,8(sp)
    80004598:	1000                	addi	s0,sp,32
    8000459a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000459c:	0001d517          	auipc	a0,0x1d
    800045a0:	4b450513          	addi	a0,a0,1204 # 80021a50 <ftable>
    800045a4:	ffffc097          	auipc	ra,0xffffc
    800045a8:	66c080e7          	jalr	1644(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    800045ac:	40dc                	lw	a5,4(s1)
    800045ae:	02f05263          	blez	a5,800045d2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800045b2:	2785                	addiw	a5,a5,1
    800045b4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800045b6:	0001d517          	auipc	a0,0x1d
    800045ba:	49a50513          	addi	a0,a0,1178 # 80021a50 <ftable>
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	706080e7          	jalr	1798(ra) # 80000cc4 <release>
  return f;
}
    800045c6:	8526                	mv	a0,s1
    800045c8:	60e2                	ld	ra,24(sp)
    800045ca:	6442                	ld	s0,16(sp)
    800045cc:	64a2                	ld	s1,8(sp)
    800045ce:	6105                	addi	sp,sp,32
    800045d0:	8082                	ret
    panic("filedup");
    800045d2:	00004517          	auipc	a0,0x4
    800045d6:	07650513          	addi	a0,a0,118 # 80008648 <syscalls+0x240>
    800045da:	ffffc097          	auipc	ra,0xffffc
    800045de:	f6e080e7          	jalr	-146(ra) # 80000548 <panic>

00000000800045e2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045e2:	7139                	addi	sp,sp,-64
    800045e4:	fc06                	sd	ra,56(sp)
    800045e6:	f822                	sd	s0,48(sp)
    800045e8:	f426                	sd	s1,40(sp)
    800045ea:	f04a                	sd	s2,32(sp)
    800045ec:	ec4e                	sd	s3,24(sp)
    800045ee:	e852                	sd	s4,16(sp)
    800045f0:	e456                	sd	s5,8(sp)
    800045f2:	0080                	addi	s0,sp,64
    800045f4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045f6:	0001d517          	auipc	a0,0x1d
    800045fa:	45a50513          	addi	a0,a0,1114 # 80021a50 <ftable>
    800045fe:	ffffc097          	auipc	ra,0xffffc
    80004602:	612080e7          	jalr	1554(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    80004606:	40dc                	lw	a5,4(s1)
    80004608:	06f05163          	blez	a5,8000466a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    8000460c:	37fd                	addiw	a5,a5,-1
    8000460e:	0007871b          	sext.w	a4,a5
    80004612:	c0dc                	sw	a5,4(s1)
    80004614:	06e04363          	bgtz	a4,8000467a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004618:	0004a903          	lw	s2,0(s1)
    8000461c:	0094ca83          	lbu	s5,9(s1)
    80004620:	0104ba03          	ld	s4,16(s1)
    80004624:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004628:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000462c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004630:	0001d517          	auipc	a0,0x1d
    80004634:	42050513          	addi	a0,a0,1056 # 80021a50 <ftable>
    80004638:	ffffc097          	auipc	ra,0xffffc
    8000463c:	68c080e7          	jalr	1676(ra) # 80000cc4 <release>

  if(ff.type == FD_PIPE){
    80004640:	4785                	li	a5,1
    80004642:	04f90d63          	beq	s2,a5,8000469c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004646:	3979                	addiw	s2,s2,-2
    80004648:	4785                	li	a5,1
    8000464a:	0527e063          	bltu	a5,s2,8000468a <fileclose+0xa8>
    begin_op();
    8000464e:	00000097          	auipc	ra,0x0
    80004652:	ac2080e7          	jalr	-1342(ra) # 80004110 <begin_op>
    iput(ff.ip);
    80004656:	854e                	mv	a0,s3
    80004658:	fffff097          	auipc	ra,0xfffff
    8000465c:	2b2080e7          	jalr	690(ra) # 8000390a <iput>
    end_op();
    80004660:	00000097          	auipc	ra,0x0
    80004664:	b30080e7          	jalr	-1232(ra) # 80004190 <end_op>
    80004668:	a00d                	j	8000468a <fileclose+0xa8>
    panic("fileclose");
    8000466a:	00004517          	auipc	a0,0x4
    8000466e:	fe650513          	addi	a0,a0,-26 # 80008650 <syscalls+0x248>
    80004672:	ffffc097          	auipc	ra,0xffffc
    80004676:	ed6080e7          	jalr	-298(ra) # 80000548 <panic>
    release(&ftable.lock);
    8000467a:	0001d517          	auipc	a0,0x1d
    8000467e:	3d650513          	addi	a0,a0,982 # 80021a50 <ftable>
    80004682:	ffffc097          	auipc	ra,0xffffc
    80004686:	642080e7          	jalr	1602(ra) # 80000cc4 <release>
  }
}
    8000468a:	70e2                	ld	ra,56(sp)
    8000468c:	7442                	ld	s0,48(sp)
    8000468e:	74a2                	ld	s1,40(sp)
    80004690:	7902                	ld	s2,32(sp)
    80004692:	69e2                	ld	s3,24(sp)
    80004694:	6a42                	ld	s4,16(sp)
    80004696:	6aa2                	ld	s5,8(sp)
    80004698:	6121                	addi	sp,sp,64
    8000469a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000469c:	85d6                	mv	a1,s5
    8000469e:	8552                	mv	a0,s4
    800046a0:	00000097          	auipc	ra,0x0
    800046a4:	372080e7          	jalr	882(ra) # 80004a12 <pipeclose>
    800046a8:	b7cd                	j	8000468a <fileclose+0xa8>

00000000800046aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800046aa:	715d                	addi	sp,sp,-80
    800046ac:	e486                	sd	ra,72(sp)
    800046ae:	e0a2                	sd	s0,64(sp)
    800046b0:	fc26                	sd	s1,56(sp)
    800046b2:	f84a                	sd	s2,48(sp)
    800046b4:	f44e                	sd	s3,40(sp)
    800046b6:	0880                	addi	s0,sp,80
    800046b8:	84aa                	mv	s1,a0
    800046ba:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800046bc:	ffffd097          	auipc	ra,0xffffd
    800046c0:	35c080e7          	jalr	860(ra) # 80001a18 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800046c4:	409c                	lw	a5,0(s1)
    800046c6:	37f9                	addiw	a5,a5,-2
    800046c8:	4705                	li	a4,1
    800046ca:	04f76763          	bltu	a4,a5,80004718 <filestat+0x6e>
    800046ce:	892a                	mv	s2,a0
    ilock(f->ip);
    800046d0:	6c88                	ld	a0,24(s1)
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	07e080e7          	jalr	126(ra) # 80003750 <ilock>
    stati(f->ip, &st);
    800046da:	fb840593          	addi	a1,s0,-72
    800046de:	6c88                	ld	a0,24(s1)
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	2fa080e7          	jalr	762(ra) # 800039da <stati>
    iunlock(f->ip);
    800046e8:	6c88                	ld	a0,24(s1)
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	128080e7          	jalr	296(ra) # 80003812 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046f2:	46e1                	li	a3,24
    800046f4:	fb840613          	addi	a2,s0,-72
    800046f8:	85ce                	mv	a1,s3
    800046fa:	05093503          	ld	a0,80(s2)
    800046fe:	ffffd097          	auipc	ra,0xffffd
    80004702:	00e080e7          	jalr	14(ra) # 8000170c <copyout>
    80004706:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    8000470a:	60a6                	ld	ra,72(sp)
    8000470c:	6406                	ld	s0,64(sp)
    8000470e:	74e2                	ld	s1,56(sp)
    80004710:	7942                	ld	s2,48(sp)
    80004712:	79a2                	ld	s3,40(sp)
    80004714:	6161                	addi	sp,sp,80
    80004716:	8082                	ret
  return -1;
    80004718:	557d                	li	a0,-1
    8000471a:	bfc5                	j	8000470a <filestat+0x60>

000000008000471c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000471c:	7179                	addi	sp,sp,-48
    8000471e:	f406                	sd	ra,40(sp)
    80004720:	f022                	sd	s0,32(sp)
    80004722:	ec26                	sd	s1,24(sp)
    80004724:	e84a                	sd	s2,16(sp)
    80004726:	e44e                	sd	s3,8(sp)
    80004728:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000472a:	00854783          	lbu	a5,8(a0)
    8000472e:	c3d5                	beqz	a5,800047d2 <fileread+0xb6>
    80004730:	84aa                	mv	s1,a0
    80004732:	89ae                	mv	s3,a1
    80004734:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004736:	411c                	lw	a5,0(a0)
    80004738:	4705                	li	a4,1
    8000473a:	04e78963          	beq	a5,a4,8000478c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000473e:	470d                	li	a4,3
    80004740:	04e78d63          	beq	a5,a4,8000479a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004744:	4709                	li	a4,2
    80004746:	06e79e63          	bne	a5,a4,800047c2 <fileread+0xa6>
    ilock(f->ip);
    8000474a:	6d08                	ld	a0,24(a0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	004080e7          	jalr	4(ra) # 80003750 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004754:	874a                	mv	a4,s2
    80004756:	5094                	lw	a3,32(s1)
    80004758:	864e                	mv	a2,s3
    8000475a:	4585                	li	a1,1
    8000475c:	6c88                	ld	a0,24(s1)
    8000475e:	fffff097          	auipc	ra,0xfffff
    80004762:	2a6080e7          	jalr	678(ra) # 80003a04 <readi>
    80004766:	892a                	mv	s2,a0
    80004768:	00a05563          	blez	a0,80004772 <fileread+0x56>
      f->off += r;
    8000476c:	509c                	lw	a5,32(s1)
    8000476e:	9fa9                	addw	a5,a5,a0
    80004770:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004772:	6c88                	ld	a0,24(s1)
    80004774:	fffff097          	auipc	ra,0xfffff
    80004778:	09e080e7          	jalr	158(ra) # 80003812 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    8000477c:	854a                	mv	a0,s2
    8000477e:	70a2                	ld	ra,40(sp)
    80004780:	7402                	ld	s0,32(sp)
    80004782:	64e2                	ld	s1,24(sp)
    80004784:	6942                	ld	s2,16(sp)
    80004786:	69a2                	ld	s3,8(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000478c:	6908                	ld	a0,16(a0)
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	418080e7          	jalr	1048(ra) # 80004ba6 <piperead>
    80004796:	892a                	mv	s2,a0
    80004798:	b7d5                	j	8000477c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000479a:	02451783          	lh	a5,36(a0)
    8000479e:	03079693          	slli	a3,a5,0x30
    800047a2:	92c1                	srli	a3,a3,0x30
    800047a4:	4725                	li	a4,9
    800047a6:	02d76863          	bltu	a4,a3,800047d6 <fileread+0xba>
    800047aa:	0792                	slli	a5,a5,0x4
    800047ac:	0001d717          	auipc	a4,0x1d
    800047b0:	20470713          	addi	a4,a4,516 # 800219b0 <devsw>
    800047b4:	97ba                	add	a5,a5,a4
    800047b6:	639c                	ld	a5,0(a5)
    800047b8:	c38d                	beqz	a5,800047da <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    800047ba:	4505                	li	a0,1
    800047bc:	9782                	jalr	a5
    800047be:	892a                	mv	s2,a0
    800047c0:	bf75                	j	8000477c <fileread+0x60>
    panic("fileread");
    800047c2:	00004517          	auipc	a0,0x4
    800047c6:	e9e50513          	addi	a0,a0,-354 # 80008660 <syscalls+0x258>
    800047ca:	ffffc097          	auipc	ra,0xffffc
    800047ce:	d7e080e7          	jalr	-642(ra) # 80000548 <panic>
    return -1;
    800047d2:	597d                	li	s2,-1
    800047d4:	b765                	j	8000477c <fileread+0x60>
      return -1;
    800047d6:	597d                	li	s2,-1
    800047d8:	b755                	j	8000477c <fileread+0x60>
    800047da:	597d                	li	s2,-1
    800047dc:	b745                	j	8000477c <fileread+0x60>

00000000800047de <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800047de:	00954783          	lbu	a5,9(a0)
    800047e2:	14078563          	beqz	a5,8000492c <filewrite+0x14e>
{
    800047e6:	715d                	addi	sp,sp,-80
    800047e8:	e486                	sd	ra,72(sp)
    800047ea:	e0a2                	sd	s0,64(sp)
    800047ec:	fc26                	sd	s1,56(sp)
    800047ee:	f84a                	sd	s2,48(sp)
    800047f0:	f44e                	sd	s3,40(sp)
    800047f2:	f052                	sd	s4,32(sp)
    800047f4:	ec56                	sd	s5,24(sp)
    800047f6:	e85a                	sd	s6,16(sp)
    800047f8:	e45e                	sd	s7,8(sp)
    800047fa:	e062                	sd	s8,0(sp)
    800047fc:	0880                	addi	s0,sp,80
    800047fe:	892a                	mv	s2,a0
    80004800:	8aae                	mv	s5,a1
    80004802:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004804:	411c                	lw	a5,0(a0)
    80004806:	4705                	li	a4,1
    80004808:	02e78263          	beq	a5,a4,8000482c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000480c:	470d                	li	a4,3
    8000480e:	02e78563          	beq	a5,a4,80004838 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004812:	4709                	li	a4,2
    80004814:	10e79463          	bne	a5,a4,8000491c <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004818:	0ec05e63          	blez	a2,80004914 <filewrite+0x136>
    int i = 0;
    8000481c:	4981                	li	s3,0
    8000481e:	6b05                	lui	s6,0x1
    80004820:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004824:	6b85                	lui	s7,0x1
    80004826:	c00b8b9b          	addiw	s7,s7,-1024
    8000482a:	a851                	j	800048be <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    8000482c:	6908                	ld	a0,16(a0)
    8000482e:	00000097          	auipc	ra,0x0
    80004832:	254080e7          	jalr	596(ra) # 80004a82 <pipewrite>
    80004836:	a85d                	j	800048ec <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004838:	02451783          	lh	a5,36(a0)
    8000483c:	03079693          	slli	a3,a5,0x30
    80004840:	92c1                	srli	a3,a3,0x30
    80004842:	4725                	li	a4,9
    80004844:	0ed76663          	bltu	a4,a3,80004930 <filewrite+0x152>
    80004848:	0792                	slli	a5,a5,0x4
    8000484a:	0001d717          	auipc	a4,0x1d
    8000484e:	16670713          	addi	a4,a4,358 # 800219b0 <devsw>
    80004852:	97ba                	add	a5,a5,a4
    80004854:	679c                	ld	a5,8(a5)
    80004856:	cff9                	beqz	a5,80004934 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    80004858:	4505                	li	a0,1
    8000485a:	9782                	jalr	a5
    8000485c:	a841                	j	800048ec <filewrite+0x10e>
    8000485e:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004862:	00000097          	auipc	ra,0x0
    80004866:	8ae080e7          	jalr	-1874(ra) # 80004110 <begin_op>
      ilock(f->ip);
    8000486a:	01893503          	ld	a0,24(s2)
    8000486e:	fffff097          	auipc	ra,0xfffff
    80004872:	ee2080e7          	jalr	-286(ra) # 80003750 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004876:	8762                	mv	a4,s8
    80004878:	02092683          	lw	a3,32(s2)
    8000487c:	01598633          	add	a2,s3,s5
    80004880:	4585                	li	a1,1
    80004882:	01893503          	ld	a0,24(s2)
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	276080e7          	jalr	630(ra) # 80003afc <writei>
    8000488e:	84aa                	mv	s1,a0
    80004890:	02a05f63          	blez	a0,800048ce <filewrite+0xf0>
        f->off += r;
    80004894:	02092783          	lw	a5,32(s2)
    80004898:	9fa9                	addw	a5,a5,a0
    8000489a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000489e:	01893503          	ld	a0,24(s2)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	f70080e7          	jalr	-144(ra) # 80003812 <iunlock>
      end_op();
    800048aa:	00000097          	auipc	ra,0x0
    800048ae:	8e6080e7          	jalr	-1818(ra) # 80004190 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    800048b2:	049c1963          	bne	s8,s1,80004904 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    800048b6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800048ba:	0349d663          	bge	s3,s4,800048e6 <filewrite+0x108>
      int n1 = n - i;
    800048be:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800048c2:	84be                	mv	s1,a5
    800048c4:	2781                	sext.w	a5,a5
    800048c6:	f8fb5ce3          	bge	s6,a5,8000485e <filewrite+0x80>
    800048ca:	84de                	mv	s1,s7
    800048cc:	bf49                	j	8000485e <filewrite+0x80>
      iunlock(f->ip);
    800048ce:	01893503          	ld	a0,24(s2)
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	f40080e7          	jalr	-192(ra) # 80003812 <iunlock>
      end_op();
    800048da:	00000097          	auipc	ra,0x0
    800048de:	8b6080e7          	jalr	-1866(ra) # 80004190 <end_op>
      if(r < 0)
    800048e2:	fc04d8e3          	bgez	s1,800048b2 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    800048e6:	8552                	mv	a0,s4
    800048e8:	033a1863          	bne	s4,s3,80004918 <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048ec:	60a6                	ld	ra,72(sp)
    800048ee:	6406                	ld	s0,64(sp)
    800048f0:	74e2                	ld	s1,56(sp)
    800048f2:	7942                	ld	s2,48(sp)
    800048f4:	79a2                	ld	s3,40(sp)
    800048f6:	7a02                	ld	s4,32(sp)
    800048f8:	6ae2                	ld	s5,24(sp)
    800048fa:	6b42                	ld	s6,16(sp)
    800048fc:	6ba2                	ld	s7,8(sp)
    800048fe:	6c02                	ld	s8,0(sp)
    80004900:	6161                	addi	sp,sp,80
    80004902:	8082                	ret
        panic("short filewrite");
    80004904:	00004517          	auipc	a0,0x4
    80004908:	d6c50513          	addi	a0,a0,-660 # 80008670 <syscalls+0x268>
    8000490c:	ffffc097          	auipc	ra,0xffffc
    80004910:	c3c080e7          	jalr	-964(ra) # 80000548 <panic>
    int i = 0;
    80004914:	4981                	li	s3,0
    80004916:	bfc1                	j	800048e6 <filewrite+0x108>
    ret = (i == n ? n : -1);
    80004918:	557d                	li	a0,-1
    8000491a:	bfc9                	j	800048ec <filewrite+0x10e>
    panic("filewrite");
    8000491c:	00004517          	auipc	a0,0x4
    80004920:	d6450513          	addi	a0,a0,-668 # 80008680 <syscalls+0x278>
    80004924:	ffffc097          	auipc	ra,0xffffc
    80004928:	c24080e7          	jalr	-988(ra) # 80000548 <panic>
    return -1;
    8000492c:	557d                	li	a0,-1
}
    8000492e:	8082                	ret
      return -1;
    80004930:	557d                	li	a0,-1
    80004932:	bf6d                	j	800048ec <filewrite+0x10e>
    80004934:	557d                	li	a0,-1
    80004936:	bf5d                	j	800048ec <filewrite+0x10e>

0000000080004938 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004938:	7179                	addi	sp,sp,-48
    8000493a:	f406                	sd	ra,40(sp)
    8000493c:	f022                	sd	s0,32(sp)
    8000493e:	ec26                	sd	s1,24(sp)
    80004940:	e84a                	sd	s2,16(sp)
    80004942:	e44e                	sd	s3,8(sp)
    80004944:	e052                	sd	s4,0(sp)
    80004946:	1800                	addi	s0,sp,48
    80004948:	84aa                	mv	s1,a0
    8000494a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000494c:	0005b023          	sd	zero,0(a1)
    80004950:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004954:	00000097          	auipc	ra,0x0
    80004958:	bd2080e7          	jalr	-1070(ra) # 80004526 <filealloc>
    8000495c:	e088                	sd	a0,0(s1)
    8000495e:	c551                	beqz	a0,800049ea <pipealloc+0xb2>
    80004960:	00000097          	auipc	ra,0x0
    80004964:	bc6080e7          	jalr	-1082(ra) # 80004526 <filealloc>
    80004968:	00aa3023          	sd	a0,0(s4)
    8000496c:	c92d                	beqz	a0,800049de <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000496e:	ffffc097          	auipc	ra,0xffffc
    80004972:	1b2080e7          	jalr	434(ra) # 80000b20 <kalloc>
    80004976:	892a                	mv	s2,a0
    80004978:	c125                	beqz	a0,800049d8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000497a:	4985                	li	s3,1
    8000497c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004980:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004984:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004988:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000498c:	00004597          	auipc	a1,0x4
    80004990:	d0458593          	addi	a1,a1,-764 # 80008690 <syscalls+0x288>
    80004994:	ffffc097          	auipc	ra,0xffffc
    80004998:	1ec080e7          	jalr	492(ra) # 80000b80 <initlock>
  (*f0)->type = FD_PIPE;
    8000499c:	609c                	ld	a5,0(s1)
    8000499e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800049a2:	609c                	ld	a5,0(s1)
    800049a4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800049a8:	609c                	ld	a5,0(s1)
    800049aa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800049ae:	609c                	ld	a5,0(s1)
    800049b0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800049b4:	000a3783          	ld	a5,0(s4)
    800049b8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800049bc:	000a3783          	ld	a5,0(s4)
    800049c0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800049c4:	000a3783          	ld	a5,0(s4)
    800049c8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800049cc:	000a3783          	ld	a5,0(s4)
    800049d0:	0127b823          	sd	s2,16(a5)
  return 0;
    800049d4:	4501                	li	a0,0
    800049d6:	a025                	j	800049fe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800049d8:	6088                	ld	a0,0(s1)
    800049da:	e501                	bnez	a0,800049e2 <pipealloc+0xaa>
    800049dc:	a039                	j	800049ea <pipealloc+0xb2>
    800049de:	6088                	ld	a0,0(s1)
    800049e0:	c51d                	beqz	a0,80004a0e <pipealloc+0xd6>
    fileclose(*f0);
    800049e2:	00000097          	auipc	ra,0x0
    800049e6:	c00080e7          	jalr	-1024(ra) # 800045e2 <fileclose>
  if(*f1)
    800049ea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049ee:	557d                	li	a0,-1
  if(*f1)
    800049f0:	c799                	beqz	a5,800049fe <pipealloc+0xc6>
    fileclose(*f1);
    800049f2:	853e                	mv	a0,a5
    800049f4:	00000097          	auipc	ra,0x0
    800049f8:	bee080e7          	jalr	-1042(ra) # 800045e2 <fileclose>
  return -1;
    800049fc:	557d                	li	a0,-1
}
    800049fe:	70a2                	ld	ra,40(sp)
    80004a00:	7402                	ld	s0,32(sp)
    80004a02:	64e2                	ld	s1,24(sp)
    80004a04:	6942                	ld	s2,16(sp)
    80004a06:	69a2                	ld	s3,8(sp)
    80004a08:	6a02                	ld	s4,0(sp)
    80004a0a:	6145                	addi	sp,sp,48
    80004a0c:	8082                	ret
  return -1;
    80004a0e:	557d                	li	a0,-1
    80004a10:	b7fd                	j	800049fe <pipealloc+0xc6>

0000000080004a12 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004a12:	1101                	addi	sp,sp,-32
    80004a14:	ec06                	sd	ra,24(sp)
    80004a16:	e822                	sd	s0,16(sp)
    80004a18:	e426                	sd	s1,8(sp)
    80004a1a:	e04a                	sd	s2,0(sp)
    80004a1c:	1000                	addi	s0,sp,32
    80004a1e:	84aa                	mv	s1,a0
    80004a20:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004a22:	ffffc097          	auipc	ra,0xffffc
    80004a26:	1ee080e7          	jalr	494(ra) # 80000c10 <acquire>
  if(writable){
    80004a2a:	02090d63          	beqz	s2,80004a64 <pipeclose+0x52>
    pi->writeopen = 0;
    80004a2e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004a32:	21848513          	addi	a0,s1,536
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	978080e7          	jalr	-1672(ra) # 800023ae <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004a3e:	2204b783          	ld	a5,544(s1)
    80004a42:	eb95                	bnez	a5,80004a76 <pipeclose+0x64>
    release(&pi->lock);
    80004a44:	8526                	mv	a0,s1
    80004a46:	ffffc097          	auipc	ra,0xffffc
    80004a4a:	27e080e7          	jalr	638(ra) # 80000cc4 <release>
    kfree((char*)pi);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	fd4080e7          	jalr	-44(ra) # 80000a24 <kfree>
  } else
    release(&pi->lock);
}
    80004a58:	60e2                	ld	ra,24(sp)
    80004a5a:	6442                	ld	s0,16(sp)
    80004a5c:	64a2                	ld	s1,8(sp)
    80004a5e:	6902                	ld	s2,0(sp)
    80004a60:	6105                	addi	sp,sp,32
    80004a62:	8082                	ret
    pi->readopen = 0;
    80004a64:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a68:	21c48513          	addi	a0,s1,540
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	942080e7          	jalr	-1726(ra) # 800023ae <wakeup>
    80004a74:	b7e9                	j	80004a3e <pipeclose+0x2c>
    release(&pi->lock);
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffc097          	auipc	ra,0xffffc
    80004a7c:	24c080e7          	jalr	588(ra) # 80000cc4 <release>
}
    80004a80:	bfe1                	j	80004a58 <pipeclose+0x46>

0000000080004a82 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a82:	7119                	addi	sp,sp,-128
    80004a84:	fc86                	sd	ra,120(sp)
    80004a86:	f8a2                	sd	s0,112(sp)
    80004a88:	f4a6                	sd	s1,104(sp)
    80004a8a:	f0ca                	sd	s2,96(sp)
    80004a8c:	ecce                	sd	s3,88(sp)
    80004a8e:	e8d2                	sd	s4,80(sp)
    80004a90:	e4d6                	sd	s5,72(sp)
    80004a92:	e0da                	sd	s6,64(sp)
    80004a94:	fc5e                	sd	s7,56(sp)
    80004a96:	f862                	sd	s8,48(sp)
    80004a98:	f466                	sd	s9,40(sp)
    80004a9a:	f06a                	sd	s10,32(sp)
    80004a9c:	ec6e                	sd	s11,24(sp)
    80004a9e:	0100                	addi	s0,sp,128
    80004aa0:	84aa                	mv	s1,a0
    80004aa2:	8cae                	mv	s9,a1
    80004aa4:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004aa6:	ffffd097          	auipc	ra,0xffffd
    80004aaa:	f72080e7          	jalr	-142(ra) # 80001a18 <myproc>
    80004aae:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004ab0:	8526                	mv	a0,s1
    80004ab2:	ffffc097          	auipc	ra,0xffffc
    80004ab6:	15e080e7          	jalr	350(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80004aba:	0d605963          	blez	s6,80004b8c <pipewrite+0x10a>
    80004abe:	89a6                	mv	s3,s1
    80004ac0:	3b7d                	addiw	s6,s6,-1
    80004ac2:	1b02                	slli	s6,s6,0x20
    80004ac4:	020b5b13          	srli	s6,s6,0x20
    80004ac8:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004aca:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004ace:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ad2:	5dfd                	li	s11,-1
    80004ad4:	000b8d1b          	sext.w	s10,s7
    80004ad8:	8c6a                	mv	s8,s10
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004ada:	2184a783          	lw	a5,536(s1)
    80004ade:	21c4a703          	lw	a4,540(s1)
    80004ae2:	2007879b          	addiw	a5,a5,512
    80004ae6:	02f71b63          	bne	a4,a5,80004b1c <pipewrite+0x9a>
      if(pi->readopen == 0 || pr->killed){
    80004aea:	2204a783          	lw	a5,544(s1)
    80004aee:	cbad                	beqz	a5,80004b60 <pipewrite+0xde>
    80004af0:	03092783          	lw	a5,48(s2)
    80004af4:	e7b5                	bnez	a5,80004b60 <pipewrite+0xde>
      wakeup(&pi->nread);
    80004af6:	8556                	mv	a0,s5
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	8b6080e7          	jalr	-1866(ra) # 800023ae <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004b00:	85ce                	mv	a1,s3
    80004b02:	8552                	mv	a0,s4
    80004b04:	ffffd097          	auipc	ra,0xffffd
    80004b08:	724080e7          	jalr	1828(ra) # 80002228 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004b0c:	2184a783          	lw	a5,536(s1)
    80004b10:	21c4a703          	lw	a4,540(s1)
    80004b14:	2007879b          	addiw	a5,a5,512
    80004b18:	fcf709e3          	beq	a4,a5,80004aea <pipewrite+0x68>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004b1c:	4685                	li	a3,1
    80004b1e:	019b8633          	add	a2,s7,s9
    80004b22:	f8f40593          	addi	a1,s0,-113
    80004b26:	05093503          	ld	a0,80(s2)
    80004b2a:	ffffd097          	auipc	ra,0xffffd
    80004b2e:	c6e080e7          	jalr	-914(ra) # 80001798 <copyin>
    80004b32:	05b50e63          	beq	a0,s11,80004b8e <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004b36:	21c4a783          	lw	a5,540(s1)
    80004b3a:	0017871b          	addiw	a4,a5,1
    80004b3e:	20e4ae23          	sw	a4,540(s1)
    80004b42:	1ff7f793          	andi	a5,a5,511
    80004b46:	97a6                	add	a5,a5,s1
    80004b48:	f8f44703          	lbu	a4,-113(s0)
    80004b4c:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004b50:	001d0c1b          	addiw	s8,s10,1
    80004b54:	001b8793          	addi	a5,s7,1 # 1001 <_entry-0x7fffefff>
    80004b58:	036b8b63          	beq	s7,s6,80004b8e <pipewrite+0x10c>
    80004b5c:	8bbe                	mv	s7,a5
    80004b5e:	bf9d                	j	80004ad4 <pipewrite+0x52>
        release(&pi->lock);
    80004b60:	8526                	mv	a0,s1
    80004b62:	ffffc097          	auipc	ra,0xffffc
    80004b66:	162080e7          	jalr	354(ra) # 80000cc4 <release>
        return -1;
    80004b6a:	5c7d                	li	s8,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004b6c:	8562                	mv	a0,s8
    80004b6e:	70e6                	ld	ra,120(sp)
    80004b70:	7446                	ld	s0,112(sp)
    80004b72:	74a6                	ld	s1,104(sp)
    80004b74:	7906                	ld	s2,96(sp)
    80004b76:	69e6                	ld	s3,88(sp)
    80004b78:	6a46                	ld	s4,80(sp)
    80004b7a:	6aa6                	ld	s5,72(sp)
    80004b7c:	6b06                	ld	s6,64(sp)
    80004b7e:	7be2                	ld	s7,56(sp)
    80004b80:	7c42                	ld	s8,48(sp)
    80004b82:	7ca2                	ld	s9,40(sp)
    80004b84:	7d02                	ld	s10,32(sp)
    80004b86:	6de2                	ld	s11,24(sp)
    80004b88:	6109                	addi	sp,sp,128
    80004b8a:	8082                	ret
  for(i = 0; i < n; i++){
    80004b8c:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004b8e:	21848513          	addi	a0,s1,536
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	81c080e7          	jalr	-2020(ra) # 800023ae <wakeup>
  release(&pi->lock);
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	ffffc097          	auipc	ra,0xffffc
    80004ba0:	128080e7          	jalr	296(ra) # 80000cc4 <release>
  return i;
    80004ba4:	b7e1                	j	80004b6c <pipewrite+0xea>

0000000080004ba6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004ba6:	715d                	addi	sp,sp,-80
    80004ba8:	e486                	sd	ra,72(sp)
    80004baa:	e0a2                	sd	s0,64(sp)
    80004bac:	fc26                	sd	s1,56(sp)
    80004bae:	f84a                	sd	s2,48(sp)
    80004bb0:	f44e                	sd	s3,40(sp)
    80004bb2:	f052                	sd	s4,32(sp)
    80004bb4:	ec56                	sd	s5,24(sp)
    80004bb6:	e85a                	sd	s6,16(sp)
    80004bb8:	0880                	addi	s0,sp,80
    80004bba:	84aa                	mv	s1,a0
    80004bbc:	892e                	mv	s2,a1
    80004bbe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	e58080e7          	jalr	-424(ra) # 80001a18 <myproc>
    80004bc8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004bca:	8b26                	mv	s6,s1
    80004bcc:	8526                	mv	a0,s1
    80004bce:	ffffc097          	auipc	ra,0xffffc
    80004bd2:	042080e7          	jalr	66(ra) # 80000c10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bd6:	2184a703          	lw	a4,536(s1)
    80004bda:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bde:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004be2:	02f71463          	bne	a4,a5,80004c0a <piperead+0x64>
    80004be6:	2244a783          	lw	a5,548(s1)
    80004bea:	c385                	beqz	a5,80004c0a <piperead+0x64>
    if(pr->killed){
    80004bec:	030a2783          	lw	a5,48(s4)
    80004bf0:	ebc1                	bnez	a5,80004c80 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004bf2:	85da                	mv	a1,s6
    80004bf4:	854e                	mv	a0,s3
    80004bf6:	ffffd097          	auipc	ra,0xffffd
    80004bfa:	632080e7          	jalr	1586(ra) # 80002228 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004bfe:	2184a703          	lw	a4,536(s1)
    80004c02:	21c4a783          	lw	a5,540(s1)
    80004c06:	fef700e3          	beq	a4,a5,80004be6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c0a:	09505263          	blez	s5,80004c8e <piperead+0xe8>
    80004c0e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c10:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004c12:	2184a783          	lw	a5,536(s1)
    80004c16:	21c4a703          	lw	a4,540(s1)
    80004c1a:	02f70d63          	beq	a4,a5,80004c54 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004c1e:	0017871b          	addiw	a4,a5,1
    80004c22:	20e4ac23          	sw	a4,536(s1)
    80004c26:	1ff7f793          	andi	a5,a5,511
    80004c2a:	97a6                	add	a5,a5,s1
    80004c2c:	0187c783          	lbu	a5,24(a5)
    80004c30:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004c34:	4685                	li	a3,1
    80004c36:	fbf40613          	addi	a2,s0,-65
    80004c3a:	85ca                	mv	a1,s2
    80004c3c:	050a3503          	ld	a0,80(s4)
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	acc080e7          	jalr	-1332(ra) # 8000170c <copyout>
    80004c48:	01650663          	beq	a0,s6,80004c54 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c4c:	2985                	addiw	s3,s3,1
    80004c4e:	0905                	addi	s2,s2,1
    80004c50:	fd3a91e3          	bne	s5,s3,80004c12 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004c54:	21c48513          	addi	a0,s1,540
    80004c58:	ffffd097          	auipc	ra,0xffffd
    80004c5c:	756080e7          	jalr	1878(ra) # 800023ae <wakeup>
  release(&pi->lock);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffc097          	auipc	ra,0xffffc
    80004c66:	062080e7          	jalr	98(ra) # 80000cc4 <release>
  return i;
}
    80004c6a:	854e                	mv	a0,s3
    80004c6c:	60a6                	ld	ra,72(sp)
    80004c6e:	6406                	ld	s0,64(sp)
    80004c70:	74e2                	ld	s1,56(sp)
    80004c72:	7942                	ld	s2,48(sp)
    80004c74:	79a2                	ld	s3,40(sp)
    80004c76:	7a02                	ld	s4,32(sp)
    80004c78:	6ae2                	ld	s5,24(sp)
    80004c7a:	6b42                	ld	s6,16(sp)
    80004c7c:	6161                	addi	sp,sp,80
    80004c7e:	8082                	ret
      release(&pi->lock);
    80004c80:	8526                	mv	a0,s1
    80004c82:	ffffc097          	auipc	ra,0xffffc
    80004c86:	042080e7          	jalr	66(ra) # 80000cc4 <release>
      return -1;
    80004c8a:	59fd                	li	s3,-1
    80004c8c:	bff9                	j	80004c6a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004c8e:	4981                	li	s3,0
    80004c90:	b7d1                	j	80004c54 <piperead+0xae>

0000000080004c92 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c92:	df010113          	addi	sp,sp,-528
    80004c96:	20113423          	sd	ra,520(sp)
    80004c9a:	20813023          	sd	s0,512(sp)
    80004c9e:	ffa6                	sd	s1,504(sp)
    80004ca0:	fbca                	sd	s2,496(sp)
    80004ca2:	f7ce                	sd	s3,488(sp)
    80004ca4:	f3d2                	sd	s4,480(sp)
    80004ca6:	efd6                	sd	s5,472(sp)
    80004ca8:	ebda                	sd	s6,464(sp)
    80004caa:	e7de                	sd	s7,456(sp)
    80004cac:	e3e2                	sd	s8,448(sp)
    80004cae:	ff66                	sd	s9,440(sp)
    80004cb0:	fb6a                	sd	s10,432(sp)
    80004cb2:	f76e                	sd	s11,424(sp)
    80004cb4:	0c00                	addi	s0,sp,528
    80004cb6:	84aa                	mv	s1,a0
    80004cb8:	dea43c23          	sd	a0,-520(s0)
    80004cbc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004cc0:	ffffd097          	auipc	ra,0xffffd
    80004cc4:	d58080e7          	jalr	-680(ra) # 80001a18 <myproc>
    80004cc8:	892a                	mv	s2,a0

  begin_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	446080e7          	jalr	1094(ra) # 80004110 <begin_op>

  if((ip = namei(path)) == 0){
    80004cd2:	8526                	mv	a0,s1
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	230080e7          	jalr	560(ra) # 80003f04 <namei>
    80004cdc:	c92d                	beqz	a0,80004d4e <exec+0xbc>
    80004cde:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004ce0:	fffff097          	auipc	ra,0xfffff
    80004ce4:	a70080e7          	jalr	-1424(ra) # 80003750 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004ce8:	04000713          	li	a4,64
    80004cec:	4681                	li	a3,0
    80004cee:	e4840613          	addi	a2,s0,-440
    80004cf2:	4581                	li	a1,0
    80004cf4:	8526                	mv	a0,s1
    80004cf6:	fffff097          	auipc	ra,0xfffff
    80004cfa:	d0e080e7          	jalr	-754(ra) # 80003a04 <readi>
    80004cfe:	04000793          	li	a5,64
    80004d02:	00f51a63          	bne	a0,a5,80004d16 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004d06:	e4842703          	lw	a4,-440(s0)
    80004d0a:	464c47b7          	lui	a5,0x464c4
    80004d0e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004d12:	04f70463          	beq	a4,a5,80004d5a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004d16:	8526                	mv	a0,s1
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	c9a080e7          	jalr	-870(ra) # 800039b2 <iunlockput>
    end_op();
    80004d20:	fffff097          	auipc	ra,0xfffff
    80004d24:	470080e7          	jalr	1136(ra) # 80004190 <end_op>
  }
  return -1;
    80004d28:	557d                	li	a0,-1
}
    80004d2a:	20813083          	ld	ra,520(sp)
    80004d2e:	20013403          	ld	s0,512(sp)
    80004d32:	74fe                	ld	s1,504(sp)
    80004d34:	795e                	ld	s2,496(sp)
    80004d36:	79be                	ld	s3,488(sp)
    80004d38:	7a1e                	ld	s4,480(sp)
    80004d3a:	6afe                	ld	s5,472(sp)
    80004d3c:	6b5e                	ld	s6,464(sp)
    80004d3e:	6bbe                	ld	s7,456(sp)
    80004d40:	6c1e                	ld	s8,448(sp)
    80004d42:	7cfa                	ld	s9,440(sp)
    80004d44:	7d5a                	ld	s10,432(sp)
    80004d46:	7dba                	ld	s11,424(sp)
    80004d48:	21010113          	addi	sp,sp,528
    80004d4c:	8082                	ret
    end_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	442080e7          	jalr	1090(ra) # 80004190 <end_op>
    return -1;
    80004d56:	557d                	li	a0,-1
    80004d58:	bfc9                	j	80004d2a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004d5a:	854a                	mv	a0,s2
    80004d5c:	ffffd097          	auipc	ra,0xffffd
    80004d60:	d80080e7          	jalr	-640(ra) # 80001adc <proc_pagetable>
    80004d64:	8baa                	mv	s7,a0
    80004d66:	d945                	beqz	a0,80004d16 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d68:	e6842983          	lw	s3,-408(s0)
    80004d6c:	e8045783          	lhu	a5,-384(s0)
    80004d70:	c7ad                	beqz	a5,80004dda <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d72:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004d74:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004d76:	6c85                	lui	s9,0x1
    80004d78:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004d7c:	def43823          	sd	a5,-528(s0)
    80004d80:	a42d                	j	80004faa <exec+0x318>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d82:	00004517          	auipc	a0,0x4
    80004d86:	91650513          	addi	a0,a0,-1770 # 80008698 <syscalls+0x290>
    80004d8a:	ffffb097          	auipc	ra,0xffffb
    80004d8e:	7be080e7          	jalr	1982(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d92:	8756                	mv	a4,s5
    80004d94:	012d86bb          	addw	a3,s11,s2
    80004d98:	4581                	li	a1,0
    80004d9a:	8526                	mv	a0,s1
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	c68080e7          	jalr	-920(ra) # 80003a04 <readi>
    80004da4:	2501                	sext.w	a0,a0
    80004da6:	1aaa9963          	bne	s5,a0,80004f58 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004daa:	6785                	lui	a5,0x1
    80004dac:	0127893b          	addw	s2,a5,s2
    80004db0:	77fd                	lui	a5,0xfffff
    80004db2:	01478a3b          	addw	s4,a5,s4
    80004db6:	1f897163          	bgeu	s2,s8,80004f98 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004dba:	02091593          	slli	a1,s2,0x20
    80004dbe:	9181                	srli	a1,a1,0x20
    80004dc0:	95ea                	add	a1,a1,s10
    80004dc2:	855e                	mv	a0,s7
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	3c6080e7          	jalr	966(ra) # 8000118a <walkaddr>
    80004dcc:	862a                	mv	a2,a0
    if(pa == 0)
    80004dce:	d955                	beqz	a0,80004d82 <exec+0xf0>
      n = PGSIZE;
    80004dd0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004dd2:	fd9a70e3          	bgeu	s4,s9,80004d92 <exec+0x100>
      n = sz - i;
    80004dd6:	8ad2                	mv	s5,s4
    80004dd8:	bf6d                	j	80004d92 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004dda:	4901                	li	s2,0
  iunlockput(ip);
    80004ddc:	8526                	mv	a0,s1
    80004dde:	fffff097          	auipc	ra,0xfffff
    80004de2:	bd4080e7          	jalr	-1068(ra) # 800039b2 <iunlockput>
  end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	3aa080e7          	jalr	938(ra) # 80004190 <end_op>
  p = myproc();
    80004dee:	ffffd097          	auipc	ra,0xffffd
    80004df2:	c2a080e7          	jalr	-982(ra) # 80001a18 <myproc>
    80004df6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004df8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004dfc:	6785                	lui	a5,0x1
    80004dfe:	17fd                	addi	a5,a5,-1
    80004e00:	993e                	add	s2,s2,a5
    80004e02:	757d                	lui	a0,0xfffff
    80004e04:	00a977b3          	and	a5,s2,a0
    80004e08:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e0c:	6609                	lui	a2,0x2
    80004e0e:	963e                	add	a2,a2,a5
    80004e10:	85be                	mv	a1,a5
    80004e12:	855e                	mv	a0,s7
    80004e14:	ffffc097          	auipc	ra,0xffffc
    80004e18:	6c4080e7          	jalr	1732(ra) # 800014d8 <uvmalloc>
    80004e1c:	8b2a                	mv	s6,a0
  ip = 0;
    80004e1e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004e20:	12050c63          	beqz	a0,80004f58 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004e24:	75f9                	lui	a1,0xffffe
    80004e26:	95aa                	add	a1,a1,a0
    80004e28:	855e                	mv	a0,s7
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	8b0080e7          	jalr	-1872(ra) # 800016da <uvmclear>
  stackbase = sp - PGSIZE;
    80004e32:	7c7d                	lui	s8,0xfffff
    80004e34:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004e36:	e0043783          	ld	a5,-512(s0)
    80004e3a:	6388                	ld	a0,0(a5)
    80004e3c:	c535                	beqz	a0,80004ea8 <exec+0x216>
    80004e3e:	e8840993          	addi	s3,s0,-376
    80004e42:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004e46:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004e48:	ffffc097          	auipc	ra,0xffffc
    80004e4c:	04c080e7          	jalr	76(ra) # 80000e94 <strlen>
    80004e50:	2505                	addiw	a0,a0,1
    80004e52:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004e56:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004e5a:	13896363          	bltu	s2,s8,80004f80 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004e5e:	e0043d83          	ld	s11,-512(s0)
    80004e62:	000dba03          	ld	s4,0(s11)
    80004e66:	8552                	mv	a0,s4
    80004e68:	ffffc097          	auipc	ra,0xffffc
    80004e6c:	02c080e7          	jalr	44(ra) # 80000e94 <strlen>
    80004e70:	0015069b          	addiw	a3,a0,1
    80004e74:	8652                	mv	a2,s4
    80004e76:	85ca                	mv	a1,s2
    80004e78:	855e                	mv	a0,s7
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	892080e7          	jalr	-1902(ra) # 8000170c <copyout>
    80004e82:	10054363          	bltz	a0,80004f88 <exec+0x2f6>
    ustack[argc] = sp;
    80004e86:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e8a:	0485                	addi	s1,s1,1
    80004e8c:	008d8793          	addi	a5,s11,8
    80004e90:	e0f43023          	sd	a5,-512(s0)
    80004e94:	008db503          	ld	a0,8(s11)
    80004e98:	c911                	beqz	a0,80004eac <exec+0x21a>
    if(argc >= MAXARG)
    80004e9a:	09a1                	addi	s3,s3,8
    80004e9c:	fb3c96e3          	bne	s9,s3,80004e48 <exec+0x1b6>
  sz = sz1;
    80004ea0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004ea4:	4481                	li	s1,0
    80004ea6:	a84d                	j	80004f58 <exec+0x2c6>
  sp = sz;
    80004ea8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004eaa:	4481                	li	s1,0
  ustack[argc] = 0;
    80004eac:	00349793          	slli	a5,s1,0x3
    80004eb0:	f9040713          	addi	a4,s0,-112
    80004eb4:	97ba                	add	a5,a5,a4
    80004eb6:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004eba:	00148693          	addi	a3,s1,1
    80004ebe:	068e                	slli	a3,a3,0x3
    80004ec0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ec4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004ec8:	01897663          	bgeu	s2,s8,80004ed4 <exec+0x242>
  sz = sz1;
    80004ecc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004ed0:	4481                	li	s1,0
    80004ed2:	a059                	j	80004f58 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ed4:	e8840613          	addi	a2,s0,-376
    80004ed8:	85ca                	mv	a1,s2
    80004eda:	855e                	mv	a0,s7
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	830080e7          	jalr	-2000(ra) # 8000170c <copyout>
    80004ee4:	0a054663          	bltz	a0,80004f90 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004ee8:	058ab783          	ld	a5,88(s5)
    80004eec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ef0:	df843783          	ld	a5,-520(s0)
    80004ef4:	0007c703          	lbu	a4,0(a5)
    80004ef8:	cf11                	beqz	a4,80004f14 <exec+0x282>
    80004efa:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004efc:	02f00693          	li	a3,47
    80004f00:	a029                	j	80004f0a <exec+0x278>
  for(last=s=path; *s; s++)
    80004f02:	0785                	addi	a5,a5,1
    80004f04:	fff7c703          	lbu	a4,-1(a5)
    80004f08:	c711                	beqz	a4,80004f14 <exec+0x282>
    if(*s == '/')
    80004f0a:	fed71ce3          	bne	a4,a3,80004f02 <exec+0x270>
      last = s+1;
    80004f0e:	def43c23          	sd	a5,-520(s0)
    80004f12:	bfc5                	j	80004f02 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004f14:	4641                	li	a2,16
    80004f16:	df843583          	ld	a1,-520(s0)
    80004f1a:	158a8513          	addi	a0,s5,344
    80004f1e:	ffffc097          	auipc	ra,0xffffc
    80004f22:	f44080e7          	jalr	-188(ra) # 80000e62 <safestrcpy>
  oldpagetable = p->pagetable;
    80004f26:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004f2a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004f2e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004f32:	058ab783          	ld	a5,88(s5)
    80004f36:	e6043703          	ld	a4,-416(s0)
    80004f3a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004f3c:	058ab783          	ld	a5,88(s5)
    80004f40:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004f44:	85ea                	mv	a1,s10
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	c32080e7          	jalr	-974(ra) # 80001b78 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004f4e:	0004851b          	sext.w	a0,s1
    80004f52:	bbe1                	j	80004d2a <exec+0x98>
    80004f54:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004f58:	e0843583          	ld	a1,-504(s0)
    80004f5c:	855e                	mv	a0,s7
    80004f5e:	ffffd097          	auipc	ra,0xffffd
    80004f62:	c1a080e7          	jalr	-998(ra) # 80001b78 <proc_freepagetable>
  if(ip){
    80004f66:	da0498e3          	bnez	s1,80004d16 <exec+0x84>
  return -1;
    80004f6a:	557d                	li	a0,-1
    80004f6c:	bb7d                	j	80004d2a <exec+0x98>
    80004f6e:	e1243423          	sd	s2,-504(s0)
    80004f72:	b7dd                	j	80004f58 <exec+0x2c6>
    80004f74:	e1243423          	sd	s2,-504(s0)
    80004f78:	b7c5                	j	80004f58 <exec+0x2c6>
    80004f7a:	e1243423          	sd	s2,-504(s0)
    80004f7e:	bfe9                	j	80004f58 <exec+0x2c6>
  sz = sz1;
    80004f80:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f84:	4481                	li	s1,0
    80004f86:	bfc9                	j	80004f58 <exec+0x2c6>
  sz = sz1;
    80004f88:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f8c:	4481                	li	s1,0
    80004f8e:	b7e9                	j	80004f58 <exec+0x2c6>
  sz = sz1;
    80004f90:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004f94:	4481                	li	s1,0
    80004f96:	b7c9                	j	80004f58 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f98:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f9c:	2b05                	addiw	s6,s6,1
    80004f9e:	0389899b          	addiw	s3,s3,56
    80004fa2:	e8045783          	lhu	a5,-384(s0)
    80004fa6:	e2fb5be3          	bge	s6,a5,80004ddc <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004faa:	2981                	sext.w	s3,s3
    80004fac:	03800713          	li	a4,56
    80004fb0:	86ce                	mv	a3,s3
    80004fb2:	e1040613          	addi	a2,s0,-496
    80004fb6:	4581                	li	a1,0
    80004fb8:	8526                	mv	a0,s1
    80004fba:	fffff097          	auipc	ra,0xfffff
    80004fbe:	a4a080e7          	jalr	-1462(ra) # 80003a04 <readi>
    80004fc2:	03800793          	li	a5,56
    80004fc6:	f8f517e3          	bne	a0,a5,80004f54 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004fca:	e1042783          	lw	a5,-496(s0)
    80004fce:	4705                	li	a4,1
    80004fd0:	fce796e3          	bne	a5,a4,80004f9c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004fd4:	e3843603          	ld	a2,-456(s0)
    80004fd8:	e3043783          	ld	a5,-464(s0)
    80004fdc:	f8f669e3          	bltu	a2,a5,80004f6e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004fe0:	e2043783          	ld	a5,-480(s0)
    80004fe4:	963e                	add	a2,a2,a5
    80004fe6:	f8f667e3          	bltu	a2,a5,80004f74 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004fea:	85ca                	mv	a1,s2
    80004fec:	855e                	mv	a0,s7
    80004fee:	ffffc097          	auipc	ra,0xffffc
    80004ff2:	4ea080e7          	jalr	1258(ra) # 800014d8 <uvmalloc>
    80004ff6:	e0a43423          	sd	a0,-504(s0)
    80004ffa:	d141                	beqz	a0,80004f7a <exec+0x2e8>
    if(ph.vaddr % PGSIZE != 0)
    80004ffc:	e2043d03          	ld	s10,-480(s0)
    80005000:	df043783          	ld	a5,-528(s0)
    80005004:	00fd77b3          	and	a5,s10,a5
    80005008:	fba1                	bnez	a5,80004f58 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000500a:	e1842d83          	lw	s11,-488(s0)
    8000500e:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005012:	f80c03e3          	beqz	s8,80004f98 <exec+0x306>
    80005016:	8a62                	mv	s4,s8
    80005018:	4901                	li	s2,0
    8000501a:	b345                	j	80004dba <exec+0x128>

000000008000501c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000501c:	7179                	addi	sp,sp,-48
    8000501e:	f406                	sd	ra,40(sp)
    80005020:	f022                	sd	s0,32(sp)
    80005022:	ec26                	sd	s1,24(sp)
    80005024:	e84a                	sd	s2,16(sp)
    80005026:	1800                	addi	s0,sp,48
    80005028:	892e                	mv	s2,a1
    8000502a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000502c:	fdc40593          	addi	a1,s0,-36
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	b92080e7          	jalr	-1134(ra) # 80002bc2 <argint>
    80005038:	04054063          	bltz	a0,80005078 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000503c:	fdc42703          	lw	a4,-36(s0)
    80005040:	47bd                	li	a5,15
    80005042:	02e7ed63          	bltu	a5,a4,8000507c <argfd+0x60>
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	9d2080e7          	jalr	-1582(ra) # 80001a18 <myproc>
    8000504e:	fdc42703          	lw	a4,-36(s0)
    80005052:	01a70793          	addi	a5,a4,26
    80005056:	078e                	slli	a5,a5,0x3
    80005058:	953e                	add	a0,a0,a5
    8000505a:	611c                	ld	a5,0(a0)
    8000505c:	c395                	beqz	a5,80005080 <argfd+0x64>
    return -1;
  if(pfd)
    8000505e:	00090463          	beqz	s2,80005066 <argfd+0x4a>
    *pfd = fd;
    80005062:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005066:	4501                	li	a0,0
  if(pf)
    80005068:	c091                	beqz	s1,8000506c <argfd+0x50>
    *pf = f;
    8000506a:	e09c                	sd	a5,0(s1)
}
    8000506c:	70a2                	ld	ra,40(sp)
    8000506e:	7402                	ld	s0,32(sp)
    80005070:	64e2                	ld	s1,24(sp)
    80005072:	6942                	ld	s2,16(sp)
    80005074:	6145                	addi	sp,sp,48
    80005076:	8082                	ret
    return -1;
    80005078:	557d                	li	a0,-1
    8000507a:	bfcd                	j	8000506c <argfd+0x50>
    return -1;
    8000507c:	557d                	li	a0,-1
    8000507e:	b7fd                	j	8000506c <argfd+0x50>
    80005080:	557d                	li	a0,-1
    80005082:	b7ed                	j	8000506c <argfd+0x50>

0000000080005084 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005084:	1101                	addi	sp,sp,-32
    80005086:	ec06                	sd	ra,24(sp)
    80005088:	e822                	sd	s0,16(sp)
    8000508a:	e426                	sd	s1,8(sp)
    8000508c:	1000                	addi	s0,sp,32
    8000508e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005090:	ffffd097          	auipc	ra,0xffffd
    80005094:	988080e7          	jalr	-1656(ra) # 80001a18 <myproc>
    80005098:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000509a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd90d0>
    8000509e:	4501                	li	a0,0
    800050a0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800050a2:	6398                	ld	a4,0(a5)
    800050a4:	cb19                	beqz	a4,800050ba <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800050a6:	2505                	addiw	a0,a0,1
    800050a8:	07a1                	addi	a5,a5,8
    800050aa:	fed51ce3          	bne	a0,a3,800050a2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800050ae:	557d                	li	a0,-1
}
    800050b0:	60e2                	ld	ra,24(sp)
    800050b2:	6442                	ld	s0,16(sp)
    800050b4:	64a2                	ld	s1,8(sp)
    800050b6:	6105                	addi	sp,sp,32
    800050b8:	8082                	ret
      p->ofile[fd] = f;
    800050ba:	01a50793          	addi	a5,a0,26
    800050be:	078e                	slli	a5,a5,0x3
    800050c0:	963e                	add	a2,a2,a5
    800050c2:	e204                	sd	s1,0(a2)
      return fd;
    800050c4:	b7f5                	j	800050b0 <fdalloc+0x2c>

00000000800050c6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800050c6:	715d                	addi	sp,sp,-80
    800050c8:	e486                	sd	ra,72(sp)
    800050ca:	e0a2                	sd	s0,64(sp)
    800050cc:	fc26                	sd	s1,56(sp)
    800050ce:	f84a                	sd	s2,48(sp)
    800050d0:	f44e                	sd	s3,40(sp)
    800050d2:	f052                	sd	s4,32(sp)
    800050d4:	ec56                	sd	s5,24(sp)
    800050d6:	0880                	addi	s0,sp,80
    800050d8:	89ae                	mv	s3,a1
    800050da:	8ab2                	mv	s5,a2
    800050dc:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800050de:	fb040593          	addi	a1,s0,-80
    800050e2:	fffff097          	auipc	ra,0xfffff
    800050e6:	e40080e7          	jalr	-448(ra) # 80003f22 <nameiparent>
    800050ea:	892a                	mv	s2,a0
    800050ec:	12050f63          	beqz	a0,8000522a <create+0x164>
    return 0;

  ilock(dp);
    800050f0:	ffffe097          	auipc	ra,0xffffe
    800050f4:	660080e7          	jalr	1632(ra) # 80003750 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800050f8:	4601                	li	a2,0
    800050fa:	fb040593          	addi	a1,s0,-80
    800050fe:	854a                	mv	a0,s2
    80005100:	fffff097          	auipc	ra,0xfffff
    80005104:	b32080e7          	jalr	-1230(ra) # 80003c32 <dirlookup>
    80005108:	84aa                	mv	s1,a0
    8000510a:	c921                	beqz	a0,8000515a <create+0x94>
    iunlockput(dp);
    8000510c:	854a                	mv	a0,s2
    8000510e:	fffff097          	auipc	ra,0xfffff
    80005112:	8a4080e7          	jalr	-1884(ra) # 800039b2 <iunlockput>
    ilock(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	638080e7          	jalr	1592(ra) # 80003750 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005120:	2981                	sext.w	s3,s3
    80005122:	4789                	li	a5,2
    80005124:	02f99463          	bne	s3,a5,8000514c <create+0x86>
    80005128:	0444d783          	lhu	a5,68(s1)
    8000512c:	37f9                	addiw	a5,a5,-2
    8000512e:	17c2                	slli	a5,a5,0x30
    80005130:	93c1                	srli	a5,a5,0x30
    80005132:	4705                	li	a4,1
    80005134:	00f76c63          	bltu	a4,a5,8000514c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005138:	8526                	mv	a0,s1
    8000513a:	60a6                	ld	ra,72(sp)
    8000513c:	6406                	ld	s0,64(sp)
    8000513e:	74e2                	ld	s1,56(sp)
    80005140:	7942                	ld	s2,48(sp)
    80005142:	79a2                	ld	s3,40(sp)
    80005144:	7a02                	ld	s4,32(sp)
    80005146:	6ae2                	ld	s5,24(sp)
    80005148:	6161                	addi	sp,sp,80
    8000514a:	8082                	ret
    iunlockput(ip);
    8000514c:	8526                	mv	a0,s1
    8000514e:	fffff097          	auipc	ra,0xfffff
    80005152:	864080e7          	jalr	-1948(ra) # 800039b2 <iunlockput>
    return 0;
    80005156:	4481                	li	s1,0
    80005158:	b7c5                	j	80005138 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000515a:	85ce                	mv	a1,s3
    8000515c:	00092503          	lw	a0,0(s2)
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	458080e7          	jalr	1112(ra) # 800035b8 <ialloc>
    80005168:	84aa                	mv	s1,a0
    8000516a:	c529                	beqz	a0,800051b4 <create+0xee>
  ilock(ip);
    8000516c:	ffffe097          	auipc	ra,0xffffe
    80005170:	5e4080e7          	jalr	1508(ra) # 80003750 <ilock>
  ip->major = major;
    80005174:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005178:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000517c:	4785                	li	a5,1
    8000517e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005182:	8526                	mv	a0,s1
    80005184:	ffffe097          	auipc	ra,0xffffe
    80005188:	502080e7          	jalr	1282(ra) # 80003686 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000518c:	2981                	sext.w	s3,s3
    8000518e:	4785                	li	a5,1
    80005190:	02f98a63          	beq	s3,a5,800051c4 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005194:	40d0                	lw	a2,4(s1)
    80005196:	fb040593          	addi	a1,s0,-80
    8000519a:	854a                	mv	a0,s2
    8000519c:	fffff097          	auipc	ra,0xfffff
    800051a0:	ca6080e7          	jalr	-858(ra) # 80003e42 <dirlink>
    800051a4:	06054b63          	bltz	a0,8000521a <create+0x154>
  iunlockput(dp);
    800051a8:	854a                	mv	a0,s2
    800051aa:	fffff097          	auipc	ra,0xfffff
    800051ae:	808080e7          	jalr	-2040(ra) # 800039b2 <iunlockput>
  return ip;
    800051b2:	b759                	j	80005138 <create+0x72>
    panic("create: ialloc");
    800051b4:	00003517          	auipc	a0,0x3
    800051b8:	50450513          	addi	a0,a0,1284 # 800086b8 <syscalls+0x2b0>
    800051bc:	ffffb097          	auipc	ra,0xffffb
    800051c0:	38c080e7          	jalr	908(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    800051c4:	04a95783          	lhu	a5,74(s2)
    800051c8:	2785                	addiw	a5,a5,1
    800051ca:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800051ce:	854a                	mv	a0,s2
    800051d0:	ffffe097          	auipc	ra,0xffffe
    800051d4:	4b6080e7          	jalr	1206(ra) # 80003686 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800051d8:	40d0                	lw	a2,4(s1)
    800051da:	00003597          	auipc	a1,0x3
    800051de:	4ee58593          	addi	a1,a1,1262 # 800086c8 <syscalls+0x2c0>
    800051e2:	8526                	mv	a0,s1
    800051e4:	fffff097          	auipc	ra,0xfffff
    800051e8:	c5e080e7          	jalr	-930(ra) # 80003e42 <dirlink>
    800051ec:	00054f63          	bltz	a0,8000520a <create+0x144>
    800051f0:	00492603          	lw	a2,4(s2)
    800051f4:	00003597          	auipc	a1,0x3
    800051f8:	4dc58593          	addi	a1,a1,1244 # 800086d0 <syscalls+0x2c8>
    800051fc:	8526                	mv	a0,s1
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	c44080e7          	jalr	-956(ra) # 80003e42 <dirlink>
    80005206:	f80557e3          	bgez	a0,80005194 <create+0xce>
      panic("create dots");
    8000520a:	00003517          	auipc	a0,0x3
    8000520e:	4ce50513          	addi	a0,a0,1230 # 800086d8 <syscalls+0x2d0>
    80005212:	ffffb097          	auipc	ra,0xffffb
    80005216:	336080e7          	jalr	822(ra) # 80000548 <panic>
    panic("create: dirlink");
    8000521a:	00003517          	auipc	a0,0x3
    8000521e:	4ce50513          	addi	a0,a0,1230 # 800086e8 <syscalls+0x2e0>
    80005222:	ffffb097          	auipc	ra,0xffffb
    80005226:	326080e7          	jalr	806(ra) # 80000548 <panic>
    return 0;
    8000522a:	84aa                	mv	s1,a0
    8000522c:	b731                	j	80005138 <create+0x72>

000000008000522e <sys_dup>:
{
    8000522e:	7179                	addi	sp,sp,-48
    80005230:	f406                	sd	ra,40(sp)
    80005232:	f022                	sd	s0,32(sp)
    80005234:	ec26                	sd	s1,24(sp)
    80005236:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005238:	fd840613          	addi	a2,s0,-40
    8000523c:	4581                	li	a1,0
    8000523e:	4501                	li	a0,0
    80005240:	00000097          	auipc	ra,0x0
    80005244:	ddc080e7          	jalr	-548(ra) # 8000501c <argfd>
    return -1;
    80005248:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000524a:	02054363          	bltz	a0,80005270 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000524e:	fd843503          	ld	a0,-40(s0)
    80005252:	00000097          	auipc	ra,0x0
    80005256:	e32080e7          	jalr	-462(ra) # 80005084 <fdalloc>
    8000525a:	84aa                	mv	s1,a0
    return -1;
    8000525c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000525e:	00054963          	bltz	a0,80005270 <sys_dup+0x42>
  filedup(f);
    80005262:	fd843503          	ld	a0,-40(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	32a080e7          	jalr	810(ra) # 80004590 <filedup>
  return fd;
    8000526e:	87a6                	mv	a5,s1
}
    80005270:	853e                	mv	a0,a5
    80005272:	70a2                	ld	ra,40(sp)
    80005274:	7402                	ld	s0,32(sp)
    80005276:	64e2                	ld	s1,24(sp)
    80005278:	6145                	addi	sp,sp,48
    8000527a:	8082                	ret

000000008000527c <sys_read>:
{
    8000527c:	7179                	addi	sp,sp,-48
    8000527e:	f406                	sd	ra,40(sp)
    80005280:	f022                	sd	s0,32(sp)
    80005282:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005284:	fe840613          	addi	a2,s0,-24
    80005288:	4581                	li	a1,0
    8000528a:	4501                	li	a0,0
    8000528c:	00000097          	auipc	ra,0x0
    80005290:	d90080e7          	jalr	-624(ra) # 8000501c <argfd>
    return -1;
    80005294:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005296:	04054163          	bltz	a0,800052d8 <sys_read+0x5c>
    8000529a:	fe440593          	addi	a1,s0,-28
    8000529e:	4509                	li	a0,2
    800052a0:	ffffe097          	auipc	ra,0xffffe
    800052a4:	922080e7          	jalr	-1758(ra) # 80002bc2 <argint>
    return -1;
    800052a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052aa:	02054763          	bltz	a0,800052d8 <sys_read+0x5c>
    800052ae:	fd840593          	addi	a1,s0,-40
    800052b2:	4505                	li	a0,1
    800052b4:	ffffe097          	auipc	ra,0xffffe
    800052b8:	930080e7          	jalr	-1744(ra) # 80002be4 <argaddr>
    return -1;
    800052bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052be:	00054d63          	bltz	a0,800052d8 <sys_read+0x5c>
  return fileread(f, p, n);
    800052c2:	fe442603          	lw	a2,-28(s0)
    800052c6:	fd843583          	ld	a1,-40(s0)
    800052ca:	fe843503          	ld	a0,-24(s0)
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	44e080e7          	jalr	1102(ra) # 8000471c <fileread>
    800052d6:	87aa                	mv	a5,a0
}
    800052d8:	853e                	mv	a0,a5
    800052da:	70a2                	ld	ra,40(sp)
    800052dc:	7402                	ld	s0,32(sp)
    800052de:	6145                	addi	sp,sp,48
    800052e0:	8082                	ret

00000000800052e2 <sys_write>:
{
    800052e2:	7179                	addi	sp,sp,-48
    800052e4:	f406                	sd	ra,40(sp)
    800052e6:	f022                	sd	s0,32(sp)
    800052e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052ea:	fe840613          	addi	a2,s0,-24
    800052ee:	4581                	li	a1,0
    800052f0:	4501                	li	a0,0
    800052f2:	00000097          	auipc	ra,0x0
    800052f6:	d2a080e7          	jalr	-726(ra) # 8000501c <argfd>
    return -1;
    800052fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052fc:	04054163          	bltz	a0,8000533e <sys_write+0x5c>
    80005300:	fe440593          	addi	a1,s0,-28
    80005304:	4509                	li	a0,2
    80005306:	ffffe097          	auipc	ra,0xffffe
    8000530a:	8bc080e7          	jalr	-1860(ra) # 80002bc2 <argint>
    return -1;
    8000530e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005310:	02054763          	bltz	a0,8000533e <sys_write+0x5c>
    80005314:	fd840593          	addi	a1,s0,-40
    80005318:	4505                	li	a0,1
    8000531a:	ffffe097          	auipc	ra,0xffffe
    8000531e:	8ca080e7          	jalr	-1846(ra) # 80002be4 <argaddr>
    return -1;
    80005322:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005324:	00054d63          	bltz	a0,8000533e <sys_write+0x5c>
  return filewrite(f, p, n);
    80005328:	fe442603          	lw	a2,-28(s0)
    8000532c:	fd843583          	ld	a1,-40(s0)
    80005330:	fe843503          	ld	a0,-24(s0)
    80005334:	fffff097          	auipc	ra,0xfffff
    80005338:	4aa080e7          	jalr	1194(ra) # 800047de <filewrite>
    8000533c:	87aa                	mv	a5,a0
}
    8000533e:	853e                	mv	a0,a5
    80005340:	70a2                	ld	ra,40(sp)
    80005342:	7402                	ld	s0,32(sp)
    80005344:	6145                	addi	sp,sp,48
    80005346:	8082                	ret

0000000080005348 <sys_close>:
{
    80005348:	1101                	addi	sp,sp,-32
    8000534a:	ec06                	sd	ra,24(sp)
    8000534c:	e822                	sd	s0,16(sp)
    8000534e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005350:	fe040613          	addi	a2,s0,-32
    80005354:	fec40593          	addi	a1,s0,-20
    80005358:	4501                	li	a0,0
    8000535a:	00000097          	auipc	ra,0x0
    8000535e:	cc2080e7          	jalr	-830(ra) # 8000501c <argfd>
    return -1;
    80005362:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005364:	02054463          	bltz	a0,8000538c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	6b0080e7          	jalr	1712(ra) # 80001a18 <myproc>
    80005370:	fec42783          	lw	a5,-20(s0)
    80005374:	07e9                	addi	a5,a5,26
    80005376:	078e                	slli	a5,a5,0x3
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000537e:	fe043503          	ld	a0,-32(s0)
    80005382:	fffff097          	auipc	ra,0xfffff
    80005386:	260080e7          	jalr	608(ra) # 800045e2 <fileclose>
  return 0;
    8000538a:	4781                	li	a5,0
}
    8000538c:	853e                	mv	a0,a5
    8000538e:	60e2                	ld	ra,24(sp)
    80005390:	6442                	ld	s0,16(sp)
    80005392:	6105                	addi	sp,sp,32
    80005394:	8082                	ret

0000000080005396 <sys_fstat>:
{
    80005396:	1101                	addi	sp,sp,-32
    80005398:	ec06                	sd	ra,24(sp)
    8000539a:	e822                	sd	s0,16(sp)
    8000539c:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000539e:	fe840613          	addi	a2,s0,-24
    800053a2:	4581                	li	a1,0
    800053a4:	4501                	li	a0,0
    800053a6:	00000097          	auipc	ra,0x0
    800053aa:	c76080e7          	jalr	-906(ra) # 8000501c <argfd>
    return -1;
    800053ae:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053b0:	02054563          	bltz	a0,800053da <sys_fstat+0x44>
    800053b4:	fe040593          	addi	a1,s0,-32
    800053b8:	4505                	li	a0,1
    800053ba:	ffffe097          	auipc	ra,0xffffe
    800053be:	82a080e7          	jalr	-2006(ra) # 80002be4 <argaddr>
    return -1;
    800053c2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800053c4:	00054b63          	bltz	a0,800053da <sys_fstat+0x44>
  return filestat(f, st);
    800053c8:	fe043583          	ld	a1,-32(s0)
    800053cc:	fe843503          	ld	a0,-24(s0)
    800053d0:	fffff097          	auipc	ra,0xfffff
    800053d4:	2da080e7          	jalr	730(ra) # 800046aa <filestat>
    800053d8:	87aa                	mv	a5,a0
}
    800053da:	853e                	mv	a0,a5
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	6105                	addi	sp,sp,32
    800053e2:	8082                	ret

00000000800053e4 <sys_link>:
{
    800053e4:	7169                	addi	sp,sp,-304
    800053e6:	f606                	sd	ra,296(sp)
    800053e8:	f222                	sd	s0,288(sp)
    800053ea:	ee26                	sd	s1,280(sp)
    800053ec:	ea4a                	sd	s2,272(sp)
    800053ee:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053f0:	08000613          	li	a2,128
    800053f4:	ed040593          	addi	a1,s0,-304
    800053f8:	4501                	li	a0,0
    800053fa:	ffffe097          	auipc	ra,0xffffe
    800053fe:	80c080e7          	jalr	-2036(ra) # 80002c06 <argstr>
    return -1;
    80005402:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005404:	10054e63          	bltz	a0,80005520 <sys_link+0x13c>
    80005408:	08000613          	li	a2,128
    8000540c:	f5040593          	addi	a1,s0,-176
    80005410:	4505                	li	a0,1
    80005412:	ffffd097          	auipc	ra,0xffffd
    80005416:	7f4080e7          	jalr	2036(ra) # 80002c06 <argstr>
    return -1;
    8000541a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000541c:	10054263          	bltz	a0,80005520 <sys_link+0x13c>
  begin_op();
    80005420:	fffff097          	auipc	ra,0xfffff
    80005424:	cf0080e7          	jalr	-784(ra) # 80004110 <begin_op>
  if((ip = namei(old)) == 0){
    80005428:	ed040513          	addi	a0,s0,-304
    8000542c:	fffff097          	auipc	ra,0xfffff
    80005430:	ad8080e7          	jalr	-1320(ra) # 80003f04 <namei>
    80005434:	84aa                	mv	s1,a0
    80005436:	c551                	beqz	a0,800054c2 <sys_link+0xde>
  ilock(ip);
    80005438:	ffffe097          	auipc	ra,0xffffe
    8000543c:	318080e7          	jalr	792(ra) # 80003750 <ilock>
  if(ip->type == T_DIR){
    80005440:	04449703          	lh	a4,68(s1)
    80005444:	4785                	li	a5,1
    80005446:	08f70463          	beq	a4,a5,800054ce <sys_link+0xea>
  ip->nlink++;
    8000544a:	04a4d783          	lhu	a5,74(s1)
    8000544e:	2785                	addiw	a5,a5,1
    80005450:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005454:	8526                	mv	a0,s1
    80005456:	ffffe097          	auipc	ra,0xffffe
    8000545a:	230080e7          	jalr	560(ra) # 80003686 <iupdate>
  iunlock(ip);
    8000545e:	8526                	mv	a0,s1
    80005460:	ffffe097          	auipc	ra,0xffffe
    80005464:	3b2080e7          	jalr	946(ra) # 80003812 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005468:	fd040593          	addi	a1,s0,-48
    8000546c:	f5040513          	addi	a0,s0,-176
    80005470:	fffff097          	auipc	ra,0xfffff
    80005474:	ab2080e7          	jalr	-1358(ra) # 80003f22 <nameiparent>
    80005478:	892a                	mv	s2,a0
    8000547a:	c935                	beqz	a0,800054ee <sys_link+0x10a>
  ilock(dp);
    8000547c:	ffffe097          	auipc	ra,0xffffe
    80005480:	2d4080e7          	jalr	724(ra) # 80003750 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005484:	00092703          	lw	a4,0(s2)
    80005488:	409c                	lw	a5,0(s1)
    8000548a:	04f71d63          	bne	a4,a5,800054e4 <sys_link+0x100>
    8000548e:	40d0                	lw	a2,4(s1)
    80005490:	fd040593          	addi	a1,s0,-48
    80005494:	854a                	mv	a0,s2
    80005496:	fffff097          	auipc	ra,0xfffff
    8000549a:	9ac080e7          	jalr	-1620(ra) # 80003e42 <dirlink>
    8000549e:	04054363          	bltz	a0,800054e4 <sys_link+0x100>
  iunlockput(dp);
    800054a2:	854a                	mv	a0,s2
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	50e080e7          	jalr	1294(ra) # 800039b2 <iunlockput>
  iput(ip);
    800054ac:	8526                	mv	a0,s1
    800054ae:	ffffe097          	auipc	ra,0xffffe
    800054b2:	45c080e7          	jalr	1116(ra) # 8000390a <iput>
  end_op();
    800054b6:	fffff097          	auipc	ra,0xfffff
    800054ba:	cda080e7          	jalr	-806(ra) # 80004190 <end_op>
  return 0;
    800054be:	4781                	li	a5,0
    800054c0:	a085                	j	80005520 <sys_link+0x13c>
    end_op();
    800054c2:	fffff097          	auipc	ra,0xfffff
    800054c6:	cce080e7          	jalr	-818(ra) # 80004190 <end_op>
    return -1;
    800054ca:	57fd                	li	a5,-1
    800054cc:	a891                	j	80005520 <sys_link+0x13c>
    iunlockput(ip);
    800054ce:	8526                	mv	a0,s1
    800054d0:	ffffe097          	auipc	ra,0xffffe
    800054d4:	4e2080e7          	jalr	1250(ra) # 800039b2 <iunlockput>
    end_op();
    800054d8:	fffff097          	auipc	ra,0xfffff
    800054dc:	cb8080e7          	jalr	-840(ra) # 80004190 <end_op>
    return -1;
    800054e0:	57fd                	li	a5,-1
    800054e2:	a83d                	j	80005520 <sys_link+0x13c>
    iunlockput(dp);
    800054e4:	854a                	mv	a0,s2
    800054e6:	ffffe097          	auipc	ra,0xffffe
    800054ea:	4cc080e7          	jalr	1228(ra) # 800039b2 <iunlockput>
  ilock(ip);
    800054ee:	8526                	mv	a0,s1
    800054f0:	ffffe097          	auipc	ra,0xffffe
    800054f4:	260080e7          	jalr	608(ra) # 80003750 <ilock>
  ip->nlink--;
    800054f8:	04a4d783          	lhu	a5,74(s1)
    800054fc:	37fd                	addiw	a5,a5,-1
    800054fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005502:	8526                	mv	a0,s1
    80005504:	ffffe097          	auipc	ra,0xffffe
    80005508:	182080e7          	jalr	386(ra) # 80003686 <iupdate>
  iunlockput(ip);
    8000550c:	8526                	mv	a0,s1
    8000550e:	ffffe097          	auipc	ra,0xffffe
    80005512:	4a4080e7          	jalr	1188(ra) # 800039b2 <iunlockput>
  end_op();
    80005516:	fffff097          	auipc	ra,0xfffff
    8000551a:	c7a080e7          	jalr	-902(ra) # 80004190 <end_op>
  return -1;
    8000551e:	57fd                	li	a5,-1
}
    80005520:	853e                	mv	a0,a5
    80005522:	70b2                	ld	ra,296(sp)
    80005524:	7412                	ld	s0,288(sp)
    80005526:	64f2                	ld	s1,280(sp)
    80005528:	6952                	ld	s2,272(sp)
    8000552a:	6155                	addi	sp,sp,304
    8000552c:	8082                	ret

000000008000552e <sys_unlink>:
{
    8000552e:	7151                	addi	sp,sp,-240
    80005530:	f586                	sd	ra,232(sp)
    80005532:	f1a2                	sd	s0,224(sp)
    80005534:	eda6                	sd	s1,216(sp)
    80005536:	e9ca                	sd	s2,208(sp)
    80005538:	e5ce                	sd	s3,200(sp)
    8000553a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000553c:	08000613          	li	a2,128
    80005540:	f3040593          	addi	a1,s0,-208
    80005544:	4501                	li	a0,0
    80005546:	ffffd097          	auipc	ra,0xffffd
    8000554a:	6c0080e7          	jalr	1728(ra) # 80002c06 <argstr>
    8000554e:	18054163          	bltz	a0,800056d0 <sys_unlink+0x1a2>
  begin_op();
    80005552:	fffff097          	auipc	ra,0xfffff
    80005556:	bbe080e7          	jalr	-1090(ra) # 80004110 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000555a:	fb040593          	addi	a1,s0,-80
    8000555e:	f3040513          	addi	a0,s0,-208
    80005562:	fffff097          	auipc	ra,0xfffff
    80005566:	9c0080e7          	jalr	-1600(ra) # 80003f22 <nameiparent>
    8000556a:	84aa                	mv	s1,a0
    8000556c:	c979                	beqz	a0,80005642 <sys_unlink+0x114>
  ilock(dp);
    8000556e:	ffffe097          	auipc	ra,0xffffe
    80005572:	1e2080e7          	jalr	482(ra) # 80003750 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005576:	00003597          	auipc	a1,0x3
    8000557a:	15258593          	addi	a1,a1,338 # 800086c8 <syscalls+0x2c0>
    8000557e:	fb040513          	addi	a0,s0,-80
    80005582:	ffffe097          	auipc	ra,0xffffe
    80005586:	696080e7          	jalr	1686(ra) # 80003c18 <namecmp>
    8000558a:	14050a63          	beqz	a0,800056de <sys_unlink+0x1b0>
    8000558e:	00003597          	auipc	a1,0x3
    80005592:	14258593          	addi	a1,a1,322 # 800086d0 <syscalls+0x2c8>
    80005596:	fb040513          	addi	a0,s0,-80
    8000559a:	ffffe097          	auipc	ra,0xffffe
    8000559e:	67e080e7          	jalr	1662(ra) # 80003c18 <namecmp>
    800055a2:	12050e63          	beqz	a0,800056de <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800055a6:	f2c40613          	addi	a2,s0,-212
    800055aa:	fb040593          	addi	a1,s0,-80
    800055ae:	8526                	mv	a0,s1
    800055b0:	ffffe097          	auipc	ra,0xffffe
    800055b4:	682080e7          	jalr	1666(ra) # 80003c32 <dirlookup>
    800055b8:	892a                	mv	s2,a0
    800055ba:	12050263          	beqz	a0,800056de <sys_unlink+0x1b0>
  ilock(ip);
    800055be:	ffffe097          	auipc	ra,0xffffe
    800055c2:	192080e7          	jalr	402(ra) # 80003750 <ilock>
  if(ip->nlink < 1)
    800055c6:	04a91783          	lh	a5,74(s2)
    800055ca:	08f05263          	blez	a5,8000564e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800055ce:	04491703          	lh	a4,68(s2)
    800055d2:	4785                	li	a5,1
    800055d4:	08f70563          	beq	a4,a5,8000565e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800055d8:	4641                	li	a2,16
    800055da:	4581                	li	a1,0
    800055dc:	fc040513          	addi	a0,s0,-64
    800055e0:	ffffb097          	auipc	ra,0xffffb
    800055e4:	72c080e7          	jalr	1836(ra) # 80000d0c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800055e8:	4741                	li	a4,16
    800055ea:	f2c42683          	lw	a3,-212(s0)
    800055ee:	fc040613          	addi	a2,s0,-64
    800055f2:	4581                	li	a1,0
    800055f4:	8526                	mv	a0,s1
    800055f6:	ffffe097          	auipc	ra,0xffffe
    800055fa:	506080e7          	jalr	1286(ra) # 80003afc <writei>
    800055fe:	47c1                	li	a5,16
    80005600:	0af51563          	bne	a0,a5,800056aa <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80005604:	04491703          	lh	a4,68(s2)
    80005608:	4785                	li	a5,1
    8000560a:	0af70863          	beq	a4,a5,800056ba <sys_unlink+0x18c>
  iunlockput(dp);
    8000560e:	8526                	mv	a0,s1
    80005610:	ffffe097          	auipc	ra,0xffffe
    80005614:	3a2080e7          	jalr	930(ra) # 800039b2 <iunlockput>
  ip->nlink--;
    80005618:	04a95783          	lhu	a5,74(s2)
    8000561c:	37fd                	addiw	a5,a5,-1
    8000561e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005622:	854a                	mv	a0,s2
    80005624:	ffffe097          	auipc	ra,0xffffe
    80005628:	062080e7          	jalr	98(ra) # 80003686 <iupdate>
  iunlockput(ip);
    8000562c:	854a                	mv	a0,s2
    8000562e:	ffffe097          	auipc	ra,0xffffe
    80005632:	384080e7          	jalr	900(ra) # 800039b2 <iunlockput>
  end_op();
    80005636:	fffff097          	auipc	ra,0xfffff
    8000563a:	b5a080e7          	jalr	-1190(ra) # 80004190 <end_op>
  return 0;
    8000563e:	4501                	li	a0,0
    80005640:	a84d                	j	800056f2 <sys_unlink+0x1c4>
    end_op();
    80005642:	fffff097          	auipc	ra,0xfffff
    80005646:	b4e080e7          	jalr	-1202(ra) # 80004190 <end_op>
    return -1;
    8000564a:	557d                	li	a0,-1
    8000564c:	a05d                	j	800056f2 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    8000564e:	00003517          	auipc	a0,0x3
    80005652:	0aa50513          	addi	a0,a0,170 # 800086f8 <syscalls+0x2f0>
    80005656:	ffffb097          	auipc	ra,0xffffb
    8000565a:	ef2080e7          	jalr	-270(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000565e:	04c92703          	lw	a4,76(s2)
    80005662:	02000793          	li	a5,32
    80005666:	f6e7f9e3          	bgeu	a5,a4,800055d8 <sys_unlink+0xaa>
    8000566a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000566e:	4741                	li	a4,16
    80005670:	86ce                	mv	a3,s3
    80005672:	f1840613          	addi	a2,s0,-232
    80005676:	4581                	li	a1,0
    80005678:	854a                	mv	a0,s2
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	38a080e7          	jalr	906(ra) # 80003a04 <readi>
    80005682:	47c1                	li	a5,16
    80005684:	00f51b63          	bne	a0,a5,8000569a <sys_unlink+0x16c>
    if(de.inum != 0)
    80005688:	f1845783          	lhu	a5,-232(s0)
    8000568c:	e7a1                	bnez	a5,800056d4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000568e:	29c1                	addiw	s3,s3,16
    80005690:	04c92783          	lw	a5,76(s2)
    80005694:	fcf9ede3          	bltu	s3,a5,8000566e <sys_unlink+0x140>
    80005698:	b781                	j	800055d8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    8000569a:	00003517          	auipc	a0,0x3
    8000569e:	07650513          	addi	a0,a0,118 # 80008710 <syscalls+0x308>
    800056a2:	ffffb097          	auipc	ra,0xffffb
    800056a6:	ea6080e7          	jalr	-346(ra) # 80000548 <panic>
    panic("unlink: writei");
    800056aa:	00003517          	auipc	a0,0x3
    800056ae:	07e50513          	addi	a0,a0,126 # 80008728 <syscalls+0x320>
    800056b2:	ffffb097          	auipc	ra,0xffffb
    800056b6:	e96080e7          	jalr	-362(ra) # 80000548 <panic>
    dp->nlink--;
    800056ba:	04a4d783          	lhu	a5,74(s1)
    800056be:	37fd                	addiw	a5,a5,-1
    800056c0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800056c4:	8526                	mv	a0,s1
    800056c6:	ffffe097          	auipc	ra,0xffffe
    800056ca:	fc0080e7          	jalr	-64(ra) # 80003686 <iupdate>
    800056ce:	b781                	j	8000560e <sys_unlink+0xe0>
    return -1;
    800056d0:	557d                	li	a0,-1
    800056d2:	a005                	j	800056f2 <sys_unlink+0x1c4>
    iunlockput(ip);
    800056d4:	854a                	mv	a0,s2
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	2dc080e7          	jalr	732(ra) # 800039b2 <iunlockput>
  iunlockput(dp);
    800056de:	8526                	mv	a0,s1
    800056e0:	ffffe097          	auipc	ra,0xffffe
    800056e4:	2d2080e7          	jalr	722(ra) # 800039b2 <iunlockput>
  end_op();
    800056e8:	fffff097          	auipc	ra,0xfffff
    800056ec:	aa8080e7          	jalr	-1368(ra) # 80004190 <end_op>
  return -1;
    800056f0:	557d                	li	a0,-1
}
    800056f2:	70ae                	ld	ra,232(sp)
    800056f4:	740e                	ld	s0,224(sp)
    800056f6:	64ee                	ld	s1,216(sp)
    800056f8:	694e                	ld	s2,208(sp)
    800056fa:	69ae                	ld	s3,200(sp)
    800056fc:	616d                	addi	sp,sp,240
    800056fe:	8082                	ret

0000000080005700 <sys_open>:

uint64
sys_open(void)
{
    80005700:	7131                	addi	sp,sp,-192
    80005702:	fd06                	sd	ra,184(sp)
    80005704:	f922                	sd	s0,176(sp)
    80005706:	f526                	sd	s1,168(sp)
    80005708:	f14a                	sd	s2,160(sp)
    8000570a:	ed4e                	sd	s3,152(sp)
    8000570c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000570e:	08000613          	li	a2,128
    80005712:	f5040593          	addi	a1,s0,-176
    80005716:	4501                	li	a0,0
    80005718:	ffffd097          	auipc	ra,0xffffd
    8000571c:	4ee080e7          	jalr	1262(ra) # 80002c06 <argstr>
    return -1;
    80005720:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005722:	0c054163          	bltz	a0,800057e4 <sys_open+0xe4>
    80005726:	f4c40593          	addi	a1,s0,-180
    8000572a:	4505                	li	a0,1
    8000572c:	ffffd097          	auipc	ra,0xffffd
    80005730:	496080e7          	jalr	1174(ra) # 80002bc2 <argint>
    80005734:	0a054863          	bltz	a0,800057e4 <sys_open+0xe4>

  begin_op();
    80005738:	fffff097          	auipc	ra,0xfffff
    8000573c:	9d8080e7          	jalr	-1576(ra) # 80004110 <begin_op>

  if(omode & O_CREATE){
    80005740:	f4c42783          	lw	a5,-180(s0)
    80005744:	2007f793          	andi	a5,a5,512
    80005748:	cbdd                	beqz	a5,800057fe <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    8000574a:	4681                	li	a3,0
    8000574c:	4601                	li	a2,0
    8000574e:	4589                	li	a1,2
    80005750:	f5040513          	addi	a0,s0,-176
    80005754:	00000097          	auipc	ra,0x0
    80005758:	972080e7          	jalr	-1678(ra) # 800050c6 <create>
    8000575c:	892a                	mv	s2,a0
    if(ip == 0){
    8000575e:	c959                	beqz	a0,800057f4 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005760:	04491703          	lh	a4,68(s2)
    80005764:	478d                	li	a5,3
    80005766:	00f71763          	bne	a4,a5,80005774 <sys_open+0x74>
    8000576a:	04695703          	lhu	a4,70(s2)
    8000576e:	47a5                	li	a5,9
    80005770:	0ce7ec63          	bltu	a5,a4,80005848 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005774:	fffff097          	auipc	ra,0xfffff
    80005778:	db2080e7          	jalr	-590(ra) # 80004526 <filealloc>
    8000577c:	89aa                	mv	s3,a0
    8000577e:	10050263          	beqz	a0,80005882 <sys_open+0x182>
    80005782:	00000097          	auipc	ra,0x0
    80005786:	902080e7          	jalr	-1790(ra) # 80005084 <fdalloc>
    8000578a:	84aa                	mv	s1,a0
    8000578c:	0e054663          	bltz	a0,80005878 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005790:	04491703          	lh	a4,68(s2)
    80005794:	478d                	li	a5,3
    80005796:	0cf70463          	beq	a4,a5,8000585e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000579a:	4789                	li	a5,2
    8000579c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    800057a0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    800057a4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    800057a8:	f4c42783          	lw	a5,-180(s0)
    800057ac:	0017c713          	xori	a4,a5,1
    800057b0:	8b05                	andi	a4,a4,1
    800057b2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800057b6:	0037f713          	andi	a4,a5,3
    800057ba:	00e03733          	snez	a4,a4
    800057be:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800057c2:	4007f793          	andi	a5,a5,1024
    800057c6:	c791                	beqz	a5,800057d2 <sys_open+0xd2>
    800057c8:	04491703          	lh	a4,68(s2)
    800057cc:	4789                	li	a5,2
    800057ce:	08f70f63          	beq	a4,a5,8000586c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    800057d2:	854a                	mv	a0,s2
    800057d4:	ffffe097          	auipc	ra,0xffffe
    800057d8:	03e080e7          	jalr	62(ra) # 80003812 <iunlock>
  end_op();
    800057dc:	fffff097          	auipc	ra,0xfffff
    800057e0:	9b4080e7          	jalr	-1612(ra) # 80004190 <end_op>

  return fd;
}
    800057e4:	8526                	mv	a0,s1
    800057e6:	70ea                	ld	ra,184(sp)
    800057e8:	744a                	ld	s0,176(sp)
    800057ea:	74aa                	ld	s1,168(sp)
    800057ec:	790a                	ld	s2,160(sp)
    800057ee:	69ea                	ld	s3,152(sp)
    800057f0:	6129                	addi	sp,sp,192
    800057f2:	8082                	ret
      end_op();
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	99c080e7          	jalr	-1636(ra) # 80004190 <end_op>
      return -1;
    800057fc:	b7e5                	j	800057e4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800057fe:	f5040513          	addi	a0,s0,-176
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	702080e7          	jalr	1794(ra) # 80003f04 <namei>
    8000580a:	892a                	mv	s2,a0
    8000580c:	c905                	beqz	a0,8000583c <sys_open+0x13c>
    ilock(ip);
    8000580e:	ffffe097          	auipc	ra,0xffffe
    80005812:	f42080e7          	jalr	-190(ra) # 80003750 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005816:	04491703          	lh	a4,68(s2)
    8000581a:	4785                	li	a5,1
    8000581c:	f4f712e3          	bne	a4,a5,80005760 <sys_open+0x60>
    80005820:	f4c42783          	lw	a5,-180(s0)
    80005824:	dba1                	beqz	a5,80005774 <sys_open+0x74>
      iunlockput(ip);
    80005826:	854a                	mv	a0,s2
    80005828:	ffffe097          	auipc	ra,0xffffe
    8000582c:	18a080e7          	jalr	394(ra) # 800039b2 <iunlockput>
      end_op();
    80005830:	fffff097          	auipc	ra,0xfffff
    80005834:	960080e7          	jalr	-1696(ra) # 80004190 <end_op>
      return -1;
    80005838:	54fd                	li	s1,-1
    8000583a:	b76d                	j	800057e4 <sys_open+0xe4>
      end_op();
    8000583c:	fffff097          	auipc	ra,0xfffff
    80005840:	954080e7          	jalr	-1708(ra) # 80004190 <end_op>
      return -1;
    80005844:	54fd                	li	s1,-1
    80005846:	bf79                	j	800057e4 <sys_open+0xe4>
    iunlockput(ip);
    80005848:	854a                	mv	a0,s2
    8000584a:	ffffe097          	auipc	ra,0xffffe
    8000584e:	168080e7          	jalr	360(ra) # 800039b2 <iunlockput>
    end_op();
    80005852:	fffff097          	auipc	ra,0xfffff
    80005856:	93e080e7          	jalr	-1730(ra) # 80004190 <end_op>
    return -1;
    8000585a:	54fd                	li	s1,-1
    8000585c:	b761                	j	800057e4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000585e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005862:	04691783          	lh	a5,70(s2)
    80005866:	02f99223          	sh	a5,36(s3)
    8000586a:	bf2d                	j	800057a4 <sys_open+0xa4>
    itrunc(ip);
    8000586c:	854a                	mv	a0,s2
    8000586e:	ffffe097          	auipc	ra,0xffffe
    80005872:	ff0080e7          	jalr	-16(ra) # 8000385e <itrunc>
    80005876:	bfb1                	j	800057d2 <sys_open+0xd2>
      fileclose(f);
    80005878:	854e                	mv	a0,s3
    8000587a:	fffff097          	auipc	ra,0xfffff
    8000587e:	d68080e7          	jalr	-664(ra) # 800045e2 <fileclose>
    iunlockput(ip);
    80005882:	854a                	mv	a0,s2
    80005884:	ffffe097          	auipc	ra,0xffffe
    80005888:	12e080e7          	jalr	302(ra) # 800039b2 <iunlockput>
    end_op();
    8000588c:	fffff097          	auipc	ra,0xfffff
    80005890:	904080e7          	jalr	-1788(ra) # 80004190 <end_op>
    return -1;
    80005894:	54fd                	li	s1,-1
    80005896:	b7b9                	j	800057e4 <sys_open+0xe4>

0000000080005898 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005898:	7175                	addi	sp,sp,-144
    8000589a:	e506                	sd	ra,136(sp)
    8000589c:	e122                	sd	s0,128(sp)
    8000589e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800058a0:	fffff097          	auipc	ra,0xfffff
    800058a4:	870080e7          	jalr	-1936(ra) # 80004110 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800058a8:	08000613          	li	a2,128
    800058ac:	f7040593          	addi	a1,s0,-144
    800058b0:	4501                	li	a0,0
    800058b2:	ffffd097          	auipc	ra,0xffffd
    800058b6:	354080e7          	jalr	852(ra) # 80002c06 <argstr>
    800058ba:	02054963          	bltz	a0,800058ec <sys_mkdir+0x54>
    800058be:	4681                	li	a3,0
    800058c0:	4601                	li	a2,0
    800058c2:	4585                	li	a1,1
    800058c4:	f7040513          	addi	a0,s0,-144
    800058c8:	fffff097          	auipc	ra,0xfffff
    800058cc:	7fe080e7          	jalr	2046(ra) # 800050c6 <create>
    800058d0:	cd11                	beqz	a0,800058ec <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	0e0080e7          	jalr	224(ra) # 800039b2 <iunlockput>
  end_op();
    800058da:	fffff097          	auipc	ra,0xfffff
    800058de:	8b6080e7          	jalr	-1866(ra) # 80004190 <end_op>
  return 0;
    800058e2:	4501                	li	a0,0
}
    800058e4:	60aa                	ld	ra,136(sp)
    800058e6:	640a                	ld	s0,128(sp)
    800058e8:	6149                	addi	sp,sp,144
    800058ea:	8082                	ret
    end_op();
    800058ec:	fffff097          	auipc	ra,0xfffff
    800058f0:	8a4080e7          	jalr	-1884(ra) # 80004190 <end_op>
    return -1;
    800058f4:	557d                	li	a0,-1
    800058f6:	b7fd                	j	800058e4 <sys_mkdir+0x4c>

00000000800058f8 <sys_mknod>:

uint64
sys_mknod(void)
{
    800058f8:	7135                	addi	sp,sp,-160
    800058fa:	ed06                	sd	ra,152(sp)
    800058fc:	e922                	sd	s0,144(sp)
    800058fe:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005900:	fffff097          	auipc	ra,0xfffff
    80005904:	810080e7          	jalr	-2032(ra) # 80004110 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005908:	08000613          	li	a2,128
    8000590c:	f7040593          	addi	a1,s0,-144
    80005910:	4501                	li	a0,0
    80005912:	ffffd097          	auipc	ra,0xffffd
    80005916:	2f4080e7          	jalr	756(ra) # 80002c06 <argstr>
    8000591a:	04054a63          	bltz	a0,8000596e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    8000591e:	f6c40593          	addi	a1,s0,-148
    80005922:	4505                	li	a0,1
    80005924:	ffffd097          	auipc	ra,0xffffd
    80005928:	29e080e7          	jalr	670(ra) # 80002bc2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000592c:	04054163          	bltz	a0,8000596e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005930:	f6840593          	addi	a1,s0,-152
    80005934:	4509                	li	a0,2
    80005936:	ffffd097          	auipc	ra,0xffffd
    8000593a:	28c080e7          	jalr	652(ra) # 80002bc2 <argint>
     argint(1, &major) < 0 ||
    8000593e:	02054863          	bltz	a0,8000596e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005942:	f6841683          	lh	a3,-152(s0)
    80005946:	f6c41603          	lh	a2,-148(s0)
    8000594a:	458d                	li	a1,3
    8000594c:	f7040513          	addi	a0,s0,-144
    80005950:	fffff097          	auipc	ra,0xfffff
    80005954:	776080e7          	jalr	1910(ra) # 800050c6 <create>
     argint(2, &minor) < 0 ||
    80005958:	c919                	beqz	a0,8000596e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000595a:	ffffe097          	auipc	ra,0xffffe
    8000595e:	058080e7          	jalr	88(ra) # 800039b2 <iunlockput>
  end_op();
    80005962:	fffff097          	auipc	ra,0xfffff
    80005966:	82e080e7          	jalr	-2002(ra) # 80004190 <end_op>
  return 0;
    8000596a:	4501                	li	a0,0
    8000596c:	a031                	j	80005978 <sys_mknod+0x80>
    end_op();
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	822080e7          	jalr	-2014(ra) # 80004190 <end_op>
    return -1;
    80005976:	557d                	li	a0,-1
}
    80005978:	60ea                	ld	ra,152(sp)
    8000597a:	644a                	ld	s0,144(sp)
    8000597c:	610d                	addi	sp,sp,160
    8000597e:	8082                	ret

0000000080005980 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005980:	7135                	addi	sp,sp,-160
    80005982:	ed06                	sd	ra,152(sp)
    80005984:	e922                	sd	s0,144(sp)
    80005986:	e526                	sd	s1,136(sp)
    80005988:	e14a                	sd	s2,128(sp)
    8000598a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000598c:	ffffc097          	auipc	ra,0xffffc
    80005990:	08c080e7          	jalr	140(ra) # 80001a18 <myproc>
    80005994:	892a                	mv	s2,a0
  
  begin_op();
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	77a080e7          	jalr	1914(ra) # 80004110 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000599e:	08000613          	li	a2,128
    800059a2:	f6040593          	addi	a1,s0,-160
    800059a6:	4501                	li	a0,0
    800059a8:	ffffd097          	auipc	ra,0xffffd
    800059ac:	25e080e7          	jalr	606(ra) # 80002c06 <argstr>
    800059b0:	04054b63          	bltz	a0,80005a06 <sys_chdir+0x86>
    800059b4:	f6040513          	addi	a0,s0,-160
    800059b8:	ffffe097          	auipc	ra,0xffffe
    800059bc:	54c080e7          	jalr	1356(ra) # 80003f04 <namei>
    800059c0:	84aa                	mv	s1,a0
    800059c2:	c131                	beqz	a0,80005a06 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800059c4:	ffffe097          	auipc	ra,0xffffe
    800059c8:	d8c080e7          	jalr	-628(ra) # 80003750 <ilock>
  if(ip->type != T_DIR){
    800059cc:	04449703          	lh	a4,68(s1)
    800059d0:	4785                	li	a5,1
    800059d2:	04f71063          	bne	a4,a5,80005a12 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800059d6:	8526                	mv	a0,s1
    800059d8:	ffffe097          	auipc	ra,0xffffe
    800059dc:	e3a080e7          	jalr	-454(ra) # 80003812 <iunlock>
  iput(p->cwd);
    800059e0:	15093503          	ld	a0,336(s2)
    800059e4:	ffffe097          	auipc	ra,0xffffe
    800059e8:	f26080e7          	jalr	-218(ra) # 8000390a <iput>
  end_op();
    800059ec:	ffffe097          	auipc	ra,0xffffe
    800059f0:	7a4080e7          	jalr	1956(ra) # 80004190 <end_op>
  p->cwd = ip;
    800059f4:	14993823          	sd	s1,336(s2)
  return 0;
    800059f8:	4501                	li	a0,0
}
    800059fa:	60ea                	ld	ra,152(sp)
    800059fc:	644a                	ld	s0,144(sp)
    800059fe:	64aa                	ld	s1,136(sp)
    80005a00:	690a                	ld	s2,128(sp)
    80005a02:	610d                	addi	sp,sp,160
    80005a04:	8082                	ret
    end_op();
    80005a06:	ffffe097          	auipc	ra,0xffffe
    80005a0a:	78a080e7          	jalr	1930(ra) # 80004190 <end_op>
    return -1;
    80005a0e:	557d                	li	a0,-1
    80005a10:	b7ed                	j	800059fa <sys_chdir+0x7a>
    iunlockput(ip);
    80005a12:	8526                	mv	a0,s1
    80005a14:	ffffe097          	auipc	ra,0xffffe
    80005a18:	f9e080e7          	jalr	-98(ra) # 800039b2 <iunlockput>
    end_op();
    80005a1c:	ffffe097          	auipc	ra,0xffffe
    80005a20:	774080e7          	jalr	1908(ra) # 80004190 <end_op>
    return -1;
    80005a24:	557d                	li	a0,-1
    80005a26:	bfd1                	j	800059fa <sys_chdir+0x7a>

0000000080005a28 <sys_exec>:

uint64
sys_exec(void)
{
    80005a28:	7145                	addi	sp,sp,-464
    80005a2a:	e786                	sd	ra,456(sp)
    80005a2c:	e3a2                	sd	s0,448(sp)
    80005a2e:	ff26                	sd	s1,440(sp)
    80005a30:	fb4a                	sd	s2,432(sp)
    80005a32:	f74e                	sd	s3,424(sp)
    80005a34:	f352                	sd	s4,416(sp)
    80005a36:	ef56                	sd	s5,408(sp)
    80005a38:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a3a:	08000613          	li	a2,128
    80005a3e:	f4040593          	addi	a1,s0,-192
    80005a42:	4501                	li	a0,0
    80005a44:	ffffd097          	auipc	ra,0xffffd
    80005a48:	1c2080e7          	jalr	450(ra) # 80002c06 <argstr>
    return -1;
    80005a4c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005a4e:	0c054a63          	bltz	a0,80005b22 <sys_exec+0xfa>
    80005a52:	e3840593          	addi	a1,s0,-456
    80005a56:	4505                	li	a0,1
    80005a58:	ffffd097          	auipc	ra,0xffffd
    80005a5c:	18c080e7          	jalr	396(ra) # 80002be4 <argaddr>
    80005a60:	0c054163          	bltz	a0,80005b22 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005a64:	10000613          	li	a2,256
    80005a68:	4581                	li	a1,0
    80005a6a:	e4040513          	addi	a0,s0,-448
    80005a6e:	ffffb097          	auipc	ra,0xffffb
    80005a72:	29e080e7          	jalr	670(ra) # 80000d0c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a76:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005a7a:	89a6                	mv	s3,s1
    80005a7c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a7e:	02000a13          	li	s4,32
    80005a82:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a86:	00391513          	slli	a0,s2,0x3
    80005a8a:	e3040593          	addi	a1,s0,-464
    80005a8e:	e3843783          	ld	a5,-456(s0)
    80005a92:	953e                	add	a0,a0,a5
    80005a94:	ffffd097          	auipc	ra,0xffffd
    80005a98:	094080e7          	jalr	148(ra) # 80002b28 <fetchaddr>
    80005a9c:	02054a63          	bltz	a0,80005ad0 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005aa0:	e3043783          	ld	a5,-464(s0)
    80005aa4:	c3b9                	beqz	a5,80005aea <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005aa6:	ffffb097          	auipc	ra,0xffffb
    80005aaa:	07a080e7          	jalr	122(ra) # 80000b20 <kalloc>
    80005aae:	85aa                	mv	a1,a0
    80005ab0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005ab4:	cd11                	beqz	a0,80005ad0 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005ab6:	6605                	lui	a2,0x1
    80005ab8:	e3043503          	ld	a0,-464(s0)
    80005abc:	ffffd097          	auipc	ra,0xffffd
    80005ac0:	0be080e7          	jalr	190(ra) # 80002b7a <fetchstr>
    80005ac4:	00054663          	bltz	a0,80005ad0 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005ac8:	0905                	addi	s2,s2,1
    80005aca:	09a1                	addi	s3,s3,8
    80005acc:	fb491be3          	bne	s2,s4,80005a82 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ad0:	10048913          	addi	s2,s1,256
    80005ad4:	6088                	ld	a0,0(s1)
    80005ad6:	c529                	beqz	a0,80005b20 <sys_exec+0xf8>
    kfree(argv[i]);
    80005ad8:	ffffb097          	auipc	ra,0xffffb
    80005adc:	f4c080e7          	jalr	-180(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ae0:	04a1                	addi	s1,s1,8
    80005ae2:	ff2499e3          	bne	s1,s2,80005ad4 <sys_exec+0xac>
  return -1;
    80005ae6:	597d                	li	s2,-1
    80005ae8:	a82d                	j	80005b22 <sys_exec+0xfa>
      argv[i] = 0;
    80005aea:	0a8e                	slli	s5,s5,0x3
    80005aec:	fc040793          	addi	a5,s0,-64
    80005af0:	9abe                	add	s5,s5,a5
    80005af2:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005af6:	e4040593          	addi	a1,s0,-448
    80005afa:	f4040513          	addi	a0,s0,-192
    80005afe:	fffff097          	auipc	ra,0xfffff
    80005b02:	194080e7          	jalr	404(ra) # 80004c92 <exec>
    80005b06:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b08:	10048993          	addi	s3,s1,256
    80005b0c:	6088                	ld	a0,0(s1)
    80005b0e:	c911                	beqz	a0,80005b22 <sys_exec+0xfa>
    kfree(argv[i]);
    80005b10:	ffffb097          	auipc	ra,0xffffb
    80005b14:	f14080e7          	jalr	-236(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005b18:	04a1                	addi	s1,s1,8
    80005b1a:	ff3499e3          	bne	s1,s3,80005b0c <sys_exec+0xe4>
    80005b1e:	a011                	j	80005b22 <sys_exec+0xfa>
  return -1;
    80005b20:	597d                	li	s2,-1
}
    80005b22:	854a                	mv	a0,s2
    80005b24:	60be                	ld	ra,456(sp)
    80005b26:	641e                	ld	s0,448(sp)
    80005b28:	74fa                	ld	s1,440(sp)
    80005b2a:	795a                	ld	s2,432(sp)
    80005b2c:	79ba                	ld	s3,424(sp)
    80005b2e:	7a1a                	ld	s4,416(sp)
    80005b30:	6afa                	ld	s5,408(sp)
    80005b32:	6179                	addi	sp,sp,464
    80005b34:	8082                	ret

0000000080005b36 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005b36:	7139                	addi	sp,sp,-64
    80005b38:	fc06                	sd	ra,56(sp)
    80005b3a:	f822                	sd	s0,48(sp)
    80005b3c:	f426                	sd	s1,40(sp)
    80005b3e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005b40:	ffffc097          	auipc	ra,0xffffc
    80005b44:	ed8080e7          	jalr	-296(ra) # 80001a18 <myproc>
    80005b48:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005b4a:	fd840593          	addi	a1,s0,-40
    80005b4e:	4501                	li	a0,0
    80005b50:	ffffd097          	auipc	ra,0xffffd
    80005b54:	094080e7          	jalr	148(ra) # 80002be4 <argaddr>
    return -1;
    80005b58:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005b5a:	0e054063          	bltz	a0,80005c3a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005b5e:	fc840593          	addi	a1,s0,-56
    80005b62:	fd040513          	addi	a0,s0,-48
    80005b66:	fffff097          	auipc	ra,0xfffff
    80005b6a:	dd2080e7          	jalr	-558(ra) # 80004938 <pipealloc>
    return -1;
    80005b6e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b70:	0c054563          	bltz	a0,80005c3a <sys_pipe+0x104>
  fd0 = -1;
    80005b74:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b78:	fd043503          	ld	a0,-48(s0)
    80005b7c:	fffff097          	auipc	ra,0xfffff
    80005b80:	508080e7          	jalr	1288(ra) # 80005084 <fdalloc>
    80005b84:	fca42223          	sw	a0,-60(s0)
    80005b88:	08054c63          	bltz	a0,80005c20 <sys_pipe+0xea>
    80005b8c:	fc843503          	ld	a0,-56(s0)
    80005b90:	fffff097          	auipc	ra,0xfffff
    80005b94:	4f4080e7          	jalr	1268(ra) # 80005084 <fdalloc>
    80005b98:	fca42023          	sw	a0,-64(s0)
    80005b9c:	06054863          	bltz	a0,80005c0c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005ba0:	4691                	li	a3,4
    80005ba2:	fc440613          	addi	a2,s0,-60
    80005ba6:	fd843583          	ld	a1,-40(s0)
    80005baa:	68a8                	ld	a0,80(s1)
    80005bac:	ffffc097          	auipc	ra,0xffffc
    80005bb0:	b60080e7          	jalr	-1184(ra) # 8000170c <copyout>
    80005bb4:	02054063          	bltz	a0,80005bd4 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005bb8:	4691                	li	a3,4
    80005bba:	fc040613          	addi	a2,s0,-64
    80005bbe:	fd843583          	ld	a1,-40(s0)
    80005bc2:	0591                	addi	a1,a1,4
    80005bc4:	68a8                	ld	a0,80(s1)
    80005bc6:	ffffc097          	auipc	ra,0xffffc
    80005bca:	b46080e7          	jalr	-1210(ra) # 8000170c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005bce:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005bd0:	06055563          	bgez	a0,80005c3a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005bd4:	fc442783          	lw	a5,-60(s0)
    80005bd8:	07e9                	addi	a5,a5,26
    80005bda:	078e                	slli	a5,a5,0x3
    80005bdc:	97a6                	add	a5,a5,s1
    80005bde:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005be2:	fc042503          	lw	a0,-64(s0)
    80005be6:	0569                	addi	a0,a0,26
    80005be8:	050e                	slli	a0,a0,0x3
    80005bea:	9526                	add	a0,a0,s1
    80005bec:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005bf0:	fd043503          	ld	a0,-48(s0)
    80005bf4:	fffff097          	auipc	ra,0xfffff
    80005bf8:	9ee080e7          	jalr	-1554(ra) # 800045e2 <fileclose>
    fileclose(wf);
    80005bfc:	fc843503          	ld	a0,-56(s0)
    80005c00:	fffff097          	auipc	ra,0xfffff
    80005c04:	9e2080e7          	jalr	-1566(ra) # 800045e2 <fileclose>
    return -1;
    80005c08:	57fd                	li	a5,-1
    80005c0a:	a805                	j	80005c3a <sys_pipe+0x104>
    if(fd0 >= 0)
    80005c0c:	fc442783          	lw	a5,-60(s0)
    80005c10:	0007c863          	bltz	a5,80005c20 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005c14:	01a78513          	addi	a0,a5,26
    80005c18:	050e                	slli	a0,a0,0x3
    80005c1a:	9526                	add	a0,a0,s1
    80005c1c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005c20:	fd043503          	ld	a0,-48(s0)
    80005c24:	fffff097          	auipc	ra,0xfffff
    80005c28:	9be080e7          	jalr	-1602(ra) # 800045e2 <fileclose>
    fileclose(wf);
    80005c2c:	fc843503          	ld	a0,-56(s0)
    80005c30:	fffff097          	auipc	ra,0xfffff
    80005c34:	9b2080e7          	jalr	-1614(ra) # 800045e2 <fileclose>
    return -1;
    80005c38:	57fd                	li	a5,-1
}
    80005c3a:	853e                	mv	a0,a5
    80005c3c:	70e2                	ld	ra,56(sp)
    80005c3e:	7442                	ld	s0,48(sp)
    80005c40:	74a2                	ld	s1,40(sp)
    80005c42:	6121                	addi	sp,sp,64
    80005c44:	8082                	ret
	...

0000000080005c50 <kernelvec>:
    80005c50:	7111                	addi	sp,sp,-256
    80005c52:	e006                	sd	ra,0(sp)
    80005c54:	e40a                	sd	sp,8(sp)
    80005c56:	e80e                	sd	gp,16(sp)
    80005c58:	ec12                	sd	tp,24(sp)
    80005c5a:	f016                	sd	t0,32(sp)
    80005c5c:	f41a                	sd	t1,40(sp)
    80005c5e:	f81e                	sd	t2,48(sp)
    80005c60:	fc22                	sd	s0,56(sp)
    80005c62:	e0a6                	sd	s1,64(sp)
    80005c64:	e4aa                	sd	a0,72(sp)
    80005c66:	e8ae                	sd	a1,80(sp)
    80005c68:	ecb2                	sd	a2,88(sp)
    80005c6a:	f0b6                	sd	a3,96(sp)
    80005c6c:	f4ba                	sd	a4,104(sp)
    80005c6e:	f8be                	sd	a5,112(sp)
    80005c70:	fcc2                	sd	a6,120(sp)
    80005c72:	e146                	sd	a7,128(sp)
    80005c74:	e54a                	sd	s2,136(sp)
    80005c76:	e94e                	sd	s3,144(sp)
    80005c78:	ed52                	sd	s4,152(sp)
    80005c7a:	f156                	sd	s5,160(sp)
    80005c7c:	f55a                	sd	s6,168(sp)
    80005c7e:	f95e                	sd	s7,176(sp)
    80005c80:	fd62                	sd	s8,184(sp)
    80005c82:	e1e6                	sd	s9,192(sp)
    80005c84:	e5ea                	sd	s10,200(sp)
    80005c86:	e9ee                	sd	s11,208(sp)
    80005c88:	edf2                	sd	t3,216(sp)
    80005c8a:	f1f6                	sd	t4,224(sp)
    80005c8c:	f5fa                	sd	t5,232(sp)
    80005c8e:	f9fe                	sd	t6,240(sp)
    80005c90:	d65fc0ef          	jal	ra,800029f4 <kerneltrap>
    80005c94:	6082                	ld	ra,0(sp)
    80005c96:	6122                	ld	sp,8(sp)
    80005c98:	61c2                	ld	gp,16(sp)
    80005c9a:	7282                	ld	t0,32(sp)
    80005c9c:	7322                	ld	t1,40(sp)
    80005c9e:	73c2                	ld	t2,48(sp)
    80005ca0:	7462                	ld	s0,56(sp)
    80005ca2:	6486                	ld	s1,64(sp)
    80005ca4:	6526                	ld	a0,72(sp)
    80005ca6:	65c6                	ld	a1,80(sp)
    80005ca8:	6666                	ld	a2,88(sp)
    80005caa:	7686                	ld	a3,96(sp)
    80005cac:	7726                	ld	a4,104(sp)
    80005cae:	77c6                	ld	a5,112(sp)
    80005cb0:	7866                	ld	a6,120(sp)
    80005cb2:	688a                	ld	a7,128(sp)
    80005cb4:	692a                	ld	s2,136(sp)
    80005cb6:	69ca                	ld	s3,144(sp)
    80005cb8:	6a6a                	ld	s4,152(sp)
    80005cba:	7a8a                	ld	s5,160(sp)
    80005cbc:	7b2a                	ld	s6,168(sp)
    80005cbe:	7bca                	ld	s7,176(sp)
    80005cc0:	7c6a                	ld	s8,184(sp)
    80005cc2:	6c8e                	ld	s9,192(sp)
    80005cc4:	6d2e                	ld	s10,200(sp)
    80005cc6:	6dce                	ld	s11,208(sp)
    80005cc8:	6e6e                	ld	t3,216(sp)
    80005cca:	7e8e                	ld	t4,224(sp)
    80005ccc:	7f2e                	ld	t5,232(sp)
    80005cce:	7fce                	ld	t6,240(sp)
    80005cd0:	6111                	addi	sp,sp,256
    80005cd2:	10200073          	sret
    80005cd6:	00000013          	nop
    80005cda:	00000013          	nop
    80005cde:	0001                	nop

0000000080005ce0 <timervec>:
    80005ce0:	34051573          	csrrw	a0,mscratch,a0
    80005ce4:	e10c                	sd	a1,0(a0)
    80005ce6:	e510                	sd	a2,8(a0)
    80005ce8:	e914                	sd	a3,16(a0)
    80005cea:	710c                	ld	a1,32(a0)
    80005cec:	7510                	ld	a2,40(a0)
    80005cee:	6194                	ld	a3,0(a1)
    80005cf0:	96b2                	add	a3,a3,a2
    80005cf2:	e194                	sd	a3,0(a1)
    80005cf4:	4589                	li	a1,2
    80005cf6:	14459073          	csrw	sip,a1
    80005cfa:	6914                	ld	a3,16(a0)
    80005cfc:	6510                	ld	a2,8(a0)
    80005cfe:	610c                	ld	a1,0(a0)
    80005d00:	34051573          	csrrw	a0,mscratch,a0
    80005d04:	30200073          	mret
	...

0000000080005d0a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005d0a:	1141                	addi	sp,sp,-16
    80005d0c:	e422                	sd	s0,8(sp)
    80005d0e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005d10:	0c0007b7          	lui	a5,0xc000
    80005d14:	4705                	li	a4,1
    80005d16:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005d18:	c3d8                	sw	a4,4(a5)
}
    80005d1a:	6422                	ld	s0,8(sp)
    80005d1c:	0141                	addi	sp,sp,16
    80005d1e:	8082                	ret

0000000080005d20 <plicinithart>:

void
plicinithart(void)
{
    80005d20:	1141                	addi	sp,sp,-16
    80005d22:	e406                	sd	ra,8(sp)
    80005d24:	e022                	sd	s0,0(sp)
    80005d26:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d28:	ffffc097          	auipc	ra,0xffffc
    80005d2c:	cc4080e7          	jalr	-828(ra) # 800019ec <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005d30:	0085171b          	slliw	a4,a0,0x8
    80005d34:	0c0027b7          	lui	a5,0xc002
    80005d38:	97ba                	add	a5,a5,a4
    80005d3a:	40200713          	li	a4,1026
    80005d3e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005d42:	00d5151b          	slliw	a0,a0,0xd
    80005d46:	0c2017b7          	lui	a5,0xc201
    80005d4a:	953e                	add	a0,a0,a5
    80005d4c:	00052023          	sw	zero,0(a0)
}
    80005d50:	60a2                	ld	ra,8(sp)
    80005d52:	6402                	ld	s0,0(sp)
    80005d54:	0141                	addi	sp,sp,16
    80005d56:	8082                	ret

0000000080005d58 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005d58:	1141                	addi	sp,sp,-16
    80005d5a:	e406                	sd	ra,8(sp)
    80005d5c:	e022                	sd	s0,0(sp)
    80005d5e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005d60:	ffffc097          	auipc	ra,0xffffc
    80005d64:	c8c080e7          	jalr	-884(ra) # 800019ec <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005d68:	00d5179b          	slliw	a5,a0,0xd
    80005d6c:	0c201537          	lui	a0,0xc201
    80005d70:	953e                	add	a0,a0,a5
  return irq;
}
    80005d72:	4148                	lw	a0,4(a0)
    80005d74:	60a2                	ld	ra,8(sp)
    80005d76:	6402                	ld	s0,0(sp)
    80005d78:	0141                	addi	sp,sp,16
    80005d7a:	8082                	ret

0000000080005d7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d7c:	1101                	addi	sp,sp,-32
    80005d7e:	ec06                	sd	ra,24(sp)
    80005d80:	e822                	sd	s0,16(sp)
    80005d82:	e426                	sd	s1,8(sp)
    80005d84:	1000                	addi	s0,sp,32
    80005d86:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d88:	ffffc097          	auipc	ra,0xffffc
    80005d8c:	c64080e7          	jalr	-924(ra) # 800019ec <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d90:	00d5151b          	slliw	a0,a0,0xd
    80005d94:	0c2017b7          	lui	a5,0xc201
    80005d98:	97aa                	add	a5,a5,a0
    80005d9a:	c3c4                	sw	s1,4(a5)
}
    80005d9c:	60e2                	ld	ra,24(sp)
    80005d9e:	6442                	ld	s0,16(sp)
    80005da0:	64a2                	ld	s1,8(sp)
    80005da2:	6105                	addi	sp,sp,32
    80005da4:	8082                	ret

0000000080005da6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005da6:	1141                	addi	sp,sp,-16
    80005da8:	e406                	sd	ra,8(sp)
    80005daa:	e022                	sd	s0,0(sp)
    80005dac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005dae:	479d                	li	a5,7
    80005db0:	04a7cc63          	blt	a5,a0,80005e08 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005db4:	0001d797          	auipc	a5,0x1d
    80005db8:	24c78793          	addi	a5,a5,588 # 80023000 <disk>
    80005dbc:	00a78733          	add	a4,a5,a0
    80005dc0:	6789                	lui	a5,0x2
    80005dc2:	97ba                	add	a5,a5,a4
    80005dc4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005dc8:	eba1                	bnez	a5,80005e18 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005dca:	00451713          	slli	a4,a0,0x4
    80005dce:	0001f797          	auipc	a5,0x1f
    80005dd2:	2327b783          	ld	a5,562(a5) # 80025000 <disk+0x2000>
    80005dd6:	97ba                	add	a5,a5,a4
    80005dd8:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005ddc:	0001d797          	auipc	a5,0x1d
    80005de0:	22478793          	addi	a5,a5,548 # 80023000 <disk>
    80005de4:	97aa                	add	a5,a5,a0
    80005de6:	6509                	lui	a0,0x2
    80005de8:	953e                	add	a0,a0,a5
    80005dea:	4785                	li	a5,1
    80005dec:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005df0:	0001f517          	auipc	a0,0x1f
    80005df4:	22850513          	addi	a0,a0,552 # 80025018 <disk+0x2018>
    80005df8:	ffffc097          	auipc	ra,0xffffc
    80005dfc:	5b6080e7          	jalr	1462(ra) # 800023ae <wakeup>
}
    80005e00:	60a2                	ld	ra,8(sp)
    80005e02:	6402                	ld	s0,0(sp)
    80005e04:	0141                	addi	sp,sp,16
    80005e06:	8082                	ret
    panic("virtio_disk_intr 1");
    80005e08:	00003517          	auipc	a0,0x3
    80005e0c:	93050513          	addi	a0,a0,-1744 # 80008738 <syscalls+0x330>
    80005e10:	ffffa097          	auipc	ra,0xffffa
    80005e14:	738080e7          	jalr	1848(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80005e18:	00003517          	auipc	a0,0x3
    80005e1c:	93850513          	addi	a0,a0,-1736 # 80008750 <syscalls+0x348>
    80005e20:	ffffa097          	auipc	ra,0xffffa
    80005e24:	728080e7          	jalr	1832(ra) # 80000548 <panic>

0000000080005e28 <virtio_disk_init>:
{
    80005e28:	1101                	addi	sp,sp,-32
    80005e2a:	ec06                	sd	ra,24(sp)
    80005e2c:	e822                	sd	s0,16(sp)
    80005e2e:	e426                	sd	s1,8(sp)
    80005e30:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005e32:	00003597          	auipc	a1,0x3
    80005e36:	93658593          	addi	a1,a1,-1738 # 80008768 <syscalls+0x360>
    80005e3a:	0001f517          	auipc	a0,0x1f
    80005e3e:	26e50513          	addi	a0,a0,622 # 800250a8 <disk+0x20a8>
    80005e42:	ffffb097          	auipc	ra,0xffffb
    80005e46:	d3e080e7          	jalr	-706(ra) # 80000b80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e4a:	100017b7          	lui	a5,0x10001
    80005e4e:	4398                	lw	a4,0(a5)
    80005e50:	2701                	sext.w	a4,a4
    80005e52:	747277b7          	lui	a5,0x74727
    80005e56:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e5a:	0ef71163          	bne	a4,a5,80005f3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e5e:	100017b7          	lui	a5,0x10001
    80005e62:	43dc                	lw	a5,4(a5)
    80005e64:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e66:	4705                	li	a4,1
    80005e68:	0ce79a63          	bne	a5,a4,80005f3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e6c:	100017b7          	lui	a5,0x10001
    80005e70:	479c                	lw	a5,8(a5)
    80005e72:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e74:	4709                	li	a4,2
    80005e76:	0ce79363          	bne	a5,a4,80005f3c <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e7a:	100017b7          	lui	a5,0x10001
    80005e7e:	47d8                	lw	a4,12(a5)
    80005e80:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e82:	554d47b7          	lui	a5,0x554d4
    80005e86:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e8a:	0af71963          	bne	a4,a5,80005f3c <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e8e:	100017b7          	lui	a5,0x10001
    80005e92:	4705                	li	a4,1
    80005e94:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e96:	470d                	li	a4,3
    80005e98:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e9a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e9c:	c7ffe737          	lui	a4,0xc7ffe
    80005ea0:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005ea4:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005ea6:	2701                	sext.w	a4,a4
    80005ea8:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005eaa:	472d                	li	a4,11
    80005eac:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005eae:	473d                	li	a4,15
    80005eb0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005eb2:	6705                	lui	a4,0x1
    80005eb4:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005eb6:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005eba:	5bdc                	lw	a5,52(a5)
    80005ebc:	2781                	sext.w	a5,a5
  if(max == 0)
    80005ebe:	c7d9                	beqz	a5,80005f4c <virtio_disk_init+0x124>
  if(max < NUM)
    80005ec0:	471d                	li	a4,7
    80005ec2:	08f77d63          	bgeu	a4,a5,80005f5c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005ec6:	100014b7          	lui	s1,0x10001
    80005eca:	47a1                	li	a5,8
    80005ecc:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005ece:	6609                	lui	a2,0x2
    80005ed0:	4581                	li	a1,0
    80005ed2:	0001d517          	auipc	a0,0x1d
    80005ed6:	12e50513          	addi	a0,a0,302 # 80023000 <disk>
    80005eda:	ffffb097          	auipc	ra,0xffffb
    80005ede:	e32080e7          	jalr	-462(ra) # 80000d0c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005ee2:	0001d717          	auipc	a4,0x1d
    80005ee6:	11e70713          	addi	a4,a4,286 # 80023000 <disk>
    80005eea:	00c75793          	srli	a5,a4,0xc
    80005eee:	2781                	sext.w	a5,a5
    80005ef0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005ef2:	0001f797          	auipc	a5,0x1f
    80005ef6:	10e78793          	addi	a5,a5,270 # 80025000 <disk+0x2000>
    80005efa:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005efc:	0001d717          	auipc	a4,0x1d
    80005f00:	18470713          	addi	a4,a4,388 # 80023080 <disk+0x80>
    80005f04:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005f06:	0001e717          	auipc	a4,0x1e
    80005f0a:	0fa70713          	addi	a4,a4,250 # 80024000 <disk+0x1000>
    80005f0e:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005f10:	4705                	li	a4,1
    80005f12:	00e78c23          	sb	a4,24(a5)
    80005f16:	00e78ca3          	sb	a4,25(a5)
    80005f1a:	00e78d23          	sb	a4,26(a5)
    80005f1e:	00e78da3          	sb	a4,27(a5)
    80005f22:	00e78e23          	sb	a4,28(a5)
    80005f26:	00e78ea3          	sb	a4,29(a5)
    80005f2a:	00e78f23          	sb	a4,30(a5)
    80005f2e:	00e78fa3          	sb	a4,31(a5)
}
    80005f32:	60e2                	ld	ra,24(sp)
    80005f34:	6442                	ld	s0,16(sp)
    80005f36:	64a2                	ld	s1,8(sp)
    80005f38:	6105                	addi	sp,sp,32
    80005f3a:	8082                	ret
    panic("could not find virtio disk");
    80005f3c:	00003517          	auipc	a0,0x3
    80005f40:	83c50513          	addi	a0,a0,-1988 # 80008778 <syscalls+0x370>
    80005f44:	ffffa097          	auipc	ra,0xffffa
    80005f48:	604080e7          	jalr	1540(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    80005f4c:	00003517          	auipc	a0,0x3
    80005f50:	84c50513          	addi	a0,a0,-1972 # 80008798 <syscalls+0x390>
    80005f54:	ffffa097          	auipc	ra,0xffffa
    80005f58:	5f4080e7          	jalr	1524(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    80005f5c:	00003517          	auipc	a0,0x3
    80005f60:	85c50513          	addi	a0,a0,-1956 # 800087b8 <syscalls+0x3b0>
    80005f64:	ffffa097          	auipc	ra,0xffffa
    80005f68:	5e4080e7          	jalr	1508(ra) # 80000548 <panic>

0000000080005f6c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f6c:	7119                	addi	sp,sp,-128
    80005f6e:	fc86                	sd	ra,120(sp)
    80005f70:	f8a2                	sd	s0,112(sp)
    80005f72:	f4a6                	sd	s1,104(sp)
    80005f74:	f0ca                	sd	s2,96(sp)
    80005f76:	ecce                	sd	s3,88(sp)
    80005f78:	e8d2                	sd	s4,80(sp)
    80005f7a:	e4d6                	sd	s5,72(sp)
    80005f7c:	e0da                	sd	s6,64(sp)
    80005f7e:	fc5e                	sd	s7,56(sp)
    80005f80:	f862                	sd	s8,48(sp)
    80005f82:	f466                	sd	s9,40(sp)
    80005f84:	f06a                	sd	s10,32(sp)
    80005f86:	0100                	addi	s0,sp,128
    80005f88:	892a                	mv	s2,a0
    80005f8a:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f8c:	00c52c83          	lw	s9,12(a0)
    80005f90:	001c9c9b          	slliw	s9,s9,0x1
    80005f94:	1c82                	slli	s9,s9,0x20
    80005f96:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005f9a:	0001f517          	auipc	a0,0x1f
    80005f9e:	10e50513          	addi	a0,a0,270 # 800250a8 <disk+0x20a8>
    80005fa2:	ffffb097          	auipc	ra,0xffffb
    80005fa6:	c6e080e7          	jalr	-914(ra) # 80000c10 <acquire>
  for(int i = 0; i < 3; i++){
    80005faa:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005fac:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005fae:	0001db97          	auipc	s7,0x1d
    80005fb2:	052b8b93          	addi	s7,s7,82 # 80023000 <disk>
    80005fb6:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005fb8:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005fba:	8a4e                	mv	s4,s3
    80005fbc:	a051                	j	80006040 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005fbe:	00fb86b3          	add	a3,s7,a5
    80005fc2:	96da                	add	a3,a3,s6
    80005fc4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005fc8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005fca:	0207c563          	bltz	a5,80005ff4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005fce:	2485                	addiw	s1,s1,1
    80005fd0:	0711                	addi	a4,a4,4
    80005fd2:	23548d63          	beq	s1,s5,8000620c <virtio_disk_rw+0x2a0>
    idx[i] = alloc_desc();
    80005fd6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005fd8:	0001f697          	auipc	a3,0x1f
    80005fdc:	04068693          	addi	a3,a3,64 # 80025018 <disk+0x2018>
    80005fe0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005fe2:	0006c583          	lbu	a1,0(a3)
    80005fe6:	fde1                	bnez	a1,80005fbe <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005fe8:	2785                	addiw	a5,a5,1
    80005fea:	0685                	addi	a3,a3,1
    80005fec:	ff879be3          	bne	a5,s8,80005fe2 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005ff0:	57fd                	li	a5,-1
    80005ff2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005ff4:	02905a63          	blez	s1,80006028 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005ff8:	f9042503          	lw	a0,-112(s0)
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	daa080e7          	jalr	-598(ra) # 80005da6 <free_desc>
      for(int j = 0; j < i; j++)
    80006004:	4785                	li	a5,1
    80006006:	0297d163          	bge	a5,s1,80006028 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000600a:	f9442503          	lw	a0,-108(s0)
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	d98080e7          	jalr	-616(ra) # 80005da6 <free_desc>
      for(int j = 0; j < i; j++)
    80006016:	4789                	li	a5,2
    80006018:	0097d863          	bge	a5,s1,80006028 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    8000601c:	f9842503          	lw	a0,-104(s0)
    80006020:	00000097          	auipc	ra,0x0
    80006024:	d86080e7          	jalr	-634(ra) # 80005da6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006028:	0001f597          	auipc	a1,0x1f
    8000602c:	08058593          	addi	a1,a1,128 # 800250a8 <disk+0x20a8>
    80006030:	0001f517          	auipc	a0,0x1f
    80006034:	fe850513          	addi	a0,a0,-24 # 80025018 <disk+0x2018>
    80006038:	ffffc097          	auipc	ra,0xffffc
    8000603c:	1f0080e7          	jalr	496(ra) # 80002228 <sleep>
  for(int i = 0; i < 3; i++){
    80006040:	f9040713          	addi	a4,s0,-112
    80006044:	84ce                	mv	s1,s3
    80006046:	bf41                	j	80005fd6 <virtio_disk_rw+0x6a>
    uint32 reserved;
    uint64 sector;
  } buf0;

  if(write)
    buf0.type = VIRTIO_BLK_T_OUT; // write the disk
    80006048:	4785                	li	a5,1
    8000604a:	f8f42023          	sw	a5,-128(s0)
  else
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
  buf0.reserved = 0;
    8000604e:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    80006052:	f9943423          	sd	s9,-120(s0)

  // buf0 is on a kernel stack, which is not direct mapped,
  // thus the call to kvmpa().
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006056:	f9042983          	lw	s3,-112(s0)
    8000605a:	00499493          	slli	s1,s3,0x4
    8000605e:	0001fa17          	auipc	s4,0x1f
    80006062:	fa2a0a13          	addi	s4,s4,-94 # 80025000 <disk+0x2000>
    80006066:	000a3a83          	ld	s5,0(s4)
    8000606a:	9aa6                	add	s5,s5,s1
    8000606c:	f8040513          	addi	a0,s0,-128
    80006070:	ffffb097          	auipc	ra,0xffffb
    80006074:	02e080e7          	jalr	46(ra) # 8000109e <kvmpa>
    80006078:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    8000607c:	000a3783          	ld	a5,0(s4)
    80006080:	97a6                	add	a5,a5,s1
    80006082:	4741                	li	a4,16
    80006084:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006086:	000a3783          	ld	a5,0(s4)
    8000608a:	97a6                	add	a5,a5,s1
    8000608c:	4705                	li	a4,1
    8000608e:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80006092:	f9442703          	lw	a4,-108(s0)
    80006096:	000a3783          	ld	a5,0(s4)
    8000609a:	97a6                	add	a5,a5,s1
    8000609c:	00e79723          	sh	a4,14(a5)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800060a0:	0712                	slli	a4,a4,0x4
    800060a2:	000a3783          	ld	a5,0(s4)
    800060a6:	97ba                	add	a5,a5,a4
    800060a8:	05890693          	addi	a3,s2,88
    800060ac:	e394                	sd	a3,0(a5)
  disk.desc[idx[1]].len = BSIZE;
    800060ae:	000a3783          	ld	a5,0(s4)
    800060b2:	97ba                	add	a5,a5,a4
    800060b4:	40000693          	li	a3,1024
    800060b8:	c794                	sw	a3,8(a5)
  if(write)
    800060ba:	100d0a63          	beqz	s10,800061ce <virtio_disk_rw+0x262>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800060be:	0001f797          	auipc	a5,0x1f
    800060c2:	f427b783          	ld	a5,-190(a5) # 80025000 <disk+0x2000>
    800060c6:	97ba                	add	a5,a5,a4
    800060c8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800060cc:	0001d517          	auipc	a0,0x1d
    800060d0:	f3450513          	addi	a0,a0,-204 # 80023000 <disk>
    800060d4:	0001f797          	auipc	a5,0x1f
    800060d8:	f2c78793          	addi	a5,a5,-212 # 80025000 <disk+0x2000>
    800060dc:	6394                	ld	a3,0(a5)
    800060de:	96ba                	add	a3,a3,a4
    800060e0:	00c6d603          	lhu	a2,12(a3)
    800060e4:	00166613          	ori	a2,a2,1
    800060e8:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800060ec:	f9842683          	lw	a3,-104(s0)
    800060f0:	6390                	ld	a2,0(a5)
    800060f2:	9732                	add	a4,a4,a2
    800060f4:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0;
    800060f8:	20098613          	addi	a2,s3,512
    800060fc:	0612                	slli	a2,a2,0x4
    800060fe:	962a                	add	a2,a2,a0
    80006100:	02060823          	sb	zero,48(a2) # 2030 <_entry-0x7fffdfd0>
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006104:	00469713          	slli	a4,a3,0x4
    80006108:	6394                	ld	a3,0(a5)
    8000610a:	96ba                	add	a3,a3,a4
    8000610c:	6589                	lui	a1,0x2
    8000610e:	03058593          	addi	a1,a1,48 # 2030 <_entry-0x7fffdfd0>
    80006112:	94ae                	add	s1,s1,a1
    80006114:	94aa                	add	s1,s1,a0
    80006116:	e284                	sd	s1,0(a3)
  disk.desc[idx[2]].len = 1;
    80006118:	6394                	ld	a3,0(a5)
    8000611a:	96ba                	add	a3,a3,a4
    8000611c:	4585                	li	a1,1
    8000611e:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006120:	6394                	ld	a3,0(a5)
    80006122:	96ba                	add	a3,a3,a4
    80006124:	4509                	li	a0,2
    80006126:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    8000612a:	6394                	ld	a3,0(a5)
    8000612c:	9736                	add	a4,a4,a3
    8000612e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006132:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80006136:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    8000613a:	6794                	ld	a3,8(a5)
    8000613c:	0026d703          	lhu	a4,2(a3)
    80006140:	8b1d                	andi	a4,a4,7
    80006142:	2709                	addiw	a4,a4,2
    80006144:	0706                	slli	a4,a4,0x1
    80006146:	9736                	add	a4,a4,a3
    80006148:	01371023          	sh	s3,0(a4)
  __sync_synchronize();
    8000614c:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80006150:	6798                	ld	a4,8(a5)
    80006152:	00275783          	lhu	a5,2(a4)
    80006156:	2785                	addiw	a5,a5,1
    80006158:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000615c:	100017b7          	lui	a5,0x10001
    80006160:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006164:	00492703          	lw	a4,4(s2)
    80006168:	4785                	li	a5,1
    8000616a:	02f71163          	bne	a4,a5,8000618c <virtio_disk_rw+0x220>
    sleep(b, &disk.vdisk_lock);
    8000616e:	0001f997          	auipc	s3,0x1f
    80006172:	f3a98993          	addi	s3,s3,-198 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80006176:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006178:	85ce                	mv	a1,s3
    8000617a:	854a                	mv	a0,s2
    8000617c:	ffffc097          	auipc	ra,0xffffc
    80006180:	0ac080e7          	jalr	172(ra) # 80002228 <sleep>
  while(b->disk == 1) {
    80006184:	00492783          	lw	a5,4(s2)
    80006188:	fe9788e3          	beq	a5,s1,80006178 <virtio_disk_rw+0x20c>
  }

  disk.info[idx[0]].b = 0;
    8000618c:	f9042483          	lw	s1,-112(s0)
    80006190:	20048793          	addi	a5,s1,512 # 10001200 <_entry-0x6fffee00>
    80006194:	00479713          	slli	a4,a5,0x4
    80006198:	0001d797          	auipc	a5,0x1d
    8000619c:	e6878793          	addi	a5,a5,-408 # 80023000 <disk>
    800061a0:	97ba                	add	a5,a5,a4
    800061a2:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800061a6:	0001f917          	auipc	s2,0x1f
    800061aa:	e5a90913          	addi	s2,s2,-422 # 80025000 <disk+0x2000>
    free_desc(i);
    800061ae:	8526                	mv	a0,s1
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	bf6080e7          	jalr	-1034(ra) # 80005da6 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    800061b8:	0492                	slli	s1,s1,0x4
    800061ba:	00093783          	ld	a5,0(s2)
    800061be:	94be                	add	s1,s1,a5
    800061c0:	00c4d783          	lhu	a5,12(s1)
    800061c4:	8b85                	andi	a5,a5,1
    800061c6:	cf89                	beqz	a5,800061e0 <virtio_disk_rw+0x274>
      i = disk.desc[i].next;
    800061c8:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    800061cc:	b7cd                	j	800061ae <virtio_disk_rw+0x242>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800061ce:	0001f797          	auipc	a5,0x1f
    800061d2:	e327b783          	ld	a5,-462(a5) # 80025000 <disk+0x2000>
    800061d6:	97ba                	add	a5,a5,a4
    800061d8:	4689                	li	a3,2
    800061da:	00d79623          	sh	a3,12(a5)
    800061de:	b5fd                	j	800060cc <virtio_disk_rw+0x160>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800061e0:	0001f517          	auipc	a0,0x1f
    800061e4:	ec850513          	addi	a0,a0,-312 # 800250a8 <disk+0x20a8>
    800061e8:	ffffb097          	auipc	ra,0xffffb
    800061ec:	adc080e7          	jalr	-1316(ra) # 80000cc4 <release>
}
    800061f0:	70e6                	ld	ra,120(sp)
    800061f2:	7446                	ld	s0,112(sp)
    800061f4:	74a6                	ld	s1,104(sp)
    800061f6:	7906                	ld	s2,96(sp)
    800061f8:	69e6                	ld	s3,88(sp)
    800061fa:	6a46                	ld	s4,80(sp)
    800061fc:	6aa6                	ld	s5,72(sp)
    800061fe:	6b06                	ld	s6,64(sp)
    80006200:	7be2                	ld	s7,56(sp)
    80006202:	7c42                	ld	s8,48(sp)
    80006204:	7ca2                	ld	s9,40(sp)
    80006206:	7d02                	ld	s10,32(sp)
    80006208:	6109                	addi	sp,sp,128
    8000620a:	8082                	ret
  if(write)
    8000620c:	e20d1ee3          	bnez	s10,80006048 <virtio_disk_rw+0xdc>
    buf0.type = VIRTIO_BLK_T_IN; // read the disk
    80006210:	f8042023          	sw	zero,-128(s0)
    80006214:	bd2d                	j	8000604e <virtio_disk_rw+0xe2>

0000000080006216 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006216:	1101                	addi	sp,sp,-32
    80006218:	ec06                	sd	ra,24(sp)
    8000621a:	e822                	sd	s0,16(sp)
    8000621c:	e426                	sd	s1,8(sp)
    8000621e:	e04a                	sd	s2,0(sp)
    80006220:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006222:	0001f517          	auipc	a0,0x1f
    80006226:	e8650513          	addi	a0,a0,-378 # 800250a8 <disk+0x20a8>
    8000622a:	ffffb097          	auipc	ra,0xffffb
    8000622e:	9e6080e7          	jalr	-1562(ra) # 80000c10 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006232:	0001f717          	auipc	a4,0x1f
    80006236:	dce70713          	addi	a4,a4,-562 # 80025000 <disk+0x2000>
    8000623a:	02075783          	lhu	a5,32(a4)
    8000623e:	6b18                	ld	a4,16(a4)
    80006240:	00275683          	lhu	a3,2(a4)
    80006244:	8ebd                	xor	a3,a3,a5
    80006246:	8a9d                	andi	a3,a3,7
    80006248:	cab9                	beqz	a3,8000629e <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    8000624a:	0001d917          	auipc	s2,0x1d
    8000624e:	db690913          	addi	s2,s2,-586 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006252:	0001f497          	auipc	s1,0x1f
    80006256:	dae48493          	addi	s1,s1,-594 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    8000625a:	078e                	slli	a5,a5,0x3
    8000625c:	97ba                	add	a5,a5,a4
    8000625e:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006260:	20078713          	addi	a4,a5,512
    80006264:	0712                	slli	a4,a4,0x4
    80006266:	974a                	add	a4,a4,s2
    80006268:	03074703          	lbu	a4,48(a4)
    8000626c:	ef21                	bnez	a4,800062c4 <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    8000626e:	20078793          	addi	a5,a5,512
    80006272:	0792                	slli	a5,a5,0x4
    80006274:	97ca                	add	a5,a5,s2
    80006276:	7798                	ld	a4,40(a5)
    80006278:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    8000627c:	7788                	ld	a0,40(a5)
    8000627e:	ffffc097          	auipc	ra,0xffffc
    80006282:	130080e7          	jalr	304(ra) # 800023ae <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    80006286:	0204d783          	lhu	a5,32(s1)
    8000628a:	2785                	addiw	a5,a5,1
    8000628c:	8b9d                	andi	a5,a5,7
    8000628e:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006292:	6898                	ld	a4,16(s1)
    80006294:	00275683          	lhu	a3,2(a4)
    80006298:	8a9d                	andi	a3,a3,7
    8000629a:	fcf690e3          	bne	a3,a5,8000625a <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000629e:	10001737          	lui	a4,0x10001
    800062a2:	533c                	lw	a5,96(a4)
    800062a4:	8b8d                	andi	a5,a5,3
    800062a6:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    800062a8:	0001f517          	auipc	a0,0x1f
    800062ac:	e0050513          	addi	a0,a0,-512 # 800250a8 <disk+0x20a8>
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	a14080e7          	jalr	-1516(ra) # 80000cc4 <release>
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6902                	ld	s2,0(sp)
    800062c0:	6105                	addi	sp,sp,32
    800062c2:	8082                	ret
      panic("virtio_disk_intr status");
    800062c4:	00002517          	auipc	a0,0x2
    800062c8:	51450513          	addi	a0,a0,1300 # 800087d8 <syscalls+0x3d0>
    800062cc:	ffffa097          	auipc	ra,0xffffa
    800062d0:	27c080e7          	jalr	636(ra) # 80000548 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
