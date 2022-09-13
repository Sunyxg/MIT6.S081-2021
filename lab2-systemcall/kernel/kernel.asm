
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001e117          	auipc	sp,0x1e
    80000004:	14010113          	addi	sp,sp,320 # 8001e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	792050ef          	jal	ra,800057a8 <start>

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
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
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
    8000004c:	154080e7          	jalr	340(ra) # 8000019c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	148080e7          	jalr	328(ra) # 800061a2 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	1e8080e7          	jalr	488(ra) # 80006256 <release>
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
    8000008e:	bce080e7          	jalr	-1074(ra) # 80005c58 <panic>

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
    800000f8:	01e080e7          	jalr	30(ra) # 80006112 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00026517          	auipc	a0,0x26
    80000104:	14050513          	addi	a0,a0,320 # 80026240 <end>
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
    80000130:	076080e7          	jalr	118(ra) # 800061a2 <acquire>
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
    80000148:	112080e7          	jalr	274(ra) # 80006256 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04a080e7          	jalr	74(ra) # 8000019c <memset>
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
    80000172:	0e8080e7          	jalr	232(ra) # 80006256 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <freememsize>:


uint64
freememsize(void)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  uint64 size = 0;
  struct run *r = kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	eca7b783          	ld	a5,-310(a5) # 80009048 <kmem+0x18>
  uint64 i = 0;
  while(r){
    80000186:	cb89                	beqz	a5,80000198 <freememsize+0x20>
  uint64 i = 0;
    80000188:	4501                	li	a0,0
    ++i;
    8000018a:	0505                	addi	a0,a0,1
    r = r->next;
    8000018c:	639c                	ld	a5,0(a5)
  while(r){
    8000018e:	fff5                	bnez	a5,8000018a <freememsize+0x12>
  }
  size = i*PGSIZE;
  return size;
}
    80000190:	0532                	slli	a0,a0,0xc
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret
  uint64 i = 0;
    80000198:	4501                	li	a0,0
    8000019a:	bfdd                	j	80000190 <freememsize+0x18>

000000008000019c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a2:	ce09                	beqz	a2,800001bc <memset+0x20>
    800001a4:	87aa                	mv	a5,a0
    800001a6:	fff6071b          	addiw	a4,a2,-1
    800001aa:	1702                	slli	a4,a4,0x20
    800001ac:	9301                	srli	a4,a4,0x20
    800001ae:	0705                	addi	a4,a4,1
    800001b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b6:	0785                	addi	a5,a5,1
    800001b8:	fee79de3          	bne	a5,a4,800001b2 <memset+0x16>
  }
  return dst;
}
    800001bc:	6422                	ld	s0,8(sp)
    800001be:	0141                	addi	sp,sp,16
    800001c0:	8082                	ret

00000000800001c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c8:	ca05                	beqz	a2,800001f8 <memcmp+0x36>
    800001ca:	fff6069b          	addiw	a3,a2,-1
    800001ce:	1682                	slli	a3,a3,0x20
    800001d0:	9281                	srli	a3,a3,0x20
    800001d2:	0685                	addi	a3,a3,1
    800001d4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d6:	00054783          	lbu	a5,0(a0)
    800001da:	0005c703          	lbu	a4,0(a1)
    800001de:	00e79863          	bne	a5,a4,800001ee <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e2:	0505                	addi	a0,a0,1
    800001e4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e6:	fed518e3          	bne	a0,a3,800001d6 <memcmp+0x14>
  }

  return 0;
    800001ea:	4501                	li	a0,0
    800001ec:	a019                	j	800001f2 <memcmp+0x30>
      return *s1 - *s2;
    800001ee:	40e7853b          	subw	a0,a5,a4
}
    800001f2:	6422                	ld	s0,8(sp)
    800001f4:	0141                	addi	sp,sp,16
    800001f6:	8082                	ret
  return 0;
    800001f8:	4501                	li	a0,0
    800001fa:	bfe5                	j	800001f2 <memcmp+0x30>

00000000800001fc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fc:	1141                	addi	sp,sp,-16
    800001fe:	e422                	sd	s0,8(sp)
    80000200:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000202:	ca0d                	beqz	a2,80000234 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000204:	00a5f963          	bgeu	a1,a0,80000216 <memmove+0x1a>
    80000208:	02061693          	slli	a3,a2,0x20
    8000020c:	9281                	srli	a3,a3,0x20
    8000020e:	00d58733          	add	a4,a1,a3
    80000212:	02e56463          	bltu	a0,a4,8000023a <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000216:	fff6079b          	addiw	a5,a2,-1
    8000021a:	1782                	slli	a5,a5,0x20
    8000021c:	9381                	srli	a5,a5,0x20
    8000021e:	0785                	addi	a5,a5,1
    80000220:	97ae                	add	a5,a5,a1
    80000222:	872a                	mv	a4,a0
      *d++ = *s++;
    80000224:	0585                	addi	a1,a1,1
    80000226:	0705                	addi	a4,a4,1
    80000228:	fff5c683          	lbu	a3,-1(a1)
    8000022c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000230:	fef59ae3          	bne	a1,a5,80000224 <memmove+0x28>

  return dst;
}
    80000234:	6422                	ld	s0,8(sp)
    80000236:	0141                	addi	sp,sp,16
    80000238:	8082                	ret
    d += n;
    8000023a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	fff7c793          	not	a5,a5
    80000248:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024a:	177d                	addi	a4,a4,-1
    8000024c:	16fd                	addi	a3,a3,-1
    8000024e:	00074603          	lbu	a2,0(a4)
    80000252:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000256:	fef71ae3          	bne	a4,a5,8000024a <memmove+0x4e>
    8000025a:	bfe9                	j	80000234 <memmove+0x38>

000000008000025c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e406                	sd	ra,8(sp)
    80000260:	e022                	sd	s0,0(sp)
    80000262:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000264:	00000097          	auipc	ra,0x0
    80000268:	f98080e7          	jalr	-104(ra) # 800001fc <memmove>
}
    8000026c:	60a2                	ld	ra,8(sp)
    8000026e:	6402                	ld	s0,0(sp)
    80000270:	0141                	addi	sp,sp,16
    80000272:	8082                	ret

0000000080000274 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000274:	1141                	addi	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027a:	ce11                	beqz	a2,80000296 <strncmp+0x22>
    8000027c:	00054783          	lbu	a5,0(a0)
    80000280:	cf89                	beqz	a5,8000029a <strncmp+0x26>
    80000282:	0005c703          	lbu	a4,0(a1)
    80000286:	00f71a63          	bne	a4,a5,8000029a <strncmp+0x26>
    n--, p++, q++;
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	0505                	addi	a0,a0,1
    8000028e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000290:	f675                	bnez	a2,8000027c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000292:	4501                	li	a0,0
    80000294:	a809                	j	800002a6 <strncmp+0x32>
    80000296:	4501                	li	a0,0
    80000298:	a039                	j	800002a6 <strncmp+0x32>
  if(n == 0)
    8000029a:	ca09                	beqz	a2,800002ac <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029c:	00054503          	lbu	a0,0(a0)
    800002a0:	0005c783          	lbu	a5,0(a1)
    800002a4:	9d1d                	subw	a0,a0,a5
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret
    return 0;
    800002ac:	4501                	li	a0,0
    800002ae:	bfe5                	j	800002a6 <strncmp+0x32>

00000000800002b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e422                	sd	s0,8(sp)
    800002b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b6:	872a                	mv	a4,a0
    800002b8:	8832                	mv	a6,a2
    800002ba:	367d                	addiw	a2,a2,-1
    800002bc:	01005963          	blez	a6,800002ce <strncpy+0x1e>
    800002c0:	0705                	addi	a4,a4,1
    800002c2:	0005c783          	lbu	a5,0(a1)
    800002c6:	fef70fa3          	sb	a5,-1(a4)
    800002ca:	0585                	addi	a1,a1,1
    800002cc:	f7f5                	bnez	a5,800002b8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ce:	00c05d63          	blez	a2,800002e8 <strncpy+0x38>
    800002d2:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d4:	0685                	addi	a3,a3,1
    800002d6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002da:	fff6c793          	not	a5,a3
    800002de:	9fb9                	addw	a5,a5,a4
    800002e0:	010787bb          	addw	a5,a5,a6
    800002e4:	fef048e3          	bgtz	a5,800002d4 <strncpy+0x24>
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f4:	02c05363          	blez	a2,8000031a <safestrcpy+0x2c>
    800002f8:	fff6069b          	addiw	a3,a2,-1
    800002fc:	1682                	slli	a3,a3,0x20
    800002fe:	9281                	srli	a3,a3,0x20
    80000300:	96ae                	add	a3,a3,a1
    80000302:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000304:	00d58963          	beq	a1,a3,80000316 <safestrcpy+0x28>
    80000308:	0585                	addi	a1,a1,1
    8000030a:	0785                	addi	a5,a5,1
    8000030c:	fff5c703          	lbu	a4,-1(a1)
    80000310:	fee78fa3          	sb	a4,-1(a5)
    80000314:	fb65                	bnez	a4,80000304 <safestrcpy+0x16>
    ;
  *s = 0;
    80000316:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031a:	6422                	ld	s0,8(sp)
    8000031c:	0141                	addi	sp,sp,16
    8000031e:	8082                	ret

0000000080000320 <strlen>:

int
strlen(const char *s)
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e422                	sd	s0,8(sp)
    80000324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	cf91                	beqz	a5,80000346 <strlen+0x26>
    8000032c:	0505                	addi	a0,a0,1
    8000032e:	87aa                	mv	a5,a0
    80000330:	4685                	li	a3,1
    80000332:	9e89                	subw	a3,a3,a0
    80000334:	00f6853b          	addw	a0,a3,a5
    80000338:	0785                	addi	a5,a5,1
    8000033a:	fff7c703          	lbu	a4,-1(a5)
    8000033e:	fb7d                	bnez	a4,80000334 <strlen+0x14>
    ;
  return n;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret
  for(n = 0; s[n]; n++)
    80000346:	4501                	li	a0,0
    80000348:	bfe5                	j	80000340 <strlen+0x20>

000000008000034a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034a:	1141                	addi	sp,sp,-16
    8000034c:	e406                	sd	ra,8(sp)
    8000034e:	e022                	sd	s0,0(sp)
    80000350:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000352:	00001097          	auipc	ra,0x1
    80000356:	aee080e7          	jalr	-1298(ra) # 80000e40 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035a:	00009717          	auipc	a4,0x9
    8000035e:	ca670713          	addi	a4,a4,-858 # 80009000 <started>
  if(cpuid() == 0){
    80000362:	c139                	beqz	a0,800003a8 <main+0x5e>
    while(started == 0)
    80000364:	431c                	lw	a5,0(a4)
    80000366:	2781                	sext.w	a5,a5
    80000368:	dff5                	beqz	a5,80000364 <main+0x1a>
      ;
    __sync_synchronize();
    8000036a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	ad2080e7          	jalr	-1326(ra) # 80000e40 <cpuid>
    80000376:	85aa                	mv	a1,a0
    80000378:	00008517          	auipc	a0,0x8
    8000037c:	cc050513          	addi	a0,a0,-832 # 80008038 <etext+0x38>
    80000380:	00006097          	auipc	ra,0x6
    80000384:	922080e7          	jalr	-1758(ra) # 80005ca2 <printf>
    kvminithart();    // turn on paging
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	0d8080e7          	jalr	216(ra) # 80000460 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000390:	00001097          	auipc	ra,0x1
    80000394:	764080e7          	jalr	1892(ra) # 80001af4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000398:	00005097          	auipc	ra,0x5
    8000039c:	d98080e7          	jalr	-616(ra) # 80005130 <plicinithart>
  }

  scheduler();        
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	fe2080e7          	jalr	-30(ra) # 80001382 <scheduler>
    consoleinit();
    800003a8:	00005097          	auipc	ra,0x5
    800003ac:	7c2080e7          	jalr	1986(ra) # 80005b6a <consoleinit>
    printfinit();
    800003b0:	00006097          	auipc	ra,0x6
    800003b4:	ad8080e7          	jalr	-1320(ra) # 80005e88 <printfinit>
    printf("\n");
    800003b8:	00008517          	auipc	a0,0x8
    800003bc:	c9050513          	addi	a0,a0,-880 # 80008048 <etext+0x48>
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	8e2080e7          	jalr	-1822(ra) # 80005ca2 <printf>
    printf("xv6 kernel is booting\n");
    800003c8:	00008517          	auipc	a0,0x8
    800003cc:	c5850513          	addi	a0,a0,-936 # 80008020 <etext+0x20>
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	8d2080e7          	jalr	-1838(ra) # 80005ca2 <printf>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	8c2080e7          	jalr	-1854(ra) # 80005ca2 <printf>
    kinit();         // physical page allocator
    800003e8:	00000097          	auipc	ra,0x0
    800003ec:	cf4080e7          	jalr	-780(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f0:	00000097          	auipc	ra,0x0
    800003f4:	322080e7          	jalr	802(ra) # 80000712 <kvminit>
    kvminithart();   // turn on paging
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	068080e7          	jalr	104(ra) # 80000460 <kvminithart>
    procinit();      // process table
    80000400:	00001097          	auipc	ra,0x1
    80000404:	990080e7          	jalr	-1648(ra) # 80000d90 <procinit>
    trapinit();      // trap vectors
    80000408:	00001097          	auipc	ra,0x1
    8000040c:	6c4080e7          	jalr	1732(ra) # 80001acc <trapinit>
    trapinithart();  // install kernel trap vector
    80000410:	00001097          	auipc	ra,0x1
    80000414:	6e4080e7          	jalr	1764(ra) # 80001af4 <trapinithart>
    plicinit();      // set up interrupt controller
    80000418:	00005097          	auipc	ra,0x5
    8000041c:	d02080e7          	jalr	-766(ra) # 8000511a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000420:	00005097          	auipc	ra,0x5
    80000424:	d10080e7          	jalr	-752(ra) # 80005130 <plicinithart>
    binit();         // buffer cache
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	eec080e7          	jalr	-276(ra) # 80002314 <binit>
    iinit();         // inode table
    80000430:	00002097          	auipc	ra,0x2
    80000434:	57c080e7          	jalr	1404(ra) # 800029ac <iinit>
    fileinit();      // file table
    80000438:	00003097          	auipc	ra,0x3
    8000043c:	526080e7          	jalr	1318(ra) # 8000395e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000440:	00005097          	auipc	ra,0x5
    80000444:	e12080e7          	jalr	-494(ra) # 80005252 <virtio_disk_init>
    userinit();      // first user process
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	d00080e7          	jalr	-768(ra) # 80001148 <userinit>
    __sync_synchronize();
    80000450:	0ff0000f          	fence
    started = 1;
    80000454:	4785                	li	a5,1
    80000456:	00009717          	auipc	a4,0x9
    8000045a:	baf72523          	sw	a5,-1110(a4) # 80009000 <started>
    8000045e:	b789                	j	800003a0 <main+0x56>

0000000080000460 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e422                	sd	s0,8(sp)
    80000464:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000466:	00009797          	auipc	a5,0x9
    8000046a:	ba27b783          	ld	a5,-1118(a5) # 80009008 <kernel_pagetable>
    8000046e:	83b1                	srli	a5,a5,0xc
    80000470:	577d                	li	a4,-1
    80000472:	177e                	slli	a4,a4,0x3f
    80000474:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000476:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000047a:	12000073          	sfence.vma
  sfence_vma();
}
    8000047e:	6422                	ld	s0,8(sp)
    80000480:	0141                	addi	sp,sp,16
    80000482:	8082                	ret

0000000080000484 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000484:	7139                	addi	sp,sp,-64
    80000486:	fc06                	sd	ra,56(sp)
    80000488:	f822                	sd	s0,48(sp)
    8000048a:	f426                	sd	s1,40(sp)
    8000048c:	f04a                	sd	s2,32(sp)
    8000048e:	ec4e                	sd	s3,24(sp)
    80000490:	e852                	sd	s4,16(sp)
    80000492:	e456                	sd	s5,8(sp)
    80000494:	e05a                	sd	s6,0(sp)
    80000496:	0080                	addi	s0,sp,64
    80000498:	84aa                	mv	s1,a0
    8000049a:	89ae                	mv	s3,a1
    8000049c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000049e:	57fd                	li	a5,-1
    800004a0:	83e9                	srli	a5,a5,0x1a
    800004a2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004a6:	04b7f263          	bgeu	a5,a1,800004ea <walk+0x66>
    panic("walk");
    800004aa:	00008517          	auipc	a0,0x8
    800004ae:	ba650513          	addi	a0,a0,-1114 # 80008050 <etext+0x50>
    800004b2:	00005097          	auipc	ra,0x5
    800004b6:	7a6080e7          	jalr	1958(ra) # 80005c58 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004ba:	060a8663          	beqz	s5,80000526 <walk+0xa2>
    800004be:	00000097          	auipc	ra,0x0
    800004c2:	c5a080e7          	jalr	-934(ra) # 80000118 <kalloc>
    800004c6:	84aa                	mv	s1,a0
    800004c8:	c529                	beqz	a0,80000512 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ca:	6605                	lui	a2,0x1
    800004cc:	4581                	li	a1,0
    800004ce:	00000097          	auipc	ra,0x0
    800004d2:	cce080e7          	jalr	-818(ra) # 8000019c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004d6:	00c4d793          	srli	a5,s1,0xc
    800004da:	07aa                	slli	a5,a5,0xa
    800004dc:	0017e793          	ori	a5,a5,1
    800004e0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e4:	3a5d                	addiw	s4,s4,-9
    800004e6:	036a0063          	beq	s4,s6,80000506 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ea:	0149d933          	srl	s2,s3,s4
    800004ee:	1ff97913          	andi	s2,s2,511
    800004f2:	090e                	slli	s2,s2,0x3
    800004f4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004f6:	00093483          	ld	s1,0(s2)
    800004fa:	0014f793          	andi	a5,s1,1
    800004fe:	dfd5                	beqz	a5,800004ba <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000500:	80a9                	srli	s1,s1,0xa
    80000502:	04b2                	slli	s1,s1,0xc
    80000504:	b7c5                	j	800004e4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000506:	00c9d513          	srli	a0,s3,0xc
    8000050a:	1ff57513          	andi	a0,a0,511
    8000050e:	050e                	slli	a0,a0,0x3
    80000510:	9526                	add	a0,a0,s1
}
    80000512:	70e2                	ld	ra,56(sp)
    80000514:	7442                	ld	s0,48(sp)
    80000516:	74a2                	ld	s1,40(sp)
    80000518:	7902                	ld	s2,32(sp)
    8000051a:	69e2                	ld	s3,24(sp)
    8000051c:	6a42                	ld	s4,16(sp)
    8000051e:	6aa2                	ld	s5,8(sp)
    80000520:	6b02                	ld	s6,0(sp)
    80000522:	6121                	addi	sp,sp,64
    80000524:	8082                	ret
        return 0;
    80000526:	4501                	li	a0,0
    80000528:	b7ed                	j	80000512 <walk+0x8e>

000000008000052a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000052a:	57fd                	li	a5,-1
    8000052c:	83e9                	srli	a5,a5,0x1a
    8000052e:	00b7f463          	bgeu	a5,a1,80000536 <walkaddr+0xc>
    return 0;
    80000532:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000534:	8082                	ret
{
    80000536:	1141                	addi	sp,sp,-16
    80000538:	e406                	sd	ra,8(sp)
    8000053a:	e022                	sd	s0,0(sp)
    8000053c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000053e:	4601                	li	a2,0
    80000540:	00000097          	auipc	ra,0x0
    80000544:	f44080e7          	jalr	-188(ra) # 80000484 <walk>
  if(pte == 0)
    80000548:	c105                	beqz	a0,80000568 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000054a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000054c:	0117f693          	andi	a3,a5,17
    80000550:	4745                	li	a4,17
    return 0;
    80000552:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000554:	00e68663          	beq	a3,a4,80000560 <walkaddr+0x36>
}
    80000558:	60a2                	ld	ra,8(sp)
    8000055a:	6402                	ld	s0,0(sp)
    8000055c:	0141                	addi	sp,sp,16
    8000055e:	8082                	ret
  pa = PTE2PA(*pte);
    80000560:	00a7d513          	srli	a0,a5,0xa
    80000564:	0532                	slli	a0,a0,0xc
  return pa;
    80000566:	bfcd                	j	80000558 <walkaddr+0x2e>
    return 0;
    80000568:	4501                	li	a0,0
    8000056a:	b7fd                	j	80000558 <walkaddr+0x2e>

000000008000056c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000056c:	715d                	addi	sp,sp,-80
    8000056e:	e486                	sd	ra,72(sp)
    80000570:	e0a2                	sd	s0,64(sp)
    80000572:	fc26                	sd	s1,56(sp)
    80000574:	f84a                	sd	s2,48(sp)
    80000576:	f44e                	sd	s3,40(sp)
    80000578:	f052                	sd	s4,32(sp)
    8000057a:	ec56                	sd	s5,24(sp)
    8000057c:	e85a                	sd	s6,16(sp)
    8000057e:	e45e                	sd	s7,8(sp)
    80000580:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000582:	c205                	beqz	a2,800005a2 <mappages+0x36>
    80000584:	8aaa                	mv	s5,a0
    80000586:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000588:	77fd                	lui	a5,0xfffff
    8000058a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000058e:	15fd                	addi	a1,a1,-1
    80000590:	00c589b3          	add	s3,a1,a2
    80000594:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000598:	8952                	mv	s2,s4
    8000059a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000059e:	6b85                	lui	s7,0x1
    800005a0:	a015                	j	800005c4 <mappages+0x58>
    panic("mappages: size");
    800005a2:	00008517          	auipc	a0,0x8
    800005a6:	ab650513          	addi	a0,a0,-1354 # 80008058 <etext+0x58>
    800005aa:	00005097          	auipc	ra,0x5
    800005ae:	6ae080e7          	jalr	1710(ra) # 80005c58 <panic>
      panic("mappages: remap");
    800005b2:	00008517          	auipc	a0,0x8
    800005b6:	ab650513          	addi	a0,a0,-1354 # 80008068 <etext+0x68>
    800005ba:	00005097          	auipc	ra,0x5
    800005be:	69e080e7          	jalr	1694(ra) # 80005c58 <panic>
    a += PGSIZE;
    800005c2:	995e                	add	s2,s2,s7
  for(;;){
    800005c4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c8:	4605                	li	a2,1
    800005ca:	85ca                	mv	a1,s2
    800005cc:	8556                	mv	a0,s5
    800005ce:	00000097          	auipc	ra,0x0
    800005d2:	eb6080e7          	jalr	-330(ra) # 80000484 <walk>
    800005d6:	cd19                	beqz	a0,800005f4 <mappages+0x88>
    if(*pte & PTE_V)
    800005d8:	611c                	ld	a5,0(a0)
    800005da:	8b85                	andi	a5,a5,1
    800005dc:	fbf9                	bnez	a5,800005b2 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005de:	80b1                	srli	s1,s1,0xc
    800005e0:	04aa                	slli	s1,s1,0xa
    800005e2:	0164e4b3          	or	s1,s1,s6
    800005e6:	0014e493          	ori	s1,s1,1
    800005ea:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ec:	fd391be3          	bne	s2,s3,800005c2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005f0:	4501                	li	a0,0
    800005f2:	a011                	j	800005f6 <mappages+0x8a>
      return -1;
    800005f4:	557d                	li	a0,-1
}
    800005f6:	60a6                	ld	ra,72(sp)
    800005f8:	6406                	ld	s0,64(sp)
    800005fa:	74e2                	ld	s1,56(sp)
    800005fc:	7942                	ld	s2,48(sp)
    800005fe:	79a2                	ld	s3,40(sp)
    80000600:	7a02                	ld	s4,32(sp)
    80000602:	6ae2                	ld	s5,24(sp)
    80000604:	6b42                	ld	s6,16(sp)
    80000606:	6ba2                	ld	s7,8(sp)
    80000608:	6161                	addi	sp,sp,80
    8000060a:	8082                	ret

000000008000060c <kvmmap>:
{
    8000060c:	1141                	addi	sp,sp,-16
    8000060e:	e406                	sd	ra,8(sp)
    80000610:	e022                	sd	s0,0(sp)
    80000612:	0800                	addi	s0,sp,16
    80000614:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000616:	86b2                	mv	a3,a2
    80000618:	863e                	mv	a2,a5
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	f52080e7          	jalr	-174(ra) # 8000056c <mappages>
    80000622:	e509                	bnez	a0,8000062c <kvmmap+0x20>
}
    80000624:	60a2                	ld	ra,8(sp)
    80000626:	6402                	ld	s0,0(sp)
    80000628:	0141                	addi	sp,sp,16
    8000062a:	8082                	ret
    panic("kvmmap");
    8000062c:	00008517          	auipc	a0,0x8
    80000630:	a4c50513          	addi	a0,a0,-1460 # 80008078 <etext+0x78>
    80000634:	00005097          	auipc	ra,0x5
    80000638:	624080e7          	jalr	1572(ra) # 80005c58 <panic>

000000008000063c <kvmmake>:
{
    8000063c:	1101                	addi	sp,sp,-32
    8000063e:	ec06                	sd	ra,24(sp)
    80000640:	e822                	sd	s0,16(sp)
    80000642:	e426                	sd	s1,8(sp)
    80000644:	e04a                	sd	s2,0(sp)
    80000646:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000648:	00000097          	auipc	ra,0x0
    8000064c:	ad0080e7          	jalr	-1328(ra) # 80000118 <kalloc>
    80000650:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000652:	6605                	lui	a2,0x1
    80000654:	4581                	li	a1,0
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	b46080e7          	jalr	-1210(ra) # 8000019c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000065e:	4719                	li	a4,6
    80000660:	6685                	lui	a3,0x1
    80000662:	10000637          	lui	a2,0x10000
    80000666:	100005b7          	lui	a1,0x10000
    8000066a:	8526                	mv	a0,s1
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	fa0080e7          	jalr	-96(ra) # 8000060c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000674:	4719                	li	a4,6
    80000676:	6685                	lui	a3,0x1
    80000678:	10001637          	lui	a2,0x10001
    8000067c:	100015b7          	lui	a1,0x10001
    80000680:	8526                	mv	a0,s1
    80000682:	00000097          	auipc	ra,0x0
    80000686:	f8a080e7          	jalr	-118(ra) # 8000060c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068a:	4719                	li	a4,6
    8000068c:	004006b7          	lui	a3,0x400
    80000690:	0c000637          	lui	a2,0xc000
    80000694:	0c0005b7          	lui	a1,0xc000
    80000698:	8526                	mv	a0,s1
    8000069a:	00000097          	auipc	ra,0x0
    8000069e:	f72080e7          	jalr	-142(ra) # 8000060c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a2:	00008917          	auipc	s2,0x8
    800006a6:	95e90913          	addi	s2,s2,-1698 # 80008000 <etext>
    800006aa:	4729                	li	a4,10
    800006ac:	80008697          	auipc	a3,0x80008
    800006b0:	95468693          	addi	a3,a3,-1708 # 8000 <_entry-0x7fff8000>
    800006b4:	4605                	li	a2,1
    800006b6:	067e                	slli	a2,a2,0x1f
    800006b8:	85b2                	mv	a1,a2
    800006ba:	8526                	mv	a0,s1
    800006bc:	00000097          	auipc	ra,0x0
    800006c0:	f50080e7          	jalr	-176(ra) # 8000060c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c4:	4719                	li	a4,6
    800006c6:	46c5                	li	a3,17
    800006c8:	06ee                	slli	a3,a3,0x1b
    800006ca:	412686b3          	sub	a3,a3,s2
    800006ce:	864a                	mv	a2,s2
    800006d0:	85ca                	mv	a1,s2
    800006d2:	8526                	mv	a0,s1
    800006d4:	00000097          	auipc	ra,0x0
    800006d8:	f38080e7          	jalr	-200(ra) # 8000060c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006dc:	4729                	li	a4,10
    800006de:	6685                	lui	a3,0x1
    800006e0:	00007617          	auipc	a2,0x7
    800006e4:	92060613          	addi	a2,a2,-1760 # 80007000 <_trampoline>
    800006e8:	040005b7          	lui	a1,0x4000
    800006ec:	15fd                	addi	a1,a1,-1
    800006ee:	05b2                	slli	a1,a1,0xc
    800006f0:	8526                	mv	a0,s1
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	f1a080e7          	jalr	-230(ra) # 8000060c <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fa:	8526                	mv	a0,s1
    800006fc:	00000097          	auipc	ra,0x0
    80000700:	5fe080e7          	jalr	1534(ra) # 80000cfa <proc_mapstacks>
}
    80000704:	8526                	mv	a0,s1
    80000706:	60e2                	ld	ra,24(sp)
    80000708:	6442                	ld	s0,16(sp)
    8000070a:	64a2                	ld	s1,8(sp)
    8000070c:	6902                	ld	s2,0(sp)
    8000070e:	6105                	addi	sp,sp,32
    80000710:	8082                	ret

0000000080000712 <kvminit>:
{
    80000712:	1141                	addi	sp,sp,-16
    80000714:	e406                	sd	ra,8(sp)
    80000716:	e022                	sd	s0,0(sp)
    80000718:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071a:	00000097          	auipc	ra,0x0
    8000071e:	f22080e7          	jalr	-222(ra) # 8000063c <kvmmake>
    80000722:	00009797          	auipc	a5,0x9
    80000726:	8ea7b323          	sd	a0,-1818(a5) # 80009008 <kernel_pagetable>
}
    8000072a:	60a2                	ld	ra,8(sp)
    8000072c:	6402                	ld	s0,0(sp)
    8000072e:	0141                	addi	sp,sp,16
    80000730:	8082                	ret

0000000080000732 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000732:	715d                	addi	sp,sp,-80
    80000734:	e486                	sd	ra,72(sp)
    80000736:	e0a2                	sd	s0,64(sp)
    80000738:	fc26                	sd	s1,56(sp)
    8000073a:	f84a                	sd	s2,48(sp)
    8000073c:	f44e                	sd	s3,40(sp)
    8000073e:	f052                	sd	s4,32(sp)
    80000740:	ec56                	sd	s5,24(sp)
    80000742:	e85a                	sd	s6,16(sp)
    80000744:	e45e                	sd	s7,8(sp)
    80000746:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000748:	03459793          	slli	a5,a1,0x34
    8000074c:	e795                	bnez	a5,80000778 <uvmunmap+0x46>
    8000074e:	8a2a                	mv	s4,a0
    80000750:	892e                	mv	s2,a1
    80000752:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000754:	0632                	slli	a2,a2,0xc
    80000756:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000075c:	6b05                	lui	s6,0x1
    8000075e:	0735e863          	bltu	a1,s3,800007ce <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000762:	60a6                	ld	ra,72(sp)
    80000764:	6406                	ld	s0,64(sp)
    80000766:	74e2                	ld	s1,56(sp)
    80000768:	7942                	ld	s2,48(sp)
    8000076a:	79a2                	ld	s3,40(sp)
    8000076c:	7a02                	ld	s4,32(sp)
    8000076e:	6ae2                	ld	s5,24(sp)
    80000770:	6b42                	ld	s6,16(sp)
    80000772:	6ba2                	ld	s7,8(sp)
    80000774:	6161                	addi	sp,sp,80
    80000776:	8082                	ret
    panic("uvmunmap: not aligned");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	90850513          	addi	a0,a0,-1784 # 80008080 <etext+0x80>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	4d8080e7          	jalr	1240(ra) # 80005c58 <panic>
      panic("uvmunmap: walk");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	91050513          	addi	a0,a0,-1776 # 80008098 <etext+0x98>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	4c8080e7          	jalr	1224(ra) # 80005c58 <panic>
      panic("uvmunmap: not mapped");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	91050513          	addi	a0,a0,-1776 # 800080a8 <etext+0xa8>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	4b8080e7          	jalr	1208(ra) # 80005c58 <panic>
      panic("uvmunmap: not a leaf");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	91850513          	addi	a0,a0,-1768 # 800080c0 <etext+0xc0>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	4a8080e7          	jalr	1192(ra) # 80005c58 <panic>
      uint64 pa = PTE2PA(*pte);
    800007b8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007ba:	0532                	slli	a0,a0,0xc
    800007bc:	00000097          	auipc	ra,0x0
    800007c0:	860080e7          	jalr	-1952(ra) # 8000001c <kfree>
    *pte = 0;
    800007c4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007c8:	995a                	add	s2,s2,s6
    800007ca:	f9397ce3          	bgeu	s2,s3,80000762 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ce:	4601                	li	a2,0
    800007d0:	85ca                	mv	a1,s2
    800007d2:	8552                	mv	a0,s4
    800007d4:	00000097          	auipc	ra,0x0
    800007d8:	cb0080e7          	jalr	-848(ra) # 80000484 <walk>
    800007dc:	84aa                	mv	s1,a0
    800007de:	d54d                	beqz	a0,80000788 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e0:	6108                	ld	a0,0(a0)
    800007e2:	00157793          	andi	a5,a0,1
    800007e6:	dbcd                	beqz	a5,80000798 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007e8:	3ff57793          	andi	a5,a0,1023
    800007ec:	fb778ee3          	beq	a5,s7,800007a8 <uvmunmap+0x76>
    if(do_free){
    800007f0:	fc0a8ae3          	beqz	s5,800007c4 <uvmunmap+0x92>
    800007f4:	b7d1                	j	800007b8 <uvmunmap+0x86>

00000000800007f6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007f6:	1101                	addi	sp,sp,-32
    800007f8:	ec06                	sd	ra,24(sp)
    800007fa:	e822                	sd	s0,16(sp)
    800007fc:	e426                	sd	s1,8(sp)
    800007fe:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000800:	00000097          	auipc	ra,0x0
    80000804:	918080e7          	jalr	-1768(ra) # 80000118 <kalloc>
    80000808:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080a:	c519                	beqz	a0,80000818 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000080c:	6605                	lui	a2,0x1
    8000080e:	4581                	li	a1,0
    80000810:	00000097          	auipc	ra,0x0
    80000814:	98c080e7          	jalr	-1652(ra) # 8000019c <memset>
  return pagetable;
}
    80000818:	8526                	mv	a0,s1
    8000081a:	60e2                	ld	ra,24(sp)
    8000081c:	6442                	ld	s0,16(sp)
    8000081e:	64a2                	ld	s1,8(sp)
    80000820:	6105                	addi	sp,sp,32
    80000822:	8082                	ret

0000000080000824 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000824:	7179                	addi	sp,sp,-48
    80000826:	f406                	sd	ra,40(sp)
    80000828:	f022                	sd	s0,32(sp)
    8000082a:	ec26                	sd	s1,24(sp)
    8000082c:	e84a                	sd	s2,16(sp)
    8000082e:	e44e                	sd	s3,8(sp)
    80000830:	e052                	sd	s4,0(sp)
    80000832:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000834:	6785                	lui	a5,0x1
    80000836:	04f67863          	bgeu	a2,a5,80000886 <uvminit+0x62>
    8000083a:	8a2a                	mv	s4,a0
    8000083c:	89ae                	mv	s3,a1
    8000083e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000840:	00000097          	auipc	ra,0x0
    80000844:	8d8080e7          	jalr	-1832(ra) # 80000118 <kalloc>
    80000848:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084a:	6605                	lui	a2,0x1
    8000084c:	4581                	li	a1,0
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	94e080e7          	jalr	-1714(ra) # 8000019c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000856:	4779                	li	a4,30
    80000858:	86ca                	mv	a3,s2
    8000085a:	6605                	lui	a2,0x1
    8000085c:	4581                	li	a1,0
    8000085e:	8552                	mv	a0,s4
    80000860:	00000097          	auipc	ra,0x0
    80000864:	d0c080e7          	jalr	-756(ra) # 8000056c <mappages>
  memmove(mem, src, sz);
    80000868:	8626                	mv	a2,s1
    8000086a:	85ce                	mv	a1,s3
    8000086c:	854a                	mv	a0,s2
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	98e080e7          	jalr	-1650(ra) # 800001fc <memmove>
}
    80000876:	70a2                	ld	ra,40(sp)
    80000878:	7402                	ld	s0,32(sp)
    8000087a:	64e2                	ld	s1,24(sp)
    8000087c:	6942                	ld	s2,16(sp)
    8000087e:	69a2                	ld	s3,8(sp)
    80000880:	6a02                	ld	s4,0(sp)
    80000882:	6145                	addi	sp,sp,48
    80000884:	8082                	ret
    panic("inituvm: more than a page");
    80000886:	00008517          	auipc	a0,0x8
    8000088a:	85250513          	addi	a0,a0,-1966 # 800080d8 <etext+0xd8>
    8000088e:	00005097          	auipc	ra,0x5
    80000892:	3ca080e7          	jalr	970(ra) # 80005c58 <panic>

0000000080000896 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000896:	1101                	addi	sp,sp,-32
    80000898:	ec06                	sd	ra,24(sp)
    8000089a:	e822                	sd	s0,16(sp)
    8000089c:	e426                	sd	s1,8(sp)
    8000089e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a2:	00b67d63          	bgeu	a2,a1,800008bc <uvmdealloc+0x26>
    800008a6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008a8:	6785                	lui	a5,0x1
    800008aa:	17fd                	addi	a5,a5,-1
    800008ac:	00f60733          	add	a4,a2,a5
    800008b0:	767d                	lui	a2,0xfffff
    800008b2:	8f71                	and	a4,a4,a2
    800008b4:	97ae                	add	a5,a5,a1
    800008b6:	8ff1                	and	a5,a5,a2
    800008b8:	00f76863          	bltu	a4,a5,800008c8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008bc:	8526                	mv	a0,s1
    800008be:	60e2                	ld	ra,24(sp)
    800008c0:	6442                	ld	s0,16(sp)
    800008c2:	64a2                	ld	s1,8(sp)
    800008c4:	6105                	addi	sp,sp,32
    800008c6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008c8:	8f99                	sub	a5,a5,a4
    800008ca:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008cc:	4685                	li	a3,1
    800008ce:	0007861b          	sext.w	a2,a5
    800008d2:	85ba                	mv	a1,a4
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	e5e080e7          	jalr	-418(ra) # 80000732 <uvmunmap>
    800008dc:	b7c5                	j	800008bc <uvmdealloc+0x26>

00000000800008de <uvmalloc>:
  if(newsz < oldsz)
    800008de:	0ab66163          	bltu	a2,a1,80000980 <uvmalloc+0xa2>
{
    800008e2:	7139                	addi	sp,sp,-64
    800008e4:	fc06                	sd	ra,56(sp)
    800008e6:	f822                	sd	s0,48(sp)
    800008e8:	f426                	sd	s1,40(sp)
    800008ea:	f04a                	sd	s2,32(sp)
    800008ec:	ec4e                	sd	s3,24(sp)
    800008ee:	e852                	sd	s4,16(sp)
    800008f0:	e456                	sd	s5,8(sp)
    800008f2:	0080                	addi	s0,sp,64
    800008f4:	8aaa                	mv	s5,a0
    800008f6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008f8:	6985                	lui	s3,0x1
    800008fa:	19fd                	addi	s3,s3,-1
    800008fc:	95ce                	add	a1,a1,s3
    800008fe:	79fd                	lui	s3,0xfffff
    80000900:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000904:	08c9f063          	bgeu	s3,a2,80000984 <uvmalloc+0xa6>
    80000908:	894e                	mv	s2,s3
    mem = kalloc();
    8000090a:	00000097          	auipc	ra,0x0
    8000090e:	80e080e7          	jalr	-2034(ra) # 80000118 <kalloc>
    80000912:	84aa                	mv	s1,a0
    if(mem == 0){
    80000914:	c51d                	beqz	a0,80000942 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000916:	6605                	lui	a2,0x1
    80000918:	4581                	li	a1,0
    8000091a:	00000097          	auipc	ra,0x0
    8000091e:	882080e7          	jalr	-1918(ra) # 8000019c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000922:	4779                	li	a4,30
    80000924:	86a6                	mv	a3,s1
    80000926:	6605                	lui	a2,0x1
    80000928:	85ca                	mv	a1,s2
    8000092a:	8556                	mv	a0,s5
    8000092c:	00000097          	auipc	ra,0x0
    80000930:	c40080e7          	jalr	-960(ra) # 8000056c <mappages>
    80000934:	e905                	bnez	a0,80000964 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000936:	6785                	lui	a5,0x1
    80000938:	993e                	add	s2,s2,a5
    8000093a:	fd4968e3          	bltu	s2,s4,8000090a <uvmalloc+0x2c>
  return newsz;
    8000093e:	8552                	mv	a0,s4
    80000940:	a809                	j	80000952 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000942:	864e                	mv	a2,s3
    80000944:	85ca                	mv	a1,s2
    80000946:	8556                	mv	a0,s5
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	f4e080e7          	jalr	-178(ra) # 80000896 <uvmdealloc>
      return 0;
    80000950:	4501                	li	a0,0
}
    80000952:	70e2                	ld	ra,56(sp)
    80000954:	7442                	ld	s0,48(sp)
    80000956:	74a2                	ld	s1,40(sp)
    80000958:	7902                	ld	s2,32(sp)
    8000095a:	69e2                	ld	s3,24(sp)
    8000095c:	6a42                	ld	s4,16(sp)
    8000095e:	6aa2                	ld	s5,8(sp)
    80000960:	6121                	addi	sp,sp,64
    80000962:	8082                	ret
      kfree(mem);
    80000964:	8526                	mv	a0,s1
    80000966:	fffff097          	auipc	ra,0xfffff
    8000096a:	6b6080e7          	jalr	1718(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f22080e7          	jalr	-222(ra) # 80000896 <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
    8000097e:	bfd1                	j	80000952 <uvmalloc+0x74>
    return oldsz;
    80000980:	852e                	mv	a0,a1
}
    80000982:	8082                	ret
  return newsz;
    80000984:	8532                	mv	a0,a2
    80000986:	b7f1                	j	80000952 <uvmalloc+0x74>

0000000080000988 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000988:	7179                	addi	sp,sp,-48
    8000098a:	f406                	sd	ra,40(sp)
    8000098c:	f022                	sd	s0,32(sp)
    8000098e:	ec26                	sd	s1,24(sp)
    80000990:	e84a                	sd	s2,16(sp)
    80000992:	e44e                	sd	s3,8(sp)
    80000994:	e052                	sd	s4,0(sp)
    80000996:	1800                	addi	s0,sp,48
    80000998:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000099a:	84aa                	mv	s1,a0
    8000099c:	6905                	lui	s2,0x1
    8000099e:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	4985                	li	s3,1
    800009a2:	a821                	j	800009ba <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009a4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009a6:	0532                	slli	a0,a0,0xc
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	fe0080e7          	jalr	-32(ra) # 80000988 <freewalk>
      pagetable[i] = 0;
    800009b0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009b4:	04a1                	addi	s1,s1,8
    800009b6:	03248163          	beq	s1,s2,800009d8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009ba:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009bc:	00f57793          	andi	a5,a0,15
    800009c0:	ff3782e3          	beq	a5,s3,800009a4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009c4:	8905                	andi	a0,a0,1
    800009c6:	d57d                	beqz	a0,800009b4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009c8:	00007517          	auipc	a0,0x7
    800009cc:	73050513          	addi	a0,a0,1840 # 800080f8 <etext+0xf8>
    800009d0:	00005097          	auipc	ra,0x5
    800009d4:	288080e7          	jalr	648(ra) # 80005c58 <panic>
    }
  }
  kfree((void*)pagetable);
    800009d8:	8552                	mv	a0,s4
    800009da:	fffff097          	auipc	ra,0xfffff
    800009de:	642080e7          	jalr	1602(ra) # 8000001c <kfree>
}
    800009e2:	70a2                	ld	ra,40(sp)
    800009e4:	7402                	ld	s0,32(sp)
    800009e6:	64e2                	ld	s1,24(sp)
    800009e8:	6942                	ld	s2,16(sp)
    800009ea:	69a2                	ld	s3,8(sp)
    800009ec:	6a02                	ld	s4,0(sp)
    800009ee:	6145                	addi	sp,sp,48
    800009f0:	8082                	ret

00000000800009f2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f2:	1101                	addi	sp,sp,-32
    800009f4:	ec06                	sd	ra,24(sp)
    800009f6:	e822                	sd	s0,16(sp)
    800009f8:	e426                	sd	s1,8(sp)
    800009fa:	1000                	addi	s0,sp,32
    800009fc:	84aa                	mv	s1,a0
  if(sz > 0)
    800009fe:	e999                	bnez	a1,80000a14 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a00:	8526                	mv	a0,s1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	f86080e7          	jalr	-122(ra) # 80000988 <freewalk>
}
    80000a0a:	60e2                	ld	ra,24(sp)
    80000a0c:	6442                	ld	s0,16(sp)
    80000a0e:	64a2                	ld	s1,8(sp)
    80000a10:	6105                	addi	sp,sp,32
    80000a12:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a14:	6605                	lui	a2,0x1
    80000a16:	167d                	addi	a2,a2,-1
    80000a18:	962e                	add	a2,a2,a1
    80000a1a:	4685                	li	a3,1
    80000a1c:	8231                	srli	a2,a2,0xc
    80000a1e:	4581                	li	a1,0
    80000a20:	00000097          	auipc	ra,0x0
    80000a24:	d12080e7          	jalr	-750(ra) # 80000732 <uvmunmap>
    80000a28:	bfe1                	j	80000a00 <uvmfree+0xe>

0000000080000a2a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a2a:	c679                	beqz	a2,80000af8 <uvmcopy+0xce>
{
    80000a2c:	715d                	addi	sp,sp,-80
    80000a2e:	e486                	sd	ra,72(sp)
    80000a30:	e0a2                	sd	s0,64(sp)
    80000a32:	fc26                	sd	s1,56(sp)
    80000a34:	f84a                	sd	s2,48(sp)
    80000a36:	f44e                	sd	s3,40(sp)
    80000a38:	f052                	sd	s4,32(sp)
    80000a3a:	ec56                	sd	s5,24(sp)
    80000a3c:	e85a                	sd	s6,16(sp)
    80000a3e:	e45e                	sd	s7,8(sp)
    80000a40:	0880                	addi	s0,sp,80
    80000a42:	8b2a                	mv	s6,a0
    80000a44:	8aae                	mv	s5,a1
    80000a46:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a48:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a4a:	4601                	li	a2,0
    80000a4c:	85ce                	mv	a1,s3
    80000a4e:	855a                	mv	a0,s6
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	a34080e7          	jalr	-1484(ra) # 80000484 <walk>
    80000a58:	c531                	beqz	a0,80000aa4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a5a:	6118                	ld	a4,0(a0)
    80000a5c:	00177793          	andi	a5,a4,1
    80000a60:	cbb1                	beqz	a5,80000ab4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a62:	00a75593          	srli	a1,a4,0xa
    80000a66:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a6a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a6e:	fffff097          	auipc	ra,0xfffff
    80000a72:	6aa080e7          	jalr	1706(ra) # 80000118 <kalloc>
    80000a76:	892a                	mv	s2,a0
    80000a78:	c939                	beqz	a0,80000ace <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a7a:	6605                	lui	a2,0x1
    80000a7c:	85de                	mv	a1,s7
    80000a7e:	fffff097          	auipc	ra,0xfffff
    80000a82:	77e080e7          	jalr	1918(ra) # 800001fc <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a86:	8726                	mv	a4,s1
    80000a88:	86ca                	mv	a3,s2
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	85ce                	mv	a1,s3
    80000a8e:	8556                	mv	a0,s5
    80000a90:	00000097          	auipc	ra,0x0
    80000a94:	adc080e7          	jalr	-1316(ra) # 8000056c <mappages>
    80000a98:	e515                	bnez	a0,80000ac4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a9a:	6785                	lui	a5,0x1
    80000a9c:	99be                	add	s3,s3,a5
    80000a9e:	fb49e6e3          	bltu	s3,s4,80000a4a <uvmcopy+0x20>
    80000aa2:	a081                	j	80000ae2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000aa4:	00007517          	auipc	a0,0x7
    80000aa8:	66450513          	addi	a0,a0,1636 # 80008108 <etext+0x108>
    80000aac:	00005097          	auipc	ra,0x5
    80000ab0:	1ac080e7          	jalr	428(ra) # 80005c58 <panic>
      panic("uvmcopy: page not present");
    80000ab4:	00007517          	auipc	a0,0x7
    80000ab8:	67450513          	addi	a0,a0,1652 # 80008128 <etext+0x128>
    80000abc:	00005097          	auipc	ra,0x5
    80000ac0:	19c080e7          	jalr	412(ra) # 80005c58 <panic>
      kfree(mem);
    80000ac4:	854a                	mv	a0,s2
    80000ac6:	fffff097          	auipc	ra,0xfffff
    80000aca:	556080e7          	jalr	1366(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ace:	4685                	li	a3,1
    80000ad0:	00c9d613          	srli	a2,s3,0xc
    80000ad4:	4581                	li	a1,0
    80000ad6:	8556                	mv	a0,s5
    80000ad8:	00000097          	auipc	ra,0x0
    80000adc:	c5a080e7          	jalr	-934(ra) # 80000732 <uvmunmap>
  return -1;
    80000ae0:	557d                	li	a0,-1
}
    80000ae2:	60a6                	ld	ra,72(sp)
    80000ae4:	6406                	ld	s0,64(sp)
    80000ae6:	74e2                	ld	s1,56(sp)
    80000ae8:	7942                	ld	s2,48(sp)
    80000aea:	79a2                	ld	s3,40(sp)
    80000aec:	7a02                	ld	s4,32(sp)
    80000aee:	6ae2                	ld	s5,24(sp)
    80000af0:	6b42                	ld	s6,16(sp)
    80000af2:	6ba2                	ld	s7,8(sp)
    80000af4:	6161                	addi	sp,sp,80
    80000af6:	8082                	ret
  return 0;
    80000af8:	4501                	li	a0,0
}
    80000afa:	8082                	ret

0000000080000afc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000afc:	1141                	addi	sp,sp,-16
    80000afe:	e406                	sd	ra,8(sp)
    80000b00:	e022                	sd	s0,0(sp)
    80000b02:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b04:	4601                	li	a2,0
    80000b06:	00000097          	auipc	ra,0x0
    80000b0a:	97e080e7          	jalr	-1666(ra) # 80000484 <walk>
  if(pte == 0)
    80000b0e:	c901                	beqz	a0,80000b1e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b10:	611c                	ld	a5,0(a0)
    80000b12:	9bbd                	andi	a5,a5,-17
    80000b14:	e11c                	sd	a5,0(a0)
}
    80000b16:	60a2                	ld	ra,8(sp)
    80000b18:	6402                	ld	s0,0(sp)
    80000b1a:	0141                	addi	sp,sp,16
    80000b1c:	8082                	ret
    panic("uvmclear");
    80000b1e:	00007517          	auipc	a0,0x7
    80000b22:	62a50513          	addi	a0,a0,1578 # 80008148 <etext+0x148>
    80000b26:	00005097          	auipc	ra,0x5
    80000b2a:	132080e7          	jalr	306(ra) # 80005c58 <panic>

0000000080000b2e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b2e:	c6bd                	beqz	a3,80000b9c <copyout+0x6e>
{
    80000b30:	715d                	addi	sp,sp,-80
    80000b32:	e486                	sd	ra,72(sp)
    80000b34:	e0a2                	sd	s0,64(sp)
    80000b36:	fc26                	sd	s1,56(sp)
    80000b38:	f84a                	sd	s2,48(sp)
    80000b3a:	f44e                	sd	s3,40(sp)
    80000b3c:	f052                	sd	s4,32(sp)
    80000b3e:	ec56                	sd	s5,24(sp)
    80000b40:	e85a                	sd	s6,16(sp)
    80000b42:	e45e                	sd	s7,8(sp)
    80000b44:	e062                	sd	s8,0(sp)
    80000b46:	0880                	addi	s0,sp,80
    80000b48:	8b2a                	mv	s6,a0
    80000b4a:	8c2e                	mv	s8,a1
    80000b4c:	8a32                	mv	s4,a2
    80000b4e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b50:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b52:	6a85                	lui	s5,0x1
    80000b54:	a015                	j	80000b78 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b56:	9562                	add	a0,a0,s8
    80000b58:	0004861b          	sext.w	a2,s1
    80000b5c:	85d2                	mv	a1,s4
    80000b5e:	41250533          	sub	a0,a0,s2
    80000b62:	fffff097          	auipc	ra,0xfffff
    80000b66:	69a080e7          	jalr	1690(ra) # 800001fc <memmove>

    len -= n;
    80000b6a:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b6e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b70:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b74:	02098263          	beqz	s3,80000b98 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b78:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b7c:	85ca                	mv	a1,s2
    80000b7e:	855a                	mv	a0,s6
    80000b80:	00000097          	auipc	ra,0x0
    80000b84:	9aa080e7          	jalr	-1622(ra) # 8000052a <walkaddr>
    if(pa0 == 0)
    80000b88:	cd01                	beqz	a0,80000ba0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b8a:	418904b3          	sub	s1,s2,s8
    80000b8e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b90:	fc99f3e3          	bgeu	s3,s1,80000b56 <copyout+0x28>
    80000b94:	84ce                	mv	s1,s3
    80000b96:	b7c1                	j	80000b56 <copyout+0x28>
  }
  return 0;
    80000b98:	4501                	li	a0,0
    80000b9a:	a021                	j	80000ba2 <copyout+0x74>
    80000b9c:	4501                	li	a0,0
}
    80000b9e:	8082                	ret
      return -1;
    80000ba0:	557d                	li	a0,-1
}
    80000ba2:	60a6                	ld	ra,72(sp)
    80000ba4:	6406                	ld	s0,64(sp)
    80000ba6:	74e2                	ld	s1,56(sp)
    80000ba8:	7942                	ld	s2,48(sp)
    80000baa:	79a2                	ld	s3,40(sp)
    80000bac:	7a02                	ld	s4,32(sp)
    80000bae:	6ae2                	ld	s5,24(sp)
    80000bb0:	6b42                	ld	s6,16(sp)
    80000bb2:	6ba2                	ld	s7,8(sp)
    80000bb4:	6c02                	ld	s8,0(sp)
    80000bb6:	6161                	addi	sp,sp,80
    80000bb8:	8082                	ret

0000000080000bba <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bba:	c6bd                	beqz	a3,80000c28 <copyin+0x6e>
{
    80000bbc:	715d                	addi	sp,sp,-80
    80000bbe:	e486                	sd	ra,72(sp)
    80000bc0:	e0a2                	sd	s0,64(sp)
    80000bc2:	fc26                	sd	s1,56(sp)
    80000bc4:	f84a                	sd	s2,48(sp)
    80000bc6:	f44e                	sd	s3,40(sp)
    80000bc8:	f052                	sd	s4,32(sp)
    80000bca:	ec56                	sd	s5,24(sp)
    80000bcc:	e85a                	sd	s6,16(sp)
    80000bce:	e45e                	sd	s7,8(sp)
    80000bd0:	e062                	sd	s8,0(sp)
    80000bd2:	0880                	addi	s0,sp,80
    80000bd4:	8b2a                	mv	s6,a0
    80000bd6:	8a2e                	mv	s4,a1
    80000bd8:	8c32                	mv	s8,a2
    80000bda:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bdc:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bde:	6a85                	lui	s5,0x1
    80000be0:	a015                	j	80000c04 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000be2:	9562                	add	a0,a0,s8
    80000be4:	0004861b          	sext.w	a2,s1
    80000be8:	412505b3          	sub	a1,a0,s2
    80000bec:	8552                	mv	a0,s4
    80000bee:	fffff097          	auipc	ra,0xfffff
    80000bf2:	60e080e7          	jalr	1550(ra) # 800001fc <memmove>

    len -= n;
    80000bf6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000bfa:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000bfc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c00:	02098263          	beqz	s3,80000c24 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c04:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c08:	85ca                	mv	a1,s2
    80000c0a:	855a                	mv	a0,s6
    80000c0c:	00000097          	auipc	ra,0x0
    80000c10:	91e080e7          	jalr	-1762(ra) # 8000052a <walkaddr>
    if(pa0 == 0)
    80000c14:	cd01                	beqz	a0,80000c2c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c16:	418904b3          	sub	s1,s2,s8
    80000c1a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c1c:	fc99f3e3          	bgeu	s3,s1,80000be2 <copyin+0x28>
    80000c20:	84ce                	mv	s1,s3
    80000c22:	b7c1                	j	80000be2 <copyin+0x28>
  }
  return 0;
    80000c24:	4501                	li	a0,0
    80000c26:	a021                	j	80000c2e <copyin+0x74>
    80000c28:	4501                	li	a0,0
}
    80000c2a:	8082                	ret
      return -1;
    80000c2c:	557d                	li	a0,-1
}
    80000c2e:	60a6                	ld	ra,72(sp)
    80000c30:	6406                	ld	s0,64(sp)
    80000c32:	74e2                	ld	s1,56(sp)
    80000c34:	7942                	ld	s2,48(sp)
    80000c36:	79a2                	ld	s3,40(sp)
    80000c38:	7a02                	ld	s4,32(sp)
    80000c3a:	6ae2                	ld	s5,24(sp)
    80000c3c:	6b42                	ld	s6,16(sp)
    80000c3e:	6ba2                	ld	s7,8(sp)
    80000c40:	6c02                	ld	s8,0(sp)
    80000c42:	6161                	addi	sp,sp,80
    80000c44:	8082                	ret

0000000080000c46 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c46:	c6c5                	beqz	a3,80000cee <copyinstr+0xa8>
{
    80000c48:	715d                	addi	sp,sp,-80
    80000c4a:	e486                	sd	ra,72(sp)
    80000c4c:	e0a2                	sd	s0,64(sp)
    80000c4e:	fc26                	sd	s1,56(sp)
    80000c50:	f84a                	sd	s2,48(sp)
    80000c52:	f44e                	sd	s3,40(sp)
    80000c54:	f052                	sd	s4,32(sp)
    80000c56:	ec56                	sd	s5,24(sp)
    80000c58:	e85a                	sd	s6,16(sp)
    80000c5a:	e45e                	sd	s7,8(sp)
    80000c5c:	0880                	addi	s0,sp,80
    80000c5e:	8a2a                	mv	s4,a0
    80000c60:	8b2e                	mv	s6,a1
    80000c62:	8bb2                	mv	s7,a2
    80000c64:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c66:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c68:	6985                	lui	s3,0x1
    80000c6a:	a035                	j	80000c96 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c6c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c70:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c72:	0017b793          	seqz	a5,a5
    80000c76:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c7a:	60a6                	ld	ra,72(sp)
    80000c7c:	6406                	ld	s0,64(sp)
    80000c7e:	74e2                	ld	s1,56(sp)
    80000c80:	7942                	ld	s2,48(sp)
    80000c82:	79a2                	ld	s3,40(sp)
    80000c84:	7a02                	ld	s4,32(sp)
    80000c86:	6ae2                	ld	s5,24(sp)
    80000c88:	6b42                	ld	s6,16(sp)
    80000c8a:	6ba2                	ld	s7,8(sp)
    80000c8c:	6161                	addi	sp,sp,80
    80000c8e:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c90:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c94:	c8a9                	beqz	s1,80000ce6 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c96:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c9a:	85ca                	mv	a1,s2
    80000c9c:	8552                	mv	a0,s4
    80000c9e:	00000097          	auipc	ra,0x0
    80000ca2:	88c080e7          	jalr	-1908(ra) # 8000052a <walkaddr>
    if(pa0 == 0)
    80000ca6:	c131                	beqz	a0,80000cea <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ca8:	41790833          	sub	a6,s2,s7
    80000cac:	984e                	add	a6,a6,s3
    if(n > max)
    80000cae:	0104f363          	bgeu	s1,a6,80000cb4 <copyinstr+0x6e>
    80000cb2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cb4:	955e                	add	a0,a0,s7
    80000cb6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cba:	fc080be3          	beqz	a6,80000c90 <copyinstr+0x4a>
    80000cbe:	985a                	add	a6,a6,s6
    80000cc0:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cc2:	41650633          	sub	a2,a0,s6
    80000cc6:	14fd                	addi	s1,s1,-1
    80000cc8:	9b26                	add	s6,s6,s1
    80000cca:	00f60733          	add	a4,a2,a5
    80000cce:	00074703          	lbu	a4,0(a4)
    80000cd2:	df49                	beqz	a4,80000c6c <copyinstr+0x26>
        *dst = *p;
    80000cd4:	00e78023          	sb	a4,0(a5)
      --max;
    80000cd8:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cdc:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cde:	ff0796e3          	bne	a5,a6,80000cca <copyinstr+0x84>
      dst++;
    80000ce2:	8b42                	mv	s6,a6
    80000ce4:	b775                	j	80000c90 <copyinstr+0x4a>
    80000ce6:	4781                	li	a5,0
    80000ce8:	b769                	j	80000c72 <copyinstr+0x2c>
      return -1;
    80000cea:	557d                	li	a0,-1
    80000cec:	b779                	j	80000c7a <copyinstr+0x34>
  int got_null = 0;
    80000cee:	4781                	li	a5,0
  if(got_null){
    80000cf0:	0017b793          	seqz	a5,a5
    80000cf4:	40f00533          	neg	a0,a5
}
    80000cf8:	8082                	ret

0000000080000cfa <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000cfa:	7139                	addi	sp,sp,-64
    80000cfc:	fc06                	sd	ra,56(sp)
    80000cfe:	f822                	sd	s0,48(sp)
    80000d00:	f426                	sd	s1,40(sp)
    80000d02:	f04a                	sd	s2,32(sp)
    80000d04:	ec4e                	sd	s3,24(sp)
    80000d06:	e852                	sd	s4,16(sp)
    80000d08:	e456                	sd	s5,8(sp)
    80000d0a:	e05a                	sd	s6,0(sp)
    80000d0c:	0080                	addi	s0,sp,64
    80000d0e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d10:	00008497          	auipc	s1,0x8
    80000d14:	77048493          	addi	s1,s1,1904 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d18:	8b26                	mv	s6,s1
    80000d1a:	00007a97          	auipc	s5,0x7
    80000d1e:	2e6a8a93          	addi	s5,s5,742 # 80008000 <etext>
    80000d22:	04000937          	lui	s2,0x4000
    80000d26:	197d                	addi	s2,s2,-1
    80000d28:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2a:	0000ea17          	auipc	s4,0xe
    80000d2e:	356a0a13          	addi	s4,s4,854 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d32:	fffff097          	auipc	ra,0xfffff
    80000d36:	3e6080e7          	jalr	998(ra) # 80000118 <kalloc>
    80000d3a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d3c:	c131                	beqz	a0,80000d80 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d3e:	416485b3          	sub	a1,s1,s6
    80000d42:	8591                	srai	a1,a1,0x4
    80000d44:	000ab783          	ld	a5,0(s5)
    80000d48:	02f585b3          	mul	a1,a1,a5
    80000d4c:	2585                	addiw	a1,a1,1
    80000d4e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d52:	4719                	li	a4,6
    80000d54:	6685                	lui	a3,0x1
    80000d56:	40b905b3          	sub	a1,s2,a1
    80000d5a:	854e                	mv	a0,s3
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	8b0080e7          	jalr	-1872(ra) # 8000060c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d64:	17048493          	addi	s1,s1,368
    80000d68:	fd4495e3          	bne	s1,s4,80000d32 <proc_mapstacks+0x38>
  }
}
    80000d6c:	70e2                	ld	ra,56(sp)
    80000d6e:	7442                	ld	s0,48(sp)
    80000d70:	74a2                	ld	s1,40(sp)
    80000d72:	7902                	ld	s2,32(sp)
    80000d74:	69e2                	ld	s3,24(sp)
    80000d76:	6a42                	ld	s4,16(sp)
    80000d78:	6aa2                	ld	s5,8(sp)
    80000d7a:	6b02                	ld	s6,0(sp)
    80000d7c:	6121                	addi	sp,sp,64
    80000d7e:	8082                	ret
      panic("kalloc");
    80000d80:	00007517          	auipc	a0,0x7
    80000d84:	3d850513          	addi	a0,a0,984 # 80008158 <etext+0x158>
    80000d88:	00005097          	auipc	ra,0x5
    80000d8c:	ed0080e7          	jalr	-304(ra) # 80005c58 <panic>

0000000080000d90 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000d90:	7139                	addi	sp,sp,-64
    80000d92:	fc06                	sd	ra,56(sp)
    80000d94:	f822                	sd	s0,48(sp)
    80000d96:	f426                	sd	s1,40(sp)
    80000d98:	f04a                	sd	s2,32(sp)
    80000d9a:	ec4e                	sd	s3,24(sp)
    80000d9c:	e852                	sd	s4,16(sp)
    80000d9e:	e456                	sd	s5,8(sp)
    80000da0:	e05a                	sd	s6,0(sp)
    80000da2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3bc58593          	addi	a1,a1,956 # 80008160 <etext+0x160>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	2a450513          	addi	a0,a0,676 # 80009050 <pid_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	35e080e7          	jalr	862(ra) # 80006112 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbc:	00007597          	auipc	a1,0x7
    80000dc0:	3ac58593          	addi	a1,a1,940 # 80008168 <etext+0x168>
    80000dc4:	00008517          	auipc	a0,0x8
    80000dc8:	2a450513          	addi	a0,a0,676 # 80009068 <wait_lock>
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	346080e7          	jalr	838(ra) # 80006112 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd4:	00008497          	auipc	s1,0x8
    80000dd8:	6ac48493          	addi	s1,s1,1708 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ddc:	00007b17          	auipc	s6,0x7
    80000de0:	39cb0b13          	addi	s6,s6,924 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000de4:	8aa6                	mv	s5,s1
    80000de6:	00007a17          	auipc	s4,0x7
    80000dea:	21aa0a13          	addi	s4,s4,538 # 80008000 <etext>
    80000dee:	04000937          	lui	s2,0x4000
    80000df2:	197d                	addi	s2,s2,-1
    80000df4:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df6:	0000e997          	auipc	s3,0xe
    80000dfa:	28a98993          	addi	s3,s3,650 # 8000f080 <tickslock>
      initlock(&p->lock, "proc");
    80000dfe:	85da                	mv	a1,s6
    80000e00:	8526                	mv	a0,s1
    80000e02:	00005097          	auipc	ra,0x5
    80000e06:	310080e7          	jalr	784(ra) # 80006112 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	415487b3          	sub	a5,s1,s5
    80000e0e:	8791                	srai	a5,a5,0x4
    80000e10:	000a3703          	ld	a4,0(s4)
    80000e14:	02e787b3          	mul	a5,a5,a4
    80000e18:	2785                	addiw	a5,a5,1
    80000e1a:	00d7979b          	slliw	a5,a5,0xd
    80000e1e:	40f907b3          	sub	a5,s2,a5
    80000e22:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e24:	17048493          	addi	s1,s1,368
    80000e28:	fd349be3          	bne	s1,s3,80000dfe <procinit+0x6e>
  }
}
    80000e2c:	70e2                	ld	ra,56(sp)
    80000e2e:	7442                	ld	s0,48(sp)
    80000e30:	74a2                	ld	s1,40(sp)
    80000e32:	7902                	ld	s2,32(sp)
    80000e34:	69e2                	ld	s3,24(sp)
    80000e36:	6a42                	ld	s4,16(sp)
    80000e38:	6aa2                	ld	s5,8(sp)
    80000e3a:	6b02                	ld	s6,0(sp)
    80000e3c:	6121                	addi	sp,sp,64
    80000e3e:	8082                	ret

0000000080000e40 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e40:	1141                	addi	sp,sp,-16
    80000e42:	e422                	sd	s0,8(sp)
    80000e44:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e46:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e48:	2501                	sext.w	a0,a0
    80000e4a:	6422                	ld	s0,8(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
    80000e56:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e58:	2781                	sext.w	a5,a5
    80000e5a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e5c:	00008517          	auipc	a0,0x8
    80000e60:	22450513          	addi	a0,a0,548 # 80009080 <cpus>
    80000e64:	953e                	add	a0,a0,a5
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret

0000000080000e6c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000e6c:	1101                	addi	sp,sp,-32
    80000e6e:	ec06                	sd	ra,24(sp)
    80000e70:	e822                	sd	s0,16(sp)
    80000e72:	e426                	sd	s1,8(sp)
    80000e74:	1000                	addi	s0,sp,32
  push_off();
    80000e76:	00005097          	auipc	ra,0x5
    80000e7a:	2e0080e7          	jalr	736(ra) # 80006156 <push_off>
    80000e7e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e80:	2781                	sext.w	a5,a5
    80000e82:	079e                	slli	a5,a5,0x7
    80000e84:	00008717          	auipc	a4,0x8
    80000e88:	1cc70713          	addi	a4,a4,460 # 80009050 <pid_lock>
    80000e8c:	97ba                	add	a5,a5,a4
    80000e8e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e90:	00005097          	auipc	ra,0x5
    80000e94:	366080e7          	jalr	870(ra) # 800061f6 <pop_off>
  return p;
}
    80000e98:	8526                	mv	a0,s1
    80000e9a:	60e2                	ld	ra,24(sp)
    80000e9c:	6442                	ld	s0,16(sp)
    80000e9e:	64a2                	ld	s1,8(sp)
    80000ea0:	6105                	addi	sp,sp,32
    80000ea2:	8082                	ret

0000000080000ea4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ea4:	1141                	addi	sp,sp,-16
    80000ea6:	e406                	sd	ra,8(sp)
    80000ea8:	e022                	sd	s0,0(sp)
    80000eaa:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eac:	00000097          	auipc	ra,0x0
    80000eb0:	fc0080e7          	jalr	-64(ra) # 80000e6c <myproc>
    80000eb4:	00005097          	auipc	ra,0x5
    80000eb8:	3a2080e7          	jalr	930(ra) # 80006256 <release>

  if (first) {
    80000ebc:	00008797          	auipc	a5,0x8
    80000ec0:	ae47a783          	lw	a5,-1308(a5) # 800089a0 <first.1677>
    80000ec4:	eb89                	bnez	a5,80000ed6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	c46080e7          	jalr	-954(ra) # 80001b0c <usertrapret>
}
    80000ece:	60a2                	ld	ra,8(sp)
    80000ed0:	6402                	ld	s0,0(sp)
    80000ed2:	0141                	addi	sp,sp,16
    80000ed4:	8082                	ret
    first = 0;
    80000ed6:	00008797          	auipc	a5,0x8
    80000eda:	ac07a523          	sw	zero,-1334(a5) # 800089a0 <first.1677>
    fsinit(ROOTDEV);
    80000ede:	4505                	li	a0,1
    80000ee0:	00002097          	auipc	ra,0x2
    80000ee4:	a4c080e7          	jalr	-1460(ra) # 8000292c <fsinit>
    80000ee8:	bff9                	j	80000ec6 <forkret+0x22>

0000000080000eea <allocpid>:
allocpid() {
    80000eea:	1101                	addi	sp,sp,-32
    80000eec:	ec06                	sd	ra,24(sp)
    80000eee:	e822                	sd	s0,16(sp)
    80000ef0:	e426                	sd	s1,8(sp)
    80000ef2:	e04a                	sd	s2,0(sp)
    80000ef4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ef6:	00008917          	auipc	s2,0x8
    80000efa:	15a90913          	addi	s2,s2,346 # 80009050 <pid_lock>
    80000efe:	854a                	mv	a0,s2
    80000f00:	00005097          	auipc	ra,0x5
    80000f04:	2a2080e7          	jalr	674(ra) # 800061a2 <acquire>
  pid = nextpid;
    80000f08:	00008797          	auipc	a5,0x8
    80000f0c:	a9c78793          	addi	a5,a5,-1380 # 800089a4 <nextpid>
    80000f10:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f12:	0014871b          	addiw	a4,s1,1
    80000f16:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f18:	854a                	mv	a0,s2
    80000f1a:	00005097          	auipc	ra,0x5
    80000f1e:	33c080e7          	jalr	828(ra) # 80006256 <release>
}
    80000f22:	8526                	mv	a0,s1
    80000f24:	60e2                	ld	ra,24(sp)
    80000f26:	6442                	ld	s0,16(sp)
    80000f28:	64a2                	ld	s1,8(sp)
    80000f2a:	6902                	ld	s2,0(sp)
    80000f2c:	6105                	addi	sp,sp,32
    80000f2e:	8082                	ret

0000000080000f30 <proc_pagetable>:
{
    80000f30:	1101                	addi	sp,sp,-32
    80000f32:	ec06                	sd	ra,24(sp)
    80000f34:	e822                	sd	s0,16(sp)
    80000f36:	e426                	sd	s1,8(sp)
    80000f38:	e04a                	sd	s2,0(sp)
    80000f3a:	1000                	addi	s0,sp,32
    80000f3c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f3e:	00000097          	auipc	ra,0x0
    80000f42:	8b8080e7          	jalr	-1864(ra) # 800007f6 <uvmcreate>
    80000f46:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f48:	c121                	beqz	a0,80000f88 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f4a:	4729                	li	a4,10
    80000f4c:	00006697          	auipc	a3,0x6
    80000f50:	0b468693          	addi	a3,a3,180 # 80007000 <_trampoline>
    80000f54:	6605                	lui	a2,0x1
    80000f56:	040005b7          	lui	a1,0x4000
    80000f5a:	15fd                	addi	a1,a1,-1
    80000f5c:	05b2                	slli	a1,a1,0xc
    80000f5e:	fffff097          	auipc	ra,0xfffff
    80000f62:	60e080e7          	jalr	1550(ra) # 8000056c <mappages>
    80000f66:	02054863          	bltz	a0,80000f96 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f6a:	4719                	li	a4,6
    80000f6c:	05893683          	ld	a3,88(s2)
    80000f70:	6605                	lui	a2,0x1
    80000f72:	020005b7          	lui	a1,0x2000
    80000f76:	15fd                	addi	a1,a1,-1
    80000f78:	05b6                	slli	a1,a1,0xd
    80000f7a:	8526                	mv	a0,s1
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	5f0080e7          	jalr	1520(ra) # 8000056c <mappages>
    80000f84:	02054163          	bltz	a0,80000fa6 <proc_pagetable+0x76>
}
    80000f88:	8526                	mv	a0,s1
    80000f8a:	60e2                	ld	ra,24(sp)
    80000f8c:	6442                	ld	s0,16(sp)
    80000f8e:	64a2                	ld	s1,8(sp)
    80000f90:	6902                	ld	s2,0(sp)
    80000f92:	6105                	addi	sp,sp,32
    80000f94:	8082                	ret
    uvmfree(pagetable, 0);
    80000f96:	4581                	li	a1,0
    80000f98:	8526                	mv	a0,s1
    80000f9a:	00000097          	auipc	ra,0x0
    80000f9e:	a58080e7          	jalr	-1448(ra) # 800009f2 <uvmfree>
    return 0;
    80000fa2:	4481                	li	s1,0
    80000fa4:	b7d5                	j	80000f88 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	77e080e7          	jalr	1918(ra) # 80000732 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fbc:	4581                	li	a1,0
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	00000097          	auipc	ra,0x0
    80000fc4:	a32080e7          	jalr	-1486(ra) # 800009f2 <uvmfree>
    return 0;
    80000fc8:	4481                	li	s1,0
    80000fca:	bf7d                	j	80000f88 <proc_pagetable+0x58>

0000000080000fcc <proc_freepagetable>:
{
    80000fcc:	1101                	addi	sp,sp,-32
    80000fce:	ec06                	sd	ra,24(sp)
    80000fd0:	e822                	sd	s0,16(sp)
    80000fd2:	e426                	sd	s1,8(sp)
    80000fd4:	e04a                	sd	s2,0(sp)
    80000fd6:	1000                	addi	s0,sp,32
    80000fd8:	84aa                	mv	s1,a0
    80000fda:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	040005b7          	lui	a1,0x4000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b2                	slli	a1,a1,0xc
    80000fe8:	fffff097          	auipc	ra,0xfffff
    80000fec:	74a080e7          	jalr	1866(ra) # 80000732 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ff0:	4681                	li	a3,0
    80000ff2:	4605                	li	a2,1
    80000ff4:	020005b7          	lui	a1,0x2000
    80000ff8:	15fd                	addi	a1,a1,-1
    80000ffa:	05b6                	slli	a1,a1,0xd
    80000ffc:	8526                	mv	a0,s1
    80000ffe:	fffff097          	auipc	ra,0xfffff
    80001002:	734080e7          	jalr	1844(ra) # 80000732 <uvmunmap>
  uvmfree(pagetable, sz);
    80001006:	85ca                	mv	a1,s2
    80001008:	8526                	mv	a0,s1
    8000100a:	00000097          	auipc	ra,0x0
    8000100e:	9e8080e7          	jalr	-1560(ra) # 800009f2 <uvmfree>
}
    80001012:	60e2                	ld	ra,24(sp)
    80001014:	6442                	ld	s0,16(sp)
    80001016:	64a2                	ld	s1,8(sp)
    80001018:	6902                	ld	s2,0(sp)
    8000101a:	6105                	addi	sp,sp,32
    8000101c:	8082                	ret

000000008000101e <freeproc>:
{
    8000101e:	1101                	addi	sp,sp,-32
    80001020:	ec06                	sd	ra,24(sp)
    80001022:	e822                	sd	s0,16(sp)
    80001024:	e426                	sd	s1,8(sp)
    80001026:	1000                	addi	s0,sp,32
    80001028:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000102a:	6d28                	ld	a0,88(a0)
    8000102c:	c509                	beqz	a0,80001036 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000102e:	fffff097          	auipc	ra,0xfffff
    80001032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001036:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000103a:	68a8                	ld	a0,80(s1)
    8000103c:	c511                	beqz	a0,80001048 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000103e:	64ac                	ld	a1,72(s1)
    80001040:	00000097          	auipc	ra,0x0
    80001044:	f8c080e7          	jalr	-116(ra) # 80000fcc <proc_freepagetable>
  p->pagetable = 0;
    80001048:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000104c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001050:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001054:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001058:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000105c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001060:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001064:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001068:	0004ac23          	sw	zero,24(s1)
  p->trace_mask = 0;
    8000106c:	1604a423          	sw	zero,360(s1)
}
    80001070:	60e2                	ld	ra,24(sp)
    80001072:	6442                	ld	s0,16(sp)
    80001074:	64a2                	ld	s1,8(sp)
    80001076:	6105                	addi	sp,sp,32
    80001078:	8082                	ret

000000008000107a <allocproc>:
{
    8000107a:	1101                	addi	sp,sp,-32
    8000107c:	ec06                	sd	ra,24(sp)
    8000107e:	e822                	sd	s0,16(sp)
    80001080:	e426                	sd	s1,8(sp)
    80001082:	e04a                	sd	s2,0(sp)
    80001084:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001086:	00008497          	auipc	s1,0x8
    8000108a:	3fa48493          	addi	s1,s1,1018 # 80009480 <proc>
    8000108e:	0000e917          	auipc	s2,0xe
    80001092:	ff290913          	addi	s2,s2,-14 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	10a080e7          	jalr	266(ra) # 800061a2 <acquire>
    if(p->state == UNUSED) {
    800010a0:	4c9c                	lw	a5,24(s1)
    800010a2:	cf81                	beqz	a5,800010ba <allocproc+0x40>
      release(&p->lock);
    800010a4:	8526                	mv	a0,s1
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	1b0080e7          	jalr	432(ra) # 80006256 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ae:	17048493          	addi	s1,s1,368
    800010b2:	ff2492e3          	bne	s1,s2,80001096 <allocproc+0x1c>
  return 0;
    800010b6:	4481                	li	s1,0
    800010b8:	a889                	j	8000110a <allocproc+0x90>
  p->pid = allocpid();
    800010ba:	00000097          	auipc	ra,0x0
    800010be:	e30080e7          	jalr	-464(ra) # 80000eea <allocpid>
    800010c2:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010c4:	4785                	li	a5,1
    800010c6:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010c8:	fffff097          	auipc	ra,0xfffff
    800010cc:	050080e7          	jalr	80(ra) # 80000118 <kalloc>
    800010d0:	892a                	mv	s2,a0
    800010d2:	eca8                	sd	a0,88(s1)
    800010d4:	c131                	beqz	a0,80001118 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010d6:	8526                	mv	a0,s1
    800010d8:	00000097          	auipc	ra,0x0
    800010dc:	e58080e7          	jalr	-424(ra) # 80000f30 <proc_pagetable>
    800010e0:	892a                	mv	s2,a0
    800010e2:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010e4:	c531                	beqz	a0,80001130 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010e6:	07000613          	li	a2,112
    800010ea:	4581                	li	a1,0
    800010ec:	06048513          	addi	a0,s1,96
    800010f0:	fffff097          	auipc	ra,0xfffff
    800010f4:	0ac080e7          	jalr	172(ra) # 8000019c <memset>
  p->context.ra = (uint64)forkret;
    800010f8:	00000797          	auipc	a5,0x0
    800010fc:	dac78793          	addi	a5,a5,-596 # 80000ea4 <forkret>
    80001100:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001102:	60bc                	ld	a5,64(s1)
    80001104:	6705                	lui	a4,0x1
    80001106:	97ba                	add	a5,a5,a4
    80001108:	f4bc                	sd	a5,104(s1)
}
    8000110a:	8526                	mv	a0,s1
    8000110c:	60e2                	ld	ra,24(sp)
    8000110e:	6442                	ld	s0,16(sp)
    80001110:	64a2                	ld	s1,8(sp)
    80001112:	6902                	ld	s2,0(sp)
    80001114:	6105                	addi	sp,sp,32
    80001116:	8082                	ret
    freeproc(p);
    80001118:	8526                	mv	a0,s1
    8000111a:	00000097          	auipc	ra,0x0
    8000111e:	f04080e7          	jalr	-252(ra) # 8000101e <freeproc>
    release(&p->lock);
    80001122:	8526                	mv	a0,s1
    80001124:	00005097          	auipc	ra,0x5
    80001128:	132080e7          	jalr	306(ra) # 80006256 <release>
    return 0;
    8000112c:	84ca                	mv	s1,s2
    8000112e:	bff1                	j	8000110a <allocproc+0x90>
    freeproc(p);
    80001130:	8526                	mv	a0,s1
    80001132:	00000097          	auipc	ra,0x0
    80001136:	eec080e7          	jalr	-276(ra) # 8000101e <freeproc>
    release(&p->lock);
    8000113a:	8526                	mv	a0,s1
    8000113c:	00005097          	auipc	ra,0x5
    80001140:	11a080e7          	jalr	282(ra) # 80006256 <release>
    return 0;
    80001144:	84ca                	mv	s1,s2
    80001146:	b7d1                	j	8000110a <allocproc+0x90>

0000000080001148 <userinit>:
{
    80001148:	1101                	addi	sp,sp,-32
    8000114a:	ec06                	sd	ra,24(sp)
    8000114c:	e822                	sd	s0,16(sp)
    8000114e:	e426                	sd	s1,8(sp)
    80001150:	1000                	addi	s0,sp,32
  p = allocproc();
    80001152:	00000097          	auipc	ra,0x0
    80001156:	f28080e7          	jalr	-216(ra) # 8000107a <allocproc>
    8000115a:	84aa                	mv	s1,a0
  initproc = p;
    8000115c:	00008797          	auipc	a5,0x8
    80001160:	eaa7ba23          	sd	a0,-332(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001164:	03400613          	li	a2,52
    80001168:	00008597          	auipc	a1,0x8
    8000116c:	84858593          	addi	a1,a1,-1976 # 800089b0 <initcode>
    80001170:	6928                	ld	a0,80(a0)
    80001172:	fffff097          	auipc	ra,0xfffff
    80001176:	6b2080e7          	jalr	1714(ra) # 80000824 <uvminit>
  p->sz = PGSIZE;
    8000117a:	6785                	lui	a5,0x1
    8000117c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000117e:	6cb8                	ld	a4,88(s1)
    80001180:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001184:	6cb8                	ld	a4,88(s1)
    80001186:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001188:	4641                	li	a2,16
    8000118a:	00007597          	auipc	a1,0x7
    8000118e:	ff658593          	addi	a1,a1,-10 # 80008180 <etext+0x180>
    80001192:	15848513          	addi	a0,s1,344
    80001196:	fffff097          	auipc	ra,0xfffff
    8000119a:	158080e7          	jalr	344(ra) # 800002ee <safestrcpy>
  p->cwd = namei("/");
    8000119e:	00007517          	auipc	a0,0x7
    800011a2:	ff250513          	addi	a0,a0,-14 # 80008190 <etext+0x190>
    800011a6:	00002097          	auipc	ra,0x2
    800011aa:	1b4080e7          	jalr	436(ra) # 8000335a <namei>
    800011ae:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011b2:	478d                	li	a5,3
    800011b4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011b6:	8526                	mv	a0,s1
    800011b8:	00005097          	auipc	ra,0x5
    800011bc:	09e080e7          	jalr	158(ra) # 80006256 <release>
}
    800011c0:	60e2                	ld	ra,24(sp)
    800011c2:	6442                	ld	s0,16(sp)
    800011c4:	64a2                	ld	s1,8(sp)
    800011c6:	6105                	addi	sp,sp,32
    800011c8:	8082                	ret

00000000800011ca <growproc>:
{
    800011ca:	1101                	addi	sp,sp,-32
    800011cc:	ec06                	sd	ra,24(sp)
    800011ce:	e822                	sd	s0,16(sp)
    800011d0:	e426                	sd	s1,8(sp)
    800011d2:	e04a                	sd	s2,0(sp)
    800011d4:	1000                	addi	s0,sp,32
    800011d6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800011d8:	00000097          	auipc	ra,0x0
    800011dc:	c94080e7          	jalr	-876(ra) # 80000e6c <myproc>
    800011e0:	892a                	mv	s2,a0
  sz = p->sz;
    800011e2:	652c                	ld	a1,72(a0)
    800011e4:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800011e8:	00904f63          	bgtz	s1,80001206 <growproc+0x3c>
  } else if(n < 0){
    800011ec:	0204cc63          	bltz	s1,80001224 <growproc+0x5a>
  p->sz = sz;
    800011f0:	1602                	slli	a2,a2,0x20
    800011f2:	9201                	srli	a2,a2,0x20
    800011f4:	04c93423          	sd	a2,72(s2)
  return 0;
    800011f8:	4501                	li	a0,0
}
    800011fa:	60e2                	ld	ra,24(sp)
    800011fc:	6442                	ld	s0,16(sp)
    800011fe:	64a2                	ld	s1,8(sp)
    80001200:	6902                	ld	s2,0(sp)
    80001202:	6105                	addi	sp,sp,32
    80001204:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001206:	9e25                	addw	a2,a2,s1
    80001208:	1602                	slli	a2,a2,0x20
    8000120a:	9201                	srli	a2,a2,0x20
    8000120c:	1582                	slli	a1,a1,0x20
    8000120e:	9181                	srli	a1,a1,0x20
    80001210:	6928                	ld	a0,80(a0)
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	6cc080e7          	jalr	1740(ra) # 800008de <uvmalloc>
    8000121a:	0005061b          	sext.w	a2,a0
    8000121e:	fa69                	bnez	a2,800011f0 <growproc+0x26>
      return -1;
    80001220:	557d                	li	a0,-1
    80001222:	bfe1                	j	800011fa <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001224:	9e25                	addw	a2,a2,s1
    80001226:	1602                	slli	a2,a2,0x20
    80001228:	9201                	srli	a2,a2,0x20
    8000122a:	1582                	slli	a1,a1,0x20
    8000122c:	9181                	srli	a1,a1,0x20
    8000122e:	6928                	ld	a0,80(a0)
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	666080e7          	jalr	1638(ra) # 80000896 <uvmdealloc>
    80001238:	0005061b          	sext.w	a2,a0
    8000123c:	bf55                	j	800011f0 <growproc+0x26>

000000008000123e <fork>:
{
    8000123e:	7179                	addi	sp,sp,-48
    80001240:	f406                	sd	ra,40(sp)
    80001242:	f022                	sd	s0,32(sp)
    80001244:	ec26                	sd	s1,24(sp)
    80001246:	e84a                	sd	s2,16(sp)
    80001248:	e44e                	sd	s3,8(sp)
    8000124a:	e052                	sd	s4,0(sp)
    8000124c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	c1e080e7          	jalr	-994(ra) # 80000e6c <myproc>
    80001256:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	e22080e7          	jalr	-478(ra) # 8000107a <allocproc>
    80001260:	10050f63          	beqz	a0,8000137e <fork+0x140>
    80001264:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001266:	04893603          	ld	a2,72(s2)
    8000126a:	692c                	ld	a1,80(a0)
    8000126c:	05093503          	ld	a0,80(s2)
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	7ba080e7          	jalr	1978(ra) # 80000a2a <uvmcopy>
    80001278:	04054a63          	bltz	a0,800012cc <fork+0x8e>
  np->sz = p->sz;
    8000127c:	04893783          	ld	a5,72(s2)
    80001280:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001284:	05893683          	ld	a3,88(s2)
    80001288:	87b6                	mv	a5,a3
    8000128a:	0589b703          	ld	a4,88(s3)
    8000128e:	12068693          	addi	a3,a3,288
    80001292:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001296:	6788                	ld	a0,8(a5)
    80001298:	6b8c                	ld	a1,16(a5)
    8000129a:	6f90                	ld	a2,24(a5)
    8000129c:	01073023          	sd	a6,0(a4)
    800012a0:	e708                	sd	a0,8(a4)
    800012a2:	eb0c                	sd	a1,16(a4)
    800012a4:	ef10                	sd	a2,24(a4)
    800012a6:	02078793          	addi	a5,a5,32
    800012aa:	02070713          	addi	a4,a4,32
    800012ae:	fed792e3          	bne	a5,a3,80001292 <fork+0x54>
  np->trace_mask = p->trace_mask;
    800012b2:	16892783          	lw	a5,360(s2)
    800012b6:	16f9a423          	sw	a5,360(s3)
  np->trapframe->a0 = 0;
    800012ba:	0589b783          	ld	a5,88(s3)
    800012be:	0607b823          	sd	zero,112(a5)
    800012c2:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012c6:	15000a13          	li	s4,336
    800012ca:	a03d                	j	800012f8 <fork+0xba>
    freeproc(np);
    800012cc:	854e                	mv	a0,s3
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	d50080e7          	jalr	-688(ra) # 8000101e <freeproc>
    release(&np->lock);
    800012d6:	854e                	mv	a0,s3
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	f7e080e7          	jalr	-130(ra) # 80006256 <release>
    return -1;
    800012e0:	5a7d                	li	s4,-1
    800012e2:	a069                	j	8000136c <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012e4:	00002097          	auipc	ra,0x2
    800012e8:	70c080e7          	jalr	1804(ra) # 800039f0 <filedup>
    800012ec:	009987b3          	add	a5,s3,s1
    800012f0:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012f2:	04a1                	addi	s1,s1,8
    800012f4:	01448763          	beq	s1,s4,80001302 <fork+0xc4>
    if(p->ofile[i])
    800012f8:	009907b3          	add	a5,s2,s1
    800012fc:	6388                	ld	a0,0(a5)
    800012fe:	f17d                	bnez	a0,800012e4 <fork+0xa6>
    80001300:	bfcd                	j	800012f2 <fork+0xb4>
  np->cwd = idup(p->cwd);
    80001302:	15093503          	ld	a0,336(s2)
    80001306:	00002097          	auipc	ra,0x2
    8000130a:	860080e7          	jalr	-1952(ra) # 80002b66 <idup>
    8000130e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001312:	4641                	li	a2,16
    80001314:	15890593          	addi	a1,s2,344
    80001318:	15898513          	addi	a0,s3,344
    8000131c:	fffff097          	auipc	ra,0xfffff
    80001320:	fd2080e7          	jalr	-46(ra) # 800002ee <safestrcpy>
  pid = np->pid;
    80001324:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001328:	854e                	mv	a0,s3
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	f2c080e7          	jalr	-212(ra) # 80006256 <release>
  acquire(&wait_lock);
    80001332:	00008497          	auipc	s1,0x8
    80001336:	d3648493          	addi	s1,s1,-714 # 80009068 <wait_lock>
    8000133a:	8526                	mv	a0,s1
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	e66080e7          	jalr	-410(ra) # 800061a2 <acquire>
  np->parent = p;
    80001344:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    80001348:	8526                	mv	a0,s1
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	f0c080e7          	jalr	-244(ra) # 80006256 <release>
  acquire(&np->lock);
    80001352:	854e                	mv	a0,s3
    80001354:	00005097          	auipc	ra,0x5
    80001358:	e4e080e7          	jalr	-434(ra) # 800061a2 <acquire>
  np->state = RUNNABLE;
    8000135c:	478d                	li	a5,3
    8000135e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001362:	854e                	mv	a0,s3
    80001364:	00005097          	auipc	ra,0x5
    80001368:	ef2080e7          	jalr	-270(ra) # 80006256 <release>
}
    8000136c:	8552                	mv	a0,s4
    8000136e:	70a2                	ld	ra,40(sp)
    80001370:	7402                	ld	s0,32(sp)
    80001372:	64e2                	ld	s1,24(sp)
    80001374:	6942                	ld	s2,16(sp)
    80001376:	69a2                	ld	s3,8(sp)
    80001378:	6a02                	ld	s4,0(sp)
    8000137a:	6145                	addi	sp,sp,48
    8000137c:	8082                	ret
    return -1;
    8000137e:	5a7d                	li	s4,-1
    80001380:	b7f5                	j	8000136c <fork+0x12e>

0000000080001382 <scheduler>:
{
    80001382:	7139                	addi	sp,sp,-64
    80001384:	fc06                	sd	ra,56(sp)
    80001386:	f822                	sd	s0,48(sp)
    80001388:	f426                	sd	s1,40(sp)
    8000138a:	f04a                	sd	s2,32(sp)
    8000138c:	ec4e                	sd	s3,24(sp)
    8000138e:	e852                	sd	s4,16(sp)
    80001390:	e456                	sd	s5,8(sp)
    80001392:	e05a                	sd	s6,0(sp)
    80001394:	0080                	addi	s0,sp,64
    80001396:	8792                	mv	a5,tp
  int id = r_tp();
    80001398:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000139a:	00779a93          	slli	s5,a5,0x7
    8000139e:	00008717          	auipc	a4,0x8
    800013a2:	cb270713          	addi	a4,a4,-846 # 80009050 <pid_lock>
    800013a6:	9756                	add	a4,a4,s5
    800013a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ac:	00008717          	auipc	a4,0x8
    800013b0:	cdc70713          	addi	a4,a4,-804 # 80009088 <cpus+0x8>
    800013b4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013b6:	498d                	li	s3,3
        p->state = RUNNING;
    800013b8:	4b11                	li	s6,4
        c->proc = p;
    800013ba:	079e                	slli	a5,a5,0x7
    800013bc:	00008a17          	auipc	s4,0x8
    800013c0:	c94a0a13          	addi	s4,s4,-876 # 80009050 <pid_lock>
    800013c4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013c6:	0000e917          	auipc	s2,0xe
    800013ca:	cba90913          	addi	s2,s2,-838 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013d6:	10079073          	csrw	sstatus,a5
    800013da:	00008497          	auipc	s1,0x8
    800013de:	0a648493          	addi	s1,s1,166 # 80009480 <proc>
    800013e2:	a03d                	j	80001410 <scheduler+0x8e>
        p->state = RUNNING;
    800013e4:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013e8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013ec:	06048593          	addi	a1,s1,96
    800013f0:	8556                	mv	a0,s5
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	670080e7          	jalr	1648(ra) # 80001a62 <swtch>
        c->proc = 0;
    800013fa:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	00005097          	auipc	ra,0x5
    80001404:	e56080e7          	jalr	-426(ra) # 80006256 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001408:	17048493          	addi	s1,s1,368
    8000140c:	fd2481e3          	beq	s1,s2,800013ce <scheduler+0x4c>
      acquire(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	00005097          	auipc	ra,0x5
    80001416:	d90080e7          	jalr	-624(ra) # 800061a2 <acquire>
      if(p->state == RUNNABLE) {
    8000141a:	4c9c                	lw	a5,24(s1)
    8000141c:	ff3791e3          	bne	a5,s3,800013fe <scheduler+0x7c>
    80001420:	b7d1                	j	800013e4 <scheduler+0x62>

0000000080001422 <sched>:
{
    80001422:	7179                	addi	sp,sp,-48
    80001424:	f406                	sd	ra,40(sp)
    80001426:	f022                	sd	s0,32(sp)
    80001428:	ec26                	sd	s1,24(sp)
    8000142a:	e84a                	sd	s2,16(sp)
    8000142c:	e44e                	sd	s3,8(sp)
    8000142e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001430:	00000097          	auipc	ra,0x0
    80001434:	a3c080e7          	jalr	-1476(ra) # 80000e6c <myproc>
    80001438:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000143a:	00005097          	auipc	ra,0x5
    8000143e:	cee080e7          	jalr	-786(ra) # 80006128 <holding>
    80001442:	c93d                	beqz	a0,800014b8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001444:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001446:	2781                	sext.w	a5,a5
    80001448:	079e                	slli	a5,a5,0x7
    8000144a:	00008717          	auipc	a4,0x8
    8000144e:	c0670713          	addi	a4,a4,-1018 # 80009050 <pid_lock>
    80001452:	97ba                	add	a5,a5,a4
    80001454:	0a87a703          	lw	a4,168(a5)
    80001458:	4785                	li	a5,1
    8000145a:	06f71763          	bne	a4,a5,800014c8 <sched+0xa6>
  if(p->state == RUNNING)
    8000145e:	4c98                	lw	a4,24(s1)
    80001460:	4791                	li	a5,4
    80001462:	06f70b63          	beq	a4,a5,800014d8 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001466:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000146a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000146c:	efb5                	bnez	a5,800014e8 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000146e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001470:	00008917          	auipc	s2,0x8
    80001474:	be090913          	addi	s2,s2,-1056 # 80009050 <pid_lock>
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	97ca                	add	a5,a5,s2
    8000147e:	0ac7a983          	lw	s3,172(a5)
    80001482:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001484:	2781                	sext.w	a5,a5
    80001486:	079e                	slli	a5,a5,0x7
    80001488:	00008597          	auipc	a1,0x8
    8000148c:	c0058593          	addi	a1,a1,-1024 # 80009088 <cpus+0x8>
    80001490:	95be                	add	a1,a1,a5
    80001492:	06048513          	addi	a0,s1,96
    80001496:	00000097          	auipc	ra,0x0
    8000149a:	5cc080e7          	jalr	1484(ra) # 80001a62 <swtch>
    8000149e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a0:	2781                	sext.w	a5,a5
    800014a2:	079e                	slli	a5,a5,0x7
    800014a4:	97ca                	add	a5,a5,s2
    800014a6:	0b37a623          	sw	s3,172(a5)
}
    800014aa:	70a2                	ld	ra,40(sp)
    800014ac:	7402                	ld	s0,32(sp)
    800014ae:	64e2                	ld	s1,24(sp)
    800014b0:	6942                	ld	s2,16(sp)
    800014b2:	69a2                	ld	s3,8(sp)
    800014b4:	6145                	addi	sp,sp,48
    800014b6:	8082                	ret
    panic("sched p->lock");
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	ce050513          	addi	a0,a0,-800 # 80008198 <etext+0x198>
    800014c0:	00004097          	auipc	ra,0x4
    800014c4:	798080e7          	jalr	1944(ra) # 80005c58 <panic>
    panic("sched locks");
    800014c8:	00007517          	auipc	a0,0x7
    800014cc:	ce050513          	addi	a0,a0,-800 # 800081a8 <etext+0x1a8>
    800014d0:	00004097          	auipc	ra,0x4
    800014d4:	788080e7          	jalr	1928(ra) # 80005c58 <panic>
    panic("sched running");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	ce050513          	addi	a0,a0,-800 # 800081b8 <etext+0x1b8>
    800014e0:	00004097          	auipc	ra,0x4
    800014e4:	778080e7          	jalr	1912(ra) # 80005c58 <panic>
    panic("sched interruptible");
    800014e8:	00007517          	auipc	a0,0x7
    800014ec:	ce050513          	addi	a0,a0,-800 # 800081c8 <etext+0x1c8>
    800014f0:	00004097          	auipc	ra,0x4
    800014f4:	768080e7          	jalr	1896(ra) # 80005c58 <panic>

00000000800014f8 <yield>:
{
    800014f8:	1101                	addi	sp,sp,-32
    800014fa:	ec06                	sd	ra,24(sp)
    800014fc:	e822                	sd	s0,16(sp)
    800014fe:	e426                	sd	s1,8(sp)
    80001500:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001502:	00000097          	auipc	ra,0x0
    80001506:	96a080e7          	jalr	-1686(ra) # 80000e6c <myproc>
    8000150a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	c96080e7          	jalr	-874(ra) # 800061a2 <acquire>
  p->state = RUNNABLE;
    80001514:	478d                	li	a5,3
    80001516:	cc9c                	sw	a5,24(s1)
  sched();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	f0a080e7          	jalr	-246(ra) # 80001422 <sched>
  release(&p->lock);
    80001520:	8526                	mv	a0,s1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	d34080e7          	jalr	-716(ra) # 80006256 <release>
}
    8000152a:	60e2                	ld	ra,24(sp)
    8000152c:	6442                	ld	s0,16(sp)
    8000152e:	64a2                	ld	s1,8(sp)
    80001530:	6105                	addi	sp,sp,32
    80001532:	8082                	ret

0000000080001534 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001534:	7179                	addi	sp,sp,-48
    80001536:	f406                	sd	ra,40(sp)
    80001538:	f022                	sd	s0,32(sp)
    8000153a:	ec26                	sd	s1,24(sp)
    8000153c:	e84a                	sd	s2,16(sp)
    8000153e:	e44e                	sd	s3,8(sp)
    80001540:	1800                	addi	s0,sp,48
    80001542:	89aa                	mv	s3,a0
    80001544:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001546:	00000097          	auipc	ra,0x0
    8000154a:	926080e7          	jalr	-1754(ra) # 80000e6c <myproc>
    8000154e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001550:	00005097          	auipc	ra,0x5
    80001554:	c52080e7          	jalr	-942(ra) # 800061a2 <acquire>
  release(lk);
    80001558:	854a                	mv	a0,s2
    8000155a:	00005097          	auipc	ra,0x5
    8000155e:	cfc080e7          	jalr	-772(ra) # 80006256 <release>

  // Go to sleep.
  p->chan = chan;
    80001562:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001566:	4789                	li	a5,2
    80001568:	cc9c                	sw	a5,24(s1)

  sched();
    8000156a:	00000097          	auipc	ra,0x0
    8000156e:	eb8080e7          	jalr	-328(ra) # 80001422 <sched>

  // Tidy up.
  p->chan = 0;
    80001572:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	cde080e7          	jalr	-802(ra) # 80006256 <release>
  acquire(lk);
    80001580:	854a                	mv	a0,s2
    80001582:	00005097          	auipc	ra,0x5
    80001586:	c20080e7          	jalr	-992(ra) # 800061a2 <acquire>
}
    8000158a:	70a2                	ld	ra,40(sp)
    8000158c:	7402                	ld	s0,32(sp)
    8000158e:	64e2                	ld	s1,24(sp)
    80001590:	6942                	ld	s2,16(sp)
    80001592:	69a2                	ld	s3,8(sp)
    80001594:	6145                	addi	sp,sp,48
    80001596:	8082                	ret

0000000080001598 <wait>:
{
    80001598:	715d                	addi	sp,sp,-80
    8000159a:	e486                	sd	ra,72(sp)
    8000159c:	e0a2                	sd	s0,64(sp)
    8000159e:	fc26                	sd	s1,56(sp)
    800015a0:	f84a                	sd	s2,48(sp)
    800015a2:	f44e                	sd	s3,40(sp)
    800015a4:	f052                	sd	s4,32(sp)
    800015a6:	ec56                	sd	s5,24(sp)
    800015a8:	e85a                	sd	s6,16(sp)
    800015aa:	e45e                	sd	s7,8(sp)
    800015ac:	e062                	sd	s8,0(sp)
    800015ae:	0880                	addi	s0,sp,80
    800015b0:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015b2:	00000097          	auipc	ra,0x0
    800015b6:	8ba080e7          	jalr	-1862(ra) # 80000e6c <myproc>
    800015ba:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015bc:	00008517          	auipc	a0,0x8
    800015c0:	aac50513          	addi	a0,a0,-1364 # 80009068 <wait_lock>
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	bde080e7          	jalr	-1058(ra) # 800061a2 <acquire>
    havekids = 0;
    800015cc:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015ce:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    800015d0:	0000e997          	auipc	s3,0xe
    800015d4:	ab098993          	addi	s3,s3,-1360 # 8000f080 <tickslock>
        havekids = 1;
    800015d8:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015da:	00008c17          	auipc	s8,0x8
    800015de:	a8ec0c13          	addi	s8,s8,-1394 # 80009068 <wait_lock>
    havekids = 0;
    800015e2:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800015e4:	00008497          	auipc	s1,0x8
    800015e8:	e9c48493          	addi	s1,s1,-356 # 80009480 <proc>
    800015ec:	a0bd                	j	8000165a <wait+0xc2>
          pid = np->pid;
    800015ee:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015f2:	000b0e63          	beqz	s6,8000160e <wait+0x76>
    800015f6:	4691                	li	a3,4
    800015f8:	02c48613          	addi	a2,s1,44
    800015fc:	85da                	mv	a1,s6
    800015fe:	05093503          	ld	a0,80(s2)
    80001602:	fffff097          	auipc	ra,0xfffff
    80001606:	52c080e7          	jalr	1324(ra) # 80000b2e <copyout>
    8000160a:	02054563          	bltz	a0,80001634 <wait+0x9c>
          freeproc(np);
    8000160e:	8526                	mv	a0,s1
    80001610:	00000097          	auipc	ra,0x0
    80001614:	a0e080e7          	jalr	-1522(ra) # 8000101e <freeproc>
          release(&np->lock);
    80001618:	8526                	mv	a0,s1
    8000161a:	00005097          	auipc	ra,0x5
    8000161e:	c3c080e7          	jalr	-964(ra) # 80006256 <release>
          release(&wait_lock);
    80001622:	00008517          	auipc	a0,0x8
    80001626:	a4650513          	addi	a0,a0,-1466 # 80009068 <wait_lock>
    8000162a:	00005097          	auipc	ra,0x5
    8000162e:	c2c080e7          	jalr	-980(ra) # 80006256 <release>
          return pid;
    80001632:	a09d                	j	80001698 <wait+0x100>
            release(&np->lock);
    80001634:	8526                	mv	a0,s1
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	c20080e7          	jalr	-992(ra) # 80006256 <release>
            release(&wait_lock);
    8000163e:	00008517          	auipc	a0,0x8
    80001642:	a2a50513          	addi	a0,a0,-1494 # 80009068 <wait_lock>
    80001646:	00005097          	auipc	ra,0x5
    8000164a:	c10080e7          	jalr	-1008(ra) # 80006256 <release>
            return -1;
    8000164e:	59fd                	li	s3,-1
    80001650:	a0a1                	j	80001698 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001652:	17048493          	addi	s1,s1,368
    80001656:	03348463          	beq	s1,s3,8000167e <wait+0xe6>
      if(np->parent == p){
    8000165a:	7c9c                	ld	a5,56(s1)
    8000165c:	ff279be3          	bne	a5,s2,80001652 <wait+0xba>
        acquire(&np->lock);
    80001660:	8526                	mv	a0,s1
    80001662:	00005097          	auipc	ra,0x5
    80001666:	b40080e7          	jalr	-1216(ra) # 800061a2 <acquire>
        if(np->state == ZOMBIE){
    8000166a:	4c9c                	lw	a5,24(s1)
    8000166c:	f94781e3          	beq	a5,s4,800015ee <wait+0x56>
        release(&np->lock);
    80001670:	8526                	mv	a0,s1
    80001672:	00005097          	auipc	ra,0x5
    80001676:	be4080e7          	jalr	-1052(ra) # 80006256 <release>
        havekids = 1;
    8000167a:	8756                	mv	a4,s5
    8000167c:	bfd9                	j	80001652 <wait+0xba>
    if(!havekids || p->killed){
    8000167e:	c701                	beqz	a4,80001686 <wait+0xee>
    80001680:	02892783          	lw	a5,40(s2)
    80001684:	c79d                	beqz	a5,800016b2 <wait+0x11a>
      release(&wait_lock);
    80001686:	00008517          	auipc	a0,0x8
    8000168a:	9e250513          	addi	a0,a0,-1566 # 80009068 <wait_lock>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	bc8080e7          	jalr	-1080(ra) # 80006256 <release>
      return -1;
    80001696:	59fd                	li	s3,-1
}
    80001698:	854e                	mv	a0,s3
    8000169a:	60a6                	ld	ra,72(sp)
    8000169c:	6406                	ld	s0,64(sp)
    8000169e:	74e2                	ld	s1,56(sp)
    800016a0:	7942                	ld	s2,48(sp)
    800016a2:	79a2                	ld	s3,40(sp)
    800016a4:	7a02                	ld	s4,32(sp)
    800016a6:	6ae2                	ld	s5,24(sp)
    800016a8:	6b42                	ld	s6,16(sp)
    800016aa:	6ba2                	ld	s7,8(sp)
    800016ac:	6c02                	ld	s8,0(sp)
    800016ae:	6161                	addi	sp,sp,80
    800016b0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b2:	85e2                	mv	a1,s8
    800016b4:	854a                	mv	a0,s2
    800016b6:	00000097          	auipc	ra,0x0
    800016ba:	e7e080e7          	jalr	-386(ra) # 80001534 <sleep>
    havekids = 0;
    800016be:	b715                	j	800015e2 <wait+0x4a>

00000000800016c0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c0:	7139                	addi	sp,sp,-64
    800016c2:	fc06                	sd	ra,56(sp)
    800016c4:	f822                	sd	s0,48(sp)
    800016c6:	f426                	sd	s1,40(sp)
    800016c8:	f04a                	sd	s2,32(sp)
    800016ca:	ec4e                	sd	s3,24(sp)
    800016cc:	e852                	sd	s4,16(sp)
    800016ce:	e456                	sd	s5,8(sp)
    800016d0:	0080                	addi	s0,sp,64
    800016d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016d4:	00008497          	auipc	s1,0x8
    800016d8:	dac48493          	addi	s1,s1,-596 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016de:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e0:	0000e917          	auipc	s2,0xe
    800016e4:	9a090913          	addi	s2,s2,-1632 # 8000f080 <tickslock>
    800016e8:	a821                	j	80001700 <wakeup+0x40>
        p->state = RUNNABLE;
    800016ea:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	b66080e7          	jalr	-1178(ra) # 80006256 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f8:	17048493          	addi	s1,s1,368
    800016fc:	03248463          	beq	s1,s2,80001724 <wakeup+0x64>
    if(p != myproc()){
    80001700:	fffff097          	auipc	ra,0xfffff
    80001704:	76c080e7          	jalr	1900(ra) # 80000e6c <myproc>
    80001708:	fea488e3          	beq	s1,a0,800016f8 <wakeup+0x38>
      acquire(&p->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	a94080e7          	jalr	-1388(ra) # 800061a2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001716:	4c9c                	lw	a5,24(s1)
    80001718:	fd379be3          	bne	a5,s3,800016ee <wakeup+0x2e>
    8000171c:	709c                	ld	a5,32(s1)
    8000171e:	fd4798e3          	bne	a5,s4,800016ee <wakeup+0x2e>
    80001722:	b7e1                	j	800016ea <wakeup+0x2a>
    }
  }
}
    80001724:	70e2                	ld	ra,56(sp)
    80001726:	7442                	ld	s0,48(sp)
    80001728:	74a2                	ld	s1,40(sp)
    8000172a:	7902                	ld	s2,32(sp)
    8000172c:	69e2                	ld	s3,24(sp)
    8000172e:	6a42                	ld	s4,16(sp)
    80001730:	6aa2                	ld	s5,8(sp)
    80001732:	6121                	addi	sp,sp,64
    80001734:	8082                	ret

0000000080001736 <reparent>:
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	e052                	sd	s4,0(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001748:	00008497          	auipc	s1,0x8
    8000174c:	d3848493          	addi	s1,s1,-712 # 80009480 <proc>
      pp->parent = initproc;
    80001750:	00008a17          	auipc	s4,0x8
    80001754:	8c0a0a13          	addi	s4,s4,-1856 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001758:	0000e997          	auipc	s3,0xe
    8000175c:	92898993          	addi	s3,s3,-1752 # 8000f080 <tickslock>
    80001760:	a029                	j	8000176a <reparent+0x34>
    80001762:	17048493          	addi	s1,s1,368
    80001766:	01348d63          	beq	s1,s3,80001780 <reparent+0x4a>
    if(pp->parent == p){
    8000176a:	7c9c                	ld	a5,56(s1)
    8000176c:	ff279be3          	bne	a5,s2,80001762 <reparent+0x2c>
      pp->parent = initproc;
    80001770:	000a3503          	ld	a0,0(s4)
    80001774:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	f4a080e7          	jalr	-182(ra) # 800016c0 <wakeup>
    8000177e:	b7d5                	j	80001762 <reparent+0x2c>
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret

0000000080001790 <exit>:
{
    80001790:	7179                	addi	sp,sp,-48
    80001792:	f406                	sd	ra,40(sp)
    80001794:	f022                	sd	s0,32(sp)
    80001796:	ec26                	sd	s1,24(sp)
    80001798:	e84a                	sd	s2,16(sp)
    8000179a:	e44e                	sd	s3,8(sp)
    8000179c:	e052                	sd	s4,0(sp)
    8000179e:	1800                	addi	s0,sp,48
    800017a0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	6ca080e7          	jalr	1738(ra) # 80000e6c <myproc>
    800017aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800017ac:	00008797          	auipc	a5,0x8
    800017b0:	8647b783          	ld	a5,-1948(a5) # 80009010 <initproc>
    800017b4:	0d050493          	addi	s1,a0,208
    800017b8:	15050913          	addi	s2,a0,336
    800017bc:	02a79363          	bne	a5,a0,800017e2 <exit+0x52>
    panic("init exiting");
    800017c0:	00007517          	auipc	a0,0x7
    800017c4:	a2050513          	addi	a0,a0,-1504 # 800081e0 <etext+0x1e0>
    800017c8:	00004097          	auipc	ra,0x4
    800017cc:	490080e7          	jalr	1168(ra) # 80005c58 <panic>
      fileclose(f);
    800017d0:	00002097          	auipc	ra,0x2
    800017d4:	272080e7          	jalr	626(ra) # 80003a42 <fileclose>
      p->ofile[fd] = 0;
    800017d8:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017dc:	04a1                	addi	s1,s1,8
    800017de:	01248563          	beq	s1,s2,800017e8 <exit+0x58>
    if(p->ofile[fd]){
    800017e2:	6088                	ld	a0,0(s1)
    800017e4:	f575                	bnez	a0,800017d0 <exit+0x40>
    800017e6:	bfdd                	j	800017dc <exit+0x4c>
  begin_op();
    800017e8:	00002097          	auipc	ra,0x2
    800017ec:	d8e080e7          	jalr	-626(ra) # 80003576 <begin_op>
  iput(p->cwd);
    800017f0:	1509b503          	ld	a0,336(s3)
    800017f4:	00001097          	auipc	ra,0x1
    800017f8:	56a080e7          	jalr	1386(ra) # 80002d5e <iput>
  end_op();
    800017fc:	00002097          	auipc	ra,0x2
    80001800:	dfa080e7          	jalr	-518(ra) # 800035f6 <end_op>
  p->cwd = 0;
    80001804:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001808:	00008497          	auipc	s1,0x8
    8000180c:	86048493          	addi	s1,s1,-1952 # 80009068 <wait_lock>
    80001810:	8526                	mv	a0,s1
    80001812:	00005097          	auipc	ra,0x5
    80001816:	990080e7          	jalr	-1648(ra) # 800061a2 <acquire>
  reparent(p);
    8000181a:	854e                	mv	a0,s3
    8000181c:	00000097          	auipc	ra,0x0
    80001820:	f1a080e7          	jalr	-230(ra) # 80001736 <reparent>
  wakeup(p->parent);
    80001824:	0389b503          	ld	a0,56(s3)
    80001828:	00000097          	auipc	ra,0x0
    8000182c:	e98080e7          	jalr	-360(ra) # 800016c0 <wakeup>
  acquire(&p->lock);
    80001830:	854e                	mv	a0,s3
    80001832:	00005097          	auipc	ra,0x5
    80001836:	970080e7          	jalr	-1680(ra) # 800061a2 <acquire>
  p->xstate = status;
    8000183a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000183e:	4795                	li	a5,5
    80001840:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001844:	8526                	mv	a0,s1
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	a10080e7          	jalr	-1520(ra) # 80006256 <release>
  sched();
    8000184e:	00000097          	auipc	ra,0x0
    80001852:	bd4080e7          	jalr	-1068(ra) # 80001422 <sched>
  panic("zombie exit");
    80001856:	00007517          	auipc	a0,0x7
    8000185a:	99a50513          	addi	a0,a0,-1638 # 800081f0 <etext+0x1f0>
    8000185e:	00004097          	auipc	ra,0x4
    80001862:	3fa080e7          	jalr	1018(ra) # 80005c58 <panic>

0000000080001866 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001866:	7179                	addi	sp,sp,-48
    80001868:	f406                	sd	ra,40(sp)
    8000186a:	f022                	sd	s0,32(sp)
    8000186c:	ec26                	sd	s1,24(sp)
    8000186e:	e84a                	sd	s2,16(sp)
    80001870:	e44e                	sd	s3,8(sp)
    80001872:	1800                	addi	s0,sp,48
    80001874:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001876:	00008497          	auipc	s1,0x8
    8000187a:	c0a48493          	addi	s1,s1,-1014 # 80009480 <proc>
    8000187e:	0000e997          	auipc	s3,0xe
    80001882:	80298993          	addi	s3,s3,-2046 # 8000f080 <tickslock>
    acquire(&p->lock);
    80001886:	8526                	mv	a0,s1
    80001888:	00005097          	auipc	ra,0x5
    8000188c:	91a080e7          	jalr	-1766(ra) # 800061a2 <acquire>
    if(p->pid == pid){
    80001890:	589c                	lw	a5,48(s1)
    80001892:	01278d63          	beq	a5,s2,800018ac <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001896:	8526                	mv	a0,s1
    80001898:	00005097          	auipc	ra,0x5
    8000189c:	9be080e7          	jalr	-1602(ra) # 80006256 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a0:	17048493          	addi	s1,s1,368
    800018a4:	ff3491e3          	bne	s1,s3,80001886 <kill+0x20>
  }
  return -1;
    800018a8:	557d                	li	a0,-1
    800018aa:	a829                	j	800018c4 <kill+0x5e>
      p->killed = 1;
    800018ac:	4785                	li	a5,1
    800018ae:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018b0:	4c98                	lw	a4,24(s1)
    800018b2:	4789                	li	a5,2
    800018b4:	00f70f63          	beq	a4,a5,800018d2 <kill+0x6c>
      release(&p->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	99c080e7          	jalr	-1636(ra) # 80006256 <release>
      return 0;
    800018c2:	4501                	li	a0,0
}
    800018c4:	70a2                	ld	ra,40(sp)
    800018c6:	7402                	ld	s0,32(sp)
    800018c8:	64e2                	ld	s1,24(sp)
    800018ca:	6942                	ld	s2,16(sp)
    800018cc:	69a2                	ld	s3,8(sp)
    800018ce:	6145                	addi	sp,sp,48
    800018d0:	8082                	ret
        p->state = RUNNABLE;
    800018d2:	478d                	li	a5,3
    800018d4:	cc9c                	sw	a5,24(s1)
    800018d6:	b7cd                	j	800018b8 <kill+0x52>

00000000800018d8 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018d8:	7179                	addi	sp,sp,-48
    800018da:	f406                	sd	ra,40(sp)
    800018dc:	f022                	sd	s0,32(sp)
    800018de:	ec26                	sd	s1,24(sp)
    800018e0:	e84a                	sd	s2,16(sp)
    800018e2:	e44e                	sd	s3,8(sp)
    800018e4:	e052                	sd	s4,0(sp)
    800018e6:	1800                	addi	s0,sp,48
    800018e8:	84aa                	mv	s1,a0
    800018ea:	892e                	mv	s2,a1
    800018ec:	89b2                	mv	s3,a2
    800018ee:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	57c080e7          	jalr	1404(ra) # 80000e6c <myproc>
  if(user_dst){
    800018f8:	c08d                	beqz	s1,8000191a <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800018fa:	86d2                	mv	a3,s4
    800018fc:	864e                	mv	a2,s3
    800018fe:	85ca                	mv	a1,s2
    80001900:	6928                	ld	a0,80(a0)
    80001902:	fffff097          	auipc	ra,0xfffff
    80001906:	22c080e7          	jalr	556(ra) # 80000b2e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000190a:	70a2                	ld	ra,40(sp)
    8000190c:	7402                	ld	s0,32(sp)
    8000190e:	64e2                	ld	s1,24(sp)
    80001910:	6942                	ld	s2,16(sp)
    80001912:	69a2                	ld	s3,8(sp)
    80001914:	6a02                	ld	s4,0(sp)
    80001916:	6145                	addi	sp,sp,48
    80001918:	8082                	ret
    memmove((char *)dst, src, len);
    8000191a:	000a061b          	sext.w	a2,s4
    8000191e:	85ce                	mv	a1,s3
    80001920:	854a                	mv	a0,s2
    80001922:	fffff097          	auipc	ra,0xfffff
    80001926:	8da080e7          	jalr	-1830(ra) # 800001fc <memmove>
    return 0;
    8000192a:	8526                	mv	a0,s1
    8000192c:	bff9                	j	8000190a <either_copyout+0x32>

000000008000192e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000192e:	7179                	addi	sp,sp,-48
    80001930:	f406                	sd	ra,40(sp)
    80001932:	f022                	sd	s0,32(sp)
    80001934:	ec26                	sd	s1,24(sp)
    80001936:	e84a                	sd	s2,16(sp)
    80001938:	e44e                	sd	s3,8(sp)
    8000193a:	e052                	sd	s4,0(sp)
    8000193c:	1800                	addi	s0,sp,48
    8000193e:	892a                	mv	s2,a0
    80001940:	84ae                	mv	s1,a1
    80001942:	89b2                	mv	s3,a2
    80001944:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	526080e7          	jalr	1318(ra) # 80000e6c <myproc>
  if(user_src){
    8000194e:	c08d                	beqz	s1,80001970 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001950:	86d2                	mv	a3,s4
    80001952:	864e                	mv	a2,s3
    80001954:	85ca                	mv	a1,s2
    80001956:	6928                	ld	a0,80(a0)
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	262080e7          	jalr	610(ra) # 80000bba <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001960:	70a2                	ld	ra,40(sp)
    80001962:	7402                	ld	s0,32(sp)
    80001964:	64e2                	ld	s1,24(sp)
    80001966:	6942                	ld	s2,16(sp)
    80001968:	69a2                	ld	s3,8(sp)
    8000196a:	6a02                	ld	s4,0(sp)
    8000196c:	6145                	addi	sp,sp,48
    8000196e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001970:	000a061b          	sext.w	a2,s4
    80001974:	85ce                	mv	a1,s3
    80001976:	854a                	mv	a0,s2
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	884080e7          	jalr	-1916(ra) # 800001fc <memmove>
    return 0;
    80001980:	8526                	mv	a0,s1
    80001982:	bff9                	j	80001960 <either_copyin+0x32>

0000000080001984 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001984:	715d                	addi	sp,sp,-80
    80001986:	e486                	sd	ra,72(sp)
    80001988:	e0a2                	sd	s0,64(sp)
    8000198a:	fc26                	sd	s1,56(sp)
    8000198c:	f84a                	sd	s2,48(sp)
    8000198e:	f44e                	sd	s3,40(sp)
    80001990:	f052                	sd	s4,32(sp)
    80001992:	ec56                	sd	s5,24(sp)
    80001994:	e85a                	sd	s6,16(sp)
    80001996:	e45e                	sd	s7,8(sp)
    80001998:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000199a:	00006517          	auipc	a0,0x6
    8000199e:	6ae50513          	addi	a0,a0,1710 # 80008048 <etext+0x48>
    800019a2:	00004097          	auipc	ra,0x4
    800019a6:	300080e7          	jalr	768(ra) # 80005ca2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019aa:	00008497          	auipc	s1,0x8
    800019ae:	c2e48493          	addi	s1,s1,-978 # 800095d8 <proc+0x158>
    800019b2:	0000e917          	auipc	s2,0xe
    800019b6:	82690913          	addi	s2,s2,-2010 # 8000f1d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019bc:	00007997          	auipc	s3,0x7
    800019c0:	84498993          	addi	s3,s3,-1980 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019c4:	00007a97          	auipc	s5,0x7
    800019c8:	844a8a93          	addi	s5,s5,-1980 # 80008208 <etext+0x208>
    printf("\n");
    800019cc:	00006a17          	auipc	s4,0x6
    800019d0:	67ca0a13          	addi	s4,s4,1660 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d4:	00007b97          	auipc	s7,0x7
    800019d8:	86cb8b93          	addi	s7,s7,-1940 # 80008240 <states.1714>
    800019dc:	a00d                	j	800019fe <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019de:	ed86a583          	lw	a1,-296(a3)
    800019e2:	8556                	mv	a0,s5
    800019e4:	00004097          	auipc	ra,0x4
    800019e8:	2be080e7          	jalr	702(ra) # 80005ca2 <printf>
    printf("\n");
    800019ec:	8552                	mv	a0,s4
    800019ee:	00004097          	auipc	ra,0x4
    800019f2:	2b4080e7          	jalr	692(ra) # 80005ca2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019f6:	17048493          	addi	s1,s1,368
    800019fa:	03248163          	beq	s1,s2,80001a1c <procdump+0x98>
    if(p->state == UNUSED)
    800019fe:	86a6                	mv	a3,s1
    80001a00:	ec04a783          	lw	a5,-320(s1)
    80001a04:	dbed                	beqz	a5,800019f6 <procdump+0x72>
      state = "???";
    80001a06:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a08:	fcfb6be3          	bltu	s6,a5,800019de <procdump+0x5a>
    80001a0c:	1782                	slli	a5,a5,0x20
    80001a0e:	9381                	srli	a5,a5,0x20
    80001a10:	078e                	slli	a5,a5,0x3
    80001a12:	97de                	add	a5,a5,s7
    80001a14:	6390                	ld	a2,0(a5)
    80001a16:	f661                	bnez	a2,800019de <procdump+0x5a>
      state = "???";
    80001a18:	864e                	mv	a2,s3
    80001a1a:	b7d1                	j	800019de <procdump+0x5a>
  }
}
    80001a1c:	60a6                	ld	ra,72(sp)
    80001a1e:	6406                	ld	s0,64(sp)
    80001a20:	74e2                	ld	s1,56(sp)
    80001a22:	7942                	ld	s2,48(sp)
    80001a24:	79a2                	ld	s3,40(sp)
    80001a26:	7a02                	ld	s4,32(sp)
    80001a28:	6ae2                	ld	s5,24(sp)
    80001a2a:	6b42                	ld	s6,16(sp)
    80001a2c:	6ba2                	ld	s7,8(sp)
    80001a2e:	6161                	addi	sp,sp,80
    80001a30:	8082                	ret

0000000080001a32 <numproc>:

int
numproc(void)
{
    80001a32:	1141                	addi	sp,sp,-16
    80001a34:	e422                	sd	s0,8(sp)
    80001a36:	0800                	addi	s0,sp,16
  int i;
  int num = 0;
  for (i=0; i<NPROC; i++) {
    80001a38:	00008797          	auipc	a5,0x8
    80001a3c:	a6078793          	addi	a5,a5,-1440 # 80009498 <proc+0x18>
    80001a40:	0000d697          	auipc	a3,0xd
    80001a44:	65868693          	addi	a3,a3,1624 # 8000f098 <bcache>
  int num = 0;
    80001a48:	4501                	li	a0,0
    80001a4a:	a029                	j	80001a54 <numproc+0x22>
  for (i=0; i<NPROC; i++) {
    80001a4c:	17078793          	addi	a5,a5,368
    80001a50:	00d78663          	beq	a5,a3,80001a5c <numproc+0x2a>
    if (proc[i].state != UNUSED)
    80001a54:	4398                	lw	a4,0(a5)
    80001a56:	db7d                	beqz	a4,80001a4c <numproc+0x1a>
      num++;
    80001a58:	2505                	addiw	a0,a0,1
    80001a5a:	bfcd                	j	80001a4c <numproc+0x1a>
  }
  return num;
    80001a5c:	6422                	ld	s0,8(sp)
    80001a5e:	0141                	addi	sp,sp,16
    80001a60:	8082                	ret

0000000080001a62 <swtch>:
    80001a62:	00153023          	sd	ra,0(a0)
    80001a66:	00253423          	sd	sp,8(a0)
    80001a6a:	e900                	sd	s0,16(a0)
    80001a6c:	ed04                	sd	s1,24(a0)
    80001a6e:	03253023          	sd	s2,32(a0)
    80001a72:	03353423          	sd	s3,40(a0)
    80001a76:	03453823          	sd	s4,48(a0)
    80001a7a:	03553c23          	sd	s5,56(a0)
    80001a7e:	05653023          	sd	s6,64(a0)
    80001a82:	05753423          	sd	s7,72(a0)
    80001a86:	05853823          	sd	s8,80(a0)
    80001a8a:	05953c23          	sd	s9,88(a0)
    80001a8e:	07a53023          	sd	s10,96(a0)
    80001a92:	07b53423          	sd	s11,104(a0)
    80001a96:	0005b083          	ld	ra,0(a1)
    80001a9a:	0085b103          	ld	sp,8(a1)
    80001a9e:	6980                	ld	s0,16(a1)
    80001aa0:	6d84                	ld	s1,24(a1)
    80001aa2:	0205b903          	ld	s2,32(a1)
    80001aa6:	0285b983          	ld	s3,40(a1)
    80001aaa:	0305ba03          	ld	s4,48(a1)
    80001aae:	0385ba83          	ld	s5,56(a1)
    80001ab2:	0405bb03          	ld	s6,64(a1)
    80001ab6:	0485bb83          	ld	s7,72(a1)
    80001aba:	0505bc03          	ld	s8,80(a1)
    80001abe:	0585bc83          	ld	s9,88(a1)
    80001ac2:	0605bd03          	ld	s10,96(a1)
    80001ac6:	0685bd83          	ld	s11,104(a1)
    80001aca:	8082                	ret

0000000080001acc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001acc:	1141                	addi	sp,sp,-16
    80001ace:	e406                	sd	ra,8(sp)
    80001ad0:	e022                	sd	s0,0(sp)
    80001ad2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ad4:	00006597          	auipc	a1,0x6
    80001ad8:	79c58593          	addi	a1,a1,1948 # 80008270 <states.1714+0x30>
    80001adc:	0000d517          	auipc	a0,0xd
    80001ae0:	5a450513          	addi	a0,a0,1444 # 8000f080 <tickslock>
    80001ae4:	00004097          	auipc	ra,0x4
    80001ae8:	62e080e7          	jalr	1582(ra) # 80006112 <initlock>
}
    80001aec:	60a2                	ld	ra,8(sp)
    80001aee:	6402                	ld	s0,0(sp)
    80001af0:	0141                	addi	sp,sp,16
    80001af2:	8082                	ret

0000000080001af4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001af4:	1141                	addi	sp,sp,-16
    80001af6:	e422                	sd	s0,8(sp)
    80001af8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001afa:	00003797          	auipc	a5,0x3
    80001afe:	56678793          	addi	a5,a5,1382 # 80005060 <kernelvec>
    80001b02:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b06:	6422                	ld	s0,8(sp)
    80001b08:	0141                	addi	sp,sp,16
    80001b0a:	8082                	ret

0000000080001b0c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b0c:	1141                	addi	sp,sp,-16
    80001b0e:	e406                	sd	ra,8(sp)
    80001b10:	e022                	sd	s0,0(sp)
    80001b12:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b14:	fffff097          	auipc	ra,0xfffff
    80001b18:	358080e7          	jalr	856(ra) # 80000e6c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b20:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b22:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b26:	00005617          	auipc	a2,0x5
    80001b2a:	4da60613          	addi	a2,a2,1242 # 80007000 <_trampoline>
    80001b2e:	00005697          	auipc	a3,0x5
    80001b32:	4d268693          	addi	a3,a3,1234 # 80007000 <_trampoline>
    80001b36:	8e91                	sub	a3,a3,a2
    80001b38:	040007b7          	lui	a5,0x4000
    80001b3c:	17fd                	addi	a5,a5,-1
    80001b3e:	07b2                	slli	a5,a5,0xc
    80001b40:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b42:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b46:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b48:	180026f3          	csrr	a3,satp
    80001b4c:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b4e:	6d38                	ld	a4,88(a0)
    80001b50:	6134                	ld	a3,64(a0)
    80001b52:	6585                	lui	a1,0x1
    80001b54:	96ae                	add	a3,a3,a1
    80001b56:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b58:	6d38                	ld	a4,88(a0)
    80001b5a:	00000697          	auipc	a3,0x0
    80001b5e:	13868693          	addi	a3,a3,312 # 80001c92 <usertrap>
    80001b62:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b64:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b66:	8692                	mv	a3,tp
    80001b68:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6a:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b6e:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b72:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b76:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b7a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b7c:	6f18                	ld	a4,24(a4)
    80001b7e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b82:	692c                	ld	a1,80(a0)
    80001b84:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b86:	00005717          	auipc	a4,0x5
    80001b8a:	50a70713          	addi	a4,a4,1290 # 80007090 <userret>
    80001b8e:	8f11                	sub	a4,a4,a2
    80001b90:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b92:	577d                	li	a4,-1
    80001b94:	177e                	slli	a4,a4,0x3f
    80001b96:	8dd9                	or	a1,a1,a4
    80001b98:	02000537          	lui	a0,0x2000
    80001b9c:	157d                	addi	a0,a0,-1
    80001b9e:	0536                	slli	a0,a0,0xd
    80001ba0:	9782                	jalr	a5
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001baa:	1101                	addi	sp,sp,-32
    80001bac:	ec06                	sd	ra,24(sp)
    80001bae:	e822                	sd	s0,16(sp)
    80001bb0:	e426                	sd	s1,8(sp)
    80001bb2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb4:	0000d497          	auipc	s1,0xd
    80001bb8:	4cc48493          	addi	s1,s1,1228 # 8000f080 <tickslock>
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	5e4080e7          	jalr	1508(ra) # 800061a2 <acquire>
  ticks++;
    80001bc6:	00007517          	auipc	a0,0x7
    80001bca:	45250513          	addi	a0,a0,1106 # 80009018 <ticks>
    80001bce:	411c                	lw	a5,0(a0)
    80001bd0:	2785                	addiw	a5,a5,1
    80001bd2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	aec080e7          	jalr	-1300(ra) # 800016c0 <wakeup>
  release(&tickslock);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00004097          	auipc	ra,0x4
    80001be2:	678080e7          	jalr	1656(ra) # 80006256 <release>
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6105                	addi	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bfa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfe:	00074d63          	bltz	a4,80001c18 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c02:	57fd                	li	a5,-1
    80001c04:	17fe                	slli	a5,a5,0x3f
    80001c06:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0a:	06f70363          	beq	a4,a5,80001c70 <devintr+0x80>
  }
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret
     (scause & 0xff) == 9){
    80001c18:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c1c:	46a5                	li	a3,9
    80001c1e:	fed792e3          	bne	a5,a3,80001c02 <devintr+0x12>
    int irq = plic_claim();
    80001c22:	00003097          	auipc	ra,0x3
    80001c26:	546080e7          	jalr	1350(ra) # 80005168 <plic_claim>
    80001c2a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2c:	47a9                	li	a5,10
    80001c2e:	02f50763          	beq	a0,a5,80001c5c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c32:	4785                	li	a5,1
    80001c34:	02f50963          	beq	a0,a5,80001c66 <devintr+0x76>
    return 1;
    80001c38:	4505                	li	a0,1
    } else if(irq){
    80001c3a:	d8f1                	beqz	s1,80001c0e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3c:	85a6                	mv	a1,s1
    80001c3e:	00006517          	auipc	a0,0x6
    80001c42:	63a50513          	addi	a0,a0,1594 # 80008278 <states.1714+0x38>
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	05c080e7          	jalr	92(ra) # 80005ca2 <printf>
      plic_complete(irq);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	53c080e7          	jalr	1340(ra) # 8000518c <plic_complete>
    return 1;
    80001c58:	4505                	li	a0,1
    80001c5a:	bf55                	j	80001c0e <devintr+0x1e>
      uartintr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	466080e7          	jalr	1126(ra) # 800060c2 <uartintr>
    80001c64:	b7ed                	j	80001c4e <devintr+0x5e>
      virtio_disk_intr();
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	a06080e7          	jalr	-1530(ra) # 8000566c <virtio_disk_intr>
    80001c6e:	b7c5                	j	80001c4e <devintr+0x5e>
    if(cpuid() == 0){
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	1d0080e7          	jalr	464(ra) # 80000e40 <cpuid>
    80001c78:	c901                	beqz	a0,80001c88 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c7a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c80:	14479073          	csrw	sip,a5
    return 2;
    80001c84:	4509                	li	a0,2
    80001c86:	b761                	j	80001c0e <devintr+0x1e>
      clockintr();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	f22080e7          	jalr	-222(ra) # 80001baa <clockintr>
    80001c90:	b7ed                	j	80001c7a <devintr+0x8a>

0000000080001c92 <usertrap>:
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	e04a                	sd	s2,0(sp)
    80001c9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca2:	1007f793          	andi	a5,a5,256
    80001ca6:	e3ad                	bnez	a5,80001d08 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca8:	00003797          	auipc	a5,0x3
    80001cac:	3b878793          	addi	a5,a5,952 # 80005060 <kernelvec>
    80001cb0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	1b8080e7          	jalr	440(ra) # 80000e6c <myproc>
    80001cbc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cbe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc0:	14102773          	csrr	a4,sepc
    80001cc4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cca:	47a1                	li	a5,8
    80001ccc:	04f71c63          	bne	a4,a5,80001d24 <usertrap+0x92>
    if(p->killed)
    80001cd0:	551c                	lw	a5,40(a0)
    80001cd2:	e3b9                	bnez	a5,80001d18 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cd4:	6cb8                	ld	a4,88(s1)
    80001cd6:	6f1c                	ld	a5,24(a4)
    80001cd8:	0791                	addi	a5,a5,4
    80001cda:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cdc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ce0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10079073          	csrw	sstatus,a5
    syscall();
    80001ce8:	00000097          	auipc	ra,0x0
    80001cec:	2e0080e7          	jalr	736(ra) # 80001fc8 <syscall>
  if(p->killed)
    80001cf0:	549c                	lw	a5,40(s1)
    80001cf2:	ebc1                	bnez	a5,80001d82 <usertrap+0xf0>
  usertrapret();
    80001cf4:	00000097          	auipc	ra,0x0
    80001cf8:	e18080e7          	jalr	-488(ra) # 80001b0c <usertrapret>
}
    80001cfc:	60e2                	ld	ra,24(sp)
    80001cfe:	6442                	ld	s0,16(sp)
    80001d00:	64a2                	ld	s1,8(sp)
    80001d02:	6902                	ld	s2,0(sp)
    80001d04:	6105                	addi	sp,sp,32
    80001d06:	8082                	ret
    panic("usertrap: not from user mode");
    80001d08:	00006517          	auipc	a0,0x6
    80001d0c:	59050513          	addi	a0,a0,1424 # 80008298 <states.1714+0x58>
    80001d10:	00004097          	auipc	ra,0x4
    80001d14:	f48080e7          	jalr	-184(ra) # 80005c58 <panic>
      exit(-1);
    80001d18:	557d                	li	a0,-1
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	a76080e7          	jalr	-1418(ra) # 80001790 <exit>
    80001d22:	bf4d                	j	80001cd4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d24:	00000097          	auipc	ra,0x0
    80001d28:	ecc080e7          	jalr	-308(ra) # 80001bf0 <devintr>
    80001d2c:	892a                	mv	s2,a0
    80001d2e:	c501                	beqz	a0,80001d36 <usertrap+0xa4>
  if(p->killed)
    80001d30:	549c                	lw	a5,40(s1)
    80001d32:	c3a1                	beqz	a5,80001d72 <usertrap+0xe0>
    80001d34:	a815                	j	80001d68 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d36:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d3a:	5890                	lw	a2,48(s1)
    80001d3c:	00006517          	auipc	a0,0x6
    80001d40:	57c50513          	addi	a0,a0,1404 # 800082b8 <states.1714+0x78>
    80001d44:	00004097          	auipc	ra,0x4
    80001d48:	f5e080e7          	jalr	-162(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d4c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d50:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	59450513          	addi	a0,a0,1428 # 800082e8 <states.1714+0xa8>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	f46080e7          	jalr	-186(ra) # 80005ca2 <printf>
    p->killed = 1;
    80001d64:	4785                	li	a5,1
    80001d66:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d68:	557d                	li	a0,-1
    80001d6a:	00000097          	auipc	ra,0x0
    80001d6e:	a26080e7          	jalr	-1498(ra) # 80001790 <exit>
  if(which_dev == 2)
    80001d72:	4789                	li	a5,2
    80001d74:	f8f910e3          	bne	s2,a5,80001cf4 <usertrap+0x62>
    yield();
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	780080e7          	jalr	1920(ra) # 800014f8 <yield>
    80001d80:	bf95                	j	80001cf4 <usertrap+0x62>
  int which_dev = 0;
    80001d82:	4901                	li	s2,0
    80001d84:	b7d5                	j	80001d68 <usertrap+0xd6>

0000000080001d86 <kerneltrap>:
{
    80001d86:	7179                	addi	sp,sp,-48
    80001d88:	f406                	sd	ra,40(sp)
    80001d8a:	f022                	sd	s0,32(sp)
    80001d8c:	ec26                	sd	s1,24(sp)
    80001d8e:	e84a                	sd	s2,16(sp)
    80001d90:	e44e                	sd	s3,8(sp)
    80001d92:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d94:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d98:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001da0:	1004f793          	andi	a5,s1,256
    80001da4:	cb85                	beqz	a5,80001dd4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001da6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001daa:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001dac:	ef85                	bnez	a5,80001de4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	e42080e7          	jalr	-446(ra) # 80001bf0 <devintr>
    80001db6:	cd1d                	beqz	a0,80001df4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001db8:	4789                	li	a5,2
    80001dba:	06f50a63          	beq	a0,a5,80001e2e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dbe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001dc2:	10049073          	csrw	sstatus,s1
}
    80001dc6:	70a2                	ld	ra,40(sp)
    80001dc8:	7402                	ld	s0,32(sp)
    80001dca:	64e2                	ld	s1,24(sp)
    80001dcc:	6942                	ld	s2,16(sp)
    80001dce:	69a2                	ld	s3,8(sp)
    80001dd0:	6145                	addi	sp,sp,48
    80001dd2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	53450513          	addi	a0,a0,1332 # 80008308 <states.1714+0xc8>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	e7c080e7          	jalr	-388(ra) # 80005c58 <panic>
    panic("kerneltrap: interrupts enabled");
    80001de4:	00006517          	auipc	a0,0x6
    80001de8:	54c50513          	addi	a0,a0,1356 # 80008330 <states.1714+0xf0>
    80001dec:	00004097          	auipc	ra,0x4
    80001df0:	e6c080e7          	jalr	-404(ra) # 80005c58 <panic>
    printf("scause %p\n", scause);
    80001df4:	85ce                	mv	a1,s3
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	55a50513          	addi	a0,a0,1370 # 80008350 <states.1714+0x110>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	ea4080e7          	jalr	-348(ra) # 80005ca2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e06:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e0a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	55250513          	addi	a0,a0,1362 # 80008360 <states.1714+0x120>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	e8c080e7          	jalr	-372(ra) # 80005ca2 <printf>
    panic("kerneltrap");
    80001e1e:	00006517          	auipc	a0,0x6
    80001e22:	55a50513          	addi	a0,a0,1370 # 80008378 <states.1714+0x138>
    80001e26:	00004097          	auipc	ra,0x4
    80001e2a:	e32080e7          	jalr	-462(ra) # 80005c58 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e2e:	fffff097          	auipc	ra,0xfffff
    80001e32:	03e080e7          	jalr	62(ra) # 80000e6c <myproc>
    80001e36:	d541                	beqz	a0,80001dbe <kerneltrap+0x38>
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	034080e7          	jalr	52(ra) # 80000e6c <myproc>
    80001e40:	4d18                	lw	a4,24(a0)
    80001e42:	4791                	li	a5,4
    80001e44:	f6f71de3          	bne	a4,a5,80001dbe <kerneltrap+0x38>
    yield();
    80001e48:	fffff097          	auipc	ra,0xfffff
    80001e4c:	6b0080e7          	jalr	1712(ra) # 800014f8 <yield>
    80001e50:	b7bd                	j	80001dbe <kerneltrap+0x38>

0000000080001e52 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e52:	1101                	addi	sp,sp,-32
    80001e54:	ec06                	sd	ra,24(sp)
    80001e56:	e822                	sd	s0,16(sp)
    80001e58:	e426                	sd	s1,8(sp)
    80001e5a:	1000                	addi	s0,sp,32
    80001e5c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e5e:	fffff097          	auipc	ra,0xfffff
    80001e62:	00e080e7          	jalr	14(ra) # 80000e6c <myproc>
  switch (n) {
    80001e66:	4795                	li	a5,5
    80001e68:	0497e163          	bltu	a5,s1,80001eaa <argraw+0x58>
    80001e6c:	048a                	slli	s1,s1,0x2
    80001e6e:	00006717          	auipc	a4,0x6
    80001e72:	60a70713          	addi	a4,a4,1546 # 80008478 <states.1714+0x238>
    80001e76:	94ba                	add	s1,s1,a4
    80001e78:	409c                	lw	a5,0(s1)
    80001e7a:	97ba                	add	a5,a5,a4
    80001e7c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e7e:	6d3c                	ld	a5,88(a0)
    80001e80:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e82:	60e2                	ld	ra,24(sp)
    80001e84:	6442                	ld	s0,16(sp)
    80001e86:	64a2                	ld	s1,8(sp)
    80001e88:	6105                	addi	sp,sp,32
    80001e8a:	8082                	ret
    return p->trapframe->a1;
    80001e8c:	6d3c                	ld	a5,88(a0)
    80001e8e:	7fa8                	ld	a0,120(a5)
    80001e90:	bfcd                	j	80001e82 <argraw+0x30>
    return p->trapframe->a2;
    80001e92:	6d3c                	ld	a5,88(a0)
    80001e94:	63c8                	ld	a0,128(a5)
    80001e96:	b7f5                	j	80001e82 <argraw+0x30>
    return p->trapframe->a3;
    80001e98:	6d3c                	ld	a5,88(a0)
    80001e9a:	67c8                	ld	a0,136(a5)
    80001e9c:	b7dd                	j	80001e82 <argraw+0x30>
    return p->trapframe->a4;
    80001e9e:	6d3c                	ld	a5,88(a0)
    80001ea0:	6bc8                	ld	a0,144(a5)
    80001ea2:	b7c5                	j	80001e82 <argraw+0x30>
    return p->trapframe->a5;
    80001ea4:	6d3c                	ld	a5,88(a0)
    80001ea6:	6fc8                	ld	a0,152(a5)
    80001ea8:	bfe9                	j	80001e82 <argraw+0x30>
  panic("argraw");
    80001eaa:	00006517          	auipc	a0,0x6
    80001eae:	4de50513          	addi	a0,a0,1246 # 80008388 <states.1714+0x148>
    80001eb2:	00004097          	auipc	ra,0x4
    80001eb6:	da6080e7          	jalr	-602(ra) # 80005c58 <panic>

0000000080001eba <fetchaddr>:
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	e426                	sd	s1,8(sp)
    80001ec2:	e04a                	sd	s2,0(sp)
    80001ec4:	1000                	addi	s0,sp,32
    80001ec6:	84aa                	mv	s1,a0
    80001ec8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	fa2080e7          	jalr	-94(ra) # 80000e6c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ed2:	653c                	ld	a5,72(a0)
    80001ed4:	02f4f863          	bgeu	s1,a5,80001f04 <fetchaddr+0x4a>
    80001ed8:	00848713          	addi	a4,s1,8
    80001edc:	02e7e663          	bltu	a5,a4,80001f08 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ee0:	46a1                	li	a3,8
    80001ee2:	8626                	mv	a2,s1
    80001ee4:	85ca                	mv	a1,s2
    80001ee6:	6928                	ld	a0,80(a0)
    80001ee8:	fffff097          	auipc	ra,0xfffff
    80001eec:	cd2080e7          	jalr	-814(ra) # 80000bba <copyin>
    80001ef0:	00a03533          	snez	a0,a0
    80001ef4:	40a00533          	neg	a0,a0
}
    80001ef8:	60e2                	ld	ra,24(sp)
    80001efa:	6442                	ld	s0,16(sp)
    80001efc:	64a2                	ld	s1,8(sp)
    80001efe:	6902                	ld	s2,0(sp)
    80001f00:	6105                	addi	sp,sp,32
    80001f02:	8082                	ret
    return -1;
    80001f04:	557d                	li	a0,-1
    80001f06:	bfcd                	j	80001ef8 <fetchaddr+0x3e>
    80001f08:	557d                	li	a0,-1
    80001f0a:	b7fd                	j	80001ef8 <fetchaddr+0x3e>

0000000080001f0c <fetchstr>:
{
    80001f0c:	7179                	addi	sp,sp,-48
    80001f0e:	f406                	sd	ra,40(sp)
    80001f10:	f022                	sd	s0,32(sp)
    80001f12:	ec26                	sd	s1,24(sp)
    80001f14:	e84a                	sd	s2,16(sp)
    80001f16:	e44e                	sd	s3,8(sp)
    80001f18:	1800                	addi	s0,sp,48
    80001f1a:	892a                	mv	s2,a0
    80001f1c:	84ae                	mv	s1,a1
    80001f1e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	f4c080e7          	jalr	-180(ra) # 80000e6c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f28:	86ce                	mv	a3,s3
    80001f2a:	864a                	mv	a2,s2
    80001f2c:	85a6                	mv	a1,s1
    80001f2e:	6928                	ld	a0,80(a0)
    80001f30:	fffff097          	auipc	ra,0xfffff
    80001f34:	d16080e7          	jalr	-746(ra) # 80000c46 <copyinstr>
  if(err < 0)
    80001f38:	00054763          	bltz	a0,80001f46 <fetchstr+0x3a>
  return strlen(buf);
    80001f3c:	8526                	mv	a0,s1
    80001f3e:	ffffe097          	auipc	ra,0xffffe
    80001f42:	3e2080e7          	jalr	994(ra) # 80000320 <strlen>
}
    80001f46:	70a2                	ld	ra,40(sp)
    80001f48:	7402                	ld	s0,32(sp)
    80001f4a:	64e2                	ld	s1,24(sp)
    80001f4c:	6942                	ld	s2,16(sp)
    80001f4e:	69a2                	ld	s3,8(sp)
    80001f50:	6145                	addi	sp,sp,48
    80001f52:	8082                	ret

0000000080001f54 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f54:	1101                	addi	sp,sp,-32
    80001f56:	ec06                	sd	ra,24(sp)
    80001f58:	e822                	sd	s0,16(sp)
    80001f5a:	e426                	sd	s1,8(sp)
    80001f5c:	1000                	addi	s0,sp,32
    80001f5e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f60:	00000097          	auipc	ra,0x0
    80001f64:	ef2080e7          	jalr	-270(ra) # 80001e52 <argraw>
    80001f68:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f6a:	4501                	li	a0,0
    80001f6c:	60e2                	ld	ra,24(sp)
    80001f6e:	6442                	ld	s0,16(sp)
    80001f70:	64a2                	ld	s1,8(sp)
    80001f72:	6105                	addi	sp,sp,32
    80001f74:	8082                	ret

0000000080001f76 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	e426                	sd	s1,8(sp)
    80001f7e:	1000                	addi	s0,sp,32
    80001f80:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f82:	00000097          	auipc	ra,0x0
    80001f86:	ed0080e7          	jalr	-304(ra) # 80001e52 <argraw>
    80001f8a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f8c:	4501                	li	a0,0
    80001f8e:	60e2                	ld	ra,24(sp)
    80001f90:	6442                	ld	s0,16(sp)
    80001f92:	64a2                	ld	s1,8(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret

0000000080001f98 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	e04a                	sd	s2,0(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84ae                	mv	s1,a1
    80001fa6:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	eaa080e7          	jalr	-342(ra) # 80001e52 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fb0:	864a                	mv	a2,s2
    80001fb2:	85a6                	mv	a1,s1
    80001fb4:	00000097          	auipc	ra,0x0
    80001fb8:	f58080e7          	jalr	-168(ra) # 80001f0c <fetchstr>
}
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6902                	ld	s2,0(sp)
    80001fc4:	6105                	addi	sp,sp,32
    80001fc6:	8082                	ret

0000000080001fc8 <syscall>:
    "uptime","open","write","mknod","unlink","link","mkdir","close","trace","sysinfo"
};

void
syscall(void)
{
    80001fc8:	7179                	addi	sp,sp,-48
    80001fca:	f406                	sd	ra,40(sp)
    80001fcc:	f022                	sd	s0,32(sp)
    80001fce:	ec26                	sd	s1,24(sp)
    80001fd0:	e84a                	sd	s2,16(sp)
    80001fd2:	e44e                	sd	s3,8(sp)
    80001fd4:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	e96080e7          	jalr	-362(ra) # 80000e6c <myproc>
    80001fde:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fe0:	05853903          	ld	s2,88(a0)
    80001fe4:	0a893783          	ld	a5,168(s2)
    80001fe8:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fec:	37fd                	addiw	a5,a5,-1
    80001fee:	4759                	li	a4,22
    80001ff0:	04f76a63          	bltu	a4,a5,80002044 <syscall+0x7c>
    80001ff4:	00399713          	slli	a4,s3,0x3
    80001ff8:	00006797          	auipc	a5,0x6
    80001ffc:	49878793          	addi	a5,a5,1176 # 80008490 <syscalls>
    80002000:	97ba                	add	a5,a5,a4
    80002002:	639c                	ld	a5,0(a5)
    80002004:	c3a1                	beqz	a5,80002044 <syscall+0x7c>
    p->trapframe->a0 = syscalls[num]();
    80002006:	9782                	jalr	a5
    80002008:	06a93823          	sd	a0,112(s2)
    int trace_mask = p->trace_mask;

    if((trace_mask >> num) & 1)
    8000200c:	1684a783          	lw	a5,360(s1)
    80002010:	4137d7bb          	sraw	a5,a5,s3
    80002014:	8b85                	andi	a5,a5,1
    80002016:	c7b1                	beqz	a5,80002062 <syscall+0x9a>
    {
      printf("%d: syscall %s -> %d\n", p->pid , syscall_names[num-1] , p->trapframe->a0);
    80002018:	6cb8                	ld	a4,88(s1)
    8000201a:	39fd                	addiw	s3,s3,-1
    8000201c:	00399793          	slli	a5,s3,0x3
    80002020:	00006997          	auipc	s3,0x6
    80002024:	47098993          	addi	s3,s3,1136 # 80008490 <syscalls>
    80002028:	99be                	add	s3,s3,a5
    8000202a:	7b34                	ld	a3,112(a4)
    8000202c:	0c09b603          	ld	a2,192(s3)
    80002030:	588c                	lw	a1,48(s1)
    80002032:	00006517          	auipc	a0,0x6
    80002036:	35e50513          	addi	a0,a0,862 # 80008390 <states.1714+0x150>
    8000203a:	00004097          	auipc	ra,0x4
    8000203e:	c68080e7          	jalr	-920(ra) # 80005ca2 <printf>
    80002042:	a005                	j	80002062 <syscall+0x9a>
    }

  } else {
    printf("%d %s: unknown sys call %d\n",
    80002044:	86ce                	mv	a3,s3
    80002046:	15848613          	addi	a2,s1,344
    8000204a:	588c                	lw	a1,48(s1)
    8000204c:	00006517          	auipc	a0,0x6
    80002050:	35c50513          	addi	a0,a0,860 # 800083a8 <states.1714+0x168>
    80002054:	00004097          	auipc	ra,0x4
    80002058:	c4e080e7          	jalr	-946(ra) # 80005ca2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000205c:	6cbc                	ld	a5,88(s1)
    8000205e:	577d                	li	a4,-1
    80002060:	fbb8                	sd	a4,112(a5)
  }
}
    80002062:	70a2                	ld	ra,40(sp)
    80002064:	7402                	ld	s0,32(sp)
    80002066:	64e2                	ld	s1,24(sp)
    80002068:	6942                	ld	s2,16(sp)
    8000206a:	69a2                	ld	s3,8(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret

0000000080002070 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    80002070:	1101                	addi	sp,sp,-32
    80002072:	ec06                	sd	ra,24(sp)
    80002074:	e822                	sd	s0,16(sp)
    80002076:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002078:	fec40593          	addi	a1,s0,-20
    8000207c:	4501                	li	a0,0
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	ed6080e7          	jalr	-298(ra) # 80001f54 <argint>
    return -1;
    80002086:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002088:	00054963          	bltz	a0,8000209a <sys_exit+0x2a>
  exit(n);
    8000208c:	fec42503          	lw	a0,-20(s0)
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	700080e7          	jalr	1792(ra) # 80001790 <exit>
  return 0;  // not reached
    80002098:	4781                	li	a5,0
}
    8000209a:	853e                	mv	a0,a5
    8000209c:	60e2                	ld	ra,24(sp)
    8000209e:	6442                	ld	s0,16(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret

00000000800020a4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020a4:	1141                	addi	sp,sp,-16
    800020a6:	e406                	sd	ra,8(sp)
    800020a8:	e022                	sd	s0,0(sp)
    800020aa:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020ac:	fffff097          	auipc	ra,0xfffff
    800020b0:	dc0080e7          	jalr	-576(ra) # 80000e6c <myproc>
}
    800020b4:	5908                	lw	a0,48(a0)
    800020b6:	60a2                	ld	ra,8(sp)
    800020b8:	6402                	ld	s0,0(sp)
    800020ba:	0141                	addi	sp,sp,16
    800020bc:	8082                	ret

00000000800020be <sys_fork>:

uint64
sys_fork(void)
{
    800020be:	1141                	addi	sp,sp,-16
    800020c0:	e406                	sd	ra,8(sp)
    800020c2:	e022                	sd	s0,0(sp)
    800020c4:	0800                	addi	s0,sp,16
  return fork();
    800020c6:	fffff097          	auipc	ra,0xfffff
    800020ca:	178080e7          	jalr	376(ra) # 8000123e <fork>
}
    800020ce:	60a2                	ld	ra,8(sp)
    800020d0:	6402                	ld	s0,0(sp)
    800020d2:	0141                	addi	sp,sp,16
    800020d4:	8082                	ret

00000000800020d6 <sys_wait>:

uint64
sys_wait(void)
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800020de:	fe840593          	addi	a1,s0,-24
    800020e2:	4501                	li	a0,0
    800020e4:	00000097          	auipc	ra,0x0
    800020e8:	e92080e7          	jalr	-366(ra) # 80001f76 <argaddr>
    800020ec:	87aa                	mv	a5,a0
    return -1;
    800020ee:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800020f0:	0007c863          	bltz	a5,80002100 <sys_wait+0x2a>
  return wait(p);
    800020f4:	fe843503          	ld	a0,-24(s0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	4a0080e7          	jalr	1184(ra) # 80001598 <wait>
}
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002108:	7179                	addi	sp,sp,-48
    8000210a:	f406                	sd	ra,40(sp)
    8000210c:	f022                	sd	s0,32(sp)
    8000210e:	ec26                	sd	s1,24(sp)
    80002110:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002112:	fdc40593          	addi	a1,s0,-36
    80002116:	4501                	li	a0,0
    80002118:	00000097          	auipc	ra,0x0
    8000211c:	e3c080e7          	jalr	-452(ra) # 80001f54 <argint>
    80002120:	87aa                	mv	a5,a0
    return -1;
    80002122:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002124:	0207c063          	bltz	a5,80002144 <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002128:	fffff097          	auipc	ra,0xfffff
    8000212c:	d44080e7          	jalr	-700(ra) # 80000e6c <myproc>
    80002130:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002132:	fdc42503          	lw	a0,-36(s0)
    80002136:	fffff097          	auipc	ra,0xfffff
    8000213a:	094080e7          	jalr	148(ra) # 800011ca <growproc>
    8000213e:	00054863          	bltz	a0,8000214e <sys_sbrk+0x46>
    return -1;
  return addr;
    80002142:	8526                	mv	a0,s1
}
    80002144:	70a2                	ld	ra,40(sp)
    80002146:	7402                	ld	s0,32(sp)
    80002148:	64e2                	ld	s1,24(sp)
    8000214a:	6145                	addi	sp,sp,48
    8000214c:	8082                	ret
    return -1;
    8000214e:	557d                	li	a0,-1
    80002150:	bfd5                	j	80002144 <sys_sbrk+0x3c>

0000000080002152 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002152:	7139                	addi	sp,sp,-64
    80002154:	fc06                	sd	ra,56(sp)
    80002156:	f822                	sd	s0,48(sp)
    80002158:	f426                	sd	s1,40(sp)
    8000215a:	f04a                	sd	s2,32(sp)
    8000215c:	ec4e                	sd	s3,24(sp)
    8000215e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002160:	fcc40593          	addi	a1,s0,-52
    80002164:	4501                	li	a0,0
    80002166:	00000097          	auipc	ra,0x0
    8000216a:	dee080e7          	jalr	-530(ra) # 80001f54 <argint>
    return -1;
    8000216e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002170:	06054563          	bltz	a0,800021da <sys_sleep+0x88>
  acquire(&tickslock);
    80002174:	0000d517          	auipc	a0,0xd
    80002178:	f0c50513          	addi	a0,a0,-244 # 8000f080 <tickslock>
    8000217c:	00004097          	auipc	ra,0x4
    80002180:	026080e7          	jalr	38(ra) # 800061a2 <acquire>
  ticks0 = ticks;
    80002184:	00007917          	auipc	s2,0x7
    80002188:	e9492903          	lw	s2,-364(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000218c:	fcc42783          	lw	a5,-52(s0)
    80002190:	cf85                	beqz	a5,800021c8 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002192:	0000d997          	auipc	s3,0xd
    80002196:	eee98993          	addi	s3,s3,-274 # 8000f080 <tickslock>
    8000219a:	00007497          	auipc	s1,0x7
    8000219e:	e7e48493          	addi	s1,s1,-386 # 80009018 <ticks>
    if(myproc()->killed){
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	cca080e7          	jalr	-822(ra) # 80000e6c <myproc>
    800021aa:	551c                	lw	a5,40(a0)
    800021ac:	ef9d                	bnez	a5,800021ea <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021ae:	85ce                	mv	a1,s3
    800021b0:	8526                	mv	a0,s1
    800021b2:	fffff097          	auipc	ra,0xfffff
    800021b6:	382080e7          	jalr	898(ra) # 80001534 <sleep>
  while(ticks - ticks0 < n){
    800021ba:	409c                	lw	a5,0(s1)
    800021bc:	412787bb          	subw	a5,a5,s2
    800021c0:	fcc42703          	lw	a4,-52(s0)
    800021c4:	fce7efe3          	bltu	a5,a4,800021a2 <sys_sleep+0x50>
  }
  release(&tickslock);
    800021c8:	0000d517          	auipc	a0,0xd
    800021cc:	eb850513          	addi	a0,a0,-328 # 8000f080 <tickslock>
    800021d0:	00004097          	auipc	ra,0x4
    800021d4:	086080e7          	jalr	134(ra) # 80006256 <release>
  return 0;
    800021d8:	4781                	li	a5,0
}
    800021da:	853e                	mv	a0,a5
    800021dc:	70e2                	ld	ra,56(sp)
    800021de:	7442                	ld	s0,48(sp)
    800021e0:	74a2                	ld	s1,40(sp)
    800021e2:	7902                	ld	s2,32(sp)
    800021e4:	69e2                	ld	s3,24(sp)
    800021e6:	6121                	addi	sp,sp,64
    800021e8:	8082                	ret
      release(&tickslock);
    800021ea:	0000d517          	auipc	a0,0xd
    800021ee:	e9650513          	addi	a0,a0,-362 # 8000f080 <tickslock>
    800021f2:	00004097          	auipc	ra,0x4
    800021f6:	064080e7          	jalr	100(ra) # 80006256 <release>
      return -1;
    800021fa:	57fd                	li	a5,-1
    800021fc:	bff9                	j	800021da <sys_sleep+0x88>

00000000800021fe <sys_kill>:

uint64
sys_kill(void)
{
    800021fe:	1101                	addi	sp,sp,-32
    80002200:	ec06                	sd	ra,24(sp)
    80002202:	e822                	sd	s0,16(sp)
    80002204:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002206:	fec40593          	addi	a1,s0,-20
    8000220a:	4501                	li	a0,0
    8000220c:	00000097          	auipc	ra,0x0
    80002210:	d48080e7          	jalr	-696(ra) # 80001f54 <argint>
    80002214:	87aa                	mv	a5,a0
    return -1;
    80002216:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002218:	0007c863          	bltz	a5,80002228 <sys_kill+0x2a>
  return kill(pid);
    8000221c:	fec42503          	lw	a0,-20(s0)
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	646080e7          	jalr	1606(ra) # 80001866 <kill>
}
    80002228:	60e2                	ld	ra,24(sp)
    8000222a:	6442                	ld	s0,16(sp)
    8000222c:	6105                	addi	sp,sp,32
    8000222e:	8082                	ret

0000000080002230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002230:	1101                	addi	sp,sp,-32
    80002232:	ec06                	sd	ra,24(sp)
    80002234:	e822                	sd	s0,16(sp)
    80002236:	e426                	sd	s1,8(sp)
    80002238:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000223a:	0000d517          	auipc	a0,0xd
    8000223e:	e4650513          	addi	a0,a0,-442 # 8000f080 <tickslock>
    80002242:	00004097          	auipc	ra,0x4
    80002246:	f60080e7          	jalr	-160(ra) # 800061a2 <acquire>
  xticks = ticks;
    8000224a:	00007497          	auipc	s1,0x7
    8000224e:	dce4a483          	lw	s1,-562(s1) # 80009018 <ticks>
  release(&tickslock);
    80002252:	0000d517          	auipc	a0,0xd
    80002256:	e2e50513          	addi	a0,a0,-466 # 8000f080 <tickslock>
    8000225a:	00004097          	auipc	ra,0x4
    8000225e:	ffc080e7          	jalr	-4(ra) # 80006256 <release>
  return xticks;
}
    80002262:	02049513          	slli	a0,s1,0x20
    80002266:	9101                	srli	a0,a0,0x20
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <sys_trace>:


uint64
sys_trace(void)
{
    80002272:	7179                	addi	sp,sp,-48
    80002274:	f406                	sd	ra,40(sp)
    80002276:	f022                	sd	s0,32(sp)
    80002278:	ec26                	sd	s1,24(sp)
    8000227a:	1800                	addi	s0,sp,48
  int mask;
  struct proc *p = myproc();
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	bf0080e7          	jalr	-1040(ra) # 80000e6c <myproc>
    80002284:	84aa                	mv	s1,a0

  if(argint(0, &mask) < 0)
    80002286:	fdc40593          	addi	a1,s0,-36
    8000228a:	4501                	li	a0,0
    8000228c:	00000097          	auipc	ra,0x0
    80002290:	cc8080e7          	jalr	-824(ra) # 80001f54 <argint>
    80002294:	00054c63          	bltz	a0,800022ac <sys_trace+0x3a>
    return -1;

  p->trace_mask = mask;
    80002298:	fdc42783          	lw	a5,-36(s0)
    8000229c:	16f4a423          	sw	a5,360(s1)
  return 0;
    800022a0:	4501                	li	a0,0

}
    800022a2:	70a2                	ld	ra,40(sp)
    800022a4:	7402                	ld	s0,32(sp)
    800022a6:	64e2                	ld	s1,24(sp)
    800022a8:	6145                	addi	sp,sp,48
    800022aa:	8082                	ret
    return -1;
    800022ac:	557d                	li	a0,-1
    800022ae:	bfd5                	j	800022a2 <sys_trace+0x30>

00000000800022b0 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    800022b0:	7139                	addi	sp,sp,-64
    800022b2:	fc06                	sd	ra,56(sp)
    800022b4:	f822                	sd	s0,48(sp)
    800022b6:	f426                	sd	s1,40(sp)
    800022b8:	0080                	addi	s0,sp,64
  uint64 infop;
  struct sysinfo info;
  struct proc *p = myproc();
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	bb2080e7          	jalr	-1102(ra) # 80000e6c <myproc>
    800022c2:	84aa                	mv	s1,a0
  
  if(argaddr(0,&infop)<0)
    800022c4:	fd840593          	addi	a1,s0,-40
    800022c8:	4501                	li	a0,0
    800022ca:	00000097          	auipc	ra,0x0
    800022ce:	cac080e7          	jalr	-852(ra) # 80001f76 <argaddr>
    return -1;
    800022d2:	57fd                	li	a5,-1
  if(argaddr(0,&infop)<0)
    800022d4:	02054a63          	bltz	a0,80002308 <sys_sysinfo+0x58>
  
  info.freemem = freememsize();
    800022d8:	ffffe097          	auipc	ra,0xffffe
    800022dc:	ea0080e7          	jalr	-352(ra) # 80000178 <freememsize>
    800022e0:	fca43423          	sd	a0,-56(s0)
  info.nproc = numproc();
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	74e080e7          	jalr	1870(ra) # 80001a32 <numproc>
    800022ec:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, infop, (char *)&info, sizeof(info)) < 0)
    800022f0:	46c1                	li	a3,16
    800022f2:	fc840613          	addi	a2,s0,-56
    800022f6:	fd843583          	ld	a1,-40(s0)
    800022fa:	68a8                	ld	a0,80(s1)
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	832080e7          	jalr	-1998(ra) # 80000b2e <copyout>
    80002304:	43f55793          	srai	a5,a0,0x3f
    return -1;

  return 0;
    80002308:	853e                	mv	a0,a5
    8000230a:	70e2                	ld	ra,56(sp)
    8000230c:	7442                	ld	s0,48(sp)
    8000230e:	74a2                	ld	s1,40(sp)
    80002310:	6121                	addi	sp,sp,64
    80002312:	8082                	ret

0000000080002314 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002314:	7179                	addi	sp,sp,-48
    80002316:	f406                	sd	ra,40(sp)
    80002318:	f022                	sd	s0,32(sp)
    8000231a:	ec26                	sd	s1,24(sp)
    8000231c:	e84a                	sd	s2,16(sp)
    8000231e:	e44e                	sd	s3,8(sp)
    80002320:	e052                	sd	s4,0(sp)
    80002322:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002324:	00006597          	auipc	a1,0x6
    80002328:	2e458593          	addi	a1,a1,740 # 80008608 <syscall_names+0xb8>
    8000232c:	0000d517          	auipc	a0,0xd
    80002330:	d6c50513          	addi	a0,a0,-660 # 8000f098 <bcache>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	dde080e7          	jalr	-546(ra) # 80006112 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000233c:	00015797          	auipc	a5,0x15
    80002340:	d5c78793          	addi	a5,a5,-676 # 80017098 <bcache+0x8000>
    80002344:	00015717          	auipc	a4,0x15
    80002348:	fbc70713          	addi	a4,a4,-68 # 80017300 <bcache+0x8268>
    8000234c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002350:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002354:	0000d497          	auipc	s1,0xd
    80002358:	d5c48493          	addi	s1,s1,-676 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    8000235c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000235e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002360:	00006a17          	auipc	s4,0x6
    80002364:	2b0a0a13          	addi	s4,s4,688 # 80008610 <syscall_names+0xc0>
    b->next = bcache.head.next;
    80002368:	2b893783          	ld	a5,696(s2)
    8000236c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000236e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002372:	85d2                	mv	a1,s4
    80002374:	01048513          	addi	a0,s1,16
    80002378:	00001097          	auipc	ra,0x1
    8000237c:	4bc080e7          	jalr	1212(ra) # 80003834 <initsleeplock>
    bcache.head.next->prev = b;
    80002380:	2b893783          	ld	a5,696(s2)
    80002384:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002386:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000238a:	45848493          	addi	s1,s1,1112
    8000238e:	fd349de3          	bne	s1,s3,80002368 <binit+0x54>
  }
}
    80002392:	70a2                	ld	ra,40(sp)
    80002394:	7402                	ld	s0,32(sp)
    80002396:	64e2                	ld	s1,24(sp)
    80002398:	6942                	ld	s2,16(sp)
    8000239a:	69a2                	ld	s3,8(sp)
    8000239c:	6a02                	ld	s4,0(sp)
    8000239e:	6145                	addi	sp,sp,48
    800023a0:	8082                	ret

00000000800023a2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023a2:	7179                	addi	sp,sp,-48
    800023a4:	f406                	sd	ra,40(sp)
    800023a6:	f022                	sd	s0,32(sp)
    800023a8:	ec26                	sd	s1,24(sp)
    800023aa:	e84a                	sd	s2,16(sp)
    800023ac:	e44e                	sd	s3,8(sp)
    800023ae:	1800                	addi	s0,sp,48
    800023b0:	89aa                	mv	s3,a0
    800023b2:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023b4:	0000d517          	auipc	a0,0xd
    800023b8:	ce450513          	addi	a0,a0,-796 # 8000f098 <bcache>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	de6080e7          	jalr	-538(ra) # 800061a2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023c4:	00015497          	auipc	s1,0x15
    800023c8:	f8c4b483          	ld	s1,-116(s1) # 80017350 <bcache+0x82b8>
    800023cc:	00015797          	auipc	a5,0x15
    800023d0:	f3478793          	addi	a5,a5,-204 # 80017300 <bcache+0x8268>
    800023d4:	02f48f63          	beq	s1,a5,80002412 <bread+0x70>
    800023d8:	873e                	mv	a4,a5
    800023da:	a021                	j	800023e2 <bread+0x40>
    800023dc:	68a4                	ld	s1,80(s1)
    800023de:	02e48a63          	beq	s1,a4,80002412 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023e2:	449c                	lw	a5,8(s1)
    800023e4:	ff379ce3          	bne	a5,s3,800023dc <bread+0x3a>
    800023e8:	44dc                	lw	a5,12(s1)
    800023ea:	ff2799e3          	bne	a5,s2,800023dc <bread+0x3a>
      b->refcnt++;
    800023ee:	40bc                	lw	a5,64(s1)
    800023f0:	2785                	addiw	a5,a5,1
    800023f2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f4:	0000d517          	auipc	a0,0xd
    800023f8:	ca450513          	addi	a0,a0,-860 # 8000f098 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	e5a080e7          	jalr	-422(ra) # 80006256 <release>
      acquiresleep(&b->lock);
    80002404:	01048513          	addi	a0,s1,16
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	466080e7          	jalr	1126(ra) # 8000386e <acquiresleep>
      return b;
    80002410:	a8b9                	j	8000246e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002412:	00015497          	auipc	s1,0x15
    80002416:	f364b483          	ld	s1,-202(s1) # 80017348 <bcache+0x82b0>
    8000241a:	00015797          	auipc	a5,0x15
    8000241e:	ee678793          	addi	a5,a5,-282 # 80017300 <bcache+0x8268>
    80002422:	00f48863          	beq	s1,a5,80002432 <bread+0x90>
    80002426:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002428:	40bc                	lw	a5,64(s1)
    8000242a:	cf81                	beqz	a5,80002442 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242c:	64a4                	ld	s1,72(s1)
    8000242e:	fee49de3          	bne	s1,a4,80002428 <bread+0x86>
  panic("bget: no buffers");
    80002432:	00006517          	auipc	a0,0x6
    80002436:	1e650513          	addi	a0,a0,486 # 80008618 <syscall_names+0xc8>
    8000243a:	00004097          	auipc	ra,0x4
    8000243e:	81e080e7          	jalr	-2018(ra) # 80005c58 <panic>
      b->dev = dev;
    80002442:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002446:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000244a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000244e:	4785                	li	a5,1
    80002450:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002452:	0000d517          	auipc	a0,0xd
    80002456:	c4650513          	addi	a0,a0,-954 # 8000f098 <bcache>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	dfc080e7          	jalr	-516(ra) # 80006256 <release>
      acquiresleep(&b->lock);
    80002462:	01048513          	addi	a0,s1,16
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	408080e7          	jalr	1032(ra) # 8000386e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000246e:	409c                	lw	a5,0(s1)
    80002470:	cb89                	beqz	a5,80002482 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002472:	8526                	mv	a0,s1
    80002474:	70a2                	ld	ra,40(sp)
    80002476:	7402                	ld	s0,32(sp)
    80002478:	64e2                	ld	s1,24(sp)
    8000247a:	6942                	ld	s2,16(sp)
    8000247c:	69a2                	ld	s3,8(sp)
    8000247e:	6145                	addi	sp,sp,48
    80002480:	8082                	ret
    virtio_disk_rw(b, 0);
    80002482:	4581                	li	a1,0
    80002484:	8526                	mv	a0,s1
    80002486:	00003097          	auipc	ra,0x3
    8000248a:	f10080e7          	jalr	-240(ra) # 80005396 <virtio_disk_rw>
    b->valid = 1;
    8000248e:	4785                	li	a5,1
    80002490:	c09c                	sw	a5,0(s1)
  return b;
    80002492:	b7c5                	j	80002472 <bread+0xd0>

0000000080002494 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002494:	1101                	addi	sp,sp,-32
    80002496:	ec06                	sd	ra,24(sp)
    80002498:	e822                	sd	s0,16(sp)
    8000249a:	e426                	sd	s1,8(sp)
    8000249c:	1000                	addi	s0,sp,32
    8000249e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024a0:	0541                	addi	a0,a0,16
    800024a2:	00001097          	auipc	ra,0x1
    800024a6:	466080e7          	jalr	1126(ra) # 80003908 <holdingsleep>
    800024aa:	cd01                	beqz	a0,800024c2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ac:	4585                	li	a1,1
    800024ae:	8526                	mv	a0,s1
    800024b0:	00003097          	auipc	ra,0x3
    800024b4:	ee6080e7          	jalr	-282(ra) # 80005396 <virtio_disk_rw>
}
    800024b8:	60e2                	ld	ra,24(sp)
    800024ba:	6442                	ld	s0,16(sp)
    800024bc:	64a2                	ld	s1,8(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret
    panic("bwrite");
    800024c2:	00006517          	auipc	a0,0x6
    800024c6:	16e50513          	addi	a0,a0,366 # 80008630 <syscall_names+0xe0>
    800024ca:	00003097          	auipc	ra,0x3
    800024ce:	78e080e7          	jalr	1934(ra) # 80005c58 <panic>

00000000800024d2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024d2:	1101                	addi	sp,sp,-32
    800024d4:	ec06                	sd	ra,24(sp)
    800024d6:	e822                	sd	s0,16(sp)
    800024d8:	e426                	sd	s1,8(sp)
    800024da:	e04a                	sd	s2,0(sp)
    800024dc:	1000                	addi	s0,sp,32
    800024de:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e0:	01050913          	addi	s2,a0,16
    800024e4:	854a                	mv	a0,s2
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	422080e7          	jalr	1058(ra) # 80003908 <holdingsleep>
    800024ee:	c92d                	beqz	a0,80002560 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800024f0:	854a                	mv	a0,s2
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	3d2080e7          	jalr	978(ra) # 800038c4 <releasesleep>

  acquire(&bcache.lock);
    800024fa:	0000d517          	auipc	a0,0xd
    800024fe:	b9e50513          	addi	a0,a0,-1122 # 8000f098 <bcache>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	ca0080e7          	jalr	-864(ra) # 800061a2 <acquire>
  b->refcnt--;
    8000250a:	40bc                	lw	a5,64(s1)
    8000250c:	37fd                	addiw	a5,a5,-1
    8000250e:	0007871b          	sext.w	a4,a5
    80002512:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002514:	eb05                	bnez	a4,80002544 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002516:	68bc                	ld	a5,80(s1)
    80002518:	64b8                	ld	a4,72(s1)
    8000251a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000251c:	64bc                	ld	a5,72(s1)
    8000251e:	68b8                	ld	a4,80(s1)
    80002520:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002522:	00015797          	auipc	a5,0x15
    80002526:	b7678793          	addi	a5,a5,-1162 # 80017098 <bcache+0x8000>
    8000252a:	2b87b703          	ld	a4,696(a5)
    8000252e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002530:	00015717          	auipc	a4,0x15
    80002534:	dd070713          	addi	a4,a4,-560 # 80017300 <bcache+0x8268>
    80002538:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000253a:	2b87b703          	ld	a4,696(a5)
    8000253e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002540:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002544:	0000d517          	auipc	a0,0xd
    80002548:	b5450513          	addi	a0,a0,-1196 # 8000f098 <bcache>
    8000254c:	00004097          	auipc	ra,0x4
    80002550:	d0a080e7          	jalr	-758(ra) # 80006256 <release>
}
    80002554:	60e2                	ld	ra,24(sp)
    80002556:	6442                	ld	s0,16(sp)
    80002558:	64a2                	ld	s1,8(sp)
    8000255a:	6902                	ld	s2,0(sp)
    8000255c:	6105                	addi	sp,sp,32
    8000255e:	8082                	ret
    panic("brelse");
    80002560:	00006517          	auipc	a0,0x6
    80002564:	0d850513          	addi	a0,a0,216 # 80008638 <syscall_names+0xe8>
    80002568:	00003097          	auipc	ra,0x3
    8000256c:	6f0080e7          	jalr	1776(ra) # 80005c58 <panic>

0000000080002570 <bpin>:

void
bpin(struct buf *b) {
    80002570:	1101                	addi	sp,sp,-32
    80002572:	ec06                	sd	ra,24(sp)
    80002574:	e822                	sd	s0,16(sp)
    80002576:	e426                	sd	s1,8(sp)
    80002578:	1000                	addi	s0,sp,32
    8000257a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000257c:	0000d517          	auipc	a0,0xd
    80002580:	b1c50513          	addi	a0,a0,-1252 # 8000f098 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	c1e080e7          	jalr	-994(ra) # 800061a2 <acquire>
  b->refcnt++;
    8000258c:	40bc                	lw	a5,64(s1)
    8000258e:	2785                	addiw	a5,a5,1
    80002590:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002592:	0000d517          	auipc	a0,0xd
    80002596:	b0650513          	addi	a0,a0,-1274 # 8000f098 <bcache>
    8000259a:	00004097          	auipc	ra,0x4
    8000259e:	cbc080e7          	jalr	-836(ra) # 80006256 <release>
}
    800025a2:	60e2                	ld	ra,24(sp)
    800025a4:	6442                	ld	s0,16(sp)
    800025a6:	64a2                	ld	s1,8(sp)
    800025a8:	6105                	addi	sp,sp,32
    800025aa:	8082                	ret

00000000800025ac <bunpin>:

void
bunpin(struct buf *b) {
    800025ac:	1101                	addi	sp,sp,-32
    800025ae:	ec06                	sd	ra,24(sp)
    800025b0:	e822                	sd	s0,16(sp)
    800025b2:	e426                	sd	s1,8(sp)
    800025b4:	1000                	addi	s0,sp,32
    800025b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b8:	0000d517          	auipc	a0,0xd
    800025bc:	ae050513          	addi	a0,a0,-1312 # 8000f098 <bcache>
    800025c0:	00004097          	auipc	ra,0x4
    800025c4:	be2080e7          	jalr	-1054(ra) # 800061a2 <acquire>
  b->refcnt--;
    800025c8:	40bc                	lw	a5,64(s1)
    800025ca:	37fd                	addiw	a5,a5,-1
    800025cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ce:	0000d517          	auipc	a0,0xd
    800025d2:	aca50513          	addi	a0,a0,-1334 # 8000f098 <bcache>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	c80080e7          	jalr	-896(ra) # 80006256 <release>
}
    800025de:	60e2                	ld	ra,24(sp)
    800025e0:	6442                	ld	s0,16(sp)
    800025e2:	64a2                	ld	s1,8(sp)
    800025e4:	6105                	addi	sp,sp,32
    800025e6:	8082                	ret

00000000800025e8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800025e8:	1101                	addi	sp,sp,-32
    800025ea:	ec06                	sd	ra,24(sp)
    800025ec:	e822                	sd	s0,16(sp)
    800025ee:	e426                	sd	s1,8(sp)
    800025f0:	e04a                	sd	s2,0(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800025f6:	00d5d59b          	srliw	a1,a1,0xd
    800025fa:	00015797          	auipc	a5,0x15
    800025fe:	17a7a783          	lw	a5,378(a5) # 80017774 <sb+0x1c>
    80002602:	9dbd                	addw	a1,a1,a5
    80002604:	00000097          	auipc	ra,0x0
    80002608:	d9e080e7          	jalr	-610(ra) # 800023a2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000260c:	0074f713          	andi	a4,s1,7
    80002610:	4785                	li	a5,1
    80002612:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002616:	14ce                	slli	s1,s1,0x33
    80002618:	90d9                	srli	s1,s1,0x36
    8000261a:	00950733          	add	a4,a0,s1
    8000261e:	05874703          	lbu	a4,88(a4)
    80002622:	00e7f6b3          	and	a3,a5,a4
    80002626:	c69d                	beqz	a3,80002654 <bfree+0x6c>
    80002628:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000262a:	94aa                	add	s1,s1,a0
    8000262c:	fff7c793          	not	a5,a5
    80002630:	8ff9                	and	a5,a5,a4
    80002632:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002636:	00001097          	auipc	ra,0x1
    8000263a:	118080e7          	jalr	280(ra) # 8000374e <log_write>
  brelse(bp);
    8000263e:	854a                	mv	a0,s2
    80002640:	00000097          	auipc	ra,0x0
    80002644:	e92080e7          	jalr	-366(ra) # 800024d2 <brelse>
}
    80002648:	60e2                	ld	ra,24(sp)
    8000264a:	6442                	ld	s0,16(sp)
    8000264c:	64a2                	ld	s1,8(sp)
    8000264e:	6902                	ld	s2,0(sp)
    80002650:	6105                	addi	sp,sp,32
    80002652:	8082                	ret
    panic("freeing free block");
    80002654:	00006517          	auipc	a0,0x6
    80002658:	fec50513          	addi	a0,a0,-20 # 80008640 <syscall_names+0xf0>
    8000265c:	00003097          	auipc	ra,0x3
    80002660:	5fc080e7          	jalr	1532(ra) # 80005c58 <panic>

0000000080002664 <balloc>:
{
    80002664:	711d                	addi	sp,sp,-96
    80002666:	ec86                	sd	ra,88(sp)
    80002668:	e8a2                	sd	s0,80(sp)
    8000266a:	e4a6                	sd	s1,72(sp)
    8000266c:	e0ca                	sd	s2,64(sp)
    8000266e:	fc4e                	sd	s3,56(sp)
    80002670:	f852                	sd	s4,48(sp)
    80002672:	f456                	sd	s5,40(sp)
    80002674:	f05a                	sd	s6,32(sp)
    80002676:	ec5e                	sd	s7,24(sp)
    80002678:	e862                	sd	s8,16(sp)
    8000267a:	e466                	sd	s9,8(sp)
    8000267c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000267e:	00015797          	auipc	a5,0x15
    80002682:	0de7a783          	lw	a5,222(a5) # 8001775c <sb+0x4>
    80002686:	cbd1                	beqz	a5,8000271a <balloc+0xb6>
    80002688:	8baa                	mv	s7,a0
    8000268a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000268c:	00015b17          	auipc	s6,0x15
    80002690:	0ccb0b13          	addi	s6,s6,204 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002694:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002696:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002698:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000269a:	6c89                	lui	s9,0x2
    8000269c:	a831                	j	800026b8 <balloc+0x54>
    brelse(bp);
    8000269e:	854a                	mv	a0,s2
    800026a0:	00000097          	auipc	ra,0x0
    800026a4:	e32080e7          	jalr	-462(ra) # 800024d2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026a8:	015c87bb          	addw	a5,s9,s5
    800026ac:	00078a9b          	sext.w	s5,a5
    800026b0:	004b2703          	lw	a4,4(s6)
    800026b4:	06eaf363          	bgeu	s5,a4,8000271a <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800026b8:	41fad79b          	sraiw	a5,s5,0x1f
    800026bc:	0137d79b          	srliw	a5,a5,0x13
    800026c0:	015787bb          	addw	a5,a5,s5
    800026c4:	40d7d79b          	sraiw	a5,a5,0xd
    800026c8:	01cb2583          	lw	a1,28(s6)
    800026cc:	9dbd                	addw	a1,a1,a5
    800026ce:	855e                	mv	a0,s7
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	cd2080e7          	jalr	-814(ra) # 800023a2 <bread>
    800026d8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026da:	004b2503          	lw	a0,4(s6)
    800026de:	000a849b          	sext.w	s1,s5
    800026e2:	8662                	mv	a2,s8
    800026e4:	faa4fde3          	bgeu	s1,a0,8000269e <balloc+0x3a>
      m = 1 << (bi % 8);
    800026e8:	41f6579b          	sraiw	a5,a2,0x1f
    800026ec:	01d7d69b          	srliw	a3,a5,0x1d
    800026f0:	00c6873b          	addw	a4,a3,a2
    800026f4:	00777793          	andi	a5,a4,7
    800026f8:	9f95                	subw	a5,a5,a3
    800026fa:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800026fe:	4037571b          	sraiw	a4,a4,0x3
    80002702:	00e906b3          	add	a3,s2,a4
    80002706:	0586c683          	lbu	a3,88(a3)
    8000270a:	00d7f5b3          	and	a1,a5,a3
    8000270e:	cd91                	beqz	a1,8000272a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	2605                	addiw	a2,a2,1
    80002712:	2485                	addiw	s1,s1,1
    80002714:	fd4618e3          	bne	a2,s4,800026e4 <balloc+0x80>
    80002718:	b759                	j	8000269e <balloc+0x3a>
  panic("balloc: out of blocks");
    8000271a:	00006517          	auipc	a0,0x6
    8000271e:	f3e50513          	addi	a0,a0,-194 # 80008658 <syscall_names+0x108>
    80002722:	00003097          	auipc	ra,0x3
    80002726:	536080e7          	jalr	1334(ra) # 80005c58 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000272a:	974a                	add	a4,a4,s2
    8000272c:	8fd5                	or	a5,a5,a3
    8000272e:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002732:	854a                	mv	a0,s2
    80002734:	00001097          	auipc	ra,0x1
    80002738:	01a080e7          	jalr	26(ra) # 8000374e <log_write>
        brelse(bp);
    8000273c:	854a                	mv	a0,s2
    8000273e:	00000097          	auipc	ra,0x0
    80002742:	d94080e7          	jalr	-620(ra) # 800024d2 <brelse>
  bp = bread(dev, bno);
    80002746:	85a6                	mv	a1,s1
    80002748:	855e                	mv	a0,s7
    8000274a:	00000097          	auipc	ra,0x0
    8000274e:	c58080e7          	jalr	-936(ra) # 800023a2 <bread>
    80002752:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002754:	40000613          	li	a2,1024
    80002758:	4581                	li	a1,0
    8000275a:	05850513          	addi	a0,a0,88
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	a3e080e7          	jalr	-1474(ra) # 8000019c <memset>
  log_write(bp);
    80002766:	854a                	mv	a0,s2
    80002768:	00001097          	auipc	ra,0x1
    8000276c:	fe6080e7          	jalr	-26(ra) # 8000374e <log_write>
  brelse(bp);
    80002770:	854a                	mv	a0,s2
    80002772:	00000097          	auipc	ra,0x0
    80002776:	d60080e7          	jalr	-672(ra) # 800024d2 <brelse>
}
    8000277a:	8526                	mv	a0,s1
    8000277c:	60e6                	ld	ra,88(sp)
    8000277e:	6446                	ld	s0,80(sp)
    80002780:	64a6                	ld	s1,72(sp)
    80002782:	6906                	ld	s2,64(sp)
    80002784:	79e2                	ld	s3,56(sp)
    80002786:	7a42                	ld	s4,48(sp)
    80002788:	7aa2                	ld	s5,40(sp)
    8000278a:	7b02                	ld	s6,32(sp)
    8000278c:	6be2                	ld	s7,24(sp)
    8000278e:	6c42                	ld	s8,16(sp)
    80002790:	6ca2                	ld	s9,8(sp)
    80002792:	6125                	addi	sp,sp,96
    80002794:	8082                	ret

0000000080002796 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002796:	7179                	addi	sp,sp,-48
    80002798:	f406                	sd	ra,40(sp)
    8000279a:	f022                	sd	s0,32(sp)
    8000279c:	ec26                	sd	s1,24(sp)
    8000279e:	e84a                	sd	s2,16(sp)
    800027a0:	e44e                	sd	s3,8(sp)
    800027a2:	e052                	sd	s4,0(sp)
    800027a4:	1800                	addi	s0,sp,48
    800027a6:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027a8:	47ad                	li	a5,11
    800027aa:	04b7fe63          	bgeu	a5,a1,80002806 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027ae:	ff45849b          	addiw	s1,a1,-12
    800027b2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800027b6:	0ff00793          	li	a5,255
    800027ba:	0ae7e363          	bltu	a5,a4,80002860 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027be:	08052583          	lw	a1,128(a0)
    800027c2:	c5ad                	beqz	a1,8000282c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027c4:	00092503          	lw	a0,0(s2)
    800027c8:	00000097          	auipc	ra,0x0
    800027cc:	bda080e7          	jalr	-1062(ra) # 800023a2 <bread>
    800027d0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027d2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800027d6:	02049593          	slli	a1,s1,0x20
    800027da:	9181                	srli	a1,a1,0x20
    800027dc:	058a                	slli	a1,a1,0x2
    800027de:	00b784b3          	add	s1,a5,a1
    800027e2:	0004a983          	lw	s3,0(s1)
    800027e6:	04098d63          	beqz	s3,80002840 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800027ea:	8552                	mv	a0,s4
    800027ec:	00000097          	auipc	ra,0x0
    800027f0:	ce6080e7          	jalr	-794(ra) # 800024d2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800027f4:	854e                	mv	a0,s3
    800027f6:	70a2                	ld	ra,40(sp)
    800027f8:	7402                	ld	s0,32(sp)
    800027fa:	64e2                	ld	s1,24(sp)
    800027fc:	6942                	ld	s2,16(sp)
    800027fe:	69a2                	ld	s3,8(sp)
    80002800:	6a02                	ld	s4,0(sp)
    80002802:	6145                	addi	sp,sp,48
    80002804:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002806:	02059493          	slli	s1,a1,0x20
    8000280a:	9081                	srli	s1,s1,0x20
    8000280c:	048a                	slli	s1,s1,0x2
    8000280e:	94aa                	add	s1,s1,a0
    80002810:	0504a983          	lw	s3,80(s1)
    80002814:	fe0990e3          	bnez	s3,800027f4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002818:	4108                	lw	a0,0(a0)
    8000281a:	00000097          	auipc	ra,0x0
    8000281e:	e4a080e7          	jalr	-438(ra) # 80002664 <balloc>
    80002822:	0005099b          	sext.w	s3,a0
    80002826:	0534a823          	sw	s3,80(s1)
    8000282a:	b7e9                	j	800027f4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000282c:	4108                	lw	a0,0(a0)
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	e36080e7          	jalr	-458(ra) # 80002664 <balloc>
    80002836:	0005059b          	sext.w	a1,a0
    8000283a:	08b92023          	sw	a1,128(s2)
    8000283e:	b759                	j	800027c4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002840:	00092503          	lw	a0,0(s2)
    80002844:	00000097          	auipc	ra,0x0
    80002848:	e20080e7          	jalr	-480(ra) # 80002664 <balloc>
    8000284c:	0005099b          	sext.w	s3,a0
    80002850:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002854:	8552                	mv	a0,s4
    80002856:	00001097          	auipc	ra,0x1
    8000285a:	ef8080e7          	jalr	-264(ra) # 8000374e <log_write>
    8000285e:	b771                	j	800027ea <bmap+0x54>
  panic("bmap: out of range");
    80002860:	00006517          	auipc	a0,0x6
    80002864:	e1050513          	addi	a0,a0,-496 # 80008670 <syscall_names+0x120>
    80002868:	00003097          	auipc	ra,0x3
    8000286c:	3f0080e7          	jalr	1008(ra) # 80005c58 <panic>

0000000080002870 <iget>:
{
    80002870:	7179                	addi	sp,sp,-48
    80002872:	f406                	sd	ra,40(sp)
    80002874:	f022                	sd	s0,32(sp)
    80002876:	ec26                	sd	s1,24(sp)
    80002878:	e84a                	sd	s2,16(sp)
    8000287a:	e44e                	sd	s3,8(sp)
    8000287c:	e052                	sd	s4,0(sp)
    8000287e:	1800                	addi	s0,sp,48
    80002880:	89aa                	mv	s3,a0
    80002882:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002884:	00015517          	auipc	a0,0x15
    80002888:	ef450513          	addi	a0,a0,-268 # 80017778 <itable>
    8000288c:	00004097          	auipc	ra,0x4
    80002890:	916080e7          	jalr	-1770(ra) # 800061a2 <acquire>
  empty = 0;
    80002894:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002896:	00015497          	auipc	s1,0x15
    8000289a:	efa48493          	addi	s1,s1,-262 # 80017790 <itable+0x18>
    8000289e:	00017697          	auipc	a3,0x17
    800028a2:	98268693          	addi	a3,a3,-1662 # 80019220 <log>
    800028a6:	a039                	j	800028b4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028a8:	02090b63          	beqz	s2,800028de <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ac:	08848493          	addi	s1,s1,136
    800028b0:	02d48a63          	beq	s1,a3,800028e4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028b4:	449c                	lw	a5,8(s1)
    800028b6:	fef059e3          	blez	a5,800028a8 <iget+0x38>
    800028ba:	4098                	lw	a4,0(s1)
    800028bc:	ff3716e3          	bne	a4,s3,800028a8 <iget+0x38>
    800028c0:	40d8                	lw	a4,4(s1)
    800028c2:	ff4713e3          	bne	a4,s4,800028a8 <iget+0x38>
      ip->ref++;
    800028c6:	2785                	addiw	a5,a5,1
    800028c8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ca:	00015517          	auipc	a0,0x15
    800028ce:	eae50513          	addi	a0,a0,-338 # 80017778 <itable>
    800028d2:	00004097          	auipc	ra,0x4
    800028d6:	984080e7          	jalr	-1660(ra) # 80006256 <release>
      return ip;
    800028da:	8926                	mv	s2,s1
    800028dc:	a03d                	j	8000290a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028de:	f7f9                	bnez	a5,800028ac <iget+0x3c>
    800028e0:	8926                	mv	s2,s1
    800028e2:	b7e9                	j	800028ac <iget+0x3c>
  if(empty == 0)
    800028e4:	02090c63          	beqz	s2,8000291c <iget+0xac>
  ip->dev = dev;
    800028e8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800028ec:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800028f0:	4785                	li	a5,1
    800028f2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800028f6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800028fa:	00015517          	auipc	a0,0x15
    800028fe:	e7e50513          	addi	a0,a0,-386 # 80017778 <itable>
    80002902:	00004097          	auipc	ra,0x4
    80002906:	954080e7          	jalr	-1708(ra) # 80006256 <release>
}
    8000290a:	854a                	mv	a0,s2
    8000290c:	70a2                	ld	ra,40(sp)
    8000290e:	7402                	ld	s0,32(sp)
    80002910:	64e2                	ld	s1,24(sp)
    80002912:	6942                	ld	s2,16(sp)
    80002914:	69a2                	ld	s3,8(sp)
    80002916:	6a02                	ld	s4,0(sp)
    80002918:	6145                	addi	sp,sp,48
    8000291a:	8082                	ret
    panic("iget: no inodes");
    8000291c:	00006517          	auipc	a0,0x6
    80002920:	d6c50513          	addi	a0,a0,-660 # 80008688 <syscall_names+0x138>
    80002924:	00003097          	auipc	ra,0x3
    80002928:	334080e7          	jalr	820(ra) # 80005c58 <panic>

000000008000292c <fsinit>:
fsinit(int dev) {
    8000292c:	7179                	addi	sp,sp,-48
    8000292e:	f406                	sd	ra,40(sp)
    80002930:	f022                	sd	s0,32(sp)
    80002932:	ec26                	sd	s1,24(sp)
    80002934:	e84a                	sd	s2,16(sp)
    80002936:	e44e                	sd	s3,8(sp)
    80002938:	1800                	addi	s0,sp,48
    8000293a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000293c:	4585                	li	a1,1
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	a64080e7          	jalr	-1436(ra) # 800023a2 <bread>
    80002946:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002948:	00015997          	auipc	s3,0x15
    8000294c:	e1098993          	addi	s3,s3,-496 # 80017758 <sb>
    80002950:	02000613          	li	a2,32
    80002954:	05850593          	addi	a1,a0,88
    80002958:	854e                	mv	a0,s3
    8000295a:	ffffe097          	auipc	ra,0xffffe
    8000295e:	8a2080e7          	jalr	-1886(ra) # 800001fc <memmove>
  brelse(bp);
    80002962:	8526                	mv	a0,s1
    80002964:	00000097          	auipc	ra,0x0
    80002968:	b6e080e7          	jalr	-1170(ra) # 800024d2 <brelse>
  if(sb.magic != FSMAGIC)
    8000296c:	0009a703          	lw	a4,0(s3)
    80002970:	102037b7          	lui	a5,0x10203
    80002974:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002978:	02f71263          	bne	a4,a5,8000299c <fsinit+0x70>
  initlog(dev, &sb);
    8000297c:	00015597          	auipc	a1,0x15
    80002980:	ddc58593          	addi	a1,a1,-548 # 80017758 <sb>
    80002984:	854a                	mv	a0,s2
    80002986:	00001097          	auipc	ra,0x1
    8000298a:	b4c080e7          	jalr	-1204(ra) # 800034d2 <initlog>
}
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	69a2                	ld	s3,8(sp)
    80002998:	6145                	addi	sp,sp,48
    8000299a:	8082                	ret
    panic("invalid file system");
    8000299c:	00006517          	auipc	a0,0x6
    800029a0:	cfc50513          	addi	a0,a0,-772 # 80008698 <syscall_names+0x148>
    800029a4:	00003097          	auipc	ra,0x3
    800029a8:	2b4080e7          	jalr	692(ra) # 80005c58 <panic>

00000000800029ac <iinit>:
{
    800029ac:	7179                	addi	sp,sp,-48
    800029ae:	f406                	sd	ra,40(sp)
    800029b0:	f022                	sd	s0,32(sp)
    800029b2:	ec26                	sd	s1,24(sp)
    800029b4:	e84a                	sd	s2,16(sp)
    800029b6:	e44e                	sd	s3,8(sp)
    800029b8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ba:	00006597          	auipc	a1,0x6
    800029be:	cf658593          	addi	a1,a1,-778 # 800086b0 <syscall_names+0x160>
    800029c2:	00015517          	auipc	a0,0x15
    800029c6:	db650513          	addi	a0,a0,-586 # 80017778 <itable>
    800029ca:	00003097          	auipc	ra,0x3
    800029ce:	748080e7          	jalr	1864(ra) # 80006112 <initlock>
  for(i = 0; i < NINODE; i++) {
    800029d2:	00015497          	auipc	s1,0x15
    800029d6:	dce48493          	addi	s1,s1,-562 # 800177a0 <itable+0x28>
    800029da:	00017997          	auipc	s3,0x17
    800029de:	85698993          	addi	s3,s3,-1962 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800029e2:	00006917          	auipc	s2,0x6
    800029e6:	cd690913          	addi	s2,s2,-810 # 800086b8 <syscall_names+0x168>
    800029ea:	85ca                	mv	a1,s2
    800029ec:	8526                	mv	a0,s1
    800029ee:	00001097          	auipc	ra,0x1
    800029f2:	e46080e7          	jalr	-442(ra) # 80003834 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800029f6:	08848493          	addi	s1,s1,136
    800029fa:	ff3498e3          	bne	s1,s3,800029ea <iinit+0x3e>
}
    800029fe:	70a2                	ld	ra,40(sp)
    80002a00:	7402                	ld	s0,32(sp)
    80002a02:	64e2                	ld	s1,24(sp)
    80002a04:	6942                	ld	s2,16(sp)
    80002a06:	69a2                	ld	s3,8(sp)
    80002a08:	6145                	addi	sp,sp,48
    80002a0a:	8082                	ret

0000000080002a0c <ialloc>:
{
    80002a0c:	715d                	addi	sp,sp,-80
    80002a0e:	e486                	sd	ra,72(sp)
    80002a10:	e0a2                	sd	s0,64(sp)
    80002a12:	fc26                	sd	s1,56(sp)
    80002a14:	f84a                	sd	s2,48(sp)
    80002a16:	f44e                	sd	s3,40(sp)
    80002a18:	f052                	sd	s4,32(sp)
    80002a1a:	ec56                	sd	s5,24(sp)
    80002a1c:	e85a                	sd	s6,16(sp)
    80002a1e:	e45e                	sd	s7,8(sp)
    80002a20:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a22:	00015717          	auipc	a4,0x15
    80002a26:	d4272703          	lw	a4,-702(a4) # 80017764 <sb+0xc>
    80002a2a:	4785                	li	a5,1
    80002a2c:	04e7fa63          	bgeu	a5,a4,80002a80 <ialloc+0x74>
    80002a30:	8aaa                	mv	s5,a0
    80002a32:	8bae                	mv	s7,a1
    80002a34:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a36:	00015a17          	auipc	s4,0x15
    80002a3a:	d22a0a13          	addi	s4,s4,-734 # 80017758 <sb>
    80002a3e:	00048b1b          	sext.w	s6,s1
    80002a42:	0044d593          	srli	a1,s1,0x4
    80002a46:	018a2783          	lw	a5,24(s4)
    80002a4a:	9dbd                	addw	a1,a1,a5
    80002a4c:	8556                	mv	a0,s5
    80002a4e:	00000097          	auipc	ra,0x0
    80002a52:	954080e7          	jalr	-1708(ra) # 800023a2 <bread>
    80002a56:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a58:	05850993          	addi	s3,a0,88
    80002a5c:	00f4f793          	andi	a5,s1,15
    80002a60:	079a                	slli	a5,a5,0x6
    80002a62:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a64:	00099783          	lh	a5,0(s3)
    80002a68:	c785                	beqz	a5,80002a90 <ialloc+0x84>
    brelse(bp);
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	a68080e7          	jalr	-1432(ra) # 800024d2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a72:	0485                	addi	s1,s1,1
    80002a74:	00ca2703          	lw	a4,12(s4)
    80002a78:	0004879b          	sext.w	a5,s1
    80002a7c:	fce7e1e3          	bltu	a5,a4,80002a3e <ialloc+0x32>
  panic("ialloc: no inodes");
    80002a80:	00006517          	auipc	a0,0x6
    80002a84:	c4050513          	addi	a0,a0,-960 # 800086c0 <syscall_names+0x170>
    80002a88:	00003097          	auipc	ra,0x3
    80002a8c:	1d0080e7          	jalr	464(ra) # 80005c58 <panic>
      memset(dip, 0, sizeof(*dip));
    80002a90:	04000613          	li	a2,64
    80002a94:	4581                	li	a1,0
    80002a96:	854e                	mv	a0,s3
    80002a98:	ffffd097          	auipc	ra,0xffffd
    80002a9c:	704080e7          	jalr	1796(ra) # 8000019c <memset>
      dip->type = type;
    80002aa0:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aa4:	854a                	mv	a0,s2
    80002aa6:	00001097          	auipc	ra,0x1
    80002aaa:	ca8080e7          	jalr	-856(ra) # 8000374e <log_write>
      brelse(bp);
    80002aae:	854a                	mv	a0,s2
    80002ab0:	00000097          	auipc	ra,0x0
    80002ab4:	a22080e7          	jalr	-1502(ra) # 800024d2 <brelse>
      return iget(dev, inum);
    80002ab8:	85da                	mv	a1,s6
    80002aba:	8556                	mv	a0,s5
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	db4080e7          	jalr	-588(ra) # 80002870 <iget>
}
    80002ac4:	60a6                	ld	ra,72(sp)
    80002ac6:	6406                	ld	s0,64(sp)
    80002ac8:	74e2                	ld	s1,56(sp)
    80002aca:	7942                	ld	s2,48(sp)
    80002acc:	79a2                	ld	s3,40(sp)
    80002ace:	7a02                	ld	s4,32(sp)
    80002ad0:	6ae2                	ld	s5,24(sp)
    80002ad2:	6b42                	ld	s6,16(sp)
    80002ad4:	6ba2                	ld	s7,8(sp)
    80002ad6:	6161                	addi	sp,sp,80
    80002ad8:	8082                	ret

0000000080002ada <iupdate>:
{
    80002ada:	1101                	addi	sp,sp,-32
    80002adc:	ec06                	sd	ra,24(sp)
    80002ade:	e822                	sd	s0,16(sp)
    80002ae0:	e426                	sd	s1,8(sp)
    80002ae2:	e04a                	sd	s2,0(sp)
    80002ae4:	1000                	addi	s0,sp,32
    80002ae6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ae8:	415c                	lw	a5,4(a0)
    80002aea:	0047d79b          	srliw	a5,a5,0x4
    80002aee:	00015597          	auipc	a1,0x15
    80002af2:	c825a583          	lw	a1,-894(a1) # 80017770 <sb+0x18>
    80002af6:	9dbd                	addw	a1,a1,a5
    80002af8:	4108                	lw	a0,0(a0)
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	8a8080e7          	jalr	-1880(ra) # 800023a2 <bread>
    80002b02:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b04:	05850793          	addi	a5,a0,88
    80002b08:	40c8                	lw	a0,4(s1)
    80002b0a:	893d                	andi	a0,a0,15
    80002b0c:	051a                	slli	a0,a0,0x6
    80002b0e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b10:	04449703          	lh	a4,68(s1)
    80002b14:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b18:	04649703          	lh	a4,70(s1)
    80002b1c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b20:	04849703          	lh	a4,72(s1)
    80002b24:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b28:	04a49703          	lh	a4,74(s1)
    80002b2c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b30:	44f8                	lw	a4,76(s1)
    80002b32:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b34:	03400613          	li	a2,52
    80002b38:	05048593          	addi	a1,s1,80
    80002b3c:	0531                	addi	a0,a0,12
    80002b3e:	ffffd097          	auipc	ra,0xffffd
    80002b42:	6be080e7          	jalr	1726(ra) # 800001fc <memmove>
  log_write(bp);
    80002b46:	854a                	mv	a0,s2
    80002b48:	00001097          	auipc	ra,0x1
    80002b4c:	c06080e7          	jalr	-1018(ra) # 8000374e <log_write>
  brelse(bp);
    80002b50:	854a                	mv	a0,s2
    80002b52:	00000097          	auipc	ra,0x0
    80002b56:	980080e7          	jalr	-1664(ra) # 800024d2 <brelse>
}
    80002b5a:	60e2                	ld	ra,24(sp)
    80002b5c:	6442                	ld	s0,16(sp)
    80002b5e:	64a2                	ld	s1,8(sp)
    80002b60:	6902                	ld	s2,0(sp)
    80002b62:	6105                	addi	sp,sp,32
    80002b64:	8082                	ret

0000000080002b66 <idup>:
{
    80002b66:	1101                	addi	sp,sp,-32
    80002b68:	ec06                	sd	ra,24(sp)
    80002b6a:	e822                	sd	s0,16(sp)
    80002b6c:	e426                	sd	s1,8(sp)
    80002b6e:	1000                	addi	s0,sp,32
    80002b70:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b72:	00015517          	auipc	a0,0x15
    80002b76:	c0650513          	addi	a0,a0,-1018 # 80017778 <itable>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	628080e7          	jalr	1576(ra) # 800061a2 <acquire>
  ip->ref++;
    80002b82:	449c                	lw	a5,8(s1)
    80002b84:	2785                	addiw	a5,a5,1
    80002b86:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b88:	00015517          	auipc	a0,0x15
    80002b8c:	bf050513          	addi	a0,a0,-1040 # 80017778 <itable>
    80002b90:	00003097          	auipc	ra,0x3
    80002b94:	6c6080e7          	jalr	1734(ra) # 80006256 <release>
}
    80002b98:	8526                	mv	a0,s1
    80002b9a:	60e2                	ld	ra,24(sp)
    80002b9c:	6442                	ld	s0,16(sp)
    80002b9e:	64a2                	ld	s1,8(sp)
    80002ba0:	6105                	addi	sp,sp,32
    80002ba2:	8082                	ret

0000000080002ba4 <ilock>:
{
    80002ba4:	1101                	addi	sp,sp,-32
    80002ba6:	ec06                	sd	ra,24(sp)
    80002ba8:	e822                	sd	s0,16(sp)
    80002baa:	e426                	sd	s1,8(sp)
    80002bac:	e04a                	sd	s2,0(sp)
    80002bae:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bb0:	c115                	beqz	a0,80002bd4 <ilock+0x30>
    80002bb2:	84aa                	mv	s1,a0
    80002bb4:	451c                	lw	a5,8(a0)
    80002bb6:	00f05f63          	blez	a5,80002bd4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bba:	0541                	addi	a0,a0,16
    80002bbc:	00001097          	auipc	ra,0x1
    80002bc0:	cb2080e7          	jalr	-846(ra) # 8000386e <acquiresleep>
  if(ip->valid == 0){
    80002bc4:	40bc                	lw	a5,64(s1)
    80002bc6:	cf99                	beqz	a5,80002be4 <ilock+0x40>
}
    80002bc8:	60e2                	ld	ra,24(sp)
    80002bca:	6442                	ld	s0,16(sp)
    80002bcc:	64a2                	ld	s1,8(sp)
    80002bce:	6902                	ld	s2,0(sp)
    80002bd0:	6105                	addi	sp,sp,32
    80002bd2:	8082                	ret
    panic("ilock");
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	b0450513          	addi	a0,a0,-1276 # 800086d8 <syscall_names+0x188>
    80002bdc:	00003097          	auipc	ra,0x3
    80002be0:	07c080e7          	jalr	124(ra) # 80005c58 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be4:	40dc                	lw	a5,4(s1)
    80002be6:	0047d79b          	srliw	a5,a5,0x4
    80002bea:	00015597          	auipc	a1,0x15
    80002bee:	b865a583          	lw	a1,-1146(a1) # 80017770 <sb+0x18>
    80002bf2:	9dbd                	addw	a1,a1,a5
    80002bf4:	4088                	lw	a0,0(s1)
    80002bf6:	fffff097          	auipc	ra,0xfffff
    80002bfa:	7ac080e7          	jalr	1964(ra) # 800023a2 <bread>
    80002bfe:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c00:	05850593          	addi	a1,a0,88
    80002c04:	40dc                	lw	a5,4(s1)
    80002c06:	8bbd                	andi	a5,a5,15
    80002c08:	079a                	slli	a5,a5,0x6
    80002c0a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c0c:	00059783          	lh	a5,0(a1)
    80002c10:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c14:	00259783          	lh	a5,2(a1)
    80002c18:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c1c:	00459783          	lh	a5,4(a1)
    80002c20:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c24:	00659783          	lh	a5,6(a1)
    80002c28:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c2c:	459c                	lw	a5,8(a1)
    80002c2e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c30:	03400613          	li	a2,52
    80002c34:	05b1                	addi	a1,a1,12
    80002c36:	05048513          	addi	a0,s1,80
    80002c3a:	ffffd097          	auipc	ra,0xffffd
    80002c3e:	5c2080e7          	jalr	1474(ra) # 800001fc <memmove>
    brelse(bp);
    80002c42:	854a                	mv	a0,s2
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	88e080e7          	jalr	-1906(ra) # 800024d2 <brelse>
    ip->valid = 1;
    80002c4c:	4785                	li	a5,1
    80002c4e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c50:	04449783          	lh	a5,68(s1)
    80002c54:	fbb5                	bnez	a5,80002bc8 <ilock+0x24>
      panic("ilock: no type");
    80002c56:	00006517          	auipc	a0,0x6
    80002c5a:	a8a50513          	addi	a0,a0,-1398 # 800086e0 <syscall_names+0x190>
    80002c5e:	00003097          	auipc	ra,0x3
    80002c62:	ffa080e7          	jalr	-6(ra) # 80005c58 <panic>

0000000080002c66 <iunlock>:
{
    80002c66:	1101                	addi	sp,sp,-32
    80002c68:	ec06                	sd	ra,24(sp)
    80002c6a:	e822                	sd	s0,16(sp)
    80002c6c:	e426                	sd	s1,8(sp)
    80002c6e:	e04a                	sd	s2,0(sp)
    80002c70:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c72:	c905                	beqz	a0,80002ca2 <iunlock+0x3c>
    80002c74:	84aa                	mv	s1,a0
    80002c76:	01050913          	addi	s2,a0,16
    80002c7a:	854a                	mv	a0,s2
    80002c7c:	00001097          	auipc	ra,0x1
    80002c80:	c8c080e7          	jalr	-884(ra) # 80003908 <holdingsleep>
    80002c84:	cd19                	beqz	a0,80002ca2 <iunlock+0x3c>
    80002c86:	449c                	lw	a5,8(s1)
    80002c88:	00f05d63          	blez	a5,80002ca2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c8c:	854a                	mv	a0,s2
    80002c8e:	00001097          	auipc	ra,0x1
    80002c92:	c36080e7          	jalr	-970(ra) # 800038c4 <releasesleep>
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	64a2                	ld	s1,8(sp)
    80002c9c:	6902                	ld	s2,0(sp)
    80002c9e:	6105                	addi	sp,sp,32
    80002ca0:	8082                	ret
    panic("iunlock");
    80002ca2:	00006517          	auipc	a0,0x6
    80002ca6:	a4e50513          	addi	a0,a0,-1458 # 800086f0 <syscall_names+0x1a0>
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	fae080e7          	jalr	-82(ra) # 80005c58 <panic>

0000000080002cb2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cb2:	7179                	addi	sp,sp,-48
    80002cb4:	f406                	sd	ra,40(sp)
    80002cb6:	f022                	sd	s0,32(sp)
    80002cb8:	ec26                	sd	s1,24(sp)
    80002cba:	e84a                	sd	s2,16(sp)
    80002cbc:	e44e                	sd	s3,8(sp)
    80002cbe:	e052                	sd	s4,0(sp)
    80002cc0:	1800                	addi	s0,sp,48
    80002cc2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cc4:	05050493          	addi	s1,a0,80
    80002cc8:	08050913          	addi	s2,a0,128
    80002ccc:	a021                	j	80002cd4 <itrunc+0x22>
    80002cce:	0491                	addi	s1,s1,4
    80002cd0:	01248d63          	beq	s1,s2,80002cea <itrunc+0x38>
    if(ip->addrs[i]){
    80002cd4:	408c                	lw	a1,0(s1)
    80002cd6:	dde5                	beqz	a1,80002cce <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002cd8:	0009a503          	lw	a0,0(s3)
    80002cdc:	00000097          	auipc	ra,0x0
    80002ce0:	90c080e7          	jalr	-1780(ra) # 800025e8 <bfree>
      ip->addrs[i] = 0;
    80002ce4:	0004a023          	sw	zero,0(s1)
    80002ce8:	b7dd                	j	80002cce <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002cea:	0809a583          	lw	a1,128(s3)
    80002cee:	e185                	bnez	a1,80002d0e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002cf0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002cf4:	854e                	mv	a0,s3
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	de4080e7          	jalr	-540(ra) # 80002ada <iupdate>
}
    80002cfe:	70a2                	ld	ra,40(sp)
    80002d00:	7402                	ld	s0,32(sp)
    80002d02:	64e2                	ld	s1,24(sp)
    80002d04:	6942                	ld	s2,16(sp)
    80002d06:	69a2                	ld	s3,8(sp)
    80002d08:	6a02                	ld	s4,0(sp)
    80002d0a:	6145                	addi	sp,sp,48
    80002d0c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d0e:	0009a503          	lw	a0,0(s3)
    80002d12:	fffff097          	auipc	ra,0xfffff
    80002d16:	690080e7          	jalr	1680(ra) # 800023a2 <bread>
    80002d1a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d1c:	05850493          	addi	s1,a0,88
    80002d20:	45850913          	addi	s2,a0,1112
    80002d24:	a811                	j	80002d38 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d26:	0009a503          	lw	a0,0(s3)
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	8be080e7          	jalr	-1858(ra) # 800025e8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d32:	0491                	addi	s1,s1,4
    80002d34:	01248563          	beq	s1,s2,80002d3e <itrunc+0x8c>
      if(a[j])
    80002d38:	408c                	lw	a1,0(s1)
    80002d3a:	dde5                	beqz	a1,80002d32 <itrunc+0x80>
    80002d3c:	b7ed                	j	80002d26 <itrunc+0x74>
    brelse(bp);
    80002d3e:	8552                	mv	a0,s4
    80002d40:	fffff097          	auipc	ra,0xfffff
    80002d44:	792080e7          	jalr	1938(ra) # 800024d2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d48:	0809a583          	lw	a1,128(s3)
    80002d4c:	0009a503          	lw	a0,0(s3)
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	898080e7          	jalr	-1896(ra) # 800025e8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d58:	0809a023          	sw	zero,128(s3)
    80002d5c:	bf51                	j	80002cf0 <itrunc+0x3e>

0000000080002d5e <iput>:
{
    80002d5e:	1101                	addi	sp,sp,-32
    80002d60:	ec06                	sd	ra,24(sp)
    80002d62:	e822                	sd	s0,16(sp)
    80002d64:	e426                	sd	s1,8(sp)
    80002d66:	e04a                	sd	s2,0(sp)
    80002d68:	1000                	addi	s0,sp,32
    80002d6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d6c:	00015517          	auipc	a0,0x15
    80002d70:	a0c50513          	addi	a0,a0,-1524 # 80017778 <itable>
    80002d74:	00003097          	auipc	ra,0x3
    80002d78:	42e080e7          	jalr	1070(ra) # 800061a2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d7c:	4498                	lw	a4,8(s1)
    80002d7e:	4785                	li	a5,1
    80002d80:	02f70363          	beq	a4,a5,80002da6 <iput+0x48>
  ip->ref--;
    80002d84:	449c                	lw	a5,8(s1)
    80002d86:	37fd                	addiw	a5,a5,-1
    80002d88:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d8a:	00015517          	auipc	a0,0x15
    80002d8e:	9ee50513          	addi	a0,a0,-1554 # 80017778 <itable>
    80002d92:	00003097          	auipc	ra,0x3
    80002d96:	4c4080e7          	jalr	1220(ra) # 80006256 <release>
}
    80002d9a:	60e2                	ld	ra,24(sp)
    80002d9c:	6442                	ld	s0,16(sp)
    80002d9e:	64a2                	ld	s1,8(sp)
    80002da0:	6902                	ld	s2,0(sp)
    80002da2:	6105                	addi	sp,sp,32
    80002da4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002da6:	40bc                	lw	a5,64(s1)
    80002da8:	dff1                	beqz	a5,80002d84 <iput+0x26>
    80002daa:	04a49783          	lh	a5,74(s1)
    80002dae:	fbf9                	bnez	a5,80002d84 <iput+0x26>
    acquiresleep(&ip->lock);
    80002db0:	01048913          	addi	s2,s1,16
    80002db4:	854a                	mv	a0,s2
    80002db6:	00001097          	auipc	ra,0x1
    80002dba:	ab8080e7          	jalr	-1352(ra) # 8000386e <acquiresleep>
    release(&itable.lock);
    80002dbe:	00015517          	auipc	a0,0x15
    80002dc2:	9ba50513          	addi	a0,a0,-1606 # 80017778 <itable>
    80002dc6:	00003097          	auipc	ra,0x3
    80002dca:	490080e7          	jalr	1168(ra) # 80006256 <release>
    itrunc(ip);
    80002dce:	8526                	mv	a0,s1
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	ee2080e7          	jalr	-286(ra) # 80002cb2 <itrunc>
    ip->type = 0;
    80002dd8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ddc:	8526                	mv	a0,s1
    80002dde:	00000097          	auipc	ra,0x0
    80002de2:	cfc080e7          	jalr	-772(ra) # 80002ada <iupdate>
    ip->valid = 0;
    80002de6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002dea:	854a                	mv	a0,s2
    80002dec:	00001097          	auipc	ra,0x1
    80002df0:	ad8080e7          	jalr	-1320(ra) # 800038c4 <releasesleep>
    acquire(&itable.lock);
    80002df4:	00015517          	auipc	a0,0x15
    80002df8:	98450513          	addi	a0,a0,-1660 # 80017778 <itable>
    80002dfc:	00003097          	auipc	ra,0x3
    80002e00:	3a6080e7          	jalr	934(ra) # 800061a2 <acquire>
    80002e04:	b741                	j	80002d84 <iput+0x26>

0000000080002e06 <iunlockput>:
{
    80002e06:	1101                	addi	sp,sp,-32
    80002e08:	ec06                	sd	ra,24(sp)
    80002e0a:	e822                	sd	s0,16(sp)
    80002e0c:	e426                	sd	s1,8(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	e54080e7          	jalr	-428(ra) # 80002c66 <iunlock>
  iput(ip);
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	00000097          	auipc	ra,0x0
    80002e20:	f42080e7          	jalr	-190(ra) # 80002d5e <iput>
}
    80002e24:	60e2                	ld	ra,24(sp)
    80002e26:	6442                	ld	s0,16(sp)
    80002e28:	64a2                	ld	s1,8(sp)
    80002e2a:	6105                	addi	sp,sp,32
    80002e2c:	8082                	ret

0000000080002e2e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e2e:	1141                	addi	sp,sp,-16
    80002e30:	e422                	sd	s0,8(sp)
    80002e32:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e34:	411c                	lw	a5,0(a0)
    80002e36:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e38:	415c                	lw	a5,4(a0)
    80002e3a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e3c:	04451783          	lh	a5,68(a0)
    80002e40:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e44:	04a51783          	lh	a5,74(a0)
    80002e48:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e4c:	04c56783          	lwu	a5,76(a0)
    80002e50:	e99c                	sd	a5,16(a1)
}
    80002e52:	6422                	ld	s0,8(sp)
    80002e54:	0141                	addi	sp,sp,16
    80002e56:	8082                	ret

0000000080002e58 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e58:	457c                	lw	a5,76(a0)
    80002e5a:	0ed7e963          	bltu	a5,a3,80002f4c <readi+0xf4>
{
    80002e5e:	7159                	addi	sp,sp,-112
    80002e60:	f486                	sd	ra,104(sp)
    80002e62:	f0a2                	sd	s0,96(sp)
    80002e64:	eca6                	sd	s1,88(sp)
    80002e66:	e8ca                	sd	s2,80(sp)
    80002e68:	e4ce                	sd	s3,72(sp)
    80002e6a:	e0d2                	sd	s4,64(sp)
    80002e6c:	fc56                	sd	s5,56(sp)
    80002e6e:	f85a                	sd	s6,48(sp)
    80002e70:	f45e                	sd	s7,40(sp)
    80002e72:	f062                	sd	s8,32(sp)
    80002e74:	ec66                	sd	s9,24(sp)
    80002e76:	e86a                	sd	s10,16(sp)
    80002e78:	e46e                	sd	s11,8(sp)
    80002e7a:	1880                	addi	s0,sp,112
    80002e7c:	8baa                	mv	s7,a0
    80002e7e:	8c2e                	mv	s8,a1
    80002e80:	8ab2                	mv	s5,a2
    80002e82:	84b6                	mv	s1,a3
    80002e84:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e86:	9f35                	addw	a4,a4,a3
    return 0;
    80002e88:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e8a:	0ad76063          	bltu	a4,a3,80002f2a <readi+0xd2>
  if(off + n > ip->size)
    80002e8e:	00e7f463          	bgeu	a5,a4,80002e96 <readi+0x3e>
    n = ip->size - off;
    80002e92:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e96:	0a0b0963          	beqz	s6,80002f48 <readi+0xf0>
    80002e9a:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e9c:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ea0:	5cfd                	li	s9,-1
    80002ea2:	a82d                	j	80002edc <readi+0x84>
    80002ea4:	020a1d93          	slli	s11,s4,0x20
    80002ea8:	020ddd93          	srli	s11,s11,0x20
    80002eac:	05890613          	addi	a2,s2,88
    80002eb0:	86ee                	mv	a3,s11
    80002eb2:	963a                	add	a2,a2,a4
    80002eb4:	85d6                	mv	a1,s5
    80002eb6:	8562                	mv	a0,s8
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	a20080e7          	jalr	-1504(ra) # 800018d8 <either_copyout>
    80002ec0:	05950d63          	beq	a0,s9,80002f1a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ec4:	854a                	mv	a0,s2
    80002ec6:	fffff097          	auipc	ra,0xfffff
    80002eca:	60c080e7          	jalr	1548(ra) # 800024d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ece:	013a09bb          	addw	s3,s4,s3
    80002ed2:	009a04bb          	addw	s1,s4,s1
    80002ed6:	9aee                	add	s5,s5,s11
    80002ed8:	0569f763          	bgeu	s3,s6,80002f26 <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002edc:	000ba903          	lw	s2,0(s7)
    80002ee0:	00a4d59b          	srliw	a1,s1,0xa
    80002ee4:	855e                	mv	a0,s7
    80002ee6:	00000097          	auipc	ra,0x0
    80002eea:	8b0080e7          	jalr	-1872(ra) # 80002796 <bmap>
    80002eee:	0005059b          	sext.w	a1,a0
    80002ef2:	854a                	mv	a0,s2
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	4ae080e7          	jalr	1198(ra) # 800023a2 <bread>
    80002efc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002efe:	3ff4f713          	andi	a4,s1,1023
    80002f02:	40ed07bb          	subw	a5,s10,a4
    80002f06:	413b06bb          	subw	a3,s6,s3
    80002f0a:	8a3e                	mv	s4,a5
    80002f0c:	2781                	sext.w	a5,a5
    80002f0e:	0006861b          	sext.w	a2,a3
    80002f12:	f8f679e3          	bgeu	a2,a5,80002ea4 <readi+0x4c>
    80002f16:	8a36                	mv	s4,a3
    80002f18:	b771                	j	80002ea4 <readi+0x4c>
      brelse(bp);
    80002f1a:	854a                	mv	a0,s2
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	5b6080e7          	jalr	1462(ra) # 800024d2 <brelse>
      tot = -1;
    80002f24:	59fd                	li	s3,-1
  }
  return tot;
    80002f26:	0009851b          	sext.w	a0,s3
}
    80002f2a:	70a6                	ld	ra,104(sp)
    80002f2c:	7406                	ld	s0,96(sp)
    80002f2e:	64e6                	ld	s1,88(sp)
    80002f30:	6946                	ld	s2,80(sp)
    80002f32:	69a6                	ld	s3,72(sp)
    80002f34:	6a06                	ld	s4,64(sp)
    80002f36:	7ae2                	ld	s5,56(sp)
    80002f38:	7b42                	ld	s6,48(sp)
    80002f3a:	7ba2                	ld	s7,40(sp)
    80002f3c:	7c02                	ld	s8,32(sp)
    80002f3e:	6ce2                	ld	s9,24(sp)
    80002f40:	6d42                	ld	s10,16(sp)
    80002f42:	6da2                	ld	s11,8(sp)
    80002f44:	6165                	addi	sp,sp,112
    80002f46:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f48:	89da                	mv	s3,s6
    80002f4a:	bff1                	j	80002f26 <readi+0xce>
    return 0;
    80002f4c:	4501                	li	a0,0
}
    80002f4e:	8082                	ret

0000000080002f50 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f50:	457c                	lw	a5,76(a0)
    80002f52:	10d7e863          	bltu	a5,a3,80003062 <writei+0x112>
{
    80002f56:	7159                	addi	sp,sp,-112
    80002f58:	f486                	sd	ra,104(sp)
    80002f5a:	f0a2                	sd	s0,96(sp)
    80002f5c:	eca6                	sd	s1,88(sp)
    80002f5e:	e8ca                	sd	s2,80(sp)
    80002f60:	e4ce                	sd	s3,72(sp)
    80002f62:	e0d2                	sd	s4,64(sp)
    80002f64:	fc56                	sd	s5,56(sp)
    80002f66:	f85a                	sd	s6,48(sp)
    80002f68:	f45e                	sd	s7,40(sp)
    80002f6a:	f062                	sd	s8,32(sp)
    80002f6c:	ec66                	sd	s9,24(sp)
    80002f6e:	e86a                	sd	s10,16(sp)
    80002f70:	e46e                	sd	s11,8(sp)
    80002f72:	1880                	addi	s0,sp,112
    80002f74:	8b2a                	mv	s6,a0
    80002f76:	8c2e                	mv	s8,a1
    80002f78:	8ab2                	mv	s5,a2
    80002f7a:	8936                	mv	s2,a3
    80002f7c:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f7e:	00e687bb          	addw	a5,a3,a4
    80002f82:	0ed7e263          	bltu	a5,a3,80003066 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f86:	00043737          	lui	a4,0x43
    80002f8a:	0ef76063          	bltu	a4,a5,8000306a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f8e:	0c0b8863          	beqz	s7,8000305e <writei+0x10e>
    80002f92:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f94:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f98:	5cfd                	li	s9,-1
    80002f9a:	a091                	j	80002fde <writei+0x8e>
    80002f9c:	02099d93          	slli	s11,s3,0x20
    80002fa0:	020ddd93          	srli	s11,s11,0x20
    80002fa4:	05848513          	addi	a0,s1,88
    80002fa8:	86ee                	mv	a3,s11
    80002faa:	8656                	mv	a2,s5
    80002fac:	85e2                	mv	a1,s8
    80002fae:	953a                	add	a0,a0,a4
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	97e080e7          	jalr	-1666(ra) # 8000192e <either_copyin>
    80002fb8:	07950263          	beq	a0,s9,8000301c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fbc:	8526                	mv	a0,s1
    80002fbe:	00000097          	auipc	ra,0x0
    80002fc2:	790080e7          	jalr	1936(ra) # 8000374e <log_write>
    brelse(bp);
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	fffff097          	auipc	ra,0xfffff
    80002fcc:	50a080e7          	jalr	1290(ra) # 800024d2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fd0:	01498a3b          	addw	s4,s3,s4
    80002fd4:	0129893b          	addw	s2,s3,s2
    80002fd8:	9aee                	add	s5,s5,s11
    80002fda:	057a7663          	bgeu	s4,s7,80003026 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002fde:	000b2483          	lw	s1,0(s6)
    80002fe2:	00a9559b          	srliw	a1,s2,0xa
    80002fe6:	855a                	mv	a0,s6
    80002fe8:	fffff097          	auipc	ra,0xfffff
    80002fec:	7ae080e7          	jalr	1966(ra) # 80002796 <bmap>
    80002ff0:	0005059b          	sext.w	a1,a0
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	fffff097          	auipc	ra,0xfffff
    80002ffa:	3ac080e7          	jalr	940(ra) # 800023a2 <bread>
    80002ffe:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003000:	3ff97713          	andi	a4,s2,1023
    80003004:	40ed07bb          	subw	a5,s10,a4
    80003008:	414b86bb          	subw	a3,s7,s4
    8000300c:	89be                	mv	s3,a5
    8000300e:	2781                	sext.w	a5,a5
    80003010:	0006861b          	sext.w	a2,a3
    80003014:	f8f674e3          	bgeu	a2,a5,80002f9c <writei+0x4c>
    80003018:	89b6                	mv	s3,a3
    8000301a:	b749                	j	80002f9c <writei+0x4c>
      brelse(bp);
    8000301c:	8526                	mv	a0,s1
    8000301e:	fffff097          	auipc	ra,0xfffff
    80003022:	4b4080e7          	jalr	1204(ra) # 800024d2 <brelse>
  }

  if(off > ip->size)
    80003026:	04cb2783          	lw	a5,76(s6)
    8000302a:	0127f463          	bgeu	a5,s2,80003032 <writei+0xe2>
    ip->size = off;
    8000302e:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003032:	855a                	mv	a0,s6
    80003034:	00000097          	auipc	ra,0x0
    80003038:	aa6080e7          	jalr	-1370(ra) # 80002ada <iupdate>

  return tot;
    8000303c:	000a051b          	sext.w	a0,s4
}
    80003040:	70a6                	ld	ra,104(sp)
    80003042:	7406                	ld	s0,96(sp)
    80003044:	64e6                	ld	s1,88(sp)
    80003046:	6946                	ld	s2,80(sp)
    80003048:	69a6                	ld	s3,72(sp)
    8000304a:	6a06                	ld	s4,64(sp)
    8000304c:	7ae2                	ld	s5,56(sp)
    8000304e:	7b42                	ld	s6,48(sp)
    80003050:	7ba2                	ld	s7,40(sp)
    80003052:	7c02                	ld	s8,32(sp)
    80003054:	6ce2                	ld	s9,24(sp)
    80003056:	6d42                	ld	s10,16(sp)
    80003058:	6da2                	ld	s11,8(sp)
    8000305a:	6165                	addi	sp,sp,112
    8000305c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000305e:	8a5e                	mv	s4,s7
    80003060:	bfc9                	j	80003032 <writei+0xe2>
    return -1;
    80003062:	557d                	li	a0,-1
}
    80003064:	8082                	ret
    return -1;
    80003066:	557d                	li	a0,-1
    80003068:	bfe1                	j	80003040 <writei+0xf0>
    return -1;
    8000306a:	557d                	li	a0,-1
    8000306c:	bfd1                	j	80003040 <writei+0xf0>

000000008000306e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000306e:	1141                	addi	sp,sp,-16
    80003070:	e406                	sd	ra,8(sp)
    80003072:	e022                	sd	s0,0(sp)
    80003074:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003076:	4639                	li	a2,14
    80003078:	ffffd097          	auipc	ra,0xffffd
    8000307c:	1fc080e7          	jalr	508(ra) # 80000274 <strncmp>
}
    80003080:	60a2                	ld	ra,8(sp)
    80003082:	6402                	ld	s0,0(sp)
    80003084:	0141                	addi	sp,sp,16
    80003086:	8082                	ret

0000000080003088 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003088:	7139                	addi	sp,sp,-64
    8000308a:	fc06                	sd	ra,56(sp)
    8000308c:	f822                	sd	s0,48(sp)
    8000308e:	f426                	sd	s1,40(sp)
    80003090:	f04a                	sd	s2,32(sp)
    80003092:	ec4e                	sd	s3,24(sp)
    80003094:	e852                	sd	s4,16(sp)
    80003096:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003098:	04451703          	lh	a4,68(a0)
    8000309c:	4785                	li	a5,1
    8000309e:	00f71a63          	bne	a4,a5,800030b2 <dirlookup+0x2a>
    800030a2:	892a                	mv	s2,a0
    800030a4:	89ae                	mv	s3,a1
    800030a6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a8:	457c                	lw	a5,76(a0)
    800030aa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030ac:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030ae:	e79d                	bnez	a5,800030dc <dirlookup+0x54>
    800030b0:	a8a5                	j	80003128 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030b2:	00005517          	auipc	a0,0x5
    800030b6:	64650513          	addi	a0,a0,1606 # 800086f8 <syscall_names+0x1a8>
    800030ba:	00003097          	auipc	ra,0x3
    800030be:	b9e080e7          	jalr	-1122(ra) # 80005c58 <panic>
      panic("dirlookup read");
    800030c2:	00005517          	auipc	a0,0x5
    800030c6:	64e50513          	addi	a0,a0,1614 # 80008710 <syscall_names+0x1c0>
    800030ca:	00003097          	auipc	ra,0x3
    800030ce:	b8e080e7          	jalr	-1138(ra) # 80005c58 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d2:	24c1                	addiw	s1,s1,16
    800030d4:	04c92783          	lw	a5,76(s2)
    800030d8:	04f4f763          	bgeu	s1,a5,80003126 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030dc:	4741                	li	a4,16
    800030de:	86a6                	mv	a3,s1
    800030e0:	fc040613          	addi	a2,s0,-64
    800030e4:	4581                	li	a1,0
    800030e6:	854a                	mv	a0,s2
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	d70080e7          	jalr	-656(ra) # 80002e58 <readi>
    800030f0:	47c1                	li	a5,16
    800030f2:	fcf518e3          	bne	a0,a5,800030c2 <dirlookup+0x3a>
    if(de.inum == 0)
    800030f6:	fc045783          	lhu	a5,-64(s0)
    800030fa:	dfe1                	beqz	a5,800030d2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030fc:	fc240593          	addi	a1,s0,-62
    80003100:	854e                	mv	a0,s3
    80003102:	00000097          	auipc	ra,0x0
    80003106:	f6c080e7          	jalr	-148(ra) # 8000306e <namecmp>
    8000310a:	f561                	bnez	a0,800030d2 <dirlookup+0x4a>
      if(poff)
    8000310c:	000a0463          	beqz	s4,80003114 <dirlookup+0x8c>
        *poff = off;
    80003110:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003114:	fc045583          	lhu	a1,-64(s0)
    80003118:	00092503          	lw	a0,0(s2)
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	754080e7          	jalr	1876(ra) # 80002870 <iget>
    80003124:	a011                	j	80003128 <dirlookup+0xa0>
  return 0;
    80003126:	4501                	li	a0,0
}
    80003128:	70e2                	ld	ra,56(sp)
    8000312a:	7442                	ld	s0,48(sp)
    8000312c:	74a2                	ld	s1,40(sp)
    8000312e:	7902                	ld	s2,32(sp)
    80003130:	69e2                	ld	s3,24(sp)
    80003132:	6a42                	ld	s4,16(sp)
    80003134:	6121                	addi	sp,sp,64
    80003136:	8082                	ret

0000000080003138 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003138:	711d                	addi	sp,sp,-96
    8000313a:	ec86                	sd	ra,88(sp)
    8000313c:	e8a2                	sd	s0,80(sp)
    8000313e:	e4a6                	sd	s1,72(sp)
    80003140:	e0ca                	sd	s2,64(sp)
    80003142:	fc4e                	sd	s3,56(sp)
    80003144:	f852                	sd	s4,48(sp)
    80003146:	f456                	sd	s5,40(sp)
    80003148:	f05a                	sd	s6,32(sp)
    8000314a:	ec5e                	sd	s7,24(sp)
    8000314c:	e862                	sd	s8,16(sp)
    8000314e:	e466                	sd	s9,8(sp)
    80003150:	1080                	addi	s0,sp,96
    80003152:	84aa                	mv	s1,a0
    80003154:	8b2e                	mv	s6,a1
    80003156:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003158:	00054703          	lbu	a4,0(a0)
    8000315c:	02f00793          	li	a5,47
    80003160:	02f70363          	beq	a4,a5,80003186 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003164:	ffffe097          	auipc	ra,0xffffe
    80003168:	d08080e7          	jalr	-760(ra) # 80000e6c <myproc>
    8000316c:	15053503          	ld	a0,336(a0)
    80003170:	00000097          	auipc	ra,0x0
    80003174:	9f6080e7          	jalr	-1546(ra) # 80002b66 <idup>
    80003178:	89aa                	mv	s3,a0
  while(*path == '/')
    8000317a:	02f00913          	li	s2,47
  len = path - s;
    8000317e:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003180:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003182:	4c05                	li	s8,1
    80003184:	a865                	j	8000323c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003186:	4585                	li	a1,1
    80003188:	4505                	li	a0,1
    8000318a:	fffff097          	auipc	ra,0xfffff
    8000318e:	6e6080e7          	jalr	1766(ra) # 80002870 <iget>
    80003192:	89aa                	mv	s3,a0
    80003194:	b7dd                	j	8000317a <namex+0x42>
      iunlockput(ip);
    80003196:	854e                	mv	a0,s3
    80003198:	00000097          	auipc	ra,0x0
    8000319c:	c6e080e7          	jalr	-914(ra) # 80002e06 <iunlockput>
      return 0;
    800031a0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031a2:	854e                	mv	a0,s3
    800031a4:	60e6                	ld	ra,88(sp)
    800031a6:	6446                	ld	s0,80(sp)
    800031a8:	64a6                	ld	s1,72(sp)
    800031aa:	6906                	ld	s2,64(sp)
    800031ac:	79e2                	ld	s3,56(sp)
    800031ae:	7a42                	ld	s4,48(sp)
    800031b0:	7aa2                	ld	s5,40(sp)
    800031b2:	7b02                	ld	s6,32(sp)
    800031b4:	6be2                	ld	s7,24(sp)
    800031b6:	6c42                	ld	s8,16(sp)
    800031b8:	6ca2                	ld	s9,8(sp)
    800031ba:	6125                	addi	sp,sp,96
    800031bc:	8082                	ret
      iunlock(ip);
    800031be:	854e                	mv	a0,s3
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	aa6080e7          	jalr	-1370(ra) # 80002c66 <iunlock>
      return ip;
    800031c8:	bfe9                	j	800031a2 <namex+0x6a>
      iunlockput(ip);
    800031ca:	854e                	mv	a0,s3
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	c3a080e7          	jalr	-966(ra) # 80002e06 <iunlockput>
      return 0;
    800031d4:	89d2                	mv	s3,s4
    800031d6:	b7f1                	j	800031a2 <namex+0x6a>
  len = path - s;
    800031d8:	40b48633          	sub	a2,s1,a1
    800031dc:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800031e0:	094cd463          	bge	s9,s4,80003268 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800031e4:	4639                	li	a2,14
    800031e6:	8556                	mv	a0,s5
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	014080e7          	jalr	20(ra) # 800001fc <memmove>
  while(*path == '/')
    800031f0:	0004c783          	lbu	a5,0(s1)
    800031f4:	01279763          	bne	a5,s2,80003202 <namex+0xca>
    path++;
    800031f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031fa:	0004c783          	lbu	a5,0(s1)
    800031fe:	ff278de3          	beq	a5,s2,800031f8 <namex+0xc0>
    ilock(ip);
    80003202:	854e                	mv	a0,s3
    80003204:	00000097          	auipc	ra,0x0
    80003208:	9a0080e7          	jalr	-1632(ra) # 80002ba4 <ilock>
    if(ip->type != T_DIR){
    8000320c:	04499783          	lh	a5,68(s3)
    80003210:	f98793e3          	bne	a5,s8,80003196 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003214:	000b0563          	beqz	s6,8000321e <namex+0xe6>
    80003218:	0004c783          	lbu	a5,0(s1)
    8000321c:	d3cd                	beqz	a5,800031be <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000321e:	865e                	mv	a2,s7
    80003220:	85d6                	mv	a1,s5
    80003222:	854e                	mv	a0,s3
    80003224:	00000097          	auipc	ra,0x0
    80003228:	e64080e7          	jalr	-412(ra) # 80003088 <dirlookup>
    8000322c:	8a2a                	mv	s4,a0
    8000322e:	dd51                	beqz	a0,800031ca <namex+0x92>
    iunlockput(ip);
    80003230:	854e                	mv	a0,s3
    80003232:	00000097          	auipc	ra,0x0
    80003236:	bd4080e7          	jalr	-1068(ra) # 80002e06 <iunlockput>
    ip = next;
    8000323a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000323c:	0004c783          	lbu	a5,0(s1)
    80003240:	05279763          	bne	a5,s2,8000328e <namex+0x156>
    path++;
    80003244:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003246:	0004c783          	lbu	a5,0(s1)
    8000324a:	ff278de3          	beq	a5,s2,80003244 <namex+0x10c>
  if(*path == 0)
    8000324e:	c79d                	beqz	a5,8000327c <namex+0x144>
    path++;
    80003250:	85a6                	mv	a1,s1
  len = path - s;
    80003252:	8a5e                	mv	s4,s7
    80003254:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003256:	01278963          	beq	a5,s2,80003268 <namex+0x130>
    8000325a:	dfbd                	beqz	a5,800031d8 <namex+0xa0>
    path++;
    8000325c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000325e:	0004c783          	lbu	a5,0(s1)
    80003262:	ff279ce3          	bne	a5,s2,8000325a <namex+0x122>
    80003266:	bf8d                	j	800031d8 <namex+0xa0>
    memmove(name, s, len);
    80003268:	2601                	sext.w	a2,a2
    8000326a:	8556                	mv	a0,s5
    8000326c:	ffffd097          	auipc	ra,0xffffd
    80003270:	f90080e7          	jalr	-112(ra) # 800001fc <memmove>
    name[len] = 0;
    80003274:	9a56                	add	s4,s4,s5
    80003276:	000a0023          	sb	zero,0(s4)
    8000327a:	bf9d                	j	800031f0 <namex+0xb8>
  if(nameiparent){
    8000327c:	f20b03e3          	beqz	s6,800031a2 <namex+0x6a>
    iput(ip);
    80003280:	854e                	mv	a0,s3
    80003282:	00000097          	auipc	ra,0x0
    80003286:	adc080e7          	jalr	-1316(ra) # 80002d5e <iput>
    return 0;
    8000328a:	4981                	li	s3,0
    8000328c:	bf19                	j	800031a2 <namex+0x6a>
  if(*path == 0)
    8000328e:	d7fd                	beqz	a5,8000327c <namex+0x144>
  while(*path != '/' && *path != 0)
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	85a6                	mv	a1,s1
    80003296:	b7d1                	j	8000325a <namex+0x122>

0000000080003298 <dirlink>:
{
    80003298:	7139                	addi	sp,sp,-64
    8000329a:	fc06                	sd	ra,56(sp)
    8000329c:	f822                	sd	s0,48(sp)
    8000329e:	f426                	sd	s1,40(sp)
    800032a0:	f04a                	sd	s2,32(sp)
    800032a2:	ec4e                	sd	s3,24(sp)
    800032a4:	e852                	sd	s4,16(sp)
    800032a6:	0080                	addi	s0,sp,64
    800032a8:	892a                	mv	s2,a0
    800032aa:	8a2e                	mv	s4,a1
    800032ac:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ae:	4601                	li	a2,0
    800032b0:	00000097          	auipc	ra,0x0
    800032b4:	dd8080e7          	jalr	-552(ra) # 80003088 <dirlookup>
    800032b8:	e93d                	bnez	a0,8000332e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ba:	04c92483          	lw	s1,76(s2)
    800032be:	c49d                	beqz	s1,800032ec <dirlink+0x54>
    800032c0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c2:	4741                	li	a4,16
    800032c4:	86a6                	mv	a3,s1
    800032c6:	fc040613          	addi	a2,s0,-64
    800032ca:	4581                	li	a1,0
    800032cc:	854a                	mv	a0,s2
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	b8a080e7          	jalr	-1142(ra) # 80002e58 <readi>
    800032d6:	47c1                	li	a5,16
    800032d8:	06f51163          	bne	a0,a5,8000333a <dirlink+0xa2>
    if(de.inum == 0)
    800032dc:	fc045783          	lhu	a5,-64(s0)
    800032e0:	c791                	beqz	a5,800032ec <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032e2:	24c1                	addiw	s1,s1,16
    800032e4:	04c92783          	lw	a5,76(s2)
    800032e8:	fcf4ede3          	bltu	s1,a5,800032c2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032ec:	4639                	li	a2,14
    800032ee:	85d2                	mv	a1,s4
    800032f0:	fc240513          	addi	a0,s0,-62
    800032f4:	ffffd097          	auipc	ra,0xffffd
    800032f8:	fbc080e7          	jalr	-68(ra) # 800002b0 <strncpy>
  de.inum = inum;
    800032fc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003300:	4741                	li	a4,16
    80003302:	86a6                	mv	a3,s1
    80003304:	fc040613          	addi	a2,s0,-64
    80003308:	4581                	li	a1,0
    8000330a:	854a                	mv	a0,s2
    8000330c:	00000097          	auipc	ra,0x0
    80003310:	c44080e7          	jalr	-956(ra) # 80002f50 <writei>
    80003314:	872a                	mv	a4,a0
    80003316:	47c1                	li	a5,16
  return 0;
    80003318:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000331a:	02f71863          	bne	a4,a5,8000334a <dirlink+0xb2>
}
    8000331e:	70e2                	ld	ra,56(sp)
    80003320:	7442                	ld	s0,48(sp)
    80003322:	74a2                	ld	s1,40(sp)
    80003324:	7902                	ld	s2,32(sp)
    80003326:	69e2                	ld	s3,24(sp)
    80003328:	6a42                	ld	s4,16(sp)
    8000332a:	6121                	addi	sp,sp,64
    8000332c:	8082                	ret
    iput(ip);
    8000332e:	00000097          	auipc	ra,0x0
    80003332:	a30080e7          	jalr	-1488(ra) # 80002d5e <iput>
    return -1;
    80003336:	557d                	li	a0,-1
    80003338:	b7dd                	j	8000331e <dirlink+0x86>
      panic("dirlink read");
    8000333a:	00005517          	auipc	a0,0x5
    8000333e:	3e650513          	addi	a0,a0,998 # 80008720 <syscall_names+0x1d0>
    80003342:	00003097          	auipc	ra,0x3
    80003346:	916080e7          	jalr	-1770(ra) # 80005c58 <panic>
    panic("dirlink");
    8000334a:	00005517          	auipc	a0,0x5
    8000334e:	4de50513          	addi	a0,a0,1246 # 80008828 <syscall_names+0x2d8>
    80003352:	00003097          	auipc	ra,0x3
    80003356:	906080e7          	jalr	-1786(ra) # 80005c58 <panic>

000000008000335a <namei>:

struct inode*
namei(char *path)
{
    8000335a:	1101                	addi	sp,sp,-32
    8000335c:	ec06                	sd	ra,24(sp)
    8000335e:	e822                	sd	s0,16(sp)
    80003360:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003362:	fe040613          	addi	a2,s0,-32
    80003366:	4581                	li	a1,0
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	dd0080e7          	jalr	-560(ra) # 80003138 <namex>
}
    80003370:	60e2                	ld	ra,24(sp)
    80003372:	6442                	ld	s0,16(sp)
    80003374:	6105                	addi	sp,sp,32
    80003376:	8082                	ret

0000000080003378 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003378:	1141                	addi	sp,sp,-16
    8000337a:	e406                	sd	ra,8(sp)
    8000337c:	e022                	sd	s0,0(sp)
    8000337e:	0800                	addi	s0,sp,16
    80003380:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003382:	4585                	li	a1,1
    80003384:	00000097          	auipc	ra,0x0
    80003388:	db4080e7          	jalr	-588(ra) # 80003138 <namex>
}
    8000338c:	60a2                	ld	ra,8(sp)
    8000338e:	6402                	ld	s0,0(sp)
    80003390:	0141                	addi	sp,sp,16
    80003392:	8082                	ret

0000000080003394 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003394:	1101                	addi	sp,sp,-32
    80003396:	ec06                	sd	ra,24(sp)
    80003398:	e822                	sd	s0,16(sp)
    8000339a:	e426                	sd	s1,8(sp)
    8000339c:	e04a                	sd	s2,0(sp)
    8000339e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033a0:	00016917          	auipc	s2,0x16
    800033a4:	e8090913          	addi	s2,s2,-384 # 80019220 <log>
    800033a8:	01892583          	lw	a1,24(s2)
    800033ac:	02892503          	lw	a0,40(s2)
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	ff2080e7          	jalr	-14(ra) # 800023a2 <bread>
    800033b8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033ba:	02c92683          	lw	a3,44(s2)
    800033be:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033c0:	02d05763          	blez	a3,800033ee <write_head+0x5a>
    800033c4:	00016797          	auipc	a5,0x16
    800033c8:	e8c78793          	addi	a5,a5,-372 # 80019250 <log+0x30>
    800033cc:	05c50713          	addi	a4,a0,92
    800033d0:	36fd                	addiw	a3,a3,-1
    800033d2:	1682                	slli	a3,a3,0x20
    800033d4:	9281                	srli	a3,a3,0x20
    800033d6:	068a                	slli	a3,a3,0x2
    800033d8:	00016617          	auipc	a2,0x16
    800033dc:	e7c60613          	addi	a2,a2,-388 # 80019254 <log+0x34>
    800033e0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800033e2:	4390                	lw	a2,0(a5)
    800033e4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800033e6:	0791                	addi	a5,a5,4
    800033e8:	0711                	addi	a4,a4,4
    800033ea:	fed79ce3          	bne	a5,a3,800033e2 <write_head+0x4e>
  }
  bwrite(buf);
    800033ee:	8526                	mv	a0,s1
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	0a4080e7          	jalr	164(ra) # 80002494 <bwrite>
  brelse(buf);
    800033f8:	8526                	mv	a0,s1
    800033fa:	fffff097          	auipc	ra,0xfffff
    800033fe:	0d8080e7          	jalr	216(ra) # 800024d2 <brelse>
}
    80003402:	60e2                	ld	ra,24(sp)
    80003404:	6442                	ld	s0,16(sp)
    80003406:	64a2                	ld	s1,8(sp)
    80003408:	6902                	ld	s2,0(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret

000000008000340e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000340e:	00016797          	auipc	a5,0x16
    80003412:	e3e7a783          	lw	a5,-450(a5) # 8001924c <log+0x2c>
    80003416:	0af05d63          	blez	a5,800034d0 <install_trans+0xc2>
{
    8000341a:	7139                	addi	sp,sp,-64
    8000341c:	fc06                	sd	ra,56(sp)
    8000341e:	f822                	sd	s0,48(sp)
    80003420:	f426                	sd	s1,40(sp)
    80003422:	f04a                	sd	s2,32(sp)
    80003424:	ec4e                	sd	s3,24(sp)
    80003426:	e852                	sd	s4,16(sp)
    80003428:	e456                	sd	s5,8(sp)
    8000342a:	e05a                	sd	s6,0(sp)
    8000342c:	0080                	addi	s0,sp,64
    8000342e:	8b2a                	mv	s6,a0
    80003430:	00016a97          	auipc	s5,0x16
    80003434:	e20a8a93          	addi	s5,s5,-480 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003438:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000343a:	00016997          	auipc	s3,0x16
    8000343e:	de698993          	addi	s3,s3,-538 # 80019220 <log>
    80003442:	a035                	j	8000346e <install_trans+0x60>
      bunpin(dbuf);
    80003444:	8526                	mv	a0,s1
    80003446:	fffff097          	auipc	ra,0xfffff
    8000344a:	166080e7          	jalr	358(ra) # 800025ac <bunpin>
    brelse(lbuf);
    8000344e:	854a                	mv	a0,s2
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	082080e7          	jalr	130(ra) # 800024d2 <brelse>
    brelse(dbuf);
    80003458:	8526                	mv	a0,s1
    8000345a:	fffff097          	auipc	ra,0xfffff
    8000345e:	078080e7          	jalr	120(ra) # 800024d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003462:	2a05                	addiw	s4,s4,1
    80003464:	0a91                	addi	s5,s5,4
    80003466:	02c9a783          	lw	a5,44(s3)
    8000346a:	04fa5963          	bge	s4,a5,800034bc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000346e:	0189a583          	lw	a1,24(s3)
    80003472:	014585bb          	addw	a1,a1,s4
    80003476:	2585                	addiw	a1,a1,1
    80003478:	0289a503          	lw	a0,40(s3)
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	f26080e7          	jalr	-218(ra) # 800023a2 <bread>
    80003484:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003486:	000aa583          	lw	a1,0(s5)
    8000348a:	0289a503          	lw	a0,40(s3)
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	f14080e7          	jalr	-236(ra) # 800023a2 <bread>
    80003496:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003498:	40000613          	li	a2,1024
    8000349c:	05890593          	addi	a1,s2,88
    800034a0:	05850513          	addi	a0,a0,88
    800034a4:	ffffd097          	auipc	ra,0xffffd
    800034a8:	d58080e7          	jalr	-680(ra) # 800001fc <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ac:	8526                	mv	a0,s1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	fe6080e7          	jalr	-26(ra) # 80002494 <bwrite>
    if(recovering == 0)
    800034b6:	f80b1ce3          	bnez	s6,8000344e <install_trans+0x40>
    800034ba:	b769                	j	80003444 <install_trans+0x36>
}
    800034bc:	70e2                	ld	ra,56(sp)
    800034be:	7442                	ld	s0,48(sp)
    800034c0:	74a2                	ld	s1,40(sp)
    800034c2:	7902                	ld	s2,32(sp)
    800034c4:	69e2                	ld	s3,24(sp)
    800034c6:	6a42                	ld	s4,16(sp)
    800034c8:	6aa2                	ld	s5,8(sp)
    800034ca:	6b02                	ld	s6,0(sp)
    800034cc:	6121                	addi	sp,sp,64
    800034ce:	8082                	ret
    800034d0:	8082                	ret

00000000800034d2 <initlog>:
{
    800034d2:	7179                	addi	sp,sp,-48
    800034d4:	f406                	sd	ra,40(sp)
    800034d6:	f022                	sd	s0,32(sp)
    800034d8:	ec26                	sd	s1,24(sp)
    800034da:	e84a                	sd	s2,16(sp)
    800034dc:	e44e                	sd	s3,8(sp)
    800034de:	1800                	addi	s0,sp,48
    800034e0:	892a                	mv	s2,a0
    800034e2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800034e4:	00016497          	auipc	s1,0x16
    800034e8:	d3c48493          	addi	s1,s1,-708 # 80019220 <log>
    800034ec:	00005597          	auipc	a1,0x5
    800034f0:	24458593          	addi	a1,a1,580 # 80008730 <syscall_names+0x1e0>
    800034f4:	8526                	mv	a0,s1
    800034f6:	00003097          	auipc	ra,0x3
    800034fa:	c1c080e7          	jalr	-996(ra) # 80006112 <initlock>
  log.start = sb->logstart;
    800034fe:	0149a583          	lw	a1,20(s3)
    80003502:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003504:	0109a783          	lw	a5,16(s3)
    80003508:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000350a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000350e:	854a                	mv	a0,s2
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	e92080e7          	jalr	-366(ra) # 800023a2 <bread>
  log.lh.n = lh->n;
    80003518:	4d3c                	lw	a5,88(a0)
    8000351a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000351c:	02f05563          	blez	a5,80003546 <initlog+0x74>
    80003520:	05c50713          	addi	a4,a0,92
    80003524:	00016697          	auipc	a3,0x16
    80003528:	d2c68693          	addi	a3,a3,-724 # 80019250 <log+0x30>
    8000352c:	37fd                	addiw	a5,a5,-1
    8000352e:	1782                	slli	a5,a5,0x20
    80003530:	9381                	srli	a5,a5,0x20
    80003532:	078a                	slli	a5,a5,0x2
    80003534:	06050613          	addi	a2,a0,96
    80003538:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000353a:	4310                	lw	a2,0(a4)
    8000353c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	0711                	addi	a4,a4,4
    80003540:	0691                	addi	a3,a3,4
    80003542:	fef71ce3          	bne	a4,a5,8000353a <initlog+0x68>
  brelse(buf);
    80003546:	fffff097          	auipc	ra,0xfffff
    8000354a:	f8c080e7          	jalr	-116(ra) # 800024d2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000354e:	4505                	li	a0,1
    80003550:	00000097          	auipc	ra,0x0
    80003554:	ebe080e7          	jalr	-322(ra) # 8000340e <install_trans>
  log.lh.n = 0;
    80003558:	00016797          	auipc	a5,0x16
    8000355c:	ce07aa23          	sw	zero,-780(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    80003560:	00000097          	auipc	ra,0x0
    80003564:	e34080e7          	jalr	-460(ra) # 80003394 <write_head>
}
    80003568:	70a2                	ld	ra,40(sp)
    8000356a:	7402                	ld	s0,32(sp)
    8000356c:	64e2                	ld	s1,24(sp)
    8000356e:	6942                	ld	s2,16(sp)
    80003570:	69a2                	ld	s3,8(sp)
    80003572:	6145                	addi	sp,sp,48
    80003574:	8082                	ret

0000000080003576 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003576:	1101                	addi	sp,sp,-32
    80003578:	ec06                	sd	ra,24(sp)
    8000357a:	e822                	sd	s0,16(sp)
    8000357c:	e426                	sd	s1,8(sp)
    8000357e:	e04a                	sd	s2,0(sp)
    80003580:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003582:	00016517          	auipc	a0,0x16
    80003586:	c9e50513          	addi	a0,a0,-866 # 80019220 <log>
    8000358a:	00003097          	auipc	ra,0x3
    8000358e:	c18080e7          	jalr	-1000(ra) # 800061a2 <acquire>
  while(1){
    if(log.committing){
    80003592:	00016497          	auipc	s1,0x16
    80003596:	c8e48493          	addi	s1,s1,-882 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000359a:	4979                	li	s2,30
    8000359c:	a039                	j	800035aa <begin_op+0x34>
      sleep(&log, &log.lock);
    8000359e:	85a6                	mv	a1,s1
    800035a0:	8526                	mv	a0,s1
    800035a2:	ffffe097          	auipc	ra,0xffffe
    800035a6:	f92080e7          	jalr	-110(ra) # 80001534 <sleep>
    if(log.committing){
    800035aa:	50dc                	lw	a5,36(s1)
    800035ac:	fbed                	bnez	a5,8000359e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ae:	509c                	lw	a5,32(s1)
    800035b0:	0017871b          	addiw	a4,a5,1
    800035b4:	0007069b          	sext.w	a3,a4
    800035b8:	0027179b          	slliw	a5,a4,0x2
    800035bc:	9fb9                	addw	a5,a5,a4
    800035be:	0017979b          	slliw	a5,a5,0x1
    800035c2:	54d8                	lw	a4,44(s1)
    800035c4:	9fb9                	addw	a5,a5,a4
    800035c6:	00f95963          	bge	s2,a5,800035d8 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ca:	85a6                	mv	a1,s1
    800035cc:	8526                	mv	a0,s1
    800035ce:	ffffe097          	auipc	ra,0xffffe
    800035d2:	f66080e7          	jalr	-154(ra) # 80001534 <sleep>
    800035d6:	bfd1                	j	800035aa <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035d8:	00016517          	auipc	a0,0x16
    800035dc:	c4850513          	addi	a0,a0,-952 # 80019220 <log>
    800035e0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	c74080e7          	jalr	-908(ra) # 80006256 <release>
      break;
    }
  }
}
    800035ea:	60e2                	ld	ra,24(sp)
    800035ec:	6442                	ld	s0,16(sp)
    800035ee:	64a2                	ld	s1,8(sp)
    800035f0:	6902                	ld	s2,0(sp)
    800035f2:	6105                	addi	sp,sp,32
    800035f4:	8082                	ret

00000000800035f6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800035f6:	7139                	addi	sp,sp,-64
    800035f8:	fc06                	sd	ra,56(sp)
    800035fa:	f822                	sd	s0,48(sp)
    800035fc:	f426                	sd	s1,40(sp)
    800035fe:	f04a                	sd	s2,32(sp)
    80003600:	ec4e                	sd	s3,24(sp)
    80003602:	e852                	sd	s4,16(sp)
    80003604:	e456                	sd	s5,8(sp)
    80003606:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003608:	00016497          	auipc	s1,0x16
    8000360c:	c1848493          	addi	s1,s1,-1000 # 80019220 <log>
    80003610:	8526                	mv	a0,s1
    80003612:	00003097          	auipc	ra,0x3
    80003616:	b90080e7          	jalr	-1136(ra) # 800061a2 <acquire>
  log.outstanding -= 1;
    8000361a:	509c                	lw	a5,32(s1)
    8000361c:	37fd                	addiw	a5,a5,-1
    8000361e:	0007891b          	sext.w	s2,a5
    80003622:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003624:	50dc                	lw	a5,36(s1)
    80003626:	efb9                	bnez	a5,80003684 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003628:	06091663          	bnez	s2,80003694 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000362c:	00016497          	auipc	s1,0x16
    80003630:	bf448493          	addi	s1,s1,-1036 # 80019220 <log>
    80003634:	4785                	li	a5,1
    80003636:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003638:	8526                	mv	a0,s1
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	c1c080e7          	jalr	-996(ra) # 80006256 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003642:	54dc                	lw	a5,44(s1)
    80003644:	06f04763          	bgtz	a5,800036b2 <end_op+0xbc>
    acquire(&log.lock);
    80003648:	00016497          	auipc	s1,0x16
    8000364c:	bd848493          	addi	s1,s1,-1064 # 80019220 <log>
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	b50080e7          	jalr	-1200(ra) # 800061a2 <acquire>
    log.committing = 0;
    8000365a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000365e:	8526                	mv	a0,s1
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	060080e7          	jalr	96(ra) # 800016c0 <wakeup>
    release(&log.lock);
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	bec080e7          	jalr	-1044(ra) # 80006256 <release>
}
    80003672:	70e2                	ld	ra,56(sp)
    80003674:	7442                	ld	s0,48(sp)
    80003676:	74a2                	ld	s1,40(sp)
    80003678:	7902                	ld	s2,32(sp)
    8000367a:	69e2                	ld	s3,24(sp)
    8000367c:	6a42                	ld	s4,16(sp)
    8000367e:	6aa2                	ld	s5,8(sp)
    80003680:	6121                	addi	sp,sp,64
    80003682:	8082                	ret
    panic("log.committing");
    80003684:	00005517          	auipc	a0,0x5
    80003688:	0b450513          	addi	a0,a0,180 # 80008738 <syscall_names+0x1e8>
    8000368c:	00002097          	auipc	ra,0x2
    80003690:	5cc080e7          	jalr	1484(ra) # 80005c58 <panic>
    wakeup(&log);
    80003694:	00016497          	auipc	s1,0x16
    80003698:	b8c48493          	addi	s1,s1,-1140 # 80019220 <log>
    8000369c:	8526                	mv	a0,s1
    8000369e:	ffffe097          	auipc	ra,0xffffe
    800036a2:	022080e7          	jalr	34(ra) # 800016c0 <wakeup>
  release(&log.lock);
    800036a6:	8526                	mv	a0,s1
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	bae080e7          	jalr	-1106(ra) # 80006256 <release>
  if(do_commit){
    800036b0:	b7c9                	j	80003672 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b2:	00016a97          	auipc	s5,0x16
    800036b6:	b9ea8a93          	addi	s5,s5,-1122 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ba:	00016a17          	auipc	s4,0x16
    800036be:	b66a0a13          	addi	s4,s4,-1178 # 80019220 <log>
    800036c2:	018a2583          	lw	a1,24(s4)
    800036c6:	012585bb          	addw	a1,a1,s2
    800036ca:	2585                	addiw	a1,a1,1
    800036cc:	028a2503          	lw	a0,40(s4)
    800036d0:	fffff097          	auipc	ra,0xfffff
    800036d4:	cd2080e7          	jalr	-814(ra) # 800023a2 <bread>
    800036d8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036da:	000aa583          	lw	a1,0(s5)
    800036de:	028a2503          	lw	a0,40(s4)
    800036e2:	fffff097          	auipc	ra,0xfffff
    800036e6:	cc0080e7          	jalr	-832(ra) # 800023a2 <bread>
    800036ea:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800036ec:	40000613          	li	a2,1024
    800036f0:	05850593          	addi	a1,a0,88
    800036f4:	05848513          	addi	a0,s1,88
    800036f8:	ffffd097          	auipc	ra,0xffffd
    800036fc:	b04080e7          	jalr	-1276(ra) # 800001fc <memmove>
    bwrite(to);  // write the log
    80003700:	8526                	mv	a0,s1
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	d92080e7          	jalr	-622(ra) # 80002494 <bwrite>
    brelse(from);
    8000370a:	854e                	mv	a0,s3
    8000370c:	fffff097          	auipc	ra,0xfffff
    80003710:	dc6080e7          	jalr	-570(ra) # 800024d2 <brelse>
    brelse(to);
    80003714:	8526                	mv	a0,s1
    80003716:	fffff097          	auipc	ra,0xfffff
    8000371a:	dbc080e7          	jalr	-580(ra) # 800024d2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371e:	2905                	addiw	s2,s2,1
    80003720:	0a91                	addi	s5,s5,4
    80003722:	02ca2783          	lw	a5,44(s4)
    80003726:	f8f94ee3          	blt	s2,a5,800036c2 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000372a:	00000097          	auipc	ra,0x0
    8000372e:	c6a080e7          	jalr	-918(ra) # 80003394 <write_head>
    install_trans(0); // Now install writes to home locations
    80003732:	4501                	li	a0,0
    80003734:	00000097          	auipc	ra,0x0
    80003738:	cda080e7          	jalr	-806(ra) # 8000340e <install_trans>
    log.lh.n = 0;
    8000373c:	00016797          	auipc	a5,0x16
    80003740:	b007a823          	sw	zero,-1264(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003744:	00000097          	auipc	ra,0x0
    80003748:	c50080e7          	jalr	-944(ra) # 80003394 <write_head>
    8000374c:	bdf5                	j	80003648 <end_op+0x52>

000000008000374e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000374e:	1101                	addi	sp,sp,-32
    80003750:	ec06                	sd	ra,24(sp)
    80003752:	e822                	sd	s0,16(sp)
    80003754:	e426                	sd	s1,8(sp)
    80003756:	e04a                	sd	s2,0(sp)
    80003758:	1000                	addi	s0,sp,32
    8000375a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000375c:	00016917          	auipc	s2,0x16
    80003760:	ac490913          	addi	s2,s2,-1340 # 80019220 <log>
    80003764:	854a                	mv	a0,s2
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	a3c080e7          	jalr	-1476(ra) # 800061a2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000376e:	02c92603          	lw	a2,44(s2)
    80003772:	47f5                	li	a5,29
    80003774:	06c7c563          	blt	a5,a2,800037de <log_write+0x90>
    80003778:	00016797          	auipc	a5,0x16
    8000377c:	ac47a783          	lw	a5,-1340(a5) # 8001923c <log+0x1c>
    80003780:	37fd                	addiw	a5,a5,-1
    80003782:	04f65e63          	bge	a2,a5,800037de <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003786:	00016797          	auipc	a5,0x16
    8000378a:	aba7a783          	lw	a5,-1350(a5) # 80019240 <log+0x20>
    8000378e:	06f05063          	blez	a5,800037ee <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003792:	4781                	li	a5,0
    80003794:	06c05563          	blez	a2,800037fe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003798:	44cc                	lw	a1,12(s1)
    8000379a:	00016717          	auipc	a4,0x16
    8000379e:	ab670713          	addi	a4,a4,-1354 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037a2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037a4:	4314                	lw	a3,0(a4)
    800037a6:	04b68c63          	beq	a3,a1,800037fe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037aa:	2785                	addiw	a5,a5,1
    800037ac:	0711                	addi	a4,a4,4
    800037ae:	fef61be3          	bne	a2,a5,800037a4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037b2:	0621                	addi	a2,a2,8
    800037b4:	060a                	slli	a2,a2,0x2
    800037b6:	00016797          	auipc	a5,0x16
    800037ba:	a6a78793          	addi	a5,a5,-1430 # 80019220 <log>
    800037be:	963e                	add	a2,a2,a5
    800037c0:	44dc                	lw	a5,12(s1)
    800037c2:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037c4:	8526                	mv	a0,s1
    800037c6:	fffff097          	auipc	ra,0xfffff
    800037ca:	daa080e7          	jalr	-598(ra) # 80002570 <bpin>
    log.lh.n++;
    800037ce:	00016717          	auipc	a4,0x16
    800037d2:	a5270713          	addi	a4,a4,-1454 # 80019220 <log>
    800037d6:	575c                	lw	a5,44(a4)
    800037d8:	2785                	addiw	a5,a5,1
    800037da:	d75c                	sw	a5,44(a4)
    800037dc:	a835                	j	80003818 <log_write+0xca>
    panic("too big a transaction");
    800037de:	00005517          	auipc	a0,0x5
    800037e2:	f6a50513          	addi	a0,a0,-150 # 80008748 <syscall_names+0x1f8>
    800037e6:	00002097          	auipc	ra,0x2
    800037ea:	472080e7          	jalr	1138(ra) # 80005c58 <panic>
    panic("log_write outside of trans");
    800037ee:	00005517          	auipc	a0,0x5
    800037f2:	f7250513          	addi	a0,a0,-142 # 80008760 <syscall_names+0x210>
    800037f6:	00002097          	auipc	ra,0x2
    800037fa:	462080e7          	jalr	1122(ra) # 80005c58 <panic>
  log.lh.block[i] = b->blockno;
    800037fe:	00878713          	addi	a4,a5,8
    80003802:	00271693          	slli	a3,a4,0x2
    80003806:	00016717          	auipc	a4,0x16
    8000380a:	a1a70713          	addi	a4,a4,-1510 # 80019220 <log>
    8000380e:	9736                	add	a4,a4,a3
    80003810:	44d4                	lw	a3,12(s1)
    80003812:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003814:	faf608e3          	beq	a2,a5,800037c4 <log_write+0x76>
  }
  release(&log.lock);
    80003818:	00016517          	auipc	a0,0x16
    8000381c:	a0850513          	addi	a0,a0,-1528 # 80019220 <log>
    80003820:	00003097          	auipc	ra,0x3
    80003824:	a36080e7          	jalr	-1482(ra) # 80006256 <release>
}
    80003828:	60e2                	ld	ra,24(sp)
    8000382a:	6442                	ld	s0,16(sp)
    8000382c:	64a2                	ld	s1,8(sp)
    8000382e:	6902                	ld	s2,0(sp)
    80003830:	6105                	addi	sp,sp,32
    80003832:	8082                	ret

0000000080003834 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003834:	1101                	addi	sp,sp,-32
    80003836:	ec06                	sd	ra,24(sp)
    80003838:	e822                	sd	s0,16(sp)
    8000383a:	e426                	sd	s1,8(sp)
    8000383c:	e04a                	sd	s2,0(sp)
    8000383e:	1000                	addi	s0,sp,32
    80003840:	84aa                	mv	s1,a0
    80003842:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003844:	00005597          	auipc	a1,0x5
    80003848:	f3c58593          	addi	a1,a1,-196 # 80008780 <syscall_names+0x230>
    8000384c:	0521                	addi	a0,a0,8
    8000384e:	00003097          	auipc	ra,0x3
    80003852:	8c4080e7          	jalr	-1852(ra) # 80006112 <initlock>
  lk->name = name;
    80003856:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000385a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000385e:	0204a423          	sw	zero,40(s1)
}
    80003862:	60e2                	ld	ra,24(sp)
    80003864:	6442                	ld	s0,16(sp)
    80003866:	64a2                	ld	s1,8(sp)
    80003868:	6902                	ld	s2,0(sp)
    8000386a:	6105                	addi	sp,sp,32
    8000386c:	8082                	ret

000000008000386e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000386e:	1101                	addi	sp,sp,-32
    80003870:	ec06                	sd	ra,24(sp)
    80003872:	e822                	sd	s0,16(sp)
    80003874:	e426                	sd	s1,8(sp)
    80003876:	e04a                	sd	s2,0(sp)
    80003878:	1000                	addi	s0,sp,32
    8000387a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000387c:	00850913          	addi	s2,a0,8
    80003880:	854a                	mv	a0,s2
    80003882:	00003097          	auipc	ra,0x3
    80003886:	920080e7          	jalr	-1760(ra) # 800061a2 <acquire>
  while (lk->locked) {
    8000388a:	409c                	lw	a5,0(s1)
    8000388c:	cb89                	beqz	a5,8000389e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000388e:	85ca                	mv	a1,s2
    80003890:	8526                	mv	a0,s1
    80003892:	ffffe097          	auipc	ra,0xffffe
    80003896:	ca2080e7          	jalr	-862(ra) # 80001534 <sleep>
  while (lk->locked) {
    8000389a:	409c                	lw	a5,0(s1)
    8000389c:	fbed                	bnez	a5,8000388e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000389e:	4785                	li	a5,1
    800038a0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038a2:	ffffd097          	auipc	ra,0xffffd
    800038a6:	5ca080e7          	jalr	1482(ra) # 80000e6c <myproc>
    800038aa:	591c                	lw	a5,48(a0)
    800038ac:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ae:	854a                	mv	a0,s2
    800038b0:	00003097          	auipc	ra,0x3
    800038b4:	9a6080e7          	jalr	-1626(ra) # 80006256 <release>
}
    800038b8:	60e2                	ld	ra,24(sp)
    800038ba:	6442                	ld	s0,16(sp)
    800038bc:	64a2                	ld	s1,8(sp)
    800038be:	6902                	ld	s2,0(sp)
    800038c0:	6105                	addi	sp,sp,32
    800038c2:	8082                	ret

00000000800038c4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	e426                	sd	s1,8(sp)
    800038cc:	e04a                	sd	s2,0(sp)
    800038ce:	1000                	addi	s0,sp,32
    800038d0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d2:	00850913          	addi	s2,a0,8
    800038d6:	854a                	mv	a0,s2
    800038d8:	00003097          	auipc	ra,0x3
    800038dc:	8ca080e7          	jalr	-1846(ra) # 800061a2 <acquire>
  lk->locked = 0;
    800038e0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038e4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	dd6080e7          	jalr	-554(ra) # 800016c0 <wakeup>
  release(&lk->lk);
    800038f2:	854a                	mv	a0,s2
    800038f4:	00003097          	auipc	ra,0x3
    800038f8:	962080e7          	jalr	-1694(ra) # 80006256 <release>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret

0000000080003908 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003908:	7179                	addi	sp,sp,-48
    8000390a:	f406                	sd	ra,40(sp)
    8000390c:	f022                	sd	s0,32(sp)
    8000390e:	ec26                	sd	s1,24(sp)
    80003910:	e84a                	sd	s2,16(sp)
    80003912:	e44e                	sd	s3,8(sp)
    80003914:	1800                	addi	s0,sp,48
    80003916:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003918:	00850913          	addi	s2,a0,8
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	884080e7          	jalr	-1916(ra) # 800061a2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003926:	409c                	lw	a5,0(s1)
    80003928:	ef99                	bnez	a5,80003946 <holdingsleep+0x3e>
    8000392a:	4481                	li	s1,0
  release(&lk->lk);
    8000392c:	854a                	mv	a0,s2
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	928080e7          	jalr	-1752(ra) # 80006256 <release>
  return r;
}
    80003936:	8526                	mv	a0,s1
    80003938:	70a2                	ld	ra,40(sp)
    8000393a:	7402                	ld	s0,32(sp)
    8000393c:	64e2                	ld	s1,24(sp)
    8000393e:	6942                	ld	s2,16(sp)
    80003940:	69a2                	ld	s3,8(sp)
    80003942:	6145                	addi	sp,sp,48
    80003944:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003946:	0284a983          	lw	s3,40(s1)
    8000394a:	ffffd097          	auipc	ra,0xffffd
    8000394e:	522080e7          	jalr	1314(ra) # 80000e6c <myproc>
    80003952:	5904                	lw	s1,48(a0)
    80003954:	413484b3          	sub	s1,s1,s3
    80003958:	0014b493          	seqz	s1,s1
    8000395c:	bfc1                	j	8000392c <holdingsleep+0x24>

000000008000395e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000395e:	1141                	addi	sp,sp,-16
    80003960:	e406                	sd	ra,8(sp)
    80003962:	e022                	sd	s0,0(sp)
    80003964:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003966:	00005597          	auipc	a1,0x5
    8000396a:	e2a58593          	addi	a1,a1,-470 # 80008790 <syscall_names+0x240>
    8000396e:	00016517          	auipc	a0,0x16
    80003972:	9fa50513          	addi	a0,a0,-1542 # 80019368 <ftable>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	79c080e7          	jalr	1948(ra) # 80006112 <initlock>
}
    8000397e:	60a2                	ld	ra,8(sp)
    80003980:	6402                	ld	s0,0(sp)
    80003982:	0141                	addi	sp,sp,16
    80003984:	8082                	ret

0000000080003986 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003986:	1101                	addi	sp,sp,-32
    80003988:	ec06                	sd	ra,24(sp)
    8000398a:	e822                	sd	s0,16(sp)
    8000398c:	e426                	sd	s1,8(sp)
    8000398e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003990:	00016517          	auipc	a0,0x16
    80003994:	9d850513          	addi	a0,a0,-1576 # 80019368 <ftable>
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	80a080e7          	jalr	-2038(ra) # 800061a2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039a0:	00016497          	auipc	s1,0x16
    800039a4:	9e048493          	addi	s1,s1,-1568 # 80019380 <ftable+0x18>
    800039a8:	00017717          	auipc	a4,0x17
    800039ac:	97870713          	addi	a4,a4,-1672 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    800039b0:	40dc                	lw	a5,4(s1)
    800039b2:	cf99                	beqz	a5,800039d0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039b4:	02848493          	addi	s1,s1,40
    800039b8:	fee49ce3          	bne	s1,a4,800039b0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039bc:	00016517          	auipc	a0,0x16
    800039c0:	9ac50513          	addi	a0,a0,-1620 # 80019368 <ftable>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	892080e7          	jalr	-1902(ra) # 80006256 <release>
  return 0;
    800039cc:	4481                	li	s1,0
    800039ce:	a819                	j	800039e4 <filealloc+0x5e>
      f->ref = 1;
    800039d0:	4785                	li	a5,1
    800039d2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039d4:	00016517          	auipc	a0,0x16
    800039d8:	99450513          	addi	a0,a0,-1644 # 80019368 <ftable>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	87a080e7          	jalr	-1926(ra) # 80006256 <release>
}
    800039e4:	8526                	mv	a0,s1
    800039e6:	60e2                	ld	ra,24(sp)
    800039e8:	6442                	ld	s0,16(sp)
    800039ea:	64a2                	ld	s1,8(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800039f0:	1101                	addi	sp,sp,-32
    800039f2:	ec06                	sd	ra,24(sp)
    800039f4:	e822                	sd	s0,16(sp)
    800039f6:	e426                	sd	s1,8(sp)
    800039f8:	1000                	addi	s0,sp,32
    800039fa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800039fc:	00016517          	auipc	a0,0x16
    80003a00:	96c50513          	addi	a0,a0,-1684 # 80019368 <ftable>
    80003a04:	00002097          	auipc	ra,0x2
    80003a08:	79e080e7          	jalr	1950(ra) # 800061a2 <acquire>
  if(f->ref < 1)
    80003a0c:	40dc                	lw	a5,4(s1)
    80003a0e:	02f05263          	blez	a5,80003a32 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a12:	2785                	addiw	a5,a5,1
    80003a14:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a16:	00016517          	auipc	a0,0x16
    80003a1a:	95250513          	addi	a0,a0,-1710 # 80019368 <ftable>
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	838080e7          	jalr	-1992(ra) # 80006256 <release>
  return f;
}
    80003a26:	8526                	mv	a0,s1
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret
    panic("filedup");
    80003a32:	00005517          	auipc	a0,0x5
    80003a36:	d6650513          	addi	a0,a0,-666 # 80008798 <syscall_names+0x248>
    80003a3a:	00002097          	auipc	ra,0x2
    80003a3e:	21e080e7          	jalr	542(ra) # 80005c58 <panic>

0000000080003a42 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a42:	7139                	addi	sp,sp,-64
    80003a44:	fc06                	sd	ra,56(sp)
    80003a46:	f822                	sd	s0,48(sp)
    80003a48:	f426                	sd	s1,40(sp)
    80003a4a:	f04a                	sd	s2,32(sp)
    80003a4c:	ec4e                	sd	s3,24(sp)
    80003a4e:	e852                	sd	s4,16(sp)
    80003a50:	e456                	sd	s5,8(sp)
    80003a52:	0080                	addi	s0,sp,64
    80003a54:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a56:	00016517          	auipc	a0,0x16
    80003a5a:	91250513          	addi	a0,a0,-1774 # 80019368 <ftable>
    80003a5e:	00002097          	auipc	ra,0x2
    80003a62:	744080e7          	jalr	1860(ra) # 800061a2 <acquire>
  if(f->ref < 1)
    80003a66:	40dc                	lw	a5,4(s1)
    80003a68:	06f05163          	blez	a5,80003aca <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a6c:	37fd                	addiw	a5,a5,-1
    80003a6e:	0007871b          	sext.w	a4,a5
    80003a72:	c0dc                	sw	a5,4(s1)
    80003a74:	06e04363          	bgtz	a4,80003ada <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a78:	0004a903          	lw	s2,0(s1)
    80003a7c:	0094ca83          	lbu	s5,9(s1)
    80003a80:	0104ba03          	ld	s4,16(s1)
    80003a84:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a88:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a8c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a90:	00016517          	auipc	a0,0x16
    80003a94:	8d850513          	addi	a0,a0,-1832 # 80019368 <ftable>
    80003a98:	00002097          	auipc	ra,0x2
    80003a9c:	7be080e7          	jalr	1982(ra) # 80006256 <release>

  if(ff.type == FD_PIPE){
    80003aa0:	4785                	li	a5,1
    80003aa2:	04f90d63          	beq	s2,a5,80003afc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003aa6:	3979                	addiw	s2,s2,-2
    80003aa8:	4785                	li	a5,1
    80003aaa:	0527e063          	bltu	a5,s2,80003aea <fileclose+0xa8>
    begin_op();
    80003aae:	00000097          	auipc	ra,0x0
    80003ab2:	ac8080e7          	jalr	-1336(ra) # 80003576 <begin_op>
    iput(ff.ip);
    80003ab6:	854e                	mv	a0,s3
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	2a6080e7          	jalr	678(ra) # 80002d5e <iput>
    end_op();
    80003ac0:	00000097          	auipc	ra,0x0
    80003ac4:	b36080e7          	jalr	-1226(ra) # 800035f6 <end_op>
    80003ac8:	a00d                	j	80003aea <fileclose+0xa8>
    panic("fileclose");
    80003aca:	00005517          	auipc	a0,0x5
    80003ace:	cd650513          	addi	a0,a0,-810 # 800087a0 <syscall_names+0x250>
    80003ad2:	00002097          	auipc	ra,0x2
    80003ad6:	186080e7          	jalr	390(ra) # 80005c58 <panic>
    release(&ftable.lock);
    80003ada:	00016517          	auipc	a0,0x16
    80003ade:	88e50513          	addi	a0,a0,-1906 # 80019368 <ftable>
    80003ae2:	00002097          	auipc	ra,0x2
    80003ae6:	774080e7          	jalr	1908(ra) # 80006256 <release>
  }
}
    80003aea:	70e2                	ld	ra,56(sp)
    80003aec:	7442                	ld	s0,48(sp)
    80003aee:	74a2                	ld	s1,40(sp)
    80003af0:	7902                	ld	s2,32(sp)
    80003af2:	69e2                	ld	s3,24(sp)
    80003af4:	6a42                	ld	s4,16(sp)
    80003af6:	6aa2                	ld	s5,8(sp)
    80003af8:	6121                	addi	sp,sp,64
    80003afa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003afc:	85d6                	mv	a1,s5
    80003afe:	8552                	mv	a0,s4
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	34c080e7          	jalr	844(ra) # 80003e4c <pipeclose>
    80003b08:	b7cd                	j	80003aea <fileclose+0xa8>

0000000080003b0a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b0a:	715d                	addi	sp,sp,-80
    80003b0c:	e486                	sd	ra,72(sp)
    80003b0e:	e0a2                	sd	s0,64(sp)
    80003b10:	fc26                	sd	s1,56(sp)
    80003b12:	f84a                	sd	s2,48(sp)
    80003b14:	f44e                	sd	s3,40(sp)
    80003b16:	0880                	addi	s0,sp,80
    80003b18:	84aa                	mv	s1,a0
    80003b1a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b1c:	ffffd097          	auipc	ra,0xffffd
    80003b20:	350080e7          	jalr	848(ra) # 80000e6c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b24:	409c                	lw	a5,0(s1)
    80003b26:	37f9                	addiw	a5,a5,-2
    80003b28:	4705                	li	a4,1
    80003b2a:	04f76763          	bltu	a4,a5,80003b78 <filestat+0x6e>
    80003b2e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b30:	6c88                	ld	a0,24(s1)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	072080e7          	jalr	114(ra) # 80002ba4 <ilock>
    stati(f->ip, &st);
    80003b3a:	fb840593          	addi	a1,s0,-72
    80003b3e:	6c88                	ld	a0,24(s1)
    80003b40:	fffff097          	auipc	ra,0xfffff
    80003b44:	2ee080e7          	jalr	750(ra) # 80002e2e <stati>
    iunlock(f->ip);
    80003b48:	6c88                	ld	a0,24(s1)
    80003b4a:	fffff097          	auipc	ra,0xfffff
    80003b4e:	11c080e7          	jalr	284(ra) # 80002c66 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b52:	46e1                	li	a3,24
    80003b54:	fb840613          	addi	a2,s0,-72
    80003b58:	85ce                	mv	a1,s3
    80003b5a:	05093503          	ld	a0,80(s2)
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	fd0080e7          	jalr	-48(ra) # 80000b2e <copyout>
    80003b66:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b6a:	60a6                	ld	ra,72(sp)
    80003b6c:	6406                	ld	s0,64(sp)
    80003b6e:	74e2                	ld	s1,56(sp)
    80003b70:	7942                	ld	s2,48(sp)
    80003b72:	79a2                	ld	s3,40(sp)
    80003b74:	6161                	addi	sp,sp,80
    80003b76:	8082                	ret
  return -1;
    80003b78:	557d                	li	a0,-1
    80003b7a:	bfc5                	j	80003b6a <filestat+0x60>

0000000080003b7c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b7c:	7179                	addi	sp,sp,-48
    80003b7e:	f406                	sd	ra,40(sp)
    80003b80:	f022                	sd	s0,32(sp)
    80003b82:	ec26                	sd	s1,24(sp)
    80003b84:	e84a                	sd	s2,16(sp)
    80003b86:	e44e                	sd	s3,8(sp)
    80003b88:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b8a:	00854783          	lbu	a5,8(a0)
    80003b8e:	c3d5                	beqz	a5,80003c32 <fileread+0xb6>
    80003b90:	84aa                	mv	s1,a0
    80003b92:	89ae                	mv	s3,a1
    80003b94:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b96:	411c                	lw	a5,0(a0)
    80003b98:	4705                	li	a4,1
    80003b9a:	04e78963          	beq	a5,a4,80003bec <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b9e:	470d                	li	a4,3
    80003ba0:	04e78d63          	beq	a5,a4,80003bfa <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ba4:	4709                	li	a4,2
    80003ba6:	06e79e63          	bne	a5,a4,80003c22 <fileread+0xa6>
    ilock(f->ip);
    80003baa:	6d08                	ld	a0,24(a0)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	ff8080e7          	jalr	-8(ra) # 80002ba4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bb4:	874a                	mv	a4,s2
    80003bb6:	5094                	lw	a3,32(s1)
    80003bb8:	864e                	mv	a2,s3
    80003bba:	4585                	li	a1,1
    80003bbc:	6c88                	ld	a0,24(s1)
    80003bbe:	fffff097          	auipc	ra,0xfffff
    80003bc2:	29a080e7          	jalr	666(ra) # 80002e58 <readi>
    80003bc6:	892a                	mv	s2,a0
    80003bc8:	00a05563          	blez	a0,80003bd2 <fileread+0x56>
      f->off += r;
    80003bcc:	509c                	lw	a5,32(s1)
    80003bce:	9fa9                	addw	a5,a5,a0
    80003bd0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bd2:	6c88                	ld	a0,24(s1)
    80003bd4:	fffff097          	auipc	ra,0xfffff
    80003bd8:	092080e7          	jalr	146(ra) # 80002c66 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003bdc:	854a                	mv	a0,s2
    80003bde:	70a2                	ld	ra,40(sp)
    80003be0:	7402                	ld	s0,32(sp)
    80003be2:	64e2                	ld	s1,24(sp)
    80003be4:	6942                	ld	s2,16(sp)
    80003be6:	69a2                	ld	s3,8(sp)
    80003be8:	6145                	addi	sp,sp,48
    80003bea:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003bec:	6908                	ld	a0,16(a0)
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	3c8080e7          	jalr	968(ra) # 80003fb6 <piperead>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	b7d5                	j	80003bdc <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bfa:	02451783          	lh	a5,36(a0)
    80003bfe:	03079693          	slli	a3,a5,0x30
    80003c02:	92c1                	srli	a3,a3,0x30
    80003c04:	4725                	li	a4,9
    80003c06:	02d76863          	bltu	a4,a3,80003c36 <fileread+0xba>
    80003c0a:	0792                	slli	a5,a5,0x4
    80003c0c:	00015717          	auipc	a4,0x15
    80003c10:	6bc70713          	addi	a4,a4,1724 # 800192c8 <devsw>
    80003c14:	97ba                	add	a5,a5,a4
    80003c16:	639c                	ld	a5,0(a5)
    80003c18:	c38d                	beqz	a5,80003c3a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c1a:	4505                	li	a0,1
    80003c1c:	9782                	jalr	a5
    80003c1e:	892a                	mv	s2,a0
    80003c20:	bf75                	j	80003bdc <fileread+0x60>
    panic("fileread");
    80003c22:	00005517          	auipc	a0,0x5
    80003c26:	b8e50513          	addi	a0,a0,-1138 # 800087b0 <syscall_names+0x260>
    80003c2a:	00002097          	auipc	ra,0x2
    80003c2e:	02e080e7          	jalr	46(ra) # 80005c58 <panic>
    return -1;
    80003c32:	597d                	li	s2,-1
    80003c34:	b765                	j	80003bdc <fileread+0x60>
      return -1;
    80003c36:	597d                	li	s2,-1
    80003c38:	b755                	j	80003bdc <fileread+0x60>
    80003c3a:	597d                	li	s2,-1
    80003c3c:	b745                	j	80003bdc <fileread+0x60>

0000000080003c3e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c3e:	715d                	addi	sp,sp,-80
    80003c40:	e486                	sd	ra,72(sp)
    80003c42:	e0a2                	sd	s0,64(sp)
    80003c44:	fc26                	sd	s1,56(sp)
    80003c46:	f84a                	sd	s2,48(sp)
    80003c48:	f44e                	sd	s3,40(sp)
    80003c4a:	f052                	sd	s4,32(sp)
    80003c4c:	ec56                	sd	s5,24(sp)
    80003c4e:	e85a                	sd	s6,16(sp)
    80003c50:	e45e                	sd	s7,8(sp)
    80003c52:	e062                	sd	s8,0(sp)
    80003c54:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c56:	00954783          	lbu	a5,9(a0)
    80003c5a:	10078663          	beqz	a5,80003d66 <filewrite+0x128>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	8aae                	mv	s5,a1
    80003c62:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c64:	411c                	lw	a5,0(a0)
    80003c66:	4705                	li	a4,1
    80003c68:	02e78263          	beq	a5,a4,80003c8c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c6c:	470d                	li	a4,3
    80003c6e:	02e78663          	beq	a5,a4,80003c9a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c72:	4709                	li	a4,2
    80003c74:	0ee79163          	bne	a5,a4,80003d56 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c78:	0ac05d63          	blez	a2,80003d32 <filewrite+0xf4>
    int i = 0;
    80003c7c:	4981                	li	s3,0
    80003c7e:	6b05                	lui	s6,0x1
    80003c80:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003c84:	6b85                	lui	s7,0x1
    80003c86:	c00b8b9b          	addiw	s7,s7,-1024
    80003c8a:	a861                	j	80003d22 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003c8c:	6908                	ld	a0,16(a0)
    80003c8e:	00000097          	auipc	ra,0x0
    80003c92:	22e080e7          	jalr	558(ra) # 80003ebc <pipewrite>
    80003c96:	8a2a                	mv	s4,a0
    80003c98:	a045                	j	80003d38 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c9a:	02451783          	lh	a5,36(a0)
    80003c9e:	03079693          	slli	a3,a5,0x30
    80003ca2:	92c1                	srli	a3,a3,0x30
    80003ca4:	4725                	li	a4,9
    80003ca6:	0cd76263          	bltu	a4,a3,80003d6a <filewrite+0x12c>
    80003caa:	0792                	slli	a5,a5,0x4
    80003cac:	00015717          	auipc	a4,0x15
    80003cb0:	61c70713          	addi	a4,a4,1564 # 800192c8 <devsw>
    80003cb4:	97ba                	add	a5,a5,a4
    80003cb6:	679c                	ld	a5,8(a5)
    80003cb8:	cbdd                	beqz	a5,80003d6e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cba:	4505                	li	a0,1
    80003cbc:	9782                	jalr	a5
    80003cbe:	8a2a                	mv	s4,a0
    80003cc0:	a8a5                	j	80003d38 <filewrite+0xfa>
    80003cc2:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cc6:	00000097          	auipc	ra,0x0
    80003cca:	8b0080e7          	jalr	-1872(ra) # 80003576 <begin_op>
      ilock(f->ip);
    80003cce:	01893503          	ld	a0,24(s2)
    80003cd2:	fffff097          	auipc	ra,0xfffff
    80003cd6:	ed2080e7          	jalr	-302(ra) # 80002ba4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cda:	8762                	mv	a4,s8
    80003cdc:	02092683          	lw	a3,32(s2)
    80003ce0:	01598633          	add	a2,s3,s5
    80003ce4:	4585                	li	a1,1
    80003ce6:	01893503          	ld	a0,24(s2)
    80003cea:	fffff097          	auipc	ra,0xfffff
    80003cee:	266080e7          	jalr	614(ra) # 80002f50 <writei>
    80003cf2:	84aa                	mv	s1,a0
    80003cf4:	00a05763          	blez	a0,80003d02 <filewrite+0xc4>
        f->off += r;
    80003cf8:	02092783          	lw	a5,32(s2)
    80003cfc:	9fa9                	addw	a5,a5,a0
    80003cfe:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d02:	01893503          	ld	a0,24(s2)
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	f60080e7          	jalr	-160(ra) # 80002c66 <iunlock>
      end_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	8e8080e7          	jalr	-1816(ra) # 800035f6 <end_op>

      if(r != n1){
    80003d16:	009c1f63          	bne	s8,s1,80003d34 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d1a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d1e:	0149db63          	bge	s3,s4,80003d34 <filewrite+0xf6>
      int n1 = n - i;
    80003d22:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d26:	84be                	mv	s1,a5
    80003d28:	2781                	sext.w	a5,a5
    80003d2a:	f8fb5ce3          	bge	s6,a5,80003cc2 <filewrite+0x84>
    80003d2e:	84de                	mv	s1,s7
    80003d30:	bf49                	j	80003cc2 <filewrite+0x84>
    int i = 0;
    80003d32:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d34:	013a1f63          	bne	s4,s3,80003d52 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d38:	8552                	mv	a0,s4
    80003d3a:	60a6                	ld	ra,72(sp)
    80003d3c:	6406                	ld	s0,64(sp)
    80003d3e:	74e2                	ld	s1,56(sp)
    80003d40:	7942                	ld	s2,48(sp)
    80003d42:	79a2                	ld	s3,40(sp)
    80003d44:	7a02                	ld	s4,32(sp)
    80003d46:	6ae2                	ld	s5,24(sp)
    80003d48:	6b42                	ld	s6,16(sp)
    80003d4a:	6ba2                	ld	s7,8(sp)
    80003d4c:	6c02                	ld	s8,0(sp)
    80003d4e:	6161                	addi	sp,sp,80
    80003d50:	8082                	ret
    ret = (i == n ? n : -1);
    80003d52:	5a7d                	li	s4,-1
    80003d54:	b7d5                	j	80003d38 <filewrite+0xfa>
    panic("filewrite");
    80003d56:	00005517          	auipc	a0,0x5
    80003d5a:	a6a50513          	addi	a0,a0,-1430 # 800087c0 <syscall_names+0x270>
    80003d5e:	00002097          	auipc	ra,0x2
    80003d62:	efa080e7          	jalr	-262(ra) # 80005c58 <panic>
    return -1;
    80003d66:	5a7d                	li	s4,-1
    80003d68:	bfc1                	j	80003d38 <filewrite+0xfa>
      return -1;
    80003d6a:	5a7d                	li	s4,-1
    80003d6c:	b7f1                	j	80003d38 <filewrite+0xfa>
    80003d6e:	5a7d                	li	s4,-1
    80003d70:	b7e1                	j	80003d38 <filewrite+0xfa>

0000000080003d72 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d72:	7179                	addi	sp,sp,-48
    80003d74:	f406                	sd	ra,40(sp)
    80003d76:	f022                	sd	s0,32(sp)
    80003d78:	ec26                	sd	s1,24(sp)
    80003d7a:	e84a                	sd	s2,16(sp)
    80003d7c:	e44e                	sd	s3,8(sp)
    80003d7e:	e052                	sd	s4,0(sp)
    80003d80:	1800                	addi	s0,sp,48
    80003d82:	84aa                	mv	s1,a0
    80003d84:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d86:	0005b023          	sd	zero,0(a1)
    80003d8a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	bf8080e7          	jalr	-1032(ra) # 80003986 <filealloc>
    80003d96:	e088                	sd	a0,0(s1)
    80003d98:	c551                	beqz	a0,80003e24 <pipealloc+0xb2>
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	bec080e7          	jalr	-1044(ra) # 80003986 <filealloc>
    80003da2:	00aa3023          	sd	a0,0(s4)
    80003da6:	c92d                	beqz	a0,80003e18 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003da8:	ffffc097          	auipc	ra,0xffffc
    80003dac:	370080e7          	jalr	880(ra) # 80000118 <kalloc>
    80003db0:	892a                	mv	s2,a0
    80003db2:	c125                	beqz	a0,80003e12 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003db4:	4985                	li	s3,1
    80003db6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dbe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dc2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dc6:	00004597          	auipc	a1,0x4
    80003dca:	61a58593          	addi	a1,a1,1562 # 800083e0 <states.1714+0x1a0>
    80003dce:	00002097          	auipc	ra,0x2
    80003dd2:	344080e7          	jalr	836(ra) # 80006112 <initlock>
  (*f0)->type = FD_PIPE;
    80003dd6:	609c                	ld	a5,0(s1)
    80003dd8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ddc:	609c                	ld	a5,0(s1)
    80003dde:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003de2:	609c                	ld	a5,0(s1)
    80003de4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003de8:	609c                	ld	a5,0(s1)
    80003dea:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dee:	000a3783          	ld	a5,0(s4)
    80003df2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003df6:	000a3783          	ld	a5,0(s4)
    80003dfa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dfe:	000a3783          	ld	a5,0(s4)
    80003e02:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e06:	000a3783          	ld	a5,0(s4)
    80003e0a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e0e:	4501                	li	a0,0
    80003e10:	a025                	j	80003e38 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e12:	6088                	ld	a0,0(s1)
    80003e14:	e501                	bnez	a0,80003e1c <pipealloc+0xaa>
    80003e16:	a039                	j	80003e24 <pipealloc+0xb2>
    80003e18:	6088                	ld	a0,0(s1)
    80003e1a:	c51d                	beqz	a0,80003e48 <pipealloc+0xd6>
    fileclose(*f0);
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	c26080e7          	jalr	-986(ra) # 80003a42 <fileclose>
  if(*f1)
    80003e24:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e28:	557d                	li	a0,-1
  if(*f1)
    80003e2a:	c799                	beqz	a5,80003e38 <pipealloc+0xc6>
    fileclose(*f1);
    80003e2c:	853e                	mv	a0,a5
    80003e2e:	00000097          	auipc	ra,0x0
    80003e32:	c14080e7          	jalr	-1004(ra) # 80003a42 <fileclose>
  return -1;
    80003e36:	557d                	li	a0,-1
}
    80003e38:	70a2                	ld	ra,40(sp)
    80003e3a:	7402                	ld	s0,32(sp)
    80003e3c:	64e2                	ld	s1,24(sp)
    80003e3e:	6942                	ld	s2,16(sp)
    80003e40:	69a2                	ld	s3,8(sp)
    80003e42:	6a02                	ld	s4,0(sp)
    80003e44:	6145                	addi	sp,sp,48
    80003e46:	8082                	ret
  return -1;
    80003e48:	557d                	li	a0,-1
    80003e4a:	b7fd                	j	80003e38 <pipealloc+0xc6>

0000000080003e4c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e4c:	1101                	addi	sp,sp,-32
    80003e4e:	ec06                	sd	ra,24(sp)
    80003e50:	e822                	sd	s0,16(sp)
    80003e52:	e426                	sd	s1,8(sp)
    80003e54:	e04a                	sd	s2,0(sp)
    80003e56:	1000                	addi	s0,sp,32
    80003e58:	84aa                	mv	s1,a0
    80003e5a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e5c:	00002097          	auipc	ra,0x2
    80003e60:	346080e7          	jalr	838(ra) # 800061a2 <acquire>
  if(writable){
    80003e64:	02090d63          	beqz	s2,80003e9e <pipeclose+0x52>
    pi->writeopen = 0;
    80003e68:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e6c:	21848513          	addi	a0,s1,536
    80003e70:	ffffe097          	auipc	ra,0xffffe
    80003e74:	850080e7          	jalr	-1968(ra) # 800016c0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e78:	2204b783          	ld	a5,544(s1)
    80003e7c:	eb95                	bnez	a5,80003eb0 <pipeclose+0x64>
    release(&pi->lock);
    80003e7e:	8526                	mv	a0,s1
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	3d6080e7          	jalr	982(ra) # 80006256 <release>
    kfree((char*)pi);
    80003e88:	8526                	mv	a0,s1
    80003e8a:	ffffc097          	auipc	ra,0xffffc
    80003e8e:	192080e7          	jalr	402(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e92:	60e2                	ld	ra,24(sp)
    80003e94:	6442                	ld	s0,16(sp)
    80003e96:	64a2                	ld	s1,8(sp)
    80003e98:	6902                	ld	s2,0(sp)
    80003e9a:	6105                	addi	sp,sp,32
    80003e9c:	8082                	ret
    pi->readopen = 0;
    80003e9e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ea2:	21c48513          	addi	a0,s1,540
    80003ea6:	ffffe097          	auipc	ra,0xffffe
    80003eaa:	81a080e7          	jalr	-2022(ra) # 800016c0 <wakeup>
    80003eae:	b7e9                	j	80003e78 <pipeclose+0x2c>
    release(&pi->lock);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	3a4080e7          	jalr	932(ra) # 80006256 <release>
}
    80003eba:	bfe1                	j	80003e92 <pipeclose+0x46>

0000000080003ebc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ebc:	7159                	addi	sp,sp,-112
    80003ebe:	f486                	sd	ra,104(sp)
    80003ec0:	f0a2                	sd	s0,96(sp)
    80003ec2:	eca6                	sd	s1,88(sp)
    80003ec4:	e8ca                	sd	s2,80(sp)
    80003ec6:	e4ce                	sd	s3,72(sp)
    80003ec8:	e0d2                	sd	s4,64(sp)
    80003eca:	fc56                	sd	s5,56(sp)
    80003ecc:	f85a                	sd	s6,48(sp)
    80003ece:	f45e                	sd	s7,40(sp)
    80003ed0:	f062                	sd	s8,32(sp)
    80003ed2:	ec66                	sd	s9,24(sp)
    80003ed4:	1880                	addi	s0,sp,112
    80003ed6:	84aa                	mv	s1,a0
    80003ed8:	8aae                	mv	s5,a1
    80003eda:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003edc:	ffffd097          	auipc	ra,0xffffd
    80003ee0:	f90080e7          	jalr	-112(ra) # 80000e6c <myproc>
    80003ee4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ee6:	8526                	mv	a0,s1
    80003ee8:	00002097          	auipc	ra,0x2
    80003eec:	2ba080e7          	jalr	698(ra) # 800061a2 <acquire>
  while(i < n){
    80003ef0:	0d405163          	blez	s4,80003fb2 <pipewrite+0xf6>
    80003ef4:	8ba6                	mv	s7,s1
  int i = 0;
    80003ef6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ef8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003efa:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003efe:	21c48c13          	addi	s8,s1,540
    80003f02:	a08d                	j	80003f64 <pipewrite+0xa8>
      release(&pi->lock);
    80003f04:	8526                	mv	a0,s1
    80003f06:	00002097          	auipc	ra,0x2
    80003f0a:	350080e7          	jalr	848(ra) # 80006256 <release>
      return -1;
    80003f0e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f10:	854a                	mv	a0,s2
    80003f12:	70a6                	ld	ra,104(sp)
    80003f14:	7406                	ld	s0,96(sp)
    80003f16:	64e6                	ld	s1,88(sp)
    80003f18:	6946                	ld	s2,80(sp)
    80003f1a:	69a6                	ld	s3,72(sp)
    80003f1c:	6a06                	ld	s4,64(sp)
    80003f1e:	7ae2                	ld	s5,56(sp)
    80003f20:	7b42                	ld	s6,48(sp)
    80003f22:	7ba2                	ld	s7,40(sp)
    80003f24:	7c02                	ld	s8,32(sp)
    80003f26:	6ce2                	ld	s9,24(sp)
    80003f28:	6165                	addi	sp,sp,112
    80003f2a:	8082                	ret
      wakeup(&pi->nread);
    80003f2c:	8566                	mv	a0,s9
    80003f2e:	ffffd097          	auipc	ra,0xffffd
    80003f32:	792080e7          	jalr	1938(ra) # 800016c0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f36:	85de                	mv	a1,s7
    80003f38:	8562                	mv	a0,s8
    80003f3a:	ffffd097          	auipc	ra,0xffffd
    80003f3e:	5fa080e7          	jalr	1530(ra) # 80001534 <sleep>
    80003f42:	a839                	j	80003f60 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f44:	21c4a783          	lw	a5,540(s1)
    80003f48:	0017871b          	addiw	a4,a5,1
    80003f4c:	20e4ae23          	sw	a4,540(s1)
    80003f50:	1ff7f793          	andi	a5,a5,511
    80003f54:	97a6                	add	a5,a5,s1
    80003f56:	f9f44703          	lbu	a4,-97(s0)
    80003f5a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f5e:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f60:	03495d63          	bge	s2,s4,80003f9a <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80003f64:	2204a783          	lw	a5,544(s1)
    80003f68:	dfd1                	beqz	a5,80003f04 <pipewrite+0x48>
    80003f6a:	0289a783          	lw	a5,40(s3)
    80003f6e:	fbd9                	bnez	a5,80003f04 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f70:	2184a783          	lw	a5,536(s1)
    80003f74:	21c4a703          	lw	a4,540(s1)
    80003f78:	2007879b          	addiw	a5,a5,512
    80003f7c:	faf708e3          	beq	a4,a5,80003f2c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f80:	4685                	li	a3,1
    80003f82:	01590633          	add	a2,s2,s5
    80003f86:	f9f40593          	addi	a1,s0,-97
    80003f8a:	0509b503          	ld	a0,80(s3)
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	c2c080e7          	jalr	-980(ra) # 80000bba <copyin>
    80003f96:	fb6517e3          	bne	a0,s6,80003f44 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003f9a:	21848513          	addi	a0,s1,536
    80003f9e:	ffffd097          	auipc	ra,0xffffd
    80003fa2:	722080e7          	jalr	1826(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	2ae080e7          	jalr	686(ra) # 80006256 <release>
  return i;
    80003fb0:	b785                	j	80003f10 <pipewrite+0x54>
  int i = 0;
    80003fb2:	4901                	li	s2,0
    80003fb4:	b7dd                	j	80003f9a <pipewrite+0xde>

0000000080003fb6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fb6:	715d                	addi	sp,sp,-80
    80003fb8:	e486                	sd	ra,72(sp)
    80003fba:	e0a2                	sd	s0,64(sp)
    80003fbc:	fc26                	sd	s1,56(sp)
    80003fbe:	f84a                	sd	s2,48(sp)
    80003fc0:	f44e                	sd	s3,40(sp)
    80003fc2:	f052                	sd	s4,32(sp)
    80003fc4:	ec56                	sd	s5,24(sp)
    80003fc6:	e85a                	sd	s6,16(sp)
    80003fc8:	0880                	addi	s0,sp,80
    80003fca:	84aa                	mv	s1,a0
    80003fcc:	892e                	mv	s2,a1
    80003fce:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	e9c080e7          	jalr	-356(ra) # 80000e6c <myproc>
    80003fd8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fda:	8b26                	mv	s6,s1
    80003fdc:	8526                	mv	a0,s1
    80003fde:	00002097          	auipc	ra,0x2
    80003fe2:	1c4080e7          	jalr	452(ra) # 800061a2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe6:	2184a703          	lw	a4,536(s1)
    80003fea:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fee:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff2:	02f71463          	bne	a4,a5,8000401a <piperead+0x64>
    80003ff6:	2244a783          	lw	a5,548(s1)
    80003ffa:	c385                	beqz	a5,8000401a <piperead+0x64>
    if(pr->killed){
    80003ffc:	028a2783          	lw	a5,40(s4)
    80004000:	ebc1                	bnez	a5,80004090 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004002:	85da                	mv	a1,s6
    80004004:	854e                	mv	a0,s3
    80004006:	ffffd097          	auipc	ra,0xffffd
    8000400a:	52e080e7          	jalr	1326(ra) # 80001534 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400e:	2184a703          	lw	a4,536(s1)
    80004012:	21c4a783          	lw	a5,540(s1)
    80004016:	fef700e3          	beq	a4,a5,80003ff6 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000401a:	09505263          	blez	s5,8000409e <piperead+0xe8>
    8000401e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004020:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004022:	2184a783          	lw	a5,536(s1)
    80004026:	21c4a703          	lw	a4,540(s1)
    8000402a:	02f70d63          	beq	a4,a5,80004064 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000402e:	0017871b          	addiw	a4,a5,1
    80004032:	20e4ac23          	sw	a4,536(s1)
    80004036:	1ff7f793          	andi	a5,a5,511
    8000403a:	97a6                	add	a5,a5,s1
    8000403c:	0187c783          	lbu	a5,24(a5)
    80004040:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004044:	4685                	li	a3,1
    80004046:	fbf40613          	addi	a2,s0,-65
    8000404a:	85ca                	mv	a1,s2
    8000404c:	050a3503          	ld	a0,80(s4)
    80004050:	ffffd097          	auipc	ra,0xffffd
    80004054:	ade080e7          	jalr	-1314(ra) # 80000b2e <copyout>
    80004058:	01650663          	beq	a0,s6,80004064 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000405c:	2985                	addiw	s3,s3,1
    8000405e:	0905                	addi	s2,s2,1
    80004060:	fd3a91e3          	bne	s5,s3,80004022 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004064:	21c48513          	addi	a0,s1,540
    80004068:	ffffd097          	auipc	ra,0xffffd
    8000406c:	658080e7          	jalr	1624(ra) # 800016c0 <wakeup>
  release(&pi->lock);
    80004070:	8526                	mv	a0,s1
    80004072:	00002097          	auipc	ra,0x2
    80004076:	1e4080e7          	jalr	484(ra) # 80006256 <release>
  return i;
}
    8000407a:	854e                	mv	a0,s3
    8000407c:	60a6                	ld	ra,72(sp)
    8000407e:	6406                	ld	s0,64(sp)
    80004080:	74e2                	ld	s1,56(sp)
    80004082:	7942                	ld	s2,48(sp)
    80004084:	79a2                	ld	s3,40(sp)
    80004086:	7a02                	ld	s4,32(sp)
    80004088:	6ae2                	ld	s5,24(sp)
    8000408a:	6b42                	ld	s6,16(sp)
    8000408c:	6161                	addi	sp,sp,80
    8000408e:	8082                	ret
      release(&pi->lock);
    80004090:	8526                	mv	a0,s1
    80004092:	00002097          	auipc	ra,0x2
    80004096:	1c4080e7          	jalr	452(ra) # 80006256 <release>
      return -1;
    8000409a:	59fd                	li	s3,-1
    8000409c:	bff9                	j	8000407a <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000409e:	4981                	li	s3,0
    800040a0:	b7d1                	j	80004064 <piperead+0xae>

00000000800040a2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800040a2:	df010113          	addi	sp,sp,-528
    800040a6:	20113423          	sd	ra,520(sp)
    800040aa:	20813023          	sd	s0,512(sp)
    800040ae:	ffa6                	sd	s1,504(sp)
    800040b0:	fbca                	sd	s2,496(sp)
    800040b2:	f7ce                	sd	s3,488(sp)
    800040b4:	f3d2                	sd	s4,480(sp)
    800040b6:	efd6                	sd	s5,472(sp)
    800040b8:	ebda                	sd	s6,464(sp)
    800040ba:	e7de                	sd	s7,456(sp)
    800040bc:	e3e2                	sd	s8,448(sp)
    800040be:	ff66                	sd	s9,440(sp)
    800040c0:	fb6a                	sd	s10,432(sp)
    800040c2:	f76e                	sd	s11,424(sp)
    800040c4:	0c00                	addi	s0,sp,528
    800040c6:	84aa                	mv	s1,a0
    800040c8:	dea43c23          	sd	a0,-520(s0)
    800040cc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040d0:	ffffd097          	auipc	ra,0xffffd
    800040d4:	d9c080e7          	jalr	-612(ra) # 80000e6c <myproc>
    800040d8:	892a                	mv	s2,a0

  begin_op();
    800040da:	fffff097          	auipc	ra,0xfffff
    800040de:	49c080e7          	jalr	1180(ra) # 80003576 <begin_op>

  if((ip = namei(path)) == 0){
    800040e2:	8526                	mv	a0,s1
    800040e4:	fffff097          	auipc	ra,0xfffff
    800040e8:	276080e7          	jalr	630(ra) # 8000335a <namei>
    800040ec:	c92d                	beqz	a0,8000415e <exec+0xbc>
    800040ee:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040f0:	fffff097          	auipc	ra,0xfffff
    800040f4:	ab4080e7          	jalr	-1356(ra) # 80002ba4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040f8:	04000713          	li	a4,64
    800040fc:	4681                	li	a3,0
    800040fe:	e5040613          	addi	a2,s0,-432
    80004102:	4581                	li	a1,0
    80004104:	8526                	mv	a0,s1
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	d52080e7          	jalr	-686(ra) # 80002e58 <readi>
    8000410e:	04000793          	li	a5,64
    80004112:	00f51a63          	bne	a0,a5,80004126 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004116:	e5042703          	lw	a4,-432(s0)
    8000411a:	464c47b7          	lui	a5,0x464c4
    8000411e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004122:	04f70463          	beq	a4,a5,8000416a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004126:	8526                	mv	a0,s1
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	cde080e7          	jalr	-802(ra) # 80002e06 <iunlockput>
    end_op();
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	4c6080e7          	jalr	1222(ra) # 800035f6 <end_op>
  }
  return -1;
    80004138:	557d                	li	a0,-1
}
    8000413a:	20813083          	ld	ra,520(sp)
    8000413e:	20013403          	ld	s0,512(sp)
    80004142:	74fe                	ld	s1,504(sp)
    80004144:	795e                	ld	s2,496(sp)
    80004146:	79be                	ld	s3,488(sp)
    80004148:	7a1e                	ld	s4,480(sp)
    8000414a:	6afe                	ld	s5,472(sp)
    8000414c:	6b5e                	ld	s6,464(sp)
    8000414e:	6bbe                	ld	s7,456(sp)
    80004150:	6c1e                	ld	s8,448(sp)
    80004152:	7cfa                	ld	s9,440(sp)
    80004154:	7d5a                	ld	s10,432(sp)
    80004156:	7dba                	ld	s11,424(sp)
    80004158:	21010113          	addi	sp,sp,528
    8000415c:	8082                	ret
    end_op();
    8000415e:	fffff097          	auipc	ra,0xfffff
    80004162:	498080e7          	jalr	1176(ra) # 800035f6 <end_op>
    return -1;
    80004166:	557d                	li	a0,-1
    80004168:	bfc9                	j	8000413a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000416a:	854a                	mv	a0,s2
    8000416c:	ffffd097          	auipc	ra,0xffffd
    80004170:	dc4080e7          	jalr	-572(ra) # 80000f30 <proc_pagetable>
    80004174:	8baa                	mv	s7,a0
    80004176:	d945                	beqz	a0,80004126 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004178:	e7042983          	lw	s3,-400(s0)
    8000417c:	e8845783          	lhu	a5,-376(s0)
    80004180:	c7ad                	beqz	a5,800041ea <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004182:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004184:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    80004186:	6c85                	lui	s9,0x1
    80004188:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000418c:	def43823          	sd	a5,-528(s0)
    80004190:	a42d                	j	800043ba <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004192:	00004517          	auipc	a0,0x4
    80004196:	63e50513          	addi	a0,a0,1598 # 800087d0 <syscall_names+0x280>
    8000419a:	00002097          	auipc	ra,0x2
    8000419e:	abe080e7          	jalr	-1346(ra) # 80005c58 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a2:	8756                	mv	a4,s5
    800041a4:	012d86bb          	addw	a3,s11,s2
    800041a8:	4581                	li	a1,0
    800041aa:	8526                	mv	a0,s1
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	cac080e7          	jalr	-852(ra) # 80002e58 <readi>
    800041b4:	2501                	sext.w	a0,a0
    800041b6:	1aaa9963          	bne	s5,a0,80004368 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800041ba:	6785                	lui	a5,0x1
    800041bc:	0127893b          	addw	s2,a5,s2
    800041c0:	77fd                	lui	a5,0xfffff
    800041c2:	01478a3b          	addw	s4,a5,s4
    800041c6:	1f897163          	bgeu	s2,s8,800043a8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800041ca:	02091593          	slli	a1,s2,0x20
    800041ce:	9181                	srli	a1,a1,0x20
    800041d0:	95ea                	add	a1,a1,s10
    800041d2:	855e                	mv	a0,s7
    800041d4:	ffffc097          	auipc	ra,0xffffc
    800041d8:	356080e7          	jalr	854(ra) # 8000052a <walkaddr>
    800041dc:	862a                	mv	a2,a0
    if(pa == 0)
    800041de:	d955                	beqz	a0,80004192 <exec+0xf0>
      n = PGSIZE;
    800041e0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800041e2:	fd9a70e3          	bgeu	s4,s9,800041a2 <exec+0x100>
      n = sz - i;
    800041e6:	8ad2                	mv	s5,s4
    800041e8:	bf6d                	j	800041a2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ea:	4901                	li	s2,0
  iunlockput(ip);
    800041ec:	8526                	mv	a0,s1
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	c18080e7          	jalr	-1000(ra) # 80002e06 <iunlockput>
  end_op();
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	400080e7          	jalr	1024(ra) # 800035f6 <end_op>
  p = myproc();
    800041fe:	ffffd097          	auipc	ra,0xffffd
    80004202:	c6e080e7          	jalr	-914(ra) # 80000e6c <myproc>
    80004206:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004208:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000420c:	6785                	lui	a5,0x1
    8000420e:	17fd                	addi	a5,a5,-1
    80004210:	993e                	add	s2,s2,a5
    80004212:	757d                	lui	a0,0xfffff
    80004214:	00a977b3          	and	a5,s2,a0
    80004218:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000421c:	6609                	lui	a2,0x2
    8000421e:	963e                	add	a2,a2,a5
    80004220:	85be                	mv	a1,a5
    80004222:	855e                	mv	a0,s7
    80004224:	ffffc097          	auipc	ra,0xffffc
    80004228:	6ba080e7          	jalr	1722(ra) # 800008de <uvmalloc>
    8000422c:	8b2a                	mv	s6,a0
  ip = 0;
    8000422e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004230:	12050c63          	beqz	a0,80004368 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004234:	75f9                	lui	a1,0xffffe
    80004236:	95aa                	add	a1,a1,a0
    80004238:	855e                	mv	a0,s7
    8000423a:	ffffd097          	auipc	ra,0xffffd
    8000423e:	8c2080e7          	jalr	-1854(ra) # 80000afc <uvmclear>
  stackbase = sp - PGSIZE;
    80004242:	7c7d                	lui	s8,0xfffff
    80004244:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004246:	e0043783          	ld	a5,-512(s0)
    8000424a:	6388                	ld	a0,0(a5)
    8000424c:	c535                	beqz	a0,800042b8 <exec+0x216>
    8000424e:	e9040993          	addi	s3,s0,-368
    80004252:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004256:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004258:	ffffc097          	auipc	ra,0xffffc
    8000425c:	0c8080e7          	jalr	200(ra) # 80000320 <strlen>
    80004260:	2505                	addiw	a0,a0,1
    80004262:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004266:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000426a:	13896363          	bltu	s2,s8,80004390 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000426e:	e0043d83          	ld	s11,-512(s0)
    80004272:	000dba03          	ld	s4,0(s11)
    80004276:	8552                	mv	a0,s4
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	0a8080e7          	jalr	168(ra) # 80000320 <strlen>
    80004280:	0015069b          	addiw	a3,a0,1
    80004284:	8652                	mv	a2,s4
    80004286:	85ca                	mv	a1,s2
    80004288:	855e                	mv	a0,s7
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	8a4080e7          	jalr	-1884(ra) # 80000b2e <copyout>
    80004292:	10054363          	bltz	a0,80004398 <exec+0x2f6>
    ustack[argc] = sp;
    80004296:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000429a:	0485                	addi	s1,s1,1
    8000429c:	008d8793          	addi	a5,s11,8
    800042a0:	e0f43023          	sd	a5,-512(s0)
    800042a4:	008db503          	ld	a0,8(s11)
    800042a8:	c911                	beqz	a0,800042bc <exec+0x21a>
    if(argc >= MAXARG)
    800042aa:	09a1                	addi	s3,s3,8
    800042ac:	fb3c96e3          	bne	s9,s3,80004258 <exec+0x1b6>
  sz = sz1;
    800042b0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042b4:	4481                	li	s1,0
    800042b6:	a84d                	j	80004368 <exec+0x2c6>
  sp = sz;
    800042b8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ba:	4481                	li	s1,0
  ustack[argc] = 0;
    800042bc:	00349793          	slli	a5,s1,0x3
    800042c0:	f9040713          	addi	a4,s0,-112
    800042c4:	97ba                	add	a5,a5,a4
    800042c6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800042ca:	00148693          	addi	a3,s1,1
    800042ce:	068e                	slli	a3,a3,0x3
    800042d0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800042d4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800042d8:	01897663          	bgeu	s2,s8,800042e4 <exec+0x242>
  sz = sz1;
    800042dc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800042e0:	4481                	li	s1,0
    800042e2:	a059                	j	80004368 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800042e4:	e9040613          	addi	a2,s0,-368
    800042e8:	85ca                	mv	a1,s2
    800042ea:	855e                	mv	a0,s7
    800042ec:	ffffd097          	auipc	ra,0xffffd
    800042f0:	842080e7          	jalr	-1982(ra) # 80000b2e <copyout>
    800042f4:	0a054663          	bltz	a0,800043a0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    800042f8:	058ab783          	ld	a5,88(s5)
    800042fc:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004300:	df843783          	ld	a5,-520(s0)
    80004304:	0007c703          	lbu	a4,0(a5)
    80004308:	cf11                	beqz	a4,80004324 <exec+0x282>
    8000430a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000430c:	02f00693          	li	a3,47
    80004310:	a039                	j	8000431e <exec+0x27c>
      last = s+1;
    80004312:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004316:	0785                	addi	a5,a5,1
    80004318:	fff7c703          	lbu	a4,-1(a5)
    8000431c:	c701                	beqz	a4,80004324 <exec+0x282>
    if(*s == '/')
    8000431e:	fed71ce3          	bne	a4,a3,80004316 <exec+0x274>
    80004322:	bfc5                	j	80004312 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004324:	4641                	li	a2,16
    80004326:	df843583          	ld	a1,-520(s0)
    8000432a:	158a8513          	addi	a0,s5,344
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	fc0080e7          	jalr	-64(ra) # 800002ee <safestrcpy>
  oldpagetable = p->pagetable;
    80004336:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000433a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000433e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004342:	058ab783          	ld	a5,88(s5)
    80004346:	e6843703          	ld	a4,-408(s0)
    8000434a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000434c:	058ab783          	ld	a5,88(s5)
    80004350:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004354:	85ea                	mv	a1,s10
    80004356:	ffffd097          	auipc	ra,0xffffd
    8000435a:	c76080e7          	jalr	-906(ra) # 80000fcc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000435e:	0004851b          	sext.w	a0,s1
    80004362:	bbe1                	j	8000413a <exec+0x98>
    80004364:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004368:	e0843583          	ld	a1,-504(s0)
    8000436c:	855e                	mv	a0,s7
    8000436e:	ffffd097          	auipc	ra,0xffffd
    80004372:	c5e080e7          	jalr	-930(ra) # 80000fcc <proc_freepagetable>
  if(ip){
    80004376:	da0498e3          	bnez	s1,80004126 <exec+0x84>
  return -1;
    8000437a:	557d                	li	a0,-1
    8000437c:	bb7d                	j	8000413a <exec+0x98>
    8000437e:	e1243423          	sd	s2,-504(s0)
    80004382:	b7dd                	j	80004368 <exec+0x2c6>
    80004384:	e1243423          	sd	s2,-504(s0)
    80004388:	b7c5                	j	80004368 <exec+0x2c6>
    8000438a:	e1243423          	sd	s2,-504(s0)
    8000438e:	bfe9                	j	80004368 <exec+0x2c6>
  sz = sz1;
    80004390:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004394:	4481                	li	s1,0
    80004396:	bfc9                	j	80004368 <exec+0x2c6>
  sz = sz1;
    80004398:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000439c:	4481                	li	s1,0
    8000439e:	b7e9                	j	80004368 <exec+0x2c6>
  sz = sz1;
    800043a0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a4:	4481                	li	s1,0
    800043a6:	b7c9                	j	80004368 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043a8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ac:	2b05                	addiw	s6,s6,1
    800043ae:	0389899b          	addiw	s3,s3,56
    800043b2:	e8845783          	lhu	a5,-376(s0)
    800043b6:	e2fb5be3          	bge	s6,a5,800041ec <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043ba:	2981                	sext.w	s3,s3
    800043bc:	03800713          	li	a4,56
    800043c0:	86ce                	mv	a3,s3
    800043c2:	e1840613          	addi	a2,s0,-488
    800043c6:	4581                	li	a1,0
    800043c8:	8526                	mv	a0,s1
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	a8e080e7          	jalr	-1394(ra) # 80002e58 <readi>
    800043d2:	03800793          	li	a5,56
    800043d6:	f8f517e3          	bne	a0,a5,80004364 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    800043da:	e1842783          	lw	a5,-488(s0)
    800043de:	4705                	li	a4,1
    800043e0:	fce796e3          	bne	a5,a4,800043ac <exec+0x30a>
    if(ph.memsz < ph.filesz)
    800043e4:	e4043603          	ld	a2,-448(s0)
    800043e8:	e3843783          	ld	a5,-456(s0)
    800043ec:	f8f669e3          	bltu	a2,a5,8000437e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800043f0:	e2843783          	ld	a5,-472(s0)
    800043f4:	963e                	add	a2,a2,a5
    800043f6:	f8f667e3          	bltu	a2,a5,80004384 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800043fa:	85ca                	mv	a1,s2
    800043fc:	855e                	mv	a0,s7
    800043fe:	ffffc097          	auipc	ra,0xffffc
    80004402:	4e0080e7          	jalr	1248(ra) # 800008de <uvmalloc>
    80004406:	e0a43423          	sd	a0,-504(s0)
    8000440a:	d141                	beqz	a0,8000438a <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000440c:	e2843d03          	ld	s10,-472(s0)
    80004410:	df043783          	ld	a5,-528(s0)
    80004414:	00fd77b3          	and	a5,s10,a5
    80004418:	fba1                	bnez	a5,80004368 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000441a:	e2042d83          	lw	s11,-480(s0)
    8000441e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004422:	f80c03e3          	beqz	s8,800043a8 <exec+0x306>
    80004426:	8a62                	mv	s4,s8
    80004428:	4901                	li	s2,0
    8000442a:	b345                	j	800041ca <exec+0x128>

000000008000442c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000442c:	7179                	addi	sp,sp,-48
    8000442e:	f406                	sd	ra,40(sp)
    80004430:	f022                	sd	s0,32(sp)
    80004432:	ec26                	sd	s1,24(sp)
    80004434:	e84a                	sd	s2,16(sp)
    80004436:	1800                	addi	s0,sp,48
    80004438:	892e                	mv	s2,a1
    8000443a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000443c:	fdc40593          	addi	a1,s0,-36
    80004440:	ffffe097          	auipc	ra,0xffffe
    80004444:	b14080e7          	jalr	-1260(ra) # 80001f54 <argint>
    80004448:	04054063          	bltz	a0,80004488 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000444c:	fdc42703          	lw	a4,-36(s0)
    80004450:	47bd                	li	a5,15
    80004452:	02e7ed63          	bltu	a5,a4,8000448c <argfd+0x60>
    80004456:	ffffd097          	auipc	ra,0xffffd
    8000445a:	a16080e7          	jalr	-1514(ra) # 80000e6c <myproc>
    8000445e:	fdc42703          	lw	a4,-36(s0)
    80004462:	01a70793          	addi	a5,a4,26
    80004466:	078e                	slli	a5,a5,0x3
    80004468:	953e                	add	a0,a0,a5
    8000446a:	611c                	ld	a5,0(a0)
    8000446c:	c395                	beqz	a5,80004490 <argfd+0x64>
    return -1;
  if(pfd)
    8000446e:	00090463          	beqz	s2,80004476 <argfd+0x4a>
    *pfd = fd;
    80004472:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004476:	4501                	li	a0,0
  if(pf)
    80004478:	c091                	beqz	s1,8000447c <argfd+0x50>
    *pf = f;
    8000447a:	e09c                	sd	a5,0(s1)
}
    8000447c:	70a2                	ld	ra,40(sp)
    8000447e:	7402                	ld	s0,32(sp)
    80004480:	64e2                	ld	s1,24(sp)
    80004482:	6942                	ld	s2,16(sp)
    80004484:	6145                	addi	sp,sp,48
    80004486:	8082                	ret
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	bfcd                	j	8000447c <argfd+0x50>
    return -1;
    8000448c:	557d                	li	a0,-1
    8000448e:	b7fd                	j	8000447c <argfd+0x50>
    80004490:	557d                	li	a0,-1
    80004492:	b7ed                	j	8000447c <argfd+0x50>

0000000080004494 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004494:	1101                	addi	sp,sp,-32
    80004496:	ec06                	sd	ra,24(sp)
    80004498:	e822                	sd	s0,16(sp)
    8000449a:	e426                	sd	s1,8(sp)
    8000449c:	1000                	addi	s0,sp,32
    8000449e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044a0:	ffffd097          	auipc	ra,0xffffd
    800044a4:	9cc080e7          	jalr	-1588(ra) # 80000e6c <myproc>
    800044a8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044aa:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd8e90>
    800044ae:	4501                	li	a0,0
    800044b0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044b2:	6398                	ld	a4,0(a5)
    800044b4:	cb19                	beqz	a4,800044ca <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044b6:	2505                	addiw	a0,a0,1
    800044b8:	07a1                	addi	a5,a5,8
    800044ba:	fed51ce3          	bne	a0,a3,800044b2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044be:	557d                	li	a0,-1
}
    800044c0:	60e2                	ld	ra,24(sp)
    800044c2:	6442                	ld	s0,16(sp)
    800044c4:	64a2                	ld	s1,8(sp)
    800044c6:	6105                	addi	sp,sp,32
    800044c8:	8082                	ret
      p->ofile[fd] = f;
    800044ca:	01a50793          	addi	a5,a0,26
    800044ce:	078e                	slli	a5,a5,0x3
    800044d0:	963e                	add	a2,a2,a5
    800044d2:	e204                	sd	s1,0(a2)
      return fd;
    800044d4:	b7f5                	j	800044c0 <fdalloc+0x2c>

00000000800044d6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044d6:	715d                	addi	sp,sp,-80
    800044d8:	e486                	sd	ra,72(sp)
    800044da:	e0a2                	sd	s0,64(sp)
    800044dc:	fc26                	sd	s1,56(sp)
    800044de:	f84a                	sd	s2,48(sp)
    800044e0:	f44e                	sd	s3,40(sp)
    800044e2:	f052                	sd	s4,32(sp)
    800044e4:	ec56                	sd	s5,24(sp)
    800044e6:	0880                	addi	s0,sp,80
    800044e8:	89ae                	mv	s3,a1
    800044ea:	8ab2                	mv	s5,a2
    800044ec:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044ee:	fb040593          	addi	a1,s0,-80
    800044f2:	fffff097          	auipc	ra,0xfffff
    800044f6:	e86080e7          	jalr	-378(ra) # 80003378 <nameiparent>
    800044fa:	892a                	mv	s2,a0
    800044fc:	12050f63          	beqz	a0,8000463a <create+0x164>
    return 0;

  ilock(dp);
    80004500:	ffffe097          	auipc	ra,0xffffe
    80004504:	6a4080e7          	jalr	1700(ra) # 80002ba4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004508:	4601                	li	a2,0
    8000450a:	fb040593          	addi	a1,s0,-80
    8000450e:	854a                	mv	a0,s2
    80004510:	fffff097          	auipc	ra,0xfffff
    80004514:	b78080e7          	jalr	-1160(ra) # 80003088 <dirlookup>
    80004518:	84aa                	mv	s1,a0
    8000451a:	c921                	beqz	a0,8000456a <create+0x94>
    iunlockput(dp);
    8000451c:	854a                	mv	a0,s2
    8000451e:	fffff097          	auipc	ra,0xfffff
    80004522:	8e8080e7          	jalr	-1816(ra) # 80002e06 <iunlockput>
    ilock(ip);
    80004526:	8526                	mv	a0,s1
    80004528:	ffffe097          	auipc	ra,0xffffe
    8000452c:	67c080e7          	jalr	1660(ra) # 80002ba4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004530:	2981                	sext.w	s3,s3
    80004532:	4789                	li	a5,2
    80004534:	02f99463          	bne	s3,a5,8000455c <create+0x86>
    80004538:	0444d783          	lhu	a5,68(s1)
    8000453c:	37f9                	addiw	a5,a5,-2
    8000453e:	17c2                	slli	a5,a5,0x30
    80004540:	93c1                	srli	a5,a5,0x30
    80004542:	4705                	li	a4,1
    80004544:	00f76c63          	bltu	a4,a5,8000455c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004548:	8526                	mv	a0,s1
    8000454a:	60a6                	ld	ra,72(sp)
    8000454c:	6406                	ld	s0,64(sp)
    8000454e:	74e2                	ld	s1,56(sp)
    80004550:	7942                	ld	s2,48(sp)
    80004552:	79a2                	ld	s3,40(sp)
    80004554:	7a02                	ld	s4,32(sp)
    80004556:	6ae2                	ld	s5,24(sp)
    80004558:	6161                	addi	sp,sp,80
    8000455a:	8082                	ret
    iunlockput(ip);
    8000455c:	8526                	mv	a0,s1
    8000455e:	fffff097          	auipc	ra,0xfffff
    80004562:	8a8080e7          	jalr	-1880(ra) # 80002e06 <iunlockput>
    return 0;
    80004566:	4481                	li	s1,0
    80004568:	b7c5                	j	80004548 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000456a:	85ce                	mv	a1,s3
    8000456c:	00092503          	lw	a0,0(s2)
    80004570:	ffffe097          	auipc	ra,0xffffe
    80004574:	49c080e7          	jalr	1180(ra) # 80002a0c <ialloc>
    80004578:	84aa                	mv	s1,a0
    8000457a:	c529                	beqz	a0,800045c4 <create+0xee>
  ilock(ip);
    8000457c:	ffffe097          	auipc	ra,0xffffe
    80004580:	628080e7          	jalr	1576(ra) # 80002ba4 <ilock>
  ip->major = major;
    80004584:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80004588:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000458c:	4785                	li	a5,1
    8000458e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004592:	8526                	mv	a0,s1
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	546080e7          	jalr	1350(ra) # 80002ada <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000459c:	2981                	sext.w	s3,s3
    8000459e:	4785                	li	a5,1
    800045a0:	02f98a63          	beq	s3,a5,800045d4 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800045a4:	40d0                	lw	a2,4(s1)
    800045a6:	fb040593          	addi	a1,s0,-80
    800045aa:	854a                	mv	a0,s2
    800045ac:	fffff097          	auipc	ra,0xfffff
    800045b0:	cec080e7          	jalr	-788(ra) # 80003298 <dirlink>
    800045b4:	06054b63          	bltz	a0,8000462a <create+0x154>
  iunlockput(dp);
    800045b8:	854a                	mv	a0,s2
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	84c080e7          	jalr	-1972(ra) # 80002e06 <iunlockput>
  return ip;
    800045c2:	b759                	j	80004548 <create+0x72>
    panic("create: ialloc");
    800045c4:	00004517          	auipc	a0,0x4
    800045c8:	22c50513          	addi	a0,a0,556 # 800087f0 <syscall_names+0x2a0>
    800045cc:	00001097          	auipc	ra,0x1
    800045d0:	68c080e7          	jalr	1676(ra) # 80005c58 <panic>
    dp->nlink++;  // for ".."
    800045d4:	04a95783          	lhu	a5,74(s2)
    800045d8:	2785                	addiw	a5,a5,1
    800045da:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045de:	854a                	mv	a0,s2
    800045e0:	ffffe097          	auipc	ra,0xffffe
    800045e4:	4fa080e7          	jalr	1274(ra) # 80002ada <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045e8:	40d0                	lw	a2,4(s1)
    800045ea:	00004597          	auipc	a1,0x4
    800045ee:	21658593          	addi	a1,a1,534 # 80008800 <syscall_names+0x2b0>
    800045f2:	8526                	mv	a0,s1
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	ca4080e7          	jalr	-860(ra) # 80003298 <dirlink>
    800045fc:	00054f63          	bltz	a0,8000461a <create+0x144>
    80004600:	00492603          	lw	a2,4(s2)
    80004604:	00004597          	auipc	a1,0x4
    80004608:	20458593          	addi	a1,a1,516 # 80008808 <syscall_names+0x2b8>
    8000460c:	8526                	mv	a0,s1
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	c8a080e7          	jalr	-886(ra) # 80003298 <dirlink>
    80004616:	f80557e3          	bgez	a0,800045a4 <create+0xce>
      panic("create dots");
    8000461a:	00004517          	auipc	a0,0x4
    8000461e:	1f650513          	addi	a0,a0,502 # 80008810 <syscall_names+0x2c0>
    80004622:	00001097          	auipc	ra,0x1
    80004626:	636080e7          	jalr	1590(ra) # 80005c58 <panic>
    panic("create: dirlink");
    8000462a:	00004517          	auipc	a0,0x4
    8000462e:	1f650513          	addi	a0,a0,502 # 80008820 <syscall_names+0x2d0>
    80004632:	00001097          	auipc	ra,0x1
    80004636:	626080e7          	jalr	1574(ra) # 80005c58 <panic>
    return 0;
    8000463a:	84aa                	mv	s1,a0
    8000463c:	b731                	j	80004548 <create+0x72>

000000008000463e <sys_dup>:
{
    8000463e:	7179                	addi	sp,sp,-48
    80004640:	f406                	sd	ra,40(sp)
    80004642:	f022                	sd	s0,32(sp)
    80004644:	ec26                	sd	s1,24(sp)
    80004646:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004648:	fd840613          	addi	a2,s0,-40
    8000464c:	4581                	li	a1,0
    8000464e:	4501                	li	a0,0
    80004650:	00000097          	auipc	ra,0x0
    80004654:	ddc080e7          	jalr	-548(ra) # 8000442c <argfd>
    return -1;
    80004658:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000465a:	02054363          	bltz	a0,80004680 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000465e:	fd843503          	ld	a0,-40(s0)
    80004662:	00000097          	auipc	ra,0x0
    80004666:	e32080e7          	jalr	-462(ra) # 80004494 <fdalloc>
    8000466a:	84aa                	mv	s1,a0
    return -1;
    8000466c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000466e:	00054963          	bltz	a0,80004680 <sys_dup+0x42>
  filedup(f);
    80004672:	fd843503          	ld	a0,-40(s0)
    80004676:	fffff097          	auipc	ra,0xfffff
    8000467a:	37a080e7          	jalr	890(ra) # 800039f0 <filedup>
  return fd;
    8000467e:	87a6                	mv	a5,s1
}
    80004680:	853e                	mv	a0,a5
    80004682:	70a2                	ld	ra,40(sp)
    80004684:	7402                	ld	s0,32(sp)
    80004686:	64e2                	ld	s1,24(sp)
    80004688:	6145                	addi	sp,sp,48
    8000468a:	8082                	ret

000000008000468c <sys_read>:
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004694:	fe840613          	addi	a2,s0,-24
    80004698:	4581                	li	a1,0
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	d90080e7          	jalr	-624(ra) # 8000442c <argfd>
    return -1;
    800046a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a6:	04054163          	bltz	a0,800046e8 <sys_read+0x5c>
    800046aa:	fe440593          	addi	a1,s0,-28
    800046ae:	4509                	li	a0,2
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	8a4080e7          	jalr	-1884(ra) # 80001f54 <argint>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	02054763          	bltz	a0,800046e8 <sys_read+0x5c>
    800046be:	fd840593          	addi	a1,s0,-40
    800046c2:	4505                	li	a0,1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	8b2080e7          	jalr	-1870(ra) # 80001f76 <argaddr>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	00054d63          	bltz	a0,800046e8 <sys_read+0x5c>
  return fileread(f, p, n);
    800046d2:	fe442603          	lw	a2,-28(s0)
    800046d6:	fd843583          	ld	a1,-40(s0)
    800046da:	fe843503          	ld	a0,-24(s0)
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	49e080e7          	jalr	1182(ra) # 80003b7c <fileread>
    800046e6:	87aa                	mv	a5,a0
}
    800046e8:	853e                	mv	a0,a5
    800046ea:	70a2                	ld	ra,40(sp)
    800046ec:	7402                	ld	s0,32(sp)
    800046ee:	6145                	addi	sp,sp,48
    800046f0:	8082                	ret

00000000800046f2 <sys_write>:
{
    800046f2:	7179                	addi	sp,sp,-48
    800046f4:	f406                	sd	ra,40(sp)
    800046f6:	f022                	sd	s0,32(sp)
    800046f8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	fe840613          	addi	a2,s0,-24
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	d2a080e7          	jalr	-726(ra) # 8000442c <argfd>
    return -1;
    8000470a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470c:	04054163          	bltz	a0,8000474e <sys_write+0x5c>
    80004710:	fe440593          	addi	a1,s0,-28
    80004714:	4509                	li	a0,2
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	83e080e7          	jalr	-1986(ra) # 80001f54 <argint>
    return -1;
    8000471e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004720:	02054763          	bltz	a0,8000474e <sys_write+0x5c>
    80004724:	fd840593          	addi	a1,s0,-40
    80004728:	4505                	li	a0,1
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	84c080e7          	jalr	-1972(ra) # 80001f76 <argaddr>
    return -1;
    80004732:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004734:	00054d63          	bltz	a0,8000474e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004738:	fe442603          	lw	a2,-28(s0)
    8000473c:	fd843583          	ld	a1,-40(s0)
    80004740:	fe843503          	ld	a0,-24(s0)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	4fa080e7          	jalr	1274(ra) # 80003c3e <filewrite>
    8000474c:	87aa                	mv	a5,a0
}
    8000474e:	853e                	mv	a0,a5
    80004750:	70a2                	ld	ra,40(sp)
    80004752:	7402                	ld	s0,32(sp)
    80004754:	6145                	addi	sp,sp,48
    80004756:	8082                	ret

0000000080004758 <sys_close>:
{
    80004758:	1101                	addi	sp,sp,-32
    8000475a:	ec06                	sd	ra,24(sp)
    8000475c:	e822                	sd	s0,16(sp)
    8000475e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004760:	fe040613          	addi	a2,s0,-32
    80004764:	fec40593          	addi	a1,s0,-20
    80004768:	4501                	li	a0,0
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	cc2080e7          	jalr	-830(ra) # 8000442c <argfd>
    return -1;
    80004772:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004774:	02054463          	bltz	a0,8000479c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	6f4080e7          	jalr	1780(ra) # 80000e6c <myproc>
    80004780:	fec42783          	lw	a5,-20(s0)
    80004784:	07e9                	addi	a5,a5,26
    80004786:	078e                	slli	a5,a5,0x3
    80004788:	97aa                	add	a5,a5,a0
    8000478a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000478e:	fe043503          	ld	a0,-32(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	2b0080e7          	jalr	688(ra) # 80003a42 <fileclose>
  return 0;
    8000479a:	4781                	li	a5,0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	60e2                	ld	ra,24(sp)
    800047a0:	6442                	ld	s0,16(sp)
    800047a2:	6105                	addi	sp,sp,32
    800047a4:	8082                	ret

00000000800047a6 <sys_fstat>:
{
    800047a6:	1101                	addi	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ae:	fe840613          	addi	a2,s0,-24
    800047b2:	4581                	li	a1,0
    800047b4:	4501                	li	a0,0
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	c76080e7          	jalr	-906(ra) # 8000442c <argfd>
    return -1;
    800047be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c0:	02054563          	bltz	a0,800047ea <sys_fstat+0x44>
    800047c4:	fe040593          	addi	a1,s0,-32
    800047c8:	4505                	li	a0,1
    800047ca:	ffffd097          	auipc	ra,0xffffd
    800047ce:	7ac080e7          	jalr	1964(ra) # 80001f76 <argaddr>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d4:	00054b63          	bltz	a0,800047ea <sys_fstat+0x44>
  return filestat(f, st);
    800047d8:	fe043583          	ld	a1,-32(s0)
    800047dc:	fe843503          	ld	a0,-24(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	32a080e7          	jalr	810(ra) # 80003b0a <filestat>
    800047e8:	87aa                	mv	a5,a0
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	60e2                	ld	ra,24(sp)
    800047ee:	6442                	ld	s0,16(sp)
    800047f0:	6105                	addi	sp,sp,32
    800047f2:	8082                	ret

00000000800047f4 <sys_link>:
{
    800047f4:	7169                	addi	sp,sp,-304
    800047f6:	f606                	sd	ra,296(sp)
    800047f8:	f222                	sd	s0,288(sp)
    800047fa:	ee26                	sd	s1,280(sp)
    800047fc:	ea4a                	sd	s2,272(sp)
    800047fe:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004800:	08000613          	li	a2,128
    80004804:	ed040593          	addi	a1,s0,-304
    80004808:	4501                	li	a0,0
    8000480a:	ffffd097          	auipc	ra,0xffffd
    8000480e:	78e080e7          	jalr	1934(ra) # 80001f98 <argstr>
    return -1;
    80004812:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004814:	10054e63          	bltz	a0,80004930 <sys_link+0x13c>
    80004818:	08000613          	li	a2,128
    8000481c:	f5040593          	addi	a1,s0,-176
    80004820:	4505                	li	a0,1
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	776080e7          	jalr	1910(ra) # 80001f98 <argstr>
    return -1;
    8000482a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000482c:	10054263          	bltz	a0,80004930 <sys_link+0x13c>
  begin_op();
    80004830:	fffff097          	auipc	ra,0xfffff
    80004834:	d46080e7          	jalr	-698(ra) # 80003576 <begin_op>
  if((ip = namei(old)) == 0){
    80004838:	ed040513          	addi	a0,s0,-304
    8000483c:	fffff097          	auipc	ra,0xfffff
    80004840:	b1e080e7          	jalr	-1250(ra) # 8000335a <namei>
    80004844:	84aa                	mv	s1,a0
    80004846:	c551                	beqz	a0,800048d2 <sys_link+0xde>
  ilock(ip);
    80004848:	ffffe097          	auipc	ra,0xffffe
    8000484c:	35c080e7          	jalr	860(ra) # 80002ba4 <ilock>
  if(ip->type == T_DIR){
    80004850:	04449703          	lh	a4,68(s1)
    80004854:	4785                	li	a5,1
    80004856:	08f70463          	beq	a4,a5,800048de <sys_link+0xea>
  ip->nlink++;
    8000485a:	04a4d783          	lhu	a5,74(s1)
    8000485e:	2785                	addiw	a5,a5,1
    80004860:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004864:	8526                	mv	a0,s1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	274080e7          	jalr	628(ra) # 80002ada <iupdate>
  iunlock(ip);
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	3f6080e7          	jalr	1014(ra) # 80002c66 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004878:	fd040593          	addi	a1,s0,-48
    8000487c:	f5040513          	addi	a0,s0,-176
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	af8080e7          	jalr	-1288(ra) # 80003378 <nameiparent>
    80004888:	892a                	mv	s2,a0
    8000488a:	c935                	beqz	a0,800048fe <sys_link+0x10a>
  ilock(dp);
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	318080e7          	jalr	792(ra) # 80002ba4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004894:	00092703          	lw	a4,0(s2)
    80004898:	409c                	lw	a5,0(s1)
    8000489a:	04f71d63          	bne	a4,a5,800048f4 <sys_link+0x100>
    8000489e:	40d0                	lw	a2,4(s1)
    800048a0:	fd040593          	addi	a1,s0,-48
    800048a4:	854a                	mv	a0,s2
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	9f2080e7          	jalr	-1550(ra) # 80003298 <dirlink>
    800048ae:	04054363          	bltz	a0,800048f4 <sys_link+0x100>
  iunlockput(dp);
    800048b2:	854a                	mv	a0,s2
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	552080e7          	jalr	1362(ra) # 80002e06 <iunlockput>
  iput(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	4a0080e7          	jalr	1184(ra) # 80002d5e <iput>
  end_op();
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	d30080e7          	jalr	-720(ra) # 800035f6 <end_op>
  return 0;
    800048ce:	4781                	li	a5,0
    800048d0:	a085                	j	80004930 <sys_link+0x13c>
    end_op();
    800048d2:	fffff097          	auipc	ra,0xfffff
    800048d6:	d24080e7          	jalr	-732(ra) # 800035f6 <end_op>
    return -1;
    800048da:	57fd                	li	a5,-1
    800048dc:	a891                	j	80004930 <sys_link+0x13c>
    iunlockput(ip);
    800048de:	8526                	mv	a0,s1
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	526080e7          	jalr	1318(ra) # 80002e06 <iunlockput>
    end_op();
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	d0e080e7          	jalr	-754(ra) # 800035f6 <end_op>
    return -1;
    800048f0:	57fd                	li	a5,-1
    800048f2:	a83d                	j	80004930 <sys_link+0x13c>
    iunlockput(dp);
    800048f4:	854a                	mv	a0,s2
    800048f6:	ffffe097          	auipc	ra,0xffffe
    800048fa:	510080e7          	jalr	1296(ra) # 80002e06 <iunlockput>
  ilock(ip);
    800048fe:	8526                	mv	a0,s1
    80004900:	ffffe097          	auipc	ra,0xffffe
    80004904:	2a4080e7          	jalr	676(ra) # 80002ba4 <ilock>
  ip->nlink--;
    80004908:	04a4d783          	lhu	a5,74(s1)
    8000490c:	37fd                	addiw	a5,a5,-1
    8000490e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004912:	8526                	mv	a0,s1
    80004914:	ffffe097          	auipc	ra,0xffffe
    80004918:	1c6080e7          	jalr	454(ra) # 80002ada <iupdate>
  iunlockput(ip);
    8000491c:	8526                	mv	a0,s1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	4e8080e7          	jalr	1256(ra) # 80002e06 <iunlockput>
  end_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	cd0080e7          	jalr	-816(ra) # 800035f6 <end_op>
  return -1;
    8000492e:	57fd                	li	a5,-1
}
    80004930:	853e                	mv	a0,a5
    80004932:	70b2                	ld	ra,296(sp)
    80004934:	7412                	ld	s0,288(sp)
    80004936:	64f2                	ld	s1,280(sp)
    80004938:	6952                	ld	s2,272(sp)
    8000493a:	6155                	addi	sp,sp,304
    8000493c:	8082                	ret

000000008000493e <sys_unlink>:
{
    8000493e:	7151                	addi	sp,sp,-240
    80004940:	f586                	sd	ra,232(sp)
    80004942:	f1a2                	sd	s0,224(sp)
    80004944:	eda6                	sd	s1,216(sp)
    80004946:	e9ca                	sd	s2,208(sp)
    80004948:	e5ce                	sd	s3,200(sp)
    8000494a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000494c:	08000613          	li	a2,128
    80004950:	f3040593          	addi	a1,s0,-208
    80004954:	4501                	li	a0,0
    80004956:	ffffd097          	auipc	ra,0xffffd
    8000495a:	642080e7          	jalr	1602(ra) # 80001f98 <argstr>
    8000495e:	18054163          	bltz	a0,80004ae0 <sys_unlink+0x1a2>
  begin_op();
    80004962:	fffff097          	auipc	ra,0xfffff
    80004966:	c14080e7          	jalr	-1004(ra) # 80003576 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000496a:	fb040593          	addi	a1,s0,-80
    8000496e:	f3040513          	addi	a0,s0,-208
    80004972:	fffff097          	auipc	ra,0xfffff
    80004976:	a06080e7          	jalr	-1530(ra) # 80003378 <nameiparent>
    8000497a:	84aa                	mv	s1,a0
    8000497c:	c979                	beqz	a0,80004a52 <sys_unlink+0x114>
  ilock(dp);
    8000497e:	ffffe097          	auipc	ra,0xffffe
    80004982:	226080e7          	jalr	550(ra) # 80002ba4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004986:	00004597          	auipc	a1,0x4
    8000498a:	e7a58593          	addi	a1,a1,-390 # 80008800 <syscall_names+0x2b0>
    8000498e:	fb040513          	addi	a0,s0,-80
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	6dc080e7          	jalr	1756(ra) # 8000306e <namecmp>
    8000499a:	14050a63          	beqz	a0,80004aee <sys_unlink+0x1b0>
    8000499e:	00004597          	auipc	a1,0x4
    800049a2:	e6a58593          	addi	a1,a1,-406 # 80008808 <syscall_names+0x2b8>
    800049a6:	fb040513          	addi	a0,s0,-80
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	6c4080e7          	jalr	1732(ra) # 8000306e <namecmp>
    800049b2:	12050e63          	beqz	a0,80004aee <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049b6:	f2c40613          	addi	a2,s0,-212
    800049ba:	fb040593          	addi	a1,s0,-80
    800049be:	8526                	mv	a0,s1
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	6c8080e7          	jalr	1736(ra) # 80003088 <dirlookup>
    800049c8:	892a                	mv	s2,a0
    800049ca:	12050263          	beqz	a0,80004aee <sys_unlink+0x1b0>
  ilock(ip);
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	1d6080e7          	jalr	470(ra) # 80002ba4 <ilock>
  if(ip->nlink < 1)
    800049d6:	04a91783          	lh	a5,74(s2)
    800049da:	08f05263          	blez	a5,80004a5e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049de:	04491703          	lh	a4,68(s2)
    800049e2:	4785                	li	a5,1
    800049e4:	08f70563          	beq	a4,a5,80004a6e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    800049e8:	4641                	li	a2,16
    800049ea:	4581                	li	a1,0
    800049ec:	fc040513          	addi	a0,s0,-64
    800049f0:	ffffb097          	auipc	ra,0xffffb
    800049f4:	7ac080e7          	jalr	1964(ra) # 8000019c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f8:	4741                	li	a4,16
    800049fa:	f2c42683          	lw	a3,-212(s0)
    800049fe:	fc040613          	addi	a2,s0,-64
    80004a02:	4581                	li	a1,0
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	54a080e7          	jalr	1354(ra) # 80002f50 <writei>
    80004a0e:	47c1                	li	a5,16
    80004a10:	0af51563          	bne	a0,a5,80004aba <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a14:	04491703          	lh	a4,68(s2)
    80004a18:	4785                	li	a5,1
    80004a1a:	0af70863          	beq	a4,a5,80004aca <sys_unlink+0x18c>
  iunlockput(dp);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	3e6080e7          	jalr	998(ra) # 80002e06 <iunlockput>
  ip->nlink--;
    80004a28:	04a95783          	lhu	a5,74(s2)
    80004a2c:	37fd                	addiw	a5,a5,-1
    80004a2e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a32:	854a                	mv	a0,s2
    80004a34:	ffffe097          	auipc	ra,0xffffe
    80004a38:	0a6080e7          	jalr	166(ra) # 80002ada <iupdate>
  iunlockput(ip);
    80004a3c:	854a                	mv	a0,s2
    80004a3e:	ffffe097          	auipc	ra,0xffffe
    80004a42:	3c8080e7          	jalr	968(ra) # 80002e06 <iunlockput>
  end_op();
    80004a46:	fffff097          	auipc	ra,0xfffff
    80004a4a:	bb0080e7          	jalr	-1104(ra) # 800035f6 <end_op>
  return 0;
    80004a4e:	4501                	li	a0,0
    80004a50:	a84d                	j	80004b02 <sys_unlink+0x1c4>
    end_op();
    80004a52:	fffff097          	auipc	ra,0xfffff
    80004a56:	ba4080e7          	jalr	-1116(ra) # 800035f6 <end_op>
    return -1;
    80004a5a:	557d                	li	a0,-1
    80004a5c:	a05d                	j	80004b02 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004a5e:	00004517          	auipc	a0,0x4
    80004a62:	dd250513          	addi	a0,a0,-558 # 80008830 <syscall_names+0x2e0>
    80004a66:	00001097          	auipc	ra,0x1
    80004a6a:	1f2080e7          	jalr	498(ra) # 80005c58 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a6e:	04c92703          	lw	a4,76(s2)
    80004a72:	02000793          	li	a5,32
    80004a76:	f6e7f9e3          	bgeu	a5,a4,800049e8 <sys_unlink+0xaa>
    80004a7a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a7e:	4741                	li	a4,16
    80004a80:	86ce                	mv	a3,s3
    80004a82:	f1840613          	addi	a2,s0,-232
    80004a86:	4581                	li	a1,0
    80004a88:	854a                	mv	a0,s2
    80004a8a:	ffffe097          	auipc	ra,0xffffe
    80004a8e:	3ce080e7          	jalr	974(ra) # 80002e58 <readi>
    80004a92:	47c1                	li	a5,16
    80004a94:	00f51b63          	bne	a0,a5,80004aaa <sys_unlink+0x16c>
    if(de.inum != 0)
    80004a98:	f1845783          	lhu	a5,-232(s0)
    80004a9c:	e7a1                	bnez	a5,80004ae4 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a9e:	29c1                	addiw	s3,s3,16
    80004aa0:	04c92783          	lw	a5,76(s2)
    80004aa4:	fcf9ede3          	bltu	s3,a5,80004a7e <sys_unlink+0x140>
    80004aa8:	b781                	j	800049e8 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004aaa:	00004517          	auipc	a0,0x4
    80004aae:	d9e50513          	addi	a0,a0,-610 # 80008848 <syscall_names+0x2f8>
    80004ab2:	00001097          	auipc	ra,0x1
    80004ab6:	1a6080e7          	jalr	422(ra) # 80005c58 <panic>
    panic("unlink: writei");
    80004aba:	00004517          	auipc	a0,0x4
    80004abe:	da650513          	addi	a0,a0,-602 # 80008860 <syscall_names+0x310>
    80004ac2:	00001097          	auipc	ra,0x1
    80004ac6:	196080e7          	jalr	406(ra) # 80005c58 <panic>
    dp->nlink--;
    80004aca:	04a4d783          	lhu	a5,74(s1)
    80004ace:	37fd                	addiw	a5,a5,-1
    80004ad0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	ffffe097          	auipc	ra,0xffffe
    80004ada:	004080e7          	jalr	4(ra) # 80002ada <iupdate>
    80004ade:	b781                	j	80004a1e <sys_unlink+0xe0>
    return -1;
    80004ae0:	557d                	li	a0,-1
    80004ae2:	a005                	j	80004b02 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	320080e7          	jalr	800(ra) # 80002e06 <iunlockput>
  iunlockput(dp);
    80004aee:	8526                	mv	a0,s1
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	316080e7          	jalr	790(ra) # 80002e06 <iunlockput>
  end_op();
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	afe080e7          	jalr	-1282(ra) # 800035f6 <end_op>
  return -1;
    80004b00:	557d                	li	a0,-1
}
    80004b02:	70ae                	ld	ra,232(sp)
    80004b04:	740e                	ld	s0,224(sp)
    80004b06:	64ee                	ld	s1,216(sp)
    80004b08:	694e                	ld	s2,208(sp)
    80004b0a:	69ae                	ld	s3,200(sp)
    80004b0c:	616d                	addi	sp,sp,240
    80004b0e:	8082                	ret

0000000080004b10 <sys_open>:

uint64
sys_open(void)
{
    80004b10:	7131                	addi	sp,sp,-192
    80004b12:	fd06                	sd	ra,184(sp)
    80004b14:	f922                	sd	s0,176(sp)
    80004b16:	f526                	sd	s1,168(sp)
    80004b18:	f14a                	sd	s2,160(sp)
    80004b1a:	ed4e                	sd	s3,152(sp)
    80004b1c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b1e:	08000613          	li	a2,128
    80004b22:	f5040593          	addi	a1,s0,-176
    80004b26:	4501                	li	a0,0
    80004b28:	ffffd097          	auipc	ra,0xffffd
    80004b2c:	470080e7          	jalr	1136(ra) # 80001f98 <argstr>
    return -1;
    80004b30:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b32:	0c054163          	bltz	a0,80004bf4 <sys_open+0xe4>
    80004b36:	f4c40593          	addi	a1,s0,-180
    80004b3a:	4505                	li	a0,1
    80004b3c:	ffffd097          	auipc	ra,0xffffd
    80004b40:	418080e7          	jalr	1048(ra) # 80001f54 <argint>
    80004b44:	0a054863          	bltz	a0,80004bf4 <sys_open+0xe4>

  begin_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	a2e080e7          	jalr	-1490(ra) # 80003576 <begin_op>

  if(omode & O_CREATE){
    80004b50:	f4c42783          	lw	a5,-180(s0)
    80004b54:	2007f793          	andi	a5,a5,512
    80004b58:	cbdd                	beqz	a5,80004c0e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b5a:	4681                	li	a3,0
    80004b5c:	4601                	li	a2,0
    80004b5e:	4589                	li	a1,2
    80004b60:	f5040513          	addi	a0,s0,-176
    80004b64:	00000097          	auipc	ra,0x0
    80004b68:	972080e7          	jalr	-1678(ra) # 800044d6 <create>
    80004b6c:	892a                	mv	s2,a0
    if(ip == 0){
    80004b6e:	c959                	beqz	a0,80004c04 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b70:	04491703          	lh	a4,68(s2)
    80004b74:	478d                	li	a5,3
    80004b76:	00f71763          	bne	a4,a5,80004b84 <sys_open+0x74>
    80004b7a:	04695703          	lhu	a4,70(s2)
    80004b7e:	47a5                	li	a5,9
    80004b80:	0ce7ec63          	bltu	a5,a4,80004c58 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	e02080e7          	jalr	-510(ra) # 80003986 <filealloc>
    80004b8c:	89aa                	mv	s3,a0
    80004b8e:	10050263          	beqz	a0,80004c92 <sys_open+0x182>
    80004b92:	00000097          	auipc	ra,0x0
    80004b96:	902080e7          	jalr	-1790(ra) # 80004494 <fdalloc>
    80004b9a:	84aa                	mv	s1,a0
    80004b9c:	0e054663          	bltz	a0,80004c88 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ba0:	04491703          	lh	a4,68(s2)
    80004ba4:	478d                	li	a5,3
    80004ba6:	0cf70463          	beq	a4,a5,80004c6e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004baa:	4789                	li	a5,2
    80004bac:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bb0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bb4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bb8:	f4c42783          	lw	a5,-180(s0)
    80004bbc:	0017c713          	xori	a4,a5,1
    80004bc0:	8b05                	andi	a4,a4,1
    80004bc2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bc6:	0037f713          	andi	a4,a5,3
    80004bca:	00e03733          	snez	a4,a4
    80004bce:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004bd2:	4007f793          	andi	a5,a5,1024
    80004bd6:	c791                	beqz	a5,80004be2 <sys_open+0xd2>
    80004bd8:	04491703          	lh	a4,68(s2)
    80004bdc:	4789                	li	a5,2
    80004bde:	08f70f63          	beq	a4,a5,80004c7c <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004be2:	854a                	mv	a0,s2
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	082080e7          	jalr	130(ra) # 80002c66 <iunlock>
  end_op();
    80004bec:	fffff097          	auipc	ra,0xfffff
    80004bf0:	a0a080e7          	jalr	-1526(ra) # 800035f6 <end_op>

  return fd;
}
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	70ea                	ld	ra,184(sp)
    80004bf8:	744a                	ld	s0,176(sp)
    80004bfa:	74aa                	ld	s1,168(sp)
    80004bfc:	790a                	ld	s2,160(sp)
    80004bfe:	69ea                	ld	s3,152(sp)
    80004c00:	6129                	addi	sp,sp,192
    80004c02:	8082                	ret
      end_op();
    80004c04:	fffff097          	auipc	ra,0xfffff
    80004c08:	9f2080e7          	jalr	-1550(ra) # 800035f6 <end_op>
      return -1;
    80004c0c:	b7e5                	j	80004bf4 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c0e:	f5040513          	addi	a0,s0,-176
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	748080e7          	jalr	1864(ra) # 8000335a <namei>
    80004c1a:	892a                	mv	s2,a0
    80004c1c:	c905                	beqz	a0,80004c4c <sys_open+0x13c>
    ilock(ip);
    80004c1e:	ffffe097          	auipc	ra,0xffffe
    80004c22:	f86080e7          	jalr	-122(ra) # 80002ba4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c26:	04491703          	lh	a4,68(s2)
    80004c2a:	4785                	li	a5,1
    80004c2c:	f4f712e3          	bne	a4,a5,80004b70 <sys_open+0x60>
    80004c30:	f4c42783          	lw	a5,-180(s0)
    80004c34:	dba1                	beqz	a5,80004b84 <sys_open+0x74>
      iunlockput(ip);
    80004c36:	854a                	mv	a0,s2
    80004c38:	ffffe097          	auipc	ra,0xffffe
    80004c3c:	1ce080e7          	jalr	462(ra) # 80002e06 <iunlockput>
      end_op();
    80004c40:	fffff097          	auipc	ra,0xfffff
    80004c44:	9b6080e7          	jalr	-1610(ra) # 800035f6 <end_op>
      return -1;
    80004c48:	54fd                	li	s1,-1
    80004c4a:	b76d                	j	80004bf4 <sys_open+0xe4>
      end_op();
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	9aa080e7          	jalr	-1622(ra) # 800035f6 <end_op>
      return -1;
    80004c54:	54fd                	li	s1,-1
    80004c56:	bf79                	j	80004bf4 <sys_open+0xe4>
    iunlockput(ip);
    80004c58:	854a                	mv	a0,s2
    80004c5a:	ffffe097          	auipc	ra,0xffffe
    80004c5e:	1ac080e7          	jalr	428(ra) # 80002e06 <iunlockput>
    end_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	994080e7          	jalr	-1644(ra) # 800035f6 <end_op>
    return -1;
    80004c6a:	54fd                	li	s1,-1
    80004c6c:	b761                	j	80004bf4 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004c6e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004c72:	04691783          	lh	a5,70(s2)
    80004c76:	02f99223          	sh	a5,36(s3)
    80004c7a:	bf2d                	j	80004bb4 <sys_open+0xa4>
    itrunc(ip);
    80004c7c:	854a                	mv	a0,s2
    80004c7e:	ffffe097          	auipc	ra,0xffffe
    80004c82:	034080e7          	jalr	52(ra) # 80002cb2 <itrunc>
    80004c86:	bfb1                	j	80004be2 <sys_open+0xd2>
      fileclose(f);
    80004c88:	854e                	mv	a0,s3
    80004c8a:	fffff097          	auipc	ra,0xfffff
    80004c8e:	db8080e7          	jalr	-584(ra) # 80003a42 <fileclose>
    iunlockput(ip);
    80004c92:	854a                	mv	a0,s2
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	172080e7          	jalr	370(ra) # 80002e06 <iunlockput>
    end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	95a080e7          	jalr	-1702(ra) # 800035f6 <end_op>
    return -1;
    80004ca4:	54fd                	li	s1,-1
    80004ca6:	b7b9                	j	80004bf4 <sys_open+0xe4>

0000000080004ca8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ca8:	7175                	addi	sp,sp,-144
    80004caa:	e506                	sd	ra,136(sp)
    80004cac:	e122                	sd	s0,128(sp)
    80004cae:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cb0:	fffff097          	auipc	ra,0xfffff
    80004cb4:	8c6080e7          	jalr	-1850(ra) # 80003576 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cb8:	08000613          	li	a2,128
    80004cbc:	f7040593          	addi	a1,s0,-144
    80004cc0:	4501                	li	a0,0
    80004cc2:	ffffd097          	auipc	ra,0xffffd
    80004cc6:	2d6080e7          	jalr	726(ra) # 80001f98 <argstr>
    80004cca:	02054963          	bltz	a0,80004cfc <sys_mkdir+0x54>
    80004cce:	4681                	li	a3,0
    80004cd0:	4601                	li	a2,0
    80004cd2:	4585                	li	a1,1
    80004cd4:	f7040513          	addi	a0,s0,-144
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	7fe080e7          	jalr	2046(ra) # 800044d6 <create>
    80004ce0:	cd11                	beqz	a0,80004cfc <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	124080e7          	jalr	292(ra) # 80002e06 <iunlockput>
  end_op();
    80004cea:	fffff097          	auipc	ra,0xfffff
    80004cee:	90c080e7          	jalr	-1780(ra) # 800035f6 <end_op>
  return 0;
    80004cf2:	4501                	li	a0,0
}
    80004cf4:	60aa                	ld	ra,136(sp)
    80004cf6:	640a                	ld	s0,128(sp)
    80004cf8:	6149                	addi	sp,sp,144
    80004cfa:	8082                	ret
    end_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	8fa080e7          	jalr	-1798(ra) # 800035f6 <end_op>
    return -1;
    80004d04:	557d                	li	a0,-1
    80004d06:	b7fd                	j	80004cf4 <sys_mkdir+0x4c>

0000000080004d08 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d08:	7135                	addi	sp,sp,-160
    80004d0a:	ed06                	sd	ra,152(sp)
    80004d0c:	e922                	sd	s0,144(sp)
    80004d0e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d10:	fffff097          	auipc	ra,0xfffff
    80004d14:	866080e7          	jalr	-1946(ra) # 80003576 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d18:	08000613          	li	a2,128
    80004d1c:	f7040593          	addi	a1,s0,-144
    80004d20:	4501                	li	a0,0
    80004d22:	ffffd097          	auipc	ra,0xffffd
    80004d26:	276080e7          	jalr	630(ra) # 80001f98 <argstr>
    80004d2a:	04054a63          	bltz	a0,80004d7e <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d2e:	f6c40593          	addi	a1,s0,-148
    80004d32:	4505                	li	a0,1
    80004d34:	ffffd097          	auipc	ra,0xffffd
    80004d38:	220080e7          	jalr	544(ra) # 80001f54 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d3c:	04054163          	bltz	a0,80004d7e <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d40:	f6840593          	addi	a1,s0,-152
    80004d44:	4509                	li	a0,2
    80004d46:	ffffd097          	auipc	ra,0xffffd
    80004d4a:	20e080e7          	jalr	526(ra) # 80001f54 <argint>
     argint(1, &major) < 0 ||
    80004d4e:	02054863          	bltz	a0,80004d7e <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d52:	f6841683          	lh	a3,-152(s0)
    80004d56:	f6c41603          	lh	a2,-148(s0)
    80004d5a:	458d                	li	a1,3
    80004d5c:	f7040513          	addi	a0,s0,-144
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	776080e7          	jalr	1910(ra) # 800044d6 <create>
     argint(2, &minor) < 0 ||
    80004d68:	c919                	beqz	a0,80004d7e <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d6a:	ffffe097          	auipc	ra,0xffffe
    80004d6e:	09c080e7          	jalr	156(ra) # 80002e06 <iunlockput>
  end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	884080e7          	jalr	-1916(ra) # 800035f6 <end_op>
  return 0;
    80004d7a:	4501                	li	a0,0
    80004d7c:	a031                	j	80004d88 <sys_mknod+0x80>
    end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	878080e7          	jalr	-1928(ra) # 800035f6 <end_op>
    return -1;
    80004d86:	557d                	li	a0,-1
}
    80004d88:	60ea                	ld	ra,152(sp)
    80004d8a:	644a                	ld	s0,144(sp)
    80004d8c:	610d                	addi	sp,sp,160
    80004d8e:	8082                	ret

0000000080004d90 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004d90:	7135                	addi	sp,sp,-160
    80004d92:	ed06                	sd	ra,152(sp)
    80004d94:	e922                	sd	s0,144(sp)
    80004d96:	e526                	sd	s1,136(sp)
    80004d98:	e14a                	sd	s2,128(sp)
    80004d9a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004d9c:	ffffc097          	auipc	ra,0xffffc
    80004da0:	0d0080e7          	jalr	208(ra) # 80000e6c <myproc>
    80004da4:	892a                	mv	s2,a0
  
  begin_op();
    80004da6:	ffffe097          	auipc	ra,0xffffe
    80004daa:	7d0080e7          	jalr	2000(ra) # 80003576 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dae:	08000613          	li	a2,128
    80004db2:	f6040593          	addi	a1,s0,-160
    80004db6:	4501                	li	a0,0
    80004db8:	ffffd097          	auipc	ra,0xffffd
    80004dbc:	1e0080e7          	jalr	480(ra) # 80001f98 <argstr>
    80004dc0:	04054b63          	bltz	a0,80004e16 <sys_chdir+0x86>
    80004dc4:	f6040513          	addi	a0,s0,-160
    80004dc8:	ffffe097          	auipc	ra,0xffffe
    80004dcc:	592080e7          	jalr	1426(ra) # 8000335a <namei>
    80004dd0:	84aa                	mv	s1,a0
    80004dd2:	c131                	beqz	a0,80004e16 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004dd4:	ffffe097          	auipc	ra,0xffffe
    80004dd8:	dd0080e7          	jalr	-560(ra) # 80002ba4 <ilock>
  if(ip->type != T_DIR){
    80004ddc:	04449703          	lh	a4,68(s1)
    80004de0:	4785                	li	a5,1
    80004de2:	04f71063          	bne	a4,a5,80004e22 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004de6:	8526                	mv	a0,s1
    80004de8:	ffffe097          	auipc	ra,0xffffe
    80004dec:	e7e080e7          	jalr	-386(ra) # 80002c66 <iunlock>
  iput(p->cwd);
    80004df0:	15093503          	ld	a0,336(s2)
    80004df4:	ffffe097          	auipc	ra,0xffffe
    80004df8:	f6a080e7          	jalr	-150(ra) # 80002d5e <iput>
  end_op();
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	7fa080e7          	jalr	2042(ra) # 800035f6 <end_op>
  p->cwd = ip;
    80004e04:	14993823          	sd	s1,336(s2)
  return 0;
    80004e08:	4501                	li	a0,0
}
    80004e0a:	60ea                	ld	ra,152(sp)
    80004e0c:	644a                	ld	s0,144(sp)
    80004e0e:	64aa                	ld	s1,136(sp)
    80004e10:	690a                	ld	s2,128(sp)
    80004e12:	610d                	addi	sp,sp,160
    80004e14:	8082                	ret
    end_op();
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	7e0080e7          	jalr	2016(ra) # 800035f6 <end_op>
    return -1;
    80004e1e:	557d                	li	a0,-1
    80004e20:	b7ed                	j	80004e0a <sys_chdir+0x7a>
    iunlockput(ip);
    80004e22:	8526                	mv	a0,s1
    80004e24:	ffffe097          	auipc	ra,0xffffe
    80004e28:	fe2080e7          	jalr	-30(ra) # 80002e06 <iunlockput>
    end_op();
    80004e2c:	ffffe097          	auipc	ra,0xffffe
    80004e30:	7ca080e7          	jalr	1994(ra) # 800035f6 <end_op>
    return -1;
    80004e34:	557d                	li	a0,-1
    80004e36:	bfd1                	j	80004e0a <sys_chdir+0x7a>

0000000080004e38 <sys_exec>:

uint64
sys_exec(void)
{
    80004e38:	7145                	addi	sp,sp,-464
    80004e3a:	e786                	sd	ra,456(sp)
    80004e3c:	e3a2                	sd	s0,448(sp)
    80004e3e:	ff26                	sd	s1,440(sp)
    80004e40:	fb4a                	sd	s2,432(sp)
    80004e42:	f74e                	sd	s3,424(sp)
    80004e44:	f352                	sd	s4,416(sp)
    80004e46:	ef56                	sd	s5,408(sp)
    80004e48:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e4a:	08000613          	li	a2,128
    80004e4e:	f4040593          	addi	a1,s0,-192
    80004e52:	4501                	li	a0,0
    80004e54:	ffffd097          	auipc	ra,0xffffd
    80004e58:	144080e7          	jalr	324(ra) # 80001f98 <argstr>
    return -1;
    80004e5c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e5e:	0c054a63          	bltz	a0,80004f32 <sys_exec+0xfa>
    80004e62:	e3840593          	addi	a1,s0,-456
    80004e66:	4505                	li	a0,1
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	10e080e7          	jalr	270(ra) # 80001f76 <argaddr>
    80004e70:	0c054163          	bltz	a0,80004f32 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004e74:	10000613          	li	a2,256
    80004e78:	4581                	li	a1,0
    80004e7a:	e4040513          	addi	a0,s0,-448
    80004e7e:	ffffb097          	auipc	ra,0xffffb
    80004e82:	31e080e7          	jalr	798(ra) # 8000019c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004e86:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004e8a:	89a6                	mv	s3,s1
    80004e8c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004e8e:	02000a13          	li	s4,32
    80004e92:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004e96:	00391513          	slli	a0,s2,0x3
    80004e9a:	e3040593          	addi	a1,s0,-464
    80004e9e:	e3843783          	ld	a5,-456(s0)
    80004ea2:	953e                	add	a0,a0,a5
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	016080e7          	jalr	22(ra) # 80001eba <fetchaddr>
    80004eac:	02054a63          	bltz	a0,80004ee0 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80004eb0:	e3043783          	ld	a5,-464(s0)
    80004eb4:	c3b9                	beqz	a5,80004efa <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004eb6:	ffffb097          	auipc	ra,0xffffb
    80004eba:	262080e7          	jalr	610(ra) # 80000118 <kalloc>
    80004ebe:	85aa                	mv	a1,a0
    80004ec0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ec4:	cd11                	beqz	a0,80004ee0 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ec6:	6605                	lui	a2,0x1
    80004ec8:	e3043503          	ld	a0,-464(s0)
    80004ecc:	ffffd097          	auipc	ra,0xffffd
    80004ed0:	040080e7          	jalr	64(ra) # 80001f0c <fetchstr>
    80004ed4:	00054663          	bltz	a0,80004ee0 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80004ed8:	0905                	addi	s2,s2,1
    80004eda:	09a1                	addi	s3,s3,8
    80004edc:	fb491be3          	bne	s2,s4,80004e92 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ee0:	10048913          	addi	s2,s1,256
    80004ee4:	6088                	ld	a0,0(s1)
    80004ee6:	c529                	beqz	a0,80004f30 <sys_exec+0xf8>
    kfree(argv[i]);
    80004ee8:	ffffb097          	auipc	ra,0xffffb
    80004eec:	134080e7          	jalr	308(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ef0:	04a1                	addi	s1,s1,8
    80004ef2:	ff2499e3          	bne	s1,s2,80004ee4 <sys_exec+0xac>
  return -1;
    80004ef6:	597d                	li	s2,-1
    80004ef8:	a82d                	j	80004f32 <sys_exec+0xfa>
      argv[i] = 0;
    80004efa:	0a8e                	slli	s5,s5,0x3
    80004efc:	fc040793          	addi	a5,s0,-64
    80004f00:	9abe                	add	s5,s5,a5
    80004f02:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f06:	e4040593          	addi	a1,s0,-448
    80004f0a:	f4040513          	addi	a0,s0,-192
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	194080e7          	jalr	404(ra) # 800040a2 <exec>
    80004f16:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f18:	10048993          	addi	s3,s1,256
    80004f1c:	6088                	ld	a0,0(s1)
    80004f1e:	c911                	beqz	a0,80004f32 <sys_exec+0xfa>
    kfree(argv[i]);
    80004f20:	ffffb097          	auipc	ra,0xffffb
    80004f24:	0fc080e7          	jalr	252(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f28:	04a1                	addi	s1,s1,8
    80004f2a:	ff3499e3          	bne	s1,s3,80004f1c <sys_exec+0xe4>
    80004f2e:	a011                	j	80004f32 <sys_exec+0xfa>
  return -1;
    80004f30:	597d                	li	s2,-1
}
    80004f32:	854a                	mv	a0,s2
    80004f34:	60be                	ld	ra,456(sp)
    80004f36:	641e                	ld	s0,448(sp)
    80004f38:	74fa                	ld	s1,440(sp)
    80004f3a:	795a                	ld	s2,432(sp)
    80004f3c:	79ba                	ld	s3,424(sp)
    80004f3e:	7a1a                	ld	s4,416(sp)
    80004f40:	6afa                	ld	s5,408(sp)
    80004f42:	6179                	addi	sp,sp,464
    80004f44:	8082                	ret

0000000080004f46 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f46:	7139                	addi	sp,sp,-64
    80004f48:	fc06                	sd	ra,56(sp)
    80004f4a:	f822                	sd	s0,48(sp)
    80004f4c:	f426                	sd	s1,40(sp)
    80004f4e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f50:	ffffc097          	auipc	ra,0xffffc
    80004f54:	f1c080e7          	jalr	-228(ra) # 80000e6c <myproc>
    80004f58:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f5a:	fd840593          	addi	a1,s0,-40
    80004f5e:	4501                	li	a0,0
    80004f60:	ffffd097          	auipc	ra,0xffffd
    80004f64:	016080e7          	jalr	22(ra) # 80001f76 <argaddr>
    return -1;
    80004f68:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004f6a:	0e054063          	bltz	a0,8000504a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004f6e:	fc840593          	addi	a1,s0,-56
    80004f72:	fd040513          	addi	a0,s0,-48
    80004f76:	fffff097          	auipc	ra,0xfffff
    80004f7a:	dfc080e7          	jalr	-516(ra) # 80003d72 <pipealloc>
    return -1;
    80004f7e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004f80:	0c054563          	bltz	a0,8000504a <sys_pipe+0x104>
  fd0 = -1;
    80004f84:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004f88:	fd043503          	ld	a0,-48(s0)
    80004f8c:	fffff097          	auipc	ra,0xfffff
    80004f90:	508080e7          	jalr	1288(ra) # 80004494 <fdalloc>
    80004f94:	fca42223          	sw	a0,-60(s0)
    80004f98:	08054c63          	bltz	a0,80005030 <sys_pipe+0xea>
    80004f9c:	fc843503          	ld	a0,-56(s0)
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	4f4080e7          	jalr	1268(ra) # 80004494 <fdalloc>
    80004fa8:	fca42023          	sw	a0,-64(s0)
    80004fac:	06054863          	bltz	a0,8000501c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fb0:	4691                	li	a3,4
    80004fb2:	fc440613          	addi	a2,s0,-60
    80004fb6:	fd843583          	ld	a1,-40(s0)
    80004fba:	68a8                	ld	a0,80(s1)
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	b72080e7          	jalr	-1166(ra) # 80000b2e <copyout>
    80004fc4:	02054063          	bltz	a0,80004fe4 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004fc8:	4691                	li	a3,4
    80004fca:	fc040613          	addi	a2,s0,-64
    80004fce:	fd843583          	ld	a1,-40(s0)
    80004fd2:	0591                	addi	a1,a1,4
    80004fd4:	68a8                	ld	a0,80(s1)
    80004fd6:	ffffc097          	auipc	ra,0xffffc
    80004fda:	b58080e7          	jalr	-1192(ra) # 80000b2e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004fde:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe0:	06055563          	bgez	a0,8000504a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80004fe4:	fc442783          	lw	a5,-60(s0)
    80004fe8:	07e9                	addi	a5,a5,26
    80004fea:	078e                	slli	a5,a5,0x3
    80004fec:	97a6                	add	a5,a5,s1
    80004fee:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004ff2:	fc042503          	lw	a0,-64(s0)
    80004ff6:	0569                	addi	a0,a0,26
    80004ff8:	050e                	slli	a0,a0,0x3
    80004ffa:	9526                	add	a0,a0,s1
    80004ffc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005000:	fd043503          	ld	a0,-48(s0)
    80005004:	fffff097          	auipc	ra,0xfffff
    80005008:	a3e080e7          	jalr	-1474(ra) # 80003a42 <fileclose>
    fileclose(wf);
    8000500c:	fc843503          	ld	a0,-56(s0)
    80005010:	fffff097          	auipc	ra,0xfffff
    80005014:	a32080e7          	jalr	-1486(ra) # 80003a42 <fileclose>
    return -1;
    80005018:	57fd                	li	a5,-1
    8000501a:	a805                	j	8000504a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000501c:	fc442783          	lw	a5,-60(s0)
    80005020:	0007c863          	bltz	a5,80005030 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005024:	01a78513          	addi	a0,a5,26
    80005028:	050e                	slli	a0,a0,0x3
    8000502a:	9526                	add	a0,a0,s1
    8000502c:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005030:	fd043503          	ld	a0,-48(s0)
    80005034:	fffff097          	auipc	ra,0xfffff
    80005038:	a0e080e7          	jalr	-1522(ra) # 80003a42 <fileclose>
    fileclose(wf);
    8000503c:	fc843503          	ld	a0,-56(s0)
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	a02080e7          	jalr	-1534(ra) # 80003a42 <fileclose>
    return -1;
    80005048:	57fd                	li	a5,-1
}
    8000504a:	853e                	mv	a0,a5
    8000504c:	70e2                	ld	ra,56(sp)
    8000504e:	7442                	ld	s0,48(sp)
    80005050:	74a2                	ld	s1,40(sp)
    80005052:	6121                	addi	sp,sp,64
    80005054:	8082                	ret
	...

0000000080005060 <kernelvec>:
    80005060:	7111                	addi	sp,sp,-256
    80005062:	e006                	sd	ra,0(sp)
    80005064:	e40a                	sd	sp,8(sp)
    80005066:	e80e                	sd	gp,16(sp)
    80005068:	ec12                	sd	tp,24(sp)
    8000506a:	f016                	sd	t0,32(sp)
    8000506c:	f41a                	sd	t1,40(sp)
    8000506e:	f81e                	sd	t2,48(sp)
    80005070:	fc22                	sd	s0,56(sp)
    80005072:	e0a6                	sd	s1,64(sp)
    80005074:	e4aa                	sd	a0,72(sp)
    80005076:	e8ae                	sd	a1,80(sp)
    80005078:	ecb2                	sd	a2,88(sp)
    8000507a:	f0b6                	sd	a3,96(sp)
    8000507c:	f4ba                	sd	a4,104(sp)
    8000507e:	f8be                	sd	a5,112(sp)
    80005080:	fcc2                	sd	a6,120(sp)
    80005082:	e146                	sd	a7,128(sp)
    80005084:	e54a                	sd	s2,136(sp)
    80005086:	e94e                	sd	s3,144(sp)
    80005088:	ed52                	sd	s4,152(sp)
    8000508a:	f156                	sd	s5,160(sp)
    8000508c:	f55a                	sd	s6,168(sp)
    8000508e:	f95e                	sd	s7,176(sp)
    80005090:	fd62                	sd	s8,184(sp)
    80005092:	e1e6                	sd	s9,192(sp)
    80005094:	e5ea                	sd	s10,200(sp)
    80005096:	e9ee                	sd	s11,208(sp)
    80005098:	edf2                	sd	t3,216(sp)
    8000509a:	f1f6                	sd	t4,224(sp)
    8000509c:	f5fa                	sd	t5,232(sp)
    8000509e:	f9fe                	sd	t6,240(sp)
    800050a0:	ce7fc0ef          	jal	ra,80001d86 <kerneltrap>
    800050a4:	6082                	ld	ra,0(sp)
    800050a6:	6122                	ld	sp,8(sp)
    800050a8:	61c2                	ld	gp,16(sp)
    800050aa:	7282                	ld	t0,32(sp)
    800050ac:	7322                	ld	t1,40(sp)
    800050ae:	73c2                	ld	t2,48(sp)
    800050b0:	7462                	ld	s0,56(sp)
    800050b2:	6486                	ld	s1,64(sp)
    800050b4:	6526                	ld	a0,72(sp)
    800050b6:	65c6                	ld	a1,80(sp)
    800050b8:	6666                	ld	a2,88(sp)
    800050ba:	7686                	ld	a3,96(sp)
    800050bc:	7726                	ld	a4,104(sp)
    800050be:	77c6                	ld	a5,112(sp)
    800050c0:	7866                	ld	a6,120(sp)
    800050c2:	688a                	ld	a7,128(sp)
    800050c4:	692a                	ld	s2,136(sp)
    800050c6:	69ca                	ld	s3,144(sp)
    800050c8:	6a6a                	ld	s4,152(sp)
    800050ca:	7a8a                	ld	s5,160(sp)
    800050cc:	7b2a                	ld	s6,168(sp)
    800050ce:	7bca                	ld	s7,176(sp)
    800050d0:	7c6a                	ld	s8,184(sp)
    800050d2:	6c8e                	ld	s9,192(sp)
    800050d4:	6d2e                	ld	s10,200(sp)
    800050d6:	6dce                	ld	s11,208(sp)
    800050d8:	6e6e                	ld	t3,216(sp)
    800050da:	7e8e                	ld	t4,224(sp)
    800050dc:	7f2e                	ld	t5,232(sp)
    800050de:	7fce                	ld	t6,240(sp)
    800050e0:	6111                	addi	sp,sp,256
    800050e2:	10200073          	sret
    800050e6:	00000013          	nop
    800050ea:	00000013          	nop
    800050ee:	0001                	nop

00000000800050f0 <timervec>:
    800050f0:	34051573          	csrrw	a0,mscratch,a0
    800050f4:	e10c                	sd	a1,0(a0)
    800050f6:	e510                	sd	a2,8(a0)
    800050f8:	e914                	sd	a3,16(a0)
    800050fa:	6d0c                	ld	a1,24(a0)
    800050fc:	7110                	ld	a2,32(a0)
    800050fe:	6194                	ld	a3,0(a1)
    80005100:	96b2                	add	a3,a3,a2
    80005102:	e194                	sd	a3,0(a1)
    80005104:	4589                	li	a1,2
    80005106:	14459073          	csrw	sip,a1
    8000510a:	6914                	ld	a3,16(a0)
    8000510c:	6510                	ld	a2,8(a0)
    8000510e:	610c                	ld	a1,0(a0)
    80005110:	34051573          	csrrw	a0,mscratch,a0
    80005114:	30200073          	mret
	...

000000008000511a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000511a:	1141                	addi	sp,sp,-16
    8000511c:	e422                	sd	s0,8(sp)
    8000511e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005120:	0c0007b7          	lui	a5,0xc000
    80005124:	4705                	li	a4,1
    80005126:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005128:	c3d8                	sw	a4,4(a5)
}
    8000512a:	6422                	ld	s0,8(sp)
    8000512c:	0141                	addi	sp,sp,16
    8000512e:	8082                	ret

0000000080005130 <plicinithart>:

void
plicinithart(void)
{
    80005130:	1141                	addi	sp,sp,-16
    80005132:	e406                	sd	ra,8(sp)
    80005134:	e022                	sd	s0,0(sp)
    80005136:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005138:	ffffc097          	auipc	ra,0xffffc
    8000513c:	d08080e7          	jalr	-760(ra) # 80000e40 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005140:	0085171b          	slliw	a4,a0,0x8
    80005144:	0c0027b7          	lui	a5,0xc002
    80005148:	97ba                	add	a5,a5,a4
    8000514a:	40200713          	li	a4,1026
    8000514e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005152:	00d5151b          	slliw	a0,a0,0xd
    80005156:	0c2017b7          	lui	a5,0xc201
    8000515a:	953e                	add	a0,a0,a5
    8000515c:	00052023          	sw	zero,0(a0)
}
    80005160:	60a2                	ld	ra,8(sp)
    80005162:	6402                	ld	s0,0(sp)
    80005164:	0141                	addi	sp,sp,16
    80005166:	8082                	ret

0000000080005168 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005168:	1141                	addi	sp,sp,-16
    8000516a:	e406                	sd	ra,8(sp)
    8000516c:	e022                	sd	s0,0(sp)
    8000516e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005170:	ffffc097          	auipc	ra,0xffffc
    80005174:	cd0080e7          	jalr	-816(ra) # 80000e40 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005178:	00d5179b          	slliw	a5,a0,0xd
    8000517c:	0c201537          	lui	a0,0xc201
    80005180:	953e                	add	a0,a0,a5
  return irq;
}
    80005182:	4148                	lw	a0,4(a0)
    80005184:	60a2                	ld	ra,8(sp)
    80005186:	6402                	ld	s0,0(sp)
    80005188:	0141                	addi	sp,sp,16
    8000518a:	8082                	ret

000000008000518c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000518c:	1101                	addi	sp,sp,-32
    8000518e:	ec06                	sd	ra,24(sp)
    80005190:	e822                	sd	s0,16(sp)
    80005192:	e426                	sd	s1,8(sp)
    80005194:	1000                	addi	s0,sp,32
    80005196:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	ca8080e7          	jalr	-856(ra) # 80000e40 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051a0:	00d5151b          	slliw	a0,a0,0xd
    800051a4:	0c2017b7          	lui	a5,0xc201
    800051a8:	97aa                	add	a5,a5,a0
    800051aa:	c3c4                	sw	s1,4(a5)
}
    800051ac:	60e2                	ld	ra,24(sp)
    800051ae:	6442                	ld	s0,16(sp)
    800051b0:	64a2                	ld	s1,8(sp)
    800051b2:	6105                	addi	sp,sp,32
    800051b4:	8082                	ret

00000000800051b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051b6:	1141                	addi	sp,sp,-16
    800051b8:	e406                	sd	ra,8(sp)
    800051ba:	e022                	sd	s0,0(sp)
    800051bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051be:	479d                	li	a5,7
    800051c0:	06a7c963          	blt	a5,a0,80005232 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800051c4:	00016797          	auipc	a5,0x16
    800051c8:	e3c78793          	addi	a5,a5,-452 # 8001b000 <disk>
    800051cc:	00a78733          	add	a4,a5,a0
    800051d0:	6789                	lui	a5,0x2
    800051d2:	97ba                	add	a5,a5,a4
    800051d4:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800051d8:	e7ad                	bnez	a5,80005242 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800051da:	00451793          	slli	a5,a0,0x4
    800051de:	00018717          	auipc	a4,0x18
    800051e2:	e2270713          	addi	a4,a4,-478 # 8001d000 <disk+0x2000>
    800051e6:	6314                	ld	a3,0(a4)
    800051e8:	96be                	add	a3,a3,a5
    800051ea:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800051ee:	6314                	ld	a3,0(a4)
    800051f0:	96be                	add	a3,a3,a5
    800051f2:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800051f6:	6314                	ld	a3,0(a4)
    800051f8:	96be                	add	a3,a3,a5
    800051fa:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800051fe:	6318                	ld	a4,0(a4)
    80005200:	97ba                	add	a5,a5,a4
    80005202:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005206:	00016797          	auipc	a5,0x16
    8000520a:	dfa78793          	addi	a5,a5,-518 # 8001b000 <disk>
    8000520e:	97aa                	add	a5,a5,a0
    80005210:	6509                	lui	a0,0x2
    80005212:	953e                	add	a0,a0,a5
    80005214:	4785                	li	a5,1
    80005216:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000521a:	00018517          	auipc	a0,0x18
    8000521e:	dfe50513          	addi	a0,a0,-514 # 8001d018 <disk+0x2018>
    80005222:	ffffc097          	auipc	ra,0xffffc
    80005226:	49e080e7          	jalr	1182(ra) # 800016c0 <wakeup>
}
    8000522a:	60a2                	ld	ra,8(sp)
    8000522c:	6402                	ld	s0,0(sp)
    8000522e:	0141                	addi	sp,sp,16
    80005230:	8082                	ret
    panic("free_desc 1");
    80005232:	00003517          	auipc	a0,0x3
    80005236:	63e50513          	addi	a0,a0,1598 # 80008870 <syscall_names+0x320>
    8000523a:	00001097          	auipc	ra,0x1
    8000523e:	a1e080e7          	jalr	-1506(ra) # 80005c58 <panic>
    panic("free_desc 2");
    80005242:	00003517          	auipc	a0,0x3
    80005246:	63e50513          	addi	a0,a0,1598 # 80008880 <syscall_names+0x330>
    8000524a:	00001097          	auipc	ra,0x1
    8000524e:	a0e080e7          	jalr	-1522(ra) # 80005c58 <panic>

0000000080005252 <virtio_disk_init>:
{
    80005252:	1101                	addi	sp,sp,-32
    80005254:	ec06                	sd	ra,24(sp)
    80005256:	e822                	sd	s0,16(sp)
    80005258:	e426                	sd	s1,8(sp)
    8000525a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000525c:	00003597          	auipc	a1,0x3
    80005260:	63458593          	addi	a1,a1,1588 # 80008890 <syscall_names+0x340>
    80005264:	00018517          	auipc	a0,0x18
    80005268:	ec450513          	addi	a0,a0,-316 # 8001d128 <disk+0x2128>
    8000526c:	00001097          	auipc	ra,0x1
    80005270:	ea6080e7          	jalr	-346(ra) # 80006112 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005274:	100017b7          	lui	a5,0x10001
    80005278:	4398                	lw	a4,0(a5)
    8000527a:	2701                	sext.w	a4,a4
    8000527c:	747277b7          	lui	a5,0x74727
    80005280:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005284:	0ef71163          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005288:	100017b7          	lui	a5,0x10001
    8000528c:	43dc                	lw	a5,4(a5)
    8000528e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005290:	4705                	li	a4,1
    80005292:	0ce79a63          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005296:	100017b7          	lui	a5,0x10001
    8000529a:	479c                	lw	a5,8(a5)
    8000529c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000529e:	4709                	li	a4,2
    800052a0:	0ce79363          	bne	a5,a4,80005366 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	47d8                	lw	a4,12(a5)
    800052aa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052ac:	554d47b7          	lui	a5,0x554d4
    800052b0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052b4:	0af71963          	bne	a4,a5,80005366 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	4705                	li	a4,1
    800052be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052c0:	470d                	li	a4,3
    800052c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052c4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052c6:	c7ffe737          	lui	a4,0xc7ffe
    800052ca:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800052ce:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052d0:	2701                	sext.w	a4,a4
    800052d2:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d4:	472d                	li	a4,11
    800052d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052d8:	473d                	li	a4,15
    800052da:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800052dc:	6705                	lui	a4,0x1
    800052de:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800052e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800052e4:	5bdc                	lw	a5,52(a5)
    800052e6:	2781                	sext.w	a5,a5
  if(max == 0)
    800052e8:	c7d9                	beqz	a5,80005376 <virtio_disk_init+0x124>
  if(max < NUM)
    800052ea:	471d                	li	a4,7
    800052ec:	08f77d63          	bgeu	a4,a5,80005386 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800052f0:	100014b7          	lui	s1,0x10001
    800052f4:	47a1                	li	a5,8
    800052f6:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800052f8:	6609                	lui	a2,0x2
    800052fa:	4581                	li	a1,0
    800052fc:	00016517          	auipc	a0,0x16
    80005300:	d0450513          	addi	a0,a0,-764 # 8001b000 <disk>
    80005304:	ffffb097          	auipc	ra,0xffffb
    80005308:	e98080e7          	jalr	-360(ra) # 8000019c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000530c:	00016717          	auipc	a4,0x16
    80005310:	cf470713          	addi	a4,a4,-780 # 8001b000 <disk>
    80005314:	00c75793          	srli	a5,a4,0xc
    80005318:	2781                	sext.w	a5,a5
    8000531a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000531c:	00018797          	auipc	a5,0x18
    80005320:	ce478793          	addi	a5,a5,-796 # 8001d000 <disk+0x2000>
    80005324:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005326:	00016717          	auipc	a4,0x16
    8000532a:	d5a70713          	addi	a4,a4,-678 # 8001b080 <disk+0x80>
    8000532e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005330:	00017717          	auipc	a4,0x17
    80005334:	cd070713          	addi	a4,a4,-816 # 8001c000 <disk+0x1000>
    80005338:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000533a:	4705                	li	a4,1
    8000533c:	00e78c23          	sb	a4,24(a5)
    80005340:	00e78ca3          	sb	a4,25(a5)
    80005344:	00e78d23          	sb	a4,26(a5)
    80005348:	00e78da3          	sb	a4,27(a5)
    8000534c:	00e78e23          	sb	a4,28(a5)
    80005350:	00e78ea3          	sb	a4,29(a5)
    80005354:	00e78f23          	sb	a4,30(a5)
    80005358:	00e78fa3          	sb	a4,31(a5)
}
    8000535c:	60e2                	ld	ra,24(sp)
    8000535e:	6442                	ld	s0,16(sp)
    80005360:	64a2                	ld	s1,8(sp)
    80005362:	6105                	addi	sp,sp,32
    80005364:	8082                	ret
    panic("could not find virtio disk");
    80005366:	00003517          	auipc	a0,0x3
    8000536a:	53a50513          	addi	a0,a0,1338 # 800088a0 <syscall_names+0x350>
    8000536e:	00001097          	auipc	ra,0x1
    80005372:	8ea080e7          	jalr	-1814(ra) # 80005c58 <panic>
    panic("virtio disk has no queue 0");
    80005376:	00003517          	auipc	a0,0x3
    8000537a:	54a50513          	addi	a0,a0,1354 # 800088c0 <syscall_names+0x370>
    8000537e:	00001097          	auipc	ra,0x1
    80005382:	8da080e7          	jalr	-1830(ra) # 80005c58 <panic>
    panic("virtio disk max queue too short");
    80005386:	00003517          	auipc	a0,0x3
    8000538a:	55a50513          	addi	a0,a0,1370 # 800088e0 <syscall_names+0x390>
    8000538e:	00001097          	auipc	ra,0x1
    80005392:	8ca080e7          	jalr	-1846(ra) # 80005c58 <panic>

0000000080005396 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005396:	7159                	addi	sp,sp,-112
    80005398:	f486                	sd	ra,104(sp)
    8000539a:	f0a2                	sd	s0,96(sp)
    8000539c:	eca6                	sd	s1,88(sp)
    8000539e:	e8ca                	sd	s2,80(sp)
    800053a0:	e4ce                	sd	s3,72(sp)
    800053a2:	e0d2                	sd	s4,64(sp)
    800053a4:	fc56                	sd	s5,56(sp)
    800053a6:	f85a                	sd	s6,48(sp)
    800053a8:	f45e                	sd	s7,40(sp)
    800053aa:	f062                	sd	s8,32(sp)
    800053ac:	ec66                	sd	s9,24(sp)
    800053ae:	e86a                	sd	s10,16(sp)
    800053b0:	1880                	addi	s0,sp,112
    800053b2:	892a                	mv	s2,a0
    800053b4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800053b6:	00c52c83          	lw	s9,12(a0)
    800053ba:	001c9c9b          	slliw	s9,s9,0x1
    800053be:	1c82                	slli	s9,s9,0x20
    800053c0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800053c4:	00018517          	auipc	a0,0x18
    800053c8:	d6450513          	addi	a0,a0,-668 # 8001d128 <disk+0x2128>
    800053cc:	00001097          	auipc	ra,0x1
    800053d0:	dd6080e7          	jalr	-554(ra) # 800061a2 <acquire>
  for(int i = 0; i < 3; i++){
    800053d4:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800053d6:	4c21                	li	s8,8
      disk.free[i] = 0;
    800053d8:	00016b97          	auipc	s7,0x16
    800053dc:	c28b8b93          	addi	s7,s7,-984 # 8001b000 <disk>
    800053e0:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800053e2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800053e4:	8a4e                	mv	s4,s3
    800053e6:	a051                	j	8000546a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    800053e8:	00fb86b3          	add	a3,s7,a5
    800053ec:	96da                	add	a3,a3,s6
    800053ee:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800053f2:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800053f4:	0207c563          	bltz	a5,8000541e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800053f8:	2485                	addiw	s1,s1,1
    800053fa:	0711                	addi	a4,a4,4
    800053fc:	25548063          	beq	s1,s5,8000563c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005400:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005402:	00018697          	auipc	a3,0x18
    80005406:	c1668693          	addi	a3,a3,-1002 # 8001d018 <disk+0x2018>
    8000540a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000540c:	0006c583          	lbu	a1,0(a3)
    80005410:	fde1                	bnez	a1,800053e8 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005412:	2785                	addiw	a5,a5,1
    80005414:	0685                	addi	a3,a3,1
    80005416:	ff879be3          	bne	a5,s8,8000540c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000541a:	57fd                	li	a5,-1
    8000541c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000541e:	02905a63          	blez	s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005422:	f9042503          	lw	a0,-112(s0)
    80005426:	00000097          	auipc	ra,0x0
    8000542a:	d90080e7          	jalr	-624(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000542e:	4785                	li	a5,1
    80005430:	0297d163          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005434:	f9442503          	lw	a0,-108(s0)
    80005438:	00000097          	auipc	ra,0x0
    8000543c:	d7e080e7          	jalr	-642(ra) # 800051b6 <free_desc>
      for(int j = 0; j < i; j++)
    80005440:	4789                	li	a5,2
    80005442:	0097d863          	bge	a5,s1,80005452 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005446:	f9842503          	lw	a0,-104(s0)
    8000544a:	00000097          	auipc	ra,0x0
    8000544e:	d6c080e7          	jalr	-660(ra) # 800051b6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005452:	00018597          	auipc	a1,0x18
    80005456:	cd658593          	addi	a1,a1,-810 # 8001d128 <disk+0x2128>
    8000545a:	00018517          	auipc	a0,0x18
    8000545e:	bbe50513          	addi	a0,a0,-1090 # 8001d018 <disk+0x2018>
    80005462:	ffffc097          	auipc	ra,0xffffc
    80005466:	0d2080e7          	jalr	210(ra) # 80001534 <sleep>
  for(int i = 0; i < 3; i++){
    8000546a:	f9040713          	addi	a4,s0,-112
    8000546e:	84ce                	mv	s1,s3
    80005470:	bf41                	j	80005400 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005472:	20058713          	addi	a4,a1,512
    80005476:	00471693          	slli	a3,a4,0x4
    8000547a:	00016717          	auipc	a4,0x16
    8000547e:	b8670713          	addi	a4,a4,-1146 # 8001b000 <disk>
    80005482:	9736                	add	a4,a4,a3
    80005484:	4685                	li	a3,1
    80005486:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000548a:	20058713          	addi	a4,a1,512
    8000548e:	00471693          	slli	a3,a4,0x4
    80005492:	00016717          	auipc	a4,0x16
    80005496:	b6e70713          	addi	a4,a4,-1170 # 8001b000 <disk>
    8000549a:	9736                	add	a4,a4,a3
    8000549c:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800054a0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800054a4:	7679                	lui	a2,0xffffe
    800054a6:	963e                	add	a2,a2,a5
    800054a8:	00018697          	auipc	a3,0x18
    800054ac:	b5868693          	addi	a3,a3,-1192 # 8001d000 <disk+0x2000>
    800054b0:	6298                	ld	a4,0(a3)
    800054b2:	9732                	add	a4,a4,a2
    800054b4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800054b6:	6298                	ld	a4,0(a3)
    800054b8:	9732                	add	a4,a4,a2
    800054ba:	4541                	li	a0,16
    800054bc:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800054be:	6298                	ld	a4,0(a3)
    800054c0:	9732                	add	a4,a4,a2
    800054c2:	4505                	li	a0,1
    800054c4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800054c8:	f9442703          	lw	a4,-108(s0)
    800054cc:	6288                	ld	a0,0(a3)
    800054ce:	962a                	add	a2,a2,a0
    800054d0:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>

  disk.desc[idx[1]].addr = (uint64) b->data;
    800054d4:	0712                	slli	a4,a4,0x4
    800054d6:	6290                	ld	a2,0(a3)
    800054d8:	963a                	add	a2,a2,a4
    800054da:	05890513          	addi	a0,s2,88
    800054de:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800054e0:	6294                	ld	a3,0(a3)
    800054e2:	96ba                	add	a3,a3,a4
    800054e4:	40000613          	li	a2,1024
    800054e8:	c690                	sw	a2,8(a3)
  if(write)
    800054ea:	140d0063          	beqz	s10,8000562a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054ee:	00018697          	auipc	a3,0x18
    800054f2:	b126b683          	ld	a3,-1262(a3) # 8001d000 <disk+0x2000>
    800054f6:	96ba                	add	a3,a3,a4
    800054f8:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054fc:	00016817          	auipc	a6,0x16
    80005500:	b0480813          	addi	a6,a6,-1276 # 8001b000 <disk>
    80005504:	00018517          	auipc	a0,0x18
    80005508:	afc50513          	addi	a0,a0,-1284 # 8001d000 <disk+0x2000>
    8000550c:	6114                	ld	a3,0(a0)
    8000550e:	96ba                	add	a3,a3,a4
    80005510:	00c6d603          	lhu	a2,12(a3)
    80005514:	00166613          	ori	a2,a2,1
    80005518:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000551c:	f9842683          	lw	a3,-104(s0)
    80005520:	6110                	ld	a2,0(a0)
    80005522:	9732                	add	a4,a4,a2
    80005524:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005528:	20058613          	addi	a2,a1,512
    8000552c:	0612                	slli	a2,a2,0x4
    8000552e:	9642                	add	a2,a2,a6
    80005530:	577d                	li	a4,-1
    80005532:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005536:	00469713          	slli	a4,a3,0x4
    8000553a:	6114                	ld	a3,0(a0)
    8000553c:	96ba                	add	a3,a3,a4
    8000553e:	03078793          	addi	a5,a5,48
    80005542:	97c2                	add	a5,a5,a6
    80005544:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005546:	611c                	ld	a5,0(a0)
    80005548:	97ba                	add	a5,a5,a4
    8000554a:	4685                	li	a3,1
    8000554c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000554e:	611c                	ld	a5,0(a0)
    80005550:	97ba                	add	a5,a5,a4
    80005552:	4809                	li	a6,2
    80005554:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005558:	611c                	ld	a5,0(a0)
    8000555a:	973e                	add	a4,a4,a5
    8000555c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005560:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005564:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005568:	6518                	ld	a4,8(a0)
    8000556a:	00275783          	lhu	a5,2(a4)
    8000556e:	8b9d                	andi	a5,a5,7
    80005570:	0786                	slli	a5,a5,0x1
    80005572:	97ba                	add	a5,a5,a4
    80005574:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80005578:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000557c:	6518                	ld	a4,8(a0)
    8000557e:	00275783          	lhu	a5,2(a4)
    80005582:	2785                	addiw	a5,a5,1
    80005584:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005588:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000558c:	100017b7          	lui	a5,0x10001
    80005590:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005594:	00492703          	lw	a4,4(s2)
    80005598:	4785                	li	a5,1
    8000559a:	02f71163          	bne	a4,a5,800055bc <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    8000559e:	00018997          	auipc	s3,0x18
    800055a2:	b8a98993          	addi	s3,s3,-1142 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    800055a6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800055a8:	85ce                	mv	a1,s3
    800055aa:	854a                	mv	a0,s2
    800055ac:	ffffc097          	auipc	ra,0xffffc
    800055b0:	f88080e7          	jalr	-120(ra) # 80001534 <sleep>
  while(b->disk == 1) {
    800055b4:	00492783          	lw	a5,4(s2)
    800055b8:	fe9788e3          	beq	a5,s1,800055a8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800055bc:	f9042903          	lw	s2,-112(s0)
    800055c0:	20090793          	addi	a5,s2,512
    800055c4:	00479713          	slli	a4,a5,0x4
    800055c8:	00016797          	auipc	a5,0x16
    800055cc:	a3878793          	addi	a5,a5,-1480 # 8001b000 <disk>
    800055d0:	97ba                	add	a5,a5,a4
    800055d2:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055d6:	00018997          	auipc	s3,0x18
    800055da:	a2a98993          	addi	s3,s3,-1494 # 8001d000 <disk+0x2000>
    800055de:	00491713          	slli	a4,s2,0x4
    800055e2:	0009b783          	ld	a5,0(s3)
    800055e6:	97ba                	add	a5,a5,a4
    800055e8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055ec:	854a                	mv	a0,s2
    800055ee:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055f2:	00000097          	auipc	ra,0x0
    800055f6:	bc4080e7          	jalr	-1084(ra) # 800051b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055fa:	8885                	andi	s1,s1,1
    800055fc:	f0ed                	bnez	s1,800055de <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055fe:	00018517          	auipc	a0,0x18
    80005602:	b2a50513          	addi	a0,a0,-1238 # 8001d128 <disk+0x2128>
    80005606:	00001097          	auipc	ra,0x1
    8000560a:	c50080e7          	jalr	-944(ra) # 80006256 <release>
}
    8000560e:	70a6                	ld	ra,104(sp)
    80005610:	7406                	ld	s0,96(sp)
    80005612:	64e6                	ld	s1,88(sp)
    80005614:	6946                	ld	s2,80(sp)
    80005616:	69a6                	ld	s3,72(sp)
    80005618:	6a06                	ld	s4,64(sp)
    8000561a:	7ae2                	ld	s5,56(sp)
    8000561c:	7b42                	ld	s6,48(sp)
    8000561e:	7ba2                	ld	s7,40(sp)
    80005620:	7c02                	ld	s8,32(sp)
    80005622:	6ce2                	ld	s9,24(sp)
    80005624:	6d42                	ld	s10,16(sp)
    80005626:	6165                	addi	sp,sp,112
    80005628:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000562a:	00018697          	auipc	a3,0x18
    8000562e:	9d66b683          	ld	a3,-1578(a3) # 8001d000 <disk+0x2000>
    80005632:	96ba                	add	a3,a3,a4
    80005634:	4609                	li	a2,2
    80005636:	00c69623          	sh	a2,12(a3)
    8000563a:	b5c9                	j	800054fc <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000563c:	f9042583          	lw	a1,-112(s0)
    80005640:	20058793          	addi	a5,a1,512
    80005644:	0792                	slli	a5,a5,0x4
    80005646:	00016517          	auipc	a0,0x16
    8000564a:	a6250513          	addi	a0,a0,-1438 # 8001b0a8 <disk+0xa8>
    8000564e:	953e                	add	a0,a0,a5
  if(write)
    80005650:	e20d11e3          	bnez	s10,80005472 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005654:	20058713          	addi	a4,a1,512
    80005658:	00471693          	slli	a3,a4,0x4
    8000565c:	00016717          	auipc	a4,0x16
    80005660:	9a470713          	addi	a4,a4,-1628 # 8001b000 <disk>
    80005664:	9736                	add	a4,a4,a3
    80005666:	0a072423          	sw	zero,168(a4)
    8000566a:	b505                	j	8000548a <virtio_disk_rw+0xf4>

000000008000566c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000566c:	1101                	addi	sp,sp,-32
    8000566e:	ec06                	sd	ra,24(sp)
    80005670:	e822                	sd	s0,16(sp)
    80005672:	e426                	sd	s1,8(sp)
    80005674:	e04a                	sd	s2,0(sp)
    80005676:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005678:	00018517          	auipc	a0,0x18
    8000567c:	ab050513          	addi	a0,a0,-1360 # 8001d128 <disk+0x2128>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	b22080e7          	jalr	-1246(ra) # 800061a2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005688:	10001737          	lui	a4,0x10001
    8000568c:	533c                	lw	a5,96(a4)
    8000568e:	8b8d                	andi	a5,a5,3
    80005690:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005692:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005696:	00018797          	auipc	a5,0x18
    8000569a:	96a78793          	addi	a5,a5,-1686 # 8001d000 <disk+0x2000>
    8000569e:	6b94                	ld	a3,16(a5)
    800056a0:	0207d703          	lhu	a4,32(a5)
    800056a4:	0026d783          	lhu	a5,2(a3)
    800056a8:	06f70163          	beq	a4,a5,8000570a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056ac:	00016917          	auipc	s2,0x16
    800056b0:	95490913          	addi	s2,s2,-1708 # 8001b000 <disk>
    800056b4:	00018497          	auipc	s1,0x18
    800056b8:	94c48493          	addi	s1,s1,-1716 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056bc:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c0:	6898                	ld	a4,16(s1)
    800056c2:	0204d783          	lhu	a5,32(s1)
    800056c6:	8b9d                	andi	a5,a5,7
    800056c8:	078e                	slli	a5,a5,0x3
    800056ca:	97ba                	add	a5,a5,a4
    800056cc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056ce:	20078713          	addi	a4,a5,512
    800056d2:	0712                	slli	a4,a4,0x4
    800056d4:	974a                	add	a4,a4,s2
    800056d6:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800056da:	e731                	bnez	a4,80005726 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056dc:	20078793          	addi	a5,a5,512
    800056e0:	0792                	slli	a5,a5,0x4
    800056e2:	97ca                	add	a5,a5,s2
    800056e4:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	fd6080e7          	jalr	-42(ra) # 800016c0 <wakeup>

    disk.used_idx += 1;
    800056f2:	0204d783          	lhu	a5,32(s1)
    800056f6:	2785                	addiw	a5,a5,1
    800056f8:	17c2                	slli	a5,a5,0x30
    800056fa:	93c1                	srli	a5,a5,0x30
    800056fc:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005700:	6898                	ld	a4,16(s1)
    80005702:	00275703          	lhu	a4,2(a4)
    80005706:	faf71be3          	bne	a4,a5,800056bc <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000570a:	00018517          	auipc	a0,0x18
    8000570e:	a1e50513          	addi	a0,a0,-1506 # 8001d128 <disk+0x2128>
    80005712:	00001097          	auipc	ra,0x1
    80005716:	b44080e7          	jalr	-1212(ra) # 80006256 <release>
}
    8000571a:	60e2                	ld	ra,24(sp)
    8000571c:	6442                	ld	s0,16(sp)
    8000571e:	64a2                	ld	s1,8(sp)
    80005720:	6902                	ld	s2,0(sp)
    80005722:	6105                	addi	sp,sp,32
    80005724:	8082                	ret
      panic("virtio_disk_intr status");
    80005726:	00003517          	auipc	a0,0x3
    8000572a:	1da50513          	addi	a0,a0,474 # 80008900 <syscall_names+0x3b0>
    8000572e:	00000097          	auipc	ra,0x0
    80005732:	52a080e7          	jalr	1322(ra) # 80005c58 <panic>

0000000080005736 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005736:	1141                	addi	sp,sp,-16
    80005738:	e422                	sd	s0,8(sp)
    8000573a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000573c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005740:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005744:	0037979b          	slliw	a5,a5,0x3
    80005748:	02004737          	lui	a4,0x2004
    8000574c:	97ba                	add	a5,a5,a4
    8000574e:	0200c737          	lui	a4,0x200c
    80005752:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005756:	000f4637          	lui	a2,0xf4
    8000575a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000575e:	95b2                	add	a1,a1,a2
    80005760:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005762:	00269713          	slli	a4,a3,0x2
    80005766:	9736                	add	a4,a4,a3
    80005768:	00371693          	slli	a3,a4,0x3
    8000576c:	00019717          	auipc	a4,0x19
    80005770:	89470713          	addi	a4,a4,-1900 # 8001e000 <timer_scratch>
    80005774:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005776:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005778:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000577a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000577e:	00000797          	auipc	a5,0x0
    80005782:	97278793          	addi	a5,a5,-1678 # 800050f0 <timervec>
    80005786:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000578a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000578e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005792:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005796:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000579a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000579e:	30479073          	csrw	mie,a5
}
    800057a2:	6422                	ld	s0,8(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <start>:
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057b4:	7779                	lui	a4,0xffffe
    800057b6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057ba:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057bc:	6705                	lui	a4,0x1
    800057be:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057c8:	ffffb797          	auipc	a5,0xffffb
    800057cc:	b8278793          	addi	a5,a5,-1150 # 8000034a <main>
    800057d0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057d4:	4781                	li	a5,0
    800057d6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057da:	67c1                	lui	a5,0x10
    800057dc:	17fd                	addi	a5,a5,-1
    800057de:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057e6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057ea:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057ee:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f2:	57fd                	li	a5,-1
    800057f4:	83a9                	srli	a5,a5,0xa
    800057f6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800057fa:	47bd                	li	a5,15
    800057fc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005800:	00000097          	auipc	ra,0x0
    80005804:	f36080e7          	jalr	-202(ra) # 80005736 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005808:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000580c:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000580e:	823e                	mv	tp,a5
  asm volatile("mret");
    80005810:	30200073          	mret
}
    80005814:	60a2                	ld	ra,8(sp)
    80005816:	6402                	ld	s0,0(sp)
    80005818:	0141                	addi	sp,sp,16
    8000581a:	8082                	ret

000000008000581c <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000581c:	715d                	addi	sp,sp,-80
    8000581e:	e486                	sd	ra,72(sp)
    80005820:	e0a2                	sd	s0,64(sp)
    80005822:	fc26                	sd	s1,56(sp)
    80005824:	f84a                	sd	s2,48(sp)
    80005826:	f44e                	sd	s3,40(sp)
    80005828:	f052                	sd	s4,32(sp)
    8000582a:	ec56                	sd	s5,24(sp)
    8000582c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000582e:	04c05663          	blez	a2,8000587a <consolewrite+0x5e>
    80005832:	8a2a                	mv	s4,a0
    80005834:	84ae                	mv	s1,a1
    80005836:	89b2                	mv	s3,a2
    80005838:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000583a:	5afd                	li	s5,-1
    8000583c:	4685                	li	a3,1
    8000583e:	8626                	mv	a2,s1
    80005840:	85d2                	mv	a1,s4
    80005842:	fbf40513          	addi	a0,s0,-65
    80005846:	ffffc097          	auipc	ra,0xffffc
    8000584a:	0e8080e7          	jalr	232(ra) # 8000192e <either_copyin>
    8000584e:	01550c63          	beq	a0,s5,80005866 <consolewrite+0x4a>
      break;
    uartputc(c);
    80005852:	fbf44503          	lbu	a0,-65(s0)
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	78e080e7          	jalr	1934(ra) # 80005fe4 <uartputc>
  for(i = 0; i < n; i++){
    8000585e:	2905                	addiw	s2,s2,1
    80005860:	0485                	addi	s1,s1,1
    80005862:	fd299de3          	bne	s3,s2,8000583c <consolewrite+0x20>
  }

  return i;
}
    80005866:	854a                	mv	a0,s2
    80005868:	60a6                	ld	ra,72(sp)
    8000586a:	6406                	ld	s0,64(sp)
    8000586c:	74e2                	ld	s1,56(sp)
    8000586e:	7942                	ld	s2,48(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6ae2                	ld	s5,24(sp)
    80005876:	6161                	addi	sp,sp,80
    80005878:	8082                	ret
  for(i = 0; i < n; i++){
    8000587a:	4901                	li	s2,0
    8000587c:	b7ed                	j	80005866 <consolewrite+0x4a>

000000008000587e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000587e:	7119                	addi	sp,sp,-128
    80005880:	fc86                	sd	ra,120(sp)
    80005882:	f8a2                	sd	s0,112(sp)
    80005884:	f4a6                	sd	s1,104(sp)
    80005886:	f0ca                	sd	s2,96(sp)
    80005888:	ecce                	sd	s3,88(sp)
    8000588a:	e8d2                	sd	s4,80(sp)
    8000588c:	e4d6                	sd	s5,72(sp)
    8000588e:	e0da                	sd	s6,64(sp)
    80005890:	fc5e                	sd	s7,56(sp)
    80005892:	f862                	sd	s8,48(sp)
    80005894:	f466                	sd	s9,40(sp)
    80005896:	f06a                	sd	s10,32(sp)
    80005898:	ec6e                	sd	s11,24(sp)
    8000589a:	0100                	addi	s0,sp,128
    8000589c:	8b2a                	mv	s6,a0
    8000589e:	8aae                	mv	s5,a1
    800058a0:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058a2:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800058a6:	00021517          	auipc	a0,0x21
    800058aa:	89a50513          	addi	a0,a0,-1894 # 80026140 <cons>
    800058ae:	00001097          	auipc	ra,0x1
    800058b2:	8f4080e7          	jalr	-1804(ra) # 800061a2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058b6:	00021497          	auipc	s1,0x21
    800058ba:	88a48493          	addi	s1,s1,-1910 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058be:	89a6                	mv	s3,s1
    800058c0:	00021917          	auipc	s2,0x21
    800058c4:	91890913          	addi	s2,s2,-1768 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800058c8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800058ca:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800058cc:	4da9                	li	s11,10
  while(n > 0){
    800058ce:	07405863          	blez	s4,8000593e <consoleread+0xc0>
    while(cons.r == cons.w){
    800058d2:	0984a783          	lw	a5,152(s1)
    800058d6:	09c4a703          	lw	a4,156(s1)
    800058da:	02f71463          	bne	a4,a5,80005902 <consoleread+0x84>
      if(myproc()->killed){
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	58e080e7          	jalr	1422(ra) # 80000e6c <myproc>
    800058e6:	551c                	lw	a5,40(a0)
    800058e8:	e7b5                	bnez	a5,80005954 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800058ea:	85ce                	mv	a1,s3
    800058ec:	854a                	mv	a0,s2
    800058ee:	ffffc097          	auipc	ra,0xffffc
    800058f2:	c46080e7          	jalr	-954(ra) # 80001534 <sleep>
    while(cons.r == cons.w){
    800058f6:	0984a783          	lw	a5,152(s1)
    800058fa:	09c4a703          	lw	a4,156(s1)
    800058fe:	fef700e3          	beq	a4,a5,800058de <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005902:	0017871b          	addiw	a4,a5,1
    80005906:	08e4ac23          	sw	a4,152(s1)
    8000590a:	07f7f713          	andi	a4,a5,127
    8000590e:	9726                	add	a4,a4,s1
    80005910:	01874703          	lbu	a4,24(a4)
    80005914:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005918:	079c0663          	beq	s8,s9,80005984 <consoleread+0x106>
    cbuf = c;
    8000591c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005920:	4685                	li	a3,1
    80005922:	f8f40613          	addi	a2,s0,-113
    80005926:	85d6                	mv	a1,s5
    80005928:	855a                	mv	a0,s6
    8000592a:	ffffc097          	auipc	ra,0xffffc
    8000592e:	fae080e7          	jalr	-82(ra) # 800018d8 <either_copyout>
    80005932:	01a50663          	beq	a0,s10,8000593e <consoleread+0xc0>
    dst++;
    80005936:	0a85                	addi	s5,s5,1
    --n;
    80005938:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000593a:	f9bc1ae3          	bne	s8,s11,800058ce <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000593e:	00021517          	auipc	a0,0x21
    80005942:	80250513          	addi	a0,a0,-2046 # 80026140 <cons>
    80005946:	00001097          	auipc	ra,0x1
    8000594a:	910080e7          	jalr	-1776(ra) # 80006256 <release>

  return target - n;
    8000594e:	414b853b          	subw	a0,s7,s4
    80005952:	a811                	j	80005966 <consoleread+0xe8>
        release(&cons.lock);
    80005954:	00020517          	auipc	a0,0x20
    80005958:	7ec50513          	addi	a0,a0,2028 # 80026140 <cons>
    8000595c:	00001097          	auipc	ra,0x1
    80005960:	8fa080e7          	jalr	-1798(ra) # 80006256 <release>
        return -1;
    80005964:	557d                	li	a0,-1
}
    80005966:	70e6                	ld	ra,120(sp)
    80005968:	7446                	ld	s0,112(sp)
    8000596a:	74a6                	ld	s1,104(sp)
    8000596c:	7906                	ld	s2,96(sp)
    8000596e:	69e6                	ld	s3,88(sp)
    80005970:	6a46                	ld	s4,80(sp)
    80005972:	6aa6                	ld	s5,72(sp)
    80005974:	6b06                	ld	s6,64(sp)
    80005976:	7be2                	ld	s7,56(sp)
    80005978:	7c42                	ld	s8,48(sp)
    8000597a:	7ca2                	ld	s9,40(sp)
    8000597c:	7d02                	ld	s10,32(sp)
    8000597e:	6de2                	ld	s11,24(sp)
    80005980:	6109                	addi	sp,sp,128
    80005982:	8082                	ret
      if(n < target){
    80005984:	000a071b          	sext.w	a4,s4
    80005988:	fb777be3          	bgeu	a4,s7,8000593e <consoleread+0xc0>
        cons.r--;
    8000598c:	00021717          	auipc	a4,0x21
    80005990:	84f72623          	sw	a5,-1972(a4) # 800261d8 <cons+0x98>
    80005994:	b76d                	j	8000593e <consoleread+0xc0>

0000000080005996 <consputc>:
{
    80005996:	1141                	addi	sp,sp,-16
    80005998:	e406                	sd	ra,8(sp)
    8000599a:	e022                	sd	s0,0(sp)
    8000599c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000599e:	10000793          	li	a5,256
    800059a2:	00f50a63          	beq	a0,a5,800059b6 <consputc+0x20>
    uartputc_sync(c);
    800059a6:	00000097          	auipc	ra,0x0
    800059aa:	564080e7          	jalr	1380(ra) # 80005f0a <uartputc_sync>
}
    800059ae:	60a2                	ld	ra,8(sp)
    800059b0:	6402                	ld	s0,0(sp)
    800059b2:	0141                	addi	sp,sp,16
    800059b4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059b6:	4521                	li	a0,8
    800059b8:	00000097          	auipc	ra,0x0
    800059bc:	552080e7          	jalr	1362(ra) # 80005f0a <uartputc_sync>
    800059c0:	02000513          	li	a0,32
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	546080e7          	jalr	1350(ra) # 80005f0a <uartputc_sync>
    800059cc:	4521                	li	a0,8
    800059ce:	00000097          	auipc	ra,0x0
    800059d2:	53c080e7          	jalr	1340(ra) # 80005f0a <uartputc_sync>
    800059d6:	bfe1                	j	800059ae <consputc+0x18>

00000000800059d8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059d8:	1101                	addi	sp,sp,-32
    800059da:	ec06                	sd	ra,24(sp)
    800059dc:	e822                	sd	s0,16(sp)
    800059de:	e426                	sd	s1,8(sp)
    800059e0:	e04a                	sd	s2,0(sp)
    800059e2:	1000                	addi	s0,sp,32
    800059e4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059e6:	00020517          	auipc	a0,0x20
    800059ea:	75a50513          	addi	a0,a0,1882 # 80026140 <cons>
    800059ee:	00000097          	auipc	ra,0x0
    800059f2:	7b4080e7          	jalr	1972(ra) # 800061a2 <acquire>

  switch(c){
    800059f6:	47d5                	li	a5,21
    800059f8:	0af48663          	beq	s1,a5,80005aa4 <consoleintr+0xcc>
    800059fc:	0297ca63          	blt	a5,s1,80005a30 <consoleintr+0x58>
    80005a00:	47a1                	li	a5,8
    80005a02:	0ef48763          	beq	s1,a5,80005af0 <consoleintr+0x118>
    80005a06:	47c1                	li	a5,16
    80005a08:	10f49a63          	bne	s1,a5,80005b1c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a0c:	ffffc097          	auipc	ra,0xffffc
    80005a10:	f78080e7          	jalr	-136(ra) # 80001984 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a14:	00020517          	auipc	a0,0x20
    80005a18:	72c50513          	addi	a0,a0,1836 # 80026140 <cons>
    80005a1c:	00001097          	auipc	ra,0x1
    80005a20:	83a080e7          	jalr	-1990(ra) # 80006256 <release>
}
    80005a24:	60e2                	ld	ra,24(sp)
    80005a26:	6442                	ld	s0,16(sp)
    80005a28:	64a2                	ld	s1,8(sp)
    80005a2a:	6902                	ld	s2,0(sp)
    80005a2c:	6105                	addi	sp,sp,32
    80005a2e:	8082                	ret
  switch(c){
    80005a30:	07f00793          	li	a5,127
    80005a34:	0af48e63          	beq	s1,a5,80005af0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a38:	00020717          	auipc	a4,0x20
    80005a3c:	70870713          	addi	a4,a4,1800 # 80026140 <cons>
    80005a40:	0a072783          	lw	a5,160(a4)
    80005a44:	09872703          	lw	a4,152(a4)
    80005a48:	9f99                	subw	a5,a5,a4
    80005a4a:	07f00713          	li	a4,127
    80005a4e:	fcf763e3          	bltu	a4,a5,80005a14 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a52:	47b5                	li	a5,13
    80005a54:	0cf48763          	beq	s1,a5,80005b22 <consoleintr+0x14a>
      consputc(c);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	00000097          	auipc	ra,0x0
    80005a5e:	f3c080e7          	jalr	-196(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a62:	00020797          	auipc	a5,0x20
    80005a66:	6de78793          	addi	a5,a5,1758 # 80026140 <cons>
    80005a6a:	0a07a703          	lw	a4,160(a5)
    80005a6e:	0017069b          	addiw	a3,a4,1
    80005a72:	0006861b          	sext.w	a2,a3
    80005a76:	0ad7a023          	sw	a3,160(a5)
    80005a7a:	07f77713          	andi	a4,a4,127
    80005a7e:	97ba                	add	a5,a5,a4
    80005a80:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a84:	47a9                	li	a5,10
    80005a86:	0cf48563          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a8a:	4791                	li	a5,4
    80005a8c:	0cf48263          	beq	s1,a5,80005b50 <consoleintr+0x178>
    80005a90:	00020797          	auipc	a5,0x20
    80005a94:	7487a783          	lw	a5,1864(a5) # 800261d8 <cons+0x98>
    80005a98:	0807879b          	addiw	a5,a5,128
    80005a9c:	f6f61ce3          	bne	a2,a5,80005a14 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa0:	863e                	mv	a2,a5
    80005aa2:	a07d                	j	80005b50 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005aa4:	00020717          	auipc	a4,0x20
    80005aa8:	69c70713          	addi	a4,a4,1692 # 80026140 <cons>
    80005aac:	0a072783          	lw	a5,160(a4)
    80005ab0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ab4:	00020497          	auipc	s1,0x20
    80005ab8:	68c48493          	addi	s1,s1,1676 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005abc:	4929                	li	s2,10
    80005abe:	f4f70be3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ac2:	37fd                	addiw	a5,a5,-1
    80005ac4:	07f7f713          	andi	a4,a5,127
    80005ac8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005aca:	01874703          	lbu	a4,24(a4)
    80005ace:	f52703e3          	beq	a4,s2,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005ad2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ad6:	10000513          	li	a0,256
    80005ada:	00000097          	auipc	ra,0x0
    80005ade:	ebc080e7          	jalr	-324(ra) # 80005996 <consputc>
    while(cons.e != cons.w &&
    80005ae2:	0a04a783          	lw	a5,160(s1)
    80005ae6:	09c4a703          	lw	a4,156(s1)
    80005aea:	fcf71ce3          	bne	a4,a5,80005ac2 <consoleintr+0xea>
    80005aee:	b71d                	j	80005a14 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005af0:	00020717          	auipc	a4,0x20
    80005af4:	65070713          	addi	a4,a4,1616 # 80026140 <cons>
    80005af8:	0a072783          	lw	a5,160(a4)
    80005afc:	09c72703          	lw	a4,156(a4)
    80005b00:	f0f70ae3          	beq	a4,a5,80005a14 <consoleintr+0x3c>
      cons.e--;
    80005b04:	37fd                	addiw	a5,a5,-1
    80005b06:	00020717          	auipc	a4,0x20
    80005b0a:	6cf72d23          	sw	a5,1754(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b0e:	10000513          	li	a0,256
    80005b12:	00000097          	auipc	ra,0x0
    80005b16:	e84080e7          	jalr	-380(ra) # 80005996 <consputc>
    80005b1a:	bded                	j	80005a14 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b1c:	ee048ce3          	beqz	s1,80005a14 <consoleintr+0x3c>
    80005b20:	bf21                	j	80005a38 <consoleintr+0x60>
      consputc(c);
    80005b22:	4529                	li	a0,10
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	e72080e7          	jalr	-398(ra) # 80005996 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b2c:	00020797          	auipc	a5,0x20
    80005b30:	61478793          	addi	a5,a5,1556 # 80026140 <cons>
    80005b34:	0a07a703          	lw	a4,160(a5)
    80005b38:	0017069b          	addiw	a3,a4,1
    80005b3c:	0006861b          	sext.w	a2,a3
    80005b40:	0ad7a023          	sw	a3,160(a5)
    80005b44:	07f77713          	andi	a4,a4,127
    80005b48:	97ba                	add	a5,a5,a4
    80005b4a:	4729                	li	a4,10
    80005b4c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b50:	00020797          	auipc	a5,0x20
    80005b54:	68c7a623          	sw	a2,1676(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b58:	00020517          	auipc	a0,0x20
    80005b5c:	68050513          	addi	a0,a0,1664 # 800261d8 <cons+0x98>
    80005b60:	ffffc097          	auipc	ra,0xffffc
    80005b64:	b60080e7          	jalr	-1184(ra) # 800016c0 <wakeup>
    80005b68:	b575                	j	80005a14 <consoleintr+0x3c>

0000000080005b6a <consoleinit>:

void
consoleinit(void)
{
    80005b6a:	1141                	addi	sp,sp,-16
    80005b6c:	e406                	sd	ra,8(sp)
    80005b6e:	e022                	sd	s0,0(sp)
    80005b70:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b72:	00003597          	auipc	a1,0x3
    80005b76:	da658593          	addi	a1,a1,-602 # 80008918 <syscall_names+0x3c8>
    80005b7a:	00020517          	auipc	a0,0x20
    80005b7e:	5c650513          	addi	a0,a0,1478 # 80026140 <cons>
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	590080e7          	jalr	1424(ra) # 80006112 <initlock>

  uartinit();
    80005b8a:	00000097          	auipc	ra,0x0
    80005b8e:	330080e7          	jalr	816(ra) # 80005eba <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b92:	00013797          	auipc	a5,0x13
    80005b96:	73678793          	addi	a5,a5,1846 # 800192c8 <devsw>
    80005b9a:	00000717          	auipc	a4,0x0
    80005b9e:	ce470713          	addi	a4,a4,-796 # 8000587e <consoleread>
    80005ba2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ba4:	00000717          	auipc	a4,0x0
    80005ba8:	c7870713          	addi	a4,a4,-904 # 8000581c <consolewrite>
    80005bac:	ef98                	sd	a4,24(a5)
}
    80005bae:	60a2                	ld	ra,8(sp)
    80005bb0:	6402                	ld	s0,0(sp)
    80005bb2:	0141                	addi	sp,sp,16
    80005bb4:	8082                	ret

0000000080005bb6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bb6:	7179                	addi	sp,sp,-48
    80005bb8:	f406                	sd	ra,40(sp)
    80005bba:	f022                	sd	s0,32(sp)
    80005bbc:	ec26                	sd	s1,24(sp)
    80005bbe:	e84a                	sd	s2,16(sp)
    80005bc0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bc2:	c219                	beqz	a2,80005bc8 <printint+0x12>
    80005bc4:	08054663          	bltz	a0,80005c50 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005bc8:	2501                	sext.w	a0,a0
    80005bca:	4881                	li	a7,0
    80005bcc:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bd0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bd2:	2581                	sext.w	a1,a1
    80005bd4:	00003617          	auipc	a2,0x3
    80005bd8:	d7460613          	addi	a2,a2,-652 # 80008948 <digits>
    80005bdc:	883a                	mv	a6,a4
    80005bde:	2705                	addiw	a4,a4,1
    80005be0:	02b577bb          	remuw	a5,a0,a1
    80005be4:	1782                	slli	a5,a5,0x20
    80005be6:	9381                	srli	a5,a5,0x20
    80005be8:	97b2                	add	a5,a5,a2
    80005bea:	0007c783          	lbu	a5,0(a5)
    80005bee:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bf2:	0005079b          	sext.w	a5,a0
    80005bf6:	02b5553b          	divuw	a0,a0,a1
    80005bfa:	0685                	addi	a3,a3,1
    80005bfc:	feb7f0e3          	bgeu	a5,a1,80005bdc <printint+0x26>

  if(sign)
    80005c00:	00088b63          	beqz	a7,80005c16 <printint+0x60>
    buf[i++] = '-';
    80005c04:	fe040793          	addi	a5,s0,-32
    80005c08:	973e                	add	a4,a4,a5
    80005c0a:	02d00793          	li	a5,45
    80005c0e:	fef70823          	sb	a5,-16(a4)
    80005c12:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c16:	02e05763          	blez	a4,80005c44 <printint+0x8e>
    80005c1a:	fd040793          	addi	a5,s0,-48
    80005c1e:	00e784b3          	add	s1,a5,a4
    80005c22:	fff78913          	addi	s2,a5,-1
    80005c26:	993a                	add	s2,s2,a4
    80005c28:	377d                	addiw	a4,a4,-1
    80005c2a:	1702                	slli	a4,a4,0x20
    80005c2c:	9301                	srli	a4,a4,0x20
    80005c2e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c32:	fff4c503          	lbu	a0,-1(s1)
    80005c36:	00000097          	auipc	ra,0x0
    80005c3a:	d60080e7          	jalr	-672(ra) # 80005996 <consputc>
  while(--i >= 0)
    80005c3e:	14fd                	addi	s1,s1,-1
    80005c40:	ff2499e3          	bne	s1,s2,80005c32 <printint+0x7c>
}
    80005c44:	70a2                	ld	ra,40(sp)
    80005c46:	7402                	ld	s0,32(sp)
    80005c48:	64e2                	ld	s1,24(sp)
    80005c4a:	6942                	ld	s2,16(sp)
    80005c4c:	6145                	addi	sp,sp,48
    80005c4e:	8082                	ret
    x = -xx;
    80005c50:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c54:	4885                	li	a7,1
    x = -xx;
    80005c56:	bf9d                	j	80005bcc <printint+0x16>

0000000080005c58 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c58:	1101                	addi	sp,sp,-32
    80005c5a:	ec06                	sd	ra,24(sp)
    80005c5c:	e822                	sd	s0,16(sp)
    80005c5e:	e426                	sd	s1,8(sp)
    80005c60:	1000                	addi	s0,sp,32
    80005c62:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c64:	00020797          	auipc	a5,0x20
    80005c68:	5807ae23          	sw	zero,1436(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c6c:	00003517          	auipc	a0,0x3
    80005c70:	cb450513          	addi	a0,a0,-844 # 80008920 <syscall_names+0x3d0>
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	02e080e7          	jalr	46(ra) # 80005ca2 <printf>
  printf(s);
    80005c7c:	8526                	mv	a0,s1
    80005c7e:	00000097          	auipc	ra,0x0
    80005c82:	024080e7          	jalr	36(ra) # 80005ca2 <printf>
  printf("\n");
    80005c86:	00002517          	auipc	a0,0x2
    80005c8a:	3c250513          	addi	a0,a0,962 # 80008048 <etext+0x48>
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	014080e7          	jalr	20(ra) # 80005ca2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c96:	4785                	li	a5,1
    80005c98:	00003717          	auipc	a4,0x3
    80005c9c:	38f72223          	sw	a5,900(a4) # 8000901c <panicked>
  for(;;)
    80005ca0:	a001                	j	80005ca0 <panic+0x48>

0000000080005ca2 <printf>:
{
    80005ca2:	7131                	addi	sp,sp,-192
    80005ca4:	fc86                	sd	ra,120(sp)
    80005ca6:	f8a2                	sd	s0,112(sp)
    80005ca8:	f4a6                	sd	s1,104(sp)
    80005caa:	f0ca                	sd	s2,96(sp)
    80005cac:	ecce                	sd	s3,88(sp)
    80005cae:	e8d2                	sd	s4,80(sp)
    80005cb0:	e4d6                	sd	s5,72(sp)
    80005cb2:	e0da                	sd	s6,64(sp)
    80005cb4:	fc5e                	sd	s7,56(sp)
    80005cb6:	f862                	sd	s8,48(sp)
    80005cb8:	f466                	sd	s9,40(sp)
    80005cba:	f06a                	sd	s10,32(sp)
    80005cbc:	ec6e                	sd	s11,24(sp)
    80005cbe:	0100                	addi	s0,sp,128
    80005cc0:	8a2a                	mv	s4,a0
    80005cc2:	e40c                	sd	a1,8(s0)
    80005cc4:	e810                	sd	a2,16(s0)
    80005cc6:	ec14                	sd	a3,24(s0)
    80005cc8:	f018                	sd	a4,32(s0)
    80005cca:	f41c                	sd	a5,40(s0)
    80005ccc:	03043823          	sd	a6,48(s0)
    80005cd0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005cd4:	00020d97          	auipc	s11,0x20
    80005cd8:	52cdad83          	lw	s11,1324(s11) # 80026200 <pr+0x18>
  if(locking)
    80005cdc:	020d9b63          	bnez	s11,80005d12 <printf+0x70>
  if (fmt == 0)
    80005ce0:	040a0263          	beqz	s4,80005d24 <printf+0x82>
  va_start(ap, fmt);
    80005ce4:	00840793          	addi	a5,s0,8
    80005ce8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cec:	000a4503          	lbu	a0,0(s4)
    80005cf0:	16050263          	beqz	a0,80005e54 <printf+0x1b2>
    80005cf4:	4481                	li	s1,0
    if(c != '%'){
    80005cf6:	02500a93          	li	s5,37
    switch(c){
    80005cfa:	07000b13          	li	s6,112
  consputc('x');
    80005cfe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d00:	00003b97          	auipc	s7,0x3
    80005d04:	c48b8b93          	addi	s7,s7,-952 # 80008948 <digits>
    switch(c){
    80005d08:	07300c93          	li	s9,115
    80005d0c:	06400c13          	li	s8,100
    80005d10:	a82d                	j	80005d4a <printf+0xa8>
    acquire(&pr.lock);
    80005d12:	00020517          	auipc	a0,0x20
    80005d16:	4d650513          	addi	a0,a0,1238 # 800261e8 <pr>
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	488080e7          	jalr	1160(ra) # 800061a2 <acquire>
    80005d22:	bf7d                	j	80005ce0 <printf+0x3e>
    panic("null fmt");
    80005d24:	00003517          	auipc	a0,0x3
    80005d28:	c0c50513          	addi	a0,a0,-1012 # 80008930 <syscall_names+0x3e0>
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	f2c080e7          	jalr	-212(ra) # 80005c58 <panic>
      consputc(c);
    80005d34:	00000097          	auipc	ra,0x0
    80005d38:	c62080e7          	jalr	-926(ra) # 80005996 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d3c:	2485                	addiw	s1,s1,1
    80005d3e:	009a07b3          	add	a5,s4,s1
    80005d42:	0007c503          	lbu	a0,0(a5)
    80005d46:	10050763          	beqz	a0,80005e54 <printf+0x1b2>
    if(c != '%'){
    80005d4a:	ff5515e3          	bne	a0,s5,80005d34 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d4e:	2485                	addiw	s1,s1,1
    80005d50:	009a07b3          	add	a5,s4,s1
    80005d54:	0007c783          	lbu	a5,0(a5)
    80005d58:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005d5c:	cfe5                	beqz	a5,80005e54 <printf+0x1b2>
    switch(c){
    80005d5e:	05678a63          	beq	a5,s6,80005db2 <printf+0x110>
    80005d62:	02fb7663          	bgeu	s6,a5,80005d8e <printf+0xec>
    80005d66:	09978963          	beq	a5,s9,80005df8 <printf+0x156>
    80005d6a:	07800713          	li	a4,120
    80005d6e:	0ce79863          	bne	a5,a4,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005d72:	f8843783          	ld	a5,-120(s0)
    80005d76:	00878713          	addi	a4,a5,8
    80005d7a:	f8e43423          	sd	a4,-120(s0)
    80005d7e:	4605                	li	a2,1
    80005d80:	85ea                	mv	a1,s10
    80005d82:	4388                	lw	a0,0(a5)
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	e32080e7          	jalr	-462(ra) # 80005bb6 <printint>
      break;
    80005d8c:	bf45                	j	80005d3c <printf+0x9a>
    switch(c){
    80005d8e:	0b578263          	beq	a5,s5,80005e32 <printf+0x190>
    80005d92:	0b879663          	bne	a5,s8,80005e3e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005d96:	f8843783          	ld	a5,-120(s0)
    80005d9a:	00878713          	addi	a4,a5,8
    80005d9e:	f8e43423          	sd	a4,-120(s0)
    80005da2:	4605                	li	a2,1
    80005da4:	45a9                	li	a1,10
    80005da6:	4388                	lw	a0,0(a5)
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	e0e080e7          	jalr	-498(ra) # 80005bb6 <printint>
      break;
    80005db0:	b771                	j	80005d3c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005db2:	f8843783          	ld	a5,-120(s0)
    80005db6:	00878713          	addi	a4,a5,8
    80005dba:	f8e43423          	sd	a4,-120(s0)
    80005dbe:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005dc2:	03000513          	li	a0,48
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	bd0080e7          	jalr	-1072(ra) # 80005996 <consputc>
  consputc('x');
    80005dce:	07800513          	li	a0,120
    80005dd2:	00000097          	auipc	ra,0x0
    80005dd6:	bc4080e7          	jalr	-1084(ra) # 80005996 <consputc>
    80005dda:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ddc:	03c9d793          	srli	a5,s3,0x3c
    80005de0:	97de                	add	a5,a5,s7
    80005de2:	0007c503          	lbu	a0,0(a5)
    80005de6:	00000097          	auipc	ra,0x0
    80005dea:	bb0080e7          	jalr	-1104(ra) # 80005996 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dee:	0992                	slli	s3,s3,0x4
    80005df0:	397d                	addiw	s2,s2,-1
    80005df2:	fe0915e3          	bnez	s2,80005ddc <printf+0x13a>
    80005df6:	b799                	j	80005d3c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005df8:	f8843783          	ld	a5,-120(s0)
    80005dfc:	00878713          	addi	a4,a5,8
    80005e00:	f8e43423          	sd	a4,-120(s0)
    80005e04:	0007b903          	ld	s2,0(a5)
    80005e08:	00090e63          	beqz	s2,80005e24 <printf+0x182>
      for(; *s; s++)
    80005e0c:	00094503          	lbu	a0,0(s2)
    80005e10:	d515                	beqz	a0,80005d3c <printf+0x9a>
        consputc(*s);
    80005e12:	00000097          	auipc	ra,0x0
    80005e16:	b84080e7          	jalr	-1148(ra) # 80005996 <consputc>
      for(; *s; s++)
    80005e1a:	0905                	addi	s2,s2,1
    80005e1c:	00094503          	lbu	a0,0(s2)
    80005e20:	f96d                	bnez	a0,80005e12 <printf+0x170>
    80005e22:	bf29                	j	80005d3c <printf+0x9a>
        s = "(null)";
    80005e24:	00003917          	auipc	s2,0x3
    80005e28:	b0490913          	addi	s2,s2,-1276 # 80008928 <syscall_names+0x3d8>
      for(; *s; s++)
    80005e2c:	02800513          	li	a0,40
    80005e30:	b7cd                	j	80005e12 <printf+0x170>
      consputc('%');
    80005e32:	8556                	mv	a0,s5
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	b62080e7          	jalr	-1182(ra) # 80005996 <consputc>
      break;
    80005e3c:	b701                	j	80005d3c <printf+0x9a>
      consputc('%');
    80005e3e:	8556                	mv	a0,s5
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	b56080e7          	jalr	-1194(ra) # 80005996 <consputc>
      consputc(c);
    80005e48:	854a                	mv	a0,s2
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	b4c080e7          	jalr	-1204(ra) # 80005996 <consputc>
      break;
    80005e52:	b5ed                	j	80005d3c <printf+0x9a>
  if(locking)
    80005e54:	020d9163          	bnez	s11,80005e76 <printf+0x1d4>
}
    80005e58:	70e6                	ld	ra,120(sp)
    80005e5a:	7446                	ld	s0,112(sp)
    80005e5c:	74a6                	ld	s1,104(sp)
    80005e5e:	7906                	ld	s2,96(sp)
    80005e60:	69e6                	ld	s3,88(sp)
    80005e62:	6a46                	ld	s4,80(sp)
    80005e64:	6aa6                	ld	s5,72(sp)
    80005e66:	6b06                	ld	s6,64(sp)
    80005e68:	7be2                	ld	s7,56(sp)
    80005e6a:	7c42                	ld	s8,48(sp)
    80005e6c:	7ca2                	ld	s9,40(sp)
    80005e6e:	7d02                	ld	s10,32(sp)
    80005e70:	6de2                	ld	s11,24(sp)
    80005e72:	6129                	addi	sp,sp,192
    80005e74:	8082                	ret
    release(&pr.lock);
    80005e76:	00020517          	auipc	a0,0x20
    80005e7a:	37250513          	addi	a0,a0,882 # 800261e8 <pr>
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	3d8080e7          	jalr	984(ra) # 80006256 <release>
}
    80005e86:	bfc9                	j	80005e58 <printf+0x1b6>

0000000080005e88 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e88:	1101                	addi	sp,sp,-32
    80005e8a:	ec06                	sd	ra,24(sp)
    80005e8c:	e822                	sd	s0,16(sp)
    80005e8e:	e426                	sd	s1,8(sp)
    80005e90:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e92:	00020497          	auipc	s1,0x20
    80005e96:	35648493          	addi	s1,s1,854 # 800261e8 <pr>
    80005e9a:	00003597          	auipc	a1,0x3
    80005e9e:	aa658593          	addi	a1,a1,-1370 # 80008940 <syscall_names+0x3f0>
    80005ea2:	8526                	mv	a0,s1
    80005ea4:	00000097          	auipc	ra,0x0
    80005ea8:	26e080e7          	jalr	622(ra) # 80006112 <initlock>
  pr.locking = 1;
    80005eac:	4785                	li	a5,1
    80005eae:	cc9c                	sw	a5,24(s1)
}
    80005eb0:	60e2                	ld	ra,24(sp)
    80005eb2:	6442                	ld	s0,16(sp)
    80005eb4:	64a2                	ld	s1,8(sp)
    80005eb6:	6105                	addi	sp,sp,32
    80005eb8:	8082                	ret

0000000080005eba <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005eba:	1141                	addi	sp,sp,-16
    80005ebc:	e406                	sd	ra,8(sp)
    80005ebe:	e022                	sd	s0,0(sp)
    80005ec0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005ec2:	100007b7          	lui	a5,0x10000
    80005ec6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005eca:	f8000713          	li	a4,-128
    80005ece:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ed2:	470d                	li	a4,3
    80005ed4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ed8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005edc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee0:	469d                	li	a3,7
    80005ee2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ee6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005eea:	00003597          	auipc	a1,0x3
    80005eee:	a7658593          	addi	a1,a1,-1418 # 80008960 <digits+0x18>
    80005ef2:	00020517          	auipc	a0,0x20
    80005ef6:	31650513          	addi	a0,a0,790 # 80026208 <uart_tx_lock>
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	218080e7          	jalr	536(ra) # 80006112 <initlock>
}
    80005f02:	60a2                	ld	ra,8(sp)
    80005f04:	6402                	ld	s0,0(sp)
    80005f06:	0141                	addi	sp,sp,16
    80005f08:	8082                	ret

0000000080005f0a <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f0a:	1101                	addi	sp,sp,-32
    80005f0c:	ec06                	sd	ra,24(sp)
    80005f0e:	e822                	sd	s0,16(sp)
    80005f10:	e426                	sd	s1,8(sp)
    80005f12:	1000                	addi	s0,sp,32
    80005f14:	84aa                	mv	s1,a0
  push_off();
    80005f16:	00000097          	auipc	ra,0x0
    80005f1a:	240080e7          	jalr	576(ra) # 80006156 <push_off>

  if(panicked){
    80005f1e:	00003797          	auipc	a5,0x3
    80005f22:	0fe7a783          	lw	a5,254(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f26:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f2a:	c391                	beqz	a5,80005f2e <uartputc_sync+0x24>
    for(;;)
    80005f2c:	a001                	j	80005f2c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f2e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f32:	0ff7f793          	andi	a5,a5,255
    80005f36:	0207f793          	andi	a5,a5,32
    80005f3a:	dbf5                	beqz	a5,80005f2e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f3c:	0ff4f793          	andi	a5,s1,255
    80005f40:	10000737          	lui	a4,0x10000
    80005f44:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	2ae080e7          	jalr	686(ra) # 800061f6 <pop_off>
}
    80005f50:	60e2                	ld	ra,24(sp)
    80005f52:	6442                	ld	s0,16(sp)
    80005f54:	64a2                	ld	s1,8(sp)
    80005f56:	6105                	addi	sp,sp,32
    80005f58:	8082                	ret

0000000080005f5a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f5a:	00003717          	auipc	a4,0x3
    80005f5e:	0c673703          	ld	a4,198(a4) # 80009020 <uart_tx_r>
    80005f62:	00003797          	auipc	a5,0x3
    80005f66:	0c67b783          	ld	a5,198(a5) # 80009028 <uart_tx_w>
    80005f6a:	06e78c63          	beq	a5,a4,80005fe2 <uartstart+0x88>
{
    80005f6e:	7139                	addi	sp,sp,-64
    80005f70:	fc06                	sd	ra,56(sp)
    80005f72:	f822                	sd	s0,48(sp)
    80005f74:	f426                	sd	s1,40(sp)
    80005f76:	f04a                	sd	s2,32(sp)
    80005f78:	ec4e                	sd	s3,24(sp)
    80005f7a:	e852                	sd	s4,16(sp)
    80005f7c:	e456                	sd	s5,8(sp)
    80005f7e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f80:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f84:	00020a17          	auipc	s4,0x20
    80005f88:	284a0a13          	addi	s4,s4,644 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005f8c:	00003497          	auipc	s1,0x3
    80005f90:	09448493          	addi	s1,s1,148 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f94:	00003997          	auipc	s3,0x3
    80005f98:	09498993          	addi	s3,s3,148 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f9c:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fa0:	0ff7f793          	andi	a5,a5,255
    80005fa4:	0207f793          	andi	a5,a5,32
    80005fa8:	c785                	beqz	a5,80005fd0 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005faa:	01f77793          	andi	a5,a4,31
    80005fae:	97d2                	add	a5,a5,s4
    80005fb0:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    80005fb4:	0705                	addi	a4,a4,1
    80005fb6:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb8:	8526                	mv	a0,s1
    80005fba:	ffffb097          	auipc	ra,0xffffb
    80005fbe:	706080e7          	jalr	1798(ra) # 800016c0 <wakeup>
    
    WriteReg(THR, c);
    80005fc2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc6:	6098                	ld	a4,0(s1)
    80005fc8:	0009b783          	ld	a5,0(s3)
    80005fcc:	fce798e3          	bne	a5,a4,80005f9c <uartstart+0x42>
  }
}
    80005fd0:	70e2                	ld	ra,56(sp)
    80005fd2:	7442                	ld	s0,48(sp)
    80005fd4:	74a2                	ld	s1,40(sp)
    80005fd6:	7902                	ld	s2,32(sp)
    80005fd8:	69e2                	ld	s3,24(sp)
    80005fda:	6a42                	ld	s4,16(sp)
    80005fdc:	6aa2                	ld	s5,8(sp)
    80005fde:	6121                	addi	sp,sp,64
    80005fe0:	8082                	ret
    80005fe2:	8082                	ret

0000000080005fe4 <uartputc>:
{
    80005fe4:	7179                	addi	sp,sp,-48
    80005fe6:	f406                	sd	ra,40(sp)
    80005fe8:	f022                	sd	s0,32(sp)
    80005fea:	ec26                	sd	s1,24(sp)
    80005fec:	e84a                	sd	s2,16(sp)
    80005fee:	e44e                	sd	s3,8(sp)
    80005ff0:	e052                	sd	s4,0(sp)
    80005ff2:	1800                	addi	s0,sp,48
    80005ff4:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80005ff6:	00020517          	auipc	a0,0x20
    80005ffa:	21250513          	addi	a0,a0,530 # 80026208 <uart_tx_lock>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	1a4080e7          	jalr	420(ra) # 800061a2 <acquire>
  if(panicked){
    80006006:	00003797          	auipc	a5,0x3
    8000600a:	0167a783          	lw	a5,22(a5) # 8000901c <panicked>
    8000600e:	c391                	beqz	a5,80006012 <uartputc+0x2e>
    for(;;)
    80006010:	a001                	j	80006010 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006012:	00003797          	auipc	a5,0x3
    80006016:	0167b783          	ld	a5,22(a5) # 80009028 <uart_tx_w>
    8000601a:	00003717          	auipc	a4,0x3
    8000601e:	00673703          	ld	a4,6(a4) # 80009020 <uart_tx_r>
    80006022:	02070713          	addi	a4,a4,32
    80006026:	02f71b63          	bne	a4,a5,8000605c <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000602a:	00020a17          	auipc	s4,0x20
    8000602e:	1dea0a13          	addi	s4,s4,478 # 80026208 <uart_tx_lock>
    80006032:	00003497          	auipc	s1,0x3
    80006036:	fee48493          	addi	s1,s1,-18 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000603a:	00003917          	auipc	s2,0x3
    8000603e:	fee90913          	addi	s2,s2,-18 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006042:	85d2                	mv	a1,s4
    80006044:	8526                	mv	a0,s1
    80006046:	ffffb097          	auipc	ra,0xffffb
    8000604a:	4ee080e7          	jalr	1262(ra) # 80001534 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604e:	00093783          	ld	a5,0(s2)
    80006052:	6098                	ld	a4,0(s1)
    80006054:	02070713          	addi	a4,a4,32
    80006058:	fef705e3          	beq	a4,a5,80006042 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000605c:	00020497          	auipc	s1,0x20
    80006060:	1ac48493          	addi	s1,s1,428 # 80026208 <uart_tx_lock>
    80006064:	01f7f713          	andi	a4,a5,31
    80006068:	9726                	add	a4,a4,s1
    8000606a:	01370c23          	sb	s3,24(a4)
      uart_tx_w += 1;
    8000606e:	0785                	addi	a5,a5,1
    80006070:	00003717          	auipc	a4,0x3
    80006074:	faf73c23          	sd	a5,-72(a4) # 80009028 <uart_tx_w>
      uartstart();
    80006078:	00000097          	auipc	ra,0x0
    8000607c:	ee2080e7          	jalr	-286(ra) # 80005f5a <uartstart>
      release(&uart_tx_lock);
    80006080:	8526                	mv	a0,s1
    80006082:	00000097          	auipc	ra,0x0
    80006086:	1d4080e7          	jalr	468(ra) # 80006256 <release>
}
    8000608a:	70a2                	ld	ra,40(sp)
    8000608c:	7402                	ld	s0,32(sp)
    8000608e:	64e2                	ld	s1,24(sp)
    80006090:	6942                	ld	s2,16(sp)
    80006092:	69a2                	ld	s3,8(sp)
    80006094:	6a02                	ld	s4,0(sp)
    80006096:	6145                	addi	sp,sp,48
    80006098:	8082                	ret

000000008000609a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e422                	sd	s0,8(sp)
    8000609e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060a0:	100007b7          	lui	a5,0x10000
    800060a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a8:	8b85                	andi	a5,a5,1
    800060aa:	cb91                	beqz	a5,800060be <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800060ac:	100007b7          	lui	a5,0x10000
    800060b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800060b4:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800060b8:	6422                	ld	s0,8(sp)
    800060ba:	0141                	addi	sp,sp,16
    800060bc:	8082                	ret
    return -1;
    800060be:	557d                	li	a0,-1
    800060c0:	bfe5                	j	800060b8 <uartgetc+0x1e>

00000000800060c2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800060c2:	1101                	addi	sp,sp,-32
    800060c4:	ec06                	sd	ra,24(sp)
    800060c6:	e822                	sd	s0,16(sp)
    800060c8:	e426                	sd	s1,8(sp)
    800060ca:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060cc:	54fd                	li	s1,-1
    int c = uartgetc();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	fcc080e7          	jalr	-52(ra) # 8000609a <uartgetc>
    if(c == -1)
    800060d6:	00950763          	beq	a0,s1,800060e4 <uartintr+0x22>
      break;
    consoleintr(c);
    800060da:	00000097          	auipc	ra,0x0
    800060de:	8fe080e7          	jalr	-1794(ra) # 800059d8 <consoleintr>
  while(1){
    800060e2:	b7f5                	j	800060ce <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060e4:	00020497          	auipc	s1,0x20
    800060e8:	12448493          	addi	s1,s1,292 # 80026208 <uart_tx_lock>
    800060ec:	8526                	mv	a0,s1
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	0b4080e7          	jalr	180(ra) # 800061a2 <acquire>
  uartstart();
    800060f6:	00000097          	auipc	ra,0x0
    800060fa:	e64080e7          	jalr	-412(ra) # 80005f5a <uartstart>
  release(&uart_tx_lock);
    800060fe:	8526                	mv	a0,s1
    80006100:	00000097          	auipc	ra,0x0
    80006104:	156080e7          	jalr	342(ra) # 80006256 <release>
}
    80006108:	60e2                	ld	ra,24(sp)
    8000610a:	6442                	ld	s0,16(sp)
    8000610c:	64a2                	ld	s1,8(sp)
    8000610e:	6105                	addi	sp,sp,32
    80006110:	8082                	ret

0000000080006112 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006112:	1141                	addi	sp,sp,-16
    80006114:	e422                	sd	s0,8(sp)
    80006116:	0800                	addi	s0,sp,16
  lk->name = name;
    80006118:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000611a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000611e:	00053823          	sd	zero,16(a0)
}
    80006122:	6422                	ld	s0,8(sp)
    80006124:	0141                	addi	sp,sp,16
    80006126:	8082                	ret

0000000080006128 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006128:	411c                	lw	a5,0(a0)
    8000612a:	e399                	bnez	a5,80006130 <holding+0x8>
    8000612c:	4501                	li	a0,0
  return r;
}
    8000612e:	8082                	ret
{
    80006130:	1101                	addi	sp,sp,-32
    80006132:	ec06                	sd	ra,24(sp)
    80006134:	e822                	sd	s0,16(sp)
    80006136:	e426                	sd	s1,8(sp)
    80006138:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000613a:	6904                	ld	s1,16(a0)
    8000613c:	ffffb097          	auipc	ra,0xffffb
    80006140:	d14080e7          	jalr	-748(ra) # 80000e50 <mycpu>
    80006144:	40a48533          	sub	a0,s1,a0
    80006148:	00153513          	seqz	a0,a0
}
    8000614c:	60e2                	ld	ra,24(sp)
    8000614e:	6442                	ld	s0,16(sp)
    80006150:	64a2                	ld	s1,8(sp)
    80006152:	6105                	addi	sp,sp,32
    80006154:	8082                	ret

0000000080006156 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006156:	1101                	addi	sp,sp,-32
    80006158:	ec06                	sd	ra,24(sp)
    8000615a:	e822                	sd	s0,16(sp)
    8000615c:	e426                	sd	s1,8(sp)
    8000615e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006160:	100024f3          	csrr	s1,sstatus
    80006164:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006168:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000616a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	ce2080e7          	jalr	-798(ra) # 80000e50 <mycpu>
    80006176:	5d3c                	lw	a5,120(a0)
    80006178:	cf89                	beqz	a5,80006192 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000617a:	ffffb097          	auipc	ra,0xffffb
    8000617e:	cd6080e7          	jalr	-810(ra) # 80000e50 <mycpu>
    80006182:	5d3c                	lw	a5,120(a0)
    80006184:	2785                	addiw	a5,a5,1
    80006186:	dd3c                	sw	a5,120(a0)
}
    80006188:	60e2                	ld	ra,24(sp)
    8000618a:	6442                	ld	s0,16(sp)
    8000618c:	64a2                	ld	s1,8(sp)
    8000618e:	6105                	addi	sp,sp,32
    80006190:	8082                	ret
    mycpu()->intena = old;
    80006192:	ffffb097          	auipc	ra,0xffffb
    80006196:	cbe080e7          	jalr	-834(ra) # 80000e50 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000619a:	8085                	srli	s1,s1,0x1
    8000619c:	8885                	andi	s1,s1,1
    8000619e:	dd64                	sw	s1,124(a0)
    800061a0:	bfe9                	j	8000617a <push_off+0x24>

00000000800061a2 <acquire>:
{
    800061a2:	1101                	addi	sp,sp,-32
    800061a4:	ec06                	sd	ra,24(sp)
    800061a6:	e822                	sd	s0,16(sp)
    800061a8:	e426                	sd	s1,8(sp)
    800061aa:	1000                	addi	s0,sp,32
    800061ac:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	fa8080e7          	jalr	-88(ra) # 80006156 <push_off>
  if(holding(lk))
    800061b6:	8526                	mv	a0,s1
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	f70080e7          	jalr	-144(ra) # 80006128 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061c0:	4705                	li	a4,1
  if(holding(lk))
    800061c2:	e115                	bnez	a0,800061e6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061c4:	87ba                	mv	a5,a4
    800061c6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061ca:	2781                	sext.w	a5,a5
    800061cc:	ffe5                	bnez	a5,800061c4 <acquire+0x22>
  __sync_synchronize();
    800061ce:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061d2:	ffffb097          	auipc	ra,0xffffb
    800061d6:	c7e080e7          	jalr	-898(ra) # 80000e50 <mycpu>
    800061da:	e888                	sd	a0,16(s1)
}
    800061dc:	60e2                	ld	ra,24(sp)
    800061de:	6442                	ld	s0,16(sp)
    800061e0:	64a2                	ld	s1,8(sp)
    800061e2:	6105                	addi	sp,sp,32
    800061e4:	8082                	ret
    panic("acquire");
    800061e6:	00002517          	auipc	a0,0x2
    800061ea:	78250513          	addi	a0,a0,1922 # 80008968 <digits+0x20>
    800061ee:	00000097          	auipc	ra,0x0
    800061f2:	a6a080e7          	jalr	-1430(ra) # 80005c58 <panic>

00000000800061f6 <pop_off>:

void
pop_off(void)
{
    800061f6:	1141                	addi	sp,sp,-16
    800061f8:	e406                	sd	ra,8(sp)
    800061fa:	e022                	sd	s0,0(sp)
    800061fc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061fe:	ffffb097          	auipc	ra,0xffffb
    80006202:	c52080e7          	jalr	-942(ra) # 80000e50 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006206:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000620a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000620c:	e78d                	bnez	a5,80006236 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000620e:	5d3c                	lw	a5,120(a0)
    80006210:	02f05b63          	blez	a5,80006246 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006214:	37fd                	addiw	a5,a5,-1
    80006216:	0007871b          	sext.w	a4,a5
    8000621a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000621c:	eb09                	bnez	a4,8000622e <pop_off+0x38>
    8000621e:	5d7c                	lw	a5,124(a0)
    80006220:	c799                	beqz	a5,8000622e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006222:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006226:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000622a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000622e:	60a2                	ld	ra,8(sp)
    80006230:	6402                	ld	s0,0(sp)
    80006232:	0141                	addi	sp,sp,16
    80006234:	8082                	ret
    panic("pop_off - interruptible");
    80006236:	00002517          	auipc	a0,0x2
    8000623a:	73a50513          	addi	a0,a0,1850 # 80008970 <digits+0x28>
    8000623e:	00000097          	auipc	ra,0x0
    80006242:	a1a080e7          	jalr	-1510(ra) # 80005c58 <panic>
    panic("pop_off");
    80006246:	00002517          	auipc	a0,0x2
    8000624a:	74250513          	addi	a0,a0,1858 # 80008988 <digits+0x40>
    8000624e:	00000097          	auipc	ra,0x0
    80006252:	a0a080e7          	jalr	-1526(ra) # 80005c58 <panic>

0000000080006256 <release>:
{
    80006256:	1101                	addi	sp,sp,-32
    80006258:	ec06                	sd	ra,24(sp)
    8000625a:	e822                	sd	s0,16(sp)
    8000625c:	e426                	sd	s1,8(sp)
    8000625e:	1000                	addi	s0,sp,32
    80006260:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006262:	00000097          	auipc	ra,0x0
    80006266:	ec6080e7          	jalr	-314(ra) # 80006128 <holding>
    8000626a:	c115                	beqz	a0,8000628e <release+0x38>
  lk->cpu = 0;
    8000626c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006270:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006274:	0f50000f          	fence	iorw,ow
    80006278:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000627c:	00000097          	auipc	ra,0x0
    80006280:	f7a080e7          	jalr	-134(ra) # 800061f6 <pop_off>
}
    80006284:	60e2                	ld	ra,24(sp)
    80006286:	6442                	ld	s0,16(sp)
    80006288:	64a2                	ld	s1,8(sp)
    8000628a:	6105                	addi	sp,sp,32
    8000628c:	8082                	ret
    panic("release");
    8000628e:	00002517          	auipc	a0,0x2
    80006292:	70250513          	addi	a0,a0,1794 # 80008990 <digits+0x48>
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	9c2080e7          	jalr	-1598(ra) # 80005c58 <panic>
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
