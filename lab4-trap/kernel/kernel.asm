
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00022117          	auipc	sp,0x22
    80000004:	14010113          	addi	sp,sp,320 # 80022140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0e3050ef          	jal	ra,800058f8 <start>

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
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0002a797          	auipc	a5,0x2a
    80000034:	21078793          	addi	a5,a5,528 # 8002a240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	306080e7          	jalr	774(ra) # 80006360 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3a6080e7          	jalr	934(ra) # 80006414 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	d1e080e7          	jalr	-738(ra) # 80005da8 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	f4450513          	addi	a0,a0,-188 # 80009030 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	1dc080e7          	jalr	476(ra) # 800062d0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	0002a517          	auipc	a0,0x2a
    80000104:	14050513          	addi	a0,a0,320 # 8002a240 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	f0e48493          	addi	s1,s1,-242 # 80009030 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	234080e7          	jalr	564(ra) # 80006360 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	ef650513          	addi	a0,a0,-266 # 80009030 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	2d0080e7          	jalr	720(ra) # 80006414 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	eca50513          	addi	a0,a0,-310 # 80009030 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	2a6080e7          	jalr	678(ra) # 80006414 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	aee080e7          	jalr	-1298(ra) # 80000e1c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	cca70713          	addi	a4,a4,-822 # 80009000 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	ad2080e7          	jalr	-1326(ra) # 80000e1c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	a96080e7          	jalr	-1386(ra) # 80005df2 <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	738080e7          	jalr	1848(ra) # 80001aa4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	f0c080e7          	jalr	-244(ra) # 80005280 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fe6080e7          	jalr	-26(ra) # 80001362 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	936080e7          	jalr	-1738(ra) # 80005cba <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	c4c080e7          	jalr	-948(ra) # 80005fd8 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	a56080e7          	jalr	-1450(ra) # 80005df2 <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	a46080e7          	jalr	-1466(ra) # 80005df2 <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	a36080e7          	jalr	-1482(ra) # 80005df2 <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	322080e7          	jalr	802(ra) # 800006ee <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	990080e7          	jalr	-1648(ra) # 80000d6c <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	698080e7          	jalr	1688(ra) # 80001a7c <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	6b8080e7          	jalr	1720(ra) # 80001aa4 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	e76080e7          	jalr	-394(ra) # 8000526a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	e84080e7          	jalr	-380(ra) # 80005280 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	060080e7          	jalr	96(ra) # 80002464 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	6f0080e7          	jalr	1776(ra) # 80002afc <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	69a080e7          	jalr	1690(ra) # 80003aae <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	f86080e7          	jalr	-122(ra) # 800053a2 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d0c080e7          	jalr	-756(ra) # 80001130 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00009717          	auipc	a4,0x9
    80000436:	bcf72723          	sw	a5,-1074(a4) # 80009000 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000442:	00009797          	auipc	a5,0x9
    80000446:	bc67b783          	ld	a5,-1082(a5) # 80009008 <kernel_pagetable>
    8000044a:	83b1                	srli	a5,a5,0xc
    8000044c:	577d                	li	a4,-1
    8000044e:	177e                	slli	a4,a4,0x3f
    80000450:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000452:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000456:	12000073          	sfence.vma
  sfence_vma();
}
    8000045a:	6422                	ld	s0,8(sp)
    8000045c:	0141                	addi	sp,sp,16
    8000045e:	8082                	ret

0000000080000460 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000460:	7139                	addi	sp,sp,-64
    80000462:	fc06                	sd	ra,56(sp)
    80000464:	f822                	sd	s0,48(sp)
    80000466:	f426                	sd	s1,40(sp)
    80000468:	f04a                	sd	s2,32(sp)
    8000046a:	ec4e                	sd	s3,24(sp)
    8000046c:	e852                	sd	s4,16(sp)
    8000046e:	e456                	sd	s5,8(sp)
    80000470:	e05a                	sd	s6,0(sp)
    80000472:	0080                	addi	s0,sp,64
    80000474:	84aa                	mv	s1,a0
    80000476:	89ae                	mv	s3,a1
    80000478:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047a:	57fd                	li	a5,-1
    8000047c:	83e9                	srli	a5,a5,0x1a
    8000047e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000480:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000482:	04b7f263          	bgeu	a5,a1,800004c6 <walk+0x66>
    panic("walk");
    80000486:	00008517          	auipc	a0,0x8
    8000048a:	bca50513          	addi	a0,a0,-1078 # 80008050 <etext+0x50>
    8000048e:	00006097          	auipc	ra,0x6
    80000492:	91a080e7          	jalr	-1766(ra) # 80005da8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000496:	060a8663          	beqz	s5,80000502 <walk+0xa2>
    8000049a:	00000097          	auipc	ra,0x0
    8000049e:	c7e080e7          	jalr	-898(ra) # 80000118 <kalloc>
    800004a2:	84aa                	mv	s1,a0
    800004a4:	c529                	beqz	a0,800004ee <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a6:	6605                	lui	a2,0x1
    800004a8:	4581                	li	a1,0
    800004aa:	00000097          	auipc	ra,0x0
    800004ae:	cce080e7          	jalr	-818(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b2:	00c4d793          	srli	a5,s1,0xc
    800004b6:	07aa                	slli	a5,a5,0xa
    800004b8:	0017e793          	ori	a5,a5,1
    800004bc:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c0:	3a5d                	addiw	s4,s4,-9
    800004c2:	036a0063          	beq	s4,s6,800004e2 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c6:	0149d933          	srl	s2,s3,s4
    800004ca:	1ff97913          	andi	s2,s2,511
    800004ce:	090e                	slli	s2,s2,0x3
    800004d0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d2:	00093483          	ld	s1,0(s2)
    800004d6:	0014f793          	andi	a5,s1,1
    800004da:	dfd5                	beqz	a5,80000496 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004dc:	80a9                	srli	s1,s1,0xa
    800004de:	04b2                	slli	s1,s1,0xc
    800004e0:	b7c5                	j	800004c0 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e2:	00c9d513          	srli	a0,s3,0xc
    800004e6:	1ff57513          	andi	a0,a0,511
    800004ea:	050e                	slli	a0,a0,0x3
    800004ec:	9526                	add	a0,a0,s1
}
    800004ee:	70e2                	ld	ra,56(sp)
    800004f0:	7442                	ld	s0,48(sp)
    800004f2:	74a2                	ld	s1,40(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	69e2                	ld	s3,24(sp)
    800004f8:	6a42                	ld	s4,16(sp)
    800004fa:	6aa2                	ld	s5,8(sp)
    800004fc:	6b02                	ld	s6,0(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
        return 0;
    80000502:	4501                	li	a0,0
    80000504:	b7ed                	j	800004ee <walk+0x8e>

0000000080000506 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000506:	57fd                	li	a5,-1
    80000508:	83e9                	srli	a5,a5,0x1a
    8000050a:	00b7f463          	bgeu	a5,a1,80000512 <walkaddr+0xc>
    return 0;
    8000050e:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000510:	8082                	ret
{
    80000512:	1141                	addi	sp,sp,-16
    80000514:	e406                	sd	ra,8(sp)
    80000516:	e022                	sd	s0,0(sp)
    80000518:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051a:	4601                	li	a2,0
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	f44080e7          	jalr	-188(ra) # 80000460 <walk>
  if(pte == 0)
    80000524:	c105                	beqz	a0,80000544 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000526:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000528:	0117f693          	andi	a3,a5,17
    8000052c:	4745                	li	a4,17
    return 0;
    8000052e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000530:	00e68663          	beq	a3,a4,8000053c <walkaddr+0x36>
}
    80000534:	60a2                	ld	ra,8(sp)
    80000536:	6402                	ld	s0,0(sp)
    80000538:	0141                	addi	sp,sp,16
    8000053a:	8082                	ret
  pa = PTE2PA(*pte);
    8000053c:	00a7d513          	srli	a0,a5,0xa
    80000540:	0532                	slli	a0,a0,0xc
  return pa;
    80000542:	bfcd                	j	80000534 <walkaddr+0x2e>
    return 0;
    80000544:	4501                	li	a0,0
    80000546:	b7fd                	j	80000534 <walkaddr+0x2e>

0000000080000548 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000548:	715d                	addi	sp,sp,-80
    8000054a:	e486                	sd	ra,72(sp)
    8000054c:	e0a2                	sd	s0,64(sp)
    8000054e:	fc26                	sd	s1,56(sp)
    80000550:	f84a                	sd	s2,48(sp)
    80000552:	f44e                	sd	s3,40(sp)
    80000554:	f052                	sd	s4,32(sp)
    80000556:	ec56                	sd	s5,24(sp)
    80000558:	e85a                	sd	s6,16(sp)
    8000055a:	e45e                	sd	s7,8(sp)
    8000055c:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055e:	c205                	beqz	a2,8000057e <mappages+0x36>
    80000560:	8aaa                	mv	s5,a0
    80000562:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000564:	77fd                	lui	a5,0xfffff
    80000566:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056a:	15fd                	addi	a1,a1,-1
    8000056c:	00c589b3          	add	s3,a1,a2
    80000570:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000574:	8952                	mv	s2,s4
    80000576:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057a:	6b85                	lui	s7,0x1
    8000057c:	a015                	j	800005a0 <mappages+0x58>
    panic("mappages: size");
    8000057e:	00008517          	auipc	a0,0x8
    80000582:	ada50513          	addi	a0,a0,-1318 # 80008058 <etext+0x58>
    80000586:	00006097          	auipc	ra,0x6
    8000058a:	822080e7          	jalr	-2014(ra) # 80005da8 <panic>
      panic("mappages: remap");
    8000058e:	00008517          	auipc	a0,0x8
    80000592:	ada50513          	addi	a0,a0,-1318 # 80008068 <etext+0x68>
    80000596:	00006097          	auipc	ra,0x6
    8000059a:	812080e7          	jalr	-2030(ra) # 80005da8 <panic>
    a += PGSIZE;
    8000059e:	995e                	add	s2,s2,s7
  for(;;){
    800005a0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a4:	4605                	li	a2,1
    800005a6:	85ca                	mv	a1,s2
    800005a8:	8556                	mv	a0,s5
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	eb6080e7          	jalr	-330(ra) # 80000460 <walk>
    800005b2:	cd19                	beqz	a0,800005d0 <mappages+0x88>
    if(*pte & PTE_V)
    800005b4:	611c                	ld	a5,0(a0)
    800005b6:	8b85                	andi	a5,a5,1
    800005b8:	fbf9                	bnez	a5,8000058e <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ba:	80b1                	srli	s1,s1,0xc
    800005bc:	04aa                	slli	s1,s1,0xa
    800005be:	0164e4b3          	or	s1,s1,s6
    800005c2:	0014e493          	ori	s1,s1,1
    800005c6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005c8:	fd391be3          	bne	s2,s3,8000059e <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005cc:	4501                	li	a0,0
    800005ce:	a011                	j	800005d2 <mappages+0x8a>
      return -1;
    800005d0:	557d                	li	a0,-1
}
    800005d2:	60a6                	ld	ra,72(sp)
    800005d4:	6406                	ld	s0,64(sp)
    800005d6:	74e2                	ld	s1,56(sp)
    800005d8:	7942                	ld	s2,48(sp)
    800005da:	79a2                	ld	s3,40(sp)
    800005dc:	7a02                	ld	s4,32(sp)
    800005de:	6ae2                	ld	s5,24(sp)
    800005e0:	6b42                	ld	s6,16(sp)
    800005e2:	6ba2                	ld	s7,8(sp)
    800005e4:	6161                	addi	sp,sp,80
    800005e6:	8082                	ret

00000000800005e8 <kvmmap>:
{
    800005e8:	1141                	addi	sp,sp,-16
    800005ea:	e406                	sd	ra,8(sp)
    800005ec:	e022                	sd	s0,0(sp)
    800005ee:	0800                	addi	s0,sp,16
    800005f0:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f2:	86b2                	mv	a3,a2
    800005f4:	863e                	mv	a2,a5
    800005f6:	00000097          	auipc	ra,0x0
    800005fa:	f52080e7          	jalr	-174(ra) # 80000548 <mappages>
    800005fe:	e509                	bnez	a0,80000608 <kvmmap+0x20>
}
    80000600:	60a2                	ld	ra,8(sp)
    80000602:	6402                	ld	s0,0(sp)
    80000604:	0141                	addi	sp,sp,16
    80000606:	8082                	ret
    panic("kvmmap");
    80000608:	00008517          	auipc	a0,0x8
    8000060c:	a7050513          	addi	a0,a0,-1424 # 80008078 <etext+0x78>
    80000610:	00005097          	auipc	ra,0x5
    80000614:	798080e7          	jalr	1944(ra) # 80005da8 <panic>

0000000080000618 <kvmmake>:
{
    80000618:	1101                	addi	sp,sp,-32
    8000061a:	ec06                	sd	ra,24(sp)
    8000061c:	e822                	sd	s0,16(sp)
    8000061e:	e426                	sd	s1,8(sp)
    80000620:	e04a                	sd	s2,0(sp)
    80000622:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000624:	00000097          	auipc	ra,0x0
    80000628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000062c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062e:	6605                	lui	a2,0x1
    80000630:	4581                	li	a1,0
    80000632:	00000097          	auipc	ra,0x0
    80000636:	b46080e7          	jalr	-1210(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063a:	4719                	li	a4,6
    8000063c:	6685                	lui	a3,0x1
    8000063e:	10000637          	lui	a2,0x10000
    80000642:	100005b7          	lui	a1,0x10000
    80000646:	8526                	mv	a0,s1
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	fa0080e7          	jalr	-96(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000650:	4719                	li	a4,6
    80000652:	6685                	lui	a3,0x1
    80000654:	10001637          	lui	a2,0x10001
    80000658:	100015b7          	lui	a1,0x10001
    8000065c:	8526                	mv	a0,s1
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	f8a080e7          	jalr	-118(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000666:	4719                	li	a4,6
    80000668:	004006b7          	lui	a3,0x400
    8000066c:	0c000637          	lui	a2,0xc000
    80000670:	0c0005b7          	lui	a1,0xc000
    80000674:	8526                	mv	a0,s1
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	f72080e7          	jalr	-142(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067e:	00008917          	auipc	s2,0x8
    80000682:	98290913          	addi	s2,s2,-1662 # 80008000 <etext>
    80000686:	4729                	li	a4,10
    80000688:	80008697          	auipc	a3,0x80008
    8000068c:	97868693          	addi	a3,a3,-1672 # 8000 <_entry-0x7fff8000>
    80000690:	4605                	li	a2,1
    80000692:	067e                	slli	a2,a2,0x1f
    80000694:	85b2                	mv	a1,a2
    80000696:	8526                	mv	a0,s1
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	f50080e7          	jalr	-176(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a0:	4719                	li	a4,6
    800006a2:	46c5                	li	a3,17
    800006a4:	06ee                	slli	a3,a3,0x1b
    800006a6:	412686b3          	sub	a3,a3,s2
    800006aa:	864a                	mv	a2,s2
    800006ac:	85ca                	mv	a1,s2
    800006ae:	8526                	mv	a0,s1
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	f38080e7          	jalr	-200(ra) # 800005e8 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b8:	4729                	li	a4,10
    800006ba:	6685                	lui	a3,0x1
    800006bc:	00007617          	auipc	a2,0x7
    800006c0:	94460613          	addi	a2,a2,-1724 # 80007000 <_trampoline>
    800006c4:	040005b7          	lui	a1,0x4000
    800006c8:	15fd                	addi	a1,a1,-1
    800006ca:	05b2                	slli	a1,a1,0xc
    800006cc:	8526                	mv	a0,s1
    800006ce:	00000097          	auipc	ra,0x0
    800006d2:	f1a080e7          	jalr	-230(ra) # 800005e8 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	5fe080e7          	jalr	1534(ra) # 80000cd6 <proc_mapstacks>
}
    800006e0:	8526                	mv	a0,s1
    800006e2:	60e2                	ld	ra,24(sp)
    800006e4:	6442                	ld	s0,16(sp)
    800006e6:	64a2                	ld	s1,8(sp)
    800006e8:	6902                	ld	s2,0(sp)
    800006ea:	6105                	addi	sp,sp,32
    800006ec:	8082                	ret

00000000800006ee <kvminit>:
{
    800006ee:	1141                	addi	sp,sp,-16
    800006f0:	e406                	sd	ra,8(sp)
    800006f2:	e022                	sd	s0,0(sp)
    800006f4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f22080e7          	jalr	-222(ra) # 80000618 <kvmmake>
    800006fe:	00009797          	auipc	a5,0x9
    80000702:	90a7b523          	sd	a0,-1782(a5) # 80009008 <kernel_pagetable>
}
    80000706:	60a2                	ld	ra,8(sp)
    80000708:	6402                	ld	s0,0(sp)
    8000070a:	0141                	addi	sp,sp,16
    8000070c:	8082                	ret

000000008000070e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070e:	715d                	addi	sp,sp,-80
    80000710:	e486                	sd	ra,72(sp)
    80000712:	e0a2                	sd	s0,64(sp)
    80000714:	fc26                	sd	s1,56(sp)
    80000716:	f84a                	sd	s2,48(sp)
    80000718:	f44e                	sd	s3,40(sp)
    8000071a:	f052                	sd	s4,32(sp)
    8000071c:	ec56                	sd	s5,24(sp)
    8000071e:	e85a                	sd	s6,16(sp)
    80000720:	e45e                	sd	s7,8(sp)
    80000722:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000724:	03459793          	slli	a5,a1,0x34
    80000728:	e795                	bnez	a5,80000754 <uvmunmap+0x46>
    8000072a:	8a2a                	mv	s4,a0
    8000072c:	892e                	mv	s2,a1
    8000072e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000730:	0632                	slli	a2,a2,0xc
    80000732:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000736:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000738:	6b05                	lui	s6,0x1
    8000073a:	0735e863          	bltu	a1,s3,800007aa <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073e:	60a6                	ld	ra,72(sp)
    80000740:	6406                	ld	s0,64(sp)
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
    80000750:	6161                	addi	sp,sp,80
    80000752:	8082                	ret
    panic("uvmunmap: not aligned");
    80000754:	00008517          	auipc	a0,0x8
    80000758:	92c50513          	addi	a0,a0,-1748 # 80008080 <etext+0x80>
    8000075c:	00005097          	auipc	ra,0x5
    80000760:	64c080e7          	jalr	1612(ra) # 80005da8 <panic>
      panic("uvmunmap: walk");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	93450513          	addi	a0,a0,-1740 # 80008098 <etext+0x98>
    8000076c:	00005097          	auipc	ra,0x5
    80000770:	63c080e7          	jalr	1596(ra) # 80005da8 <panic>
      panic("uvmunmap: not mapped");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	93450513          	addi	a0,a0,-1740 # 800080a8 <etext+0xa8>
    8000077c:	00005097          	auipc	ra,0x5
    80000780:	62c080e7          	jalr	1580(ra) # 80005da8 <panic>
      panic("uvmunmap: not a leaf");
    80000784:	00008517          	auipc	a0,0x8
    80000788:	93c50513          	addi	a0,a0,-1732 # 800080c0 <etext+0xc0>
    8000078c:	00005097          	auipc	ra,0x5
    80000790:	61c080e7          	jalr	1564(ra) # 80005da8 <panic>
      uint64 pa = PTE2PA(*pte);
    80000794:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000796:	0532                	slli	a0,a0,0xc
    80000798:	00000097          	auipc	ra,0x0
    8000079c:	884080e7          	jalr	-1916(ra) # 8000001c <kfree>
    *pte = 0;
    800007a0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a4:	995a                	add	s2,s2,s6
    800007a6:	f9397ce3          	bgeu	s2,s3,8000073e <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007aa:	4601                	li	a2,0
    800007ac:	85ca                	mv	a1,s2
    800007ae:	8552                	mv	a0,s4
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	cb0080e7          	jalr	-848(ra) # 80000460 <walk>
    800007b8:	84aa                	mv	s1,a0
    800007ba:	d54d                	beqz	a0,80000764 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007bc:	6108                	ld	a0,0(a0)
    800007be:	00157793          	andi	a5,a0,1
    800007c2:	dbcd                	beqz	a5,80000774 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c4:	3ff57793          	andi	a5,a0,1023
    800007c8:	fb778ee3          	beq	a5,s7,80000784 <uvmunmap+0x76>
    if(do_free){
    800007cc:	fc0a8ae3          	beqz	s5,800007a0 <uvmunmap+0x92>
    800007d0:	b7d1                	j	80000794 <uvmunmap+0x86>

00000000800007d2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d2:	1101                	addi	sp,sp,-32
    800007d4:	ec06                	sd	ra,24(sp)
    800007d6:	e822                	sd	s0,16(sp)
    800007d8:	e426                	sd	s1,8(sp)
    800007da:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	93c080e7          	jalr	-1732(ra) # 80000118 <kalloc>
    800007e4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e6:	c519                	beqz	a0,800007f4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e8:	6605                	lui	a2,0x1
    800007ea:	4581                	li	a1,0
    800007ec:	00000097          	auipc	ra,0x0
    800007f0:	98c080e7          	jalr	-1652(ra) # 80000178 <memset>
  return pagetable;
}
    800007f4:	8526                	mv	a0,s1
    800007f6:	60e2                	ld	ra,24(sp)
    800007f8:	6442                	ld	s0,16(sp)
    800007fa:	64a2                	ld	s1,8(sp)
    800007fc:	6105                	addi	sp,sp,32
    800007fe:	8082                	ret

0000000080000800 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	e052                	sd	s4,0(sp)
    8000080e:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000810:	6785                	lui	a5,0x1
    80000812:	04f67863          	bgeu	a2,a5,80000862 <uvminit+0x62>
    80000816:	8a2a                	mv	s4,a0
    80000818:	89ae                	mv	s3,a1
    8000081a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000081c:	00000097          	auipc	ra,0x0
    80000820:	8fc080e7          	jalr	-1796(ra) # 80000118 <kalloc>
    80000824:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000826:	6605                	lui	a2,0x1
    80000828:	4581                	li	a1,0
    8000082a:	00000097          	auipc	ra,0x0
    8000082e:	94e080e7          	jalr	-1714(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000832:	4779                	li	a4,30
    80000834:	86ca                	mv	a3,s2
    80000836:	6605                	lui	a2,0x1
    80000838:	4581                	li	a1,0
    8000083a:	8552                	mv	a0,s4
    8000083c:	00000097          	auipc	ra,0x0
    80000840:	d0c080e7          	jalr	-756(ra) # 80000548 <mappages>
  memmove(mem, src, sz);
    80000844:	8626                	mv	a2,s1
    80000846:	85ce                	mv	a1,s3
    80000848:	854a                	mv	a0,s2
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	98e080e7          	jalr	-1650(ra) # 800001d8 <memmove>
}
    80000852:	70a2                	ld	ra,40(sp)
    80000854:	7402                	ld	s0,32(sp)
    80000856:	64e2                	ld	s1,24(sp)
    80000858:	6942                	ld	s2,16(sp)
    8000085a:	69a2                	ld	s3,8(sp)
    8000085c:	6a02                	ld	s4,0(sp)
    8000085e:	6145                	addi	sp,sp,48
    80000860:	8082                	ret
    panic("inituvm: more than a page");
    80000862:	00008517          	auipc	a0,0x8
    80000866:	87650513          	addi	a0,a0,-1930 # 800080d8 <etext+0xd8>
    8000086a:	00005097          	auipc	ra,0x5
    8000086e:	53e080e7          	jalr	1342(ra) # 80005da8 <panic>

0000000080000872 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000872:	1101                	addi	sp,sp,-32
    80000874:	ec06                	sd	ra,24(sp)
    80000876:	e822                	sd	s0,16(sp)
    80000878:	e426                	sd	s1,8(sp)
    8000087a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087e:	00b67d63          	bgeu	a2,a1,80000898 <uvmdealloc+0x26>
    80000882:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000884:	6785                	lui	a5,0x1
    80000886:	17fd                	addi	a5,a5,-1
    80000888:	00f60733          	add	a4,a2,a5
    8000088c:	767d                	lui	a2,0xfffff
    8000088e:	8f71                	and	a4,a4,a2
    80000890:	97ae                	add	a5,a5,a1
    80000892:	8ff1                	and	a5,a5,a2
    80000894:	00f76863          	bltu	a4,a5,800008a4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000898:	8526                	mv	a0,s1
    8000089a:	60e2                	ld	ra,24(sp)
    8000089c:	6442                	ld	s0,16(sp)
    8000089e:	64a2                	ld	s1,8(sp)
    800008a0:	6105                	addi	sp,sp,32
    800008a2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a4:	8f99                	sub	a5,a5,a4
    800008a6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a8:	4685                	li	a3,1
    800008aa:	0007861b          	sext.w	a2,a5
    800008ae:	85ba                	mv	a1,a4
    800008b0:	00000097          	auipc	ra,0x0
    800008b4:	e5e080e7          	jalr	-418(ra) # 8000070e <uvmunmap>
    800008b8:	b7c5                	j	80000898 <uvmdealloc+0x26>

00000000800008ba <uvmalloc>:
  if(newsz < oldsz)
    800008ba:	0ab66163          	bltu	a2,a1,8000095c <uvmalloc+0xa2>
{
    800008be:	7139                	addi	sp,sp,-64
    800008c0:	fc06                	sd	ra,56(sp)
    800008c2:	f822                	sd	s0,48(sp)
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	f04a                	sd	s2,32(sp)
    800008c8:	ec4e                	sd	s3,24(sp)
    800008ca:	e852                	sd	s4,16(sp)
    800008cc:	e456                	sd	s5,8(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6985                	lui	s3,0x1
    800008d6:	19fd                	addi	s3,s3,-1
    800008d8:	95ce                	add	a1,a1,s3
    800008da:	79fd                	lui	s3,0xfffff
    800008dc:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f063          	bgeu	s3,a2,80000960 <uvmalloc+0xa6>
    800008e4:	894e                	mv	s2,s3
    mem = kalloc();
    800008e6:	00000097          	auipc	ra,0x0
    800008ea:	832080e7          	jalr	-1998(ra) # 80000118 <kalloc>
    800008ee:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f0:	c51d                	beqz	a0,8000091e <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800008f2:	6605                	lui	a2,0x1
    800008f4:	4581                	li	a1,0
    800008f6:	00000097          	auipc	ra,0x0
    800008fa:	882080e7          	jalr	-1918(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800008fe:	4779                	li	a4,30
    80000900:	86a6                	mv	a3,s1
    80000902:	6605                	lui	a2,0x1
    80000904:	85ca                	mv	a1,s2
    80000906:	8556                	mv	a0,s5
    80000908:	00000097          	auipc	ra,0x0
    8000090c:	c40080e7          	jalr	-960(ra) # 80000548 <mappages>
    80000910:	e905                	bnez	a0,80000940 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000912:	6785                	lui	a5,0x1
    80000914:	993e                	add	s2,s2,a5
    80000916:	fd4968e3          	bltu	s2,s4,800008e6 <uvmalloc+0x2c>
  return newsz;
    8000091a:	8552                	mv	a0,s4
    8000091c:	a809                	j	8000092e <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    8000091e:	864e                	mv	a2,s3
    80000920:	85ca                	mv	a1,s2
    80000922:	8556                	mv	a0,s5
    80000924:	00000097          	auipc	ra,0x0
    80000928:	f4e080e7          	jalr	-178(ra) # 80000872 <uvmdealloc>
      return 0;
    8000092c:	4501                	li	a0,0
}
    8000092e:	70e2                	ld	ra,56(sp)
    80000930:	7442                	ld	s0,48(sp)
    80000932:	74a2                	ld	s1,40(sp)
    80000934:	7902                	ld	s2,32(sp)
    80000936:	69e2                	ld	s3,24(sp)
    80000938:	6a42                	ld	s4,16(sp)
    8000093a:	6aa2                	ld	s5,8(sp)
    8000093c:	6121                	addi	sp,sp,64
    8000093e:	8082                	ret
      kfree(mem);
    80000940:	8526                	mv	a0,s1
    80000942:	fffff097          	auipc	ra,0xfffff
    80000946:	6da080e7          	jalr	1754(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000094a:	864e                	mv	a2,s3
    8000094c:	85ca                	mv	a1,s2
    8000094e:	8556                	mv	a0,s5
    80000950:	00000097          	auipc	ra,0x0
    80000954:	f22080e7          	jalr	-222(ra) # 80000872 <uvmdealloc>
      return 0;
    80000958:	4501                	li	a0,0
    8000095a:	bfd1                	j	8000092e <uvmalloc+0x74>
    return oldsz;
    8000095c:	852e                	mv	a0,a1
}
    8000095e:	8082                	ret
  return newsz;
    80000960:	8532                	mv	a0,a2
    80000962:	b7f1                	j	8000092e <uvmalloc+0x74>

0000000080000964 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000964:	7179                	addi	sp,sp,-48
    80000966:	f406                	sd	ra,40(sp)
    80000968:	f022                	sd	s0,32(sp)
    8000096a:	ec26                	sd	s1,24(sp)
    8000096c:	e84a                	sd	s2,16(sp)
    8000096e:	e44e                	sd	s3,8(sp)
    80000970:	e052                	sd	s4,0(sp)
    80000972:	1800                	addi	s0,sp,48
    80000974:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000976:	84aa                	mv	s1,a0
    80000978:	6905                	lui	s2,0x1
    8000097a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097c:	4985                	li	s3,1
    8000097e:	a821                	j	80000996 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000980:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000982:	0532                	slli	a0,a0,0xc
    80000984:	00000097          	auipc	ra,0x0
    80000988:	fe0080e7          	jalr	-32(ra) # 80000964 <freewalk>
      pagetable[i] = 0;
    8000098c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000990:	04a1                	addi	s1,s1,8
    80000992:	03248163          	beq	s1,s2,800009b4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000996:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	00f57793          	andi	a5,a0,15
    8000099c:	ff3782e3          	beq	a5,s3,80000980 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a0:	8905                	andi	a0,a0,1
    800009a2:	d57d                	beqz	a0,80000990 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009a4:	00007517          	auipc	a0,0x7
    800009a8:	75450513          	addi	a0,a0,1876 # 800080f8 <etext+0xf8>
    800009ac:	00005097          	auipc	ra,0x5
    800009b0:	3fc080e7          	jalr	1020(ra) # 80005da8 <panic>
    }
  }
  kfree((void*)pagetable);
    800009b4:	8552                	mv	a0,s4
    800009b6:	fffff097          	auipc	ra,0xfffff
    800009ba:	666080e7          	jalr	1638(ra) # 8000001c <kfree>
}
    800009be:	70a2                	ld	ra,40(sp)
    800009c0:	7402                	ld	s0,32(sp)
    800009c2:	64e2                	ld	s1,24(sp)
    800009c4:	6942                	ld	s2,16(sp)
    800009c6:	69a2                	ld	s3,8(sp)
    800009c8:	6a02                	ld	s4,0(sp)
    800009ca:	6145                	addi	sp,sp,48
    800009cc:	8082                	ret

00000000800009ce <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ce:	1101                	addi	sp,sp,-32
    800009d0:	ec06                	sd	ra,24(sp)
    800009d2:	e822                	sd	s0,16(sp)
    800009d4:	e426                	sd	s1,8(sp)
    800009d6:	1000                	addi	s0,sp,32
    800009d8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009da:	e999                	bnez	a1,800009f0 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009dc:	8526                	mv	a0,s1
    800009de:	00000097          	auipc	ra,0x0
    800009e2:	f86080e7          	jalr	-122(ra) # 80000964 <freewalk>
}
    800009e6:	60e2                	ld	ra,24(sp)
    800009e8:	6442                	ld	s0,16(sp)
    800009ea:	64a2                	ld	s1,8(sp)
    800009ec:	6105                	addi	sp,sp,32
    800009ee:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f0:	6605                	lui	a2,0x1
    800009f2:	167d                	addi	a2,a2,-1
    800009f4:	962e                	add	a2,a2,a1
    800009f6:	4685                	li	a3,1
    800009f8:	8231                	srli	a2,a2,0xc
    800009fa:	4581                	li	a1,0
    800009fc:	00000097          	auipc	ra,0x0
    80000a00:	d12080e7          	jalr	-750(ra) # 8000070e <uvmunmap>
    80000a04:	bfe1                	j	800009dc <uvmfree+0xe>

0000000080000a06 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	c679                	beqz	a2,80000ad4 <uvmcopy+0xce>
{
    80000a08:	715d                	addi	sp,sp,-80
    80000a0a:	e486                	sd	ra,72(sp)
    80000a0c:	e0a2                	sd	s0,64(sp)
    80000a0e:	fc26                	sd	s1,56(sp)
    80000a10:	f84a                	sd	s2,48(sp)
    80000a12:	f44e                	sd	s3,40(sp)
    80000a14:	f052                	sd	s4,32(sp)
    80000a16:	ec56                	sd	s5,24(sp)
    80000a18:	e85a                	sd	s6,16(sp)
    80000a1a:	e45e                	sd	s7,8(sp)
    80000a1c:	0880                	addi	s0,sp,80
    80000a1e:	8b2a                	mv	s6,a0
    80000a20:	8aae                	mv	s5,a1
    80000a22:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a24:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a26:	4601                	li	a2,0
    80000a28:	85ce                	mv	a1,s3
    80000a2a:	855a                	mv	a0,s6
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	a34080e7          	jalr	-1484(ra) # 80000460 <walk>
    80000a34:	c531                	beqz	a0,80000a80 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a36:	6118                	ld	a4,0(a0)
    80000a38:	00177793          	andi	a5,a4,1
    80000a3c:	cbb1                	beqz	a5,80000a90 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a3e:	00a75593          	srli	a1,a4,0xa
    80000a42:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a46:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a4a:	fffff097          	auipc	ra,0xfffff
    80000a4e:	6ce080e7          	jalr	1742(ra) # 80000118 <kalloc>
    80000a52:	892a                	mv	s2,a0
    80000a54:	c939                	beqz	a0,80000aaa <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a56:	6605                	lui	a2,0x1
    80000a58:	85de                	mv	a1,s7
    80000a5a:	fffff097          	auipc	ra,0xfffff
    80000a5e:	77e080e7          	jalr	1918(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a62:	8726                	mv	a4,s1
    80000a64:	86ca                	mv	a3,s2
    80000a66:	6605                	lui	a2,0x1
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	8556                	mv	a0,s5
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	adc080e7          	jalr	-1316(ra) # 80000548 <mappages>
    80000a74:	e515                	bnez	a0,80000aa0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a76:	6785                	lui	a5,0x1
    80000a78:	99be                	add	s3,s3,a5
    80000a7a:	fb49e6e3          	bltu	s3,s4,80000a26 <uvmcopy+0x20>
    80000a7e:	a081                	j	80000abe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a80:	00007517          	auipc	a0,0x7
    80000a84:	68850513          	addi	a0,a0,1672 # 80008108 <etext+0x108>
    80000a88:	00005097          	auipc	ra,0x5
    80000a8c:	320080e7          	jalr	800(ra) # 80005da8 <panic>
      panic("uvmcopy: page not present");
    80000a90:	00007517          	auipc	a0,0x7
    80000a94:	69850513          	addi	a0,a0,1688 # 80008128 <etext+0x128>
    80000a98:	00005097          	auipc	ra,0x5
    80000a9c:	310080e7          	jalr	784(ra) # 80005da8 <panic>
      kfree(mem);
    80000aa0:	854a                	mv	a0,s2
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	57a080e7          	jalr	1402(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aaa:	4685                	li	a3,1
    80000aac:	00c9d613          	srli	a2,s3,0xc
    80000ab0:	4581                	li	a1,0
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	c5a080e7          	jalr	-934(ra) # 8000070e <uvmunmap>
  return -1;
    80000abc:	557d                	li	a0,-1
}
    80000abe:	60a6                	ld	ra,72(sp)
    80000ac0:	6406                	ld	s0,64(sp)
    80000ac2:	74e2                	ld	s1,56(sp)
    80000ac4:	7942                	ld	s2,48(sp)
    80000ac6:	79a2                	ld	s3,40(sp)
    80000ac8:	7a02                	ld	s4,32(sp)
    80000aca:	6ae2                	ld	s5,24(sp)
    80000acc:	6b42                	ld	s6,16(sp)
    80000ace:	6ba2                	ld	s7,8(sp)
    80000ad0:	6161                	addi	sp,sp,80
    80000ad2:	8082                	ret
  return 0;
    80000ad4:	4501                	li	a0,0
}
    80000ad6:	8082                	ret

0000000080000ad8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ad8:	1141                	addi	sp,sp,-16
    80000ada:	e406                	sd	ra,8(sp)
    80000adc:	e022                	sd	s0,0(sp)
    80000ade:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ae0:	4601                	li	a2,0
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	97e080e7          	jalr	-1666(ra) # 80000460 <walk>
  if(pte == 0)
    80000aea:	c901                	beqz	a0,80000afa <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000aec:	611c                	ld	a5,0(a0)
    80000aee:	9bbd                	andi	a5,a5,-17
    80000af0:	e11c                	sd	a5,0(a0)
}
    80000af2:	60a2                	ld	ra,8(sp)
    80000af4:	6402                	ld	s0,0(sp)
    80000af6:	0141                	addi	sp,sp,16
    80000af8:	8082                	ret
    panic("uvmclear");
    80000afa:	00007517          	auipc	a0,0x7
    80000afe:	64e50513          	addi	a0,a0,1614 # 80008148 <etext+0x148>
    80000b02:	00005097          	auipc	ra,0x5
    80000b06:	2a6080e7          	jalr	678(ra) # 80005da8 <panic>

0000000080000b0a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b0a:	c6bd                	beqz	a3,80000b78 <copyout+0x6e>
{
    80000b0c:	715d                	addi	sp,sp,-80
    80000b0e:	e486                	sd	ra,72(sp)
    80000b10:	e0a2                	sd	s0,64(sp)
    80000b12:	fc26                	sd	s1,56(sp)
    80000b14:	f84a                	sd	s2,48(sp)
    80000b16:	f44e                	sd	s3,40(sp)
    80000b18:	f052                	sd	s4,32(sp)
    80000b1a:	ec56                	sd	s5,24(sp)
    80000b1c:	e85a                	sd	s6,16(sp)
    80000b1e:	e45e                	sd	s7,8(sp)
    80000b20:	e062                	sd	s8,0(sp)
    80000b22:	0880                	addi	s0,sp,80
    80000b24:	8b2a                	mv	s6,a0
    80000b26:	8c2e                	mv	s8,a1
    80000b28:	8a32                	mv	s4,a2
    80000b2a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b2e:	6a85                	lui	s5,0x1
    80000b30:	a015                	j	80000b54 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b32:	9562                	add	a0,a0,s8
    80000b34:	0004861b          	sext.w	a2,s1
    80000b38:	85d2                	mv	a1,s4
    80000b3a:	41250533          	sub	a0,a0,s2
    80000b3e:	fffff097          	auipc	ra,0xfffff
    80000b42:	69a080e7          	jalr	1690(ra) # 800001d8 <memmove>

    len -= n;
    80000b46:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b4a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b4c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b50:	02098263          	beqz	s3,80000b74 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b54:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	855a                	mv	a0,s6
    80000b5c:	00000097          	auipc	ra,0x0
    80000b60:	9aa080e7          	jalr	-1622(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000b64:	cd01                	beqz	a0,80000b7c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b66:	418904b3          	sub	s1,s2,s8
    80000b6a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b6c:	fc99f3e3          	bgeu	s3,s1,80000b32 <copyout+0x28>
    80000b70:	84ce                	mv	s1,s3
    80000b72:	b7c1                	j	80000b32 <copyout+0x28>
  }
  return 0;
    80000b74:	4501                	li	a0,0
    80000b76:	a021                	j	80000b7e <copyout+0x74>
    80000b78:	4501                	li	a0,0
}
    80000b7a:	8082                	ret
      return -1;
    80000b7c:	557d                	li	a0,-1
}
    80000b7e:	60a6                	ld	ra,72(sp)
    80000b80:	6406                	ld	s0,64(sp)
    80000b82:	74e2                	ld	s1,56(sp)
    80000b84:	7942                	ld	s2,48(sp)
    80000b86:	79a2                	ld	s3,40(sp)
    80000b88:	7a02                	ld	s4,32(sp)
    80000b8a:	6ae2                	ld	s5,24(sp)
    80000b8c:	6b42                	ld	s6,16(sp)
    80000b8e:	6ba2                	ld	s7,8(sp)
    80000b90:	6c02                	ld	s8,0(sp)
    80000b92:	6161                	addi	sp,sp,80
    80000b94:	8082                	ret

0000000080000b96 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b96:	c6bd                	beqz	a3,80000c04 <copyin+0x6e>
{
    80000b98:	715d                	addi	sp,sp,-80
    80000b9a:	e486                	sd	ra,72(sp)
    80000b9c:	e0a2                	sd	s0,64(sp)
    80000b9e:	fc26                	sd	s1,56(sp)
    80000ba0:	f84a                	sd	s2,48(sp)
    80000ba2:	f44e                	sd	s3,40(sp)
    80000ba4:	f052                	sd	s4,32(sp)
    80000ba6:	ec56                	sd	s5,24(sp)
    80000ba8:	e85a                	sd	s6,16(sp)
    80000baa:	e45e                	sd	s7,8(sp)
    80000bac:	e062                	sd	s8,0(sp)
    80000bae:	0880                	addi	s0,sp,80
    80000bb0:	8b2a                	mv	s6,a0
    80000bb2:	8a2e                	mv	s4,a1
    80000bb4:	8c32                	mv	s8,a2
    80000bb6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bb8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bba:	6a85                	lui	s5,0x1
    80000bbc:	a015                	j	80000be0 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bbe:	9562                	add	a0,a0,s8
    80000bc0:	0004861b          	sext.w	a2,s1
    80000bc4:	412505b3          	sub	a1,a0,s2
    80000bc8:	8552                	mv	a0,s4
    80000bca:	fffff097          	auipc	ra,0xfffff
    80000bce:	60e080e7          	jalr	1550(ra) # 800001d8 <memmove>

    len -= n;
    80000bd2:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bd6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bd8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000bdc:	02098263          	beqz	s3,80000c00 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000be0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000be4:	85ca                	mv	a1,s2
    80000be6:	855a                	mv	a0,s6
    80000be8:	00000097          	auipc	ra,0x0
    80000bec:	91e080e7          	jalr	-1762(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000bf0:	cd01                	beqz	a0,80000c08 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bf2:	418904b3          	sub	s1,s2,s8
    80000bf6:	94d6                	add	s1,s1,s5
    if(n > len)
    80000bf8:	fc99f3e3          	bgeu	s3,s1,80000bbe <copyin+0x28>
    80000bfc:	84ce                	mv	s1,s3
    80000bfe:	b7c1                	j	80000bbe <copyin+0x28>
  }
  return 0;
    80000c00:	4501                	li	a0,0
    80000c02:	a021                	j	80000c0a <copyin+0x74>
    80000c04:	4501                	li	a0,0
}
    80000c06:	8082                	ret
      return -1;
    80000c08:	557d                	li	a0,-1
}
    80000c0a:	60a6                	ld	ra,72(sp)
    80000c0c:	6406                	ld	s0,64(sp)
    80000c0e:	74e2                	ld	s1,56(sp)
    80000c10:	7942                	ld	s2,48(sp)
    80000c12:	79a2                	ld	s3,40(sp)
    80000c14:	7a02                	ld	s4,32(sp)
    80000c16:	6ae2                	ld	s5,24(sp)
    80000c18:	6b42                	ld	s6,16(sp)
    80000c1a:	6ba2                	ld	s7,8(sp)
    80000c1c:	6c02                	ld	s8,0(sp)
    80000c1e:	6161                	addi	sp,sp,80
    80000c20:	8082                	ret

0000000080000c22 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c22:	c6c5                	beqz	a3,80000cca <copyinstr+0xa8>
{
    80000c24:	715d                	addi	sp,sp,-80
    80000c26:	e486                	sd	ra,72(sp)
    80000c28:	e0a2                	sd	s0,64(sp)
    80000c2a:	fc26                	sd	s1,56(sp)
    80000c2c:	f84a                	sd	s2,48(sp)
    80000c2e:	f44e                	sd	s3,40(sp)
    80000c30:	f052                	sd	s4,32(sp)
    80000c32:	ec56                	sd	s5,24(sp)
    80000c34:	e85a                	sd	s6,16(sp)
    80000c36:	e45e                	sd	s7,8(sp)
    80000c38:	0880                	addi	s0,sp,80
    80000c3a:	8a2a                	mv	s4,a0
    80000c3c:	8b2e                	mv	s6,a1
    80000c3e:	8bb2                	mv	s7,a2
    80000c40:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c42:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c44:	6985                	lui	s3,0x1
    80000c46:	a035                	j	80000c72 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c48:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c4c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c4e:	0017b793          	seqz	a5,a5
    80000c52:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c56:	60a6                	ld	ra,72(sp)
    80000c58:	6406                	ld	s0,64(sp)
    80000c5a:	74e2                	ld	s1,56(sp)
    80000c5c:	7942                	ld	s2,48(sp)
    80000c5e:	79a2                	ld	s3,40(sp)
    80000c60:	7a02                	ld	s4,32(sp)
    80000c62:	6ae2                	ld	s5,24(sp)
    80000c64:	6b42                	ld	s6,16(sp)
    80000c66:	6ba2                	ld	s7,8(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c6c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c70:	c8a9                	beqz	s1,80000cc2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c72:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85ca                	mv	a1,s2
    80000c78:	8552                	mv	a0,s4
    80000c7a:	00000097          	auipc	ra,0x0
    80000c7e:	88c080e7          	jalr	-1908(ra) # 80000506 <walkaddr>
    if(pa0 == 0)
    80000c82:	c131                	beqz	a0,80000cc6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c84:	41790833          	sub	a6,s2,s7
    80000c88:	984e                	add	a6,a6,s3
    if(n > max)
    80000c8a:	0104f363          	bgeu	s1,a6,80000c90 <copyinstr+0x6e>
    80000c8e:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c90:	955e                	add	a0,a0,s7
    80000c92:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000c96:	fc080be3          	beqz	a6,80000c6c <copyinstr+0x4a>
    80000c9a:	985a                	add	a6,a6,s6
    80000c9c:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000c9e:	41650633          	sub	a2,a0,s6
    80000ca2:	14fd                	addi	s1,s1,-1
    80000ca4:	9b26                	add	s6,s6,s1
    80000ca6:	00f60733          	add	a4,a2,a5
    80000caa:	00074703          	lbu	a4,0(a4)
    80000cae:	df49                	beqz	a4,80000c48 <copyinstr+0x26>
        *dst = *p;
    80000cb0:	00e78023          	sb	a4,0(a5)
      --max;
    80000cb4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cba:	ff0796e3          	bne	a5,a6,80000ca6 <copyinstr+0x84>
      dst++;
    80000cbe:	8b42                	mv	s6,a6
    80000cc0:	b775                	j	80000c6c <copyinstr+0x4a>
    80000cc2:	4781                	li	a5,0
    80000cc4:	b769                	j	80000c4e <copyinstr+0x2c>
      return -1;
    80000cc6:	557d                	li	a0,-1
    80000cc8:	b779                	j	80000c56 <copyinstr+0x34>
  int got_null = 0;
    80000cca:	4781                	li	a5,0
  if(got_null){
    80000ccc:	0017b793          	seqz	a5,a5
    80000cd0:	40f00533          	neg	a0,a5
}
    80000cd4:	8082                	ret

0000000080000cd6 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cd6:	7139                	addi	sp,sp,-64
    80000cd8:	fc06                	sd	ra,56(sp)
    80000cda:	f822                	sd	s0,48(sp)
    80000cdc:	f426                	sd	s1,40(sp)
    80000cde:	f04a                	sd	s2,32(sp)
    80000ce0:	ec4e                	sd	s3,24(sp)
    80000ce2:	e852                	sd	s4,16(sp)
    80000ce4:	e456                	sd	s5,8(sp)
    80000ce6:	e05a                	sd	s6,0(sp)
    80000ce8:	0080                	addi	s0,sp,64
    80000cea:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cec:	00008497          	auipc	s1,0x8
    80000cf0:	79448493          	addi	s1,s1,1940 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf4:	8b26                	mv	s6,s1
    80000cf6:	00007a97          	auipc	s5,0x7
    80000cfa:	30aa8a93          	addi	s5,s5,778 # 80008000 <etext>
    80000cfe:	04000937          	lui	s2,0x4000
    80000d02:	197d                	addi	s2,s2,-1
    80000d04:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d06:	00012a17          	auipc	s4,0x12
    80000d0a:	57aa0a13          	addi	s4,s4,1402 # 80013280 <tickslock>
    char *pa = kalloc();
    80000d0e:	fffff097          	auipc	ra,0xfffff
    80000d12:	40a080e7          	jalr	1034(ra) # 80000118 <kalloc>
    80000d16:	862a                	mv	a2,a0
    if(pa == 0)
    80000d18:	c131                	beqz	a0,80000d5c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d1a:	416485b3          	sub	a1,s1,s6
    80000d1e:	858d                	srai	a1,a1,0x3
    80000d20:	000ab783          	ld	a5,0(s5)
    80000d24:	02f585b3          	mul	a1,a1,a5
    80000d28:	2585                	addiw	a1,a1,1
    80000d2a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d2e:	4719                	li	a4,6
    80000d30:	6685                	lui	a3,0x1
    80000d32:	40b905b3          	sub	a1,s2,a1
    80000d36:	854e                	mv	a0,s3
    80000d38:	00000097          	auipc	ra,0x0
    80000d3c:	8b0080e7          	jalr	-1872(ra) # 800005e8 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	27848493          	addi	s1,s1,632
    80000d44:	fd4495e3          	bne	s1,s4,80000d0e <proc_mapstacks+0x38>
  }
}
    80000d48:	70e2                	ld	ra,56(sp)
    80000d4a:	7442                	ld	s0,48(sp)
    80000d4c:	74a2                	ld	s1,40(sp)
    80000d4e:	7902                	ld	s2,32(sp)
    80000d50:	69e2                	ld	s3,24(sp)
    80000d52:	6a42                	ld	s4,16(sp)
    80000d54:	6aa2                	ld	s5,8(sp)
    80000d56:	6b02                	ld	s6,0(sp)
    80000d58:	6121                	addi	sp,sp,64
    80000d5a:	8082                	ret
      panic("kalloc");
    80000d5c:	00007517          	auipc	a0,0x7
    80000d60:	3fc50513          	addi	a0,a0,1020 # 80008158 <etext+0x158>
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	044080e7          	jalr	68(ra) # 80005da8 <panic>

0000000080000d6c <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	3e058593          	addi	a1,a1,992 # 80008160 <etext+0x160>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	2c850513          	addi	a0,a0,712 # 80009050 <pid_lock>
    80000d90:	00005097          	auipc	ra,0x5
    80000d94:	540080e7          	jalr	1344(ra) # 800062d0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d98:	00007597          	auipc	a1,0x7
    80000d9c:	3d058593          	addi	a1,a1,976 # 80008168 <etext+0x168>
    80000da0:	00008517          	auipc	a0,0x8
    80000da4:	2c850513          	addi	a0,a0,712 # 80009068 <wait_lock>
    80000da8:	00005097          	auipc	ra,0x5
    80000dac:	528080e7          	jalr	1320(ra) # 800062d0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	00008497          	auipc	s1,0x8
    80000db4:	6d048493          	addi	s1,s1,1744 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000db8:	00007b17          	auipc	s6,0x7
    80000dbc:	3c0b0b13          	addi	s6,s6,960 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000dc0:	8aa6                	mv	s5,s1
    80000dc2:	00007a17          	auipc	s4,0x7
    80000dc6:	23ea0a13          	addi	s4,s4,574 # 80008000 <etext>
    80000dca:	04000937          	lui	s2,0x4000
    80000dce:	197d                	addi	s2,s2,-1
    80000dd0:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd2:	00012997          	auipc	s3,0x12
    80000dd6:	4ae98993          	addi	s3,s3,1198 # 80013280 <tickslock>
      initlock(&p->lock, "proc");
    80000dda:	85da                	mv	a1,s6
    80000ddc:	8526                	mv	a0,s1
    80000dde:	00005097          	auipc	ra,0x5
    80000de2:	4f2080e7          	jalr	1266(ra) # 800062d0 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000de6:	415487b3          	sub	a5,s1,s5
    80000dea:	878d                	srai	a5,a5,0x3
    80000dec:	000a3703          	ld	a4,0(s4)
    80000df0:	02e787b3          	mul	a5,a5,a4
    80000df4:	2785                	addiw	a5,a5,1
    80000df6:	00d7979b          	slliw	a5,a5,0xd
    80000dfa:	40f907b3          	sub	a5,s2,a5
    80000dfe:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	27848493          	addi	s1,s1,632
    80000e04:	fd349be3          	bne	s1,s3,80000dda <procinit+0x6e>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e22:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e24:	2501                	sext.w	a0,a0
    80000e26:	6422                	ld	s0,8(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
    80000e32:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e34:	2781                	sext.w	a5,a5
    80000e36:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e38:	00008517          	auipc	a0,0x8
    80000e3c:	24850513          	addi	a0,a0,584 # 80009080 <cpus>
    80000e40:	953e                	add	a0,a0,a5
    80000e42:	6422                	ld	s0,8(sp)
    80000e44:	0141                	addi	sp,sp,16
    80000e46:	8082                	ret

0000000080000e48 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e48:	1101                	addi	sp,sp,-32
    80000e4a:	ec06                	sd	ra,24(sp)
    80000e4c:	e822                	sd	s0,16(sp)
    80000e4e:	e426                	sd	s1,8(sp)
    80000e50:	1000                	addi	s0,sp,32
  push_off();
    80000e52:	00005097          	auipc	ra,0x5
    80000e56:	4c2080e7          	jalr	1218(ra) # 80006314 <push_off>
    80000e5a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e5c:	2781                	sext.w	a5,a5
    80000e5e:	079e                	slli	a5,a5,0x7
    80000e60:	00008717          	auipc	a4,0x8
    80000e64:	1f070713          	addi	a4,a4,496 # 80009050 <pid_lock>
    80000e68:	97ba                	add	a5,a5,a4
    80000e6a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	548080e7          	jalr	1352(ra) # 800063b4 <pop_off>
  return p;
}
    80000e74:	8526                	mv	a0,s1
    80000e76:	60e2                	ld	ra,24(sp)
    80000e78:	6442                	ld	s0,16(sp)
    80000e7a:	64a2                	ld	s1,8(sp)
    80000e7c:	6105                	addi	sp,sp,32
    80000e7e:	8082                	ret

0000000080000e80 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e88:	00000097          	auipc	ra,0x0
    80000e8c:	fc0080e7          	jalr	-64(ra) # 80000e48 <myproc>
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	584080e7          	jalr	1412(ra) # 80006414 <release>

  if (first) {
    80000e98:	00008797          	auipc	a5,0x8
    80000e9c:	9a87a783          	lw	a5,-1624(a5) # 80008840 <first.1713>
    80000ea0:	eb89                	bnez	a5,80000eb2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ea2:	00001097          	auipc	ra,0x1
    80000ea6:	c1a080e7          	jalr	-998(ra) # 80001abc <usertrapret>
}
    80000eaa:	60a2                	ld	ra,8(sp)
    80000eac:	6402                	ld	s0,0(sp)
    80000eae:	0141                	addi	sp,sp,16
    80000eb0:	8082                	ret
    first = 0;
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	9807a723          	sw	zero,-1650(a5) # 80008840 <first.1713>
    fsinit(ROOTDEV);
    80000eba:	4505                	li	a0,1
    80000ebc:	00002097          	auipc	ra,0x2
    80000ec0:	bc0080e7          	jalr	-1088(ra) # 80002a7c <fsinit>
    80000ec4:	bff9                	j	80000ea2 <forkret+0x22>

0000000080000ec6 <allocpid>:
allocpid() {
    80000ec6:	1101                	addi	sp,sp,-32
    80000ec8:	ec06                	sd	ra,24(sp)
    80000eca:	e822                	sd	s0,16(sp)
    80000ecc:	e426                	sd	s1,8(sp)
    80000ece:	e04a                	sd	s2,0(sp)
    80000ed0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ed2:	00008917          	auipc	s2,0x8
    80000ed6:	17e90913          	addi	s2,s2,382 # 80009050 <pid_lock>
    80000eda:	854a                	mv	a0,s2
    80000edc:	00005097          	auipc	ra,0x5
    80000ee0:	484080e7          	jalr	1156(ra) # 80006360 <acquire>
  pid = nextpid;
    80000ee4:	00008797          	auipc	a5,0x8
    80000ee8:	96078793          	addi	a5,a5,-1696 # 80008844 <nextpid>
    80000eec:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000eee:	0014871b          	addiw	a4,s1,1
    80000ef2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	51e080e7          	jalr	1310(ra) # 80006414 <release>
}
    80000efe:	8526                	mv	a0,s1
    80000f00:	60e2                	ld	ra,24(sp)
    80000f02:	6442                	ld	s0,16(sp)
    80000f04:	64a2                	ld	s1,8(sp)
    80000f06:	6902                	ld	s2,0(sp)
    80000f08:	6105                	addi	sp,sp,32
    80000f0a:	8082                	ret

0000000080000f0c <proc_pagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	8b8080e7          	jalr	-1864(ra) # 800007d2 <uvmcreate>
    80000f22:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f24:	c121                	beqz	a0,80000f64 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f26:	4729                	li	a4,10
    80000f28:	00006697          	auipc	a3,0x6
    80000f2c:	0d868693          	addi	a3,a3,216 # 80007000 <_trampoline>
    80000f30:	6605                	lui	a2,0x1
    80000f32:	040005b7          	lui	a1,0x4000
    80000f36:	15fd                	addi	a1,a1,-1
    80000f38:	05b2                	slli	a1,a1,0xc
    80000f3a:	fffff097          	auipc	ra,0xfffff
    80000f3e:	60e080e7          	jalr	1550(ra) # 80000548 <mappages>
    80000f42:	02054863          	bltz	a0,80000f72 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f46:	4719                	li	a4,6
    80000f48:	06893683          	ld	a3,104(s2)
    80000f4c:	6605                	lui	a2,0x1
    80000f4e:	020005b7          	lui	a1,0x2000
    80000f52:	15fd                	addi	a1,a1,-1
    80000f54:	05b6                	slli	a1,a1,0xd
    80000f56:	8526                	mv	a0,s1
    80000f58:	fffff097          	auipc	ra,0xfffff
    80000f5c:	5f0080e7          	jalr	1520(ra) # 80000548 <mappages>
    80000f60:	02054163          	bltz	a0,80000f82 <proc_pagetable+0x76>
}
    80000f64:	8526                	mv	a0,s1
    80000f66:	60e2                	ld	ra,24(sp)
    80000f68:	6442                	ld	s0,16(sp)
    80000f6a:	64a2                	ld	s1,8(sp)
    80000f6c:	6902                	ld	s2,0(sp)
    80000f6e:	6105                	addi	sp,sp,32
    80000f70:	8082                	ret
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	a58080e7          	jalr	-1448(ra) # 800009ce <uvmfree>
    return 0;
    80000f7e:	4481                	li	s1,0
    80000f80:	b7d5                	j	80000f64 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f82:	4681                	li	a3,0
    80000f84:	4605                	li	a2,1
    80000f86:	040005b7          	lui	a1,0x4000
    80000f8a:	15fd                	addi	a1,a1,-1
    80000f8c:	05b2                	slli	a1,a1,0xc
    80000f8e:	8526                	mv	a0,s1
    80000f90:	fffff097          	auipc	ra,0xfffff
    80000f94:	77e080e7          	jalr	1918(ra) # 8000070e <uvmunmap>
    uvmfree(pagetable, 0);
    80000f98:	4581                	li	a1,0
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	00000097          	auipc	ra,0x0
    80000fa0:	a32080e7          	jalr	-1486(ra) # 800009ce <uvmfree>
    return 0;
    80000fa4:	4481                	li	s1,0
    80000fa6:	bf7d                	j	80000f64 <proc_pagetable+0x58>

0000000080000fa8 <proc_freepagetable>:
{
    80000fa8:	1101                	addi	sp,sp,-32
    80000faa:	ec06                	sd	ra,24(sp)
    80000fac:	e822                	sd	s0,16(sp)
    80000fae:	e426                	sd	s1,8(sp)
    80000fb0:	e04a                	sd	s2,0(sp)
    80000fb2:	1000                	addi	s0,sp,32
    80000fb4:	84aa                	mv	s1,a0
    80000fb6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	74a080e7          	jalr	1866(ra) # 8000070e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fcc:	4681                	li	a3,0
    80000fce:	4605                	li	a2,1
    80000fd0:	020005b7          	lui	a1,0x2000
    80000fd4:	15fd                	addi	a1,a1,-1
    80000fd6:	05b6                	slli	a1,a1,0xd
    80000fd8:	8526                	mv	a0,s1
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	734080e7          	jalr	1844(ra) # 8000070e <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe2:	85ca                	mv	a1,s2
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00000097          	auipc	ra,0x0
    80000fea:	9e8080e7          	jalr	-1560(ra) # 800009ce <uvmfree>
}
    80000fee:	60e2                	ld	ra,24(sp)
    80000ff0:	6442                	ld	s0,16(sp)
    80000ff2:	64a2                	ld	s1,8(sp)
    80000ff4:	6902                	ld	s2,0(sp)
    80000ff6:	6105                	addi	sp,sp,32
    80000ff8:	8082                	ret

0000000080000ffa <freeproc>:
{
    80000ffa:	1101                	addi	sp,sp,-32
    80000ffc:	ec06                	sd	ra,24(sp)
    80000ffe:	e822                	sd	s0,16(sp)
    80001000:	e426                	sd	s1,8(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001006:	7528                	ld	a0,104(a0)
    80001008:	c509                	beqz	a0,80001012 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000100a:	fffff097          	auipc	ra,0xfffff
    8000100e:	012080e7          	jalr	18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001012:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001016:	70a8                	ld	a0,96(s1)
    80001018:	c511                	beqz	a0,80001024 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000101a:	68ac                	ld	a1,80(s1)
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	f8c080e7          	jalr	-116(ra) # 80000fa8 <proc_freepagetable>
  p->pagetable = 0;
    80001024:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001028:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000102c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001030:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001034:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001038:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001040:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001044:	0004ac23          	sw	zero,24(s1)
}
    80001048:	60e2                	ld	ra,24(sp)
    8000104a:	6442                	ld	s0,16(sp)
    8000104c:	64a2                	ld	s1,8(sp)
    8000104e:	6105                	addi	sp,sp,32
    80001050:	8082                	ret

0000000080001052 <allocproc>:
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	e04a                	sd	s2,0(sp)
    8000105c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105e:	00008497          	auipc	s1,0x8
    80001062:	42248493          	addi	s1,s1,1058 # 80009480 <proc>
    80001066:	00012917          	auipc	s2,0x12
    8000106a:	21a90913          	addi	s2,s2,538 # 80013280 <tickslock>
    acquire(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	00005097          	auipc	ra,0x5
    80001074:	2f0080e7          	jalr	752(ra) # 80006360 <acquire>
    if(p->state == UNUSED) {
    80001078:	4c9c                	lw	a5,24(s1)
    8000107a:	cf81                	beqz	a5,80001092 <allocproc+0x40>
      release(&p->lock);
    8000107c:	8526                	mv	a0,s1
    8000107e:	00005097          	auipc	ra,0x5
    80001082:	396080e7          	jalr	918(ra) # 80006414 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	27848493          	addi	s1,s1,632
    8000108a:	ff2492e3          	bne	s1,s2,8000106e <allocproc+0x1c>
  return 0;
    8000108e:	4481                	li	s1,0
    80001090:	a08d                	j	800010f2 <allocproc+0xa0>
  p->pid = allocpid();
    80001092:	00000097          	auipc	ra,0x0
    80001096:	e34080e7          	jalr	-460(ra) # 80000ec6 <allocpid>
    8000109a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000109c:	4785                	li	a5,1
    8000109e:	cc9c                	sw	a5,24(s1)
  p->alarm = 0;
    800010a0:	0204aa23          	sw	zero,52(s1)
  p->cu_alarm = 0;
    800010a4:	0204ac23          	sw	zero,56(s1)
  p->alret = 0;
    800010a8:	0404bc23          	sd	zero,88(s1)
  p->c_alret = 0;
    800010ac:	0204ae23          	sw	zero,60(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	068080e7          	jalr	104(ra) # 80000118 <kalloc>
    800010b8:	892a                	mv	s2,a0
    800010ba:	f4a8                	sd	a0,104(s1)
    800010bc:	c131                	beqz	a0,80001100 <allocproc+0xae>
  p->pagetable = proc_pagetable(p);
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	e4c080e7          	jalr	-436(ra) # 80000f0c <proc_pagetable>
    800010c8:	892a                	mv	s2,a0
    800010ca:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    800010cc:	c531                	beqz	a0,80001118 <allocproc+0xc6>
  memset(&p->context, 0, sizeof(p->context));
    800010ce:	07000613          	li	a2,112
    800010d2:	4581                	li	a1,0
    800010d4:	07048513          	addi	a0,s1,112
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	0a0080e7          	jalr	160(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e0:	00000797          	auipc	a5,0x0
    800010e4:	da078793          	addi	a5,a5,-608 # 80000e80 <forkret>
    800010e8:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ea:	64bc                	ld	a5,72(s1)
    800010ec:	6705                	lui	a4,0x1
    800010ee:	97ba                	add	a5,a5,a4
    800010f0:	fcbc                	sd	a5,120(s1)
}
    800010f2:	8526                	mv	a0,s1
    800010f4:	60e2                	ld	ra,24(sp)
    800010f6:	6442                	ld	s0,16(sp)
    800010f8:	64a2                	ld	s1,8(sp)
    800010fa:	6902                	ld	s2,0(sp)
    800010fc:	6105                	addi	sp,sp,32
    800010fe:	8082                	ret
    freeproc(p);
    80001100:	8526                	mv	a0,s1
    80001102:	00000097          	auipc	ra,0x0
    80001106:	ef8080e7          	jalr	-264(ra) # 80000ffa <freeproc>
    release(&p->lock);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00005097          	auipc	ra,0x5
    80001110:	308080e7          	jalr	776(ra) # 80006414 <release>
    return 0;
    80001114:	84ca                	mv	s1,s2
    80001116:	bff1                	j	800010f2 <allocproc+0xa0>
    freeproc(p);
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	ee0080e7          	jalr	-288(ra) # 80000ffa <freeproc>
    release(&p->lock);
    80001122:	8526                	mv	a0,s1
    80001124:	00005097          	auipc	ra,0x5
    80001128:	2f0080e7          	jalr	752(ra) # 80006414 <release>
    return 0;
    8000112c:	84ca                	mv	s1,s2
    8000112e:	b7d1                	j	800010f2 <allocproc+0xa0>

0000000080001130 <userinit>:
{
    80001130:	1101                	addi	sp,sp,-32
    80001132:	ec06                	sd	ra,24(sp)
    80001134:	e822                	sd	s0,16(sp)
    80001136:	e426                	sd	s1,8(sp)
    80001138:	1000                	addi	s0,sp,32
  p = allocproc();
    8000113a:	00000097          	auipc	ra,0x0
    8000113e:	f18080e7          	jalr	-232(ra) # 80001052 <allocproc>
    80001142:	84aa                	mv	s1,a0
  initproc = p;
    80001144:	00008797          	auipc	a5,0x8
    80001148:	eca7b623          	sd	a0,-308(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000114c:	03400613          	li	a2,52
    80001150:	00007597          	auipc	a1,0x7
    80001154:	70058593          	addi	a1,a1,1792 # 80008850 <initcode>
    80001158:	7128                	ld	a0,96(a0)
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	6a6080e7          	jalr	1702(ra) # 80000800 <uvminit>
  p->sz = PGSIZE;
    80001162:	6785                	lui	a5,0x1
    80001164:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    80001166:	74b8                	ld	a4,104(s1)
    80001168:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000116c:	74b8                	ld	a4,104(s1)
    8000116e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001170:	4641                	li	a2,16
    80001172:	00007597          	auipc	a1,0x7
    80001176:	00e58593          	addi	a1,a1,14 # 80008180 <etext+0x180>
    8000117a:	16848513          	addi	a0,s1,360
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	14c080e7          	jalr	332(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001186:	00007517          	auipc	a0,0x7
    8000118a:	00a50513          	addi	a0,a0,10 # 80008190 <etext+0x190>
    8000118e:	00002097          	auipc	ra,0x2
    80001192:	31c080e7          	jalr	796(ra) # 800034aa <namei>
    80001196:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    8000119a:	478d                	li	a5,3
    8000119c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000119e:	8526                	mv	a0,s1
    800011a0:	00005097          	auipc	ra,0x5
    800011a4:	274080e7          	jalr	628(ra) # 80006414 <release>
}
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6105                	addi	sp,sp,32
    800011b0:	8082                	ret

00000000800011b2 <growproc>:
{
    800011b2:	1101                	addi	sp,sp,-32
    800011b4:	ec06                	sd	ra,24(sp)
    800011b6:	e822                	sd	s0,16(sp)
    800011b8:	e426                	sd	s1,8(sp)
    800011ba:	e04a                	sd	s2,0(sp)
    800011bc:	1000                	addi	s0,sp,32
    800011be:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011c0:	00000097          	auipc	ra,0x0
    800011c4:	c88080e7          	jalr	-888(ra) # 80000e48 <myproc>
    800011c8:	892a                	mv	s2,a0
  sz = p->sz;
    800011ca:	692c                	ld	a1,80(a0)
    800011cc:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011d0:	00904f63          	bgtz	s1,800011ee <growproc+0x3c>
  } else if(n < 0){
    800011d4:	0204cc63          	bltz	s1,8000120c <growproc+0x5a>
  p->sz = sz;
    800011d8:	1602                	slli	a2,a2,0x20
    800011da:	9201                	srli	a2,a2,0x20
    800011dc:	04c93823          	sd	a2,80(s2)
  return 0;
    800011e0:	4501                	li	a0,0
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6902                	ld	s2,0(sp)
    800011ea:	6105                	addi	sp,sp,32
    800011ec:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800011ee:	9e25                	addw	a2,a2,s1
    800011f0:	1602                	slli	a2,a2,0x20
    800011f2:	9201                	srli	a2,a2,0x20
    800011f4:	1582                	slli	a1,a1,0x20
    800011f6:	9181                	srli	a1,a1,0x20
    800011f8:	7128                	ld	a0,96(a0)
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	6c0080e7          	jalr	1728(ra) # 800008ba <uvmalloc>
    80001202:	0005061b          	sext.w	a2,a0
    80001206:	fa69                	bnez	a2,800011d8 <growproc+0x26>
      return -1;
    80001208:	557d                	li	a0,-1
    8000120a:	bfe1                	j	800011e2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000120c:	9e25                	addw	a2,a2,s1
    8000120e:	1602                	slli	a2,a2,0x20
    80001210:	9201                	srli	a2,a2,0x20
    80001212:	1582                	slli	a1,a1,0x20
    80001214:	9181                	srli	a1,a1,0x20
    80001216:	7128                	ld	a0,96(a0)
    80001218:	fffff097          	auipc	ra,0xfffff
    8000121c:	65a080e7          	jalr	1626(ra) # 80000872 <uvmdealloc>
    80001220:	0005061b          	sext.w	a2,a0
    80001224:	bf55                	j	800011d8 <growproc+0x26>

0000000080001226 <fork>:
{
    80001226:	7179                	addi	sp,sp,-48
    80001228:	f406                	sd	ra,40(sp)
    8000122a:	f022                	sd	s0,32(sp)
    8000122c:	ec26                	sd	s1,24(sp)
    8000122e:	e84a                	sd	s2,16(sp)
    80001230:	e44e                	sd	s3,8(sp)
    80001232:	e052                	sd	s4,0(sp)
    80001234:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	c12080e7          	jalr	-1006(ra) # 80000e48 <myproc>
    8000123e:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001240:	00000097          	auipc	ra,0x0
    80001244:	e12080e7          	jalr	-494(ra) # 80001052 <allocproc>
    80001248:	10050b63          	beqz	a0,8000135e <fork+0x138>
    8000124c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000124e:	05093603          	ld	a2,80(s2)
    80001252:	712c                	ld	a1,96(a0)
    80001254:	06093503          	ld	a0,96(s2)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	7ae080e7          	jalr	1966(ra) # 80000a06 <uvmcopy>
    80001260:	04054663          	bltz	a0,800012ac <fork+0x86>
  np->sz = p->sz;
    80001264:	05093783          	ld	a5,80(s2)
    80001268:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    8000126c:	06893683          	ld	a3,104(s2)
    80001270:	87b6                	mv	a5,a3
    80001272:	0689b703          	ld	a4,104(s3)
    80001276:	12068693          	addi	a3,a3,288
    8000127a:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000127e:	6788                	ld	a0,8(a5)
    80001280:	6b8c                	ld	a1,16(a5)
    80001282:	6f90                	ld	a2,24(a5)
    80001284:	01073023          	sd	a6,0(a4)
    80001288:	e708                	sd	a0,8(a4)
    8000128a:	eb0c                	sd	a1,16(a4)
    8000128c:	ef10                	sd	a2,24(a4)
    8000128e:	02078793          	addi	a5,a5,32
    80001292:	02070713          	addi	a4,a4,32
    80001296:	fed792e3          	bne	a5,a3,8000127a <fork+0x54>
  np->trapframe->a0 = 0;
    8000129a:	0689b783          	ld	a5,104(s3)
    8000129e:	0607b823          	sd	zero,112(a5)
    800012a2:	0e000493          	li	s1,224
  for(i = 0; i < NOFILE; i++)
    800012a6:	16000a13          	li	s4,352
    800012aa:	a03d                	j	800012d8 <fork+0xb2>
    freeproc(np);
    800012ac:	854e                	mv	a0,s3
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	d4c080e7          	jalr	-692(ra) # 80000ffa <freeproc>
    release(&np->lock);
    800012b6:	854e                	mv	a0,s3
    800012b8:	00005097          	auipc	ra,0x5
    800012bc:	15c080e7          	jalr	348(ra) # 80006414 <release>
    return -1;
    800012c0:	5a7d                	li	s4,-1
    800012c2:	a069                	j	8000134c <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012c4:	00003097          	auipc	ra,0x3
    800012c8:	87c080e7          	jalr	-1924(ra) # 80003b40 <filedup>
    800012cc:	009987b3          	add	a5,s3,s1
    800012d0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012d2:	04a1                	addi	s1,s1,8
    800012d4:	01448763          	beq	s1,s4,800012e2 <fork+0xbc>
    if(p->ofile[i])
    800012d8:	009907b3          	add	a5,s2,s1
    800012dc:	6388                	ld	a0,0(a5)
    800012de:	f17d                	bnez	a0,800012c4 <fork+0x9e>
    800012e0:	bfcd                	j	800012d2 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012e2:	16093503          	ld	a0,352(s2)
    800012e6:	00002097          	auipc	ra,0x2
    800012ea:	9d0080e7          	jalr	-1584(ra) # 80002cb6 <idup>
    800012ee:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012f2:	4641                	li	a2,16
    800012f4:	16890593          	addi	a1,s2,360
    800012f8:	16898513          	addi	a0,s3,360
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	fce080e7          	jalr	-50(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001304:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001308:	854e                	mv	a0,s3
    8000130a:	00005097          	auipc	ra,0x5
    8000130e:	10a080e7          	jalr	266(ra) # 80006414 <release>
  acquire(&wait_lock);
    80001312:	00008497          	auipc	s1,0x8
    80001316:	d5648493          	addi	s1,s1,-682 # 80009068 <wait_lock>
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	044080e7          	jalr	68(ra) # 80006360 <acquire>
  np->parent = p;
    80001324:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	0ea080e7          	jalr	234(ra) # 80006414 <release>
  acquire(&np->lock);
    80001332:	854e                	mv	a0,s3
    80001334:	00005097          	auipc	ra,0x5
    80001338:	02c080e7          	jalr	44(ra) # 80006360 <acquire>
  np->state = RUNNABLE;
    8000133c:	478d                	li	a5,3
    8000133e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001342:	854e                	mv	a0,s3
    80001344:	00005097          	auipc	ra,0x5
    80001348:	0d0080e7          	jalr	208(ra) # 80006414 <release>
}
    8000134c:	8552                	mv	a0,s4
    8000134e:	70a2                	ld	ra,40(sp)
    80001350:	7402                	ld	s0,32(sp)
    80001352:	64e2                	ld	s1,24(sp)
    80001354:	6942                	ld	s2,16(sp)
    80001356:	69a2                	ld	s3,8(sp)
    80001358:	6a02                	ld	s4,0(sp)
    8000135a:	6145                	addi	sp,sp,48
    8000135c:	8082                	ret
    return -1;
    8000135e:	5a7d                	li	s4,-1
    80001360:	b7f5                	j	8000134c <fork+0x126>

0000000080001362 <scheduler>:
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	f426                	sd	s1,40(sp)
    8000136a:	f04a                	sd	s2,32(sp)
    8000136c:	ec4e                	sd	s3,24(sp)
    8000136e:	e852                	sd	s4,16(sp)
    80001370:	e456                	sd	s5,8(sp)
    80001372:	e05a                	sd	s6,0(sp)
    80001374:	0080                	addi	s0,sp,64
    80001376:	8792                	mv	a5,tp
  int id = r_tp();
    80001378:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000137a:	00779a93          	slli	s5,a5,0x7
    8000137e:	00008717          	auipc	a4,0x8
    80001382:	cd270713          	addi	a4,a4,-814 # 80009050 <pid_lock>
    80001386:	9756                	add	a4,a4,s5
    80001388:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000138c:	00008717          	auipc	a4,0x8
    80001390:	cfc70713          	addi	a4,a4,-772 # 80009088 <cpus+0x8>
    80001394:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001396:	498d                	li	s3,3
        p->state = RUNNING;
    80001398:	4b11                	li	s6,4
        c->proc = p;
    8000139a:	079e                	slli	a5,a5,0x7
    8000139c:	00008a17          	auipc	s4,0x8
    800013a0:	cb4a0a13          	addi	s4,s4,-844 # 80009050 <pid_lock>
    800013a4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013a6:	00012917          	auipc	s2,0x12
    800013aa:	eda90913          	addi	s2,s2,-294 # 80013280 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013b2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013b6:	10079073          	csrw	sstatus,a5
    800013ba:	00008497          	auipc	s1,0x8
    800013be:	0c648493          	addi	s1,s1,198 # 80009480 <proc>
    800013c2:	a03d                	j	800013f0 <scheduler+0x8e>
        p->state = RUNNING;
    800013c4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013c8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013cc:	07048593          	addi	a1,s1,112
    800013d0:	8556                	mv	a0,s5
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	640080e7          	jalr	1600(ra) # 80001a12 <swtch>
        c->proc = 0;
    800013da:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013de:	8526                	mv	a0,s1
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	034080e7          	jalr	52(ra) # 80006414 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013e8:	27848493          	addi	s1,s1,632
    800013ec:	fd2481e3          	beq	s1,s2,800013ae <scheduler+0x4c>
      acquire(&p->lock);
    800013f0:	8526                	mv	a0,s1
    800013f2:	00005097          	auipc	ra,0x5
    800013f6:	f6e080e7          	jalr	-146(ra) # 80006360 <acquire>
      if(p->state == RUNNABLE) {
    800013fa:	4c9c                	lw	a5,24(s1)
    800013fc:	ff3791e3          	bne	a5,s3,800013de <scheduler+0x7c>
    80001400:	b7d1                	j	800013c4 <scheduler+0x62>

0000000080001402 <sched>:
{
    80001402:	7179                	addi	sp,sp,-48
    80001404:	f406                	sd	ra,40(sp)
    80001406:	f022                	sd	s0,32(sp)
    80001408:	ec26                	sd	s1,24(sp)
    8000140a:	e84a                	sd	s2,16(sp)
    8000140c:	e44e                	sd	s3,8(sp)
    8000140e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001410:	00000097          	auipc	ra,0x0
    80001414:	a38080e7          	jalr	-1480(ra) # 80000e48 <myproc>
    80001418:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000141a:	00005097          	auipc	ra,0x5
    8000141e:	ecc080e7          	jalr	-308(ra) # 800062e6 <holding>
    80001422:	c93d                	beqz	a0,80001498 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001424:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001426:	2781                	sext.w	a5,a5
    80001428:	079e                	slli	a5,a5,0x7
    8000142a:	00008717          	auipc	a4,0x8
    8000142e:	c2670713          	addi	a4,a4,-986 # 80009050 <pid_lock>
    80001432:	97ba                	add	a5,a5,a4
    80001434:	0a87a703          	lw	a4,168(a5)
    80001438:	4785                	li	a5,1
    8000143a:	06f71763          	bne	a4,a5,800014a8 <sched+0xa6>
  if(p->state == RUNNING)
    8000143e:	4c98                	lw	a4,24(s1)
    80001440:	4791                	li	a5,4
    80001442:	06f70b63          	beq	a4,a5,800014b8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001446:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000144a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000144c:	efb5                	bnez	a5,800014c8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001450:	00008917          	auipc	s2,0x8
    80001454:	c0090913          	addi	s2,s2,-1024 # 80009050 <pid_lock>
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	97ca                	add	a5,a5,s2
    8000145e:	0ac7a983          	lw	s3,172(a5)
    80001462:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001464:	2781                	sext.w	a5,a5
    80001466:	079e                	slli	a5,a5,0x7
    80001468:	00008597          	auipc	a1,0x8
    8000146c:	c2058593          	addi	a1,a1,-992 # 80009088 <cpus+0x8>
    80001470:	95be                	add	a1,a1,a5
    80001472:	07048513          	addi	a0,s1,112
    80001476:	00000097          	auipc	ra,0x0
    8000147a:	59c080e7          	jalr	1436(ra) # 80001a12 <swtch>
    8000147e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001480:	2781                	sext.w	a5,a5
    80001482:	079e                	slli	a5,a5,0x7
    80001484:	97ca                	add	a5,a5,s2
    80001486:	0b37a623          	sw	s3,172(a5)
}
    8000148a:	70a2                	ld	ra,40(sp)
    8000148c:	7402                	ld	s0,32(sp)
    8000148e:	64e2                	ld	s1,24(sp)
    80001490:	6942                	ld	s2,16(sp)
    80001492:	69a2                	ld	s3,8(sp)
    80001494:	6145                	addi	sp,sp,48
    80001496:	8082                	ret
    panic("sched p->lock");
    80001498:	00007517          	auipc	a0,0x7
    8000149c:	d0050513          	addi	a0,a0,-768 # 80008198 <etext+0x198>
    800014a0:	00005097          	auipc	ra,0x5
    800014a4:	908080e7          	jalr	-1784(ra) # 80005da8 <panic>
    panic("sched locks");
    800014a8:	00007517          	auipc	a0,0x7
    800014ac:	d0050513          	addi	a0,a0,-768 # 800081a8 <etext+0x1a8>
    800014b0:	00005097          	auipc	ra,0x5
    800014b4:	8f8080e7          	jalr	-1800(ra) # 80005da8 <panic>
    panic("sched running");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d0050513          	addi	a0,a0,-768 # 800081b8 <etext+0x1b8>
    800014c0:	00005097          	auipc	ra,0x5
    800014c4:	8e8080e7          	jalr	-1816(ra) # 80005da8 <panic>
    panic("sched interruptible");
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	d0050513          	addi	a0,a0,-768 # 800081c8 <etext+0x1c8>
    800014d0:	00005097          	auipc	ra,0x5
    800014d4:	8d8080e7          	jalr	-1832(ra) # 80005da8 <panic>

00000000800014d8 <yield>:
{
    800014d8:	1101                	addi	sp,sp,-32
    800014da:	ec06                	sd	ra,24(sp)
    800014dc:	e822                	sd	s0,16(sp)
    800014de:	e426                	sd	s1,8(sp)
    800014e0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	966080e7          	jalr	-1690(ra) # 80000e48 <myproc>
    800014ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	e74080e7          	jalr	-396(ra) # 80006360 <acquire>
  p->state = RUNNABLE;
    800014f4:	478d                	li	a5,3
    800014f6:	cc9c                	sw	a5,24(s1)
  sched();
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	f0a080e7          	jalr	-246(ra) # 80001402 <sched>
  release(&p->lock);
    80001500:	8526                	mv	a0,s1
    80001502:	00005097          	auipc	ra,0x5
    80001506:	f12080e7          	jalr	-238(ra) # 80006414 <release>
}
    8000150a:	60e2                	ld	ra,24(sp)
    8000150c:	6442                	ld	s0,16(sp)
    8000150e:	64a2                	ld	s1,8(sp)
    80001510:	6105                	addi	sp,sp,32
    80001512:	8082                	ret

0000000080001514 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001514:	7179                	addi	sp,sp,-48
    80001516:	f406                	sd	ra,40(sp)
    80001518:	f022                	sd	s0,32(sp)
    8000151a:	ec26                	sd	s1,24(sp)
    8000151c:	e84a                	sd	s2,16(sp)
    8000151e:	e44e                	sd	s3,8(sp)
    80001520:	1800                	addi	s0,sp,48
    80001522:	89aa                	mv	s3,a0
    80001524:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001526:	00000097          	auipc	ra,0x0
    8000152a:	922080e7          	jalr	-1758(ra) # 80000e48 <myproc>
    8000152e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001530:	00005097          	auipc	ra,0x5
    80001534:	e30080e7          	jalr	-464(ra) # 80006360 <acquire>
  release(lk);
    80001538:	854a                	mv	a0,s2
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	eda080e7          	jalr	-294(ra) # 80006414 <release>

  // Go to sleep.
  p->chan = chan;
    80001542:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001546:	4789                	li	a5,2
    80001548:	cc9c                	sw	a5,24(s1)

  sched();
    8000154a:	00000097          	auipc	ra,0x0
    8000154e:	eb8080e7          	jalr	-328(ra) # 80001402 <sched>

  // Tidy up.
  p->chan = 0;
    80001552:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	00005097          	auipc	ra,0x5
    8000155c:	ebc080e7          	jalr	-324(ra) # 80006414 <release>
  acquire(lk);
    80001560:	854a                	mv	a0,s2
    80001562:	00005097          	auipc	ra,0x5
    80001566:	dfe080e7          	jalr	-514(ra) # 80006360 <acquire>
}
    8000156a:	70a2                	ld	ra,40(sp)
    8000156c:	7402                	ld	s0,32(sp)
    8000156e:	64e2                	ld	s1,24(sp)
    80001570:	6942                	ld	s2,16(sp)
    80001572:	69a2                	ld	s3,8(sp)
    80001574:	6145                	addi	sp,sp,48
    80001576:	8082                	ret

0000000080001578 <wait>:
{
    80001578:	715d                	addi	sp,sp,-80
    8000157a:	e486                	sd	ra,72(sp)
    8000157c:	e0a2                	sd	s0,64(sp)
    8000157e:	fc26                	sd	s1,56(sp)
    80001580:	f84a                	sd	s2,48(sp)
    80001582:	f44e                	sd	s3,40(sp)
    80001584:	f052                	sd	s4,32(sp)
    80001586:	ec56                	sd	s5,24(sp)
    80001588:	e85a                	sd	s6,16(sp)
    8000158a:	e45e                	sd	s7,8(sp)
    8000158c:	e062                	sd	s8,0(sp)
    8000158e:	0880                	addi	s0,sp,80
    80001590:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001592:	00000097          	auipc	ra,0x0
    80001596:	8b6080e7          	jalr	-1866(ra) # 80000e48 <myproc>
    8000159a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000159c:	00008517          	auipc	a0,0x8
    800015a0:	acc50513          	addi	a0,a0,-1332 # 80009068 <wait_lock>
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	dbc080e7          	jalr	-580(ra) # 80006360 <acquire>
    havekids = 0;
    800015ac:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ae:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015b0:	00012997          	auipc	s3,0x12
    800015b4:	cd098993          	addi	s3,s3,-816 # 80013280 <tickslock>
        havekids = 1;
    800015b8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015ba:	00008c17          	auipc	s8,0x8
    800015be:	aaec0c13          	addi	s8,s8,-1362 # 80009068 <wait_lock>
    havekids = 0;
    800015c2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015c4:	00008497          	auipc	s1,0x8
    800015c8:	ebc48493          	addi	s1,s1,-324 # 80009480 <proc>
    800015cc:	a0bd                	j	8000163a <wait+0xc2>
          pid = np->pid;
    800015ce:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015d2:	000b0e63          	beqz	s6,800015ee <wait+0x76>
    800015d6:	4691                	li	a3,4
    800015d8:	02c48613          	addi	a2,s1,44
    800015dc:	85da                	mv	a1,s6
    800015de:	06093503          	ld	a0,96(s2)
    800015e2:	fffff097          	auipc	ra,0xfffff
    800015e6:	528080e7          	jalr	1320(ra) # 80000b0a <copyout>
    800015ea:	02054563          	bltz	a0,80001614 <wait+0x9c>
          freeproc(np);
    800015ee:	8526                	mv	a0,s1
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	a0a080e7          	jalr	-1526(ra) # 80000ffa <freeproc>
          release(&np->lock);
    800015f8:	8526                	mv	a0,s1
    800015fa:	00005097          	auipc	ra,0x5
    800015fe:	e1a080e7          	jalr	-486(ra) # 80006414 <release>
          release(&wait_lock);
    80001602:	00008517          	auipc	a0,0x8
    80001606:	a6650513          	addi	a0,a0,-1434 # 80009068 <wait_lock>
    8000160a:	00005097          	auipc	ra,0x5
    8000160e:	e0a080e7          	jalr	-502(ra) # 80006414 <release>
          return pid;
    80001612:	a09d                	j	80001678 <wait+0x100>
            release(&np->lock);
    80001614:	8526                	mv	a0,s1
    80001616:	00005097          	auipc	ra,0x5
    8000161a:	dfe080e7          	jalr	-514(ra) # 80006414 <release>
            release(&wait_lock);
    8000161e:	00008517          	auipc	a0,0x8
    80001622:	a4a50513          	addi	a0,a0,-1462 # 80009068 <wait_lock>
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	dee080e7          	jalr	-530(ra) # 80006414 <release>
            return -1;
    8000162e:	59fd                	li	s3,-1
    80001630:	a0a1                	j	80001678 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001632:	27848493          	addi	s1,s1,632
    80001636:	03348463          	beq	s1,s3,8000165e <wait+0xe6>
      if(np->parent == p){
    8000163a:	60bc                	ld	a5,64(s1)
    8000163c:	ff279be3          	bne	a5,s2,80001632 <wait+0xba>
        acquire(&np->lock);
    80001640:	8526                	mv	a0,s1
    80001642:	00005097          	auipc	ra,0x5
    80001646:	d1e080e7          	jalr	-738(ra) # 80006360 <acquire>
        if(np->state == ZOMBIE){
    8000164a:	4c9c                	lw	a5,24(s1)
    8000164c:	f94781e3          	beq	a5,s4,800015ce <wait+0x56>
        release(&np->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	dc2080e7          	jalr	-574(ra) # 80006414 <release>
        havekids = 1;
    8000165a:	8756                	mv	a4,s5
    8000165c:	bfd9                	j	80001632 <wait+0xba>
    if(!havekids || p->killed){
    8000165e:	c701                	beqz	a4,80001666 <wait+0xee>
    80001660:	02892783          	lw	a5,40(s2)
    80001664:	c79d                	beqz	a5,80001692 <wait+0x11a>
      release(&wait_lock);
    80001666:	00008517          	auipc	a0,0x8
    8000166a:	a0250513          	addi	a0,a0,-1534 # 80009068 <wait_lock>
    8000166e:	00005097          	auipc	ra,0x5
    80001672:	da6080e7          	jalr	-602(ra) # 80006414 <release>
      return -1;
    80001676:	59fd                	li	s3,-1
}
    80001678:	854e                	mv	a0,s3
    8000167a:	60a6                	ld	ra,72(sp)
    8000167c:	6406                	ld	s0,64(sp)
    8000167e:	74e2                	ld	s1,56(sp)
    80001680:	7942                	ld	s2,48(sp)
    80001682:	79a2                	ld	s3,40(sp)
    80001684:	7a02                	ld	s4,32(sp)
    80001686:	6ae2                	ld	s5,24(sp)
    80001688:	6b42                	ld	s6,16(sp)
    8000168a:	6ba2                	ld	s7,8(sp)
    8000168c:	6c02                	ld	s8,0(sp)
    8000168e:	6161                	addi	sp,sp,80
    80001690:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001692:	85e2                	mv	a1,s8
    80001694:	854a                	mv	a0,s2
    80001696:	00000097          	auipc	ra,0x0
    8000169a:	e7e080e7          	jalr	-386(ra) # 80001514 <sleep>
    havekids = 0;
    8000169e:	b715                	j	800015c2 <wait+0x4a>

00000000800016a0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016a0:	7139                	addi	sp,sp,-64
    800016a2:	fc06                	sd	ra,56(sp)
    800016a4:	f822                	sd	s0,48(sp)
    800016a6:	f426                	sd	s1,40(sp)
    800016a8:	f04a                	sd	s2,32(sp)
    800016aa:	ec4e                	sd	s3,24(sp)
    800016ac:	e852                	sd	s4,16(sp)
    800016ae:	e456                	sd	s5,8(sp)
    800016b0:	0080                	addi	s0,sp,64
    800016b2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016b4:	00008497          	auipc	s1,0x8
    800016b8:	dcc48493          	addi	s1,s1,-564 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016bc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016be:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016c0:	00012917          	auipc	s2,0x12
    800016c4:	bc090913          	addi	s2,s2,-1088 # 80013280 <tickslock>
    800016c8:	a821                	j	800016e0 <wakeup+0x40>
        p->state = RUNNABLE;
    800016ca:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016ce:	8526                	mv	a0,s1
    800016d0:	00005097          	auipc	ra,0x5
    800016d4:	d44080e7          	jalr	-700(ra) # 80006414 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016d8:	27848493          	addi	s1,s1,632
    800016dc:	03248463          	beq	s1,s2,80001704 <wakeup+0x64>
    if(p != myproc()){
    800016e0:	fffff097          	auipc	ra,0xfffff
    800016e4:	768080e7          	jalr	1896(ra) # 80000e48 <myproc>
    800016e8:	fea488e3          	beq	s1,a0,800016d8 <wakeup+0x38>
      acquire(&p->lock);
    800016ec:	8526                	mv	a0,s1
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	c72080e7          	jalr	-910(ra) # 80006360 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016f6:	4c9c                	lw	a5,24(s1)
    800016f8:	fd379be3          	bne	a5,s3,800016ce <wakeup+0x2e>
    800016fc:	709c                	ld	a5,32(s1)
    800016fe:	fd4798e3          	bne	a5,s4,800016ce <wakeup+0x2e>
    80001702:	b7e1                	j	800016ca <wakeup+0x2a>
    }
  }
}
    80001704:	70e2                	ld	ra,56(sp)
    80001706:	7442                	ld	s0,48(sp)
    80001708:	74a2                	ld	s1,40(sp)
    8000170a:	7902                	ld	s2,32(sp)
    8000170c:	69e2                	ld	s3,24(sp)
    8000170e:	6a42                	ld	s4,16(sp)
    80001710:	6aa2                	ld	s5,8(sp)
    80001712:	6121                	addi	sp,sp,64
    80001714:	8082                	ret

0000000080001716 <reparent>:
{
    80001716:	7179                	addi	sp,sp,-48
    80001718:	f406                	sd	ra,40(sp)
    8000171a:	f022                	sd	s0,32(sp)
    8000171c:	ec26                	sd	s1,24(sp)
    8000171e:	e84a                	sd	s2,16(sp)
    80001720:	e44e                	sd	s3,8(sp)
    80001722:	e052                	sd	s4,0(sp)
    80001724:	1800                	addi	s0,sp,48
    80001726:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001728:	00008497          	auipc	s1,0x8
    8000172c:	d5848493          	addi	s1,s1,-680 # 80009480 <proc>
      pp->parent = initproc;
    80001730:	00008a17          	auipc	s4,0x8
    80001734:	8e0a0a13          	addi	s4,s4,-1824 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001738:	00012997          	auipc	s3,0x12
    8000173c:	b4898993          	addi	s3,s3,-1208 # 80013280 <tickslock>
    80001740:	a029                	j	8000174a <reparent+0x34>
    80001742:	27848493          	addi	s1,s1,632
    80001746:	01348d63          	beq	s1,s3,80001760 <reparent+0x4a>
    if(pp->parent == p){
    8000174a:	60bc                	ld	a5,64(s1)
    8000174c:	ff279be3          	bne	a5,s2,80001742 <reparent+0x2c>
      pp->parent = initproc;
    80001750:	000a3503          	ld	a0,0(s4)
    80001754:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001756:	00000097          	auipc	ra,0x0
    8000175a:	f4a080e7          	jalr	-182(ra) # 800016a0 <wakeup>
    8000175e:	b7d5                	j	80001742 <reparent+0x2c>
}
    80001760:	70a2                	ld	ra,40(sp)
    80001762:	7402                	ld	s0,32(sp)
    80001764:	64e2                	ld	s1,24(sp)
    80001766:	6942                	ld	s2,16(sp)
    80001768:	69a2                	ld	s3,8(sp)
    8000176a:	6a02                	ld	s4,0(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret

0000000080001770 <exit>:
{
    80001770:	7179                	addi	sp,sp,-48
    80001772:	f406                	sd	ra,40(sp)
    80001774:	f022                	sd	s0,32(sp)
    80001776:	ec26                	sd	s1,24(sp)
    80001778:	e84a                	sd	s2,16(sp)
    8000177a:	e44e                	sd	s3,8(sp)
    8000177c:	e052                	sd	s4,0(sp)
    8000177e:	1800                	addi	s0,sp,48
    80001780:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001782:	fffff097          	auipc	ra,0xfffff
    80001786:	6c6080e7          	jalr	1734(ra) # 80000e48 <myproc>
    8000178a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000178c:	00008797          	auipc	a5,0x8
    80001790:	8847b783          	ld	a5,-1916(a5) # 80009010 <initproc>
    80001794:	0e050493          	addi	s1,a0,224
    80001798:	16050913          	addi	s2,a0,352
    8000179c:	02a79363          	bne	a5,a0,800017c2 <exit+0x52>
    panic("init exiting");
    800017a0:	00007517          	auipc	a0,0x7
    800017a4:	a4050513          	addi	a0,a0,-1472 # 800081e0 <etext+0x1e0>
    800017a8:	00004097          	auipc	ra,0x4
    800017ac:	600080e7          	jalr	1536(ra) # 80005da8 <panic>
      fileclose(f);
    800017b0:	00002097          	auipc	ra,0x2
    800017b4:	3e2080e7          	jalr	994(ra) # 80003b92 <fileclose>
      p->ofile[fd] = 0;
    800017b8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017bc:	04a1                	addi	s1,s1,8
    800017be:	01248563          	beq	s1,s2,800017c8 <exit+0x58>
    if(p->ofile[fd]){
    800017c2:	6088                	ld	a0,0(s1)
    800017c4:	f575                	bnez	a0,800017b0 <exit+0x40>
    800017c6:	bfdd                	j	800017bc <exit+0x4c>
  begin_op();
    800017c8:	00002097          	auipc	ra,0x2
    800017cc:	efe080e7          	jalr	-258(ra) # 800036c6 <begin_op>
  iput(p->cwd);
    800017d0:	1609b503          	ld	a0,352(s3)
    800017d4:	00001097          	auipc	ra,0x1
    800017d8:	6da080e7          	jalr	1754(ra) # 80002eae <iput>
  end_op();
    800017dc:	00002097          	auipc	ra,0x2
    800017e0:	f6a080e7          	jalr	-150(ra) # 80003746 <end_op>
  p->cwd = 0;
    800017e4:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    800017e8:	00008497          	auipc	s1,0x8
    800017ec:	88048493          	addi	s1,s1,-1920 # 80009068 <wait_lock>
    800017f0:	8526                	mv	a0,s1
    800017f2:	00005097          	auipc	ra,0x5
    800017f6:	b6e080e7          	jalr	-1170(ra) # 80006360 <acquire>
  reparent(p);
    800017fa:	854e                	mv	a0,s3
    800017fc:	00000097          	auipc	ra,0x0
    80001800:	f1a080e7          	jalr	-230(ra) # 80001716 <reparent>
  wakeup(p->parent);
    80001804:	0409b503          	ld	a0,64(s3)
    80001808:	00000097          	auipc	ra,0x0
    8000180c:	e98080e7          	jalr	-360(ra) # 800016a0 <wakeup>
  acquire(&p->lock);
    80001810:	854e                	mv	a0,s3
    80001812:	00005097          	auipc	ra,0x5
    80001816:	b4e080e7          	jalr	-1202(ra) # 80006360 <acquire>
  p->xstate = status;
    8000181a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000181e:	4795                	li	a5,5
    80001820:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001824:	8526                	mv	a0,s1
    80001826:	00005097          	auipc	ra,0x5
    8000182a:	bee080e7          	jalr	-1042(ra) # 80006414 <release>
  sched();
    8000182e:	00000097          	auipc	ra,0x0
    80001832:	bd4080e7          	jalr	-1068(ra) # 80001402 <sched>
  panic("zombie exit");
    80001836:	00007517          	auipc	a0,0x7
    8000183a:	9ba50513          	addi	a0,a0,-1606 # 800081f0 <etext+0x1f0>
    8000183e:	00004097          	auipc	ra,0x4
    80001842:	56a080e7          	jalr	1386(ra) # 80005da8 <panic>

0000000080001846 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001846:	7179                	addi	sp,sp,-48
    80001848:	f406                	sd	ra,40(sp)
    8000184a:	f022                	sd	s0,32(sp)
    8000184c:	ec26                	sd	s1,24(sp)
    8000184e:	e84a                	sd	s2,16(sp)
    80001850:	e44e                	sd	s3,8(sp)
    80001852:	1800                	addi	s0,sp,48
    80001854:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001856:	00008497          	auipc	s1,0x8
    8000185a:	c2a48493          	addi	s1,s1,-982 # 80009480 <proc>
    8000185e:	00012997          	auipc	s3,0x12
    80001862:	a2298993          	addi	s3,s3,-1502 # 80013280 <tickslock>
    acquire(&p->lock);
    80001866:	8526                	mv	a0,s1
    80001868:	00005097          	auipc	ra,0x5
    8000186c:	af8080e7          	jalr	-1288(ra) # 80006360 <acquire>
    if(p->pid == pid){
    80001870:	589c                	lw	a5,48(s1)
    80001872:	01278d63          	beq	a5,s2,8000188c <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001876:	8526                	mv	a0,s1
    80001878:	00005097          	auipc	ra,0x5
    8000187c:	b9c080e7          	jalr	-1124(ra) # 80006414 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001880:	27848493          	addi	s1,s1,632
    80001884:	ff3491e3          	bne	s1,s3,80001866 <kill+0x20>
  }
  return -1;
    80001888:	557d                	li	a0,-1
    8000188a:	a829                	j	800018a4 <kill+0x5e>
      p->killed = 1;
    8000188c:	4785                	li	a5,1
    8000188e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001890:	4c98                	lw	a4,24(s1)
    80001892:	4789                	li	a5,2
    80001894:	00f70f63          	beq	a4,a5,800018b2 <kill+0x6c>
      release(&p->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	b7a080e7          	jalr	-1158(ra) # 80006414 <release>
      return 0;
    800018a2:	4501                	li	a0,0
}
    800018a4:	70a2                	ld	ra,40(sp)
    800018a6:	7402                	ld	s0,32(sp)
    800018a8:	64e2                	ld	s1,24(sp)
    800018aa:	6942                	ld	s2,16(sp)
    800018ac:	69a2                	ld	s3,8(sp)
    800018ae:	6145                	addi	sp,sp,48
    800018b0:	8082                	ret
        p->state = RUNNABLE;
    800018b2:	478d                	li	a5,3
    800018b4:	cc9c                	sw	a5,24(s1)
    800018b6:	b7cd                	j	80001898 <kill+0x52>

00000000800018b8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018b8:	7179                	addi	sp,sp,-48
    800018ba:	f406                	sd	ra,40(sp)
    800018bc:	f022                	sd	s0,32(sp)
    800018be:	ec26                	sd	s1,24(sp)
    800018c0:	e84a                	sd	s2,16(sp)
    800018c2:	e44e                	sd	s3,8(sp)
    800018c4:	e052                	sd	s4,0(sp)
    800018c6:	1800                	addi	s0,sp,48
    800018c8:	84aa                	mv	s1,a0
    800018ca:	892e                	mv	s2,a1
    800018cc:	89b2                	mv	s3,a2
    800018ce:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018d0:	fffff097          	auipc	ra,0xfffff
    800018d4:	578080e7          	jalr	1400(ra) # 80000e48 <myproc>
  if(user_dst){
    800018d8:	c08d                	beqz	s1,800018fa <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018da:	86d2                	mv	a3,s4
    800018dc:	864e                	mv	a2,s3
    800018de:	85ca                	mv	a1,s2
    800018e0:	7128                	ld	a0,96(a0)
    800018e2:	fffff097          	auipc	ra,0xfffff
    800018e6:	228080e7          	jalr	552(ra) # 80000b0a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800018ea:	70a2                	ld	ra,40(sp)
    800018ec:	7402                	ld	s0,32(sp)
    800018ee:	64e2                	ld	s1,24(sp)
    800018f0:	6942                	ld	s2,16(sp)
    800018f2:	69a2                	ld	s3,8(sp)
    800018f4:	6a02                	ld	s4,0(sp)
    800018f6:	6145                	addi	sp,sp,48
    800018f8:	8082                	ret
    memmove((char *)dst, src, len);
    800018fa:	000a061b          	sext.w	a2,s4
    800018fe:	85ce                	mv	a1,s3
    80001900:	854a                	mv	a0,s2
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	8d6080e7          	jalr	-1834(ra) # 800001d8 <memmove>
    return 0;
    8000190a:	8526                	mv	a0,s1
    8000190c:	bff9                	j	800018ea <either_copyout+0x32>

000000008000190e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000190e:	7179                	addi	sp,sp,-48
    80001910:	f406                	sd	ra,40(sp)
    80001912:	f022                	sd	s0,32(sp)
    80001914:	ec26                	sd	s1,24(sp)
    80001916:	e84a                	sd	s2,16(sp)
    80001918:	e44e                	sd	s3,8(sp)
    8000191a:	e052                	sd	s4,0(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	892a                	mv	s2,a0
    80001920:	84ae                	mv	s1,a1
    80001922:	89b2                	mv	s3,a2
    80001924:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	522080e7          	jalr	1314(ra) # 80000e48 <myproc>
  if(user_src){
    8000192e:	c08d                	beqz	s1,80001950 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001930:	86d2                	mv	a3,s4
    80001932:	864e                	mv	a2,s3
    80001934:	85ca                	mv	a1,s2
    80001936:	7128                	ld	a0,96(a0)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	25e080e7          	jalr	606(ra) # 80000b96 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001940:	70a2                	ld	ra,40(sp)
    80001942:	7402                	ld	s0,32(sp)
    80001944:	64e2                	ld	s1,24(sp)
    80001946:	6942                	ld	s2,16(sp)
    80001948:	69a2                	ld	s3,8(sp)
    8000194a:	6a02                	ld	s4,0(sp)
    8000194c:	6145                	addi	sp,sp,48
    8000194e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001950:	000a061b          	sext.w	a2,s4
    80001954:	85ce                	mv	a1,s3
    80001956:	854a                	mv	a0,s2
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	880080e7          	jalr	-1920(ra) # 800001d8 <memmove>
    return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	bff9                	j	80001940 <either_copyin+0x32>

0000000080001964 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001964:	715d                	addi	sp,sp,-80
    80001966:	e486                	sd	ra,72(sp)
    80001968:	e0a2                	sd	s0,64(sp)
    8000196a:	fc26                	sd	s1,56(sp)
    8000196c:	f84a                	sd	s2,48(sp)
    8000196e:	f44e                	sd	s3,40(sp)
    80001970:	f052                	sd	s4,32(sp)
    80001972:	ec56                	sd	s5,24(sp)
    80001974:	e85a                	sd	s6,16(sp)
    80001976:	e45e                	sd	s7,8(sp)
    80001978:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000197a:	00006517          	auipc	a0,0x6
    8000197e:	6ce50513          	addi	a0,a0,1742 # 80008048 <etext+0x48>
    80001982:	00004097          	auipc	ra,0x4
    80001986:	470080e7          	jalr	1136(ra) # 80005df2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000198a:	00008497          	auipc	s1,0x8
    8000198e:	c5e48493          	addi	s1,s1,-930 # 800095e8 <proc+0x168>
    80001992:	00012917          	auipc	s2,0x12
    80001996:	a5690913          	addi	s2,s2,-1450 # 800133e8 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000199a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000199c:	00007997          	auipc	s3,0x7
    800019a0:	86498993          	addi	s3,s3,-1948 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019a4:	00007a97          	auipc	s5,0x7
    800019a8:	864a8a93          	addi	s5,s5,-1948 # 80008208 <etext+0x208>
    printf("\n");
    800019ac:	00006a17          	auipc	s4,0x6
    800019b0:	69ca0a13          	addi	s4,s4,1692 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019b4:	00007b97          	auipc	s7,0x7
    800019b8:	88cb8b93          	addi	s7,s7,-1908 # 80008240 <states.1750>
    800019bc:	a00d                	j	800019de <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019be:	ec86a583          	lw	a1,-312(a3)
    800019c2:	8556                	mv	a0,s5
    800019c4:	00004097          	auipc	ra,0x4
    800019c8:	42e080e7          	jalr	1070(ra) # 80005df2 <printf>
    printf("\n");
    800019cc:	8552                	mv	a0,s4
    800019ce:	00004097          	auipc	ra,0x4
    800019d2:	424080e7          	jalr	1060(ra) # 80005df2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	27848493          	addi	s1,s1,632
    800019da:	03248163          	beq	s1,s2,800019fc <procdump+0x98>
    if(p->state == UNUSED)
    800019de:	86a6                	mv	a3,s1
    800019e0:	eb04a783          	lw	a5,-336(s1)
    800019e4:	dbed                	beqz	a5,800019d6 <procdump+0x72>
      state = "???";
    800019e6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019e8:	fcfb6be3          	bltu	s6,a5,800019be <procdump+0x5a>
    800019ec:	1782                	slli	a5,a5,0x20
    800019ee:	9381                	srli	a5,a5,0x20
    800019f0:	078e                	slli	a5,a5,0x3
    800019f2:	97de                	add	a5,a5,s7
    800019f4:	6390                	ld	a2,0(a5)
    800019f6:	f661                	bnez	a2,800019be <procdump+0x5a>
      state = "???";
    800019f8:	864e                	mv	a2,s3
    800019fa:	b7d1                	j	800019be <procdump+0x5a>
  }
}
    800019fc:	60a6                	ld	ra,72(sp)
    800019fe:	6406                	ld	s0,64(sp)
    80001a00:	74e2                	ld	s1,56(sp)
    80001a02:	7942                	ld	s2,48(sp)
    80001a04:	79a2                	ld	s3,40(sp)
    80001a06:	7a02                	ld	s4,32(sp)
    80001a08:	6ae2                	ld	s5,24(sp)
    80001a0a:	6b42                	ld	s6,16(sp)
    80001a0c:	6ba2                	ld	s7,8(sp)
    80001a0e:	6161                	addi	sp,sp,80
    80001a10:	8082                	ret

0000000080001a12 <swtch>:
    80001a12:	00153023          	sd	ra,0(a0)
    80001a16:	00253423          	sd	sp,8(a0)
    80001a1a:	e900                	sd	s0,16(a0)
    80001a1c:	ed04                	sd	s1,24(a0)
    80001a1e:	03253023          	sd	s2,32(a0)
    80001a22:	03353423          	sd	s3,40(a0)
    80001a26:	03453823          	sd	s4,48(a0)
    80001a2a:	03553c23          	sd	s5,56(a0)
    80001a2e:	05653023          	sd	s6,64(a0)
    80001a32:	05753423          	sd	s7,72(a0)
    80001a36:	05853823          	sd	s8,80(a0)
    80001a3a:	05953c23          	sd	s9,88(a0)
    80001a3e:	07a53023          	sd	s10,96(a0)
    80001a42:	07b53423          	sd	s11,104(a0)
    80001a46:	0005b083          	ld	ra,0(a1)
    80001a4a:	0085b103          	ld	sp,8(a1)
    80001a4e:	6980                	ld	s0,16(a1)
    80001a50:	6d84                	ld	s1,24(a1)
    80001a52:	0205b903          	ld	s2,32(a1)
    80001a56:	0285b983          	ld	s3,40(a1)
    80001a5a:	0305ba03          	ld	s4,48(a1)
    80001a5e:	0385ba83          	ld	s5,56(a1)
    80001a62:	0405bb03          	ld	s6,64(a1)
    80001a66:	0485bb83          	ld	s7,72(a1)
    80001a6a:	0505bc03          	ld	s8,80(a1)
    80001a6e:	0585bc83          	ld	s9,88(a1)
    80001a72:	0605bd03          	ld	s10,96(a1)
    80001a76:	0685bd83          	ld	s11,104(a1)
    80001a7a:	8082                	ret

0000000080001a7c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001a7c:	1141                	addi	sp,sp,-16
    80001a7e:	e406                	sd	ra,8(sp)
    80001a80:	e022                	sd	s0,0(sp)
    80001a82:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001a84:	00006597          	auipc	a1,0x6
    80001a88:	7ec58593          	addi	a1,a1,2028 # 80008270 <states.1750+0x30>
    80001a8c:	00011517          	auipc	a0,0x11
    80001a90:	7f450513          	addi	a0,a0,2036 # 80013280 <tickslock>
    80001a94:	00005097          	auipc	ra,0x5
    80001a98:	83c080e7          	jalr	-1988(ra) # 800062d0 <initlock>
}
    80001a9c:	60a2                	ld	ra,8(sp)
    80001a9e:	6402                	ld	s0,0(sp)
    80001aa0:	0141                	addi	sp,sp,16
    80001aa2:	8082                	ret

0000000080001aa4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001aa4:	1141                	addi	sp,sp,-16
    80001aa6:	e422                	sd	s0,8(sp)
    80001aa8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001aaa:	00003797          	auipc	a5,0x3
    80001aae:	70678793          	addi	a5,a5,1798 # 800051b0 <kernelvec>
    80001ab2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ab6:	6422                	ld	s0,8(sp)
    80001ab8:	0141                	addi	sp,sp,16
    80001aba:	8082                	ret

0000000080001abc <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001abc:	1141                	addi	sp,sp,-16
    80001abe:	e406                	sd	ra,8(sp)
    80001ac0:	e022                	sd	s0,0(sp)
    80001ac2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ac4:	fffff097          	auipc	ra,0xfffff
    80001ac8:	384080e7          	jalr	900(ra) # 80000e48 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001acc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ad0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ad2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001ad6:	00005617          	auipc	a2,0x5
    80001ada:	52a60613          	addi	a2,a2,1322 # 80007000 <_trampoline>
    80001ade:	00005697          	auipc	a3,0x5
    80001ae2:	52268693          	addi	a3,a3,1314 # 80007000 <_trampoline>
    80001ae6:	8e91                	sub	a3,a3,a2
    80001ae8:	040007b7          	lui	a5,0x4000
    80001aec:	17fd                	addi	a5,a5,-1
    80001aee:	07b2                	slli	a5,a5,0xc
    80001af0:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001af2:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001af6:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001af8:	180026f3          	csrr	a3,satp
    80001afc:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack？
    80001afe:	7538                	ld	a4,104(a0)
    80001b00:	6534                	ld	a3,72(a0)
    80001b02:	6585                	lui	a1,0x1
    80001b04:	96ae                	add	a3,a3,a1
    80001b06:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap; // 指向usertrap的指针
    80001b08:	7538                	ld	a4,104(a0)
    80001b0a:	00000697          	auipc	a3,0x0
    80001b0e:	13868693          	addi	a3,a3,312 # 80001c42 <usertrap>
    80001b12:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b14:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b16:	8692                	mv	a3,tp
    80001b18:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b1e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b22:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b26:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b2a:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b2c:	6f18                	ld	a4,24(a4)
    80001b2e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b32:	712c                	ld	a1,96(a0)
    80001b34:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b36:	00005717          	auipc	a4,0x5
    80001b3a:	55a70713          	addi	a4,a4,1370 # 80007090 <userret>
    80001b3e:	8f11                	sub	a4,a4,a2
    80001b40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b42:	577d                	li	a4,-1
    80001b44:	177e                	slli	a4,a4,0x3f
    80001b46:	8dd9                	or	a1,a1,a4
    80001b48:	02000537          	lui	a0,0x2000
    80001b4c:	157d                	addi	a0,a0,-1
    80001b4e:	0536                	slli	a0,a0,0xd
    80001b50:	9782                	jalr	a5
}
    80001b52:	60a2                	ld	ra,8(sp)
    80001b54:	6402                	ld	s0,0(sp)
    80001b56:	0141                	addi	sp,sp,16
    80001b58:	8082                	ret

0000000080001b5a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b5a:	1101                	addi	sp,sp,-32
    80001b5c:	ec06                	sd	ra,24(sp)
    80001b5e:	e822                	sd	s0,16(sp)
    80001b60:	e426                	sd	s1,8(sp)
    80001b62:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b64:	00011497          	auipc	s1,0x11
    80001b68:	71c48493          	addi	s1,s1,1820 # 80013280 <tickslock>
    80001b6c:	8526                	mv	a0,s1
    80001b6e:	00004097          	auipc	ra,0x4
    80001b72:	7f2080e7          	jalr	2034(ra) # 80006360 <acquire>
  ticks++;
    80001b76:	00007517          	auipc	a0,0x7
    80001b7a:	4a250513          	addi	a0,a0,1186 # 80009018 <ticks>
    80001b7e:	411c                	lw	a5,0(a0)
    80001b80:	2785                	addiw	a5,a5,1
    80001b82:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001b84:	00000097          	auipc	ra,0x0
    80001b88:	b1c080e7          	jalr	-1252(ra) # 800016a0 <wakeup>
  release(&tickslock);
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	00005097          	auipc	ra,0x5
    80001b92:	886080e7          	jalr	-1914(ra) # 80006414 <release>
}
    80001b96:	60e2                	ld	ra,24(sp)
    80001b98:	6442                	ld	s0,16(sp)
    80001b9a:	64a2                	ld	s1,8(sp)
    80001b9c:	6105                	addi	sp,sp,32
    80001b9e:	8082                	ret

0000000080001ba0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001ba0:	1101                	addi	sp,sp,-32
    80001ba2:	ec06                	sd	ra,24(sp)
    80001ba4:	e822                	sd	s0,16(sp)
    80001ba6:	e426                	sd	s1,8(sp)
    80001ba8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001baa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bae:	00074d63          	bltz	a4,80001bc8 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001bb2:	57fd                	li	a5,-1
    80001bb4:	17fe                	slli	a5,a5,0x3f
    80001bb6:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bb8:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bba:	06f70363          	beq	a4,a5,80001c20 <devintr+0x80>
  }
}
    80001bbe:	60e2                	ld	ra,24(sp)
    80001bc0:	6442                	ld	s0,16(sp)
    80001bc2:	64a2                	ld	s1,8(sp)
    80001bc4:	6105                	addi	sp,sp,32
    80001bc6:	8082                	ret
     (scause & 0xff) == 9){
    80001bc8:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001bcc:	46a5                	li	a3,9
    80001bce:	fed792e3          	bne	a5,a3,80001bb2 <devintr+0x12>
    int irq = plic_claim();
    80001bd2:	00003097          	auipc	ra,0x3
    80001bd6:	6e6080e7          	jalr	1766(ra) # 800052b8 <plic_claim>
    80001bda:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001bdc:	47a9                	li	a5,10
    80001bde:	02f50763          	beq	a0,a5,80001c0c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001be2:	4785                	li	a5,1
    80001be4:	02f50963          	beq	a0,a5,80001c16 <devintr+0x76>
    return 1;
    80001be8:	4505                	li	a0,1
    } else if(irq){
    80001bea:	d8f1                	beqz	s1,80001bbe <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001bec:	85a6                	mv	a1,s1
    80001bee:	00006517          	auipc	a0,0x6
    80001bf2:	68a50513          	addi	a0,a0,1674 # 80008278 <states.1750+0x38>
    80001bf6:	00004097          	auipc	ra,0x4
    80001bfa:	1fc080e7          	jalr	508(ra) # 80005df2 <printf>
      plic_complete(irq);
    80001bfe:	8526                	mv	a0,s1
    80001c00:	00003097          	auipc	ra,0x3
    80001c04:	6dc080e7          	jalr	1756(ra) # 800052dc <plic_complete>
    return 1;
    80001c08:	4505                	li	a0,1
    80001c0a:	bf55                	j	80001bbe <devintr+0x1e>
      uartintr();
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	674080e7          	jalr	1652(ra) # 80006280 <uartintr>
    80001c14:	b7ed                	j	80001bfe <devintr+0x5e>
      virtio_disk_intr();
    80001c16:	00004097          	auipc	ra,0x4
    80001c1a:	ba6080e7          	jalr	-1114(ra) # 800057bc <virtio_disk_intr>
    80001c1e:	b7c5                	j	80001bfe <devintr+0x5e>
    if(cpuid() == 0){
    80001c20:	fffff097          	auipc	ra,0xfffff
    80001c24:	1fc080e7          	jalr	508(ra) # 80000e1c <cpuid>
    80001c28:	c901                	beqz	a0,80001c38 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c2a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c2e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c30:	14479073          	csrw	sip,a5
    return 2;
    80001c34:	4509                	li	a0,2
    80001c36:	b761                	j	80001bbe <devintr+0x1e>
      clockintr();
    80001c38:	00000097          	auipc	ra,0x0
    80001c3c:	f22080e7          	jalr	-222(ra) # 80001b5a <clockintr>
    80001c40:	b7ed                	j	80001c2a <devintr+0x8a>

0000000080001c42 <usertrap>:
{
    80001c42:	1101                	addi	sp,sp,-32
    80001c44:	ec06                	sd	ra,24(sp)
    80001c46:	e822                	sd	s0,16(sp)
    80001c48:	e426                	sd	s1,8(sp)
    80001c4a:	e04a                	sd	s2,0(sp)
    80001c4c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c4e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c52:	1007f793          	andi	a5,a5,256
    80001c56:	e3b5                	bnez	a5,80001cba <usertrap+0x78>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c58:	00003797          	auipc	a5,0x3
    80001c5c:	55878793          	addi	a5,a5,1368 # 800051b0 <kernelvec>
    80001c60:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001c64:	fffff097          	auipc	ra,0xfffff
    80001c68:	1e4080e7          	jalr	484(ra) # 80000e48 <myproc>
    80001c6c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001c6e:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c70:	14102773          	csrr	a4,sepc
    80001c74:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c76:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001c7a:	47a1                	li	a5,8
    80001c7c:	04f71d63          	bne	a4,a5,80001cd6 <usertrap+0x94>
    if(p->killed)
    80001c80:	551c                	lw	a5,40(a0)
    80001c82:	e7a1                	bnez	a5,80001cca <usertrap+0x88>
    p->trapframe->epc += 4;
    80001c84:	74b8                	ld	a4,104(s1)
    80001c86:	6f1c                	ld	a5,24(a4)
    80001c88:	0791                	addi	a5,a5,4
    80001c8a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c90:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c94:	10079073          	csrw	sstatus,a5
    syscall();
    80001c98:	00000097          	auipc	ra,0x0
    80001c9c:	3d0080e7          	jalr	976(ra) # 80002068 <syscall>
  if(p->killed)
    80001ca0:	549c                	lw	a5,40(s1)
    80001ca2:	18079063          	bnez	a5,80001e22 <usertrap+0x1e0>
  usertrapret();
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	e16080e7          	jalr	-490(ra) # 80001abc <usertrapret>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6902                	ld	s2,0(sp)
    80001cb6:	6105                	addi	sp,sp,32
    80001cb8:	8082                	ret
    panic("usertrap: not from user mode");
    80001cba:	00006517          	auipc	a0,0x6
    80001cbe:	5de50513          	addi	a0,a0,1502 # 80008298 <states.1750+0x58>
    80001cc2:	00004097          	auipc	ra,0x4
    80001cc6:	0e6080e7          	jalr	230(ra) # 80005da8 <panic>
      exit(-1);
    80001cca:	557d                	li	a0,-1
    80001ccc:	00000097          	auipc	ra,0x0
    80001cd0:	aa4080e7          	jalr	-1372(ra) # 80001770 <exit>
    80001cd4:	bf45                	j	80001c84 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	eca080e7          	jalr	-310(ra) # 80001ba0 <devintr>
    80001cde:	892a                	mv	s2,a0
    80001ce0:	c501                	beqz	a0,80001ce8 <usertrap+0xa6>
  if(p->killed)
    80001ce2:	549c                	lw	a5,40(s1)
    80001ce4:	c3a1                	beqz	a5,80001d24 <usertrap+0xe2>
    80001ce6:	a815                	j	80001d1a <usertrap+0xd8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cec:	5890                	lw	a2,48(s1)
    80001cee:	00006517          	auipc	a0,0x6
    80001cf2:	5ca50513          	addi	a0,a0,1482 # 800082b8 <states.1750+0x78>
    80001cf6:	00004097          	auipc	ra,0x4
    80001cfa:	0fc080e7          	jalr	252(ra) # 80005df2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cfe:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d02:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d06:	00006517          	auipc	a0,0x6
    80001d0a:	5e250513          	addi	a0,a0,1506 # 800082e8 <states.1750+0xa8>
    80001d0e:	00004097          	auipc	ra,0x4
    80001d12:	0e4080e7          	jalr	228(ra) # 80005df2 <printf>
    p->killed = 1;
    80001d16:	4785                	li	a5,1
    80001d18:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d1a:	557d                	li	a0,-1
    80001d1c:	00000097          	auipc	ra,0x0
    80001d20:	a54080e7          	jalr	-1452(ra) # 80001770 <exit>
  if(which_dev == 2)
    80001d24:	4789                	li	a5,2
    80001d26:	f8f910e3          	bne	s2,a5,80001ca6 <usertrap+0x64>
    if(p->alarm>0 && p->c_alret == 0){
    80001d2a:	58dc                	lw	a5,52(s1)
    80001d2c:	0ef05663          	blez	a5,80001e18 <usertrap+0x1d6>
    80001d30:	5cd8                	lw	a4,60(s1)
    80001d32:	e37d                	bnez	a4,80001e18 <usertrap+0x1d6>
      p->cu_alarm ++ ;
    80001d34:	5c98                	lw	a4,56(s1)
    80001d36:	2705                	addiw	a4,a4,1
    80001d38:	0007069b          	sext.w	a3,a4
    80001d3c:	dc98                	sw	a4,56(s1)
      if(p->cu_alarm > p->alarm)
    80001d3e:	0cd7dd63          	bge	a5,a3,80001e18 <usertrap+0x1d6>
        p->c_alret = 1;
    80001d42:	4785                	li	a5,1
    80001d44:	dcdc                	sw	a5,60(s1)
        p->cu_alarm = 0;
    80001d46:	0204ac23          	sw	zero,56(s1)
        p->saved_epc = p->trapframe->epc;
    80001d4a:	74bc                	ld	a5,104(s1)
    80001d4c:	6f98                	ld	a4,24(a5)
    80001d4e:	16e4bc23          	sd	a4,376(s1)
        p->saved_ra = p->trapframe->ra;
    80001d52:	7798                	ld	a4,40(a5)
    80001d54:	18e4b023          	sd	a4,384(s1)
        p->saved_sp = p->trapframe->sp;
    80001d58:	7b98                	ld	a4,48(a5)
    80001d5a:	18e4b423          	sd	a4,392(s1)
        p->saved_gp = p->trapframe->gp;
    80001d5e:	7f98                	ld	a4,56(a5)
    80001d60:	18e4b823          	sd	a4,400(s1)
        p->saved_tp = p->trapframe->tp;
    80001d64:	63b8                	ld	a4,64(a5)
    80001d66:	18e4bc23          	sd	a4,408(s1)
        p->saved_t0 = p->trapframe->t0;
    80001d6a:	67b8                	ld	a4,72(a5)
    80001d6c:	1ae4b023          	sd	a4,416(s1)
        p->saved_t1 = p->trapframe->t1;
    80001d70:	6bb8                	ld	a4,80(a5)
    80001d72:	1ae4b423          	sd	a4,424(s1)
        p->saved_t2 = p->trapframe->t2;
    80001d76:	6fb8                	ld	a4,88(a5)
    80001d78:	1ae4b823          	sd	a4,432(s1)
        p->saved_t3 = p->trapframe->t3;
    80001d7c:	1007b703          	ld	a4,256(a5)
    80001d80:	24e4bc23          	sd	a4,600(s1)
        p->saved_t4 = p->trapframe->t4;
    80001d84:	1087b703          	ld	a4,264(a5)
    80001d88:	26e4b023          	sd	a4,608(s1)
        p->saved_t5 = p->trapframe->t5;
    80001d8c:	1107b703          	ld	a4,272(a5)
    80001d90:	26e4b423          	sd	a4,616(s1)
        p->saved_t6 = p->trapframe->t6;
    80001d94:	1187b703          	ld	a4,280(a5)
    80001d98:	26e4b823          	sd	a4,624(s1)
        p->saved_s0 = p->trapframe->s0;
    80001d9c:	73b8                	ld	a4,96(a5)
    80001d9e:	1ae4bc23          	sd	a4,440(s1)
        p->saved_s1 = p->trapframe->s1;
    80001da2:	77b8                	ld	a4,104(a5)
    80001da4:	1ce4b023          	sd	a4,448(s1)
        p->saved_s2 = p->trapframe->s2;
    80001da8:	7bd8                	ld	a4,176(a5)
    80001daa:	1ce4b423          	sd	a4,456(s1)
        p->saved_s3 = p->trapframe->s3;
    80001dae:	7fd8                	ld	a4,184(a5)
    80001db0:	1ce4b823          	sd	a4,464(s1)
        p->saved_s4 = p->trapframe->s4;
    80001db4:	63f8                	ld	a4,192(a5)
    80001db6:	1ce4bc23          	sd	a4,472(s1)
        p->saved_s5 = p->trapframe->s5;
    80001dba:	67f8                	ld	a4,200(a5)
    80001dbc:	1ee4b023          	sd	a4,480(s1)
        p->saved_s6 = p->trapframe->s6;
    80001dc0:	6bf8                	ld	a4,208(a5)
    80001dc2:	1ee4b423          	sd	a4,488(s1)
        p->saved_s7 = p->trapframe->s7;
    80001dc6:	6ff8                	ld	a4,216(a5)
    80001dc8:	1ee4b823          	sd	a4,496(s1)
        p->saved_s8 = p->trapframe->s8;
    80001dcc:	73f8                	ld	a4,224(a5)
    80001dce:	1ee4bc23          	sd	a4,504(s1)
        p->saved_s9 = p->trapframe->s9;
    80001dd2:	77f8                	ld	a4,232(a5)
    80001dd4:	20e4b023          	sd	a4,512(s1)
        p->saved_s10 = p->trapframe->s10;
    80001dd8:	7bf8                	ld	a4,240(a5)
    80001dda:	20e4b423          	sd	a4,520(s1)
        p->saved_s11 = p->trapframe->s11;
    80001dde:	7ff8                	ld	a4,248(a5)
    80001de0:	20e4b823          	sd	a4,528(s1)
        p->saved_a0 = p->trapframe->a0;
    80001de4:	7bb8                	ld	a4,112(a5)
    80001de6:	20e4bc23          	sd	a4,536(s1)
        p->saved_a1 = p->trapframe->a1;
    80001dea:	7fb8                	ld	a4,120(a5)
    80001dec:	22e4b023          	sd	a4,544(s1)
        p->saved_a2 = p->trapframe->a2;
    80001df0:	63d8                	ld	a4,128(a5)
    80001df2:	22e4b423          	sd	a4,552(s1)
        p->saved_a3 = p->trapframe->a3;
    80001df6:	67d8                	ld	a4,136(a5)
    80001df8:	22e4b823          	sd	a4,560(s1)
        p->saved_a4 = p->trapframe->a4;
    80001dfc:	6bd8                	ld	a4,144(a5)
    80001dfe:	22e4bc23          	sd	a4,568(s1)
        p->saved_a5 = p->trapframe->a5;
    80001e02:	6fd8                	ld	a4,152(a5)
    80001e04:	24e4b023          	sd	a4,576(s1)
        p->saved_a6 = p->trapframe->a6;
    80001e08:	73d8                	ld	a4,160(a5)
    80001e0a:	24e4b423          	sd	a4,584(s1)
        p->saved_a7 = p->trapframe->a7;
    80001e0e:	77d8                	ld	a4,168(a5)
    80001e10:	24e4b823          	sd	a4,592(s1)
        p->trapframe->epc = p->alret;
    80001e14:	6cb8                	ld	a4,88(s1)
    80001e16:	ef98                	sd	a4,24(a5)
    yield();
    80001e18:	fffff097          	auipc	ra,0xfffff
    80001e1c:	6c0080e7          	jalr	1728(ra) # 800014d8 <yield>
    80001e20:	b559                	j	80001ca6 <usertrap+0x64>
  int which_dev = 0;
    80001e22:	4901                	li	s2,0
    80001e24:	bddd                	j	80001d1a <usertrap+0xd8>

0000000080001e26 <kerneltrap>:
{
    80001e26:	7179                	addi	sp,sp,-48
    80001e28:	f406                	sd	ra,40(sp)
    80001e2a:	f022                	sd	s0,32(sp)
    80001e2c:	ec26                	sd	s1,24(sp)
    80001e2e:	e84a                	sd	s2,16(sp)
    80001e30:	e44e                	sd	s3,8(sp)
    80001e32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e3c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e40:	1004f793          	andi	a5,s1,256
    80001e44:	cb85                	beqz	a5,80001e74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e4c:	ef85                	bnez	a5,80001e84 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e4e:	00000097          	auipc	ra,0x0
    80001e52:	d52080e7          	jalr	-686(ra) # 80001ba0 <devintr>
    80001e56:	cd1d                	beqz	a0,80001e94 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e58:	4789                	li	a5,2
    80001e5a:	06f50a63          	beq	a0,a5,80001ece <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e62:	10049073          	csrw	sstatus,s1
}
    80001e66:	70a2                	ld	ra,40(sp)
    80001e68:	7402                	ld	s0,32(sp)
    80001e6a:	64e2                	ld	s1,24(sp)
    80001e6c:	6942                	ld	s2,16(sp)
    80001e6e:	69a2                	ld	s3,8(sp)
    80001e70:	6145                	addi	sp,sp,48
    80001e72:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e74:	00006517          	auipc	a0,0x6
    80001e78:	49450513          	addi	a0,a0,1172 # 80008308 <states.1750+0xc8>
    80001e7c:	00004097          	auipc	ra,0x4
    80001e80:	f2c080e7          	jalr	-212(ra) # 80005da8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e84:	00006517          	auipc	a0,0x6
    80001e88:	4ac50513          	addi	a0,a0,1196 # 80008330 <states.1750+0xf0>
    80001e8c:	00004097          	auipc	ra,0x4
    80001e90:	f1c080e7          	jalr	-228(ra) # 80005da8 <panic>
    printf("scause %p\n", scause);
    80001e94:	85ce                	mv	a1,s3
    80001e96:	00006517          	auipc	a0,0x6
    80001e9a:	4ba50513          	addi	a0,a0,1210 # 80008350 <states.1750+0x110>
    80001e9e:	00004097          	auipc	ra,0x4
    80001ea2:	f54080e7          	jalr	-172(ra) # 80005df2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ea6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eaa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eae:	00006517          	auipc	a0,0x6
    80001eb2:	4b250513          	addi	a0,a0,1202 # 80008360 <states.1750+0x120>
    80001eb6:	00004097          	auipc	ra,0x4
    80001eba:	f3c080e7          	jalr	-196(ra) # 80005df2 <printf>
    panic("kerneltrap");
    80001ebe:	00006517          	auipc	a0,0x6
    80001ec2:	4ba50513          	addi	a0,a0,1210 # 80008378 <states.1750+0x138>
    80001ec6:	00004097          	auipc	ra,0x4
    80001eca:	ee2080e7          	jalr	-286(ra) # 80005da8 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	f7a080e7          	jalr	-134(ra) # 80000e48 <myproc>
    80001ed6:	d541                	beqz	a0,80001e5e <kerneltrap+0x38>
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	f70080e7          	jalr	-144(ra) # 80000e48 <myproc>
    80001ee0:	4d18                	lw	a4,24(a0)
    80001ee2:	4791                	li	a5,4
    80001ee4:	f6f71de3          	bne	a4,a5,80001e5e <kerneltrap+0x38>
    yield();
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	5f0080e7          	jalr	1520(ra) # 800014d8 <yield>
    80001ef0:	b7bd                	j	80001e5e <kerneltrap+0x38>

0000000080001ef2 <argraw>:
  return strlen(buf);
}

static uint64 
argraw(int n)
{
    80001ef2:	1101                	addi	sp,sp,-32
    80001ef4:	ec06                	sd	ra,24(sp)
    80001ef6:	e822                	sd	s0,16(sp)
    80001ef8:	e426                	sd	s1,8(sp)
    80001efa:	1000                	addi	s0,sp,32
    80001efc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	f4a080e7          	jalr	-182(ra) # 80000e48 <myproc>
  switch (n) {
    80001f06:	4795                	li	a5,5
    80001f08:	0497e163          	bltu	a5,s1,80001f4a <argraw+0x58>
    80001f0c:	048a                	slli	s1,s1,0x2
    80001f0e:	00006717          	auipc	a4,0x6
    80001f12:	4a270713          	addi	a4,a4,1186 # 800083b0 <states.1750+0x170>
    80001f16:	94ba                	add	s1,s1,a4
    80001f18:	409c                	lw	a5,0(s1)
    80001f1a:	97ba                	add	a5,a5,a4
    80001f1c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f1e:	753c                	ld	a5,104(a0)
    80001f20:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f22:	60e2                	ld	ra,24(sp)
    80001f24:	6442                	ld	s0,16(sp)
    80001f26:	64a2                	ld	s1,8(sp)
    80001f28:	6105                	addi	sp,sp,32
    80001f2a:	8082                	ret
    return p->trapframe->a1;
    80001f2c:	753c                	ld	a5,104(a0)
    80001f2e:	7fa8                	ld	a0,120(a5)
    80001f30:	bfcd                	j	80001f22 <argraw+0x30>
    return p->trapframe->a2;
    80001f32:	753c                	ld	a5,104(a0)
    80001f34:	63c8                	ld	a0,128(a5)
    80001f36:	b7f5                	j	80001f22 <argraw+0x30>
    return p->trapframe->a3;
    80001f38:	753c                	ld	a5,104(a0)
    80001f3a:	67c8                	ld	a0,136(a5)
    80001f3c:	b7dd                	j	80001f22 <argraw+0x30>
    return p->trapframe->a4;
    80001f3e:	753c                	ld	a5,104(a0)
    80001f40:	6bc8                	ld	a0,144(a5)
    80001f42:	b7c5                	j	80001f22 <argraw+0x30>
    return p->trapframe->a5;
    80001f44:	753c                	ld	a5,104(a0)
    80001f46:	6fc8                	ld	a0,152(a5)
    80001f48:	bfe9                	j	80001f22 <argraw+0x30>
  panic("argraw");
    80001f4a:	00006517          	auipc	a0,0x6
    80001f4e:	43e50513          	addi	a0,a0,1086 # 80008388 <states.1750+0x148>
    80001f52:	00004097          	auipc	ra,0x4
    80001f56:	e56080e7          	jalr	-426(ra) # 80005da8 <panic>

0000000080001f5a <fetchaddr>:
{
    80001f5a:	1101                	addi	sp,sp,-32
    80001f5c:	ec06                	sd	ra,24(sp)
    80001f5e:	e822                	sd	s0,16(sp)
    80001f60:	e426                	sd	s1,8(sp)
    80001f62:	e04a                	sd	s2,0(sp)
    80001f64:	1000                	addi	s0,sp,32
    80001f66:	84aa                	mv	s1,a0
    80001f68:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	ede080e7          	jalr	-290(ra) # 80000e48 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f72:	693c                	ld	a5,80(a0)
    80001f74:	02f4f863          	bgeu	s1,a5,80001fa4 <fetchaddr+0x4a>
    80001f78:	00848713          	addi	a4,s1,8
    80001f7c:	02e7e663          	bltu	a5,a4,80001fa8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f80:	46a1                	li	a3,8
    80001f82:	8626                	mv	a2,s1
    80001f84:	85ca                	mv	a1,s2
    80001f86:	7128                	ld	a0,96(a0)
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	c0e080e7          	jalr	-1010(ra) # 80000b96 <copyin>
    80001f90:	00a03533          	snez	a0,a0
    80001f94:	40a00533          	neg	a0,a0
}
    80001f98:	60e2                	ld	ra,24(sp)
    80001f9a:	6442                	ld	s0,16(sp)
    80001f9c:	64a2                	ld	s1,8(sp)
    80001f9e:	6902                	ld	s2,0(sp)
    80001fa0:	6105                	addi	sp,sp,32
    80001fa2:	8082                	ret
    return -1;
    80001fa4:	557d                	li	a0,-1
    80001fa6:	bfcd                	j	80001f98 <fetchaddr+0x3e>
    80001fa8:	557d                	li	a0,-1
    80001faa:	b7fd                	j	80001f98 <fetchaddr+0x3e>

0000000080001fac <fetchstr>:
{
    80001fac:	7179                	addi	sp,sp,-48
    80001fae:	f406                	sd	ra,40(sp)
    80001fb0:	f022                	sd	s0,32(sp)
    80001fb2:	ec26                	sd	s1,24(sp)
    80001fb4:	e84a                	sd	s2,16(sp)
    80001fb6:	e44e                	sd	s3,8(sp)
    80001fb8:	1800                	addi	s0,sp,48
    80001fba:	892a                	mv	s2,a0
    80001fbc:	84ae                	mv	s1,a1
    80001fbe:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	e88080e7          	jalr	-376(ra) # 80000e48 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001fc8:	86ce                	mv	a3,s3
    80001fca:	864a                	mv	a2,s2
    80001fcc:	85a6                	mv	a1,s1
    80001fce:	7128                	ld	a0,96(a0)
    80001fd0:	fffff097          	auipc	ra,0xfffff
    80001fd4:	c52080e7          	jalr	-942(ra) # 80000c22 <copyinstr>
  if(err < 0)
    80001fd8:	00054763          	bltz	a0,80001fe6 <fetchstr+0x3a>
  return strlen(buf);
    80001fdc:	8526                	mv	a0,s1
    80001fde:	ffffe097          	auipc	ra,0xffffe
    80001fe2:	31e080e7          	jalr	798(ra) # 800002fc <strlen>
}
    80001fe6:	70a2                	ld	ra,40(sp)
    80001fe8:	7402                	ld	s0,32(sp)
    80001fea:	64e2                	ld	s1,24(sp)
    80001fec:	6942                	ld	s2,16(sp)
    80001fee:	69a2                	ld	s3,8(sp)
    80001ff0:	6145                	addi	sp,sp,48
    80001ff2:	8082                	ret

0000000080001ff4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	1000                	addi	s0,sp,32
    80001ffe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002000:	00000097          	auipc	ra,0x0
    80002004:	ef2080e7          	jalr	-270(ra) # 80001ef2 <argraw>
    80002008:	c088                	sw	a0,0(s1)
  return 0;
}
    8000200a:	4501                	li	a0,0
    8000200c:	60e2                	ld	ra,24(sp)
    8000200e:	6442                	ld	s0,16(sp)
    80002010:	64a2                	ld	s1,8(sp)
    80002012:	6105                	addi	sp,sp,32
    80002014:	8082                	ret

0000000080002016 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002016:	1101                	addi	sp,sp,-32
    80002018:	ec06                	sd	ra,24(sp)
    8000201a:	e822                	sd	s0,16(sp)
    8000201c:	e426                	sd	s1,8(sp)
    8000201e:	1000                	addi	s0,sp,32
    80002020:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002022:	00000097          	auipc	ra,0x0
    80002026:	ed0080e7          	jalr	-304(ra) # 80001ef2 <argraw>
    8000202a:	e088                	sd	a0,0(s1)
  return 0;
}
    8000202c:	4501                	li	a0,0
    8000202e:	60e2                	ld	ra,24(sp)
    80002030:	6442                	ld	s0,16(sp)
    80002032:	64a2                	ld	s1,8(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret

0000000080002038 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002038:	1101                	addi	sp,sp,-32
    8000203a:	ec06                	sd	ra,24(sp)
    8000203c:	e822                	sd	s0,16(sp)
    8000203e:	e426                	sd	s1,8(sp)
    80002040:	e04a                	sd	s2,0(sp)
    80002042:	1000                	addi	s0,sp,32
    80002044:	84ae                	mv	s1,a1
    80002046:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002048:	00000097          	auipc	ra,0x0
    8000204c:	eaa080e7          	jalr	-342(ra) # 80001ef2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002050:	864a                	mv	a2,s2
    80002052:	85a6                	mv	a1,s1
    80002054:	00000097          	auipc	ra,0x0
    80002058:	f58080e7          	jalr	-168(ra) # 80001fac <fetchstr>
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6902                	ld	s2,0(sp)
    80002064:	6105                	addi	sp,sp,32
    80002066:	8082                	ret

0000000080002068 <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	e04a                	sd	s2,0(sp)
    80002072:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002074:	fffff097          	auipc	ra,0xfffff
    80002078:	dd4080e7          	jalr	-556(ra) # 80000e48 <myproc>
    8000207c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000207e:	06853903          	ld	s2,104(a0)
    80002082:	0a893783          	ld	a5,168(s2)
    80002086:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000208a:	37fd                	addiw	a5,a5,-1
    8000208c:	4759                	li	a4,22
    8000208e:	00f76f63          	bltu	a4,a5,800020ac <syscall+0x44>
    80002092:	00369713          	slli	a4,a3,0x3
    80002096:	00006797          	auipc	a5,0x6
    8000209a:	33278793          	addi	a5,a5,818 # 800083c8 <syscalls>
    8000209e:	97ba                	add	a5,a5,a4
    800020a0:	639c                	ld	a5,0(a5)
    800020a2:	c789                	beqz	a5,800020ac <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800020a4:	9782                	jalr	a5
    800020a6:	06a93823          	sd	a0,112(s2)
    800020aa:	a839                	j	800020c8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020ac:	16848613          	addi	a2,s1,360
    800020b0:	588c                	lw	a1,48(s1)
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	2de50513          	addi	a0,a0,734 # 80008390 <states.1750+0x150>
    800020ba:	00004097          	auipc	ra,0x4
    800020be:	d38080e7          	jalr	-712(ra) # 80005df2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020c2:	74bc                	ld	a5,104(s1)
    800020c4:	577d                	li	a4,-1
    800020c6:	fbb8                	sd	a4,112(a5)
  }
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6902                	ld	s2,0(sp)
    800020d0:	6105                	addi	sp,sp,32
    800020d2:	8082                	ret

00000000800020d4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020dc:	fec40593          	addi	a1,s0,-20
    800020e0:	4501                	li	a0,0
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	f12080e7          	jalr	-238(ra) # 80001ff4 <argint>
    return -1;
    800020ea:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ec:	00054963          	bltz	a0,800020fe <sys_exit+0x2a>
  exit(n);
    800020f0:	fec42503          	lw	a0,-20(s0)
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	67c080e7          	jalr	1660(ra) # 80001770 <exit>
  return 0;  // not reached
    800020fc:	4781                	li	a5,0
}
    800020fe:	853e                	mv	a0,a5
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002108:	1141                	addi	sp,sp,-16
    8000210a:	e406                	sd	ra,8(sp)
    8000210c:	e022                	sd	s0,0(sp)
    8000210e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	d38080e7          	jalr	-712(ra) # 80000e48 <myproc>
}
    80002118:	5908                	lw	a0,48(a0)
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_fork>:

uint64
sys_fork(void)
{
    80002122:	1141                	addi	sp,sp,-16
    80002124:	e406                	sd	ra,8(sp)
    80002126:	e022                	sd	s0,0(sp)
    80002128:	0800                	addi	s0,sp,16
  return fork();
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	0fc080e7          	jalr	252(ra) # 80001226 <fork>
}
    80002132:	60a2                	ld	ra,8(sp)
    80002134:	6402                	ld	s0,0(sp)
    80002136:	0141                	addi	sp,sp,16
    80002138:	8082                	ret

000000008000213a <sys_wait>:

uint64
sys_wait(void)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002142:	fe840593          	addi	a1,s0,-24
    80002146:	4501                	li	a0,0
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	ece080e7          	jalr	-306(ra) # 80002016 <argaddr>
    80002150:	87aa                	mv	a5,a0
    return -1;
    80002152:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002154:	0007c863          	bltz	a5,80002164 <sys_wait+0x2a>
  return wait(p);
    80002158:	fe843503          	ld	a0,-24(s0)
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	41c080e7          	jalr	1052(ra) # 80001578 <wait>
}
    80002164:	60e2                	ld	ra,24(sp)
    80002166:	6442                	ld	s0,16(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000216c:	7179                	addi	sp,sp,-48
    8000216e:	f406                	sd	ra,40(sp)
    80002170:	f022                	sd	s0,32(sp)
    80002172:	ec26                	sd	s1,24(sp)
    80002174:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002176:	fdc40593          	addi	a1,s0,-36
    8000217a:	4501                	li	a0,0
    8000217c:	00000097          	auipc	ra,0x0
    80002180:	e78080e7          	jalr	-392(ra) # 80001ff4 <argint>
    80002184:	87aa                	mv	a5,a0
    return -1;
    80002186:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002188:	0207c063          	bltz	a5,800021a8 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    8000218c:	fffff097          	auipc	ra,0xfffff
    80002190:	cbc080e7          	jalr	-836(ra) # 80000e48 <myproc>
    80002194:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    80002196:	fdc42503          	lw	a0,-36(s0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	018080e7          	jalr	24(ra) # 800011b2 <growproc>
    800021a2:	00054863          	bltz	a0,800021b2 <sys_sbrk+0x46>
    return -1;
  return addr;
    800021a6:	8526                	mv	a0,s1
}
    800021a8:	70a2                	ld	ra,40(sp)
    800021aa:	7402                	ld	s0,32(sp)
    800021ac:	64e2                	ld	s1,24(sp)
    800021ae:	6145                	addi	sp,sp,48
    800021b0:	8082                	ret
    return -1;
    800021b2:	557d                	li	a0,-1
    800021b4:	bfd5                	j	800021a8 <sys_sbrk+0x3c>

00000000800021b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021b6:	7139                	addi	sp,sp,-64
    800021b8:	fc06                	sd	ra,56(sp)
    800021ba:	f822                	sd	s0,48(sp)
    800021bc:	f426                	sd	s1,40(sp)
    800021be:	f04a                	sd	s2,32(sp)
    800021c0:	ec4e                	sd	s3,24(sp)
    800021c2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800021c4:	fcc40593          	addi	a1,s0,-52
    800021c8:	4501                	li	a0,0
    800021ca:	00000097          	auipc	ra,0x0
    800021ce:	e2a080e7          	jalr	-470(ra) # 80001ff4 <argint>
    return -1;
    800021d2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021d4:	06054963          	bltz	a0,80002246 <sys_sleep+0x90>
  acquire(&tickslock);
    800021d8:	00011517          	auipc	a0,0x11
    800021dc:	0a850513          	addi	a0,a0,168 # 80013280 <tickslock>
    800021e0:	00004097          	auipc	ra,0x4
    800021e4:	180080e7          	jalr	384(ra) # 80006360 <acquire>
  ticks0 = ticks;
    800021e8:	00007917          	auipc	s2,0x7
    800021ec:	e3092903          	lw	s2,-464(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021f0:	fcc42783          	lw	a5,-52(s0)
    800021f4:	cf85                	beqz	a5,8000222c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021f6:	00011997          	auipc	s3,0x11
    800021fa:	08a98993          	addi	s3,s3,138 # 80013280 <tickslock>
    800021fe:	00007497          	auipc	s1,0x7
    80002202:	e1a48493          	addi	s1,s1,-486 # 80009018 <ticks>
    if(myproc()->killed){
    80002206:	fffff097          	auipc	ra,0xfffff
    8000220a:	c42080e7          	jalr	-958(ra) # 80000e48 <myproc>
    8000220e:	551c                	lw	a5,40(a0)
    80002210:	e3b9                	bnez	a5,80002256 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    80002212:	85ce                	mv	a1,s3
    80002214:	8526                	mv	a0,s1
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	2fe080e7          	jalr	766(ra) # 80001514 <sleep>
  while(ticks - ticks0 < n){
    8000221e:	409c                	lw	a5,0(s1)
    80002220:	412787bb          	subw	a5,a5,s2
    80002224:	fcc42703          	lw	a4,-52(s0)
    80002228:	fce7efe3          	bltu	a5,a4,80002206 <sys_sleep+0x50>
  }
  release(&tickslock);
    8000222c:	00011517          	auipc	a0,0x11
    80002230:	05450513          	addi	a0,a0,84 # 80013280 <tickslock>
    80002234:	00004097          	auipc	ra,0x4
    80002238:	1e0080e7          	jalr	480(ra) # 80006414 <release>

  backtrace();
    8000223c:	00004097          	auipc	ra,0x4
    80002240:	dce080e7          	jalr	-562(ra) # 8000600a <backtrace>

  return 0;
    80002244:	4781                	li	a5,0
}
    80002246:	853e                	mv	a0,a5
    80002248:	70e2                	ld	ra,56(sp)
    8000224a:	7442                	ld	s0,48(sp)
    8000224c:	74a2                	ld	s1,40(sp)
    8000224e:	7902                	ld	s2,32(sp)
    80002250:	69e2                	ld	s3,24(sp)
    80002252:	6121                	addi	sp,sp,64
    80002254:	8082                	ret
      release(&tickslock);
    80002256:	00011517          	auipc	a0,0x11
    8000225a:	02a50513          	addi	a0,a0,42 # 80013280 <tickslock>
    8000225e:	00004097          	auipc	ra,0x4
    80002262:	1b6080e7          	jalr	438(ra) # 80006414 <release>
      return -1;
    80002266:	57fd                	li	a5,-1
    80002268:	bff9                	j	80002246 <sys_sleep+0x90>

000000008000226a <sys_kill>:

uint64
sys_kill(void)
{
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002272:	fec40593          	addi	a1,s0,-20
    80002276:	4501                	li	a0,0
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	d7c080e7          	jalr	-644(ra) # 80001ff4 <argint>
    80002280:	87aa                	mv	a5,a0
    return -1;
    80002282:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002284:	0007c863          	bltz	a5,80002294 <sys_kill+0x2a>
  return kill(pid);
    80002288:	fec42503          	lw	a0,-20(s0)
    8000228c:	fffff097          	auipc	ra,0xfffff
    80002290:	5ba080e7          	jalr	1466(ra) # 80001846 <kill>
}
    80002294:	60e2                	ld	ra,24(sp)
    80002296:	6442                	ld	s0,16(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000229c:	1101                	addi	sp,sp,-32
    8000229e:	ec06                	sd	ra,24(sp)
    800022a0:	e822                	sd	s0,16(sp)
    800022a2:	e426                	sd	s1,8(sp)
    800022a4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022a6:	00011517          	auipc	a0,0x11
    800022aa:	fda50513          	addi	a0,a0,-38 # 80013280 <tickslock>
    800022ae:	00004097          	auipc	ra,0x4
    800022b2:	0b2080e7          	jalr	178(ra) # 80006360 <acquire>
  xticks = ticks;
    800022b6:	00007497          	auipc	s1,0x7
    800022ba:	d624a483          	lw	s1,-670(s1) # 80009018 <ticks>
  release(&tickslock);
    800022be:	00011517          	auipc	a0,0x11
    800022c2:	fc250513          	addi	a0,a0,-62 # 80013280 <tickslock>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	14e080e7          	jalr	334(ra) # 80006414 <release>
  return xticks;
}
    800022ce:	02049513          	slli	a0,s1,0x20
    800022d2:	9101                	srli	a0,a0,0x20
    800022d4:	60e2                	ld	ra,24(sp)
    800022d6:	6442                	ld	s0,16(sp)
    800022d8:	64a2                	ld	s1,8(sp)
    800022da:	6105                	addi	sp,sp,32
    800022dc:	8082                	ret

00000000800022de <sys_sigalarm>:

//
uint64
sys_sigalarm(void)
{ 
    800022de:	7179                	addi	sp,sp,-48
    800022e0:	f406                	sd	ra,40(sp)
    800022e2:	f022                	sd	s0,32(sp)
    800022e4:	ec26                	sd	s1,24(sp)
    800022e6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800022e8:	fffff097          	auipc	ra,0xfffff
    800022ec:	b60080e7          	jalr	-1184(ra) # 80000e48 <myproc>
    800022f0:	84aa                	mv	s1,a0
  int alarm;
  uint64 alret;

  if(argint(0,&alarm)<0 || argaddr(1, &alret) < 0)
    800022f2:	fdc40593          	addi	a1,s0,-36
    800022f6:	4501                	li	a0,0
    800022f8:	00000097          	auipc	ra,0x0
    800022fc:	cfc080e7          	jalr	-772(ra) # 80001ff4 <argint>
    return -1;
    80002300:	57fd                	li	a5,-1
  if(argint(0,&alarm)<0 || argaddr(1, &alret) < 0)
    80002302:	02054463          	bltz	a0,8000232a <sys_sigalarm+0x4c>
    80002306:	fd040593          	addi	a1,s0,-48
    8000230a:	4505                	li	a0,1
    8000230c:	00000097          	auipc	ra,0x0
    80002310:	d0a080e7          	jalr	-758(ra) # 80002016 <argaddr>
    80002314:	02054163          	bltz	a0,80002336 <sys_sigalarm+0x58>

  p->alarm = alarm;
    80002318:	fdc42783          	lw	a5,-36(s0)
    8000231c:	d8dc                	sw	a5,52(s1)
  p->alret = alret;
    8000231e:	fd043783          	ld	a5,-48(s0)
    80002322:	ecbc                	sd	a5,88(s1)
  p->cu_alarm = 0;
    80002324:	0204ac23          	sw	zero,56(s1)

  return 0;
    80002328:	4781                	li	a5,0
}
    8000232a:	853e                	mv	a0,a5
    8000232c:	70a2                	ld	ra,40(sp)
    8000232e:	7402                	ld	s0,32(sp)
    80002330:	64e2                	ld	s1,24(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret
    return -1;
    80002336:	57fd                	li	a5,-1
    80002338:	bfcd                	j	8000232a <sys_sigalarm+0x4c>

000000008000233a <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000233a:	1141                	addi	sp,sp,-16
    8000233c:	e406                	sd	ra,8(sp)
    8000233e:	e022                	sd	s0,0(sp)
    80002340:	0800                	addi	s0,sp,16

  struct proc *p = myproc();
    80002342:	fffff097          	auipc	ra,0xfffff
    80002346:	b06080e7          	jalr	-1274(ra) # 80000e48 <myproc>
  p->trapframe->epc = p->saved_epc;
    8000234a:	753c                	ld	a5,104(a0)
    8000234c:	17853703          	ld	a4,376(a0)
    80002350:	ef98                	sd	a4,24(a5)
  p->trapframe->ra = p->saved_ra;
    80002352:	753c                	ld	a5,104(a0)
    80002354:	18053703          	ld	a4,384(a0)
    80002358:	f798                	sd	a4,40(a5)
  p->trapframe->sp = p->saved_sp;
    8000235a:	753c                	ld	a5,104(a0)
    8000235c:	18853703          	ld	a4,392(a0)
    80002360:	fb98                	sd	a4,48(a5)
  p->trapframe->gp = p->saved_gp;
    80002362:	753c                	ld	a5,104(a0)
    80002364:	19053703          	ld	a4,400(a0)
    80002368:	ff98                	sd	a4,56(a5)
  p->trapframe->tp = p->saved_tp;
    8000236a:	753c                	ld	a5,104(a0)
    8000236c:	19853703          	ld	a4,408(a0)
    80002370:	e3b8                	sd	a4,64(a5)
  p->trapframe->t0 = p->saved_t0;
    80002372:	753c                	ld	a5,104(a0)
    80002374:	1a053703          	ld	a4,416(a0)
    80002378:	e7b8                	sd	a4,72(a5)
  p->trapframe->t1 = p->saved_t1;
    8000237a:	753c                	ld	a5,104(a0)
    8000237c:	1a853703          	ld	a4,424(a0)
    80002380:	ebb8                	sd	a4,80(a5)
  p->trapframe->t2 = p->saved_t2;
    80002382:	753c                	ld	a5,104(a0)
    80002384:	1b053703          	ld	a4,432(a0)
    80002388:	efb8                	sd	a4,88(a5)
  p->trapframe->t3 = p->saved_t3;
    8000238a:	753c                	ld	a5,104(a0)
    8000238c:	25853703          	ld	a4,600(a0)
    80002390:	10e7b023          	sd	a4,256(a5)
  p->trapframe->t4 = p->saved_t4;
    80002394:	753c                	ld	a5,104(a0)
    80002396:	26053703          	ld	a4,608(a0)
    8000239a:	10e7b423          	sd	a4,264(a5)
  p->trapframe->t5 = p->saved_t5;
    8000239e:	753c                	ld	a5,104(a0)
    800023a0:	26853703          	ld	a4,616(a0)
    800023a4:	10e7b823          	sd	a4,272(a5)
  p->trapframe->t6 = p->saved_t6;
    800023a8:	753c                	ld	a5,104(a0)
    800023aa:	27053703          	ld	a4,624(a0)
    800023ae:	10e7bc23          	sd	a4,280(a5)
  p->trapframe->s0 = p->saved_s0;
    800023b2:	753c                	ld	a5,104(a0)
    800023b4:	1b853703          	ld	a4,440(a0)
    800023b8:	f3b8                	sd	a4,96(a5)
  p->trapframe->s1 = p->saved_s1;
    800023ba:	753c                	ld	a5,104(a0)
    800023bc:	1c053703          	ld	a4,448(a0)
    800023c0:	f7b8                	sd	a4,104(a5)
  p->trapframe->s2 = p->saved_s2;
    800023c2:	753c                	ld	a5,104(a0)
    800023c4:	1c853703          	ld	a4,456(a0)
    800023c8:	fbd8                	sd	a4,176(a5)
  p->trapframe->s3 = p->saved_s3;
    800023ca:	753c                	ld	a5,104(a0)
    800023cc:	1d053703          	ld	a4,464(a0)
    800023d0:	ffd8                	sd	a4,184(a5)
  p->trapframe->s4 = p->saved_s4;
    800023d2:	753c                	ld	a5,104(a0)
    800023d4:	1d853703          	ld	a4,472(a0)
    800023d8:	e3f8                	sd	a4,192(a5)
  p->trapframe->s5 = p->saved_s5;
    800023da:	753c                	ld	a5,104(a0)
    800023dc:	1e053703          	ld	a4,480(a0)
    800023e0:	e7f8                	sd	a4,200(a5)
  p->trapframe->s6 = p->saved_s6;
    800023e2:	753c                	ld	a5,104(a0)
    800023e4:	1e853703          	ld	a4,488(a0)
    800023e8:	ebf8                	sd	a4,208(a5)
  p->trapframe->s7 = p->saved_s7;
    800023ea:	753c                	ld	a5,104(a0)
    800023ec:	1f053703          	ld	a4,496(a0)
    800023f0:	eff8                	sd	a4,216(a5)
  p->trapframe->s8 = p->saved_s8;
    800023f2:	753c                	ld	a5,104(a0)
    800023f4:	1f853703          	ld	a4,504(a0)
    800023f8:	f3f8                	sd	a4,224(a5)
  p->trapframe->s9 = p->saved_s9;
    800023fa:	753c                	ld	a5,104(a0)
    800023fc:	20053703          	ld	a4,512(a0)
    80002400:	f7f8                	sd	a4,232(a5)
  p->trapframe->s10 = p->saved_s10;
    80002402:	753c                	ld	a5,104(a0)
    80002404:	20853703          	ld	a4,520(a0)
    80002408:	fbf8                	sd	a4,240(a5)
  p->trapframe->s11 = p->saved_s11;
    8000240a:	753c                	ld	a5,104(a0)
    8000240c:	21053703          	ld	a4,528(a0)
    80002410:	fff8                	sd	a4,248(a5)
  p->trapframe->a0 = p->saved_a0;
    80002412:	753c                	ld	a5,104(a0)
    80002414:	21853703          	ld	a4,536(a0)
    80002418:	fbb8                	sd	a4,112(a5)
  p->trapframe->a1 = p->saved_a1;
    8000241a:	753c                	ld	a5,104(a0)
    8000241c:	22053703          	ld	a4,544(a0)
    80002420:	ffb8                	sd	a4,120(a5)
  p->trapframe->a2 = p->saved_a2;
    80002422:	753c                	ld	a5,104(a0)
    80002424:	22853703          	ld	a4,552(a0)
    80002428:	e3d8                	sd	a4,128(a5)
  p->trapframe->a3 = p->saved_a3;
    8000242a:	753c                	ld	a5,104(a0)
    8000242c:	23053703          	ld	a4,560(a0)
    80002430:	e7d8                	sd	a4,136(a5)
  p->trapframe->a4 = p->saved_a4;
    80002432:	753c                	ld	a5,104(a0)
    80002434:	23853703          	ld	a4,568(a0)
    80002438:	ebd8                	sd	a4,144(a5)
  p->trapframe->a5 = p->saved_a5;
    8000243a:	753c                	ld	a5,104(a0)
    8000243c:	24053703          	ld	a4,576(a0)
    80002440:	efd8                	sd	a4,152(a5)
  p->trapframe->a6 = p->saved_a6;
    80002442:	753c                	ld	a5,104(a0)
    80002444:	24853703          	ld	a4,584(a0)
    80002448:	f3d8                	sd	a4,160(a5)
  p->trapframe->a7 = p->saved_a7;
    8000244a:	753c                	ld	a5,104(a0)
    8000244c:	25053703          	ld	a4,592(a0)
    80002450:	f7d8                	sd	a4,168(a5)
  p->alret = 0;
    80002452:	04053c23          	sd	zero,88(a0)
  p->c_alret = 0;
    80002456:	02052e23          	sw	zero,60(a0)
  return 0;
    8000245a:	4501                	li	a0,0
    8000245c:	60a2                	ld	ra,8(sp)
    8000245e:	6402                	ld	s0,0(sp)
    80002460:	0141                	addi	sp,sp,16
    80002462:	8082                	ret

0000000080002464 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002464:	7179                	addi	sp,sp,-48
    80002466:	f406                	sd	ra,40(sp)
    80002468:	f022                	sd	s0,32(sp)
    8000246a:	ec26                	sd	s1,24(sp)
    8000246c:	e84a                	sd	s2,16(sp)
    8000246e:	e44e                	sd	s3,8(sp)
    80002470:	e052                	sd	s4,0(sp)
    80002472:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002474:	00006597          	auipc	a1,0x6
    80002478:	01458593          	addi	a1,a1,20 # 80008488 <syscalls+0xc0>
    8000247c:	00011517          	auipc	a0,0x11
    80002480:	e1c50513          	addi	a0,a0,-484 # 80013298 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	e4c080e7          	jalr	-436(ra) # 800062d0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000248c:	00019797          	auipc	a5,0x19
    80002490:	e0c78793          	addi	a5,a5,-500 # 8001b298 <bcache+0x8000>
    80002494:	00019717          	auipc	a4,0x19
    80002498:	06c70713          	addi	a4,a4,108 # 8001b500 <bcache+0x8268>
    8000249c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024a4:	00011497          	auipc	s1,0x11
    800024a8:	e0c48493          	addi	s1,s1,-500 # 800132b0 <bcache+0x18>
    b->next = bcache.head.next;
    800024ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024b0:	00006a17          	auipc	s4,0x6
    800024b4:	fe0a0a13          	addi	s4,s4,-32 # 80008490 <syscalls+0xc8>
    b->next = bcache.head.next;
    800024b8:	2b893783          	ld	a5,696(s2)
    800024bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024c2:	85d2                	mv	a1,s4
    800024c4:	01048513          	addi	a0,s1,16
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	4bc080e7          	jalr	1212(ra) # 80003984 <initsleeplock>
    bcache.head.next->prev = b;
    800024d0:	2b893783          	ld	a5,696(s2)
    800024d4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024d6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024da:	45848493          	addi	s1,s1,1112
    800024de:	fd349de3          	bne	s1,s3,800024b8 <binit+0x54>
  }
}
    800024e2:	70a2                	ld	ra,40(sp)
    800024e4:	7402                	ld	s0,32(sp)
    800024e6:	64e2                	ld	s1,24(sp)
    800024e8:	6942                	ld	s2,16(sp)
    800024ea:	69a2                	ld	s3,8(sp)
    800024ec:	6a02                	ld	s4,0(sp)
    800024ee:	6145                	addi	sp,sp,48
    800024f0:	8082                	ret

00000000800024f2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800024f2:	7179                	addi	sp,sp,-48
    800024f4:	f406                	sd	ra,40(sp)
    800024f6:	f022                	sd	s0,32(sp)
    800024f8:	ec26                	sd	s1,24(sp)
    800024fa:	e84a                	sd	s2,16(sp)
    800024fc:	e44e                	sd	s3,8(sp)
    800024fe:	1800                	addi	s0,sp,48
    80002500:	89aa                	mv	s3,a0
    80002502:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002504:	00011517          	auipc	a0,0x11
    80002508:	d9450513          	addi	a0,a0,-620 # 80013298 <bcache>
    8000250c:	00004097          	auipc	ra,0x4
    80002510:	e54080e7          	jalr	-428(ra) # 80006360 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002514:	00019497          	auipc	s1,0x19
    80002518:	03c4b483          	ld	s1,60(s1) # 8001b550 <bcache+0x82b8>
    8000251c:	00019797          	auipc	a5,0x19
    80002520:	fe478793          	addi	a5,a5,-28 # 8001b500 <bcache+0x8268>
    80002524:	02f48f63          	beq	s1,a5,80002562 <bread+0x70>
    80002528:	873e                	mv	a4,a5
    8000252a:	a021                	j	80002532 <bread+0x40>
    8000252c:	68a4                	ld	s1,80(s1)
    8000252e:	02e48a63          	beq	s1,a4,80002562 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002532:	449c                	lw	a5,8(s1)
    80002534:	ff379ce3          	bne	a5,s3,8000252c <bread+0x3a>
    80002538:	44dc                	lw	a5,12(s1)
    8000253a:	ff2799e3          	bne	a5,s2,8000252c <bread+0x3a>
      b->refcnt++;
    8000253e:	40bc                	lw	a5,64(s1)
    80002540:	2785                	addiw	a5,a5,1
    80002542:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002544:	00011517          	auipc	a0,0x11
    80002548:	d5450513          	addi	a0,a0,-684 # 80013298 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	ec8080e7          	jalr	-312(ra) # 80006414 <release>
      acquiresleep(&b->lock);
    80002554:	01048513          	addi	a0,s1,16
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	466080e7          	jalr	1126(ra) # 800039be <acquiresleep>
      return b;
    80002560:	a8b9                	j	800025be <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002562:	00019497          	auipc	s1,0x19
    80002566:	fe64b483          	ld	s1,-26(s1) # 8001b548 <bcache+0x82b0>
    8000256a:	00019797          	auipc	a5,0x19
    8000256e:	f9678793          	addi	a5,a5,-106 # 8001b500 <bcache+0x8268>
    80002572:	00f48863          	beq	s1,a5,80002582 <bread+0x90>
    80002576:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002578:	40bc                	lw	a5,64(s1)
    8000257a:	cf81                	beqz	a5,80002592 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000257c:	64a4                	ld	s1,72(s1)
    8000257e:	fee49de3          	bne	s1,a4,80002578 <bread+0x86>
  panic("bget: no buffers");
    80002582:	00006517          	auipc	a0,0x6
    80002586:	f1650513          	addi	a0,a0,-234 # 80008498 <syscalls+0xd0>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	81e080e7          	jalr	-2018(ra) # 80005da8 <panic>
      b->dev = dev;
    80002592:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002596:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000259a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000259e:	4785                	li	a5,1
    800025a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025a2:	00011517          	auipc	a0,0x11
    800025a6:	cf650513          	addi	a0,a0,-778 # 80013298 <bcache>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	e6a080e7          	jalr	-406(ra) # 80006414 <release>
      acquiresleep(&b->lock);
    800025b2:	01048513          	addi	a0,s1,16
    800025b6:	00001097          	auipc	ra,0x1
    800025ba:	408080e7          	jalr	1032(ra) # 800039be <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025be:	409c                	lw	a5,0(s1)
    800025c0:	cb89                	beqz	a5,800025d2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025c2:	8526                	mv	a0,s1
    800025c4:	70a2                	ld	ra,40(sp)
    800025c6:	7402                	ld	s0,32(sp)
    800025c8:	64e2                	ld	s1,24(sp)
    800025ca:	6942                	ld	s2,16(sp)
    800025cc:	69a2                	ld	s3,8(sp)
    800025ce:	6145                	addi	sp,sp,48
    800025d0:	8082                	ret
    virtio_disk_rw(b, 0);
    800025d2:	4581                	li	a1,0
    800025d4:	8526                	mv	a0,s1
    800025d6:	00003097          	auipc	ra,0x3
    800025da:	f10080e7          	jalr	-240(ra) # 800054e6 <virtio_disk_rw>
    b->valid = 1;
    800025de:	4785                	li	a5,1
    800025e0:	c09c                	sw	a5,0(s1)
  return b;
    800025e2:	b7c5                	j	800025c2 <bread+0xd0>

00000000800025e4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025f0:	0541                	addi	a0,a0,16
    800025f2:	00001097          	auipc	ra,0x1
    800025f6:	466080e7          	jalr	1126(ra) # 80003a58 <holdingsleep>
    800025fa:	cd01                	beqz	a0,80002612 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800025fc:	4585                	li	a1,1
    800025fe:	8526                	mv	a0,s1
    80002600:	00003097          	auipc	ra,0x3
    80002604:	ee6080e7          	jalr	-282(ra) # 800054e6 <virtio_disk_rw>
}
    80002608:	60e2                	ld	ra,24(sp)
    8000260a:	6442                	ld	s0,16(sp)
    8000260c:	64a2                	ld	s1,8(sp)
    8000260e:	6105                	addi	sp,sp,32
    80002610:	8082                	ret
    panic("bwrite");
    80002612:	00006517          	auipc	a0,0x6
    80002616:	e9e50513          	addi	a0,a0,-354 # 800084b0 <syscalls+0xe8>
    8000261a:	00003097          	auipc	ra,0x3
    8000261e:	78e080e7          	jalr	1934(ra) # 80005da8 <panic>

0000000080002622 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002622:	1101                	addi	sp,sp,-32
    80002624:	ec06                	sd	ra,24(sp)
    80002626:	e822                	sd	s0,16(sp)
    80002628:	e426                	sd	s1,8(sp)
    8000262a:	e04a                	sd	s2,0(sp)
    8000262c:	1000                	addi	s0,sp,32
    8000262e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002630:	01050913          	addi	s2,a0,16
    80002634:	854a                	mv	a0,s2
    80002636:	00001097          	auipc	ra,0x1
    8000263a:	422080e7          	jalr	1058(ra) # 80003a58 <holdingsleep>
    8000263e:	c92d                	beqz	a0,800026b0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002640:	854a                	mv	a0,s2
    80002642:	00001097          	auipc	ra,0x1
    80002646:	3d2080e7          	jalr	978(ra) # 80003a14 <releasesleep>

  acquire(&bcache.lock);
    8000264a:	00011517          	auipc	a0,0x11
    8000264e:	c4e50513          	addi	a0,a0,-946 # 80013298 <bcache>
    80002652:	00004097          	auipc	ra,0x4
    80002656:	d0e080e7          	jalr	-754(ra) # 80006360 <acquire>
  b->refcnt--;
    8000265a:	40bc                	lw	a5,64(s1)
    8000265c:	37fd                	addiw	a5,a5,-1
    8000265e:	0007871b          	sext.w	a4,a5
    80002662:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002664:	eb05                	bnez	a4,80002694 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002666:	68bc                	ld	a5,80(s1)
    80002668:	64b8                	ld	a4,72(s1)
    8000266a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000266c:	64bc                	ld	a5,72(s1)
    8000266e:	68b8                	ld	a4,80(s1)
    80002670:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002672:	00019797          	auipc	a5,0x19
    80002676:	c2678793          	addi	a5,a5,-986 # 8001b298 <bcache+0x8000>
    8000267a:	2b87b703          	ld	a4,696(a5)
    8000267e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002680:	00019717          	auipc	a4,0x19
    80002684:	e8070713          	addi	a4,a4,-384 # 8001b500 <bcache+0x8268>
    80002688:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000268a:	2b87b703          	ld	a4,696(a5)
    8000268e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002690:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002694:	00011517          	auipc	a0,0x11
    80002698:	c0450513          	addi	a0,a0,-1020 # 80013298 <bcache>
    8000269c:	00004097          	auipc	ra,0x4
    800026a0:	d78080e7          	jalr	-648(ra) # 80006414 <release>
}
    800026a4:	60e2                	ld	ra,24(sp)
    800026a6:	6442                	ld	s0,16(sp)
    800026a8:	64a2                	ld	s1,8(sp)
    800026aa:	6902                	ld	s2,0(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret
    panic("brelse");
    800026b0:	00006517          	auipc	a0,0x6
    800026b4:	e0850513          	addi	a0,a0,-504 # 800084b8 <syscalls+0xf0>
    800026b8:	00003097          	auipc	ra,0x3
    800026bc:	6f0080e7          	jalr	1776(ra) # 80005da8 <panic>

00000000800026c0 <bpin>:

void
bpin(struct buf *b) {
    800026c0:	1101                	addi	sp,sp,-32
    800026c2:	ec06                	sd	ra,24(sp)
    800026c4:	e822                	sd	s0,16(sp)
    800026c6:	e426                	sd	s1,8(sp)
    800026c8:	1000                	addi	s0,sp,32
    800026ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026cc:	00011517          	auipc	a0,0x11
    800026d0:	bcc50513          	addi	a0,a0,-1076 # 80013298 <bcache>
    800026d4:	00004097          	auipc	ra,0x4
    800026d8:	c8c080e7          	jalr	-884(ra) # 80006360 <acquire>
  b->refcnt++;
    800026dc:	40bc                	lw	a5,64(s1)
    800026de:	2785                	addiw	a5,a5,1
    800026e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800026e2:	00011517          	auipc	a0,0x11
    800026e6:	bb650513          	addi	a0,a0,-1098 # 80013298 <bcache>
    800026ea:	00004097          	auipc	ra,0x4
    800026ee:	d2a080e7          	jalr	-726(ra) # 80006414 <release>
}
    800026f2:	60e2                	ld	ra,24(sp)
    800026f4:	6442                	ld	s0,16(sp)
    800026f6:	64a2                	ld	s1,8(sp)
    800026f8:	6105                	addi	sp,sp,32
    800026fa:	8082                	ret

00000000800026fc <bunpin>:

void
bunpin(struct buf *b) {
    800026fc:	1101                	addi	sp,sp,-32
    800026fe:	ec06                	sd	ra,24(sp)
    80002700:	e822                	sd	s0,16(sp)
    80002702:	e426                	sd	s1,8(sp)
    80002704:	1000                	addi	s0,sp,32
    80002706:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002708:	00011517          	auipc	a0,0x11
    8000270c:	b9050513          	addi	a0,a0,-1136 # 80013298 <bcache>
    80002710:	00004097          	auipc	ra,0x4
    80002714:	c50080e7          	jalr	-944(ra) # 80006360 <acquire>
  b->refcnt--;
    80002718:	40bc                	lw	a5,64(s1)
    8000271a:	37fd                	addiw	a5,a5,-1
    8000271c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000271e:	00011517          	auipc	a0,0x11
    80002722:	b7a50513          	addi	a0,a0,-1158 # 80013298 <bcache>
    80002726:	00004097          	auipc	ra,0x4
    8000272a:	cee080e7          	jalr	-786(ra) # 80006414 <release>
}
    8000272e:	60e2                	ld	ra,24(sp)
    80002730:	6442                	ld	s0,16(sp)
    80002732:	64a2                	ld	s1,8(sp)
    80002734:	6105                	addi	sp,sp,32
    80002736:	8082                	ret

0000000080002738 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002738:	1101                	addi	sp,sp,-32
    8000273a:	ec06                	sd	ra,24(sp)
    8000273c:	e822                	sd	s0,16(sp)
    8000273e:	e426                	sd	s1,8(sp)
    80002740:	e04a                	sd	s2,0(sp)
    80002742:	1000                	addi	s0,sp,32
    80002744:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002746:	00d5d59b          	srliw	a1,a1,0xd
    8000274a:	00019797          	auipc	a5,0x19
    8000274e:	22a7a783          	lw	a5,554(a5) # 8001b974 <sb+0x1c>
    80002752:	9dbd                	addw	a1,a1,a5
    80002754:	00000097          	auipc	ra,0x0
    80002758:	d9e080e7          	jalr	-610(ra) # 800024f2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000275c:	0074f713          	andi	a4,s1,7
    80002760:	4785                	li	a5,1
    80002762:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002766:	14ce                	slli	s1,s1,0x33
    80002768:	90d9                	srli	s1,s1,0x36
    8000276a:	00950733          	add	a4,a0,s1
    8000276e:	05874703          	lbu	a4,88(a4)
    80002772:	00e7f6b3          	and	a3,a5,a4
    80002776:	c69d                	beqz	a3,800027a4 <bfree+0x6c>
    80002778:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000277a:	94aa                	add	s1,s1,a0
    8000277c:	fff7c793          	not	a5,a5
    80002780:	8ff9                	and	a5,a5,a4
    80002782:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002786:	00001097          	auipc	ra,0x1
    8000278a:	118080e7          	jalr	280(ra) # 8000389e <log_write>
  brelse(bp);
    8000278e:	854a                	mv	a0,s2
    80002790:	00000097          	auipc	ra,0x0
    80002794:	e92080e7          	jalr	-366(ra) # 80002622 <brelse>
}
    80002798:	60e2                	ld	ra,24(sp)
    8000279a:	6442                	ld	s0,16(sp)
    8000279c:	64a2                	ld	s1,8(sp)
    8000279e:	6902                	ld	s2,0(sp)
    800027a0:	6105                	addi	sp,sp,32
    800027a2:	8082                	ret
    panic("freeing free block");
    800027a4:	00006517          	auipc	a0,0x6
    800027a8:	d1c50513          	addi	a0,a0,-740 # 800084c0 <syscalls+0xf8>
    800027ac:	00003097          	auipc	ra,0x3
    800027b0:	5fc080e7          	jalr	1532(ra) # 80005da8 <panic>

00000000800027b4 <balloc>:
{
    800027b4:	711d                	addi	sp,sp,-96
    800027b6:	ec86                	sd	ra,88(sp)
    800027b8:	e8a2                	sd	s0,80(sp)
    800027ba:	e4a6                	sd	s1,72(sp)
    800027bc:	e0ca                	sd	s2,64(sp)
    800027be:	fc4e                	sd	s3,56(sp)
    800027c0:	f852                	sd	s4,48(sp)
    800027c2:	f456                	sd	s5,40(sp)
    800027c4:	f05a                	sd	s6,32(sp)
    800027c6:	ec5e                	sd	s7,24(sp)
    800027c8:	e862                	sd	s8,16(sp)
    800027ca:	e466                	sd	s9,8(sp)
    800027cc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027ce:	00019797          	auipc	a5,0x19
    800027d2:	18e7a783          	lw	a5,398(a5) # 8001b95c <sb+0x4>
    800027d6:	cbd1                	beqz	a5,8000286a <balloc+0xb6>
    800027d8:	8baa                	mv	s7,a0
    800027da:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027dc:	00019b17          	auipc	s6,0x19
    800027e0:	17cb0b13          	addi	s6,s6,380 # 8001b958 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800027e6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027e8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800027ea:	6c89                	lui	s9,0x2
    800027ec:	a831                	j	80002808 <balloc+0x54>
    brelse(bp);
    800027ee:	854a                	mv	a0,s2
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	e32080e7          	jalr	-462(ra) # 80002622 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027f8:	015c87bb          	addw	a5,s9,s5
    800027fc:	00078a9b          	sext.w	s5,a5
    80002800:	004b2703          	lw	a4,4(s6)
    80002804:	06eaf363          	bgeu	s5,a4,8000286a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80002808:	41fad79b          	sraiw	a5,s5,0x1f
    8000280c:	0137d79b          	srliw	a5,a5,0x13
    80002810:	015787bb          	addw	a5,a5,s5
    80002814:	40d7d79b          	sraiw	a5,a5,0xd
    80002818:	01cb2583          	lw	a1,28(s6)
    8000281c:	9dbd                	addw	a1,a1,a5
    8000281e:	855e                	mv	a0,s7
    80002820:	00000097          	auipc	ra,0x0
    80002824:	cd2080e7          	jalr	-814(ra) # 800024f2 <bread>
    80002828:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000282a:	004b2503          	lw	a0,4(s6)
    8000282e:	000a849b          	sext.w	s1,s5
    80002832:	8662                	mv	a2,s8
    80002834:	faa4fde3          	bgeu	s1,a0,800027ee <balloc+0x3a>
      m = 1 << (bi % 8);
    80002838:	41f6579b          	sraiw	a5,a2,0x1f
    8000283c:	01d7d69b          	srliw	a3,a5,0x1d
    80002840:	00c6873b          	addw	a4,a3,a2
    80002844:	00777793          	andi	a5,a4,7
    80002848:	9f95                	subw	a5,a5,a3
    8000284a:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000284e:	4037571b          	sraiw	a4,a4,0x3
    80002852:	00e906b3          	add	a3,s2,a4
    80002856:	0586c683          	lbu	a3,88(a3)
    8000285a:	00d7f5b3          	and	a1,a5,a3
    8000285e:	cd91                	beqz	a1,8000287a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002860:	2605                	addiw	a2,a2,1
    80002862:	2485                	addiw	s1,s1,1
    80002864:	fd4618e3          	bne	a2,s4,80002834 <balloc+0x80>
    80002868:	b759                	j	800027ee <balloc+0x3a>
  panic("balloc: out of blocks");
    8000286a:	00006517          	auipc	a0,0x6
    8000286e:	c6e50513          	addi	a0,a0,-914 # 800084d8 <syscalls+0x110>
    80002872:	00003097          	auipc	ra,0x3
    80002876:	536080e7          	jalr	1334(ra) # 80005da8 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000287a:	974a                	add	a4,a4,s2
    8000287c:	8fd5                	or	a5,a5,a3
    8000287e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00001097          	auipc	ra,0x1
    80002888:	01a080e7          	jalr	26(ra) # 8000389e <log_write>
        brelse(bp);
    8000288c:	854a                	mv	a0,s2
    8000288e:	00000097          	auipc	ra,0x0
    80002892:	d94080e7          	jalr	-620(ra) # 80002622 <brelse>
  bp = bread(dev, bno);
    80002896:	85a6                	mv	a1,s1
    80002898:	855e                	mv	a0,s7
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	c58080e7          	jalr	-936(ra) # 800024f2 <bread>
    800028a2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028a4:	40000613          	li	a2,1024
    800028a8:	4581                	li	a1,0
    800028aa:	05850513          	addi	a0,a0,88
    800028ae:	ffffe097          	auipc	ra,0xffffe
    800028b2:	8ca080e7          	jalr	-1846(ra) # 80000178 <memset>
  log_write(bp);
    800028b6:	854a                	mv	a0,s2
    800028b8:	00001097          	auipc	ra,0x1
    800028bc:	fe6080e7          	jalr	-26(ra) # 8000389e <log_write>
  brelse(bp);
    800028c0:	854a                	mv	a0,s2
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	d60080e7          	jalr	-672(ra) # 80002622 <brelse>
}
    800028ca:	8526                	mv	a0,s1
    800028cc:	60e6                	ld	ra,88(sp)
    800028ce:	6446                	ld	s0,80(sp)
    800028d0:	64a6                	ld	s1,72(sp)
    800028d2:	6906                	ld	s2,64(sp)
    800028d4:	79e2                	ld	s3,56(sp)
    800028d6:	7a42                	ld	s4,48(sp)
    800028d8:	7aa2                	ld	s5,40(sp)
    800028da:	7b02                	ld	s6,32(sp)
    800028dc:	6be2                	ld	s7,24(sp)
    800028de:	6c42                	ld	s8,16(sp)
    800028e0:	6ca2                	ld	s9,8(sp)
    800028e2:	6125                	addi	sp,sp,96
    800028e4:	8082                	ret

00000000800028e6 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800028e6:	7179                	addi	sp,sp,-48
    800028e8:	f406                	sd	ra,40(sp)
    800028ea:	f022                	sd	s0,32(sp)
    800028ec:	ec26                	sd	s1,24(sp)
    800028ee:	e84a                	sd	s2,16(sp)
    800028f0:	e44e                	sd	s3,8(sp)
    800028f2:	e052                	sd	s4,0(sp)
    800028f4:	1800                	addi	s0,sp,48
    800028f6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800028f8:	47ad                	li	a5,11
    800028fa:	04b7fe63          	bgeu	a5,a1,80002956 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800028fe:	ff45849b          	addiw	s1,a1,-12
    80002902:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002906:	0ff00793          	li	a5,255
    8000290a:	0ae7e363          	bltu	a5,a4,800029b0 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000290e:	08052583          	lw	a1,128(a0)
    80002912:	c5ad                	beqz	a1,8000297c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002914:	00092503          	lw	a0,0(s2)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	bda080e7          	jalr	-1062(ra) # 800024f2 <bread>
    80002920:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002922:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002926:	02049593          	slli	a1,s1,0x20
    8000292a:	9181                	srli	a1,a1,0x20
    8000292c:	058a                	slli	a1,a1,0x2
    8000292e:	00b784b3          	add	s1,a5,a1
    80002932:	0004a983          	lw	s3,0(s1)
    80002936:	04098d63          	beqz	s3,80002990 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000293a:	8552                	mv	a0,s4
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	ce6080e7          	jalr	-794(ra) # 80002622 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002944:	854e                	mv	a0,s3
    80002946:	70a2                	ld	ra,40(sp)
    80002948:	7402                	ld	s0,32(sp)
    8000294a:	64e2                	ld	s1,24(sp)
    8000294c:	6942                	ld	s2,16(sp)
    8000294e:	69a2                	ld	s3,8(sp)
    80002950:	6a02                	ld	s4,0(sp)
    80002952:	6145                	addi	sp,sp,48
    80002954:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002956:	02059493          	slli	s1,a1,0x20
    8000295a:	9081                	srli	s1,s1,0x20
    8000295c:	048a                	slli	s1,s1,0x2
    8000295e:	94aa                	add	s1,s1,a0
    80002960:	0504a983          	lw	s3,80(s1)
    80002964:	fe0990e3          	bnez	s3,80002944 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002968:	4108                	lw	a0,0(a0)
    8000296a:	00000097          	auipc	ra,0x0
    8000296e:	e4a080e7          	jalr	-438(ra) # 800027b4 <balloc>
    80002972:	0005099b          	sext.w	s3,a0
    80002976:	0534a823          	sw	s3,80(s1)
    8000297a:	b7e9                	j	80002944 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000297c:	4108                	lw	a0,0(a0)
    8000297e:	00000097          	auipc	ra,0x0
    80002982:	e36080e7          	jalr	-458(ra) # 800027b4 <balloc>
    80002986:	0005059b          	sext.w	a1,a0
    8000298a:	08b92023          	sw	a1,128(s2)
    8000298e:	b759                	j	80002914 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002990:	00092503          	lw	a0,0(s2)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e20080e7          	jalr	-480(ra) # 800027b4 <balloc>
    8000299c:	0005099b          	sext.w	s3,a0
    800029a0:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800029a4:	8552                	mv	a0,s4
    800029a6:	00001097          	auipc	ra,0x1
    800029aa:	ef8080e7          	jalr	-264(ra) # 8000389e <log_write>
    800029ae:	b771                	j	8000293a <bmap+0x54>
  panic("bmap: out of range");
    800029b0:	00006517          	auipc	a0,0x6
    800029b4:	b4050513          	addi	a0,a0,-1216 # 800084f0 <syscalls+0x128>
    800029b8:	00003097          	auipc	ra,0x3
    800029bc:	3f0080e7          	jalr	1008(ra) # 80005da8 <panic>

00000000800029c0 <iget>:
{
    800029c0:	7179                	addi	sp,sp,-48
    800029c2:	f406                	sd	ra,40(sp)
    800029c4:	f022                	sd	s0,32(sp)
    800029c6:	ec26                	sd	s1,24(sp)
    800029c8:	e84a                	sd	s2,16(sp)
    800029ca:	e44e                	sd	s3,8(sp)
    800029cc:	e052                	sd	s4,0(sp)
    800029ce:	1800                	addi	s0,sp,48
    800029d0:	89aa                	mv	s3,a0
    800029d2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029d4:	00019517          	auipc	a0,0x19
    800029d8:	fa450513          	addi	a0,a0,-92 # 8001b978 <itable>
    800029dc:	00004097          	auipc	ra,0x4
    800029e0:	984080e7          	jalr	-1660(ra) # 80006360 <acquire>
  empty = 0;
    800029e4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029e6:	00019497          	auipc	s1,0x19
    800029ea:	faa48493          	addi	s1,s1,-86 # 8001b990 <itable+0x18>
    800029ee:	0001b697          	auipc	a3,0x1b
    800029f2:	a3268693          	addi	a3,a3,-1486 # 8001d420 <log>
    800029f6:	a039                	j	80002a04 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029f8:	02090b63          	beqz	s2,80002a2e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800029fc:	08848493          	addi	s1,s1,136
    80002a00:	02d48a63          	beq	s1,a3,80002a34 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a04:	449c                	lw	a5,8(s1)
    80002a06:	fef059e3          	blez	a5,800029f8 <iget+0x38>
    80002a0a:	4098                	lw	a4,0(s1)
    80002a0c:	ff3716e3          	bne	a4,s3,800029f8 <iget+0x38>
    80002a10:	40d8                	lw	a4,4(s1)
    80002a12:	ff4713e3          	bne	a4,s4,800029f8 <iget+0x38>
      ip->ref++;
    80002a16:	2785                	addiw	a5,a5,1
    80002a18:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a1a:	00019517          	auipc	a0,0x19
    80002a1e:	f5e50513          	addi	a0,a0,-162 # 8001b978 <itable>
    80002a22:	00004097          	auipc	ra,0x4
    80002a26:	9f2080e7          	jalr	-1550(ra) # 80006414 <release>
      return ip;
    80002a2a:	8926                	mv	s2,s1
    80002a2c:	a03d                	j	80002a5a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2e:	f7f9                	bnez	a5,800029fc <iget+0x3c>
    80002a30:	8926                	mv	s2,s1
    80002a32:	b7e9                	j	800029fc <iget+0x3c>
  if(empty == 0)
    80002a34:	02090c63          	beqz	s2,80002a6c <iget+0xac>
  ip->dev = dev;
    80002a38:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a3c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a40:	4785                	li	a5,1
    80002a42:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a46:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a4a:	00019517          	auipc	a0,0x19
    80002a4e:	f2e50513          	addi	a0,a0,-210 # 8001b978 <itable>
    80002a52:	00004097          	auipc	ra,0x4
    80002a56:	9c2080e7          	jalr	-1598(ra) # 80006414 <release>
}
    80002a5a:	854a                	mv	a0,s2
    80002a5c:	70a2                	ld	ra,40(sp)
    80002a5e:	7402                	ld	s0,32(sp)
    80002a60:	64e2                	ld	s1,24(sp)
    80002a62:	6942                	ld	s2,16(sp)
    80002a64:	69a2                	ld	s3,8(sp)
    80002a66:	6a02                	ld	s4,0(sp)
    80002a68:	6145                	addi	sp,sp,48
    80002a6a:	8082                	ret
    panic("iget: no inodes");
    80002a6c:	00006517          	auipc	a0,0x6
    80002a70:	a9c50513          	addi	a0,a0,-1380 # 80008508 <syscalls+0x140>
    80002a74:	00003097          	auipc	ra,0x3
    80002a78:	334080e7          	jalr	820(ra) # 80005da8 <panic>

0000000080002a7c <fsinit>:
fsinit(int dev) {
    80002a7c:	7179                	addi	sp,sp,-48
    80002a7e:	f406                	sd	ra,40(sp)
    80002a80:	f022                	sd	s0,32(sp)
    80002a82:	ec26                	sd	s1,24(sp)
    80002a84:	e84a                	sd	s2,16(sp)
    80002a86:	e44e                	sd	s3,8(sp)
    80002a88:	1800                	addi	s0,sp,48
    80002a8a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a8c:	4585                	li	a1,1
    80002a8e:	00000097          	auipc	ra,0x0
    80002a92:	a64080e7          	jalr	-1436(ra) # 800024f2 <bread>
    80002a96:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a98:	00019997          	auipc	s3,0x19
    80002a9c:	ec098993          	addi	s3,s3,-320 # 8001b958 <sb>
    80002aa0:	02000613          	li	a2,32
    80002aa4:	05850593          	addi	a1,a0,88
    80002aa8:	854e                	mv	a0,s3
    80002aaa:	ffffd097          	auipc	ra,0xffffd
    80002aae:	72e080e7          	jalr	1838(ra) # 800001d8 <memmove>
  brelse(bp);
    80002ab2:	8526                	mv	a0,s1
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	b6e080e7          	jalr	-1170(ra) # 80002622 <brelse>
  if(sb.magic != FSMAGIC)
    80002abc:	0009a703          	lw	a4,0(s3)
    80002ac0:	102037b7          	lui	a5,0x10203
    80002ac4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ac8:	02f71263          	bne	a4,a5,80002aec <fsinit+0x70>
  initlog(dev, &sb);
    80002acc:	00019597          	auipc	a1,0x19
    80002ad0:	e8c58593          	addi	a1,a1,-372 # 8001b958 <sb>
    80002ad4:	854a                	mv	a0,s2
    80002ad6:	00001097          	auipc	ra,0x1
    80002ada:	b4c080e7          	jalr	-1204(ra) # 80003622 <initlog>
}
    80002ade:	70a2                	ld	ra,40(sp)
    80002ae0:	7402                	ld	s0,32(sp)
    80002ae2:	64e2                	ld	s1,24(sp)
    80002ae4:	6942                	ld	s2,16(sp)
    80002ae6:	69a2                	ld	s3,8(sp)
    80002ae8:	6145                	addi	sp,sp,48
    80002aea:	8082                	ret
    panic("invalid file system");
    80002aec:	00006517          	auipc	a0,0x6
    80002af0:	a2c50513          	addi	a0,a0,-1492 # 80008518 <syscalls+0x150>
    80002af4:	00003097          	auipc	ra,0x3
    80002af8:	2b4080e7          	jalr	692(ra) # 80005da8 <panic>

0000000080002afc <iinit>:
{
    80002afc:	7179                	addi	sp,sp,-48
    80002afe:	f406                	sd	ra,40(sp)
    80002b00:	f022                	sd	s0,32(sp)
    80002b02:	ec26                	sd	s1,24(sp)
    80002b04:	e84a                	sd	s2,16(sp)
    80002b06:	e44e                	sd	s3,8(sp)
    80002b08:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b0a:	00006597          	auipc	a1,0x6
    80002b0e:	a2658593          	addi	a1,a1,-1498 # 80008530 <syscalls+0x168>
    80002b12:	00019517          	auipc	a0,0x19
    80002b16:	e6650513          	addi	a0,a0,-410 # 8001b978 <itable>
    80002b1a:	00003097          	auipc	ra,0x3
    80002b1e:	7b6080e7          	jalr	1974(ra) # 800062d0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b22:	00019497          	auipc	s1,0x19
    80002b26:	e7e48493          	addi	s1,s1,-386 # 8001b9a0 <itable+0x28>
    80002b2a:	0001b997          	auipc	s3,0x1b
    80002b2e:	90698993          	addi	s3,s3,-1786 # 8001d430 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b32:	00006917          	auipc	s2,0x6
    80002b36:	a0690913          	addi	s2,s2,-1530 # 80008538 <syscalls+0x170>
    80002b3a:	85ca                	mv	a1,s2
    80002b3c:	8526                	mv	a0,s1
    80002b3e:	00001097          	auipc	ra,0x1
    80002b42:	e46080e7          	jalr	-442(ra) # 80003984 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b46:	08848493          	addi	s1,s1,136
    80002b4a:	ff3498e3          	bne	s1,s3,80002b3a <iinit+0x3e>
}
    80002b4e:	70a2                	ld	ra,40(sp)
    80002b50:	7402                	ld	s0,32(sp)
    80002b52:	64e2                	ld	s1,24(sp)
    80002b54:	6942                	ld	s2,16(sp)
    80002b56:	69a2                	ld	s3,8(sp)
    80002b58:	6145                	addi	sp,sp,48
    80002b5a:	8082                	ret

0000000080002b5c <ialloc>:
{
    80002b5c:	715d                	addi	sp,sp,-80
    80002b5e:	e486                	sd	ra,72(sp)
    80002b60:	e0a2                	sd	s0,64(sp)
    80002b62:	fc26                	sd	s1,56(sp)
    80002b64:	f84a                	sd	s2,48(sp)
    80002b66:	f44e                	sd	s3,40(sp)
    80002b68:	f052                	sd	s4,32(sp)
    80002b6a:	ec56                	sd	s5,24(sp)
    80002b6c:	e85a                	sd	s6,16(sp)
    80002b6e:	e45e                	sd	s7,8(sp)
    80002b70:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b72:	00019717          	auipc	a4,0x19
    80002b76:	df272703          	lw	a4,-526(a4) # 8001b964 <sb+0xc>
    80002b7a:	4785                	li	a5,1
    80002b7c:	04e7fa63          	bgeu	a5,a4,80002bd0 <ialloc+0x74>
    80002b80:	8aaa                	mv	s5,a0
    80002b82:	8bae                	mv	s7,a1
    80002b84:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b86:	00019a17          	auipc	s4,0x19
    80002b8a:	dd2a0a13          	addi	s4,s4,-558 # 8001b958 <sb>
    80002b8e:	00048b1b          	sext.w	s6,s1
    80002b92:	0044d593          	srli	a1,s1,0x4
    80002b96:	018a2783          	lw	a5,24(s4)
    80002b9a:	9dbd                	addw	a1,a1,a5
    80002b9c:	8556                	mv	a0,s5
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	954080e7          	jalr	-1708(ra) # 800024f2 <bread>
    80002ba6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ba8:	05850993          	addi	s3,a0,88
    80002bac:	00f4f793          	andi	a5,s1,15
    80002bb0:	079a                	slli	a5,a5,0x6
    80002bb2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bb4:	00099783          	lh	a5,0(s3)
    80002bb8:	c785                	beqz	a5,80002be0 <ialloc+0x84>
    brelse(bp);
    80002bba:	00000097          	auipc	ra,0x0
    80002bbe:	a68080e7          	jalr	-1432(ra) # 80002622 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bc2:	0485                	addi	s1,s1,1
    80002bc4:	00ca2703          	lw	a4,12(s4)
    80002bc8:	0004879b          	sext.w	a5,s1
    80002bcc:	fce7e1e3          	bltu	a5,a4,80002b8e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002bd0:	00006517          	auipc	a0,0x6
    80002bd4:	97050513          	addi	a0,a0,-1680 # 80008540 <syscalls+0x178>
    80002bd8:	00003097          	auipc	ra,0x3
    80002bdc:	1d0080e7          	jalr	464(ra) # 80005da8 <panic>
      memset(dip, 0, sizeof(*dip));
    80002be0:	04000613          	li	a2,64
    80002be4:	4581                	li	a1,0
    80002be6:	854e                	mv	a0,s3
    80002be8:	ffffd097          	auipc	ra,0xffffd
    80002bec:	590080e7          	jalr	1424(ra) # 80000178 <memset>
      dip->type = type;
    80002bf0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bf4:	854a                	mv	a0,s2
    80002bf6:	00001097          	auipc	ra,0x1
    80002bfa:	ca8080e7          	jalr	-856(ra) # 8000389e <log_write>
      brelse(bp);
    80002bfe:	854a                	mv	a0,s2
    80002c00:	00000097          	auipc	ra,0x0
    80002c04:	a22080e7          	jalr	-1502(ra) # 80002622 <brelse>
      return iget(dev, inum);
    80002c08:	85da                	mv	a1,s6
    80002c0a:	8556                	mv	a0,s5
    80002c0c:	00000097          	auipc	ra,0x0
    80002c10:	db4080e7          	jalr	-588(ra) # 800029c0 <iget>
}
    80002c14:	60a6                	ld	ra,72(sp)
    80002c16:	6406                	ld	s0,64(sp)
    80002c18:	74e2                	ld	s1,56(sp)
    80002c1a:	7942                	ld	s2,48(sp)
    80002c1c:	79a2                	ld	s3,40(sp)
    80002c1e:	7a02                	ld	s4,32(sp)
    80002c20:	6ae2                	ld	s5,24(sp)
    80002c22:	6b42                	ld	s6,16(sp)
    80002c24:	6ba2                	ld	s7,8(sp)
    80002c26:	6161                	addi	sp,sp,80
    80002c28:	8082                	ret

0000000080002c2a <iupdate>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
    80002c36:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c38:	415c                	lw	a5,4(a0)
    80002c3a:	0047d79b          	srliw	a5,a5,0x4
    80002c3e:	00019597          	auipc	a1,0x19
    80002c42:	d325a583          	lw	a1,-718(a1) # 8001b970 <sb+0x18>
    80002c46:	9dbd                	addw	a1,a1,a5
    80002c48:	4108                	lw	a0,0(a0)
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	8a8080e7          	jalr	-1880(ra) # 800024f2 <bread>
    80002c52:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c54:	05850793          	addi	a5,a0,88
    80002c58:	40c8                	lw	a0,4(s1)
    80002c5a:	893d                	andi	a0,a0,15
    80002c5c:	051a                	slli	a0,a0,0x6
    80002c5e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002c60:	04449703          	lh	a4,68(s1)
    80002c64:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002c68:	04649703          	lh	a4,70(s1)
    80002c6c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002c70:	04849703          	lh	a4,72(s1)
    80002c74:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c78:	04a49703          	lh	a4,74(s1)
    80002c7c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c80:	44f8                	lw	a4,76(s1)
    80002c82:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c84:	03400613          	li	a2,52
    80002c88:	05048593          	addi	a1,s1,80
    80002c8c:	0531                	addi	a0,a0,12
    80002c8e:	ffffd097          	auipc	ra,0xffffd
    80002c92:	54a080e7          	jalr	1354(ra) # 800001d8 <memmove>
  log_write(bp);
    80002c96:	854a                	mv	a0,s2
    80002c98:	00001097          	auipc	ra,0x1
    80002c9c:	c06080e7          	jalr	-1018(ra) # 8000389e <log_write>
  brelse(bp);
    80002ca0:	854a                	mv	a0,s2
    80002ca2:	00000097          	auipc	ra,0x0
    80002ca6:	980080e7          	jalr	-1664(ra) # 80002622 <brelse>
}
    80002caa:	60e2                	ld	ra,24(sp)
    80002cac:	6442                	ld	s0,16(sp)
    80002cae:	64a2                	ld	s1,8(sp)
    80002cb0:	6902                	ld	s2,0(sp)
    80002cb2:	6105                	addi	sp,sp,32
    80002cb4:	8082                	ret

0000000080002cb6 <idup>:
{
    80002cb6:	1101                	addi	sp,sp,-32
    80002cb8:	ec06                	sd	ra,24(sp)
    80002cba:	e822                	sd	s0,16(sp)
    80002cbc:	e426                	sd	s1,8(sp)
    80002cbe:	1000                	addi	s0,sp,32
    80002cc0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cc2:	00019517          	auipc	a0,0x19
    80002cc6:	cb650513          	addi	a0,a0,-842 # 8001b978 <itable>
    80002cca:	00003097          	auipc	ra,0x3
    80002cce:	696080e7          	jalr	1686(ra) # 80006360 <acquire>
  ip->ref++;
    80002cd2:	449c                	lw	a5,8(s1)
    80002cd4:	2785                	addiw	a5,a5,1
    80002cd6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cd8:	00019517          	auipc	a0,0x19
    80002cdc:	ca050513          	addi	a0,a0,-864 # 8001b978 <itable>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	734080e7          	jalr	1844(ra) # 80006414 <release>
}
    80002ce8:	8526                	mv	a0,s1
    80002cea:	60e2                	ld	ra,24(sp)
    80002cec:	6442                	ld	s0,16(sp)
    80002cee:	64a2                	ld	s1,8(sp)
    80002cf0:	6105                	addi	sp,sp,32
    80002cf2:	8082                	ret

0000000080002cf4 <ilock>:
{
    80002cf4:	1101                	addi	sp,sp,-32
    80002cf6:	ec06                	sd	ra,24(sp)
    80002cf8:	e822                	sd	s0,16(sp)
    80002cfa:	e426                	sd	s1,8(sp)
    80002cfc:	e04a                	sd	s2,0(sp)
    80002cfe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d00:	c115                	beqz	a0,80002d24 <ilock+0x30>
    80002d02:	84aa                	mv	s1,a0
    80002d04:	451c                	lw	a5,8(a0)
    80002d06:	00f05f63          	blez	a5,80002d24 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d0a:	0541                	addi	a0,a0,16
    80002d0c:	00001097          	auipc	ra,0x1
    80002d10:	cb2080e7          	jalr	-846(ra) # 800039be <acquiresleep>
  if(ip->valid == 0){
    80002d14:	40bc                	lw	a5,64(s1)
    80002d16:	cf99                	beqz	a5,80002d34 <ilock+0x40>
}
    80002d18:	60e2                	ld	ra,24(sp)
    80002d1a:	6442                	ld	s0,16(sp)
    80002d1c:	64a2                	ld	s1,8(sp)
    80002d1e:	6902                	ld	s2,0(sp)
    80002d20:	6105                	addi	sp,sp,32
    80002d22:	8082                	ret
    panic("ilock");
    80002d24:	00006517          	auipc	a0,0x6
    80002d28:	83450513          	addi	a0,a0,-1996 # 80008558 <syscalls+0x190>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	07c080e7          	jalr	124(ra) # 80005da8 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d34:	40dc                	lw	a5,4(s1)
    80002d36:	0047d79b          	srliw	a5,a5,0x4
    80002d3a:	00019597          	auipc	a1,0x19
    80002d3e:	c365a583          	lw	a1,-970(a1) # 8001b970 <sb+0x18>
    80002d42:	9dbd                	addw	a1,a1,a5
    80002d44:	4088                	lw	a0,0(s1)
    80002d46:	fffff097          	auipc	ra,0xfffff
    80002d4a:	7ac080e7          	jalr	1964(ra) # 800024f2 <bread>
    80002d4e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d50:	05850593          	addi	a1,a0,88
    80002d54:	40dc                	lw	a5,4(s1)
    80002d56:	8bbd                	andi	a5,a5,15
    80002d58:	079a                	slli	a5,a5,0x6
    80002d5a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d5c:	00059783          	lh	a5,0(a1)
    80002d60:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d64:	00259783          	lh	a5,2(a1)
    80002d68:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d6c:	00459783          	lh	a5,4(a1)
    80002d70:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d74:	00659783          	lh	a5,6(a1)
    80002d78:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d7c:	459c                	lw	a5,8(a1)
    80002d7e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d80:	03400613          	li	a2,52
    80002d84:	05b1                	addi	a1,a1,12
    80002d86:	05048513          	addi	a0,s1,80
    80002d8a:	ffffd097          	auipc	ra,0xffffd
    80002d8e:	44e080e7          	jalr	1102(ra) # 800001d8 <memmove>
    brelse(bp);
    80002d92:	854a                	mv	a0,s2
    80002d94:	00000097          	auipc	ra,0x0
    80002d98:	88e080e7          	jalr	-1906(ra) # 80002622 <brelse>
    ip->valid = 1;
    80002d9c:	4785                	li	a5,1
    80002d9e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002da0:	04449783          	lh	a5,68(s1)
    80002da4:	fbb5                	bnez	a5,80002d18 <ilock+0x24>
      panic("ilock: no type");
    80002da6:	00005517          	auipc	a0,0x5
    80002daa:	7ba50513          	addi	a0,a0,1978 # 80008560 <syscalls+0x198>
    80002dae:	00003097          	auipc	ra,0x3
    80002db2:	ffa080e7          	jalr	-6(ra) # 80005da8 <panic>

0000000080002db6 <iunlock>:
{
    80002db6:	1101                	addi	sp,sp,-32
    80002db8:	ec06                	sd	ra,24(sp)
    80002dba:	e822                	sd	s0,16(sp)
    80002dbc:	e426                	sd	s1,8(sp)
    80002dbe:	e04a                	sd	s2,0(sp)
    80002dc0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dc2:	c905                	beqz	a0,80002df2 <iunlock+0x3c>
    80002dc4:	84aa                	mv	s1,a0
    80002dc6:	01050913          	addi	s2,a0,16
    80002dca:	854a                	mv	a0,s2
    80002dcc:	00001097          	auipc	ra,0x1
    80002dd0:	c8c080e7          	jalr	-884(ra) # 80003a58 <holdingsleep>
    80002dd4:	cd19                	beqz	a0,80002df2 <iunlock+0x3c>
    80002dd6:	449c                	lw	a5,8(s1)
    80002dd8:	00f05d63          	blez	a5,80002df2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002ddc:	854a                	mv	a0,s2
    80002dde:	00001097          	auipc	ra,0x1
    80002de2:	c36080e7          	jalr	-970(ra) # 80003a14 <releasesleep>
}
    80002de6:	60e2                	ld	ra,24(sp)
    80002de8:	6442                	ld	s0,16(sp)
    80002dea:	64a2                	ld	s1,8(sp)
    80002dec:	6902                	ld	s2,0(sp)
    80002dee:	6105                	addi	sp,sp,32
    80002df0:	8082                	ret
    panic("iunlock");
    80002df2:	00005517          	auipc	a0,0x5
    80002df6:	77e50513          	addi	a0,a0,1918 # 80008570 <syscalls+0x1a8>
    80002dfa:	00003097          	auipc	ra,0x3
    80002dfe:	fae080e7          	jalr	-82(ra) # 80005da8 <panic>

0000000080002e02 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e02:	7179                	addi	sp,sp,-48
    80002e04:	f406                	sd	ra,40(sp)
    80002e06:	f022                	sd	s0,32(sp)
    80002e08:	ec26                	sd	s1,24(sp)
    80002e0a:	e84a                	sd	s2,16(sp)
    80002e0c:	e44e                	sd	s3,8(sp)
    80002e0e:	e052                	sd	s4,0(sp)
    80002e10:	1800                	addi	s0,sp,48
    80002e12:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e14:	05050493          	addi	s1,a0,80
    80002e18:	08050913          	addi	s2,a0,128
    80002e1c:	a021                	j	80002e24 <itrunc+0x22>
    80002e1e:	0491                	addi	s1,s1,4
    80002e20:	01248d63          	beq	s1,s2,80002e3a <itrunc+0x38>
    if(ip->addrs[i]){
    80002e24:	408c                	lw	a1,0(s1)
    80002e26:	dde5                	beqz	a1,80002e1e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e28:	0009a503          	lw	a0,0(s3)
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	90c080e7          	jalr	-1780(ra) # 80002738 <bfree>
      ip->addrs[i] = 0;
    80002e34:	0004a023          	sw	zero,0(s1)
    80002e38:	b7dd                	j	80002e1e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e3a:	0809a583          	lw	a1,128(s3)
    80002e3e:	e185                	bnez	a1,80002e5e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e40:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e44:	854e                	mv	a0,s3
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	de4080e7          	jalr	-540(ra) # 80002c2a <iupdate>
}
    80002e4e:	70a2                	ld	ra,40(sp)
    80002e50:	7402                	ld	s0,32(sp)
    80002e52:	64e2                	ld	s1,24(sp)
    80002e54:	6942                	ld	s2,16(sp)
    80002e56:	69a2                	ld	s3,8(sp)
    80002e58:	6a02                	ld	s4,0(sp)
    80002e5a:	6145                	addi	sp,sp,48
    80002e5c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e5e:	0009a503          	lw	a0,0(s3)
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	690080e7          	jalr	1680(ra) # 800024f2 <bread>
    80002e6a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e6c:	05850493          	addi	s1,a0,88
    80002e70:	45850913          	addi	s2,a0,1112
    80002e74:	a811                	j	80002e88 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002e76:	0009a503          	lw	a0,0(s3)
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	8be080e7          	jalr	-1858(ra) # 80002738 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e82:	0491                	addi	s1,s1,4
    80002e84:	01248563          	beq	s1,s2,80002e8e <itrunc+0x8c>
      if(a[j])
    80002e88:	408c                	lw	a1,0(s1)
    80002e8a:	dde5                	beqz	a1,80002e82 <itrunc+0x80>
    80002e8c:	b7ed                	j	80002e76 <itrunc+0x74>
    brelse(bp);
    80002e8e:	8552                	mv	a0,s4
    80002e90:	fffff097          	auipc	ra,0xfffff
    80002e94:	792080e7          	jalr	1938(ra) # 80002622 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e98:	0809a583          	lw	a1,128(s3)
    80002e9c:	0009a503          	lw	a0,0(s3)
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	898080e7          	jalr	-1896(ra) # 80002738 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ea8:	0809a023          	sw	zero,128(s3)
    80002eac:	bf51                	j	80002e40 <itrunc+0x3e>

0000000080002eae <iput>:
{
    80002eae:	1101                	addi	sp,sp,-32
    80002eb0:	ec06                	sd	ra,24(sp)
    80002eb2:	e822                	sd	s0,16(sp)
    80002eb4:	e426                	sd	s1,8(sp)
    80002eb6:	e04a                	sd	s2,0(sp)
    80002eb8:	1000                	addi	s0,sp,32
    80002eba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ebc:	00019517          	auipc	a0,0x19
    80002ec0:	abc50513          	addi	a0,a0,-1348 # 8001b978 <itable>
    80002ec4:	00003097          	auipc	ra,0x3
    80002ec8:	49c080e7          	jalr	1180(ra) # 80006360 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ecc:	4498                	lw	a4,8(s1)
    80002ece:	4785                	li	a5,1
    80002ed0:	02f70363          	beq	a4,a5,80002ef6 <iput+0x48>
  ip->ref--;
    80002ed4:	449c                	lw	a5,8(s1)
    80002ed6:	37fd                	addiw	a5,a5,-1
    80002ed8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eda:	00019517          	auipc	a0,0x19
    80002ede:	a9e50513          	addi	a0,a0,-1378 # 8001b978 <itable>
    80002ee2:	00003097          	auipc	ra,0x3
    80002ee6:	532080e7          	jalr	1330(ra) # 80006414 <release>
}
    80002eea:	60e2                	ld	ra,24(sp)
    80002eec:	6442                	ld	s0,16(sp)
    80002eee:	64a2                	ld	s1,8(sp)
    80002ef0:	6902                	ld	s2,0(sp)
    80002ef2:	6105                	addi	sp,sp,32
    80002ef4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ef6:	40bc                	lw	a5,64(s1)
    80002ef8:	dff1                	beqz	a5,80002ed4 <iput+0x26>
    80002efa:	04a49783          	lh	a5,74(s1)
    80002efe:	fbf9                	bnez	a5,80002ed4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f00:	01048913          	addi	s2,s1,16
    80002f04:	854a                	mv	a0,s2
    80002f06:	00001097          	auipc	ra,0x1
    80002f0a:	ab8080e7          	jalr	-1352(ra) # 800039be <acquiresleep>
    release(&itable.lock);
    80002f0e:	00019517          	auipc	a0,0x19
    80002f12:	a6a50513          	addi	a0,a0,-1430 # 8001b978 <itable>
    80002f16:	00003097          	auipc	ra,0x3
    80002f1a:	4fe080e7          	jalr	1278(ra) # 80006414 <release>
    itrunc(ip);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	00000097          	auipc	ra,0x0
    80002f24:	ee2080e7          	jalr	-286(ra) # 80002e02 <itrunc>
    ip->type = 0;
    80002f28:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	00000097          	auipc	ra,0x0
    80002f32:	cfc080e7          	jalr	-772(ra) # 80002c2a <iupdate>
    ip->valid = 0;
    80002f36:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	00001097          	auipc	ra,0x1
    80002f40:	ad8080e7          	jalr	-1320(ra) # 80003a14 <releasesleep>
    acquire(&itable.lock);
    80002f44:	00019517          	auipc	a0,0x19
    80002f48:	a3450513          	addi	a0,a0,-1484 # 8001b978 <itable>
    80002f4c:	00003097          	auipc	ra,0x3
    80002f50:	414080e7          	jalr	1044(ra) # 80006360 <acquire>
    80002f54:	b741                	j	80002ed4 <iput+0x26>

0000000080002f56 <iunlockput>:
{
    80002f56:	1101                	addi	sp,sp,-32
    80002f58:	ec06                	sd	ra,24(sp)
    80002f5a:	e822                	sd	s0,16(sp)
    80002f5c:	e426                	sd	s1,8(sp)
    80002f5e:	1000                	addi	s0,sp,32
    80002f60:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f62:	00000097          	auipc	ra,0x0
    80002f66:	e54080e7          	jalr	-428(ra) # 80002db6 <iunlock>
  iput(ip);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	00000097          	auipc	ra,0x0
    80002f70:	f42080e7          	jalr	-190(ra) # 80002eae <iput>
}
    80002f74:	60e2                	ld	ra,24(sp)
    80002f76:	6442                	ld	s0,16(sp)
    80002f78:	64a2                	ld	s1,8(sp)
    80002f7a:	6105                	addi	sp,sp,32
    80002f7c:	8082                	ret

0000000080002f7e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f7e:	1141                	addi	sp,sp,-16
    80002f80:	e422                	sd	s0,8(sp)
    80002f82:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f84:	411c                	lw	a5,0(a0)
    80002f86:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f88:	415c                	lw	a5,4(a0)
    80002f8a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f8c:	04451783          	lh	a5,68(a0)
    80002f90:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f94:	04a51783          	lh	a5,74(a0)
    80002f98:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f9c:	04c56783          	lwu	a5,76(a0)
    80002fa0:	e99c                	sd	a5,16(a1)
}
    80002fa2:	6422                	ld	s0,8(sp)
    80002fa4:	0141                	addi	sp,sp,16
    80002fa6:	8082                	ret

0000000080002fa8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa8:	457c                	lw	a5,76(a0)
    80002faa:	0ed7e963          	bltu	a5,a3,8000309c <readi+0xf4>
{
    80002fae:	7159                	addi	sp,sp,-112
    80002fb0:	f486                	sd	ra,104(sp)
    80002fb2:	f0a2                	sd	s0,96(sp)
    80002fb4:	eca6                	sd	s1,88(sp)
    80002fb6:	e8ca                	sd	s2,80(sp)
    80002fb8:	e4ce                	sd	s3,72(sp)
    80002fba:	e0d2                	sd	s4,64(sp)
    80002fbc:	fc56                	sd	s5,56(sp)
    80002fbe:	f85a                	sd	s6,48(sp)
    80002fc0:	f45e                	sd	s7,40(sp)
    80002fc2:	f062                	sd	s8,32(sp)
    80002fc4:	ec66                	sd	s9,24(sp)
    80002fc6:	e86a                	sd	s10,16(sp)
    80002fc8:	e46e                	sd	s11,8(sp)
    80002fca:	1880                	addi	s0,sp,112
    80002fcc:	8baa                	mv	s7,a0
    80002fce:	8c2e                	mv	s8,a1
    80002fd0:	8ab2                	mv	s5,a2
    80002fd2:	84b6                	mv	s1,a3
    80002fd4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fd6:	9f35                	addw	a4,a4,a3
    return 0;
    80002fd8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002fda:	0ad76063          	bltu	a4,a3,8000307a <readi+0xd2>
  if(off + n > ip->size)
    80002fde:	00e7f463          	bgeu	a5,a4,80002fe6 <readi+0x3e>
    n = ip->size - off;
    80002fe2:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fe6:	0a0b0963          	beqz	s6,80003098 <readi+0xf0>
    80002fea:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fec:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ff0:	5cfd                	li	s9,-1
    80002ff2:	a82d                	j	8000302c <readi+0x84>
    80002ff4:	020a1d93          	slli	s11,s4,0x20
    80002ff8:	020ddd93          	srli	s11,s11,0x20
    80002ffc:	05890613          	addi	a2,s2,88
    80003000:	86ee                	mv	a3,s11
    80003002:	963a                	add	a2,a2,a4
    80003004:	85d6                	mv	a1,s5
    80003006:	8562                	mv	a0,s8
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	8b0080e7          	jalr	-1872(ra) # 800018b8 <either_copyout>
    80003010:	05950d63          	beq	a0,s9,8000306a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003014:	854a                	mv	a0,s2
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	60c080e7          	jalr	1548(ra) # 80002622 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000301e:	013a09bb          	addw	s3,s4,s3
    80003022:	009a04bb          	addw	s1,s4,s1
    80003026:	9aee                	add	s5,s5,s11
    80003028:	0569f763          	bgeu	s3,s6,80003076 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000302c:	000ba903          	lw	s2,0(s7)
    80003030:	00a4d59b          	srliw	a1,s1,0xa
    80003034:	855e                	mv	a0,s7
    80003036:	00000097          	auipc	ra,0x0
    8000303a:	8b0080e7          	jalr	-1872(ra) # 800028e6 <bmap>
    8000303e:	0005059b          	sext.w	a1,a0
    80003042:	854a                	mv	a0,s2
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	4ae080e7          	jalr	1198(ra) # 800024f2 <bread>
    8000304c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000304e:	3ff4f713          	andi	a4,s1,1023
    80003052:	40ed07bb          	subw	a5,s10,a4
    80003056:	413b06bb          	subw	a3,s6,s3
    8000305a:	8a3e                	mv	s4,a5
    8000305c:	2781                	sext.w	a5,a5
    8000305e:	0006861b          	sext.w	a2,a3
    80003062:	f8f679e3          	bgeu	a2,a5,80002ff4 <readi+0x4c>
    80003066:	8a36                	mv	s4,a3
    80003068:	b771                	j	80002ff4 <readi+0x4c>
      brelse(bp);
    8000306a:	854a                	mv	a0,s2
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	5b6080e7          	jalr	1462(ra) # 80002622 <brelse>
      tot = -1;
    80003074:	59fd                	li	s3,-1
  }
  return tot;
    80003076:	0009851b          	sext.w	a0,s3
}
    8000307a:	70a6                	ld	ra,104(sp)
    8000307c:	7406                	ld	s0,96(sp)
    8000307e:	64e6                	ld	s1,88(sp)
    80003080:	6946                	ld	s2,80(sp)
    80003082:	69a6                	ld	s3,72(sp)
    80003084:	6a06                	ld	s4,64(sp)
    80003086:	7ae2                	ld	s5,56(sp)
    80003088:	7b42                	ld	s6,48(sp)
    8000308a:	7ba2                	ld	s7,40(sp)
    8000308c:	7c02                	ld	s8,32(sp)
    8000308e:	6ce2                	ld	s9,24(sp)
    80003090:	6d42                	ld	s10,16(sp)
    80003092:	6da2                	ld	s11,8(sp)
    80003094:	6165                	addi	sp,sp,112
    80003096:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003098:	89da                	mv	s3,s6
    8000309a:	bff1                	j	80003076 <readi+0xce>
    return 0;
    8000309c:	4501                	li	a0,0
}
    8000309e:	8082                	ret

00000000800030a0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030a0:	457c                	lw	a5,76(a0)
    800030a2:	10d7e863          	bltu	a5,a3,800031b2 <writei+0x112>
{
    800030a6:	7159                	addi	sp,sp,-112
    800030a8:	f486                	sd	ra,104(sp)
    800030aa:	f0a2                	sd	s0,96(sp)
    800030ac:	eca6                	sd	s1,88(sp)
    800030ae:	e8ca                	sd	s2,80(sp)
    800030b0:	e4ce                	sd	s3,72(sp)
    800030b2:	e0d2                	sd	s4,64(sp)
    800030b4:	fc56                	sd	s5,56(sp)
    800030b6:	f85a                	sd	s6,48(sp)
    800030b8:	f45e                	sd	s7,40(sp)
    800030ba:	f062                	sd	s8,32(sp)
    800030bc:	ec66                	sd	s9,24(sp)
    800030be:	e86a                	sd	s10,16(sp)
    800030c0:	e46e                	sd	s11,8(sp)
    800030c2:	1880                	addi	s0,sp,112
    800030c4:	8b2a                	mv	s6,a0
    800030c6:	8c2e                	mv	s8,a1
    800030c8:	8ab2                	mv	s5,a2
    800030ca:	8936                	mv	s2,a3
    800030cc:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800030ce:	00e687bb          	addw	a5,a3,a4
    800030d2:	0ed7e263          	bltu	a5,a3,800031b6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800030d6:	00043737          	lui	a4,0x43
    800030da:	0ef76063          	bltu	a4,a5,800031ba <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030de:	0c0b8863          	beqz	s7,800031ae <writei+0x10e>
    800030e2:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030e4:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800030e8:	5cfd                	li	s9,-1
    800030ea:	a091                	j	8000312e <writei+0x8e>
    800030ec:	02099d93          	slli	s11,s3,0x20
    800030f0:	020ddd93          	srli	s11,s11,0x20
    800030f4:	05848513          	addi	a0,s1,88
    800030f8:	86ee                	mv	a3,s11
    800030fa:	8656                	mv	a2,s5
    800030fc:	85e2                	mv	a1,s8
    800030fe:	953a                	add	a0,a0,a4
    80003100:	fffff097          	auipc	ra,0xfffff
    80003104:	80e080e7          	jalr	-2034(ra) # 8000190e <either_copyin>
    80003108:	07950263          	beq	a0,s9,8000316c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000310c:	8526                	mv	a0,s1
    8000310e:	00000097          	auipc	ra,0x0
    80003112:	790080e7          	jalr	1936(ra) # 8000389e <log_write>
    brelse(bp);
    80003116:	8526                	mv	a0,s1
    80003118:	fffff097          	auipc	ra,0xfffff
    8000311c:	50a080e7          	jalr	1290(ra) # 80002622 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003120:	01498a3b          	addw	s4,s3,s4
    80003124:	0129893b          	addw	s2,s3,s2
    80003128:	9aee                	add	s5,s5,s11
    8000312a:	057a7663          	bgeu	s4,s7,80003176 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000312e:	000b2483          	lw	s1,0(s6)
    80003132:	00a9559b          	srliw	a1,s2,0xa
    80003136:	855a                	mv	a0,s6
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	7ae080e7          	jalr	1966(ra) # 800028e6 <bmap>
    80003140:	0005059b          	sext.w	a1,a0
    80003144:	8526                	mv	a0,s1
    80003146:	fffff097          	auipc	ra,0xfffff
    8000314a:	3ac080e7          	jalr	940(ra) # 800024f2 <bread>
    8000314e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003150:	3ff97713          	andi	a4,s2,1023
    80003154:	40ed07bb          	subw	a5,s10,a4
    80003158:	414b86bb          	subw	a3,s7,s4
    8000315c:	89be                	mv	s3,a5
    8000315e:	2781                	sext.w	a5,a5
    80003160:	0006861b          	sext.w	a2,a3
    80003164:	f8f674e3          	bgeu	a2,a5,800030ec <writei+0x4c>
    80003168:	89b6                	mv	s3,a3
    8000316a:	b749                	j	800030ec <writei+0x4c>
      brelse(bp);
    8000316c:	8526                	mv	a0,s1
    8000316e:	fffff097          	auipc	ra,0xfffff
    80003172:	4b4080e7          	jalr	1204(ra) # 80002622 <brelse>
  }

  if(off > ip->size)
    80003176:	04cb2783          	lw	a5,76(s6)
    8000317a:	0127f463          	bgeu	a5,s2,80003182 <writei+0xe2>
    ip->size = off;
    8000317e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003182:	855a                	mv	a0,s6
    80003184:	00000097          	auipc	ra,0x0
    80003188:	aa6080e7          	jalr	-1370(ra) # 80002c2a <iupdate>

  return tot;
    8000318c:	000a051b          	sext.w	a0,s4
}
    80003190:	70a6                	ld	ra,104(sp)
    80003192:	7406                	ld	s0,96(sp)
    80003194:	64e6                	ld	s1,88(sp)
    80003196:	6946                	ld	s2,80(sp)
    80003198:	69a6                	ld	s3,72(sp)
    8000319a:	6a06                	ld	s4,64(sp)
    8000319c:	7ae2                	ld	s5,56(sp)
    8000319e:	7b42                	ld	s6,48(sp)
    800031a0:	7ba2                	ld	s7,40(sp)
    800031a2:	7c02                	ld	s8,32(sp)
    800031a4:	6ce2                	ld	s9,24(sp)
    800031a6:	6d42                	ld	s10,16(sp)
    800031a8:	6da2                	ld	s11,8(sp)
    800031aa:	6165                	addi	sp,sp,112
    800031ac:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ae:	8a5e                	mv	s4,s7
    800031b0:	bfc9                	j	80003182 <writei+0xe2>
    return -1;
    800031b2:	557d                	li	a0,-1
}
    800031b4:	8082                	ret
    return -1;
    800031b6:	557d                	li	a0,-1
    800031b8:	bfe1                	j	80003190 <writei+0xf0>
    return -1;
    800031ba:	557d                	li	a0,-1
    800031bc:	bfd1                	j	80003190 <writei+0xf0>

00000000800031be <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031be:	1141                	addi	sp,sp,-16
    800031c0:	e406                	sd	ra,8(sp)
    800031c2:	e022                	sd	s0,0(sp)
    800031c4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031c6:	4639                	li	a2,14
    800031c8:	ffffd097          	auipc	ra,0xffffd
    800031cc:	088080e7          	jalr	136(ra) # 80000250 <strncmp>
}
    800031d0:	60a2                	ld	ra,8(sp)
    800031d2:	6402                	ld	s0,0(sp)
    800031d4:	0141                	addi	sp,sp,16
    800031d6:	8082                	ret

00000000800031d8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031d8:	7139                	addi	sp,sp,-64
    800031da:	fc06                	sd	ra,56(sp)
    800031dc:	f822                	sd	s0,48(sp)
    800031de:	f426                	sd	s1,40(sp)
    800031e0:	f04a                	sd	s2,32(sp)
    800031e2:	ec4e                	sd	s3,24(sp)
    800031e4:	e852                	sd	s4,16(sp)
    800031e6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800031e8:	04451703          	lh	a4,68(a0)
    800031ec:	4785                	li	a5,1
    800031ee:	00f71a63          	bne	a4,a5,80003202 <dirlookup+0x2a>
    800031f2:	892a                	mv	s2,a0
    800031f4:	89ae                	mv	s3,a1
    800031f6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800031f8:	457c                	lw	a5,76(a0)
    800031fa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800031fc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031fe:	e79d                	bnez	a5,8000322c <dirlookup+0x54>
    80003200:	a8a5                	j	80003278 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003202:	00005517          	auipc	a0,0x5
    80003206:	37650513          	addi	a0,a0,886 # 80008578 <syscalls+0x1b0>
    8000320a:	00003097          	auipc	ra,0x3
    8000320e:	b9e080e7          	jalr	-1122(ra) # 80005da8 <panic>
      panic("dirlookup read");
    80003212:	00005517          	auipc	a0,0x5
    80003216:	37e50513          	addi	a0,a0,894 # 80008590 <syscalls+0x1c8>
    8000321a:	00003097          	auipc	ra,0x3
    8000321e:	b8e080e7          	jalr	-1138(ra) # 80005da8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003222:	24c1                	addiw	s1,s1,16
    80003224:	04c92783          	lw	a5,76(s2)
    80003228:	04f4f763          	bgeu	s1,a5,80003276 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000322c:	4741                	li	a4,16
    8000322e:	86a6                	mv	a3,s1
    80003230:	fc040613          	addi	a2,s0,-64
    80003234:	4581                	li	a1,0
    80003236:	854a                	mv	a0,s2
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	d70080e7          	jalr	-656(ra) # 80002fa8 <readi>
    80003240:	47c1                	li	a5,16
    80003242:	fcf518e3          	bne	a0,a5,80003212 <dirlookup+0x3a>
    if(de.inum == 0)
    80003246:	fc045783          	lhu	a5,-64(s0)
    8000324a:	dfe1                	beqz	a5,80003222 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000324c:	fc240593          	addi	a1,s0,-62
    80003250:	854e                	mv	a0,s3
    80003252:	00000097          	auipc	ra,0x0
    80003256:	f6c080e7          	jalr	-148(ra) # 800031be <namecmp>
    8000325a:	f561                	bnez	a0,80003222 <dirlookup+0x4a>
      if(poff)
    8000325c:	000a0463          	beqz	s4,80003264 <dirlookup+0x8c>
        *poff = off;
    80003260:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003264:	fc045583          	lhu	a1,-64(s0)
    80003268:	00092503          	lw	a0,0(s2)
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	754080e7          	jalr	1876(ra) # 800029c0 <iget>
    80003274:	a011                	j	80003278 <dirlookup+0xa0>
  return 0;
    80003276:	4501                	li	a0,0
}
    80003278:	70e2                	ld	ra,56(sp)
    8000327a:	7442                	ld	s0,48(sp)
    8000327c:	74a2                	ld	s1,40(sp)
    8000327e:	7902                	ld	s2,32(sp)
    80003280:	69e2                	ld	s3,24(sp)
    80003282:	6a42                	ld	s4,16(sp)
    80003284:	6121                	addi	sp,sp,64
    80003286:	8082                	ret

0000000080003288 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003288:	711d                	addi	sp,sp,-96
    8000328a:	ec86                	sd	ra,88(sp)
    8000328c:	e8a2                	sd	s0,80(sp)
    8000328e:	e4a6                	sd	s1,72(sp)
    80003290:	e0ca                	sd	s2,64(sp)
    80003292:	fc4e                	sd	s3,56(sp)
    80003294:	f852                	sd	s4,48(sp)
    80003296:	f456                	sd	s5,40(sp)
    80003298:	f05a                	sd	s6,32(sp)
    8000329a:	ec5e                	sd	s7,24(sp)
    8000329c:	e862                	sd	s8,16(sp)
    8000329e:	e466                	sd	s9,8(sp)
    800032a0:	1080                	addi	s0,sp,96
    800032a2:	84aa                	mv	s1,a0
    800032a4:	8b2e                	mv	s6,a1
    800032a6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032a8:	00054703          	lbu	a4,0(a0)
    800032ac:	02f00793          	li	a5,47
    800032b0:	02f70363          	beq	a4,a5,800032d6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032b4:	ffffe097          	auipc	ra,0xffffe
    800032b8:	b94080e7          	jalr	-1132(ra) # 80000e48 <myproc>
    800032bc:	16053503          	ld	a0,352(a0)
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	9f6080e7          	jalr	-1546(ra) # 80002cb6 <idup>
    800032c8:	89aa                	mv	s3,a0
  while(*path == '/')
    800032ca:	02f00913          	li	s2,47
  len = path - s;
    800032ce:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800032d0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032d2:	4c05                	li	s8,1
    800032d4:	a865                	j	8000338c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800032d6:	4585                	li	a1,1
    800032d8:	4505                	li	a0,1
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	6e6080e7          	jalr	1766(ra) # 800029c0 <iget>
    800032e2:	89aa                	mv	s3,a0
    800032e4:	b7dd                	j	800032ca <namex+0x42>
      iunlockput(ip);
    800032e6:	854e                	mv	a0,s3
    800032e8:	00000097          	auipc	ra,0x0
    800032ec:	c6e080e7          	jalr	-914(ra) # 80002f56 <iunlockput>
      return 0;
    800032f0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032f2:	854e                	mv	a0,s3
    800032f4:	60e6                	ld	ra,88(sp)
    800032f6:	6446                	ld	s0,80(sp)
    800032f8:	64a6                	ld	s1,72(sp)
    800032fa:	6906                	ld	s2,64(sp)
    800032fc:	79e2                	ld	s3,56(sp)
    800032fe:	7a42                	ld	s4,48(sp)
    80003300:	7aa2                	ld	s5,40(sp)
    80003302:	7b02                	ld	s6,32(sp)
    80003304:	6be2                	ld	s7,24(sp)
    80003306:	6c42                	ld	s8,16(sp)
    80003308:	6ca2                	ld	s9,8(sp)
    8000330a:	6125                	addi	sp,sp,96
    8000330c:	8082                	ret
      iunlock(ip);
    8000330e:	854e                	mv	a0,s3
    80003310:	00000097          	auipc	ra,0x0
    80003314:	aa6080e7          	jalr	-1370(ra) # 80002db6 <iunlock>
      return ip;
    80003318:	bfe9                	j	800032f2 <namex+0x6a>
      iunlockput(ip);
    8000331a:	854e                	mv	a0,s3
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	c3a080e7          	jalr	-966(ra) # 80002f56 <iunlockput>
      return 0;
    80003324:	89d2                	mv	s3,s4
    80003326:	b7f1                	j	800032f2 <namex+0x6a>
  len = path - s;
    80003328:	40b48633          	sub	a2,s1,a1
    8000332c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003330:	094cd463          	bge	s9,s4,800033b8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003334:	4639                	li	a2,14
    80003336:	8556                	mv	a0,s5
    80003338:	ffffd097          	auipc	ra,0xffffd
    8000333c:	ea0080e7          	jalr	-352(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003340:	0004c783          	lbu	a5,0(s1)
    80003344:	01279763          	bne	a5,s2,80003352 <namex+0xca>
    path++;
    80003348:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000334a:	0004c783          	lbu	a5,0(s1)
    8000334e:	ff278de3          	beq	a5,s2,80003348 <namex+0xc0>
    ilock(ip);
    80003352:	854e                	mv	a0,s3
    80003354:	00000097          	auipc	ra,0x0
    80003358:	9a0080e7          	jalr	-1632(ra) # 80002cf4 <ilock>
    if(ip->type != T_DIR){
    8000335c:	04499783          	lh	a5,68(s3)
    80003360:	f98793e3          	bne	a5,s8,800032e6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003364:	000b0563          	beqz	s6,8000336e <namex+0xe6>
    80003368:	0004c783          	lbu	a5,0(s1)
    8000336c:	d3cd                	beqz	a5,8000330e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000336e:	865e                	mv	a2,s7
    80003370:	85d6                	mv	a1,s5
    80003372:	854e                	mv	a0,s3
    80003374:	00000097          	auipc	ra,0x0
    80003378:	e64080e7          	jalr	-412(ra) # 800031d8 <dirlookup>
    8000337c:	8a2a                	mv	s4,a0
    8000337e:	dd51                	beqz	a0,8000331a <namex+0x92>
    iunlockput(ip);
    80003380:	854e                	mv	a0,s3
    80003382:	00000097          	auipc	ra,0x0
    80003386:	bd4080e7          	jalr	-1068(ra) # 80002f56 <iunlockput>
    ip = next;
    8000338a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000338c:	0004c783          	lbu	a5,0(s1)
    80003390:	05279763          	bne	a5,s2,800033de <namex+0x156>
    path++;
    80003394:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003396:	0004c783          	lbu	a5,0(s1)
    8000339a:	ff278de3          	beq	a5,s2,80003394 <namex+0x10c>
  if(*path == 0)
    8000339e:	c79d                	beqz	a5,800033cc <namex+0x144>
    path++;
    800033a0:	85a6                	mv	a1,s1
  len = path - s;
    800033a2:	8a5e                	mv	s4,s7
    800033a4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033a6:	01278963          	beq	a5,s2,800033b8 <namex+0x130>
    800033aa:	dfbd                	beqz	a5,80003328 <namex+0xa0>
    path++;
    800033ac:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	ff279ce3          	bne	a5,s2,800033aa <namex+0x122>
    800033b6:	bf8d                	j	80003328 <namex+0xa0>
    memmove(name, s, len);
    800033b8:	2601                	sext.w	a2,a2
    800033ba:	8556                	mv	a0,s5
    800033bc:	ffffd097          	auipc	ra,0xffffd
    800033c0:	e1c080e7          	jalr	-484(ra) # 800001d8 <memmove>
    name[len] = 0;
    800033c4:	9a56                	add	s4,s4,s5
    800033c6:	000a0023          	sb	zero,0(s4)
    800033ca:	bf9d                	j	80003340 <namex+0xb8>
  if(nameiparent){
    800033cc:	f20b03e3          	beqz	s6,800032f2 <namex+0x6a>
    iput(ip);
    800033d0:	854e                	mv	a0,s3
    800033d2:	00000097          	auipc	ra,0x0
    800033d6:	adc080e7          	jalr	-1316(ra) # 80002eae <iput>
    return 0;
    800033da:	4981                	li	s3,0
    800033dc:	bf19                	j	800032f2 <namex+0x6a>
  if(*path == 0)
    800033de:	d7fd                	beqz	a5,800033cc <namex+0x144>
  while(*path != '/' && *path != 0)
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	85a6                	mv	a1,s1
    800033e6:	b7d1                	j	800033aa <namex+0x122>

00000000800033e8 <dirlink>:
{
    800033e8:	7139                	addi	sp,sp,-64
    800033ea:	fc06                	sd	ra,56(sp)
    800033ec:	f822                	sd	s0,48(sp)
    800033ee:	f426                	sd	s1,40(sp)
    800033f0:	f04a                	sd	s2,32(sp)
    800033f2:	ec4e                	sd	s3,24(sp)
    800033f4:	e852                	sd	s4,16(sp)
    800033f6:	0080                	addi	s0,sp,64
    800033f8:	892a                	mv	s2,a0
    800033fa:	8a2e                	mv	s4,a1
    800033fc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033fe:	4601                	li	a2,0
    80003400:	00000097          	auipc	ra,0x0
    80003404:	dd8080e7          	jalr	-552(ra) # 800031d8 <dirlookup>
    80003408:	e93d                	bnez	a0,8000347e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000340a:	04c92483          	lw	s1,76(s2)
    8000340e:	c49d                	beqz	s1,8000343c <dirlink+0x54>
    80003410:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003412:	4741                	li	a4,16
    80003414:	86a6                	mv	a3,s1
    80003416:	fc040613          	addi	a2,s0,-64
    8000341a:	4581                	li	a1,0
    8000341c:	854a                	mv	a0,s2
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	b8a080e7          	jalr	-1142(ra) # 80002fa8 <readi>
    80003426:	47c1                	li	a5,16
    80003428:	06f51163          	bne	a0,a5,8000348a <dirlink+0xa2>
    if(de.inum == 0)
    8000342c:	fc045783          	lhu	a5,-64(s0)
    80003430:	c791                	beqz	a5,8000343c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003432:	24c1                	addiw	s1,s1,16
    80003434:	04c92783          	lw	a5,76(s2)
    80003438:	fcf4ede3          	bltu	s1,a5,80003412 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000343c:	4639                	li	a2,14
    8000343e:	85d2                	mv	a1,s4
    80003440:	fc240513          	addi	a0,s0,-62
    80003444:	ffffd097          	auipc	ra,0xffffd
    80003448:	e48080e7          	jalr	-440(ra) # 8000028c <strncpy>
  de.inum = inum;
    8000344c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	4741                	li	a4,16
    80003452:	86a6                	mv	a3,s1
    80003454:	fc040613          	addi	a2,s0,-64
    80003458:	4581                	li	a1,0
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	c44080e7          	jalr	-956(ra) # 800030a0 <writei>
    80003464:	872a                	mv	a4,a0
    80003466:	47c1                	li	a5,16
  return 0;
    80003468:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000346a:	02f71863          	bne	a4,a5,8000349a <dirlink+0xb2>
}
    8000346e:	70e2                	ld	ra,56(sp)
    80003470:	7442                	ld	s0,48(sp)
    80003472:	74a2                	ld	s1,40(sp)
    80003474:	7902                	ld	s2,32(sp)
    80003476:	69e2                	ld	s3,24(sp)
    80003478:	6a42                	ld	s4,16(sp)
    8000347a:	6121                	addi	sp,sp,64
    8000347c:	8082                	ret
    iput(ip);
    8000347e:	00000097          	auipc	ra,0x0
    80003482:	a30080e7          	jalr	-1488(ra) # 80002eae <iput>
    return -1;
    80003486:	557d                	li	a0,-1
    80003488:	b7dd                	j	8000346e <dirlink+0x86>
      panic("dirlink read");
    8000348a:	00005517          	auipc	a0,0x5
    8000348e:	11650513          	addi	a0,a0,278 # 800085a0 <syscalls+0x1d8>
    80003492:	00003097          	auipc	ra,0x3
    80003496:	916080e7          	jalr	-1770(ra) # 80005da8 <panic>
    panic("dirlink");
    8000349a:	00005517          	auipc	a0,0x5
    8000349e:	21650513          	addi	a0,a0,534 # 800086b0 <syscalls+0x2e8>
    800034a2:	00003097          	auipc	ra,0x3
    800034a6:	906080e7          	jalr	-1786(ra) # 80005da8 <panic>

00000000800034aa <namei>:

struct inode*
namei(char *path)
{
    800034aa:	1101                	addi	sp,sp,-32
    800034ac:	ec06                	sd	ra,24(sp)
    800034ae:	e822                	sd	s0,16(sp)
    800034b0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034b2:	fe040613          	addi	a2,s0,-32
    800034b6:	4581                	li	a1,0
    800034b8:	00000097          	auipc	ra,0x0
    800034bc:	dd0080e7          	jalr	-560(ra) # 80003288 <namex>
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	6105                	addi	sp,sp,32
    800034c6:	8082                	ret

00000000800034c8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034c8:	1141                	addi	sp,sp,-16
    800034ca:	e406                	sd	ra,8(sp)
    800034cc:	e022                	sd	s0,0(sp)
    800034ce:	0800                	addi	s0,sp,16
    800034d0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034d2:	4585                	li	a1,1
    800034d4:	00000097          	auipc	ra,0x0
    800034d8:	db4080e7          	jalr	-588(ra) # 80003288 <namex>
}
    800034dc:	60a2                	ld	ra,8(sp)
    800034de:	6402                	ld	s0,0(sp)
    800034e0:	0141                	addi	sp,sp,16
    800034e2:	8082                	ret

00000000800034e4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034e4:	1101                	addi	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	e04a                	sd	s2,0(sp)
    800034ee:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034f0:	0001a917          	auipc	s2,0x1a
    800034f4:	f3090913          	addi	s2,s2,-208 # 8001d420 <log>
    800034f8:	01892583          	lw	a1,24(s2)
    800034fc:	02892503          	lw	a0,40(s2)
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	ff2080e7          	jalr	-14(ra) # 800024f2 <bread>
    80003508:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000350a:	02c92683          	lw	a3,44(s2)
    8000350e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003510:	02d05763          	blez	a3,8000353e <write_head+0x5a>
    80003514:	0001a797          	auipc	a5,0x1a
    80003518:	f3c78793          	addi	a5,a5,-196 # 8001d450 <log+0x30>
    8000351c:	05c50713          	addi	a4,a0,92
    80003520:	36fd                	addiw	a3,a3,-1
    80003522:	1682                	slli	a3,a3,0x20
    80003524:	9281                	srli	a3,a3,0x20
    80003526:	068a                	slli	a3,a3,0x2
    80003528:	0001a617          	auipc	a2,0x1a
    8000352c:	f2c60613          	addi	a2,a2,-212 # 8001d454 <log+0x34>
    80003530:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003532:	4390                	lw	a2,0(a5)
    80003534:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003536:	0791                	addi	a5,a5,4
    80003538:	0711                	addi	a4,a4,4
    8000353a:	fed79ce3          	bne	a5,a3,80003532 <write_head+0x4e>
  }
  bwrite(buf);
    8000353e:	8526                	mv	a0,s1
    80003540:	fffff097          	auipc	ra,0xfffff
    80003544:	0a4080e7          	jalr	164(ra) # 800025e4 <bwrite>
  brelse(buf);
    80003548:	8526                	mv	a0,s1
    8000354a:	fffff097          	auipc	ra,0xfffff
    8000354e:	0d8080e7          	jalr	216(ra) # 80002622 <brelse>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6902                	ld	s2,0(sp)
    8000355a:	6105                	addi	sp,sp,32
    8000355c:	8082                	ret

000000008000355e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000355e:	0001a797          	auipc	a5,0x1a
    80003562:	eee7a783          	lw	a5,-274(a5) # 8001d44c <log+0x2c>
    80003566:	0af05d63          	blez	a5,80003620 <install_trans+0xc2>
{
    8000356a:	7139                	addi	sp,sp,-64
    8000356c:	fc06                	sd	ra,56(sp)
    8000356e:	f822                	sd	s0,48(sp)
    80003570:	f426                	sd	s1,40(sp)
    80003572:	f04a                	sd	s2,32(sp)
    80003574:	ec4e                	sd	s3,24(sp)
    80003576:	e852                	sd	s4,16(sp)
    80003578:	e456                	sd	s5,8(sp)
    8000357a:	e05a                	sd	s6,0(sp)
    8000357c:	0080                	addi	s0,sp,64
    8000357e:	8b2a                	mv	s6,a0
    80003580:	0001aa97          	auipc	s5,0x1a
    80003584:	ed0a8a93          	addi	s5,s5,-304 # 8001d450 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003588:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000358a:	0001a997          	auipc	s3,0x1a
    8000358e:	e9698993          	addi	s3,s3,-362 # 8001d420 <log>
    80003592:	a035                	j	800035be <install_trans+0x60>
      bunpin(dbuf);
    80003594:	8526                	mv	a0,s1
    80003596:	fffff097          	auipc	ra,0xfffff
    8000359a:	166080e7          	jalr	358(ra) # 800026fc <bunpin>
    brelse(lbuf);
    8000359e:	854a                	mv	a0,s2
    800035a0:	fffff097          	auipc	ra,0xfffff
    800035a4:	082080e7          	jalr	130(ra) # 80002622 <brelse>
    brelse(dbuf);
    800035a8:	8526                	mv	a0,s1
    800035aa:	fffff097          	auipc	ra,0xfffff
    800035ae:	078080e7          	jalr	120(ra) # 80002622 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b2:	2a05                	addiw	s4,s4,1
    800035b4:	0a91                	addi	s5,s5,4
    800035b6:	02c9a783          	lw	a5,44(s3)
    800035ba:	04fa5963          	bge	s4,a5,8000360c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035be:	0189a583          	lw	a1,24(s3)
    800035c2:	014585bb          	addw	a1,a1,s4
    800035c6:	2585                	addiw	a1,a1,1
    800035c8:	0289a503          	lw	a0,40(s3)
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	f26080e7          	jalr	-218(ra) # 800024f2 <bread>
    800035d4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035d6:	000aa583          	lw	a1,0(s5)
    800035da:	0289a503          	lw	a0,40(s3)
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	f14080e7          	jalr	-236(ra) # 800024f2 <bread>
    800035e6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035e8:	40000613          	li	a2,1024
    800035ec:	05890593          	addi	a1,s2,88
    800035f0:	05850513          	addi	a0,a0,88
    800035f4:	ffffd097          	auipc	ra,0xffffd
    800035f8:	be4080e7          	jalr	-1052(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800035fc:	8526                	mv	a0,s1
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	fe6080e7          	jalr	-26(ra) # 800025e4 <bwrite>
    if(recovering == 0)
    80003606:	f80b1ce3          	bnez	s6,8000359e <install_trans+0x40>
    8000360a:	b769                	j	80003594 <install_trans+0x36>
}
    8000360c:	70e2                	ld	ra,56(sp)
    8000360e:	7442                	ld	s0,48(sp)
    80003610:	74a2                	ld	s1,40(sp)
    80003612:	7902                	ld	s2,32(sp)
    80003614:	69e2                	ld	s3,24(sp)
    80003616:	6a42                	ld	s4,16(sp)
    80003618:	6aa2                	ld	s5,8(sp)
    8000361a:	6b02                	ld	s6,0(sp)
    8000361c:	6121                	addi	sp,sp,64
    8000361e:	8082                	ret
    80003620:	8082                	ret

0000000080003622 <initlog>:
{
    80003622:	7179                	addi	sp,sp,-48
    80003624:	f406                	sd	ra,40(sp)
    80003626:	f022                	sd	s0,32(sp)
    80003628:	ec26                	sd	s1,24(sp)
    8000362a:	e84a                	sd	s2,16(sp)
    8000362c:	e44e                	sd	s3,8(sp)
    8000362e:	1800                	addi	s0,sp,48
    80003630:	892a                	mv	s2,a0
    80003632:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003634:	0001a497          	auipc	s1,0x1a
    80003638:	dec48493          	addi	s1,s1,-532 # 8001d420 <log>
    8000363c:	00005597          	auipc	a1,0x5
    80003640:	f7458593          	addi	a1,a1,-140 # 800085b0 <syscalls+0x1e8>
    80003644:	8526                	mv	a0,s1
    80003646:	00003097          	auipc	ra,0x3
    8000364a:	c8a080e7          	jalr	-886(ra) # 800062d0 <initlock>
  log.start = sb->logstart;
    8000364e:	0149a583          	lw	a1,20(s3)
    80003652:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003654:	0109a783          	lw	a5,16(s3)
    80003658:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000365a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000365e:	854a                	mv	a0,s2
    80003660:	fffff097          	auipc	ra,0xfffff
    80003664:	e92080e7          	jalr	-366(ra) # 800024f2 <bread>
  log.lh.n = lh->n;
    80003668:	4d3c                	lw	a5,88(a0)
    8000366a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000366c:	02f05563          	blez	a5,80003696 <initlog+0x74>
    80003670:	05c50713          	addi	a4,a0,92
    80003674:	0001a697          	auipc	a3,0x1a
    80003678:	ddc68693          	addi	a3,a3,-548 # 8001d450 <log+0x30>
    8000367c:	37fd                	addiw	a5,a5,-1
    8000367e:	1782                	slli	a5,a5,0x20
    80003680:	9381                	srli	a5,a5,0x20
    80003682:	078a                	slli	a5,a5,0x2
    80003684:	06050613          	addi	a2,a0,96
    80003688:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000368a:	4310                	lw	a2,0(a4)
    8000368c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000368e:	0711                	addi	a4,a4,4
    80003690:	0691                	addi	a3,a3,4
    80003692:	fef71ce3          	bne	a4,a5,8000368a <initlog+0x68>
  brelse(buf);
    80003696:	fffff097          	auipc	ra,0xfffff
    8000369a:	f8c080e7          	jalr	-116(ra) # 80002622 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000369e:	4505                	li	a0,1
    800036a0:	00000097          	auipc	ra,0x0
    800036a4:	ebe080e7          	jalr	-322(ra) # 8000355e <install_trans>
  log.lh.n = 0;
    800036a8:	0001a797          	auipc	a5,0x1a
    800036ac:	da07a223          	sw	zero,-604(a5) # 8001d44c <log+0x2c>
  write_head(); // clear the log
    800036b0:	00000097          	auipc	ra,0x0
    800036b4:	e34080e7          	jalr	-460(ra) # 800034e4 <write_head>
}
    800036b8:	70a2                	ld	ra,40(sp)
    800036ba:	7402                	ld	s0,32(sp)
    800036bc:	64e2                	ld	s1,24(sp)
    800036be:	6942                	ld	s2,16(sp)
    800036c0:	69a2                	ld	s3,8(sp)
    800036c2:	6145                	addi	sp,sp,48
    800036c4:	8082                	ret

00000000800036c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036c6:	1101                	addi	sp,sp,-32
    800036c8:	ec06                	sd	ra,24(sp)
    800036ca:	e822                	sd	s0,16(sp)
    800036cc:	e426                	sd	s1,8(sp)
    800036ce:	e04a                	sd	s2,0(sp)
    800036d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036d2:	0001a517          	auipc	a0,0x1a
    800036d6:	d4e50513          	addi	a0,a0,-690 # 8001d420 <log>
    800036da:	00003097          	auipc	ra,0x3
    800036de:	c86080e7          	jalr	-890(ra) # 80006360 <acquire>
  while(1){
    if(log.committing){
    800036e2:	0001a497          	auipc	s1,0x1a
    800036e6:	d3e48493          	addi	s1,s1,-706 # 8001d420 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036ea:	4979                	li	s2,30
    800036ec:	a039                	j	800036fa <begin_op+0x34>
      sleep(&log, &log.lock);
    800036ee:	85a6                	mv	a1,s1
    800036f0:	8526                	mv	a0,s1
    800036f2:	ffffe097          	auipc	ra,0xffffe
    800036f6:	e22080e7          	jalr	-478(ra) # 80001514 <sleep>
    if(log.committing){
    800036fa:	50dc                	lw	a5,36(s1)
    800036fc:	fbed                	bnez	a5,800036ee <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800036fe:	509c                	lw	a5,32(s1)
    80003700:	0017871b          	addiw	a4,a5,1
    80003704:	0007069b          	sext.w	a3,a4
    80003708:	0027179b          	slliw	a5,a4,0x2
    8000370c:	9fb9                	addw	a5,a5,a4
    8000370e:	0017979b          	slliw	a5,a5,0x1
    80003712:	54d8                	lw	a4,44(s1)
    80003714:	9fb9                	addw	a5,a5,a4
    80003716:	00f95963          	bge	s2,a5,80003728 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000371a:	85a6                	mv	a1,s1
    8000371c:	8526                	mv	a0,s1
    8000371e:	ffffe097          	auipc	ra,0xffffe
    80003722:	df6080e7          	jalr	-522(ra) # 80001514 <sleep>
    80003726:	bfd1                	j	800036fa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003728:	0001a517          	auipc	a0,0x1a
    8000372c:	cf850513          	addi	a0,a0,-776 # 8001d420 <log>
    80003730:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003732:	00003097          	auipc	ra,0x3
    80003736:	ce2080e7          	jalr	-798(ra) # 80006414 <release>
      break;
    }
  }
}
    8000373a:	60e2                	ld	ra,24(sp)
    8000373c:	6442                	ld	s0,16(sp)
    8000373e:	64a2                	ld	s1,8(sp)
    80003740:	6902                	ld	s2,0(sp)
    80003742:	6105                	addi	sp,sp,32
    80003744:	8082                	ret

0000000080003746 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003746:	7139                	addi	sp,sp,-64
    80003748:	fc06                	sd	ra,56(sp)
    8000374a:	f822                	sd	s0,48(sp)
    8000374c:	f426                	sd	s1,40(sp)
    8000374e:	f04a                	sd	s2,32(sp)
    80003750:	ec4e                	sd	s3,24(sp)
    80003752:	e852                	sd	s4,16(sp)
    80003754:	e456                	sd	s5,8(sp)
    80003756:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003758:	0001a497          	auipc	s1,0x1a
    8000375c:	cc848493          	addi	s1,s1,-824 # 8001d420 <log>
    80003760:	8526                	mv	a0,s1
    80003762:	00003097          	auipc	ra,0x3
    80003766:	bfe080e7          	jalr	-1026(ra) # 80006360 <acquire>
  log.outstanding -= 1;
    8000376a:	509c                	lw	a5,32(s1)
    8000376c:	37fd                	addiw	a5,a5,-1
    8000376e:	0007891b          	sext.w	s2,a5
    80003772:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003774:	50dc                	lw	a5,36(s1)
    80003776:	efb9                	bnez	a5,800037d4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003778:	06091663          	bnez	s2,800037e4 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000377c:	0001a497          	auipc	s1,0x1a
    80003780:	ca448493          	addi	s1,s1,-860 # 8001d420 <log>
    80003784:	4785                	li	a5,1
    80003786:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003788:	8526                	mv	a0,s1
    8000378a:	00003097          	auipc	ra,0x3
    8000378e:	c8a080e7          	jalr	-886(ra) # 80006414 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003792:	54dc                	lw	a5,44(s1)
    80003794:	06f04763          	bgtz	a5,80003802 <end_op+0xbc>
    acquire(&log.lock);
    80003798:	0001a497          	auipc	s1,0x1a
    8000379c:	c8848493          	addi	s1,s1,-888 # 8001d420 <log>
    800037a0:	8526                	mv	a0,s1
    800037a2:	00003097          	auipc	ra,0x3
    800037a6:	bbe080e7          	jalr	-1090(ra) # 80006360 <acquire>
    log.committing = 0;
    800037aa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037ae:	8526                	mv	a0,s1
    800037b0:	ffffe097          	auipc	ra,0xffffe
    800037b4:	ef0080e7          	jalr	-272(ra) # 800016a0 <wakeup>
    release(&log.lock);
    800037b8:	8526                	mv	a0,s1
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	c5a080e7          	jalr	-934(ra) # 80006414 <release>
}
    800037c2:	70e2                	ld	ra,56(sp)
    800037c4:	7442                	ld	s0,48(sp)
    800037c6:	74a2                	ld	s1,40(sp)
    800037c8:	7902                	ld	s2,32(sp)
    800037ca:	69e2                	ld	s3,24(sp)
    800037cc:	6a42                	ld	s4,16(sp)
    800037ce:	6aa2                	ld	s5,8(sp)
    800037d0:	6121                	addi	sp,sp,64
    800037d2:	8082                	ret
    panic("log.committing");
    800037d4:	00005517          	auipc	a0,0x5
    800037d8:	de450513          	addi	a0,a0,-540 # 800085b8 <syscalls+0x1f0>
    800037dc:	00002097          	auipc	ra,0x2
    800037e0:	5cc080e7          	jalr	1484(ra) # 80005da8 <panic>
    wakeup(&log);
    800037e4:	0001a497          	auipc	s1,0x1a
    800037e8:	c3c48493          	addi	s1,s1,-964 # 8001d420 <log>
    800037ec:	8526                	mv	a0,s1
    800037ee:	ffffe097          	auipc	ra,0xffffe
    800037f2:	eb2080e7          	jalr	-334(ra) # 800016a0 <wakeup>
  release(&log.lock);
    800037f6:	8526                	mv	a0,s1
    800037f8:	00003097          	auipc	ra,0x3
    800037fc:	c1c080e7          	jalr	-996(ra) # 80006414 <release>
  if(do_commit){
    80003800:	b7c9                	j	800037c2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003802:	0001aa97          	auipc	s5,0x1a
    80003806:	c4ea8a93          	addi	s5,s5,-946 # 8001d450 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000380a:	0001aa17          	auipc	s4,0x1a
    8000380e:	c16a0a13          	addi	s4,s4,-1002 # 8001d420 <log>
    80003812:	018a2583          	lw	a1,24(s4)
    80003816:	012585bb          	addw	a1,a1,s2
    8000381a:	2585                	addiw	a1,a1,1
    8000381c:	028a2503          	lw	a0,40(s4)
    80003820:	fffff097          	auipc	ra,0xfffff
    80003824:	cd2080e7          	jalr	-814(ra) # 800024f2 <bread>
    80003828:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000382a:	000aa583          	lw	a1,0(s5)
    8000382e:	028a2503          	lw	a0,40(s4)
    80003832:	fffff097          	auipc	ra,0xfffff
    80003836:	cc0080e7          	jalr	-832(ra) # 800024f2 <bread>
    8000383a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000383c:	40000613          	li	a2,1024
    80003840:	05850593          	addi	a1,a0,88
    80003844:	05848513          	addi	a0,s1,88
    80003848:	ffffd097          	auipc	ra,0xffffd
    8000384c:	990080e7          	jalr	-1648(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003850:	8526                	mv	a0,s1
    80003852:	fffff097          	auipc	ra,0xfffff
    80003856:	d92080e7          	jalr	-622(ra) # 800025e4 <bwrite>
    brelse(from);
    8000385a:	854e                	mv	a0,s3
    8000385c:	fffff097          	auipc	ra,0xfffff
    80003860:	dc6080e7          	jalr	-570(ra) # 80002622 <brelse>
    brelse(to);
    80003864:	8526                	mv	a0,s1
    80003866:	fffff097          	auipc	ra,0xfffff
    8000386a:	dbc080e7          	jalr	-580(ra) # 80002622 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000386e:	2905                	addiw	s2,s2,1
    80003870:	0a91                	addi	s5,s5,4
    80003872:	02ca2783          	lw	a5,44(s4)
    80003876:	f8f94ee3          	blt	s2,a5,80003812 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000387a:	00000097          	auipc	ra,0x0
    8000387e:	c6a080e7          	jalr	-918(ra) # 800034e4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003882:	4501                	li	a0,0
    80003884:	00000097          	auipc	ra,0x0
    80003888:	cda080e7          	jalr	-806(ra) # 8000355e <install_trans>
    log.lh.n = 0;
    8000388c:	0001a797          	auipc	a5,0x1a
    80003890:	bc07a023          	sw	zero,-1088(a5) # 8001d44c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003894:	00000097          	auipc	ra,0x0
    80003898:	c50080e7          	jalr	-944(ra) # 800034e4 <write_head>
    8000389c:	bdf5                	j	80003798 <end_op+0x52>

000000008000389e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038ac:	0001a917          	auipc	s2,0x1a
    800038b0:	b7490913          	addi	s2,s2,-1164 # 8001d420 <log>
    800038b4:	854a                	mv	a0,s2
    800038b6:	00003097          	auipc	ra,0x3
    800038ba:	aaa080e7          	jalr	-1366(ra) # 80006360 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038be:	02c92603          	lw	a2,44(s2)
    800038c2:	47f5                	li	a5,29
    800038c4:	06c7c563          	blt	a5,a2,8000392e <log_write+0x90>
    800038c8:	0001a797          	auipc	a5,0x1a
    800038cc:	b747a783          	lw	a5,-1164(a5) # 8001d43c <log+0x1c>
    800038d0:	37fd                	addiw	a5,a5,-1
    800038d2:	04f65e63          	bge	a2,a5,8000392e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800038d6:	0001a797          	auipc	a5,0x1a
    800038da:	b6a7a783          	lw	a5,-1174(a5) # 8001d440 <log+0x20>
    800038de:	06f05063          	blez	a5,8000393e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038e2:	4781                	li	a5,0
    800038e4:	06c05563          	blez	a2,8000394e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038e8:	44cc                	lw	a1,12(s1)
    800038ea:	0001a717          	auipc	a4,0x1a
    800038ee:	b6670713          	addi	a4,a4,-1178 # 8001d450 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800038f2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038f4:	4314                	lw	a3,0(a4)
    800038f6:	04b68c63          	beq	a3,a1,8000394e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800038fa:	2785                	addiw	a5,a5,1
    800038fc:	0711                	addi	a4,a4,4
    800038fe:	fef61be3          	bne	a2,a5,800038f4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003902:	0621                	addi	a2,a2,8
    80003904:	060a                	slli	a2,a2,0x2
    80003906:	0001a797          	auipc	a5,0x1a
    8000390a:	b1a78793          	addi	a5,a5,-1254 # 8001d420 <log>
    8000390e:	963e                	add	a2,a2,a5
    80003910:	44dc                	lw	a5,12(s1)
    80003912:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003914:	8526                	mv	a0,s1
    80003916:	fffff097          	auipc	ra,0xfffff
    8000391a:	daa080e7          	jalr	-598(ra) # 800026c0 <bpin>
    log.lh.n++;
    8000391e:	0001a717          	auipc	a4,0x1a
    80003922:	b0270713          	addi	a4,a4,-1278 # 8001d420 <log>
    80003926:	575c                	lw	a5,44(a4)
    80003928:	2785                	addiw	a5,a5,1
    8000392a:	d75c                	sw	a5,44(a4)
    8000392c:	a835                	j	80003968 <log_write+0xca>
    panic("too big a transaction");
    8000392e:	00005517          	auipc	a0,0x5
    80003932:	c9a50513          	addi	a0,a0,-870 # 800085c8 <syscalls+0x200>
    80003936:	00002097          	auipc	ra,0x2
    8000393a:	472080e7          	jalr	1138(ra) # 80005da8 <panic>
    panic("log_write outside of trans");
    8000393e:	00005517          	auipc	a0,0x5
    80003942:	ca250513          	addi	a0,a0,-862 # 800085e0 <syscalls+0x218>
    80003946:	00002097          	auipc	ra,0x2
    8000394a:	462080e7          	jalr	1122(ra) # 80005da8 <panic>
  log.lh.block[i] = b->blockno;
    8000394e:	00878713          	addi	a4,a5,8
    80003952:	00271693          	slli	a3,a4,0x2
    80003956:	0001a717          	auipc	a4,0x1a
    8000395a:	aca70713          	addi	a4,a4,-1334 # 8001d420 <log>
    8000395e:	9736                	add	a4,a4,a3
    80003960:	44d4                	lw	a3,12(s1)
    80003962:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003964:	faf608e3          	beq	a2,a5,80003914 <log_write+0x76>
  }
  release(&log.lock);
    80003968:	0001a517          	auipc	a0,0x1a
    8000396c:	ab850513          	addi	a0,a0,-1352 # 8001d420 <log>
    80003970:	00003097          	auipc	ra,0x3
    80003974:	aa4080e7          	jalr	-1372(ra) # 80006414 <release>
}
    80003978:	60e2                	ld	ra,24(sp)
    8000397a:	6442                	ld	s0,16(sp)
    8000397c:	64a2                	ld	s1,8(sp)
    8000397e:	6902                	ld	s2,0(sp)
    80003980:	6105                	addi	sp,sp,32
    80003982:	8082                	ret

0000000080003984 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003984:	1101                	addi	sp,sp,-32
    80003986:	ec06                	sd	ra,24(sp)
    80003988:	e822                	sd	s0,16(sp)
    8000398a:	e426                	sd	s1,8(sp)
    8000398c:	e04a                	sd	s2,0(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
    80003992:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003994:	00005597          	auipc	a1,0x5
    80003998:	c6c58593          	addi	a1,a1,-916 # 80008600 <syscalls+0x238>
    8000399c:	0521                	addi	a0,a0,8
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	932080e7          	jalr	-1742(ra) # 800062d0 <initlock>
  lk->name = name;
    800039a6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039aa:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ae:	0204a423          	sw	zero,40(s1)
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6902                	ld	s2,0(sp)
    800039ba:	6105                	addi	sp,sp,32
    800039bc:	8082                	ret

00000000800039be <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039be:	1101                	addi	sp,sp,-32
    800039c0:	ec06                	sd	ra,24(sp)
    800039c2:	e822                	sd	s0,16(sp)
    800039c4:	e426                	sd	s1,8(sp)
    800039c6:	e04a                	sd	s2,0(sp)
    800039c8:	1000                	addi	s0,sp,32
    800039ca:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039cc:	00850913          	addi	s2,a0,8
    800039d0:	854a                	mv	a0,s2
    800039d2:	00003097          	auipc	ra,0x3
    800039d6:	98e080e7          	jalr	-1650(ra) # 80006360 <acquire>
  while (lk->locked) {
    800039da:	409c                	lw	a5,0(s1)
    800039dc:	cb89                	beqz	a5,800039ee <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800039de:	85ca                	mv	a1,s2
    800039e0:	8526                	mv	a0,s1
    800039e2:	ffffe097          	auipc	ra,0xffffe
    800039e6:	b32080e7          	jalr	-1230(ra) # 80001514 <sleep>
  while (lk->locked) {
    800039ea:	409c                	lw	a5,0(s1)
    800039ec:	fbed                	bnez	a5,800039de <acquiresleep+0x20>
  }
  lk->locked = 1;
    800039ee:	4785                	li	a5,1
    800039f0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800039f2:	ffffd097          	auipc	ra,0xffffd
    800039f6:	456080e7          	jalr	1110(ra) # 80000e48 <myproc>
    800039fa:	591c                	lw	a5,48(a0)
    800039fc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039fe:	854a                	mv	a0,s2
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	a14080e7          	jalr	-1516(ra) # 80006414 <release>
}
    80003a08:	60e2                	ld	ra,24(sp)
    80003a0a:	6442                	ld	s0,16(sp)
    80003a0c:	64a2                	ld	s1,8(sp)
    80003a0e:	6902                	ld	s2,0(sp)
    80003a10:	6105                	addi	sp,sp,32
    80003a12:	8082                	ret

0000000080003a14 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a14:	1101                	addi	sp,sp,-32
    80003a16:	ec06                	sd	ra,24(sp)
    80003a18:	e822                	sd	s0,16(sp)
    80003a1a:	e426                	sd	s1,8(sp)
    80003a1c:	e04a                	sd	s2,0(sp)
    80003a1e:	1000                	addi	s0,sp,32
    80003a20:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a22:	00850913          	addi	s2,a0,8
    80003a26:	854a                	mv	a0,s2
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	938080e7          	jalr	-1736(ra) # 80006360 <acquire>
  lk->locked = 0;
    80003a30:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a34:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a38:	8526                	mv	a0,s1
    80003a3a:	ffffe097          	auipc	ra,0xffffe
    80003a3e:	c66080e7          	jalr	-922(ra) # 800016a0 <wakeup>
  release(&lk->lk);
    80003a42:	854a                	mv	a0,s2
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	9d0080e7          	jalr	-1584(ra) # 80006414 <release>
}
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6902                	ld	s2,0(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a58:	7179                	addi	sp,sp,-48
    80003a5a:	f406                	sd	ra,40(sp)
    80003a5c:	f022                	sd	s0,32(sp)
    80003a5e:	ec26                	sd	s1,24(sp)
    80003a60:	e84a                	sd	s2,16(sp)
    80003a62:	e44e                	sd	s3,8(sp)
    80003a64:	1800                	addi	s0,sp,48
    80003a66:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a68:	00850913          	addi	s2,a0,8
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	8f2080e7          	jalr	-1806(ra) # 80006360 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a76:	409c                	lw	a5,0(s1)
    80003a78:	ef99                	bnez	a5,80003a96 <holdingsleep+0x3e>
    80003a7a:	4481                	li	s1,0
  release(&lk->lk);
    80003a7c:	854a                	mv	a0,s2
    80003a7e:	00003097          	auipc	ra,0x3
    80003a82:	996080e7          	jalr	-1642(ra) # 80006414 <release>
  return r;
}
    80003a86:	8526                	mv	a0,s1
    80003a88:	70a2                	ld	ra,40(sp)
    80003a8a:	7402                	ld	s0,32(sp)
    80003a8c:	64e2                	ld	s1,24(sp)
    80003a8e:	6942                	ld	s2,16(sp)
    80003a90:	69a2                	ld	s3,8(sp)
    80003a92:	6145                	addi	sp,sp,48
    80003a94:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a96:	0284a983          	lw	s3,40(s1)
    80003a9a:	ffffd097          	auipc	ra,0xffffd
    80003a9e:	3ae080e7          	jalr	942(ra) # 80000e48 <myproc>
    80003aa2:	5904                	lw	s1,48(a0)
    80003aa4:	413484b3          	sub	s1,s1,s3
    80003aa8:	0014b493          	seqz	s1,s1
    80003aac:	bfc1                	j	80003a7c <holdingsleep+0x24>

0000000080003aae <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003aae:	1141                	addi	sp,sp,-16
    80003ab0:	e406                	sd	ra,8(sp)
    80003ab2:	e022                	sd	s0,0(sp)
    80003ab4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ab6:	00005597          	auipc	a1,0x5
    80003aba:	b5a58593          	addi	a1,a1,-1190 # 80008610 <syscalls+0x248>
    80003abe:	0001a517          	auipc	a0,0x1a
    80003ac2:	aaa50513          	addi	a0,a0,-1366 # 8001d568 <ftable>
    80003ac6:	00003097          	auipc	ra,0x3
    80003aca:	80a080e7          	jalr	-2038(ra) # 800062d0 <initlock>
}
    80003ace:	60a2                	ld	ra,8(sp)
    80003ad0:	6402                	ld	s0,0(sp)
    80003ad2:	0141                	addi	sp,sp,16
    80003ad4:	8082                	ret

0000000080003ad6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003ad6:	1101                	addi	sp,sp,-32
    80003ad8:	ec06                	sd	ra,24(sp)
    80003ada:	e822                	sd	s0,16(sp)
    80003adc:	e426                	sd	s1,8(sp)
    80003ade:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ae0:	0001a517          	auipc	a0,0x1a
    80003ae4:	a8850513          	addi	a0,a0,-1400 # 8001d568 <ftable>
    80003ae8:	00003097          	auipc	ra,0x3
    80003aec:	878080e7          	jalr	-1928(ra) # 80006360 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003af0:	0001a497          	auipc	s1,0x1a
    80003af4:	a9048493          	addi	s1,s1,-1392 # 8001d580 <ftable+0x18>
    80003af8:	0001b717          	auipc	a4,0x1b
    80003afc:	a2870713          	addi	a4,a4,-1496 # 8001e520 <ftable+0xfb8>
    if(f->ref == 0){
    80003b00:	40dc                	lw	a5,4(s1)
    80003b02:	cf99                	beqz	a5,80003b20 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b04:	02848493          	addi	s1,s1,40
    80003b08:	fee49ce3          	bne	s1,a4,80003b00 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b0c:	0001a517          	auipc	a0,0x1a
    80003b10:	a5c50513          	addi	a0,a0,-1444 # 8001d568 <ftable>
    80003b14:	00003097          	auipc	ra,0x3
    80003b18:	900080e7          	jalr	-1792(ra) # 80006414 <release>
  return 0;
    80003b1c:	4481                	li	s1,0
    80003b1e:	a819                	j	80003b34 <filealloc+0x5e>
      f->ref = 1;
    80003b20:	4785                	li	a5,1
    80003b22:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b24:	0001a517          	auipc	a0,0x1a
    80003b28:	a4450513          	addi	a0,a0,-1468 # 8001d568 <ftable>
    80003b2c:	00003097          	auipc	ra,0x3
    80003b30:	8e8080e7          	jalr	-1816(ra) # 80006414 <release>
}
    80003b34:	8526                	mv	a0,s1
    80003b36:	60e2                	ld	ra,24(sp)
    80003b38:	6442                	ld	s0,16(sp)
    80003b3a:	64a2                	ld	s1,8(sp)
    80003b3c:	6105                	addi	sp,sp,32
    80003b3e:	8082                	ret

0000000080003b40 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b40:	1101                	addi	sp,sp,-32
    80003b42:	ec06                	sd	ra,24(sp)
    80003b44:	e822                	sd	s0,16(sp)
    80003b46:	e426                	sd	s1,8(sp)
    80003b48:	1000                	addi	s0,sp,32
    80003b4a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b4c:	0001a517          	auipc	a0,0x1a
    80003b50:	a1c50513          	addi	a0,a0,-1508 # 8001d568 <ftable>
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	80c080e7          	jalr	-2036(ra) # 80006360 <acquire>
  if(f->ref < 1)
    80003b5c:	40dc                	lw	a5,4(s1)
    80003b5e:	02f05263          	blez	a5,80003b82 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b62:	2785                	addiw	a5,a5,1
    80003b64:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b66:	0001a517          	auipc	a0,0x1a
    80003b6a:	a0250513          	addi	a0,a0,-1534 # 8001d568 <ftable>
    80003b6e:	00003097          	auipc	ra,0x3
    80003b72:	8a6080e7          	jalr	-1882(ra) # 80006414 <release>
  return f;
}
    80003b76:	8526                	mv	a0,s1
    80003b78:	60e2                	ld	ra,24(sp)
    80003b7a:	6442                	ld	s0,16(sp)
    80003b7c:	64a2                	ld	s1,8(sp)
    80003b7e:	6105                	addi	sp,sp,32
    80003b80:	8082                	ret
    panic("filedup");
    80003b82:	00005517          	auipc	a0,0x5
    80003b86:	a9650513          	addi	a0,a0,-1386 # 80008618 <syscalls+0x250>
    80003b8a:	00002097          	auipc	ra,0x2
    80003b8e:	21e080e7          	jalr	542(ra) # 80005da8 <panic>

0000000080003b92 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b92:	7139                	addi	sp,sp,-64
    80003b94:	fc06                	sd	ra,56(sp)
    80003b96:	f822                	sd	s0,48(sp)
    80003b98:	f426                	sd	s1,40(sp)
    80003b9a:	f04a                	sd	s2,32(sp)
    80003b9c:	ec4e                	sd	s3,24(sp)
    80003b9e:	e852                	sd	s4,16(sp)
    80003ba0:	e456                	sd	s5,8(sp)
    80003ba2:	0080                	addi	s0,sp,64
    80003ba4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ba6:	0001a517          	auipc	a0,0x1a
    80003baa:	9c250513          	addi	a0,a0,-1598 # 8001d568 <ftable>
    80003bae:	00002097          	auipc	ra,0x2
    80003bb2:	7b2080e7          	jalr	1970(ra) # 80006360 <acquire>
  if(f->ref < 1)
    80003bb6:	40dc                	lw	a5,4(s1)
    80003bb8:	06f05163          	blez	a5,80003c1a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bbc:	37fd                	addiw	a5,a5,-1
    80003bbe:	0007871b          	sext.w	a4,a5
    80003bc2:	c0dc                	sw	a5,4(s1)
    80003bc4:	06e04363          	bgtz	a4,80003c2a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bc8:	0004a903          	lw	s2,0(s1)
    80003bcc:	0094ca83          	lbu	s5,9(s1)
    80003bd0:	0104ba03          	ld	s4,16(s1)
    80003bd4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003bd8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003bdc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003be0:	0001a517          	auipc	a0,0x1a
    80003be4:	98850513          	addi	a0,a0,-1656 # 8001d568 <ftable>
    80003be8:	00003097          	auipc	ra,0x3
    80003bec:	82c080e7          	jalr	-2004(ra) # 80006414 <release>

  if(ff.type == FD_PIPE){
    80003bf0:	4785                	li	a5,1
    80003bf2:	04f90d63          	beq	s2,a5,80003c4c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003bf6:	3979                	addiw	s2,s2,-2
    80003bf8:	4785                	li	a5,1
    80003bfa:	0527e063          	bltu	a5,s2,80003c3a <fileclose+0xa8>
    begin_op();
    80003bfe:	00000097          	auipc	ra,0x0
    80003c02:	ac8080e7          	jalr	-1336(ra) # 800036c6 <begin_op>
    iput(ff.ip);
    80003c06:	854e                	mv	a0,s3
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	2a6080e7          	jalr	678(ra) # 80002eae <iput>
    end_op();
    80003c10:	00000097          	auipc	ra,0x0
    80003c14:	b36080e7          	jalr	-1226(ra) # 80003746 <end_op>
    80003c18:	a00d                	j	80003c3a <fileclose+0xa8>
    panic("fileclose");
    80003c1a:	00005517          	auipc	a0,0x5
    80003c1e:	a0650513          	addi	a0,a0,-1530 # 80008620 <syscalls+0x258>
    80003c22:	00002097          	auipc	ra,0x2
    80003c26:	186080e7          	jalr	390(ra) # 80005da8 <panic>
    release(&ftable.lock);
    80003c2a:	0001a517          	auipc	a0,0x1a
    80003c2e:	93e50513          	addi	a0,a0,-1730 # 8001d568 <ftable>
    80003c32:	00002097          	auipc	ra,0x2
    80003c36:	7e2080e7          	jalr	2018(ra) # 80006414 <release>
  }
}
    80003c3a:	70e2                	ld	ra,56(sp)
    80003c3c:	7442                	ld	s0,48(sp)
    80003c3e:	74a2                	ld	s1,40(sp)
    80003c40:	7902                	ld	s2,32(sp)
    80003c42:	69e2                	ld	s3,24(sp)
    80003c44:	6a42                	ld	s4,16(sp)
    80003c46:	6aa2                	ld	s5,8(sp)
    80003c48:	6121                	addi	sp,sp,64
    80003c4a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c4c:	85d6                	mv	a1,s5
    80003c4e:	8552                	mv	a0,s4
    80003c50:	00000097          	auipc	ra,0x0
    80003c54:	34c080e7          	jalr	844(ra) # 80003f9c <pipeclose>
    80003c58:	b7cd                	j	80003c3a <fileclose+0xa8>

0000000080003c5a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c5a:	715d                	addi	sp,sp,-80
    80003c5c:	e486                	sd	ra,72(sp)
    80003c5e:	e0a2                	sd	s0,64(sp)
    80003c60:	fc26                	sd	s1,56(sp)
    80003c62:	f84a                	sd	s2,48(sp)
    80003c64:	f44e                	sd	s3,40(sp)
    80003c66:	0880                	addi	s0,sp,80
    80003c68:	84aa                	mv	s1,a0
    80003c6a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c6c:	ffffd097          	auipc	ra,0xffffd
    80003c70:	1dc080e7          	jalr	476(ra) # 80000e48 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003c74:	409c                	lw	a5,0(s1)
    80003c76:	37f9                	addiw	a5,a5,-2
    80003c78:	4705                	li	a4,1
    80003c7a:	04f76763          	bltu	a4,a5,80003cc8 <filestat+0x6e>
    80003c7e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c80:	6c88                	ld	a0,24(s1)
    80003c82:	fffff097          	auipc	ra,0xfffff
    80003c86:	072080e7          	jalr	114(ra) # 80002cf4 <ilock>
    stati(f->ip, &st);
    80003c8a:	fb840593          	addi	a1,s0,-72
    80003c8e:	6c88                	ld	a0,24(s1)
    80003c90:	fffff097          	auipc	ra,0xfffff
    80003c94:	2ee080e7          	jalr	750(ra) # 80002f7e <stati>
    iunlock(f->ip);
    80003c98:	6c88                	ld	a0,24(s1)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	11c080e7          	jalr	284(ra) # 80002db6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ca2:	46e1                	li	a3,24
    80003ca4:	fb840613          	addi	a2,s0,-72
    80003ca8:	85ce                	mv	a1,s3
    80003caa:	06093503          	ld	a0,96(s2)
    80003cae:	ffffd097          	auipc	ra,0xffffd
    80003cb2:	e5c080e7          	jalr	-420(ra) # 80000b0a <copyout>
    80003cb6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003cba:	60a6                	ld	ra,72(sp)
    80003cbc:	6406                	ld	s0,64(sp)
    80003cbe:	74e2                	ld	s1,56(sp)
    80003cc0:	7942                	ld	s2,48(sp)
    80003cc2:	79a2                	ld	s3,40(sp)
    80003cc4:	6161                	addi	sp,sp,80
    80003cc6:	8082                	ret
  return -1;
    80003cc8:	557d                	li	a0,-1
    80003cca:	bfc5                	j	80003cba <filestat+0x60>

0000000080003ccc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ccc:	7179                	addi	sp,sp,-48
    80003cce:	f406                	sd	ra,40(sp)
    80003cd0:	f022                	sd	s0,32(sp)
    80003cd2:	ec26                	sd	s1,24(sp)
    80003cd4:	e84a                	sd	s2,16(sp)
    80003cd6:	e44e                	sd	s3,8(sp)
    80003cd8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003cda:	00854783          	lbu	a5,8(a0)
    80003cde:	c3d5                	beqz	a5,80003d82 <fileread+0xb6>
    80003ce0:	84aa                	mv	s1,a0
    80003ce2:	89ae                	mv	s3,a1
    80003ce4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ce6:	411c                	lw	a5,0(a0)
    80003ce8:	4705                	li	a4,1
    80003cea:	04e78963          	beq	a5,a4,80003d3c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cee:	470d                	li	a4,3
    80003cf0:	04e78d63          	beq	a5,a4,80003d4a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cf4:	4709                	li	a4,2
    80003cf6:	06e79e63          	bne	a5,a4,80003d72 <fileread+0xa6>
    ilock(f->ip);
    80003cfa:	6d08                	ld	a0,24(a0)
    80003cfc:	fffff097          	auipc	ra,0xfffff
    80003d00:	ff8080e7          	jalr	-8(ra) # 80002cf4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d04:	874a                	mv	a4,s2
    80003d06:	5094                	lw	a3,32(s1)
    80003d08:	864e                	mv	a2,s3
    80003d0a:	4585                	li	a1,1
    80003d0c:	6c88                	ld	a0,24(s1)
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	29a080e7          	jalr	666(ra) # 80002fa8 <readi>
    80003d16:	892a                	mv	s2,a0
    80003d18:	00a05563          	blez	a0,80003d22 <fileread+0x56>
      f->off += r;
    80003d1c:	509c                	lw	a5,32(s1)
    80003d1e:	9fa9                	addw	a5,a5,a0
    80003d20:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	092080e7          	jalr	146(ra) # 80002db6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d2c:	854a                	mv	a0,s2
    80003d2e:	70a2                	ld	ra,40(sp)
    80003d30:	7402                	ld	s0,32(sp)
    80003d32:	64e2                	ld	s1,24(sp)
    80003d34:	6942                	ld	s2,16(sp)
    80003d36:	69a2                	ld	s3,8(sp)
    80003d38:	6145                	addi	sp,sp,48
    80003d3a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d3c:	6908                	ld	a0,16(a0)
    80003d3e:	00000097          	auipc	ra,0x0
    80003d42:	3c8080e7          	jalr	968(ra) # 80004106 <piperead>
    80003d46:	892a                	mv	s2,a0
    80003d48:	b7d5                	j	80003d2c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d4a:	02451783          	lh	a5,36(a0)
    80003d4e:	03079693          	slli	a3,a5,0x30
    80003d52:	92c1                	srli	a3,a3,0x30
    80003d54:	4725                	li	a4,9
    80003d56:	02d76863          	bltu	a4,a3,80003d86 <fileread+0xba>
    80003d5a:	0792                	slli	a5,a5,0x4
    80003d5c:	00019717          	auipc	a4,0x19
    80003d60:	76c70713          	addi	a4,a4,1900 # 8001d4c8 <devsw>
    80003d64:	97ba                	add	a5,a5,a4
    80003d66:	639c                	ld	a5,0(a5)
    80003d68:	c38d                	beqz	a5,80003d8a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d6a:	4505                	li	a0,1
    80003d6c:	9782                	jalr	a5
    80003d6e:	892a                	mv	s2,a0
    80003d70:	bf75                	j	80003d2c <fileread+0x60>
    panic("fileread");
    80003d72:	00005517          	auipc	a0,0x5
    80003d76:	8be50513          	addi	a0,a0,-1858 # 80008630 <syscalls+0x268>
    80003d7a:	00002097          	auipc	ra,0x2
    80003d7e:	02e080e7          	jalr	46(ra) # 80005da8 <panic>
    return -1;
    80003d82:	597d                	li	s2,-1
    80003d84:	b765                	j	80003d2c <fileread+0x60>
      return -1;
    80003d86:	597d                	li	s2,-1
    80003d88:	b755                	j	80003d2c <fileread+0x60>
    80003d8a:	597d                	li	s2,-1
    80003d8c:	b745                	j	80003d2c <fileread+0x60>

0000000080003d8e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d8e:	715d                	addi	sp,sp,-80
    80003d90:	e486                	sd	ra,72(sp)
    80003d92:	e0a2                	sd	s0,64(sp)
    80003d94:	fc26                	sd	s1,56(sp)
    80003d96:	f84a                	sd	s2,48(sp)
    80003d98:	f44e                	sd	s3,40(sp)
    80003d9a:	f052                	sd	s4,32(sp)
    80003d9c:	ec56                	sd	s5,24(sp)
    80003d9e:	e85a                	sd	s6,16(sp)
    80003da0:	e45e                	sd	s7,8(sp)
    80003da2:	e062                	sd	s8,0(sp)
    80003da4:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003da6:	00954783          	lbu	a5,9(a0)
    80003daa:	10078663          	beqz	a5,80003eb6 <filewrite+0x128>
    80003dae:	892a                	mv	s2,a0
    80003db0:	8aae                	mv	s5,a1
    80003db2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003db4:	411c                	lw	a5,0(a0)
    80003db6:	4705                	li	a4,1
    80003db8:	02e78263          	beq	a5,a4,80003ddc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dbc:	470d                	li	a4,3
    80003dbe:	02e78663          	beq	a5,a4,80003dea <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dc2:	4709                	li	a4,2
    80003dc4:	0ee79163          	bne	a5,a4,80003ea6 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003dc8:	0ac05d63          	blez	a2,80003e82 <filewrite+0xf4>
    int i = 0;
    80003dcc:	4981                	li	s3,0
    80003dce:	6b05                	lui	s6,0x1
    80003dd0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003dd4:	6b85                	lui	s7,0x1
    80003dd6:	c00b8b9b          	addiw	s7,s7,-1024
    80003dda:	a861                	j	80003e72 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ddc:	6908                	ld	a0,16(a0)
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	22e080e7          	jalr	558(ra) # 8000400c <pipewrite>
    80003de6:	8a2a                	mv	s4,a0
    80003de8:	a045                	j	80003e88 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003dea:	02451783          	lh	a5,36(a0)
    80003dee:	03079693          	slli	a3,a5,0x30
    80003df2:	92c1                	srli	a3,a3,0x30
    80003df4:	4725                	li	a4,9
    80003df6:	0cd76263          	bltu	a4,a3,80003eba <filewrite+0x12c>
    80003dfa:	0792                	slli	a5,a5,0x4
    80003dfc:	00019717          	auipc	a4,0x19
    80003e00:	6cc70713          	addi	a4,a4,1740 # 8001d4c8 <devsw>
    80003e04:	97ba                	add	a5,a5,a4
    80003e06:	679c                	ld	a5,8(a5)
    80003e08:	cbdd                	beqz	a5,80003ebe <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e0a:	4505                	li	a0,1
    80003e0c:	9782                	jalr	a5
    80003e0e:	8a2a                	mv	s4,a0
    80003e10:	a8a5                	j	80003e88 <filewrite+0xfa>
    80003e12:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	8b0080e7          	jalr	-1872(ra) # 800036c6 <begin_op>
      ilock(f->ip);
    80003e1e:	01893503          	ld	a0,24(s2)
    80003e22:	fffff097          	auipc	ra,0xfffff
    80003e26:	ed2080e7          	jalr	-302(ra) # 80002cf4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e2a:	8762                	mv	a4,s8
    80003e2c:	02092683          	lw	a3,32(s2)
    80003e30:	01598633          	add	a2,s3,s5
    80003e34:	4585                	li	a1,1
    80003e36:	01893503          	ld	a0,24(s2)
    80003e3a:	fffff097          	auipc	ra,0xfffff
    80003e3e:	266080e7          	jalr	614(ra) # 800030a0 <writei>
    80003e42:	84aa                	mv	s1,a0
    80003e44:	00a05763          	blez	a0,80003e52 <filewrite+0xc4>
        f->off += r;
    80003e48:	02092783          	lw	a5,32(s2)
    80003e4c:	9fa9                	addw	a5,a5,a0
    80003e4e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e52:	01893503          	ld	a0,24(s2)
    80003e56:	fffff097          	auipc	ra,0xfffff
    80003e5a:	f60080e7          	jalr	-160(ra) # 80002db6 <iunlock>
      end_op();
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	8e8080e7          	jalr	-1816(ra) # 80003746 <end_op>

      if(r != n1){
    80003e66:	009c1f63          	bne	s8,s1,80003e84 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e6a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e6e:	0149db63          	bge	s3,s4,80003e84 <filewrite+0xf6>
      int n1 = n - i;
    80003e72:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003e76:	84be                	mv	s1,a5
    80003e78:	2781                	sext.w	a5,a5
    80003e7a:	f8fb5ce3          	bge	s6,a5,80003e12 <filewrite+0x84>
    80003e7e:	84de                	mv	s1,s7
    80003e80:	bf49                	j	80003e12 <filewrite+0x84>
    int i = 0;
    80003e82:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e84:	013a1f63          	bne	s4,s3,80003ea2 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e88:	8552                	mv	a0,s4
    80003e8a:	60a6                	ld	ra,72(sp)
    80003e8c:	6406                	ld	s0,64(sp)
    80003e8e:	74e2                	ld	s1,56(sp)
    80003e90:	7942                	ld	s2,48(sp)
    80003e92:	79a2                	ld	s3,40(sp)
    80003e94:	7a02                	ld	s4,32(sp)
    80003e96:	6ae2                	ld	s5,24(sp)
    80003e98:	6b42                	ld	s6,16(sp)
    80003e9a:	6ba2                	ld	s7,8(sp)
    80003e9c:	6c02                	ld	s8,0(sp)
    80003e9e:	6161                	addi	sp,sp,80
    80003ea0:	8082                	ret
    ret = (i == n ? n : -1);
    80003ea2:	5a7d                	li	s4,-1
    80003ea4:	b7d5                	j	80003e88 <filewrite+0xfa>
    panic("filewrite");
    80003ea6:	00004517          	auipc	a0,0x4
    80003eaa:	79a50513          	addi	a0,a0,1946 # 80008640 <syscalls+0x278>
    80003eae:	00002097          	auipc	ra,0x2
    80003eb2:	efa080e7          	jalr	-262(ra) # 80005da8 <panic>
    return -1;
    80003eb6:	5a7d                	li	s4,-1
    80003eb8:	bfc1                	j	80003e88 <filewrite+0xfa>
      return -1;
    80003eba:	5a7d                	li	s4,-1
    80003ebc:	b7f1                	j	80003e88 <filewrite+0xfa>
    80003ebe:	5a7d                	li	s4,-1
    80003ec0:	b7e1                	j	80003e88 <filewrite+0xfa>

0000000080003ec2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ec2:	7179                	addi	sp,sp,-48
    80003ec4:	f406                	sd	ra,40(sp)
    80003ec6:	f022                	sd	s0,32(sp)
    80003ec8:	ec26                	sd	s1,24(sp)
    80003eca:	e84a                	sd	s2,16(sp)
    80003ecc:	e44e                	sd	s3,8(sp)
    80003ece:	e052                	sd	s4,0(sp)
    80003ed0:	1800                	addi	s0,sp,48
    80003ed2:	84aa                	mv	s1,a0
    80003ed4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003ed6:	0005b023          	sd	zero,0(a1)
    80003eda:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ede:	00000097          	auipc	ra,0x0
    80003ee2:	bf8080e7          	jalr	-1032(ra) # 80003ad6 <filealloc>
    80003ee6:	e088                	sd	a0,0(s1)
    80003ee8:	c551                	beqz	a0,80003f74 <pipealloc+0xb2>
    80003eea:	00000097          	auipc	ra,0x0
    80003eee:	bec080e7          	jalr	-1044(ra) # 80003ad6 <filealloc>
    80003ef2:	00aa3023          	sd	a0,0(s4)
    80003ef6:	c92d                	beqz	a0,80003f68 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ef8:	ffffc097          	auipc	ra,0xffffc
    80003efc:	220080e7          	jalr	544(ra) # 80000118 <kalloc>
    80003f00:	892a                	mv	s2,a0
    80003f02:	c125                	beqz	a0,80003f62 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f04:	4985                	li	s3,1
    80003f06:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f0a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f0e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f12:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f16:	00004597          	auipc	a1,0x4
    80003f1a:	73a58593          	addi	a1,a1,1850 # 80008650 <syscalls+0x288>
    80003f1e:	00002097          	auipc	ra,0x2
    80003f22:	3b2080e7          	jalr	946(ra) # 800062d0 <initlock>
  (*f0)->type = FD_PIPE;
    80003f26:	609c                	ld	a5,0(s1)
    80003f28:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f2c:	609c                	ld	a5,0(s1)
    80003f2e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f32:	609c                	ld	a5,0(s1)
    80003f34:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f38:	609c                	ld	a5,0(s1)
    80003f3a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f3e:	000a3783          	ld	a5,0(s4)
    80003f42:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f46:	000a3783          	ld	a5,0(s4)
    80003f4a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f4e:	000a3783          	ld	a5,0(s4)
    80003f52:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f56:	000a3783          	ld	a5,0(s4)
    80003f5a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f5e:	4501                	li	a0,0
    80003f60:	a025                	j	80003f88 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f62:	6088                	ld	a0,0(s1)
    80003f64:	e501                	bnez	a0,80003f6c <pipealloc+0xaa>
    80003f66:	a039                	j	80003f74 <pipealloc+0xb2>
    80003f68:	6088                	ld	a0,0(s1)
    80003f6a:	c51d                	beqz	a0,80003f98 <pipealloc+0xd6>
    fileclose(*f0);
    80003f6c:	00000097          	auipc	ra,0x0
    80003f70:	c26080e7          	jalr	-986(ra) # 80003b92 <fileclose>
  if(*f1)
    80003f74:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f78:	557d                	li	a0,-1
  if(*f1)
    80003f7a:	c799                	beqz	a5,80003f88 <pipealloc+0xc6>
    fileclose(*f1);
    80003f7c:	853e                	mv	a0,a5
    80003f7e:	00000097          	auipc	ra,0x0
    80003f82:	c14080e7          	jalr	-1004(ra) # 80003b92 <fileclose>
  return -1;
    80003f86:	557d                	li	a0,-1
}
    80003f88:	70a2                	ld	ra,40(sp)
    80003f8a:	7402                	ld	s0,32(sp)
    80003f8c:	64e2                	ld	s1,24(sp)
    80003f8e:	6942                	ld	s2,16(sp)
    80003f90:	69a2                	ld	s3,8(sp)
    80003f92:	6a02                	ld	s4,0(sp)
    80003f94:	6145                	addi	sp,sp,48
    80003f96:	8082                	ret
  return -1;
    80003f98:	557d                	li	a0,-1
    80003f9a:	b7fd                	j	80003f88 <pipealloc+0xc6>

0000000080003f9c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f9c:	1101                	addi	sp,sp,-32
    80003f9e:	ec06                	sd	ra,24(sp)
    80003fa0:	e822                	sd	s0,16(sp)
    80003fa2:	e426                	sd	s1,8(sp)
    80003fa4:	e04a                	sd	s2,0(sp)
    80003fa6:	1000                	addi	s0,sp,32
    80003fa8:	84aa                	mv	s1,a0
    80003faa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fac:	00002097          	auipc	ra,0x2
    80003fb0:	3b4080e7          	jalr	948(ra) # 80006360 <acquire>
  if(writable){
    80003fb4:	02090d63          	beqz	s2,80003fee <pipeclose+0x52>
    pi->writeopen = 0;
    80003fb8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fbc:	21848513          	addi	a0,s1,536
    80003fc0:	ffffd097          	auipc	ra,0xffffd
    80003fc4:	6e0080e7          	jalr	1760(ra) # 800016a0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003fc8:	2204b783          	ld	a5,544(s1)
    80003fcc:	eb95                	bnez	a5,80004000 <pipeclose+0x64>
    release(&pi->lock);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	00002097          	auipc	ra,0x2
    80003fd4:	444080e7          	jalr	1092(ra) # 80006414 <release>
    kfree((char*)pi);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	ffffc097          	auipc	ra,0xffffc
    80003fde:	042080e7          	jalr	66(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003fe2:	60e2                	ld	ra,24(sp)
    80003fe4:	6442                	ld	s0,16(sp)
    80003fe6:	64a2                	ld	s1,8(sp)
    80003fe8:	6902                	ld	s2,0(sp)
    80003fea:	6105                	addi	sp,sp,32
    80003fec:	8082                	ret
    pi->readopen = 0;
    80003fee:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ff2:	21c48513          	addi	a0,s1,540
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	6aa080e7          	jalr	1706(ra) # 800016a0 <wakeup>
    80003ffe:	b7e9                	j	80003fc8 <pipeclose+0x2c>
    release(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	412080e7          	jalr	1042(ra) # 80006414 <release>
}
    8000400a:	bfe1                	j	80003fe2 <pipeclose+0x46>

000000008000400c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000400c:	7159                	addi	sp,sp,-112
    8000400e:	f486                	sd	ra,104(sp)
    80004010:	f0a2                	sd	s0,96(sp)
    80004012:	eca6                	sd	s1,88(sp)
    80004014:	e8ca                	sd	s2,80(sp)
    80004016:	e4ce                	sd	s3,72(sp)
    80004018:	e0d2                	sd	s4,64(sp)
    8000401a:	fc56                	sd	s5,56(sp)
    8000401c:	f85a                	sd	s6,48(sp)
    8000401e:	f45e                	sd	s7,40(sp)
    80004020:	f062                	sd	s8,32(sp)
    80004022:	ec66                	sd	s9,24(sp)
    80004024:	1880                	addi	s0,sp,112
    80004026:	84aa                	mv	s1,a0
    80004028:	8aae                	mv	s5,a1
    8000402a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	e1c080e7          	jalr	-484(ra) # 80000e48 <myproc>
    80004034:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004036:	8526                	mv	a0,s1
    80004038:	00002097          	auipc	ra,0x2
    8000403c:	328080e7          	jalr	808(ra) # 80006360 <acquire>
  while(i < n){
    80004040:	0d405163          	blez	s4,80004102 <pipewrite+0xf6>
    80004044:	8ba6                	mv	s7,s1
  int i = 0;
    80004046:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004048:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000404a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000404e:	21c48c13          	addi	s8,s1,540
    80004052:	a08d                	j	800040b4 <pipewrite+0xa8>
      release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	3be080e7          	jalr	958(ra) # 80006414 <release>
      return -1;
    8000405e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004060:	854a                	mv	a0,s2
    80004062:	70a6                	ld	ra,104(sp)
    80004064:	7406                	ld	s0,96(sp)
    80004066:	64e6                	ld	s1,88(sp)
    80004068:	6946                	ld	s2,80(sp)
    8000406a:	69a6                	ld	s3,72(sp)
    8000406c:	6a06                	ld	s4,64(sp)
    8000406e:	7ae2                	ld	s5,56(sp)
    80004070:	7b42                	ld	s6,48(sp)
    80004072:	7ba2                	ld	s7,40(sp)
    80004074:	7c02                	ld	s8,32(sp)
    80004076:	6ce2                	ld	s9,24(sp)
    80004078:	6165                	addi	sp,sp,112
    8000407a:	8082                	ret
      wakeup(&pi->nread);
    8000407c:	8566                	mv	a0,s9
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	622080e7          	jalr	1570(ra) # 800016a0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004086:	85de                	mv	a1,s7
    80004088:	8562                	mv	a0,s8
    8000408a:	ffffd097          	auipc	ra,0xffffd
    8000408e:	48a080e7          	jalr	1162(ra) # 80001514 <sleep>
    80004092:	a839                	j	800040b0 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004094:	21c4a783          	lw	a5,540(s1)
    80004098:	0017871b          	addiw	a4,a5,1
    8000409c:	20e4ae23          	sw	a4,540(s1)
    800040a0:	1ff7f793          	andi	a5,a5,511
    800040a4:	97a6                	add	a5,a5,s1
    800040a6:	f9f44703          	lbu	a4,-97(s0)
    800040aa:	00e78c23          	sb	a4,24(a5)
      i++;
    800040ae:	2905                	addiw	s2,s2,1
  while(i < n){
    800040b0:	03495d63          	bge	s2,s4,800040ea <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    800040b4:	2204a783          	lw	a5,544(s1)
    800040b8:	dfd1                	beqz	a5,80004054 <pipewrite+0x48>
    800040ba:	0289a783          	lw	a5,40(s3)
    800040be:	fbd9                	bnez	a5,80004054 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040c0:	2184a783          	lw	a5,536(s1)
    800040c4:	21c4a703          	lw	a4,540(s1)
    800040c8:	2007879b          	addiw	a5,a5,512
    800040cc:	faf708e3          	beq	a4,a5,8000407c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040d0:	4685                	li	a3,1
    800040d2:	01590633          	add	a2,s2,s5
    800040d6:	f9f40593          	addi	a1,s0,-97
    800040da:	0609b503          	ld	a0,96(s3)
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	ab8080e7          	jalr	-1352(ra) # 80000b96 <copyin>
    800040e6:	fb6517e3          	bne	a0,s6,80004094 <pipewrite+0x88>
  wakeup(&pi->nread);
    800040ea:	21848513          	addi	a0,s1,536
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	5b2080e7          	jalr	1458(ra) # 800016a0 <wakeup>
  release(&pi->lock);
    800040f6:	8526                	mv	a0,s1
    800040f8:	00002097          	auipc	ra,0x2
    800040fc:	31c080e7          	jalr	796(ra) # 80006414 <release>
  return i;
    80004100:	b785                	j	80004060 <pipewrite+0x54>
  int i = 0;
    80004102:	4901                	li	s2,0
    80004104:	b7dd                	j	800040ea <pipewrite+0xde>

0000000080004106 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004106:	715d                	addi	sp,sp,-80
    80004108:	e486                	sd	ra,72(sp)
    8000410a:	e0a2                	sd	s0,64(sp)
    8000410c:	fc26                	sd	s1,56(sp)
    8000410e:	f84a                	sd	s2,48(sp)
    80004110:	f44e                	sd	s3,40(sp)
    80004112:	f052                	sd	s4,32(sp)
    80004114:	ec56                	sd	s5,24(sp)
    80004116:	e85a                	sd	s6,16(sp)
    80004118:	0880                	addi	s0,sp,80
    8000411a:	84aa                	mv	s1,a0
    8000411c:	892e                	mv	s2,a1
    8000411e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004120:	ffffd097          	auipc	ra,0xffffd
    80004124:	d28080e7          	jalr	-728(ra) # 80000e48 <myproc>
    80004128:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000412a:	8b26                	mv	s6,s1
    8000412c:	8526                	mv	a0,s1
    8000412e:	00002097          	auipc	ra,0x2
    80004132:	232080e7          	jalr	562(ra) # 80006360 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004136:	2184a703          	lw	a4,536(s1)
    8000413a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000413e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004142:	02f71463          	bne	a4,a5,8000416a <piperead+0x64>
    80004146:	2244a783          	lw	a5,548(s1)
    8000414a:	c385                	beqz	a5,8000416a <piperead+0x64>
    if(pr->killed){
    8000414c:	028a2783          	lw	a5,40(s4)
    80004150:	ebc1                	bnez	a5,800041e0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004152:	85da                	mv	a1,s6
    80004154:	854e                	mv	a0,s3
    80004156:	ffffd097          	auipc	ra,0xffffd
    8000415a:	3be080e7          	jalr	958(ra) # 80001514 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000415e:	2184a703          	lw	a4,536(s1)
    80004162:	21c4a783          	lw	a5,540(s1)
    80004166:	fef700e3          	beq	a4,a5,80004146 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416a:	09505263          	blez	s5,800041ee <piperead+0xe8>
    8000416e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004170:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004172:	2184a783          	lw	a5,536(s1)
    80004176:	21c4a703          	lw	a4,540(s1)
    8000417a:	02f70d63          	beq	a4,a5,800041b4 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000417e:	0017871b          	addiw	a4,a5,1
    80004182:	20e4ac23          	sw	a4,536(s1)
    80004186:	1ff7f793          	andi	a5,a5,511
    8000418a:	97a6                	add	a5,a5,s1
    8000418c:	0187c783          	lbu	a5,24(a5)
    80004190:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004194:	4685                	li	a3,1
    80004196:	fbf40613          	addi	a2,s0,-65
    8000419a:	85ca                	mv	a1,s2
    8000419c:	060a3503          	ld	a0,96(s4)
    800041a0:	ffffd097          	auipc	ra,0xffffd
    800041a4:	96a080e7          	jalr	-1686(ra) # 80000b0a <copyout>
    800041a8:	01650663          	beq	a0,s6,800041b4 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ac:	2985                	addiw	s3,s3,1
    800041ae:	0905                	addi	s2,s2,1
    800041b0:	fd3a91e3          	bne	s5,s3,80004172 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041b4:	21c48513          	addi	a0,s1,540
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	4e8080e7          	jalr	1256(ra) # 800016a0 <wakeup>
  release(&pi->lock);
    800041c0:	8526                	mv	a0,s1
    800041c2:	00002097          	auipc	ra,0x2
    800041c6:	252080e7          	jalr	594(ra) # 80006414 <release>
  return i;
}
    800041ca:	854e                	mv	a0,s3
    800041cc:	60a6                	ld	ra,72(sp)
    800041ce:	6406                	ld	s0,64(sp)
    800041d0:	74e2                	ld	s1,56(sp)
    800041d2:	7942                	ld	s2,48(sp)
    800041d4:	79a2                	ld	s3,40(sp)
    800041d6:	7a02                	ld	s4,32(sp)
    800041d8:	6ae2                	ld	s5,24(sp)
    800041da:	6b42                	ld	s6,16(sp)
    800041dc:	6161                	addi	sp,sp,80
    800041de:	8082                	ret
      release(&pi->lock);
    800041e0:	8526                	mv	a0,s1
    800041e2:	00002097          	auipc	ra,0x2
    800041e6:	232080e7          	jalr	562(ra) # 80006414 <release>
      return -1;
    800041ea:	59fd                	li	s3,-1
    800041ec:	bff9                	j	800041ca <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ee:	4981                	li	s3,0
    800041f0:	b7d1                	j	800041b4 <piperead+0xae>

00000000800041f2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800041f2:	df010113          	addi	sp,sp,-528
    800041f6:	20113423          	sd	ra,520(sp)
    800041fa:	20813023          	sd	s0,512(sp)
    800041fe:	ffa6                	sd	s1,504(sp)
    80004200:	fbca                	sd	s2,496(sp)
    80004202:	f7ce                	sd	s3,488(sp)
    80004204:	f3d2                	sd	s4,480(sp)
    80004206:	efd6                	sd	s5,472(sp)
    80004208:	ebda                	sd	s6,464(sp)
    8000420a:	e7de                	sd	s7,456(sp)
    8000420c:	e3e2                	sd	s8,448(sp)
    8000420e:	ff66                	sd	s9,440(sp)
    80004210:	fb6a                	sd	s10,432(sp)
    80004212:	f76e                	sd	s11,424(sp)
    80004214:	0c00                	addi	s0,sp,528
    80004216:	84aa                	mv	s1,a0
    80004218:	dea43c23          	sd	a0,-520(s0)
    8000421c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004220:	ffffd097          	auipc	ra,0xffffd
    80004224:	c28080e7          	jalr	-984(ra) # 80000e48 <myproc>
    80004228:	892a                	mv	s2,a0

  begin_op();
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	49c080e7          	jalr	1180(ra) # 800036c6 <begin_op>

  if((ip = namei(path)) == 0){
    80004232:	8526                	mv	a0,s1
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	276080e7          	jalr	630(ra) # 800034aa <namei>
    8000423c:	c92d                	beqz	a0,800042ae <exec+0xbc>
    8000423e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004240:	fffff097          	auipc	ra,0xfffff
    80004244:	ab4080e7          	jalr	-1356(ra) # 80002cf4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004248:	04000713          	li	a4,64
    8000424c:	4681                	li	a3,0
    8000424e:	e5040613          	addi	a2,s0,-432
    80004252:	4581                	li	a1,0
    80004254:	8526                	mv	a0,s1
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	d52080e7          	jalr	-686(ra) # 80002fa8 <readi>
    8000425e:	04000793          	li	a5,64
    80004262:	00f51a63          	bne	a0,a5,80004276 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004266:	e5042703          	lw	a4,-432(s0)
    8000426a:	464c47b7          	lui	a5,0x464c4
    8000426e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004272:	04f70463          	beq	a4,a5,800042ba <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004276:	8526                	mv	a0,s1
    80004278:	fffff097          	auipc	ra,0xfffff
    8000427c:	cde080e7          	jalr	-802(ra) # 80002f56 <iunlockput>
    end_op();
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	4c6080e7          	jalr	1222(ra) # 80003746 <end_op>
  }
  return -1;
    80004288:	557d                	li	a0,-1
}
    8000428a:	20813083          	ld	ra,520(sp)
    8000428e:	20013403          	ld	s0,512(sp)
    80004292:	74fe                	ld	s1,504(sp)
    80004294:	795e                	ld	s2,496(sp)
    80004296:	79be                	ld	s3,488(sp)
    80004298:	7a1e                	ld	s4,480(sp)
    8000429a:	6afe                	ld	s5,472(sp)
    8000429c:	6b5e                	ld	s6,464(sp)
    8000429e:	6bbe                	ld	s7,456(sp)
    800042a0:	6c1e                	ld	s8,448(sp)
    800042a2:	7cfa                	ld	s9,440(sp)
    800042a4:	7d5a                	ld	s10,432(sp)
    800042a6:	7dba                	ld	s11,424(sp)
    800042a8:	21010113          	addi	sp,sp,528
    800042ac:	8082                	ret
    end_op();
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	498080e7          	jalr	1176(ra) # 80003746 <end_op>
    return -1;
    800042b6:	557d                	li	a0,-1
    800042b8:	bfc9                	j	8000428a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042ba:	854a                	mv	a0,s2
    800042bc:	ffffd097          	auipc	ra,0xffffd
    800042c0:	c50080e7          	jalr	-944(ra) # 80000f0c <proc_pagetable>
    800042c4:	8baa                	mv	s7,a0
    800042c6:	d945                	beqz	a0,80004276 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042c8:	e7042983          	lw	s3,-400(s0)
    800042cc:	e8845783          	lhu	a5,-376(s0)
    800042d0:	c7ad                	beqz	a5,8000433a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042d4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800042d6:	6c85                	lui	s9,0x1
    800042d8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042dc:	def43823          	sd	a5,-528(s0)
    800042e0:	a42d                	j	8000450a <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042e2:	00004517          	auipc	a0,0x4
    800042e6:	37650513          	addi	a0,a0,886 # 80008658 <syscalls+0x290>
    800042ea:	00002097          	auipc	ra,0x2
    800042ee:	abe080e7          	jalr	-1346(ra) # 80005da8 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042f2:	8756                	mv	a4,s5
    800042f4:	012d86bb          	addw	a3,s11,s2
    800042f8:	4581                	li	a1,0
    800042fa:	8526                	mv	a0,s1
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	cac080e7          	jalr	-852(ra) # 80002fa8 <readi>
    80004304:	2501                	sext.w	a0,a0
    80004306:	1aaa9963          	bne	s5,a0,800044b8 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    8000430a:	6785                	lui	a5,0x1
    8000430c:	0127893b          	addw	s2,a5,s2
    80004310:	77fd                	lui	a5,0xfffff
    80004312:	01478a3b          	addw	s4,a5,s4
    80004316:	1f897163          	bgeu	s2,s8,800044f8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    8000431a:	02091593          	slli	a1,s2,0x20
    8000431e:	9181                	srli	a1,a1,0x20
    80004320:	95ea                	add	a1,a1,s10
    80004322:	855e                	mv	a0,s7
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	1e2080e7          	jalr	482(ra) # 80000506 <walkaddr>
    8000432c:	862a                	mv	a2,a0
    if(pa == 0)
    8000432e:	d955                	beqz	a0,800042e2 <exec+0xf0>
      n = PGSIZE;
    80004330:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004332:	fd9a70e3          	bgeu	s4,s9,800042f2 <exec+0x100>
      n = sz - i;
    80004336:	8ad2                	mv	s5,s4
    80004338:	bf6d                	j	800042f2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000433a:	4901                	li	s2,0
  iunlockput(ip);
    8000433c:	8526                	mv	a0,s1
    8000433e:	fffff097          	auipc	ra,0xfffff
    80004342:	c18080e7          	jalr	-1000(ra) # 80002f56 <iunlockput>
  end_op();
    80004346:	fffff097          	auipc	ra,0xfffff
    8000434a:	400080e7          	jalr	1024(ra) # 80003746 <end_op>
  p = myproc();
    8000434e:	ffffd097          	auipc	ra,0xffffd
    80004352:	afa080e7          	jalr	-1286(ra) # 80000e48 <myproc>
    80004356:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004358:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    8000435c:	6785                	lui	a5,0x1
    8000435e:	17fd                	addi	a5,a5,-1
    80004360:	993e                	add	s2,s2,a5
    80004362:	757d                	lui	a0,0xfffff
    80004364:	00a977b3          	and	a5,s2,a0
    80004368:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000436c:	6609                	lui	a2,0x2
    8000436e:	963e                	add	a2,a2,a5
    80004370:	85be                	mv	a1,a5
    80004372:	855e                	mv	a0,s7
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	546080e7          	jalr	1350(ra) # 800008ba <uvmalloc>
    8000437c:	8b2a                	mv	s6,a0
  ip = 0;
    8000437e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004380:	12050c63          	beqz	a0,800044b8 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004384:	75f9                	lui	a1,0xffffe
    80004386:	95aa                	add	a1,a1,a0
    80004388:	855e                	mv	a0,s7
    8000438a:	ffffc097          	auipc	ra,0xffffc
    8000438e:	74e080e7          	jalr	1870(ra) # 80000ad8 <uvmclear>
  stackbase = sp - PGSIZE;
    80004392:	7c7d                	lui	s8,0xfffff
    80004394:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004396:	e0043783          	ld	a5,-512(s0)
    8000439a:	6388                	ld	a0,0(a5)
    8000439c:	c535                	beqz	a0,80004408 <exec+0x216>
    8000439e:	e9040993          	addi	s3,s0,-368
    800043a2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043a6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800043a8:	ffffc097          	auipc	ra,0xffffc
    800043ac:	f54080e7          	jalr	-172(ra) # 800002fc <strlen>
    800043b0:	2505                	addiw	a0,a0,1
    800043b2:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043b6:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043ba:	13896363          	bltu	s2,s8,800044e0 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043be:	e0043d83          	ld	s11,-512(s0)
    800043c2:	000dba03          	ld	s4,0(s11)
    800043c6:	8552                	mv	a0,s4
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	f34080e7          	jalr	-204(ra) # 800002fc <strlen>
    800043d0:	0015069b          	addiw	a3,a0,1
    800043d4:	8652                	mv	a2,s4
    800043d6:	85ca                	mv	a1,s2
    800043d8:	855e                	mv	a0,s7
    800043da:	ffffc097          	auipc	ra,0xffffc
    800043de:	730080e7          	jalr	1840(ra) # 80000b0a <copyout>
    800043e2:	10054363          	bltz	a0,800044e8 <exec+0x2f6>
    ustack[argc] = sp;
    800043e6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043ea:	0485                	addi	s1,s1,1
    800043ec:	008d8793          	addi	a5,s11,8
    800043f0:	e0f43023          	sd	a5,-512(s0)
    800043f4:	008db503          	ld	a0,8(s11)
    800043f8:	c911                	beqz	a0,8000440c <exec+0x21a>
    if(argc >= MAXARG)
    800043fa:	09a1                	addi	s3,s3,8
    800043fc:	fb3c96e3          	bne	s9,s3,800043a8 <exec+0x1b6>
  sz = sz1;
    80004400:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004404:	4481                	li	s1,0
    80004406:	a84d                	j	800044b8 <exec+0x2c6>
  sp = sz;
    80004408:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000440a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000440c:	00349793          	slli	a5,s1,0x3
    80004410:	f9040713          	addi	a4,s0,-112
    80004414:	97ba                	add	a5,a5,a4
    80004416:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000441a:	00148693          	addi	a3,s1,1
    8000441e:	068e                	slli	a3,a3,0x3
    80004420:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004424:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004428:	01897663          	bgeu	s2,s8,80004434 <exec+0x242>
  sz = sz1;
    8000442c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004430:	4481                	li	s1,0
    80004432:	a059                	j	800044b8 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004434:	e9040613          	addi	a2,s0,-368
    80004438:	85ca                	mv	a1,s2
    8000443a:	855e                	mv	a0,s7
    8000443c:	ffffc097          	auipc	ra,0xffffc
    80004440:	6ce080e7          	jalr	1742(ra) # 80000b0a <copyout>
    80004444:	0a054663          	bltz	a0,800044f0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004448:	068ab783          	ld	a5,104(s5)
    8000444c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004450:	df843783          	ld	a5,-520(s0)
    80004454:	0007c703          	lbu	a4,0(a5)
    80004458:	cf11                	beqz	a4,80004474 <exec+0x282>
    8000445a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000445c:	02f00693          	li	a3,47
    80004460:	a039                	j	8000446e <exec+0x27c>
      last = s+1;
    80004462:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004466:	0785                	addi	a5,a5,1
    80004468:	fff7c703          	lbu	a4,-1(a5)
    8000446c:	c701                	beqz	a4,80004474 <exec+0x282>
    if(*s == '/')
    8000446e:	fed71ce3          	bne	a4,a3,80004466 <exec+0x274>
    80004472:	bfc5                	j	80004462 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004474:	4641                	li	a2,16
    80004476:	df843583          	ld	a1,-520(s0)
    8000447a:	168a8513          	addi	a0,s5,360
    8000447e:	ffffc097          	auipc	ra,0xffffc
    80004482:	e4c080e7          	jalr	-436(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004486:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    8000448a:	077ab023          	sd	s7,96(s5)
  p->sz = sz;
    8000448e:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004492:	068ab783          	ld	a5,104(s5)
    80004496:	e6843703          	ld	a4,-408(s0)
    8000449a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000449c:	068ab783          	ld	a5,104(s5)
    800044a0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044a4:	85ea                	mv	a1,s10
    800044a6:	ffffd097          	auipc	ra,0xffffd
    800044aa:	b02080e7          	jalr	-1278(ra) # 80000fa8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044ae:	0004851b          	sext.w	a0,s1
    800044b2:	bbe1                	j	8000428a <exec+0x98>
    800044b4:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044b8:	e0843583          	ld	a1,-504(s0)
    800044bc:	855e                	mv	a0,s7
    800044be:	ffffd097          	auipc	ra,0xffffd
    800044c2:	aea080e7          	jalr	-1302(ra) # 80000fa8 <proc_freepagetable>
  if(ip){
    800044c6:	da0498e3          	bnez	s1,80004276 <exec+0x84>
  return -1;
    800044ca:	557d                	li	a0,-1
    800044cc:	bb7d                	j	8000428a <exec+0x98>
    800044ce:	e1243423          	sd	s2,-504(s0)
    800044d2:	b7dd                	j	800044b8 <exec+0x2c6>
    800044d4:	e1243423          	sd	s2,-504(s0)
    800044d8:	b7c5                	j	800044b8 <exec+0x2c6>
    800044da:	e1243423          	sd	s2,-504(s0)
    800044de:	bfe9                	j	800044b8 <exec+0x2c6>
  sz = sz1;
    800044e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e4:	4481                	li	s1,0
    800044e6:	bfc9                	j	800044b8 <exec+0x2c6>
  sz = sz1;
    800044e8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ec:	4481                	li	s1,0
    800044ee:	b7e9                	j	800044b8 <exec+0x2c6>
  sz = sz1;
    800044f0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044f4:	4481                	li	s1,0
    800044f6:	b7c9                	j	800044b8 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800044f8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044fc:	2b05                	addiw	s6,s6,1
    800044fe:	0389899b          	addiw	s3,s3,56
    80004502:	e8845783          	lhu	a5,-376(s0)
    80004506:	e2fb5be3          	bge	s6,a5,8000433c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000450a:	2981                	sext.w	s3,s3
    8000450c:	03800713          	li	a4,56
    80004510:	86ce                	mv	a3,s3
    80004512:	e1840613          	addi	a2,s0,-488
    80004516:	4581                	li	a1,0
    80004518:	8526                	mv	a0,s1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	a8e080e7          	jalr	-1394(ra) # 80002fa8 <readi>
    80004522:	03800793          	li	a5,56
    80004526:	f8f517e3          	bne	a0,a5,800044b4 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000452a:	e1842783          	lw	a5,-488(s0)
    8000452e:	4705                	li	a4,1
    80004530:	fce796e3          	bne	a5,a4,800044fc <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004534:	e4043603          	ld	a2,-448(s0)
    80004538:	e3843783          	ld	a5,-456(s0)
    8000453c:	f8f669e3          	bltu	a2,a5,800044ce <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004540:	e2843783          	ld	a5,-472(s0)
    80004544:	963e                	add	a2,a2,a5
    80004546:	f8f667e3          	bltu	a2,a5,800044d4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000454a:	85ca                	mv	a1,s2
    8000454c:	855e                	mv	a0,s7
    8000454e:	ffffc097          	auipc	ra,0xffffc
    80004552:	36c080e7          	jalr	876(ra) # 800008ba <uvmalloc>
    80004556:	e0a43423          	sd	a0,-504(s0)
    8000455a:	d141                	beqz	a0,800044da <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000455c:	e2843d03          	ld	s10,-472(s0)
    80004560:	df043783          	ld	a5,-528(s0)
    80004564:	00fd77b3          	and	a5,s10,a5
    80004568:	fba1                	bnez	a5,800044b8 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000456a:	e2042d83          	lw	s11,-480(s0)
    8000456e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004572:	f80c03e3          	beqz	s8,800044f8 <exec+0x306>
    80004576:	8a62                	mv	s4,s8
    80004578:	4901                	li	s2,0
    8000457a:	b345                	j	8000431a <exec+0x128>

000000008000457c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000457c:	7179                	addi	sp,sp,-48
    8000457e:	f406                	sd	ra,40(sp)
    80004580:	f022                	sd	s0,32(sp)
    80004582:	ec26                	sd	s1,24(sp)
    80004584:	e84a                	sd	s2,16(sp)
    80004586:	1800                	addi	s0,sp,48
    80004588:	892e                	mv	s2,a1
    8000458a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000458c:	fdc40593          	addi	a1,s0,-36
    80004590:	ffffe097          	auipc	ra,0xffffe
    80004594:	a64080e7          	jalr	-1436(ra) # 80001ff4 <argint>
    80004598:	04054063          	bltz	a0,800045d8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000459c:	fdc42703          	lw	a4,-36(s0)
    800045a0:	47bd                	li	a5,15
    800045a2:	02e7ed63          	bltu	a5,a4,800045dc <argfd+0x60>
    800045a6:	ffffd097          	auipc	ra,0xffffd
    800045aa:	8a2080e7          	jalr	-1886(ra) # 80000e48 <myproc>
    800045ae:	fdc42703          	lw	a4,-36(s0)
    800045b2:	01c70793          	addi	a5,a4,28
    800045b6:	078e                	slli	a5,a5,0x3
    800045b8:	953e                	add	a0,a0,a5
    800045ba:	611c                	ld	a5,0(a0)
    800045bc:	c395                	beqz	a5,800045e0 <argfd+0x64>
    return -1;
  if(pfd)
    800045be:	00090463          	beqz	s2,800045c6 <argfd+0x4a>
    *pfd = fd;
    800045c2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800045c6:	4501                	li	a0,0
  if(pf)
    800045c8:	c091                	beqz	s1,800045cc <argfd+0x50>
    *pf = f;
    800045ca:	e09c                	sd	a5,0(s1)
}
    800045cc:	70a2                	ld	ra,40(sp)
    800045ce:	7402                	ld	s0,32(sp)
    800045d0:	64e2                	ld	s1,24(sp)
    800045d2:	6942                	ld	s2,16(sp)
    800045d4:	6145                	addi	sp,sp,48
    800045d6:	8082                	ret
    return -1;
    800045d8:	557d                	li	a0,-1
    800045da:	bfcd                	j	800045cc <argfd+0x50>
    return -1;
    800045dc:	557d                	li	a0,-1
    800045de:	b7fd                	j	800045cc <argfd+0x50>
    800045e0:	557d                	li	a0,-1
    800045e2:	b7ed                	j	800045cc <argfd+0x50>

00000000800045e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045e4:	1101                	addi	sp,sp,-32
    800045e6:	ec06                	sd	ra,24(sp)
    800045e8:	e822                	sd	s0,16(sp)
    800045ea:	e426                	sd	s1,8(sp)
    800045ec:	1000                	addi	s0,sp,32
    800045ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045f0:	ffffd097          	auipc	ra,0xffffd
    800045f4:	858080e7          	jalr	-1960(ra) # 80000e48 <myproc>
    800045f8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045fa:	0e050793          	addi	a5,a0,224 # fffffffffffff0e0 <end+0xffffffff7ffd4ea0>
    800045fe:	4501                	li	a0,0
    80004600:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004602:	6398                	ld	a4,0(a5)
    80004604:	cb19                	beqz	a4,8000461a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004606:	2505                	addiw	a0,a0,1
    80004608:	07a1                	addi	a5,a5,8
    8000460a:	fed51ce3          	bne	a0,a3,80004602 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000460e:	557d                	li	a0,-1
}
    80004610:	60e2                	ld	ra,24(sp)
    80004612:	6442                	ld	s0,16(sp)
    80004614:	64a2                	ld	s1,8(sp)
    80004616:	6105                	addi	sp,sp,32
    80004618:	8082                	ret
      p->ofile[fd] = f;
    8000461a:	01c50793          	addi	a5,a0,28
    8000461e:	078e                	slli	a5,a5,0x3
    80004620:	963e                	add	a2,a2,a5
    80004622:	e204                	sd	s1,0(a2)
      return fd;
    80004624:	b7f5                	j	80004610 <fdalloc+0x2c>

0000000080004626 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004626:	715d                	addi	sp,sp,-80
    80004628:	e486                	sd	ra,72(sp)
    8000462a:	e0a2                	sd	s0,64(sp)
    8000462c:	fc26                	sd	s1,56(sp)
    8000462e:	f84a                	sd	s2,48(sp)
    80004630:	f44e                	sd	s3,40(sp)
    80004632:	f052                	sd	s4,32(sp)
    80004634:	ec56                	sd	s5,24(sp)
    80004636:	0880                	addi	s0,sp,80
    80004638:	89ae                	mv	s3,a1
    8000463a:	8ab2                	mv	s5,a2
    8000463c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000463e:	fb040593          	addi	a1,s0,-80
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	e86080e7          	jalr	-378(ra) # 800034c8 <nameiparent>
    8000464a:	892a                	mv	s2,a0
    8000464c:	12050f63          	beqz	a0,8000478a <create+0x164>
    return 0;

  ilock(dp);
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	6a4080e7          	jalr	1700(ra) # 80002cf4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004658:	4601                	li	a2,0
    8000465a:	fb040593          	addi	a1,s0,-80
    8000465e:	854a                	mv	a0,s2
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	b78080e7          	jalr	-1160(ra) # 800031d8 <dirlookup>
    80004668:	84aa                	mv	s1,a0
    8000466a:	c921                	beqz	a0,800046ba <create+0x94>
    iunlockput(dp);
    8000466c:	854a                	mv	a0,s2
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	8e8080e7          	jalr	-1816(ra) # 80002f56 <iunlockput>
    ilock(ip);
    80004676:	8526                	mv	a0,s1
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	67c080e7          	jalr	1660(ra) # 80002cf4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004680:	2981                	sext.w	s3,s3
    80004682:	4789                	li	a5,2
    80004684:	02f99463          	bne	s3,a5,800046ac <create+0x86>
    80004688:	0444d783          	lhu	a5,68(s1)
    8000468c:	37f9                	addiw	a5,a5,-2
    8000468e:	17c2                	slli	a5,a5,0x30
    80004690:	93c1                	srli	a5,a5,0x30
    80004692:	4705                	li	a4,1
    80004694:	00f76c63          	bltu	a4,a5,800046ac <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004698:	8526                	mv	a0,s1
    8000469a:	60a6                	ld	ra,72(sp)
    8000469c:	6406                	ld	s0,64(sp)
    8000469e:	74e2                	ld	s1,56(sp)
    800046a0:	7942                	ld	s2,48(sp)
    800046a2:	79a2                	ld	s3,40(sp)
    800046a4:	7a02                	ld	s4,32(sp)
    800046a6:	6ae2                	ld	s5,24(sp)
    800046a8:	6161                	addi	sp,sp,80
    800046aa:	8082                	ret
    iunlockput(ip);
    800046ac:	8526                	mv	a0,s1
    800046ae:	fffff097          	auipc	ra,0xfffff
    800046b2:	8a8080e7          	jalr	-1880(ra) # 80002f56 <iunlockput>
    return 0;
    800046b6:	4481                	li	s1,0
    800046b8:	b7c5                	j	80004698 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800046ba:	85ce                	mv	a1,s3
    800046bc:	00092503          	lw	a0,0(s2)
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	49c080e7          	jalr	1180(ra) # 80002b5c <ialloc>
    800046c8:	84aa                	mv	s1,a0
    800046ca:	c529                	beqz	a0,80004714 <create+0xee>
  ilock(ip);
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	628080e7          	jalr	1576(ra) # 80002cf4 <ilock>
  ip->major = major;
    800046d4:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    800046d8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800046dc:	4785                	li	a5,1
    800046de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800046e2:	8526                	mv	a0,s1
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	546080e7          	jalr	1350(ra) # 80002c2a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046ec:	2981                	sext.w	s3,s3
    800046ee:	4785                	li	a5,1
    800046f0:	02f98a63          	beq	s3,a5,80004724 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800046f4:	40d0                	lw	a2,4(s1)
    800046f6:	fb040593          	addi	a1,s0,-80
    800046fa:	854a                	mv	a0,s2
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	cec080e7          	jalr	-788(ra) # 800033e8 <dirlink>
    80004704:	06054b63          	bltz	a0,8000477a <create+0x154>
  iunlockput(dp);
    80004708:	854a                	mv	a0,s2
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	84c080e7          	jalr	-1972(ra) # 80002f56 <iunlockput>
  return ip;
    80004712:	b759                	j	80004698 <create+0x72>
    panic("create: ialloc");
    80004714:	00004517          	auipc	a0,0x4
    80004718:	f6450513          	addi	a0,a0,-156 # 80008678 <syscalls+0x2b0>
    8000471c:	00001097          	auipc	ra,0x1
    80004720:	68c080e7          	jalr	1676(ra) # 80005da8 <panic>
    dp->nlink++;  // for ".."
    80004724:	04a95783          	lhu	a5,74(s2)
    80004728:	2785                	addiw	a5,a5,1
    8000472a:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000472e:	854a                	mv	a0,s2
    80004730:	ffffe097          	auipc	ra,0xffffe
    80004734:	4fa080e7          	jalr	1274(ra) # 80002c2a <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004738:	40d0                	lw	a2,4(s1)
    8000473a:	00004597          	auipc	a1,0x4
    8000473e:	f4e58593          	addi	a1,a1,-178 # 80008688 <syscalls+0x2c0>
    80004742:	8526                	mv	a0,s1
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	ca4080e7          	jalr	-860(ra) # 800033e8 <dirlink>
    8000474c:	00054f63          	bltz	a0,8000476a <create+0x144>
    80004750:	00492603          	lw	a2,4(s2)
    80004754:	00004597          	auipc	a1,0x4
    80004758:	f3c58593          	addi	a1,a1,-196 # 80008690 <syscalls+0x2c8>
    8000475c:	8526                	mv	a0,s1
    8000475e:	fffff097          	auipc	ra,0xfffff
    80004762:	c8a080e7          	jalr	-886(ra) # 800033e8 <dirlink>
    80004766:	f80557e3          	bgez	a0,800046f4 <create+0xce>
      panic("create dots");
    8000476a:	00004517          	auipc	a0,0x4
    8000476e:	f2e50513          	addi	a0,a0,-210 # 80008698 <syscalls+0x2d0>
    80004772:	00001097          	auipc	ra,0x1
    80004776:	636080e7          	jalr	1590(ra) # 80005da8 <panic>
    panic("create: dirlink");
    8000477a:	00004517          	auipc	a0,0x4
    8000477e:	f2e50513          	addi	a0,a0,-210 # 800086a8 <syscalls+0x2e0>
    80004782:	00001097          	auipc	ra,0x1
    80004786:	626080e7          	jalr	1574(ra) # 80005da8 <panic>
    return 0;
    8000478a:	84aa                	mv	s1,a0
    8000478c:	b731                	j	80004698 <create+0x72>

000000008000478e <sys_dup>:
{
    8000478e:	7179                	addi	sp,sp,-48
    80004790:	f406                	sd	ra,40(sp)
    80004792:	f022                	sd	s0,32(sp)
    80004794:	ec26                	sd	s1,24(sp)
    80004796:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004798:	fd840613          	addi	a2,s0,-40
    8000479c:	4581                	li	a1,0
    8000479e:	4501                	li	a0,0
    800047a0:	00000097          	auipc	ra,0x0
    800047a4:	ddc080e7          	jalr	-548(ra) # 8000457c <argfd>
    return -1;
    800047a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800047aa:	02054363          	bltz	a0,800047d0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800047ae:	fd843503          	ld	a0,-40(s0)
    800047b2:	00000097          	auipc	ra,0x0
    800047b6:	e32080e7          	jalr	-462(ra) # 800045e4 <fdalloc>
    800047ba:	84aa                	mv	s1,a0
    return -1;
    800047bc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047be:	00054963          	bltz	a0,800047d0 <sys_dup+0x42>
  filedup(f);
    800047c2:	fd843503          	ld	a0,-40(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	37a080e7          	jalr	890(ra) # 80003b40 <filedup>
  return fd;
    800047ce:	87a6                	mv	a5,s1
}
    800047d0:	853e                	mv	a0,a5
    800047d2:	70a2                	ld	ra,40(sp)
    800047d4:	7402                	ld	s0,32(sp)
    800047d6:	64e2                	ld	s1,24(sp)
    800047d8:	6145                	addi	sp,sp,48
    800047da:	8082                	ret

00000000800047dc <sys_read>:
{
    800047dc:	7179                	addi	sp,sp,-48
    800047de:	f406                	sd	ra,40(sp)
    800047e0:	f022                	sd	s0,32(sp)
    800047e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e4:	fe840613          	addi	a2,s0,-24
    800047e8:	4581                	li	a1,0
    800047ea:	4501                	li	a0,0
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	d90080e7          	jalr	-624(ra) # 8000457c <argfd>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f6:	04054163          	bltz	a0,80004838 <sys_read+0x5c>
    800047fa:	fe440593          	addi	a1,s0,-28
    800047fe:	4509                	li	a0,2
    80004800:	ffffd097          	auipc	ra,0xffffd
    80004804:	7f4080e7          	jalr	2036(ra) # 80001ff4 <argint>
    return -1;
    80004808:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480a:	02054763          	bltz	a0,80004838 <sys_read+0x5c>
    8000480e:	fd840593          	addi	a1,s0,-40
    80004812:	4505                	li	a0,1
    80004814:	ffffe097          	auipc	ra,0xffffe
    80004818:	802080e7          	jalr	-2046(ra) # 80002016 <argaddr>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481e:	00054d63          	bltz	a0,80004838 <sys_read+0x5c>
  return fileread(f, p, n);
    80004822:	fe442603          	lw	a2,-28(s0)
    80004826:	fd843583          	ld	a1,-40(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	49e080e7          	jalr	1182(ra) # 80003ccc <fileread>
    80004836:	87aa                	mv	a5,a0
}
    80004838:	853e                	mv	a0,a5
    8000483a:	70a2                	ld	ra,40(sp)
    8000483c:	7402                	ld	s0,32(sp)
    8000483e:	6145                	addi	sp,sp,48
    80004840:	8082                	ret

0000000080004842 <sys_write>:
{
    80004842:	7179                	addi	sp,sp,-48
    80004844:	f406                	sd	ra,40(sp)
    80004846:	f022                	sd	s0,32(sp)
    80004848:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000484a:	fe840613          	addi	a2,s0,-24
    8000484e:	4581                	li	a1,0
    80004850:	4501                	li	a0,0
    80004852:	00000097          	auipc	ra,0x0
    80004856:	d2a080e7          	jalr	-726(ra) # 8000457c <argfd>
    return -1;
    8000485a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000485c:	04054163          	bltz	a0,8000489e <sys_write+0x5c>
    80004860:	fe440593          	addi	a1,s0,-28
    80004864:	4509                	li	a0,2
    80004866:	ffffd097          	auipc	ra,0xffffd
    8000486a:	78e080e7          	jalr	1934(ra) # 80001ff4 <argint>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004870:	02054763          	bltz	a0,8000489e <sys_write+0x5c>
    80004874:	fd840593          	addi	a1,s0,-40
    80004878:	4505                	li	a0,1
    8000487a:	ffffd097          	auipc	ra,0xffffd
    8000487e:	79c080e7          	jalr	1948(ra) # 80002016 <argaddr>
    return -1;
    80004882:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004884:	00054d63          	bltz	a0,8000489e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004888:	fe442603          	lw	a2,-28(s0)
    8000488c:	fd843583          	ld	a1,-40(s0)
    80004890:	fe843503          	ld	a0,-24(s0)
    80004894:	fffff097          	auipc	ra,0xfffff
    80004898:	4fa080e7          	jalr	1274(ra) # 80003d8e <filewrite>
    8000489c:	87aa                	mv	a5,a0
}
    8000489e:	853e                	mv	a0,a5
    800048a0:	70a2                	ld	ra,40(sp)
    800048a2:	7402                	ld	s0,32(sp)
    800048a4:	6145                	addi	sp,sp,48
    800048a6:	8082                	ret

00000000800048a8 <sys_close>:
{
    800048a8:	1101                	addi	sp,sp,-32
    800048aa:	ec06                	sd	ra,24(sp)
    800048ac:	e822                	sd	s0,16(sp)
    800048ae:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800048b0:	fe040613          	addi	a2,s0,-32
    800048b4:	fec40593          	addi	a1,s0,-20
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	cc2080e7          	jalr	-830(ra) # 8000457c <argfd>
    return -1;
    800048c2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800048c4:	02054463          	bltz	a0,800048ec <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800048c8:	ffffc097          	auipc	ra,0xffffc
    800048cc:	580080e7          	jalr	1408(ra) # 80000e48 <myproc>
    800048d0:	fec42783          	lw	a5,-20(s0)
    800048d4:	07f1                	addi	a5,a5,28
    800048d6:	078e                	slli	a5,a5,0x3
    800048d8:	97aa                	add	a5,a5,a0
    800048da:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800048de:	fe043503          	ld	a0,-32(s0)
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	2b0080e7          	jalr	688(ra) # 80003b92 <fileclose>
  return 0;
    800048ea:	4781                	li	a5,0
}
    800048ec:	853e                	mv	a0,a5
    800048ee:	60e2                	ld	ra,24(sp)
    800048f0:	6442                	ld	s0,16(sp)
    800048f2:	6105                	addi	sp,sp,32
    800048f4:	8082                	ret

00000000800048f6 <sys_fstat>:
{
    800048f6:	1101                	addi	sp,sp,-32
    800048f8:	ec06                	sd	ra,24(sp)
    800048fa:	e822                	sd	s0,16(sp)
    800048fc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048fe:	fe840613          	addi	a2,s0,-24
    80004902:	4581                	li	a1,0
    80004904:	4501                	li	a0,0
    80004906:	00000097          	auipc	ra,0x0
    8000490a:	c76080e7          	jalr	-906(ra) # 8000457c <argfd>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004910:	02054563          	bltz	a0,8000493a <sys_fstat+0x44>
    80004914:	fe040593          	addi	a1,s0,-32
    80004918:	4505                	li	a0,1
    8000491a:	ffffd097          	auipc	ra,0xffffd
    8000491e:	6fc080e7          	jalr	1788(ra) # 80002016 <argaddr>
    return -1;
    80004922:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004924:	00054b63          	bltz	a0,8000493a <sys_fstat+0x44>
  return filestat(f, st);
    80004928:	fe043583          	ld	a1,-32(s0)
    8000492c:	fe843503          	ld	a0,-24(s0)
    80004930:	fffff097          	auipc	ra,0xfffff
    80004934:	32a080e7          	jalr	810(ra) # 80003c5a <filestat>
    80004938:	87aa                	mv	a5,a0
}
    8000493a:	853e                	mv	a0,a5
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	6105                	addi	sp,sp,32
    80004942:	8082                	ret

0000000080004944 <sys_link>:
{
    80004944:	7169                	addi	sp,sp,-304
    80004946:	f606                	sd	ra,296(sp)
    80004948:	f222                	sd	s0,288(sp)
    8000494a:	ee26                	sd	s1,280(sp)
    8000494c:	ea4a                	sd	s2,272(sp)
    8000494e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004950:	08000613          	li	a2,128
    80004954:	ed040593          	addi	a1,s0,-304
    80004958:	4501                	li	a0,0
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	6de080e7          	jalr	1758(ra) # 80002038 <argstr>
    return -1;
    80004962:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004964:	10054e63          	bltz	a0,80004a80 <sys_link+0x13c>
    80004968:	08000613          	li	a2,128
    8000496c:	f5040593          	addi	a1,s0,-176
    80004970:	4505                	li	a0,1
    80004972:	ffffd097          	auipc	ra,0xffffd
    80004976:	6c6080e7          	jalr	1734(ra) # 80002038 <argstr>
    return -1;
    8000497a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000497c:	10054263          	bltz	a0,80004a80 <sys_link+0x13c>
  begin_op();
    80004980:	fffff097          	auipc	ra,0xfffff
    80004984:	d46080e7          	jalr	-698(ra) # 800036c6 <begin_op>
  if((ip = namei(old)) == 0){
    80004988:	ed040513          	addi	a0,s0,-304
    8000498c:	fffff097          	auipc	ra,0xfffff
    80004990:	b1e080e7          	jalr	-1250(ra) # 800034aa <namei>
    80004994:	84aa                	mv	s1,a0
    80004996:	c551                	beqz	a0,80004a22 <sys_link+0xde>
  ilock(ip);
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	35c080e7          	jalr	860(ra) # 80002cf4 <ilock>
  if(ip->type == T_DIR){
    800049a0:	04449703          	lh	a4,68(s1)
    800049a4:	4785                	li	a5,1
    800049a6:	08f70463          	beq	a4,a5,80004a2e <sys_link+0xea>
  ip->nlink++;
    800049aa:	04a4d783          	lhu	a5,74(s1)
    800049ae:	2785                	addiw	a5,a5,1
    800049b0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	274080e7          	jalr	628(ra) # 80002c2a <iupdate>
  iunlock(ip);
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	3f6080e7          	jalr	1014(ra) # 80002db6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800049c8:	fd040593          	addi	a1,s0,-48
    800049cc:	f5040513          	addi	a0,s0,-176
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	af8080e7          	jalr	-1288(ra) # 800034c8 <nameiparent>
    800049d8:	892a                	mv	s2,a0
    800049da:	c935                	beqz	a0,80004a4e <sys_link+0x10a>
  ilock(dp);
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	318080e7          	jalr	792(ra) # 80002cf4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049e4:	00092703          	lw	a4,0(s2)
    800049e8:	409c                	lw	a5,0(s1)
    800049ea:	04f71d63          	bne	a4,a5,80004a44 <sys_link+0x100>
    800049ee:	40d0                	lw	a2,4(s1)
    800049f0:	fd040593          	addi	a1,s0,-48
    800049f4:	854a                	mv	a0,s2
    800049f6:	fffff097          	auipc	ra,0xfffff
    800049fa:	9f2080e7          	jalr	-1550(ra) # 800033e8 <dirlink>
    800049fe:	04054363          	bltz	a0,80004a44 <sys_link+0x100>
  iunlockput(dp);
    80004a02:	854a                	mv	a0,s2
    80004a04:	ffffe097          	auipc	ra,0xffffe
    80004a08:	552080e7          	jalr	1362(ra) # 80002f56 <iunlockput>
  iput(ip);
    80004a0c:	8526                	mv	a0,s1
    80004a0e:	ffffe097          	auipc	ra,0xffffe
    80004a12:	4a0080e7          	jalr	1184(ra) # 80002eae <iput>
  end_op();
    80004a16:	fffff097          	auipc	ra,0xfffff
    80004a1a:	d30080e7          	jalr	-720(ra) # 80003746 <end_op>
  return 0;
    80004a1e:	4781                	li	a5,0
    80004a20:	a085                	j	80004a80 <sys_link+0x13c>
    end_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	d24080e7          	jalr	-732(ra) # 80003746 <end_op>
    return -1;
    80004a2a:	57fd                	li	a5,-1
    80004a2c:	a891                	j	80004a80 <sys_link+0x13c>
    iunlockput(ip);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	526080e7          	jalr	1318(ra) # 80002f56 <iunlockput>
    end_op();
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	d0e080e7          	jalr	-754(ra) # 80003746 <end_op>
    return -1;
    80004a40:	57fd                	li	a5,-1
    80004a42:	a83d                	j	80004a80 <sys_link+0x13c>
    iunlockput(dp);
    80004a44:	854a                	mv	a0,s2
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	510080e7          	jalr	1296(ra) # 80002f56 <iunlockput>
  ilock(ip);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	2a4080e7          	jalr	676(ra) # 80002cf4 <ilock>
  ip->nlink--;
    80004a58:	04a4d783          	lhu	a5,74(s1)
    80004a5c:	37fd                	addiw	a5,a5,-1
    80004a5e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	1c6080e7          	jalr	454(ra) # 80002c2a <iupdate>
  iunlockput(ip);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	4e8080e7          	jalr	1256(ra) # 80002f56 <iunlockput>
  end_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	cd0080e7          	jalr	-816(ra) # 80003746 <end_op>
  return -1;
    80004a7e:	57fd                	li	a5,-1
}
    80004a80:	853e                	mv	a0,a5
    80004a82:	70b2                	ld	ra,296(sp)
    80004a84:	7412                	ld	s0,288(sp)
    80004a86:	64f2                	ld	s1,280(sp)
    80004a88:	6952                	ld	s2,272(sp)
    80004a8a:	6155                	addi	sp,sp,304
    80004a8c:	8082                	ret

0000000080004a8e <sys_unlink>:
{
    80004a8e:	7151                	addi	sp,sp,-240
    80004a90:	f586                	sd	ra,232(sp)
    80004a92:	f1a2                	sd	s0,224(sp)
    80004a94:	eda6                	sd	s1,216(sp)
    80004a96:	e9ca                	sd	s2,208(sp)
    80004a98:	e5ce                	sd	s3,200(sp)
    80004a9a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a9c:	08000613          	li	a2,128
    80004aa0:	f3040593          	addi	a1,s0,-208
    80004aa4:	4501                	li	a0,0
    80004aa6:	ffffd097          	auipc	ra,0xffffd
    80004aaa:	592080e7          	jalr	1426(ra) # 80002038 <argstr>
    80004aae:	18054163          	bltz	a0,80004c30 <sys_unlink+0x1a2>
  begin_op();
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	c14080e7          	jalr	-1004(ra) # 800036c6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004aba:	fb040593          	addi	a1,s0,-80
    80004abe:	f3040513          	addi	a0,s0,-208
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	a06080e7          	jalr	-1530(ra) # 800034c8 <nameiparent>
    80004aca:	84aa                	mv	s1,a0
    80004acc:	c979                	beqz	a0,80004ba2 <sys_unlink+0x114>
  ilock(dp);
    80004ace:	ffffe097          	auipc	ra,0xffffe
    80004ad2:	226080e7          	jalr	550(ra) # 80002cf4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad6:	00004597          	auipc	a1,0x4
    80004ada:	bb258593          	addi	a1,a1,-1102 # 80008688 <syscalls+0x2c0>
    80004ade:	fb040513          	addi	a0,s0,-80
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	6dc080e7          	jalr	1756(ra) # 800031be <namecmp>
    80004aea:	14050a63          	beqz	a0,80004c3e <sys_unlink+0x1b0>
    80004aee:	00004597          	auipc	a1,0x4
    80004af2:	ba258593          	addi	a1,a1,-1118 # 80008690 <syscalls+0x2c8>
    80004af6:	fb040513          	addi	a0,s0,-80
    80004afa:	ffffe097          	auipc	ra,0xffffe
    80004afe:	6c4080e7          	jalr	1732(ra) # 800031be <namecmp>
    80004b02:	12050e63          	beqz	a0,80004c3e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b06:	f2c40613          	addi	a2,s0,-212
    80004b0a:	fb040593          	addi	a1,s0,-80
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	6c8080e7          	jalr	1736(ra) # 800031d8 <dirlookup>
    80004b18:	892a                	mv	s2,a0
    80004b1a:	12050263          	beqz	a0,80004c3e <sys_unlink+0x1b0>
  ilock(ip);
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	1d6080e7          	jalr	470(ra) # 80002cf4 <ilock>
  if(ip->nlink < 1)
    80004b26:	04a91783          	lh	a5,74(s2)
    80004b2a:	08f05263          	blez	a5,80004bae <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004b2e:	04491703          	lh	a4,68(s2)
    80004b32:	4785                	li	a5,1
    80004b34:	08f70563          	beq	a4,a5,80004bbe <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b38:	4641                	li	a2,16
    80004b3a:	4581                	li	a1,0
    80004b3c:	fc040513          	addi	a0,s0,-64
    80004b40:	ffffb097          	auipc	ra,0xffffb
    80004b44:	638080e7          	jalr	1592(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b48:	4741                	li	a4,16
    80004b4a:	f2c42683          	lw	a3,-212(s0)
    80004b4e:	fc040613          	addi	a2,s0,-64
    80004b52:	4581                	li	a1,0
    80004b54:	8526                	mv	a0,s1
    80004b56:	ffffe097          	auipc	ra,0xffffe
    80004b5a:	54a080e7          	jalr	1354(ra) # 800030a0 <writei>
    80004b5e:	47c1                	li	a5,16
    80004b60:	0af51563          	bne	a0,a5,80004c0a <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b64:	04491703          	lh	a4,68(s2)
    80004b68:	4785                	li	a5,1
    80004b6a:	0af70863          	beq	a4,a5,80004c1a <sys_unlink+0x18c>
  iunlockput(dp);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	3e6080e7          	jalr	998(ra) # 80002f56 <iunlockput>
  ip->nlink--;
    80004b78:	04a95783          	lhu	a5,74(s2)
    80004b7c:	37fd                	addiw	a5,a5,-1
    80004b7e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b82:	854a                	mv	a0,s2
    80004b84:	ffffe097          	auipc	ra,0xffffe
    80004b88:	0a6080e7          	jalr	166(ra) # 80002c2a <iupdate>
  iunlockput(ip);
    80004b8c:	854a                	mv	a0,s2
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	3c8080e7          	jalr	968(ra) # 80002f56 <iunlockput>
  end_op();
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	bb0080e7          	jalr	-1104(ra) # 80003746 <end_op>
  return 0;
    80004b9e:	4501                	li	a0,0
    80004ba0:	a84d                	j	80004c52 <sys_unlink+0x1c4>
    end_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	ba4080e7          	jalr	-1116(ra) # 80003746 <end_op>
    return -1;
    80004baa:	557d                	li	a0,-1
    80004bac:	a05d                	j	80004c52 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004bae:	00004517          	auipc	a0,0x4
    80004bb2:	b0a50513          	addi	a0,a0,-1270 # 800086b8 <syscalls+0x2f0>
    80004bb6:	00001097          	auipc	ra,0x1
    80004bba:	1f2080e7          	jalr	498(ra) # 80005da8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bbe:	04c92703          	lw	a4,76(s2)
    80004bc2:	02000793          	li	a5,32
    80004bc6:	f6e7f9e3          	bgeu	a5,a4,80004b38 <sys_unlink+0xaa>
    80004bca:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bce:	4741                	li	a4,16
    80004bd0:	86ce                	mv	a3,s3
    80004bd2:	f1840613          	addi	a2,s0,-232
    80004bd6:	4581                	li	a1,0
    80004bd8:	854a                	mv	a0,s2
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	3ce080e7          	jalr	974(ra) # 80002fa8 <readi>
    80004be2:	47c1                	li	a5,16
    80004be4:	00f51b63          	bne	a0,a5,80004bfa <sys_unlink+0x16c>
    if(de.inum != 0)
    80004be8:	f1845783          	lhu	a5,-232(s0)
    80004bec:	e7a1                	bnez	a5,80004c34 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bee:	29c1                	addiw	s3,s3,16
    80004bf0:	04c92783          	lw	a5,76(s2)
    80004bf4:	fcf9ede3          	bltu	s3,a5,80004bce <sys_unlink+0x140>
    80004bf8:	b781                	j	80004b38 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bfa:	00004517          	auipc	a0,0x4
    80004bfe:	ad650513          	addi	a0,a0,-1322 # 800086d0 <syscalls+0x308>
    80004c02:	00001097          	auipc	ra,0x1
    80004c06:	1a6080e7          	jalr	422(ra) # 80005da8 <panic>
    panic("unlink: writei");
    80004c0a:	00004517          	auipc	a0,0x4
    80004c0e:	ade50513          	addi	a0,a0,-1314 # 800086e8 <syscalls+0x320>
    80004c12:	00001097          	auipc	ra,0x1
    80004c16:	196080e7          	jalr	406(ra) # 80005da8 <panic>
    dp->nlink--;
    80004c1a:	04a4d783          	lhu	a5,74(s1)
    80004c1e:	37fd                	addiw	a5,a5,-1
    80004c20:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c24:	8526                	mv	a0,s1
    80004c26:	ffffe097          	auipc	ra,0xffffe
    80004c2a:	004080e7          	jalr	4(ra) # 80002c2a <iupdate>
    80004c2e:	b781                	j	80004b6e <sys_unlink+0xe0>
    return -1;
    80004c30:	557d                	li	a0,-1
    80004c32:	a005                	j	80004c52 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c34:	854a                	mv	a0,s2
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	320080e7          	jalr	800(ra) # 80002f56 <iunlockput>
  iunlockput(dp);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	ffffe097          	auipc	ra,0xffffe
    80004c44:	316080e7          	jalr	790(ra) # 80002f56 <iunlockput>
  end_op();
    80004c48:	fffff097          	auipc	ra,0xfffff
    80004c4c:	afe080e7          	jalr	-1282(ra) # 80003746 <end_op>
  return -1;
    80004c50:	557d                	li	a0,-1
}
    80004c52:	70ae                	ld	ra,232(sp)
    80004c54:	740e                	ld	s0,224(sp)
    80004c56:	64ee                	ld	s1,216(sp)
    80004c58:	694e                	ld	s2,208(sp)
    80004c5a:	69ae                	ld	s3,200(sp)
    80004c5c:	616d                	addi	sp,sp,240
    80004c5e:	8082                	ret

0000000080004c60 <sys_open>:

uint64
sys_open(void)
{
    80004c60:	7131                	addi	sp,sp,-192
    80004c62:	fd06                	sd	ra,184(sp)
    80004c64:	f922                	sd	s0,176(sp)
    80004c66:	f526                	sd	s1,168(sp)
    80004c68:	f14a                	sd	s2,160(sp)
    80004c6a:	ed4e                	sd	s3,152(sp)
    80004c6c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c6e:	08000613          	li	a2,128
    80004c72:	f5040593          	addi	a1,s0,-176
    80004c76:	4501                	li	a0,0
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	3c0080e7          	jalr	960(ra) # 80002038 <argstr>
    return -1;
    80004c80:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c82:	0c054163          	bltz	a0,80004d44 <sys_open+0xe4>
    80004c86:	f4c40593          	addi	a1,s0,-180
    80004c8a:	4505                	li	a0,1
    80004c8c:	ffffd097          	auipc	ra,0xffffd
    80004c90:	368080e7          	jalr	872(ra) # 80001ff4 <argint>
    80004c94:	0a054863          	bltz	a0,80004d44 <sys_open+0xe4>

  begin_op();
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	a2e080e7          	jalr	-1490(ra) # 800036c6 <begin_op>

  if(omode & O_CREATE){
    80004ca0:	f4c42783          	lw	a5,-180(s0)
    80004ca4:	2007f793          	andi	a5,a5,512
    80004ca8:	cbdd                	beqz	a5,80004d5e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004caa:	4681                	li	a3,0
    80004cac:	4601                	li	a2,0
    80004cae:	4589                	li	a1,2
    80004cb0:	f5040513          	addi	a0,s0,-176
    80004cb4:	00000097          	auipc	ra,0x0
    80004cb8:	972080e7          	jalr	-1678(ra) # 80004626 <create>
    80004cbc:	892a                	mv	s2,a0
    if(ip == 0){
    80004cbe:	c959                	beqz	a0,80004d54 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004cc0:	04491703          	lh	a4,68(s2)
    80004cc4:	478d                	li	a5,3
    80004cc6:	00f71763          	bne	a4,a5,80004cd4 <sys_open+0x74>
    80004cca:	04695703          	lhu	a4,70(s2)
    80004cce:	47a5                	li	a5,9
    80004cd0:	0ce7ec63          	bltu	a5,a4,80004da8 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	e02080e7          	jalr	-510(ra) # 80003ad6 <filealloc>
    80004cdc:	89aa                	mv	s3,a0
    80004cde:	10050263          	beqz	a0,80004de2 <sys_open+0x182>
    80004ce2:	00000097          	auipc	ra,0x0
    80004ce6:	902080e7          	jalr	-1790(ra) # 800045e4 <fdalloc>
    80004cea:	84aa                	mv	s1,a0
    80004cec:	0e054663          	bltz	a0,80004dd8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cf0:	04491703          	lh	a4,68(s2)
    80004cf4:	478d                	li	a5,3
    80004cf6:	0cf70463          	beq	a4,a5,80004dbe <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cfa:	4789                	li	a5,2
    80004cfc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d00:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d04:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d08:	f4c42783          	lw	a5,-180(s0)
    80004d0c:	0017c713          	xori	a4,a5,1
    80004d10:	8b05                	andi	a4,a4,1
    80004d12:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004d16:	0037f713          	andi	a4,a5,3
    80004d1a:	00e03733          	snez	a4,a4
    80004d1e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004d22:	4007f793          	andi	a5,a5,1024
    80004d26:	c791                	beqz	a5,80004d32 <sys_open+0xd2>
    80004d28:	04491703          	lh	a4,68(s2)
    80004d2c:	4789                	li	a5,2
    80004d2e:	08f70f63          	beq	a4,a5,80004dcc <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004d32:	854a                	mv	a0,s2
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	082080e7          	jalr	130(ra) # 80002db6 <iunlock>
  end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	a0a080e7          	jalr	-1526(ra) # 80003746 <end_op>

  return fd;
}
    80004d44:	8526                	mv	a0,s1
    80004d46:	70ea                	ld	ra,184(sp)
    80004d48:	744a                	ld	s0,176(sp)
    80004d4a:	74aa                	ld	s1,168(sp)
    80004d4c:	790a                	ld	s2,160(sp)
    80004d4e:	69ea                	ld	s3,152(sp)
    80004d50:	6129                	addi	sp,sp,192
    80004d52:	8082                	ret
      end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	9f2080e7          	jalr	-1550(ra) # 80003746 <end_op>
      return -1;
    80004d5c:	b7e5                	j	80004d44 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d5e:	f5040513          	addi	a0,s0,-176
    80004d62:	ffffe097          	auipc	ra,0xffffe
    80004d66:	748080e7          	jalr	1864(ra) # 800034aa <namei>
    80004d6a:	892a                	mv	s2,a0
    80004d6c:	c905                	beqz	a0,80004d9c <sys_open+0x13c>
    ilock(ip);
    80004d6e:	ffffe097          	auipc	ra,0xffffe
    80004d72:	f86080e7          	jalr	-122(ra) # 80002cf4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d76:	04491703          	lh	a4,68(s2)
    80004d7a:	4785                	li	a5,1
    80004d7c:	f4f712e3          	bne	a4,a5,80004cc0 <sys_open+0x60>
    80004d80:	f4c42783          	lw	a5,-180(s0)
    80004d84:	dba1                	beqz	a5,80004cd4 <sys_open+0x74>
      iunlockput(ip);
    80004d86:	854a                	mv	a0,s2
    80004d88:	ffffe097          	auipc	ra,0xffffe
    80004d8c:	1ce080e7          	jalr	462(ra) # 80002f56 <iunlockput>
      end_op();
    80004d90:	fffff097          	auipc	ra,0xfffff
    80004d94:	9b6080e7          	jalr	-1610(ra) # 80003746 <end_op>
      return -1;
    80004d98:	54fd                	li	s1,-1
    80004d9a:	b76d                	j	80004d44 <sys_open+0xe4>
      end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	9aa080e7          	jalr	-1622(ra) # 80003746 <end_op>
      return -1;
    80004da4:	54fd                	li	s1,-1
    80004da6:	bf79                	j	80004d44 <sys_open+0xe4>
    iunlockput(ip);
    80004da8:	854a                	mv	a0,s2
    80004daa:	ffffe097          	auipc	ra,0xffffe
    80004dae:	1ac080e7          	jalr	428(ra) # 80002f56 <iunlockput>
    end_op();
    80004db2:	fffff097          	auipc	ra,0xfffff
    80004db6:	994080e7          	jalr	-1644(ra) # 80003746 <end_op>
    return -1;
    80004dba:	54fd                	li	s1,-1
    80004dbc:	b761                	j	80004d44 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004dbe:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004dc2:	04691783          	lh	a5,70(s2)
    80004dc6:	02f99223          	sh	a5,36(s3)
    80004dca:	bf2d                	j	80004d04 <sys_open+0xa4>
    itrunc(ip);
    80004dcc:	854a                	mv	a0,s2
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	034080e7          	jalr	52(ra) # 80002e02 <itrunc>
    80004dd6:	bfb1                	j	80004d32 <sys_open+0xd2>
      fileclose(f);
    80004dd8:	854e                	mv	a0,s3
    80004dda:	fffff097          	auipc	ra,0xfffff
    80004dde:	db8080e7          	jalr	-584(ra) # 80003b92 <fileclose>
    iunlockput(ip);
    80004de2:	854a                	mv	a0,s2
    80004de4:	ffffe097          	auipc	ra,0xffffe
    80004de8:	172080e7          	jalr	370(ra) # 80002f56 <iunlockput>
    end_op();
    80004dec:	fffff097          	auipc	ra,0xfffff
    80004df0:	95a080e7          	jalr	-1702(ra) # 80003746 <end_op>
    return -1;
    80004df4:	54fd                	li	s1,-1
    80004df6:	b7b9                	j	80004d44 <sys_open+0xe4>

0000000080004df8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004df8:	7175                	addi	sp,sp,-144
    80004dfa:	e506                	sd	ra,136(sp)
    80004dfc:	e122                	sd	s0,128(sp)
    80004dfe:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e00:	fffff097          	auipc	ra,0xfffff
    80004e04:	8c6080e7          	jalr	-1850(ra) # 800036c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e08:	08000613          	li	a2,128
    80004e0c:	f7040593          	addi	a1,s0,-144
    80004e10:	4501                	li	a0,0
    80004e12:	ffffd097          	auipc	ra,0xffffd
    80004e16:	226080e7          	jalr	550(ra) # 80002038 <argstr>
    80004e1a:	02054963          	bltz	a0,80004e4c <sys_mkdir+0x54>
    80004e1e:	4681                	li	a3,0
    80004e20:	4601                	li	a2,0
    80004e22:	4585                	li	a1,1
    80004e24:	f7040513          	addi	a0,s0,-144
    80004e28:	fffff097          	auipc	ra,0xfffff
    80004e2c:	7fe080e7          	jalr	2046(ra) # 80004626 <create>
    80004e30:	cd11                	beqz	a0,80004e4c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	124080e7          	jalr	292(ra) # 80002f56 <iunlockput>
  end_op();
    80004e3a:	fffff097          	auipc	ra,0xfffff
    80004e3e:	90c080e7          	jalr	-1780(ra) # 80003746 <end_op>
  return 0;
    80004e42:	4501                	li	a0,0
}
    80004e44:	60aa                	ld	ra,136(sp)
    80004e46:	640a                	ld	s0,128(sp)
    80004e48:	6149                	addi	sp,sp,144
    80004e4a:	8082                	ret
    end_op();
    80004e4c:	fffff097          	auipc	ra,0xfffff
    80004e50:	8fa080e7          	jalr	-1798(ra) # 80003746 <end_op>
    return -1;
    80004e54:	557d                	li	a0,-1
    80004e56:	b7fd                	j	80004e44 <sys_mkdir+0x4c>

0000000080004e58 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e58:	7135                	addi	sp,sp,-160
    80004e5a:	ed06                	sd	ra,152(sp)
    80004e5c:	e922                	sd	s0,144(sp)
    80004e5e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e60:	fffff097          	auipc	ra,0xfffff
    80004e64:	866080e7          	jalr	-1946(ra) # 800036c6 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e68:	08000613          	li	a2,128
    80004e6c:	f7040593          	addi	a1,s0,-144
    80004e70:	4501                	li	a0,0
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	1c6080e7          	jalr	454(ra) # 80002038 <argstr>
    80004e7a:	04054a63          	bltz	a0,80004ece <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e7e:	f6c40593          	addi	a1,s0,-148
    80004e82:	4505                	li	a0,1
    80004e84:	ffffd097          	auipc	ra,0xffffd
    80004e88:	170080e7          	jalr	368(ra) # 80001ff4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e8c:	04054163          	bltz	a0,80004ece <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e90:	f6840593          	addi	a1,s0,-152
    80004e94:	4509                	li	a0,2
    80004e96:	ffffd097          	auipc	ra,0xffffd
    80004e9a:	15e080e7          	jalr	350(ra) # 80001ff4 <argint>
     argint(1, &major) < 0 ||
    80004e9e:	02054863          	bltz	a0,80004ece <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ea2:	f6841683          	lh	a3,-152(s0)
    80004ea6:	f6c41603          	lh	a2,-148(s0)
    80004eaa:	458d                	li	a1,3
    80004eac:	f7040513          	addi	a0,s0,-144
    80004eb0:	fffff097          	auipc	ra,0xfffff
    80004eb4:	776080e7          	jalr	1910(ra) # 80004626 <create>
     argint(2, &minor) < 0 ||
    80004eb8:	c919                	beqz	a0,80004ece <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	09c080e7          	jalr	156(ra) # 80002f56 <iunlockput>
  end_op();
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	884080e7          	jalr	-1916(ra) # 80003746 <end_op>
  return 0;
    80004eca:	4501                	li	a0,0
    80004ecc:	a031                	j	80004ed8 <sys_mknod+0x80>
    end_op();
    80004ece:	fffff097          	auipc	ra,0xfffff
    80004ed2:	878080e7          	jalr	-1928(ra) # 80003746 <end_op>
    return -1;
    80004ed6:	557d                	li	a0,-1
}
    80004ed8:	60ea                	ld	ra,152(sp)
    80004eda:	644a                	ld	s0,144(sp)
    80004edc:	610d                	addi	sp,sp,160
    80004ede:	8082                	ret

0000000080004ee0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ee0:	7135                	addi	sp,sp,-160
    80004ee2:	ed06                	sd	ra,152(sp)
    80004ee4:	e922                	sd	s0,144(sp)
    80004ee6:	e526                	sd	s1,136(sp)
    80004ee8:	e14a                	sd	s2,128(sp)
    80004eea:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	f5c080e7          	jalr	-164(ra) # 80000e48 <myproc>
    80004ef4:	892a                	mv	s2,a0
  
  begin_op();
    80004ef6:	ffffe097          	auipc	ra,0xffffe
    80004efa:	7d0080e7          	jalr	2000(ra) # 800036c6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004efe:	08000613          	li	a2,128
    80004f02:	f6040593          	addi	a1,s0,-160
    80004f06:	4501                	li	a0,0
    80004f08:	ffffd097          	auipc	ra,0xffffd
    80004f0c:	130080e7          	jalr	304(ra) # 80002038 <argstr>
    80004f10:	04054b63          	bltz	a0,80004f66 <sys_chdir+0x86>
    80004f14:	f6040513          	addi	a0,s0,-160
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	592080e7          	jalr	1426(ra) # 800034aa <namei>
    80004f20:	84aa                	mv	s1,a0
    80004f22:	c131                	beqz	a0,80004f66 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	dd0080e7          	jalr	-560(ra) # 80002cf4 <ilock>
  if(ip->type != T_DIR){
    80004f2c:	04449703          	lh	a4,68(s1)
    80004f30:	4785                	li	a5,1
    80004f32:	04f71063          	bne	a4,a5,80004f72 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	e7e080e7          	jalr	-386(ra) # 80002db6 <iunlock>
  iput(p->cwd);
    80004f40:	16093503          	ld	a0,352(s2)
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	f6a080e7          	jalr	-150(ra) # 80002eae <iput>
  end_op();
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	7fa080e7          	jalr	2042(ra) # 80003746 <end_op>
  p->cwd = ip;
    80004f54:	16993023          	sd	s1,352(s2)
  return 0;
    80004f58:	4501                	li	a0,0
}
    80004f5a:	60ea                	ld	ra,152(sp)
    80004f5c:	644a                	ld	s0,144(sp)
    80004f5e:	64aa                	ld	s1,136(sp)
    80004f60:	690a                	ld	s2,128(sp)
    80004f62:	610d                	addi	sp,sp,160
    80004f64:	8082                	ret
    end_op();
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	7e0080e7          	jalr	2016(ra) # 80003746 <end_op>
    return -1;
    80004f6e:	557d                	li	a0,-1
    80004f70:	b7ed                	j	80004f5a <sys_chdir+0x7a>
    iunlockput(ip);
    80004f72:	8526                	mv	a0,s1
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	fe2080e7          	jalr	-30(ra) # 80002f56 <iunlockput>
    end_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	7ca080e7          	jalr	1994(ra) # 80003746 <end_op>
    return -1;
    80004f84:	557d                	li	a0,-1
    80004f86:	bfd1                	j	80004f5a <sys_chdir+0x7a>

0000000080004f88 <sys_exec>:

uint64
sys_exec(void)
{
    80004f88:	7145                	addi	sp,sp,-464
    80004f8a:	e786                	sd	ra,456(sp)
    80004f8c:	e3a2                	sd	s0,448(sp)
    80004f8e:	ff26                	sd	s1,440(sp)
    80004f90:	fb4a                	sd	s2,432(sp)
    80004f92:	f74e                	sd	s3,424(sp)
    80004f94:	f352                	sd	s4,416(sp)
    80004f96:	ef56                	sd	s5,408(sp)
    80004f98:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f9a:	08000613          	li	a2,128
    80004f9e:	f4040593          	addi	a1,s0,-192
    80004fa2:	4501                	li	a0,0
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	094080e7          	jalr	148(ra) # 80002038 <argstr>
    return -1;
    80004fac:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004fae:	0c054a63          	bltz	a0,80005082 <sys_exec+0xfa>
    80004fb2:	e3840593          	addi	a1,s0,-456
    80004fb6:	4505                	li	a0,1
    80004fb8:	ffffd097          	auipc	ra,0xffffd
    80004fbc:	05e080e7          	jalr	94(ra) # 80002016 <argaddr>
    80004fc0:	0c054163          	bltz	a0,80005082 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004fc4:	10000613          	li	a2,256
    80004fc8:	4581                	li	a1,0
    80004fca:	e4040513          	addi	a0,s0,-448
    80004fce:	ffffb097          	auipc	ra,0xffffb
    80004fd2:	1aa080e7          	jalr	426(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fd6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004fda:	89a6                	mv	s3,s1
    80004fdc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fde:	02000a13          	li	s4,32
    80004fe2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fe6:	00391513          	slli	a0,s2,0x3
    80004fea:	e3040593          	addi	a1,s0,-464
    80004fee:	e3843783          	ld	a5,-456(s0)
    80004ff2:	953e                	add	a0,a0,a5
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	f66080e7          	jalr	-154(ra) # 80001f5a <fetchaddr>
    80004ffc:	02054a63          	bltz	a0,80005030 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005000:	e3043783          	ld	a5,-464(s0)
    80005004:	c3b9                	beqz	a5,8000504a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005006:	ffffb097          	auipc	ra,0xffffb
    8000500a:	112080e7          	jalr	274(ra) # 80000118 <kalloc>
    8000500e:	85aa                	mv	a1,a0
    80005010:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005014:	cd11                	beqz	a0,80005030 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005016:	6605                	lui	a2,0x1
    80005018:	e3043503          	ld	a0,-464(s0)
    8000501c:	ffffd097          	auipc	ra,0xffffd
    80005020:	f90080e7          	jalr	-112(ra) # 80001fac <fetchstr>
    80005024:	00054663          	bltz	a0,80005030 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005028:	0905                	addi	s2,s2,1
    8000502a:	09a1                	addi	s3,s3,8
    8000502c:	fb491be3          	bne	s2,s4,80004fe2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005030:	10048913          	addi	s2,s1,256
    80005034:	6088                	ld	a0,0(s1)
    80005036:	c529                	beqz	a0,80005080 <sys_exec+0xf8>
    kfree(argv[i]);
    80005038:	ffffb097          	auipc	ra,0xffffb
    8000503c:	fe4080e7          	jalr	-28(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005040:	04a1                	addi	s1,s1,8
    80005042:	ff2499e3          	bne	s1,s2,80005034 <sys_exec+0xac>
  return -1;
    80005046:	597d                	li	s2,-1
    80005048:	a82d                	j	80005082 <sys_exec+0xfa>
      argv[i] = 0;
    8000504a:	0a8e                	slli	s5,s5,0x3
    8000504c:	fc040793          	addi	a5,s0,-64
    80005050:	9abe                	add	s5,s5,a5
    80005052:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005056:	e4040593          	addi	a1,s0,-448
    8000505a:	f4040513          	addi	a0,s0,-192
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	194080e7          	jalr	404(ra) # 800041f2 <exec>
    80005066:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005068:	10048993          	addi	s3,s1,256
    8000506c:	6088                	ld	a0,0(s1)
    8000506e:	c911                	beqz	a0,80005082 <sys_exec+0xfa>
    kfree(argv[i]);
    80005070:	ffffb097          	auipc	ra,0xffffb
    80005074:	fac080e7          	jalr	-84(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005078:	04a1                	addi	s1,s1,8
    8000507a:	ff3499e3          	bne	s1,s3,8000506c <sys_exec+0xe4>
    8000507e:	a011                	j	80005082 <sys_exec+0xfa>
  return -1;
    80005080:	597d                	li	s2,-1
}
    80005082:	854a                	mv	a0,s2
    80005084:	60be                	ld	ra,456(sp)
    80005086:	641e                	ld	s0,448(sp)
    80005088:	74fa                	ld	s1,440(sp)
    8000508a:	795a                	ld	s2,432(sp)
    8000508c:	79ba                	ld	s3,424(sp)
    8000508e:	7a1a                	ld	s4,416(sp)
    80005090:	6afa                	ld	s5,408(sp)
    80005092:	6179                	addi	sp,sp,464
    80005094:	8082                	ret

0000000080005096 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005096:	7139                	addi	sp,sp,-64
    80005098:	fc06                	sd	ra,56(sp)
    8000509a:	f822                	sd	s0,48(sp)
    8000509c:	f426                	sd	s1,40(sp)
    8000509e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	da8080e7          	jalr	-600(ra) # 80000e48 <myproc>
    800050a8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050aa:	fd840593          	addi	a1,s0,-40
    800050ae:	4501                	li	a0,0
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	f66080e7          	jalr	-154(ra) # 80002016 <argaddr>
    return -1;
    800050b8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050ba:	0e054063          	bltz	a0,8000519a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050be:	fc840593          	addi	a1,s0,-56
    800050c2:	fd040513          	addi	a0,s0,-48
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	dfc080e7          	jalr	-516(ra) # 80003ec2 <pipealloc>
    return -1;
    800050ce:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050d0:	0c054563          	bltz	a0,8000519a <sys_pipe+0x104>
  fd0 = -1;
    800050d4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050d8:	fd043503          	ld	a0,-48(s0)
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	508080e7          	jalr	1288(ra) # 800045e4 <fdalloc>
    800050e4:	fca42223          	sw	a0,-60(s0)
    800050e8:	08054c63          	bltz	a0,80005180 <sys_pipe+0xea>
    800050ec:	fc843503          	ld	a0,-56(s0)
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	4f4080e7          	jalr	1268(ra) # 800045e4 <fdalloc>
    800050f8:	fca42023          	sw	a0,-64(s0)
    800050fc:	06054863          	bltz	a0,8000516c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005100:	4691                	li	a3,4
    80005102:	fc440613          	addi	a2,s0,-60
    80005106:	fd843583          	ld	a1,-40(s0)
    8000510a:	70a8                	ld	a0,96(s1)
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	9fe080e7          	jalr	-1538(ra) # 80000b0a <copyout>
    80005114:	02054063          	bltz	a0,80005134 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005118:	4691                	li	a3,4
    8000511a:	fc040613          	addi	a2,s0,-64
    8000511e:	fd843583          	ld	a1,-40(s0)
    80005122:	0591                	addi	a1,a1,4
    80005124:	70a8                	ld	a0,96(s1)
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	9e4080e7          	jalr	-1564(ra) # 80000b0a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000512e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005130:	06055563          	bgez	a0,8000519a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005134:	fc442783          	lw	a5,-60(s0)
    80005138:	07f1                	addi	a5,a5,28
    8000513a:	078e                	slli	a5,a5,0x3
    8000513c:	97a6                	add	a5,a5,s1
    8000513e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005142:	fc042503          	lw	a0,-64(s0)
    80005146:	0571                	addi	a0,a0,28
    80005148:	050e                	slli	a0,a0,0x3
    8000514a:	9526                	add	a0,a0,s1
    8000514c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005150:	fd043503          	ld	a0,-48(s0)
    80005154:	fffff097          	auipc	ra,0xfffff
    80005158:	a3e080e7          	jalr	-1474(ra) # 80003b92 <fileclose>
    fileclose(wf);
    8000515c:	fc843503          	ld	a0,-56(s0)
    80005160:	fffff097          	auipc	ra,0xfffff
    80005164:	a32080e7          	jalr	-1486(ra) # 80003b92 <fileclose>
    return -1;
    80005168:	57fd                	li	a5,-1
    8000516a:	a805                	j	8000519a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000516c:	fc442783          	lw	a5,-60(s0)
    80005170:	0007c863          	bltz	a5,80005180 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005174:	01c78513          	addi	a0,a5,28
    80005178:	050e                	slli	a0,a0,0x3
    8000517a:	9526                	add	a0,a0,s1
    8000517c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005180:	fd043503          	ld	a0,-48(s0)
    80005184:	fffff097          	auipc	ra,0xfffff
    80005188:	a0e080e7          	jalr	-1522(ra) # 80003b92 <fileclose>
    fileclose(wf);
    8000518c:	fc843503          	ld	a0,-56(s0)
    80005190:	fffff097          	auipc	ra,0xfffff
    80005194:	a02080e7          	jalr	-1534(ra) # 80003b92 <fileclose>
    return -1;
    80005198:	57fd                	li	a5,-1
}
    8000519a:	853e                	mv	a0,a5
    8000519c:	70e2                	ld	ra,56(sp)
    8000519e:	7442                	ld	s0,48(sp)
    800051a0:	74a2                	ld	s1,40(sp)
    800051a2:	6121                	addi	sp,sp,64
    800051a4:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	c37fc0ef          	jal	ra,80001e26 <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e422                	sd	s0,8(sp)
    8000526e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005270:	0c0007b7          	lui	a5,0xc000
    80005274:	4705                	li	a4,1
    80005276:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005278:	c3d8                	sw	a4,4(a5)
}
    8000527a:	6422                	ld	s0,8(sp)
    8000527c:	0141                	addi	sp,sp,16
    8000527e:	8082                	ret

0000000080005280 <plicinithart>:

void
plicinithart(void)
{
    80005280:	1141                	addi	sp,sp,-16
    80005282:	e406                	sd	ra,8(sp)
    80005284:	e022                	sd	s0,0(sp)
    80005286:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	b94080e7          	jalr	-1132(ra) # 80000e1c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005290:	0085171b          	slliw	a4,a0,0x8
    80005294:	0c0027b7          	lui	a5,0xc002
    80005298:	97ba                	add	a5,a5,a4
    8000529a:	40200713          	li	a4,1026
    8000529e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a2:	00d5151b          	slliw	a0,a0,0xd
    800052a6:	0c2017b7          	lui	a5,0xc201
    800052aa:	953e                	add	a0,a0,a5
    800052ac:	00052023          	sw	zero,0(a0)
}
    800052b0:	60a2                	ld	ra,8(sp)
    800052b2:	6402                	ld	s0,0(sp)
    800052b4:	0141                	addi	sp,sp,16
    800052b6:	8082                	ret

00000000800052b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052b8:	1141                	addi	sp,sp,-16
    800052ba:	e406                	sd	ra,8(sp)
    800052bc:	e022                	sd	s0,0(sp)
    800052be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c0:	ffffc097          	auipc	ra,0xffffc
    800052c4:	b5c080e7          	jalr	-1188(ra) # 80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052c8:	00d5179b          	slliw	a5,a0,0xd
    800052cc:	0c201537          	lui	a0,0xc201
    800052d0:	953e                	add	a0,a0,a5
  return irq;
}
    800052d2:	4148                	lw	a0,4(a0)
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret

00000000800052dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052dc:	1101                	addi	sp,sp,-32
    800052de:	ec06                	sd	ra,24(sp)
    800052e0:	e822                	sd	s0,16(sp)
    800052e2:	e426                	sd	s1,8(sp)
    800052e4:	1000                	addi	s0,sp,32
    800052e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052e8:	ffffc097          	auipc	ra,0xffffc
    800052ec:	b34080e7          	jalr	-1228(ra) # 80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052f0:	00d5151b          	slliw	a0,a0,0xd
    800052f4:	0c2017b7          	lui	a5,0xc201
    800052f8:	97aa                	add	a5,a5,a0
    800052fa:	c3c4                	sw	s1,4(a5)
}
    800052fc:	60e2                	ld	ra,24(sp)
    800052fe:	6442                	ld	s0,16(sp)
    80005300:	64a2                	ld	s1,8(sp)
    80005302:	6105                	addi	sp,sp,32
    80005304:	8082                	ret

0000000080005306 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005306:	1141                	addi	sp,sp,-16
    80005308:	e406                	sd	ra,8(sp)
    8000530a:	e022                	sd	s0,0(sp)
    8000530c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000530e:	479d                	li	a5,7
    80005310:	06a7c963          	blt	a5,a0,80005382 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005314:	0001a797          	auipc	a5,0x1a
    80005318:	cec78793          	addi	a5,a5,-788 # 8001f000 <disk>
    8000531c:	00a78733          	add	a4,a5,a0
    80005320:	6789                	lui	a5,0x2
    80005322:	97ba                	add	a5,a5,a4
    80005324:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005328:	e7ad                	bnez	a5,80005392 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000532a:	00451793          	slli	a5,a0,0x4
    8000532e:	0001c717          	auipc	a4,0x1c
    80005332:	cd270713          	addi	a4,a4,-814 # 80021000 <disk+0x2000>
    80005336:	6314                	ld	a3,0(a4)
    80005338:	96be                	add	a3,a3,a5
    8000533a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000533e:	6314                	ld	a3,0(a4)
    80005340:	96be                	add	a3,a3,a5
    80005342:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005346:	6314                	ld	a3,0(a4)
    80005348:	96be                	add	a3,a3,a5
    8000534a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000534e:	6318                	ld	a4,0(a4)
    80005350:	97ba                	add	a5,a5,a4
    80005352:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005356:	0001a797          	auipc	a5,0x1a
    8000535a:	caa78793          	addi	a5,a5,-854 # 8001f000 <disk>
    8000535e:	97aa                	add	a5,a5,a0
    80005360:	6509                	lui	a0,0x2
    80005362:	953e                	add	a0,a0,a5
    80005364:	4785                	li	a5,1
    80005366:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000536a:	0001c517          	auipc	a0,0x1c
    8000536e:	cae50513          	addi	a0,a0,-850 # 80021018 <disk+0x2018>
    80005372:	ffffc097          	auipc	ra,0xffffc
    80005376:	32e080e7          	jalr	814(ra) # 800016a0 <wakeup>
}
    8000537a:	60a2                	ld	ra,8(sp)
    8000537c:	6402                	ld	s0,0(sp)
    8000537e:	0141                	addi	sp,sp,16
    80005380:	8082                	ret
    panic("free_desc 1");
    80005382:	00003517          	auipc	a0,0x3
    80005386:	37650513          	addi	a0,a0,886 # 800086f8 <syscalls+0x330>
    8000538a:	00001097          	auipc	ra,0x1
    8000538e:	a1e080e7          	jalr	-1506(ra) # 80005da8 <panic>
    panic("free_desc 2");
    80005392:	00003517          	auipc	a0,0x3
    80005396:	37650513          	addi	a0,a0,886 # 80008708 <syscalls+0x340>
    8000539a:	00001097          	auipc	ra,0x1
    8000539e:	a0e080e7          	jalr	-1522(ra) # 80005da8 <panic>

00000000800053a2 <virtio_disk_init>:
{
    800053a2:	1101                	addi	sp,sp,-32
    800053a4:	ec06                	sd	ra,24(sp)
    800053a6:	e822                	sd	s0,16(sp)
    800053a8:	e426                	sd	s1,8(sp)
    800053aa:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053ac:	00003597          	auipc	a1,0x3
    800053b0:	36c58593          	addi	a1,a1,876 # 80008718 <syscalls+0x350>
    800053b4:	0001c517          	auipc	a0,0x1c
    800053b8:	d7450513          	addi	a0,a0,-652 # 80021128 <disk+0x2128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	f14080e7          	jalr	-236(ra) # 800062d0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c4:	100017b7          	lui	a5,0x10001
    800053c8:	4398                	lw	a4,0(a5)
    800053ca:	2701                	sext.w	a4,a4
    800053cc:	747277b7          	lui	a5,0x74727
    800053d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053d4:	0ef71163          	bne	a4,a5,800054b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	43dc                	lw	a5,4(a5)
    800053de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e0:	4705                	li	a4,1
    800053e2:	0ce79a63          	bne	a5,a4,800054b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e6:	100017b7          	lui	a5,0x10001
    800053ea:	479c                	lw	a5,8(a5)
    800053ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ee:	4709                	li	a4,2
    800053f0:	0ce79363          	bne	a5,a4,800054b6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053f4:	100017b7          	lui	a5,0x10001
    800053f8:	47d8                	lw	a4,12(a5)
    800053fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053fc:	554d47b7          	lui	a5,0x554d4
    80005400:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005404:	0af71963          	bne	a4,a5,800054b6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005408:	100017b7          	lui	a5,0x10001
    8000540c:	4705                	li	a4,1
    8000540e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005410:	470d                	li	a4,3
    80005412:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005414:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005416:	c7ffe737          	lui	a4,0xc7ffe
    8000541a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd451f>
    8000541e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005420:	2701                	sext.w	a4,a4
    80005422:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005424:	472d                	li	a4,11
    80005426:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005428:	473d                	li	a4,15
    8000542a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000542c:	6705                	lui	a4,0x1
    8000542e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005430:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005434:	5bdc                	lw	a5,52(a5)
    80005436:	2781                	sext.w	a5,a5
  if(max == 0)
    80005438:	c7d9                	beqz	a5,800054c6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000543a:	471d                	li	a4,7
    8000543c:	08f77d63          	bgeu	a4,a5,800054d6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005440:	100014b7          	lui	s1,0x10001
    80005444:	47a1                	li	a5,8
    80005446:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005448:	6609                	lui	a2,0x2
    8000544a:	4581                	li	a1,0
    8000544c:	0001a517          	auipc	a0,0x1a
    80005450:	bb450513          	addi	a0,a0,-1100 # 8001f000 <disk>
    80005454:	ffffb097          	auipc	ra,0xffffb
    80005458:	d24080e7          	jalr	-732(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000545c:	0001a717          	auipc	a4,0x1a
    80005460:	ba470713          	addi	a4,a4,-1116 # 8001f000 <disk>
    80005464:	00c75793          	srli	a5,a4,0xc
    80005468:	2781                	sext.w	a5,a5
    8000546a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000546c:	0001c797          	auipc	a5,0x1c
    80005470:	b9478793          	addi	a5,a5,-1132 # 80021000 <disk+0x2000>
    80005474:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005476:	0001a717          	auipc	a4,0x1a
    8000547a:	c0a70713          	addi	a4,a4,-1014 # 8001f080 <disk+0x80>
    8000547e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005480:	0001b717          	auipc	a4,0x1b
    80005484:	b8070713          	addi	a4,a4,-1152 # 80020000 <disk+0x1000>
    80005488:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000548a:	4705                	li	a4,1
    8000548c:	00e78c23          	sb	a4,24(a5)
    80005490:	00e78ca3          	sb	a4,25(a5)
    80005494:	00e78d23          	sb	a4,26(a5)
    80005498:	00e78da3          	sb	a4,27(a5)
    8000549c:	00e78e23          	sb	a4,28(a5)
    800054a0:	00e78ea3          	sb	a4,29(a5)
    800054a4:	00e78f23          	sb	a4,30(a5)
    800054a8:	00e78fa3          	sb	a4,31(a5)
}
    800054ac:	60e2                	ld	ra,24(sp)
    800054ae:	6442                	ld	s0,16(sp)
    800054b0:	64a2                	ld	s1,8(sp)
    800054b2:	6105                	addi	sp,sp,32
    800054b4:	8082                	ret
    panic("could not find virtio disk");
    800054b6:	00003517          	auipc	a0,0x3
    800054ba:	27250513          	addi	a0,a0,626 # 80008728 <syscalls+0x360>
    800054be:	00001097          	auipc	ra,0x1
    800054c2:	8ea080e7          	jalr	-1814(ra) # 80005da8 <panic>
    panic("virtio disk has no queue 0");
    800054c6:	00003517          	auipc	a0,0x3
    800054ca:	28250513          	addi	a0,a0,642 # 80008748 <syscalls+0x380>
    800054ce:	00001097          	auipc	ra,0x1
    800054d2:	8da080e7          	jalr	-1830(ra) # 80005da8 <panic>
    panic("virtio disk max queue too short");
    800054d6:	00003517          	auipc	a0,0x3
    800054da:	29250513          	addi	a0,a0,658 # 80008768 <syscalls+0x3a0>
    800054de:	00001097          	auipc	ra,0x1
    800054e2:	8ca080e7          	jalr	-1846(ra) # 80005da8 <panic>

00000000800054e6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054e6:	7159                	addi	sp,sp,-112
    800054e8:	f486                	sd	ra,104(sp)
    800054ea:	f0a2                	sd	s0,96(sp)
    800054ec:	eca6                	sd	s1,88(sp)
    800054ee:	e8ca                	sd	s2,80(sp)
    800054f0:	e4ce                	sd	s3,72(sp)
    800054f2:	e0d2                	sd	s4,64(sp)
    800054f4:	fc56                	sd	s5,56(sp)
    800054f6:	f85a                	sd	s6,48(sp)
    800054f8:	f45e                	sd	s7,40(sp)
    800054fa:	f062                	sd	s8,32(sp)
    800054fc:	ec66                	sd	s9,24(sp)
    800054fe:	e86a                	sd	s10,16(sp)
    80005500:	1880                	addi	s0,sp,112
    80005502:	892a                	mv	s2,a0
    80005504:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005506:	00c52c83          	lw	s9,12(a0)
    8000550a:	001c9c9b          	slliw	s9,s9,0x1
    8000550e:	1c82                	slli	s9,s9,0x20
    80005510:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005514:	0001c517          	auipc	a0,0x1c
    80005518:	c1450513          	addi	a0,a0,-1004 # 80021128 <disk+0x2128>
    8000551c:	00001097          	auipc	ra,0x1
    80005520:	e44080e7          	jalr	-444(ra) # 80006360 <acquire>
  for(int i = 0; i < 3; i++){
    80005524:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005526:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005528:	0001ab97          	auipc	s7,0x1a
    8000552c:	ad8b8b93          	addi	s7,s7,-1320 # 8001f000 <disk>
    80005530:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005532:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005534:	8a4e                	mv	s4,s3
    80005536:	a051                	j	800055ba <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005538:	00fb86b3          	add	a3,s7,a5
    8000553c:	96da                	add	a3,a3,s6
    8000553e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005542:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005544:	0207c563          	bltz	a5,8000556e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005548:	2485                	addiw	s1,s1,1
    8000554a:	0711                	addi	a4,a4,4
    8000554c:	25548063          	beq	s1,s5,8000578c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005550:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005552:	0001c697          	auipc	a3,0x1c
    80005556:	ac668693          	addi	a3,a3,-1338 # 80021018 <disk+0x2018>
    8000555a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000555c:	0006c583          	lbu	a1,0(a3)
    80005560:	fde1                	bnez	a1,80005538 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005562:	2785                	addiw	a5,a5,1
    80005564:	0685                	addi	a3,a3,1
    80005566:	ff879be3          	bne	a5,s8,8000555c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000556a:	57fd                	li	a5,-1
    8000556c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000556e:	02905a63          	blez	s1,800055a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005572:	f9042503          	lw	a0,-112(s0)
    80005576:	00000097          	auipc	ra,0x0
    8000557a:	d90080e7          	jalr	-624(ra) # 80005306 <free_desc>
      for(int j = 0; j < i; j++)
    8000557e:	4785                	li	a5,1
    80005580:	0297d163          	bge	a5,s1,800055a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005584:	f9442503          	lw	a0,-108(s0)
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	d7e080e7          	jalr	-642(ra) # 80005306 <free_desc>
      for(int j = 0; j < i; j++)
    80005590:	4789                	li	a5,2
    80005592:	0097d863          	bge	a5,s1,800055a2 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005596:	f9842503          	lw	a0,-104(s0)
    8000559a:	00000097          	auipc	ra,0x0
    8000559e:	d6c080e7          	jalr	-660(ra) # 80005306 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055a2:	0001c597          	auipc	a1,0x1c
    800055a6:	b8658593          	addi	a1,a1,-1146 # 80021128 <disk+0x2128>
    800055aa:	0001c517          	auipc	a0,0x1c
    800055ae:	a6e50513          	addi	a0,a0,-1426 # 80021018 <disk+0x2018>
    800055b2:	ffffc097          	auipc	ra,0xffffc
    800055b6:	f62080e7          	jalr	-158(ra) # 80001514 <sleep>
  for(int i = 0; i < 3; i++){
    800055ba:	f9040713          	addi	a4,s0,-112
    800055be:	84ce                	mv	s1,s3
    800055c0:	bf41                	j	80005550 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055c2:	20058713          	addi	a4,a1,512
    800055c6:	00471693          	slli	a3,a4,0x4
    800055ca:	0001a717          	auipc	a4,0x1a
    800055ce:	a3670713          	addi	a4,a4,-1482 # 8001f000 <disk>
    800055d2:	9736                	add	a4,a4,a3
    800055d4:	4685                	li	a3,1
    800055d6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055da:	20058713          	addi	a4,a1,512
    800055de:	00471693          	slli	a3,a4,0x4
    800055e2:	0001a717          	auipc	a4,0x1a
    800055e6:	a1e70713          	addi	a4,a4,-1506 # 8001f000 <disk>
    800055ea:	9736                	add	a4,a4,a3
    800055ec:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800055f0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055f4:	7679                	lui	a2,0xffffe
    800055f6:	963e                	add	a2,a2,a5
    800055f8:	0001c697          	auipc	a3,0x1c
    800055fc:	a0868693          	addi	a3,a3,-1528 # 80021000 <disk+0x2000>
    80005600:	6298                	ld	a4,0(a3)
    80005602:	9732                	add	a4,a4,a2
    80005604:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005606:	6298                	ld	a4,0(a3)
    80005608:	9732                	add	a4,a4,a2
    8000560a:	4541                	li	a0,16
    8000560c:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000560e:	6298                	ld	a4,0(a3)
    80005610:	9732                	add	a4,a4,a2
    80005612:	4505                	li	a0,1
    80005614:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80005618:	f9442703          	lw	a4,-108(s0)
    8000561c:	6288                	ld	a0,0(a3)
    8000561e:	962a                	add	a2,a2,a0
    80005620:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd3dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005624:	0712                	slli	a4,a4,0x4
    80005626:	6290                	ld	a2,0(a3)
    80005628:	963a                	add	a2,a2,a4
    8000562a:	05890513          	addi	a0,s2,88
    8000562e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005630:	6294                	ld	a3,0(a3)
    80005632:	96ba                	add	a3,a3,a4
    80005634:	40000613          	li	a2,1024
    80005638:	c690                	sw	a2,8(a3)
  if(write)
    8000563a:	140d0063          	beqz	s10,8000577a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000563e:	0001c697          	auipc	a3,0x1c
    80005642:	9c26b683          	ld	a3,-1598(a3) # 80021000 <disk+0x2000>
    80005646:	96ba                	add	a3,a3,a4
    80005648:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000564c:	0001a817          	auipc	a6,0x1a
    80005650:	9b480813          	addi	a6,a6,-1612 # 8001f000 <disk>
    80005654:	0001c517          	auipc	a0,0x1c
    80005658:	9ac50513          	addi	a0,a0,-1620 # 80021000 <disk+0x2000>
    8000565c:	6114                	ld	a3,0(a0)
    8000565e:	96ba                	add	a3,a3,a4
    80005660:	00c6d603          	lhu	a2,12(a3)
    80005664:	00166613          	ori	a2,a2,1
    80005668:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000566c:	f9842683          	lw	a3,-104(s0)
    80005670:	6110                	ld	a2,0(a0)
    80005672:	9732                	add	a4,a4,a2
    80005674:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005678:	20058613          	addi	a2,a1,512
    8000567c:	0612                	slli	a2,a2,0x4
    8000567e:	9642                	add	a2,a2,a6
    80005680:	577d                	li	a4,-1
    80005682:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005686:	00469713          	slli	a4,a3,0x4
    8000568a:	6114                	ld	a3,0(a0)
    8000568c:	96ba                	add	a3,a3,a4
    8000568e:	03078793          	addi	a5,a5,48
    80005692:	97c2                	add	a5,a5,a6
    80005694:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005696:	611c                	ld	a5,0(a0)
    80005698:	97ba                	add	a5,a5,a4
    8000569a:	4685                	li	a3,1
    8000569c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000569e:	611c                	ld	a5,0(a0)
    800056a0:	97ba                	add	a5,a5,a4
    800056a2:	4809                	li	a6,2
    800056a4:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800056a8:	611c                	ld	a5,0(a0)
    800056aa:	973e                	add	a4,a4,a5
    800056ac:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056b0:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    800056b4:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056b8:	6518                	ld	a4,8(a0)
    800056ba:	00275783          	lhu	a5,2(a4)
    800056be:	8b9d                	andi	a5,a5,7
    800056c0:	0786                	slli	a5,a5,0x1
    800056c2:	97ba                	add	a5,a5,a4
    800056c4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800056c8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056cc:	6518                	ld	a4,8(a0)
    800056ce:	00275783          	lhu	a5,2(a4)
    800056d2:	2785                	addiw	a5,a5,1
    800056d4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056d8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056dc:	100017b7          	lui	a5,0x10001
    800056e0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056e4:	00492703          	lw	a4,4(s2)
    800056e8:	4785                	li	a5,1
    800056ea:	02f71163          	bne	a4,a5,8000570c <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800056ee:	0001c997          	auipc	s3,0x1c
    800056f2:	a3a98993          	addi	s3,s3,-1478 # 80021128 <disk+0x2128>
  while(b->disk == 1) {
    800056f6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056f8:	85ce                	mv	a1,s3
    800056fa:	854a                	mv	a0,s2
    800056fc:	ffffc097          	auipc	ra,0xffffc
    80005700:	e18080e7          	jalr	-488(ra) # 80001514 <sleep>
  while(b->disk == 1) {
    80005704:	00492783          	lw	a5,4(s2)
    80005708:	fe9788e3          	beq	a5,s1,800056f8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    8000570c:	f9042903          	lw	s2,-112(s0)
    80005710:	20090793          	addi	a5,s2,512
    80005714:	00479713          	slli	a4,a5,0x4
    80005718:	0001a797          	auipc	a5,0x1a
    8000571c:	8e878793          	addi	a5,a5,-1816 # 8001f000 <disk>
    80005720:	97ba                	add	a5,a5,a4
    80005722:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005726:	0001c997          	auipc	s3,0x1c
    8000572a:	8da98993          	addi	s3,s3,-1830 # 80021000 <disk+0x2000>
    8000572e:	00491713          	slli	a4,s2,0x4
    80005732:	0009b783          	ld	a5,0(s3)
    80005736:	97ba                	add	a5,a5,a4
    80005738:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000573c:	854a                	mv	a0,s2
    8000573e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005742:	00000097          	auipc	ra,0x0
    80005746:	bc4080e7          	jalr	-1084(ra) # 80005306 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000574a:	8885                	andi	s1,s1,1
    8000574c:	f0ed                	bnez	s1,8000572e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000574e:	0001c517          	auipc	a0,0x1c
    80005752:	9da50513          	addi	a0,a0,-1574 # 80021128 <disk+0x2128>
    80005756:	00001097          	auipc	ra,0x1
    8000575a:	cbe080e7          	jalr	-834(ra) # 80006414 <release>
}
    8000575e:	70a6                	ld	ra,104(sp)
    80005760:	7406                	ld	s0,96(sp)
    80005762:	64e6                	ld	s1,88(sp)
    80005764:	6946                	ld	s2,80(sp)
    80005766:	69a6                	ld	s3,72(sp)
    80005768:	6a06                	ld	s4,64(sp)
    8000576a:	7ae2                	ld	s5,56(sp)
    8000576c:	7b42                	ld	s6,48(sp)
    8000576e:	7ba2                	ld	s7,40(sp)
    80005770:	7c02                	ld	s8,32(sp)
    80005772:	6ce2                	ld	s9,24(sp)
    80005774:	6d42                	ld	s10,16(sp)
    80005776:	6165                	addi	sp,sp,112
    80005778:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000577a:	0001c697          	auipc	a3,0x1c
    8000577e:	8866b683          	ld	a3,-1914(a3) # 80021000 <disk+0x2000>
    80005782:	96ba                	add	a3,a3,a4
    80005784:	4609                	li	a2,2
    80005786:	00c69623          	sh	a2,12(a3)
    8000578a:	b5c9                	j	8000564c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000578c:	f9042583          	lw	a1,-112(s0)
    80005790:	20058793          	addi	a5,a1,512
    80005794:	0792                	slli	a5,a5,0x4
    80005796:	0001a517          	auipc	a0,0x1a
    8000579a:	91250513          	addi	a0,a0,-1774 # 8001f0a8 <disk+0xa8>
    8000579e:	953e                	add	a0,a0,a5
  if(write)
    800057a0:	e20d11e3          	bnez	s10,800055c2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800057a4:	20058713          	addi	a4,a1,512
    800057a8:	00471693          	slli	a3,a4,0x4
    800057ac:	0001a717          	auipc	a4,0x1a
    800057b0:	85470713          	addi	a4,a4,-1964 # 8001f000 <disk>
    800057b4:	9736                	add	a4,a4,a3
    800057b6:	0a072423          	sw	zero,168(a4)
    800057ba:	b505                	j	800055da <virtio_disk_rw+0xf4>

00000000800057bc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057bc:	1101                	addi	sp,sp,-32
    800057be:	ec06                	sd	ra,24(sp)
    800057c0:	e822                	sd	s0,16(sp)
    800057c2:	e426                	sd	s1,8(sp)
    800057c4:	e04a                	sd	s2,0(sp)
    800057c6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057c8:	0001c517          	auipc	a0,0x1c
    800057cc:	96050513          	addi	a0,a0,-1696 # 80021128 <disk+0x2128>
    800057d0:	00001097          	auipc	ra,0x1
    800057d4:	b90080e7          	jalr	-1136(ra) # 80006360 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057d8:	10001737          	lui	a4,0x10001
    800057dc:	533c                	lw	a5,96(a4)
    800057de:	8b8d                	andi	a5,a5,3
    800057e0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057e2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057e6:	0001c797          	auipc	a5,0x1c
    800057ea:	81a78793          	addi	a5,a5,-2022 # 80021000 <disk+0x2000>
    800057ee:	6b94                	ld	a3,16(a5)
    800057f0:	0207d703          	lhu	a4,32(a5)
    800057f4:	0026d783          	lhu	a5,2(a3)
    800057f8:	06f70163          	beq	a4,a5,8000585a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057fc:	0001a917          	auipc	s2,0x1a
    80005800:	80490913          	addi	s2,s2,-2044 # 8001f000 <disk>
    80005804:	0001b497          	auipc	s1,0x1b
    80005808:	7fc48493          	addi	s1,s1,2044 # 80021000 <disk+0x2000>
    __sync_synchronize();
    8000580c:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005810:	6898                	ld	a4,16(s1)
    80005812:	0204d783          	lhu	a5,32(s1)
    80005816:	8b9d                	andi	a5,a5,7
    80005818:	078e                	slli	a5,a5,0x3
    8000581a:	97ba                	add	a5,a5,a4
    8000581c:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000581e:	20078713          	addi	a4,a5,512
    80005822:	0712                	slli	a4,a4,0x4
    80005824:	974a                	add	a4,a4,s2
    80005826:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000582a:	e731                	bnez	a4,80005876 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000582c:	20078793          	addi	a5,a5,512
    80005830:	0792                	slli	a5,a5,0x4
    80005832:	97ca                	add	a5,a5,s2
    80005834:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005836:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000583a:	ffffc097          	auipc	ra,0xffffc
    8000583e:	e66080e7          	jalr	-410(ra) # 800016a0 <wakeup>

    disk.used_idx += 1;
    80005842:	0204d783          	lhu	a5,32(s1)
    80005846:	2785                	addiw	a5,a5,1
    80005848:	17c2                	slli	a5,a5,0x30
    8000584a:	93c1                	srli	a5,a5,0x30
    8000584c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005850:	6898                	ld	a4,16(s1)
    80005852:	00275703          	lhu	a4,2(a4)
    80005856:	faf71be3          	bne	a4,a5,8000580c <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000585a:	0001c517          	auipc	a0,0x1c
    8000585e:	8ce50513          	addi	a0,a0,-1842 # 80021128 <disk+0x2128>
    80005862:	00001097          	auipc	ra,0x1
    80005866:	bb2080e7          	jalr	-1102(ra) # 80006414 <release>
}
    8000586a:	60e2                	ld	ra,24(sp)
    8000586c:	6442                	ld	s0,16(sp)
    8000586e:	64a2                	ld	s1,8(sp)
    80005870:	6902                	ld	s2,0(sp)
    80005872:	6105                	addi	sp,sp,32
    80005874:	8082                	ret
      panic("virtio_disk_intr status");
    80005876:	00003517          	auipc	a0,0x3
    8000587a:	f1250513          	addi	a0,a0,-238 # 80008788 <syscalls+0x3c0>
    8000587e:	00000097          	auipc	ra,0x0
    80005882:	52a080e7          	jalr	1322(ra) # 80005da8 <panic>

0000000080005886 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005886:	1141                	addi	sp,sp,-16
    80005888:	e422                	sd	s0,8(sp)
    8000588a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000588c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005890:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005894:	0037979b          	slliw	a5,a5,0x3
    80005898:	02004737          	lui	a4,0x2004
    8000589c:	97ba                	add	a5,a5,a4
    8000589e:	0200c737          	lui	a4,0x200c
    800058a2:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058a6:	000f4637          	lui	a2,0xf4
    800058aa:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800058ae:	95b2                	add	a1,a1,a2
    800058b0:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800058b2:	00269713          	slli	a4,a3,0x2
    800058b6:	9736                	add	a4,a4,a3
    800058b8:	00371693          	slli	a3,a4,0x3
    800058bc:	0001c717          	auipc	a4,0x1c
    800058c0:	74470713          	addi	a4,a4,1860 # 80022000 <timer_scratch>
    800058c4:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800058c6:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800058c8:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800058ca:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058ce:	00000797          	auipc	a5,0x0
    800058d2:	97278793          	addi	a5,a5,-1678 # 80005240 <timervec>
    800058d6:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058da:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058de:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058e2:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058e6:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058ea:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058ee:	30479073          	csrw	mie,a5
}
    800058f2:	6422                	ld	s0,8(sp)
    800058f4:	0141                	addi	sp,sp,16
    800058f6:	8082                	ret

00000000800058f8 <start>:
{
    800058f8:	1141                	addi	sp,sp,-16
    800058fa:	e406                	sd	ra,8(sp)
    800058fc:	e022                	sd	s0,0(sp)
    800058fe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005900:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005904:	7779                	lui	a4,0xffffe
    80005906:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd45bf>
    8000590a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000590c:	6705                	lui	a4,0x1
    8000590e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005912:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005914:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005918:	ffffb797          	auipc	a5,0xffffb
    8000591c:	a0e78793          	addi	a5,a5,-1522 # 80000326 <main>
    80005920:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005924:	4781                	li	a5,0
    80005926:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000592a:	67c1                	lui	a5,0x10
    8000592c:	17fd                	addi	a5,a5,-1
    8000592e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005932:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005936:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000593a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000593e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005942:	57fd                	li	a5,-1
    80005944:	83a9                	srli	a5,a5,0xa
    80005946:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000594a:	47bd                	li	a5,15
    8000594c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005950:	00000097          	auipc	ra,0x0
    80005954:	f36080e7          	jalr	-202(ra) # 80005886 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005958:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000595c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000595e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005960:	30200073          	mret
}
    80005964:	60a2                	ld	ra,8(sp)
    80005966:	6402                	ld	s0,0(sp)
    80005968:	0141                	addi	sp,sp,16
    8000596a:	8082                	ret

000000008000596c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000596c:	715d                	addi	sp,sp,-80
    8000596e:	e486                	sd	ra,72(sp)
    80005970:	e0a2                	sd	s0,64(sp)
    80005972:	fc26                	sd	s1,56(sp)
    80005974:	f84a                	sd	s2,48(sp)
    80005976:	f44e                	sd	s3,40(sp)
    80005978:	f052                	sd	s4,32(sp)
    8000597a:	ec56                	sd	s5,24(sp)
    8000597c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000597e:	04c05663          	blez	a2,800059ca <consolewrite+0x5e>
    80005982:	8a2a                	mv	s4,a0
    80005984:	84ae                	mv	s1,a1
    80005986:	89b2                	mv	s3,a2
    80005988:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000598a:	5afd                	li	s5,-1
    8000598c:	4685                	li	a3,1
    8000598e:	8626                	mv	a2,s1
    80005990:	85d2                	mv	a1,s4
    80005992:	fbf40513          	addi	a0,s0,-65
    80005996:	ffffc097          	auipc	ra,0xffffc
    8000599a:	f78080e7          	jalr	-136(ra) # 8000190e <either_copyin>
    8000599e:	01550c63          	beq	a0,s5,800059b6 <consolewrite+0x4a>
      break;
    uartputc(c);
    800059a2:	fbf44503          	lbu	a0,-65(s0)
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	7fc080e7          	jalr	2044(ra) # 800061a2 <uartputc>
  for(i = 0; i < n; i++){
    800059ae:	2905                	addiw	s2,s2,1
    800059b0:	0485                	addi	s1,s1,1
    800059b2:	fd299de3          	bne	s3,s2,8000598c <consolewrite+0x20>
  }

  return i;
}
    800059b6:	854a                	mv	a0,s2
    800059b8:	60a6                	ld	ra,72(sp)
    800059ba:	6406                	ld	s0,64(sp)
    800059bc:	74e2                	ld	s1,56(sp)
    800059be:	7942                	ld	s2,48(sp)
    800059c0:	79a2                	ld	s3,40(sp)
    800059c2:	7a02                	ld	s4,32(sp)
    800059c4:	6ae2                	ld	s5,24(sp)
    800059c6:	6161                	addi	sp,sp,80
    800059c8:	8082                	ret
  for(i = 0; i < n; i++){
    800059ca:	4901                	li	s2,0
    800059cc:	b7ed                	j	800059b6 <consolewrite+0x4a>

00000000800059ce <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059ce:	7119                	addi	sp,sp,-128
    800059d0:	fc86                	sd	ra,120(sp)
    800059d2:	f8a2                	sd	s0,112(sp)
    800059d4:	f4a6                	sd	s1,104(sp)
    800059d6:	f0ca                	sd	s2,96(sp)
    800059d8:	ecce                	sd	s3,88(sp)
    800059da:	e8d2                	sd	s4,80(sp)
    800059dc:	e4d6                	sd	s5,72(sp)
    800059de:	e0da                	sd	s6,64(sp)
    800059e0:	fc5e                	sd	s7,56(sp)
    800059e2:	f862                	sd	s8,48(sp)
    800059e4:	f466                	sd	s9,40(sp)
    800059e6:	f06a                	sd	s10,32(sp)
    800059e8:	ec6e                	sd	s11,24(sp)
    800059ea:	0100                	addi	s0,sp,128
    800059ec:	8b2a                	mv	s6,a0
    800059ee:	8aae                	mv	s5,a1
    800059f0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059f2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059f6:	00024517          	auipc	a0,0x24
    800059fa:	74a50513          	addi	a0,a0,1866 # 8002a140 <cons>
    800059fe:	00001097          	auipc	ra,0x1
    80005a02:	962080e7          	jalr	-1694(ra) # 80006360 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a06:	00024497          	auipc	s1,0x24
    80005a0a:	73a48493          	addi	s1,s1,1850 # 8002a140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a0e:	89a6                	mv	s3,s1
    80005a10:	00024917          	auipc	s2,0x24
    80005a14:	7c890913          	addi	s2,s2,1992 # 8002a1d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005a18:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a1a:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a1c:	4da9                	li	s11,10
  while(n > 0){
    80005a1e:	07405863          	blez	s4,80005a8e <consoleread+0xc0>
    while(cons.r == cons.w){
    80005a22:	0984a783          	lw	a5,152(s1)
    80005a26:	09c4a703          	lw	a4,156(s1)
    80005a2a:	02f71463          	bne	a4,a5,80005a52 <consoleread+0x84>
      if(myproc()->killed){
    80005a2e:	ffffb097          	auipc	ra,0xffffb
    80005a32:	41a080e7          	jalr	1050(ra) # 80000e48 <myproc>
    80005a36:	551c                	lw	a5,40(a0)
    80005a38:	e7b5                	bnez	a5,80005aa4 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005a3a:	85ce                	mv	a1,s3
    80005a3c:	854a                	mv	a0,s2
    80005a3e:	ffffc097          	auipc	ra,0xffffc
    80005a42:	ad6080e7          	jalr	-1322(ra) # 80001514 <sleep>
    while(cons.r == cons.w){
    80005a46:	0984a783          	lw	a5,152(s1)
    80005a4a:	09c4a703          	lw	a4,156(s1)
    80005a4e:	fef700e3          	beq	a4,a5,80005a2e <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a52:	0017871b          	addiw	a4,a5,1
    80005a56:	08e4ac23          	sw	a4,152(s1)
    80005a5a:	07f7f713          	andi	a4,a5,127
    80005a5e:	9726                	add	a4,a4,s1
    80005a60:	01874703          	lbu	a4,24(a4)
    80005a64:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a68:	079c0663          	beq	s8,s9,80005ad4 <consoleread+0x106>
    cbuf = c;
    80005a6c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a70:	4685                	li	a3,1
    80005a72:	f8f40613          	addi	a2,s0,-113
    80005a76:	85d6                	mv	a1,s5
    80005a78:	855a                	mv	a0,s6
    80005a7a:	ffffc097          	auipc	ra,0xffffc
    80005a7e:	e3e080e7          	jalr	-450(ra) # 800018b8 <either_copyout>
    80005a82:	01a50663          	beq	a0,s10,80005a8e <consoleread+0xc0>
    dst++;
    80005a86:	0a85                	addi	s5,s5,1
    --n;
    80005a88:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a8a:	f9bc1ae3          	bne	s8,s11,80005a1e <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a8e:	00024517          	auipc	a0,0x24
    80005a92:	6b250513          	addi	a0,a0,1714 # 8002a140 <cons>
    80005a96:	00001097          	auipc	ra,0x1
    80005a9a:	97e080e7          	jalr	-1666(ra) # 80006414 <release>

  return target - n;
    80005a9e:	414b853b          	subw	a0,s7,s4
    80005aa2:	a811                	j	80005ab6 <consoleread+0xe8>
        release(&cons.lock);
    80005aa4:	00024517          	auipc	a0,0x24
    80005aa8:	69c50513          	addi	a0,a0,1692 # 8002a140 <cons>
    80005aac:	00001097          	auipc	ra,0x1
    80005ab0:	968080e7          	jalr	-1688(ra) # 80006414 <release>
        return -1;
    80005ab4:	557d                	li	a0,-1
}
    80005ab6:	70e6                	ld	ra,120(sp)
    80005ab8:	7446                	ld	s0,112(sp)
    80005aba:	74a6                	ld	s1,104(sp)
    80005abc:	7906                	ld	s2,96(sp)
    80005abe:	69e6                	ld	s3,88(sp)
    80005ac0:	6a46                	ld	s4,80(sp)
    80005ac2:	6aa6                	ld	s5,72(sp)
    80005ac4:	6b06                	ld	s6,64(sp)
    80005ac6:	7be2                	ld	s7,56(sp)
    80005ac8:	7c42                	ld	s8,48(sp)
    80005aca:	7ca2                	ld	s9,40(sp)
    80005acc:	7d02                	ld	s10,32(sp)
    80005ace:	6de2                	ld	s11,24(sp)
    80005ad0:	6109                	addi	sp,sp,128
    80005ad2:	8082                	ret
      if(n < target){
    80005ad4:	000a071b          	sext.w	a4,s4
    80005ad8:	fb777be3          	bgeu	a4,s7,80005a8e <consoleread+0xc0>
        cons.r--;
    80005adc:	00024717          	auipc	a4,0x24
    80005ae0:	6ef72e23          	sw	a5,1788(a4) # 8002a1d8 <cons+0x98>
    80005ae4:	b76d                	j	80005a8e <consoleread+0xc0>

0000000080005ae6 <consputc>:
{
    80005ae6:	1141                	addi	sp,sp,-16
    80005ae8:	e406                	sd	ra,8(sp)
    80005aea:	e022                	sd	s0,0(sp)
    80005aec:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aee:	10000793          	li	a5,256
    80005af2:	00f50a63          	beq	a0,a5,80005b06 <consputc+0x20>
    uartputc_sync(c);
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	5d2080e7          	jalr	1490(ra) # 800060c8 <uartputc_sync>
}
    80005afe:	60a2                	ld	ra,8(sp)
    80005b00:	6402                	ld	s0,0(sp)
    80005b02:	0141                	addi	sp,sp,16
    80005b04:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b06:	4521                	li	a0,8
    80005b08:	00000097          	auipc	ra,0x0
    80005b0c:	5c0080e7          	jalr	1472(ra) # 800060c8 <uartputc_sync>
    80005b10:	02000513          	li	a0,32
    80005b14:	00000097          	auipc	ra,0x0
    80005b18:	5b4080e7          	jalr	1460(ra) # 800060c8 <uartputc_sync>
    80005b1c:	4521                	li	a0,8
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	5aa080e7          	jalr	1450(ra) # 800060c8 <uartputc_sync>
    80005b26:	bfe1                	j	80005afe <consputc+0x18>

0000000080005b28 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b28:	1101                	addi	sp,sp,-32
    80005b2a:	ec06                	sd	ra,24(sp)
    80005b2c:	e822                	sd	s0,16(sp)
    80005b2e:	e426                	sd	s1,8(sp)
    80005b30:	e04a                	sd	s2,0(sp)
    80005b32:	1000                	addi	s0,sp,32
    80005b34:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b36:	00024517          	auipc	a0,0x24
    80005b3a:	60a50513          	addi	a0,a0,1546 # 8002a140 <cons>
    80005b3e:	00001097          	auipc	ra,0x1
    80005b42:	822080e7          	jalr	-2014(ra) # 80006360 <acquire>

  switch(c){
    80005b46:	47d5                	li	a5,21
    80005b48:	0af48663          	beq	s1,a5,80005bf4 <consoleintr+0xcc>
    80005b4c:	0297ca63          	blt	a5,s1,80005b80 <consoleintr+0x58>
    80005b50:	47a1                	li	a5,8
    80005b52:	0ef48763          	beq	s1,a5,80005c40 <consoleintr+0x118>
    80005b56:	47c1                	li	a5,16
    80005b58:	10f49a63          	bne	s1,a5,80005c6c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b5c:	ffffc097          	auipc	ra,0xffffc
    80005b60:	e08080e7          	jalr	-504(ra) # 80001964 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b64:	00024517          	auipc	a0,0x24
    80005b68:	5dc50513          	addi	a0,a0,1500 # 8002a140 <cons>
    80005b6c:	00001097          	auipc	ra,0x1
    80005b70:	8a8080e7          	jalr	-1880(ra) # 80006414 <release>
}
    80005b74:	60e2                	ld	ra,24(sp)
    80005b76:	6442                	ld	s0,16(sp)
    80005b78:	64a2                	ld	s1,8(sp)
    80005b7a:	6902                	ld	s2,0(sp)
    80005b7c:	6105                	addi	sp,sp,32
    80005b7e:	8082                	ret
  switch(c){
    80005b80:	07f00793          	li	a5,127
    80005b84:	0af48e63          	beq	s1,a5,80005c40 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b88:	00024717          	auipc	a4,0x24
    80005b8c:	5b870713          	addi	a4,a4,1464 # 8002a140 <cons>
    80005b90:	0a072783          	lw	a5,160(a4)
    80005b94:	09872703          	lw	a4,152(a4)
    80005b98:	9f99                	subw	a5,a5,a4
    80005b9a:	07f00713          	li	a4,127
    80005b9e:	fcf763e3          	bltu	a4,a5,80005b64 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ba2:	47b5                	li	a5,13
    80005ba4:	0cf48763          	beq	s1,a5,80005c72 <consoleintr+0x14a>
      consputc(c);
    80005ba8:	8526                	mv	a0,s1
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	f3c080e7          	jalr	-196(ra) # 80005ae6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bb2:	00024797          	auipc	a5,0x24
    80005bb6:	58e78793          	addi	a5,a5,1422 # 8002a140 <cons>
    80005bba:	0a07a703          	lw	a4,160(a5)
    80005bbe:	0017069b          	addiw	a3,a4,1
    80005bc2:	0006861b          	sext.w	a2,a3
    80005bc6:	0ad7a023          	sw	a3,160(a5)
    80005bca:	07f77713          	andi	a4,a4,127
    80005bce:	97ba                	add	a5,a5,a4
    80005bd0:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005bd4:	47a9                	li	a5,10
    80005bd6:	0cf48563          	beq	s1,a5,80005ca0 <consoleintr+0x178>
    80005bda:	4791                	li	a5,4
    80005bdc:	0cf48263          	beq	s1,a5,80005ca0 <consoleintr+0x178>
    80005be0:	00024797          	auipc	a5,0x24
    80005be4:	5f87a783          	lw	a5,1528(a5) # 8002a1d8 <cons+0x98>
    80005be8:	0807879b          	addiw	a5,a5,128
    80005bec:	f6f61ce3          	bne	a2,a5,80005b64 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005bf0:	863e                	mv	a2,a5
    80005bf2:	a07d                	j	80005ca0 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bf4:	00024717          	auipc	a4,0x24
    80005bf8:	54c70713          	addi	a4,a4,1356 # 8002a140 <cons>
    80005bfc:	0a072783          	lw	a5,160(a4)
    80005c00:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c04:	00024497          	auipc	s1,0x24
    80005c08:	53c48493          	addi	s1,s1,1340 # 8002a140 <cons>
    while(cons.e != cons.w &&
    80005c0c:	4929                	li	s2,10
    80005c0e:	f4f70be3          	beq	a4,a5,80005b64 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005c12:	37fd                	addiw	a5,a5,-1
    80005c14:	07f7f713          	andi	a4,a5,127
    80005c18:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c1a:	01874703          	lbu	a4,24(a4)
    80005c1e:	f52703e3          	beq	a4,s2,80005b64 <consoleintr+0x3c>
      cons.e--;
    80005c22:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c26:	10000513          	li	a0,256
    80005c2a:	00000097          	auipc	ra,0x0
    80005c2e:	ebc080e7          	jalr	-324(ra) # 80005ae6 <consputc>
    while(cons.e != cons.w &&
    80005c32:	0a04a783          	lw	a5,160(s1)
    80005c36:	09c4a703          	lw	a4,156(s1)
    80005c3a:	fcf71ce3          	bne	a4,a5,80005c12 <consoleintr+0xea>
    80005c3e:	b71d                	j	80005b64 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c40:	00024717          	auipc	a4,0x24
    80005c44:	50070713          	addi	a4,a4,1280 # 8002a140 <cons>
    80005c48:	0a072783          	lw	a5,160(a4)
    80005c4c:	09c72703          	lw	a4,156(a4)
    80005c50:	f0f70ae3          	beq	a4,a5,80005b64 <consoleintr+0x3c>
      cons.e--;
    80005c54:	37fd                	addiw	a5,a5,-1
    80005c56:	00024717          	auipc	a4,0x24
    80005c5a:	58f72523          	sw	a5,1418(a4) # 8002a1e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c5e:	10000513          	li	a0,256
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	e84080e7          	jalr	-380(ra) # 80005ae6 <consputc>
    80005c6a:	bded                	j	80005b64 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c6c:	ee048ce3          	beqz	s1,80005b64 <consoleintr+0x3c>
    80005c70:	bf21                	j	80005b88 <consoleintr+0x60>
      consputc(c);
    80005c72:	4529                	li	a0,10
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	e72080e7          	jalr	-398(ra) # 80005ae6 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c7c:	00024797          	auipc	a5,0x24
    80005c80:	4c478793          	addi	a5,a5,1220 # 8002a140 <cons>
    80005c84:	0a07a703          	lw	a4,160(a5)
    80005c88:	0017069b          	addiw	a3,a4,1
    80005c8c:	0006861b          	sext.w	a2,a3
    80005c90:	0ad7a023          	sw	a3,160(a5)
    80005c94:	07f77713          	andi	a4,a4,127
    80005c98:	97ba                	add	a5,a5,a4
    80005c9a:	4729                	li	a4,10
    80005c9c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ca0:	00024797          	auipc	a5,0x24
    80005ca4:	52c7ae23          	sw	a2,1340(a5) # 8002a1dc <cons+0x9c>
        wakeup(&cons.r);
    80005ca8:	00024517          	auipc	a0,0x24
    80005cac:	53050513          	addi	a0,a0,1328 # 8002a1d8 <cons+0x98>
    80005cb0:	ffffc097          	auipc	ra,0xffffc
    80005cb4:	9f0080e7          	jalr	-1552(ra) # 800016a0 <wakeup>
    80005cb8:	b575                	j	80005b64 <consoleintr+0x3c>

0000000080005cba <consoleinit>:

void
consoleinit(void)
{
    80005cba:	1141                	addi	sp,sp,-16
    80005cbc:	e406                	sd	ra,8(sp)
    80005cbe:	e022                	sd	s0,0(sp)
    80005cc0:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cc2:	00003597          	auipc	a1,0x3
    80005cc6:	ade58593          	addi	a1,a1,-1314 # 800087a0 <syscalls+0x3d8>
    80005cca:	00024517          	auipc	a0,0x24
    80005cce:	47650513          	addi	a0,a0,1142 # 8002a140 <cons>
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	5fe080e7          	jalr	1534(ra) # 800062d0 <initlock>

  uartinit();
    80005cda:	00000097          	auipc	ra,0x0
    80005cde:	39e080e7          	jalr	926(ra) # 80006078 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ce2:	00017797          	auipc	a5,0x17
    80005ce6:	7e678793          	addi	a5,a5,2022 # 8001d4c8 <devsw>
    80005cea:	00000717          	auipc	a4,0x0
    80005cee:	ce470713          	addi	a4,a4,-796 # 800059ce <consoleread>
    80005cf2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cf4:	00000717          	auipc	a4,0x0
    80005cf8:	c7870713          	addi	a4,a4,-904 # 8000596c <consolewrite>
    80005cfc:	ef98                	sd	a4,24(a5)
}
    80005cfe:	60a2                	ld	ra,8(sp)
    80005d00:	6402                	ld	s0,0(sp)
    80005d02:	0141                	addi	sp,sp,16
    80005d04:	8082                	ret

0000000080005d06 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d06:	7179                	addi	sp,sp,-48
    80005d08:	f406                	sd	ra,40(sp)
    80005d0a:	f022                	sd	s0,32(sp)
    80005d0c:	ec26                	sd	s1,24(sp)
    80005d0e:	e84a                	sd	s2,16(sp)
    80005d10:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d12:	c219                	beqz	a2,80005d18 <printint+0x12>
    80005d14:	08054663          	bltz	a0,80005da0 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005d18:	2501                	sext.w	a0,a0
    80005d1a:	4881                	li	a7,0
    80005d1c:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d20:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d22:	2581                	sext.w	a1,a1
    80005d24:	00003617          	auipc	a2,0x3
    80005d28:	acc60613          	addi	a2,a2,-1332 # 800087f0 <digits>
    80005d2c:	883a                	mv	a6,a4
    80005d2e:	2705                	addiw	a4,a4,1
    80005d30:	02b577bb          	remuw	a5,a0,a1
    80005d34:	1782                	slli	a5,a5,0x20
    80005d36:	9381                	srli	a5,a5,0x20
    80005d38:	97b2                	add	a5,a5,a2
    80005d3a:	0007c783          	lbu	a5,0(a5)
    80005d3e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d42:	0005079b          	sext.w	a5,a0
    80005d46:	02b5553b          	divuw	a0,a0,a1
    80005d4a:	0685                	addi	a3,a3,1
    80005d4c:	feb7f0e3          	bgeu	a5,a1,80005d2c <printint+0x26>

  if(sign)
    80005d50:	00088b63          	beqz	a7,80005d66 <printint+0x60>
    buf[i++] = '-';
    80005d54:	fe040793          	addi	a5,s0,-32
    80005d58:	973e                	add	a4,a4,a5
    80005d5a:	02d00793          	li	a5,45
    80005d5e:	fef70823          	sb	a5,-16(a4)
    80005d62:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d66:	02e05763          	blez	a4,80005d94 <printint+0x8e>
    80005d6a:	fd040793          	addi	a5,s0,-48
    80005d6e:	00e784b3          	add	s1,a5,a4
    80005d72:	fff78913          	addi	s2,a5,-1
    80005d76:	993a                	add	s2,s2,a4
    80005d78:	377d                	addiw	a4,a4,-1
    80005d7a:	1702                	slli	a4,a4,0x20
    80005d7c:	9301                	srli	a4,a4,0x20
    80005d7e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d82:	fff4c503          	lbu	a0,-1(s1)
    80005d86:	00000097          	auipc	ra,0x0
    80005d8a:	d60080e7          	jalr	-672(ra) # 80005ae6 <consputc>
  while(--i >= 0)
    80005d8e:	14fd                	addi	s1,s1,-1
    80005d90:	ff2499e3          	bne	s1,s2,80005d82 <printint+0x7c>
}
    80005d94:	70a2                	ld	ra,40(sp)
    80005d96:	7402                	ld	s0,32(sp)
    80005d98:	64e2                	ld	s1,24(sp)
    80005d9a:	6942                	ld	s2,16(sp)
    80005d9c:	6145                	addi	sp,sp,48
    80005d9e:	8082                	ret
    x = -xx;
    80005da0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005da4:	4885                	li	a7,1
    x = -xx;
    80005da6:	bf9d                	j	80005d1c <printint+0x16>

0000000080005da8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005da8:	1101                	addi	sp,sp,-32
    80005daa:	ec06                	sd	ra,24(sp)
    80005dac:	e822                	sd	s0,16(sp)
    80005dae:	e426                	sd	s1,8(sp)
    80005db0:	1000                	addi	s0,sp,32
    80005db2:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005db4:	00024797          	auipc	a5,0x24
    80005db8:	4407a623          	sw	zero,1100(a5) # 8002a200 <pr+0x18>
  printf("panic: ");
    80005dbc:	00003517          	auipc	a0,0x3
    80005dc0:	9ec50513          	addi	a0,a0,-1556 # 800087a8 <syscalls+0x3e0>
    80005dc4:	00000097          	auipc	ra,0x0
    80005dc8:	02e080e7          	jalr	46(ra) # 80005df2 <printf>
  printf(s);
    80005dcc:	8526                	mv	a0,s1
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	024080e7          	jalr	36(ra) # 80005df2 <printf>
  printf("\n");
    80005dd6:	00002517          	auipc	a0,0x2
    80005dda:	27250513          	addi	a0,a0,626 # 80008048 <etext+0x48>
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	014080e7          	jalr	20(ra) # 80005df2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005de6:	4785                	li	a5,1
    80005de8:	00003717          	auipc	a4,0x3
    80005dec:	22f72a23          	sw	a5,564(a4) # 8000901c <panicked>
  for(;;)
    80005df0:	a001                	j	80005df0 <panic+0x48>

0000000080005df2 <printf>:
{
    80005df2:	7131                	addi	sp,sp,-192
    80005df4:	fc86                	sd	ra,120(sp)
    80005df6:	f8a2                	sd	s0,112(sp)
    80005df8:	f4a6                	sd	s1,104(sp)
    80005dfa:	f0ca                	sd	s2,96(sp)
    80005dfc:	ecce                	sd	s3,88(sp)
    80005dfe:	e8d2                	sd	s4,80(sp)
    80005e00:	e4d6                	sd	s5,72(sp)
    80005e02:	e0da                	sd	s6,64(sp)
    80005e04:	fc5e                	sd	s7,56(sp)
    80005e06:	f862                	sd	s8,48(sp)
    80005e08:	f466                	sd	s9,40(sp)
    80005e0a:	f06a                	sd	s10,32(sp)
    80005e0c:	ec6e                	sd	s11,24(sp)
    80005e0e:	0100                	addi	s0,sp,128
    80005e10:	8a2a                	mv	s4,a0
    80005e12:	e40c                	sd	a1,8(s0)
    80005e14:	e810                	sd	a2,16(s0)
    80005e16:	ec14                	sd	a3,24(s0)
    80005e18:	f018                	sd	a4,32(s0)
    80005e1a:	f41c                	sd	a5,40(s0)
    80005e1c:	03043823          	sd	a6,48(s0)
    80005e20:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e24:	00024d97          	auipc	s11,0x24
    80005e28:	3dcdad83          	lw	s11,988(s11) # 8002a200 <pr+0x18>
  if(locking)
    80005e2c:	020d9b63          	bnez	s11,80005e62 <printf+0x70>
  if (fmt == 0)
    80005e30:	040a0263          	beqz	s4,80005e74 <printf+0x82>
  va_start(ap, fmt);
    80005e34:	00840793          	addi	a5,s0,8
    80005e38:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e3c:	000a4503          	lbu	a0,0(s4)
    80005e40:	16050263          	beqz	a0,80005fa4 <printf+0x1b2>
    80005e44:	4481                	li	s1,0
    if(c != '%'){
    80005e46:	02500a93          	li	s5,37
    switch(c){
    80005e4a:	07000b13          	li	s6,112
  consputc('x');
    80005e4e:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e50:	00003b97          	auipc	s7,0x3
    80005e54:	9a0b8b93          	addi	s7,s7,-1632 # 800087f0 <digits>
    switch(c){
    80005e58:	07300c93          	li	s9,115
    80005e5c:	06400c13          	li	s8,100
    80005e60:	a82d                	j	80005e9a <printf+0xa8>
    acquire(&pr.lock);
    80005e62:	00024517          	auipc	a0,0x24
    80005e66:	38650513          	addi	a0,a0,902 # 8002a1e8 <pr>
    80005e6a:	00000097          	auipc	ra,0x0
    80005e6e:	4f6080e7          	jalr	1270(ra) # 80006360 <acquire>
    80005e72:	bf7d                	j	80005e30 <printf+0x3e>
    panic("null fmt");
    80005e74:	00003517          	auipc	a0,0x3
    80005e78:	94450513          	addi	a0,a0,-1724 # 800087b8 <syscalls+0x3f0>
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	f2c080e7          	jalr	-212(ra) # 80005da8 <panic>
      consputc(c);
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	c62080e7          	jalr	-926(ra) # 80005ae6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e8c:	2485                	addiw	s1,s1,1
    80005e8e:	009a07b3          	add	a5,s4,s1
    80005e92:	0007c503          	lbu	a0,0(a5)
    80005e96:	10050763          	beqz	a0,80005fa4 <printf+0x1b2>
    if(c != '%'){
    80005e9a:	ff5515e3          	bne	a0,s5,80005e84 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e9e:	2485                	addiw	s1,s1,1
    80005ea0:	009a07b3          	add	a5,s4,s1
    80005ea4:	0007c783          	lbu	a5,0(a5)
    80005ea8:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005eac:	cfe5                	beqz	a5,80005fa4 <printf+0x1b2>
    switch(c){
    80005eae:	05678a63          	beq	a5,s6,80005f02 <printf+0x110>
    80005eb2:	02fb7663          	bgeu	s6,a5,80005ede <printf+0xec>
    80005eb6:	09978963          	beq	a5,s9,80005f48 <printf+0x156>
    80005eba:	07800713          	li	a4,120
    80005ebe:	0ce79863          	bne	a5,a4,80005f8e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ec2:	f8843783          	ld	a5,-120(s0)
    80005ec6:	00878713          	addi	a4,a5,8
    80005eca:	f8e43423          	sd	a4,-120(s0)
    80005ece:	4605                	li	a2,1
    80005ed0:	85ea                	mv	a1,s10
    80005ed2:	4388                	lw	a0,0(a5)
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	e32080e7          	jalr	-462(ra) # 80005d06 <printint>
      break;
    80005edc:	bf45                	j	80005e8c <printf+0x9a>
    switch(c){
    80005ede:	0b578263          	beq	a5,s5,80005f82 <printf+0x190>
    80005ee2:	0b879663          	bne	a5,s8,80005f8e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ee6:	f8843783          	ld	a5,-120(s0)
    80005eea:	00878713          	addi	a4,a5,8
    80005eee:	f8e43423          	sd	a4,-120(s0)
    80005ef2:	4605                	li	a2,1
    80005ef4:	45a9                	li	a1,10
    80005ef6:	4388                	lw	a0,0(a5)
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	e0e080e7          	jalr	-498(ra) # 80005d06 <printint>
      break;
    80005f00:	b771                	j	80005e8c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f02:	f8843783          	ld	a5,-120(s0)
    80005f06:	00878713          	addi	a4,a5,8
    80005f0a:	f8e43423          	sd	a4,-120(s0)
    80005f0e:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005f12:	03000513          	li	a0,48
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	bd0080e7          	jalr	-1072(ra) # 80005ae6 <consputc>
  consputc('x');
    80005f1e:	07800513          	li	a0,120
    80005f22:	00000097          	auipc	ra,0x0
    80005f26:	bc4080e7          	jalr	-1084(ra) # 80005ae6 <consputc>
    80005f2a:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2c:	03c9d793          	srli	a5,s3,0x3c
    80005f30:	97de                	add	a5,a5,s7
    80005f32:	0007c503          	lbu	a0,0(a5)
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	bb0080e7          	jalr	-1104(ra) # 80005ae6 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f3e:	0992                	slli	s3,s3,0x4
    80005f40:	397d                	addiw	s2,s2,-1
    80005f42:	fe0915e3          	bnez	s2,80005f2c <printf+0x13a>
    80005f46:	b799                	j	80005e8c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f48:	f8843783          	ld	a5,-120(s0)
    80005f4c:	00878713          	addi	a4,a5,8
    80005f50:	f8e43423          	sd	a4,-120(s0)
    80005f54:	0007b903          	ld	s2,0(a5)
    80005f58:	00090e63          	beqz	s2,80005f74 <printf+0x182>
      for(; *s; s++)
    80005f5c:	00094503          	lbu	a0,0(s2)
    80005f60:	d515                	beqz	a0,80005e8c <printf+0x9a>
        consputc(*s);
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	b84080e7          	jalr	-1148(ra) # 80005ae6 <consputc>
      for(; *s; s++)
    80005f6a:	0905                	addi	s2,s2,1
    80005f6c:	00094503          	lbu	a0,0(s2)
    80005f70:	f96d                	bnez	a0,80005f62 <printf+0x170>
    80005f72:	bf29                	j	80005e8c <printf+0x9a>
        s = "(null)";
    80005f74:	00003917          	auipc	s2,0x3
    80005f78:	83c90913          	addi	s2,s2,-1988 # 800087b0 <syscalls+0x3e8>
      for(; *s; s++)
    80005f7c:	02800513          	li	a0,40
    80005f80:	b7cd                	j	80005f62 <printf+0x170>
      consputc('%');
    80005f82:	8556                	mv	a0,s5
    80005f84:	00000097          	auipc	ra,0x0
    80005f88:	b62080e7          	jalr	-1182(ra) # 80005ae6 <consputc>
      break;
    80005f8c:	b701                	j	80005e8c <printf+0x9a>
      consputc('%');
    80005f8e:	8556                	mv	a0,s5
    80005f90:	00000097          	auipc	ra,0x0
    80005f94:	b56080e7          	jalr	-1194(ra) # 80005ae6 <consputc>
      consputc(c);
    80005f98:	854a                	mv	a0,s2
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	b4c080e7          	jalr	-1204(ra) # 80005ae6 <consputc>
      break;
    80005fa2:	b5ed                	j	80005e8c <printf+0x9a>
  if(locking)
    80005fa4:	020d9163          	bnez	s11,80005fc6 <printf+0x1d4>
}
    80005fa8:	70e6                	ld	ra,120(sp)
    80005faa:	7446                	ld	s0,112(sp)
    80005fac:	74a6                	ld	s1,104(sp)
    80005fae:	7906                	ld	s2,96(sp)
    80005fb0:	69e6                	ld	s3,88(sp)
    80005fb2:	6a46                	ld	s4,80(sp)
    80005fb4:	6aa6                	ld	s5,72(sp)
    80005fb6:	6b06                	ld	s6,64(sp)
    80005fb8:	7be2                	ld	s7,56(sp)
    80005fba:	7c42                	ld	s8,48(sp)
    80005fbc:	7ca2                	ld	s9,40(sp)
    80005fbe:	7d02                	ld	s10,32(sp)
    80005fc0:	6de2                	ld	s11,24(sp)
    80005fc2:	6129                	addi	sp,sp,192
    80005fc4:	8082                	ret
    release(&pr.lock);
    80005fc6:	00024517          	auipc	a0,0x24
    80005fca:	22250513          	addi	a0,a0,546 # 8002a1e8 <pr>
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	446080e7          	jalr	1094(ra) # 80006414 <release>
}
    80005fd6:	bfc9                	j	80005fa8 <printf+0x1b6>

0000000080005fd8 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fd8:	1101                	addi	sp,sp,-32
    80005fda:	ec06                	sd	ra,24(sp)
    80005fdc:	e822                	sd	s0,16(sp)
    80005fde:	e426                	sd	s1,8(sp)
    80005fe0:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fe2:	00024497          	auipc	s1,0x24
    80005fe6:	20648493          	addi	s1,s1,518 # 8002a1e8 <pr>
    80005fea:	00002597          	auipc	a1,0x2
    80005fee:	7de58593          	addi	a1,a1,2014 # 800087c8 <syscalls+0x400>
    80005ff2:	8526                	mv	a0,s1
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	2dc080e7          	jalr	732(ra) # 800062d0 <initlock>
  pr.locking = 1;
    80005ffc:	4785                	li	a5,1
    80005ffe:	cc9c                	sw	a5,24(s1)
}
    80006000:	60e2                	ld	ra,24(sp)
    80006002:	6442                	ld	s0,16(sp)
    80006004:	64a2                	ld	s1,8(sp)
    80006006:	6105                	addi	sp,sp,32
    80006008:	8082                	ret

000000008000600a <backtrace>:

void
backtrace(void)
{
    8000600a:	7179                	addi	sp,sp,-48
    8000600c:	f406                	sd	ra,40(sp)
    8000600e:	f022                	sd	s0,32(sp)
    80006010:	ec26                	sd	s1,24(sp)
    80006012:	e84a                	sd	s2,16(sp)
    80006014:	e44e                	sd	s3,8(sp)
    80006016:	e052                	sd	s4,0(sp)
    80006018:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    8000601a:	00002517          	auipc	a0,0x2
    8000601e:	7b650513          	addi	a0,a0,1974 # 800087d0 <syscalls+0x408>
    80006022:	00000097          	auipc	ra,0x0
    80006026:	dd0080e7          	jalr	-560(ra) # 80005df2 <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    8000602a:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  uint64 top = PGROUNDUP(fp);
    8000602c:	6905                	lui	s2,0x1
    8000602e:	197d                	addi	s2,s2,-1
    80006030:	9926                	add	s2,s2,s1
    80006032:	79fd                	lui	s3,0xfffff
    80006034:	01397933          	and	s2,s2,s3
  uint64 down = PGROUNDDOWN(fp);
    80006038:	0134f9b3          	and	s3,s1,s3

  while ( fp<top && fp>down)
    8000603c:	0324f663          	bgeu	s1,s2,80006068 <backtrace+0x5e>
    80006040:	0299f463          	bgeu	s3,s1,80006068 <backtrace+0x5e>
  {
    uint64 ra = *(uint64 *)(fp-8);
    printf("fp: %p ra: %p \n", fp , ra );
    80006044:	00002a17          	auipc	s4,0x2
    80006048:	79ca0a13          	addi	s4,s4,1948 # 800087e0 <syscalls+0x418>
    8000604c:	ff84b603          	ld	a2,-8(s1)
    80006050:	85a6                	mv	a1,s1
    80006052:	8552                	mv	a0,s4
    80006054:	00000097          	auipc	ra,0x0
    80006058:	d9e080e7          	jalr	-610(ra) # 80005df2 <printf>
    fp = *(uint64 *)(fp-16);
    8000605c:	ff04b483          	ld	s1,-16(s1)
  while ( fp<top && fp>down)
    80006060:	0124f463          	bgeu	s1,s2,80006068 <backtrace+0x5e>
    80006064:	fe99e4e3          	bltu	s3,s1,8000604c <backtrace+0x42>
  }
    80006068:	70a2                	ld	ra,40(sp)
    8000606a:	7402                	ld	s0,32(sp)
    8000606c:	64e2                	ld	s1,24(sp)
    8000606e:	6942                	ld	s2,16(sp)
    80006070:	69a2                	ld	s3,8(sp)
    80006072:	6a02                	ld	s4,0(sp)
    80006074:	6145                	addi	sp,sp,48
    80006076:	8082                	ret

0000000080006078 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006078:	1141                	addi	sp,sp,-16
    8000607a:	e406                	sd	ra,8(sp)
    8000607c:	e022                	sd	s0,0(sp)
    8000607e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006080:	100007b7          	lui	a5,0x10000
    80006084:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006088:	f8000713          	li	a4,-128
    8000608c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006090:	470d                	li	a4,3
    80006092:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006096:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000609a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000609e:	469d                	li	a3,7
    800060a0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800060a4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060a8:	00002597          	auipc	a1,0x2
    800060ac:	76058593          	addi	a1,a1,1888 # 80008808 <digits+0x18>
    800060b0:	00024517          	auipc	a0,0x24
    800060b4:	15850513          	addi	a0,a0,344 # 8002a208 <uart_tx_lock>
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	218080e7          	jalr	536(ra) # 800062d0 <initlock>
}
    800060c0:	60a2                	ld	ra,8(sp)
    800060c2:	6402                	ld	s0,0(sp)
    800060c4:	0141                	addi	sp,sp,16
    800060c6:	8082                	ret

00000000800060c8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060c8:	1101                	addi	sp,sp,-32
    800060ca:	ec06                	sd	ra,24(sp)
    800060cc:	e822                	sd	s0,16(sp)
    800060ce:	e426                	sd	s1,8(sp)
    800060d0:	1000                	addi	s0,sp,32
    800060d2:	84aa                	mv	s1,a0
  push_off();
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	240080e7          	jalr	576(ra) # 80006314 <push_off>

  if(panicked){
    800060dc:	00003797          	auipc	a5,0x3
    800060e0:	f407a783          	lw	a5,-192(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060e4:	10000737          	lui	a4,0x10000
  if(panicked){
    800060e8:	c391                	beqz	a5,800060ec <uartputc_sync+0x24>
    for(;;)
    800060ea:	a001                	j	800060ea <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060ec:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060f0:	0ff7f793          	andi	a5,a5,255
    800060f4:	0207f793          	andi	a5,a5,32
    800060f8:	dbf5                	beqz	a5,800060ec <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060fa:	0ff4f793          	andi	a5,s1,255
    800060fe:	10000737          	lui	a4,0x10000
    80006102:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	2ae080e7          	jalr	686(ra) # 800063b4 <pop_off>
}
    8000610e:	60e2                	ld	ra,24(sp)
    80006110:	6442                	ld	s0,16(sp)
    80006112:	64a2                	ld	s1,8(sp)
    80006114:	6105                	addi	sp,sp,32
    80006116:	8082                	ret

0000000080006118 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006118:	00003717          	auipc	a4,0x3
    8000611c:	f0873703          	ld	a4,-248(a4) # 80009020 <uart_tx_r>
    80006120:	00003797          	auipc	a5,0x3
    80006124:	f087b783          	ld	a5,-248(a5) # 80009028 <uart_tx_w>
    80006128:	06e78c63          	beq	a5,a4,800061a0 <uartstart+0x88>
{
    8000612c:	7139                	addi	sp,sp,-64
    8000612e:	fc06                	sd	ra,56(sp)
    80006130:	f822                	sd	s0,48(sp)
    80006132:	f426                	sd	s1,40(sp)
    80006134:	f04a                	sd	s2,32(sp)
    80006136:	ec4e                	sd	s3,24(sp)
    80006138:	e852                	sd	s4,16(sp)
    8000613a:	e456                	sd	s5,8(sp)
    8000613c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000613e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006142:	00024a17          	auipc	s4,0x24
    80006146:	0c6a0a13          	addi	s4,s4,198 # 8002a208 <uart_tx_lock>
    uart_tx_r += 1;
    8000614a:	00003497          	auipc	s1,0x3
    8000614e:	ed648493          	addi	s1,s1,-298 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006152:	00003997          	auipc	s3,0x3
    80006156:	ed698993          	addi	s3,s3,-298 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000615a:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000615e:	0ff7f793          	andi	a5,a5,255
    80006162:	0207f793          	andi	a5,a5,32
    80006166:	c785                	beqz	a5,8000618e <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006168:	01f77793          	andi	a5,a4,31
    8000616c:	97d2                	add	a5,a5,s4
    8000616e:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80006172:	0705                	addi	a4,a4,1
    80006174:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006176:	8526                	mv	a0,s1
    80006178:	ffffb097          	auipc	ra,0xffffb
    8000617c:	528080e7          	jalr	1320(ra) # 800016a0 <wakeup>
    
    WriteReg(THR, c);
    80006180:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006184:	6098                	ld	a4,0(s1)
    80006186:	0009b783          	ld	a5,0(s3)
    8000618a:	fce798e3          	bne	a5,a4,8000615a <uartstart+0x42>
  }
}
    8000618e:	70e2                	ld	ra,56(sp)
    80006190:	7442                	ld	s0,48(sp)
    80006192:	74a2                	ld	s1,40(sp)
    80006194:	7902                	ld	s2,32(sp)
    80006196:	69e2                	ld	s3,24(sp)
    80006198:	6a42                	ld	s4,16(sp)
    8000619a:	6aa2                	ld	s5,8(sp)
    8000619c:	6121                	addi	sp,sp,64
    8000619e:	8082                	ret
    800061a0:	8082                	ret

00000000800061a2 <uartputc>:
{
    800061a2:	7179                	addi	sp,sp,-48
    800061a4:	f406                	sd	ra,40(sp)
    800061a6:	f022                	sd	s0,32(sp)
    800061a8:	ec26                	sd	s1,24(sp)
    800061aa:	e84a                	sd	s2,16(sp)
    800061ac:	e44e                	sd	s3,8(sp)
    800061ae:	e052                	sd	s4,0(sp)
    800061b0:	1800                	addi	s0,sp,48
    800061b2:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800061b4:	00024517          	auipc	a0,0x24
    800061b8:	05450513          	addi	a0,a0,84 # 8002a208 <uart_tx_lock>
    800061bc:	00000097          	auipc	ra,0x0
    800061c0:	1a4080e7          	jalr	420(ra) # 80006360 <acquire>
  if(panicked){
    800061c4:	00003797          	auipc	a5,0x3
    800061c8:	e587a783          	lw	a5,-424(a5) # 8000901c <panicked>
    800061cc:	c391                	beqz	a5,800061d0 <uartputc+0x2e>
    for(;;)
    800061ce:	a001                	j	800061ce <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061d0:	00003797          	auipc	a5,0x3
    800061d4:	e587b783          	ld	a5,-424(a5) # 80009028 <uart_tx_w>
    800061d8:	00003717          	auipc	a4,0x3
    800061dc:	e4873703          	ld	a4,-440(a4) # 80009020 <uart_tx_r>
    800061e0:	02070713          	addi	a4,a4,32
    800061e4:	02f71b63          	bne	a4,a5,8000621a <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061e8:	00024a17          	auipc	s4,0x24
    800061ec:	020a0a13          	addi	s4,s4,32 # 8002a208 <uart_tx_lock>
    800061f0:	00003497          	auipc	s1,0x3
    800061f4:	e3048493          	addi	s1,s1,-464 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061f8:	00003917          	auipc	s2,0x3
    800061fc:	e3090913          	addi	s2,s2,-464 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006200:	85d2                	mv	a1,s4
    80006202:	8526                	mv	a0,s1
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	310080e7          	jalr	784(ra) # 80001514 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620c:	00093783          	ld	a5,0(s2)
    80006210:	6098                	ld	a4,0(s1)
    80006212:	02070713          	addi	a4,a4,32
    80006216:	fef705e3          	beq	a4,a5,80006200 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000621a:	00024497          	auipc	s1,0x24
    8000621e:	fee48493          	addi	s1,s1,-18 # 8002a208 <uart_tx_lock>
    80006222:	01f7f713          	andi	a4,a5,31
    80006226:	9726                	add	a4,a4,s1
    80006228:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000622c:	0785                	addi	a5,a5,1
    8000622e:	00003717          	auipc	a4,0x3
    80006232:	def73d23          	sd	a5,-518(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006236:	00000097          	auipc	ra,0x0
    8000623a:	ee2080e7          	jalr	-286(ra) # 80006118 <uartstart>
      release(&uart_tx_lock);
    8000623e:	8526                	mv	a0,s1
    80006240:	00000097          	auipc	ra,0x0
    80006244:	1d4080e7          	jalr	468(ra) # 80006414 <release>
}
    80006248:	70a2                	ld	ra,40(sp)
    8000624a:	7402                	ld	s0,32(sp)
    8000624c:	64e2                	ld	s1,24(sp)
    8000624e:	6942                	ld	s2,16(sp)
    80006250:	69a2                	ld	s3,8(sp)
    80006252:	6a02                	ld	s4,0(sp)
    80006254:	6145                	addi	sp,sp,48
    80006256:	8082                	ret

0000000080006258 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006258:	1141                	addi	sp,sp,-16
    8000625a:	e422                	sd	s0,8(sp)
    8000625c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000625e:	100007b7          	lui	a5,0x10000
    80006262:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006266:	8b85                	andi	a5,a5,1
    80006268:	cb91                	beqz	a5,8000627c <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000626a:	100007b7          	lui	a5,0x10000
    8000626e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006272:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006276:	6422                	ld	s0,8(sp)
    80006278:	0141                	addi	sp,sp,16
    8000627a:	8082                	ret
    return -1;
    8000627c:	557d                	li	a0,-1
    8000627e:	bfe5                	j	80006276 <uartgetc+0x1e>

0000000080006280 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006280:	1101                	addi	sp,sp,-32
    80006282:	ec06                	sd	ra,24(sp)
    80006284:	e822                	sd	s0,16(sp)
    80006286:	e426                	sd	s1,8(sp)
    80006288:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000628a:	54fd                	li	s1,-1
    int c = uartgetc();
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	fcc080e7          	jalr	-52(ra) # 80006258 <uartgetc>
    if(c == -1)
    80006294:	00950763          	beq	a0,s1,800062a2 <uartintr+0x22>
      break;
    consoleintr(c);
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	890080e7          	jalr	-1904(ra) # 80005b28 <consoleintr>
  while(1){
    800062a0:	b7f5                	j	8000628c <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062a2:	00024497          	auipc	s1,0x24
    800062a6:	f6648493          	addi	s1,s1,-154 # 8002a208 <uart_tx_lock>
    800062aa:	8526                	mv	a0,s1
    800062ac:	00000097          	auipc	ra,0x0
    800062b0:	0b4080e7          	jalr	180(ra) # 80006360 <acquire>
  uartstart();
    800062b4:	00000097          	auipc	ra,0x0
    800062b8:	e64080e7          	jalr	-412(ra) # 80006118 <uartstart>
  release(&uart_tx_lock);
    800062bc:	8526                	mv	a0,s1
    800062be:	00000097          	auipc	ra,0x0
    800062c2:	156080e7          	jalr	342(ra) # 80006414 <release>
}
    800062c6:	60e2                	ld	ra,24(sp)
    800062c8:	6442                	ld	s0,16(sp)
    800062ca:	64a2                	ld	s1,8(sp)
    800062cc:	6105                	addi	sp,sp,32
    800062ce:	8082                	ret

00000000800062d0 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062d0:	1141                	addi	sp,sp,-16
    800062d2:	e422                	sd	s0,8(sp)
    800062d4:	0800                	addi	s0,sp,16
  lk->name = name;
    800062d6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062d8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062dc:	00053823          	sd	zero,16(a0)
}
    800062e0:	6422                	ld	s0,8(sp)
    800062e2:	0141                	addi	sp,sp,16
    800062e4:	8082                	ret

00000000800062e6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062e6:	411c                	lw	a5,0(a0)
    800062e8:	e399                	bnez	a5,800062ee <holding+0x8>
    800062ea:	4501                	li	a0,0
  return r;
}
    800062ec:	8082                	ret
{
    800062ee:	1101                	addi	sp,sp,-32
    800062f0:	ec06                	sd	ra,24(sp)
    800062f2:	e822                	sd	s0,16(sp)
    800062f4:	e426                	sd	s1,8(sp)
    800062f6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062f8:	6904                	ld	s1,16(a0)
    800062fa:	ffffb097          	auipc	ra,0xffffb
    800062fe:	b32080e7          	jalr	-1230(ra) # 80000e2c <mycpu>
    80006302:	40a48533          	sub	a0,s1,a0
    80006306:	00153513          	seqz	a0,a0
}
    8000630a:	60e2                	ld	ra,24(sp)
    8000630c:	6442                	ld	s0,16(sp)
    8000630e:	64a2                	ld	s1,8(sp)
    80006310:	6105                	addi	sp,sp,32
    80006312:	8082                	ret

0000000080006314 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006314:	1101                	addi	sp,sp,-32
    80006316:	ec06                	sd	ra,24(sp)
    80006318:	e822                	sd	s0,16(sp)
    8000631a:	e426                	sd	s1,8(sp)
    8000631c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000631e:	100024f3          	csrr	s1,sstatus
    80006322:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006326:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006328:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000632c:	ffffb097          	auipc	ra,0xffffb
    80006330:	b00080e7          	jalr	-1280(ra) # 80000e2c <mycpu>
    80006334:	5d3c                	lw	a5,120(a0)
    80006336:	cf89                	beqz	a5,80006350 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006338:	ffffb097          	auipc	ra,0xffffb
    8000633c:	af4080e7          	jalr	-1292(ra) # 80000e2c <mycpu>
    80006340:	5d3c                	lw	a5,120(a0)
    80006342:	2785                	addiw	a5,a5,1
    80006344:	dd3c                	sw	a5,120(a0)
}
    80006346:	60e2                	ld	ra,24(sp)
    80006348:	6442                	ld	s0,16(sp)
    8000634a:	64a2                	ld	s1,8(sp)
    8000634c:	6105                	addi	sp,sp,32
    8000634e:	8082                	ret
    mycpu()->intena = old;
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	adc080e7          	jalr	-1316(ra) # 80000e2c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006358:	8085                	srli	s1,s1,0x1
    8000635a:	8885                	andi	s1,s1,1
    8000635c:	dd64                	sw	s1,124(a0)
    8000635e:	bfe9                	j	80006338 <push_off+0x24>

0000000080006360 <acquire>:
{
    80006360:	1101                	addi	sp,sp,-32
    80006362:	ec06                	sd	ra,24(sp)
    80006364:	e822                	sd	s0,16(sp)
    80006366:	e426                	sd	s1,8(sp)
    80006368:	1000                	addi	s0,sp,32
    8000636a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	fa8080e7          	jalr	-88(ra) # 80006314 <push_off>
  if(holding(lk))
    80006374:	8526                	mv	a0,s1
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	f70080e7          	jalr	-144(ra) # 800062e6 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000637e:	4705                	li	a4,1
  if(holding(lk))
    80006380:	e115                	bnez	a0,800063a4 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006382:	87ba                	mv	a5,a4
    80006384:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006388:	2781                	sext.w	a5,a5
    8000638a:	ffe5                	bnez	a5,80006382 <acquire+0x22>
  __sync_synchronize();
    8000638c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	a9c080e7          	jalr	-1380(ra) # 80000e2c <mycpu>
    80006398:	e888                	sd	a0,16(s1)
}
    8000639a:	60e2                	ld	ra,24(sp)
    8000639c:	6442                	ld	s0,16(sp)
    8000639e:	64a2                	ld	s1,8(sp)
    800063a0:	6105                	addi	sp,sp,32
    800063a2:	8082                	ret
    panic("acquire");
    800063a4:	00002517          	auipc	a0,0x2
    800063a8:	46c50513          	addi	a0,a0,1132 # 80008810 <digits+0x20>
    800063ac:	00000097          	auipc	ra,0x0
    800063b0:	9fc080e7          	jalr	-1540(ra) # 80005da8 <panic>

00000000800063b4 <pop_off>:

void
pop_off(void)
{
    800063b4:	1141                	addi	sp,sp,-16
    800063b6:	e406                	sd	ra,8(sp)
    800063b8:	e022                	sd	s0,0(sp)
    800063ba:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063bc:	ffffb097          	auipc	ra,0xffffb
    800063c0:	a70080e7          	jalr	-1424(ra) # 80000e2c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063c8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063ca:	e78d                	bnez	a5,800063f4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063cc:	5d3c                	lw	a5,120(a0)
    800063ce:	02f05b63          	blez	a5,80006404 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063d2:	37fd                	addiw	a5,a5,-1
    800063d4:	0007871b          	sext.w	a4,a5
    800063d8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063da:	eb09                	bnez	a4,800063ec <pop_off+0x38>
    800063dc:	5d7c                	lw	a5,124(a0)
    800063de:	c799                	beqz	a5,800063ec <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063e0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063e4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063e8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063ec:	60a2                	ld	ra,8(sp)
    800063ee:	6402                	ld	s0,0(sp)
    800063f0:	0141                	addi	sp,sp,16
    800063f2:	8082                	ret
    panic("pop_off - interruptible");
    800063f4:	00002517          	auipc	a0,0x2
    800063f8:	42450513          	addi	a0,a0,1060 # 80008818 <digits+0x28>
    800063fc:	00000097          	auipc	ra,0x0
    80006400:	9ac080e7          	jalr	-1620(ra) # 80005da8 <panic>
    panic("pop_off");
    80006404:	00002517          	auipc	a0,0x2
    80006408:	42c50513          	addi	a0,a0,1068 # 80008830 <digits+0x40>
    8000640c:	00000097          	auipc	ra,0x0
    80006410:	99c080e7          	jalr	-1636(ra) # 80005da8 <panic>

0000000080006414 <release>:
{
    80006414:	1101                	addi	sp,sp,-32
    80006416:	ec06                	sd	ra,24(sp)
    80006418:	e822                	sd	s0,16(sp)
    8000641a:	e426                	sd	s1,8(sp)
    8000641c:	1000                	addi	s0,sp,32
    8000641e:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006420:	00000097          	auipc	ra,0x0
    80006424:	ec6080e7          	jalr	-314(ra) # 800062e6 <holding>
    80006428:	c115                	beqz	a0,8000644c <release+0x38>
  lk->cpu = 0;
    8000642a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000642e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006432:	0f50000f          	fence	iorw,ow
    80006436:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000643a:	00000097          	auipc	ra,0x0
    8000643e:	f7a080e7          	jalr	-134(ra) # 800063b4 <pop_off>
}
    80006442:	60e2                	ld	ra,24(sp)
    80006444:	6442                	ld	s0,16(sp)
    80006446:	64a2                	ld	s1,8(sp)
    80006448:	6105                	addi	sp,sp,32
    8000644a:	8082                	ret
    panic("release");
    8000644c:	00002517          	auipc	a0,0x2
    80006450:	3ec50513          	addi	a0,a0,1004 # 80008838 <digits+0x48>
    80006454:	00000097          	auipc	ra,0x0
    80006458:	954080e7          	jalr	-1708(ra) # 80005da8 <panic>
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
