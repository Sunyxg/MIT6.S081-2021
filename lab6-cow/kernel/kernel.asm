
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0023e117          	auipc	sp,0x23e
    80000004:	14010113          	addi	sp,sp,320 # 8023e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0c3050ef          	jal	ra,800058d8 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb5                	bnez	a5,800000a0 <kfree+0x84>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00246797          	auipc	a5,0x246
    80000034:	21078793          	addi	a5,a5,528 # 80246240 <end>
    80000038:	06f56463          	bltu	a0,a5,800000a0 <kfree+0x84>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	06f57063          	bgeu	a0,a5,800000a0 <kfree+0x84>
    panic("kfree");

  acquire(&cow_cn.lock);
    80000044:	00009517          	auipc	a0,0x9
    80000048:	00c50513          	addi	a0,a0,12 # 80009050 <cow_cn>
    8000004c:	00006097          	auipc	ra,0x6
    80000050:	286080e7          	jalr	646(ra) # 800062d2 <acquire>
  int pn = (uint64)pa / PGSIZE;
    80000054:	00c4d793          	srli	a5,s1,0xc
    80000058:	2781                	sext.w	a5,a5
  if(cow_cn.cnt[pn] < 1 )
    8000005a:	00478713          	addi	a4,a5,4
    8000005e:	00271693          	slli	a3,a4,0x2
    80000062:	00009717          	auipc	a4,0x9
    80000066:	fee70713          	addi	a4,a4,-18 # 80009050 <cow_cn>
    8000006a:	9736                	add	a4,a4,a3
    8000006c:	4718                	lw	a4,8(a4)
    8000006e:	04e05163          	blez	a4,800000b0 <kfree+0x94>
    panic("cow_kfree\n");
  int tmp = --cow_cn.cnt[pn];
    80000072:	377d                	addiw	a4,a4,-1
    80000074:	0007091b          	sext.w	s2,a4
    80000078:	00009517          	auipc	a0,0x9
    8000007c:	fd850513          	addi	a0,a0,-40 # 80009050 <cow_cn>
    80000080:	0791                	addi	a5,a5,4
    80000082:	078a                	slli	a5,a5,0x2
    80000084:	97aa                	add	a5,a5,a0
    80000086:	c798                	sw	a4,8(a5)
  release(&cow_cn.lock);
    80000088:	00006097          	auipc	ra,0x6
    8000008c:	2fe080e7          	jalr	766(ra) # 80006386 <release>

  if(tmp > 0)
    80000090:	03205863          	blez	s2,800000c0 <kfree+0xa4>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    80000094:	60e2                	ld	ra,24(sp)
    80000096:	6442                	ld	s0,16(sp)
    80000098:	64a2                	ld	s1,8(sp)
    8000009a:	6902                	ld	s2,0(sp)
    8000009c:	6105                	addi	sp,sp,32
    8000009e:	8082                	ret
    panic("kfree");
    800000a0:	00008517          	auipc	a0,0x8
    800000a4:	f7050513          	addi	a0,a0,-144 # 80008010 <etext+0x10>
    800000a8:	00006097          	auipc	ra,0x6
    800000ac:	ce0080e7          	jalr	-800(ra) # 80005d88 <panic>
    panic("cow_kfree\n");
    800000b0:	00008517          	auipc	a0,0x8
    800000b4:	f6850513          	addi	a0,a0,-152 # 80008018 <etext+0x18>
    800000b8:	00006097          	auipc	ra,0x6
    800000bc:	cd0080e7          	jalr	-816(ra) # 80005d88 <panic>
  memset(pa, 1, PGSIZE);
    800000c0:	6605                	lui	a2,0x1
    800000c2:	4585                	li	a1,1
    800000c4:	8526                	mv	a0,s1
    800000c6:	00000097          	auipc	ra,0x0
    800000ca:	1da080e7          	jalr	474(ra) # 800002a0 <memset>
  acquire(&kmem.lock);
    800000ce:	00009917          	auipc	s2,0x9
    800000d2:	f6290913          	addi	s2,s2,-158 # 80009030 <kmem>
    800000d6:	854a                	mv	a0,s2
    800000d8:	00006097          	auipc	ra,0x6
    800000dc:	1fa080e7          	jalr	506(ra) # 800062d2 <acquire>
  r->next = kmem.freelist;
    800000e0:	01893783          	ld	a5,24(s2)
    800000e4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800000e6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    800000ea:	854a                	mv	a0,s2
    800000ec:	00006097          	auipc	ra,0x6
    800000f0:	29a080e7          	jalr	666(ra) # 80006386 <release>
    800000f4:	b745                	j	80000094 <kfree+0x78>

00000000800000f6 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000f6:	1101                	addi	sp,sp,-32
    800000f8:	ec06                	sd	ra,24(sp)
    800000fa:	e822                	sd	s0,16(sp)
    800000fc:	e426                	sd	s1,8(sp)
    800000fe:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000100:	00009497          	auipc	s1,0x9
    80000104:	f3048493          	addi	s1,s1,-208 # 80009030 <kmem>
    80000108:	8526                	mv	a0,s1
    8000010a:	00006097          	auipc	ra,0x6
    8000010e:	1c8080e7          	jalr	456(ra) # 800062d2 <acquire>
  r = kmem.freelist;
    80000112:	6c84                	ld	s1,24(s1)
  if(r)
    80000114:	c0d1                	beqz	s1,80000198 <kalloc+0xa2>
    kmem.freelist = r->next;
    80000116:	609c                	ld	a5,0(s1)
    80000118:	00009517          	auipc	a0,0x9
    8000011c:	f1850513          	addi	a0,a0,-232 # 80009030 <kmem>
    80000120:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000122:	00006097          	auipc	ra,0x6
    80000126:	264080e7          	jalr	612(ra) # 80006386 <release>

  if(r)
  {
    acquire(&cow_cn.lock);
    8000012a:	00009517          	auipc	a0,0x9
    8000012e:	f2650513          	addi	a0,a0,-218 # 80009050 <cow_cn>
    80000132:	00006097          	auipc	ra,0x6
    80000136:	1a0080e7          	jalr	416(ra) # 800062d2 <acquire>
    if(cow_cn.cnt[(uint64)r / PGSIZE] != 0)
    8000013a:	00c4d793          	srli	a5,s1,0xc
    8000013e:	00478713          	addi	a4,a5,4
    80000142:	00271693          	slli	a3,a4,0x2
    80000146:	00009717          	auipc	a4,0x9
    8000014a:	f0a70713          	addi	a4,a4,-246 # 80009050 <cow_cn>
    8000014e:	9736                	add	a4,a4,a3
    80000150:	4718                	lw	a4,8(a4)
    80000152:	eb1d                	bnez	a4,80000188 <kalloc+0x92>
      panic("cow kalloc!\n");
    cow_cn.cnt[(uint64)r / PGSIZE] = 1 ;
    80000154:	00009517          	auipc	a0,0x9
    80000158:	efc50513          	addi	a0,a0,-260 # 80009050 <cow_cn>
    8000015c:	0791                	addi	a5,a5,4
    8000015e:	078a                	slli	a5,a5,0x2
    80000160:	97aa                	add	a5,a5,a0
    80000162:	4705                	li	a4,1
    80000164:	c798                	sw	a4,8(a5)
    release(&cow_cn.lock);
    80000166:	00006097          	auipc	ra,0x6
    8000016a:	220080e7          	jalr	544(ra) # 80006386 <release>
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000016e:	6605                	lui	a2,0x1
    80000170:	4595                	li	a1,5
    80000172:	8526                	mv	a0,s1
    80000174:	00000097          	auipc	ra,0x0
    80000178:	12c080e7          	jalr	300(ra) # 800002a0 <memset>
    //print_page_cnt();
  }


  return (void*)r;
}
    8000017c:	8526                	mv	a0,s1
    8000017e:	60e2                	ld	ra,24(sp)
    80000180:	6442                	ld	s0,16(sp)
    80000182:	64a2                	ld	s1,8(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret
      panic("cow kalloc!\n");
    80000188:	00008517          	auipc	a0,0x8
    8000018c:	ea050513          	addi	a0,a0,-352 # 80008028 <etext+0x28>
    80000190:	00006097          	auipc	ra,0x6
    80000194:	bf8080e7          	jalr	-1032(ra) # 80005d88 <panic>
  release(&kmem.lock);
    80000198:	00009517          	auipc	a0,0x9
    8000019c:	e9850513          	addi	a0,a0,-360 # 80009030 <kmem>
    800001a0:	00006097          	auipc	ra,0x6
    800001a4:	1e6080e7          	jalr	486(ra) # 80006386 <release>
  if(r)
    800001a8:	bfd1                	j	8000017c <kalloc+0x86>

00000000800001aa <addcnt>:

int addcnt(void* pa) {
    800001aa:	1101                	addi	sp,sp,-32
    800001ac:	ec06                	sd	ra,24(sp)
    800001ae:	e822                	sd	s0,16(sp)
    800001b0:	e426                	sd	s1,8(sp)
    800001b2:	1000                	addi	s0,sp,32
    800001b4:	84aa                	mv	s1,a0
  acquire(&cow_cn.lock);
    800001b6:	00009517          	auipc	a0,0x9
    800001ba:	e9a50513          	addi	a0,a0,-358 # 80009050 <cow_cn>
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	114080e7          	jalr	276(ra) # 800062d2 <acquire>
  ++cow_cn.cnt[(uint64)pa / PGSIZE];
    800001c6:	00c4d793          	srli	a5,s1,0xc
    800001ca:	00009517          	auipc	a0,0x9
    800001ce:	e8650513          	addi	a0,a0,-378 # 80009050 <cow_cn>
    800001d2:	0791                	addi	a5,a5,4
    800001d4:	078a                	slli	a5,a5,0x2
    800001d6:	97aa                	add	a5,a5,a0
    800001d8:	4798                	lw	a4,8(a5)
    800001da:	2705                	addiw	a4,a4,1
    800001dc:	c798                	sw	a4,8(a5)
  release(&cow_cn.lock);
    800001de:	00006097          	auipc	ra,0x6
    800001e2:	1a8080e7          	jalr	424(ra) # 80006386 <release>
  return 0;
}
    800001e6:	4501                	li	a0,0
    800001e8:	60e2                	ld	ra,24(sp)
    800001ea:	6442                	ld	s0,16(sp)
    800001ec:	64a2                	ld	s1,8(sp)
    800001ee:	6105                	addi	sp,sp,32
    800001f0:	8082                	ret

00000000800001f2 <freerange>:
{
    800001f2:	7139                	addi	sp,sp,-64
    800001f4:	fc06                	sd	ra,56(sp)
    800001f6:	f822                	sd	s0,48(sp)
    800001f8:	f426                	sd	s1,40(sp)
    800001fa:	f04a                	sd	s2,32(sp)
    800001fc:	ec4e                	sd	s3,24(sp)
    800001fe:	e852                	sd	s4,16(sp)
    80000200:	e456                	sd	s5,8(sp)
    80000202:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000204:	6785                	lui	a5,0x1
    80000206:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000020a:	94aa                	add	s1,s1,a0
    8000020c:	757d                	lui	a0,0xfffff
    8000020e:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000210:	94be                	add	s1,s1,a5
    80000212:	0295e463          	bltu	a1,s1,8000023a <freerange+0x48>
    80000216:	89ae                	mv	s3,a1
    80000218:	7afd                	lui	s5,0xfffff
    8000021a:	6a05                	lui	s4,0x1
    8000021c:	01548933          	add	s2,s1,s5
    addcnt((void *)p);
    80000220:	854a                	mv	a0,s2
    80000222:	00000097          	auipc	ra,0x0
    80000226:	f88080e7          	jalr	-120(ra) # 800001aa <addcnt>
    kfree(p);
    8000022a:	854a                	mv	a0,s2
    8000022c:	00000097          	auipc	ra,0x0
    80000230:	df0080e7          	jalr	-528(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000234:	94d2                	add	s1,s1,s4
    80000236:	fe99f3e3          	bgeu	s3,s1,8000021c <freerange+0x2a>
}
    8000023a:	70e2                	ld	ra,56(sp)
    8000023c:	7442                	ld	s0,48(sp)
    8000023e:	74a2                	ld	s1,40(sp)
    80000240:	7902                	ld	s2,32(sp)
    80000242:	69e2                	ld	s3,24(sp)
    80000244:	6a42                	ld	s4,16(sp)
    80000246:	6aa2                	ld	s5,8(sp)
    80000248:	6121                	addi	sp,sp,64
    8000024a:	8082                	ret

000000008000024c <kinit>:
{
    8000024c:	1141                	addi	sp,sp,-16
    8000024e:	e406                	sd	ra,8(sp)
    80000250:	e022                	sd	s0,0(sp)
    80000252:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000254:	00008597          	auipc	a1,0x8
    80000258:	de458593          	addi	a1,a1,-540 # 80008038 <etext+0x38>
    8000025c:	00009517          	auipc	a0,0x9
    80000260:	dd450513          	addi	a0,a0,-556 # 80009030 <kmem>
    80000264:	00006097          	auipc	ra,0x6
    80000268:	fde080e7          	jalr	-34(ra) # 80006242 <initlock>
  initlock(&cow_cn.lock, "cow_cn");
    8000026c:	00008597          	auipc	a1,0x8
    80000270:	dd458593          	addi	a1,a1,-556 # 80008040 <etext+0x40>
    80000274:	00009517          	auipc	a0,0x9
    80000278:	ddc50513          	addi	a0,a0,-548 # 80009050 <cow_cn>
    8000027c:	00006097          	auipc	ra,0x6
    80000280:	fc6080e7          	jalr	-58(ra) # 80006242 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000284:	45c5                	li	a1,17
    80000286:	05ee                	slli	a1,a1,0x1b
    80000288:	00246517          	auipc	a0,0x246
    8000028c:	fb850513          	addi	a0,a0,-72 # 80246240 <end>
    80000290:	00000097          	auipc	ra,0x0
    80000294:	f62080e7          	jalr	-158(ra) # 800001f2 <freerange>
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e422                	sd	s0,8(sp)
    800002a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002a6:	ce09                	beqz	a2,800002c0 <memset+0x20>
    800002a8:	87aa                	mv	a5,a0
    800002aa:	fff6071b          	addiw	a4,a2,-1
    800002ae:	1702                	slli	a4,a4,0x20
    800002b0:	9301                	srli	a4,a4,0x20
    800002b2:	0705                	addi	a4,a4,1
    800002b4:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800002b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002ba:	0785                	addi	a5,a5,1
    800002bc:	fee79de3          	bne	a5,a4,800002b6 <memset+0x16>
  }
  return dst;
}
    800002c0:	6422                	ld	s0,8(sp)
    800002c2:	0141                	addi	sp,sp,16
    800002c4:	8082                	ret

00000000800002c6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002c6:	1141                	addi	sp,sp,-16
    800002c8:	e422                	sd	s0,8(sp)
    800002ca:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002cc:	ca05                	beqz	a2,800002fc <memcmp+0x36>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	0685                	addi	a3,a3,1
    800002d8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002da:	00054783          	lbu	a5,0(a0)
    800002de:	0005c703          	lbu	a4,0(a1)
    800002e2:	00e79863          	bne	a5,a4,800002f2 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800002e6:	0505                	addi	a0,a0,1
    800002e8:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002ea:	fed518e3          	bne	a0,a3,800002da <memcmp+0x14>
  }

  return 0;
    800002ee:	4501                	li	a0,0
    800002f0:	a019                	j	800002f6 <memcmp+0x30>
      return *s1 - *s2;
    800002f2:	40e7853b          	subw	a0,a5,a4
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret
  return 0;
    800002fc:	4501                	li	a0,0
    800002fe:	bfe5                	j	800002f6 <memcmp+0x30>

0000000080000300 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000306:	ca0d                	beqz	a2,80000338 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000308:	00a5f963          	bgeu	a1,a0,8000031a <memmove+0x1a>
    8000030c:	02061693          	slli	a3,a2,0x20
    80000310:	9281                	srli	a3,a3,0x20
    80000312:	00d58733          	add	a4,a1,a3
    80000316:	02e56463          	bltu	a0,a4,8000033e <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000031a:	fff6079b          	addiw	a5,a2,-1
    8000031e:	1782                	slli	a5,a5,0x20
    80000320:	9381                	srli	a5,a5,0x20
    80000322:	0785                	addi	a5,a5,1
    80000324:	97ae                	add	a5,a5,a1
    80000326:	872a                	mv	a4,a0
      *d++ = *s++;
    80000328:	0585                	addi	a1,a1,1
    8000032a:	0705                	addi	a4,a4,1
    8000032c:	fff5c683          	lbu	a3,-1(a1)
    80000330:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000334:	fef59ae3          	bne	a1,a5,80000328 <memmove+0x28>

  return dst;
}
    80000338:	6422                	ld	s0,8(sp)
    8000033a:	0141                	addi	sp,sp,16
    8000033c:	8082                	ret
    d += n;
    8000033e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000340:	fff6079b          	addiw	a5,a2,-1
    80000344:	1782                	slli	a5,a5,0x20
    80000346:	9381                	srli	a5,a5,0x20
    80000348:	fff7c793          	not	a5,a5
    8000034c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000034e:	177d                	addi	a4,a4,-1
    80000350:	16fd                	addi	a3,a3,-1
    80000352:	00074603          	lbu	a2,0(a4)
    80000356:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000035a:	fef71ae3          	bne	a4,a5,8000034e <memmove+0x4e>
    8000035e:	bfe9                	j	80000338 <memmove+0x38>

0000000080000360 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000360:	1141                	addi	sp,sp,-16
    80000362:	e406                	sd	ra,8(sp)
    80000364:	e022                	sd	s0,0(sp)
    80000366:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000368:	00000097          	auipc	ra,0x0
    8000036c:	f98080e7          	jalr	-104(ra) # 80000300 <memmove>
}
    80000370:	60a2                	ld	ra,8(sp)
    80000372:	6402                	ld	s0,0(sp)
    80000374:	0141                	addi	sp,sp,16
    80000376:	8082                	ret

0000000080000378 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000378:	1141                	addi	sp,sp,-16
    8000037a:	e422                	sd	s0,8(sp)
    8000037c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000037e:	ce11                	beqz	a2,8000039a <strncmp+0x22>
    80000380:	00054783          	lbu	a5,0(a0)
    80000384:	cf89                	beqz	a5,8000039e <strncmp+0x26>
    80000386:	0005c703          	lbu	a4,0(a1)
    8000038a:	00f71a63          	bne	a4,a5,8000039e <strncmp+0x26>
    n--, p++, q++;
    8000038e:	367d                	addiw	a2,a2,-1
    80000390:	0505                	addi	a0,a0,1
    80000392:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000394:	f675                	bnez	a2,80000380 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000396:	4501                	li	a0,0
    80000398:	a809                	j	800003aa <strncmp+0x32>
    8000039a:	4501                	li	a0,0
    8000039c:	a039                	j	800003aa <strncmp+0x32>
  if(n == 0)
    8000039e:	ca09                	beqz	a2,800003b0 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800003a0:	00054503          	lbu	a0,0(a0)
    800003a4:	0005c783          	lbu	a5,0(a1)
    800003a8:	9d1d                	subw	a0,a0,a5
}
    800003aa:	6422                	ld	s0,8(sp)
    800003ac:	0141                	addi	sp,sp,16
    800003ae:	8082                	ret
    return 0;
    800003b0:	4501                	li	a0,0
    800003b2:	bfe5                	j	800003aa <strncmp+0x32>

00000000800003b4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003b4:	1141                	addi	sp,sp,-16
    800003b6:	e422                	sd	s0,8(sp)
    800003b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003ba:	872a                	mv	a4,a0
    800003bc:	8832                	mv	a6,a2
    800003be:	367d                	addiw	a2,a2,-1
    800003c0:	01005963          	blez	a6,800003d2 <strncpy+0x1e>
    800003c4:	0705                	addi	a4,a4,1
    800003c6:	0005c783          	lbu	a5,0(a1)
    800003ca:	fef70fa3          	sb	a5,-1(a4)
    800003ce:	0585                	addi	a1,a1,1
    800003d0:	f7f5                	bnez	a5,800003bc <strncpy+0x8>
    ;
  while(n-- > 0)
    800003d2:	00c05d63          	blez	a2,800003ec <strncpy+0x38>
    800003d6:	86ba                	mv	a3,a4
    *s++ = 0;
    800003d8:	0685                	addi	a3,a3,1
    800003da:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800003de:	fff6c793          	not	a5,a3
    800003e2:	9fb9                	addw	a5,a5,a4
    800003e4:	010787bb          	addw	a5,a5,a6
    800003e8:	fef048e3          	bgtz	a5,800003d8 <strncpy+0x24>
  return os;
}
    800003ec:	6422                	ld	s0,8(sp)
    800003ee:	0141                	addi	sp,sp,16
    800003f0:	8082                	ret

00000000800003f2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003f2:	1141                	addi	sp,sp,-16
    800003f4:	e422                	sd	s0,8(sp)
    800003f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003f8:	02c05363          	blez	a2,8000041e <safestrcpy+0x2c>
    800003fc:	fff6069b          	addiw	a3,a2,-1
    80000400:	1682                	slli	a3,a3,0x20
    80000402:	9281                	srli	a3,a3,0x20
    80000404:	96ae                	add	a3,a3,a1
    80000406:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000408:	00d58963          	beq	a1,a3,8000041a <safestrcpy+0x28>
    8000040c:	0585                	addi	a1,a1,1
    8000040e:	0785                	addi	a5,a5,1
    80000410:	fff5c703          	lbu	a4,-1(a1)
    80000414:	fee78fa3          	sb	a4,-1(a5)
    80000418:	fb65                	bnez	a4,80000408 <safestrcpy+0x16>
    ;
  *s = 0;
    8000041a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000041e:	6422                	ld	s0,8(sp)
    80000420:	0141                	addi	sp,sp,16
    80000422:	8082                	ret

0000000080000424 <strlen>:

int
strlen(const char *s)
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e422                	sd	s0,8(sp)
    80000428:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000042a:	00054783          	lbu	a5,0(a0)
    8000042e:	cf91                	beqz	a5,8000044a <strlen+0x26>
    80000430:	0505                	addi	a0,a0,1
    80000432:	87aa                	mv	a5,a0
    80000434:	4685                	li	a3,1
    80000436:	9e89                	subw	a3,a3,a0
    80000438:	00f6853b          	addw	a0,a3,a5
    8000043c:	0785                	addi	a5,a5,1
    8000043e:	fff7c703          	lbu	a4,-1(a5)
    80000442:	fb7d                	bnez	a4,80000438 <strlen+0x14>
    ;
  return n;
}
    80000444:	6422                	ld	s0,8(sp)
    80000446:	0141                	addi	sp,sp,16
    80000448:	8082                	ret
  for(n = 0; s[n]; n++)
    8000044a:	4501                	li	a0,0
    8000044c:	bfe5                	j	80000444 <strlen+0x20>

000000008000044e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000044e:	1141                	addi	sp,sp,-16
    80000450:	e406                	sd	ra,8(sp)
    80000452:	e022                	sd	s0,0(sp)
    80000454:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000456:	00001097          	auipc	ra,0x1
    8000045a:	bdc080e7          	jalr	-1060(ra) # 80001032 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000045e:	00009717          	auipc	a4,0x9
    80000462:	ba270713          	addi	a4,a4,-1118 # 80009000 <started>
  if(cpuid() == 0){
    80000466:	c139                	beqz	a0,800004ac <main+0x5e>
    while(started == 0)
    80000468:	431c                	lw	a5,0(a4)
    8000046a:	2781                	sext.w	a5,a5
    8000046c:	dff5                	beqz	a5,80000468 <main+0x1a>
      ;
    __sync_synchronize();
    8000046e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000472:	00001097          	auipc	ra,0x1
    80000476:	bc0080e7          	jalr	-1088(ra) # 80001032 <cpuid>
    8000047a:	85aa                	mv	a1,a0
    8000047c:	00008517          	auipc	a0,0x8
    80000480:	be450513          	addi	a0,a0,-1052 # 80008060 <etext+0x60>
    80000484:	00006097          	auipc	ra,0x6
    80000488:	94e080e7          	jalr	-1714(ra) # 80005dd2 <printf>
    kvminithart();    // turn on paging
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	0d8080e7          	jalr	216(ra) # 80000564 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000494:	00002097          	auipc	ra,0x2
    80000498:	816080e7          	jalr	-2026(ra) # 80001caa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000049c:	00005097          	auipc	ra,0x5
    800004a0:	dc4080e7          	jalr	-572(ra) # 80005260 <plicinithart>
  }

  scheduler();        
    800004a4:	00001097          	auipc	ra,0x1
    800004a8:	0c4080e7          	jalr	196(ra) # 80001568 <scheduler>
    consoleinit();
    800004ac:	00005097          	auipc	ra,0x5
    800004b0:	7ee080e7          	jalr	2030(ra) # 80005c9a <consoleinit>
    printfinit();
    800004b4:	00006097          	auipc	ra,0x6
    800004b8:	b04080e7          	jalr	-1276(ra) # 80005fb8 <printfinit>
    printf("\n");
    800004bc:	00008517          	auipc	a0,0x8
    800004c0:	bb450513          	addi	a0,a0,-1100 # 80008070 <etext+0x70>
    800004c4:	00006097          	auipc	ra,0x6
    800004c8:	90e080e7          	jalr	-1778(ra) # 80005dd2 <printf>
    printf("xv6 kernel is booting\n");
    800004cc:	00008517          	auipc	a0,0x8
    800004d0:	b7c50513          	addi	a0,a0,-1156 # 80008048 <etext+0x48>
    800004d4:	00006097          	auipc	ra,0x6
    800004d8:	8fe080e7          	jalr	-1794(ra) # 80005dd2 <printf>
    printf("\n");
    800004dc:	00008517          	auipc	a0,0x8
    800004e0:	b9450513          	addi	a0,a0,-1132 # 80008070 <etext+0x70>
    800004e4:	00006097          	auipc	ra,0x6
    800004e8:	8ee080e7          	jalr	-1810(ra) # 80005dd2 <printf>
    kinit();         // physical page allocator
    800004ec:	00000097          	auipc	ra,0x0
    800004f0:	d60080e7          	jalr	-672(ra) # 8000024c <kinit>
    kvminit();       // create kernel page table
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	322080e7          	jalr	802(ra) # 80000816 <kvminit>
    kvminithart();   // turn on paging
    800004fc:	00000097          	auipc	ra,0x0
    80000500:	068080e7          	jalr	104(ra) # 80000564 <kvminithart>
    procinit();      // process table
    80000504:	00001097          	auipc	ra,0x1
    80000508:	a7e080e7          	jalr	-1410(ra) # 80000f82 <procinit>
    trapinit();      // trap vectors
    8000050c:	00001097          	auipc	ra,0x1
    80000510:	776080e7          	jalr	1910(ra) # 80001c82 <trapinit>
    trapinithart();  // install kernel trap vector
    80000514:	00001097          	auipc	ra,0x1
    80000518:	796080e7          	jalr	1942(ra) # 80001caa <trapinithart>
    plicinit();      // set up interrupt controller
    8000051c:	00005097          	auipc	ra,0x5
    80000520:	d2e080e7          	jalr	-722(ra) # 8000524a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000524:	00005097          	auipc	ra,0x5
    80000528:	d3c080e7          	jalr	-708(ra) # 80005260 <plicinithart>
    binit();         // buffer cache
    8000052c:	00002097          	auipc	ra,0x2
    80000530:	f18080e7          	jalr	-232(ra) # 80002444 <binit>
    iinit();         // inode table
    80000534:	00002097          	auipc	ra,0x2
    80000538:	5a8080e7          	jalr	1448(ra) # 80002adc <iinit>
    fileinit();      // file table
    8000053c:	00003097          	auipc	ra,0x3
    80000540:	552080e7          	jalr	1362(ra) # 80003a8e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000544:	00005097          	auipc	ra,0x5
    80000548:	e3e080e7          	jalr	-450(ra) # 80005382 <virtio_disk_init>
    userinit();      // first user process
    8000054c:	00001097          	auipc	ra,0x1
    80000550:	dea080e7          	jalr	-534(ra) # 80001336 <userinit>
    __sync_synchronize();
    80000554:	0ff0000f          	fence
    started = 1;
    80000558:	4785                	li	a5,1
    8000055a:	00009717          	auipc	a4,0x9
    8000055e:	aaf72323          	sw	a5,-1370(a4) # 80009000 <started>
    80000562:	b789                	j	800004a4 <main+0x56>

0000000080000564 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000564:	1141                	addi	sp,sp,-16
    80000566:	e422                	sd	s0,8(sp)
    80000568:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000056a:	00009797          	auipc	a5,0x9
    8000056e:	a9e7b783          	ld	a5,-1378(a5) # 80009008 <kernel_pagetable>
    80000572:	83b1                	srli	a5,a5,0xc
    80000574:	577d                	li	a4,-1
    80000576:	177e                	slli	a4,a4,0x3f
    80000578:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    8000057a:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000057e:	12000073          	sfence.vma
  sfence_vma();
}
    80000582:	6422                	ld	s0,8(sp)
    80000584:	0141                	addi	sp,sp,16
    80000586:	8082                	ret

0000000080000588 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000588:	7139                	addi	sp,sp,-64
    8000058a:	fc06                	sd	ra,56(sp)
    8000058c:	f822                	sd	s0,48(sp)
    8000058e:	f426                	sd	s1,40(sp)
    80000590:	f04a                	sd	s2,32(sp)
    80000592:	ec4e                	sd	s3,24(sp)
    80000594:	e852                	sd	s4,16(sp)
    80000596:	e456                	sd	s5,8(sp)
    80000598:	e05a                	sd	s6,0(sp)
    8000059a:	0080                	addi	s0,sp,64
    8000059c:	84aa                	mv	s1,a0
    8000059e:	89ae                	mv	s3,a1
    800005a0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800005a2:	57fd                	li	a5,-1
    800005a4:	83e9                	srli	a5,a5,0x1a
    800005a6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800005a8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800005aa:	04b7f263          	bgeu	a5,a1,800005ee <walk+0x66>
    panic("walk");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aca50513          	addi	a0,a0,-1334 # 80008078 <etext+0x78>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	7d2080e7          	jalr	2002(ra) # 80005d88 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005be:	060a8663          	beqz	s5,8000062a <walk+0xa2>
    800005c2:	00000097          	auipc	ra,0x0
    800005c6:	b34080e7          	jalr	-1228(ra) # 800000f6 <kalloc>
    800005ca:	84aa                	mv	s1,a0
    800005cc:	c529                	beqz	a0,80000616 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800005ce:	6605                	lui	a2,0x1
    800005d0:	4581                	li	a1,0
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	cce080e7          	jalr	-818(ra) # 800002a0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005da:	00c4d793          	srli	a5,s1,0xc
    800005de:	07aa                	slli	a5,a5,0xa
    800005e0:	0017e793          	ori	a5,a5,1
    800005e4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800005e8:	3a5d                	addiw	s4,s4,-9
    800005ea:	036a0063          	beq	s4,s6,8000060a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800005ee:	0149d933          	srl	s2,s3,s4
    800005f2:	1ff97913          	andi	s2,s2,511
    800005f6:	090e                	slli	s2,s2,0x3
    800005f8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800005fa:	00093483          	ld	s1,0(s2)
    800005fe:	0014f793          	andi	a5,s1,1
    80000602:	dfd5                	beqz	a5,800005be <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000604:	80a9                	srli	s1,s1,0xa
    80000606:	04b2                	slli	s1,s1,0xc
    80000608:	b7c5                	j	800005e8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000060a:	00c9d513          	srli	a0,s3,0xc
    8000060e:	1ff57513          	andi	a0,a0,511
    80000612:	050e                	slli	a0,a0,0x3
    80000614:	9526                	add	a0,a0,s1
}
    80000616:	70e2                	ld	ra,56(sp)
    80000618:	7442                	ld	s0,48(sp)
    8000061a:	74a2                	ld	s1,40(sp)
    8000061c:	7902                	ld	s2,32(sp)
    8000061e:	69e2                	ld	s3,24(sp)
    80000620:	6a42                	ld	s4,16(sp)
    80000622:	6aa2                	ld	s5,8(sp)
    80000624:	6b02                	ld	s6,0(sp)
    80000626:	6121                	addi	sp,sp,64
    80000628:	8082                	ret
        return 0;
    8000062a:	4501                	li	a0,0
    8000062c:	b7ed                	j	80000616 <walk+0x8e>

000000008000062e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000062e:	57fd                	li	a5,-1
    80000630:	83e9                	srli	a5,a5,0x1a
    80000632:	00b7f463          	bgeu	a5,a1,8000063a <walkaddr+0xc>
    return 0;
    80000636:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000638:	8082                	ret
{
    8000063a:	1141                	addi	sp,sp,-16
    8000063c:	e406                	sd	ra,8(sp)
    8000063e:	e022                	sd	s0,0(sp)
    80000640:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000642:	4601                	li	a2,0
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f44080e7          	jalr	-188(ra) # 80000588 <walk>
  if(pte == 0)
    8000064c:	c105                	beqz	a0,8000066c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000064e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000650:	0117f693          	andi	a3,a5,17
    80000654:	4745                	li	a4,17
    return 0;
    80000656:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000658:	00e68663          	beq	a3,a4,80000664 <walkaddr+0x36>
}
    8000065c:	60a2                	ld	ra,8(sp)
    8000065e:	6402                	ld	s0,0(sp)
    80000660:	0141                	addi	sp,sp,16
    80000662:	8082                	ret
  pa = PTE2PA(*pte);
    80000664:	00a7d513          	srli	a0,a5,0xa
    80000668:	0532                	slli	a0,a0,0xc
  return pa;
    8000066a:	bfcd                	j	8000065c <walkaddr+0x2e>
    return 0;
    8000066c:	4501                	li	a0,0
    8000066e:	b7fd                	j	8000065c <walkaddr+0x2e>

0000000080000670 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000670:	715d                	addi	sp,sp,-80
    80000672:	e486                	sd	ra,72(sp)
    80000674:	e0a2                	sd	s0,64(sp)
    80000676:	fc26                	sd	s1,56(sp)
    80000678:	f84a                	sd	s2,48(sp)
    8000067a:	f44e                	sd	s3,40(sp)
    8000067c:	f052                	sd	s4,32(sp)
    8000067e:	ec56                	sd	s5,24(sp)
    80000680:	e85a                	sd	s6,16(sp)
    80000682:	e45e                	sd	s7,8(sp)
    80000684:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000686:	c205                	beqz	a2,800006a6 <mappages+0x36>
    80000688:	8aaa                	mv	s5,a0
    8000068a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000068c:	77fd                	lui	a5,0xfffff
    8000068e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000692:	15fd                	addi	a1,a1,-1
    80000694:	00c589b3          	add	s3,a1,a2
    80000698:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000069c:	8952                	mv	s2,s4
    8000069e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800006a2:	6b85                	lui	s7,0x1
    800006a4:	a015                	j	800006c8 <mappages+0x58>
    panic("mappages: size");
    800006a6:	00008517          	auipc	a0,0x8
    800006aa:	9da50513          	addi	a0,a0,-1574 # 80008080 <etext+0x80>
    800006ae:	00005097          	auipc	ra,0x5
    800006b2:	6da080e7          	jalr	1754(ra) # 80005d88 <panic>
      panic("mappages: remap");
    800006b6:	00008517          	auipc	a0,0x8
    800006ba:	9da50513          	addi	a0,a0,-1574 # 80008090 <etext+0x90>
    800006be:	00005097          	auipc	ra,0x5
    800006c2:	6ca080e7          	jalr	1738(ra) # 80005d88 <panic>
    a += PGSIZE;
    800006c6:	995e                	add	s2,s2,s7
  for(;;){
    800006c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800006cc:	4605                	li	a2,1
    800006ce:	85ca                	mv	a1,s2
    800006d0:	8556                	mv	a0,s5
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	eb6080e7          	jalr	-330(ra) # 80000588 <walk>
    800006da:	cd19                	beqz	a0,800006f8 <mappages+0x88>
    if(*pte & PTE_V)
    800006dc:	611c                	ld	a5,0(a0)
    800006de:	8b85                	andi	a5,a5,1
    800006e0:	fbf9                	bnez	a5,800006b6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006e2:	80b1                	srli	s1,s1,0xc
    800006e4:	04aa                	slli	s1,s1,0xa
    800006e6:	0164e4b3          	or	s1,s1,s6
    800006ea:	0014e493          	ori	s1,s1,1
    800006ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800006f0:	fd391be3          	bne	s2,s3,800006c6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800006f4:	4501                	li	a0,0
    800006f6:	a011                	j	800006fa <mappages+0x8a>
      return -1;
    800006f8:	557d                	li	a0,-1
}
    800006fa:	60a6                	ld	ra,72(sp)
    800006fc:	6406                	ld	s0,64(sp)
    800006fe:	74e2                	ld	s1,56(sp)
    80000700:	7942                	ld	s2,48(sp)
    80000702:	79a2                	ld	s3,40(sp)
    80000704:	7a02                	ld	s4,32(sp)
    80000706:	6ae2                	ld	s5,24(sp)
    80000708:	6b42                	ld	s6,16(sp)
    8000070a:	6ba2                	ld	s7,8(sp)
    8000070c:	6161                	addi	sp,sp,80
    8000070e:	8082                	ret

0000000080000710 <kvmmap>:
{
    80000710:	1141                	addi	sp,sp,-16
    80000712:	e406                	sd	ra,8(sp)
    80000714:	e022                	sd	s0,0(sp)
    80000716:	0800                	addi	s0,sp,16
    80000718:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000071a:	86b2                	mv	a3,a2
    8000071c:	863e                	mv	a2,a5
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f52080e7          	jalr	-174(ra) # 80000670 <mappages>
    80000726:	e509                	bnez	a0,80000730 <kvmmap+0x20>
}
    80000728:	60a2                	ld	ra,8(sp)
    8000072a:	6402                	ld	s0,0(sp)
    8000072c:	0141                	addi	sp,sp,16
    8000072e:	8082                	ret
    panic("kvmmap");
    80000730:	00008517          	auipc	a0,0x8
    80000734:	97050513          	addi	a0,a0,-1680 # 800080a0 <etext+0xa0>
    80000738:	00005097          	auipc	ra,0x5
    8000073c:	650080e7          	jalr	1616(ra) # 80005d88 <panic>

0000000080000740 <kvmmake>:
{
    80000740:	1101                	addi	sp,sp,-32
    80000742:	ec06                	sd	ra,24(sp)
    80000744:	e822                	sd	s0,16(sp)
    80000746:	e426                	sd	s1,8(sp)
    80000748:	e04a                	sd	s2,0(sp)
    8000074a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	9aa080e7          	jalr	-1622(ra) # 800000f6 <kalloc>
    80000754:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000756:	6605                	lui	a2,0x1
    80000758:	4581                	li	a1,0
    8000075a:	00000097          	auipc	ra,0x0
    8000075e:	b46080e7          	jalr	-1210(ra) # 800002a0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000762:	4719                	li	a4,6
    80000764:	6685                	lui	a3,0x1
    80000766:	10000637          	lui	a2,0x10000
    8000076a:	100005b7          	lui	a1,0x10000
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	fa0080e7          	jalr	-96(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000778:	4719                	li	a4,6
    8000077a:	6685                	lui	a3,0x1
    8000077c:	10001637          	lui	a2,0x10001
    80000780:	100015b7          	lui	a1,0x10001
    80000784:	8526                	mv	a0,s1
    80000786:	00000097          	auipc	ra,0x0
    8000078a:	f8a080e7          	jalr	-118(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000078e:	4719                	li	a4,6
    80000790:	004006b7          	lui	a3,0x400
    80000794:	0c000637          	lui	a2,0xc000
    80000798:	0c0005b7          	lui	a1,0xc000
    8000079c:	8526                	mv	a0,s1
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	f72080e7          	jalr	-142(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800007a6:	00008917          	auipc	s2,0x8
    800007aa:	85a90913          	addi	s2,s2,-1958 # 80008000 <etext>
    800007ae:	4729                	li	a4,10
    800007b0:	80008697          	auipc	a3,0x80008
    800007b4:	85068693          	addi	a3,a3,-1968 # 8000 <_entry-0x7fff8000>
    800007b8:	4605                	li	a2,1
    800007ba:	067e                	slli	a2,a2,0x1f
    800007bc:	85b2                	mv	a1,a2
    800007be:	8526                	mv	a0,s1
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	f50080e7          	jalr	-176(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800007c8:	4719                	li	a4,6
    800007ca:	46c5                	li	a3,17
    800007cc:	06ee                	slli	a3,a3,0x1b
    800007ce:	412686b3          	sub	a3,a3,s2
    800007d2:	864a                	mv	a2,s2
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8526                	mv	a0,s1
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	f38080e7          	jalr	-200(ra) # 80000710 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800007e0:	4729                	li	a4,10
    800007e2:	6685                	lui	a3,0x1
    800007e4:	00007617          	auipc	a2,0x7
    800007e8:	81c60613          	addi	a2,a2,-2020 # 80007000 <_trampoline>
    800007ec:	040005b7          	lui	a1,0x4000
    800007f0:	15fd                	addi	a1,a1,-1
    800007f2:	05b2                	slli	a1,a1,0xc
    800007f4:	8526                	mv	a0,s1
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	f1a080e7          	jalr	-230(ra) # 80000710 <kvmmap>
  proc_mapstacks(kpgtbl);
    800007fe:	8526                	mv	a0,s1
    80000800:	00000097          	auipc	ra,0x0
    80000804:	6ec080e7          	jalr	1772(ra) # 80000eec <proc_mapstacks>
}
    80000808:	8526                	mv	a0,s1
    8000080a:	60e2                	ld	ra,24(sp)
    8000080c:	6442                	ld	s0,16(sp)
    8000080e:	64a2                	ld	s1,8(sp)
    80000810:	6902                	ld	s2,0(sp)
    80000812:	6105                	addi	sp,sp,32
    80000814:	8082                	ret

0000000080000816 <kvminit>:
{
    80000816:	1141                	addi	sp,sp,-16
    80000818:	e406                	sd	ra,8(sp)
    8000081a:	e022                	sd	s0,0(sp)
    8000081c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	f22080e7          	jalr	-222(ra) # 80000740 <kvmmake>
    80000826:	00008797          	auipc	a5,0x8
    8000082a:	7ea7b123          	sd	a0,2018(a5) # 80009008 <kernel_pagetable>
}
    8000082e:	60a2                	ld	ra,8(sp)
    80000830:	6402                	ld	s0,0(sp)
    80000832:	0141                	addi	sp,sp,16
    80000834:	8082                	ret

0000000080000836 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000836:	715d                	addi	sp,sp,-80
    80000838:	e486                	sd	ra,72(sp)
    8000083a:	e0a2                	sd	s0,64(sp)
    8000083c:	fc26                	sd	s1,56(sp)
    8000083e:	f84a                	sd	s2,48(sp)
    80000840:	f44e                	sd	s3,40(sp)
    80000842:	f052                	sd	s4,32(sp)
    80000844:	ec56                	sd	s5,24(sp)
    80000846:	e85a                	sd	s6,16(sp)
    80000848:	e45e                	sd	s7,8(sp)
    8000084a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000084c:	03459793          	slli	a5,a1,0x34
    80000850:	e795                	bnez	a5,8000087c <uvmunmap+0x46>
    80000852:	8a2a                	mv	s4,a0
    80000854:	892e                	mv	s2,a1
    80000856:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000858:	0632                	slli	a2,a2,0xc
    8000085a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000085e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000860:	6b05                	lui	s6,0x1
    80000862:	0735e863          	bltu	a1,s3,800008d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000866:	60a6                	ld	ra,72(sp)
    80000868:	6406                	ld	s0,64(sp)
    8000086a:	74e2                	ld	s1,56(sp)
    8000086c:	7942                	ld	s2,48(sp)
    8000086e:	79a2                	ld	s3,40(sp)
    80000870:	7a02                	ld	s4,32(sp)
    80000872:	6ae2                	ld	s5,24(sp)
    80000874:	6b42                	ld	s6,16(sp)
    80000876:	6ba2                	ld	s7,8(sp)
    80000878:	6161                	addi	sp,sp,80
    8000087a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000087c:	00008517          	auipc	a0,0x8
    80000880:	82c50513          	addi	a0,a0,-2004 # 800080a8 <etext+0xa8>
    80000884:	00005097          	auipc	ra,0x5
    80000888:	504080e7          	jalr	1284(ra) # 80005d88 <panic>
      panic("uvmunmap: walk");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	83450513          	addi	a0,a0,-1996 # 800080c0 <etext+0xc0>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	4f4080e7          	jalr	1268(ra) # 80005d88 <panic>
      panic("uvmunmap: not mapped");
    8000089c:	00008517          	auipc	a0,0x8
    800008a0:	83450513          	addi	a0,a0,-1996 # 800080d0 <etext+0xd0>
    800008a4:	00005097          	auipc	ra,0x5
    800008a8:	4e4080e7          	jalr	1252(ra) # 80005d88 <panic>
      panic("uvmunmap: not a leaf");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	83c50513          	addi	a0,a0,-1988 # 800080e8 <etext+0xe8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	4d4080e7          	jalr	1236(ra) # 80005d88 <panic>
      uint64 pa = PTE2PA(*pte);
    800008bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800008be:	0532                	slli	a0,a0,0xc
    800008c0:	fffff097          	auipc	ra,0xfffff
    800008c4:	75c080e7          	jalr	1884(ra) # 8000001c <kfree>
    *pte = 0;
    800008c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800008cc:	995a                	add	s2,s2,s6
    800008ce:	f9397ce3          	bgeu	s2,s3,80000866 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800008d2:	4601                	li	a2,0
    800008d4:	85ca                	mv	a1,s2
    800008d6:	8552                	mv	a0,s4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	cb0080e7          	jalr	-848(ra) # 80000588 <walk>
    800008e0:	84aa                	mv	s1,a0
    800008e2:	d54d                	beqz	a0,8000088c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800008e4:	6108                	ld	a0,0(a0)
    800008e6:	00157793          	andi	a5,a0,1
    800008ea:	dbcd                	beqz	a5,8000089c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800008ec:	3ff57793          	andi	a5,a0,1023
    800008f0:	fb778ee3          	beq	a5,s7,800008ac <uvmunmap+0x76>
    if(do_free){
    800008f4:	fc0a8ae3          	beqz	s5,800008c8 <uvmunmap+0x92>
    800008f8:	b7d1                	j	800008bc <uvmunmap+0x86>

00000000800008fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800008fa:	1101                	addi	sp,sp,-32
    800008fc:	ec06                	sd	ra,24(sp)
    800008fe:	e822                	sd	s0,16(sp)
    80000900:	e426                	sd	s1,8(sp)
    80000902:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000904:	fffff097          	auipc	ra,0xfffff
    80000908:	7f2080e7          	jalr	2034(ra) # 800000f6 <kalloc>
    8000090c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000090e:	c519                	beqz	a0,8000091c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000910:	6605                	lui	a2,0x1
    80000912:	4581                	li	a1,0
    80000914:	00000097          	auipc	ra,0x0
    80000918:	98c080e7          	jalr	-1652(ra) # 800002a0 <memset>
  return pagetable;
}
    8000091c:	8526                	mv	a0,s1
    8000091e:	60e2                	ld	ra,24(sp)
    80000920:	6442                	ld	s0,16(sp)
    80000922:	64a2                	ld	s1,8(sp)
    80000924:	6105                	addi	sp,sp,32
    80000926:	8082                	ret

0000000080000928 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000928:	7179                	addi	sp,sp,-48
    8000092a:	f406                	sd	ra,40(sp)
    8000092c:	f022                	sd	s0,32(sp)
    8000092e:	ec26                	sd	s1,24(sp)
    80000930:	e84a                	sd	s2,16(sp)
    80000932:	e44e                	sd	s3,8(sp)
    80000934:	e052                	sd	s4,0(sp)
    80000936:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000938:	6785                	lui	a5,0x1
    8000093a:	04f67863          	bgeu	a2,a5,8000098a <uvminit+0x62>
    8000093e:	8a2a                	mv	s4,a0
    80000940:	89ae                	mv	s3,a1
    80000942:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000944:	fffff097          	auipc	ra,0xfffff
    80000948:	7b2080e7          	jalr	1970(ra) # 800000f6 <kalloc>
    8000094c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000094e:	6605                	lui	a2,0x1
    80000950:	4581                	li	a1,0
    80000952:	00000097          	auipc	ra,0x0
    80000956:	94e080e7          	jalr	-1714(ra) # 800002a0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000095a:	4779                	li	a4,30
    8000095c:	86ca                	mv	a3,s2
    8000095e:	6605                	lui	a2,0x1
    80000960:	4581                	li	a1,0
    80000962:	8552                	mv	a0,s4
    80000964:	00000097          	auipc	ra,0x0
    80000968:	d0c080e7          	jalr	-756(ra) # 80000670 <mappages>
  memmove(mem, src, sz);
    8000096c:	8626                	mv	a2,s1
    8000096e:	85ce                	mv	a1,s3
    80000970:	854a                	mv	a0,s2
    80000972:	00000097          	auipc	ra,0x0
    80000976:	98e080e7          	jalr	-1650(ra) # 80000300 <memmove>
}
    8000097a:	70a2                	ld	ra,40(sp)
    8000097c:	7402                	ld	s0,32(sp)
    8000097e:	64e2                	ld	s1,24(sp)
    80000980:	6942                	ld	s2,16(sp)
    80000982:	69a2                	ld	s3,8(sp)
    80000984:	6a02                	ld	s4,0(sp)
    80000986:	6145                	addi	sp,sp,48
    80000988:	8082                	ret
    panic("inituvm: more than a page");
    8000098a:	00007517          	auipc	a0,0x7
    8000098e:	77650513          	addi	a0,a0,1910 # 80008100 <etext+0x100>
    80000992:	00005097          	auipc	ra,0x5
    80000996:	3f6080e7          	jalr	1014(ra) # 80005d88 <panic>

000000008000099a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800009a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800009a6:	00b67d63          	bgeu	a2,a1,800009c0 <uvmdealloc+0x26>
    800009aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800009ac:	6785                	lui	a5,0x1
    800009ae:	17fd                	addi	a5,a5,-1
    800009b0:	00f60733          	add	a4,a2,a5
    800009b4:	767d                	lui	a2,0xfffff
    800009b6:	8f71                	and	a4,a4,a2
    800009b8:	97ae                	add	a5,a5,a1
    800009ba:	8ff1                	and	a5,a5,a2
    800009bc:	00f76863          	bltu	a4,a5,800009cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009c0:	8526                	mv	a0,s1
    800009c2:	60e2                	ld	ra,24(sp)
    800009c4:	6442                	ld	s0,16(sp)
    800009c6:	64a2                	ld	s1,8(sp)
    800009c8:	6105                	addi	sp,sp,32
    800009ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800009cc:	8f99                	sub	a5,a5,a4
    800009ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800009d0:	4685                	li	a3,1
    800009d2:	0007861b          	sext.w	a2,a5
    800009d6:	85ba                	mv	a1,a4
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	e5e080e7          	jalr	-418(ra) # 80000836 <uvmunmap>
    800009e0:	b7c5                	j	800009c0 <uvmdealloc+0x26>

00000000800009e2 <uvmalloc>:
  if(newsz < oldsz)
    800009e2:	0ab66163          	bltu	a2,a1,80000a84 <uvmalloc+0xa2>
{
    800009e6:	7139                	addi	sp,sp,-64
    800009e8:	fc06                	sd	ra,56(sp)
    800009ea:	f822                	sd	s0,48(sp)
    800009ec:	f426                	sd	s1,40(sp)
    800009ee:	f04a                	sd	s2,32(sp)
    800009f0:	ec4e                	sd	s3,24(sp)
    800009f2:	e852                	sd	s4,16(sp)
    800009f4:	e456                	sd	s5,8(sp)
    800009f6:	0080                	addi	s0,sp,64
    800009f8:	8aaa                	mv	s5,a0
    800009fa:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800009fc:	6985                	lui	s3,0x1
    800009fe:	19fd                	addi	s3,s3,-1
    80000a00:	95ce                	add	a1,a1,s3
    80000a02:	79fd                	lui	s3,0xfffff
    80000a04:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a08:	08c9f063          	bgeu	s3,a2,80000a88 <uvmalloc+0xa6>
    80000a0c:	894e                	mv	s2,s3
    mem = kalloc();
    80000a0e:	fffff097          	auipc	ra,0xfffff
    80000a12:	6e8080e7          	jalr	1768(ra) # 800000f6 <kalloc>
    80000a16:	84aa                	mv	s1,a0
    if(mem == 0){
    80000a18:	c51d                	beqz	a0,80000a46 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000a1a:	6605                	lui	a2,0x1
    80000a1c:	4581                	li	a1,0
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	882080e7          	jalr	-1918(ra) # 800002a0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000a26:	4779                	li	a4,30
    80000a28:	86a6                	mv	a3,s1
    80000a2a:	6605                	lui	a2,0x1
    80000a2c:	85ca                	mv	a1,s2
    80000a2e:	8556                	mv	a0,s5
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	c40080e7          	jalr	-960(ra) # 80000670 <mappages>
    80000a38:	e905                	bnez	a0,80000a68 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000a3a:	6785                	lui	a5,0x1
    80000a3c:	993e                	add	s2,s2,a5
    80000a3e:	fd4968e3          	bltu	s2,s4,80000a0e <uvmalloc+0x2c>
  return newsz;
    80000a42:	8552                	mv	a0,s4
    80000a44:	a809                	j	80000a56 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000a46:	864e                	mv	a2,s3
    80000a48:	85ca                	mv	a1,s2
    80000a4a:	8556                	mv	a0,s5
    80000a4c:	00000097          	auipc	ra,0x0
    80000a50:	f4e080e7          	jalr	-178(ra) # 8000099a <uvmdealloc>
      return 0;
    80000a54:	4501                	li	a0,0
}
    80000a56:	70e2                	ld	ra,56(sp)
    80000a58:	7442                	ld	s0,48(sp)
    80000a5a:	74a2                	ld	s1,40(sp)
    80000a5c:	7902                	ld	s2,32(sp)
    80000a5e:	69e2                	ld	s3,24(sp)
    80000a60:	6a42                	ld	s4,16(sp)
    80000a62:	6aa2                	ld	s5,8(sp)
    80000a64:	6121                	addi	sp,sp,64
    80000a66:	8082                	ret
      kfree(mem);
    80000a68:	8526                	mv	a0,s1
    80000a6a:	fffff097          	auipc	ra,0xfffff
    80000a6e:	5b2080e7          	jalr	1458(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a72:	864e                	mv	a2,s3
    80000a74:	85ca                	mv	a1,s2
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f22080e7          	jalr	-222(ra) # 8000099a <uvmdealloc>
      return 0;
    80000a80:	4501                	li	a0,0
    80000a82:	bfd1                	j	80000a56 <uvmalloc+0x74>
    return oldsz;
    80000a84:	852e                	mv	a0,a1
}
    80000a86:	8082                	ret
  return newsz;
    80000a88:	8532                	mv	a0,a2
    80000a8a:	b7f1                	j	80000a56 <uvmalloc+0x74>

0000000080000a8c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a8c:	7179                	addi	sp,sp,-48
    80000a8e:	f406                	sd	ra,40(sp)
    80000a90:	f022                	sd	s0,32(sp)
    80000a92:	ec26                	sd	s1,24(sp)
    80000a94:	e84a                	sd	s2,16(sp)
    80000a96:	e44e                	sd	s3,8(sp)
    80000a98:	e052                	sd	s4,0(sp)
    80000a9a:	1800                	addi	s0,sp,48
    80000a9c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a9e:	84aa                	mv	s1,a0
    80000aa0:	6905                	lui	s2,0x1
    80000aa2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000aa4:	4985                	li	s3,1
    80000aa6:	a821                	j	80000abe <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000aa8:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000aaa:	0532                	slli	a0,a0,0xc
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	fe0080e7          	jalr	-32(ra) # 80000a8c <freewalk>
      pagetable[i] = 0;
    80000ab4:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000ab8:	04a1                	addi	s1,s1,8
    80000aba:	03248163          	beq	s1,s2,80000adc <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000abe:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000ac0:	00f57793          	andi	a5,a0,15
    80000ac4:	ff3782e3          	beq	a5,s3,80000aa8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000ac8:	8905                	andi	a0,a0,1
    80000aca:	d57d                	beqz	a0,80000ab8 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000acc:	00007517          	auipc	a0,0x7
    80000ad0:	65450513          	addi	a0,a0,1620 # 80008120 <etext+0x120>
    80000ad4:	00005097          	auipc	ra,0x5
    80000ad8:	2b4080e7          	jalr	692(ra) # 80005d88 <panic>
    }
  }
  kfree((void*)pagetable);
    80000adc:	8552                	mv	a0,s4
    80000ade:	fffff097          	auipc	ra,0xfffff
    80000ae2:	53e080e7          	jalr	1342(ra) # 8000001c <kfree>
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6942                	ld	s2,16(sp)
    80000aee:	69a2                	ld	s3,8(sp)
    80000af0:	6a02                	ld	s4,0(sp)
    80000af2:	6145                	addi	sp,sp,48
    80000af4:	8082                	ret

0000000080000af6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000af6:	1101                	addi	sp,sp,-32
    80000af8:	ec06                	sd	ra,24(sp)
    80000afa:	e822                	sd	s0,16(sp)
    80000afc:	e426                	sd	s1,8(sp)
    80000afe:	1000                	addi	s0,sp,32
    80000b00:	84aa                	mv	s1,a0
  if(sz > 0)
    80000b02:	e999                	bnez	a1,80000b18 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000b04:	8526                	mv	a0,s1
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	f86080e7          	jalr	-122(ra) # 80000a8c <freewalk>
}
    80000b0e:	60e2                	ld	ra,24(sp)
    80000b10:	6442                	ld	s0,16(sp)
    80000b12:	64a2                	ld	s1,8(sp)
    80000b14:	6105                	addi	sp,sp,32
    80000b16:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000b18:	6605                	lui	a2,0x1
    80000b1a:	167d                	addi	a2,a2,-1
    80000b1c:	962e                	add	a2,a2,a1
    80000b1e:	4685                	li	a3,1
    80000b20:	8231                	srli	a2,a2,0xc
    80000b22:	4581                	li	a1,0
    80000b24:	00000097          	auipc	ra,0x0
    80000b28:	d12080e7          	jalr	-750(ra) # 80000836 <uvmunmap>
    80000b2c:	bfe1                	j	80000b04 <uvmfree+0xe>

0000000080000b2e <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b2e:	7139                	addi	sp,sp,-64
    80000b30:	fc06                	sd	ra,56(sp)
    80000b32:	f822                	sd	s0,48(sp)
    80000b34:	f426                	sd	s1,40(sp)
    80000b36:	f04a                	sd	s2,32(sp)
    80000b38:	ec4e                	sd	s3,24(sp)
    80000b3a:	e852                	sd	s4,16(sp)
    80000b3c:	e456                	sd	s5,8(sp)
    80000b3e:	e05a                	sd	s6,0(sp)
    80000b40:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;


  for(i = 0; i < sz; i += PGSIZE){
    80000b42:	c645                	beqz	a2,80000bea <uvmcopy+0xbc>
    80000b44:	8aaa                	mv	s5,a0
    80000b46:	8a2e                	mv	s4,a1
    80000b48:	89b2                	mv	s3,a2
    80000b4a:	4481                	li	s1,0
    if((pte = walk(old, i, 0)) == 0)
    80000b4c:	4601                	li	a2,0
    80000b4e:	85a6                	mv	a1,s1
    80000b50:	8556                	mv	a0,s5
    80000b52:	00000097          	auipc	ra,0x0
    80000b56:	a36080e7          	jalr	-1482(ra) # 80000588 <walk>
    80000b5a:	c139                	beqz	a0,80000ba0 <uvmcopy+0x72>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000b5c:	6118                	ld	a4,0(a0)
    80000b5e:	00177793          	andi	a5,a4,1
    80000b62:	c7b9                	beqz	a5,80000bb0 <uvmcopy+0x82>
    // if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    //   kfree(mem);
    //   goto err;
    // }

    pa = PTE2PA(*pte);
    80000b64:	00a75913          	srli	s2,a4,0xa
    80000b68:	0932                	slli	s2,s2,0xc
    *pte = (((*pte) & (~PTE_W)) | PTE_C);
    80000b6a:	efb77713          	andi	a4,a4,-261
    80000b6e:	10076713          	ori	a4,a4,256
    80000b72:	e118                	sd	a4,0(a0)
    flags = PTE_FLAGS(*pte);
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000b74:	3fb77713          	andi	a4,a4,1019
    80000b78:	86ca                	mv	a3,s2
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	85a6                	mv	a1,s1
    80000b7e:	8552                	mv	a0,s4
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	af0080e7          	jalr	-1296(ra) # 80000670 <mappages>
    80000b88:	8b2a                	mv	s6,a0
    80000b8a:	e91d                	bnez	a0,80000bc0 <uvmcopy+0x92>
      goto err;
    }
    addcnt((void *)pa);
    80000b8c:	854a                	mv	a0,s2
    80000b8e:	fffff097          	auipc	ra,0xfffff
    80000b92:	61c080e7          	jalr	1564(ra) # 800001aa <addcnt>
  for(i = 0; i < sz; i += PGSIZE){
    80000b96:	6785                	lui	a5,0x1
    80000b98:	94be                	add	s1,s1,a5
    80000b9a:	fb34e9e3          	bltu	s1,s3,80000b4c <uvmcopy+0x1e>
    80000b9e:	a81d                	j	80000bd4 <uvmcopy+0xa6>
      panic("uvmcopy: pte should exist");
    80000ba0:	00007517          	auipc	a0,0x7
    80000ba4:	59050513          	addi	a0,a0,1424 # 80008130 <etext+0x130>
    80000ba8:	00005097          	auipc	ra,0x5
    80000bac:	1e0080e7          	jalr	480(ra) # 80005d88 <panic>
      panic("uvmcopy: page not present");
    80000bb0:	00007517          	auipc	a0,0x7
    80000bb4:	5a050513          	addi	a0,a0,1440 # 80008150 <etext+0x150>
    80000bb8:	00005097          	auipc	ra,0x5
    80000bbc:	1d0080e7          	jalr	464(ra) # 80005d88 <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000bc0:	4685                	li	a3,1
    80000bc2:	00c4d613          	srli	a2,s1,0xc
    80000bc6:	4581                	li	a1,0
    80000bc8:	8552                	mv	a0,s4
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	c6c080e7          	jalr	-916(ra) # 80000836 <uvmunmap>
  return -1;
    80000bd2:	5b7d                	li	s6,-1
}
    80000bd4:	855a                	mv	a0,s6
    80000bd6:	70e2                	ld	ra,56(sp)
    80000bd8:	7442                	ld	s0,48(sp)
    80000bda:	74a2                	ld	s1,40(sp)
    80000bdc:	7902                	ld	s2,32(sp)
    80000bde:	69e2                	ld	s3,24(sp)
    80000be0:	6a42                	ld	s4,16(sp)
    80000be2:	6aa2                	ld	s5,8(sp)
    80000be4:	6b02                	ld	s6,0(sp)
    80000be6:	6121                	addi	sp,sp,64
    80000be8:	8082                	ret
  return 0;
    80000bea:	4b01                	li	s6,0
    80000bec:	b7e5                	j	80000bd4 <uvmcopy+0xa6>

0000000080000bee <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bee:	1141                	addi	sp,sp,-16
    80000bf0:	e406                	sd	ra,8(sp)
    80000bf2:	e022                	sd	s0,0(sp)
    80000bf4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bf6:	4601                	li	a2,0
    80000bf8:	00000097          	auipc	ra,0x0
    80000bfc:	990080e7          	jalr	-1648(ra) # 80000588 <walk>
  if(pte == 0)
    80000c00:	c901                	beqz	a0,80000c10 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c02:	611c                	ld	a5,0(a0)
    80000c04:	9bbd                	andi	a5,a5,-17
    80000c06:	e11c                	sd	a5,0(a0)
}
    80000c08:	60a2                	ld	ra,8(sp)
    80000c0a:	6402                	ld	s0,0(sp)
    80000c0c:	0141                	addi	sp,sp,16
    80000c0e:	8082                	ret
    panic("uvmclear");
    80000c10:	00007517          	auipc	a0,0x7
    80000c14:	56050513          	addi	a0,a0,1376 # 80008170 <etext+0x170>
    80000c18:	00005097          	auipc	ra,0x5
    80000c1c:	170080e7          	jalr	368(ra) # 80005d88 <panic>

0000000080000c20 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000c20:	c6bd                	beqz	a3,80000c8e <copyin+0x6e>
{
    80000c22:	715d                	addi	sp,sp,-80
    80000c24:	e486                	sd	ra,72(sp)
    80000c26:	e0a2                	sd	s0,64(sp)
    80000c28:	fc26                	sd	s1,56(sp)
    80000c2a:	f84a                	sd	s2,48(sp)
    80000c2c:	f44e                	sd	s3,40(sp)
    80000c2e:	f052                	sd	s4,32(sp)
    80000c30:	ec56                	sd	s5,24(sp)
    80000c32:	e85a                	sd	s6,16(sp)
    80000c34:	e45e                	sd	s7,8(sp)
    80000c36:	e062                	sd	s8,0(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8b2a                	mv	s6,a0
    80000c3c:	8a2e                	mv	s4,a1
    80000c3e:	8c32                	mv	s8,a2
    80000c40:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6a85                	lui	s5,0x1
    80000c46:	a015                	j	80000c6a <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c48:	9562                	add	a0,a0,s8
    80000c4a:	0004861b          	sext.w	a2,s1
    80000c4e:	412505b3          	sub	a1,a0,s2
    80000c52:	8552                	mv	a0,s4
    80000c54:	fffff097          	auipc	ra,0xfffff
    80000c58:	6ac080e7          	jalr	1708(ra) # 80000300 <memmove>

    len -= n;
    80000c5c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c60:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c62:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c66:	02098263          	beqz	s3,80000c8a <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c6a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c6e:	85ca                	mv	a1,s2
    80000c70:	855a                	mv	a0,s6
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	9bc080e7          	jalr	-1604(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000c7a:	cd01                	beqz	a0,80000c92 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c7c:	418904b3          	sub	s1,s2,s8
    80000c80:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c82:	fc99f3e3          	bgeu	s3,s1,80000c48 <copyin+0x28>
    80000c86:	84ce                	mv	s1,s3
    80000c88:	b7c1                	j	80000c48 <copyin+0x28>
  }
  return 0;
    80000c8a:	4501                	li	a0,0
    80000c8c:	a021                	j	80000c94 <copyin+0x74>
    80000c8e:	4501                	li	a0,0
}
    80000c90:	8082                	ret
      return -1;
    80000c92:	557d                	li	a0,-1
}
    80000c94:	60a6                	ld	ra,72(sp)
    80000c96:	6406                	ld	s0,64(sp)
    80000c98:	74e2                	ld	s1,56(sp)
    80000c9a:	7942                	ld	s2,48(sp)
    80000c9c:	79a2                	ld	s3,40(sp)
    80000c9e:	7a02                	ld	s4,32(sp)
    80000ca0:	6ae2                	ld	s5,24(sp)
    80000ca2:	6b42                	ld	s6,16(sp)
    80000ca4:	6ba2                	ld	s7,8(sp)
    80000ca6:	6c02                	ld	s8,0(sp)
    80000ca8:	6161                	addi	sp,sp,80
    80000caa:	8082                	ret

0000000080000cac <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000cac:	c6c5                	beqz	a3,80000d54 <copyinstr+0xa8>
{
    80000cae:	715d                	addi	sp,sp,-80
    80000cb0:	e486                	sd	ra,72(sp)
    80000cb2:	e0a2                	sd	s0,64(sp)
    80000cb4:	fc26                	sd	s1,56(sp)
    80000cb6:	f84a                	sd	s2,48(sp)
    80000cb8:	f44e                	sd	s3,40(sp)
    80000cba:	f052                	sd	s4,32(sp)
    80000cbc:	ec56                	sd	s5,24(sp)
    80000cbe:	e85a                	sd	s6,16(sp)
    80000cc0:	e45e                	sd	s7,8(sp)
    80000cc2:	0880                	addi	s0,sp,80
    80000cc4:	8a2a                	mv	s4,a0
    80000cc6:	8b2e                	mv	s6,a1
    80000cc8:	8bb2                	mv	s7,a2
    80000cca:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ccc:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000cce:	6985                	lui	s3,0x1
    80000cd0:	a035                	j	80000cfc <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cd2:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cd6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ce0:	60a6                	ld	ra,72(sp)
    80000ce2:	6406                	ld	s0,64(sp)
    80000ce4:	74e2                	ld	s1,56(sp)
    80000ce6:	7942                	ld	s2,48(sp)
    80000ce8:	79a2                	ld	s3,40(sp)
    80000cea:	7a02                	ld	s4,32(sp)
    80000cec:	6ae2                	ld	s5,24(sp)
    80000cee:	6b42                	ld	s6,16(sp)
    80000cf0:	6ba2                	ld	s7,8(sp)
    80000cf2:	6161                	addi	sp,sp,80
    80000cf4:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cf6:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cfa:	c8a9                	beqz	s1,80000d4c <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cfc:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000d00:	85ca                	mv	a1,s2
    80000d02:	8552                	mv	a0,s4
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	92a080e7          	jalr	-1750(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000d0c:	c131                	beqz	a0,80000d50 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000d0e:	41790833          	sub	a6,s2,s7
    80000d12:	984e                	add	a6,a6,s3
    if(n > max)
    80000d14:	0104f363          	bgeu	s1,a6,80000d1a <copyinstr+0x6e>
    80000d18:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000d1a:	955e                	add	a0,a0,s7
    80000d1c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000d20:	fc080be3          	beqz	a6,80000cf6 <copyinstr+0x4a>
    80000d24:	985a                	add	a6,a6,s6
    80000d26:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d28:	41650633          	sub	a2,a0,s6
    80000d2c:	14fd                	addi	s1,s1,-1
    80000d2e:	9b26                	add	s6,s6,s1
    80000d30:	00f60733          	add	a4,a2,a5
    80000d34:	00074703          	lbu	a4,0(a4)
    80000d38:	df49                	beqz	a4,80000cd2 <copyinstr+0x26>
        *dst = *p;
    80000d3a:	00e78023          	sb	a4,0(a5)
      --max;
    80000d3e:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d42:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d44:	ff0796e3          	bne	a5,a6,80000d30 <copyinstr+0x84>
      dst++;
    80000d48:	8b42                	mv	s6,a6
    80000d4a:	b775                	j	80000cf6 <copyinstr+0x4a>
    80000d4c:	4781                	li	a5,0
    80000d4e:	b769                	j	80000cd8 <copyinstr+0x2c>
      return -1;
    80000d50:	557d                	li	a0,-1
    80000d52:	b779                	j	80000ce0 <copyinstr+0x34>
  int got_null = 0;
    80000d54:	4781                	li	a5,0
  if(got_null){
    80000d56:	0017b793          	seqz	a5,a5
    80000d5a:	40f00533          	neg	a0,a5
}
    80000d5e:	8082                	ret

0000000080000d60 <if_cow>:

int
if_cow(pagetable_t pagetable, uint64 va)
{
  if(va >= MAXVA)
    80000d60:	57fd                	li	a5,-1
    80000d62:	83e9                	srli	a5,a5,0x1a
    80000d64:	00b7f463          	bgeu	a5,a1,80000d6c <if_cow+0xc>
    return 0;
    80000d68:	4501                	li	a0,0
    return 1;
  }
  else{
    return 0;
  }
}
    80000d6a:	8082                	ret
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e406                	sd	ra,8(sp)
    80000d70:	e022                	sd	s0,0(sp)
    80000d72:	0800                	addi	s0,sp,16
  if((pte = walk(pagetable, va, 0)) == 0)
    80000d74:	4601                	li	a2,0
    80000d76:	77fd                	lui	a5,0xfffff
    80000d78:	8dfd                	and	a1,a1,a5
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	80e080e7          	jalr	-2034(ra) # 80000588 <walk>
    80000d82:	c105                	beqz	a0,80000da2 <if_cow+0x42>
  if((*pte & PTE_V) == 0)
    80000d84:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000d86:	0117f693          	andi	a3,a5,17
    80000d8a:	4745                	li	a4,17
    return 0;
    80000d8c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000d8e:	00e68663          	beq	a3,a4,80000d9a <if_cow+0x3a>
}
    80000d92:	60a2                	ld	ra,8(sp)
    80000d94:	6402                	ld	s0,0(sp)
    80000d96:	0141                	addi	sp,sp,16
    80000d98:	8082                	ret
  if((*pte) & PTE_C)
    80000d9a:	0087d513          	srli	a0,a5,0x8
    return 0;
    80000d9e:	8905                	andi	a0,a0,1
    80000da0:	bfcd                	j	80000d92 <if_cow+0x32>
    return 0;
    80000da2:	4501                	li	a0,0
    80000da4:	b7fd                	j	80000d92 <if_cow+0x32>

0000000080000da6 <cow>:

int
cow(pagetable_t pagetable, uint64 va)
{
    80000da6:	7139                	addi	sp,sp,-64
    80000da8:	fc06                	sd	ra,56(sp)
    80000daa:	f822                	sd	s0,48(sp)
    80000dac:	f426                	sd	s1,40(sp)
    80000dae:	f04a                	sd	s2,32(sp)
    80000db0:	ec4e                	sd	s3,24(sp)
    80000db2:	e852                	sd	s4,16(sp)
    80000db4:	e456                	sd	s5,8(sp)
    80000db6:	0080                	addi	s0,sp,64
    80000db8:	8a2a                	mv	s4,a0
  va = PGROUNDDOWN(va);
    80000dba:	79fd                	lui	s3,0xfffff
    80000dbc:	0135f9b3          	and	s3,a1,s3
  pte_t *pte = walk(pagetable,va,0);
    80000dc0:	4601                	li	a2,0
    80000dc2:	85ce                	mv	a1,s3
    80000dc4:	fffff097          	auipc	ra,0xfffff
    80000dc8:	7c4080e7          	jalr	1988(ra) # 80000588 <walk>

  int flag = PTE_FLAGS(*pte);
    80000dcc:	611c                	ld	a5,0(a0)
    80000dce:	00078a9b          	sext.w	s5,a5
  uint64 pa = PTE2PA(*pte);
    80000dd2:	83a9                	srli	a5,a5,0xa
    80000dd4:	00c79493          	slli	s1,a5,0xc

  char *mem = kalloc();
    80000dd8:	fffff097          	auipc	ra,0xfffff
    80000ddc:	31e080e7          	jalr	798(ra) # 800000f6 <kalloc>
  if(mem == 0)
    80000de0:	cd29                	beqz	a0,80000e3a <cow+0x94>
    80000de2:	892a                	mv	s2,a0
  {
    return -1;
  }
  memmove(mem, (char*)pa, PGSIZE);
    80000de4:	6605                	lui	a2,0x1
    80000de6:	85a6                	mv	a1,s1
    80000de8:	fffff097          	auipc	ra,0xfffff
    80000dec:	518080e7          	jalr	1304(ra) # 80000300 <memmove>
  // *pte = 0;
  // kfree((void *)pa);
  uvmunmap(pagetable, va, 1, 1);
    80000df0:	4685                	li	a3,1
    80000df2:	4605                	li	a2,1
    80000df4:	85ce                	mv	a1,s3
    80000df6:	8552                	mv	a0,s4
    80000df8:	00000097          	auipc	ra,0x0
    80000dfc:	a3e080e7          	jalr	-1474(ra) # 80000836 <uvmunmap>

  //保留原来的权限不改变
  flag = ((flag & (~PTE_C)) | PTE_W);
    80000e00:	2fbaf713          	andi	a4,s5,763

  if(mappages(pagetable, va, PGSIZE, (uint64)mem, flag) != 0)
    80000e04:	00476713          	ori	a4,a4,4
    80000e08:	86ca                	mv	a3,s2
    80000e0a:	6605                	lui	a2,0x1
    80000e0c:	85ce                	mv	a1,s3
    80000e0e:	8552                	mv	a0,s4
    80000e10:	00000097          	auipc	ra,0x0
    80000e14:	860080e7          	jalr	-1952(ra) # 80000670 <mappages>
    80000e18:	e911                	bnez	a0,80000e2c <cow+0x86>
  }
  // pte_t *pte = walk(p->pagetable, va, 0);
  // printf("pte : %p", *pte);

  return 0;
    80000e1a:	70e2                	ld	ra,56(sp)
    80000e1c:	7442                	ld	s0,48(sp)
    80000e1e:	74a2                	ld	s1,40(sp)
    80000e20:	7902                	ld	s2,32(sp)
    80000e22:	69e2                	ld	s3,24(sp)
    80000e24:	6a42                	ld	s4,16(sp)
    80000e26:	6aa2                	ld	s5,8(sp)
    80000e28:	6121                	addi	sp,sp,64
    80000e2a:	8082                	ret
    kfree(mem);
    80000e2c:	854a                	mv	a0,s2
    80000e2e:	fffff097          	auipc	ra,0xfffff
    80000e32:	1ee080e7          	jalr	494(ra) # 8000001c <kfree>
    return -1;
    80000e36:	557d                	li	a0,-1
    80000e38:	b7cd                	j	80000e1a <cow+0x74>
    return -1;
    80000e3a:	557d                	li	a0,-1
    80000e3c:	bff9                	j	80000e1a <cow+0x74>

0000000080000e3e <copyout>:
  while(len > 0){
    80000e3e:	c6d1                	beqz	a3,80000eca <copyout+0x8c>
{
    80000e40:	715d                	addi	sp,sp,-80
    80000e42:	e486                	sd	ra,72(sp)
    80000e44:	e0a2                	sd	s0,64(sp)
    80000e46:	fc26                	sd	s1,56(sp)
    80000e48:	f84a                	sd	s2,48(sp)
    80000e4a:	f44e                	sd	s3,40(sp)
    80000e4c:	f052                	sd	s4,32(sp)
    80000e4e:	ec56                	sd	s5,24(sp)
    80000e50:	e85a                	sd	s6,16(sp)
    80000e52:	e45e                	sd	s7,8(sp)
    80000e54:	e062                	sd	s8,0(sp)
    80000e56:	0880                	addi	s0,sp,80
    80000e58:	8b2a                	mv	s6,a0
    80000e5a:	89ae                	mv	s3,a1
    80000e5c:	8ab2                	mv	s5,a2
    80000e5e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000e60:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (dstva - va0);
    80000e62:	6b85                	lui	s7,0x1
    80000e64:	a015                	j	80000e88 <copyout+0x4a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000e66:	412989b3          	sub	s3,s3,s2
    80000e6a:	0004861b          	sext.w	a2,s1
    80000e6e:	85d6                	mv	a1,s5
    80000e70:	954e                	add	a0,a0,s3
    80000e72:	fffff097          	auipc	ra,0xfffff
    80000e76:	48e080e7          	jalr	1166(ra) # 80000300 <memmove>
    len -= n;
    80000e7a:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000e7e:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000e80:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80000e84:	040a0163          	beqz	s4,80000ec6 <copyout+0x88>
    va0 = PGROUNDDOWN(dstva);
    80000e88:	0189f933          	and	s2,s3,s8
    if(if_cow(pagetable , va0))
    80000e8c:	85ca                	mv	a1,s2
    80000e8e:	855a                	mv	a0,s6
    80000e90:	00000097          	auipc	ra,0x0
    80000e94:	ed0080e7          	jalr	-304(ra) # 80000d60 <if_cow>
    80000e98:	c909                	beqz	a0,80000eaa <copyout+0x6c>
      if(cow(pagetable, va0) < 0){
    80000e9a:	85ca                	mv	a1,s2
    80000e9c:	855a                	mv	a0,s6
    80000e9e:	00000097          	auipc	ra,0x0
    80000ea2:	f08080e7          	jalr	-248(ra) # 80000da6 <cow>
    80000ea6:	02054463          	bltz	a0,80000ece <copyout+0x90>
    pa0 = walkaddr(pagetable, va0);
    80000eaa:	85ca                	mv	a1,s2
    80000eac:	855a                	mv	a0,s6
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	780080e7          	jalr	1920(ra) # 8000062e <walkaddr>
    if(pa0 == 0)
    80000eb6:	cd11                	beqz	a0,80000ed2 <copyout+0x94>
    n = PGSIZE - (dstva - va0);
    80000eb8:	413904b3          	sub	s1,s2,s3
    80000ebc:	94de                	add	s1,s1,s7
    if(n > len)
    80000ebe:	fa9a74e3          	bgeu	s4,s1,80000e66 <copyout+0x28>
    80000ec2:	84d2                	mv	s1,s4
    80000ec4:	b74d                	j	80000e66 <copyout+0x28>
  return 0;
    80000ec6:	4501                	li	a0,0
    80000ec8:	a031                	j	80000ed4 <copyout+0x96>
    80000eca:	4501                	li	a0,0
}
    80000ecc:	8082                	ret
        return -1;
    80000ece:	557d                	li	a0,-1
    80000ed0:	a011                	j	80000ed4 <copyout+0x96>
      return -1;
    80000ed2:	557d                	li	a0,-1
}
    80000ed4:	60a6                	ld	ra,72(sp)
    80000ed6:	6406                	ld	s0,64(sp)
    80000ed8:	74e2                	ld	s1,56(sp)
    80000eda:	7942                	ld	s2,48(sp)
    80000edc:	79a2                	ld	s3,40(sp)
    80000ede:	7a02                	ld	s4,32(sp)
    80000ee0:	6ae2                	ld	s5,24(sp)
    80000ee2:	6b42                	ld	s6,16(sp)
    80000ee4:	6ba2                	ld	s7,8(sp)
    80000ee6:	6c02                	ld	s8,0(sp)
    80000ee8:	6161                	addi	sp,sp,80
    80000eea:	8082                	ret

0000000080000eec <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000eec:	7139                	addi	sp,sp,-64
    80000eee:	fc06                	sd	ra,56(sp)
    80000ef0:	f822                	sd	s0,48(sp)
    80000ef2:	f426                	sd	s1,40(sp)
    80000ef4:	f04a                	sd	s2,32(sp)
    80000ef6:	ec4e                	sd	s3,24(sp)
    80000ef8:	e852                	sd	s4,16(sp)
    80000efa:	e456                	sd	s5,8(sp)
    80000efc:	e05a                	sd	s6,0(sp)
    80000efe:	0080                	addi	s0,sp,64
    80000f00:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f02:	00228497          	auipc	s1,0x228
    80000f06:	59648493          	addi	s1,s1,1430 # 80229498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f0a:	8b26                	mv	s6,s1
    80000f0c:	00007a97          	auipc	s5,0x7
    80000f10:	0f4a8a93          	addi	s5,s5,244 # 80008000 <etext>
    80000f14:	04000937          	lui	s2,0x4000
    80000f18:	197d                	addi	s2,s2,-1
    80000f1a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f1c:	0022ea17          	auipc	s4,0x22e
    80000f20:	f7ca0a13          	addi	s4,s4,-132 # 8022ee98 <tickslock>
    char *pa = kalloc();
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	1d2080e7          	jalr	466(ra) # 800000f6 <kalloc>
    80000f2c:	862a                	mv	a2,a0
    if(pa == 0)
    80000f2e:	c131                	beqz	a0,80000f72 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f30:	416485b3          	sub	a1,s1,s6
    80000f34:	858d                	srai	a1,a1,0x3
    80000f36:	000ab783          	ld	a5,0(s5)
    80000f3a:	02f585b3          	mul	a1,a1,a5
    80000f3e:	2585                	addiw	a1,a1,1
    80000f40:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f44:	4719                	li	a4,6
    80000f46:	6685                	lui	a3,0x1
    80000f48:	40b905b3          	sub	a1,s2,a1
    80000f4c:	854e                	mv	a0,s3
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	7c2080e7          	jalr	1986(ra) # 80000710 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f56:	16848493          	addi	s1,s1,360
    80000f5a:	fd4495e3          	bne	s1,s4,80000f24 <proc_mapstacks+0x38>
  }
}
    80000f5e:	70e2                	ld	ra,56(sp)
    80000f60:	7442                	ld	s0,48(sp)
    80000f62:	74a2                	ld	s1,40(sp)
    80000f64:	7902                	ld	s2,32(sp)
    80000f66:	69e2                	ld	s3,24(sp)
    80000f68:	6a42                	ld	s4,16(sp)
    80000f6a:	6aa2                	ld	s5,8(sp)
    80000f6c:	6b02                	ld	s6,0(sp)
    80000f6e:	6121                	addi	sp,sp,64
    80000f70:	8082                	ret
      panic("kalloc");
    80000f72:	00007517          	auipc	a0,0x7
    80000f76:	20e50513          	addi	a0,a0,526 # 80008180 <etext+0x180>
    80000f7a:	00005097          	auipc	ra,0x5
    80000f7e:	e0e080e7          	jalr	-498(ra) # 80005d88 <panic>

0000000080000f82 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f82:	7139                	addi	sp,sp,-64
    80000f84:	fc06                	sd	ra,56(sp)
    80000f86:	f822                	sd	s0,48(sp)
    80000f88:	f426                	sd	s1,40(sp)
    80000f8a:	f04a                	sd	s2,32(sp)
    80000f8c:	ec4e                	sd	s3,24(sp)
    80000f8e:	e852                	sd	s4,16(sp)
    80000f90:	e456                	sd	s5,8(sp)
    80000f92:	e05a                	sd	s6,0(sp)
    80000f94:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f96:	00007597          	auipc	a1,0x7
    80000f9a:	1f258593          	addi	a1,a1,498 # 80008188 <etext+0x188>
    80000f9e:	00228517          	auipc	a0,0x228
    80000fa2:	0ca50513          	addi	a0,a0,202 # 80229068 <pid_lock>
    80000fa6:	00005097          	auipc	ra,0x5
    80000faa:	29c080e7          	jalr	668(ra) # 80006242 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fae:	00007597          	auipc	a1,0x7
    80000fb2:	1e258593          	addi	a1,a1,482 # 80008190 <etext+0x190>
    80000fb6:	00228517          	auipc	a0,0x228
    80000fba:	0ca50513          	addi	a0,a0,202 # 80229080 <wait_lock>
    80000fbe:	00005097          	auipc	ra,0x5
    80000fc2:	284080e7          	jalr	644(ra) # 80006242 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc6:	00228497          	auipc	s1,0x228
    80000fca:	4d248493          	addi	s1,s1,1234 # 80229498 <proc>
      initlock(&p->lock, "proc");
    80000fce:	00007b17          	auipc	s6,0x7
    80000fd2:	1d2b0b13          	addi	s6,s6,466 # 800081a0 <etext+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    80000fd6:	8aa6                	mv	s5,s1
    80000fd8:	00007a17          	auipc	s4,0x7
    80000fdc:	028a0a13          	addi	s4,s4,40 # 80008000 <etext>
    80000fe0:	04000937          	lui	s2,0x4000
    80000fe4:	197d                	addi	s2,s2,-1
    80000fe6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe8:	0022e997          	auipc	s3,0x22e
    80000fec:	eb098993          	addi	s3,s3,-336 # 8022ee98 <tickslock>
      initlock(&p->lock, "proc");
    80000ff0:	85da                	mv	a1,s6
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	00005097          	auipc	ra,0x5
    80000ff8:	24e080e7          	jalr	590(ra) # 80006242 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000ffc:	415487b3          	sub	a5,s1,s5
    80001000:	878d                	srai	a5,a5,0x3
    80001002:	000a3703          	ld	a4,0(s4)
    80001006:	02e787b3          	mul	a5,a5,a4
    8000100a:	2785                	addiw	a5,a5,1
    8000100c:	00d7979b          	slliw	a5,a5,0xd
    80001010:	40f907b3          	sub	a5,s2,a5
    80001014:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001016:	16848493          	addi	s1,s1,360
    8000101a:	fd349be3          	bne	s1,s3,80000ff0 <procinit+0x6e>
  }
}
    8000101e:	70e2                	ld	ra,56(sp)
    80001020:	7442                	ld	s0,48(sp)
    80001022:	74a2                	ld	s1,40(sp)
    80001024:	7902                	ld	s2,32(sp)
    80001026:	69e2                	ld	s3,24(sp)
    80001028:	6a42                	ld	s4,16(sp)
    8000102a:	6aa2                	ld	s5,8(sp)
    8000102c:	6b02                	ld	s6,0(sp)
    8000102e:	6121                	addi	sp,sp,64
    80001030:	8082                	ret

0000000080001032 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e422                	sd	s0,8(sp)
    80001036:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001038:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000103a:	2501                	sext.w	a0,a0
    8000103c:	6422                	ld	s0,8(sp)
    8000103e:	0141                	addi	sp,sp,16
    80001040:	8082                	ret

0000000080001042 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001042:	1141                	addi	sp,sp,-16
    80001044:	e422                	sd	s0,8(sp)
    80001046:	0800                	addi	s0,sp,16
    80001048:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000104a:	2781                	sext.w	a5,a5
    8000104c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000104e:	00228517          	auipc	a0,0x228
    80001052:	04a50513          	addi	a0,a0,74 # 80229098 <cpus>
    80001056:	953e                	add	a0,a0,a5
    80001058:	6422                	ld	s0,8(sp)
    8000105a:	0141                	addi	sp,sp,16
    8000105c:	8082                	ret

000000008000105e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	1000                	addi	s0,sp,32
  push_off();
    80001068:	00005097          	auipc	ra,0x5
    8000106c:	21e080e7          	jalr	542(ra) # 80006286 <push_off>
    80001070:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001072:	2781                	sext.w	a5,a5
    80001074:	079e                	slli	a5,a5,0x7
    80001076:	00228717          	auipc	a4,0x228
    8000107a:	ff270713          	addi	a4,a4,-14 # 80229068 <pid_lock>
    8000107e:	97ba                	add	a5,a5,a4
    80001080:	7b84                	ld	s1,48(a5)
  pop_off();
    80001082:	00005097          	auipc	ra,0x5
    80001086:	2a4080e7          	jalr	676(ra) # 80006326 <pop_off>
  return p;
}
    8000108a:	8526                	mv	a0,s1
    8000108c:	60e2                	ld	ra,24(sp)
    8000108e:	6442                	ld	s0,16(sp)
    80001090:	64a2                	ld	s1,8(sp)
    80001092:	6105                	addi	sp,sp,32
    80001094:	8082                	ret

0000000080001096 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001096:	1141                	addi	sp,sp,-16
    80001098:	e406                	sd	ra,8(sp)
    8000109a:	e022                	sd	s0,0(sp)
    8000109c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000109e:	00000097          	auipc	ra,0x0
    800010a2:	fc0080e7          	jalr	-64(ra) # 8000105e <myproc>
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	2e0080e7          	jalr	736(ra) # 80006386 <release>

  if (first) {
    800010ae:	00007797          	auipc	a5,0x7
    800010b2:	7b27a783          	lw	a5,1970(a5) # 80008860 <first.1680>
    800010b6:	eb89                	bnez	a5,800010c8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010b8:	00001097          	auipc	ra,0x1
    800010bc:	c0a080e7          	jalr	-1014(ra) # 80001cc2 <usertrapret>
}
    800010c0:	60a2                	ld	ra,8(sp)
    800010c2:	6402                	ld	s0,0(sp)
    800010c4:	0141                	addi	sp,sp,16
    800010c6:	8082                	ret
    first = 0;
    800010c8:	00007797          	auipc	a5,0x7
    800010cc:	7807ac23          	sw	zero,1944(a5) # 80008860 <first.1680>
    fsinit(ROOTDEV);
    800010d0:	4505                	li	a0,1
    800010d2:	00002097          	auipc	ra,0x2
    800010d6:	98a080e7          	jalr	-1654(ra) # 80002a5c <fsinit>
    800010da:	bff9                	j	800010b8 <forkret+0x22>

00000000800010dc <allocpid>:
allocpid() {
    800010dc:	1101                	addi	sp,sp,-32
    800010de:	ec06                	sd	ra,24(sp)
    800010e0:	e822                	sd	s0,16(sp)
    800010e2:	e426                	sd	s1,8(sp)
    800010e4:	e04a                	sd	s2,0(sp)
    800010e6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010e8:	00228917          	auipc	s2,0x228
    800010ec:	f8090913          	addi	s2,s2,-128 # 80229068 <pid_lock>
    800010f0:	854a                	mv	a0,s2
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	1e0080e7          	jalr	480(ra) # 800062d2 <acquire>
  pid = nextpid;
    800010fa:	00007797          	auipc	a5,0x7
    800010fe:	76a78793          	addi	a5,a5,1898 # 80008864 <nextpid>
    80001102:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001104:	0014871b          	addiw	a4,s1,1
    80001108:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000110a:	854a                	mv	a0,s2
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	27a080e7          	jalr	634(ra) # 80006386 <release>
}
    80001114:	8526                	mv	a0,s1
    80001116:	60e2                	ld	ra,24(sp)
    80001118:	6442                	ld	s0,16(sp)
    8000111a:	64a2                	ld	s1,8(sp)
    8000111c:	6902                	ld	s2,0(sp)
    8000111e:	6105                	addi	sp,sp,32
    80001120:	8082                	ret

0000000080001122 <proc_pagetable>:
{
    80001122:	1101                	addi	sp,sp,-32
    80001124:	ec06                	sd	ra,24(sp)
    80001126:	e822                	sd	s0,16(sp)
    80001128:	e426                	sd	s1,8(sp)
    8000112a:	e04a                	sd	s2,0(sp)
    8000112c:	1000                	addi	s0,sp,32
    8000112e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001130:	fffff097          	auipc	ra,0xfffff
    80001134:	7ca080e7          	jalr	1994(ra) # 800008fa <uvmcreate>
    80001138:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000113a:	c121                	beqz	a0,8000117a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000113c:	4729                	li	a4,10
    8000113e:	00006697          	auipc	a3,0x6
    80001142:	ec268693          	addi	a3,a3,-318 # 80007000 <_trampoline>
    80001146:	6605                	lui	a2,0x1
    80001148:	040005b7          	lui	a1,0x4000
    8000114c:	15fd                	addi	a1,a1,-1
    8000114e:	05b2                	slli	a1,a1,0xc
    80001150:	fffff097          	auipc	ra,0xfffff
    80001154:	520080e7          	jalr	1312(ra) # 80000670 <mappages>
    80001158:	02054863          	bltz	a0,80001188 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000115c:	4719                	li	a4,6
    8000115e:	05893683          	ld	a3,88(s2)
    80001162:	6605                	lui	a2,0x1
    80001164:	020005b7          	lui	a1,0x2000
    80001168:	15fd                	addi	a1,a1,-1
    8000116a:	05b6                	slli	a1,a1,0xd
    8000116c:	8526                	mv	a0,s1
    8000116e:	fffff097          	auipc	ra,0xfffff
    80001172:	502080e7          	jalr	1282(ra) # 80000670 <mappages>
    80001176:	02054163          	bltz	a0,80001198 <proc_pagetable+0x76>
}
    8000117a:	8526                	mv	a0,s1
    8000117c:	60e2                	ld	ra,24(sp)
    8000117e:	6442                	ld	s0,16(sp)
    80001180:	64a2                	ld	s1,8(sp)
    80001182:	6902                	ld	s2,0(sp)
    80001184:	6105                	addi	sp,sp,32
    80001186:	8082                	ret
    uvmfree(pagetable, 0);
    80001188:	4581                	li	a1,0
    8000118a:	8526                	mv	a0,s1
    8000118c:	00000097          	auipc	ra,0x0
    80001190:	96a080e7          	jalr	-1686(ra) # 80000af6 <uvmfree>
    return 0;
    80001194:	4481                	li	s1,0
    80001196:	b7d5                	j	8000117a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001198:	4681                	li	a3,0
    8000119a:	4605                	li	a2,1
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15fd                	addi	a1,a1,-1
    800011a2:	05b2                	slli	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	690080e7          	jalr	1680(ra) # 80000836 <uvmunmap>
    uvmfree(pagetable, 0);
    800011ae:	4581                	li	a1,0
    800011b0:	8526                	mv	a0,s1
    800011b2:	00000097          	auipc	ra,0x0
    800011b6:	944080e7          	jalr	-1724(ra) # 80000af6 <uvmfree>
    return 0;
    800011ba:	4481                	li	s1,0
    800011bc:	bf7d                	j	8000117a <proc_pagetable+0x58>

00000000800011be <proc_freepagetable>:
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	e04a                	sd	s2,0(sp)
    800011c8:	1000                	addi	s0,sp,32
    800011ca:	84aa                	mv	s1,a0
    800011cc:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ce:	4681                	li	a3,0
    800011d0:	4605                	li	a2,1
    800011d2:	040005b7          	lui	a1,0x4000
    800011d6:	15fd                	addi	a1,a1,-1
    800011d8:	05b2                	slli	a1,a1,0xc
    800011da:	fffff097          	auipc	ra,0xfffff
    800011de:	65c080e7          	jalr	1628(ra) # 80000836 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011e2:	4681                	li	a3,0
    800011e4:	4605                	li	a2,1
    800011e6:	020005b7          	lui	a1,0x2000
    800011ea:	15fd                	addi	a1,a1,-1
    800011ec:	05b6                	slli	a1,a1,0xd
    800011ee:	8526                	mv	a0,s1
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	646080e7          	jalr	1606(ra) # 80000836 <uvmunmap>
  uvmfree(pagetable, sz);
    800011f8:	85ca                	mv	a1,s2
    800011fa:	8526                	mv	a0,s1
    800011fc:	00000097          	auipc	ra,0x0
    80001200:	8fa080e7          	jalr	-1798(ra) # 80000af6 <uvmfree>
}
    80001204:	60e2                	ld	ra,24(sp)
    80001206:	6442                	ld	s0,16(sp)
    80001208:	64a2                	ld	s1,8(sp)
    8000120a:	6902                	ld	s2,0(sp)
    8000120c:	6105                	addi	sp,sp,32
    8000120e:	8082                	ret

0000000080001210 <freeproc>:
{
    80001210:	1101                	addi	sp,sp,-32
    80001212:	ec06                	sd	ra,24(sp)
    80001214:	e822                	sd	s0,16(sp)
    80001216:	e426                	sd	s1,8(sp)
    80001218:	1000                	addi	s0,sp,32
    8000121a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000121c:	6d28                	ld	a0,88(a0)
    8000121e:	c509                	beqz	a0,80001228 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	dfc080e7          	jalr	-516(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001228:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000122c:	68a8                	ld	a0,80(s1)
    8000122e:	c511                	beqz	a0,8000123a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001230:	64ac                	ld	a1,72(s1)
    80001232:	00000097          	auipc	ra,0x0
    80001236:	f8c080e7          	jalr	-116(ra) # 800011be <proc_freepagetable>
  p->pagetable = 0;
    8000123a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000123e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001242:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001246:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000124a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000124e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001252:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001256:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000125a:	0004ac23          	sw	zero,24(s1)
}
    8000125e:	60e2                	ld	ra,24(sp)
    80001260:	6442                	ld	s0,16(sp)
    80001262:	64a2                	ld	s1,8(sp)
    80001264:	6105                	addi	sp,sp,32
    80001266:	8082                	ret

0000000080001268 <allocproc>:
{
    80001268:	1101                	addi	sp,sp,-32
    8000126a:	ec06                	sd	ra,24(sp)
    8000126c:	e822                	sd	s0,16(sp)
    8000126e:	e426                	sd	s1,8(sp)
    80001270:	e04a                	sd	s2,0(sp)
    80001272:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001274:	00228497          	auipc	s1,0x228
    80001278:	22448493          	addi	s1,s1,548 # 80229498 <proc>
    8000127c:	0022e917          	auipc	s2,0x22e
    80001280:	c1c90913          	addi	s2,s2,-996 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001284:	8526                	mv	a0,s1
    80001286:	00005097          	auipc	ra,0x5
    8000128a:	04c080e7          	jalr	76(ra) # 800062d2 <acquire>
    if(p->state == UNUSED) {
    8000128e:	4c9c                	lw	a5,24(s1)
    80001290:	cf81                	beqz	a5,800012a8 <allocproc+0x40>
      release(&p->lock);
    80001292:	8526                	mv	a0,s1
    80001294:	00005097          	auipc	ra,0x5
    80001298:	0f2080e7          	jalr	242(ra) # 80006386 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000129c:	16848493          	addi	s1,s1,360
    800012a0:	ff2492e3          	bne	s1,s2,80001284 <allocproc+0x1c>
  return 0;
    800012a4:	4481                	li	s1,0
    800012a6:	a889                	j	800012f8 <allocproc+0x90>
  p->pid = allocpid();
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	e34080e7          	jalr	-460(ra) # 800010dc <allocpid>
    800012b0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012b2:	4785                	li	a5,1
    800012b4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012b6:	fffff097          	auipc	ra,0xfffff
    800012ba:	e40080e7          	jalr	-448(ra) # 800000f6 <kalloc>
    800012be:	892a                	mv	s2,a0
    800012c0:	eca8                	sd	a0,88(s1)
    800012c2:	c131                	beqz	a0,80001306 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00000097          	auipc	ra,0x0
    800012ca:	e5c080e7          	jalr	-420(ra) # 80001122 <proc_pagetable>
    800012ce:	892a                	mv	s2,a0
    800012d0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012d2:	c531                	beqz	a0,8000131e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012d4:	07000613          	li	a2,112
    800012d8:	4581                	li	a1,0
    800012da:	06048513          	addi	a0,s1,96
    800012de:	fffff097          	auipc	ra,0xfffff
    800012e2:	fc2080e7          	jalr	-62(ra) # 800002a0 <memset>
  p->context.ra = (uint64)forkret;
    800012e6:	00000797          	auipc	a5,0x0
    800012ea:	db078793          	addi	a5,a5,-592 # 80001096 <forkret>
    800012ee:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012f0:	60bc                	ld	a5,64(s1)
    800012f2:	6705                	lui	a4,0x1
    800012f4:	97ba                	add	a5,a5,a4
    800012f6:	f4bc                	sd	a5,104(s1)
}
    800012f8:	8526                	mv	a0,s1
    800012fa:	60e2                	ld	ra,24(sp)
    800012fc:	6442                	ld	s0,16(sp)
    800012fe:	64a2                	ld	s1,8(sp)
    80001300:	6902                	ld	s2,0(sp)
    80001302:	6105                	addi	sp,sp,32
    80001304:	8082                	ret
    freeproc(p);
    80001306:	8526                	mv	a0,s1
    80001308:	00000097          	auipc	ra,0x0
    8000130c:	f08080e7          	jalr	-248(ra) # 80001210 <freeproc>
    release(&p->lock);
    80001310:	8526                	mv	a0,s1
    80001312:	00005097          	auipc	ra,0x5
    80001316:	074080e7          	jalr	116(ra) # 80006386 <release>
    return 0;
    8000131a:	84ca                	mv	s1,s2
    8000131c:	bff1                	j	800012f8 <allocproc+0x90>
    freeproc(p);
    8000131e:	8526                	mv	a0,s1
    80001320:	00000097          	auipc	ra,0x0
    80001324:	ef0080e7          	jalr	-272(ra) # 80001210 <freeproc>
    release(&p->lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	05c080e7          	jalr	92(ra) # 80006386 <release>
    return 0;
    80001332:	84ca                	mv	s1,s2
    80001334:	b7d1                	j	800012f8 <allocproc+0x90>

0000000080001336 <userinit>:
{
    80001336:	1101                	addi	sp,sp,-32
    80001338:	ec06                	sd	ra,24(sp)
    8000133a:	e822                	sd	s0,16(sp)
    8000133c:	e426                	sd	s1,8(sp)
    8000133e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001340:	00000097          	auipc	ra,0x0
    80001344:	f28080e7          	jalr	-216(ra) # 80001268 <allocproc>
    80001348:	84aa                	mv	s1,a0
  initproc = p;
    8000134a:	00008797          	auipc	a5,0x8
    8000134e:	cca7b323          	sd	a0,-826(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001352:	03400613          	li	a2,52
    80001356:	00007597          	auipc	a1,0x7
    8000135a:	51a58593          	addi	a1,a1,1306 # 80008870 <initcode>
    8000135e:	6928                	ld	a0,80(a0)
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	5c8080e7          	jalr	1480(ra) # 80000928 <uvminit>
  p->sz = PGSIZE;
    80001368:	6785                	lui	a5,0x1
    8000136a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000136c:	6cb8                	ld	a4,88(s1)
    8000136e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001372:	6cb8                	ld	a4,88(s1)
    80001374:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001376:	4641                	li	a2,16
    80001378:	00007597          	auipc	a1,0x7
    8000137c:	e3058593          	addi	a1,a1,-464 # 800081a8 <etext+0x1a8>
    80001380:	15848513          	addi	a0,s1,344
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	06e080e7          	jalr	110(ra) # 800003f2 <safestrcpy>
  p->cwd = namei("/");
    8000138c:	00007517          	auipc	a0,0x7
    80001390:	e2c50513          	addi	a0,a0,-468 # 800081b8 <etext+0x1b8>
    80001394:	00002097          	auipc	ra,0x2
    80001398:	0f6080e7          	jalr	246(ra) # 8000348a <namei>
    8000139c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013a0:	478d                	li	a5,3
    800013a2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013a4:	8526                	mv	a0,s1
    800013a6:	00005097          	auipc	ra,0x5
    800013aa:	fe0080e7          	jalr	-32(ra) # 80006386 <release>
}
    800013ae:	60e2                	ld	ra,24(sp)
    800013b0:	6442                	ld	s0,16(sp)
    800013b2:	64a2                	ld	s1,8(sp)
    800013b4:	6105                	addi	sp,sp,32
    800013b6:	8082                	ret

00000000800013b8 <growproc>:
{
    800013b8:	1101                	addi	sp,sp,-32
    800013ba:	ec06                	sd	ra,24(sp)
    800013bc:	e822                	sd	s0,16(sp)
    800013be:	e426                	sd	s1,8(sp)
    800013c0:	e04a                	sd	s2,0(sp)
    800013c2:	1000                	addi	s0,sp,32
    800013c4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	c98080e7          	jalr	-872(ra) # 8000105e <myproc>
    800013ce:	892a                	mv	s2,a0
  sz = p->sz;
    800013d0:	652c                	ld	a1,72(a0)
    800013d2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800013d6:	00904f63          	bgtz	s1,800013f4 <growproc+0x3c>
  } else if(n < 0){
    800013da:	0204cc63          	bltz	s1,80001412 <growproc+0x5a>
  p->sz = sz;
    800013de:	1602                	slli	a2,a2,0x20
    800013e0:	9201                	srli	a2,a2,0x20
    800013e2:	04c93423          	sd	a2,72(s2)
  return 0;
    800013e6:	4501                	li	a0,0
}
    800013e8:	60e2                	ld	ra,24(sp)
    800013ea:	6442                	ld	s0,16(sp)
    800013ec:	64a2                	ld	s1,8(sp)
    800013ee:	6902                	ld	s2,0(sp)
    800013f0:	6105                	addi	sp,sp,32
    800013f2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013f4:	9e25                	addw	a2,a2,s1
    800013f6:	1602                	slli	a2,a2,0x20
    800013f8:	9201                	srli	a2,a2,0x20
    800013fa:	1582                	slli	a1,a1,0x20
    800013fc:	9181                	srli	a1,a1,0x20
    800013fe:	6928                	ld	a0,80(a0)
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	5e2080e7          	jalr	1506(ra) # 800009e2 <uvmalloc>
    80001408:	0005061b          	sext.w	a2,a0
    8000140c:	fa69                	bnez	a2,800013de <growproc+0x26>
      return -1;
    8000140e:	557d                	li	a0,-1
    80001410:	bfe1                	j	800013e8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001412:	9e25                	addw	a2,a2,s1
    80001414:	1602                	slli	a2,a2,0x20
    80001416:	9201                	srli	a2,a2,0x20
    80001418:	1582                	slli	a1,a1,0x20
    8000141a:	9181                	srli	a1,a1,0x20
    8000141c:	6928                	ld	a0,80(a0)
    8000141e:	fffff097          	auipc	ra,0xfffff
    80001422:	57c080e7          	jalr	1404(ra) # 8000099a <uvmdealloc>
    80001426:	0005061b          	sext.w	a2,a0
    8000142a:	bf55                	j	800013de <growproc+0x26>

000000008000142c <fork>:
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	c22080e7          	jalr	-990(ra) # 8000105e <myproc>
    80001444:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	e22080e7          	jalr	-478(ra) # 80001268 <allocproc>
    8000144e:	10050b63          	beqz	a0,80001564 <fork+0x138>
    80001452:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001454:	04893603          	ld	a2,72(s2)
    80001458:	692c                	ld	a1,80(a0)
    8000145a:	05093503          	ld	a0,80(s2)
    8000145e:	fffff097          	auipc	ra,0xfffff
    80001462:	6d0080e7          	jalr	1744(ra) # 80000b2e <uvmcopy>
    80001466:	04054663          	bltz	a0,800014b2 <fork+0x86>
  np->sz = p->sz;
    8000146a:	04893783          	ld	a5,72(s2)
    8000146e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001472:	05893683          	ld	a3,88(s2)
    80001476:	87b6                	mv	a5,a3
    80001478:	0589b703          	ld	a4,88(s3)
    8000147c:	12068693          	addi	a3,a3,288
    80001480:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001484:	6788                	ld	a0,8(a5)
    80001486:	6b8c                	ld	a1,16(a5)
    80001488:	6f90                	ld	a2,24(a5)
    8000148a:	01073023          	sd	a6,0(a4)
    8000148e:	e708                	sd	a0,8(a4)
    80001490:	eb0c                	sd	a1,16(a4)
    80001492:	ef10                	sd	a2,24(a4)
    80001494:	02078793          	addi	a5,a5,32
    80001498:	02070713          	addi	a4,a4,32
    8000149c:	fed792e3          	bne	a5,a3,80001480 <fork+0x54>
  np->trapframe->a0 = 0;
    800014a0:	0589b783          	ld	a5,88(s3)
    800014a4:	0607b823          	sd	zero,112(a5)
    800014a8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800014ac:	15000a13          	li	s4,336
    800014b0:	a03d                	j	800014de <fork+0xb2>
    freeproc(np);
    800014b2:	854e                	mv	a0,s3
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	d5c080e7          	jalr	-676(ra) # 80001210 <freeproc>
    release(&np->lock);
    800014bc:	854e                	mv	a0,s3
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	ec8080e7          	jalr	-312(ra) # 80006386 <release>
    return -1;
    800014c6:	5a7d                	li	s4,-1
    800014c8:	a069                	j	80001552 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800014ca:	00002097          	auipc	ra,0x2
    800014ce:	656080e7          	jalr	1622(ra) # 80003b20 <filedup>
    800014d2:	009987b3          	add	a5,s3,s1
    800014d6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014d8:	04a1                	addi	s1,s1,8
    800014da:	01448763          	beq	s1,s4,800014e8 <fork+0xbc>
    if(p->ofile[i])
    800014de:	009907b3          	add	a5,s2,s1
    800014e2:	6388                	ld	a0,0(a5)
    800014e4:	f17d                	bnez	a0,800014ca <fork+0x9e>
    800014e6:	bfcd                	j	800014d8 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014e8:	15093503          	ld	a0,336(s2)
    800014ec:	00001097          	auipc	ra,0x1
    800014f0:	7aa080e7          	jalr	1962(ra) # 80002c96 <idup>
    800014f4:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014f8:	4641                	li	a2,16
    800014fa:	15890593          	addi	a1,s2,344
    800014fe:	15898513          	addi	a0,s3,344
    80001502:	fffff097          	auipc	ra,0xfffff
    80001506:	ef0080e7          	jalr	-272(ra) # 800003f2 <safestrcpy>
  pid = np->pid;
    8000150a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000150e:	854e                	mv	a0,s3
    80001510:	00005097          	auipc	ra,0x5
    80001514:	e76080e7          	jalr	-394(ra) # 80006386 <release>
  acquire(&wait_lock);
    80001518:	00228497          	auipc	s1,0x228
    8000151c:	b6848493          	addi	s1,s1,-1176 # 80229080 <wait_lock>
    80001520:	8526                	mv	a0,s1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	db0080e7          	jalr	-592(ra) # 800062d2 <acquire>
  np->parent = p;
    8000152a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000152e:	8526                	mv	a0,s1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	e56080e7          	jalr	-426(ra) # 80006386 <release>
  acquire(&np->lock);
    80001538:	854e                	mv	a0,s3
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	d98080e7          	jalr	-616(ra) # 800062d2 <acquire>
  np->state = RUNNABLE;
    80001542:	478d                	li	a5,3
    80001544:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001548:	854e                	mv	a0,s3
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	e3c080e7          	jalr	-452(ra) # 80006386 <release>
}
    80001552:	8552                	mv	a0,s4
    80001554:	70a2                	ld	ra,40(sp)
    80001556:	7402                	ld	s0,32(sp)
    80001558:	64e2                	ld	s1,24(sp)
    8000155a:	6942                	ld	s2,16(sp)
    8000155c:	69a2                	ld	s3,8(sp)
    8000155e:	6a02                	ld	s4,0(sp)
    80001560:	6145                	addi	sp,sp,48
    80001562:	8082                	ret
    return -1;
    80001564:	5a7d                	li	s4,-1
    80001566:	b7f5                	j	80001552 <fork+0x126>

0000000080001568 <scheduler>:
{
    80001568:	7139                	addi	sp,sp,-64
    8000156a:	fc06                	sd	ra,56(sp)
    8000156c:	f822                	sd	s0,48(sp)
    8000156e:	f426                	sd	s1,40(sp)
    80001570:	f04a                	sd	s2,32(sp)
    80001572:	ec4e                	sd	s3,24(sp)
    80001574:	e852                	sd	s4,16(sp)
    80001576:	e456                	sd	s5,8(sp)
    80001578:	e05a                	sd	s6,0(sp)
    8000157a:	0080                	addi	s0,sp,64
    8000157c:	8792                	mv	a5,tp
  int id = r_tp();
    8000157e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001580:	00779a93          	slli	s5,a5,0x7
    80001584:	00228717          	auipc	a4,0x228
    80001588:	ae470713          	addi	a4,a4,-1308 # 80229068 <pid_lock>
    8000158c:	9756                	add	a4,a4,s5
    8000158e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001592:	00228717          	auipc	a4,0x228
    80001596:	b0e70713          	addi	a4,a4,-1266 # 802290a0 <cpus+0x8>
    8000159a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000159c:	498d                	li	s3,3
        p->state = RUNNING;
    8000159e:	4b11                	li	s6,4
        c->proc = p;
    800015a0:	079e                	slli	a5,a5,0x7
    800015a2:	00228a17          	auipc	s4,0x228
    800015a6:	ac6a0a13          	addi	s4,s4,-1338 # 80229068 <pid_lock>
    800015aa:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ac:	0022e917          	auipc	s2,0x22e
    800015b0:	8ec90913          	addi	s2,s2,-1812 # 8022ee98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015bc:	10079073          	csrw	sstatus,a5
    800015c0:	00228497          	auipc	s1,0x228
    800015c4:	ed848493          	addi	s1,s1,-296 # 80229498 <proc>
    800015c8:	a03d                	j	800015f6 <scheduler+0x8e>
        p->state = RUNNING;
    800015ca:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015ce:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015d2:	06048593          	addi	a1,s1,96
    800015d6:	8556                	mv	a0,s5
    800015d8:	00000097          	auipc	ra,0x0
    800015dc:	640080e7          	jalr	1600(ra) # 80001c18 <swtch>
        c->proc = 0;
    800015e0:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	00005097          	auipc	ra,0x5
    800015ea:	da0080e7          	jalr	-608(ra) # 80006386 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ee:	16848493          	addi	s1,s1,360
    800015f2:	fd2481e3          	beq	s1,s2,800015b4 <scheduler+0x4c>
      acquire(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	cda080e7          	jalr	-806(ra) # 800062d2 <acquire>
      if(p->state == RUNNABLE) {
    80001600:	4c9c                	lw	a5,24(s1)
    80001602:	ff3791e3          	bne	a5,s3,800015e4 <scheduler+0x7c>
    80001606:	b7d1                	j	800015ca <scheduler+0x62>

0000000080001608 <sched>:
{
    80001608:	7179                	addi	sp,sp,-48
    8000160a:	f406                	sd	ra,40(sp)
    8000160c:	f022                	sd	s0,32(sp)
    8000160e:	ec26                	sd	s1,24(sp)
    80001610:	e84a                	sd	s2,16(sp)
    80001612:	e44e                	sd	s3,8(sp)
    80001614:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	a48080e7          	jalr	-1464(ra) # 8000105e <myproc>
    8000161e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001620:	00005097          	auipc	ra,0x5
    80001624:	c38080e7          	jalr	-968(ra) # 80006258 <holding>
    80001628:	c93d                	beqz	a0,8000169e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000162a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000162c:	2781                	sext.w	a5,a5
    8000162e:	079e                	slli	a5,a5,0x7
    80001630:	00228717          	auipc	a4,0x228
    80001634:	a3870713          	addi	a4,a4,-1480 # 80229068 <pid_lock>
    80001638:	97ba                	add	a5,a5,a4
    8000163a:	0a87a703          	lw	a4,168(a5)
    8000163e:	4785                	li	a5,1
    80001640:	06f71763          	bne	a4,a5,800016ae <sched+0xa6>
  if(p->state == RUNNING)
    80001644:	4c98                	lw	a4,24(s1)
    80001646:	4791                	li	a5,4
    80001648:	06f70b63          	beq	a4,a5,800016be <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000164c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001650:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001652:	efb5                	bnez	a5,800016ce <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001654:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001656:	00228917          	auipc	s2,0x228
    8000165a:	a1290913          	addi	s2,s2,-1518 # 80229068 <pid_lock>
    8000165e:	2781                	sext.w	a5,a5
    80001660:	079e                	slli	a5,a5,0x7
    80001662:	97ca                	add	a5,a5,s2
    80001664:	0ac7a983          	lw	s3,172(a5)
    80001668:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	079e                	slli	a5,a5,0x7
    8000166e:	00228597          	auipc	a1,0x228
    80001672:	a3258593          	addi	a1,a1,-1486 # 802290a0 <cpus+0x8>
    80001676:	95be                	add	a1,a1,a5
    80001678:	06048513          	addi	a0,s1,96
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	59c080e7          	jalr	1436(ra) # 80001c18 <swtch>
    80001684:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001686:	2781                	sext.w	a5,a5
    80001688:	079e                	slli	a5,a5,0x7
    8000168a:	97ca                	add	a5,a5,s2
    8000168c:	0b37a623          	sw	s3,172(a5)
}
    80001690:	70a2                	ld	ra,40(sp)
    80001692:	7402                	ld	s0,32(sp)
    80001694:	64e2                	ld	s1,24(sp)
    80001696:	6942                	ld	s2,16(sp)
    80001698:	69a2                	ld	s3,8(sp)
    8000169a:	6145                	addi	sp,sp,48
    8000169c:	8082                	ret
    panic("sched p->lock");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	b2250513          	addi	a0,a0,-1246 # 800081c0 <etext+0x1c0>
    800016a6:	00004097          	auipc	ra,0x4
    800016aa:	6e2080e7          	jalr	1762(ra) # 80005d88 <panic>
    panic("sched locks");
    800016ae:	00007517          	auipc	a0,0x7
    800016b2:	b2250513          	addi	a0,a0,-1246 # 800081d0 <etext+0x1d0>
    800016b6:	00004097          	auipc	ra,0x4
    800016ba:	6d2080e7          	jalr	1746(ra) # 80005d88 <panic>
    panic("sched running");
    800016be:	00007517          	auipc	a0,0x7
    800016c2:	b2250513          	addi	a0,a0,-1246 # 800081e0 <etext+0x1e0>
    800016c6:	00004097          	auipc	ra,0x4
    800016ca:	6c2080e7          	jalr	1730(ra) # 80005d88 <panic>
    panic("sched interruptible");
    800016ce:	00007517          	auipc	a0,0x7
    800016d2:	b2250513          	addi	a0,a0,-1246 # 800081f0 <etext+0x1f0>
    800016d6:	00004097          	auipc	ra,0x4
    800016da:	6b2080e7          	jalr	1714(ra) # 80005d88 <panic>

00000000800016de <yield>:
{
    800016de:	1101                	addi	sp,sp,-32
    800016e0:	ec06                	sd	ra,24(sp)
    800016e2:	e822                	sd	s0,16(sp)
    800016e4:	e426                	sd	s1,8(sp)
    800016e6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	976080e7          	jalr	-1674(ra) # 8000105e <myproc>
    800016f0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	be0080e7          	jalr	-1056(ra) # 800062d2 <acquire>
  p->state = RUNNABLE;
    800016fa:	478d                	li	a5,3
    800016fc:	cc9c                	sw	a5,24(s1)
  sched();
    800016fe:	00000097          	auipc	ra,0x0
    80001702:	f0a080e7          	jalr	-246(ra) # 80001608 <sched>
  release(&p->lock);
    80001706:	8526                	mv	a0,s1
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	c7e080e7          	jalr	-898(ra) # 80006386 <release>
}
    80001710:	60e2                	ld	ra,24(sp)
    80001712:	6442                	ld	s0,16(sp)
    80001714:	64a2                	ld	s1,8(sp)
    80001716:	6105                	addi	sp,sp,32
    80001718:	8082                	ret

000000008000171a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000171a:	7179                	addi	sp,sp,-48
    8000171c:	f406                	sd	ra,40(sp)
    8000171e:	f022                	sd	s0,32(sp)
    80001720:	ec26                	sd	s1,24(sp)
    80001722:	e84a                	sd	s2,16(sp)
    80001724:	e44e                	sd	s3,8(sp)
    80001726:	1800                	addi	s0,sp,48
    80001728:	89aa                	mv	s3,a0
    8000172a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	932080e7          	jalr	-1742(ra) # 8000105e <myproc>
    80001734:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001736:	00005097          	auipc	ra,0x5
    8000173a:	b9c080e7          	jalr	-1124(ra) # 800062d2 <acquire>
  release(lk);
    8000173e:	854a                	mv	a0,s2
    80001740:	00005097          	auipc	ra,0x5
    80001744:	c46080e7          	jalr	-954(ra) # 80006386 <release>

  // Go to sleep.
  p->chan = chan;
    80001748:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000174c:	4789                	li	a5,2
    8000174e:	cc9c                	sw	a5,24(s1)

  sched();
    80001750:	00000097          	auipc	ra,0x0
    80001754:	eb8080e7          	jalr	-328(ra) # 80001608 <sched>

  // Tidy up.
  p->chan = 0;
    80001758:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	c28080e7          	jalr	-984(ra) # 80006386 <release>
  acquire(lk);
    80001766:	854a                	mv	a0,s2
    80001768:	00005097          	auipc	ra,0x5
    8000176c:	b6a080e7          	jalr	-1174(ra) # 800062d2 <acquire>
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret

000000008000177e <wait>:
{
    8000177e:	715d                	addi	sp,sp,-80
    80001780:	e486                	sd	ra,72(sp)
    80001782:	e0a2                	sd	s0,64(sp)
    80001784:	fc26                	sd	s1,56(sp)
    80001786:	f84a                	sd	s2,48(sp)
    80001788:	f44e                	sd	s3,40(sp)
    8000178a:	f052                	sd	s4,32(sp)
    8000178c:	ec56                	sd	s5,24(sp)
    8000178e:	e85a                	sd	s6,16(sp)
    80001790:	e45e                	sd	s7,8(sp)
    80001792:	e062                	sd	s8,0(sp)
    80001794:	0880                	addi	s0,sp,80
    80001796:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001798:	00000097          	auipc	ra,0x0
    8000179c:	8c6080e7          	jalr	-1850(ra) # 8000105e <myproc>
    800017a0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017a2:	00228517          	auipc	a0,0x228
    800017a6:	8de50513          	addi	a0,a0,-1826 # 80229080 <wait_lock>
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	b28080e7          	jalr	-1240(ra) # 800062d2 <acquire>
    havekids = 0;
    800017b2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800017b4:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800017b6:	0022d997          	auipc	s3,0x22d
    800017ba:	6e298993          	addi	s3,s3,1762 # 8022ee98 <tickslock>
        havekids = 1;
    800017be:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017c0:	00228c17          	auipc	s8,0x228
    800017c4:	8c0c0c13          	addi	s8,s8,-1856 # 80229080 <wait_lock>
    havekids = 0;
    800017c8:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017ca:	00228497          	auipc	s1,0x228
    800017ce:	cce48493          	addi	s1,s1,-818 # 80229498 <proc>
    800017d2:	a0bd                	j	80001840 <wait+0xc2>
          pid = np->pid;
    800017d4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017d8:	000b0e63          	beqz	s6,800017f4 <wait+0x76>
    800017dc:	4691                	li	a3,4
    800017de:	02c48613          	addi	a2,s1,44
    800017e2:	85da                	mv	a1,s6
    800017e4:	05093503          	ld	a0,80(s2)
    800017e8:	fffff097          	auipc	ra,0xfffff
    800017ec:	656080e7          	jalr	1622(ra) # 80000e3e <copyout>
    800017f0:	02054563          	bltz	a0,8000181a <wait+0x9c>
          freeproc(np);
    800017f4:	8526                	mv	a0,s1
    800017f6:	00000097          	auipc	ra,0x0
    800017fa:	a1a080e7          	jalr	-1510(ra) # 80001210 <freeproc>
          release(&np->lock);
    800017fe:	8526                	mv	a0,s1
    80001800:	00005097          	auipc	ra,0x5
    80001804:	b86080e7          	jalr	-1146(ra) # 80006386 <release>
          release(&wait_lock);
    80001808:	00228517          	auipc	a0,0x228
    8000180c:	87850513          	addi	a0,a0,-1928 # 80229080 <wait_lock>
    80001810:	00005097          	auipc	ra,0x5
    80001814:	b76080e7          	jalr	-1162(ra) # 80006386 <release>
          return pid;
    80001818:	a09d                	j	8000187e <wait+0x100>
            release(&np->lock);
    8000181a:	8526                	mv	a0,s1
    8000181c:	00005097          	auipc	ra,0x5
    80001820:	b6a080e7          	jalr	-1174(ra) # 80006386 <release>
            release(&wait_lock);
    80001824:	00228517          	auipc	a0,0x228
    80001828:	85c50513          	addi	a0,a0,-1956 # 80229080 <wait_lock>
    8000182c:	00005097          	auipc	ra,0x5
    80001830:	b5a080e7          	jalr	-1190(ra) # 80006386 <release>
            return -1;
    80001834:	59fd                	li	s3,-1
    80001836:	a0a1                	j	8000187e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001838:	16848493          	addi	s1,s1,360
    8000183c:	03348463          	beq	s1,s3,80001864 <wait+0xe6>
      if(np->parent == p){
    80001840:	7c9c                	ld	a5,56(s1)
    80001842:	ff279be3          	bne	a5,s2,80001838 <wait+0xba>
        acquire(&np->lock);
    80001846:	8526                	mv	a0,s1
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	a8a080e7          	jalr	-1398(ra) # 800062d2 <acquire>
        if(np->state == ZOMBIE){
    80001850:	4c9c                	lw	a5,24(s1)
    80001852:	f94781e3          	beq	a5,s4,800017d4 <wait+0x56>
        release(&np->lock);
    80001856:	8526                	mv	a0,s1
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	b2e080e7          	jalr	-1234(ra) # 80006386 <release>
        havekids = 1;
    80001860:	8756                	mv	a4,s5
    80001862:	bfd9                	j	80001838 <wait+0xba>
    if(!havekids || p->killed){
    80001864:	c701                	beqz	a4,8000186c <wait+0xee>
    80001866:	02892783          	lw	a5,40(s2)
    8000186a:	c79d                	beqz	a5,80001898 <wait+0x11a>
      release(&wait_lock);
    8000186c:	00228517          	auipc	a0,0x228
    80001870:	81450513          	addi	a0,a0,-2028 # 80229080 <wait_lock>
    80001874:	00005097          	auipc	ra,0x5
    80001878:	b12080e7          	jalr	-1262(ra) # 80006386 <release>
      return -1;
    8000187c:	59fd                	li	s3,-1
}
    8000187e:	854e                	mv	a0,s3
    80001880:	60a6                	ld	ra,72(sp)
    80001882:	6406                	ld	s0,64(sp)
    80001884:	74e2                	ld	s1,56(sp)
    80001886:	7942                	ld	s2,48(sp)
    80001888:	79a2                	ld	s3,40(sp)
    8000188a:	7a02                	ld	s4,32(sp)
    8000188c:	6ae2                	ld	s5,24(sp)
    8000188e:	6b42                	ld	s6,16(sp)
    80001890:	6ba2                	ld	s7,8(sp)
    80001892:	6c02                	ld	s8,0(sp)
    80001894:	6161                	addi	sp,sp,80
    80001896:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001898:	85e2                	mv	a1,s8
    8000189a:	854a                	mv	a0,s2
    8000189c:	00000097          	auipc	ra,0x0
    800018a0:	e7e080e7          	jalr	-386(ra) # 8000171a <sleep>
    havekids = 0;
    800018a4:	b715                	j	800017c8 <wait+0x4a>

00000000800018a6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018a6:	7139                	addi	sp,sp,-64
    800018a8:	fc06                	sd	ra,56(sp)
    800018aa:	f822                	sd	s0,48(sp)
    800018ac:	f426                	sd	s1,40(sp)
    800018ae:	f04a                	sd	s2,32(sp)
    800018b0:	ec4e                	sd	s3,24(sp)
    800018b2:	e852                	sd	s4,16(sp)
    800018b4:	e456                	sd	s5,8(sp)
    800018b6:	0080                	addi	s0,sp,64
    800018b8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018ba:	00228497          	auipc	s1,0x228
    800018be:	bde48493          	addi	s1,s1,-1058 # 80229498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018c2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018c4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c6:	0022d917          	auipc	s2,0x22d
    800018ca:	5d290913          	addi	s2,s2,1490 # 8022ee98 <tickslock>
    800018ce:	a821                	j	800018e6 <wakeup+0x40>
        p->state = RUNNABLE;
    800018d0:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	ab0080e7          	jalr	-1360(ra) # 80006386 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018de:	16848493          	addi	s1,s1,360
    800018e2:	03248463          	beq	s1,s2,8000190a <wakeup+0x64>
    if(p != myproc()){
    800018e6:	fffff097          	auipc	ra,0xfffff
    800018ea:	778080e7          	jalr	1912(ra) # 8000105e <myproc>
    800018ee:	fea488e3          	beq	s1,a0,800018de <wakeup+0x38>
      acquire(&p->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	9de080e7          	jalr	-1570(ra) # 800062d2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018fc:	4c9c                	lw	a5,24(s1)
    800018fe:	fd379be3          	bne	a5,s3,800018d4 <wakeup+0x2e>
    80001902:	709c                	ld	a5,32(s1)
    80001904:	fd4798e3          	bne	a5,s4,800018d4 <wakeup+0x2e>
    80001908:	b7e1                	j	800018d0 <wakeup+0x2a>
    }
  }
}
    8000190a:	70e2                	ld	ra,56(sp)
    8000190c:	7442                	ld	s0,48(sp)
    8000190e:	74a2                	ld	s1,40(sp)
    80001910:	7902                	ld	s2,32(sp)
    80001912:	69e2                	ld	s3,24(sp)
    80001914:	6a42                	ld	s4,16(sp)
    80001916:	6aa2                	ld	s5,8(sp)
    80001918:	6121                	addi	sp,sp,64
    8000191a:	8082                	ret

000000008000191c <reparent>:
{
    8000191c:	7179                	addi	sp,sp,-48
    8000191e:	f406                	sd	ra,40(sp)
    80001920:	f022                	sd	s0,32(sp)
    80001922:	ec26                	sd	s1,24(sp)
    80001924:	e84a                	sd	s2,16(sp)
    80001926:	e44e                	sd	s3,8(sp)
    80001928:	e052                	sd	s4,0(sp)
    8000192a:	1800                	addi	s0,sp,48
    8000192c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000192e:	00228497          	auipc	s1,0x228
    80001932:	b6a48493          	addi	s1,s1,-1174 # 80229498 <proc>
      pp->parent = initproc;
    80001936:	00007a17          	auipc	s4,0x7
    8000193a:	6daa0a13          	addi	s4,s4,1754 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000193e:	0022d997          	auipc	s3,0x22d
    80001942:	55a98993          	addi	s3,s3,1370 # 8022ee98 <tickslock>
    80001946:	a029                	j	80001950 <reparent+0x34>
    80001948:	16848493          	addi	s1,s1,360
    8000194c:	01348d63          	beq	s1,s3,80001966 <reparent+0x4a>
    if(pp->parent == p){
    80001950:	7c9c                	ld	a5,56(s1)
    80001952:	ff279be3          	bne	a5,s2,80001948 <reparent+0x2c>
      pp->parent = initproc;
    80001956:	000a3503          	ld	a0,0(s4)
    8000195a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000195c:	00000097          	auipc	ra,0x0
    80001960:	f4a080e7          	jalr	-182(ra) # 800018a6 <wakeup>
    80001964:	b7d5                	j	80001948 <reparent+0x2c>
}
    80001966:	70a2                	ld	ra,40(sp)
    80001968:	7402                	ld	s0,32(sp)
    8000196a:	64e2                	ld	s1,24(sp)
    8000196c:	6942                	ld	s2,16(sp)
    8000196e:	69a2                	ld	s3,8(sp)
    80001970:	6a02                	ld	s4,0(sp)
    80001972:	6145                	addi	sp,sp,48
    80001974:	8082                	ret

0000000080001976 <exit>:
{
    80001976:	7179                	addi	sp,sp,-48
    80001978:	f406                	sd	ra,40(sp)
    8000197a:	f022                	sd	s0,32(sp)
    8000197c:	ec26                	sd	s1,24(sp)
    8000197e:	e84a                	sd	s2,16(sp)
    80001980:	e44e                	sd	s3,8(sp)
    80001982:	e052                	sd	s4,0(sp)
    80001984:	1800                	addi	s0,sp,48
    80001986:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	6d6080e7          	jalr	1750(ra) # 8000105e <myproc>
    80001990:	89aa                	mv	s3,a0
  if(p == initproc)
    80001992:	00007797          	auipc	a5,0x7
    80001996:	67e7b783          	ld	a5,1662(a5) # 80009010 <initproc>
    8000199a:	0d050493          	addi	s1,a0,208
    8000199e:	15050913          	addi	s2,a0,336
    800019a2:	02a79363          	bne	a5,a0,800019c8 <exit+0x52>
    panic("init exiting");
    800019a6:	00007517          	auipc	a0,0x7
    800019aa:	86250513          	addi	a0,a0,-1950 # 80008208 <etext+0x208>
    800019ae:	00004097          	auipc	ra,0x4
    800019b2:	3da080e7          	jalr	986(ra) # 80005d88 <panic>
      fileclose(f);
    800019b6:	00002097          	auipc	ra,0x2
    800019ba:	1bc080e7          	jalr	444(ra) # 80003b72 <fileclose>
      p->ofile[fd] = 0;
    800019be:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019c2:	04a1                	addi	s1,s1,8
    800019c4:	01248563          	beq	s1,s2,800019ce <exit+0x58>
    if(p->ofile[fd]){
    800019c8:	6088                	ld	a0,0(s1)
    800019ca:	f575                	bnez	a0,800019b6 <exit+0x40>
    800019cc:	bfdd                	j	800019c2 <exit+0x4c>
  begin_op();
    800019ce:	00002097          	auipc	ra,0x2
    800019d2:	cd8080e7          	jalr	-808(ra) # 800036a6 <begin_op>
  iput(p->cwd);
    800019d6:	1509b503          	ld	a0,336(s3)
    800019da:	00001097          	auipc	ra,0x1
    800019de:	4b4080e7          	jalr	1204(ra) # 80002e8e <iput>
  end_op();
    800019e2:	00002097          	auipc	ra,0x2
    800019e6:	d44080e7          	jalr	-700(ra) # 80003726 <end_op>
  p->cwd = 0;
    800019ea:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019ee:	00227497          	auipc	s1,0x227
    800019f2:	69248493          	addi	s1,s1,1682 # 80229080 <wait_lock>
    800019f6:	8526                	mv	a0,s1
    800019f8:	00005097          	auipc	ra,0x5
    800019fc:	8da080e7          	jalr	-1830(ra) # 800062d2 <acquire>
  reparent(p);
    80001a00:	854e                	mv	a0,s3
    80001a02:	00000097          	auipc	ra,0x0
    80001a06:	f1a080e7          	jalr	-230(ra) # 8000191c <reparent>
  wakeup(p->parent);
    80001a0a:	0389b503          	ld	a0,56(s3)
    80001a0e:	00000097          	auipc	ra,0x0
    80001a12:	e98080e7          	jalr	-360(ra) # 800018a6 <wakeup>
  acquire(&p->lock);
    80001a16:	854e                	mv	a0,s3
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	8ba080e7          	jalr	-1862(ra) # 800062d2 <acquire>
  p->xstate = status;
    80001a20:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a24:	4795                	li	a5,5
    80001a26:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	00005097          	auipc	ra,0x5
    80001a30:	95a080e7          	jalr	-1702(ra) # 80006386 <release>
  sched();
    80001a34:	00000097          	auipc	ra,0x0
    80001a38:	bd4080e7          	jalr	-1068(ra) # 80001608 <sched>
  panic("zombie exit");
    80001a3c:	00006517          	auipc	a0,0x6
    80001a40:	7dc50513          	addi	a0,a0,2012 # 80008218 <etext+0x218>
    80001a44:	00004097          	auipc	ra,0x4
    80001a48:	344080e7          	jalr	836(ra) # 80005d88 <panic>

0000000080001a4c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a4c:	7179                	addi	sp,sp,-48
    80001a4e:	f406                	sd	ra,40(sp)
    80001a50:	f022                	sd	s0,32(sp)
    80001a52:	ec26                	sd	s1,24(sp)
    80001a54:	e84a                	sd	s2,16(sp)
    80001a56:	e44e                	sd	s3,8(sp)
    80001a58:	1800                	addi	s0,sp,48
    80001a5a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a5c:	00228497          	auipc	s1,0x228
    80001a60:	a3c48493          	addi	s1,s1,-1476 # 80229498 <proc>
    80001a64:	0022d997          	auipc	s3,0x22d
    80001a68:	43498993          	addi	s3,s3,1076 # 8022ee98 <tickslock>
    acquire(&p->lock);
    80001a6c:	8526                	mv	a0,s1
    80001a6e:	00005097          	auipc	ra,0x5
    80001a72:	864080e7          	jalr	-1948(ra) # 800062d2 <acquire>
    if(p->pid == pid){
    80001a76:	589c                	lw	a5,48(s1)
    80001a78:	01278d63          	beq	a5,s2,80001a92 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	00005097          	auipc	ra,0x5
    80001a82:	908080e7          	jalr	-1784(ra) # 80006386 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a86:	16848493          	addi	s1,s1,360
    80001a8a:	ff3491e3          	bne	s1,s3,80001a6c <kill+0x20>
  }
  return -1;
    80001a8e:	557d                	li	a0,-1
    80001a90:	a829                	j	80001aaa <kill+0x5e>
      p->killed = 1;
    80001a92:	4785                	li	a5,1
    80001a94:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a96:	4c98                	lw	a4,24(s1)
    80001a98:	4789                	li	a5,2
    80001a9a:	00f70f63          	beq	a4,a5,80001ab8 <kill+0x6c>
      release(&p->lock);
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	00005097          	auipc	ra,0x5
    80001aa4:	8e6080e7          	jalr	-1818(ra) # 80006386 <release>
      return 0;
    80001aa8:	4501                	li	a0,0
}
    80001aaa:	70a2                	ld	ra,40(sp)
    80001aac:	7402                	ld	s0,32(sp)
    80001aae:	64e2                	ld	s1,24(sp)
    80001ab0:	6942                	ld	s2,16(sp)
    80001ab2:	69a2                	ld	s3,8(sp)
    80001ab4:	6145                	addi	sp,sp,48
    80001ab6:	8082                	ret
        p->state = RUNNABLE;
    80001ab8:	478d                	li	a5,3
    80001aba:	cc9c                	sw	a5,24(s1)
    80001abc:	b7cd                	j	80001a9e <kill+0x52>

0000000080001abe <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001abe:	7179                	addi	sp,sp,-48
    80001ac0:	f406                	sd	ra,40(sp)
    80001ac2:	f022                	sd	s0,32(sp)
    80001ac4:	ec26                	sd	s1,24(sp)
    80001ac6:	e84a                	sd	s2,16(sp)
    80001ac8:	e44e                	sd	s3,8(sp)
    80001aca:	e052                	sd	s4,0(sp)
    80001acc:	1800                	addi	s0,sp,48
    80001ace:	84aa                	mv	s1,a0
    80001ad0:	892e                	mv	s2,a1
    80001ad2:	89b2                	mv	s3,a2
    80001ad4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	588080e7          	jalr	1416(ra) # 8000105e <myproc>
  if(user_dst){
    80001ade:	c08d                	beqz	s1,80001b00 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ae0:	86d2                	mv	a3,s4
    80001ae2:	864e                	mv	a2,s3
    80001ae4:	85ca                	mv	a1,s2
    80001ae6:	6928                	ld	a0,80(a0)
    80001ae8:	fffff097          	auipc	ra,0xfffff
    80001aec:	356080e7          	jalr	854(ra) # 80000e3e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001af0:	70a2                	ld	ra,40(sp)
    80001af2:	7402                	ld	s0,32(sp)
    80001af4:	64e2                	ld	s1,24(sp)
    80001af6:	6942                	ld	s2,16(sp)
    80001af8:	69a2                	ld	s3,8(sp)
    80001afa:	6a02                	ld	s4,0(sp)
    80001afc:	6145                	addi	sp,sp,48
    80001afe:	8082                	ret
    memmove((char *)dst, src, len);
    80001b00:	000a061b          	sext.w	a2,s4
    80001b04:	85ce                	mv	a1,s3
    80001b06:	854a                	mv	a0,s2
    80001b08:	ffffe097          	auipc	ra,0xffffe
    80001b0c:	7f8080e7          	jalr	2040(ra) # 80000300 <memmove>
    return 0;
    80001b10:	8526                	mv	a0,s1
    80001b12:	bff9                	j	80001af0 <either_copyout+0x32>

0000000080001b14 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b14:	7179                	addi	sp,sp,-48
    80001b16:	f406                	sd	ra,40(sp)
    80001b18:	f022                	sd	s0,32(sp)
    80001b1a:	ec26                	sd	s1,24(sp)
    80001b1c:	e84a                	sd	s2,16(sp)
    80001b1e:	e44e                	sd	s3,8(sp)
    80001b20:	e052                	sd	s4,0(sp)
    80001b22:	1800                	addi	s0,sp,48
    80001b24:	892a                	mv	s2,a0
    80001b26:	84ae                	mv	s1,a1
    80001b28:	89b2                	mv	s3,a2
    80001b2a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b2c:	fffff097          	auipc	ra,0xfffff
    80001b30:	532080e7          	jalr	1330(ra) # 8000105e <myproc>
  if(user_src){
    80001b34:	c08d                	beqz	s1,80001b56 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b36:	86d2                	mv	a3,s4
    80001b38:	864e                	mv	a2,s3
    80001b3a:	85ca                	mv	a1,s2
    80001b3c:	6928                	ld	a0,80(a0)
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	0e2080e7          	jalr	226(ra) # 80000c20 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b46:	70a2                	ld	ra,40(sp)
    80001b48:	7402                	ld	s0,32(sp)
    80001b4a:	64e2                	ld	s1,24(sp)
    80001b4c:	6942                	ld	s2,16(sp)
    80001b4e:	69a2                	ld	s3,8(sp)
    80001b50:	6a02                	ld	s4,0(sp)
    80001b52:	6145                	addi	sp,sp,48
    80001b54:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b56:	000a061b          	sext.w	a2,s4
    80001b5a:	85ce                	mv	a1,s3
    80001b5c:	854a                	mv	a0,s2
    80001b5e:	ffffe097          	auipc	ra,0xffffe
    80001b62:	7a2080e7          	jalr	1954(ra) # 80000300 <memmove>
    return 0;
    80001b66:	8526                	mv	a0,s1
    80001b68:	bff9                	j	80001b46 <either_copyin+0x32>

0000000080001b6a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b6a:	715d                	addi	sp,sp,-80
    80001b6c:	e486                	sd	ra,72(sp)
    80001b6e:	e0a2                	sd	s0,64(sp)
    80001b70:	fc26                	sd	s1,56(sp)
    80001b72:	f84a                	sd	s2,48(sp)
    80001b74:	f44e                	sd	s3,40(sp)
    80001b76:	f052                	sd	s4,32(sp)
    80001b78:	ec56                	sd	s5,24(sp)
    80001b7a:	e85a                	sd	s6,16(sp)
    80001b7c:	e45e                	sd	s7,8(sp)
    80001b7e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	4f050513          	addi	a0,a0,1264 # 80008070 <etext+0x70>
    80001b88:	00004097          	auipc	ra,0x4
    80001b8c:	24a080e7          	jalr	586(ra) # 80005dd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b90:	00228497          	auipc	s1,0x228
    80001b94:	a6048493          	addi	s1,s1,-1440 # 802295f0 <proc+0x158>
    80001b98:	0022d917          	auipc	s2,0x22d
    80001b9c:	45890913          	addi	s2,s2,1112 # 8022eff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ba2:	00006997          	auipc	s3,0x6
    80001ba6:	68698993          	addi	s3,s3,1670 # 80008228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80001baa:	00006a97          	auipc	s5,0x6
    80001bae:	686a8a93          	addi	s5,s5,1670 # 80008230 <etext+0x230>
    printf("\n");
    80001bb2:	00006a17          	auipc	s4,0x6
    80001bb6:	4bea0a13          	addi	s4,s4,1214 # 80008070 <etext+0x70>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bba:	00006b97          	auipc	s7,0x6
    80001bbe:	6aeb8b93          	addi	s7,s7,1710 # 80008268 <states.1717>
    80001bc2:	a00d                	j	80001be4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bc4:	ed86a583          	lw	a1,-296(a3)
    80001bc8:	8556                	mv	a0,s5
    80001bca:	00004097          	auipc	ra,0x4
    80001bce:	208080e7          	jalr	520(ra) # 80005dd2 <printf>
    printf("\n");
    80001bd2:	8552                	mv	a0,s4
    80001bd4:	00004097          	auipc	ra,0x4
    80001bd8:	1fe080e7          	jalr	510(ra) # 80005dd2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bdc:	16848493          	addi	s1,s1,360
    80001be0:	03248163          	beq	s1,s2,80001c02 <procdump+0x98>
    if(p->state == UNUSED)
    80001be4:	86a6                	mv	a3,s1
    80001be6:	ec04a783          	lw	a5,-320(s1)
    80001bea:	dbed                	beqz	a5,80001bdc <procdump+0x72>
      state = "???";
    80001bec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bee:	fcfb6be3          	bltu	s6,a5,80001bc4 <procdump+0x5a>
    80001bf2:	1782                	slli	a5,a5,0x20
    80001bf4:	9381                	srli	a5,a5,0x20
    80001bf6:	078e                	slli	a5,a5,0x3
    80001bf8:	97de                	add	a5,a5,s7
    80001bfa:	6390                	ld	a2,0(a5)
    80001bfc:	f661                	bnez	a2,80001bc4 <procdump+0x5a>
      state = "???";
    80001bfe:	864e                	mv	a2,s3
    80001c00:	b7d1                	j	80001bc4 <procdump+0x5a>
  }
}
    80001c02:	60a6                	ld	ra,72(sp)
    80001c04:	6406                	ld	s0,64(sp)
    80001c06:	74e2                	ld	s1,56(sp)
    80001c08:	7942                	ld	s2,48(sp)
    80001c0a:	79a2                	ld	s3,40(sp)
    80001c0c:	7a02                	ld	s4,32(sp)
    80001c0e:	6ae2                	ld	s5,24(sp)
    80001c10:	6b42                	ld	s6,16(sp)
    80001c12:	6ba2                	ld	s7,8(sp)
    80001c14:	6161                	addi	sp,sp,80
    80001c16:	8082                	ret

0000000080001c18 <swtch>:
    80001c18:	00153023          	sd	ra,0(a0)
    80001c1c:	00253423          	sd	sp,8(a0)
    80001c20:	e900                	sd	s0,16(a0)
    80001c22:	ed04                	sd	s1,24(a0)
    80001c24:	03253023          	sd	s2,32(a0)
    80001c28:	03353423          	sd	s3,40(a0)
    80001c2c:	03453823          	sd	s4,48(a0)
    80001c30:	03553c23          	sd	s5,56(a0)
    80001c34:	05653023          	sd	s6,64(a0)
    80001c38:	05753423          	sd	s7,72(a0)
    80001c3c:	05853823          	sd	s8,80(a0)
    80001c40:	05953c23          	sd	s9,88(a0)
    80001c44:	07a53023          	sd	s10,96(a0)
    80001c48:	07b53423          	sd	s11,104(a0)
    80001c4c:	0005b083          	ld	ra,0(a1)
    80001c50:	0085b103          	ld	sp,8(a1)
    80001c54:	6980                	ld	s0,16(a1)
    80001c56:	6d84                	ld	s1,24(a1)
    80001c58:	0205b903          	ld	s2,32(a1)
    80001c5c:	0285b983          	ld	s3,40(a1)
    80001c60:	0305ba03          	ld	s4,48(a1)
    80001c64:	0385ba83          	ld	s5,56(a1)
    80001c68:	0405bb03          	ld	s6,64(a1)
    80001c6c:	0485bb83          	ld	s7,72(a1)
    80001c70:	0505bc03          	ld	s8,80(a1)
    80001c74:	0585bc83          	ld	s9,88(a1)
    80001c78:	0605bd03          	ld	s10,96(a1)
    80001c7c:	0685bd83          	ld	s11,104(a1)
    80001c80:	8082                	ret

0000000080001c82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c82:	1141                	addi	sp,sp,-16
    80001c84:	e406                	sd	ra,8(sp)
    80001c86:	e022                	sd	s0,0(sp)
    80001c88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c8a:	00006597          	auipc	a1,0x6
    80001c8e:	60e58593          	addi	a1,a1,1550 # 80008298 <states.1717+0x30>
    80001c92:	0022d517          	auipc	a0,0x22d
    80001c96:	20650513          	addi	a0,a0,518 # 8022ee98 <tickslock>
    80001c9a:	00004097          	auipc	ra,0x4
    80001c9e:	5a8080e7          	jalr	1448(ra) # 80006242 <initlock>
}
    80001ca2:	60a2                	ld	ra,8(sp)
    80001ca4:	6402                	ld	s0,0(sp)
    80001ca6:	0141                	addi	sp,sp,16
    80001ca8:	8082                	ret

0000000080001caa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001caa:	1141                	addi	sp,sp,-16
    80001cac:	e422                	sd	s0,8(sp)
    80001cae:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	00003797          	auipc	a5,0x3
    80001cb4:	4e078793          	addi	a5,a5,1248 # 80005190 <kernelvec>
    80001cb8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cbc:	6422                	ld	s0,8(sp)
    80001cbe:	0141                	addi	sp,sp,16
    80001cc0:	8082                	ret

0000000080001cc2 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e406                	sd	ra,8(sp)
    80001cc6:	e022                	sd	s0,0(sp)
    80001cc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cca:	fffff097          	auipc	ra,0xfffff
    80001cce:	394080e7          	jalr	916(ra) # 8000105e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cdc:	00005617          	auipc	a2,0x5
    80001ce0:	32460613          	addi	a2,a2,804 # 80007000 <_trampoline>
    80001ce4:	00005697          	auipc	a3,0x5
    80001ce8:	31c68693          	addi	a3,a3,796 # 80007000 <_trampoline>
    80001cec:	8e91                	sub	a3,a3,a2
    80001cee:	040007b7          	lui	a5,0x4000
    80001cf2:	17fd                	addi	a5,a5,-1
    80001cf4:	07b2                	slli	a5,a5,0xc
    80001cf6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf8:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cfc:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cfe:	180026f3          	csrr	a3,satp
    80001d02:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d04:	6d38                	ld	a4,88(a0)
    80001d06:	6134                	ld	a3,64(a0)
    80001d08:	6585                	lui	a1,0x1
    80001d0a:	96ae                	add	a3,a3,a1
    80001d0c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d0e:	6d38                	ld	a4,88(a0)
    80001d10:	00000697          	auipc	a3,0x0
    80001d14:	13868693          	addi	a3,a3,312 # 80001e48 <usertrap>
    80001d18:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d1a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d1c:	8692                	mv	a3,tp
    80001d1e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d20:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d24:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d28:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d2c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d30:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d32:	6f18                	ld	a4,24(a4)
    80001d34:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d38:	692c                	ld	a1,80(a0)
    80001d3a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d3c:	00005717          	auipc	a4,0x5
    80001d40:	35470713          	addi	a4,a4,852 # 80007090 <userret>
    80001d44:	8f11                	sub	a4,a4,a2
    80001d46:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d48:	577d                	li	a4,-1
    80001d4a:	177e                	slli	a4,a4,0x3f
    80001d4c:	8dd9                	or	a1,a1,a4
    80001d4e:	02000537          	lui	a0,0x2000
    80001d52:	157d                	addi	a0,a0,-1
    80001d54:	0536                	slli	a0,a0,0xd
    80001d56:	9782                	jalr	a5
}
    80001d58:	60a2                	ld	ra,8(sp)
    80001d5a:	6402                	ld	s0,0(sp)
    80001d5c:	0141                	addi	sp,sp,16
    80001d5e:	8082                	ret

0000000080001d60 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d60:	1101                	addi	sp,sp,-32
    80001d62:	ec06                	sd	ra,24(sp)
    80001d64:	e822                	sd	s0,16(sp)
    80001d66:	e426                	sd	s1,8(sp)
    80001d68:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d6a:	0022d497          	auipc	s1,0x22d
    80001d6e:	12e48493          	addi	s1,s1,302 # 8022ee98 <tickslock>
    80001d72:	8526                	mv	a0,s1
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	55e080e7          	jalr	1374(ra) # 800062d2 <acquire>
  ticks++;
    80001d7c:	00007517          	auipc	a0,0x7
    80001d80:	29c50513          	addi	a0,a0,668 # 80009018 <ticks>
    80001d84:	411c                	lw	a5,0(a0)
    80001d86:	2785                	addiw	a5,a5,1
    80001d88:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	b1c080e7          	jalr	-1252(ra) # 800018a6 <wakeup>
  release(&tickslock);
    80001d92:	8526                	mv	a0,s1
    80001d94:	00004097          	auipc	ra,0x4
    80001d98:	5f2080e7          	jalr	1522(ra) # 80006386 <release>
}
    80001d9c:	60e2                	ld	ra,24(sp)
    80001d9e:	6442                	ld	s0,16(sp)
    80001da0:	64a2                	ld	s1,8(sp)
    80001da2:	6105                	addi	sp,sp,32
    80001da4:	8082                	ret

0000000080001da6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001da6:	1101                	addi	sp,sp,-32
    80001da8:	ec06                	sd	ra,24(sp)
    80001daa:	e822                	sd	s0,16(sp)
    80001dac:	e426                	sd	s1,8(sp)
    80001dae:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001db4:	00074d63          	bltz	a4,80001dce <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001db8:	57fd                	li	a5,-1
    80001dba:	17fe                	slli	a5,a5,0x3f
    80001dbc:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dbe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dc0:	06f70363          	beq	a4,a5,80001e26 <devintr+0x80>
  }
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	64a2                	ld	s1,8(sp)
    80001dca:	6105                	addi	sp,sp,32
    80001dcc:	8082                	ret
     (scause & 0xff) == 9){
    80001dce:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001dd2:	46a5                	li	a3,9
    80001dd4:	fed792e3          	bne	a5,a3,80001db8 <devintr+0x12>
    int irq = plic_claim();
    80001dd8:	00003097          	auipc	ra,0x3
    80001ddc:	4c0080e7          	jalr	1216(ra) # 80005298 <plic_claim>
    80001de0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001de2:	47a9                	li	a5,10
    80001de4:	02f50763          	beq	a0,a5,80001e12 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001de8:	4785                	li	a5,1
    80001dea:	02f50963          	beq	a0,a5,80001e1c <devintr+0x76>
    return 1;
    80001dee:	4505                	li	a0,1
    } else if(irq){
    80001df0:	d8f1                	beqz	s1,80001dc4 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001df2:	85a6                	mv	a1,s1
    80001df4:	00006517          	auipc	a0,0x6
    80001df8:	4ac50513          	addi	a0,a0,1196 # 800082a0 <states.1717+0x38>
    80001dfc:	00004097          	auipc	ra,0x4
    80001e00:	fd6080e7          	jalr	-42(ra) # 80005dd2 <printf>
      plic_complete(irq);
    80001e04:	8526                	mv	a0,s1
    80001e06:	00003097          	auipc	ra,0x3
    80001e0a:	4b6080e7          	jalr	1206(ra) # 800052bc <plic_complete>
    return 1;
    80001e0e:	4505                	li	a0,1
    80001e10:	bf55                	j	80001dc4 <devintr+0x1e>
      uartintr();
    80001e12:	00004097          	auipc	ra,0x4
    80001e16:	3e0080e7          	jalr	992(ra) # 800061f2 <uartintr>
    80001e1a:	b7ed                	j	80001e04 <devintr+0x5e>
      virtio_disk_intr();
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	980080e7          	jalr	-1664(ra) # 8000579c <virtio_disk_intr>
    80001e24:	b7c5                	j	80001e04 <devintr+0x5e>
    if(cpuid() == 0){
    80001e26:	fffff097          	auipc	ra,0xfffff
    80001e2a:	20c080e7          	jalr	524(ra) # 80001032 <cpuid>
    80001e2e:	c901                	beqz	a0,80001e3e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e30:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e34:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e36:	14479073          	csrw	sip,a5
    return 2;
    80001e3a:	4509                	li	a0,2
    80001e3c:	b761                	j	80001dc4 <devintr+0x1e>
      clockintr();
    80001e3e:	00000097          	auipc	ra,0x0
    80001e42:	f22080e7          	jalr	-222(ra) # 80001d60 <clockintr>
    80001e46:	b7ed                	j	80001e30 <devintr+0x8a>

0000000080001e48 <usertrap>:
{
    80001e48:	7179                	addi	sp,sp,-48
    80001e4a:	f406                	sd	ra,40(sp)
    80001e4c:	f022                	sd	s0,32(sp)
    80001e4e:	ec26                	sd	s1,24(sp)
    80001e50:	e84a                	sd	s2,16(sp)
    80001e52:	e44e                	sd	s3,8(sp)
    80001e54:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e56:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e5a:	1007f793          	andi	a5,a5,256
    80001e5e:	e3b5                	bnez	a5,80001ec2 <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e60:	00003797          	auipc	a5,0x3
    80001e64:	33078793          	addi	a5,a5,816 # 80005190 <kernelvec>
    80001e68:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e6c:	fffff097          	auipc	ra,0xfffff
    80001e70:	1f2080e7          	jalr	498(ra) # 8000105e <myproc>
    80001e74:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e76:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e78:	14102773          	csrr	a4,sepc
    80001e7c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e7e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e82:	47a1                	li	a5,8
    80001e84:	04f71d63          	bne	a4,a5,80001ede <usertrap+0x96>
    if(p->killed)
    80001e88:	551c                	lw	a5,40(a0)
    80001e8a:	e7a1                	bnez	a5,80001ed2 <usertrap+0x8a>
    p->trapframe->epc += 4;
    80001e8c:	6cb8                	ld	a4,88(s1)
    80001e8e:	6f1c                	ld	a5,24(a4)
    80001e90:	0791                	addi	a5,a5,4
    80001e92:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e9c:	10079073          	csrw	sstatus,a5
    syscall();
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	336080e7          	jalr	822(ra) # 800021d6 <syscall>
  if(p->killed)
    80001ea8:	549c                	lw	a5,40(s1)
    80001eaa:	e3fd                	bnez	a5,80001f90 <usertrap+0x148>
  usertrapret();
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	e16080e7          	jalr	-490(ra) # 80001cc2 <usertrapret>
}
    80001eb4:	70a2                	ld	ra,40(sp)
    80001eb6:	7402                	ld	s0,32(sp)
    80001eb8:	64e2                	ld	s1,24(sp)
    80001eba:	6942                	ld	s2,16(sp)
    80001ebc:	69a2                	ld	s3,8(sp)
    80001ebe:	6145                	addi	sp,sp,48
    80001ec0:	8082                	ret
    panic("usertrap: not from user mode");
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	3fe50513          	addi	a0,a0,1022 # 800082c0 <states.1717+0x58>
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	ebe080e7          	jalr	-322(ra) # 80005d88 <panic>
      exit(-1);
    80001ed2:	557d                	li	a0,-1
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	aa2080e7          	jalr	-1374(ra) # 80001976 <exit>
    80001edc:	bf45                	j	80001e8c <usertrap+0x44>
  } else if((which_dev = devintr()) != 0){
    80001ede:	00000097          	auipc	ra,0x0
    80001ee2:	ec8080e7          	jalr	-312(ra) # 80001da6 <devintr>
    80001ee6:	892a                	mv	s2,a0
    80001ee8:	e14d                	bnez	a0,80001f8a <usertrap+0x142>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eea:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15 || r_scause() == 13 ){
    80001eee:	47bd                	li	a5,15
    80001ef0:	00f70763          	beq	a4,a5,80001efe <usertrap+0xb6>
    80001ef4:	14202773          	csrr	a4,scause
    80001ef8:	47b5                	li	a5,13
    80001efa:	04f71e63          	bne	a4,a5,80001f56 <usertrap+0x10e>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001efe:	143029f3          	csrr	s3,stval
    if(if_cow(p->pagetable , va))
    80001f02:	85ce                	mv	a1,s3
    80001f04:	68a8                	ld	a0,80(s1)
    80001f06:	fffff097          	auipc	ra,0xfffff
    80001f0a:	e5a080e7          	jalr	-422(ra) # 80000d60 <if_cow>
    80001f0e:	e105                	bnez	a0,80001f2e <usertrap+0xe6>
      p->killed = 1;
    80001f10:	4785                	li	a5,1
    80001f12:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f14:	557d                	li	a0,-1
    80001f16:	00000097          	auipc	ra,0x0
    80001f1a:	a60080e7          	jalr	-1440(ra) # 80001976 <exit>
  if(which_dev == 2)
    80001f1e:	4789                	li	a5,2
    80001f20:	f8f916e3          	bne	s2,a5,80001eac <usertrap+0x64>
    yield();
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	7ba080e7          	jalr	1978(ra) # 800016de <yield>
    80001f2c:	b741                	j	80001eac <usertrap+0x64>
      if(cow(p->pagetable , va) == -1)
    80001f2e:	85ce                	mv	a1,s3
    80001f30:	68a8                	ld	a0,80(s1)
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	e74080e7          	jalr	-396(ra) # 80000da6 <cow>
    80001f3a:	57fd                	li	a5,-1
    80001f3c:	f6f516e3          	bne	a0,a5,80001ea8 <usertrap+0x60>
        printf("usertrap(): cow failed!\n");
    80001f40:	00006517          	auipc	a0,0x6
    80001f44:	3a050513          	addi	a0,a0,928 # 800082e0 <states.1717+0x78>
    80001f48:	00004097          	auipc	ra,0x4
    80001f4c:	e8a080e7          	jalr	-374(ra) # 80005dd2 <printf>
        p->killed = 1;
    80001f50:	4785                	li	a5,1
    80001f52:	d49c                	sw	a5,40(s1)
    80001f54:	b7c1                	j	80001f14 <usertrap+0xcc>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f5a:	5890                	lw	a2,48(s1)
    80001f5c:	00006517          	auipc	a0,0x6
    80001f60:	3a450513          	addi	a0,a0,932 # 80008300 <states.1717+0x98>
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	e6e080e7          	jalr	-402(ra) # 80005dd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f6c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f70:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	3bc50513          	addi	a0,a0,956 # 80008330 <states.1717+0xc8>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	e56080e7          	jalr	-426(ra) # 80005dd2 <printf>
    p->killed = 1;
    80001f84:	4785                	li	a5,1
    80001f86:	d49c                	sw	a5,40(s1)
    80001f88:	b771                	j	80001f14 <usertrap+0xcc>
  if(p->killed)
    80001f8a:	549c                	lw	a5,40(s1)
    80001f8c:	dbc9                	beqz	a5,80001f1e <usertrap+0xd6>
    80001f8e:	b759                	j	80001f14 <usertrap+0xcc>
    80001f90:	4901                	li	s2,0
    80001f92:	b749                	j	80001f14 <usertrap+0xcc>

0000000080001f94 <kerneltrap>:
{
    80001f94:	7179                	addi	sp,sp,-48
    80001f96:	f406                	sd	ra,40(sp)
    80001f98:	f022                	sd	s0,32(sp)
    80001f9a:	ec26                	sd	s1,24(sp)
    80001f9c:	e84a                	sd	s2,16(sp)
    80001f9e:	e44e                	sd	s3,8(sp)
    80001fa0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fa2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001faa:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001fae:	1004f793          	andi	a5,s1,256
    80001fb2:	cb85                	beqz	a5,80001fe2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fb8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001fba:	ef85                	bnez	a5,80001ff2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	dea080e7          	jalr	-534(ra) # 80001da6 <devintr>
    80001fc4:	cd1d                	beqz	a0,80002002 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fc6:	4789                	li	a5,2
    80001fc8:	06f50a63          	beq	a0,a5,8000203c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fcc:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fd0:	10049073          	csrw	sstatus,s1
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	69a2                	ld	s3,8(sp)
    80001fde:	6145                	addi	sp,sp,48
    80001fe0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fe2:	00006517          	auipc	a0,0x6
    80001fe6:	36e50513          	addi	a0,a0,878 # 80008350 <states.1717+0xe8>
    80001fea:	00004097          	auipc	ra,0x4
    80001fee:	d9e080e7          	jalr	-610(ra) # 80005d88 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	38650513          	addi	a0,a0,902 # 80008378 <states.1717+0x110>
    80001ffa:	00004097          	auipc	ra,0x4
    80001ffe:	d8e080e7          	jalr	-626(ra) # 80005d88 <panic>
    printf("scause %p\n", scause);
    80002002:	85ce                	mv	a1,s3
    80002004:	00006517          	auipc	a0,0x6
    80002008:	39450513          	addi	a0,a0,916 # 80008398 <states.1717+0x130>
    8000200c:	00004097          	auipc	ra,0x4
    80002010:	dc6080e7          	jalr	-570(ra) # 80005dd2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002014:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002018:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000201c:	00006517          	auipc	a0,0x6
    80002020:	38c50513          	addi	a0,a0,908 # 800083a8 <states.1717+0x140>
    80002024:	00004097          	auipc	ra,0x4
    80002028:	dae080e7          	jalr	-594(ra) # 80005dd2 <printf>
    panic("kerneltrap");
    8000202c:	00006517          	auipc	a0,0x6
    80002030:	39450513          	addi	a0,a0,916 # 800083c0 <states.1717+0x158>
    80002034:	00004097          	auipc	ra,0x4
    80002038:	d54080e7          	jalr	-684(ra) # 80005d88 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	022080e7          	jalr	34(ra) # 8000105e <myproc>
    80002044:	d541                	beqz	a0,80001fcc <kerneltrap+0x38>
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	018080e7          	jalr	24(ra) # 8000105e <myproc>
    8000204e:	4d18                	lw	a4,24(a0)
    80002050:	4791                	li	a5,4
    80002052:	f6f71de3          	bne	a4,a5,80001fcc <kerneltrap+0x38>
    yield();
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	688080e7          	jalr	1672(ra) # 800016de <yield>
    8000205e:	b7bd                	j	80001fcc <kerneltrap+0x38>

0000000080002060 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002060:	1101                	addi	sp,sp,-32
    80002062:	ec06                	sd	ra,24(sp)
    80002064:	e822                	sd	s0,16(sp)
    80002066:	e426                	sd	s1,8(sp)
    80002068:	1000                	addi	s0,sp,32
    8000206a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	ff2080e7          	jalr	-14(ra) # 8000105e <myproc>
  switch (n) {
    80002074:	4795                	li	a5,5
    80002076:	0497e163          	bltu	a5,s1,800020b8 <argraw+0x58>
    8000207a:	048a                	slli	s1,s1,0x2
    8000207c:	00006717          	auipc	a4,0x6
    80002080:	37c70713          	addi	a4,a4,892 # 800083f8 <states.1717+0x190>
    80002084:	94ba                	add	s1,s1,a4
    80002086:	409c                	lw	a5,0(s1)
    80002088:	97ba                	add	a5,a5,a4
    8000208a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000208c:	6d3c                	ld	a5,88(a0)
    8000208e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002090:	60e2                	ld	ra,24(sp)
    80002092:	6442                	ld	s0,16(sp)
    80002094:	64a2                	ld	s1,8(sp)
    80002096:	6105                	addi	sp,sp,32
    80002098:	8082                	ret
    return p->trapframe->a1;
    8000209a:	6d3c                	ld	a5,88(a0)
    8000209c:	7fa8                	ld	a0,120(a5)
    8000209e:	bfcd                	j	80002090 <argraw+0x30>
    return p->trapframe->a2;
    800020a0:	6d3c                	ld	a5,88(a0)
    800020a2:	63c8                	ld	a0,128(a5)
    800020a4:	b7f5                	j	80002090 <argraw+0x30>
    return p->trapframe->a3;
    800020a6:	6d3c                	ld	a5,88(a0)
    800020a8:	67c8                	ld	a0,136(a5)
    800020aa:	b7dd                	j	80002090 <argraw+0x30>
    return p->trapframe->a4;
    800020ac:	6d3c                	ld	a5,88(a0)
    800020ae:	6bc8                	ld	a0,144(a5)
    800020b0:	b7c5                	j	80002090 <argraw+0x30>
    return p->trapframe->a5;
    800020b2:	6d3c                	ld	a5,88(a0)
    800020b4:	6fc8                	ld	a0,152(a5)
    800020b6:	bfe9                	j	80002090 <argraw+0x30>
  panic("argraw");
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	31850513          	addi	a0,a0,792 # 800083d0 <states.1717+0x168>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	cc8080e7          	jalr	-824(ra) # 80005d88 <panic>

00000000800020c8 <fetchaddr>:
{
    800020c8:	1101                	addi	sp,sp,-32
    800020ca:	ec06                	sd	ra,24(sp)
    800020cc:	e822                	sd	s0,16(sp)
    800020ce:	e426                	sd	s1,8(sp)
    800020d0:	e04a                	sd	s2,0(sp)
    800020d2:	1000                	addi	s0,sp,32
    800020d4:	84aa                	mv	s1,a0
    800020d6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	f86080e7          	jalr	-122(ra) # 8000105e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020e0:	653c                	ld	a5,72(a0)
    800020e2:	02f4f863          	bgeu	s1,a5,80002112 <fetchaddr+0x4a>
    800020e6:	00848713          	addi	a4,s1,8
    800020ea:	02e7e663          	bltu	a5,a4,80002116 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020ee:	46a1                	li	a3,8
    800020f0:	8626                	mv	a2,s1
    800020f2:	85ca                	mv	a1,s2
    800020f4:	6928                	ld	a0,80(a0)
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	b2a080e7          	jalr	-1238(ra) # 80000c20 <copyin>
    800020fe:	00a03533          	snez	a0,a0
    80002102:	40a00533          	neg	a0,a0
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6902                	ld	s2,0(sp)
    8000210e:	6105                	addi	sp,sp,32
    80002110:	8082                	ret
    return -1;
    80002112:	557d                	li	a0,-1
    80002114:	bfcd                	j	80002106 <fetchaddr+0x3e>
    80002116:	557d                	li	a0,-1
    80002118:	b7fd                	j	80002106 <fetchaddr+0x3e>

000000008000211a <fetchstr>:
{
    8000211a:	7179                	addi	sp,sp,-48
    8000211c:	f406                	sd	ra,40(sp)
    8000211e:	f022                	sd	s0,32(sp)
    80002120:	ec26                	sd	s1,24(sp)
    80002122:	e84a                	sd	s2,16(sp)
    80002124:	e44e                	sd	s3,8(sp)
    80002126:	1800                	addi	s0,sp,48
    80002128:	892a                	mv	s2,a0
    8000212a:	84ae                	mv	s1,a1
    8000212c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000212e:	fffff097          	auipc	ra,0xfffff
    80002132:	f30080e7          	jalr	-208(ra) # 8000105e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002136:	86ce                	mv	a3,s3
    80002138:	864a                	mv	a2,s2
    8000213a:	85a6                	mv	a1,s1
    8000213c:	6928                	ld	a0,80(a0)
    8000213e:	fffff097          	auipc	ra,0xfffff
    80002142:	b6e080e7          	jalr	-1170(ra) # 80000cac <copyinstr>
  if(err < 0)
    80002146:	00054763          	bltz	a0,80002154 <fetchstr+0x3a>
  return strlen(buf);
    8000214a:	8526                	mv	a0,s1
    8000214c:	ffffe097          	auipc	ra,0xffffe
    80002150:	2d8080e7          	jalr	728(ra) # 80000424 <strlen>
}
    80002154:	70a2                	ld	ra,40(sp)
    80002156:	7402                	ld	s0,32(sp)
    80002158:	64e2                	ld	s1,24(sp)
    8000215a:	6942                	ld	s2,16(sp)
    8000215c:	69a2                	ld	s3,8(sp)
    8000215e:	6145                	addi	sp,sp,48
    80002160:	8082                	ret

0000000080002162 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002162:	1101                	addi	sp,sp,-32
    80002164:	ec06                	sd	ra,24(sp)
    80002166:	e822                	sd	s0,16(sp)
    80002168:	e426                	sd	s1,8(sp)
    8000216a:	1000                	addi	s0,sp,32
    8000216c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000216e:	00000097          	auipc	ra,0x0
    80002172:	ef2080e7          	jalr	-270(ra) # 80002060 <argraw>
    80002176:	c088                	sw	a0,0(s1)
  return 0;
}
    80002178:	4501                	li	a0,0
    8000217a:	60e2                	ld	ra,24(sp)
    8000217c:	6442                	ld	s0,16(sp)
    8000217e:	64a2                	ld	s1,8(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002184:	1101                	addi	sp,sp,-32
    80002186:	ec06                	sd	ra,24(sp)
    80002188:	e822                	sd	s0,16(sp)
    8000218a:	e426                	sd	s1,8(sp)
    8000218c:	1000                	addi	s0,sp,32
    8000218e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002190:	00000097          	auipc	ra,0x0
    80002194:	ed0080e7          	jalr	-304(ra) # 80002060 <argraw>
    80002198:	e088                	sd	a0,0(s1)
  return 0;
}
    8000219a:	4501                	li	a0,0
    8000219c:	60e2                	ld	ra,24(sp)
    8000219e:	6442                	ld	s0,16(sp)
    800021a0:	64a2                	ld	s1,8(sp)
    800021a2:	6105                	addi	sp,sp,32
    800021a4:	8082                	ret

00000000800021a6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800021a6:	1101                	addi	sp,sp,-32
    800021a8:	ec06                	sd	ra,24(sp)
    800021aa:	e822                	sd	s0,16(sp)
    800021ac:	e426                	sd	s1,8(sp)
    800021ae:	e04a                	sd	s2,0(sp)
    800021b0:	1000                	addi	s0,sp,32
    800021b2:	84ae                	mv	s1,a1
    800021b4:	8932                	mv	s2,a2
  *ip = argraw(n);
    800021b6:	00000097          	auipc	ra,0x0
    800021ba:	eaa080e7          	jalr	-342(ra) # 80002060 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021be:	864a                	mv	a2,s2
    800021c0:	85a6                	mv	a1,s1
    800021c2:	00000097          	auipc	ra,0x0
    800021c6:	f58080e7          	jalr	-168(ra) # 8000211a <fetchstr>
}
    800021ca:	60e2                	ld	ra,24(sp)
    800021cc:	6442                	ld	s0,16(sp)
    800021ce:	64a2                	ld	s1,8(sp)
    800021d0:	6902                	ld	s2,0(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	e426                	sd	s1,8(sp)
    800021de:	e04a                	sd	s2,0(sp)
    800021e0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	e7c080e7          	jalr	-388(ra) # 8000105e <myproc>
    800021ea:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021ec:	05853903          	ld	s2,88(a0)
    800021f0:	0a893783          	ld	a5,168(s2)
    800021f4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021f8:	37fd                	addiw	a5,a5,-1
    800021fa:	4751                	li	a4,20
    800021fc:	00f76f63          	bltu	a4,a5,8000221a <syscall+0x44>
    80002200:	00369713          	slli	a4,a3,0x3
    80002204:	00006797          	auipc	a5,0x6
    80002208:	20c78793          	addi	a5,a5,524 # 80008410 <syscalls>
    8000220c:	97ba                	add	a5,a5,a4
    8000220e:	639c                	ld	a5,0(a5)
    80002210:	c789                	beqz	a5,8000221a <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002212:	9782                	jalr	a5
    80002214:	06a93823          	sd	a0,112(s2)
    80002218:	a839                	j	80002236 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000221a:	15848613          	addi	a2,s1,344
    8000221e:	588c                	lw	a1,48(s1)
    80002220:	00006517          	auipc	a0,0x6
    80002224:	1b850513          	addi	a0,a0,440 # 800083d8 <states.1717+0x170>
    80002228:	00004097          	auipc	ra,0x4
    8000222c:	baa080e7          	jalr	-1110(ra) # 80005dd2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002230:	6cbc                	ld	a5,88(s1)
    80002232:	577d                	li	a4,-1
    80002234:	fbb8                	sd	a4,112(a5)
  }
}
    80002236:	60e2                	ld	ra,24(sp)
    80002238:	6442                	ld	s0,16(sp)
    8000223a:	64a2                	ld	s1,8(sp)
    8000223c:	6902                	ld	s2,0(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret

0000000080002242 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002242:	1101                	addi	sp,sp,-32
    80002244:	ec06                	sd	ra,24(sp)
    80002246:	e822                	sd	s0,16(sp)
    80002248:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000224a:	fec40593          	addi	a1,s0,-20
    8000224e:	4501                	li	a0,0
    80002250:	00000097          	auipc	ra,0x0
    80002254:	f12080e7          	jalr	-238(ra) # 80002162 <argint>
    return -1;
    80002258:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000225a:	00054963          	bltz	a0,8000226c <sys_exit+0x2a>
  exit(n);
    8000225e:	fec42503          	lw	a0,-20(s0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	714080e7          	jalr	1812(ra) # 80001976 <exit>
  return 0;  // not reached
    8000226a:	4781                	li	a5,0
}
    8000226c:	853e                	mv	a0,a5
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	6105                	addi	sp,sp,32
    80002274:	8082                	ret

0000000080002276 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002276:	1141                	addi	sp,sp,-16
    80002278:	e406                	sd	ra,8(sp)
    8000227a:	e022                	sd	s0,0(sp)
    8000227c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000227e:	fffff097          	auipc	ra,0xfffff
    80002282:	de0080e7          	jalr	-544(ra) # 8000105e <myproc>
}
    80002286:	5908                	lw	a0,48(a0)
    80002288:	60a2                	ld	ra,8(sp)
    8000228a:	6402                	ld	s0,0(sp)
    8000228c:	0141                	addi	sp,sp,16
    8000228e:	8082                	ret

0000000080002290 <sys_fork>:

uint64
sys_fork(void)
{
    80002290:	1141                	addi	sp,sp,-16
    80002292:	e406                	sd	ra,8(sp)
    80002294:	e022                	sd	s0,0(sp)
    80002296:	0800                	addi	s0,sp,16
  return fork();
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	194080e7          	jalr	404(ra) # 8000142c <fork>
}
    800022a0:	60a2                	ld	ra,8(sp)
    800022a2:	6402                	ld	s0,0(sp)
    800022a4:	0141                	addi	sp,sp,16
    800022a6:	8082                	ret

00000000800022a8 <sys_wait>:

uint64
sys_wait(void)
{
    800022a8:	1101                	addi	sp,sp,-32
    800022aa:	ec06                	sd	ra,24(sp)
    800022ac:	e822                	sd	s0,16(sp)
    800022ae:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022b0:	fe840593          	addi	a1,s0,-24
    800022b4:	4501                	li	a0,0
    800022b6:	00000097          	auipc	ra,0x0
    800022ba:	ece080e7          	jalr	-306(ra) # 80002184 <argaddr>
    800022be:	87aa                	mv	a5,a0
    return -1;
    800022c0:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022c2:	0007c863          	bltz	a5,800022d2 <sys_wait+0x2a>
  return wait(p);
    800022c6:	fe843503          	ld	a0,-24(s0)
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	4b4080e7          	jalr	1204(ra) # 8000177e <wait>
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	6105                	addi	sp,sp,32
    800022d8:	8082                	ret

00000000800022da <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022da:	7179                	addi	sp,sp,-48
    800022dc:	f406                	sd	ra,40(sp)
    800022de:	f022                	sd	s0,32(sp)
    800022e0:	ec26                	sd	s1,24(sp)
    800022e2:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022e4:	fdc40593          	addi	a1,s0,-36
    800022e8:	4501                	li	a0,0
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	e78080e7          	jalr	-392(ra) # 80002162 <argint>
    800022f2:	87aa                	mv	a5,a0
    return -1;
    800022f4:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022f6:	0207c063          	bltz	a5,80002316 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    800022fa:	fffff097          	auipc	ra,0xfffff
    800022fe:	d64080e7          	jalr	-668(ra) # 8000105e <myproc>
    80002302:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002304:	fdc42503          	lw	a0,-36(s0)
    80002308:	fffff097          	auipc	ra,0xfffff
    8000230c:	0b0080e7          	jalr	176(ra) # 800013b8 <growproc>
    80002310:	00054863          	bltz	a0,80002320 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002314:	8526                	mv	a0,s1
}
    80002316:	70a2                	ld	ra,40(sp)
    80002318:	7402                	ld	s0,32(sp)
    8000231a:	64e2                	ld	s1,24(sp)
    8000231c:	6145                	addi	sp,sp,48
    8000231e:	8082                	ret
    return -1;
    80002320:	557d                	li	a0,-1
    80002322:	bfd5                	j	80002316 <sys_sbrk+0x3c>

0000000080002324 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002324:	7139                	addi	sp,sp,-64
    80002326:	fc06                	sd	ra,56(sp)
    80002328:	f822                	sd	s0,48(sp)
    8000232a:	f426                	sd	s1,40(sp)
    8000232c:	f04a                	sd	s2,32(sp)
    8000232e:	ec4e                	sd	s3,24(sp)
    80002330:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002332:	fcc40593          	addi	a1,s0,-52
    80002336:	4501                	li	a0,0
    80002338:	00000097          	auipc	ra,0x0
    8000233c:	e2a080e7          	jalr	-470(ra) # 80002162 <argint>
    return -1;
    80002340:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002342:	06054563          	bltz	a0,800023ac <sys_sleep+0x88>
  acquire(&tickslock);
    80002346:	0022d517          	auipc	a0,0x22d
    8000234a:	b5250513          	addi	a0,a0,-1198 # 8022ee98 <tickslock>
    8000234e:	00004097          	auipc	ra,0x4
    80002352:	f84080e7          	jalr	-124(ra) # 800062d2 <acquire>
  ticks0 = ticks;
    80002356:	00007917          	auipc	s2,0x7
    8000235a:	cc292903          	lw	s2,-830(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000235e:	fcc42783          	lw	a5,-52(s0)
    80002362:	cf85                	beqz	a5,8000239a <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002364:	0022d997          	auipc	s3,0x22d
    80002368:	b3498993          	addi	s3,s3,-1228 # 8022ee98 <tickslock>
    8000236c:	00007497          	auipc	s1,0x7
    80002370:	cac48493          	addi	s1,s1,-852 # 80009018 <ticks>
    if(myproc()->killed){
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	cea080e7          	jalr	-790(ra) # 8000105e <myproc>
    8000237c:	551c                	lw	a5,40(a0)
    8000237e:	ef9d                	bnez	a5,800023bc <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002380:	85ce                	mv	a1,s3
    80002382:	8526                	mv	a0,s1
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	396080e7          	jalr	918(ra) # 8000171a <sleep>
  while(ticks - ticks0 < n){
    8000238c:	409c                	lw	a5,0(s1)
    8000238e:	412787bb          	subw	a5,a5,s2
    80002392:	fcc42703          	lw	a4,-52(s0)
    80002396:	fce7efe3          	bltu	a5,a4,80002374 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000239a:	0022d517          	auipc	a0,0x22d
    8000239e:	afe50513          	addi	a0,a0,-1282 # 8022ee98 <tickslock>
    800023a2:	00004097          	auipc	ra,0x4
    800023a6:	fe4080e7          	jalr	-28(ra) # 80006386 <release>
  return 0;
    800023aa:	4781                	li	a5,0
}
    800023ac:	853e                	mv	a0,a5
    800023ae:	70e2                	ld	ra,56(sp)
    800023b0:	7442                	ld	s0,48(sp)
    800023b2:	74a2                	ld	s1,40(sp)
    800023b4:	7902                	ld	s2,32(sp)
    800023b6:	69e2                	ld	s3,24(sp)
    800023b8:	6121                	addi	sp,sp,64
    800023ba:	8082                	ret
      release(&tickslock);
    800023bc:	0022d517          	auipc	a0,0x22d
    800023c0:	adc50513          	addi	a0,a0,-1316 # 8022ee98 <tickslock>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	fc2080e7          	jalr	-62(ra) # 80006386 <release>
      return -1;
    800023cc:	57fd                	li	a5,-1
    800023ce:	bff9                	j	800023ac <sys_sleep+0x88>

00000000800023d0 <sys_kill>:

uint64
sys_kill(void)
{
    800023d0:	1101                	addi	sp,sp,-32
    800023d2:	ec06                	sd	ra,24(sp)
    800023d4:	e822                	sd	s0,16(sp)
    800023d6:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023d8:	fec40593          	addi	a1,s0,-20
    800023dc:	4501                	li	a0,0
    800023de:	00000097          	auipc	ra,0x0
    800023e2:	d84080e7          	jalr	-636(ra) # 80002162 <argint>
    800023e6:	87aa                	mv	a5,a0
    return -1;
    800023e8:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800023ea:	0007c863          	bltz	a5,800023fa <sys_kill+0x2a>
  return kill(pid);
    800023ee:	fec42503          	lw	a0,-20(s0)
    800023f2:	fffff097          	auipc	ra,0xfffff
    800023f6:	65a080e7          	jalr	1626(ra) # 80001a4c <kill>
}
    800023fa:	60e2                	ld	ra,24(sp)
    800023fc:	6442                	ld	s0,16(sp)
    800023fe:	6105                	addi	sp,sp,32
    80002400:	8082                	ret

0000000080002402 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002402:	1101                	addi	sp,sp,-32
    80002404:	ec06                	sd	ra,24(sp)
    80002406:	e822                	sd	s0,16(sp)
    80002408:	e426                	sd	s1,8(sp)
    8000240a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000240c:	0022d517          	auipc	a0,0x22d
    80002410:	a8c50513          	addi	a0,a0,-1396 # 8022ee98 <tickslock>
    80002414:	00004097          	auipc	ra,0x4
    80002418:	ebe080e7          	jalr	-322(ra) # 800062d2 <acquire>
  xticks = ticks;
    8000241c:	00007497          	auipc	s1,0x7
    80002420:	bfc4a483          	lw	s1,-1028(s1) # 80009018 <ticks>
  release(&tickslock);
    80002424:	0022d517          	auipc	a0,0x22d
    80002428:	a7450513          	addi	a0,a0,-1420 # 8022ee98 <tickslock>
    8000242c:	00004097          	auipc	ra,0x4
    80002430:	f5a080e7          	jalr	-166(ra) # 80006386 <release>
  return xticks;
}
    80002434:	02049513          	slli	a0,s1,0x20
    80002438:	9101                	srli	a0,a0,0x20
    8000243a:	60e2                	ld	ra,24(sp)
    8000243c:	6442                	ld	s0,16(sp)
    8000243e:	64a2                	ld	s1,8(sp)
    80002440:	6105                	addi	sp,sp,32
    80002442:	8082                	ret

0000000080002444 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002444:	7179                	addi	sp,sp,-48
    80002446:	f406                	sd	ra,40(sp)
    80002448:	f022                	sd	s0,32(sp)
    8000244a:	ec26                	sd	s1,24(sp)
    8000244c:	e84a                	sd	s2,16(sp)
    8000244e:	e44e                	sd	s3,8(sp)
    80002450:	e052                	sd	s4,0(sp)
    80002452:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002454:	00006597          	auipc	a1,0x6
    80002458:	06c58593          	addi	a1,a1,108 # 800084c0 <syscalls+0xb0>
    8000245c:	0022d517          	auipc	a0,0x22d
    80002460:	a5450513          	addi	a0,a0,-1452 # 8022eeb0 <bcache>
    80002464:	00004097          	auipc	ra,0x4
    80002468:	dde080e7          	jalr	-546(ra) # 80006242 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000246c:	00235797          	auipc	a5,0x235
    80002470:	a4478793          	addi	a5,a5,-1468 # 80236eb0 <bcache+0x8000>
    80002474:	00235717          	auipc	a4,0x235
    80002478:	ca470713          	addi	a4,a4,-860 # 80237118 <bcache+0x8268>
    8000247c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002480:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002484:	0022d497          	auipc	s1,0x22d
    80002488:	a4448493          	addi	s1,s1,-1468 # 8022eec8 <bcache+0x18>
    b->next = bcache.head.next;
    8000248c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000248e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002490:	00006a17          	auipc	s4,0x6
    80002494:	038a0a13          	addi	s4,s4,56 # 800084c8 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002498:	2b893783          	ld	a5,696(s2)
    8000249c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000249e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024a2:	85d2                	mv	a1,s4
    800024a4:	01048513          	addi	a0,s1,16
    800024a8:	00001097          	auipc	ra,0x1
    800024ac:	4bc080e7          	jalr	1212(ra) # 80003964 <initsleeplock>
    bcache.head.next->prev = b;
    800024b0:	2b893783          	ld	a5,696(s2)
    800024b4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024b6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024ba:	45848493          	addi	s1,s1,1112
    800024be:	fd349de3          	bne	s1,s3,80002498 <binit+0x54>
  }
}
    800024c2:	70a2                	ld	ra,40(sp)
    800024c4:	7402                	ld	s0,32(sp)
    800024c6:	64e2                	ld	s1,24(sp)
    800024c8:	6942                	ld	s2,16(sp)
    800024ca:	69a2                	ld	s3,8(sp)
    800024cc:	6a02                	ld	s4,0(sp)
    800024ce:	6145                	addi	sp,sp,48
    800024d0:	8082                	ret

00000000800024d2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024d2:	7179                	addi	sp,sp,-48
    800024d4:	f406                	sd	ra,40(sp)
    800024d6:	f022                	sd	s0,32(sp)
    800024d8:	ec26                	sd	s1,24(sp)
    800024da:	e84a                	sd	s2,16(sp)
    800024dc:	e44e                	sd	s3,8(sp)
    800024de:	1800                	addi	s0,sp,48
    800024e0:	89aa                	mv	s3,a0
    800024e2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800024e4:	0022d517          	auipc	a0,0x22d
    800024e8:	9cc50513          	addi	a0,a0,-1588 # 8022eeb0 <bcache>
    800024ec:	00004097          	auipc	ra,0x4
    800024f0:	de6080e7          	jalr	-538(ra) # 800062d2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800024f4:	00235497          	auipc	s1,0x235
    800024f8:	c744b483          	ld	s1,-908(s1) # 80237168 <bcache+0x82b8>
    800024fc:	00235797          	auipc	a5,0x235
    80002500:	c1c78793          	addi	a5,a5,-996 # 80237118 <bcache+0x8268>
    80002504:	02f48f63          	beq	s1,a5,80002542 <bread+0x70>
    80002508:	873e                	mv	a4,a5
    8000250a:	a021                	j	80002512 <bread+0x40>
    8000250c:	68a4                	ld	s1,80(s1)
    8000250e:	02e48a63          	beq	s1,a4,80002542 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002512:	449c                	lw	a5,8(s1)
    80002514:	ff379ce3          	bne	a5,s3,8000250c <bread+0x3a>
    80002518:	44dc                	lw	a5,12(s1)
    8000251a:	ff2799e3          	bne	a5,s2,8000250c <bread+0x3a>
      b->refcnt++;
    8000251e:	40bc                	lw	a5,64(s1)
    80002520:	2785                	addiw	a5,a5,1
    80002522:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002524:	0022d517          	auipc	a0,0x22d
    80002528:	98c50513          	addi	a0,a0,-1652 # 8022eeb0 <bcache>
    8000252c:	00004097          	auipc	ra,0x4
    80002530:	e5a080e7          	jalr	-422(ra) # 80006386 <release>
      acquiresleep(&b->lock);
    80002534:	01048513          	addi	a0,s1,16
    80002538:	00001097          	auipc	ra,0x1
    8000253c:	466080e7          	jalr	1126(ra) # 8000399e <acquiresleep>
      return b;
    80002540:	a8b9                	j	8000259e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002542:	00235497          	auipc	s1,0x235
    80002546:	c1e4b483          	ld	s1,-994(s1) # 80237160 <bcache+0x82b0>
    8000254a:	00235797          	auipc	a5,0x235
    8000254e:	bce78793          	addi	a5,a5,-1074 # 80237118 <bcache+0x8268>
    80002552:	00f48863          	beq	s1,a5,80002562 <bread+0x90>
    80002556:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002558:	40bc                	lw	a5,64(s1)
    8000255a:	cf81                	beqz	a5,80002572 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000255c:	64a4                	ld	s1,72(s1)
    8000255e:	fee49de3          	bne	s1,a4,80002558 <bread+0x86>
  panic("bget: no buffers");
    80002562:	00006517          	auipc	a0,0x6
    80002566:	f6e50513          	addi	a0,a0,-146 # 800084d0 <syscalls+0xc0>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	81e080e7          	jalr	-2018(ra) # 80005d88 <panic>
      b->dev = dev;
    80002572:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002576:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000257a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000257e:	4785                	li	a5,1
    80002580:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002582:	0022d517          	auipc	a0,0x22d
    80002586:	92e50513          	addi	a0,a0,-1746 # 8022eeb0 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	dfc080e7          	jalr	-516(ra) # 80006386 <release>
      acquiresleep(&b->lock);
    80002592:	01048513          	addi	a0,s1,16
    80002596:	00001097          	auipc	ra,0x1
    8000259a:	408080e7          	jalr	1032(ra) # 8000399e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000259e:	409c                	lw	a5,0(s1)
    800025a0:	cb89                	beqz	a5,800025b2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025a2:	8526                	mv	a0,s1
    800025a4:	70a2                	ld	ra,40(sp)
    800025a6:	7402                	ld	s0,32(sp)
    800025a8:	64e2                	ld	s1,24(sp)
    800025aa:	6942                	ld	s2,16(sp)
    800025ac:	69a2                	ld	s3,8(sp)
    800025ae:	6145                	addi	sp,sp,48
    800025b0:	8082                	ret
    virtio_disk_rw(b, 0);
    800025b2:	4581                	li	a1,0
    800025b4:	8526                	mv	a0,s1
    800025b6:	00003097          	auipc	ra,0x3
    800025ba:	f10080e7          	jalr	-240(ra) # 800054c6 <virtio_disk_rw>
    b->valid = 1;
    800025be:	4785                	li	a5,1
    800025c0:	c09c                	sw	a5,0(s1)
  return b;
    800025c2:	b7c5                	j	800025a2 <bread+0xd0>

00000000800025c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025d0:	0541                	addi	a0,a0,16
    800025d2:	00001097          	auipc	ra,0x1
    800025d6:	466080e7          	jalr	1126(ra) # 80003a38 <holdingsleep>
    800025da:	cd01                	beqz	a0,800025f2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025dc:	4585                	li	a1,1
    800025de:	8526                	mv	a0,s1
    800025e0:	00003097          	auipc	ra,0x3
    800025e4:	ee6080e7          	jalr	-282(ra) # 800054c6 <virtio_disk_rw>
}
    800025e8:	60e2                	ld	ra,24(sp)
    800025ea:	6442                	ld	s0,16(sp)
    800025ec:	64a2                	ld	s1,8(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret
    panic("bwrite");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	ef650513          	addi	a0,a0,-266 # 800084e8 <syscalls+0xd8>
    800025fa:	00003097          	auipc	ra,0x3
    800025fe:	78e080e7          	jalr	1934(ra) # 80005d88 <panic>

0000000080002602 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	e04a                	sd	s2,0(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002610:	01050913          	addi	s2,a0,16
    80002614:	854a                	mv	a0,s2
    80002616:	00001097          	auipc	ra,0x1
    8000261a:	422080e7          	jalr	1058(ra) # 80003a38 <holdingsleep>
    8000261e:	c92d                	beqz	a0,80002690 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002620:	854a                	mv	a0,s2
    80002622:	00001097          	auipc	ra,0x1
    80002626:	3d2080e7          	jalr	978(ra) # 800039f4 <releasesleep>

  acquire(&bcache.lock);
    8000262a:	0022d517          	auipc	a0,0x22d
    8000262e:	88650513          	addi	a0,a0,-1914 # 8022eeb0 <bcache>
    80002632:	00004097          	auipc	ra,0x4
    80002636:	ca0080e7          	jalr	-864(ra) # 800062d2 <acquire>
  b->refcnt--;
    8000263a:	40bc                	lw	a5,64(s1)
    8000263c:	37fd                	addiw	a5,a5,-1
    8000263e:	0007871b          	sext.w	a4,a5
    80002642:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002644:	eb05                	bnez	a4,80002674 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002646:	68bc                	ld	a5,80(s1)
    80002648:	64b8                	ld	a4,72(s1)
    8000264a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000264c:	64bc                	ld	a5,72(s1)
    8000264e:	68b8                	ld	a4,80(s1)
    80002650:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002652:	00235797          	auipc	a5,0x235
    80002656:	85e78793          	addi	a5,a5,-1954 # 80236eb0 <bcache+0x8000>
    8000265a:	2b87b703          	ld	a4,696(a5)
    8000265e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002660:	00235717          	auipc	a4,0x235
    80002664:	ab870713          	addi	a4,a4,-1352 # 80237118 <bcache+0x8268>
    80002668:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000266a:	2b87b703          	ld	a4,696(a5)
    8000266e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002670:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002674:	0022d517          	auipc	a0,0x22d
    80002678:	83c50513          	addi	a0,a0,-1988 # 8022eeb0 <bcache>
    8000267c:	00004097          	auipc	ra,0x4
    80002680:	d0a080e7          	jalr	-758(ra) # 80006386 <release>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6902                	ld	s2,0(sp)
    8000268c:	6105                	addi	sp,sp,32
    8000268e:	8082                	ret
    panic("brelse");
    80002690:	00006517          	auipc	a0,0x6
    80002694:	e6050513          	addi	a0,a0,-416 # 800084f0 <syscalls+0xe0>
    80002698:	00003097          	auipc	ra,0x3
    8000269c:	6f0080e7          	jalr	1776(ra) # 80005d88 <panic>

00000000800026a0 <bpin>:

void
bpin(struct buf *b) {
    800026a0:	1101                	addi	sp,sp,-32
    800026a2:	ec06                	sd	ra,24(sp)
    800026a4:	e822                	sd	s0,16(sp)
    800026a6:	e426                	sd	s1,8(sp)
    800026a8:	1000                	addi	s0,sp,32
    800026aa:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ac:	0022d517          	auipc	a0,0x22d
    800026b0:	80450513          	addi	a0,a0,-2044 # 8022eeb0 <bcache>
    800026b4:	00004097          	auipc	ra,0x4
    800026b8:	c1e080e7          	jalr	-994(ra) # 800062d2 <acquire>
  b->refcnt++;
    800026bc:	40bc                	lw	a5,64(s1)
    800026be:	2785                	addiw	a5,a5,1
    800026c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026c2:	0022c517          	auipc	a0,0x22c
    800026c6:	7ee50513          	addi	a0,a0,2030 # 8022eeb0 <bcache>
    800026ca:	00004097          	auipc	ra,0x4
    800026ce:	cbc080e7          	jalr	-836(ra) # 80006386 <release>
}
    800026d2:	60e2                	ld	ra,24(sp)
    800026d4:	6442                	ld	s0,16(sp)
    800026d6:	64a2                	ld	s1,8(sp)
    800026d8:	6105                	addi	sp,sp,32
    800026da:	8082                	ret

00000000800026dc <bunpin>:

void
bunpin(struct buf *b) {
    800026dc:	1101                	addi	sp,sp,-32
    800026de:	ec06                	sd	ra,24(sp)
    800026e0:	e822                	sd	s0,16(sp)
    800026e2:	e426                	sd	s1,8(sp)
    800026e4:	1000                	addi	s0,sp,32
    800026e6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026e8:	0022c517          	auipc	a0,0x22c
    800026ec:	7c850513          	addi	a0,a0,1992 # 8022eeb0 <bcache>
    800026f0:	00004097          	auipc	ra,0x4
    800026f4:	be2080e7          	jalr	-1054(ra) # 800062d2 <acquire>
  b->refcnt--;
    800026f8:	40bc                	lw	a5,64(s1)
    800026fa:	37fd                	addiw	a5,a5,-1
    800026fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026fe:	0022c517          	auipc	a0,0x22c
    80002702:	7b250513          	addi	a0,a0,1970 # 8022eeb0 <bcache>
    80002706:	00004097          	auipc	ra,0x4
    8000270a:	c80080e7          	jalr	-896(ra) # 80006386 <release>
}
    8000270e:	60e2                	ld	ra,24(sp)
    80002710:	6442                	ld	s0,16(sp)
    80002712:	64a2                	ld	s1,8(sp)
    80002714:	6105                	addi	sp,sp,32
    80002716:	8082                	ret

0000000080002718 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002718:	1101                	addi	sp,sp,-32
    8000271a:	ec06                	sd	ra,24(sp)
    8000271c:	e822                	sd	s0,16(sp)
    8000271e:	e426                	sd	s1,8(sp)
    80002720:	e04a                	sd	s2,0(sp)
    80002722:	1000                	addi	s0,sp,32
    80002724:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002726:	00d5d59b          	srliw	a1,a1,0xd
    8000272a:	00235797          	auipc	a5,0x235
    8000272e:	e627a783          	lw	a5,-414(a5) # 8023758c <sb+0x1c>
    80002732:	9dbd                	addw	a1,a1,a5
    80002734:	00000097          	auipc	ra,0x0
    80002738:	d9e080e7          	jalr	-610(ra) # 800024d2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000273c:	0074f713          	andi	a4,s1,7
    80002740:	4785                	li	a5,1
    80002742:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002746:	14ce                	slli	s1,s1,0x33
    80002748:	90d9                	srli	s1,s1,0x36
    8000274a:	00950733          	add	a4,a0,s1
    8000274e:	05874703          	lbu	a4,88(a4)
    80002752:	00e7f6b3          	and	a3,a5,a4
    80002756:	c69d                	beqz	a3,80002784 <bfree+0x6c>
    80002758:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000275a:	94aa                	add	s1,s1,a0
    8000275c:	fff7c793          	not	a5,a5
    80002760:	8ff9                	and	a5,a5,a4
    80002762:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002766:	00001097          	auipc	ra,0x1
    8000276a:	118080e7          	jalr	280(ra) # 8000387e <log_write>
  brelse(bp);
    8000276e:	854a                	mv	a0,s2
    80002770:	00000097          	auipc	ra,0x0
    80002774:	e92080e7          	jalr	-366(ra) # 80002602 <brelse>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6902                	ld	s2,0(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret
    panic("freeing free block");
    80002784:	00006517          	auipc	a0,0x6
    80002788:	d7450513          	addi	a0,a0,-652 # 800084f8 <syscalls+0xe8>
    8000278c:	00003097          	auipc	ra,0x3
    80002790:	5fc080e7          	jalr	1532(ra) # 80005d88 <panic>

0000000080002794 <balloc>:
{
    80002794:	711d                	addi	sp,sp,-96
    80002796:	ec86                	sd	ra,88(sp)
    80002798:	e8a2                	sd	s0,80(sp)
    8000279a:	e4a6                	sd	s1,72(sp)
    8000279c:	e0ca                	sd	s2,64(sp)
    8000279e:	fc4e                	sd	s3,56(sp)
    800027a0:	f852                	sd	s4,48(sp)
    800027a2:	f456                	sd	s5,40(sp)
    800027a4:	f05a                	sd	s6,32(sp)
    800027a6:	ec5e                	sd	s7,24(sp)
    800027a8:	e862                	sd	s8,16(sp)
    800027aa:	e466                	sd	s9,8(sp)
    800027ac:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ae:	00235797          	auipc	a5,0x235
    800027b2:	dc67a783          	lw	a5,-570(a5) # 80237574 <sb+0x4>
    800027b6:	cbd1                	beqz	a5,8000284a <balloc+0xb6>
    800027b8:	8baa                	mv	s7,a0
    800027ba:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027bc:	00235b17          	auipc	s6,0x235
    800027c0:	db4b0b13          	addi	s6,s6,-588 # 80237570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027c6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027c8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027ca:	6c89                	lui	s9,0x2
    800027cc:	a831                	j	800027e8 <balloc+0x54>
    brelse(bp);
    800027ce:	854a                	mv	a0,s2
    800027d0:	00000097          	auipc	ra,0x0
    800027d4:	e32080e7          	jalr	-462(ra) # 80002602 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027d8:	015c87bb          	addw	a5,s9,s5
    800027dc:	00078a9b          	sext.w	s5,a5
    800027e0:	004b2703          	lw	a4,4(s6)
    800027e4:	06eaf363          	bgeu	s5,a4,8000284a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800027e8:	41fad79b          	sraiw	a5,s5,0x1f
    800027ec:	0137d79b          	srliw	a5,a5,0x13
    800027f0:	015787bb          	addw	a5,a5,s5
    800027f4:	40d7d79b          	sraiw	a5,a5,0xd
    800027f8:	01cb2583          	lw	a1,28(s6)
    800027fc:	9dbd                	addw	a1,a1,a5
    800027fe:	855e                	mv	a0,s7
    80002800:	00000097          	auipc	ra,0x0
    80002804:	cd2080e7          	jalr	-814(ra) # 800024d2 <bread>
    80002808:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280a:	004b2503          	lw	a0,4(s6)
    8000280e:	000a849b          	sext.w	s1,s5
    80002812:	8662                	mv	a2,s8
    80002814:	faa4fde3          	bgeu	s1,a0,800027ce <balloc+0x3a>
      m = 1 << (bi % 8);
    80002818:	41f6579b          	sraiw	a5,a2,0x1f
    8000281c:	01d7d69b          	srliw	a3,a5,0x1d
    80002820:	00c6873b          	addw	a4,a3,a2
    80002824:	00777793          	andi	a5,a4,7
    80002828:	9f95                	subw	a5,a5,a3
    8000282a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000282e:	4037571b          	sraiw	a4,a4,0x3
    80002832:	00e906b3          	add	a3,s2,a4
    80002836:	0586c683          	lbu	a3,88(a3)
    8000283a:	00d7f5b3          	and	a1,a5,a3
    8000283e:	cd91                	beqz	a1,8000285a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	2605                	addiw	a2,a2,1
    80002842:	2485                	addiw	s1,s1,1
    80002844:	fd4618e3          	bne	a2,s4,80002814 <balloc+0x80>
    80002848:	b759                	j	800027ce <balloc+0x3a>
  panic("balloc: out of blocks");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	cc650513          	addi	a0,a0,-826 # 80008510 <syscalls+0x100>
    80002852:	00003097          	auipc	ra,0x3
    80002856:	536080e7          	jalr	1334(ra) # 80005d88 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000285a:	974a                	add	a4,a4,s2
    8000285c:	8fd5                	or	a5,a5,a3
    8000285e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002862:	854a                	mv	a0,s2
    80002864:	00001097          	auipc	ra,0x1
    80002868:	01a080e7          	jalr	26(ra) # 8000387e <log_write>
        brelse(bp);
    8000286c:	854a                	mv	a0,s2
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	d94080e7          	jalr	-620(ra) # 80002602 <brelse>
  bp = bread(dev, bno);
    80002876:	85a6                	mv	a1,s1
    80002878:	855e                	mv	a0,s7
    8000287a:	00000097          	auipc	ra,0x0
    8000287e:	c58080e7          	jalr	-936(ra) # 800024d2 <bread>
    80002882:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002884:	40000613          	li	a2,1024
    80002888:	4581                	li	a1,0
    8000288a:	05850513          	addi	a0,a0,88
    8000288e:	ffffe097          	auipc	ra,0xffffe
    80002892:	a12080e7          	jalr	-1518(ra) # 800002a0 <memset>
  log_write(bp);
    80002896:	854a                	mv	a0,s2
    80002898:	00001097          	auipc	ra,0x1
    8000289c:	fe6080e7          	jalr	-26(ra) # 8000387e <log_write>
  brelse(bp);
    800028a0:	854a                	mv	a0,s2
    800028a2:	00000097          	auipc	ra,0x0
    800028a6:	d60080e7          	jalr	-672(ra) # 80002602 <brelse>
}
    800028aa:	8526                	mv	a0,s1
    800028ac:	60e6                	ld	ra,88(sp)
    800028ae:	6446                	ld	s0,80(sp)
    800028b0:	64a6                	ld	s1,72(sp)
    800028b2:	6906                	ld	s2,64(sp)
    800028b4:	79e2                	ld	s3,56(sp)
    800028b6:	7a42                	ld	s4,48(sp)
    800028b8:	7aa2                	ld	s5,40(sp)
    800028ba:	7b02                	ld	s6,32(sp)
    800028bc:	6be2                	ld	s7,24(sp)
    800028be:	6c42                	ld	s8,16(sp)
    800028c0:	6ca2                	ld	s9,8(sp)
    800028c2:	6125                	addi	sp,sp,96
    800028c4:	8082                	ret

00000000800028c6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028c6:	7179                	addi	sp,sp,-48
    800028c8:	f406                	sd	ra,40(sp)
    800028ca:	f022                	sd	s0,32(sp)
    800028cc:	ec26                	sd	s1,24(sp)
    800028ce:	e84a                	sd	s2,16(sp)
    800028d0:	e44e                	sd	s3,8(sp)
    800028d2:	e052                	sd	s4,0(sp)
    800028d4:	1800                	addi	s0,sp,48
    800028d6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028d8:	47ad                	li	a5,11
    800028da:	04b7fe63          	bgeu	a5,a1,80002936 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028de:	ff45849b          	addiw	s1,a1,-12
    800028e2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028e6:	0ff00793          	li	a5,255
    800028ea:	0ae7e363          	bltu	a5,a4,80002990 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800028ee:	08052583          	lw	a1,128(a0)
    800028f2:	c5ad                	beqz	a1,8000295c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800028f4:	00092503          	lw	a0,0(s2)
    800028f8:	00000097          	auipc	ra,0x0
    800028fc:	bda080e7          	jalr	-1062(ra) # 800024d2 <bread>
    80002900:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002902:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002906:	02049593          	slli	a1,s1,0x20
    8000290a:	9181                	srli	a1,a1,0x20
    8000290c:	058a                	slli	a1,a1,0x2
    8000290e:	00b784b3          	add	s1,a5,a1
    80002912:	0004a983          	lw	s3,0(s1)
    80002916:	04098d63          	beqz	s3,80002970 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000291a:	8552                	mv	a0,s4
    8000291c:	00000097          	auipc	ra,0x0
    80002920:	ce6080e7          	jalr	-794(ra) # 80002602 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002924:	854e                	mv	a0,s3
    80002926:	70a2                	ld	ra,40(sp)
    80002928:	7402                	ld	s0,32(sp)
    8000292a:	64e2                	ld	s1,24(sp)
    8000292c:	6942                	ld	s2,16(sp)
    8000292e:	69a2                	ld	s3,8(sp)
    80002930:	6a02                	ld	s4,0(sp)
    80002932:	6145                	addi	sp,sp,48
    80002934:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002936:	02059493          	slli	s1,a1,0x20
    8000293a:	9081                	srli	s1,s1,0x20
    8000293c:	048a                	slli	s1,s1,0x2
    8000293e:	94aa                	add	s1,s1,a0
    80002940:	0504a983          	lw	s3,80(s1)
    80002944:	fe0990e3          	bnez	s3,80002924 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002948:	4108                	lw	a0,0(a0)
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	e4a080e7          	jalr	-438(ra) # 80002794 <balloc>
    80002952:	0005099b          	sext.w	s3,a0
    80002956:	0534a823          	sw	s3,80(s1)
    8000295a:	b7e9                	j	80002924 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000295c:	4108                	lw	a0,0(a0)
    8000295e:	00000097          	auipc	ra,0x0
    80002962:	e36080e7          	jalr	-458(ra) # 80002794 <balloc>
    80002966:	0005059b          	sext.w	a1,a0
    8000296a:	08b92023          	sw	a1,128(s2)
    8000296e:	b759                	j	800028f4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002970:	00092503          	lw	a0,0(s2)
    80002974:	00000097          	auipc	ra,0x0
    80002978:	e20080e7          	jalr	-480(ra) # 80002794 <balloc>
    8000297c:	0005099b          	sext.w	s3,a0
    80002980:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002984:	8552                	mv	a0,s4
    80002986:	00001097          	auipc	ra,0x1
    8000298a:	ef8080e7          	jalr	-264(ra) # 8000387e <log_write>
    8000298e:	b771                	j	8000291a <bmap+0x54>
  panic("bmap: out of range");
    80002990:	00006517          	auipc	a0,0x6
    80002994:	b9850513          	addi	a0,a0,-1128 # 80008528 <syscalls+0x118>
    80002998:	00003097          	auipc	ra,0x3
    8000299c:	3f0080e7          	jalr	1008(ra) # 80005d88 <panic>

00000000800029a0 <iget>:
{
    800029a0:	7179                	addi	sp,sp,-48
    800029a2:	f406                	sd	ra,40(sp)
    800029a4:	f022                	sd	s0,32(sp)
    800029a6:	ec26                	sd	s1,24(sp)
    800029a8:	e84a                	sd	s2,16(sp)
    800029aa:	e44e                	sd	s3,8(sp)
    800029ac:	e052                	sd	s4,0(sp)
    800029ae:	1800                	addi	s0,sp,48
    800029b0:	89aa                	mv	s3,a0
    800029b2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029b4:	00235517          	auipc	a0,0x235
    800029b8:	bdc50513          	addi	a0,a0,-1060 # 80237590 <itable>
    800029bc:	00004097          	auipc	ra,0x4
    800029c0:	916080e7          	jalr	-1770(ra) # 800062d2 <acquire>
  empty = 0;
    800029c4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029c6:	00235497          	auipc	s1,0x235
    800029ca:	be248493          	addi	s1,s1,-1054 # 802375a8 <itable+0x18>
    800029ce:	00236697          	auipc	a3,0x236
    800029d2:	66a68693          	addi	a3,a3,1642 # 80239038 <log>
    800029d6:	a039                	j	800029e4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029d8:	02090b63          	beqz	s2,80002a0e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029dc:	08848493          	addi	s1,s1,136
    800029e0:	02d48a63          	beq	s1,a3,80002a14 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800029e4:	449c                	lw	a5,8(s1)
    800029e6:	fef059e3          	blez	a5,800029d8 <iget+0x38>
    800029ea:	4098                	lw	a4,0(s1)
    800029ec:	ff3716e3          	bne	a4,s3,800029d8 <iget+0x38>
    800029f0:	40d8                	lw	a4,4(s1)
    800029f2:	ff4713e3          	bne	a4,s4,800029d8 <iget+0x38>
      ip->ref++;
    800029f6:	2785                	addiw	a5,a5,1
    800029f8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029fa:	00235517          	auipc	a0,0x235
    800029fe:	b9650513          	addi	a0,a0,-1130 # 80237590 <itable>
    80002a02:	00004097          	auipc	ra,0x4
    80002a06:	984080e7          	jalr	-1660(ra) # 80006386 <release>
      return ip;
    80002a0a:	8926                	mv	s2,s1
    80002a0c:	a03d                	j	80002a3a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a0e:	f7f9                	bnez	a5,800029dc <iget+0x3c>
    80002a10:	8926                	mv	s2,s1
    80002a12:	b7e9                	j	800029dc <iget+0x3c>
  if(empty == 0)
    80002a14:	02090c63          	beqz	s2,80002a4c <iget+0xac>
  ip->dev = dev;
    80002a18:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a1c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a20:	4785                	li	a5,1
    80002a22:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a26:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a2a:	00235517          	auipc	a0,0x235
    80002a2e:	b6650513          	addi	a0,a0,-1178 # 80237590 <itable>
    80002a32:	00004097          	auipc	ra,0x4
    80002a36:	954080e7          	jalr	-1708(ra) # 80006386 <release>
}
    80002a3a:	854a                	mv	a0,s2
    80002a3c:	70a2                	ld	ra,40(sp)
    80002a3e:	7402                	ld	s0,32(sp)
    80002a40:	64e2                	ld	s1,24(sp)
    80002a42:	6942                	ld	s2,16(sp)
    80002a44:	69a2                	ld	s3,8(sp)
    80002a46:	6a02                	ld	s4,0(sp)
    80002a48:	6145                	addi	sp,sp,48
    80002a4a:	8082                	ret
    panic("iget: no inodes");
    80002a4c:	00006517          	auipc	a0,0x6
    80002a50:	af450513          	addi	a0,a0,-1292 # 80008540 <syscalls+0x130>
    80002a54:	00003097          	auipc	ra,0x3
    80002a58:	334080e7          	jalr	820(ra) # 80005d88 <panic>

0000000080002a5c <fsinit>:
fsinit(int dev) {
    80002a5c:	7179                	addi	sp,sp,-48
    80002a5e:	f406                	sd	ra,40(sp)
    80002a60:	f022                	sd	s0,32(sp)
    80002a62:	ec26                	sd	s1,24(sp)
    80002a64:	e84a                	sd	s2,16(sp)
    80002a66:	e44e                	sd	s3,8(sp)
    80002a68:	1800                	addi	s0,sp,48
    80002a6a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a6c:	4585                	li	a1,1
    80002a6e:	00000097          	auipc	ra,0x0
    80002a72:	a64080e7          	jalr	-1436(ra) # 800024d2 <bread>
    80002a76:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a78:	00235997          	auipc	s3,0x235
    80002a7c:	af898993          	addi	s3,s3,-1288 # 80237570 <sb>
    80002a80:	02000613          	li	a2,32
    80002a84:	05850593          	addi	a1,a0,88
    80002a88:	854e                	mv	a0,s3
    80002a8a:	ffffe097          	auipc	ra,0xffffe
    80002a8e:	876080e7          	jalr	-1930(ra) # 80000300 <memmove>
  brelse(bp);
    80002a92:	8526                	mv	a0,s1
    80002a94:	00000097          	auipc	ra,0x0
    80002a98:	b6e080e7          	jalr	-1170(ra) # 80002602 <brelse>
  if(sb.magic != FSMAGIC)
    80002a9c:	0009a703          	lw	a4,0(s3)
    80002aa0:	102037b7          	lui	a5,0x10203
    80002aa4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002aa8:	02f71263          	bne	a4,a5,80002acc <fsinit+0x70>
  initlog(dev, &sb);
    80002aac:	00235597          	auipc	a1,0x235
    80002ab0:	ac458593          	addi	a1,a1,-1340 # 80237570 <sb>
    80002ab4:	854a                	mv	a0,s2
    80002ab6:	00001097          	auipc	ra,0x1
    80002aba:	b4c080e7          	jalr	-1204(ra) # 80003602 <initlog>
}
    80002abe:	70a2                	ld	ra,40(sp)
    80002ac0:	7402                	ld	s0,32(sp)
    80002ac2:	64e2                	ld	s1,24(sp)
    80002ac4:	6942                	ld	s2,16(sp)
    80002ac6:	69a2                	ld	s3,8(sp)
    80002ac8:	6145                	addi	sp,sp,48
    80002aca:	8082                	ret
    panic("invalid file system");
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	a8450513          	addi	a0,a0,-1404 # 80008550 <syscalls+0x140>
    80002ad4:	00003097          	auipc	ra,0x3
    80002ad8:	2b4080e7          	jalr	692(ra) # 80005d88 <panic>

0000000080002adc <iinit>:
{
    80002adc:	7179                	addi	sp,sp,-48
    80002ade:	f406                	sd	ra,40(sp)
    80002ae0:	f022                	sd	s0,32(sp)
    80002ae2:	ec26                	sd	s1,24(sp)
    80002ae4:	e84a                	sd	s2,16(sp)
    80002ae6:	e44e                	sd	s3,8(sp)
    80002ae8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aea:	00006597          	auipc	a1,0x6
    80002aee:	a7e58593          	addi	a1,a1,-1410 # 80008568 <syscalls+0x158>
    80002af2:	00235517          	auipc	a0,0x235
    80002af6:	a9e50513          	addi	a0,a0,-1378 # 80237590 <itable>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	748080e7          	jalr	1864(ra) # 80006242 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b02:	00235497          	auipc	s1,0x235
    80002b06:	ab648493          	addi	s1,s1,-1354 # 802375b8 <itable+0x28>
    80002b0a:	00236997          	auipc	s3,0x236
    80002b0e:	53e98993          	addi	s3,s3,1342 # 80239048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b12:	00006917          	auipc	s2,0x6
    80002b16:	a5e90913          	addi	s2,s2,-1442 # 80008570 <syscalls+0x160>
    80002b1a:	85ca                	mv	a1,s2
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	00001097          	auipc	ra,0x1
    80002b22:	e46080e7          	jalr	-442(ra) # 80003964 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b26:	08848493          	addi	s1,s1,136
    80002b2a:	ff3498e3          	bne	s1,s3,80002b1a <iinit+0x3e>
}
    80002b2e:	70a2                	ld	ra,40(sp)
    80002b30:	7402                	ld	s0,32(sp)
    80002b32:	64e2                	ld	s1,24(sp)
    80002b34:	6942                	ld	s2,16(sp)
    80002b36:	69a2                	ld	s3,8(sp)
    80002b38:	6145                	addi	sp,sp,48
    80002b3a:	8082                	ret

0000000080002b3c <ialloc>:
{
    80002b3c:	715d                	addi	sp,sp,-80
    80002b3e:	e486                	sd	ra,72(sp)
    80002b40:	e0a2                	sd	s0,64(sp)
    80002b42:	fc26                	sd	s1,56(sp)
    80002b44:	f84a                	sd	s2,48(sp)
    80002b46:	f44e                	sd	s3,40(sp)
    80002b48:	f052                	sd	s4,32(sp)
    80002b4a:	ec56                	sd	s5,24(sp)
    80002b4c:	e85a                	sd	s6,16(sp)
    80002b4e:	e45e                	sd	s7,8(sp)
    80002b50:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b52:	00235717          	auipc	a4,0x235
    80002b56:	a2a72703          	lw	a4,-1494(a4) # 8023757c <sb+0xc>
    80002b5a:	4785                	li	a5,1
    80002b5c:	04e7fa63          	bgeu	a5,a4,80002bb0 <ialloc+0x74>
    80002b60:	8aaa                	mv	s5,a0
    80002b62:	8bae                	mv	s7,a1
    80002b64:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b66:	00235a17          	auipc	s4,0x235
    80002b6a:	a0aa0a13          	addi	s4,s4,-1526 # 80237570 <sb>
    80002b6e:	00048b1b          	sext.w	s6,s1
    80002b72:	0044d593          	srli	a1,s1,0x4
    80002b76:	018a2783          	lw	a5,24(s4)
    80002b7a:	9dbd                	addw	a1,a1,a5
    80002b7c:	8556                	mv	a0,s5
    80002b7e:	00000097          	auipc	ra,0x0
    80002b82:	954080e7          	jalr	-1708(ra) # 800024d2 <bread>
    80002b86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b88:	05850993          	addi	s3,a0,88
    80002b8c:	00f4f793          	andi	a5,s1,15
    80002b90:	079a                	slli	a5,a5,0x6
    80002b92:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b94:	00099783          	lh	a5,0(s3)
    80002b98:	c785                	beqz	a5,80002bc0 <ialloc+0x84>
    brelse(bp);
    80002b9a:	00000097          	auipc	ra,0x0
    80002b9e:	a68080e7          	jalr	-1432(ra) # 80002602 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba2:	0485                	addi	s1,s1,1
    80002ba4:	00ca2703          	lw	a4,12(s4)
    80002ba8:	0004879b          	sext.w	a5,s1
    80002bac:	fce7e1e3          	bltu	a5,a4,80002b6e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bb0:	00006517          	auipc	a0,0x6
    80002bb4:	9c850513          	addi	a0,a0,-1592 # 80008578 <syscalls+0x168>
    80002bb8:	00003097          	auipc	ra,0x3
    80002bbc:	1d0080e7          	jalr	464(ra) # 80005d88 <panic>
      memset(dip, 0, sizeof(*dip));
    80002bc0:	04000613          	li	a2,64
    80002bc4:	4581                	li	a1,0
    80002bc6:	854e                	mv	a0,s3
    80002bc8:	ffffd097          	auipc	ra,0xffffd
    80002bcc:	6d8080e7          	jalr	1752(ra) # 800002a0 <memset>
      dip->type = type;
    80002bd0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bd4:	854a                	mv	a0,s2
    80002bd6:	00001097          	auipc	ra,0x1
    80002bda:	ca8080e7          	jalr	-856(ra) # 8000387e <log_write>
      brelse(bp);
    80002bde:	854a                	mv	a0,s2
    80002be0:	00000097          	auipc	ra,0x0
    80002be4:	a22080e7          	jalr	-1502(ra) # 80002602 <brelse>
      return iget(dev, inum);
    80002be8:	85da                	mv	a1,s6
    80002bea:	8556                	mv	a0,s5
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	db4080e7          	jalr	-588(ra) # 800029a0 <iget>
}
    80002bf4:	60a6                	ld	ra,72(sp)
    80002bf6:	6406                	ld	s0,64(sp)
    80002bf8:	74e2                	ld	s1,56(sp)
    80002bfa:	7942                	ld	s2,48(sp)
    80002bfc:	79a2                	ld	s3,40(sp)
    80002bfe:	7a02                	ld	s4,32(sp)
    80002c00:	6ae2                	ld	s5,24(sp)
    80002c02:	6b42                	ld	s6,16(sp)
    80002c04:	6ba2                	ld	s7,8(sp)
    80002c06:	6161                	addi	sp,sp,80
    80002c08:	8082                	ret

0000000080002c0a <iupdate>:
{
    80002c0a:	1101                	addi	sp,sp,-32
    80002c0c:	ec06                	sd	ra,24(sp)
    80002c0e:	e822                	sd	s0,16(sp)
    80002c10:	e426                	sd	s1,8(sp)
    80002c12:	e04a                	sd	s2,0(sp)
    80002c14:	1000                	addi	s0,sp,32
    80002c16:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c18:	415c                	lw	a5,4(a0)
    80002c1a:	0047d79b          	srliw	a5,a5,0x4
    80002c1e:	00235597          	auipc	a1,0x235
    80002c22:	96a5a583          	lw	a1,-1686(a1) # 80237588 <sb+0x18>
    80002c26:	9dbd                	addw	a1,a1,a5
    80002c28:	4108                	lw	a0,0(a0)
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	8a8080e7          	jalr	-1880(ra) # 800024d2 <bread>
    80002c32:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c34:	05850793          	addi	a5,a0,88
    80002c38:	40c8                	lw	a0,4(s1)
    80002c3a:	893d                	andi	a0,a0,15
    80002c3c:	051a                	slli	a0,a0,0x6
    80002c3e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c40:	04449703          	lh	a4,68(s1)
    80002c44:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c48:	04649703          	lh	a4,70(s1)
    80002c4c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c50:	04849703          	lh	a4,72(s1)
    80002c54:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c58:	04a49703          	lh	a4,74(s1)
    80002c5c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c60:	44f8                	lw	a4,76(s1)
    80002c62:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c64:	03400613          	li	a2,52
    80002c68:	05048593          	addi	a1,s1,80
    80002c6c:	0531                	addi	a0,a0,12
    80002c6e:	ffffd097          	auipc	ra,0xffffd
    80002c72:	692080e7          	jalr	1682(ra) # 80000300 <memmove>
  log_write(bp);
    80002c76:	854a                	mv	a0,s2
    80002c78:	00001097          	auipc	ra,0x1
    80002c7c:	c06080e7          	jalr	-1018(ra) # 8000387e <log_write>
  brelse(bp);
    80002c80:	854a                	mv	a0,s2
    80002c82:	00000097          	auipc	ra,0x0
    80002c86:	980080e7          	jalr	-1664(ra) # 80002602 <brelse>
}
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	64a2                	ld	s1,8(sp)
    80002c90:	6902                	ld	s2,0(sp)
    80002c92:	6105                	addi	sp,sp,32
    80002c94:	8082                	ret

0000000080002c96 <idup>:
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	1000                	addi	s0,sp,32
    80002ca0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca2:	00235517          	auipc	a0,0x235
    80002ca6:	8ee50513          	addi	a0,a0,-1810 # 80237590 <itable>
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	628080e7          	jalr	1576(ra) # 800062d2 <acquire>
  ip->ref++;
    80002cb2:	449c                	lw	a5,8(s1)
    80002cb4:	2785                	addiw	a5,a5,1
    80002cb6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cb8:	00235517          	auipc	a0,0x235
    80002cbc:	8d850513          	addi	a0,a0,-1832 # 80237590 <itable>
    80002cc0:	00003097          	auipc	ra,0x3
    80002cc4:	6c6080e7          	jalr	1734(ra) # 80006386 <release>
}
    80002cc8:	8526                	mv	a0,s1
    80002cca:	60e2                	ld	ra,24(sp)
    80002ccc:	6442                	ld	s0,16(sp)
    80002cce:	64a2                	ld	s1,8(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret

0000000080002cd4 <ilock>:
{
    80002cd4:	1101                	addi	sp,sp,-32
    80002cd6:	ec06                	sd	ra,24(sp)
    80002cd8:	e822                	sd	s0,16(sp)
    80002cda:	e426                	sd	s1,8(sp)
    80002cdc:	e04a                	sd	s2,0(sp)
    80002cde:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ce0:	c115                	beqz	a0,80002d04 <ilock+0x30>
    80002ce2:	84aa                	mv	s1,a0
    80002ce4:	451c                	lw	a5,8(a0)
    80002ce6:	00f05f63          	blez	a5,80002d04 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002cea:	0541                	addi	a0,a0,16
    80002cec:	00001097          	auipc	ra,0x1
    80002cf0:	cb2080e7          	jalr	-846(ra) # 8000399e <acquiresleep>
  if(ip->valid == 0){
    80002cf4:	40bc                	lw	a5,64(s1)
    80002cf6:	cf99                	beqz	a5,80002d14 <ilock+0x40>
}
    80002cf8:	60e2                	ld	ra,24(sp)
    80002cfa:	6442                	ld	s0,16(sp)
    80002cfc:	64a2                	ld	s1,8(sp)
    80002cfe:	6902                	ld	s2,0(sp)
    80002d00:	6105                	addi	sp,sp,32
    80002d02:	8082                	ret
    panic("ilock");
    80002d04:	00006517          	auipc	a0,0x6
    80002d08:	88c50513          	addi	a0,a0,-1908 # 80008590 <syscalls+0x180>
    80002d0c:	00003097          	auipc	ra,0x3
    80002d10:	07c080e7          	jalr	124(ra) # 80005d88 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d14:	40dc                	lw	a5,4(s1)
    80002d16:	0047d79b          	srliw	a5,a5,0x4
    80002d1a:	00235597          	auipc	a1,0x235
    80002d1e:	86e5a583          	lw	a1,-1938(a1) # 80237588 <sb+0x18>
    80002d22:	9dbd                	addw	a1,a1,a5
    80002d24:	4088                	lw	a0,0(s1)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	7ac080e7          	jalr	1964(ra) # 800024d2 <bread>
    80002d2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d30:	05850593          	addi	a1,a0,88
    80002d34:	40dc                	lw	a5,4(s1)
    80002d36:	8bbd                	andi	a5,a5,15
    80002d38:	079a                	slli	a5,a5,0x6
    80002d3a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d3c:	00059783          	lh	a5,0(a1)
    80002d40:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d44:	00259783          	lh	a5,2(a1)
    80002d48:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d4c:	00459783          	lh	a5,4(a1)
    80002d50:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d54:	00659783          	lh	a5,6(a1)
    80002d58:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d5c:	459c                	lw	a5,8(a1)
    80002d5e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d60:	03400613          	li	a2,52
    80002d64:	05b1                	addi	a1,a1,12
    80002d66:	05048513          	addi	a0,s1,80
    80002d6a:	ffffd097          	auipc	ra,0xffffd
    80002d6e:	596080e7          	jalr	1430(ra) # 80000300 <memmove>
    brelse(bp);
    80002d72:	854a                	mv	a0,s2
    80002d74:	00000097          	auipc	ra,0x0
    80002d78:	88e080e7          	jalr	-1906(ra) # 80002602 <brelse>
    ip->valid = 1;
    80002d7c:	4785                	li	a5,1
    80002d7e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d80:	04449783          	lh	a5,68(s1)
    80002d84:	fbb5                	bnez	a5,80002cf8 <ilock+0x24>
      panic("ilock: no type");
    80002d86:	00006517          	auipc	a0,0x6
    80002d8a:	81250513          	addi	a0,a0,-2030 # 80008598 <syscalls+0x188>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	ffa080e7          	jalr	-6(ra) # 80005d88 <panic>

0000000080002d96 <iunlock>:
{
    80002d96:	1101                	addi	sp,sp,-32
    80002d98:	ec06                	sd	ra,24(sp)
    80002d9a:	e822                	sd	s0,16(sp)
    80002d9c:	e426                	sd	s1,8(sp)
    80002d9e:	e04a                	sd	s2,0(sp)
    80002da0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002da2:	c905                	beqz	a0,80002dd2 <iunlock+0x3c>
    80002da4:	84aa                	mv	s1,a0
    80002da6:	01050913          	addi	s2,a0,16
    80002daa:	854a                	mv	a0,s2
    80002dac:	00001097          	auipc	ra,0x1
    80002db0:	c8c080e7          	jalr	-884(ra) # 80003a38 <holdingsleep>
    80002db4:	cd19                	beqz	a0,80002dd2 <iunlock+0x3c>
    80002db6:	449c                	lw	a5,8(s1)
    80002db8:	00f05d63          	blez	a5,80002dd2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002dbc:	854a                	mv	a0,s2
    80002dbe:	00001097          	auipc	ra,0x1
    80002dc2:	c36080e7          	jalr	-970(ra) # 800039f4 <releasesleep>
}
    80002dc6:	60e2                	ld	ra,24(sp)
    80002dc8:	6442                	ld	s0,16(sp)
    80002dca:	64a2                	ld	s1,8(sp)
    80002dcc:	6902                	ld	s2,0(sp)
    80002dce:	6105                	addi	sp,sp,32
    80002dd0:	8082                	ret
    panic("iunlock");
    80002dd2:	00005517          	auipc	a0,0x5
    80002dd6:	7d650513          	addi	a0,a0,2006 # 800085a8 <syscalls+0x198>
    80002dda:	00003097          	auipc	ra,0x3
    80002dde:	fae080e7          	jalr	-82(ra) # 80005d88 <panic>

0000000080002de2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002de2:	7179                	addi	sp,sp,-48
    80002de4:	f406                	sd	ra,40(sp)
    80002de6:	f022                	sd	s0,32(sp)
    80002de8:	ec26                	sd	s1,24(sp)
    80002dea:	e84a                	sd	s2,16(sp)
    80002dec:	e44e                	sd	s3,8(sp)
    80002dee:	e052                	sd	s4,0(sp)
    80002df0:	1800                	addi	s0,sp,48
    80002df2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002df4:	05050493          	addi	s1,a0,80
    80002df8:	08050913          	addi	s2,a0,128
    80002dfc:	a021                	j	80002e04 <itrunc+0x22>
    80002dfe:	0491                	addi	s1,s1,4
    80002e00:	01248d63          	beq	s1,s2,80002e1a <itrunc+0x38>
    if(ip->addrs[i]){
    80002e04:	408c                	lw	a1,0(s1)
    80002e06:	dde5                	beqz	a1,80002dfe <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e08:	0009a503          	lw	a0,0(s3)
    80002e0c:	00000097          	auipc	ra,0x0
    80002e10:	90c080e7          	jalr	-1780(ra) # 80002718 <bfree>
      ip->addrs[i] = 0;
    80002e14:	0004a023          	sw	zero,0(s1)
    80002e18:	b7dd                	j	80002dfe <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e1a:	0809a583          	lw	a1,128(s3)
    80002e1e:	e185                	bnez	a1,80002e3e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e20:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e24:	854e                	mv	a0,s3
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	de4080e7          	jalr	-540(ra) # 80002c0a <iupdate>
}
    80002e2e:	70a2                	ld	ra,40(sp)
    80002e30:	7402                	ld	s0,32(sp)
    80002e32:	64e2                	ld	s1,24(sp)
    80002e34:	6942                	ld	s2,16(sp)
    80002e36:	69a2                	ld	s3,8(sp)
    80002e38:	6a02                	ld	s4,0(sp)
    80002e3a:	6145                	addi	sp,sp,48
    80002e3c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e3e:	0009a503          	lw	a0,0(s3)
    80002e42:	fffff097          	auipc	ra,0xfffff
    80002e46:	690080e7          	jalr	1680(ra) # 800024d2 <bread>
    80002e4a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e4c:	05850493          	addi	s1,a0,88
    80002e50:	45850913          	addi	s2,a0,1112
    80002e54:	a811                	j	80002e68 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e56:	0009a503          	lw	a0,0(s3)
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	8be080e7          	jalr	-1858(ra) # 80002718 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e62:	0491                	addi	s1,s1,4
    80002e64:	01248563          	beq	s1,s2,80002e6e <itrunc+0x8c>
      if(a[j])
    80002e68:	408c                	lw	a1,0(s1)
    80002e6a:	dde5                	beqz	a1,80002e62 <itrunc+0x80>
    80002e6c:	b7ed                	j	80002e56 <itrunc+0x74>
    brelse(bp);
    80002e6e:	8552                	mv	a0,s4
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	792080e7          	jalr	1938(ra) # 80002602 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e78:	0809a583          	lw	a1,128(s3)
    80002e7c:	0009a503          	lw	a0,0(s3)
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	898080e7          	jalr	-1896(ra) # 80002718 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e88:	0809a023          	sw	zero,128(s3)
    80002e8c:	bf51                	j	80002e20 <itrunc+0x3e>

0000000080002e8e <iput>:
{
    80002e8e:	1101                	addi	sp,sp,-32
    80002e90:	ec06                	sd	ra,24(sp)
    80002e92:	e822                	sd	s0,16(sp)
    80002e94:	e426                	sd	s1,8(sp)
    80002e96:	e04a                	sd	s2,0(sp)
    80002e98:	1000                	addi	s0,sp,32
    80002e9a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e9c:	00234517          	auipc	a0,0x234
    80002ea0:	6f450513          	addi	a0,a0,1780 # 80237590 <itable>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	42e080e7          	jalr	1070(ra) # 800062d2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002eac:	4498                	lw	a4,8(s1)
    80002eae:	4785                	li	a5,1
    80002eb0:	02f70363          	beq	a4,a5,80002ed6 <iput+0x48>
  ip->ref--;
    80002eb4:	449c                	lw	a5,8(s1)
    80002eb6:	37fd                	addiw	a5,a5,-1
    80002eb8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eba:	00234517          	auipc	a0,0x234
    80002ebe:	6d650513          	addi	a0,a0,1750 # 80237590 <itable>
    80002ec2:	00003097          	auipc	ra,0x3
    80002ec6:	4c4080e7          	jalr	1220(ra) # 80006386 <release>
}
    80002eca:	60e2                	ld	ra,24(sp)
    80002ecc:	6442                	ld	s0,16(sp)
    80002ece:	64a2                	ld	s1,8(sp)
    80002ed0:	6902                	ld	s2,0(sp)
    80002ed2:	6105                	addi	sp,sp,32
    80002ed4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ed6:	40bc                	lw	a5,64(s1)
    80002ed8:	dff1                	beqz	a5,80002eb4 <iput+0x26>
    80002eda:	04a49783          	lh	a5,74(s1)
    80002ede:	fbf9                	bnez	a5,80002eb4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002ee0:	01048913          	addi	s2,s1,16
    80002ee4:	854a                	mv	a0,s2
    80002ee6:	00001097          	auipc	ra,0x1
    80002eea:	ab8080e7          	jalr	-1352(ra) # 8000399e <acquiresleep>
    release(&itable.lock);
    80002eee:	00234517          	auipc	a0,0x234
    80002ef2:	6a250513          	addi	a0,a0,1698 # 80237590 <itable>
    80002ef6:	00003097          	auipc	ra,0x3
    80002efa:	490080e7          	jalr	1168(ra) # 80006386 <release>
    itrunc(ip);
    80002efe:	8526                	mv	a0,s1
    80002f00:	00000097          	auipc	ra,0x0
    80002f04:	ee2080e7          	jalr	-286(ra) # 80002de2 <itrunc>
    ip->type = 0;
    80002f08:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f0c:	8526                	mv	a0,s1
    80002f0e:	00000097          	auipc	ra,0x0
    80002f12:	cfc080e7          	jalr	-772(ra) # 80002c0a <iupdate>
    ip->valid = 0;
    80002f16:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	00001097          	auipc	ra,0x1
    80002f20:	ad8080e7          	jalr	-1320(ra) # 800039f4 <releasesleep>
    acquire(&itable.lock);
    80002f24:	00234517          	auipc	a0,0x234
    80002f28:	66c50513          	addi	a0,a0,1644 # 80237590 <itable>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	3a6080e7          	jalr	934(ra) # 800062d2 <acquire>
    80002f34:	b741                	j	80002eb4 <iput+0x26>

0000000080002f36 <iunlockput>:
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	e426                	sd	s1,8(sp)
    80002f3e:	1000                	addi	s0,sp,32
    80002f40:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f42:	00000097          	auipc	ra,0x0
    80002f46:	e54080e7          	jalr	-428(ra) # 80002d96 <iunlock>
  iput(ip);
    80002f4a:	8526                	mv	a0,s1
    80002f4c:	00000097          	auipc	ra,0x0
    80002f50:	f42080e7          	jalr	-190(ra) # 80002e8e <iput>
}
    80002f54:	60e2                	ld	ra,24(sp)
    80002f56:	6442                	ld	s0,16(sp)
    80002f58:	64a2                	ld	s1,8(sp)
    80002f5a:	6105                	addi	sp,sp,32
    80002f5c:	8082                	ret

0000000080002f5e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f5e:	1141                	addi	sp,sp,-16
    80002f60:	e422                	sd	s0,8(sp)
    80002f62:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f64:	411c                	lw	a5,0(a0)
    80002f66:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f68:	415c                	lw	a5,4(a0)
    80002f6a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f6c:	04451783          	lh	a5,68(a0)
    80002f70:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f74:	04a51783          	lh	a5,74(a0)
    80002f78:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f7c:	04c56783          	lwu	a5,76(a0)
    80002f80:	e99c                	sd	a5,16(a1)
}
    80002f82:	6422                	ld	s0,8(sp)
    80002f84:	0141                	addi	sp,sp,16
    80002f86:	8082                	ret

0000000080002f88 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f88:	457c                	lw	a5,76(a0)
    80002f8a:	0ed7e963          	bltu	a5,a3,8000307c <readi+0xf4>
{
    80002f8e:	7159                	addi	sp,sp,-112
    80002f90:	f486                	sd	ra,104(sp)
    80002f92:	f0a2                	sd	s0,96(sp)
    80002f94:	eca6                	sd	s1,88(sp)
    80002f96:	e8ca                	sd	s2,80(sp)
    80002f98:	e4ce                	sd	s3,72(sp)
    80002f9a:	e0d2                	sd	s4,64(sp)
    80002f9c:	fc56                	sd	s5,56(sp)
    80002f9e:	f85a                	sd	s6,48(sp)
    80002fa0:	f45e                	sd	s7,40(sp)
    80002fa2:	f062                	sd	s8,32(sp)
    80002fa4:	ec66                	sd	s9,24(sp)
    80002fa6:	e86a                	sd	s10,16(sp)
    80002fa8:	e46e                	sd	s11,8(sp)
    80002faa:	1880                	addi	s0,sp,112
    80002fac:	8baa                	mv	s7,a0
    80002fae:	8c2e                	mv	s8,a1
    80002fb0:	8ab2                	mv	s5,a2
    80002fb2:	84b6                	mv	s1,a3
    80002fb4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fb6:	9f35                	addw	a4,a4,a3
    return 0;
    80002fb8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fba:	0ad76063          	bltu	a4,a3,8000305a <readi+0xd2>
  if(off + n > ip->size)
    80002fbe:	00e7f463          	bgeu	a5,a4,80002fc6 <readi+0x3e>
    n = ip->size - off;
    80002fc2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fc6:	0a0b0963          	beqz	s6,80003078 <readi+0xf0>
    80002fca:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fcc:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002fd0:	5cfd                	li	s9,-1
    80002fd2:	a82d                	j	8000300c <readi+0x84>
    80002fd4:	020a1d93          	slli	s11,s4,0x20
    80002fd8:	020ddd93          	srli	s11,s11,0x20
    80002fdc:	05890613          	addi	a2,s2,88
    80002fe0:	86ee                	mv	a3,s11
    80002fe2:	963a                	add	a2,a2,a4
    80002fe4:	85d6                	mv	a1,s5
    80002fe6:	8562                	mv	a0,s8
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	ad6080e7          	jalr	-1322(ra) # 80001abe <either_copyout>
    80002ff0:	05950d63          	beq	a0,s9,8000304a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ff4:	854a                	mv	a0,s2
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	60c080e7          	jalr	1548(ra) # 80002602 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ffe:	013a09bb          	addw	s3,s4,s3
    80003002:	009a04bb          	addw	s1,s4,s1
    80003006:	9aee                	add	s5,s5,s11
    80003008:	0569f763          	bgeu	s3,s6,80003056 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000300c:	000ba903          	lw	s2,0(s7)
    80003010:	00a4d59b          	srliw	a1,s1,0xa
    80003014:	855e                	mv	a0,s7
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	8b0080e7          	jalr	-1872(ra) # 800028c6 <bmap>
    8000301e:	0005059b          	sext.w	a1,a0
    80003022:	854a                	mv	a0,s2
    80003024:	fffff097          	auipc	ra,0xfffff
    80003028:	4ae080e7          	jalr	1198(ra) # 800024d2 <bread>
    8000302c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000302e:	3ff4f713          	andi	a4,s1,1023
    80003032:	40ed07bb          	subw	a5,s10,a4
    80003036:	413b06bb          	subw	a3,s6,s3
    8000303a:	8a3e                	mv	s4,a5
    8000303c:	2781                	sext.w	a5,a5
    8000303e:	0006861b          	sext.w	a2,a3
    80003042:	f8f679e3          	bgeu	a2,a5,80002fd4 <readi+0x4c>
    80003046:	8a36                	mv	s4,a3
    80003048:	b771                	j	80002fd4 <readi+0x4c>
      brelse(bp);
    8000304a:	854a                	mv	a0,s2
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	5b6080e7          	jalr	1462(ra) # 80002602 <brelse>
      tot = -1;
    80003054:	59fd                	li	s3,-1
  }
  return tot;
    80003056:	0009851b          	sext.w	a0,s3
}
    8000305a:	70a6                	ld	ra,104(sp)
    8000305c:	7406                	ld	s0,96(sp)
    8000305e:	64e6                	ld	s1,88(sp)
    80003060:	6946                	ld	s2,80(sp)
    80003062:	69a6                	ld	s3,72(sp)
    80003064:	6a06                	ld	s4,64(sp)
    80003066:	7ae2                	ld	s5,56(sp)
    80003068:	7b42                	ld	s6,48(sp)
    8000306a:	7ba2                	ld	s7,40(sp)
    8000306c:	7c02                	ld	s8,32(sp)
    8000306e:	6ce2                	ld	s9,24(sp)
    80003070:	6d42                	ld	s10,16(sp)
    80003072:	6da2                	ld	s11,8(sp)
    80003074:	6165                	addi	sp,sp,112
    80003076:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003078:	89da                	mv	s3,s6
    8000307a:	bff1                	j	80003056 <readi+0xce>
    return 0;
    8000307c:	4501                	li	a0,0
}
    8000307e:	8082                	ret

0000000080003080 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003080:	457c                	lw	a5,76(a0)
    80003082:	10d7e863          	bltu	a5,a3,80003192 <writei+0x112>
{
    80003086:	7159                	addi	sp,sp,-112
    80003088:	f486                	sd	ra,104(sp)
    8000308a:	f0a2                	sd	s0,96(sp)
    8000308c:	eca6                	sd	s1,88(sp)
    8000308e:	e8ca                	sd	s2,80(sp)
    80003090:	e4ce                	sd	s3,72(sp)
    80003092:	e0d2                	sd	s4,64(sp)
    80003094:	fc56                	sd	s5,56(sp)
    80003096:	f85a                	sd	s6,48(sp)
    80003098:	f45e                	sd	s7,40(sp)
    8000309a:	f062                	sd	s8,32(sp)
    8000309c:	ec66                	sd	s9,24(sp)
    8000309e:	e86a                	sd	s10,16(sp)
    800030a0:	e46e                	sd	s11,8(sp)
    800030a2:	1880                	addi	s0,sp,112
    800030a4:	8b2a                	mv	s6,a0
    800030a6:	8c2e                	mv	s8,a1
    800030a8:	8ab2                	mv	s5,a2
    800030aa:	8936                	mv	s2,a3
    800030ac:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030ae:	00e687bb          	addw	a5,a3,a4
    800030b2:	0ed7e263          	bltu	a5,a3,80003196 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030b6:	00043737          	lui	a4,0x43
    800030ba:	0ef76063          	bltu	a4,a5,8000319a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030be:	0c0b8863          	beqz	s7,8000318e <writei+0x10e>
    800030c2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030c8:	5cfd                	li	s9,-1
    800030ca:	a091                	j	8000310e <writei+0x8e>
    800030cc:	02099d93          	slli	s11,s3,0x20
    800030d0:	020ddd93          	srli	s11,s11,0x20
    800030d4:	05848513          	addi	a0,s1,88
    800030d8:	86ee                	mv	a3,s11
    800030da:	8656                	mv	a2,s5
    800030dc:	85e2                	mv	a1,s8
    800030de:	953a                	add	a0,a0,a4
    800030e0:	fffff097          	auipc	ra,0xfffff
    800030e4:	a34080e7          	jalr	-1484(ra) # 80001b14 <either_copyin>
    800030e8:	07950263          	beq	a0,s9,8000314c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800030ec:	8526                	mv	a0,s1
    800030ee:	00000097          	auipc	ra,0x0
    800030f2:	790080e7          	jalr	1936(ra) # 8000387e <log_write>
    brelse(bp);
    800030f6:	8526                	mv	a0,s1
    800030f8:	fffff097          	auipc	ra,0xfffff
    800030fc:	50a080e7          	jalr	1290(ra) # 80002602 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003100:	01498a3b          	addw	s4,s3,s4
    80003104:	0129893b          	addw	s2,s3,s2
    80003108:	9aee                	add	s5,s5,s11
    8000310a:	057a7663          	bgeu	s4,s7,80003156 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000310e:	000b2483          	lw	s1,0(s6)
    80003112:	00a9559b          	srliw	a1,s2,0xa
    80003116:	855a                	mv	a0,s6
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	7ae080e7          	jalr	1966(ra) # 800028c6 <bmap>
    80003120:	0005059b          	sext.w	a1,a0
    80003124:	8526                	mv	a0,s1
    80003126:	fffff097          	auipc	ra,0xfffff
    8000312a:	3ac080e7          	jalr	940(ra) # 800024d2 <bread>
    8000312e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003130:	3ff97713          	andi	a4,s2,1023
    80003134:	40ed07bb          	subw	a5,s10,a4
    80003138:	414b86bb          	subw	a3,s7,s4
    8000313c:	89be                	mv	s3,a5
    8000313e:	2781                	sext.w	a5,a5
    80003140:	0006861b          	sext.w	a2,a3
    80003144:	f8f674e3          	bgeu	a2,a5,800030cc <writei+0x4c>
    80003148:	89b6                	mv	s3,a3
    8000314a:	b749                	j	800030cc <writei+0x4c>
      brelse(bp);
    8000314c:	8526                	mv	a0,s1
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	4b4080e7          	jalr	1204(ra) # 80002602 <brelse>
  }

  if(off > ip->size)
    80003156:	04cb2783          	lw	a5,76(s6)
    8000315a:	0127f463          	bgeu	a5,s2,80003162 <writei+0xe2>
    ip->size = off;
    8000315e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003162:	855a                	mv	a0,s6
    80003164:	00000097          	auipc	ra,0x0
    80003168:	aa6080e7          	jalr	-1370(ra) # 80002c0a <iupdate>

  return tot;
    8000316c:	000a051b          	sext.w	a0,s4
}
    80003170:	70a6                	ld	ra,104(sp)
    80003172:	7406                	ld	s0,96(sp)
    80003174:	64e6                	ld	s1,88(sp)
    80003176:	6946                	ld	s2,80(sp)
    80003178:	69a6                	ld	s3,72(sp)
    8000317a:	6a06                	ld	s4,64(sp)
    8000317c:	7ae2                	ld	s5,56(sp)
    8000317e:	7b42                	ld	s6,48(sp)
    80003180:	7ba2                	ld	s7,40(sp)
    80003182:	7c02                	ld	s8,32(sp)
    80003184:	6ce2                	ld	s9,24(sp)
    80003186:	6d42                	ld	s10,16(sp)
    80003188:	6da2                	ld	s11,8(sp)
    8000318a:	6165                	addi	sp,sp,112
    8000318c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318e:	8a5e                	mv	s4,s7
    80003190:	bfc9                	j	80003162 <writei+0xe2>
    return -1;
    80003192:	557d                	li	a0,-1
}
    80003194:	8082                	ret
    return -1;
    80003196:	557d                	li	a0,-1
    80003198:	bfe1                	j	80003170 <writei+0xf0>
    return -1;
    8000319a:	557d                	li	a0,-1
    8000319c:	bfd1                	j	80003170 <writei+0xf0>

000000008000319e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000319e:	1141                	addi	sp,sp,-16
    800031a0:	e406                	sd	ra,8(sp)
    800031a2:	e022                	sd	s0,0(sp)
    800031a4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031a6:	4639                	li	a2,14
    800031a8:	ffffd097          	auipc	ra,0xffffd
    800031ac:	1d0080e7          	jalr	464(ra) # 80000378 <strncmp>
}
    800031b0:	60a2                	ld	ra,8(sp)
    800031b2:	6402                	ld	s0,0(sp)
    800031b4:	0141                	addi	sp,sp,16
    800031b6:	8082                	ret

00000000800031b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031b8:	7139                	addi	sp,sp,-64
    800031ba:	fc06                	sd	ra,56(sp)
    800031bc:	f822                	sd	s0,48(sp)
    800031be:	f426                	sd	s1,40(sp)
    800031c0:	f04a                	sd	s2,32(sp)
    800031c2:	ec4e                	sd	s3,24(sp)
    800031c4:	e852                	sd	s4,16(sp)
    800031c6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031c8:	04451703          	lh	a4,68(a0)
    800031cc:	4785                	li	a5,1
    800031ce:	00f71a63          	bne	a4,a5,800031e2 <dirlookup+0x2a>
    800031d2:	892a                	mv	s2,a0
    800031d4:	89ae                	mv	s3,a1
    800031d6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031d8:	457c                	lw	a5,76(a0)
    800031da:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031dc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031de:	e79d                	bnez	a5,8000320c <dirlookup+0x54>
    800031e0:	a8a5                	j	80003258 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800031e2:	00005517          	auipc	a0,0x5
    800031e6:	3ce50513          	addi	a0,a0,974 # 800085b0 <syscalls+0x1a0>
    800031ea:	00003097          	auipc	ra,0x3
    800031ee:	b9e080e7          	jalr	-1122(ra) # 80005d88 <panic>
      panic("dirlookup read");
    800031f2:	00005517          	auipc	a0,0x5
    800031f6:	3d650513          	addi	a0,a0,982 # 800085c8 <syscalls+0x1b8>
    800031fa:	00003097          	auipc	ra,0x3
    800031fe:	b8e080e7          	jalr	-1138(ra) # 80005d88 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003202:	24c1                	addiw	s1,s1,16
    80003204:	04c92783          	lw	a5,76(s2)
    80003208:	04f4f763          	bgeu	s1,a5,80003256 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000320c:	4741                	li	a4,16
    8000320e:	86a6                	mv	a3,s1
    80003210:	fc040613          	addi	a2,s0,-64
    80003214:	4581                	li	a1,0
    80003216:	854a                	mv	a0,s2
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	d70080e7          	jalr	-656(ra) # 80002f88 <readi>
    80003220:	47c1                	li	a5,16
    80003222:	fcf518e3          	bne	a0,a5,800031f2 <dirlookup+0x3a>
    if(de.inum == 0)
    80003226:	fc045783          	lhu	a5,-64(s0)
    8000322a:	dfe1                	beqz	a5,80003202 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000322c:	fc240593          	addi	a1,s0,-62
    80003230:	854e                	mv	a0,s3
    80003232:	00000097          	auipc	ra,0x0
    80003236:	f6c080e7          	jalr	-148(ra) # 8000319e <namecmp>
    8000323a:	f561                	bnez	a0,80003202 <dirlookup+0x4a>
      if(poff)
    8000323c:	000a0463          	beqz	s4,80003244 <dirlookup+0x8c>
        *poff = off;
    80003240:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003244:	fc045583          	lhu	a1,-64(s0)
    80003248:	00092503          	lw	a0,0(s2)
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	754080e7          	jalr	1876(ra) # 800029a0 <iget>
    80003254:	a011                	j	80003258 <dirlookup+0xa0>
  return 0;
    80003256:	4501                	li	a0,0
}
    80003258:	70e2                	ld	ra,56(sp)
    8000325a:	7442                	ld	s0,48(sp)
    8000325c:	74a2                	ld	s1,40(sp)
    8000325e:	7902                	ld	s2,32(sp)
    80003260:	69e2                	ld	s3,24(sp)
    80003262:	6a42                	ld	s4,16(sp)
    80003264:	6121                	addi	sp,sp,64
    80003266:	8082                	ret

0000000080003268 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003268:	711d                	addi	sp,sp,-96
    8000326a:	ec86                	sd	ra,88(sp)
    8000326c:	e8a2                	sd	s0,80(sp)
    8000326e:	e4a6                	sd	s1,72(sp)
    80003270:	e0ca                	sd	s2,64(sp)
    80003272:	fc4e                	sd	s3,56(sp)
    80003274:	f852                	sd	s4,48(sp)
    80003276:	f456                	sd	s5,40(sp)
    80003278:	f05a                	sd	s6,32(sp)
    8000327a:	ec5e                	sd	s7,24(sp)
    8000327c:	e862                	sd	s8,16(sp)
    8000327e:	e466                	sd	s9,8(sp)
    80003280:	1080                	addi	s0,sp,96
    80003282:	84aa                	mv	s1,a0
    80003284:	8b2e                	mv	s6,a1
    80003286:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003288:	00054703          	lbu	a4,0(a0)
    8000328c:	02f00793          	li	a5,47
    80003290:	02f70363          	beq	a4,a5,800032b6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003294:	ffffe097          	auipc	ra,0xffffe
    80003298:	dca080e7          	jalr	-566(ra) # 8000105e <myproc>
    8000329c:	15053503          	ld	a0,336(a0)
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	9f6080e7          	jalr	-1546(ra) # 80002c96 <idup>
    800032a8:	89aa                	mv	s3,a0
  while(*path == '/')
    800032aa:	02f00913          	li	s2,47
  len = path - s;
    800032ae:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032b0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032b2:	4c05                	li	s8,1
    800032b4:	a865                	j	8000336c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032b6:	4585                	li	a1,1
    800032b8:	4505                	li	a0,1
    800032ba:	fffff097          	auipc	ra,0xfffff
    800032be:	6e6080e7          	jalr	1766(ra) # 800029a0 <iget>
    800032c2:	89aa                	mv	s3,a0
    800032c4:	b7dd                	j	800032aa <namex+0x42>
      iunlockput(ip);
    800032c6:	854e                	mv	a0,s3
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	c6e080e7          	jalr	-914(ra) # 80002f36 <iunlockput>
      return 0;
    800032d0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032d2:	854e                	mv	a0,s3
    800032d4:	60e6                	ld	ra,88(sp)
    800032d6:	6446                	ld	s0,80(sp)
    800032d8:	64a6                	ld	s1,72(sp)
    800032da:	6906                	ld	s2,64(sp)
    800032dc:	79e2                	ld	s3,56(sp)
    800032de:	7a42                	ld	s4,48(sp)
    800032e0:	7aa2                	ld	s5,40(sp)
    800032e2:	7b02                	ld	s6,32(sp)
    800032e4:	6be2                	ld	s7,24(sp)
    800032e6:	6c42                	ld	s8,16(sp)
    800032e8:	6ca2                	ld	s9,8(sp)
    800032ea:	6125                	addi	sp,sp,96
    800032ec:	8082                	ret
      iunlock(ip);
    800032ee:	854e                	mv	a0,s3
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	aa6080e7          	jalr	-1370(ra) # 80002d96 <iunlock>
      return ip;
    800032f8:	bfe9                	j	800032d2 <namex+0x6a>
      iunlockput(ip);
    800032fa:	854e                	mv	a0,s3
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	c3a080e7          	jalr	-966(ra) # 80002f36 <iunlockput>
      return 0;
    80003304:	89d2                	mv	s3,s4
    80003306:	b7f1                	j	800032d2 <namex+0x6a>
  len = path - s;
    80003308:	40b48633          	sub	a2,s1,a1
    8000330c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003310:	094cd463          	bge	s9,s4,80003398 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003314:	4639                	li	a2,14
    80003316:	8556                	mv	a0,s5
    80003318:	ffffd097          	auipc	ra,0xffffd
    8000331c:	fe8080e7          	jalr	-24(ra) # 80000300 <memmove>
  while(*path == '/')
    80003320:	0004c783          	lbu	a5,0(s1)
    80003324:	01279763          	bne	a5,s2,80003332 <namex+0xca>
    path++;
    80003328:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000332a:	0004c783          	lbu	a5,0(s1)
    8000332e:	ff278de3          	beq	a5,s2,80003328 <namex+0xc0>
    ilock(ip);
    80003332:	854e                	mv	a0,s3
    80003334:	00000097          	auipc	ra,0x0
    80003338:	9a0080e7          	jalr	-1632(ra) # 80002cd4 <ilock>
    if(ip->type != T_DIR){
    8000333c:	04499783          	lh	a5,68(s3)
    80003340:	f98793e3          	bne	a5,s8,800032c6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003344:	000b0563          	beqz	s6,8000334e <namex+0xe6>
    80003348:	0004c783          	lbu	a5,0(s1)
    8000334c:	d3cd                	beqz	a5,800032ee <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000334e:	865e                	mv	a2,s7
    80003350:	85d6                	mv	a1,s5
    80003352:	854e                	mv	a0,s3
    80003354:	00000097          	auipc	ra,0x0
    80003358:	e64080e7          	jalr	-412(ra) # 800031b8 <dirlookup>
    8000335c:	8a2a                	mv	s4,a0
    8000335e:	dd51                	beqz	a0,800032fa <namex+0x92>
    iunlockput(ip);
    80003360:	854e                	mv	a0,s3
    80003362:	00000097          	auipc	ra,0x0
    80003366:	bd4080e7          	jalr	-1068(ra) # 80002f36 <iunlockput>
    ip = next;
    8000336a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000336c:	0004c783          	lbu	a5,0(s1)
    80003370:	05279763          	bne	a5,s2,800033be <namex+0x156>
    path++;
    80003374:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003376:	0004c783          	lbu	a5,0(s1)
    8000337a:	ff278de3          	beq	a5,s2,80003374 <namex+0x10c>
  if(*path == 0)
    8000337e:	c79d                	beqz	a5,800033ac <namex+0x144>
    path++;
    80003380:	85a6                	mv	a1,s1
  len = path - s;
    80003382:	8a5e                	mv	s4,s7
    80003384:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003386:	01278963          	beq	a5,s2,80003398 <namex+0x130>
    8000338a:	dfbd                	beqz	a5,80003308 <namex+0xa0>
    path++;
    8000338c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000338e:	0004c783          	lbu	a5,0(s1)
    80003392:	ff279ce3          	bne	a5,s2,8000338a <namex+0x122>
    80003396:	bf8d                	j	80003308 <namex+0xa0>
    memmove(name, s, len);
    80003398:	2601                	sext.w	a2,a2
    8000339a:	8556                	mv	a0,s5
    8000339c:	ffffd097          	auipc	ra,0xffffd
    800033a0:	f64080e7          	jalr	-156(ra) # 80000300 <memmove>
    name[len] = 0;
    800033a4:	9a56                	add	s4,s4,s5
    800033a6:	000a0023          	sb	zero,0(s4)
    800033aa:	bf9d                	j	80003320 <namex+0xb8>
  if(nameiparent){
    800033ac:	f20b03e3          	beqz	s6,800032d2 <namex+0x6a>
    iput(ip);
    800033b0:	854e                	mv	a0,s3
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	adc080e7          	jalr	-1316(ra) # 80002e8e <iput>
    return 0;
    800033ba:	4981                	li	s3,0
    800033bc:	bf19                	j	800032d2 <namex+0x6a>
  if(*path == 0)
    800033be:	d7fd                	beqz	a5,800033ac <namex+0x144>
  while(*path != '/' && *path != 0)
    800033c0:	0004c783          	lbu	a5,0(s1)
    800033c4:	85a6                	mv	a1,s1
    800033c6:	b7d1                	j	8000338a <namex+0x122>

00000000800033c8 <dirlink>:
{
    800033c8:	7139                	addi	sp,sp,-64
    800033ca:	fc06                	sd	ra,56(sp)
    800033cc:	f822                	sd	s0,48(sp)
    800033ce:	f426                	sd	s1,40(sp)
    800033d0:	f04a                	sd	s2,32(sp)
    800033d2:	ec4e                	sd	s3,24(sp)
    800033d4:	e852                	sd	s4,16(sp)
    800033d6:	0080                	addi	s0,sp,64
    800033d8:	892a                	mv	s2,a0
    800033da:	8a2e                	mv	s4,a1
    800033dc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033de:	4601                	li	a2,0
    800033e0:	00000097          	auipc	ra,0x0
    800033e4:	dd8080e7          	jalr	-552(ra) # 800031b8 <dirlookup>
    800033e8:	e93d                	bnez	a0,8000345e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ea:	04c92483          	lw	s1,76(s2)
    800033ee:	c49d                	beqz	s1,8000341c <dirlink+0x54>
    800033f0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033f2:	4741                	li	a4,16
    800033f4:	86a6                	mv	a3,s1
    800033f6:	fc040613          	addi	a2,s0,-64
    800033fa:	4581                	li	a1,0
    800033fc:	854a                	mv	a0,s2
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	b8a080e7          	jalr	-1142(ra) # 80002f88 <readi>
    80003406:	47c1                	li	a5,16
    80003408:	06f51163          	bne	a0,a5,8000346a <dirlink+0xa2>
    if(de.inum == 0)
    8000340c:	fc045783          	lhu	a5,-64(s0)
    80003410:	c791                	beqz	a5,8000341c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003412:	24c1                	addiw	s1,s1,16
    80003414:	04c92783          	lw	a5,76(s2)
    80003418:	fcf4ede3          	bltu	s1,a5,800033f2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000341c:	4639                	li	a2,14
    8000341e:	85d2                	mv	a1,s4
    80003420:	fc240513          	addi	a0,s0,-62
    80003424:	ffffd097          	auipc	ra,0xffffd
    80003428:	f90080e7          	jalr	-112(ra) # 800003b4 <strncpy>
  de.inum = inum;
    8000342c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003430:	4741                	li	a4,16
    80003432:	86a6                	mv	a3,s1
    80003434:	fc040613          	addi	a2,s0,-64
    80003438:	4581                	li	a1,0
    8000343a:	854a                	mv	a0,s2
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	c44080e7          	jalr	-956(ra) # 80003080 <writei>
    80003444:	872a                	mv	a4,a0
    80003446:	47c1                	li	a5,16
  return 0;
    80003448:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000344a:	02f71863          	bne	a4,a5,8000347a <dirlink+0xb2>
}
    8000344e:	70e2                	ld	ra,56(sp)
    80003450:	7442                	ld	s0,48(sp)
    80003452:	74a2                	ld	s1,40(sp)
    80003454:	7902                	ld	s2,32(sp)
    80003456:	69e2                	ld	s3,24(sp)
    80003458:	6a42                	ld	s4,16(sp)
    8000345a:	6121                	addi	sp,sp,64
    8000345c:	8082                	ret
    iput(ip);
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	a30080e7          	jalr	-1488(ra) # 80002e8e <iput>
    return -1;
    80003466:	557d                	li	a0,-1
    80003468:	b7dd                	j	8000344e <dirlink+0x86>
      panic("dirlink read");
    8000346a:	00005517          	auipc	a0,0x5
    8000346e:	16e50513          	addi	a0,a0,366 # 800085d8 <syscalls+0x1c8>
    80003472:	00003097          	auipc	ra,0x3
    80003476:	916080e7          	jalr	-1770(ra) # 80005d88 <panic>
    panic("dirlink");
    8000347a:	00005517          	auipc	a0,0x5
    8000347e:	26e50513          	addi	a0,a0,622 # 800086e8 <syscalls+0x2d8>
    80003482:	00003097          	auipc	ra,0x3
    80003486:	906080e7          	jalr	-1786(ra) # 80005d88 <panic>

000000008000348a <namei>:

struct inode*
namei(char *path)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003492:	fe040613          	addi	a2,s0,-32
    80003496:	4581                	li	a1,0
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	dd0080e7          	jalr	-560(ra) # 80003268 <namex>
}
    800034a0:	60e2                	ld	ra,24(sp)
    800034a2:	6442                	ld	s0,16(sp)
    800034a4:	6105                	addi	sp,sp,32
    800034a6:	8082                	ret

00000000800034a8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034a8:	1141                	addi	sp,sp,-16
    800034aa:	e406                	sd	ra,8(sp)
    800034ac:	e022                	sd	s0,0(sp)
    800034ae:	0800                	addi	s0,sp,16
    800034b0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034b2:	4585                	li	a1,1
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	db4080e7          	jalr	-588(ra) # 80003268 <namex>
}
    800034bc:	60a2                	ld	ra,8(sp)
    800034be:	6402                	ld	s0,0(sp)
    800034c0:	0141                	addi	sp,sp,16
    800034c2:	8082                	ret

00000000800034c4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034c4:	1101                	addi	sp,sp,-32
    800034c6:	ec06                	sd	ra,24(sp)
    800034c8:	e822                	sd	s0,16(sp)
    800034ca:	e426                	sd	s1,8(sp)
    800034cc:	e04a                	sd	s2,0(sp)
    800034ce:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034d0:	00236917          	auipc	s2,0x236
    800034d4:	b6890913          	addi	s2,s2,-1176 # 80239038 <log>
    800034d8:	01892583          	lw	a1,24(s2)
    800034dc:	02892503          	lw	a0,40(s2)
    800034e0:	fffff097          	auipc	ra,0xfffff
    800034e4:	ff2080e7          	jalr	-14(ra) # 800024d2 <bread>
    800034e8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034ea:	02c92683          	lw	a3,44(s2)
    800034ee:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034f0:	02d05763          	blez	a3,8000351e <write_head+0x5a>
    800034f4:	00236797          	auipc	a5,0x236
    800034f8:	b7478793          	addi	a5,a5,-1164 # 80239068 <log+0x30>
    800034fc:	05c50713          	addi	a4,a0,92
    80003500:	36fd                	addiw	a3,a3,-1
    80003502:	1682                	slli	a3,a3,0x20
    80003504:	9281                	srli	a3,a3,0x20
    80003506:	068a                	slli	a3,a3,0x2
    80003508:	00236617          	auipc	a2,0x236
    8000350c:	b6460613          	addi	a2,a2,-1180 # 8023906c <log+0x34>
    80003510:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003512:	4390                	lw	a2,0(a5)
    80003514:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003516:	0791                	addi	a5,a5,4
    80003518:	0711                	addi	a4,a4,4
    8000351a:	fed79ce3          	bne	a5,a3,80003512 <write_head+0x4e>
  }
  bwrite(buf);
    8000351e:	8526                	mv	a0,s1
    80003520:	fffff097          	auipc	ra,0xfffff
    80003524:	0a4080e7          	jalr	164(ra) # 800025c4 <bwrite>
  brelse(buf);
    80003528:	8526                	mv	a0,s1
    8000352a:	fffff097          	auipc	ra,0xfffff
    8000352e:	0d8080e7          	jalr	216(ra) # 80002602 <brelse>
}
    80003532:	60e2                	ld	ra,24(sp)
    80003534:	6442                	ld	s0,16(sp)
    80003536:	64a2                	ld	s1,8(sp)
    80003538:	6902                	ld	s2,0(sp)
    8000353a:	6105                	addi	sp,sp,32
    8000353c:	8082                	ret

000000008000353e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000353e:	00236797          	auipc	a5,0x236
    80003542:	b267a783          	lw	a5,-1242(a5) # 80239064 <log+0x2c>
    80003546:	0af05d63          	blez	a5,80003600 <install_trans+0xc2>
{
    8000354a:	7139                	addi	sp,sp,-64
    8000354c:	fc06                	sd	ra,56(sp)
    8000354e:	f822                	sd	s0,48(sp)
    80003550:	f426                	sd	s1,40(sp)
    80003552:	f04a                	sd	s2,32(sp)
    80003554:	ec4e                	sd	s3,24(sp)
    80003556:	e852                	sd	s4,16(sp)
    80003558:	e456                	sd	s5,8(sp)
    8000355a:	e05a                	sd	s6,0(sp)
    8000355c:	0080                	addi	s0,sp,64
    8000355e:	8b2a                	mv	s6,a0
    80003560:	00236a97          	auipc	s5,0x236
    80003564:	b08a8a93          	addi	s5,s5,-1272 # 80239068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003568:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000356a:	00236997          	auipc	s3,0x236
    8000356e:	ace98993          	addi	s3,s3,-1330 # 80239038 <log>
    80003572:	a035                	j	8000359e <install_trans+0x60>
      bunpin(dbuf);
    80003574:	8526                	mv	a0,s1
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	166080e7          	jalr	358(ra) # 800026dc <bunpin>
    brelse(lbuf);
    8000357e:	854a                	mv	a0,s2
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	082080e7          	jalr	130(ra) # 80002602 <brelse>
    brelse(dbuf);
    80003588:	8526                	mv	a0,s1
    8000358a:	fffff097          	auipc	ra,0xfffff
    8000358e:	078080e7          	jalr	120(ra) # 80002602 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003592:	2a05                	addiw	s4,s4,1
    80003594:	0a91                	addi	s5,s5,4
    80003596:	02c9a783          	lw	a5,44(s3)
    8000359a:	04fa5963          	bge	s4,a5,800035ec <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000359e:	0189a583          	lw	a1,24(s3)
    800035a2:	014585bb          	addw	a1,a1,s4
    800035a6:	2585                	addiw	a1,a1,1
    800035a8:	0289a503          	lw	a0,40(s3)
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	f26080e7          	jalr	-218(ra) # 800024d2 <bread>
    800035b4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035b6:	000aa583          	lw	a1,0(s5)
    800035ba:	0289a503          	lw	a0,40(s3)
    800035be:	fffff097          	auipc	ra,0xfffff
    800035c2:	f14080e7          	jalr	-236(ra) # 800024d2 <bread>
    800035c6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035c8:	40000613          	li	a2,1024
    800035cc:	05890593          	addi	a1,s2,88
    800035d0:	05850513          	addi	a0,a0,88
    800035d4:	ffffd097          	auipc	ra,0xffffd
    800035d8:	d2c080e7          	jalr	-724(ra) # 80000300 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035dc:	8526                	mv	a0,s1
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	fe6080e7          	jalr	-26(ra) # 800025c4 <bwrite>
    if(recovering == 0)
    800035e6:	f80b1ce3          	bnez	s6,8000357e <install_trans+0x40>
    800035ea:	b769                	j	80003574 <install_trans+0x36>
}
    800035ec:	70e2                	ld	ra,56(sp)
    800035ee:	7442                	ld	s0,48(sp)
    800035f0:	74a2                	ld	s1,40(sp)
    800035f2:	7902                	ld	s2,32(sp)
    800035f4:	69e2                	ld	s3,24(sp)
    800035f6:	6a42                	ld	s4,16(sp)
    800035f8:	6aa2                	ld	s5,8(sp)
    800035fa:	6b02                	ld	s6,0(sp)
    800035fc:	6121                	addi	sp,sp,64
    800035fe:	8082                	ret
    80003600:	8082                	ret

0000000080003602 <initlog>:
{
    80003602:	7179                	addi	sp,sp,-48
    80003604:	f406                	sd	ra,40(sp)
    80003606:	f022                	sd	s0,32(sp)
    80003608:	ec26                	sd	s1,24(sp)
    8000360a:	e84a                	sd	s2,16(sp)
    8000360c:	e44e                	sd	s3,8(sp)
    8000360e:	1800                	addi	s0,sp,48
    80003610:	892a                	mv	s2,a0
    80003612:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003614:	00236497          	auipc	s1,0x236
    80003618:	a2448493          	addi	s1,s1,-1500 # 80239038 <log>
    8000361c:	00005597          	auipc	a1,0x5
    80003620:	fcc58593          	addi	a1,a1,-52 # 800085e8 <syscalls+0x1d8>
    80003624:	8526                	mv	a0,s1
    80003626:	00003097          	auipc	ra,0x3
    8000362a:	c1c080e7          	jalr	-996(ra) # 80006242 <initlock>
  log.start = sb->logstart;
    8000362e:	0149a583          	lw	a1,20(s3)
    80003632:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003634:	0109a783          	lw	a5,16(s3)
    80003638:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000363a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000363e:	854a                	mv	a0,s2
    80003640:	fffff097          	auipc	ra,0xfffff
    80003644:	e92080e7          	jalr	-366(ra) # 800024d2 <bread>
  log.lh.n = lh->n;
    80003648:	4d3c                	lw	a5,88(a0)
    8000364a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000364c:	02f05563          	blez	a5,80003676 <initlog+0x74>
    80003650:	05c50713          	addi	a4,a0,92
    80003654:	00236697          	auipc	a3,0x236
    80003658:	a1468693          	addi	a3,a3,-1516 # 80239068 <log+0x30>
    8000365c:	37fd                	addiw	a5,a5,-1
    8000365e:	1782                	slli	a5,a5,0x20
    80003660:	9381                	srli	a5,a5,0x20
    80003662:	078a                	slli	a5,a5,0x2
    80003664:	06050613          	addi	a2,a0,96
    80003668:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000366a:	4310                	lw	a2,0(a4)
    8000366c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000366e:	0711                	addi	a4,a4,4
    80003670:	0691                	addi	a3,a3,4
    80003672:	fef71ce3          	bne	a4,a5,8000366a <initlog+0x68>
  brelse(buf);
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	f8c080e7          	jalr	-116(ra) # 80002602 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000367e:	4505                	li	a0,1
    80003680:	00000097          	auipc	ra,0x0
    80003684:	ebe080e7          	jalr	-322(ra) # 8000353e <install_trans>
  log.lh.n = 0;
    80003688:	00236797          	auipc	a5,0x236
    8000368c:	9c07ae23          	sw	zero,-1572(a5) # 80239064 <log+0x2c>
  write_head(); // clear the log
    80003690:	00000097          	auipc	ra,0x0
    80003694:	e34080e7          	jalr	-460(ra) # 800034c4 <write_head>
}
    80003698:	70a2                	ld	ra,40(sp)
    8000369a:	7402                	ld	s0,32(sp)
    8000369c:	64e2                	ld	s1,24(sp)
    8000369e:	6942                	ld	s2,16(sp)
    800036a0:	69a2                	ld	s3,8(sp)
    800036a2:	6145                	addi	sp,sp,48
    800036a4:	8082                	ret

00000000800036a6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036a6:	1101                	addi	sp,sp,-32
    800036a8:	ec06                	sd	ra,24(sp)
    800036aa:	e822                	sd	s0,16(sp)
    800036ac:	e426                	sd	s1,8(sp)
    800036ae:	e04a                	sd	s2,0(sp)
    800036b0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036b2:	00236517          	auipc	a0,0x236
    800036b6:	98650513          	addi	a0,a0,-1658 # 80239038 <log>
    800036ba:	00003097          	auipc	ra,0x3
    800036be:	c18080e7          	jalr	-1000(ra) # 800062d2 <acquire>
  while(1){
    if(log.committing){
    800036c2:	00236497          	auipc	s1,0x236
    800036c6:	97648493          	addi	s1,s1,-1674 # 80239038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ca:	4979                	li	s2,30
    800036cc:	a039                	j	800036da <begin_op+0x34>
      sleep(&log, &log.lock);
    800036ce:	85a6                	mv	a1,s1
    800036d0:	8526                	mv	a0,s1
    800036d2:	ffffe097          	auipc	ra,0xffffe
    800036d6:	048080e7          	jalr	72(ra) # 8000171a <sleep>
    if(log.committing){
    800036da:	50dc                	lw	a5,36(s1)
    800036dc:	fbed                	bnez	a5,800036ce <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036de:	509c                	lw	a5,32(s1)
    800036e0:	0017871b          	addiw	a4,a5,1
    800036e4:	0007069b          	sext.w	a3,a4
    800036e8:	0027179b          	slliw	a5,a4,0x2
    800036ec:	9fb9                	addw	a5,a5,a4
    800036ee:	0017979b          	slliw	a5,a5,0x1
    800036f2:	54d8                	lw	a4,44(s1)
    800036f4:	9fb9                	addw	a5,a5,a4
    800036f6:	00f95963          	bge	s2,a5,80003708 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036fa:	85a6                	mv	a1,s1
    800036fc:	8526                	mv	a0,s1
    800036fe:	ffffe097          	auipc	ra,0xffffe
    80003702:	01c080e7          	jalr	28(ra) # 8000171a <sleep>
    80003706:	bfd1                	j	800036da <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003708:	00236517          	auipc	a0,0x236
    8000370c:	93050513          	addi	a0,a0,-1744 # 80239038 <log>
    80003710:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003712:	00003097          	auipc	ra,0x3
    80003716:	c74080e7          	jalr	-908(ra) # 80006386 <release>
      break;
    }
  }
}
    8000371a:	60e2                	ld	ra,24(sp)
    8000371c:	6442                	ld	s0,16(sp)
    8000371e:	64a2                	ld	s1,8(sp)
    80003720:	6902                	ld	s2,0(sp)
    80003722:	6105                	addi	sp,sp,32
    80003724:	8082                	ret

0000000080003726 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003726:	7139                	addi	sp,sp,-64
    80003728:	fc06                	sd	ra,56(sp)
    8000372a:	f822                	sd	s0,48(sp)
    8000372c:	f426                	sd	s1,40(sp)
    8000372e:	f04a                	sd	s2,32(sp)
    80003730:	ec4e                	sd	s3,24(sp)
    80003732:	e852                	sd	s4,16(sp)
    80003734:	e456                	sd	s5,8(sp)
    80003736:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003738:	00236497          	auipc	s1,0x236
    8000373c:	90048493          	addi	s1,s1,-1792 # 80239038 <log>
    80003740:	8526                	mv	a0,s1
    80003742:	00003097          	auipc	ra,0x3
    80003746:	b90080e7          	jalr	-1136(ra) # 800062d2 <acquire>
  log.outstanding -= 1;
    8000374a:	509c                	lw	a5,32(s1)
    8000374c:	37fd                	addiw	a5,a5,-1
    8000374e:	0007891b          	sext.w	s2,a5
    80003752:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003754:	50dc                	lw	a5,36(s1)
    80003756:	efb9                	bnez	a5,800037b4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003758:	06091663          	bnez	s2,800037c4 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000375c:	00236497          	auipc	s1,0x236
    80003760:	8dc48493          	addi	s1,s1,-1828 # 80239038 <log>
    80003764:	4785                	li	a5,1
    80003766:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003768:	8526                	mv	a0,s1
    8000376a:	00003097          	auipc	ra,0x3
    8000376e:	c1c080e7          	jalr	-996(ra) # 80006386 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003772:	54dc                	lw	a5,44(s1)
    80003774:	06f04763          	bgtz	a5,800037e2 <end_op+0xbc>
    acquire(&log.lock);
    80003778:	00236497          	auipc	s1,0x236
    8000377c:	8c048493          	addi	s1,s1,-1856 # 80239038 <log>
    80003780:	8526                	mv	a0,s1
    80003782:	00003097          	auipc	ra,0x3
    80003786:	b50080e7          	jalr	-1200(ra) # 800062d2 <acquire>
    log.committing = 0;
    8000378a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000378e:	8526                	mv	a0,s1
    80003790:	ffffe097          	auipc	ra,0xffffe
    80003794:	116080e7          	jalr	278(ra) # 800018a6 <wakeup>
    release(&log.lock);
    80003798:	8526                	mv	a0,s1
    8000379a:	00003097          	auipc	ra,0x3
    8000379e:	bec080e7          	jalr	-1044(ra) # 80006386 <release>
}
    800037a2:	70e2                	ld	ra,56(sp)
    800037a4:	7442                	ld	s0,48(sp)
    800037a6:	74a2                	ld	s1,40(sp)
    800037a8:	7902                	ld	s2,32(sp)
    800037aa:	69e2                	ld	s3,24(sp)
    800037ac:	6a42                	ld	s4,16(sp)
    800037ae:	6aa2                	ld	s5,8(sp)
    800037b0:	6121                	addi	sp,sp,64
    800037b2:	8082                	ret
    panic("log.committing");
    800037b4:	00005517          	auipc	a0,0x5
    800037b8:	e3c50513          	addi	a0,a0,-452 # 800085f0 <syscalls+0x1e0>
    800037bc:	00002097          	auipc	ra,0x2
    800037c0:	5cc080e7          	jalr	1484(ra) # 80005d88 <panic>
    wakeup(&log);
    800037c4:	00236497          	auipc	s1,0x236
    800037c8:	87448493          	addi	s1,s1,-1932 # 80239038 <log>
    800037cc:	8526                	mv	a0,s1
    800037ce:	ffffe097          	auipc	ra,0xffffe
    800037d2:	0d8080e7          	jalr	216(ra) # 800018a6 <wakeup>
  release(&log.lock);
    800037d6:	8526                	mv	a0,s1
    800037d8:	00003097          	auipc	ra,0x3
    800037dc:	bae080e7          	jalr	-1106(ra) # 80006386 <release>
  if(do_commit){
    800037e0:	b7c9                	j	800037a2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e2:	00236a97          	auipc	s5,0x236
    800037e6:	886a8a93          	addi	s5,s5,-1914 # 80239068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037ea:	00236a17          	auipc	s4,0x236
    800037ee:	84ea0a13          	addi	s4,s4,-1970 # 80239038 <log>
    800037f2:	018a2583          	lw	a1,24(s4)
    800037f6:	012585bb          	addw	a1,a1,s2
    800037fa:	2585                	addiw	a1,a1,1
    800037fc:	028a2503          	lw	a0,40(s4)
    80003800:	fffff097          	auipc	ra,0xfffff
    80003804:	cd2080e7          	jalr	-814(ra) # 800024d2 <bread>
    80003808:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000380a:	000aa583          	lw	a1,0(s5)
    8000380e:	028a2503          	lw	a0,40(s4)
    80003812:	fffff097          	auipc	ra,0xfffff
    80003816:	cc0080e7          	jalr	-832(ra) # 800024d2 <bread>
    8000381a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000381c:	40000613          	li	a2,1024
    80003820:	05850593          	addi	a1,a0,88
    80003824:	05848513          	addi	a0,s1,88
    80003828:	ffffd097          	auipc	ra,0xffffd
    8000382c:	ad8080e7          	jalr	-1320(ra) # 80000300 <memmove>
    bwrite(to);  // write the log
    80003830:	8526                	mv	a0,s1
    80003832:	fffff097          	auipc	ra,0xfffff
    80003836:	d92080e7          	jalr	-622(ra) # 800025c4 <bwrite>
    brelse(from);
    8000383a:	854e                	mv	a0,s3
    8000383c:	fffff097          	auipc	ra,0xfffff
    80003840:	dc6080e7          	jalr	-570(ra) # 80002602 <brelse>
    brelse(to);
    80003844:	8526                	mv	a0,s1
    80003846:	fffff097          	auipc	ra,0xfffff
    8000384a:	dbc080e7          	jalr	-580(ra) # 80002602 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000384e:	2905                	addiw	s2,s2,1
    80003850:	0a91                	addi	s5,s5,4
    80003852:	02ca2783          	lw	a5,44(s4)
    80003856:	f8f94ee3          	blt	s2,a5,800037f2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000385a:	00000097          	auipc	ra,0x0
    8000385e:	c6a080e7          	jalr	-918(ra) # 800034c4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003862:	4501                	li	a0,0
    80003864:	00000097          	auipc	ra,0x0
    80003868:	cda080e7          	jalr	-806(ra) # 8000353e <install_trans>
    log.lh.n = 0;
    8000386c:	00235797          	auipc	a5,0x235
    80003870:	7e07ac23          	sw	zero,2040(a5) # 80239064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003874:	00000097          	auipc	ra,0x0
    80003878:	c50080e7          	jalr	-944(ra) # 800034c4 <write_head>
    8000387c:	bdf5                	j	80003778 <end_op+0x52>

000000008000387e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000387e:	1101                	addi	sp,sp,-32
    80003880:	ec06                	sd	ra,24(sp)
    80003882:	e822                	sd	s0,16(sp)
    80003884:	e426                	sd	s1,8(sp)
    80003886:	e04a                	sd	s2,0(sp)
    80003888:	1000                	addi	s0,sp,32
    8000388a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000388c:	00235917          	auipc	s2,0x235
    80003890:	7ac90913          	addi	s2,s2,1964 # 80239038 <log>
    80003894:	854a                	mv	a0,s2
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	a3c080e7          	jalr	-1476(ra) # 800062d2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000389e:	02c92603          	lw	a2,44(s2)
    800038a2:	47f5                	li	a5,29
    800038a4:	06c7c563          	blt	a5,a2,8000390e <log_write+0x90>
    800038a8:	00235797          	auipc	a5,0x235
    800038ac:	7ac7a783          	lw	a5,1964(a5) # 80239054 <log+0x1c>
    800038b0:	37fd                	addiw	a5,a5,-1
    800038b2:	04f65e63          	bge	a2,a5,8000390e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038b6:	00235797          	auipc	a5,0x235
    800038ba:	7a27a783          	lw	a5,1954(a5) # 80239058 <log+0x20>
    800038be:	06f05063          	blez	a5,8000391e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038c2:	4781                	li	a5,0
    800038c4:	06c05563          	blez	a2,8000392e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038c8:	44cc                	lw	a1,12(s1)
    800038ca:	00235717          	auipc	a4,0x235
    800038ce:	79e70713          	addi	a4,a4,1950 # 80239068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038d2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038d4:	4314                	lw	a3,0(a4)
    800038d6:	04b68c63          	beq	a3,a1,8000392e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038da:	2785                	addiw	a5,a5,1
    800038dc:	0711                	addi	a4,a4,4
    800038de:	fef61be3          	bne	a2,a5,800038d4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038e2:	0621                	addi	a2,a2,8
    800038e4:	060a                	slli	a2,a2,0x2
    800038e6:	00235797          	auipc	a5,0x235
    800038ea:	75278793          	addi	a5,a5,1874 # 80239038 <log>
    800038ee:	963e                	add	a2,a2,a5
    800038f0:	44dc                	lw	a5,12(s1)
    800038f2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038f4:	8526                	mv	a0,s1
    800038f6:	fffff097          	auipc	ra,0xfffff
    800038fa:	daa080e7          	jalr	-598(ra) # 800026a0 <bpin>
    log.lh.n++;
    800038fe:	00235717          	auipc	a4,0x235
    80003902:	73a70713          	addi	a4,a4,1850 # 80239038 <log>
    80003906:	575c                	lw	a5,44(a4)
    80003908:	2785                	addiw	a5,a5,1
    8000390a:	d75c                	sw	a5,44(a4)
    8000390c:	a835                	j	80003948 <log_write+0xca>
    panic("too big a transaction");
    8000390e:	00005517          	auipc	a0,0x5
    80003912:	cf250513          	addi	a0,a0,-782 # 80008600 <syscalls+0x1f0>
    80003916:	00002097          	auipc	ra,0x2
    8000391a:	472080e7          	jalr	1138(ra) # 80005d88 <panic>
    panic("log_write outside of trans");
    8000391e:	00005517          	auipc	a0,0x5
    80003922:	cfa50513          	addi	a0,a0,-774 # 80008618 <syscalls+0x208>
    80003926:	00002097          	auipc	ra,0x2
    8000392a:	462080e7          	jalr	1122(ra) # 80005d88 <panic>
  log.lh.block[i] = b->blockno;
    8000392e:	00878713          	addi	a4,a5,8
    80003932:	00271693          	slli	a3,a4,0x2
    80003936:	00235717          	auipc	a4,0x235
    8000393a:	70270713          	addi	a4,a4,1794 # 80239038 <log>
    8000393e:	9736                	add	a4,a4,a3
    80003940:	44d4                	lw	a3,12(s1)
    80003942:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003944:	faf608e3          	beq	a2,a5,800038f4 <log_write+0x76>
  }
  release(&log.lock);
    80003948:	00235517          	auipc	a0,0x235
    8000394c:	6f050513          	addi	a0,a0,1776 # 80239038 <log>
    80003950:	00003097          	auipc	ra,0x3
    80003954:	a36080e7          	jalr	-1482(ra) # 80006386 <release>
}
    80003958:	60e2                	ld	ra,24(sp)
    8000395a:	6442                	ld	s0,16(sp)
    8000395c:	64a2                	ld	s1,8(sp)
    8000395e:	6902                	ld	s2,0(sp)
    80003960:	6105                	addi	sp,sp,32
    80003962:	8082                	ret

0000000080003964 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003964:	1101                	addi	sp,sp,-32
    80003966:	ec06                	sd	ra,24(sp)
    80003968:	e822                	sd	s0,16(sp)
    8000396a:	e426                	sd	s1,8(sp)
    8000396c:	e04a                	sd	s2,0(sp)
    8000396e:	1000                	addi	s0,sp,32
    80003970:	84aa                	mv	s1,a0
    80003972:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003974:	00005597          	auipc	a1,0x5
    80003978:	cc458593          	addi	a1,a1,-828 # 80008638 <syscalls+0x228>
    8000397c:	0521                	addi	a0,a0,8
    8000397e:	00003097          	auipc	ra,0x3
    80003982:	8c4080e7          	jalr	-1852(ra) # 80006242 <initlock>
  lk->name = name;
    80003986:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000398a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000398e:	0204a423          	sw	zero,40(s1)
}
    80003992:	60e2                	ld	ra,24(sp)
    80003994:	6442                	ld	s0,16(sp)
    80003996:	64a2                	ld	s1,8(sp)
    80003998:	6902                	ld	s2,0(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret

000000008000399e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000399e:	1101                	addi	sp,sp,-32
    800039a0:	ec06                	sd	ra,24(sp)
    800039a2:	e822                	sd	s0,16(sp)
    800039a4:	e426                	sd	s1,8(sp)
    800039a6:	e04a                	sd	s2,0(sp)
    800039a8:	1000                	addi	s0,sp,32
    800039aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039ac:	00850913          	addi	s2,a0,8
    800039b0:	854a                	mv	a0,s2
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	920080e7          	jalr	-1760(ra) # 800062d2 <acquire>
  while (lk->locked) {
    800039ba:	409c                	lw	a5,0(s1)
    800039bc:	cb89                	beqz	a5,800039ce <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039be:	85ca                	mv	a1,s2
    800039c0:	8526                	mv	a0,s1
    800039c2:	ffffe097          	auipc	ra,0xffffe
    800039c6:	d58080e7          	jalr	-680(ra) # 8000171a <sleep>
  while (lk->locked) {
    800039ca:	409c                	lw	a5,0(s1)
    800039cc:	fbed                	bnez	a5,800039be <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ce:	4785                	li	a5,1
    800039d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039d2:	ffffd097          	auipc	ra,0xffffd
    800039d6:	68c080e7          	jalr	1676(ra) # 8000105e <myproc>
    800039da:	591c                	lw	a5,48(a0)
    800039dc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039de:	854a                	mv	a0,s2
    800039e0:	00003097          	auipc	ra,0x3
    800039e4:	9a6080e7          	jalr	-1626(ra) # 80006386 <release>
}
    800039e8:	60e2                	ld	ra,24(sp)
    800039ea:	6442                	ld	s0,16(sp)
    800039ec:	64a2                	ld	s1,8(sp)
    800039ee:	6902                	ld	s2,0(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret

00000000800039f4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039f4:	1101                	addi	sp,sp,-32
    800039f6:	ec06                	sd	ra,24(sp)
    800039f8:	e822                	sd	s0,16(sp)
    800039fa:	e426                	sd	s1,8(sp)
    800039fc:	e04a                	sd	s2,0(sp)
    800039fe:	1000                	addi	s0,sp,32
    80003a00:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a02:	00850913          	addi	s2,a0,8
    80003a06:	854a                	mv	a0,s2
    80003a08:	00003097          	auipc	ra,0x3
    80003a0c:	8ca080e7          	jalr	-1846(ra) # 800062d2 <acquire>
  lk->locked = 0;
    80003a10:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a14:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a18:	8526                	mv	a0,s1
    80003a1a:	ffffe097          	auipc	ra,0xffffe
    80003a1e:	e8c080e7          	jalr	-372(ra) # 800018a6 <wakeup>
  release(&lk->lk);
    80003a22:	854a                	mv	a0,s2
    80003a24:	00003097          	auipc	ra,0x3
    80003a28:	962080e7          	jalr	-1694(ra) # 80006386 <release>
}
    80003a2c:	60e2                	ld	ra,24(sp)
    80003a2e:	6442                	ld	s0,16(sp)
    80003a30:	64a2                	ld	s1,8(sp)
    80003a32:	6902                	ld	s2,0(sp)
    80003a34:	6105                	addi	sp,sp,32
    80003a36:	8082                	ret

0000000080003a38 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a38:	7179                	addi	sp,sp,-48
    80003a3a:	f406                	sd	ra,40(sp)
    80003a3c:	f022                	sd	s0,32(sp)
    80003a3e:	ec26                	sd	s1,24(sp)
    80003a40:	e84a                	sd	s2,16(sp)
    80003a42:	e44e                	sd	s3,8(sp)
    80003a44:	1800                	addi	s0,sp,48
    80003a46:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a48:	00850913          	addi	s2,a0,8
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	884080e7          	jalr	-1916(ra) # 800062d2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a56:	409c                	lw	a5,0(s1)
    80003a58:	ef99                	bnez	a5,80003a76 <holdingsleep+0x3e>
    80003a5a:	4481                	li	s1,0
  release(&lk->lk);
    80003a5c:	854a                	mv	a0,s2
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	928080e7          	jalr	-1752(ra) # 80006386 <release>
  return r;
}
    80003a66:	8526                	mv	a0,s1
    80003a68:	70a2                	ld	ra,40(sp)
    80003a6a:	7402                	ld	s0,32(sp)
    80003a6c:	64e2                	ld	s1,24(sp)
    80003a6e:	6942                	ld	s2,16(sp)
    80003a70:	69a2                	ld	s3,8(sp)
    80003a72:	6145                	addi	sp,sp,48
    80003a74:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a76:	0284a983          	lw	s3,40(s1)
    80003a7a:	ffffd097          	auipc	ra,0xffffd
    80003a7e:	5e4080e7          	jalr	1508(ra) # 8000105e <myproc>
    80003a82:	5904                	lw	s1,48(a0)
    80003a84:	413484b3          	sub	s1,s1,s3
    80003a88:	0014b493          	seqz	s1,s1
    80003a8c:	bfc1                	j	80003a5c <holdingsleep+0x24>

0000000080003a8e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a8e:	1141                	addi	sp,sp,-16
    80003a90:	e406                	sd	ra,8(sp)
    80003a92:	e022                	sd	s0,0(sp)
    80003a94:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a96:	00005597          	auipc	a1,0x5
    80003a9a:	bb258593          	addi	a1,a1,-1102 # 80008648 <syscalls+0x238>
    80003a9e:	00235517          	auipc	a0,0x235
    80003aa2:	6e250513          	addi	a0,a0,1762 # 80239180 <ftable>
    80003aa6:	00002097          	auipc	ra,0x2
    80003aaa:	79c080e7          	jalr	1948(ra) # 80006242 <initlock>
}
    80003aae:	60a2                	ld	ra,8(sp)
    80003ab0:	6402                	ld	s0,0(sp)
    80003ab2:	0141                	addi	sp,sp,16
    80003ab4:	8082                	ret

0000000080003ab6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ab6:	1101                	addi	sp,sp,-32
    80003ab8:	ec06                	sd	ra,24(sp)
    80003aba:	e822                	sd	s0,16(sp)
    80003abc:	e426                	sd	s1,8(sp)
    80003abe:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ac0:	00235517          	auipc	a0,0x235
    80003ac4:	6c050513          	addi	a0,a0,1728 # 80239180 <ftable>
    80003ac8:	00003097          	auipc	ra,0x3
    80003acc:	80a080e7          	jalr	-2038(ra) # 800062d2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ad0:	00235497          	auipc	s1,0x235
    80003ad4:	6c848493          	addi	s1,s1,1736 # 80239198 <ftable+0x18>
    80003ad8:	00236717          	auipc	a4,0x236
    80003adc:	66070713          	addi	a4,a4,1632 # 8023a138 <ftable+0xfb8>
    if(f->ref == 0){
    80003ae0:	40dc                	lw	a5,4(s1)
    80003ae2:	cf99                	beqz	a5,80003b00 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003ae4:	02848493          	addi	s1,s1,40
    80003ae8:	fee49ce3          	bne	s1,a4,80003ae0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003aec:	00235517          	auipc	a0,0x235
    80003af0:	69450513          	addi	a0,a0,1684 # 80239180 <ftable>
    80003af4:	00003097          	auipc	ra,0x3
    80003af8:	892080e7          	jalr	-1902(ra) # 80006386 <release>
  return 0;
    80003afc:	4481                	li	s1,0
    80003afe:	a819                	j	80003b14 <filealloc+0x5e>
      f->ref = 1;
    80003b00:	4785                	li	a5,1
    80003b02:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b04:	00235517          	auipc	a0,0x235
    80003b08:	67c50513          	addi	a0,a0,1660 # 80239180 <ftable>
    80003b0c:	00003097          	auipc	ra,0x3
    80003b10:	87a080e7          	jalr	-1926(ra) # 80006386 <release>
}
    80003b14:	8526                	mv	a0,s1
    80003b16:	60e2                	ld	ra,24(sp)
    80003b18:	6442                	ld	s0,16(sp)
    80003b1a:	64a2                	ld	s1,8(sp)
    80003b1c:	6105                	addi	sp,sp,32
    80003b1e:	8082                	ret

0000000080003b20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b20:	1101                	addi	sp,sp,-32
    80003b22:	ec06                	sd	ra,24(sp)
    80003b24:	e822                	sd	s0,16(sp)
    80003b26:	e426                	sd	s1,8(sp)
    80003b28:	1000                	addi	s0,sp,32
    80003b2a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b2c:	00235517          	auipc	a0,0x235
    80003b30:	65450513          	addi	a0,a0,1620 # 80239180 <ftable>
    80003b34:	00002097          	auipc	ra,0x2
    80003b38:	79e080e7          	jalr	1950(ra) # 800062d2 <acquire>
  if(f->ref < 1)
    80003b3c:	40dc                	lw	a5,4(s1)
    80003b3e:	02f05263          	blez	a5,80003b62 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b42:	2785                	addiw	a5,a5,1
    80003b44:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b46:	00235517          	auipc	a0,0x235
    80003b4a:	63a50513          	addi	a0,a0,1594 # 80239180 <ftable>
    80003b4e:	00003097          	auipc	ra,0x3
    80003b52:	838080e7          	jalr	-1992(ra) # 80006386 <release>
  return f;
}
    80003b56:	8526                	mv	a0,s1
    80003b58:	60e2                	ld	ra,24(sp)
    80003b5a:	6442                	ld	s0,16(sp)
    80003b5c:	64a2                	ld	s1,8(sp)
    80003b5e:	6105                	addi	sp,sp,32
    80003b60:	8082                	ret
    panic("filedup");
    80003b62:	00005517          	auipc	a0,0x5
    80003b66:	aee50513          	addi	a0,a0,-1298 # 80008650 <syscalls+0x240>
    80003b6a:	00002097          	auipc	ra,0x2
    80003b6e:	21e080e7          	jalr	542(ra) # 80005d88 <panic>

0000000080003b72 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b72:	7139                	addi	sp,sp,-64
    80003b74:	fc06                	sd	ra,56(sp)
    80003b76:	f822                	sd	s0,48(sp)
    80003b78:	f426                	sd	s1,40(sp)
    80003b7a:	f04a                	sd	s2,32(sp)
    80003b7c:	ec4e                	sd	s3,24(sp)
    80003b7e:	e852                	sd	s4,16(sp)
    80003b80:	e456                	sd	s5,8(sp)
    80003b82:	0080                	addi	s0,sp,64
    80003b84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b86:	00235517          	auipc	a0,0x235
    80003b8a:	5fa50513          	addi	a0,a0,1530 # 80239180 <ftable>
    80003b8e:	00002097          	auipc	ra,0x2
    80003b92:	744080e7          	jalr	1860(ra) # 800062d2 <acquire>
  if(f->ref < 1)
    80003b96:	40dc                	lw	a5,4(s1)
    80003b98:	06f05163          	blez	a5,80003bfa <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b9c:	37fd                	addiw	a5,a5,-1
    80003b9e:	0007871b          	sext.w	a4,a5
    80003ba2:	c0dc                	sw	a5,4(s1)
    80003ba4:	06e04363          	bgtz	a4,80003c0a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ba8:	0004a903          	lw	s2,0(s1)
    80003bac:	0094ca83          	lbu	s5,9(s1)
    80003bb0:	0104ba03          	ld	s4,16(s1)
    80003bb4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bb8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bbc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003bc0:	00235517          	auipc	a0,0x235
    80003bc4:	5c050513          	addi	a0,a0,1472 # 80239180 <ftable>
    80003bc8:	00002097          	auipc	ra,0x2
    80003bcc:	7be080e7          	jalr	1982(ra) # 80006386 <release>

  if(ff.type == FD_PIPE){
    80003bd0:	4785                	li	a5,1
    80003bd2:	04f90d63          	beq	s2,a5,80003c2c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bd6:	3979                	addiw	s2,s2,-2
    80003bd8:	4785                	li	a5,1
    80003bda:	0527e063          	bltu	a5,s2,80003c1a <fileclose+0xa8>
    begin_op();
    80003bde:	00000097          	auipc	ra,0x0
    80003be2:	ac8080e7          	jalr	-1336(ra) # 800036a6 <begin_op>
    iput(ff.ip);
    80003be6:	854e                	mv	a0,s3
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	2a6080e7          	jalr	678(ra) # 80002e8e <iput>
    end_op();
    80003bf0:	00000097          	auipc	ra,0x0
    80003bf4:	b36080e7          	jalr	-1226(ra) # 80003726 <end_op>
    80003bf8:	a00d                	j	80003c1a <fileclose+0xa8>
    panic("fileclose");
    80003bfa:	00005517          	auipc	a0,0x5
    80003bfe:	a5e50513          	addi	a0,a0,-1442 # 80008658 <syscalls+0x248>
    80003c02:	00002097          	auipc	ra,0x2
    80003c06:	186080e7          	jalr	390(ra) # 80005d88 <panic>
    release(&ftable.lock);
    80003c0a:	00235517          	auipc	a0,0x235
    80003c0e:	57650513          	addi	a0,a0,1398 # 80239180 <ftable>
    80003c12:	00002097          	auipc	ra,0x2
    80003c16:	774080e7          	jalr	1908(ra) # 80006386 <release>
  }
}
    80003c1a:	70e2                	ld	ra,56(sp)
    80003c1c:	7442                	ld	s0,48(sp)
    80003c1e:	74a2                	ld	s1,40(sp)
    80003c20:	7902                	ld	s2,32(sp)
    80003c22:	69e2                	ld	s3,24(sp)
    80003c24:	6a42                	ld	s4,16(sp)
    80003c26:	6aa2                	ld	s5,8(sp)
    80003c28:	6121                	addi	sp,sp,64
    80003c2a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c2c:	85d6                	mv	a1,s5
    80003c2e:	8552                	mv	a0,s4
    80003c30:	00000097          	auipc	ra,0x0
    80003c34:	34c080e7          	jalr	844(ra) # 80003f7c <pipeclose>
    80003c38:	b7cd                	j	80003c1a <fileclose+0xa8>

0000000080003c3a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c3a:	715d                	addi	sp,sp,-80
    80003c3c:	e486                	sd	ra,72(sp)
    80003c3e:	e0a2                	sd	s0,64(sp)
    80003c40:	fc26                	sd	s1,56(sp)
    80003c42:	f84a                	sd	s2,48(sp)
    80003c44:	f44e                	sd	s3,40(sp)
    80003c46:	0880                	addi	s0,sp,80
    80003c48:	84aa                	mv	s1,a0
    80003c4a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c4c:	ffffd097          	auipc	ra,0xffffd
    80003c50:	412080e7          	jalr	1042(ra) # 8000105e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c54:	409c                	lw	a5,0(s1)
    80003c56:	37f9                	addiw	a5,a5,-2
    80003c58:	4705                	li	a4,1
    80003c5a:	04f76763          	bltu	a4,a5,80003ca8 <filestat+0x6e>
    80003c5e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c60:	6c88                	ld	a0,24(s1)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	072080e7          	jalr	114(ra) # 80002cd4 <ilock>
    stati(f->ip, &st);
    80003c6a:	fb840593          	addi	a1,s0,-72
    80003c6e:	6c88                	ld	a0,24(s1)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	2ee080e7          	jalr	750(ra) # 80002f5e <stati>
    iunlock(f->ip);
    80003c78:	6c88                	ld	a0,24(s1)
    80003c7a:	fffff097          	auipc	ra,0xfffff
    80003c7e:	11c080e7          	jalr	284(ra) # 80002d96 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c82:	46e1                	li	a3,24
    80003c84:	fb840613          	addi	a2,s0,-72
    80003c88:	85ce                	mv	a1,s3
    80003c8a:	05093503          	ld	a0,80(s2)
    80003c8e:	ffffd097          	auipc	ra,0xffffd
    80003c92:	1b0080e7          	jalr	432(ra) # 80000e3e <copyout>
    80003c96:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c9a:	60a6                	ld	ra,72(sp)
    80003c9c:	6406                	ld	s0,64(sp)
    80003c9e:	74e2                	ld	s1,56(sp)
    80003ca0:	7942                	ld	s2,48(sp)
    80003ca2:	79a2                	ld	s3,40(sp)
    80003ca4:	6161                	addi	sp,sp,80
    80003ca6:	8082                	ret
  return -1;
    80003ca8:	557d                	li	a0,-1
    80003caa:	bfc5                	j	80003c9a <filestat+0x60>

0000000080003cac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cac:	7179                	addi	sp,sp,-48
    80003cae:	f406                	sd	ra,40(sp)
    80003cb0:	f022                	sd	s0,32(sp)
    80003cb2:	ec26                	sd	s1,24(sp)
    80003cb4:	e84a                	sd	s2,16(sp)
    80003cb6:	e44e                	sd	s3,8(sp)
    80003cb8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cba:	00854783          	lbu	a5,8(a0)
    80003cbe:	c3d5                	beqz	a5,80003d62 <fileread+0xb6>
    80003cc0:	84aa                	mv	s1,a0
    80003cc2:	89ae                	mv	s3,a1
    80003cc4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cc6:	411c                	lw	a5,0(a0)
    80003cc8:	4705                	li	a4,1
    80003cca:	04e78963          	beq	a5,a4,80003d1c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cce:	470d                	li	a4,3
    80003cd0:	04e78d63          	beq	a5,a4,80003d2a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cd4:	4709                	li	a4,2
    80003cd6:	06e79e63          	bne	a5,a4,80003d52 <fileread+0xa6>
    ilock(f->ip);
    80003cda:	6d08                	ld	a0,24(a0)
    80003cdc:	fffff097          	auipc	ra,0xfffff
    80003ce0:	ff8080e7          	jalr	-8(ra) # 80002cd4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ce4:	874a                	mv	a4,s2
    80003ce6:	5094                	lw	a3,32(s1)
    80003ce8:	864e                	mv	a2,s3
    80003cea:	4585                	li	a1,1
    80003cec:	6c88                	ld	a0,24(s1)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	29a080e7          	jalr	666(ra) # 80002f88 <readi>
    80003cf6:	892a                	mv	s2,a0
    80003cf8:	00a05563          	blez	a0,80003d02 <fileread+0x56>
      f->off += r;
    80003cfc:	509c                	lw	a5,32(s1)
    80003cfe:	9fa9                	addw	a5,a5,a0
    80003d00:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d02:	6c88                	ld	a0,24(s1)
    80003d04:	fffff097          	auipc	ra,0xfffff
    80003d08:	092080e7          	jalr	146(ra) # 80002d96 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d0c:	854a                	mv	a0,s2
    80003d0e:	70a2                	ld	ra,40(sp)
    80003d10:	7402                	ld	s0,32(sp)
    80003d12:	64e2                	ld	s1,24(sp)
    80003d14:	6942                	ld	s2,16(sp)
    80003d16:	69a2                	ld	s3,8(sp)
    80003d18:	6145                	addi	sp,sp,48
    80003d1a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d1c:	6908                	ld	a0,16(a0)
    80003d1e:	00000097          	auipc	ra,0x0
    80003d22:	3c8080e7          	jalr	968(ra) # 800040e6 <piperead>
    80003d26:	892a                	mv	s2,a0
    80003d28:	b7d5                	j	80003d0c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d2a:	02451783          	lh	a5,36(a0)
    80003d2e:	03079693          	slli	a3,a5,0x30
    80003d32:	92c1                	srli	a3,a3,0x30
    80003d34:	4725                	li	a4,9
    80003d36:	02d76863          	bltu	a4,a3,80003d66 <fileread+0xba>
    80003d3a:	0792                	slli	a5,a5,0x4
    80003d3c:	00235717          	auipc	a4,0x235
    80003d40:	3a470713          	addi	a4,a4,932 # 802390e0 <devsw>
    80003d44:	97ba                	add	a5,a5,a4
    80003d46:	639c                	ld	a5,0(a5)
    80003d48:	c38d                	beqz	a5,80003d6a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d4a:	4505                	li	a0,1
    80003d4c:	9782                	jalr	a5
    80003d4e:	892a                	mv	s2,a0
    80003d50:	bf75                	j	80003d0c <fileread+0x60>
    panic("fileread");
    80003d52:	00005517          	auipc	a0,0x5
    80003d56:	91650513          	addi	a0,a0,-1770 # 80008668 <syscalls+0x258>
    80003d5a:	00002097          	auipc	ra,0x2
    80003d5e:	02e080e7          	jalr	46(ra) # 80005d88 <panic>
    return -1;
    80003d62:	597d                	li	s2,-1
    80003d64:	b765                	j	80003d0c <fileread+0x60>
      return -1;
    80003d66:	597d                	li	s2,-1
    80003d68:	b755                	j	80003d0c <fileread+0x60>
    80003d6a:	597d                	li	s2,-1
    80003d6c:	b745                	j	80003d0c <fileread+0x60>

0000000080003d6e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d6e:	715d                	addi	sp,sp,-80
    80003d70:	e486                	sd	ra,72(sp)
    80003d72:	e0a2                	sd	s0,64(sp)
    80003d74:	fc26                	sd	s1,56(sp)
    80003d76:	f84a                	sd	s2,48(sp)
    80003d78:	f44e                	sd	s3,40(sp)
    80003d7a:	f052                	sd	s4,32(sp)
    80003d7c:	ec56                	sd	s5,24(sp)
    80003d7e:	e85a                	sd	s6,16(sp)
    80003d80:	e45e                	sd	s7,8(sp)
    80003d82:	e062                	sd	s8,0(sp)
    80003d84:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d86:	00954783          	lbu	a5,9(a0)
    80003d8a:	10078663          	beqz	a5,80003e96 <filewrite+0x128>
    80003d8e:	892a                	mv	s2,a0
    80003d90:	8aae                	mv	s5,a1
    80003d92:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d94:	411c                	lw	a5,0(a0)
    80003d96:	4705                	li	a4,1
    80003d98:	02e78263          	beq	a5,a4,80003dbc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d9c:	470d                	li	a4,3
    80003d9e:	02e78663          	beq	a5,a4,80003dca <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003da2:	4709                	li	a4,2
    80003da4:	0ee79163          	bne	a5,a4,80003e86 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003da8:	0ac05d63          	blez	a2,80003e62 <filewrite+0xf4>
    int i = 0;
    80003dac:	4981                	li	s3,0
    80003dae:	6b05                	lui	s6,0x1
    80003db0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003db4:	6b85                	lui	s7,0x1
    80003db6:	c00b8b9b          	addiw	s7,s7,-1024
    80003dba:	a861                	j	80003e52 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003dbc:	6908                	ld	a0,16(a0)
    80003dbe:	00000097          	auipc	ra,0x0
    80003dc2:	22e080e7          	jalr	558(ra) # 80003fec <pipewrite>
    80003dc6:	8a2a                	mv	s4,a0
    80003dc8:	a045                	j	80003e68 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dca:	02451783          	lh	a5,36(a0)
    80003dce:	03079693          	slli	a3,a5,0x30
    80003dd2:	92c1                	srli	a3,a3,0x30
    80003dd4:	4725                	li	a4,9
    80003dd6:	0cd76263          	bltu	a4,a3,80003e9a <filewrite+0x12c>
    80003dda:	0792                	slli	a5,a5,0x4
    80003ddc:	00235717          	auipc	a4,0x235
    80003de0:	30470713          	addi	a4,a4,772 # 802390e0 <devsw>
    80003de4:	97ba                	add	a5,a5,a4
    80003de6:	679c                	ld	a5,8(a5)
    80003de8:	cbdd                	beqz	a5,80003e9e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003dea:	4505                	li	a0,1
    80003dec:	9782                	jalr	a5
    80003dee:	8a2a                	mv	s4,a0
    80003df0:	a8a5                	j	80003e68 <filewrite+0xfa>
    80003df2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003df6:	00000097          	auipc	ra,0x0
    80003dfa:	8b0080e7          	jalr	-1872(ra) # 800036a6 <begin_op>
      ilock(f->ip);
    80003dfe:	01893503          	ld	a0,24(s2)
    80003e02:	fffff097          	auipc	ra,0xfffff
    80003e06:	ed2080e7          	jalr	-302(ra) # 80002cd4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e0a:	8762                	mv	a4,s8
    80003e0c:	02092683          	lw	a3,32(s2)
    80003e10:	01598633          	add	a2,s3,s5
    80003e14:	4585                	li	a1,1
    80003e16:	01893503          	ld	a0,24(s2)
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	266080e7          	jalr	614(ra) # 80003080 <writei>
    80003e22:	84aa                	mv	s1,a0
    80003e24:	00a05763          	blez	a0,80003e32 <filewrite+0xc4>
        f->off += r;
    80003e28:	02092783          	lw	a5,32(s2)
    80003e2c:	9fa9                	addw	a5,a5,a0
    80003e2e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e32:	01893503          	ld	a0,24(s2)
    80003e36:	fffff097          	auipc	ra,0xfffff
    80003e3a:	f60080e7          	jalr	-160(ra) # 80002d96 <iunlock>
      end_op();
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	8e8080e7          	jalr	-1816(ra) # 80003726 <end_op>

      if(r != n1){
    80003e46:	009c1f63          	bne	s8,s1,80003e64 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e4a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e4e:	0149db63          	bge	s3,s4,80003e64 <filewrite+0xf6>
      int n1 = n - i;
    80003e52:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e56:	84be                	mv	s1,a5
    80003e58:	2781                	sext.w	a5,a5
    80003e5a:	f8fb5ce3          	bge	s6,a5,80003df2 <filewrite+0x84>
    80003e5e:	84de                	mv	s1,s7
    80003e60:	bf49                	j	80003df2 <filewrite+0x84>
    int i = 0;
    80003e62:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e64:	013a1f63          	bne	s4,s3,80003e82 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e68:	8552                	mv	a0,s4
    80003e6a:	60a6                	ld	ra,72(sp)
    80003e6c:	6406                	ld	s0,64(sp)
    80003e6e:	74e2                	ld	s1,56(sp)
    80003e70:	7942                	ld	s2,48(sp)
    80003e72:	79a2                	ld	s3,40(sp)
    80003e74:	7a02                	ld	s4,32(sp)
    80003e76:	6ae2                	ld	s5,24(sp)
    80003e78:	6b42                	ld	s6,16(sp)
    80003e7a:	6ba2                	ld	s7,8(sp)
    80003e7c:	6c02                	ld	s8,0(sp)
    80003e7e:	6161                	addi	sp,sp,80
    80003e80:	8082                	ret
    ret = (i == n ? n : -1);
    80003e82:	5a7d                	li	s4,-1
    80003e84:	b7d5                	j	80003e68 <filewrite+0xfa>
    panic("filewrite");
    80003e86:	00004517          	auipc	a0,0x4
    80003e8a:	7f250513          	addi	a0,a0,2034 # 80008678 <syscalls+0x268>
    80003e8e:	00002097          	auipc	ra,0x2
    80003e92:	efa080e7          	jalr	-262(ra) # 80005d88 <panic>
    return -1;
    80003e96:	5a7d                	li	s4,-1
    80003e98:	bfc1                	j	80003e68 <filewrite+0xfa>
      return -1;
    80003e9a:	5a7d                	li	s4,-1
    80003e9c:	b7f1                	j	80003e68 <filewrite+0xfa>
    80003e9e:	5a7d                	li	s4,-1
    80003ea0:	b7e1                	j	80003e68 <filewrite+0xfa>

0000000080003ea2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ea2:	7179                	addi	sp,sp,-48
    80003ea4:	f406                	sd	ra,40(sp)
    80003ea6:	f022                	sd	s0,32(sp)
    80003ea8:	ec26                	sd	s1,24(sp)
    80003eaa:	e84a                	sd	s2,16(sp)
    80003eac:	e44e                	sd	s3,8(sp)
    80003eae:	e052                	sd	s4,0(sp)
    80003eb0:	1800                	addi	s0,sp,48
    80003eb2:	84aa                	mv	s1,a0
    80003eb4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003eb6:	0005b023          	sd	zero,0(a1)
    80003eba:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	bf8080e7          	jalr	-1032(ra) # 80003ab6 <filealloc>
    80003ec6:	e088                	sd	a0,0(s1)
    80003ec8:	c551                	beqz	a0,80003f54 <pipealloc+0xb2>
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	bec080e7          	jalr	-1044(ra) # 80003ab6 <filealloc>
    80003ed2:	00aa3023          	sd	a0,0(s4)
    80003ed6:	c92d                	beqz	a0,80003f48 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ed8:	ffffc097          	auipc	ra,0xffffc
    80003edc:	21e080e7          	jalr	542(ra) # 800000f6 <kalloc>
    80003ee0:	892a                	mv	s2,a0
    80003ee2:	c125                	beqz	a0,80003f42 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ee4:	4985                	li	s3,1
    80003ee6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003eea:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003eee:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ef2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ef6:	00004597          	auipc	a1,0x4
    80003efa:	79258593          	addi	a1,a1,1938 # 80008688 <syscalls+0x278>
    80003efe:	00002097          	auipc	ra,0x2
    80003f02:	344080e7          	jalr	836(ra) # 80006242 <initlock>
  (*f0)->type = FD_PIPE;
    80003f06:	609c                	ld	a5,0(s1)
    80003f08:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f0c:	609c                	ld	a5,0(s1)
    80003f0e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f12:	609c                	ld	a5,0(s1)
    80003f14:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f18:	609c                	ld	a5,0(s1)
    80003f1a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f1e:	000a3783          	ld	a5,0(s4)
    80003f22:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f26:	000a3783          	ld	a5,0(s4)
    80003f2a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f2e:	000a3783          	ld	a5,0(s4)
    80003f32:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f36:	000a3783          	ld	a5,0(s4)
    80003f3a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f3e:	4501                	li	a0,0
    80003f40:	a025                	j	80003f68 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f42:	6088                	ld	a0,0(s1)
    80003f44:	e501                	bnez	a0,80003f4c <pipealloc+0xaa>
    80003f46:	a039                	j	80003f54 <pipealloc+0xb2>
    80003f48:	6088                	ld	a0,0(s1)
    80003f4a:	c51d                	beqz	a0,80003f78 <pipealloc+0xd6>
    fileclose(*f0);
    80003f4c:	00000097          	auipc	ra,0x0
    80003f50:	c26080e7          	jalr	-986(ra) # 80003b72 <fileclose>
  if(*f1)
    80003f54:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f58:	557d                	li	a0,-1
  if(*f1)
    80003f5a:	c799                	beqz	a5,80003f68 <pipealloc+0xc6>
    fileclose(*f1);
    80003f5c:	853e                	mv	a0,a5
    80003f5e:	00000097          	auipc	ra,0x0
    80003f62:	c14080e7          	jalr	-1004(ra) # 80003b72 <fileclose>
  return -1;
    80003f66:	557d                	li	a0,-1
}
    80003f68:	70a2                	ld	ra,40(sp)
    80003f6a:	7402                	ld	s0,32(sp)
    80003f6c:	64e2                	ld	s1,24(sp)
    80003f6e:	6942                	ld	s2,16(sp)
    80003f70:	69a2                	ld	s3,8(sp)
    80003f72:	6a02                	ld	s4,0(sp)
    80003f74:	6145                	addi	sp,sp,48
    80003f76:	8082                	ret
  return -1;
    80003f78:	557d                	li	a0,-1
    80003f7a:	b7fd                	j	80003f68 <pipealloc+0xc6>

0000000080003f7c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f7c:	1101                	addi	sp,sp,-32
    80003f7e:	ec06                	sd	ra,24(sp)
    80003f80:	e822                	sd	s0,16(sp)
    80003f82:	e426                	sd	s1,8(sp)
    80003f84:	e04a                	sd	s2,0(sp)
    80003f86:	1000                	addi	s0,sp,32
    80003f88:	84aa                	mv	s1,a0
    80003f8a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f8c:	00002097          	auipc	ra,0x2
    80003f90:	346080e7          	jalr	838(ra) # 800062d2 <acquire>
  if(writable){
    80003f94:	02090d63          	beqz	s2,80003fce <pipeclose+0x52>
    pi->writeopen = 0;
    80003f98:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f9c:	21848513          	addi	a0,s1,536
    80003fa0:	ffffe097          	auipc	ra,0xffffe
    80003fa4:	906080e7          	jalr	-1786(ra) # 800018a6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fa8:	2204b783          	ld	a5,544(s1)
    80003fac:	eb95                	bnez	a5,80003fe0 <pipeclose+0x64>
    release(&pi->lock);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00002097          	auipc	ra,0x2
    80003fb4:	3d6080e7          	jalr	982(ra) # 80006386 <release>
    kfree((char*)pi);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	ffffc097          	auipc	ra,0xffffc
    80003fbe:	062080e7          	jalr	98(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fc2:	60e2                	ld	ra,24(sp)
    80003fc4:	6442                	ld	s0,16(sp)
    80003fc6:	64a2                	ld	s1,8(sp)
    80003fc8:	6902                	ld	s2,0(sp)
    80003fca:	6105                	addi	sp,sp,32
    80003fcc:	8082                	ret
    pi->readopen = 0;
    80003fce:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fd2:	21c48513          	addi	a0,s1,540
    80003fd6:	ffffe097          	auipc	ra,0xffffe
    80003fda:	8d0080e7          	jalr	-1840(ra) # 800018a6 <wakeup>
    80003fde:	b7e9                	j	80003fa8 <pipeclose+0x2c>
    release(&pi->lock);
    80003fe0:	8526                	mv	a0,s1
    80003fe2:	00002097          	auipc	ra,0x2
    80003fe6:	3a4080e7          	jalr	932(ra) # 80006386 <release>
}
    80003fea:	bfe1                	j	80003fc2 <pipeclose+0x46>

0000000080003fec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fec:	7159                	addi	sp,sp,-112
    80003fee:	f486                	sd	ra,104(sp)
    80003ff0:	f0a2                	sd	s0,96(sp)
    80003ff2:	eca6                	sd	s1,88(sp)
    80003ff4:	e8ca                	sd	s2,80(sp)
    80003ff6:	e4ce                	sd	s3,72(sp)
    80003ff8:	e0d2                	sd	s4,64(sp)
    80003ffa:	fc56                	sd	s5,56(sp)
    80003ffc:	f85a                	sd	s6,48(sp)
    80003ffe:	f45e                	sd	s7,40(sp)
    80004000:	f062                	sd	s8,32(sp)
    80004002:	ec66                	sd	s9,24(sp)
    80004004:	1880                	addi	s0,sp,112
    80004006:	84aa                	mv	s1,a0
    80004008:	8aae                	mv	s5,a1
    8000400a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	052080e7          	jalr	82(ra) # 8000105e <myproc>
    80004014:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004016:	8526                	mv	a0,s1
    80004018:	00002097          	auipc	ra,0x2
    8000401c:	2ba080e7          	jalr	698(ra) # 800062d2 <acquire>
  while(i < n){
    80004020:	0d405163          	blez	s4,800040e2 <pipewrite+0xf6>
    80004024:	8ba6                	mv	s7,s1
  int i = 0;
    80004026:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004028:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000402a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000402e:	21c48c13          	addi	s8,s1,540
    80004032:	a08d                	j	80004094 <pipewrite+0xa8>
      release(&pi->lock);
    80004034:	8526                	mv	a0,s1
    80004036:	00002097          	auipc	ra,0x2
    8000403a:	350080e7          	jalr	848(ra) # 80006386 <release>
      return -1;
    8000403e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004040:	854a                	mv	a0,s2
    80004042:	70a6                	ld	ra,104(sp)
    80004044:	7406                	ld	s0,96(sp)
    80004046:	64e6                	ld	s1,88(sp)
    80004048:	6946                	ld	s2,80(sp)
    8000404a:	69a6                	ld	s3,72(sp)
    8000404c:	6a06                	ld	s4,64(sp)
    8000404e:	7ae2                	ld	s5,56(sp)
    80004050:	7b42                	ld	s6,48(sp)
    80004052:	7ba2                	ld	s7,40(sp)
    80004054:	7c02                	ld	s8,32(sp)
    80004056:	6ce2                	ld	s9,24(sp)
    80004058:	6165                	addi	sp,sp,112
    8000405a:	8082                	ret
      wakeup(&pi->nread);
    8000405c:	8566                	mv	a0,s9
    8000405e:	ffffe097          	auipc	ra,0xffffe
    80004062:	848080e7          	jalr	-1976(ra) # 800018a6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004066:	85de                	mv	a1,s7
    80004068:	8562                	mv	a0,s8
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	6b0080e7          	jalr	1712(ra) # 8000171a <sleep>
    80004072:	a839                	j	80004090 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004074:	21c4a783          	lw	a5,540(s1)
    80004078:	0017871b          	addiw	a4,a5,1
    8000407c:	20e4ae23          	sw	a4,540(s1)
    80004080:	1ff7f793          	andi	a5,a5,511
    80004084:	97a6                	add	a5,a5,s1
    80004086:	f9f44703          	lbu	a4,-97(s0)
    8000408a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000408e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004090:	03495d63          	bge	s2,s4,800040ca <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004094:	2204a783          	lw	a5,544(s1)
    80004098:	dfd1                	beqz	a5,80004034 <pipewrite+0x48>
    8000409a:	0289a783          	lw	a5,40(s3)
    8000409e:	fbd9                	bnez	a5,80004034 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040a0:	2184a783          	lw	a5,536(s1)
    800040a4:	21c4a703          	lw	a4,540(s1)
    800040a8:	2007879b          	addiw	a5,a5,512
    800040ac:	faf708e3          	beq	a4,a5,8000405c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040b0:	4685                	li	a3,1
    800040b2:	01590633          	add	a2,s2,s5
    800040b6:	f9f40593          	addi	a1,s0,-97
    800040ba:	0509b503          	ld	a0,80(s3)
    800040be:	ffffd097          	auipc	ra,0xffffd
    800040c2:	b62080e7          	jalr	-1182(ra) # 80000c20 <copyin>
    800040c6:	fb6517e3          	bne	a0,s6,80004074 <pipewrite+0x88>
  wakeup(&pi->nread);
    800040ca:	21848513          	addi	a0,s1,536
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	7d8080e7          	jalr	2008(ra) # 800018a6 <wakeup>
  release(&pi->lock);
    800040d6:	8526                	mv	a0,s1
    800040d8:	00002097          	auipc	ra,0x2
    800040dc:	2ae080e7          	jalr	686(ra) # 80006386 <release>
  return i;
    800040e0:	b785                	j	80004040 <pipewrite+0x54>
  int i = 0;
    800040e2:	4901                	li	s2,0
    800040e4:	b7dd                	j	800040ca <pipewrite+0xde>

00000000800040e6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040e6:	715d                	addi	sp,sp,-80
    800040e8:	e486                	sd	ra,72(sp)
    800040ea:	e0a2                	sd	s0,64(sp)
    800040ec:	fc26                	sd	s1,56(sp)
    800040ee:	f84a                	sd	s2,48(sp)
    800040f0:	f44e                	sd	s3,40(sp)
    800040f2:	f052                	sd	s4,32(sp)
    800040f4:	ec56                	sd	s5,24(sp)
    800040f6:	e85a                	sd	s6,16(sp)
    800040f8:	0880                	addi	s0,sp,80
    800040fa:	84aa                	mv	s1,a0
    800040fc:	892e                	mv	s2,a1
    800040fe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004100:	ffffd097          	auipc	ra,0xffffd
    80004104:	f5e080e7          	jalr	-162(ra) # 8000105e <myproc>
    80004108:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000410a:	8b26                	mv	s6,s1
    8000410c:	8526                	mv	a0,s1
    8000410e:	00002097          	auipc	ra,0x2
    80004112:	1c4080e7          	jalr	452(ra) # 800062d2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004116:	2184a703          	lw	a4,536(s1)
    8000411a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000411e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004122:	02f71463          	bne	a4,a5,8000414a <piperead+0x64>
    80004126:	2244a783          	lw	a5,548(s1)
    8000412a:	c385                	beqz	a5,8000414a <piperead+0x64>
    if(pr->killed){
    8000412c:	028a2783          	lw	a5,40(s4)
    80004130:	ebc1                	bnez	a5,800041c0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004132:	85da                	mv	a1,s6
    80004134:	854e                	mv	a0,s3
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	5e4080e7          	jalr	1508(ra) # 8000171a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000413e:	2184a703          	lw	a4,536(s1)
    80004142:	21c4a783          	lw	a5,540(s1)
    80004146:	fef700e3          	beq	a4,a5,80004126 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000414a:	09505263          	blez	s5,800041ce <piperead+0xe8>
    8000414e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004150:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004152:	2184a783          	lw	a5,536(s1)
    80004156:	21c4a703          	lw	a4,540(s1)
    8000415a:	02f70d63          	beq	a4,a5,80004194 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000415e:	0017871b          	addiw	a4,a5,1
    80004162:	20e4ac23          	sw	a4,536(s1)
    80004166:	1ff7f793          	andi	a5,a5,511
    8000416a:	97a6                	add	a5,a5,s1
    8000416c:	0187c783          	lbu	a5,24(a5)
    80004170:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004174:	4685                	li	a3,1
    80004176:	fbf40613          	addi	a2,s0,-65
    8000417a:	85ca                	mv	a1,s2
    8000417c:	050a3503          	ld	a0,80(s4)
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	cbe080e7          	jalr	-834(ra) # 80000e3e <copyout>
    80004188:	01650663          	beq	a0,s6,80004194 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000418c:	2985                	addiw	s3,s3,1
    8000418e:	0905                	addi	s2,s2,1
    80004190:	fd3a91e3          	bne	s5,s3,80004152 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004194:	21c48513          	addi	a0,s1,540
    80004198:	ffffd097          	auipc	ra,0xffffd
    8000419c:	70e080e7          	jalr	1806(ra) # 800018a6 <wakeup>
  release(&pi->lock);
    800041a0:	8526                	mv	a0,s1
    800041a2:	00002097          	auipc	ra,0x2
    800041a6:	1e4080e7          	jalr	484(ra) # 80006386 <release>
  return i;
}
    800041aa:	854e                	mv	a0,s3
    800041ac:	60a6                	ld	ra,72(sp)
    800041ae:	6406                	ld	s0,64(sp)
    800041b0:	74e2                	ld	s1,56(sp)
    800041b2:	7942                	ld	s2,48(sp)
    800041b4:	79a2                	ld	s3,40(sp)
    800041b6:	7a02                	ld	s4,32(sp)
    800041b8:	6ae2                	ld	s5,24(sp)
    800041ba:	6b42                	ld	s6,16(sp)
    800041bc:	6161                	addi	sp,sp,80
    800041be:	8082                	ret
      release(&pi->lock);
    800041c0:	8526                	mv	a0,s1
    800041c2:	00002097          	auipc	ra,0x2
    800041c6:	1c4080e7          	jalr	452(ra) # 80006386 <release>
      return -1;
    800041ca:	59fd                	li	s3,-1
    800041cc:	bff9                	j	800041aa <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ce:	4981                	li	s3,0
    800041d0:	b7d1                	j	80004194 <piperead+0xae>

00000000800041d2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041d2:	df010113          	addi	sp,sp,-528
    800041d6:	20113423          	sd	ra,520(sp)
    800041da:	20813023          	sd	s0,512(sp)
    800041de:	ffa6                	sd	s1,504(sp)
    800041e0:	fbca                	sd	s2,496(sp)
    800041e2:	f7ce                	sd	s3,488(sp)
    800041e4:	f3d2                	sd	s4,480(sp)
    800041e6:	efd6                	sd	s5,472(sp)
    800041e8:	ebda                	sd	s6,464(sp)
    800041ea:	e7de                	sd	s7,456(sp)
    800041ec:	e3e2                	sd	s8,448(sp)
    800041ee:	ff66                	sd	s9,440(sp)
    800041f0:	fb6a                	sd	s10,432(sp)
    800041f2:	f76e                	sd	s11,424(sp)
    800041f4:	0c00                	addi	s0,sp,528
    800041f6:	84aa                	mv	s1,a0
    800041f8:	dea43c23          	sd	a0,-520(s0)
    800041fc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	e5e080e7          	jalr	-418(ra) # 8000105e <myproc>
    80004208:	892a                	mv	s2,a0

  begin_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	49c080e7          	jalr	1180(ra) # 800036a6 <begin_op>

  if((ip = namei(path)) == 0){
    80004212:	8526                	mv	a0,s1
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	276080e7          	jalr	630(ra) # 8000348a <namei>
    8000421c:	c92d                	beqz	a0,8000428e <exec+0xbc>
    8000421e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	ab4080e7          	jalr	-1356(ra) # 80002cd4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004228:	04000713          	li	a4,64
    8000422c:	4681                	li	a3,0
    8000422e:	e5040613          	addi	a2,s0,-432
    80004232:	4581                	li	a1,0
    80004234:	8526                	mv	a0,s1
    80004236:	fffff097          	auipc	ra,0xfffff
    8000423a:	d52080e7          	jalr	-686(ra) # 80002f88 <readi>
    8000423e:	04000793          	li	a5,64
    80004242:	00f51a63          	bne	a0,a5,80004256 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004246:	e5042703          	lw	a4,-432(s0)
    8000424a:	464c47b7          	lui	a5,0x464c4
    8000424e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004252:	04f70463          	beq	a4,a5,8000429a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004256:	8526                	mv	a0,s1
    80004258:	fffff097          	auipc	ra,0xfffff
    8000425c:	cde080e7          	jalr	-802(ra) # 80002f36 <iunlockput>
    end_op();
    80004260:	fffff097          	auipc	ra,0xfffff
    80004264:	4c6080e7          	jalr	1222(ra) # 80003726 <end_op>
  }
  return -1;
    80004268:	557d                	li	a0,-1
}
    8000426a:	20813083          	ld	ra,520(sp)
    8000426e:	20013403          	ld	s0,512(sp)
    80004272:	74fe                	ld	s1,504(sp)
    80004274:	795e                	ld	s2,496(sp)
    80004276:	79be                	ld	s3,488(sp)
    80004278:	7a1e                	ld	s4,480(sp)
    8000427a:	6afe                	ld	s5,472(sp)
    8000427c:	6b5e                	ld	s6,464(sp)
    8000427e:	6bbe                	ld	s7,456(sp)
    80004280:	6c1e                	ld	s8,448(sp)
    80004282:	7cfa                	ld	s9,440(sp)
    80004284:	7d5a                	ld	s10,432(sp)
    80004286:	7dba                	ld	s11,424(sp)
    80004288:	21010113          	addi	sp,sp,528
    8000428c:	8082                	ret
    end_op();
    8000428e:	fffff097          	auipc	ra,0xfffff
    80004292:	498080e7          	jalr	1176(ra) # 80003726 <end_op>
    return -1;
    80004296:	557d                	li	a0,-1
    80004298:	bfc9                	j	8000426a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000429a:	854a                	mv	a0,s2
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	e86080e7          	jalr	-378(ra) # 80001122 <proc_pagetable>
    800042a4:	8baa                	mv	s7,a0
    800042a6:	d945                	beqz	a0,80004256 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042a8:	e7042983          	lw	s3,-400(s0)
    800042ac:	e8845783          	lhu	a5,-376(s0)
    800042b0:	c7ad                	beqz	a5,8000431a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042b2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042b6:	6c85                	lui	s9,0x1
    800042b8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042bc:	def43823          	sd	a5,-528(s0)
    800042c0:	a42d                	j	800044ea <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042c2:	00004517          	auipc	a0,0x4
    800042c6:	3ce50513          	addi	a0,a0,974 # 80008690 <syscalls+0x280>
    800042ca:	00002097          	auipc	ra,0x2
    800042ce:	abe080e7          	jalr	-1346(ra) # 80005d88 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042d2:	8756                	mv	a4,s5
    800042d4:	012d86bb          	addw	a3,s11,s2
    800042d8:	4581                	li	a1,0
    800042da:	8526                	mv	a0,s1
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	cac080e7          	jalr	-852(ra) # 80002f88 <readi>
    800042e4:	2501                	sext.w	a0,a0
    800042e6:	1aaa9963          	bne	s5,a0,80004498 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800042ea:	6785                	lui	a5,0x1
    800042ec:	0127893b          	addw	s2,a5,s2
    800042f0:	77fd                	lui	a5,0xfffff
    800042f2:	01478a3b          	addw	s4,a5,s4
    800042f6:	1f897163          	bgeu	s2,s8,800044d8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800042fa:	02091593          	slli	a1,s2,0x20
    800042fe:	9181                	srli	a1,a1,0x20
    80004300:	95ea                	add	a1,a1,s10
    80004302:	855e                	mv	a0,s7
    80004304:	ffffc097          	auipc	ra,0xffffc
    80004308:	32a080e7          	jalr	810(ra) # 8000062e <walkaddr>
    8000430c:	862a                	mv	a2,a0
    if(pa == 0)
    8000430e:	d955                	beqz	a0,800042c2 <exec+0xf0>
      n = PGSIZE;
    80004310:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004312:	fd9a70e3          	bgeu	s4,s9,800042d2 <exec+0x100>
      n = sz - i;
    80004316:	8ad2                	mv	s5,s4
    80004318:	bf6d                	j	800042d2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000431a:	4901                	li	s2,0
  iunlockput(ip);
    8000431c:	8526                	mv	a0,s1
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	c18080e7          	jalr	-1000(ra) # 80002f36 <iunlockput>
  end_op();
    80004326:	fffff097          	auipc	ra,0xfffff
    8000432a:	400080e7          	jalr	1024(ra) # 80003726 <end_op>
  p = myproc();
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	d30080e7          	jalr	-720(ra) # 8000105e <myproc>
    80004336:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004338:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000433c:	6785                	lui	a5,0x1
    8000433e:	17fd                	addi	a5,a5,-1
    80004340:	993e                	add	s2,s2,a5
    80004342:	757d                	lui	a0,0xfffff
    80004344:	00a977b3          	and	a5,s2,a0
    80004348:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000434c:	6609                	lui	a2,0x2
    8000434e:	963e                	add	a2,a2,a5
    80004350:	85be                	mv	a1,a5
    80004352:	855e                	mv	a0,s7
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	68e080e7          	jalr	1678(ra) # 800009e2 <uvmalloc>
    8000435c:	8b2a                	mv	s6,a0
  ip = 0;
    8000435e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004360:	12050c63          	beqz	a0,80004498 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004364:	75f9                	lui	a1,0xffffe
    80004366:	95aa                	add	a1,a1,a0
    80004368:	855e                	mv	a0,s7
    8000436a:	ffffd097          	auipc	ra,0xffffd
    8000436e:	884080e7          	jalr	-1916(ra) # 80000bee <uvmclear>
  stackbase = sp - PGSIZE;
    80004372:	7c7d                	lui	s8,0xfffff
    80004374:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004376:	e0043783          	ld	a5,-512(s0)
    8000437a:	6388                	ld	a0,0(a5)
    8000437c:	c535                	beqz	a0,800043e8 <exec+0x216>
    8000437e:	e9040993          	addi	s3,s0,-368
    80004382:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004386:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004388:	ffffc097          	auipc	ra,0xffffc
    8000438c:	09c080e7          	jalr	156(ra) # 80000424 <strlen>
    80004390:	2505                	addiw	a0,a0,1
    80004392:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004396:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000439a:	13896363          	bltu	s2,s8,800044c0 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000439e:	e0043d83          	ld	s11,-512(s0)
    800043a2:	000dba03          	ld	s4,0(s11)
    800043a6:	8552                	mv	a0,s4
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	07c080e7          	jalr	124(ra) # 80000424 <strlen>
    800043b0:	0015069b          	addiw	a3,a0,1
    800043b4:	8652                	mv	a2,s4
    800043b6:	85ca                	mv	a1,s2
    800043b8:	855e                	mv	a0,s7
    800043ba:	ffffd097          	auipc	ra,0xffffd
    800043be:	a84080e7          	jalr	-1404(ra) # 80000e3e <copyout>
    800043c2:	10054363          	bltz	a0,800044c8 <exec+0x2f6>
    ustack[argc] = sp;
    800043c6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ca:	0485                	addi	s1,s1,1
    800043cc:	008d8793          	addi	a5,s11,8
    800043d0:	e0f43023          	sd	a5,-512(s0)
    800043d4:	008db503          	ld	a0,8(s11)
    800043d8:	c911                	beqz	a0,800043ec <exec+0x21a>
    if(argc >= MAXARG)
    800043da:	09a1                	addi	s3,s3,8
    800043dc:	fb3c96e3          	bne	s9,s3,80004388 <exec+0x1b6>
  sz = sz1;
    800043e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043e4:	4481                	li	s1,0
    800043e6:	a84d                	j	80004498 <exec+0x2c6>
  sp = sz;
    800043e8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ea:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ec:	00349793          	slli	a5,s1,0x3
    800043f0:	f9040713          	addi	a4,s0,-112
    800043f4:	97ba                	add	a5,a5,a4
    800043f6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043fa:	00148693          	addi	a3,s1,1
    800043fe:	068e                	slli	a3,a3,0x3
    80004400:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004404:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004408:	01897663          	bgeu	s2,s8,80004414 <exec+0x242>
  sz = sz1;
    8000440c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004410:	4481                	li	s1,0
    80004412:	a059                	j	80004498 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004414:	e9040613          	addi	a2,s0,-368
    80004418:	85ca                	mv	a1,s2
    8000441a:	855e                	mv	a0,s7
    8000441c:	ffffd097          	auipc	ra,0xffffd
    80004420:	a22080e7          	jalr	-1502(ra) # 80000e3e <copyout>
    80004424:	0a054663          	bltz	a0,800044d0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004428:	058ab783          	ld	a5,88(s5)
    8000442c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004430:	df843783          	ld	a5,-520(s0)
    80004434:	0007c703          	lbu	a4,0(a5)
    80004438:	cf11                	beqz	a4,80004454 <exec+0x282>
    8000443a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000443c:	02f00693          	li	a3,47
    80004440:	a039                	j	8000444e <exec+0x27c>
      last = s+1;
    80004442:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004446:	0785                	addi	a5,a5,1
    80004448:	fff7c703          	lbu	a4,-1(a5)
    8000444c:	c701                	beqz	a4,80004454 <exec+0x282>
    if(*s == '/')
    8000444e:	fed71ce3          	bne	a4,a3,80004446 <exec+0x274>
    80004452:	bfc5                	j	80004442 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004454:	4641                	li	a2,16
    80004456:	df843583          	ld	a1,-520(s0)
    8000445a:	158a8513          	addi	a0,s5,344
    8000445e:	ffffc097          	auipc	ra,0xffffc
    80004462:	f94080e7          	jalr	-108(ra) # 800003f2 <safestrcpy>
  oldpagetable = p->pagetable;
    80004466:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000446a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000446e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004472:	058ab783          	ld	a5,88(s5)
    80004476:	e6843703          	ld	a4,-408(s0)
    8000447a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000447c:	058ab783          	ld	a5,88(s5)
    80004480:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004484:	85ea                	mv	a1,s10
    80004486:	ffffd097          	auipc	ra,0xffffd
    8000448a:	d38080e7          	jalr	-712(ra) # 800011be <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000448e:	0004851b          	sext.w	a0,s1
    80004492:	bbe1                	j	8000426a <exec+0x98>
    80004494:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004498:	e0843583          	ld	a1,-504(s0)
    8000449c:	855e                	mv	a0,s7
    8000449e:	ffffd097          	auipc	ra,0xffffd
    800044a2:	d20080e7          	jalr	-736(ra) # 800011be <proc_freepagetable>
  if(ip){
    800044a6:	da0498e3          	bnez	s1,80004256 <exec+0x84>
  return -1;
    800044aa:	557d                	li	a0,-1
    800044ac:	bb7d                	j	8000426a <exec+0x98>
    800044ae:	e1243423          	sd	s2,-504(s0)
    800044b2:	b7dd                	j	80004498 <exec+0x2c6>
    800044b4:	e1243423          	sd	s2,-504(s0)
    800044b8:	b7c5                	j	80004498 <exec+0x2c6>
    800044ba:	e1243423          	sd	s2,-504(s0)
    800044be:	bfe9                	j	80004498 <exec+0x2c6>
  sz = sz1;
    800044c0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044c4:	4481                	li	s1,0
    800044c6:	bfc9                	j	80004498 <exec+0x2c6>
  sz = sz1;
    800044c8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044cc:	4481                	li	s1,0
    800044ce:	b7e9                	j	80004498 <exec+0x2c6>
  sz = sz1;
    800044d0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044d4:	4481                	li	s1,0
    800044d6:	b7c9                	j	80004498 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044d8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044dc:	2b05                	addiw	s6,s6,1
    800044de:	0389899b          	addiw	s3,s3,56
    800044e2:	e8845783          	lhu	a5,-376(s0)
    800044e6:	e2fb5be3          	bge	s6,a5,8000431c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044ea:	2981                	sext.w	s3,s3
    800044ec:	03800713          	li	a4,56
    800044f0:	86ce                	mv	a3,s3
    800044f2:	e1840613          	addi	a2,s0,-488
    800044f6:	4581                	li	a1,0
    800044f8:	8526                	mv	a0,s1
    800044fa:	fffff097          	auipc	ra,0xfffff
    800044fe:	a8e080e7          	jalr	-1394(ra) # 80002f88 <readi>
    80004502:	03800793          	li	a5,56
    80004506:	f8f517e3          	bne	a0,a5,80004494 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000450a:	e1842783          	lw	a5,-488(s0)
    8000450e:	4705                	li	a4,1
    80004510:	fce796e3          	bne	a5,a4,800044dc <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004514:	e4043603          	ld	a2,-448(s0)
    80004518:	e3843783          	ld	a5,-456(s0)
    8000451c:	f8f669e3          	bltu	a2,a5,800044ae <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004520:	e2843783          	ld	a5,-472(s0)
    80004524:	963e                	add	a2,a2,a5
    80004526:	f8f667e3          	bltu	a2,a5,800044b4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000452a:	85ca                	mv	a1,s2
    8000452c:	855e                	mv	a0,s7
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	4b4080e7          	jalr	1204(ra) # 800009e2 <uvmalloc>
    80004536:	e0a43423          	sd	a0,-504(s0)
    8000453a:	d141                	beqz	a0,800044ba <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000453c:	e2843d03          	ld	s10,-472(s0)
    80004540:	df043783          	ld	a5,-528(s0)
    80004544:	00fd77b3          	and	a5,s10,a5
    80004548:	fba1                	bnez	a5,80004498 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000454a:	e2042d83          	lw	s11,-480(s0)
    8000454e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004552:	f80c03e3          	beqz	s8,800044d8 <exec+0x306>
    80004556:	8a62                	mv	s4,s8
    80004558:	4901                	li	s2,0
    8000455a:	b345                	j	800042fa <exec+0x128>

000000008000455c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000455c:	7179                	addi	sp,sp,-48
    8000455e:	f406                	sd	ra,40(sp)
    80004560:	f022                	sd	s0,32(sp)
    80004562:	ec26                	sd	s1,24(sp)
    80004564:	e84a                	sd	s2,16(sp)
    80004566:	1800                	addi	s0,sp,48
    80004568:	892e                	mv	s2,a1
    8000456a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000456c:	fdc40593          	addi	a1,s0,-36
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	bf2080e7          	jalr	-1038(ra) # 80002162 <argint>
    80004578:	04054063          	bltz	a0,800045b8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000457c:	fdc42703          	lw	a4,-36(s0)
    80004580:	47bd                	li	a5,15
    80004582:	02e7ed63          	bltu	a5,a4,800045bc <argfd+0x60>
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	ad8080e7          	jalr	-1320(ra) # 8000105e <myproc>
    8000458e:	fdc42703          	lw	a4,-36(s0)
    80004592:	01a70793          	addi	a5,a4,26
    80004596:	078e                	slli	a5,a5,0x3
    80004598:	953e                	add	a0,a0,a5
    8000459a:	611c                	ld	a5,0(a0)
    8000459c:	c395                	beqz	a5,800045c0 <argfd+0x64>
    return -1;
  if(pfd)
    8000459e:	00090463          	beqz	s2,800045a6 <argfd+0x4a>
    *pfd = fd;
    800045a2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045a6:	4501                	li	a0,0
  if(pf)
    800045a8:	c091                	beqz	s1,800045ac <argfd+0x50>
    *pf = f;
    800045aa:	e09c                	sd	a5,0(s1)
}
    800045ac:	70a2                	ld	ra,40(sp)
    800045ae:	7402                	ld	s0,32(sp)
    800045b0:	64e2                	ld	s1,24(sp)
    800045b2:	6942                	ld	s2,16(sp)
    800045b4:	6145                	addi	sp,sp,48
    800045b6:	8082                	ret
    return -1;
    800045b8:	557d                	li	a0,-1
    800045ba:	bfcd                	j	800045ac <argfd+0x50>
    return -1;
    800045bc:	557d                	li	a0,-1
    800045be:	b7fd                	j	800045ac <argfd+0x50>
    800045c0:	557d                	li	a0,-1
    800045c2:	b7ed                	j	800045ac <argfd+0x50>

00000000800045c4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045c4:	1101                	addi	sp,sp,-32
    800045c6:	ec06                	sd	ra,24(sp)
    800045c8:	e822                	sd	s0,16(sp)
    800045ca:	e426                	sd	s1,8(sp)
    800045cc:	1000                	addi	s0,sp,32
    800045ce:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045d0:	ffffd097          	auipc	ra,0xffffd
    800045d4:	a8e080e7          	jalr	-1394(ra) # 8000105e <myproc>
    800045d8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045da:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7fdb8e90>
    800045de:	4501                	li	a0,0
    800045e0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045e2:	6398                	ld	a4,0(a5)
    800045e4:	cb19                	beqz	a4,800045fa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045e6:	2505                	addiw	a0,a0,1
    800045e8:	07a1                	addi	a5,a5,8
    800045ea:	fed51ce3          	bne	a0,a3,800045e2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045ee:	557d                	li	a0,-1
}
    800045f0:	60e2                	ld	ra,24(sp)
    800045f2:	6442                	ld	s0,16(sp)
    800045f4:	64a2                	ld	s1,8(sp)
    800045f6:	6105                	addi	sp,sp,32
    800045f8:	8082                	ret
      p->ofile[fd] = f;
    800045fa:	01a50793          	addi	a5,a0,26
    800045fe:	078e                	slli	a5,a5,0x3
    80004600:	963e                	add	a2,a2,a5
    80004602:	e204                	sd	s1,0(a2)
      return fd;
    80004604:	b7f5                	j	800045f0 <fdalloc+0x2c>

0000000080004606 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004606:	715d                	addi	sp,sp,-80
    80004608:	e486                	sd	ra,72(sp)
    8000460a:	e0a2                	sd	s0,64(sp)
    8000460c:	fc26                	sd	s1,56(sp)
    8000460e:	f84a                	sd	s2,48(sp)
    80004610:	f44e                	sd	s3,40(sp)
    80004612:	f052                	sd	s4,32(sp)
    80004614:	ec56                	sd	s5,24(sp)
    80004616:	0880                	addi	s0,sp,80
    80004618:	89ae                	mv	s3,a1
    8000461a:	8ab2                	mv	s5,a2
    8000461c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000461e:	fb040593          	addi	a1,s0,-80
    80004622:	fffff097          	auipc	ra,0xfffff
    80004626:	e86080e7          	jalr	-378(ra) # 800034a8 <nameiparent>
    8000462a:	892a                	mv	s2,a0
    8000462c:	12050f63          	beqz	a0,8000476a <create+0x164>
    return 0;

  ilock(dp);
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	6a4080e7          	jalr	1700(ra) # 80002cd4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004638:	4601                	li	a2,0
    8000463a:	fb040593          	addi	a1,s0,-80
    8000463e:	854a                	mv	a0,s2
    80004640:	fffff097          	auipc	ra,0xfffff
    80004644:	b78080e7          	jalr	-1160(ra) # 800031b8 <dirlookup>
    80004648:	84aa                	mv	s1,a0
    8000464a:	c921                	beqz	a0,8000469a <create+0x94>
    iunlockput(dp);
    8000464c:	854a                	mv	a0,s2
    8000464e:	fffff097          	auipc	ra,0xfffff
    80004652:	8e8080e7          	jalr	-1816(ra) # 80002f36 <iunlockput>
    ilock(ip);
    80004656:	8526                	mv	a0,s1
    80004658:	ffffe097          	auipc	ra,0xffffe
    8000465c:	67c080e7          	jalr	1660(ra) # 80002cd4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004660:	2981                	sext.w	s3,s3
    80004662:	4789                	li	a5,2
    80004664:	02f99463          	bne	s3,a5,8000468c <create+0x86>
    80004668:	0444d783          	lhu	a5,68(s1)
    8000466c:	37f9                	addiw	a5,a5,-2
    8000466e:	17c2                	slli	a5,a5,0x30
    80004670:	93c1                	srli	a5,a5,0x30
    80004672:	4705                	li	a4,1
    80004674:	00f76c63          	bltu	a4,a5,8000468c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004678:	8526                	mv	a0,s1
    8000467a:	60a6                	ld	ra,72(sp)
    8000467c:	6406                	ld	s0,64(sp)
    8000467e:	74e2                	ld	s1,56(sp)
    80004680:	7942                	ld	s2,48(sp)
    80004682:	79a2                	ld	s3,40(sp)
    80004684:	7a02                	ld	s4,32(sp)
    80004686:	6ae2                	ld	s5,24(sp)
    80004688:	6161                	addi	sp,sp,80
    8000468a:	8082                	ret
    iunlockput(ip);
    8000468c:	8526                	mv	a0,s1
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	8a8080e7          	jalr	-1880(ra) # 80002f36 <iunlockput>
    return 0;
    80004696:	4481                	li	s1,0
    80004698:	b7c5                	j	80004678 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000469a:	85ce                	mv	a1,s3
    8000469c:	00092503          	lw	a0,0(s2)
    800046a0:	ffffe097          	auipc	ra,0xffffe
    800046a4:	49c080e7          	jalr	1180(ra) # 80002b3c <ialloc>
    800046a8:	84aa                	mv	s1,a0
    800046aa:	c529                	beqz	a0,800046f4 <create+0xee>
  ilock(ip);
    800046ac:	ffffe097          	auipc	ra,0xffffe
    800046b0:	628080e7          	jalr	1576(ra) # 80002cd4 <ilock>
  ip->major = major;
    800046b4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046b8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046bc:	4785                	li	a5,1
    800046be:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046c2:	8526                	mv	a0,s1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	546080e7          	jalr	1350(ra) # 80002c0a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046cc:	2981                	sext.w	s3,s3
    800046ce:	4785                	li	a5,1
    800046d0:	02f98a63          	beq	s3,a5,80004704 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046d4:	40d0                	lw	a2,4(s1)
    800046d6:	fb040593          	addi	a1,s0,-80
    800046da:	854a                	mv	a0,s2
    800046dc:	fffff097          	auipc	ra,0xfffff
    800046e0:	cec080e7          	jalr	-788(ra) # 800033c8 <dirlink>
    800046e4:	06054b63          	bltz	a0,8000475a <create+0x154>
  iunlockput(dp);
    800046e8:	854a                	mv	a0,s2
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	84c080e7          	jalr	-1972(ra) # 80002f36 <iunlockput>
  return ip;
    800046f2:	b759                	j	80004678 <create+0x72>
    panic("create: ialloc");
    800046f4:	00004517          	auipc	a0,0x4
    800046f8:	fbc50513          	addi	a0,a0,-68 # 800086b0 <syscalls+0x2a0>
    800046fc:	00001097          	auipc	ra,0x1
    80004700:	68c080e7          	jalr	1676(ra) # 80005d88 <panic>
    dp->nlink++;  // for ".."
    80004704:	04a95783          	lhu	a5,74(s2)
    80004708:	2785                	addiw	a5,a5,1
    8000470a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000470e:	854a                	mv	a0,s2
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	4fa080e7          	jalr	1274(ra) # 80002c0a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004718:	40d0                	lw	a2,4(s1)
    8000471a:	00004597          	auipc	a1,0x4
    8000471e:	fa658593          	addi	a1,a1,-90 # 800086c0 <syscalls+0x2b0>
    80004722:	8526                	mv	a0,s1
    80004724:	fffff097          	auipc	ra,0xfffff
    80004728:	ca4080e7          	jalr	-860(ra) # 800033c8 <dirlink>
    8000472c:	00054f63          	bltz	a0,8000474a <create+0x144>
    80004730:	00492603          	lw	a2,4(s2)
    80004734:	00004597          	auipc	a1,0x4
    80004738:	f9458593          	addi	a1,a1,-108 # 800086c8 <syscalls+0x2b8>
    8000473c:	8526                	mv	a0,s1
    8000473e:	fffff097          	auipc	ra,0xfffff
    80004742:	c8a080e7          	jalr	-886(ra) # 800033c8 <dirlink>
    80004746:	f80557e3          	bgez	a0,800046d4 <create+0xce>
      panic("create dots");
    8000474a:	00004517          	auipc	a0,0x4
    8000474e:	f8650513          	addi	a0,a0,-122 # 800086d0 <syscalls+0x2c0>
    80004752:	00001097          	auipc	ra,0x1
    80004756:	636080e7          	jalr	1590(ra) # 80005d88 <panic>
    panic("create: dirlink");
    8000475a:	00004517          	auipc	a0,0x4
    8000475e:	f8650513          	addi	a0,a0,-122 # 800086e0 <syscalls+0x2d0>
    80004762:	00001097          	auipc	ra,0x1
    80004766:	626080e7          	jalr	1574(ra) # 80005d88 <panic>
    return 0;
    8000476a:	84aa                	mv	s1,a0
    8000476c:	b731                	j	80004678 <create+0x72>

000000008000476e <sys_dup>:
{
    8000476e:	7179                	addi	sp,sp,-48
    80004770:	f406                	sd	ra,40(sp)
    80004772:	f022                	sd	s0,32(sp)
    80004774:	ec26                	sd	s1,24(sp)
    80004776:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004778:	fd840613          	addi	a2,s0,-40
    8000477c:	4581                	li	a1,0
    8000477e:	4501                	li	a0,0
    80004780:	00000097          	auipc	ra,0x0
    80004784:	ddc080e7          	jalr	-548(ra) # 8000455c <argfd>
    return -1;
    80004788:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000478a:	02054363          	bltz	a0,800047b0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000478e:	fd843503          	ld	a0,-40(s0)
    80004792:	00000097          	auipc	ra,0x0
    80004796:	e32080e7          	jalr	-462(ra) # 800045c4 <fdalloc>
    8000479a:	84aa                	mv	s1,a0
    return -1;
    8000479c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000479e:	00054963          	bltz	a0,800047b0 <sys_dup+0x42>
  filedup(f);
    800047a2:	fd843503          	ld	a0,-40(s0)
    800047a6:	fffff097          	auipc	ra,0xfffff
    800047aa:	37a080e7          	jalr	890(ra) # 80003b20 <filedup>
  return fd;
    800047ae:	87a6                	mv	a5,s1
}
    800047b0:	853e                	mv	a0,a5
    800047b2:	70a2                	ld	ra,40(sp)
    800047b4:	7402                	ld	s0,32(sp)
    800047b6:	64e2                	ld	s1,24(sp)
    800047b8:	6145                	addi	sp,sp,48
    800047ba:	8082                	ret

00000000800047bc <sys_read>:
{
    800047bc:	7179                	addi	sp,sp,-48
    800047be:	f406                	sd	ra,40(sp)
    800047c0:	f022                	sd	s0,32(sp)
    800047c2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047c4:	fe840613          	addi	a2,s0,-24
    800047c8:	4581                	li	a1,0
    800047ca:	4501                	li	a0,0
    800047cc:	00000097          	auipc	ra,0x0
    800047d0:	d90080e7          	jalr	-624(ra) # 8000455c <argfd>
    return -1;
    800047d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047d6:	04054163          	bltz	a0,80004818 <sys_read+0x5c>
    800047da:	fe440593          	addi	a1,s0,-28
    800047de:	4509                	li	a0,2
    800047e0:	ffffe097          	auipc	ra,0xffffe
    800047e4:	982080e7          	jalr	-1662(ra) # 80002162 <argint>
    return -1;
    800047e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047ea:	02054763          	bltz	a0,80004818 <sys_read+0x5c>
    800047ee:	fd840593          	addi	a1,s0,-40
    800047f2:	4505                	li	a0,1
    800047f4:	ffffe097          	auipc	ra,0xffffe
    800047f8:	990080e7          	jalr	-1648(ra) # 80002184 <argaddr>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047fe:	00054d63          	bltz	a0,80004818 <sys_read+0x5c>
  return fileread(f, p, n);
    80004802:	fe442603          	lw	a2,-28(s0)
    80004806:	fd843583          	ld	a1,-40(s0)
    8000480a:	fe843503          	ld	a0,-24(s0)
    8000480e:	fffff097          	auipc	ra,0xfffff
    80004812:	49e080e7          	jalr	1182(ra) # 80003cac <fileread>
    80004816:	87aa                	mv	a5,a0
}
    80004818:	853e                	mv	a0,a5
    8000481a:	70a2                	ld	ra,40(sp)
    8000481c:	7402                	ld	s0,32(sp)
    8000481e:	6145                	addi	sp,sp,48
    80004820:	8082                	ret

0000000080004822 <sys_write>:
{
    80004822:	7179                	addi	sp,sp,-48
    80004824:	f406                	sd	ra,40(sp)
    80004826:	f022                	sd	s0,32(sp)
    80004828:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000482a:	fe840613          	addi	a2,s0,-24
    8000482e:	4581                	li	a1,0
    80004830:	4501                	li	a0,0
    80004832:	00000097          	auipc	ra,0x0
    80004836:	d2a080e7          	jalr	-726(ra) # 8000455c <argfd>
    return -1;
    8000483a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000483c:	04054163          	bltz	a0,8000487e <sys_write+0x5c>
    80004840:	fe440593          	addi	a1,s0,-28
    80004844:	4509                	li	a0,2
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	91c080e7          	jalr	-1764(ra) # 80002162 <argint>
    return -1;
    8000484e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004850:	02054763          	bltz	a0,8000487e <sys_write+0x5c>
    80004854:	fd840593          	addi	a1,s0,-40
    80004858:	4505                	li	a0,1
    8000485a:	ffffe097          	auipc	ra,0xffffe
    8000485e:	92a080e7          	jalr	-1750(ra) # 80002184 <argaddr>
    return -1;
    80004862:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004864:	00054d63          	bltz	a0,8000487e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004868:	fe442603          	lw	a2,-28(s0)
    8000486c:	fd843583          	ld	a1,-40(s0)
    80004870:	fe843503          	ld	a0,-24(s0)
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	4fa080e7          	jalr	1274(ra) # 80003d6e <filewrite>
    8000487c:	87aa                	mv	a5,a0
}
    8000487e:	853e                	mv	a0,a5
    80004880:	70a2                	ld	ra,40(sp)
    80004882:	7402                	ld	s0,32(sp)
    80004884:	6145                	addi	sp,sp,48
    80004886:	8082                	ret

0000000080004888 <sys_close>:
{
    80004888:	1101                	addi	sp,sp,-32
    8000488a:	ec06                	sd	ra,24(sp)
    8000488c:	e822                	sd	s0,16(sp)
    8000488e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004890:	fe040613          	addi	a2,s0,-32
    80004894:	fec40593          	addi	a1,s0,-20
    80004898:	4501                	li	a0,0
    8000489a:	00000097          	auipc	ra,0x0
    8000489e:	cc2080e7          	jalr	-830(ra) # 8000455c <argfd>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048a4:	02054463          	bltz	a0,800048cc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048a8:	ffffc097          	auipc	ra,0xffffc
    800048ac:	7b6080e7          	jalr	1974(ra) # 8000105e <myproc>
    800048b0:	fec42783          	lw	a5,-20(s0)
    800048b4:	07e9                	addi	a5,a5,26
    800048b6:	078e                	slli	a5,a5,0x3
    800048b8:	97aa                	add	a5,a5,a0
    800048ba:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048be:	fe043503          	ld	a0,-32(s0)
    800048c2:	fffff097          	auipc	ra,0xfffff
    800048c6:	2b0080e7          	jalr	688(ra) # 80003b72 <fileclose>
  return 0;
    800048ca:	4781                	li	a5,0
}
    800048cc:	853e                	mv	a0,a5
    800048ce:	60e2                	ld	ra,24(sp)
    800048d0:	6442                	ld	s0,16(sp)
    800048d2:	6105                	addi	sp,sp,32
    800048d4:	8082                	ret

00000000800048d6 <sys_fstat>:
{
    800048d6:	1101                	addi	sp,sp,-32
    800048d8:	ec06                	sd	ra,24(sp)
    800048da:	e822                	sd	s0,16(sp)
    800048dc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048de:	fe840613          	addi	a2,s0,-24
    800048e2:	4581                	li	a1,0
    800048e4:	4501                	li	a0,0
    800048e6:	00000097          	auipc	ra,0x0
    800048ea:	c76080e7          	jalr	-906(ra) # 8000455c <argfd>
    return -1;
    800048ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048f0:	02054563          	bltz	a0,8000491a <sys_fstat+0x44>
    800048f4:	fe040593          	addi	a1,s0,-32
    800048f8:	4505                	li	a0,1
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	88a080e7          	jalr	-1910(ra) # 80002184 <argaddr>
    return -1;
    80004902:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004904:	00054b63          	bltz	a0,8000491a <sys_fstat+0x44>
  return filestat(f, st);
    80004908:	fe043583          	ld	a1,-32(s0)
    8000490c:	fe843503          	ld	a0,-24(s0)
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	32a080e7          	jalr	810(ra) # 80003c3a <filestat>
    80004918:	87aa                	mv	a5,a0
}
    8000491a:	853e                	mv	a0,a5
    8000491c:	60e2                	ld	ra,24(sp)
    8000491e:	6442                	ld	s0,16(sp)
    80004920:	6105                	addi	sp,sp,32
    80004922:	8082                	ret

0000000080004924 <sys_link>:
{
    80004924:	7169                	addi	sp,sp,-304
    80004926:	f606                	sd	ra,296(sp)
    80004928:	f222                	sd	s0,288(sp)
    8000492a:	ee26                	sd	s1,280(sp)
    8000492c:	ea4a                	sd	s2,272(sp)
    8000492e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004930:	08000613          	li	a2,128
    80004934:	ed040593          	addi	a1,s0,-304
    80004938:	4501                	li	a0,0
    8000493a:	ffffe097          	auipc	ra,0xffffe
    8000493e:	86c080e7          	jalr	-1940(ra) # 800021a6 <argstr>
    return -1;
    80004942:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004944:	10054e63          	bltz	a0,80004a60 <sys_link+0x13c>
    80004948:	08000613          	li	a2,128
    8000494c:	f5040593          	addi	a1,s0,-176
    80004950:	4505                	li	a0,1
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	854080e7          	jalr	-1964(ra) # 800021a6 <argstr>
    return -1;
    8000495a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000495c:	10054263          	bltz	a0,80004a60 <sys_link+0x13c>
  begin_op();
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	d46080e7          	jalr	-698(ra) # 800036a6 <begin_op>
  if((ip = namei(old)) == 0){
    80004968:	ed040513          	addi	a0,s0,-304
    8000496c:	fffff097          	auipc	ra,0xfffff
    80004970:	b1e080e7          	jalr	-1250(ra) # 8000348a <namei>
    80004974:	84aa                	mv	s1,a0
    80004976:	c551                	beqz	a0,80004a02 <sys_link+0xde>
  ilock(ip);
    80004978:	ffffe097          	auipc	ra,0xffffe
    8000497c:	35c080e7          	jalr	860(ra) # 80002cd4 <ilock>
  if(ip->type == T_DIR){
    80004980:	04449703          	lh	a4,68(s1)
    80004984:	4785                	li	a5,1
    80004986:	08f70463          	beq	a4,a5,80004a0e <sys_link+0xea>
  ip->nlink++;
    8000498a:	04a4d783          	lhu	a5,74(s1)
    8000498e:	2785                	addiw	a5,a5,1
    80004990:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004994:	8526                	mv	a0,s1
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	274080e7          	jalr	628(ra) # 80002c0a <iupdate>
  iunlock(ip);
    8000499e:	8526                	mv	a0,s1
    800049a0:	ffffe097          	auipc	ra,0xffffe
    800049a4:	3f6080e7          	jalr	1014(ra) # 80002d96 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049a8:	fd040593          	addi	a1,s0,-48
    800049ac:	f5040513          	addi	a0,s0,-176
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	af8080e7          	jalr	-1288(ra) # 800034a8 <nameiparent>
    800049b8:	892a                	mv	s2,a0
    800049ba:	c935                	beqz	a0,80004a2e <sys_link+0x10a>
  ilock(dp);
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	318080e7          	jalr	792(ra) # 80002cd4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049c4:	00092703          	lw	a4,0(s2)
    800049c8:	409c                	lw	a5,0(s1)
    800049ca:	04f71d63          	bne	a4,a5,80004a24 <sys_link+0x100>
    800049ce:	40d0                	lw	a2,4(s1)
    800049d0:	fd040593          	addi	a1,s0,-48
    800049d4:	854a                	mv	a0,s2
    800049d6:	fffff097          	auipc	ra,0xfffff
    800049da:	9f2080e7          	jalr	-1550(ra) # 800033c8 <dirlink>
    800049de:	04054363          	bltz	a0,80004a24 <sys_link+0x100>
  iunlockput(dp);
    800049e2:	854a                	mv	a0,s2
    800049e4:	ffffe097          	auipc	ra,0xffffe
    800049e8:	552080e7          	jalr	1362(ra) # 80002f36 <iunlockput>
  iput(ip);
    800049ec:	8526                	mv	a0,s1
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	4a0080e7          	jalr	1184(ra) # 80002e8e <iput>
  end_op();
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	d30080e7          	jalr	-720(ra) # 80003726 <end_op>
  return 0;
    800049fe:	4781                	li	a5,0
    80004a00:	a085                	j	80004a60 <sys_link+0x13c>
    end_op();
    80004a02:	fffff097          	auipc	ra,0xfffff
    80004a06:	d24080e7          	jalr	-732(ra) # 80003726 <end_op>
    return -1;
    80004a0a:	57fd                	li	a5,-1
    80004a0c:	a891                	j	80004a60 <sys_link+0x13c>
    iunlockput(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	526080e7          	jalr	1318(ra) # 80002f36 <iunlockput>
    end_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	d0e080e7          	jalr	-754(ra) # 80003726 <end_op>
    return -1;
    80004a20:	57fd                	li	a5,-1
    80004a22:	a83d                	j	80004a60 <sys_link+0x13c>
    iunlockput(dp);
    80004a24:	854a                	mv	a0,s2
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	510080e7          	jalr	1296(ra) # 80002f36 <iunlockput>
  ilock(ip);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	2a4080e7          	jalr	676(ra) # 80002cd4 <ilock>
  ip->nlink--;
    80004a38:	04a4d783          	lhu	a5,74(s1)
    80004a3c:	37fd                	addiw	a5,a5,-1
    80004a3e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	1c6080e7          	jalr	454(ra) # 80002c0a <iupdate>
  iunlockput(ip);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	4e8080e7          	jalr	1256(ra) # 80002f36 <iunlockput>
  end_op();
    80004a56:	fffff097          	auipc	ra,0xfffff
    80004a5a:	cd0080e7          	jalr	-816(ra) # 80003726 <end_op>
  return -1;
    80004a5e:	57fd                	li	a5,-1
}
    80004a60:	853e                	mv	a0,a5
    80004a62:	70b2                	ld	ra,296(sp)
    80004a64:	7412                	ld	s0,288(sp)
    80004a66:	64f2                	ld	s1,280(sp)
    80004a68:	6952                	ld	s2,272(sp)
    80004a6a:	6155                	addi	sp,sp,304
    80004a6c:	8082                	ret

0000000080004a6e <sys_unlink>:
{
    80004a6e:	7151                	addi	sp,sp,-240
    80004a70:	f586                	sd	ra,232(sp)
    80004a72:	f1a2                	sd	s0,224(sp)
    80004a74:	eda6                	sd	s1,216(sp)
    80004a76:	e9ca                	sd	s2,208(sp)
    80004a78:	e5ce                	sd	s3,200(sp)
    80004a7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a7c:	08000613          	li	a2,128
    80004a80:	f3040593          	addi	a1,s0,-208
    80004a84:	4501                	li	a0,0
    80004a86:	ffffd097          	auipc	ra,0xffffd
    80004a8a:	720080e7          	jalr	1824(ra) # 800021a6 <argstr>
    80004a8e:	18054163          	bltz	a0,80004c10 <sys_unlink+0x1a2>
  begin_op();
    80004a92:	fffff097          	auipc	ra,0xfffff
    80004a96:	c14080e7          	jalr	-1004(ra) # 800036a6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a9a:	fb040593          	addi	a1,s0,-80
    80004a9e:	f3040513          	addi	a0,s0,-208
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	a06080e7          	jalr	-1530(ra) # 800034a8 <nameiparent>
    80004aaa:	84aa                	mv	s1,a0
    80004aac:	c979                	beqz	a0,80004b82 <sys_unlink+0x114>
  ilock(dp);
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	226080e7          	jalr	550(ra) # 80002cd4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ab6:	00004597          	auipc	a1,0x4
    80004aba:	c0a58593          	addi	a1,a1,-1014 # 800086c0 <syscalls+0x2b0>
    80004abe:	fb040513          	addi	a0,s0,-80
    80004ac2:	ffffe097          	auipc	ra,0xffffe
    80004ac6:	6dc080e7          	jalr	1756(ra) # 8000319e <namecmp>
    80004aca:	14050a63          	beqz	a0,80004c1e <sys_unlink+0x1b0>
    80004ace:	00004597          	auipc	a1,0x4
    80004ad2:	bfa58593          	addi	a1,a1,-1030 # 800086c8 <syscalls+0x2b8>
    80004ad6:	fb040513          	addi	a0,s0,-80
    80004ada:	ffffe097          	auipc	ra,0xffffe
    80004ade:	6c4080e7          	jalr	1732(ra) # 8000319e <namecmp>
    80004ae2:	12050e63          	beqz	a0,80004c1e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ae6:	f2c40613          	addi	a2,s0,-212
    80004aea:	fb040593          	addi	a1,s0,-80
    80004aee:	8526                	mv	a0,s1
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	6c8080e7          	jalr	1736(ra) # 800031b8 <dirlookup>
    80004af8:	892a                	mv	s2,a0
    80004afa:	12050263          	beqz	a0,80004c1e <sys_unlink+0x1b0>
  ilock(ip);
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	1d6080e7          	jalr	470(ra) # 80002cd4 <ilock>
  if(ip->nlink < 1)
    80004b06:	04a91783          	lh	a5,74(s2)
    80004b0a:	08f05263          	blez	a5,80004b8e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b0e:	04491703          	lh	a4,68(s2)
    80004b12:	4785                	li	a5,1
    80004b14:	08f70563          	beq	a4,a5,80004b9e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b18:	4641                	li	a2,16
    80004b1a:	4581                	li	a1,0
    80004b1c:	fc040513          	addi	a0,s0,-64
    80004b20:	ffffb097          	auipc	ra,0xffffb
    80004b24:	780080e7          	jalr	1920(ra) # 800002a0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b28:	4741                	li	a4,16
    80004b2a:	f2c42683          	lw	a3,-212(s0)
    80004b2e:	fc040613          	addi	a2,s0,-64
    80004b32:	4581                	li	a1,0
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	54a080e7          	jalr	1354(ra) # 80003080 <writei>
    80004b3e:	47c1                	li	a5,16
    80004b40:	0af51563          	bne	a0,a5,80004bea <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b44:	04491703          	lh	a4,68(s2)
    80004b48:	4785                	li	a5,1
    80004b4a:	0af70863          	beq	a4,a5,80004bfa <sys_unlink+0x18c>
  iunlockput(dp);
    80004b4e:	8526                	mv	a0,s1
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	3e6080e7          	jalr	998(ra) # 80002f36 <iunlockput>
  ip->nlink--;
    80004b58:	04a95783          	lhu	a5,74(s2)
    80004b5c:	37fd                	addiw	a5,a5,-1
    80004b5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b62:	854a                	mv	a0,s2
    80004b64:	ffffe097          	auipc	ra,0xffffe
    80004b68:	0a6080e7          	jalr	166(ra) # 80002c0a <iupdate>
  iunlockput(ip);
    80004b6c:	854a                	mv	a0,s2
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	3c8080e7          	jalr	968(ra) # 80002f36 <iunlockput>
  end_op();
    80004b76:	fffff097          	auipc	ra,0xfffff
    80004b7a:	bb0080e7          	jalr	-1104(ra) # 80003726 <end_op>
  return 0;
    80004b7e:	4501                	li	a0,0
    80004b80:	a84d                	j	80004c32 <sys_unlink+0x1c4>
    end_op();
    80004b82:	fffff097          	auipc	ra,0xfffff
    80004b86:	ba4080e7          	jalr	-1116(ra) # 80003726 <end_op>
    return -1;
    80004b8a:	557d                	li	a0,-1
    80004b8c:	a05d                	j	80004c32 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b8e:	00004517          	auipc	a0,0x4
    80004b92:	b6250513          	addi	a0,a0,-1182 # 800086f0 <syscalls+0x2e0>
    80004b96:	00001097          	auipc	ra,0x1
    80004b9a:	1f2080e7          	jalr	498(ra) # 80005d88 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9e:	04c92703          	lw	a4,76(s2)
    80004ba2:	02000793          	li	a5,32
    80004ba6:	f6e7f9e3          	bgeu	a5,a4,80004b18 <sys_unlink+0xaa>
    80004baa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bae:	4741                	li	a4,16
    80004bb0:	86ce                	mv	a3,s3
    80004bb2:	f1840613          	addi	a2,s0,-232
    80004bb6:	4581                	li	a1,0
    80004bb8:	854a                	mv	a0,s2
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	3ce080e7          	jalr	974(ra) # 80002f88 <readi>
    80004bc2:	47c1                	li	a5,16
    80004bc4:	00f51b63          	bne	a0,a5,80004bda <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bc8:	f1845783          	lhu	a5,-232(s0)
    80004bcc:	e7a1                	bnez	a5,80004c14 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bce:	29c1                	addiw	s3,s3,16
    80004bd0:	04c92783          	lw	a5,76(s2)
    80004bd4:	fcf9ede3          	bltu	s3,a5,80004bae <sys_unlink+0x140>
    80004bd8:	b781                	j	80004b18 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bda:	00004517          	auipc	a0,0x4
    80004bde:	b2e50513          	addi	a0,a0,-1234 # 80008708 <syscalls+0x2f8>
    80004be2:	00001097          	auipc	ra,0x1
    80004be6:	1a6080e7          	jalr	422(ra) # 80005d88 <panic>
    panic("unlink: writei");
    80004bea:	00004517          	auipc	a0,0x4
    80004bee:	b3650513          	addi	a0,a0,-1226 # 80008720 <syscalls+0x310>
    80004bf2:	00001097          	auipc	ra,0x1
    80004bf6:	196080e7          	jalr	406(ra) # 80005d88 <panic>
    dp->nlink--;
    80004bfa:	04a4d783          	lhu	a5,74(s1)
    80004bfe:	37fd                	addiw	a5,a5,-1
    80004c00:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	004080e7          	jalr	4(ra) # 80002c0a <iupdate>
    80004c0e:	b781                	j	80004b4e <sys_unlink+0xe0>
    return -1;
    80004c10:	557d                	li	a0,-1
    80004c12:	a005                	j	80004c32 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	320080e7          	jalr	800(ra) # 80002f36 <iunlockput>
  iunlockput(dp);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	316080e7          	jalr	790(ra) # 80002f36 <iunlockput>
  end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	afe080e7          	jalr	-1282(ra) # 80003726 <end_op>
  return -1;
    80004c30:	557d                	li	a0,-1
}
    80004c32:	70ae                	ld	ra,232(sp)
    80004c34:	740e                	ld	s0,224(sp)
    80004c36:	64ee                	ld	s1,216(sp)
    80004c38:	694e                	ld	s2,208(sp)
    80004c3a:	69ae                	ld	s3,200(sp)
    80004c3c:	616d                	addi	sp,sp,240
    80004c3e:	8082                	ret

0000000080004c40 <sys_open>:

uint64
sys_open(void)
{
    80004c40:	7131                	addi	sp,sp,-192
    80004c42:	fd06                	sd	ra,184(sp)
    80004c44:	f922                	sd	s0,176(sp)
    80004c46:	f526                	sd	s1,168(sp)
    80004c48:	f14a                	sd	s2,160(sp)
    80004c4a:	ed4e                	sd	s3,152(sp)
    80004c4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c4e:	08000613          	li	a2,128
    80004c52:	f5040593          	addi	a1,s0,-176
    80004c56:	4501                	li	a0,0
    80004c58:	ffffd097          	auipc	ra,0xffffd
    80004c5c:	54e080e7          	jalr	1358(ra) # 800021a6 <argstr>
    return -1;
    80004c60:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c62:	0c054163          	bltz	a0,80004d24 <sys_open+0xe4>
    80004c66:	f4c40593          	addi	a1,s0,-180
    80004c6a:	4505                	li	a0,1
    80004c6c:	ffffd097          	auipc	ra,0xffffd
    80004c70:	4f6080e7          	jalr	1270(ra) # 80002162 <argint>
    80004c74:	0a054863          	bltz	a0,80004d24 <sys_open+0xe4>

  begin_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	a2e080e7          	jalr	-1490(ra) # 800036a6 <begin_op>

  if(omode & O_CREATE){
    80004c80:	f4c42783          	lw	a5,-180(s0)
    80004c84:	2007f793          	andi	a5,a5,512
    80004c88:	cbdd                	beqz	a5,80004d3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c8a:	4681                	li	a3,0
    80004c8c:	4601                	li	a2,0
    80004c8e:	4589                	li	a1,2
    80004c90:	f5040513          	addi	a0,s0,-176
    80004c94:	00000097          	auipc	ra,0x0
    80004c98:	972080e7          	jalr	-1678(ra) # 80004606 <create>
    80004c9c:	892a                	mv	s2,a0
    if(ip == 0){
    80004c9e:	c959                	beqz	a0,80004d34 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ca0:	04491703          	lh	a4,68(s2)
    80004ca4:	478d                	li	a5,3
    80004ca6:	00f71763          	bne	a4,a5,80004cb4 <sys_open+0x74>
    80004caa:	04695703          	lhu	a4,70(s2)
    80004cae:	47a5                	li	a5,9
    80004cb0:	0ce7ec63          	bltu	a5,a4,80004d88 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	e02080e7          	jalr	-510(ra) # 80003ab6 <filealloc>
    80004cbc:	89aa                	mv	s3,a0
    80004cbe:	10050263          	beqz	a0,80004dc2 <sys_open+0x182>
    80004cc2:	00000097          	auipc	ra,0x0
    80004cc6:	902080e7          	jalr	-1790(ra) # 800045c4 <fdalloc>
    80004cca:	84aa                	mv	s1,a0
    80004ccc:	0e054663          	bltz	a0,80004db8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cd0:	04491703          	lh	a4,68(s2)
    80004cd4:	478d                	li	a5,3
    80004cd6:	0cf70463          	beq	a4,a5,80004d9e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cda:	4789                	li	a5,2
    80004cdc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004ce0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004ce4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ce8:	f4c42783          	lw	a5,-180(s0)
    80004cec:	0017c713          	xori	a4,a5,1
    80004cf0:	8b05                	andi	a4,a4,1
    80004cf2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cf6:	0037f713          	andi	a4,a5,3
    80004cfa:	00e03733          	snez	a4,a4
    80004cfe:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d02:	4007f793          	andi	a5,a5,1024
    80004d06:	c791                	beqz	a5,80004d12 <sys_open+0xd2>
    80004d08:	04491703          	lh	a4,68(s2)
    80004d0c:	4789                	li	a5,2
    80004d0e:	08f70f63          	beq	a4,a5,80004dac <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d12:	854a                	mv	a0,s2
    80004d14:	ffffe097          	auipc	ra,0xffffe
    80004d18:	082080e7          	jalr	130(ra) # 80002d96 <iunlock>
  end_op();
    80004d1c:	fffff097          	auipc	ra,0xfffff
    80004d20:	a0a080e7          	jalr	-1526(ra) # 80003726 <end_op>

  return fd;
}
    80004d24:	8526                	mv	a0,s1
    80004d26:	70ea                	ld	ra,184(sp)
    80004d28:	744a                	ld	s0,176(sp)
    80004d2a:	74aa                	ld	s1,168(sp)
    80004d2c:	790a                	ld	s2,160(sp)
    80004d2e:	69ea                	ld	s3,152(sp)
    80004d30:	6129                	addi	sp,sp,192
    80004d32:	8082                	ret
      end_op();
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	9f2080e7          	jalr	-1550(ra) # 80003726 <end_op>
      return -1;
    80004d3c:	b7e5                	j	80004d24 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d3e:	f5040513          	addi	a0,s0,-176
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	748080e7          	jalr	1864(ra) # 8000348a <namei>
    80004d4a:	892a                	mv	s2,a0
    80004d4c:	c905                	beqz	a0,80004d7c <sys_open+0x13c>
    ilock(ip);
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	f86080e7          	jalr	-122(ra) # 80002cd4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d56:	04491703          	lh	a4,68(s2)
    80004d5a:	4785                	li	a5,1
    80004d5c:	f4f712e3          	bne	a4,a5,80004ca0 <sys_open+0x60>
    80004d60:	f4c42783          	lw	a5,-180(s0)
    80004d64:	dba1                	beqz	a5,80004cb4 <sys_open+0x74>
      iunlockput(ip);
    80004d66:	854a                	mv	a0,s2
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	1ce080e7          	jalr	462(ra) # 80002f36 <iunlockput>
      end_op();
    80004d70:	fffff097          	auipc	ra,0xfffff
    80004d74:	9b6080e7          	jalr	-1610(ra) # 80003726 <end_op>
      return -1;
    80004d78:	54fd                	li	s1,-1
    80004d7a:	b76d                	j	80004d24 <sys_open+0xe4>
      end_op();
    80004d7c:	fffff097          	auipc	ra,0xfffff
    80004d80:	9aa080e7          	jalr	-1622(ra) # 80003726 <end_op>
      return -1;
    80004d84:	54fd                	li	s1,-1
    80004d86:	bf79                	j	80004d24 <sys_open+0xe4>
    iunlockput(ip);
    80004d88:	854a                	mv	a0,s2
    80004d8a:	ffffe097          	auipc	ra,0xffffe
    80004d8e:	1ac080e7          	jalr	428(ra) # 80002f36 <iunlockput>
    end_op();
    80004d92:	fffff097          	auipc	ra,0xfffff
    80004d96:	994080e7          	jalr	-1644(ra) # 80003726 <end_op>
    return -1;
    80004d9a:	54fd                	li	s1,-1
    80004d9c:	b761                	j	80004d24 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004da2:	04691783          	lh	a5,70(s2)
    80004da6:	02f99223          	sh	a5,36(s3)
    80004daa:	bf2d                	j	80004ce4 <sys_open+0xa4>
    itrunc(ip);
    80004dac:	854a                	mv	a0,s2
    80004dae:	ffffe097          	auipc	ra,0xffffe
    80004db2:	034080e7          	jalr	52(ra) # 80002de2 <itrunc>
    80004db6:	bfb1                	j	80004d12 <sys_open+0xd2>
      fileclose(f);
    80004db8:	854e                	mv	a0,s3
    80004dba:	fffff097          	auipc	ra,0xfffff
    80004dbe:	db8080e7          	jalr	-584(ra) # 80003b72 <fileclose>
    iunlockput(ip);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	ffffe097          	auipc	ra,0xffffe
    80004dc8:	172080e7          	jalr	370(ra) # 80002f36 <iunlockput>
    end_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	95a080e7          	jalr	-1702(ra) # 80003726 <end_op>
    return -1;
    80004dd4:	54fd                	li	s1,-1
    80004dd6:	b7b9                	j	80004d24 <sys_open+0xe4>

0000000080004dd8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dd8:	7175                	addi	sp,sp,-144
    80004dda:	e506                	sd	ra,136(sp)
    80004ddc:	e122                	sd	s0,128(sp)
    80004dde:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	8c6080e7          	jalr	-1850(ra) # 800036a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004de8:	08000613          	li	a2,128
    80004dec:	f7040593          	addi	a1,s0,-144
    80004df0:	4501                	li	a0,0
    80004df2:	ffffd097          	auipc	ra,0xffffd
    80004df6:	3b4080e7          	jalr	948(ra) # 800021a6 <argstr>
    80004dfa:	02054963          	bltz	a0,80004e2c <sys_mkdir+0x54>
    80004dfe:	4681                	li	a3,0
    80004e00:	4601                	li	a2,0
    80004e02:	4585                	li	a1,1
    80004e04:	f7040513          	addi	a0,s0,-144
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	7fe080e7          	jalr	2046(ra) # 80004606 <create>
    80004e10:	cd11                	beqz	a0,80004e2c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	124080e7          	jalr	292(ra) # 80002f36 <iunlockput>
  end_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	90c080e7          	jalr	-1780(ra) # 80003726 <end_op>
  return 0;
    80004e22:	4501                	li	a0,0
}
    80004e24:	60aa                	ld	ra,136(sp)
    80004e26:	640a                	ld	s0,128(sp)
    80004e28:	6149                	addi	sp,sp,144
    80004e2a:	8082                	ret
    end_op();
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	8fa080e7          	jalr	-1798(ra) # 80003726 <end_op>
    return -1;
    80004e34:	557d                	li	a0,-1
    80004e36:	b7fd                	j	80004e24 <sys_mkdir+0x4c>

0000000080004e38 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e38:	7135                	addi	sp,sp,-160
    80004e3a:	ed06                	sd	ra,152(sp)
    80004e3c:	e922                	sd	s0,144(sp)
    80004e3e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	866080e7          	jalr	-1946(ra) # 800036a6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e48:	08000613          	li	a2,128
    80004e4c:	f7040593          	addi	a1,s0,-144
    80004e50:	4501                	li	a0,0
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	354080e7          	jalr	852(ra) # 800021a6 <argstr>
    80004e5a:	04054a63          	bltz	a0,80004eae <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e5e:	f6c40593          	addi	a1,s0,-148
    80004e62:	4505                	li	a0,1
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	2fe080e7          	jalr	766(ra) # 80002162 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e6c:	04054163          	bltz	a0,80004eae <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e70:	f6840593          	addi	a1,s0,-152
    80004e74:	4509                	li	a0,2
    80004e76:	ffffd097          	auipc	ra,0xffffd
    80004e7a:	2ec080e7          	jalr	748(ra) # 80002162 <argint>
     argint(1, &major) < 0 ||
    80004e7e:	02054863          	bltz	a0,80004eae <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e82:	f6841683          	lh	a3,-152(s0)
    80004e86:	f6c41603          	lh	a2,-148(s0)
    80004e8a:	458d                	li	a1,3
    80004e8c:	f7040513          	addi	a0,s0,-144
    80004e90:	fffff097          	auipc	ra,0xfffff
    80004e94:	776080e7          	jalr	1910(ra) # 80004606 <create>
     argint(2, &minor) < 0 ||
    80004e98:	c919                	beqz	a0,80004eae <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	09c080e7          	jalr	156(ra) # 80002f36 <iunlockput>
  end_op();
    80004ea2:	fffff097          	auipc	ra,0xfffff
    80004ea6:	884080e7          	jalr	-1916(ra) # 80003726 <end_op>
  return 0;
    80004eaa:	4501                	li	a0,0
    80004eac:	a031                	j	80004eb8 <sys_mknod+0x80>
    end_op();
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	878080e7          	jalr	-1928(ra) # 80003726 <end_op>
    return -1;
    80004eb6:	557d                	li	a0,-1
}
    80004eb8:	60ea                	ld	ra,152(sp)
    80004eba:	644a                	ld	s0,144(sp)
    80004ebc:	610d                	addi	sp,sp,160
    80004ebe:	8082                	ret

0000000080004ec0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ec0:	7135                	addi	sp,sp,-160
    80004ec2:	ed06                	sd	ra,152(sp)
    80004ec4:	e922                	sd	s0,144(sp)
    80004ec6:	e526                	sd	s1,136(sp)
    80004ec8:	e14a                	sd	s2,128(sp)
    80004eca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004ecc:	ffffc097          	auipc	ra,0xffffc
    80004ed0:	192080e7          	jalr	402(ra) # 8000105e <myproc>
    80004ed4:	892a                	mv	s2,a0
  
  begin_op();
    80004ed6:	ffffe097          	auipc	ra,0xffffe
    80004eda:	7d0080e7          	jalr	2000(ra) # 800036a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ede:	08000613          	li	a2,128
    80004ee2:	f6040593          	addi	a1,s0,-160
    80004ee6:	4501                	li	a0,0
    80004ee8:	ffffd097          	auipc	ra,0xffffd
    80004eec:	2be080e7          	jalr	702(ra) # 800021a6 <argstr>
    80004ef0:	04054b63          	bltz	a0,80004f46 <sys_chdir+0x86>
    80004ef4:	f6040513          	addi	a0,s0,-160
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	592080e7          	jalr	1426(ra) # 8000348a <namei>
    80004f00:	84aa                	mv	s1,a0
    80004f02:	c131                	beqz	a0,80004f46 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f04:	ffffe097          	auipc	ra,0xffffe
    80004f08:	dd0080e7          	jalr	-560(ra) # 80002cd4 <ilock>
  if(ip->type != T_DIR){
    80004f0c:	04449703          	lh	a4,68(s1)
    80004f10:	4785                	li	a5,1
    80004f12:	04f71063          	bne	a4,a5,80004f52 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f16:	8526                	mv	a0,s1
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	e7e080e7          	jalr	-386(ra) # 80002d96 <iunlock>
  iput(p->cwd);
    80004f20:	15093503          	ld	a0,336(s2)
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	f6a080e7          	jalr	-150(ra) # 80002e8e <iput>
  end_op();
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	7fa080e7          	jalr	2042(ra) # 80003726 <end_op>
  p->cwd = ip;
    80004f34:	14993823          	sd	s1,336(s2)
  return 0;
    80004f38:	4501                	li	a0,0
}
    80004f3a:	60ea                	ld	ra,152(sp)
    80004f3c:	644a                	ld	s0,144(sp)
    80004f3e:	64aa                	ld	s1,136(sp)
    80004f40:	690a                	ld	s2,128(sp)
    80004f42:	610d                	addi	sp,sp,160
    80004f44:	8082                	ret
    end_op();
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	7e0080e7          	jalr	2016(ra) # 80003726 <end_op>
    return -1;
    80004f4e:	557d                	li	a0,-1
    80004f50:	b7ed                	j	80004f3a <sys_chdir+0x7a>
    iunlockput(ip);
    80004f52:	8526                	mv	a0,s1
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	fe2080e7          	jalr	-30(ra) # 80002f36 <iunlockput>
    end_op();
    80004f5c:	ffffe097          	auipc	ra,0xffffe
    80004f60:	7ca080e7          	jalr	1994(ra) # 80003726 <end_op>
    return -1;
    80004f64:	557d                	li	a0,-1
    80004f66:	bfd1                	j	80004f3a <sys_chdir+0x7a>

0000000080004f68 <sys_exec>:

uint64
sys_exec(void)
{
    80004f68:	7145                	addi	sp,sp,-464
    80004f6a:	e786                	sd	ra,456(sp)
    80004f6c:	e3a2                	sd	s0,448(sp)
    80004f6e:	ff26                	sd	s1,440(sp)
    80004f70:	fb4a                	sd	s2,432(sp)
    80004f72:	f74e                	sd	s3,424(sp)
    80004f74:	f352                	sd	s4,416(sp)
    80004f76:	ef56                	sd	s5,408(sp)
    80004f78:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f7a:	08000613          	li	a2,128
    80004f7e:	f4040593          	addi	a1,s0,-192
    80004f82:	4501                	li	a0,0
    80004f84:	ffffd097          	auipc	ra,0xffffd
    80004f88:	222080e7          	jalr	546(ra) # 800021a6 <argstr>
    return -1;
    80004f8c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f8e:	0c054a63          	bltz	a0,80005062 <sys_exec+0xfa>
    80004f92:	e3840593          	addi	a1,s0,-456
    80004f96:	4505                	li	a0,1
    80004f98:	ffffd097          	auipc	ra,0xffffd
    80004f9c:	1ec080e7          	jalr	492(ra) # 80002184 <argaddr>
    80004fa0:	0c054163          	bltz	a0,80005062 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fa4:	10000613          	li	a2,256
    80004fa8:	4581                	li	a1,0
    80004faa:	e4040513          	addi	a0,s0,-448
    80004fae:	ffffb097          	auipc	ra,0xffffb
    80004fb2:	2f2080e7          	jalr	754(ra) # 800002a0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fb6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fba:	89a6                	mv	s3,s1
    80004fbc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fbe:	02000a13          	li	s4,32
    80004fc2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fc6:	00391513          	slli	a0,s2,0x3
    80004fca:	e3040593          	addi	a1,s0,-464
    80004fce:	e3843783          	ld	a5,-456(s0)
    80004fd2:	953e                	add	a0,a0,a5
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	0f4080e7          	jalr	244(ra) # 800020c8 <fetchaddr>
    80004fdc:	02054a63          	bltz	a0,80005010 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004fe0:	e3043783          	ld	a5,-464(s0)
    80004fe4:	c3b9                	beqz	a5,8000502a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fe6:	ffffb097          	auipc	ra,0xffffb
    80004fea:	110080e7          	jalr	272(ra) # 800000f6 <kalloc>
    80004fee:	85aa                	mv	a1,a0
    80004ff0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ff4:	cd11                	beqz	a0,80005010 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ff6:	6605                	lui	a2,0x1
    80004ff8:	e3043503          	ld	a0,-464(s0)
    80004ffc:	ffffd097          	auipc	ra,0xffffd
    80005000:	11e080e7          	jalr	286(ra) # 8000211a <fetchstr>
    80005004:	00054663          	bltz	a0,80005010 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005008:	0905                	addi	s2,s2,1
    8000500a:	09a1                	addi	s3,s3,8
    8000500c:	fb491be3          	bne	s2,s4,80004fc2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005010:	10048913          	addi	s2,s1,256
    80005014:	6088                	ld	a0,0(s1)
    80005016:	c529                	beqz	a0,80005060 <sys_exec+0xf8>
    kfree(argv[i]);
    80005018:	ffffb097          	auipc	ra,0xffffb
    8000501c:	004080e7          	jalr	4(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005020:	04a1                	addi	s1,s1,8
    80005022:	ff2499e3          	bne	s1,s2,80005014 <sys_exec+0xac>
  return -1;
    80005026:	597d                	li	s2,-1
    80005028:	a82d                	j	80005062 <sys_exec+0xfa>
      argv[i] = 0;
    8000502a:	0a8e                	slli	s5,s5,0x3
    8000502c:	fc040793          	addi	a5,s0,-64
    80005030:	9abe                	add	s5,s5,a5
    80005032:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005036:	e4040593          	addi	a1,s0,-448
    8000503a:	f4040513          	addi	a0,s0,-192
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	194080e7          	jalr	404(ra) # 800041d2 <exec>
    80005046:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005048:	10048993          	addi	s3,s1,256
    8000504c:	6088                	ld	a0,0(s1)
    8000504e:	c911                	beqz	a0,80005062 <sys_exec+0xfa>
    kfree(argv[i]);
    80005050:	ffffb097          	auipc	ra,0xffffb
    80005054:	fcc080e7          	jalr	-52(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005058:	04a1                	addi	s1,s1,8
    8000505a:	ff3499e3          	bne	s1,s3,8000504c <sys_exec+0xe4>
    8000505e:	a011                	j	80005062 <sys_exec+0xfa>
  return -1;
    80005060:	597d                	li	s2,-1
}
    80005062:	854a                	mv	a0,s2
    80005064:	60be                	ld	ra,456(sp)
    80005066:	641e                	ld	s0,448(sp)
    80005068:	74fa                	ld	s1,440(sp)
    8000506a:	795a                	ld	s2,432(sp)
    8000506c:	79ba                	ld	s3,424(sp)
    8000506e:	7a1a                	ld	s4,416(sp)
    80005070:	6afa                	ld	s5,408(sp)
    80005072:	6179                	addi	sp,sp,464
    80005074:	8082                	ret

0000000080005076 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005076:	7139                	addi	sp,sp,-64
    80005078:	fc06                	sd	ra,56(sp)
    8000507a:	f822                	sd	s0,48(sp)
    8000507c:	f426                	sd	s1,40(sp)
    8000507e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005080:	ffffc097          	auipc	ra,0xffffc
    80005084:	fde080e7          	jalr	-34(ra) # 8000105e <myproc>
    80005088:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000508a:	fd840593          	addi	a1,s0,-40
    8000508e:	4501                	li	a0,0
    80005090:	ffffd097          	auipc	ra,0xffffd
    80005094:	0f4080e7          	jalr	244(ra) # 80002184 <argaddr>
    return -1;
    80005098:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000509a:	0e054063          	bltz	a0,8000517a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000509e:	fc840593          	addi	a1,s0,-56
    800050a2:	fd040513          	addi	a0,s0,-48
    800050a6:	fffff097          	auipc	ra,0xfffff
    800050aa:	dfc080e7          	jalr	-516(ra) # 80003ea2 <pipealloc>
    return -1;
    800050ae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050b0:	0c054563          	bltz	a0,8000517a <sys_pipe+0x104>
  fd0 = -1;
    800050b4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050b8:	fd043503          	ld	a0,-48(s0)
    800050bc:	fffff097          	auipc	ra,0xfffff
    800050c0:	508080e7          	jalr	1288(ra) # 800045c4 <fdalloc>
    800050c4:	fca42223          	sw	a0,-60(s0)
    800050c8:	08054c63          	bltz	a0,80005160 <sys_pipe+0xea>
    800050cc:	fc843503          	ld	a0,-56(s0)
    800050d0:	fffff097          	auipc	ra,0xfffff
    800050d4:	4f4080e7          	jalr	1268(ra) # 800045c4 <fdalloc>
    800050d8:	fca42023          	sw	a0,-64(s0)
    800050dc:	06054863          	bltz	a0,8000514c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050e0:	4691                	li	a3,4
    800050e2:	fc440613          	addi	a2,s0,-60
    800050e6:	fd843583          	ld	a1,-40(s0)
    800050ea:	68a8                	ld	a0,80(s1)
    800050ec:	ffffc097          	auipc	ra,0xffffc
    800050f0:	d52080e7          	jalr	-686(ra) # 80000e3e <copyout>
    800050f4:	02054063          	bltz	a0,80005114 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050f8:	4691                	li	a3,4
    800050fa:	fc040613          	addi	a2,s0,-64
    800050fe:	fd843583          	ld	a1,-40(s0)
    80005102:	0591                	addi	a1,a1,4
    80005104:	68a8                	ld	a0,80(s1)
    80005106:	ffffc097          	auipc	ra,0xffffc
    8000510a:	d38080e7          	jalr	-712(ra) # 80000e3e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000510e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005110:	06055563          	bgez	a0,8000517a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005114:	fc442783          	lw	a5,-60(s0)
    80005118:	07e9                	addi	a5,a5,26
    8000511a:	078e                	slli	a5,a5,0x3
    8000511c:	97a6                	add	a5,a5,s1
    8000511e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005122:	fc042503          	lw	a0,-64(s0)
    80005126:	0569                	addi	a0,a0,26
    80005128:	050e                	slli	a0,a0,0x3
    8000512a:	9526                	add	a0,a0,s1
    8000512c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005130:	fd043503          	ld	a0,-48(s0)
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	a3e080e7          	jalr	-1474(ra) # 80003b72 <fileclose>
    fileclose(wf);
    8000513c:	fc843503          	ld	a0,-56(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	a32080e7          	jalr	-1486(ra) # 80003b72 <fileclose>
    return -1;
    80005148:	57fd                	li	a5,-1
    8000514a:	a805                	j	8000517a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000514c:	fc442783          	lw	a5,-60(s0)
    80005150:	0007c863          	bltz	a5,80005160 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005154:	01a78513          	addi	a0,a5,26
    80005158:	050e                	slli	a0,a0,0x3
    8000515a:	9526                	add	a0,a0,s1
    8000515c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005160:	fd043503          	ld	a0,-48(s0)
    80005164:	fffff097          	auipc	ra,0xfffff
    80005168:	a0e080e7          	jalr	-1522(ra) # 80003b72 <fileclose>
    fileclose(wf);
    8000516c:	fc843503          	ld	a0,-56(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	a02080e7          	jalr	-1534(ra) # 80003b72 <fileclose>
    return -1;
    80005178:	57fd                	li	a5,-1
}
    8000517a:	853e                	mv	a0,a5
    8000517c:	70e2                	ld	ra,56(sp)
    8000517e:	7442                	ld	s0,48(sp)
    80005180:	74a2                	ld	s1,40(sp)
    80005182:	6121                	addi	sp,sp,64
    80005184:	8082                	ret
	...

0000000080005190 <kernelvec>:
    80005190:	7111                	addi	sp,sp,-256
    80005192:	e006                	sd	ra,0(sp)
    80005194:	e40a                	sd	sp,8(sp)
    80005196:	e80e                	sd	gp,16(sp)
    80005198:	ec12                	sd	tp,24(sp)
    8000519a:	f016                	sd	t0,32(sp)
    8000519c:	f41a                	sd	t1,40(sp)
    8000519e:	f81e                	sd	t2,48(sp)
    800051a0:	fc22                	sd	s0,56(sp)
    800051a2:	e0a6                	sd	s1,64(sp)
    800051a4:	e4aa                	sd	a0,72(sp)
    800051a6:	e8ae                	sd	a1,80(sp)
    800051a8:	ecb2                	sd	a2,88(sp)
    800051aa:	f0b6                	sd	a3,96(sp)
    800051ac:	f4ba                	sd	a4,104(sp)
    800051ae:	f8be                	sd	a5,112(sp)
    800051b0:	fcc2                	sd	a6,120(sp)
    800051b2:	e146                	sd	a7,128(sp)
    800051b4:	e54a                	sd	s2,136(sp)
    800051b6:	e94e                	sd	s3,144(sp)
    800051b8:	ed52                	sd	s4,152(sp)
    800051ba:	f156                	sd	s5,160(sp)
    800051bc:	f55a                	sd	s6,168(sp)
    800051be:	f95e                	sd	s7,176(sp)
    800051c0:	fd62                	sd	s8,184(sp)
    800051c2:	e1e6                	sd	s9,192(sp)
    800051c4:	e5ea                	sd	s10,200(sp)
    800051c6:	e9ee                	sd	s11,208(sp)
    800051c8:	edf2                	sd	t3,216(sp)
    800051ca:	f1f6                	sd	t4,224(sp)
    800051cc:	f5fa                	sd	t5,232(sp)
    800051ce:	f9fe                	sd	t6,240(sp)
    800051d0:	dc5fc0ef          	jal	ra,80001f94 <kerneltrap>
    800051d4:	6082                	ld	ra,0(sp)
    800051d6:	6122                	ld	sp,8(sp)
    800051d8:	61c2                	ld	gp,16(sp)
    800051da:	7282                	ld	t0,32(sp)
    800051dc:	7322                	ld	t1,40(sp)
    800051de:	73c2                	ld	t2,48(sp)
    800051e0:	7462                	ld	s0,56(sp)
    800051e2:	6486                	ld	s1,64(sp)
    800051e4:	6526                	ld	a0,72(sp)
    800051e6:	65c6                	ld	a1,80(sp)
    800051e8:	6666                	ld	a2,88(sp)
    800051ea:	7686                	ld	a3,96(sp)
    800051ec:	7726                	ld	a4,104(sp)
    800051ee:	77c6                	ld	a5,112(sp)
    800051f0:	7866                	ld	a6,120(sp)
    800051f2:	688a                	ld	a7,128(sp)
    800051f4:	692a                	ld	s2,136(sp)
    800051f6:	69ca                	ld	s3,144(sp)
    800051f8:	6a6a                	ld	s4,152(sp)
    800051fa:	7a8a                	ld	s5,160(sp)
    800051fc:	7b2a                	ld	s6,168(sp)
    800051fe:	7bca                	ld	s7,176(sp)
    80005200:	7c6a                	ld	s8,184(sp)
    80005202:	6c8e                	ld	s9,192(sp)
    80005204:	6d2e                	ld	s10,200(sp)
    80005206:	6dce                	ld	s11,208(sp)
    80005208:	6e6e                	ld	t3,216(sp)
    8000520a:	7e8e                	ld	t4,224(sp)
    8000520c:	7f2e                	ld	t5,232(sp)
    8000520e:	7fce                	ld	t6,240(sp)
    80005210:	6111                	addi	sp,sp,256
    80005212:	10200073          	sret
    80005216:	00000013          	nop
    8000521a:	00000013          	nop
    8000521e:	0001                	nop

0000000080005220 <timervec>:
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	e10c                	sd	a1,0(a0)
    80005226:	e510                	sd	a2,8(a0)
    80005228:	e914                	sd	a3,16(a0)
    8000522a:	6d0c                	ld	a1,24(a0)
    8000522c:	7110                	ld	a2,32(a0)
    8000522e:	6194                	ld	a3,0(a1)
    80005230:	96b2                	add	a3,a3,a2
    80005232:	e194                	sd	a3,0(a1)
    80005234:	4589                	li	a1,2
    80005236:	14459073          	csrw	sip,a1
    8000523a:	6914                	ld	a3,16(a0)
    8000523c:	6510                	ld	a2,8(a0)
    8000523e:	610c                	ld	a1,0(a0)
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	30200073          	mret
	...

000000008000524a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000524a:	1141                	addi	sp,sp,-16
    8000524c:	e422                	sd	s0,8(sp)
    8000524e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005250:	0c0007b7          	lui	a5,0xc000
    80005254:	4705                	li	a4,1
    80005256:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005258:	c3d8                	sw	a4,4(a5)
}
    8000525a:	6422                	ld	s0,8(sp)
    8000525c:	0141                	addi	sp,sp,16
    8000525e:	8082                	ret

0000000080005260 <plicinithart>:

void
plicinithart(void)
{
    80005260:	1141                	addi	sp,sp,-16
    80005262:	e406                	sd	ra,8(sp)
    80005264:	e022                	sd	s0,0(sp)
    80005266:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	dca080e7          	jalr	-566(ra) # 80001032 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005270:	0085171b          	slliw	a4,a0,0x8
    80005274:	0c0027b7          	lui	a5,0xc002
    80005278:	97ba                	add	a5,a5,a4
    8000527a:	40200713          	li	a4,1026
    8000527e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005282:	00d5151b          	slliw	a0,a0,0xd
    80005286:	0c2017b7          	lui	a5,0xc201
    8000528a:	953e                	add	a0,a0,a5
    8000528c:	00052023          	sw	zero,0(a0)
}
    80005290:	60a2                	ld	ra,8(sp)
    80005292:	6402                	ld	s0,0(sp)
    80005294:	0141                	addi	sp,sp,16
    80005296:	8082                	ret

0000000080005298 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005298:	1141                	addi	sp,sp,-16
    8000529a:	e406                	sd	ra,8(sp)
    8000529c:	e022                	sd	s0,0(sp)
    8000529e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	d92080e7          	jalr	-622(ra) # 80001032 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052a8:	00d5179b          	slliw	a5,a0,0xd
    800052ac:	0c201537          	lui	a0,0xc201
    800052b0:	953e                	add	a0,a0,a5
  return irq;
}
    800052b2:	4148                	lw	a0,4(a0)
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052bc:	1101                	addi	sp,sp,-32
    800052be:	ec06                	sd	ra,24(sp)
    800052c0:	e822                	sd	s0,16(sp)
    800052c2:	e426                	sd	s1,8(sp)
    800052c4:	1000                	addi	s0,sp,32
    800052c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052c8:	ffffc097          	auipc	ra,0xffffc
    800052cc:	d6a080e7          	jalr	-662(ra) # 80001032 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052d0:	00d5151b          	slliw	a0,a0,0xd
    800052d4:	0c2017b7          	lui	a5,0xc201
    800052d8:	97aa                	add	a5,a5,a0
    800052da:	c3c4                	sw	s1,4(a5)
}
    800052dc:	60e2                	ld	ra,24(sp)
    800052de:	6442                	ld	s0,16(sp)
    800052e0:	64a2                	ld	s1,8(sp)
    800052e2:	6105                	addi	sp,sp,32
    800052e4:	8082                	ret

00000000800052e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052e6:	1141                	addi	sp,sp,-16
    800052e8:	e406                	sd	ra,8(sp)
    800052ea:	e022                	sd	s0,0(sp)
    800052ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ee:	479d                	li	a5,7
    800052f0:	06a7c963          	blt	a5,a0,80005362 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800052f4:	00236797          	auipc	a5,0x236
    800052f8:	d0c78793          	addi	a5,a5,-756 # 8023b000 <disk>
    800052fc:	00a78733          	add	a4,a5,a0
    80005300:	6789                	lui	a5,0x2
    80005302:	97ba                	add	a5,a5,a4
    80005304:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005308:	e7ad                	bnez	a5,80005372 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000530a:	00451793          	slli	a5,a0,0x4
    8000530e:	00238717          	auipc	a4,0x238
    80005312:	cf270713          	addi	a4,a4,-782 # 8023d000 <disk+0x2000>
    80005316:	6314                	ld	a3,0(a4)
    80005318:	96be                	add	a3,a3,a5
    8000531a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000531e:	6314                	ld	a3,0(a4)
    80005320:	96be                	add	a3,a3,a5
    80005322:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005326:	6314                	ld	a3,0(a4)
    80005328:	96be                	add	a3,a3,a5
    8000532a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000532e:	6318                	ld	a4,0(a4)
    80005330:	97ba                	add	a5,a5,a4
    80005332:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005336:	00236797          	auipc	a5,0x236
    8000533a:	cca78793          	addi	a5,a5,-822 # 8023b000 <disk>
    8000533e:	97aa                	add	a5,a5,a0
    80005340:	6509                	lui	a0,0x2
    80005342:	953e                	add	a0,a0,a5
    80005344:	4785                	li	a5,1
    80005346:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000534a:	00238517          	auipc	a0,0x238
    8000534e:	cce50513          	addi	a0,a0,-818 # 8023d018 <disk+0x2018>
    80005352:	ffffc097          	auipc	ra,0xffffc
    80005356:	554080e7          	jalr	1364(ra) # 800018a6 <wakeup>
}
    8000535a:	60a2                	ld	ra,8(sp)
    8000535c:	6402                	ld	s0,0(sp)
    8000535e:	0141                	addi	sp,sp,16
    80005360:	8082                	ret
    panic("free_desc 1");
    80005362:	00003517          	auipc	a0,0x3
    80005366:	3ce50513          	addi	a0,a0,974 # 80008730 <syscalls+0x320>
    8000536a:	00001097          	auipc	ra,0x1
    8000536e:	a1e080e7          	jalr	-1506(ra) # 80005d88 <panic>
    panic("free_desc 2");
    80005372:	00003517          	auipc	a0,0x3
    80005376:	3ce50513          	addi	a0,a0,974 # 80008740 <syscalls+0x330>
    8000537a:	00001097          	auipc	ra,0x1
    8000537e:	a0e080e7          	jalr	-1522(ra) # 80005d88 <panic>

0000000080005382 <virtio_disk_init>:
{
    80005382:	1101                	addi	sp,sp,-32
    80005384:	ec06                	sd	ra,24(sp)
    80005386:	e822                	sd	s0,16(sp)
    80005388:	e426                	sd	s1,8(sp)
    8000538a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000538c:	00003597          	auipc	a1,0x3
    80005390:	3c458593          	addi	a1,a1,964 # 80008750 <syscalls+0x340>
    80005394:	00238517          	auipc	a0,0x238
    80005398:	d9450513          	addi	a0,a0,-620 # 8023d128 <disk+0x2128>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	ea6080e7          	jalr	-346(ra) # 80006242 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053a4:	100017b7          	lui	a5,0x10001
    800053a8:	4398                	lw	a4,0(a5)
    800053aa:	2701                	sext.w	a4,a4
    800053ac:	747277b7          	lui	a5,0x74727
    800053b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053b4:	0ef71163          	bne	a4,a5,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053b8:	100017b7          	lui	a5,0x10001
    800053bc:	43dc                	lw	a5,4(a5)
    800053be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c0:	4705                	li	a4,1
    800053c2:	0ce79a63          	bne	a5,a4,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053c6:	100017b7          	lui	a5,0x10001
    800053ca:	479c                	lw	a5,8(a5)
    800053cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ce:	4709                	li	a4,2
    800053d0:	0ce79363          	bne	a5,a4,80005496 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053d4:	100017b7          	lui	a5,0x10001
    800053d8:	47d8                	lw	a4,12(a5)
    800053da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053dc:	554d47b7          	lui	a5,0x554d4
    800053e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053e4:	0af71963          	bne	a4,a5,80005496 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053e8:	100017b7          	lui	a5,0x10001
    800053ec:	4705                	li	a4,1
    800053ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f0:	470d                	li	a4,3
    800053f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053f6:	c7ffe737          	lui	a4,0xc7ffe
    800053fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db851f>
    800053fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005400:	2701                	sext.w	a4,a4
    80005402:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005404:	472d                	li	a4,11
    80005406:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005408:	473d                	li	a4,15
    8000540a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000540c:	6705                	lui	a4,0x1
    8000540e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005410:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005414:	5bdc                	lw	a5,52(a5)
    80005416:	2781                	sext.w	a5,a5
  if(max == 0)
    80005418:	c7d9                	beqz	a5,800054a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000541a:	471d                	li	a4,7
    8000541c:	08f77d63          	bgeu	a4,a5,800054b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005420:	100014b7          	lui	s1,0x10001
    80005424:	47a1                	li	a5,8
    80005426:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005428:	6609                	lui	a2,0x2
    8000542a:	4581                	li	a1,0
    8000542c:	00236517          	auipc	a0,0x236
    80005430:	bd450513          	addi	a0,a0,-1068 # 8023b000 <disk>
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	e6c080e7          	jalr	-404(ra) # 800002a0 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000543c:	00236717          	auipc	a4,0x236
    80005440:	bc470713          	addi	a4,a4,-1084 # 8023b000 <disk>
    80005444:	00c75793          	srli	a5,a4,0xc
    80005448:	2781                	sext.w	a5,a5
    8000544a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000544c:	00238797          	auipc	a5,0x238
    80005450:	bb478793          	addi	a5,a5,-1100 # 8023d000 <disk+0x2000>
    80005454:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005456:	00236717          	auipc	a4,0x236
    8000545a:	c2a70713          	addi	a4,a4,-982 # 8023b080 <disk+0x80>
    8000545e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005460:	00237717          	auipc	a4,0x237
    80005464:	ba070713          	addi	a4,a4,-1120 # 8023c000 <disk+0x1000>
    80005468:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000546a:	4705                	li	a4,1
    8000546c:	00e78c23          	sb	a4,24(a5)
    80005470:	00e78ca3          	sb	a4,25(a5)
    80005474:	00e78d23          	sb	a4,26(a5)
    80005478:	00e78da3          	sb	a4,27(a5)
    8000547c:	00e78e23          	sb	a4,28(a5)
    80005480:	00e78ea3          	sb	a4,29(a5)
    80005484:	00e78f23          	sb	a4,30(a5)
    80005488:	00e78fa3          	sb	a4,31(a5)
}
    8000548c:	60e2                	ld	ra,24(sp)
    8000548e:	6442                	ld	s0,16(sp)
    80005490:	64a2                	ld	s1,8(sp)
    80005492:	6105                	addi	sp,sp,32
    80005494:	8082                	ret
    panic("could not find virtio disk");
    80005496:	00003517          	auipc	a0,0x3
    8000549a:	2ca50513          	addi	a0,a0,714 # 80008760 <syscalls+0x350>
    8000549e:	00001097          	auipc	ra,0x1
    800054a2:	8ea080e7          	jalr	-1814(ra) # 80005d88 <panic>
    panic("virtio disk has no queue 0");
    800054a6:	00003517          	auipc	a0,0x3
    800054aa:	2da50513          	addi	a0,a0,730 # 80008780 <syscalls+0x370>
    800054ae:	00001097          	auipc	ra,0x1
    800054b2:	8da080e7          	jalr	-1830(ra) # 80005d88 <panic>
    panic("virtio disk max queue too short");
    800054b6:	00003517          	auipc	a0,0x3
    800054ba:	2ea50513          	addi	a0,a0,746 # 800087a0 <syscalls+0x390>
    800054be:	00001097          	auipc	ra,0x1
    800054c2:	8ca080e7          	jalr	-1846(ra) # 80005d88 <panic>

00000000800054c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054c6:	7159                	addi	sp,sp,-112
    800054c8:	f486                	sd	ra,104(sp)
    800054ca:	f0a2                	sd	s0,96(sp)
    800054cc:	eca6                	sd	s1,88(sp)
    800054ce:	e8ca                	sd	s2,80(sp)
    800054d0:	e4ce                	sd	s3,72(sp)
    800054d2:	e0d2                	sd	s4,64(sp)
    800054d4:	fc56                	sd	s5,56(sp)
    800054d6:	f85a                	sd	s6,48(sp)
    800054d8:	f45e                	sd	s7,40(sp)
    800054da:	f062                	sd	s8,32(sp)
    800054dc:	ec66                	sd	s9,24(sp)
    800054de:	e86a                	sd	s10,16(sp)
    800054e0:	1880                	addi	s0,sp,112
    800054e2:	892a                	mv	s2,a0
    800054e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054e6:	00c52c83          	lw	s9,12(a0)
    800054ea:	001c9c9b          	slliw	s9,s9,0x1
    800054ee:	1c82                	slli	s9,s9,0x20
    800054f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054f4:	00238517          	auipc	a0,0x238
    800054f8:	c3450513          	addi	a0,a0,-972 # 8023d128 <disk+0x2128>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	dd6080e7          	jalr	-554(ra) # 800062d2 <acquire>
  for(int i = 0; i < 3; i++){
    80005504:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005506:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005508:	00236b97          	auipc	s7,0x236
    8000550c:	af8b8b93          	addi	s7,s7,-1288 # 8023b000 <disk>
    80005510:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005512:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005514:	8a4e                	mv	s4,s3
    80005516:	a051                	j	8000559a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005518:	00fb86b3          	add	a3,s7,a5
    8000551c:	96da                	add	a3,a3,s6
    8000551e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005522:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005524:	0207c563          	bltz	a5,8000554e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005528:	2485                	addiw	s1,s1,1
    8000552a:	0711                	addi	a4,a4,4
    8000552c:	25548063          	beq	s1,s5,8000576c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005530:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005532:	00238697          	auipc	a3,0x238
    80005536:	ae668693          	addi	a3,a3,-1306 # 8023d018 <disk+0x2018>
    8000553a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000553c:	0006c583          	lbu	a1,0(a3)
    80005540:	fde1                	bnez	a1,80005518 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005542:	2785                	addiw	a5,a5,1
    80005544:	0685                	addi	a3,a3,1
    80005546:	ff879be3          	bne	a5,s8,8000553c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000554a:	57fd                	li	a5,-1
    8000554c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000554e:	02905a63          	blez	s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005552:	f9042503          	lw	a0,-112(s0)
    80005556:	00000097          	auipc	ra,0x0
    8000555a:	d90080e7          	jalr	-624(ra) # 800052e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000555e:	4785                	li	a5,1
    80005560:	0297d163          	bge	a5,s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005564:	f9442503          	lw	a0,-108(s0)
    80005568:	00000097          	auipc	ra,0x0
    8000556c:	d7e080e7          	jalr	-642(ra) # 800052e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005570:	4789                	li	a5,2
    80005572:	0097d863          	bge	a5,s1,80005582 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005576:	f9842503          	lw	a0,-104(s0)
    8000557a:	00000097          	auipc	ra,0x0
    8000557e:	d6c080e7          	jalr	-660(ra) # 800052e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005582:	00238597          	auipc	a1,0x238
    80005586:	ba658593          	addi	a1,a1,-1114 # 8023d128 <disk+0x2128>
    8000558a:	00238517          	auipc	a0,0x238
    8000558e:	a8e50513          	addi	a0,a0,-1394 # 8023d018 <disk+0x2018>
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	188080e7          	jalr	392(ra) # 8000171a <sleep>
  for(int i = 0; i < 3; i++){
    8000559a:	f9040713          	addi	a4,s0,-112
    8000559e:	84ce                	mv	s1,s3
    800055a0:	bf41                	j	80005530 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055a2:	20058713          	addi	a4,a1,512
    800055a6:	00471693          	slli	a3,a4,0x4
    800055aa:	00236717          	auipc	a4,0x236
    800055ae:	a5670713          	addi	a4,a4,-1450 # 8023b000 <disk>
    800055b2:	9736                	add	a4,a4,a3
    800055b4:	4685                	li	a3,1
    800055b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055ba:	20058713          	addi	a4,a1,512
    800055be:	00471693          	slli	a3,a4,0x4
    800055c2:	00236717          	auipc	a4,0x236
    800055c6:	a3e70713          	addi	a4,a4,-1474 # 8023b000 <disk>
    800055ca:	9736                	add	a4,a4,a3
    800055cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055d4:	7679                	lui	a2,0xffffe
    800055d6:	963e                	add	a2,a2,a5
    800055d8:	00238697          	auipc	a3,0x238
    800055dc:	a2868693          	addi	a3,a3,-1496 # 8023d000 <disk+0x2000>
    800055e0:	6298                	ld	a4,0(a3)
    800055e2:	9732                	add	a4,a4,a2
    800055e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800055e6:	6298                	ld	a4,0(a3)
    800055e8:	9732                	add	a4,a4,a2
    800055ea:	4541                	li	a0,16
    800055ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055ee:	6298                	ld	a4,0(a3)
    800055f0:	9732                	add	a4,a4,a2
    800055f2:	4505                	li	a0,1
    800055f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800055f8:	f9442703          	lw	a4,-108(s0)
    800055fc:	6288                	ld	a0,0(a3)
    800055fe:	962a                	add	a2,a2,a0
    80005600:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7fdb7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005604:	0712                	slli	a4,a4,0x4
    80005606:	6290                	ld	a2,0(a3)
    80005608:	963a                	add	a2,a2,a4
    8000560a:	05890513          	addi	a0,s2,88
    8000560e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005610:	6294                	ld	a3,0(a3)
    80005612:	96ba                	add	a3,a3,a4
    80005614:	40000613          	li	a2,1024
    80005618:	c690                	sw	a2,8(a3)
  if(write)
    8000561a:	140d0063          	beqz	s10,8000575a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000561e:	00238697          	auipc	a3,0x238
    80005622:	9e26b683          	ld	a3,-1566(a3) # 8023d000 <disk+0x2000>
    80005626:	96ba                	add	a3,a3,a4
    80005628:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000562c:	00236817          	auipc	a6,0x236
    80005630:	9d480813          	addi	a6,a6,-1580 # 8023b000 <disk>
    80005634:	00238517          	auipc	a0,0x238
    80005638:	9cc50513          	addi	a0,a0,-1588 # 8023d000 <disk+0x2000>
    8000563c:	6114                	ld	a3,0(a0)
    8000563e:	96ba                	add	a3,a3,a4
    80005640:	00c6d603          	lhu	a2,12(a3)
    80005644:	00166613          	ori	a2,a2,1
    80005648:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000564c:	f9842683          	lw	a3,-104(s0)
    80005650:	6110                	ld	a2,0(a0)
    80005652:	9732                	add	a4,a4,a2
    80005654:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005658:	20058613          	addi	a2,a1,512
    8000565c:	0612                	slli	a2,a2,0x4
    8000565e:	9642                	add	a2,a2,a6
    80005660:	577d                	li	a4,-1
    80005662:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005666:	00469713          	slli	a4,a3,0x4
    8000566a:	6114                	ld	a3,0(a0)
    8000566c:	96ba                	add	a3,a3,a4
    8000566e:	03078793          	addi	a5,a5,48
    80005672:	97c2                	add	a5,a5,a6
    80005674:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005676:	611c                	ld	a5,0(a0)
    80005678:	97ba                	add	a5,a5,a4
    8000567a:	4685                	li	a3,1
    8000567c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000567e:	611c                	ld	a5,0(a0)
    80005680:	97ba                	add	a5,a5,a4
    80005682:	4809                	li	a6,2
    80005684:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005688:	611c                	ld	a5,0(a0)
    8000568a:	973e                	add	a4,a4,a5
    8000568c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005690:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005694:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005698:	6518                	ld	a4,8(a0)
    8000569a:	00275783          	lhu	a5,2(a4)
    8000569e:	8b9d                	andi	a5,a5,7
    800056a0:	0786                	slli	a5,a5,0x1
    800056a2:	97ba                	add	a5,a5,a4
    800056a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056ac:	6518                	ld	a4,8(a0)
    800056ae:	00275783          	lhu	a5,2(a4)
    800056b2:	2785                	addiw	a5,a5,1
    800056b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056bc:	100017b7          	lui	a5,0x10001
    800056c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056c4:	00492703          	lw	a4,4(s2)
    800056c8:	4785                	li	a5,1
    800056ca:	02f71163          	bne	a4,a5,800056ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056ce:	00238997          	auipc	s3,0x238
    800056d2:	a5a98993          	addi	s3,s3,-1446 # 8023d128 <disk+0x2128>
  while(b->disk == 1) {
    800056d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056d8:	85ce                	mv	a1,s3
    800056da:	854a                	mv	a0,s2
    800056dc:	ffffc097          	auipc	ra,0xffffc
    800056e0:	03e080e7          	jalr	62(ra) # 8000171a <sleep>
  while(b->disk == 1) {
    800056e4:	00492783          	lw	a5,4(s2)
    800056e8:	fe9788e3          	beq	a5,s1,800056d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800056ec:	f9042903          	lw	s2,-112(s0)
    800056f0:	20090793          	addi	a5,s2,512
    800056f4:	00479713          	slli	a4,a5,0x4
    800056f8:	00236797          	auipc	a5,0x236
    800056fc:	90878793          	addi	a5,a5,-1784 # 8023b000 <disk>
    80005700:	97ba                	add	a5,a5,a4
    80005702:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005706:	00238997          	auipc	s3,0x238
    8000570a:	8fa98993          	addi	s3,s3,-1798 # 8023d000 <disk+0x2000>
    8000570e:	00491713          	slli	a4,s2,0x4
    80005712:	0009b783          	ld	a5,0(s3)
    80005716:	97ba                	add	a5,a5,a4
    80005718:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000571c:	854a                	mv	a0,s2
    8000571e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005722:	00000097          	auipc	ra,0x0
    80005726:	bc4080e7          	jalr	-1084(ra) # 800052e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000572a:	8885                	andi	s1,s1,1
    8000572c:	f0ed                	bnez	s1,8000570e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000572e:	00238517          	auipc	a0,0x238
    80005732:	9fa50513          	addi	a0,a0,-1542 # 8023d128 <disk+0x2128>
    80005736:	00001097          	auipc	ra,0x1
    8000573a:	c50080e7          	jalr	-944(ra) # 80006386 <release>
}
    8000573e:	70a6                	ld	ra,104(sp)
    80005740:	7406                	ld	s0,96(sp)
    80005742:	64e6                	ld	s1,88(sp)
    80005744:	6946                	ld	s2,80(sp)
    80005746:	69a6                	ld	s3,72(sp)
    80005748:	6a06                	ld	s4,64(sp)
    8000574a:	7ae2                	ld	s5,56(sp)
    8000574c:	7b42                	ld	s6,48(sp)
    8000574e:	7ba2                	ld	s7,40(sp)
    80005750:	7c02                	ld	s8,32(sp)
    80005752:	6ce2                	ld	s9,24(sp)
    80005754:	6d42                	ld	s10,16(sp)
    80005756:	6165                	addi	sp,sp,112
    80005758:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000575a:	00238697          	auipc	a3,0x238
    8000575e:	8a66b683          	ld	a3,-1882(a3) # 8023d000 <disk+0x2000>
    80005762:	96ba                	add	a3,a3,a4
    80005764:	4609                	li	a2,2
    80005766:	00c69623          	sh	a2,12(a3)
    8000576a:	b5c9                	j	8000562c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000576c:	f9042583          	lw	a1,-112(s0)
    80005770:	20058793          	addi	a5,a1,512
    80005774:	0792                	slli	a5,a5,0x4
    80005776:	00236517          	auipc	a0,0x236
    8000577a:	93250513          	addi	a0,a0,-1742 # 8023b0a8 <disk+0xa8>
    8000577e:	953e                	add	a0,a0,a5
  if(write)
    80005780:	e20d11e3          	bnez	s10,800055a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005784:	20058713          	addi	a4,a1,512
    80005788:	00471693          	slli	a3,a4,0x4
    8000578c:	00236717          	auipc	a4,0x236
    80005790:	87470713          	addi	a4,a4,-1932 # 8023b000 <disk>
    80005794:	9736                	add	a4,a4,a3
    80005796:	0a072423          	sw	zero,168(a4)
    8000579a:	b505                	j	800055ba <virtio_disk_rw+0xf4>

000000008000579c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000579c:	1101                	addi	sp,sp,-32
    8000579e:	ec06                	sd	ra,24(sp)
    800057a0:	e822                	sd	s0,16(sp)
    800057a2:	e426                	sd	s1,8(sp)
    800057a4:	e04a                	sd	s2,0(sp)
    800057a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057a8:	00238517          	auipc	a0,0x238
    800057ac:	98050513          	addi	a0,a0,-1664 # 8023d128 <disk+0x2128>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	b22080e7          	jalr	-1246(ra) # 800062d2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057b8:	10001737          	lui	a4,0x10001
    800057bc:	533c                	lw	a5,96(a4)
    800057be:	8b8d                	andi	a5,a5,3
    800057c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057c6:	00238797          	auipc	a5,0x238
    800057ca:	83a78793          	addi	a5,a5,-1990 # 8023d000 <disk+0x2000>
    800057ce:	6b94                	ld	a3,16(a5)
    800057d0:	0207d703          	lhu	a4,32(a5)
    800057d4:	0026d783          	lhu	a5,2(a3)
    800057d8:	06f70163          	beq	a4,a5,8000583a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057dc:	00236917          	auipc	s2,0x236
    800057e0:	82490913          	addi	s2,s2,-2012 # 8023b000 <disk>
    800057e4:	00238497          	auipc	s1,0x238
    800057e8:	81c48493          	addi	s1,s1,-2020 # 8023d000 <disk+0x2000>
    __sync_synchronize();
    800057ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057f0:	6898                	ld	a4,16(s1)
    800057f2:	0204d783          	lhu	a5,32(s1)
    800057f6:	8b9d                	andi	a5,a5,7
    800057f8:	078e                	slli	a5,a5,0x3
    800057fa:	97ba                	add	a5,a5,a4
    800057fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057fe:	20078713          	addi	a4,a5,512
    80005802:	0712                	slli	a4,a4,0x4
    80005804:	974a                	add	a4,a4,s2
    80005806:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000580a:	e731                	bnez	a4,80005856 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000580c:	20078793          	addi	a5,a5,512
    80005810:	0792                	slli	a5,a5,0x4
    80005812:	97ca                	add	a5,a5,s2
    80005814:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005816:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000581a:	ffffc097          	auipc	ra,0xffffc
    8000581e:	08c080e7          	jalr	140(ra) # 800018a6 <wakeup>

    disk.used_idx += 1;
    80005822:	0204d783          	lhu	a5,32(s1)
    80005826:	2785                	addiw	a5,a5,1
    80005828:	17c2                	slli	a5,a5,0x30
    8000582a:	93c1                	srli	a5,a5,0x30
    8000582c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005830:	6898                	ld	a4,16(s1)
    80005832:	00275703          	lhu	a4,2(a4)
    80005836:	faf71be3          	bne	a4,a5,800057ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000583a:	00238517          	auipc	a0,0x238
    8000583e:	8ee50513          	addi	a0,a0,-1810 # 8023d128 <disk+0x2128>
    80005842:	00001097          	auipc	ra,0x1
    80005846:	b44080e7          	jalr	-1212(ra) # 80006386 <release>
}
    8000584a:	60e2                	ld	ra,24(sp)
    8000584c:	6442                	ld	s0,16(sp)
    8000584e:	64a2                	ld	s1,8(sp)
    80005850:	6902                	ld	s2,0(sp)
    80005852:	6105                	addi	sp,sp,32
    80005854:	8082                	ret
      panic("virtio_disk_intr status");
    80005856:	00003517          	auipc	a0,0x3
    8000585a:	f6a50513          	addi	a0,a0,-150 # 800087c0 <syscalls+0x3b0>
    8000585e:	00000097          	auipc	ra,0x0
    80005862:	52a080e7          	jalr	1322(ra) # 80005d88 <panic>

0000000080005866 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005866:	1141                	addi	sp,sp,-16
    80005868:	e422                	sd	s0,8(sp)
    8000586a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000586c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005870:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005874:	0037979b          	slliw	a5,a5,0x3
    80005878:	02004737          	lui	a4,0x2004
    8000587c:	97ba                	add	a5,a5,a4
    8000587e:	0200c737          	lui	a4,0x200c
    80005882:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005886:	000f4637          	lui	a2,0xf4
    8000588a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000588e:	95b2                	add	a1,a1,a2
    80005890:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005892:	00269713          	slli	a4,a3,0x2
    80005896:	9736                	add	a4,a4,a3
    80005898:	00371693          	slli	a3,a4,0x3
    8000589c:	00238717          	auipc	a4,0x238
    800058a0:	76470713          	addi	a4,a4,1892 # 8023e000 <timer_scratch>
    800058a4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058a6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058a8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058aa:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ae:	00000797          	auipc	a5,0x0
    800058b2:	97278793          	addi	a5,a5,-1678 # 80005220 <timervec>
    800058b6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ba:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058be:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058c6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058ca:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058ce:	30479073          	csrw	mie,a5
}
    800058d2:	6422                	ld	s0,8(sp)
    800058d4:	0141                	addi	sp,sp,16
    800058d6:	8082                	ret

00000000800058d8 <start>:
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e406                	sd	ra,8(sp)
    800058dc:	e022                	sd	s0,0(sp)
    800058de:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058e0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058e4:	7779                	lui	a4,0xffffe
    800058e6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb85bf>
    800058ea:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058ec:	6705                	lui	a4,0x1
    800058ee:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058f2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058f4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058f8:	ffffb797          	auipc	a5,0xffffb
    800058fc:	b5678793          	addi	a5,a5,-1194 # 8000044e <main>
    80005900:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005904:	4781                	li	a5,0
    80005906:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000590a:	67c1                	lui	a5,0x10
    8000590c:	17fd                	addi	a5,a5,-1
    8000590e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005912:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005916:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000591a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000591e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005922:	57fd                	li	a5,-1
    80005924:	83a9                	srli	a5,a5,0xa
    80005926:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000592a:	47bd                	li	a5,15
    8000592c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005930:	00000097          	auipc	ra,0x0
    80005934:	f36080e7          	jalr	-202(ra) # 80005866 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005938:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000593c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000593e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005940:	30200073          	mret
}
    80005944:	60a2                	ld	ra,8(sp)
    80005946:	6402                	ld	s0,0(sp)
    80005948:	0141                	addi	sp,sp,16
    8000594a:	8082                	ret

000000008000594c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000594c:	715d                	addi	sp,sp,-80
    8000594e:	e486                	sd	ra,72(sp)
    80005950:	e0a2                	sd	s0,64(sp)
    80005952:	fc26                	sd	s1,56(sp)
    80005954:	f84a                	sd	s2,48(sp)
    80005956:	f44e                	sd	s3,40(sp)
    80005958:	f052                	sd	s4,32(sp)
    8000595a:	ec56                	sd	s5,24(sp)
    8000595c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000595e:	04c05663          	blez	a2,800059aa <consolewrite+0x5e>
    80005962:	8a2a                	mv	s4,a0
    80005964:	84ae                	mv	s1,a1
    80005966:	89b2                	mv	s3,a2
    80005968:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000596a:	5afd                	li	s5,-1
    8000596c:	4685                	li	a3,1
    8000596e:	8626                	mv	a2,s1
    80005970:	85d2                	mv	a1,s4
    80005972:	fbf40513          	addi	a0,s0,-65
    80005976:	ffffc097          	auipc	ra,0xffffc
    8000597a:	19e080e7          	jalr	414(ra) # 80001b14 <either_copyin>
    8000597e:	01550c63          	beq	a0,s5,80005996 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005982:	fbf44503          	lbu	a0,-65(s0)
    80005986:	00000097          	auipc	ra,0x0
    8000598a:	78e080e7          	jalr	1934(ra) # 80006114 <uartputc>
  for(i = 0; i < n; i++){
    8000598e:	2905                	addiw	s2,s2,1
    80005990:	0485                	addi	s1,s1,1
    80005992:	fd299de3          	bne	s3,s2,8000596c <consolewrite+0x20>
  }

  return i;
}
    80005996:	854a                	mv	a0,s2
    80005998:	60a6                	ld	ra,72(sp)
    8000599a:	6406                	ld	s0,64(sp)
    8000599c:	74e2                	ld	s1,56(sp)
    8000599e:	7942                	ld	s2,48(sp)
    800059a0:	79a2                	ld	s3,40(sp)
    800059a2:	7a02                	ld	s4,32(sp)
    800059a4:	6ae2                	ld	s5,24(sp)
    800059a6:	6161                	addi	sp,sp,80
    800059a8:	8082                	ret
  for(i = 0; i < n; i++){
    800059aa:	4901                	li	s2,0
    800059ac:	b7ed                	j	80005996 <consolewrite+0x4a>

00000000800059ae <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ae:	7119                	addi	sp,sp,-128
    800059b0:	fc86                	sd	ra,120(sp)
    800059b2:	f8a2                	sd	s0,112(sp)
    800059b4:	f4a6                	sd	s1,104(sp)
    800059b6:	f0ca                	sd	s2,96(sp)
    800059b8:	ecce                	sd	s3,88(sp)
    800059ba:	e8d2                	sd	s4,80(sp)
    800059bc:	e4d6                	sd	s5,72(sp)
    800059be:	e0da                	sd	s6,64(sp)
    800059c0:	fc5e                	sd	s7,56(sp)
    800059c2:	f862                	sd	s8,48(sp)
    800059c4:	f466                	sd	s9,40(sp)
    800059c6:	f06a                	sd	s10,32(sp)
    800059c8:	ec6e                	sd	s11,24(sp)
    800059ca:	0100                	addi	s0,sp,128
    800059cc:	8b2a                	mv	s6,a0
    800059ce:	8aae                	mv	s5,a1
    800059d0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059d2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059d6:	00240517          	auipc	a0,0x240
    800059da:	76a50513          	addi	a0,a0,1898 # 80246140 <cons>
    800059de:	00001097          	auipc	ra,0x1
    800059e2:	8f4080e7          	jalr	-1804(ra) # 800062d2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059e6:	00240497          	auipc	s1,0x240
    800059ea:	75a48493          	addi	s1,s1,1882 # 80246140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059ee:	89a6                	mv	s3,s1
    800059f0:	00240917          	auipc	s2,0x240
    800059f4:	7e890913          	addi	s2,s2,2024 # 802461d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800059f8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059fa:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059fc:	4da9                	li	s11,10
  while(n > 0){
    800059fe:	07405863          	blez	s4,80005a6e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a02:	0984a783          	lw	a5,152(s1)
    80005a06:	09c4a703          	lw	a4,156(s1)
    80005a0a:	02f71463          	bne	a4,a5,80005a32 <consoleread+0x84>
      if(myproc()->killed){
    80005a0e:	ffffb097          	auipc	ra,0xffffb
    80005a12:	650080e7          	jalr	1616(ra) # 8000105e <myproc>
    80005a16:	551c                	lw	a5,40(a0)
    80005a18:	e7b5                	bnez	a5,80005a84 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a1a:	85ce                	mv	a1,s3
    80005a1c:	854a                	mv	a0,s2
    80005a1e:	ffffc097          	auipc	ra,0xffffc
    80005a22:	cfc080e7          	jalr	-772(ra) # 8000171a <sleep>
    while(cons.r == cons.w){
    80005a26:	0984a783          	lw	a5,152(s1)
    80005a2a:	09c4a703          	lw	a4,156(s1)
    80005a2e:	fef700e3          	beq	a4,a5,80005a0e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a32:	0017871b          	addiw	a4,a5,1
    80005a36:	08e4ac23          	sw	a4,152(s1)
    80005a3a:	07f7f713          	andi	a4,a5,127
    80005a3e:	9726                	add	a4,a4,s1
    80005a40:	01874703          	lbu	a4,24(a4)
    80005a44:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a48:	079c0663          	beq	s8,s9,80005ab4 <consoleread+0x106>
    cbuf = c;
    80005a4c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a50:	4685                	li	a3,1
    80005a52:	f8f40613          	addi	a2,s0,-113
    80005a56:	85d6                	mv	a1,s5
    80005a58:	855a                	mv	a0,s6
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	064080e7          	jalr	100(ra) # 80001abe <either_copyout>
    80005a62:	01a50663          	beq	a0,s10,80005a6e <consoleread+0xc0>
    dst++;
    80005a66:	0a85                	addi	s5,s5,1
    --n;
    80005a68:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a6a:	f9bc1ae3          	bne	s8,s11,800059fe <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a6e:	00240517          	auipc	a0,0x240
    80005a72:	6d250513          	addi	a0,a0,1746 # 80246140 <cons>
    80005a76:	00001097          	auipc	ra,0x1
    80005a7a:	910080e7          	jalr	-1776(ra) # 80006386 <release>

  return target - n;
    80005a7e:	414b853b          	subw	a0,s7,s4
    80005a82:	a811                	j	80005a96 <consoleread+0xe8>
        release(&cons.lock);
    80005a84:	00240517          	auipc	a0,0x240
    80005a88:	6bc50513          	addi	a0,a0,1724 # 80246140 <cons>
    80005a8c:	00001097          	auipc	ra,0x1
    80005a90:	8fa080e7          	jalr	-1798(ra) # 80006386 <release>
        return -1;
    80005a94:	557d                	li	a0,-1
}
    80005a96:	70e6                	ld	ra,120(sp)
    80005a98:	7446                	ld	s0,112(sp)
    80005a9a:	74a6                	ld	s1,104(sp)
    80005a9c:	7906                	ld	s2,96(sp)
    80005a9e:	69e6                	ld	s3,88(sp)
    80005aa0:	6a46                	ld	s4,80(sp)
    80005aa2:	6aa6                	ld	s5,72(sp)
    80005aa4:	6b06                	ld	s6,64(sp)
    80005aa6:	7be2                	ld	s7,56(sp)
    80005aa8:	7c42                	ld	s8,48(sp)
    80005aaa:	7ca2                	ld	s9,40(sp)
    80005aac:	7d02                	ld	s10,32(sp)
    80005aae:	6de2                	ld	s11,24(sp)
    80005ab0:	6109                	addi	sp,sp,128
    80005ab2:	8082                	ret
      if(n < target){
    80005ab4:	000a071b          	sext.w	a4,s4
    80005ab8:	fb777be3          	bgeu	a4,s7,80005a6e <consoleread+0xc0>
        cons.r--;
    80005abc:	00240717          	auipc	a4,0x240
    80005ac0:	70f72e23          	sw	a5,1820(a4) # 802461d8 <cons+0x98>
    80005ac4:	b76d                	j	80005a6e <consoleread+0xc0>

0000000080005ac6 <consputc>:
{
    80005ac6:	1141                	addi	sp,sp,-16
    80005ac8:	e406                	sd	ra,8(sp)
    80005aca:	e022                	sd	s0,0(sp)
    80005acc:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ace:	10000793          	li	a5,256
    80005ad2:	00f50a63          	beq	a0,a5,80005ae6 <consputc+0x20>
    uartputc_sync(c);
    80005ad6:	00000097          	auipc	ra,0x0
    80005ada:	564080e7          	jalr	1380(ra) # 8000603a <uartputc_sync>
}
    80005ade:	60a2                	ld	ra,8(sp)
    80005ae0:	6402                	ld	s0,0(sp)
    80005ae2:	0141                	addi	sp,sp,16
    80005ae4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae6:	4521                	li	a0,8
    80005ae8:	00000097          	auipc	ra,0x0
    80005aec:	552080e7          	jalr	1362(ra) # 8000603a <uartputc_sync>
    80005af0:	02000513          	li	a0,32
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	546080e7          	jalr	1350(ra) # 8000603a <uartputc_sync>
    80005afc:	4521                	li	a0,8
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	53c080e7          	jalr	1340(ra) # 8000603a <uartputc_sync>
    80005b06:	bfe1                	j	80005ade <consputc+0x18>

0000000080005b08 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b08:	1101                	addi	sp,sp,-32
    80005b0a:	ec06                	sd	ra,24(sp)
    80005b0c:	e822                	sd	s0,16(sp)
    80005b0e:	e426                	sd	s1,8(sp)
    80005b10:	e04a                	sd	s2,0(sp)
    80005b12:	1000                	addi	s0,sp,32
    80005b14:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b16:	00240517          	auipc	a0,0x240
    80005b1a:	62a50513          	addi	a0,a0,1578 # 80246140 <cons>
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	7b4080e7          	jalr	1972(ra) # 800062d2 <acquire>

  switch(c){
    80005b26:	47d5                	li	a5,21
    80005b28:	0af48663          	beq	s1,a5,80005bd4 <consoleintr+0xcc>
    80005b2c:	0297ca63          	blt	a5,s1,80005b60 <consoleintr+0x58>
    80005b30:	47a1                	li	a5,8
    80005b32:	0ef48763          	beq	s1,a5,80005c20 <consoleintr+0x118>
    80005b36:	47c1                	li	a5,16
    80005b38:	10f49a63          	bne	s1,a5,80005c4c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b3c:	ffffc097          	auipc	ra,0xffffc
    80005b40:	02e080e7          	jalr	46(ra) # 80001b6a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b44:	00240517          	auipc	a0,0x240
    80005b48:	5fc50513          	addi	a0,a0,1532 # 80246140 <cons>
    80005b4c:	00001097          	auipc	ra,0x1
    80005b50:	83a080e7          	jalr	-1990(ra) # 80006386 <release>
}
    80005b54:	60e2                	ld	ra,24(sp)
    80005b56:	6442                	ld	s0,16(sp)
    80005b58:	64a2                	ld	s1,8(sp)
    80005b5a:	6902                	ld	s2,0(sp)
    80005b5c:	6105                	addi	sp,sp,32
    80005b5e:	8082                	ret
  switch(c){
    80005b60:	07f00793          	li	a5,127
    80005b64:	0af48e63          	beq	s1,a5,80005c20 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b68:	00240717          	auipc	a4,0x240
    80005b6c:	5d870713          	addi	a4,a4,1496 # 80246140 <cons>
    80005b70:	0a072783          	lw	a5,160(a4)
    80005b74:	09872703          	lw	a4,152(a4)
    80005b78:	9f99                	subw	a5,a5,a4
    80005b7a:	07f00713          	li	a4,127
    80005b7e:	fcf763e3          	bltu	a4,a5,80005b44 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b82:	47b5                	li	a5,13
    80005b84:	0cf48763          	beq	s1,a5,80005c52 <consoleintr+0x14a>
      consputc(c);
    80005b88:	8526                	mv	a0,s1
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	f3c080e7          	jalr	-196(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b92:	00240797          	auipc	a5,0x240
    80005b96:	5ae78793          	addi	a5,a5,1454 # 80246140 <cons>
    80005b9a:	0a07a703          	lw	a4,160(a5)
    80005b9e:	0017069b          	addiw	a3,a4,1
    80005ba2:	0006861b          	sext.w	a2,a3
    80005ba6:	0ad7a023          	sw	a3,160(a5)
    80005baa:	07f77713          	andi	a4,a4,127
    80005bae:	97ba                	add	a5,a5,a4
    80005bb0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bb4:	47a9                	li	a5,10
    80005bb6:	0cf48563          	beq	s1,a5,80005c80 <consoleintr+0x178>
    80005bba:	4791                	li	a5,4
    80005bbc:	0cf48263          	beq	s1,a5,80005c80 <consoleintr+0x178>
    80005bc0:	00240797          	auipc	a5,0x240
    80005bc4:	6187a783          	lw	a5,1560(a5) # 802461d8 <cons+0x98>
    80005bc8:	0807879b          	addiw	a5,a5,128
    80005bcc:	f6f61ce3          	bne	a2,a5,80005b44 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bd0:	863e                	mv	a2,a5
    80005bd2:	a07d                	j	80005c80 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bd4:	00240717          	auipc	a4,0x240
    80005bd8:	56c70713          	addi	a4,a4,1388 # 80246140 <cons>
    80005bdc:	0a072783          	lw	a5,160(a4)
    80005be0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005be4:	00240497          	auipc	s1,0x240
    80005be8:	55c48493          	addi	s1,s1,1372 # 80246140 <cons>
    while(cons.e != cons.w &&
    80005bec:	4929                	li	s2,10
    80005bee:	f4f70be3          	beq	a4,a5,80005b44 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bf2:	37fd                	addiw	a5,a5,-1
    80005bf4:	07f7f713          	andi	a4,a5,127
    80005bf8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bfa:	01874703          	lbu	a4,24(a4)
    80005bfe:	f52703e3          	beq	a4,s2,80005b44 <consoleintr+0x3c>
      cons.e--;
    80005c02:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c06:	10000513          	li	a0,256
    80005c0a:	00000097          	auipc	ra,0x0
    80005c0e:	ebc080e7          	jalr	-324(ra) # 80005ac6 <consputc>
    while(cons.e != cons.w &&
    80005c12:	0a04a783          	lw	a5,160(s1)
    80005c16:	09c4a703          	lw	a4,156(s1)
    80005c1a:	fcf71ce3          	bne	a4,a5,80005bf2 <consoleintr+0xea>
    80005c1e:	b71d                	j	80005b44 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c20:	00240717          	auipc	a4,0x240
    80005c24:	52070713          	addi	a4,a4,1312 # 80246140 <cons>
    80005c28:	0a072783          	lw	a5,160(a4)
    80005c2c:	09c72703          	lw	a4,156(a4)
    80005c30:	f0f70ae3          	beq	a4,a5,80005b44 <consoleintr+0x3c>
      cons.e--;
    80005c34:	37fd                	addiw	a5,a5,-1
    80005c36:	00240717          	auipc	a4,0x240
    80005c3a:	5af72523          	sw	a5,1450(a4) # 802461e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c3e:	10000513          	li	a0,256
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	e84080e7          	jalr	-380(ra) # 80005ac6 <consputc>
    80005c4a:	bded                	j	80005b44 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c4c:	ee048ce3          	beqz	s1,80005b44 <consoleintr+0x3c>
    80005c50:	bf21                	j	80005b68 <consoleintr+0x60>
      consputc(c);
    80005c52:	4529                	li	a0,10
    80005c54:	00000097          	auipc	ra,0x0
    80005c58:	e72080e7          	jalr	-398(ra) # 80005ac6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c5c:	00240797          	auipc	a5,0x240
    80005c60:	4e478793          	addi	a5,a5,1252 # 80246140 <cons>
    80005c64:	0a07a703          	lw	a4,160(a5)
    80005c68:	0017069b          	addiw	a3,a4,1
    80005c6c:	0006861b          	sext.w	a2,a3
    80005c70:	0ad7a023          	sw	a3,160(a5)
    80005c74:	07f77713          	andi	a4,a4,127
    80005c78:	97ba                	add	a5,a5,a4
    80005c7a:	4729                	li	a4,10
    80005c7c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c80:	00240797          	auipc	a5,0x240
    80005c84:	54c7ae23          	sw	a2,1372(a5) # 802461dc <cons+0x9c>
        wakeup(&cons.r);
    80005c88:	00240517          	auipc	a0,0x240
    80005c8c:	55050513          	addi	a0,a0,1360 # 802461d8 <cons+0x98>
    80005c90:	ffffc097          	auipc	ra,0xffffc
    80005c94:	c16080e7          	jalr	-1002(ra) # 800018a6 <wakeup>
    80005c98:	b575                	j	80005b44 <consoleintr+0x3c>

0000000080005c9a <consoleinit>:

void
consoleinit(void)
{
    80005c9a:	1141                	addi	sp,sp,-16
    80005c9c:	e406                	sd	ra,8(sp)
    80005c9e:	e022                	sd	s0,0(sp)
    80005ca0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ca2:	00003597          	auipc	a1,0x3
    80005ca6:	b3658593          	addi	a1,a1,-1226 # 800087d8 <syscalls+0x3c8>
    80005caa:	00240517          	auipc	a0,0x240
    80005cae:	49650513          	addi	a0,a0,1174 # 80246140 <cons>
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	590080e7          	jalr	1424(ra) # 80006242 <initlock>

  uartinit();
    80005cba:	00000097          	auipc	ra,0x0
    80005cbe:	330080e7          	jalr	816(ra) # 80005fea <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cc2:	00233797          	auipc	a5,0x233
    80005cc6:	41e78793          	addi	a5,a5,1054 # 802390e0 <devsw>
    80005cca:	00000717          	auipc	a4,0x0
    80005cce:	ce470713          	addi	a4,a4,-796 # 800059ae <consoleread>
    80005cd2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cd4:	00000717          	auipc	a4,0x0
    80005cd8:	c7870713          	addi	a4,a4,-904 # 8000594c <consolewrite>
    80005cdc:	ef98                	sd	a4,24(a5)
}
    80005cde:	60a2                	ld	ra,8(sp)
    80005ce0:	6402                	ld	s0,0(sp)
    80005ce2:	0141                	addi	sp,sp,16
    80005ce4:	8082                	ret

0000000080005ce6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ce6:	7179                	addi	sp,sp,-48
    80005ce8:	f406                	sd	ra,40(sp)
    80005cea:	f022                	sd	s0,32(sp)
    80005cec:	ec26                	sd	s1,24(sp)
    80005cee:	e84a                	sd	s2,16(sp)
    80005cf0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cf2:	c219                	beqz	a2,80005cf8 <printint+0x12>
    80005cf4:	08054663          	bltz	a0,80005d80 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cf8:	2501                	sext.w	a0,a0
    80005cfa:	4881                	li	a7,0
    80005cfc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d00:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d02:	2581                	sext.w	a1,a1
    80005d04:	00003617          	auipc	a2,0x3
    80005d08:	b0460613          	addi	a2,a2,-1276 # 80008808 <digits>
    80005d0c:	883a                	mv	a6,a4
    80005d0e:	2705                	addiw	a4,a4,1
    80005d10:	02b577bb          	remuw	a5,a0,a1
    80005d14:	1782                	slli	a5,a5,0x20
    80005d16:	9381                	srli	a5,a5,0x20
    80005d18:	97b2                	add	a5,a5,a2
    80005d1a:	0007c783          	lbu	a5,0(a5)
    80005d1e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d22:	0005079b          	sext.w	a5,a0
    80005d26:	02b5553b          	divuw	a0,a0,a1
    80005d2a:	0685                	addi	a3,a3,1
    80005d2c:	feb7f0e3          	bgeu	a5,a1,80005d0c <printint+0x26>

  if(sign)
    80005d30:	00088b63          	beqz	a7,80005d46 <printint+0x60>
    buf[i++] = '-';
    80005d34:	fe040793          	addi	a5,s0,-32
    80005d38:	973e                	add	a4,a4,a5
    80005d3a:	02d00793          	li	a5,45
    80005d3e:	fef70823          	sb	a5,-16(a4)
    80005d42:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d46:	02e05763          	blez	a4,80005d74 <printint+0x8e>
    80005d4a:	fd040793          	addi	a5,s0,-48
    80005d4e:	00e784b3          	add	s1,a5,a4
    80005d52:	fff78913          	addi	s2,a5,-1
    80005d56:	993a                	add	s2,s2,a4
    80005d58:	377d                	addiw	a4,a4,-1
    80005d5a:	1702                	slli	a4,a4,0x20
    80005d5c:	9301                	srli	a4,a4,0x20
    80005d5e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d62:	fff4c503          	lbu	a0,-1(s1)
    80005d66:	00000097          	auipc	ra,0x0
    80005d6a:	d60080e7          	jalr	-672(ra) # 80005ac6 <consputc>
  while(--i >= 0)
    80005d6e:	14fd                	addi	s1,s1,-1
    80005d70:	ff2499e3          	bne	s1,s2,80005d62 <printint+0x7c>
}
    80005d74:	70a2                	ld	ra,40(sp)
    80005d76:	7402                	ld	s0,32(sp)
    80005d78:	64e2                	ld	s1,24(sp)
    80005d7a:	6942                	ld	s2,16(sp)
    80005d7c:	6145                	addi	sp,sp,48
    80005d7e:	8082                	ret
    x = -xx;
    80005d80:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d84:	4885                	li	a7,1
    x = -xx;
    80005d86:	bf9d                	j	80005cfc <printint+0x16>

0000000080005d88 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d88:	1101                	addi	sp,sp,-32
    80005d8a:	ec06                	sd	ra,24(sp)
    80005d8c:	e822                	sd	s0,16(sp)
    80005d8e:	e426                	sd	s1,8(sp)
    80005d90:	1000                	addi	s0,sp,32
    80005d92:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d94:	00240797          	auipc	a5,0x240
    80005d98:	4607a623          	sw	zero,1132(a5) # 80246200 <pr+0x18>
  printf("panic: ");
    80005d9c:	00003517          	auipc	a0,0x3
    80005da0:	a4450513          	addi	a0,a0,-1468 # 800087e0 <syscalls+0x3d0>
    80005da4:	00000097          	auipc	ra,0x0
    80005da8:	02e080e7          	jalr	46(ra) # 80005dd2 <printf>
  printf(s);
    80005dac:	8526                	mv	a0,s1
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	024080e7          	jalr	36(ra) # 80005dd2 <printf>
  printf("\n");
    80005db6:	00002517          	auipc	a0,0x2
    80005dba:	2ba50513          	addi	a0,a0,698 # 80008070 <etext+0x70>
    80005dbe:	00000097          	auipc	ra,0x0
    80005dc2:	014080e7          	jalr	20(ra) # 80005dd2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dc6:	4785                	li	a5,1
    80005dc8:	00003717          	auipc	a4,0x3
    80005dcc:	24f72a23          	sw	a5,596(a4) # 8000901c <panicked>
  for(;;)
    80005dd0:	a001                	j	80005dd0 <panic+0x48>

0000000080005dd2 <printf>:
{
    80005dd2:	7131                	addi	sp,sp,-192
    80005dd4:	fc86                	sd	ra,120(sp)
    80005dd6:	f8a2                	sd	s0,112(sp)
    80005dd8:	f4a6                	sd	s1,104(sp)
    80005dda:	f0ca                	sd	s2,96(sp)
    80005ddc:	ecce                	sd	s3,88(sp)
    80005dde:	e8d2                	sd	s4,80(sp)
    80005de0:	e4d6                	sd	s5,72(sp)
    80005de2:	e0da                	sd	s6,64(sp)
    80005de4:	fc5e                	sd	s7,56(sp)
    80005de6:	f862                	sd	s8,48(sp)
    80005de8:	f466                	sd	s9,40(sp)
    80005dea:	f06a                	sd	s10,32(sp)
    80005dec:	ec6e                	sd	s11,24(sp)
    80005dee:	0100                	addi	s0,sp,128
    80005df0:	8a2a                	mv	s4,a0
    80005df2:	e40c                	sd	a1,8(s0)
    80005df4:	e810                	sd	a2,16(s0)
    80005df6:	ec14                	sd	a3,24(s0)
    80005df8:	f018                	sd	a4,32(s0)
    80005dfa:	f41c                	sd	a5,40(s0)
    80005dfc:	03043823          	sd	a6,48(s0)
    80005e00:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e04:	00240d97          	auipc	s11,0x240
    80005e08:	3fcdad83          	lw	s11,1020(s11) # 80246200 <pr+0x18>
  if(locking)
    80005e0c:	020d9b63          	bnez	s11,80005e42 <printf+0x70>
  if (fmt == 0)
    80005e10:	040a0263          	beqz	s4,80005e54 <printf+0x82>
  va_start(ap, fmt);
    80005e14:	00840793          	addi	a5,s0,8
    80005e18:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e1c:	000a4503          	lbu	a0,0(s4)
    80005e20:	16050263          	beqz	a0,80005f84 <printf+0x1b2>
    80005e24:	4481                	li	s1,0
    if(c != '%'){
    80005e26:	02500a93          	li	s5,37
    switch(c){
    80005e2a:	07000b13          	li	s6,112
  consputc('x');
    80005e2e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e30:	00003b97          	auipc	s7,0x3
    80005e34:	9d8b8b93          	addi	s7,s7,-1576 # 80008808 <digits>
    switch(c){
    80005e38:	07300c93          	li	s9,115
    80005e3c:	06400c13          	li	s8,100
    80005e40:	a82d                	j	80005e7a <printf+0xa8>
    acquire(&pr.lock);
    80005e42:	00240517          	auipc	a0,0x240
    80005e46:	3a650513          	addi	a0,a0,934 # 802461e8 <pr>
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	488080e7          	jalr	1160(ra) # 800062d2 <acquire>
    80005e52:	bf7d                	j	80005e10 <printf+0x3e>
    panic("null fmt");
    80005e54:	00003517          	auipc	a0,0x3
    80005e58:	99c50513          	addi	a0,a0,-1636 # 800087f0 <syscalls+0x3e0>
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	f2c080e7          	jalr	-212(ra) # 80005d88 <panic>
      consputc(c);
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	c62080e7          	jalr	-926(ra) # 80005ac6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e6c:	2485                	addiw	s1,s1,1
    80005e6e:	009a07b3          	add	a5,s4,s1
    80005e72:	0007c503          	lbu	a0,0(a5)
    80005e76:	10050763          	beqz	a0,80005f84 <printf+0x1b2>
    if(c != '%'){
    80005e7a:	ff5515e3          	bne	a0,s5,80005e64 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e7e:	2485                	addiw	s1,s1,1
    80005e80:	009a07b3          	add	a5,s4,s1
    80005e84:	0007c783          	lbu	a5,0(a5)
    80005e88:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e8c:	cfe5                	beqz	a5,80005f84 <printf+0x1b2>
    switch(c){
    80005e8e:	05678a63          	beq	a5,s6,80005ee2 <printf+0x110>
    80005e92:	02fb7663          	bgeu	s6,a5,80005ebe <printf+0xec>
    80005e96:	09978963          	beq	a5,s9,80005f28 <printf+0x156>
    80005e9a:	07800713          	li	a4,120
    80005e9e:	0ce79863          	bne	a5,a4,80005f6e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ea2:	f8843783          	ld	a5,-120(s0)
    80005ea6:	00878713          	addi	a4,a5,8
    80005eaa:	f8e43423          	sd	a4,-120(s0)
    80005eae:	4605                	li	a2,1
    80005eb0:	85ea                	mv	a1,s10
    80005eb2:	4388                	lw	a0,0(a5)
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	e32080e7          	jalr	-462(ra) # 80005ce6 <printint>
      break;
    80005ebc:	bf45                	j	80005e6c <printf+0x9a>
    switch(c){
    80005ebe:	0b578263          	beq	a5,s5,80005f62 <printf+0x190>
    80005ec2:	0b879663          	bne	a5,s8,80005f6e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ec6:	f8843783          	ld	a5,-120(s0)
    80005eca:	00878713          	addi	a4,a5,8
    80005ece:	f8e43423          	sd	a4,-120(s0)
    80005ed2:	4605                	li	a2,1
    80005ed4:	45a9                	li	a1,10
    80005ed6:	4388                	lw	a0,0(a5)
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	e0e080e7          	jalr	-498(ra) # 80005ce6 <printint>
      break;
    80005ee0:	b771                	j	80005e6c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ee2:	f8843783          	ld	a5,-120(s0)
    80005ee6:	00878713          	addi	a4,a5,8
    80005eea:	f8e43423          	sd	a4,-120(s0)
    80005eee:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005ef2:	03000513          	li	a0,48
    80005ef6:	00000097          	auipc	ra,0x0
    80005efa:	bd0080e7          	jalr	-1072(ra) # 80005ac6 <consputc>
  consputc('x');
    80005efe:	07800513          	li	a0,120
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	bc4080e7          	jalr	-1084(ra) # 80005ac6 <consputc>
    80005f0a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f0c:	03c9d793          	srli	a5,s3,0x3c
    80005f10:	97de                	add	a5,a5,s7
    80005f12:	0007c503          	lbu	a0,0(a5)
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	bb0080e7          	jalr	-1104(ra) # 80005ac6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f1e:	0992                	slli	s3,s3,0x4
    80005f20:	397d                	addiw	s2,s2,-1
    80005f22:	fe0915e3          	bnez	s2,80005f0c <printf+0x13a>
    80005f26:	b799                	j	80005e6c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f28:	f8843783          	ld	a5,-120(s0)
    80005f2c:	00878713          	addi	a4,a5,8
    80005f30:	f8e43423          	sd	a4,-120(s0)
    80005f34:	0007b903          	ld	s2,0(a5)
    80005f38:	00090e63          	beqz	s2,80005f54 <printf+0x182>
      for(; *s; s++)
    80005f3c:	00094503          	lbu	a0,0(s2)
    80005f40:	d515                	beqz	a0,80005e6c <printf+0x9a>
        consputc(*s);
    80005f42:	00000097          	auipc	ra,0x0
    80005f46:	b84080e7          	jalr	-1148(ra) # 80005ac6 <consputc>
      for(; *s; s++)
    80005f4a:	0905                	addi	s2,s2,1
    80005f4c:	00094503          	lbu	a0,0(s2)
    80005f50:	f96d                	bnez	a0,80005f42 <printf+0x170>
    80005f52:	bf29                	j	80005e6c <printf+0x9a>
        s = "(null)";
    80005f54:	00003917          	auipc	s2,0x3
    80005f58:	89490913          	addi	s2,s2,-1900 # 800087e8 <syscalls+0x3d8>
      for(; *s; s++)
    80005f5c:	02800513          	li	a0,40
    80005f60:	b7cd                	j	80005f42 <printf+0x170>
      consputc('%');
    80005f62:	8556                	mv	a0,s5
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	b62080e7          	jalr	-1182(ra) # 80005ac6 <consputc>
      break;
    80005f6c:	b701                	j	80005e6c <printf+0x9a>
      consputc('%');
    80005f6e:	8556                	mv	a0,s5
    80005f70:	00000097          	auipc	ra,0x0
    80005f74:	b56080e7          	jalr	-1194(ra) # 80005ac6 <consputc>
      consputc(c);
    80005f78:	854a                	mv	a0,s2
    80005f7a:	00000097          	auipc	ra,0x0
    80005f7e:	b4c080e7          	jalr	-1204(ra) # 80005ac6 <consputc>
      break;
    80005f82:	b5ed                	j	80005e6c <printf+0x9a>
  if(locking)
    80005f84:	020d9163          	bnez	s11,80005fa6 <printf+0x1d4>
}
    80005f88:	70e6                	ld	ra,120(sp)
    80005f8a:	7446                	ld	s0,112(sp)
    80005f8c:	74a6                	ld	s1,104(sp)
    80005f8e:	7906                	ld	s2,96(sp)
    80005f90:	69e6                	ld	s3,88(sp)
    80005f92:	6a46                	ld	s4,80(sp)
    80005f94:	6aa6                	ld	s5,72(sp)
    80005f96:	6b06                	ld	s6,64(sp)
    80005f98:	7be2                	ld	s7,56(sp)
    80005f9a:	7c42                	ld	s8,48(sp)
    80005f9c:	7ca2                	ld	s9,40(sp)
    80005f9e:	7d02                	ld	s10,32(sp)
    80005fa0:	6de2                	ld	s11,24(sp)
    80005fa2:	6129                	addi	sp,sp,192
    80005fa4:	8082                	ret
    release(&pr.lock);
    80005fa6:	00240517          	auipc	a0,0x240
    80005faa:	24250513          	addi	a0,a0,578 # 802461e8 <pr>
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	3d8080e7          	jalr	984(ra) # 80006386 <release>
}
    80005fb6:	bfc9                	j	80005f88 <printf+0x1b6>

0000000080005fb8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fb8:	1101                	addi	sp,sp,-32
    80005fba:	ec06                	sd	ra,24(sp)
    80005fbc:	e822                	sd	s0,16(sp)
    80005fbe:	e426                	sd	s1,8(sp)
    80005fc0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fc2:	00240497          	auipc	s1,0x240
    80005fc6:	22648493          	addi	s1,s1,550 # 802461e8 <pr>
    80005fca:	00003597          	auipc	a1,0x3
    80005fce:	83658593          	addi	a1,a1,-1994 # 80008800 <syscalls+0x3f0>
    80005fd2:	8526                	mv	a0,s1
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	26e080e7          	jalr	622(ra) # 80006242 <initlock>
  pr.locking = 1;
    80005fdc:	4785                	li	a5,1
    80005fde:	cc9c                	sw	a5,24(s1)
}
    80005fe0:	60e2                	ld	ra,24(sp)
    80005fe2:	6442                	ld	s0,16(sp)
    80005fe4:	64a2                	ld	s1,8(sp)
    80005fe6:	6105                	addi	sp,sp,32
    80005fe8:	8082                	ret

0000000080005fea <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fea:	1141                	addi	sp,sp,-16
    80005fec:	e406                	sd	ra,8(sp)
    80005fee:	e022                	sd	s0,0(sp)
    80005ff0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ff2:	100007b7          	lui	a5,0x10000
    80005ff6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ffa:	f8000713          	li	a4,-128
    80005ffe:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006002:	470d                	li	a4,3
    80006004:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006008:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000600c:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006010:	469d                	li	a3,7
    80006012:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006016:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000601a:	00003597          	auipc	a1,0x3
    8000601e:	80658593          	addi	a1,a1,-2042 # 80008820 <digits+0x18>
    80006022:	00240517          	auipc	a0,0x240
    80006026:	1e650513          	addi	a0,a0,486 # 80246208 <uart_tx_lock>
    8000602a:	00000097          	auipc	ra,0x0
    8000602e:	218080e7          	jalr	536(ra) # 80006242 <initlock>
}
    80006032:	60a2                	ld	ra,8(sp)
    80006034:	6402                	ld	s0,0(sp)
    80006036:	0141                	addi	sp,sp,16
    80006038:	8082                	ret

000000008000603a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000603a:	1101                	addi	sp,sp,-32
    8000603c:	ec06                	sd	ra,24(sp)
    8000603e:	e822                	sd	s0,16(sp)
    80006040:	e426                	sd	s1,8(sp)
    80006042:	1000                	addi	s0,sp,32
    80006044:	84aa                	mv	s1,a0
  push_off();
    80006046:	00000097          	auipc	ra,0x0
    8000604a:	240080e7          	jalr	576(ra) # 80006286 <push_off>

  if(panicked){
    8000604e:	00003797          	auipc	a5,0x3
    80006052:	fce7a783          	lw	a5,-50(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006056:	10000737          	lui	a4,0x10000
  if(panicked){
    8000605a:	c391                	beqz	a5,8000605e <uartputc_sync+0x24>
    for(;;)
    8000605c:	a001                	j	8000605c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000605e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006062:	0ff7f793          	andi	a5,a5,255
    80006066:	0207f793          	andi	a5,a5,32
    8000606a:	dbf5                	beqz	a5,8000605e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000606c:	0ff4f793          	andi	a5,s1,255
    80006070:	10000737          	lui	a4,0x10000
    80006074:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	2ae080e7          	jalr	686(ra) # 80006326 <pop_off>
}
    80006080:	60e2                	ld	ra,24(sp)
    80006082:	6442                	ld	s0,16(sp)
    80006084:	64a2                	ld	s1,8(sp)
    80006086:	6105                	addi	sp,sp,32
    80006088:	8082                	ret

000000008000608a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000608a:	00003717          	auipc	a4,0x3
    8000608e:	f9673703          	ld	a4,-106(a4) # 80009020 <uart_tx_r>
    80006092:	00003797          	auipc	a5,0x3
    80006096:	f967b783          	ld	a5,-106(a5) # 80009028 <uart_tx_w>
    8000609a:	06e78c63          	beq	a5,a4,80006112 <uartstart+0x88>
{
    8000609e:	7139                	addi	sp,sp,-64
    800060a0:	fc06                	sd	ra,56(sp)
    800060a2:	f822                	sd	s0,48(sp)
    800060a4:	f426                	sd	s1,40(sp)
    800060a6:	f04a                	sd	s2,32(sp)
    800060a8:	ec4e                	sd	s3,24(sp)
    800060aa:	e852                	sd	s4,16(sp)
    800060ac:	e456                	sd	s5,8(sp)
    800060ae:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060b0:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060b4:	00240a17          	auipc	s4,0x240
    800060b8:	154a0a13          	addi	s4,s4,340 # 80246208 <uart_tx_lock>
    uart_tx_r += 1;
    800060bc:	00003497          	auipc	s1,0x3
    800060c0:	f6448493          	addi	s1,s1,-156 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060c4:	00003997          	auipc	s3,0x3
    800060c8:	f6498993          	addi	s3,s3,-156 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060cc:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060d0:	0ff7f793          	andi	a5,a5,255
    800060d4:	0207f793          	andi	a5,a5,32
    800060d8:	c785                	beqz	a5,80006100 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060da:	01f77793          	andi	a5,a4,31
    800060de:	97d2                	add	a5,a5,s4
    800060e0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060e4:	0705                	addi	a4,a4,1
    800060e6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060e8:	8526                	mv	a0,s1
    800060ea:	ffffb097          	auipc	ra,0xffffb
    800060ee:	7bc080e7          	jalr	1980(ra) # 800018a6 <wakeup>
    
    WriteReg(THR, c);
    800060f2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060f6:	6098                	ld	a4,0(s1)
    800060f8:	0009b783          	ld	a5,0(s3)
    800060fc:	fce798e3          	bne	a5,a4,800060cc <uartstart+0x42>
  }
}
    80006100:	70e2                	ld	ra,56(sp)
    80006102:	7442                	ld	s0,48(sp)
    80006104:	74a2                	ld	s1,40(sp)
    80006106:	7902                	ld	s2,32(sp)
    80006108:	69e2                	ld	s3,24(sp)
    8000610a:	6a42                	ld	s4,16(sp)
    8000610c:	6aa2                	ld	s5,8(sp)
    8000610e:	6121                	addi	sp,sp,64
    80006110:	8082                	ret
    80006112:	8082                	ret

0000000080006114 <uartputc>:
{
    80006114:	7179                	addi	sp,sp,-48
    80006116:	f406                	sd	ra,40(sp)
    80006118:	f022                	sd	s0,32(sp)
    8000611a:	ec26                	sd	s1,24(sp)
    8000611c:	e84a                	sd	s2,16(sp)
    8000611e:	e44e                	sd	s3,8(sp)
    80006120:	e052                	sd	s4,0(sp)
    80006122:	1800                	addi	s0,sp,48
    80006124:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006126:	00240517          	auipc	a0,0x240
    8000612a:	0e250513          	addi	a0,a0,226 # 80246208 <uart_tx_lock>
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	1a4080e7          	jalr	420(ra) # 800062d2 <acquire>
  if(panicked){
    80006136:	00003797          	auipc	a5,0x3
    8000613a:	ee67a783          	lw	a5,-282(a5) # 8000901c <panicked>
    8000613e:	c391                	beqz	a5,80006142 <uartputc+0x2e>
    for(;;)
    80006140:	a001                	j	80006140 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006142:	00003797          	auipc	a5,0x3
    80006146:	ee67b783          	ld	a5,-282(a5) # 80009028 <uart_tx_w>
    8000614a:	00003717          	auipc	a4,0x3
    8000614e:	ed673703          	ld	a4,-298(a4) # 80009020 <uart_tx_r>
    80006152:	02070713          	addi	a4,a4,32
    80006156:	02f71b63          	bne	a4,a5,8000618c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000615a:	00240a17          	auipc	s4,0x240
    8000615e:	0aea0a13          	addi	s4,s4,174 # 80246208 <uart_tx_lock>
    80006162:	00003497          	auipc	s1,0x3
    80006166:	ebe48493          	addi	s1,s1,-322 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000616a:	00003917          	auipc	s2,0x3
    8000616e:	ebe90913          	addi	s2,s2,-322 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006172:	85d2                	mv	a1,s4
    80006174:	8526                	mv	a0,s1
    80006176:	ffffb097          	auipc	ra,0xffffb
    8000617a:	5a4080e7          	jalr	1444(ra) # 8000171a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000617e:	00093783          	ld	a5,0(s2)
    80006182:	6098                	ld	a4,0(s1)
    80006184:	02070713          	addi	a4,a4,32
    80006188:	fef705e3          	beq	a4,a5,80006172 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000618c:	00240497          	auipc	s1,0x240
    80006190:	07c48493          	addi	s1,s1,124 # 80246208 <uart_tx_lock>
    80006194:	01f7f713          	andi	a4,a5,31
    80006198:	9726                	add	a4,a4,s1
    8000619a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000619e:	0785                	addi	a5,a5,1
    800061a0:	00003717          	auipc	a4,0x3
    800061a4:	e8f73423          	sd	a5,-376(a4) # 80009028 <uart_tx_w>
      uartstart();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	ee2080e7          	jalr	-286(ra) # 8000608a <uartstart>
      release(&uart_tx_lock);
    800061b0:	8526                	mv	a0,s1
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	1d4080e7          	jalr	468(ra) # 80006386 <release>
}
    800061ba:	70a2                	ld	ra,40(sp)
    800061bc:	7402                	ld	s0,32(sp)
    800061be:	64e2                	ld	s1,24(sp)
    800061c0:	6942                	ld	s2,16(sp)
    800061c2:	69a2                	ld	s3,8(sp)
    800061c4:	6a02                	ld	s4,0(sp)
    800061c6:	6145                	addi	sp,sp,48
    800061c8:	8082                	ret

00000000800061ca <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061ca:	1141                	addi	sp,sp,-16
    800061cc:	e422                	sd	s0,8(sp)
    800061ce:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061d0:	100007b7          	lui	a5,0x10000
    800061d4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061d8:	8b85                	andi	a5,a5,1
    800061da:	cb91                	beqz	a5,800061ee <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061dc:	100007b7          	lui	a5,0x10000
    800061e0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061e4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061e8:	6422                	ld	s0,8(sp)
    800061ea:	0141                	addi	sp,sp,16
    800061ec:	8082                	ret
    return -1;
    800061ee:	557d                	li	a0,-1
    800061f0:	bfe5                	j	800061e8 <uartgetc+0x1e>

00000000800061f2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061fc:	54fd                	li	s1,-1
    int c = uartgetc();
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	fcc080e7          	jalr	-52(ra) # 800061ca <uartgetc>
    if(c == -1)
    80006206:	00950763          	beq	a0,s1,80006214 <uartintr+0x22>
      break;
    consoleintr(c);
    8000620a:	00000097          	auipc	ra,0x0
    8000620e:	8fe080e7          	jalr	-1794(ra) # 80005b08 <consoleintr>
  while(1){
    80006212:	b7f5                	j	800061fe <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006214:	00240497          	auipc	s1,0x240
    80006218:	ff448493          	addi	s1,s1,-12 # 80246208 <uart_tx_lock>
    8000621c:	8526                	mv	a0,s1
    8000621e:	00000097          	auipc	ra,0x0
    80006222:	0b4080e7          	jalr	180(ra) # 800062d2 <acquire>
  uartstart();
    80006226:	00000097          	auipc	ra,0x0
    8000622a:	e64080e7          	jalr	-412(ra) # 8000608a <uartstart>
  release(&uart_tx_lock);
    8000622e:	8526                	mv	a0,s1
    80006230:	00000097          	auipc	ra,0x0
    80006234:	156080e7          	jalr	342(ra) # 80006386 <release>
}
    80006238:	60e2                	ld	ra,24(sp)
    8000623a:	6442                	ld	s0,16(sp)
    8000623c:	64a2                	ld	s1,8(sp)
    8000623e:	6105                	addi	sp,sp,32
    80006240:	8082                	ret

0000000080006242 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006242:	1141                	addi	sp,sp,-16
    80006244:	e422                	sd	s0,8(sp)
    80006246:	0800                	addi	s0,sp,16
  lk->name = name;
    80006248:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000624a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000624e:	00053823          	sd	zero,16(a0)
}
    80006252:	6422                	ld	s0,8(sp)
    80006254:	0141                	addi	sp,sp,16
    80006256:	8082                	ret

0000000080006258 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006258:	411c                	lw	a5,0(a0)
    8000625a:	e399                	bnez	a5,80006260 <holding+0x8>
    8000625c:	4501                	li	a0,0
  return r;
}
    8000625e:	8082                	ret
{
    80006260:	1101                	addi	sp,sp,-32
    80006262:	ec06                	sd	ra,24(sp)
    80006264:	e822                	sd	s0,16(sp)
    80006266:	e426                	sd	s1,8(sp)
    80006268:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000626a:	6904                	ld	s1,16(a0)
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	dd6080e7          	jalr	-554(ra) # 80001042 <mycpu>
    80006274:	40a48533          	sub	a0,s1,a0
    80006278:	00153513          	seqz	a0,a0
}
    8000627c:	60e2                	ld	ra,24(sp)
    8000627e:	6442                	ld	s0,16(sp)
    80006280:	64a2                	ld	s1,8(sp)
    80006282:	6105                	addi	sp,sp,32
    80006284:	8082                	ret

0000000080006286 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006286:	1101                	addi	sp,sp,-32
    80006288:	ec06                	sd	ra,24(sp)
    8000628a:	e822                	sd	s0,16(sp)
    8000628c:	e426                	sd	s1,8(sp)
    8000628e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006290:	100024f3          	csrr	s1,sstatus
    80006294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006298:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000629a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000629e:	ffffb097          	auipc	ra,0xffffb
    800062a2:	da4080e7          	jalr	-604(ra) # 80001042 <mycpu>
    800062a6:	5d3c                	lw	a5,120(a0)
    800062a8:	cf89                	beqz	a5,800062c2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062aa:	ffffb097          	auipc	ra,0xffffb
    800062ae:	d98080e7          	jalr	-616(ra) # 80001042 <mycpu>
    800062b2:	5d3c                	lw	a5,120(a0)
    800062b4:	2785                	addiw	a5,a5,1
    800062b6:	dd3c                	sw	a5,120(a0)
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret
    mycpu()->intena = old;
    800062c2:	ffffb097          	auipc	ra,0xffffb
    800062c6:	d80080e7          	jalr	-640(ra) # 80001042 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062ca:	8085                	srli	s1,s1,0x1
    800062cc:	8885                	andi	s1,s1,1
    800062ce:	dd64                	sw	s1,124(a0)
    800062d0:	bfe9                	j	800062aa <push_off+0x24>

00000000800062d2 <acquire>:
{
    800062d2:	1101                	addi	sp,sp,-32
    800062d4:	ec06                	sd	ra,24(sp)
    800062d6:	e822                	sd	s0,16(sp)
    800062d8:	e426                	sd	s1,8(sp)
    800062da:	1000                	addi	s0,sp,32
    800062dc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062de:	00000097          	auipc	ra,0x0
    800062e2:	fa8080e7          	jalr	-88(ra) # 80006286 <push_off>
  if(holding(lk))
    800062e6:	8526                	mv	a0,s1
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	f70080e7          	jalr	-144(ra) # 80006258 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f0:	4705                	li	a4,1
  if(holding(lk))
    800062f2:	e115                	bnez	a0,80006316 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062f4:	87ba                	mv	a5,a4
    800062f6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062fa:	2781                	sext.w	a5,a5
    800062fc:	ffe5                	bnez	a5,800062f4 <acquire+0x22>
  __sync_synchronize();
    800062fe:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006302:	ffffb097          	auipc	ra,0xffffb
    80006306:	d40080e7          	jalr	-704(ra) # 80001042 <mycpu>
    8000630a:	e888                	sd	a0,16(s1)
}
    8000630c:	60e2                	ld	ra,24(sp)
    8000630e:	6442                	ld	s0,16(sp)
    80006310:	64a2                	ld	s1,8(sp)
    80006312:	6105                	addi	sp,sp,32
    80006314:	8082                	ret
    panic("acquire");
    80006316:	00002517          	auipc	a0,0x2
    8000631a:	51250513          	addi	a0,a0,1298 # 80008828 <digits+0x20>
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	a6a080e7          	jalr	-1430(ra) # 80005d88 <panic>

0000000080006326 <pop_off>:

void
pop_off(void)
{
    80006326:	1141                	addi	sp,sp,-16
    80006328:	e406                	sd	ra,8(sp)
    8000632a:	e022                	sd	s0,0(sp)
    8000632c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	d14080e7          	jalr	-748(ra) # 80001042 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006336:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000633a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000633c:	e78d                	bnez	a5,80006366 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000633e:	5d3c                	lw	a5,120(a0)
    80006340:	02f05b63          	blez	a5,80006376 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006344:	37fd                	addiw	a5,a5,-1
    80006346:	0007871b          	sext.w	a4,a5
    8000634a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000634c:	eb09                	bnez	a4,8000635e <pop_off+0x38>
    8000634e:	5d7c                	lw	a5,124(a0)
    80006350:	c799                	beqz	a5,8000635e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006352:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006356:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000635a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000635e:	60a2                	ld	ra,8(sp)
    80006360:	6402                	ld	s0,0(sp)
    80006362:	0141                	addi	sp,sp,16
    80006364:	8082                	ret
    panic("pop_off - interruptible");
    80006366:	00002517          	auipc	a0,0x2
    8000636a:	4ca50513          	addi	a0,a0,1226 # 80008830 <digits+0x28>
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	a1a080e7          	jalr	-1510(ra) # 80005d88 <panic>
    panic("pop_off");
    80006376:	00002517          	auipc	a0,0x2
    8000637a:	4d250513          	addi	a0,a0,1234 # 80008848 <digits+0x40>
    8000637e:	00000097          	auipc	ra,0x0
    80006382:	a0a080e7          	jalr	-1526(ra) # 80005d88 <panic>

0000000080006386 <release>:
{
    80006386:	1101                	addi	sp,sp,-32
    80006388:	ec06                	sd	ra,24(sp)
    8000638a:	e822                	sd	s0,16(sp)
    8000638c:	e426                	sd	s1,8(sp)
    8000638e:	1000                	addi	s0,sp,32
    80006390:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006392:	00000097          	auipc	ra,0x0
    80006396:	ec6080e7          	jalr	-314(ra) # 80006258 <holding>
    8000639a:	c115                	beqz	a0,800063be <release+0x38>
  lk->cpu = 0;
    8000639c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800063a0:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800063a4:	0f50000f          	fence	iorw,ow
    800063a8:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	f7a080e7          	jalr	-134(ra) # 80006326 <pop_off>
}
    800063b4:	60e2                	ld	ra,24(sp)
    800063b6:	6442                	ld	s0,16(sp)
    800063b8:	64a2                	ld	s1,8(sp)
    800063ba:	6105                	addi	sp,sp,32
    800063bc:	8082                	ret
    panic("release");
    800063be:	00002517          	auipc	a0,0x2
    800063c2:	49250513          	addi	a0,a0,1170 # 80008850 <digits+0x48>
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	9c2080e7          	jalr	-1598(ra) # 80005d88 <panic>
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
