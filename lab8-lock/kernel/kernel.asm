
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00022117          	auipc	sp,0x22
    80000004:	17010113          	addi	sp,sp,368 # 80022170 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	4f7050ef          	jal	ra,80005d0c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64

  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	03451793          	slli	a5,a0,0x34
    80000032:	e3c1                	bnez	a5,800000b2 <kfree+0x96>
    80000034:	84aa                	mv	s1,a0
    80000036:	0002b797          	auipc	a5,0x2b
    8000003a:	21278793          	addi	a5,a5,530 # 8002b248 <end>
    8000003e:	06f56a63          	bltu	a0,a5,800000b2 <kfree+0x96>
    80000042:	47c5                	li	a5,17
    80000044:	07ee                	slli	a5,a5,0x1b
    80000046:	06f57663          	bgeu	a0,a5,800000b2 <kfree+0x96>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	00000097          	auipc	ra,0x0
    80000052:	300080e7          	jalr	768(ra) # 8000034e <memset>

  r = (struct run*)pa;
  push_off();
    80000056:	00006097          	auipc	ra,0x6
    8000005a:	64e080e7          	jalr	1614(ra) # 800066a4 <push_off>
  int id = cpuid();
    8000005e:	00001097          	auipc	ra,0x1
    80000062:	fa4080e7          	jalr	-92(ra) # 80001002 <cpuid>
  acquire(&kmem[id].lock);
    80000066:	00009a97          	auipc	s5,0x9
    8000006a:	fcaa8a93          	addi	s5,s5,-54 # 80009030 <kmem>
    8000006e:	00251993          	slli	s3,a0,0x2
    80000072:	00a98933          	add	s2,s3,a0
    80000076:	090e                	slli	s2,s2,0x3
    80000078:	9956                	add	s2,s2,s5
    8000007a:	854a                	mv	a0,s2
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	674080e7          	jalr	1652(ra) # 800066f0 <acquire>
  r->next = kmem[id].freelist;
    80000084:	02093783          	ld	a5,32(s2)
    80000088:	e09c                	sd	a5,0(s1)
  kmem[id].freelist = r;
    8000008a:	02993023          	sd	s1,32(s2)
  release(&kmem[id].lock);
    8000008e:	854a                	mv	a0,s2
    80000090:	00006097          	auipc	ra,0x6
    80000094:	730080e7          	jalr	1840(ra) # 800067c0 <release>
  //printf("cpu id : %d   pa: %p", id, pa);
  pop_off();
    80000098:	00006097          	auipc	ra,0x6
    8000009c:	6c8080e7          	jalr	1736(ra) # 80006760 <pop_off>
}
    800000a0:	70e2                	ld	ra,56(sp)
    800000a2:	7442                	ld	s0,48(sp)
    800000a4:	74a2                	ld	s1,40(sp)
    800000a6:	7902                	ld	s2,32(sp)
    800000a8:	69e2                	ld	s3,24(sp)
    800000aa:	6a42                	ld	s4,16(sp)
    800000ac:	6aa2                	ld	s5,8(sp)
    800000ae:	6121                	addi	sp,sp,64
    800000b0:	8082                	ret
    panic("kfree");
    800000b2:	00008517          	auipc	a0,0x8
    800000b6:	f5e50513          	addi	a0,a0,-162 # 80008010 <etext+0x10>
    800000ba:	00006097          	auipc	ra,0x6
    800000be:	102080e7          	jalr	258(ra) # 800061bc <panic>

00000000800000c2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000c2:	715d                	addi	sp,sp,-80
    800000c4:	e486                	sd	ra,72(sp)
    800000c6:	e0a2                	sd	s0,64(sp)
    800000c8:	fc26                	sd	s1,56(sp)
    800000ca:	f84a                	sd	s2,48(sp)
    800000cc:	f44e                	sd	s3,40(sp)
    800000ce:	f052                	sd	s4,32(sp)
    800000d0:	ec56                	sd	s5,24(sp)
    800000d2:	e85a                	sd	s6,16(sp)
    800000d4:	e45e                	sd	s7,8(sp)
    800000d6:	e062                	sd	s8,0(sp)
    800000d8:	0880                	addi	s0,sp,80
  push_off();
    800000da:	00006097          	auipc	ra,0x6
    800000de:	5ca080e7          	jalr	1482(ra) # 800066a4 <push_off>
  int id = cpuid();
    800000e2:	00001097          	auipc	ra,0x1
    800000e6:	f20080e7          	jalr	-224(ra) # 80001002 <cpuid>
    800000ea:	892a                	mv	s2,a0
  struct run *r , *st_r ;

  acquire(&kmem[id].lock);
    800000ec:	00251793          	slli	a5,a0,0x2
    800000f0:	97aa                	add	a5,a5,a0
    800000f2:	078e                	slli	a5,a5,0x3
    800000f4:	00009a17          	auipc	s4,0x9
    800000f8:	f3ca0a13          	addi	s4,s4,-196 # 80009030 <kmem>
    800000fc:	9a3e                	add	s4,s4,a5
    800000fe:	8552                	mv	a0,s4
    80000100:	00006097          	auipc	ra,0x6
    80000104:	5f0080e7          	jalr	1520(ra) # 800066f0 <acquire>
  r = kmem[id].freelist;
    80000108:	020a3a83          	ld	s5,32(s4)
  if(r)
    8000010c:	040a8363          	beqz	s5,80000152 <kalloc+0x90>
  {
    kmem[id].freelist = r->next;
    80000110:	000ab703          	ld	a4,0(s5)
    80000114:	02ea3023          	sd	a4,32(s4)
        break;
      }
      release(&kmem[st].lock);
    }
  }
  release(&kmem[id].lock);
    80000118:	8552                	mv	a0,s4
    8000011a:	00006097          	auipc	ra,0x6
    8000011e:	6a6080e7          	jalr	1702(ra) # 800067c0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000122:	6605                	lui	a2,0x1
    80000124:	4595                	li	a1,5
    80000126:	8556                	mv	a0,s5
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	226080e7          	jalr	550(ra) # 8000034e <memset>
  pop_off();
    80000130:	00006097          	auipc	ra,0x6
    80000134:	630080e7          	jalr	1584(ra) # 80006760 <pop_off>

  return (void*)r;
}
    80000138:	8556                	mv	a0,s5
    8000013a:	60a6                	ld	ra,72(sp)
    8000013c:	6406                	ld	s0,64(sp)
    8000013e:	74e2                	ld	s1,56(sp)
    80000140:	7942                	ld	s2,48(sp)
    80000142:	79a2                	ld	s3,40(sp)
    80000144:	7a02                	ld	s4,32(sp)
    80000146:	6ae2                	ld	s5,24(sp)
    80000148:	6b42                	ld	s6,16(sp)
    8000014a:	6ba2                	ld	s7,8(sp)
    8000014c:	6c02                	ld	s8,0(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
    80000152:	00009497          	auipc	s1,0x9
    80000156:	ede48493          	addi	s1,s1,-290 # 80009030 <kmem>
    for(int st = 0; st< NCPU; st++)
    8000015a:	4981                	li	s3,0
    8000015c:	4ba1                	li	s7,8
    8000015e:	a0a1                	j	800001a6 <kalloc+0xe4>
        kmem[st].freelist = kmem[id].freelist;
    80000160:	00009697          	auipc	a3,0x9
    80000164:	ed068693          	addi	a3,a3,-304 # 80009030 <kmem>
    80000168:	00291713          	slli	a4,s2,0x2
    8000016c:	012707b3          	add	a5,a4,s2
    80000170:	078e                	slli	a5,a5,0x3
    80000172:	97b6                	add	a5,a5,a3
    80000174:	7390                	ld	a2,32(a5)
    80000176:	00299793          	slli	a5,s3,0x2
    8000017a:	97ce                	add	a5,a5,s3
    8000017c:	078e                	slli	a5,a5,0x3
    8000017e:	97b6                	add	a5,a5,a3
    80000180:	f390                	sd	a2,32(a5)
        kmem[id].freelist = r->next;
    80000182:	000b3783          	ld	a5,0(s6)
    80000186:	974a                	add	a4,a4,s2
    80000188:	070e                	slli	a4,a4,0x3
    8000018a:	9736                	add	a4,a4,a3
    8000018c:	f31c                	sd	a5,32(a4)
        release(&kmem[st].lock);
    8000018e:	8526                	mv	a0,s1
    80000190:	00006097          	auipc	ra,0x6
    80000194:	630080e7          	jalr	1584(ra) # 800067c0 <release>
      st_r = kmem[st].freelist;
    80000198:	8ada                	mv	s5,s6
        break;
    8000019a:	bfbd                	j	80000118 <kalloc+0x56>
    for(int st = 0; st< NCPU; st++)
    8000019c:	2985                	addiw	s3,s3,1
    8000019e:	02848493          	addi	s1,s1,40
    800001a2:	03798363          	beq	s3,s7,800001c8 <kalloc+0x106>
      if(st == id)
    800001a6:	ff390be3          	beq	s2,s3,8000019c <kalloc+0xda>
      acquire(&kmem[st].lock);
    800001aa:	8526                	mv	a0,s1
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	544080e7          	jalr	1348(ra) # 800066f0 <acquire>
      st_r = kmem[st].freelist;
    800001b4:	0204bb03          	ld	s6,32(s1)
      if(st_r)
    800001b8:	fa0b14e3          	bnez	s6,80000160 <kalloc+0x9e>
      release(&kmem[st].lock);
    800001bc:	8526                	mv	a0,s1
    800001be:	00006097          	auipc	ra,0x6
    800001c2:	602080e7          	jalr	1538(ra) # 800067c0 <release>
    800001c6:	bfd9                	j	8000019c <kalloc+0xda>
  release(&kmem[id].lock);
    800001c8:	8552                	mv	a0,s4
    800001ca:	00006097          	auipc	ra,0x6
    800001ce:	5f6080e7          	jalr	1526(ra) # 800067c0 <release>
  if(r)
    800001d2:	bfb9                	j	80000130 <kalloc+0x6e>

00000000800001d4 <kfree_init>:

void
kfree_init(void *pa)
{
    800001d4:	7179                	addi	sp,sp,-48
    800001d6:	f406                	sd	ra,40(sp)
    800001d8:	f022                	sd	s0,32(sp)
    800001da:	ec26                	sd	s1,24(sp)
    800001dc:	e84a                	sd	s2,16(sp)
    800001de:	e44e                	sd	s3,8(sp)
    800001e0:	1800                	addi	s0,sp,48
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800001e2:	03451793          	slli	a5,a0,0x34
    800001e6:	e3d9                	bnez	a5,8000026c <kfree_init+0x98>
    800001e8:	84aa                	mv	s1,a0
    800001ea:	0002b797          	auipc	a5,0x2b
    800001ee:	05e78793          	addi	a5,a5,94 # 8002b248 <end>
    800001f2:	06f56d63          	bltu	a0,a5,8000026c <kfree_init+0x98>
    800001f6:	47c5                	li	a5,17
    800001f8:	07ee                	slli	a5,a5,0x1b
    800001fa:	06f57963          	bgeu	a0,a5,8000026c <kfree_init+0x98>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800001fe:	6605                	lui	a2,0x1
    80000200:	4585                	li	a1,1
    80000202:	00000097          	auipc	ra,0x0
    80000206:	14c080e7          	jalr	332(ra) # 8000034e <memset>

  r = (struct run*)pa;

  acquire(&kmem[id_i].lock);
    8000020a:	00009917          	auipc	s2,0x9
    8000020e:	e2690913          	addi	s2,s2,-474 # 80009030 <kmem>
    80000212:	00009997          	auipc	s3,0x9
    80000216:	dee98993          	addi	s3,s3,-530 # 80009000 <id_i>
    8000021a:	0009a783          	lw	a5,0(s3)
    8000021e:	00279513          	slli	a0,a5,0x2
    80000222:	953e                	add	a0,a0,a5
    80000224:	050e                	slli	a0,a0,0x3
    80000226:	954a                	add	a0,a0,s2
    80000228:	00006097          	auipc	ra,0x6
    8000022c:	4c8080e7          	jalr	1224(ra) # 800066f0 <acquire>
  r->next = kmem[id_i].freelist;
    80000230:	0009a703          	lw	a4,0(s3)
    80000234:	00271793          	slli	a5,a4,0x2
    80000238:	97ba                	add	a5,a5,a4
    8000023a:	078e                	slli	a5,a5,0x3
    8000023c:	97ca                	add	a5,a5,s2
    8000023e:	739c                	ld	a5,32(a5)
    80000240:	e09c                	sd	a5,0(s1)
  kmem[id_i].freelist = r;
    80000242:	0009a703          	lw	a4,0(s3)
    80000246:	00271513          	slli	a0,a4,0x2
    8000024a:	00e507b3          	add	a5,a0,a4
    8000024e:	078e                	slli	a5,a5,0x3
    80000250:	97ca                	add	a5,a5,s2
    80000252:	f384                	sd	s1,32(a5)
  release(&kmem[id_i].lock);
    80000254:	853e                	mv	a0,a5
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	56a080e7          	jalr	1386(ra) # 800067c0 <release>
  //printf("cpu id : %d   pa: %p \n", id_i, pa);

    8000025e:	70a2                	ld	ra,40(sp)
    80000260:	7402                	ld	s0,32(sp)
    80000262:	64e2                	ld	s1,24(sp)
    80000264:	6942                	ld	s2,16(sp)
    80000266:	69a2                	ld	s3,8(sp)
    80000268:	6145                	addi	sp,sp,48
    8000026a:	8082                	ret
    panic("kfree");
    8000026c:	00008517          	auipc	a0,0x8
    80000270:	da450513          	addi	a0,a0,-604 # 80008010 <etext+0x10>
    80000274:	00006097          	auipc	ra,0x6
    80000278:	f48080e7          	jalr	-184(ra) # 800061bc <panic>

000000008000027c <freerange>:
{
    8000027c:	7139                	addi	sp,sp,-64
    8000027e:	fc06                	sd	ra,56(sp)
    80000280:	f822                	sd	s0,48(sp)
    80000282:	f426                	sd	s1,40(sp)
    80000284:	f04a                	sd	s2,32(sp)
    80000286:	ec4e                	sd	s3,24(sp)
    80000288:	e852                	sd	s4,16(sp)
    8000028a:	e456                	sd	s5,8(sp)
    8000028c:	e05a                	sd	s6,0(sp)
    8000028e:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000290:	6785                	lui	a5,0x1
    80000292:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000296:	94aa                	add	s1,s1,a0
    80000298:	757d                	lui	a0,0xfffff
    8000029a:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000029c:	94be                	add	s1,s1,a5
    8000029e:	0495e063          	bltu	a1,s1,800002de <freerange+0x62>
    800002a2:	89ae                	mv	s3,a1
    kfree_init(p);
    800002a4:	7b7d                	lui	s6,0xfffff
    id_i++;
    800002a6:	00009917          	auipc	s2,0x9
    800002aa:	d5a90913          	addi	s2,s2,-678 # 80009000 <id_i>
    if(id_i>= NCPU)
    800002ae:	4a9d                	li	s5,7
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800002b0:	6a05                	lui	s4,0x1
    800002b2:	a031                	j	800002be <freerange+0x42>
      id_i = 0;
    800002b4:	00092023          	sw	zero,0(s2)
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800002b8:	94d2                	add	s1,s1,s4
    800002ba:	0299e263          	bltu	s3,s1,800002de <freerange+0x62>
    kfree_init(p);
    800002be:	01648533          	add	a0,s1,s6
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	f12080e7          	jalr	-238(ra) # 800001d4 <kfree_init>
    id_i++;
    800002ca:	00092783          	lw	a5,0(s2)
    800002ce:	2785                	addiw	a5,a5,1
    800002d0:	0007871b          	sext.w	a4,a5
    if(id_i>= NCPU)
    800002d4:	feeac0e3          	blt	s5,a4,800002b4 <freerange+0x38>
    id_i++;
    800002d8:	00f92023          	sw	a5,0(s2)
    800002dc:	bff1                	j	800002b8 <freerange+0x3c>
}
    800002de:	70e2                	ld	ra,56(sp)
    800002e0:	7442                	ld	s0,48(sp)
    800002e2:	74a2                	ld	s1,40(sp)
    800002e4:	7902                	ld	s2,32(sp)
    800002e6:	69e2                	ld	s3,24(sp)
    800002e8:	6a42                	ld	s4,16(sp)
    800002ea:	6aa2                	ld	s5,8(sp)
    800002ec:	6b02                	ld	s6,0(sp)
    800002ee:	6121                	addi	sp,sp,64
    800002f0:	8082                	ret

00000000800002f2 <kinit>:
{
    800002f2:	7179                	addi	sp,sp,-48
    800002f4:	f406                	sd	ra,40(sp)
    800002f6:	f022                	sd	s0,32(sp)
    800002f8:	ec26                	sd	s1,24(sp)
    800002fa:	e84a                	sd	s2,16(sp)
    800002fc:	e44e                	sd	s3,8(sp)
    800002fe:	1800                	addi	s0,sp,48
  for(int i = 0; i<NCPU; i++)
    80000300:	00009497          	auipc	s1,0x9
    80000304:	d3048493          	addi	s1,s1,-720 # 80009030 <kmem>
    80000308:	00009997          	auipc	s3,0x9
    8000030c:	e6898993          	addi	s3,s3,-408 # 80009170 <pid_lock>
    initlock(&kmem[i].lock, "kmem");
    80000310:	00008917          	auipc	s2,0x8
    80000314:	d0890913          	addi	s2,s2,-760 # 80008018 <etext+0x18>
    80000318:	85ca                	mv	a1,s2
    8000031a:	8526                	mv	a0,s1
    8000031c:	00006097          	auipc	ra,0x6
    80000320:	550080e7          	jalr	1360(ra) # 8000686c <initlock>
  for(int i = 0; i<NCPU; i++)
    80000324:	02848493          	addi	s1,s1,40
    80000328:	ff3498e3          	bne	s1,s3,80000318 <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    8000032c:	45c5                	li	a1,17
    8000032e:	05ee                	slli	a1,a1,0x1b
    80000330:	0002b517          	auipc	a0,0x2b
    80000334:	f1850513          	addi	a0,a0,-232 # 8002b248 <end>
    80000338:	00000097          	auipc	ra,0x0
    8000033c:	f44080e7          	jalr	-188(ra) # 8000027c <freerange>
}
    80000340:	70a2                	ld	ra,40(sp)
    80000342:	7402                	ld	s0,32(sp)
    80000344:	64e2                	ld	s1,24(sp)
    80000346:	6942                	ld	s2,16(sp)
    80000348:	69a2                	ld	s3,8(sp)
    8000034a:	6145                	addi	sp,sp,48
    8000034c:	8082                	ret

000000008000034e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000034e:	1141                	addi	sp,sp,-16
    80000350:	e422                	sd	s0,8(sp)
    80000352:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000354:	ce09                	beqz	a2,8000036e <memset+0x20>
    80000356:	87aa                	mv	a5,a0
    80000358:	fff6071b          	addiw	a4,a2,-1
    8000035c:	1702                	slli	a4,a4,0x20
    8000035e:	9301                	srli	a4,a4,0x20
    80000360:	0705                	addi	a4,a4,1
    80000362:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000364:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000368:	0785                	addi	a5,a5,1
    8000036a:	fee79de3          	bne	a5,a4,80000364 <memset+0x16>
  }
  return dst;
}
    8000036e:	6422                	ld	s0,8(sp)
    80000370:	0141                	addi	sp,sp,16
    80000372:	8082                	ret

0000000080000374 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000374:	1141                	addi	sp,sp,-16
    80000376:	e422                	sd	s0,8(sp)
    80000378:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000037a:	ca05                	beqz	a2,800003aa <memcmp+0x36>
    8000037c:	fff6069b          	addiw	a3,a2,-1
    80000380:	1682                	slli	a3,a3,0x20
    80000382:	9281                	srli	a3,a3,0x20
    80000384:	0685                	addi	a3,a3,1
    80000386:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000388:	00054783          	lbu	a5,0(a0)
    8000038c:	0005c703          	lbu	a4,0(a1)
    80000390:	00e79863          	bne	a5,a4,800003a0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000394:	0505                	addi	a0,a0,1
    80000396:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000398:	fed518e3          	bne	a0,a3,80000388 <memcmp+0x14>
  }

  return 0;
    8000039c:	4501                	li	a0,0
    8000039e:	a019                	j	800003a4 <memcmp+0x30>
      return *s1 - *s2;
    800003a0:	40e7853b          	subw	a0,a5,a4
}
    800003a4:	6422                	ld	s0,8(sp)
    800003a6:	0141                	addi	sp,sp,16
    800003a8:	8082                	ret
  return 0;
    800003aa:	4501                	li	a0,0
    800003ac:	bfe5                	j	800003a4 <memcmp+0x30>

00000000800003ae <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800003ae:	1141                	addi	sp,sp,-16
    800003b0:	e422                	sd	s0,8(sp)
    800003b2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800003b4:	ca0d                	beqz	a2,800003e6 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800003b6:	00a5f963          	bgeu	a1,a0,800003c8 <memmove+0x1a>
    800003ba:	02061693          	slli	a3,a2,0x20
    800003be:	9281                	srli	a3,a3,0x20
    800003c0:	00d58733          	add	a4,a1,a3
    800003c4:	02e56463          	bltu	a0,a4,800003ec <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800003c8:	fff6079b          	addiw	a5,a2,-1
    800003cc:	1782                	slli	a5,a5,0x20
    800003ce:	9381                	srli	a5,a5,0x20
    800003d0:	0785                	addi	a5,a5,1
    800003d2:	97ae                	add	a5,a5,a1
    800003d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800003d6:	0585                	addi	a1,a1,1
    800003d8:	0705                	addi	a4,a4,1
    800003da:	fff5c683          	lbu	a3,-1(a1)
    800003de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800003e2:	fef59ae3          	bne	a1,a5,800003d6 <memmove+0x28>

  return dst;
}
    800003e6:	6422                	ld	s0,8(sp)
    800003e8:	0141                	addi	sp,sp,16
    800003ea:	8082                	ret
    d += n;
    800003ec:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800003ee:	fff6079b          	addiw	a5,a2,-1
    800003f2:	1782                	slli	a5,a5,0x20
    800003f4:	9381                	srli	a5,a5,0x20
    800003f6:	fff7c793          	not	a5,a5
    800003fa:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800003fc:	177d                	addi	a4,a4,-1
    800003fe:	16fd                	addi	a3,a3,-1
    80000400:	00074603          	lbu	a2,0(a4)
    80000404:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000408:	fef71ae3          	bne	a4,a5,800003fc <memmove+0x4e>
    8000040c:	bfe9                	j	800003e6 <memmove+0x38>

000000008000040e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000040e:	1141                	addi	sp,sp,-16
    80000410:	e406                	sd	ra,8(sp)
    80000412:	e022                	sd	s0,0(sp)
    80000414:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000416:	00000097          	auipc	ra,0x0
    8000041a:	f98080e7          	jalr	-104(ra) # 800003ae <memmove>
}
    8000041e:	60a2                	ld	ra,8(sp)
    80000420:	6402                	ld	s0,0(sp)
    80000422:	0141                	addi	sp,sp,16
    80000424:	8082                	ret

0000000080000426 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000426:	1141                	addi	sp,sp,-16
    80000428:	e422                	sd	s0,8(sp)
    8000042a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000042c:	ce11                	beqz	a2,80000448 <strncmp+0x22>
    8000042e:	00054783          	lbu	a5,0(a0)
    80000432:	cf89                	beqz	a5,8000044c <strncmp+0x26>
    80000434:	0005c703          	lbu	a4,0(a1)
    80000438:	00f71a63          	bne	a4,a5,8000044c <strncmp+0x26>
    n--, p++, q++;
    8000043c:	367d                	addiw	a2,a2,-1
    8000043e:	0505                	addi	a0,a0,1
    80000440:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000442:	f675                	bnez	a2,8000042e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000444:	4501                	li	a0,0
    80000446:	a809                	j	80000458 <strncmp+0x32>
    80000448:	4501                	li	a0,0
    8000044a:	a039                	j	80000458 <strncmp+0x32>
  if(n == 0)
    8000044c:	ca09                	beqz	a2,8000045e <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000044e:	00054503          	lbu	a0,0(a0)
    80000452:	0005c783          	lbu	a5,0(a1)
    80000456:	9d1d                	subw	a0,a0,a5
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret
    return 0;
    8000045e:	4501                	li	a0,0
    80000460:	bfe5                	j	80000458 <strncmp+0x32>

0000000080000462 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000462:	1141                	addi	sp,sp,-16
    80000464:	e422                	sd	s0,8(sp)
    80000466:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000468:	872a                	mv	a4,a0
    8000046a:	8832                	mv	a6,a2
    8000046c:	367d                	addiw	a2,a2,-1
    8000046e:	01005963          	blez	a6,80000480 <strncpy+0x1e>
    80000472:	0705                	addi	a4,a4,1
    80000474:	0005c783          	lbu	a5,0(a1)
    80000478:	fef70fa3          	sb	a5,-1(a4)
    8000047c:	0585                	addi	a1,a1,1
    8000047e:	f7f5                	bnez	a5,8000046a <strncpy+0x8>
    ;
  while(n-- > 0)
    80000480:	00c05d63          	blez	a2,8000049a <strncpy+0x38>
    80000484:	86ba                	mv	a3,a4
    *s++ = 0;
    80000486:	0685                	addi	a3,a3,1
    80000488:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    8000048c:	fff6c793          	not	a5,a3
    80000490:	9fb9                	addw	a5,a5,a4
    80000492:	010787bb          	addw	a5,a5,a6
    80000496:	fef048e3          	bgtz	a5,80000486 <strncpy+0x24>
  return os;
}
    8000049a:	6422                	ld	s0,8(sp)
    8000049c:	0141                	addi	sp,sp,16
    8000049e:	8082                	ret

00000000800004a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800004a0:	1141                	addi	sp,sp,-16
    800004a2:	e422                	sd	s0,8(sp)
    800004a4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800004a6:	02c05363          	blez	a2,800004cc <safestrcpy+0x2c>
    800004aa:	fff6069b          	addiw	a3,a2,-1
    800004ae:	1682                	slli	a3,a3,0x20
    800004b0:	9281                	srli	a3,a3,0x20
    800004b2:	96ae                	add	a3,a3,a1
    800004b4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800004b6:	00d58963          	beq	a1,a3,800004c8 <safestrcpy+0x28>
    800004ba:	0585                	addi	a1,a1,1
    800004bc:	0785                	addi	a5,a5,1
    800004be:	fff5c703          	lbu	a4,-1(a1)
    800004c2:	fee78fa3          	sb	a4,-1(a5)
    800004c6:	fb65                	bnez	a4,800004b6 <safestrcpy+0x16>
    ;
  *s = 0;
    800004c8:	00078023          	sb	zero,0(a5)
  return os;
}
    800004cc:	6422                	ld	s0,8(sp)
    800004ce:	0141                	addi	sp,sp,16
    800004d0:	8082                	ret

00000000800004d2 <strlen>:

int
strlen(const char *s)
{
    800004d2:	1141                	addi	sp,sp,-16
    800004d4:	e422                	sd	s0,8(sp)
    800004d6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800004d8:	00054783          	lbu	a5,0(a0)
    800004dc:	cf91                	beqz	a5,800004f8 <strlen+0x26>
    800004de:	0505                	addi	a0,a0,1
    800004e0:	87aa                	mv	a5,a0
    800004e2:	4685                	li	a3,1
    800004e4:	9e89                	subw	a3,a3,a0
    800004e6:	00f6853b          	addw	a0,a3,a5
    800004ea:	0785                	addi	a5,a5,1
    800004ec:	fff7c703          	lbu	a4,-1(a5)
    800004f0:	fb7d                	bnez	a4,800004e6 <strlen+0x14>
    ;
  return n;
}
    800004f2:	6422                	ld	s0,8(sp)
    800004f4:	0141                	addi	sp,sp,16
    800004f6:	8082                	ret
  for(n = 0; s[n]; n++)
    800004f8:	4501                	li	a0,0
    800004fa:	bfe5                	j	800004f2 <strlen+0x20>

00000000800004fc <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800004fc:	1101                	addi	sp,sp,-32
    800004fe:	ec06                	sd	ra,24(sp)
    80000500:	e822                	sd	s0,16(sp)
    80000502:	e426                	sd	s1,8(sp)
    80000504:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80000506:	00001097          	auipc	ra,0x1
    8000050a:	afc080e7          	jalr	-1284(ra) # 80001002 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(lockfree_read4((int *) &started) == 0)
    8000050e:	00009497          	auipc	s1,0x9
    80000512:	af648493          	addi	s1,s1,-1290 # 80009004 <started>
  if(cpuid() == 0){
    80000516:	c531                	beqz	a0,80000562 <main+0x66>
    while(lockfree_read4((int *) &started) == 0)
    80000518:	8526                	mv	a0,s1
    8000051a:	00006097          	auipc	ra,0x6
    8000051e:	3e8080e7          	jalr	1000(ra) # 80006902 <lockfree_read4>
    80000522:	d97d                	beqz	a0,80000518 <main+0x1c>
      ;
    __sync_synchronize();
    80000524:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000528:	00001097          	auipc	ra,0x1
    8000052c:	ada080e7          	jalr	-1318(ra) # 80001002 <cpuid>
    80000530:	85aa                	mv	a1,a0
    80000532:	00008517          	auipc	a0,0x8
    80000536:	b0650513          	addi	a0,a0,-1274 # 80008038 <etext+0x38>
    8000053a:	00006097          	auipc	ra,0x6
    8000053e:	ccc080e7          	jalr	-820(ra) # 80006206 <printf>
    kvminithart();    // turn on paging
    80000542:	00000097          	auipc	ra,0x0
    80000546:	0e0080e7          	jalr	224(ra) # 80000622 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000054a:	00001097          	auipc	ra,0x1
    8000054e:	730080e7          	jalr	1840(ra) # 80001c7a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000552:	00005097          	auipc	ra,0x5
    80000556:	e0e080e7          	jalr	-498(ra) # 80005360 <plicinithart>
  }

  scheduler();        
    8000055a:	00001097          	auipc	ra,0x1
    8000055e:	fde080e7          	jalr	-34(ra) # 80001538 <scheduler>
    consoleinit();
    80000562:	00006097          	auipc	ra,0x6
    80000566:	b6c080e7          	jalr	-1172(ra) # 800060ce <consoleinit>
    statsinit();
    8000056a:	00005097          	auipc	ra,0x5
    8000056e:	4dc080e7          	jalr	1244(ra) # 80005a46 <statsinit>
    printfinit();
    80000572:	00006097          	auipc	ra,0x6
    80000576:	e7a080e7          	jalr	-390(ra) # 800063ec <printfinit>
    printf("\n");
    8000057a:	00008517          	auipc	a0,0x8
    8000057e:	2ee50513          	addi	a0,a0,750 # 80008868 <digits+0x88>
    80000582:	00006097          	auipc	ra,0x6
    80000586:	c84080e7          	jalr	-892(ra) # 80006206 <printf>
    printf("xv6 kernel is booting\n");
    8000058a:	00008517          	auipc	a0,0x8
    8000058e:	a9650513          	addi	a0,a0,-1386 # 80008020 <etext+0x20>
    80000592:	00006097          	auipc	ra,0x6
    80000596:	c74080e7          	jalr	-908(ra) # 80006206 <printf>
    printf("\n");
    8000059a:	00008517          	auipc	a0,0x8
    8000059e:	2ce50513          	addi	a0,a0,718 # 80008868 <digits+0x88>
    800005a2:	00006097          	auipc	ra,0x6
    800005a6:	c64080e7          	jalr	-924(ra) # 80006206 <printf>
    kinit();         // physical page allocator
    800005aa:	00000097          	auipc	ra,0x0
    800005ae:	d48080e7          	jalr	-696(ra) # 800002f2 <kinit>
    kvminit();       // create kernel page table
    800005b2:	00000097          	auipc	ra,0x0
    800005b6:	322080e7          	jalr	802(ra) # 800008d4 <kvminit>
    kvminithart();   // turn on paging
    800005ba:	00000097          	auipc	ra,0x0
    800005be:	068080e7          	jalr	104(ra) # 80000622 <kvminithart>
    procinit();      // process table
    800005c2:	00001097          	auipc	ra,0x1
    800005c6:	990080e7          	jalr	-1648(ra) # 80000f52 <procinit>
    trapinit();      // trap vectors
    800005ca:	00001097          	auipc	ra,0x1
    800005ce:	688080e7          	jalr	1672(ra) # 80001c52 <trapinit>
    trapinithart();  // install kernel trap vector
    800005d2:	00001097          	auipc	ra,0x1
    800005d6:	6a8080e7          	jalr	1704(ra) # 80001c7a <trapinithart>
    plicinit();      // set up interrupt controller
    800005da:	00005097          	auipc	ra,0x5
    800005de:	d70080e7          	jalr	-656(ra) # 8000534a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800005e2:	00005097          	auipc	ra,0x5
    800005e6:	d7e080e7          	jalr	-642(ra) # 80005360 <plicinithart>
    binit();         // buffer cache
    800005ea:	00002097          	auipc	ra,0x2
    800005ee:	dd2080e7          	jalr	-558(ra) # 800023bc <binit>
    iinit();         // inode table
    800005f2:	00002097          	auipc	ra,0x2
    800005f6:	5e0080e7          	jalr	1504(ra) # 80002bd2 <iinit>
    fileinit();      // file table
    800005fa:	00003097          	auipc	ra,0x3
    800005fe:	58a080e7          	jalr	1418(ra) # 80003b84 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000602:	00005097          	auipc	ra,0x5
    80000606:	e80080e7          	jalr	-384(ra) # 80005482 <virtio_disk_init>
    userinit();      // first user process
    8000060a:	00001097          	auipc	ra,0x1
    8000060e:	cfc080e7          	jalr	-772(ra) # 80001306 <userinit>
    __sync_synchronize();
    80000612:	0ff0000f          	fence
    started = 1;
    80000616:	4785                	li	a5,1
    80000618:	00009717          	auipc	a4,0x9
    8000061c:	9ef72623          	sw	a5,-1556(a4) # 80009004 <started>
    80000620:	bf2d                	j	8000055a <main+0x5e>

0000000080000622 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000622:	1141                	addi	sp,sp,-16
    80000624:	e422                	sd	s0,8(sp)
    80000626:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000628:	00009797          	auipc	a5,0x9
    8000062c:	9e07b783          	ld	a5,-1568(a5) # 80009008 <kernel_pagetable>
    80000630:	83b1                	srli	a5,a5,0xc
    80000632:	577d                	li	a4,-1
    80000634:	177e                	slli	a4,a4,0x3f
    80000636:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000638:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000063c:	12000073          	sfence.vma
  sfence_vma();
}
    80000640:	6422                	ld	s0,8(sp)
    80000642:	0141                	addi	sp,sp,16
    80000644:	8082                	ret

0000000080000646 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000646:	7139                	addi	sp,sp,-64
    80000648:	fc06                	sd	ra,56(sp)
    8000064a:	f822                	sd	s0,48(sp)
    8000064c:	f426                	sd	s1,40(sp)
    8000064e:	f04a                	sd	s2,32(sp)
    80000650:	ec4e                	sd	s3,24(sp)
    80000652:	e852                	sd	s4,16(sp)
    80000654:	e456                	sd	s5,8(sp)
    80000656:	e05a                	sd	s6,0(sp)
    80000658:	0080                	addi	s0,sp,64
    8000065a:	84aa                	mv	s1,a0
    8000065c:	89ae                	mv	s3,a1
    8000065e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000660:	57fd                	li	a5,-1
    80000662:	83e9                	srli	a5,a5,0x1a
    80000664:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000666:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000668:	04b7f263          	bgeu	a5,a1,800006ac <walk+0x66>
    panic("walk");
    8000066c:	00008517          	auipc	a0,0x8
    80000670:	9e450513          	addi	a0,a0,-1564 # 80008050 <etext+0x50>
    80000674:	00006097          	auipc	ra,0x6
    80000678:	b48080e7          	jalr	-1208(ra) # 800061bc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000067c:	060a8663          	beqz	s5,800006e8 <walk+0xa2>
    80000680:	00000097          	auipc	ra,0x0
    80000684:	a42080e7          	jalr	-1470(ra) # 800000c2 <kalloc>
    80000688:	84aa                	mv	s1,a0
    8000068a:	c529                	beqz	a0,800006d4 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000068c:	6605                	lui	a2,0x1
    8000068e:	4581                	li	a1,0
    80000690:	00000097          	auipc	ra,0x0
    80000694:	cbe080e7          	jalr	-834(ra) # 8000034e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000698:	00c4d793          	srli	a5,s1,0xc
    8000069c:	07aa                	slli	a5,a5,0xa
    8000069e:	0017e793          	ori	a5,a5,1
    800006a2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800006a6:	3a5d                	addiw	s4,s4,-9
    800006a8:	036a0063          	beq	s4,s6,800006c8 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800006ac:	0149d933          	srl	s2,s3,s4
    800006b0:	1ff97913          	andi	s2,s2,511
    800006b4:	090e                	slli	s2,s2,0x3
    800006b6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800006b8:	00093483          	ld	s1,0(s2)
    800006bc:	0014f793          	andi	a5,s1,1
    800006c0:	dfd5                	beqz	a5,8000067c <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800006c2:	80a9                	srli	s1,s1,0xa
    800006c4:	04b2                	slli	s1,s1,0xc
    800006c6:	b7c5                	j	800006a6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800006c8:	00c9d513          	srli	a0,s3,0xc
    800006cc:	1ff57513          	andi	a0,a0,511
    800006d0:	050e                	slli	a0,a0,0x3
    800006d2:	9526                	add	a0,a0,s1
}
    800006d4:	70e2                	ld	ra,56(sp)
    800006d6:	7442                	ld	s0,48(sp)
    800006d8:	74a2                	ld	s1,40(sp)
    800006da:	7902                	ld	s2,32(sp)
    800006dc:	69e2                	ld	s3,24(sp)
    800006de:	6a42                	ld	s4,16(sp)
    800006e0:	6aa2                	ld	s5,8(sp)
    800006e2:	6b02                	ld	s6,0(sp)
    800006e4:	6121                	addi	sp,sp,64
    800006e6:	8082                	ret
        return 0;
    800006e8:	4501                	li	a0,0
    800006ea:	b7ed                	j	800006d4 <walk+0x8e>

00000000800006ec <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800006ec:	57fd                	li	a5,-1
    800006ee:	83e9                	srli	a5,a5,0x1a
    800006f0:	00b7f463          	bgeu	a5,a1,800006f8 <walkaddr+0xc>
    return 0;
    800006f4:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800006f6:	8082                	ret
{
    800006f8:	1141                	addi	sp,sp,-16
    800006fa:	e406                	sd	ra,8(sp)
    800006fc:	e022                	sd	s0,0(sp)
    800006fe:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000700:	4601                	li	a2,0
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f44080e7          	jalr	-188(ra) # 80000646 <walk>
  if(pte == 0)
    8000070a:	c105                	beqz	a0,8000072a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000070c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000070e:	0117f693          	andi	a3,a5,17
    80000712:	4745                	li	a4,17
    return 0;
    80000714:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000716:	00e68663          	beq	a3,a4,80000722 <walkaddr+0x36>
}
    8000071a:	60a2                	ld	ra,8(sp)
    8000071c:	6402                	ld	s0,0(sp)
    8000071e:	0141                	addi	sp,sp,16
    80000720:	8082                	ret
  pa = PTE2PA(*pte);
    80000722:	00a7d513          	srli	a0,a5,0xa
    80000726:	0532                	slli	a0,a0,0xc
  return pa;
    80000728:	bfcd                	j	8000071a <walkaddr+0x2e>
    return 0;
    8000072a:	4501                	li	a0,0
    8000072c:	b7fd                	j	8000071a <walkaddr+0x2e>

000000008000072e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000072e:	715d                	addi	sp,sp,-80
    80000730:	e486                	sd	ra,72(sp)
    80000732:	e0a2                	sd	s0,64(sp)
    80000734:	fc26                	sd	s1,56(sp)
    80000736:	f84a                	sd	s2,48(sp)
    80000738:	f44e                	sd	s3,40(sp)
    8000073a:	f052                	sd	s4,32(sp)
    8000073c:	ec56                	sd	s5,24(sp)
    8000073e:	e85a                	sd	s6,16(sp)
    80000740:	e45e                	sd	s7,8(sp)
    80000742:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000744:	c205                	beqz	a2,80000764 <mappages+0x36>
    80000746:	8aaa                	mv	s5,a0
    80000748:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000074a:	77fd                	lui	a5,0xfffff
    8000074c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000750:	15fd                	addi	a1,a1,-1
    80000752:	00c589b3          	add	s3,a1,a2
    80000756:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000075a:	8952                	mv	s2,s4
    8000075c:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000760:	6b85                	lui	s7,0x1
    80000762:	a015                	j	80000786 <mappages+0x58>
    panic("mappages: size");
    80000764:	00008517          	auipc	a0,0x8
    80000768:	8f450513          	addi	a0,a0,-1804 # 80008058 <etext+0x58>
    8000076c:	00006097          	auipc	ra,0x6
    80000770:	a50080e7          	jalr	-1456(ra) # 800061bc <panic>
      panic("mappages: remap");
    80000774:	00008517          	auipc	a0,0x8
    80000778:	8f450513          	addi	a0,a0,-1804 # 80008068 <etext+0x68>
    8000077c:	00006097          	auipc	ra,0x6
    80000780:	a40080e7          	jalr	-1472(ra) # 800061bc <panic>
    a += PGSIZE;
    80000784:	995e                	add	s2,s2,s7
  for(;;){
    80000786:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000078a:	4605                	li	a2,1
    8000078c:	85ca                	mv	a1,s2
    8000078e:	8556                	mv	a0,s5
    80000790:	00000097          	auipc	ra,0x0
    80000794:	eb6080e7          	jalr	-330(ra) # 80000646 <walk>
    80000798:	cd19                	beqz	a0,800007b6 <mappages+0x88>
    if(*pte & PTE_V)
    8000079a:	611c                	ld	a5,0(a0)
    8000079c:	8b85                	andi	a5,a5,1
    8000079e:	fbf9                	bnez	a5,80000774 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800007a0:	80b1                	srli	s1,s1,0xc
    800007a2:	04aa                	slli	s1,s1,0xa
    800007a4:	0164e4b3          	or	s1,s1,s6
    800007a8:	0014e493          	ori	s1,s1,1
    800007ac:	e104                	sd	s1,0(a0)
    if(a == last)
    800007ae:	fd391be3          	bne	s2,s3,80000784 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800007b2:	4501                	li	a0,0
    800007b4:	a011                	j	800007b8 <mappages+0x8a>
      return -1;
    800007b6:	557d                	li	a0,-1
}
    800007b8:	60a6                	ld	ra,72(sp)
    800007ba:	6406                	ld	s0,64(sp)
    800007bc:	74e2                	ld	s1,56(sp)
    800007be:	7942                	ld	s2,48(sp)
    800007c0:	79a2                	ld	s3,40(sp)
    800007c2:	7a02                	ld	s4,32(sp)
    800007c4:	6ae2                	ld	s5,24(sp)
    800007c6:	6b42                	ld	s6,16(sp)
    800007c8:	6ba2                	ld	s7,8(sp)
    800007ca:	6161                	addi	sp,sp,80
    800007cc:	8082                	ret

00000000800007ce <kvmmap>:
{
    800007ce:	1141                	addi	sp,sp,-16
    800007d0:	e406                	sd	ra,8(sp)
    800007d2:	e022                	sd	s0,0(sp)
    800007d4:	0800                	addi	s0,sp,16
    800007d6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800007d8:	86b2                	mv	a3,a2
    800007da:	863e                	mv	a2,a5
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	f52080e7          	jalr	-174(ra) # 8000072e <mappages>
    800007e4:	e509                	bnez	a0,800007ee <kvmmap+0x20>
}
    800007e6:	60a2                	ld	ra,8(sp)
    800007e8:	6402                	ld	s0,0(sp)
    800007ea:	0141                	addi	sp,sp,16
    800007ec:	8082                	ret
    panic("kvmmap");
    800007ee:	00008517          	auipc	a0,0x8
    800007f2:	88a50513          	addi	a0,a0,-1910 # 80008078 <etext+0x78>
    800007f6:	00006097          	auipc	ra,0x6
    800007fa:	9c6080e7          	jalr	-1594(ra) # 800061bc <panic>

00000000800007fe <kvmmake>:
{
    800007fe:	1101                	addi	sp,sp,-32
    80000800:	ec06                	sd	ra,24(sp)
    80000802:	e822                	sd	s0,16(sp)
    80000804:	e426                	sd	s1,8(sp)
    80000806:	e04a                	sd	s2,0(sp)
    80000808:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000080a:	00000097          	auipc	ra,0x0
    8000080e:	8b8080e7          	jalr	-1864(ra) # 800000c2 <kalloc>
    80000812:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000814:	6605                	lui	a2,0x1
    80000816:	4581                	li	a1,0
    80000818:	00000097          	auipc	ra,0x0
    8000081c:	b36080e7          	jalr	-1226(ra) # 8000034e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000820:	4719                	li	a4,6
    80000822:	6685                	lui	a3,0x1
    80000824:	10000637          	lui	a2,0x10000
    80000828:	100005b7          	lui	a1,0x10000
    8000082c:	8526                	mv	a0,s1
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	fa0080e7          	jalr	-96(ra) # 800007ce <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000836:	4719                	li	a4,6
    80000838:	6685                	lui	a3,0x1
    8000083a:	10001637          	lui	a2,0x10001
    8000083e:	100015b7          	lui	a1,0x10001
    80000842:	8526                	mv	a0,s1
    80000844:	00000097          	auipc	ra,0x0
    80000848:	f8a080e7          	jalr	-118(ra) # 800007ce <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000084c:	4719                	li	a4,6
    8000084e:	004006b7          	lui	a3,0x400
    80000852:	0c000637          	lui	a2,0xc000
    80000856:	0c0005b7          	lui	a1,0xc000
    8000085a:	8526                	mv	a0,s1
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	f72080e7          	jalr	-142(ra) # 800007ce <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000864:	00007917          	auipc	s2,0x7
    80000868:	79c90913          	addi	s2,s2,1948 # 80008000 <etext>
    8000086c:	4729                	li	a4,10
    8000086e:	80007697          	auipc	a3,0x80007
    80000872:	79268693          	addi	a3,a3,1938 # 8000 <_entry-0x7fff8000>
    80000876:	4605                	li	a2,1
    80000878:	067e                	slli	a2,a2,0x1f
    8000087a:	85b2                	mv	a1,a2
    8000087c:	8526                	mv	a0,s1
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	f50080e7          	jalr	-176(ra) # 800007ce <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000886:	4719                	li	a4,6
    80000888:	46c5                	li	a3,17
    8000088a:	06ee                	slli	a3,a3,0x1b
    8000088c:	412686b3          	sub	a3,a3,s2
    80000890:	864a                	mv	a2,s2
    80000892:	85ca                	mv	a1,s2
    80000894:	8526                	mv	a0,s1
    80000896:	00000097          	auipc	ra,0x0
    8000089a:	f38080e7          	jalr	-200(ra) # 800007ce <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000089e:	4729                	li	a4,10
    800008a0:	6685                	lui	a3,0x1
    800008a2:	00006617          	auipc	a2,0x6
    800008a6:	75e60613          	addi	a2,a2,1886 # 80007000 <_trampoline>
    800008aa:	040005b7          	lui	a1,0x4000
    800008ae:	15fd                	addi	a1,a1,-1
    800008b0:	05b2                	slli	a1,a1,0xc
    800008b2:	8526                	mv	a0,s1
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	f1a080e7          	jalr	-230(ra) # 800007ce <kvmmap>
  proc_mapstacks(kpgtbl);
    800008bc:	8526                	mv	a0,s1
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	5fe080e7          	jalr	1534(ra) # 80000ebc <proc_mapstacks>
}
    800008c6:	8526                	mv	a0,s1
    800008c8:	60e2                	ld	ra,24(sp)
    800008ca:	6442                	ld	s0,16(sp)
    800008cc:	64a2                	ld	s1,8(sp)
    800008ce:	6902                	ld	s2,0(sp)
    800008d0:	6105                	addi	sp,sp,32
    800008d2:	8082                	ret

00000000800008d4 <kvminit>:
{
    800008d4:	1141                	addi	sp,sp,-16
    800008d6:	e406                	sd	ra,8(sp)
    800008d8:	e022                	sd	s0,0(sp)
    800008da:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800008dc:	00000097          	auipc	ra,0x0
    800008e0:	f22080e7          	jalr	-222(ra) # 800007fe <kvmmake>
    800008e4:	00008797          	auipc	a5,0x8
    800008e8:	72a7b223          	sd	a0,1828(a5) # 80009008 <kernel_pagetable>
}
    800008ec:	60a2                	ld	ra,8(sp)
    800008ee:	6402                	ld	s0,0(sp)
    800008f0:	0141                	addi	sp,sp,16
    800008f2:	8082                	ret

00000000800008f4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800008f4:	715d                	addi	sp,sp,-80
    800008f6:	e486                	sd	ra,72(sp)
    800008f8:	e0a2                	sd	s0,64(sp)
    800008fa:	fc26                	sd	s1,56(sp)
    800008fc:	f84a                	sd	s2,48(sp)
    800008fe:	f44e                	sd	s3,40(sp)
    80000900:	f052                	sd	s4,32(sp)
    80000902:	ec56                	sd	s5,24(sp)
    80000904:	e85a                	sd	s6,16(sp)
    80000906:	e45e                	sd	s7,8(sp)
    80000908:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000090a:	03459793          	slli	a5,a1,0x34
    8000090e:	e795                	bnez	a5,8000093a <uvmunmap+0x46>
    80000910:	8a2a                	mv	s4,a0
    80000912:	892e                	mv	s2,a1
    80000914:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000916:	0632                	slli	a2,a2,0xc
    80000918:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000091c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000091e:	6b05                	lui	s6,0x1
    80000920:	0735e863          	bltu	a1,s3,80000990 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000924:	60a6                	ld	ra,72(sp)
    80000926:	6406                	ld	s0,64(sp)
    80000928:	74e2                	ld	s1,56(sp)
    8000092a:	7942                	ld	s2,48(sp)
    8000092c:	79a2                	ld	s3,40(sp)
    8000092e:	7a02                	ld	s4,32(sp)
    80000930:	6ae2                	ld	s5,24(sp)
    80000932:	6b42                	ld	s6,16(sp)
    80000934:	6ba2                	ld	s7,8(sp)
    80000936:	6161                	addi	sp,sp,80
    80000938:	8082                	ret
    panic("uvmunmap: not aligned");
    8000093a:	00007517          	auipc	a0,0x7
    8000093e:	74650513          	addi	a0,a0,1862 # 80008080 <etext+0x80>
    80000942:	00006097          	auipc	ra,0x6
    80000946:	87a080e7          	jalr	-1926(ra) # 800061bc <panic>
      panic("uvmunmap: walk");
    8000094a:	00007517          	auipc	a0,0x7
    8000094e:	74e50513          	addi	a0,a0,1870 # 80008098 <etext+0x98>
    80000952:	00006097          	auipc	ra,0x6
    80000956:	86a080e7          	jalr	-1942(ra) # 800061bc <panic>
      panic("uvmunmap: not mapped");
    8000095a:	00007517          	auipc	a0,0x7
    8000095e:	74e50513          	addi	a0,a0,1870 # 800080a8 <etext+0xa8>
    80000962:	00006097          	auipc	ra,0x6
    80000966:	85a080e7          	jalr	-1958(ra) # 800061bc <panic>
      panic("uvmunmap: not a leaf");
    8000096a:	00007517          	auipc	a0,0x7
    8000096e:	75650513          	addi	a0,a0,1878 # 800080c0 <etext+0xc0>
    80000972:	00006097          	auipc	ra,0x6
    80000976:	84a080e7          	jalr	-1974(ra) # 800061bc <panic>
      uint64 pa = PTE2PA(*pte);
    8000097a:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000097c:	0532                	slli	a0,a0,0xc
    8000097e:	fffff097          	auipc	ra,0xfffff
    80000982:	69e080e7          	jalr	1694(ra) # 8000001c <kfree>
    *pte = 0;
    80000986:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000098a:	995a                	add	s2,s2,s6
    8000098c:	f9397ce3          	bgeu	s2,s3,80000924 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000990:	4601                	li	a2,0
    80000992:	85ca                	mv	a1,s2
    80000994:	8552                	mv	a0,s4
    80000996:	00000097          	auipc	ra,0x0
    8000099a:	cb0080e7          	jalr	-848(ra) # 80000646 <walk>
    8000099e:	84aa                	mv	s1,a0
    800009a0:	d54d                	beqz	a0,8000094a <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800009a2:	6108                	ld	a0,0(a0)
    800009a4:	00157793          	andi	a5,a0,1
    800009a8:	dbcd                	beqz	a5,8000095a <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800009aa:	3ff57793          	andi	a5,a0,1023
    800009ae:	fb778ee3          	beq	a5,s7,8000096a <uvmunmap+0x76>
    if(do_free){
    800009b2:	fc0a8ae3          	beqz	s5,80000986 <uvmunmap+0x92>
    800009b6:	b7d1                	j	8000097a <uvmunmap+0x86>

00000000800009b8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800009b8:	1101                	addi	sp,sp,-32
    800009ba:	ec06                	sd	ra,24(sp)
    800009bc:	e822                	sd	s0,16(sp)
    800009be:	e426                	sd	s1,8(sp)
    800009c0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	700080e7          	jalr	1792(ra) # 800000c2 <kalloc>
    800009ca:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800009cc:	c519                	beqz	a0,800009da <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800009ce:	6605                	lui	a2,0x1
    800009d0:	4581                	li	a1,0
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	97c080e7          	jalr	-1668(ra) # 8000034e <memset>
  return pagetable;
}
    800009da:	8526                	mv	a0,s1
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6105                	addi	sp,sp,32
    800009e4:	8082                	ret

00000000800009e6 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800009e6:	7179                	addi	sp,sp,-48
    800009e8:	f406                	sd	ra,40(sp)
    800009ea:	f022                	sd	s0,32(sp)
    800009ec:	ec26                	sd	s1,24(sp)
    800009ee:	e84a                	sd	s2,16(sp)
    800009f0:	e44e                	sd	s3,8(sp)
    800009f2:	e052                	sd	s4,0(sp)
    800009f4:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800009f6:	6785                	lui	a5,0x1
    800009f8:	04f67863          	bgeu	a2,a5,80000a48 <uvminit+0x62>
    800009fc:	8a2a                	mv	s4,a0
    800009fe:	89ae                	mv	s3,a1
    80000a00:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000a02:	fffff097          	auipc	ra,0xfffff
    80000a06:	6c0080e7          	jalr	1728(ra) # 800000c2 <kalloc>
    80000a0a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000a0c:	6605                	lui	a2,0x1
    80000a0e:	4581                	li	a1,0
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	93e080e7          	jalr	-1730(ra) # 8000034e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000a18:	4779                	li	a4,30
    80000a1a:	86ca                	mv	a3,s2
    80000a1c:	6605                	lui	a2,0x1
    80000a1e:	4581                	li	a1,0
    80000a20:	8552                	mv	a0,s4
    80000a22:	00000097          	auipc	ra,0x0
    80000a26:	d0c080e7          	jalr	-756(ra) # 8000072e <mappages>
  memmove(mem, src, sz);
    80000a2a:	8626                	mv	a2,s1
    80000a2c:	85ce                	mv	a1,s3
    80000a2e:	854a                	mv	a0,s2
    80000a30:	00000097          	auipc	ra,0x0
    80000a34:	97e080e7          	jalr	-1666(ra) # 800003ae <memmove>
}
    80000a38:	70a2                	ld	ra,40(sp)
    80000a3a:	7402                	ld	s0,32(sp)
    80000a3c:	64e2                	ld	s1,24(sp)
    80000a3e:	6942                	ld	s2,16(sp)
    80000a40:	69a2                	ld	s3,8(sp)
    80000a42:	6a02                	ld	s4,0(sp)
    80000a44:	6145                	addi	sp,sp,48
    80000a46:	8082                	ret
    panic("inituvm: more than a page");
    80000a48:	00007517          	auipc	a0,0x7
    80000a4c:	69050513          	addi	a0,a0,1680 # 800080d8 <etext+0xd8>
    80000a50:	00005097          	auipc	ra,0x5
    80000a54:	76c080e7          	jalr	1900(ra) # 800061bc <panic>

0000000080000a58 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000a58:	1101                	addi	sp,sp,-32
    80000a5a:	ec06                	sd	ra,24(sp)
    80000a5c:	e822                	sd	s0,16(sp)
    80000a5e:	e426                	sd	s1,8(sp)
    80000a60:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000a62:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000a64:	00b67d63          	bgeu	a2,a1,80000a7e <uvmdealloc+0x26>
    80000a68:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000a6a:	6785                	lui	a5,0x1
    80000a6c:	17fd                	addi	a5,a5,-1
    80000a6e:	00f60733          	add	a4,a2,a5
    80000a72:	767d                	lui	a2,0xfffff
    80000a74:	8f71                	and	a4,a4,a2
    80000a76:	97ae                	add	a5,a5,a1
    80000a78:	8ff1                	and	a5,a5,a2
    80000a7a:	00f76863          	bltu	a4,a5,80000a8a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000a7e:	8526                	mv	a0,s1
    80000a80:	60e2                	ld	ra,24(sp)
    80000a82:	6442                	ld	s0,16(sp)
    80000a84:	64a2                	ld	s1,8(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a8a:	8f99                	sub	a5,a5,a4
    80000a8c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a8e:	4685                	li	a3,1
    80000a90:	0007861b          	sext.w	a2,a5
    80000a94:	85ba                	mv	a1,a4
    80000a96:	00000097          	auipc	ra,0x0
    80000a9a:	e5e080e7          	jalr	-418(ra) # 800008f4 <uvmunmap>
    80000a9e:	b7c5                	j	80000a7e <uvmdealloc+0x26>

0000000080000aa0 <uvmalloc>:
  if(newsz < oldsz)
    80000aa0:	0ab66163          	bltu	a2,a1,80000b42 <uvmalloc+0xa2>
{
    80000aa4:	7139                	addi	sp,sp,-64
    80000aa6:	fc06                	sd	ra,56(sp)
    80000aa8:	f822                	sd	s0,48(sp)
    80000aaa:	f426                	sd	s1,40(sp)
    80000aac:	f04a                	sd	s2,32(sp)
    80000aae:	ec4e                	sd	s3,24(sp)
    80000ab0:	e852                	sd	s4,16(sp)
    80000ab2:	e456                	sd	s5,8(sp)
    80000ab4:	0080                	addi	s0,sp,64
    80000ab6:	8aaa                	mv	s5,a0
    80000ab8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000aba:	6985                	lui	s3,0x1
    80000abc:	19fd                	addi	s3,s3,-1
    80000abe:	95ce                	add	a1,a1,s3
    80000ac0:	79fd                	lui	s3,0xfffff
    80000ac2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000ac6:	08c9f063          	bgeu	s3,a2,80000b46 <uvmalloc+0xa6>
    80000aca:	894e                	mv	s2,s3
    mem = kalloc();
    80000acc:	fffff097          	auipc	ra,0xfffff
    80000ad0:	5f6080e7          	jalr	1526(ra) # 800000c2 <kalloc>
    80000ad4:	84aa                	mv	s1,a0
    if(mem == 0){
    80000ad6:	c51d                	beqz	a0,80000b04 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000ad8:	6605                	lui	a2,0x1
    80000ada:	4581                	li	a1,0
    80000adc:	00000097          	auipc	ra,0x0
    80000ae0:	872080e7          	jalr	-1934(ra) # 8000034e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000ae4:	4779                	li	a4,30
    80000ae6:	86a6                	mv	a3,s1
    80000ae8:	6605                	lui	a2,0x1
    80000aea:	85ca                	mv	a1,s2
    80000aec:	8556                	mv	a0,s5
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	c40080e7          	jalr	-960(ra) # 8000072e <mappages>
    80000af6:	e905                	bnez	a0,80000b26 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000af8:	6785                	lui	a5,0x1
    80000afa:	993e                	add	s2,s2,a5
    80000afc:	fd4968e3          	bltu	s2,s4,80000acc <uvmalloc+0x2c>
  return newsz;
    80000b00:	8552                	mv	a0,s4
    80000b02:	a809                	j	80000b14 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000b04:	864e                	mv	a2,s3
    80000b06:	85ca                	mv	a1,s2
    80000b08:	8556                	mv	a0,s5
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	f4e080e7          	jalr	-178(ra) # 80000a58 <uvmdealloc>
      return 0;
    80000b12:	4501                	li	a0,0
}
    80000b14:	70e2                	ld	ra,56(sp)
    80000b16:	7442                	ld	s0,48(sp)
    80000b18:	74a2                	ld	s1,40(sp)
    80000b1a:	7902                	ld	s2,32(sp)
    80000b1c:	69e2                	ld	s3,24(sp)
    80000b1e:	6a42                	ld	s4,16(sp)
    80000b20:	6aa2                	ld	s5,8(sp)
    80000b22:	6121                	addi	sp,sp,64
    80000b24:	8082                	ret
      kfree(mem);
    80000b26:	8526                	mv	a0,s1
    80000b28:	fffff097          	auipc	ra,0xfffff
    80000b2c:	4f4080e7          	jalr	1268(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000b30:	864e                	mv	a2,s3
    80000b32:	85ca                	mv	a1,s2
    80000b34:	8556                	mv	a0,s5
    80000b36:	00000097          	auipc	ra,0x0
    80000b3a:	f22080e7          	jalr	-222(ra) # 80000a58 <uvmdealloc>
      return 0;
    80000b3e:	4501                	li	a0,0
    80000b40:	bfd1                	j	80000b14 <uvmalloc+0x74>
    return oldsz;
    80000b42:	852e                	mv	a0,a1
}
    80000b44:	8082                	ret
  return newsz;
    80000b46:	8532                	mv	a0,a2
    80000b48:	b7f1                	j	80000b14 <uvmalloc+0x74>

0000000080000b4a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000b4a:	7179                	addi	sp,sp,-48
    80000b4c:	f406                	sd	ra,40(sp)
    80000b4e:	f022                	sd	s0,32(sp)
    80000b50:	ec26                	sd	s1,24(sp)
    80000b52:	e84a                	sd	s2,16(sp)
    80000b54:	e44e                	sd	s3,8(sp)
    80000b56:	e052                	sd	s4,0(sp)
    80000b58:	1800                	addi	s0,sp,48
    80000b5a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000b5c:	84aa                	mv	s1,a0
    80000b5e:	6905                	lui	s2,0x1
    80000b60:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b62:	4985                	li	s3,1
    80000b64:	a821                	j	80000b7c <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000b66:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    80000b68:	0532                	slli	a0,a0,0xc
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	fe0080e7          	jalr	-32(ra) # 80000b4a <freewalk>
      pagetable[i] = 0;
    80000b72:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000b76:	04a1                	addi	s1,s1,8
    80000b78:	03248163          	beq	s1,s2,80000b9a <freewalk+0x50>
    pte_t pte = pagetable[i];
    80000b7c:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000b7e:	00f57793          	andi	a5,a0,15
    80000b82:	ff3782e3          	beq	a5,s3,80000b66 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000b86:	8905                	andi	a0,a0,1
    80000b88:	d57d                	beqz	a0,80000b76 <freewalk+0x2c>
      panic("freewalk: leaf");
    80000b8a:	00007517          	auipc	a0,0x7
    80000b8e:	56e50513          	addi	a0,a0,1390 # 800080f8 <etext+0xf8>
    80000b92:	00005097          	auipc	ra,0x5
    80000b96:	62a080e7          	jalr	1578(ra) # 800061bc <panic>
    }
  }
  kfree((void*)pagetable);
    80000b9a:	8552                	mv	a0,s4
    80000b9c:	fffff097          	auipc	ra,0xfffff
    80000ba0:	480080e7          	jalr	1152(ra) # 8000001c <kfree>
}
    80000ba4:	70a2                	ld	ra,40(sp)
    80000ba6:	7402                	ld	s0,32(sp)
    80000ba8:	64e2                	ld	s1,24(sp)
    80000baa:	6942                	ld	s2,16(sp)
    80000bac:	69a2                	ld	s3,8(sp)
    80000bae:	6a02                	ld	s4,0(sp)
    80000bb0:	6145                	addi	sp,sp,48
    80000bb2:	8082                	ret

0000000080000bb4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
    80000bbe:	84aa                	mv	s1,a0
  if(sz > 0)
    80000bc0:	e999                	bnez	a1,80000bd6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000bc2:	8526                	mv	a0,s1
    80000bc4:	00000097          	auipc	ra,0x0
    80000bc8:	f86080e7          	jalr	-122(ra) # 80000b4a <freewalk>
}
    80000bcc:	60e2                	ld	ra,24(sp)
    80000bce:	6442                	ld	s0,16(sp)
    80000bd0:	64a2                	ld	s1,8(sp)
    80000bd2:	6105                	addi	sp,sp,32
    80000bd4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000bd6:	6605                	lui	a2,0x1
    80000bd8:	167d                	addi	a2,a2,-1
    80000bda:	962e                	add	a2,a2,a1
    80000bdc:	4685                	li	a3,1
    80000bde:	8231                	srli	a2,a2,0xc
    80000be0:	4581                	li	a1,0
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	d12080e7          	jalr	-750(ra) # 800008f4 <uvmunmap>
    80000bea:	bfe1                	j	80000bc2 <uvmfree+0xe>

0000000080000bec <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000bec:	c679                	beqz	a2,80000cba <uvmcopy+0xce>
{
    80000bee:	715d                	addi	sp,sp,-80
    80000bf0:	e486                	sd	ra,72(sp)
    80000bf2:	e0a2                	sd	s0,64(sp)
    80000bf4:	fc26                	sd	s1,56(sp)
    80000bf6:	f84a                	sd	s2,48(sp)
    80000bf8:	f44e                	sd	s3,40(sp)
    80000bfa:	f052                	sd	s4,32(sp)
    80000bfc:	ec56                	sd	s5,24(sp)
    80000bfe:	e85a                	sd	s6,16(sp)
    80000c00:	e45e                	sd	s7,8(sp)
    80000c02:	0880                	addi	s0,sp,80
    80000c04:	8b2a                	mv	s6,a0
    80000c06:	8aae                	mv	s5,a1
    80000c08:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000c0a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000c0c:	4601                	li	a2,0
    80000c0e:	85ce                	mv	a1,s3
    80000c10:	855a                	mv	a0,s6
    80000c12:	00000097          	auipc	ra,0x0
    80000c16:	a34080e7          	jalr	-1484(ra) # 80000646 <walk>
    80000c1a:	c531                	beqz	a0,80000c66 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000c1c:	6118                	ld	a4,0(a0)
    80000c1e:	00177793          	andi	a5,a4,1
    80000c22:	cbb1                	beqz	a5,80000c76 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000c24:	00a75593          	srli	a1,a4,0xa
    80000c28:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000c2c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000c30:	fffff097          	auipc	ra,0xfffff
    80000c34:	492080e7          	jalr	1170(ra) # 800000c2 <kalloc>
    80000c38:	892a                	mv	s2,a0
    80000c3a:	c939                	beqz	a0,80000c90 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000c3c:	6605                	lui	a2,0x1
    80000c3e:	85de                	mv	a1,s7
    80000c40:	fffff097          	auipc	ra,0xfffff
    80000c44:	76e080e7          	jalr	1902(ra) # 800003ae <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000c48:	8726                	mv	a4,s1
    80000c4a:	86ca                	mv	a3,s2
    80000c4c:	6605                	lui	a2,0x1
    80000c4e:	85ce                	mv	a1,s3
    80000c50:	8556                	mv	a0,s5
    80000c52:	00000097          	auipc	ra,0x0
    80000c56:	adc080e7          	jalr	-1316(ra) # 8000072e <mappages>
    80000c5a:	e515                	bnez	a0,80000c86 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000c5c:	6785                	lui	a5,0x1
    80000c5e:	99be                	add	s3,s3,a5
    80000c60:	fb49e6e3          	bltu	s3,s4,80000c0c <uvmcopy+0x20>
    80000c64:	a081                	j	80000ca4 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	4a250513          	addi	a0,a0,1186 # 80008108 <etext+0x108>
    80000c6e:	00005097          	auipc	ra,0x5
    80000c72:	54e080e7          	jalr	1358(ra) # 800061bc <panic>
      panic("uvmcopy: page not present");
    80000c76:	00007517          	auipc	a0,0x7
    80000c7a:	4b250513          	addi	a0,a0,1202 # 80008128 <etext+0x128>
    80000c7e:	00005097          	auipc	ra,0x5
    80000c82:	53e080e7          	jalr	1342(ra) # 800061bc <panic>
      kfree(mem);
    80000c86:	854a                	mv	a0,s2
    80000c88:	fffff097          	auipc	ra,0xfffff
    80000c8c:	394080e7          	jalr	916(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c90:	4685                	li	a3,1
    80000c92:	00c9d613          	srli	a2,s3,0xc
    80000c96:	4581                	li	a1,0
    80000c98:	8556                	mv	a0,s5
    80000c9a:	00000097          	auipc	ra,0x0
    80000c9e:	c5a080e7          	jalr	-934(ra) # 800008f4 <uvmunmap>
  return -1;
    80000ca2:	557d                	li	a0,-1
}
    80000ca4:	60a6                	ld	ra,72(sp)
    80000ca6:	6406                	ld	s0,64(sp)
    80000ca8:	74e2                	ld	s1,56(sp)
    80000caa:	7942                	ld	s2,48(sp)
    80000cac:	79a2                	ld	s3,40(sp)
    80000cae:	7a02                	ld	s4,32(sp)
    80000cb0:	6ae2                	ld	s5,24(sp)
    80000cb2:	6b42                	ld	s6,16(sp)
    80000cb4:	6ba2                	ld	s7,8(sp)
    80000cb6:	6161                	addi	sp,sp,80
    80000cb8:	8082                	ret
  return 0;
    80000cba:	4501                	li	a0,0
}
    80000cbc:	8082                	ret

0000000080000cbe <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e406                	sd	ra,8(sp)
    80000cc2:	e022                	sd	s0,0(sp)
    80000cc4:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000cc6:	4601                	li	a2,0
    80000cc8:	00000097          	auipc	ra,0x0
    80000ccc:	97e080e7          	jalr	-1666(ra) # 80000646 <walk>
  if(pte == 0)
    80000cd0:	c901                	beqz	a0,80000ce0 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000cd2:	611c                	ld	a5,0(a0)
    80000cd4:	9bbd                	andi	a5,a5,-17
    80000cd6:	e11c                	sd	a5,0(a0)
}
    80000cd8:	60a2                	ld	ra,8(sp)
    80000cda:	6402                	ld	s0,0(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret
    panic("uvmclear");
    80000ce0:	00007517          	auipc	a0,0x7
    80000ce4:	46850513          	addi	a0,a0,1128 # 80008148 <etext+0x148>
    80000ce8:	00005097          	auipc	ra,0x5
    80000cec:	4d4080e7          	jalr	1236(ra) # 800061bc <panic>

0000000080000cf0 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000cf0:	c6bd                	beqz	a3,80000d5e <copyout+0x6e>
{
    80000cf2:	715d                	addi	sp,sp,-80
    80000cf4:	e486                	sd	ra,72(sp)
    80000cf6:	e0a2                	sd	s0,64(sp)
    80000cf8:	fc26                	sd	s1,56(sp)
    80000cfa:	f84a                	sd	s2,48(sp)
    80000cfc:	f44e                	sd	s3,40(sp)
    80000cfe:	f052                	sd	s4,32(sp)
    80000d00:	ec56                	sd	s5,24(sp)
    80000d02:	e85a                	sd	s6,16(sp)
    80000d04:	e45e                	sd	s7,8(sp)
    80000d06:	e062                	sd	s8,0(sp)
    80000d08:	0880                	addi	s0,sp,80
    80000d0a:	8b2a                	mv	s6,a0
    80000d0c:	8c2e                	mv	s8,a1
    80000d0e:	8a32                	mv	s4,a2
    80000d10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000d12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000d14:	6a85                	lui	s5,0x1
    80000d16:	a015                	j	80000d3a <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d18:	9562                	add	a0,a0,s8
    80000d1a:	0004861b          	sext.w	a2,s1
    80000d1e:	85d2                	mv	a1,s4
    80000d20:	41250533          	sub	a0,a0,s2
    80000d24:	fffff097          	auipc	ra,0xfffff
    80000d28:	68a080e7          	jalr	1674(ra) # 800003ae <memmove>

    len -= n;
    80000d2c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000d30:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000d32:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000d36:	02098263          	beqz	s3,80000d5a <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000d3a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000d3e:	85ca                	mv	a1,s2
    80000d40:	855a                	mv	a0,s6
    80000d42:	00000097          	auipc	ra,0x0
    80000d46:	9aa080e7          	jalr	-1622(ra) # 800006ec <walkaddr>
    if(pa0 == 0)
    80000d4a:	cd01                	beqz	a0,80000d62 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000d4c:	418904b3          	sub	s1,s2,s8
    80000d50:	94d6                	add	s1,s1,s5
    if(n > len)
    80000d52:	fc99f3e3          	bgeu	s3,s1,80000d18 <copyout+0x28>
    80000d56:	84ce                	mv	s1,s3
    80000d58:	b7c1                	j	80000d18 <copyout+0x28>
  }
  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	a021                	j	80000d64 <copyout+0x74>
    80000d5e:	4501                	li	a0,0
}
    80000d60:	8082                	ret
      return -1;
    80000d62:	557d                	li	a0,-1
}
    80000d64:	60a6                	ld	ra,72(sp)
    80000d66:	6406                	ld	s0,64(sp)
    80000d68:	74e2                	ld	s1,56(sp)
    80000d6a:	7942                	ld	s2,48(sp)
    80000d6c:	79a2                	ld	s3,40(sp)
    80000d6e:	7a02                	ld	s4,32(sp)
    80000d70:	6ae2                	ld	s5,24(sp)
    80000d72:	6b42                	ld	s6,16(sp)
    80000d74:	6ba2                	ld	s7,8(sp)
    80000d76:	6c02                	ld	s8,0(sp)
    80000d78:	6161                	addi	sp,sp,80
    80000d7a:	8082                	ret

0000000080000d7c <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d7c:	c6bd                	beqz	a3,80000dea <copyin+0x6e>
{
    80000d7e:	715d                	addi	sp,sp,-80
    80000d80:	e486                	sd	ra,72(sp)
    80000d82:	e0a2                	sd	s0,64(sp)
    80000d84:	fc26                	sd	s1,56(sp)
    80000d86:	f84a                	sd	s2,48(sp)
    80000d88:	f44e                	sd	s3,40(sp)
    80000d8a:	f052                	sd	s4,32(sp)
    80000d8c:	ec56                	sd	s5,24(sp)
    80000d8e:	e85a                	sd	s6,16(sp)
    80000d90:	e45e                	sd	s7,8(sp)
    80000d92:	e062                	sd	s8,0(sp)
    80000d94:	0880                	addi	s0,sp,80
    80000d96:	8b2a                	mv	s6,a0
    80000d98:	8a2e                	mv	s4,a1
    80000d9a:	8c32                	mv	s8,a2
    80000d9c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000d9e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000da0:	6a85                	lui	s5,0x1
    80000da2:	a015                	j	80000dc6 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000da4:	9562                	add	a0,a0,s8
    80000da6:	0004861b          	sext.w	a2,s1
    80000daa:	412505b3          	sub	a1,a0,s2
    80000dae:	8552                	mv	a0,s4
    80000db0:	fffff097          	auipc	ra,0xfffff
    80000db4:	5fe080e7          	jalr	1534(ra) # 800003ae <memmove>

    len -= n;
    80000db8:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000dbc:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000dbe:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000dc2:	02098263          	beqz	s3,80000de6 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000dc6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000dca:	85ca                	mv	a1,s2
    80000dcc:	855a                	mv	a0,s6
    80000dce:	00000097          	auipc	ra,0x0
    80000dd2:	91e080e7          	jalr	-1762(ra) # 800006ec <walkaddr>
    if(pa0 == 0)
    80000dd6:	cd01                	beqz	a0,80000dee <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000dd8:	418904b3          	sub	s1,s2,s8
    80000ddc:	94d6                	add	s1,s1,s5
    if(n > len)
    80000dde:	fc99f3e3          	bgeu	s3,s1,80000da4 <copyin+0x28>
    80000de2:	84ce                	mv	s1,s3
    80000de4:	b7c1                	j	80000da4 <copyin+0x28>
  }
  return 0;
    80000de6:	4501                	li	a0,0
    80000de8:	a021                	j	80000df0 <copyin+0x74>
    80000dea:	4501                	li	a0,0
}
    80000dec:	8082                	ret
      return -1;
    80000dee:	557d                	li	a0,-1
}
    80000df0:	60a6                	ld	ra,72(sp)
    80000df2:	6406                	ld	s0,64(sp)
    80000df4:	74e2                	ld	s1,56(sp)
    80000df6:	7942                	ld	s2,48(sp)
    80000df8:	79a2                	ld	s3,40(sp)
    80000dfa:	7a02                	ld	s4,32(sp)
    80000dfc:	6ae2                	ld	s5,24(sp)
    80000dfe:	6b42                	ld	s6,16(sp)
    80000e00:	6ba2                	ld	s7,8(sp)
    80000e02:	6c02                	ld	s8,0(sp)
    80000e04:	6161                	addi	sp,sp,80
    80000e06:	8082                	ret

0000000080000e08 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000e08:	c6c5                	beqz	a3,80000eb0 <copyinstr+0xa8>
{
    80000e0a:	715d                	addi	sp,sp,-80
    80000e0c:	e486                	sd	ra,72(sp)
    80000e0e:	e0a2                	sd	s0,64(sp)
    80000e10:	fc26                	sd	s1,56(sp)
    80000e12:	f84a                	sd	s2,48(sp)
    80000e14:	f44e                	sd	s3,40(sp)
    80000e16:	f052                	sd	s4,32(sp)
    80000e18:	ec56                	sd	s5,24(sp)
    80000e1a:	e85a                	sd	s6,16(sp)
    80000e1c:	e45e                	sd	s7,8(sp)
    80000e1e:	0880                	addi	s0,sp,80
    80000e20:	8a2a                	mv	s4,a0
    80000e22:	8b2e                	mv	s6,a1
    80000e24:	8bb2                	mv	s7,a2
    80000e26:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000e28:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e2a:	6985                	lui	s3,0x1
    80000e2c:	a035                	j	80000e58 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e2e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e32:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e34:	0017b793          	seqz	a5,a5
    80000e38:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e3c:	60a6                	ld	ra,72(sp)
    80000e3e:	6406                	ld	s0,64(sp)
    80000e40:	74e2                	ld	s1,56(sp)
    80000e42:	7942                	ld	s2,48(sp)
    80000e44:	79a2                	ld	s3,40(sp)
    80000e46:	7a02                	ld	s4,32(sp)
    80000e48:	6ae2                	ld	s5,24(sp)
    80000e4a:	6b42                	ld	s6,16(sp)
    80000e4c:	6ba2                	ld	s7,8(sp)
    80000e4e:	6161                	addi	sp,sp,80
    80000e50:	8082                	ret
    srcva = va0 + PGSIZE;
    80000e52:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000e56:	c8a9                	beqz	s1,80000ea8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000e58:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e5c:	85ca                	mv	a1,s2
    80000e5e:	8552                	mv	a0,s4
    80000e60:	00000097          	auipc	ra,0x0
    80000e64:	88c080e7          	jalr	-1908(ra) # 800006ec <walkaddr>
    if(pa0 == 0)
    80000e68:	c131                	beqz	a0,80000eac <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000e6a:	41790833          	sub	a6,s2,s7
    80000e6e:	984e                	add	a6,a6,s3
    if(n > max)
    80000e70:	0104f363          	bgeu	s1,a6,80000e76 <copyinstr+0x6e>
    80000e74:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000e76:	955e                	add	a0,a0,s7
    80000e78:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000e7c:	fc080be3          	beqz	a6,80000e52 <copyinstr+0x4a>
    80000e80:	985a                	add	a6,a6,s6
    80000e82:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000e84:	41650633          	sub	a2,a0,s6
    80000e88:	14fd                	addi	s1,s1,-1
    80000e8a:	9b26                	add	s6,s6,s1
    80000e8c:	00f60733          	add	a4,a2,a5
    80000e90:	00074703          	lbu	a4,0(a4)
    80000e94:	df49                	beqz	a4,80000e2e <copyinstr+0x26>
        *dst = *p;
    80000e96:	00e78023          	sb	a4,0(a5)
      --max;
    80000e9a:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000e9e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ea0:	ff0796e3          	bne	a5,a6,80000e8c <copyinstr+0x84>
      dst++;
    80000ea4:	8b42                	mv	s6,a6
    80000ea6:	b775                	j	80000e52 <copyinstr+0x4a>
    80000ea8:	4781                	li	a5,0
    80000eaa:	b769                	j	80000e34 <copyinstr+0x2c>
      return -1;
    80000eac:	557d                	li	a0,-1
    80000eae:	b779                	j	80000e3c <copyinstr+0x34>
  int got_null = 0;
    80000eb0:	4781                	li	a5,0
  if(got_null){
    80000eb2:	0017b793          	seqz	a5,a5
    80000eb6:	40f00533          	neg	a0,a5
}
    80000eba:	8082                	ret

0000000080000ebc <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000ebc:	7139                	addi	sp,sp,-64
    80000ebe:	fc06                	sd	ra,56(sp)
    80000ec0:	f822                	sd	s0,48(sp)
    80000ec2:	f426                	sd	s1,40(sp)
    80000ec4:	f04a                	sd	s2,32(sp)
    80000ec6:	ec4e                	sd	s3,24(sp)
    80000ec8:	e852                	sd	s4,16(sp)
    80000eca:	e456                	sd	s5,8(sp)
    80000ecc:	e05a                	sd	s6,0(sp)
    80000ece:	0080                	addi	s0,sp,64
    80000ed0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ed2:	00008497          	auipc	s1,0x8
    80000ed6:	6de48493          	addi	s1,s1,1758 # 800095b0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000eda:	8b26                	mv	s6,s1
    80000edc:	00007a97          	auipc	s5,0x7
    80000ee0:	124a8a93          	addi	s5,s5,292 # 80008000 <etext>
    80000ee4:	04000937          	lui	s2,0x4000
    80000ee8:	197d                	addi	s2,s2,-1
    80000eea:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eec:	0000ea17          	auipc	s4,0xe
    80000ef0:	2c4a0a13          	addi	s4,s4,708 # 8000f1b0 <tickslock>
    char *pa = kalloc();
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	1ce080e7          	jalr	462(ra) # 800000c2 <kalloc>
    80000efc:	862a                	mv	a2,a0
    if(pa == 0)
    80000efe:	c131                	beqz	a0,80000f42 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000f00:	416485b3          	sub	a1,s1,s6
    80000f04:	8591                	srai	a1,a1,0x4
    80000f06:	000ab783          	ld	a5,0(s5)
    80000f0a:	02f585b3          	mul	a1,a1,a5
    80000f0e:	2585                	addiw	a1,a1,1
    80000f10:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f14:	4719                	li	a4,6
    80000f16:	6685                	lui	a3,0x1
    80000f18:	40b905b3          	sub	a1,s2,a1
    80000f1c:	854e                	mv	a0,s3
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	8b0080e7          	jalr	-1872(ra) # 800007ce <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f26:	17048493          	addi	s1,s1,368
    80000f2a:	fd4495e3          	bne	s1,s4,80000ef4 <proc_mapstacks+0x38>
  }
}
    80000f2e:	70e2                	ld	ra,56(sp)
    80000f30:	7442                	ld	s0,48(sp)
    80000f32:	74a2                	ld	s1,40(sp)
    80000f34:	7902                	ld	s2,32(sp)
    80000f36:	69e2                	ld	s3,24(sp)
    80000f38:	6a42                	ld	s4,16(sp)
    80000f3a:	6aa2                	ld	s5,8(sp)
    80000f3c:	6b02                	ld	s6,0(sp)
    80000f3e:	6121                	addi	sp,sp,64
    80000f40:	8082                	ret
      panic("kalloc");
    80000f42:	00007517          	auipc	a0,0x7
    80000f46:	21650513          	addi	a0,a0,534 # 80008158 <etext+0x158>
    80000f4a:	00005097          	auipc	ra,0x5
    80000f4e:	272080e7          	jalr	626(ra) # 800061bc <panic>

0000000080000f52 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f52:	7139                	addi	sp,sp,-64
    80000f54:	fc06                	sd	ra,56(sp)
    80000f56:	f822                	sd	s0,48(sp)
    80000f58:	f426                	sd	s1,40(sp)
    80000f5a:	f04a                	sd	s2,32(sp)
    80000f5c:	ec4e                	sd	s3,24(sp)
    80000f5e:	e852                	sd	s4,16(sp)
    80000f60:	e456                	sd	s5,8(sp)
    80000f62:	e05a                	sd	s6,0(sp)
    80000f64:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f66:	00007597          	auipc	a1,0x7
    80000f6a:	1fa58593          	addi	a1,a1,506 # 80008160 <etext+0x160>
    80000f6e:	00008517          	auipc	a0,0x8
    80000f72:	20250513          	addi	a0,a0,514 # 80009170 <pid_lock>
    80000f76:	00006097          	auipc	ra,0x6
    80000f7a:	8f6080e7          	jalr	-1802(ra) # 8000686c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f7e:	00007597          	auipc	a1,0x7
    80000f82:	1ea58593          	addi	a1,a1,490 # 80008168 <etext+0x168>
    80000f86:	00008517          	auipc	a0,0x8
    80000f8a:	20a50513          	addi	a0,a0,522 # 80009190 <wait_lock>
    80000f8e:	00006097          	auipc	ra,0x6
    80000f92:	8de080e7          	jalr	-1826(ra) # 8000686c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f96:	00008497          	auipc	s1,0x8
    80000f9a:	61a48493          	addi	s1,s1,1562 # 800095b0 <proc>
      initlock(&p->lock, "proc");
    80000f9e:	00007b17          	auipc	s6,0x7
    80000fa2:	1dab0b13          	addi	s6,s6,474 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000fa6:	8aa6                	mv	s5,s1
    80000fa8:	00007a17          	auipc	s4,0x7
    80000fac:	058a0a13          	addi	s4,s4,88 # 80008000 <etext>
    80000fb0:	04000937          	lui	s2,0x4000
    80000fb4:	197d                	addi	s2,s2,-1
    80000fb6:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb8:	0000e997          	auipc	s3,0xe
    80000fbc:	1f898993          	addi	s3,s3,504 # 8000f1b0 <tickslock>
      initlock(&p->lock, "proc");
    80000fc0:	85da                	mv	a1,s6
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	00006097          	auipc	ra,0x6
    80000fc8:	8a8080e7          	jalr	-1880(ra) # 8000686c <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000fcc:	415487b3          	sub	a5,s1,s5
    80000fd0:	8791                	srai	a5,a5,0x4
    80000fd2:	000a3703          	ld	a4,0(s4)
    80000fd6:	02e787b3          	mul	a5,a5,a4
    80000fda:	2785                	addiw	a5,a5,1
    80000fdc:	00d7979b          	slliw	a5,a5,0xd
    80000fe0:	40f907b3          	sub	a5,s2,a5
    80000fe4:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe6:	17048493          	addi	s1,s1,368
    80000fea:	fd349be3          	bne	s1,s3,80000fc0 <procinit+0x6e>
  }
}
    80000fee:	70e2                	ld	ra,56(sp)
    80000ff0:	7442                	ld	s0,48(sp)
    80000ff2:	74a2                	ld	s1,40(sp)
    80000ff4:	7902                	ld	s2,32(sp)
    80000ff6:	69e2                	ld	s3,24(sp)
    80000ff8:	6a42                	ld	s4,16(sp)
    80000ffa:	6aa2                	ld	s5,8(sp)
    80000ffc:	6b02                	ld	s6,0(sp)
    80000ffe:	6121                	addi	sp,sp,64
    80001000:	8082                	ret

0000000080001002 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001002:	1141                	addi	sp,sp,-16
    80001004:	e422                	sd	s0,8(sp)
    80001006:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001008:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000100a:	2501                	sext.w	a0,a0
    8000100c:	6422                	ld	s0,8(sp)
    8000100e:	0141                	addi	sp,sp,16
    80001010:	8082                	ret

0000000080001012 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001012:	1141                	addi	sp,sp,-16
    80001014:	e422                	sd	s0,8(sp)
    80001016:	0800                	addi	s0,sp,16
    80001018:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000101a:	2781                	sext.w	a5,a5
    8000101c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000101e:	00008517          	auipc	a0,0x8
    80001022:	19250513          	addi	a0,a0,402 # 800091b0 <cpus>
    80001026:	953e                	add	a0,a0,a5
    80001028:	6422                	ld	s0,8(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret

000000008000102e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
  push_off();
    80001038:	00005097          	auipc	ra,0x5
    8000103c:	66c080e7          	jalr	1644(ra) # 800066a4 <push_off>
    80001040:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001042:	2781                	sext.w	a5,a5
    80001044:	079e                	slli	a5,a5,0x7
    80001046:	00008717          	auipc	a4,0x8
    8000104a:	12a70713          	addi	a4,a4,298 # 80009170 <pid_lock>
    8000104e:	97ba                	add	a5,a5,a4
    80001050:	63a4                	ld	s1,64(a5)
  pop_off();
    80001052:	00005097          	auipc	ra,0x5
    80001056:	70e080e7          	jalr	1806(ra) # 80006760 <pop_off>
  return p;
}
    8000105a:	8526                	mv	a0,s1
    8000105c:	60e2                	ld	ra,24(sp)
    8000105e:	6442                	ld	s0,16(sp)
    80001060:	64a2                	ld	s1,8(sp)
    80001062:	6105                	addi	sp,sp,32
    80001064:	8082                	ret

0000000080001066 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001066:	1141                	addi	sp,sp,-16
    80001068:	e406                	sd	ra,8(sp)
    8000106a:	e022                	sd	s0,0(sp)
    8000106c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000106e:	00000097          	auipc	ra,0x0
    80001072:	fc0080e7          	jalr	-64(ra) # 8000102e <myproc>
    80001076:	00005097          	auipc	ra,0x5
    8000107a:	74a080e7          	jalr	1866(ra) # 800067c0 <release>

  if (first) {
    8000107e:	00008797          	auipc	a5,0x8
    80001082:	8427a783          	lw	a5,-1982(a5) # 800088c0 <first.1688>
    80001086:	eb89                	bnez	a5,80001098 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001088:	00001097          	auipc	ra,0x1
    8000108c:	c0a080e7          	jalr	-1014(ra) # 80001c92 <usertrapret>
}
    80001090:	60a2                	ld	ra,8(sp)
    80001092:	6402                	ld	s0,0(sp)
    80001094:	0141                	addi	sp,sp,16
    80001096:	8082                	ret
    first = 0;
    80001098:	00008797          	auipc	a5,0x8
    8000109c:	8207a423          	sw	zero,-2008(a5) # 800088c0 <first.1688>
    fsinit(ROOTDEV);
    800010a0:	4505                	li	a0,1
    800010a2:	00002097          	auipc	ra,0x2
    800010a6:	ab0080e7          	jalr	-1360(ra) # 80002b52 <fsinit>
    800010aa:	bff9                	j	80001088 <forkret+0x22>

00000000800010ac <allocpid>:
allocpid() {
    800010ac:	1101                	addi	sp,sp,-32
    800010ae:	ec06                	sd	ra,24(sp)
    800010b0:	e822                	sd	s0,16(sp)
    800010b2:	e426                	sd	s1,8(sp)
    800010b4:	e04a                	sd	s2,0(sp)
    800010b6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010b8:	00008917          	auipc	s2,0x8
    800010bc:	0b890913          	addi	s2,s2,184 # 80009170 <pid_lock>
    800010c0:	854a                	mv	a0,s2
    800010c2:	00005097          	auipc	ra,0x5
    800010c6:	62e080e7          	jalr	1582(ra) # 800066f0 <acquire>
  pid = nextpid;
    800010ca:	00007797          	auipc	a5,0x7
    800010ce:	7fa78793          	addi	a5,a5,2042 # 800088c4 <nextpid>
    800010d2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010d4:	0014871b          	addiw	a4,s1,1
    800010d8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800010da:	854a                	mv	a0,s2
    800010dc:	00005097          	auipc	ra,0x5
    800010e0:	6e4080e7          	jalr	1764(ra) # 800067c0 <release>
}
    800010e4:	8526                	mv	a0,s1
    800010e6:	60e2                	ld	ra,24(sp)
    800010e8:	6442                	ld	s0,16(sp)
    800010ea:	64a2                	ld	s1,8(sp)
    800010ec:	6902                	ld	s2,0(sp)
    800010ee:	6105                	addi	sp,sp,32
    800010f0:	8082                	ret

00000000800010f2 <proc_pagetable>:
{
    800010f2:	1101                	addi	sp,sp,-32
    800010f4:	ec06                	sd	ra,24(sp)
    800010f6:	e822                	sd	s0,16(sp)
    800010f8:	e426                	sd	s1,8(sp)
    800010fa:	e04a                	sd	s2,0(sp)
    800010fc:	1000                	addi	s0,sp,32
    800010fe:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001100:	00000097          	auipc	ra,0x0
    80001104:	8b8080e7          	jalr	-1864(ra) # 800009b8 <uvmcreate>
    80001108:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000110a:	c121                	beqz	a0,8000114a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000110c:	4729                	li	a4,10
    8000110e:	00006697          	auipc	a3,0x6
    80001112:	ef268693          	addi	a3,a3,-270 # 80007000 <_trampoline>
    80001116:	6605                	lui	a2,0x1
    80001118:	040005b7          	lui	a1,0x4000
    8000111c:	15fd                	addi	a1,a1,-1
    8000111e:	05b2                	slli	a1,a1,0xc
    80001120:	fffff097          	auipc	ra,0xfffff
    80001124:	60e080e7          	jalr	1550(ra) # 8000072e <mappages>
    80001128:	02054863          	bltz	a0,80001158 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000112c:	4719                	li	a4,6
    8000112e:	06093683          	ld	a3,96(s2)
    80001132:	6605                	lui	a2,0x1
    80001134:	020005b7          	lui	a1,0x2000
    80001138:	15fd                	addi	a1,a1,-1
    8000113a:	05b6                	slli	a1,a1,0xd
    8000113c:	8526                	mv	a0,s1
    8000113e:	fffff097          	auipc	ra,0xfffff
    80001142:	5f0080e7          	jalr	1520(ra) # 8000072e <mappages>
    80001146:	02054163          	bltz	a0,80001168 <proc_pagetable+0x76>
}
    8000114a:	8526                	mv	a0,s1
    8000114c:	60e2                	ld	ra,24(sp)
    8000114e:	6442                	ld	s0,16(sp)
    80001150:	64a2                	ld	s1,8(sp)
    80001152:	6902                	ld	s2,0(sp)
    80001154:	6105                	addi	sp,sp,32
    80001156:	8082                	ret
    uvmfree(pagetable, 0);
    80001158:	4581                	li	a1,0
    8000115a:	8526                	mv	a0,s1
    8000115c:	00000097          	auipc	ra,0x0
    80001160:	a58080e7          	jalr	-1448(ra) # 80000bb4 <uvmfree>
    return 0;
    80001164:	4481                	li	s1,0
    80001166:	b7d5                	j	8000114a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001168:	4681                	li	a3,0
    8000116a:	4605                	li	a2,1
    8000116c:	040005b7          	lui	a1,0x4000
    80001170:	15fd                	addi	a1,a1,-1
    80001172:	05b2                	slli	a1,a1,0xc
    80001174:	8526                	mv	a0,s1
    80001176:	fffff097          	auipc	ra,0xfffff
    8000117a:	77e080e7          	jalr	1918(ra) # 800008f4 <uvmunmap>
    uvmfree(pagetable, 0);
    8000117e:	4581                	li	a1,0
    80001180:	8526                	mv	a0,s1
    80001182:	00000097          	auipc	ra,0x0
    80001186:	a32080e7          	jalr	-1486(ra) # 80000bb4 <uvmfree>
    return 0;
    8000118a:	4481                	li	s1,0
    8000118c:	bf7d                	j	8000114a <proc_pagetable+0x58>

000000008000118e <proc_freepagetable>:
{
    8000118e:	1101                	addi	sp,sp,-32
    80001190:	ec06                	sd	ra,24(sp)
    80001192:	e822                	sd	s0,16(sp)
    80001194:	e426                	sd	s1,8(sp)
    80001196:	e04a                	sd	s2,0(sp)
    80001198:	1000                	addi	s0,sp,32
    8000119a:	84aa                	mv	s1,a0
    8000119c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000119e:	4681                	li	a3,0
    800011a0:	4605                	li	a2,1
    800011a2:	040005b7          	lui	a1,0x4000
    800011a6:	15fd                	addi	a1,a1,-1
    800011a8:	05b2                	slli	a1,a1,0xc
    800011aa:	fffff097          	auipc	ra,0xfffff
    800011ae:	74a080e7          	jalr	1866(ra) # 800008f4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011b2:	4681                	li	a3,0
    800011b4:	4605                	li	a2,1
    800011b6:	020005b7          	lui	a1,0x2000
    800011ba:	15fd                	addi	a1,a1,-1
    800011bc:	05b6                	slli	a1,a1,0xd
    800011be:	8526                	mv	a0,s1
    800011c0:	fffff097          	auipc	ra,0xfffff
    800011c4:	734080e7          	jalr	1844(ra) # 800008f4 <uvmunmap>
  uvmfree(pagetable, sz);
    800011c8:	85ca                	mv	a1,s2
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	9e8080e7          	jalr	-1560(ra) # 80000bb4 <uvmfree>
}
    800011d4:	60e2                	ld	ra,24(sp)
    800011d6:	6442                	ld	s0,16(sp)
    800011d8:	64a2                	ld	s1,8(sp)
    800011da:	6902                	ld	s2,0(sp)
    800011dc:	6105                	addi	sp,sp,32
    800011de:	8082                	ret

00000000800011e0 <freeproc>:
{
    800011e0:	1101                	addi	sp,sp,-32
    800011e2:	ec06                	sd	ra,24(sp)
    800011e4:	e822                	sd	s0,16(sp)
    800011e6:	e426                	sd	s1,8(sp)
    800011e8:	1000                	addi	s0,sp,32
    800011ea:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011ec:	7128                	ld	a0,96(a0)
    800011ee:	c509                	beqz	a0,800011f8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011f0:	fffff097          	auipc	ra,0xfffff
    800011f4:	e2c080e7          	jalr	-468(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011f8:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011fc:	6ca8                	ld	a0,88(s1)
    800011fe:	c511                	beqz	a0,8000120a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001200:	68ac                	ld	a1,80(s1)
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f8c080e7          	jalr	-116(ra) # 8000118e <proc_freepagetable>
  p->pagetable = 0;
    8000120a:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000120e:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001212:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001216:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000121a:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    8000121e:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001222:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001226:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000122a:	0204a023          	sw	zero,32(s1)
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6105                	addi	sp,sp,32
    80001236:	8082                	ret

0000000080001238 <allocproc>:
{
    80001238:	1101                	addi	sp,sp,-32
    8000123a:	ec06                	sd	ra,24(sp)
    8000123c:	e822                	sd	s0,16(sp)
    8000123e:	e426                	sd	s1,8(sp)
    80001240:	e04a                	sd	s2,0(sp)
    80001242:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001244:	00008497          	auipc	s1,0x8
    80001248:	36c48493          	addi	s1,s1,876 # 800095b0 <proc>
    8000124c:	0000e917          	auipc	s2,0xe
    80001250:	f6490913          	addi	s2,s2,-156 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    80001254:	8526                	mv	a0,s1
    80001256:	00005097          	auipc	ra,0x5
    8000125a:	49a080e7          	jalr	1178(ra) # 800066f0 <acquire>
    if(p->state == UNUSED) {
    8000125e:	509c                	lw	a5,32(s1)
    80001260:	cf81                	beqz	a5,80001278 <allocproc+0x40>
      release(&p->lock);
    80001262:	8526                	mv	a0,s1
    80001264:	00005097          	auipc	ra,0x5
    80001268:	55c080e7          	jalr	1372(ra) # 800067c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000126c:	17048493          	addi	s1,s1,368
    80001270:	ff2492e3          	bne	s1,s2,80001254 <allocproc+0x1c>
  return 0;
    80001274:	4481                	li	s1,0
    80001276:	a889                	j	800012c8 <allocproc+0x90>
  p->pid = allocpid();
    80001278:	00000097          	auipc	ra,0x0
    8000127c:	e34080e7          	jalr	-460(ra) # 800010ac <allocpid>
    80001280:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001282:	4785                	li	a5,1
    80001284:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	e3c080e7          	jalr	-452(ra) # 800000c2 <kalloc>
    8000128e:	892a                	mv	s2,a0
    80001290:	f0a8                	sd	a0,96(s1)
    80001292:	c131                	beqz	a0,800012d6 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001294:	8526                	mv	a0,s1
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	e5c080e7          	jalr	-420(ra) # 800010f2 <proc_pagetable>
    8000129e:	892a                	mv	s2,a0
    800012a0:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800012a2:	c531                	beqz	a0,800012ee <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012a4:	07000613          	li	a2,112
    800012a8:	4581                	li	a1,0
    800012aa:	06848513          	addi	a0,s1,104
    800012ae:	fffff097          	auipc	ra,0xfffff
    800012b2:	0a0080e7          	jalr	160(ra) # 8000034e <memset>
  p->context.ra = (uint64)forkret;
    800012b6:	00000797          	auipc	a5,0x0
    800012ba:	db078793          	addi	a5,a5,-592 # 80001066 <forkret>
    800012be:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012c0:	64bc                	ld	a5,72(s1)
    800012c2:	6705                	lui	a4,0x1
    800012c4:	97ba                	add	a5,a5,a4
    800012c6:	f8bc                	sd	a5,112(s1)
}
    800012c8:	8526                	mv	a0,s1
    800012ca:	60e2                	ld	ra,24(sp)
    800012cc:	6442                	ld	s0,16(sp)
    800012ce:	64a2                	ld	s1,8(sp)
    800012d0:	6902                	ld	s2,0(sp)
    800012d2:	6105                	addi	sp,sp,32
    800012d4:	8082                	ret
    freeproc(p);
    800012d6:	8526                	mv	a0,s1
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	f08080e7          	jalr	-248(ra) # 800011e0 <freeproc>
    release(&p->lock);
    800012e0:	8526                	mv	a0,s1
    800012e2:	00005097          	auipc	ra,0x5
    800012e6:	4de080e7          	jalr	1246(ra) # 800067c0 <release>
    return 0;
    800012ea:	84ca                	mv	s1,s2
    800012ec:	bff1                	j	800012c8 <allocproc+0x90>
    freeproc(p);
    800012ee:	8526                	mv	a0,s1
    800012f0:	00000097          	auipc	ra,0x0
    800012f4:	ef0080e7          	jalr	-272(ra) # 800011e0 <freeproc>
    release(&p->lock);
    800012f8:	8526                	mv	a0,s1
    800012fa:	00005097          	auipc	ra,0x5
    800012fe:	4c6080e7          	jalr	1222(ra) # 800067c0 <release>
    return 0;
    80001302:	84ca                	mv	s1,s2
    80001304:	b7d1                	j	800012c8 <allocproc+0x90>

0000000080001306 <userinit>:
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001310:	00000097          	auipc	ra,0x0
    80001314:	f28080e7          	jalr	-216(ra) # 80001238 <allocproc>
    80001318:	84aa                	mv	s1,a0
  initproc = p;
    8000131a:	00008797          	auipc	a5,0x8
    8000131e:	cea7bb23          	sd	a0,-778(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001322:	03400613          	li	a2,52
    80001326:	00007597          	auipc	a1,0x7
    8000132a:	5aa58593          	addi	a1,a1,1450 # 800088d0 <initcode>
    8000132e:	6d28                	ld	a0,88(a0)
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	6b6080e7          	jalr	1718(ra) # 800009e6 <uvminit>
  p->sz = PGSIZE;
    80001338:	6785                	lui	a5,0x1
    8000133a:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    8000133c:	70b8                	ld	a4,96(s1)
    8000133e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001342:	70b8                	ld	a4,96(s1)
    80001344:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001346:	4641                	li	a2,16
    80001348:	00007597          	auipc	a1,0x7
    8000134c:	e3858593          	addi	a1,a1,-456 # 80008180 <etext+0x180>
    80001350:	16048513          	addi	a0,s1,352
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	14c080e7          	jalr	332(ra) # 800004a0 <safestrcpy>
  p->cwd = namei("/");
    8000135c:	00007517          	auipc	a0,0x7
    80001360:	e3450513          	addi	a0,a0,-460 # 80008190 <etext+0x190>
    80001364:	00002097          	auipc	ra,0x2
    80001368:	21c080e7          	jalr	540(ra) # 80003580 <namei>
    8000136c:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001370:	478d                	li	a5,3
    80001372:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001374:	8526                	mv	a0,s1
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	44a080e7          	jalr	1098(ra) # 800067c0 <release>
}
    8000137e:	60e2                	ld	ra,24(sp)
    80001380:	6442                	ld	s0,16(sp)
    80001382:	64a2                	ld	s1,8(sp)
    80001384:	6105                	addi	sp,sp,32
    80001386:	8082                	ret

0000000080001388 <growproc>:
{
    80001388:	1101                	addi	sp,sp,-32
    8000138a:	ec06                	sd	ra,24(sp)
    8000138c:	e822                	sd	s0,16(sp)
    8000138e:	e426                	sd	s1,8(sp)
    80001390:	e04a                	sd	s2,0(sp)
    80001392:	1000                	addi	s0,sp,32
    80001394:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001396:	00000097          	auipc	ra,0x0
    8000139a:	c98080e7          	jalr	-872(ra) # 8000102e <myproc>
    8000139e:	892a                	mv	s2,a0
  sz = p->sz;
    800013a0:	692c                	ld	a1,80(a0)
    800013a2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    800013a6:	00904f63          	bgtz	s1,800013c4 <growproc+0x3c>
  } else if(n < 0){
    800013aa:	0204cc63          	bltz	s1,800013e2 <growproc+0x5a>
  p->sz = sz;
    800013ae:	1602                	slli	a2,a2,0x20
    800013b0:	9201                	srli	a2,a2,0x20
    800013b2:	04c93823          	sd	a2,80(s2)
  return 0;
    800013b6:	4501                	li	a0,0
}
    800013b8:	60e2                	ld	ra,24(sp)
    800013ba:	6442                	ld	s0,16(sp)
    800013bc:	64a2                	ld	s1,8(sp)
    800013be:	6902                	ld	s2,0(sp)
    800013c0:	6105                	addi	sp,sp,32
    800013c2:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013c4:	9e25                	addw	a2,a2,s1
    800013c6:	1602                	slli	a2,a2,0x20
    800013c8:	9201                	srli	a2,a2,0x20
    800013ca:	1582                	slli	a1,a1,0x20
    800013cc:	9181                	srli	a1,a1,0x20
    800013ce:	6d28                	ld	a0,88(a0)
    800013d0:	fffff097          	auipc	ra,0xfffff
    800013d4:	6d0080e7          	jalr	1744(ra) # 80000aa0 <uvmalloc>
    800013d8:	0005061b          	sext.w	a2,a0
    800013dc:	fa69                	bnez	a2,800013ae <growproc+0x26>
      return -1;
    800013de:	557d                	li	a0,-1
    800013e0:	bfe1                	j	800013b8 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013e2:	9e25                	addw	a2,a2,s1
    800013e4:	1602                	slli	a2,a2,0x20
    800013e6:	9201                	srli	a2,a2,0x20
    800013e8:	1582                	slli	a1,a1,0x20
    800013ea:	9181                	srli	a1,a1,0x20
    800013ec:	6d28                	ld	a0,88(a0)
    800013ee:	fffff097          	auipc	ra,0xfffff
    800013f2:	66a080e7          	jalr	1642(ra) # 80000a58 <uvmdealloc>
    800013f6:	0005061b          	sext.w	a2,a0
    800013fa:	bf55                	j	800013ae <growproc+0x26>

00000000800013fc <fork>:
{
    800013fc:	7179                	addi	sp,sp,-48
    800013fe:	f406                	sd	ra,40(sp)
    80001400:	f022                	sd	s0,32(sp)
    80001402:	ec26                	sd	s1,24(sp)
    80001404:	e84a                	sd	s2,16(sp)
    80001406:	e44e                	sd	s3,8(sp)
    80001408:	e052                	sd	s4,0(sp)
    8000140a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000140c:	00000097          	auipc	ra,0x0
    80001410:	c22080e7          	jalr	-990(ra) # 8000102e <myproc>
    80001414:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001416:	00000097          	auipc	ra,0x0
    8000141a:	e22080e7          	jalr	-478(ra) # 80001238 <allocproc>
    8000141e:	10050b63          	beqz	a0,80001534 <fork+0x138>
    80001422:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001424:	05093603          	ld	a2,80(s2)
    80001428:	6d2c                	ld	a1,88(a0)
    8000142a:	05893503          	ld	a0,88(s2)
    8000142e:	fffff097          	auipc	ra,0xfffff
    80001432:	7be080e7          	jalr	1982(ra) # 80000bec <uvmcopy>
    80001436:	04054663          	bltz	a0,80001482 <fork+0x86>
  np->sz = p->sz;
    8000143a:	05093783          	ld	a5,80(s2)
    8000143e:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001442:	06093683          	ld	a3,96(s2)
    80001446:	87b6                	mv	a5,a3
    80001448:	0609b703          	ld	a4,96(s3)
    8000144c:	12068693          	addi	a3,a3,288
    80001450:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001454:	6788                	ld	a0,8(a5)
    80001456:	6b8c                	ld	a1,16(a5)
    80001458:	6f90                	ld	a2,24(a5)
    8000145a:	01073023          	sd	a6,0(a4)
    8000145e:	e708                	sd	a0,8(a4)
    80001460:	eb0c                	sd	a1,16(a4)
    80001462:	ef10                	sd	a2,24(a4)
    80001464:	02078793          	addi	a5,a5,32
    80001468:	02070713          	addi	a4,a4,32
    8000146c:	fed792e3          	bne	a5,a3,80001450 <fork+0x54>
  np->trapframe->a0 = 0;
    80001470:	0609b783          	ld	a5,96(s3)
    80001474:	0607b823          	sd	zero,112(a5)
    80001478:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    8000147c:	15800a13          	li	s4,344
    80001480:	a03d                	j	800014ae <fork+0xb2>
    freeproc(np);
    80001482:	854e                	mv	a0,s3
    80001484:	00000097          	auipc	ra,0x0
    80001488:	d5c080e7          	jalr	-676(ra) # 800011e0 <freeproc>
    release(&np->lock);
    8000148c:	854e                	mv	a0,s3
    8000148e:	00005097          	auipc	ra,0x5
    80001492:	332080e7          	jalr	818(ra) # 800067c0 <release>
    return -1;
    80001496:	5a7d                	li	s4,-1
    80001498:	a069                	j	80001522 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    8000149a:	00002097          	auipc	ra,0x2
    8000149e:	77c080e7          	jalr	1916(ra) # 80003c16 <filedup>
    800014a2:	009987b3          	add	a5,s3,s1
    800014a6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800014a8:	04a1                	addi	s1,s1,8
    800014aa:	01448763          	beq	s1,s4,800014b8 <fork+0xbc>
    if(p->ofile[i])
    800014ae:	009907b3          	add	a5,s2,s1
    800014b2:	6388                	ld	a0,0(a5)
    800014b4:	f17d                	bnez	a0,8000149a <fork+0x9e>
    800014b6:	bfcd                	j	800014a8 <fork+0xac>
  np->cwd = idup(p->cwd);
    800014b8:	15893503          	ld	a0,344(s2)
    800014bc:	00002097          	auipc	ra,0x2
    800014c0:	8d0080e7          	jalr	-1840(ra) # 80002d8c <idup>
    800014c4:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014c8:	4641                	li	a2,16
    800014ca:	16090593          	addi	a1,s2,352
    800014ce:	16098513          	addi	a0,s3,352
    800014d2:	fffff097          	auipc	ra,0xfffff
    800014d6:	fce080e7          	jalr	-50(ra) # 800004a0 <safestrcpy>
  pid = np->pid;
    800014da:	0389aa03          	lw	s4,56(s3)
  release(&np->lock);
    800014de:	854e                	mv	a0,s3
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	2e0080e7          	jalr	736(ra) # 800067c0 <release>
  acquire(&wait_lock);
    800014e8:	00008497          	auipc	s1,0x8
    800014ec:	ca848493          	addi	s1,s1,-856 # 80009190 <wait_lock>
    800014f0:	8526                	mv	a0,s1
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	1fe080e7          	jalr	510(ra) # 800066f0 <acquire>
  np->parent = p;
    800014fa:	0529b023          	sd	s2,64(s3)
  release(&wait_lock);
    800014fe:	8526                	mv	a0,s1
    80001500:	00005097          	auipc	ra,0x5
    80001504:	2c0080e7          	jalr	704(ra) # 800067c0 <release>
  acquire(&np->lock);
    80001508:	854e                	mv	a0,s3
    8000150a:	00005097          	auipc	ra,0x5
    8000150e:	1e6080e7          	jalr	486(ra) # 800066f0 <acquire>
  np->state = RUNNABLE;
    80001512:	478d                	li	a5,3
    80001514:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001518:	854e                	mv	a0,s3
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	2a6080e7          	jalr	678(ra) # 800067c0 <release>
}
    80001522:	8552                	mv	a0,s4
    80001524:	70a2                	ld	ra,40(sp)
    80001526:	7402                	ld	s0,32(sp)
    80001528:	64e2                	ld	s1,24(sp)
    8000152a:	6942                	ld	s2,16(sp)
    8000152c:	69a2                	ld	s3,8(sp)
    8000152e:	6a02                	ld	s4,0(sp)
    80001530:	6145                	addi	sp,sp,48
    80001532:	8082                	ret
    return -1;
    80001534:	5a7d                	li	s4,-1
    80001536:	b7f5                	j	80001522 <fork+0x126>

0000000080001538 <scheduler>:
{
    80001538:	7139                	addi	sp,sp,-64
    8000153a:	fc06                	sd	ra,56(sp)
    8000153c:	f822                	sd	s0,48(sp)
    8000153e:	f426                	sd	s1,40(sp)
    80001540:	f04a                	sd	s2,32(sp)
    80001542:	ec4e                	sd	s3,24(sp)
    80001544:	e852                	sd	s4,16(sp)
    80001546:	e456                	sd	s5,8(sp)
    80001548:	e05a                	sd	s6,0(sp)
    8000154a:	0080                	addi	s0,sp,64
    8000154c:	8792                	mv	a5,tp
  int id = r_tp();
    8000154e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001550:	00779a93          	slli	s5,a5,0x7
    80001554:	00008717          	auipc	a4,0x8
    80001558:	c1c70713          	addi	a4,a4,-996 # 80009170 <pid_lock>
    8000155c:	9756                	add	a4,a4,s5
    8000155e:	04073023          	sd	zero,64(a4)
        swtch(&c->context, &p->context);
    80001562:	00008717          	auipc	a4,0x8
    80001566:	c5670713          	addi	a4,a4,-938 # 800091b8 <cpus+0x8>
    8000156a:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000156c:	498d                	li	s3,3
        p->state = RUNNING;
    8000156e:	4b11                	li	s6,4
        c->proc = p;
    80001570:	079e                	slli	a5,a5,0x7
    80001572:	00008a17          	auipc	s4,0x8
    80001576:	bfea0a13          	addi	s4,s4,-1026 # 80009170 <pid_lock>
    8000157a:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000157c:	0000e917          	auipc	s2,0xe
    80001580:	c3490913          	addi	s2,s2,-972 # 8000f1b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001584:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001588:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000158c:	10079073          	csrw	sstatus,a5
    80001590:	00008497          	auipc	s1,0x8
    80001594:	02048493          	addi	s1,s1,32 # 800095b0 <proc>
    80001598:	a03d                	j	800015c6 <scheduler+0x8e>
        p->state = RUNNING;
    8000159a:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    8000159e:	049a3023          	sd	s1,64(s4)
        swtch(&c->context, &p->context);
    800015a2:	06848593          	addi	a1,s1,104
    800015a6:	8556                	mv	a0,s5
    800015a8:	00000097          	auipc	ra,0x0
    800015ac:	640080e7          	jalr	1600(ra) # 80001be8 <swtch>
        c->proc = 0;
    800015b0:	040a3023          	sd	zero,64(s4)
      release(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	20a080e7          	jalr	522(ra) # 800067c0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015be:	17048493          	addi	s1,s1,368
    800015c2:	fd2481e3          	beq	s1,s2,80001584 <scheduler+0x4c>
      acquire(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	00005097          	auipc	ra,0x5
    800015cc:	128080e7          	jalr	296(ra) # 800066f0 <acquire>
      if(p->state == RUNNABLE) {
    800015d0:	509c                	lw	a5,32(s1)
    800015d2:	ff3791e3          	bne	a5,s3,800015b4 <scheduler+0x7c>
    800015d6:	b7d1                	j	8000159a <scheduler+0x62>

00000000800015d8 <sched>:
{
    800015d8:	7179                	addi	sp,sp,-48
    800015da:	f406                	sd	ra,40(sp)
    800015dc:	f022                	sd	s0,32(sp)
    800015de:	ec26                	sd	s1,24(sp)
    800015e0:	e84a                	sd	s2,16(sp)
    800015e2:	e44e                	sd	s3,8(sp)
    800015e4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	a48080e7          	jalr	-1464(ra) # 8000102e <myproc>
    800015ee:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800015f0:	00005097          	auipc	ra,0x5
    800015f4:	086080e7          	jalr	134(ra) # 80006676 <holding>
    800015f8:	c93d                	beqz	a0,8000166e <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015fa:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015fc:	2781                	sext.w	a5,a5
    800015fe:	079e                	slli	a5,a5,0x7
    80001600:	00008717          	auipc	a4,0x8
    80001604:	b7070713          	addi	a4,a4,-1168 # 80009170 <pid_lock>
    80001608:	97ba                	add	a5,a5,a4
    8000160a:	0b87a703          	lw	a4,184(a5)
    8000160e:	4785                	li	a5,1
    80001610:	06f71763          	bne	a4,a5,8000167e <sched+0xa6>
  if(p->state == RUNNING)
    80001614:	5098                	lw	a4,32(s1)
    80001616:	4791                	li	a5,4
    80001618:	06f70b63          	beq	a4,a5,8000168e <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000161c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001620:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001622:	efb5                	bnez	a5,8000169e <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001624:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001626:	00008917          	auipc	s2,0x8
    8000162a:	b4a90913          	addi	s2,s2,-1206 # 80009170 <pid_lock>
    8000162e:	2781                	sext.w	a5,a5
    80001630:	079e                	slli	a5,a5,0x7
    80001632:	97ca                	add	a5,a5,s2
    80001634:	0bc7a983          	lw	s3,188(a5)
    80001638:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000163a:	2781                	sext.w	a5,a5
    8000163c:	079e                	slli	a5,a5,0x7
    8000163e:	00008597          	auipc	a1,0x8
    80001642:	b7a58593          	addi	a1,a1,-1158 # 800091b8 <cpus+0x8>
    80001646:	95be                	add	a1,a1,a5
    80001648:	06848513          	addi	a0,s1,104
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	59c080e7          	jalr	1436(ra) # 80001be8 <swtch>
    80001654:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001656:	2781                	sext.w	a5,a5
    80001658:	079e                	slli	a5,a5,0x7
    8000165a:	97ca                	add	a5,a5,s2
    8000165c:	0b37ae23          	sw	s3,188(a5)
}
    80001660:	70a2                	ld	ra,40(sp)
    80001662:	7402                	ld	s0,32(sp)
    80001664:	64e2                	ld	s1,24(sp)
    80001666:	6942                	ld	s2,16(sp)
    80001668:	69a2                	ld	s3,8(sp)
    8000166a:	6145                	addi	sp,sp,48
    8000166c:	8082                	ret
    panic("sched p->lock");
    8000166e:	00007517          	auipc	a0,0x7
    80001672:	b2a50513          	addi	a0,a0,-1238 # 80008198 <etext+0x198>
    80001676:	00005097          	auipc	ra,0x5
    8000167a:	b46080e7          	jalr	-1210(ra) # 800061bc <panic>
    panic("sched locks");
    8000167e:	00007517          	auipc	a0,0x7
    80001682:	b2a50513          	addi	a0,a0,-1238 # 800081a8 <etext+0x1a8>
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	b36080e7          	jalr	-1226(ra) # 800061bc <panic>
    panic("sched running");
    8000168e:	00007517          	auipc	a0,0x7
    80001692:	b2a50513          	addi	a0,a0,-1238 # 800081b8 <etext+0x1b8>
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	b26080e7          	jalr	-1242(ra) # 800061bc <panic>
    panic("sched interruptible");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	b2a50513          	addi	a0,a0,-1238 # 800081c8 <etext+0x1c8>
    800016a6:	00005097          	auipc	ra,0x5
    800016aa:	b16080e7          	jalr	-1258(ra) # 800061bc <panic>

00000000800016ae <yield>:
{
    800016ae:	1101                	addi	sp,sp,-32
    800016b0:	ec06                	sd	ra,24(sp)
    800016b2:	e822                	sd	s0,16(sp)
    800016b4:	e426                	sd	s1,8(sp)
    800016b6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016b8:	00000097          	auipc	ra,0x0
    800016bc:	976080e7          	jalr	-1674(ra) # 8000102e <myproc>
    800016c0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	02e080e7          	jalr	46(ra) # 800066f0 <acquire>
  p->state = RUNNABLE;
    800016ca:	478d                	li	a5,3
    800016cc:	d09c                	sw	a5,32(s1)
  sched();
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	f0a080e7          	jalr	-246(ra) # 800015d8 <sched>
  release(&p->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	0e8080e7          	jalr	232(ra) # 800067c0 <release>
}
    800016e0:	60e2                	ld	ra,24(sp)
    800016e2:	6442                	ld	s0,16(sp)
    800016e4:	64a2                	ld	s1,8(sp)
    800016e6:	6105                	addi	sp,sp,32
    800016e8:	8082                	ret

00000000800016ea <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800016ea:	7179                	addi	sp,sp,-48
    800016ec:	f406                	sd	ra,40(sp)
    800016ee:	f022                	sd	s0,32(sp)
    800016f0:	ec26                	sd	s1,24(sp)
    800016f2:	e84a                	sd	s2,16(sp)
    800016f4:	e44e                	sd	s3,8(sp)
    800016f6:	1800                	addi	s0,sp,48
    800016f8:	89aa                	mv	s3,a0
    800016fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	932080e7          	jalr	-1742(ra) # 8000102e <myproc>
    80001704:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	fea080e7          	jalr	-22(ra) # 800066f0 <acquire>
  release(lk);
    8000170e:	854a                	mv	a0,s2
    80001710:	00005097          	auipc	ra,0x5
    80001714:	0b0080e7          	jalr	176(ra) # 800067c0 <release>

  // Go to sleep.
  p->chan = chan;
    80001718:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    8000171c:	4789                	li	a5,2
    8000171e:	d09c                	sw	a5,32(s1)

  sched();
    80001720:	00000097          	auipc	ra,0x0
    80001724:	eb8080e7          	jalr	-328(ra) # 800015d8 <sched>

  // Tidy up.
  p->chan = 0;
    80001728:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000172c:	8526                	mv	a0,s1
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	092080e7          	jalr	146(ra) # 800067c0 <release>
  acquire(lk);
    80001736:	854a                	mv	a0,s2
    80001738:	00005097          	auipc	ra,0x5
    8000173c:	fb8080e7          	jalr	-72(ra) # 800066f0 <acquire>
}
    80001740:	70a2                	ld	ra,40(sp)
    80001742:	7402                	ld	s0,32(sp)
    80001744:	64e2                	ld	s1,24(sp)
    80001746:	6942                	ld	s2,16(sp)
    80001748:	69a2                	ld	s3,8(sp)
    8000174a:	6145                	addi	sp,sp,48
    8000174c:	8082                	ret

000000008000174e <wait>:
{
    8000174e:	715d                	addi	sp,sp,-80
    80001750:	e486                	sd	ra,72(sp)
    80001752:	e0a2                	sd	s0,64(sp)
    80001754:	fc26                	sd	s1,56(sp)
    80001756:	f84a                	sd	s2,48(sp)
    80001758:	f44e                	sd	s3,40(sp)
    8000175a:	f052                	sd	s4,32(sp)
    8000175c:	ec56                	sd	s5,24(sp)
    8000175e:	e85a                	sd	s6,16(sp)
    80001760:	e45e                	sd	s7,8(sp)
    80001762:	e062                	sd	s8,0(sp)
    80001764:	0880                	addi	s0,sp,80
    80001766:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001768:	00000097          	auipc	ra,0x0
    8000176c:	8c6080e7          	jalr	-1850(ra) # 8000102e <myproc>
    80001770:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001772:	00008517          	auipc	a0,0x8
    80001776:	a1e50513          	addi	a0,a0,-1506 # 80009190 <wait_lock>
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	f76080e7          	jalr	-138(ra) # 800066f0 <acquire>
    havekids = 0;
    80001782:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80001784:	4a15                	li	s4,5
    for(np = proc; np < &proc[NPROC]; np++){
    80001786:	0000e997          	auipc	s3,0xe
    8000178a:	a2a98993          	addi	s3,s3,-1494 # 8000f1b0 <tickslock>
        havekids = 1;
    8000178e:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001790:	00008c17          	auipc	s8,0x8
    80001794:	a00c0c13          	addi	s8,s8,-1536 # 80009190 <wait_lock>
    havekids = 0;
    80001798:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000179a:	00008497          	auipc	s1,0x8
    8000179e:	e1648493          	addi	s1,s1,-490 # 800095b0 <proc>
    800017a2:	a0bd                	j	80001810 <wait+0xc2>
          pid = np->pid;
    800017a4:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017a8:	000b0e63          	beqz	s6,800017c4 <wait+0x76>
    800017ac:	4691                	li	a3,4
    800017ae:	03448613          	addi	a2,s1,52
    800017b2:	85da                	mv	a1,s6
    800017b4:	05893503          	ld	a0,88(s2)
    800017b8:	fffff097          	auipc	ra,0xfffff
    800017bc:	538080e7          	jalr	1336(ra) # 80000cf0 <copyout>
    800017c0:	02054563          	bltz	a0,800017ea <wait+0x9c>
          freeproc(np);
    800017c4:	8526                	mv	a0,s1
    800017c6:	00000097          	auipc	ra,0x0
    800017ca:	a1a080e7          	jalr	-1510(ra) # 800011e0 <freeproc>
          release(&np->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	00005097          	auipc	ra,0x5
    800017d4:	ff0080e7          	jalr	-16(ra) # 800067c0 <release>
          release(&wait_lock);
    800017d8:	00008517          	auipc	a0,0x8
    800017dc:	9b850513          	addi	a0,a0,-1608 # 80009190 <wait_lock>
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	fe0080e7          	jalr	-32(ra) # 800067c0 <release>
          return pid;
    800017e8:	a09d                	j	8000184e <wait+0x100>
            release(&np->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	fd4080e7          	jalr	-44(ra) # 800067c0 <release>
            release(&wait_lock);
    800017f4:	00008517          	auipc	a0,0x8
    800017f8:	99c50513          	addi	a0,a0,-1636 # 80009190 <wait_lock>
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	fc4080e7          	jalr	-60(ra) # 800067c0 <release>
            return -1;
    80001804:	59fd                	li	s3,-1
    80001806:	a0a1                	j	8000184e <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80001808:	17048493          	addi	s1,s1,368
    8000180c:	03348463          	beq	s1,s3,80001834 <wait+0xe6>
      if(np->parent == p){
    80001810:	60bc                	ld	a5,64(s1)
    80001812:	ff279be3          	bne	a5,s2,80001808 <wait+0xba>
        acquire(&np->lock);
    80001816:	8526                	mv	a0,s1
    80001818:	00005097          	auipc	ra,0x5
    8000181c:	ed8080e7          	jalr	-296(ra) # 800066f0 <acquire>
        if(np->state == ZOMBIE){
    80001820:	509c                	lw	a5,32(s1)
    80001822:	f94781e3          	beq	a5,s4,800017a4 <wait+0x56>
        release(&np->lock);
    80001826:	8526                	mv	a0,s1
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	f98080e7          	jalr	-104(ra) # 800067c0 <release>
        havekids = 1;
    80001830:	8756                	mv	a4,s5
    80001832:	bfd9                	j	80001808 <wait+0xba>
    if(!havekids || p->killed){
    80001834:	c701                	beqz	a4,8000183c <wait+0xee>
    80001836:	03092783          	lw	a5,48(s2)
    8000183a:	c79d                	beqz	a5,80001868 <wait+0x11a>
      release(&wait_lock);
    8000183c:	00008517          	auipc	a0,0x8
    80001840:	95450513          	addi	a0,a0,-1708 # 80009190 <wait_lock>
    80001844:	00005097          	auipc	ra,0x5
    80001848:	f7c080e7          	jalr	-132(ra) # 800067c0 <release>
      return -1;
    8000184c:	59fd                	li	s3,-1
}
    8000184e:	854e                	mv	a0,s3
    80001850:	60a6                	ld	ra,72(sp)
    80001852:	6406                	ld	s0,64(sp)
    80001854:	74e2                	ld	s1,56(sp)
    80001856:	7942                	ld	s2,48(sp)
    80001858:	79a2                	ld	s3,40(sp)
    8000185a:	7a02                	ld	s4,32(sp)
    8000185c:	6ae2                	ld	s5,24(sp)
    8000185e:	6b42                	ld	s6,16(sp)
    80001860:	6ba2                	ld	s7,8(sp)
    80001862:	6c02                	ld	s8,0(sp)
    80001864:	6161                	addi	sp,sp,80
    80001866:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001868:	85e2                	mv	a1,s8
    8000186a:	854a                	mv	a0,s2
    8000186c:	00000097          	auipc	ra,0x0
    80001870:	e7e080e7          	jalr	-386(ra) # 800016ea <sleep>
    havekids = 0;
    80001874:	b715                	j	80001798 <wait+0x4a>

0000000080001876 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001876:	7139                	addi	sp,sp,-64
    80001878:	fc06                	sd	ra,56(sp)
    8000187a:	f822                	sd	s0,48(sp)
    8000187c:	f426                	sd	s1,40(sp)
    8000187e:	f04a                	sd	s2,32(sp)
    80001880:	ec4e                	sd	s3,24(sp)
    80001882:	e852                	sd	s4,16(sp)
    80001884:	e456                	sd	s5,8(sp)
    80001886:	0080                	addi	s0,sp,64
    80001888:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000188a:	00008497          	auipc	s1,0x8
    8000188e:	d2648493          	addi	s1,s1,-730 # 800095b0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001892:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001894:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001896:	0000e917          	auipc	s2,0xe
    8000189a:	91a90913          	addi	s2,s2,-1766 # 8000f1b0 <tickslock>
    8000189e:	a821                	j	800018b6 <wakeup+0x40>
        p->state = RUNNABLE;
    800018a0:	0354a023          	sw	s5,32(s1)
      }
      release(&p->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	f1a080e7          	jalr	-230(ra) # 800067c0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ae:	17048493          	addi	s1,s1,368
    800018b2:	03248463          	beq	s1,s2,800018da <wakeup+0x64>
    if(p != myproc()){
    800018b6:	fffff097          	auipc	ra,0xfffff
    800018ba:	778080e7          	jalr	1912(ra) # 8000102e <myproc>
    800018be:	fea488e3          	beq	s1,a0,800018ae <wakeup+0x38>
      acquire(&p->lock);
    800018c2:	8526                	mv	a0,s1
    800018c4:	00005097          	auipc	ra,0x5
    800018c8:	e2c080e7          	jalr	-468(ra) # 800066f0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018cc:	509c                	lw	a5,32(s1)
    800018ce:	fd379be3          	bne	a5,s3,800018a4 <wakeup+0x2e>
    800018d2:	749c                	ld	a5,40(s1)
    800018d4:	fd4798e3          	bne	a5,s4,800018a4 <wakeup+0x2e>
    800018d8:	b7e1                	j	800018a0 <wakeup+0x2a>
    }
  }
}
    800018da:	70e2                	ld	ra,56(sp)
    800018dc:	7442                	ld	s0,48(sp)
    800018de:	74a2                	ld	s1,40(sp)
    800018e0:	7902                	ld	s2,32(sp)
    800018e2:	69e2                	ld	s3,24(sp)
    800018e4:	6a42                	ld	s4,16(sp)
    800018e6:	6aa2                	ld	s5,8(sp)
    800018e8:	6121                	addi	sp,sp,64
    800018ea:	8082                	ret

00000000800018ec <reparent>:
{
    800018ec:	7179                	addi	sp,sp,-48
    800018ee:	f406                	sd	ra,40(sp)
    800018f0:	f022                	sd	s0,32(sp)
    800018f2:	ec26                	sd	s1,24(sp)
    800018f4:	e84a                	sd	s2,16(sp)
    800018f6:	e44e                	sd	s3,8(sp)
    800018f8:	e052                	sd	s4,0(sp)
    800018fa:	1800                	addi	s0,sp,48
    800018fc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800018fe:	00008497          	auipc	s1,0x8
    80001902:	cb248493          	addi	s1,s1,-846 # 800095b0 <proc>
      pp->parent = initproc;
    80001906:	00007a17          	auipc	s4,0x7
    8000190a:	70aa0a13          	addi	s4,s4,1802 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000190e:	0000e997          	auipc	s3,0xe
    80001912:	8a298993          	addi	s3,s3,-1886 # 8000f1b0 <tickslock>
    80001916:	a029                	j	80001920 <reparent+0x34>
    80001918:	17048493          	addi	s1,s1,368
    8000191c:	01348d63          	beq	s1,s3,80001936 <reparent+0x4a>
    if(pp->parent == p){
    80001920:	60bc                	ld	a5,64(s1)
    80001922:	ff279be3          	bne	a5,s2,80001918 <reparent+0x2c>
      pp->parent = initproc;
    80001926:	000a3503          	ld	a0,0(s4)
    8000192a:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000192c:	00000097          	auipc	ra,0x0
    80001930:	f4a080e7          	jalr	-182(ra) # 80001876 <wakeup>
    80001934:	b7d5                	j	80001918 <reparent+0x2c>
}
    80001936:	70a2                	ld	ra,40(sp)
    80001938:	7402                	ld	s0,32(sp)
    8000193a:	64e2                	ld	s1,24(sp)
    8000193c:	6942                	ld	s2,16(sp)
    8000193e:	69a2                	ld	s3,8(sp)
    80001940:	6a02                	ld	s4,0(sp)
    80001942:	6145                	addi	sp,sp,48
    80001944:	8082                	ret

0000000080001946 <exit>:
{
    80001946:	7179                	addi	sp,sp,-48
    80001948:	f406                	sd	ra,40(sp)
    8000194a:	f022                	sd	s0,32(sp)
    8000194c:	ec26                	sd	s1,24(sp)
    8000194e:	e84a                	sd	s2,16(sp)
    80001950:	e44e                	sd	s3,8(sp)
    80001952:	e052                	sd	s4,0(sp)
    80001954:	1800                	addi	s0,sp,48
    80001956:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	6d6080e7          	jalr	1750(ra) # 8000102e <myproc>
    80001960:	89aa                	mv	s3,a0
  if(p == initproc)
    80001962:	00007797          	auipc	a5,0x7
    80001966:	6ae7b783          	ld	a5,1710(a5) # 80009010 <initproc>
    8000196a:	0d850493          	addi	s1,a0,216
    8000196e:	15850913          	addi	s2,a0,344
    80001972:	02a79363          	bne	a5,a0,80001998 <exit+0x52>
    panic("init exiting");
    80001976:	00007517          	auipc	a0,0x7
    8000197a:	86a50513          	addi	a0,a0,-1942 # 800081e0 <etext+0x1e0>
    8000197e:	00005097          	auipc	ra,0x5
    80001982:	83e080e7          	jalr	-1986(ra) # 800061bc <panic>
      fileclose(f);
    80001986:	00002097          	auipc	ra,0x2
    8000198a:	2e2080e7          	jalr	738(ra) # 80003c68 <fileclose>
      p->ofile[fd] = 0;
    8000198e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001992:	04a1                	addi	s1,s1,8
    80001994:	01248563          	beq	s1,s2,8000199e <exit+0x58>
    if(p->ofile[fd]){
    80001998:	6088                	ld	a0,0(s1)
    8000199a:	f575                	bnez	a0,80001986 <exit+0x40>
    8000199c:	bfdd                	j	80001992 <exit+0x4c>
  begin_op();
    8000199e:	00002097          	auipc	ra,0x2
    800019a2:	dfe080e7          	jalr	-514(ra) # 8000379c <begin_op>
  iput(p->cwd);
    800019a6:	1589b503          	ld	a0,344(s3)
    800019aa:	00001097          	auipc	ra,0x1
    800019ae:	5da080e7          	jalr	1498(ra) # 80002f84 <iput>
  end_op();
    800019b2:	00002097          	auipc	ra,0x2
    800019b6:	e6a080e7          	jalr	-406(ra) # 8000381c <end_op>
  p->cwd = 0;
    800019ba:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019be:	00007497          	auipc	s1,0x7
    800019c2:	7d248493          	addi	s1,s1,2002 # 80009190 <wait_lock>
    800019c6:	8526                	mv	a0,s1
    800019c8:	00005097          	auipc	ra,0x5
    800019cc:	d28080e7          	jalr	-728(ra) # 800066f0 <acquire>
  reparent(p);
    800019d0:	854e                	mv	a0,s3
    800019d2:	00000097          	auipc	ra,0x0
    800019d6:	f1a080e7          	jalr	-230(ra) # 800018ec <reparent>
  wakeup(p->parent);
    800019da:	0409b503          	ld	a0,64(s3)
    800019de:	00000097          	auipc	ra,0x0
    800019e2:	e98080e7          	jalr	-360(ra) # 80001876 <wakeup>
  acquire(&p->lock);
    800019e6:	854e                	mv	a0,s3
    800019e8:	00005097          	auipc	ra,0x5
    800019ec:	d08080e7          	jalr	-760(ra) # 800066f0 <acquire>
  p->xstate = status;
    800019f0:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    800019f4:	4795                	li	a5,5
    800019f6:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    800019fa:	8526                	mv	a0,s1
    800019fc:	00005097          	auipc	ra,0x5
    80001a00:	dc4080e7          	jalr	-572(ra) # 800067c0 <release>
  sched();
    80001a04:	00000097          	auipc	ra,0x0
    80001a08:	bd4080e7          	jalr	-1068(ra) # 800015d8 <sched>
  panic("zombie exit");
    80001a0c:	00006517          	auipc	a0,0x6
    80001a10:	7e450513          	addi	a0,a0,2020 # 800081f0 <etext+0x1f0>
    80001a14:	00004097          	auipc	ra,0x4
    80001a18:	7a8080e7          	jalr	1960(ra) # 800061bc <panic>

0000000080001a1c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a1c:	7179                	addi	sp,sp,-48
    80001a1e:	f406                	sd	ra,40(sp)
    80001a20:	f022                	sd	s0,32(sp)
    80001a22:	ec26                	sd	s1,24(sp)
    80001a24:	e84a                	sd	s2,16(sp)
    80001a26:	e44e                	sd	s3,8(sp)
    80001a28:	1800                	addi	s0,sp,48
    80001a2a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a2c:	00008497          	auipc	s1,0x8
    80001a30:	b8448493          	addi	s1,s1,-1148 # 800095b0 <proc>
    80001a34:	0000d997          	auipc	s3,0xd
    80001a38:	77c98993          	addi	s3,s3,1916 # 8000f1b0 <tickslock>
    acquire(&p->lock);
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	00005097          	auipc	ra,0x5
    80001a42:	cb2080e7          	jalr	-846(ra) # 800066f0 <acquire>
    if(p->pid == pid){
    80001a46:	5c9c                	lw	a5,56(s1)
    80001a48:	01278d63          	beq	a5,s2,80001a62 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	00005097          	auipc	ra,0x5
    80001a52:	d72080e7          	jalr	-654(ra) # 800067c0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a56:	17048493          	addi	s1,s1,368
    80001a5a:	ff3491e3          	bne	s1,s3,80001a3c <kill+0x20>
  }
  return -1;
    80001a5e:	557d                	li	a0,-1
    80001a60:	a829                	j	80001a7a <kill+0x5e>
      p->killed = 1;
    80001a62:	4785                	li	a5,1
    80001a64:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80001a66:	5098                	lw	a4,32(s1)
    80001a68:	4789                	li	a5,2
    80001a6a:	00f70f63          	beq	a4,a5,80001a88 <kill+0x6c>
      release(&p->lock);
    80001a6e:	8526                	mv	a0,s1
    80001a70:	00005097          	auipc	ra,0x5
    80001a74:	d50080e7          	jalr	-688(ra) # 800067c0 <release>
      return 0;
    80001a78:	4501                	li	a0,0
}
    80001a7a:	70a2                	ld	ra,40(sp)
    80001a7c:	7402                	ld	s0,32(sp)
    80001a7e:	64e2                	ld	s1,24(sp)
    80001a80:	6942                	ld	s2,16(sp)
    80001a82:	69a2                	ld	s3,8(sp)
    80001a84:	6145                	addi	sp,sp,48
    80001a86:	8082                	ret
        p->state = RUNNABLE;
    80001a88:	478d                	li	a5,3
    80001a8a:	d09c                	sw	a5,32(s1)
    80001a8c:	b7cd                	j	80001a6e <kill+0x52>

0000000080001a8e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a8e:	7179                	addi	sp,sp,-48
    80001a90:	f406                	sd	ra,40(sp)
    80001a92:	f022                	sd	s0,32(sp)
    80001a94:	ec26                	sd	s1,24(sp)
    80001a96:	e84a                	sd	s2,16(sp)
    80001a98:	e44e                	sd	s3,8(sp)
    80001a9a:	e052                	sd	s4,0(sp)
    80001a9c:	1800                	addi	s0,sp,48
    80001a9e:	84aa                	mv	s1,a0
    80001aa0:	892e                	mv	s2,a1
    80001aa2:	89b2                	mv	s3,a2
    80001aa4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aa6:	fffff097          	auipc	ra,0xfffff
    80001aaa:	588080e7          	jalr	1416(ra) # 8000102e <myproc>
  if(user_dst){
    80001aae:	c08d                	beqz	s1,80001ad0 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ab0:	86d2                	mv	a3,s4
    80001ab2:	864e                	mv	a2,s3
    80001ab4:	85ca                	mv	a1,s2
    80001ab6:	6d28                	ld	a0,88(a0)
    80001ab8:	fffff097          	auipc	ra,0xfffff
    80001abc:	238080e7          	jalr	568(ra) # 80000cf0 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ac0:	70a2                	ld	ra,40(sp)
    80001ac2:	7402                	ld	s0,32(sp)
    80001ac4:	64e2                	ld	s1,24(sp)
    80001ac6:	6942                	ld	s2,16(sp)
    80001ac8:	69a2                	ld	s3,8(sp)
    80001aca:	6a02                	ld	s4,0(sp)
    80001acc:	6145                	addi	sp,sp,48
    80001ace:	8082                	ret
    memmove((char *)dst, src, len);
    80001ad0:	000a061b          	sext.w	a2,s4
    80001ad4:	85ce                	mv	a1,s3
    80001ad6:	854a                	mv	a0,s2
    80001ad8:	fffff097          	auipc	ra,0xfffff
    80001adc:	8d6080e7          	jalr	-1834(ra) # 800003ae <memmove>
    return 0;
    80001ae0:	8526                	mv	a0,s1
    80001ae2:	bff9                	j	80001ac0 <either_copyout+0x32>

0000000080001ae4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ae4:	7179                	addi	sp,sp,-48
    80001ae6:	f406                	sd	ra,40(sp)
    80001ae8:	f022                	sd	s0,32(sp)
    80001aea:	ec26                	sd	s1,24(sp)
    80001aec:	e84a                	sd	s2,16(sp)
    80001aee:	e44e                	sd	s3,8(sp)
    80001af0:	e052                	sd	s4,0(sp)
    80001af2:	1800                	addi	s0,sp,48
    80001af4:	892a                	mv	s2,a0
    80001af6:	84ae                	mv	s1,a1
    80001af8:	89b2                	mv	s3,a2
    80001afa:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	532080e7          	jalr	1330(ra) # 8000102e <myproc>
  if(user_src){
    80001b04:	c08d                	beqz	s1,80001b26 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b06:	86d2                	mv	a3,s4
    80001b08:	864e                	mv	a2,s3
    80001b0a:	85ca                	mv	a1,s2
    80001b0c:	6d28                	ld	a0,88(a0)
    80001b0e:	fffff097          	auipc	ra,0xfffff
    80001b12:	26e080e7          	jalr	622(ra) # 80000d7c <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b16:	70a2                	ld	ra,40(sp)
    80001b18:	7402                	ld	s0,32(sp)
    80001b1a:	64e2                	ld	s1,24(sp)
    80001b1c:	6942                	ld	s2,16(sp)
    80001b1e:	69a2                	ld	s3,8(sp)
    80001b20:	6a02                	ld	s4,0(sp)
    80001b22:	6145                	addi	sp,sp,48
    80001b24:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b26:	000a061b          	sext.w	a2,s4
    80001b2a:	85ce                	mv	a1,s3
    80001b2c:	854a                	mv	a0,s2
    80001b2e:	fffff097          	auipc	ra,0xfffff
    80001b32:	880080e7          	jalr	-1920(ra) # 800003ae <memmove>
    return 0;
    80001b36:	8526                	mv	a0,s1
    80001b38:	bff9                	j	80001b16 <either_copyin+0x32>

0000000080001b3a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b3a:	715d                	addi	sp,sp,-80
    80001b3c:	e486                	sd	ra,72(sp)
    80001b3e:	e0a2                	sd	s0,64(sp)
    80001b40:	fc26                	sd	s1,56(sp)
    80001b42:	f84a                	sd	s2,48(sp)
    80001b44:	f44e                	sd	s3,40(sp)
    80001b46:	f052                	sd	s4,32(sp)
    80001b48:	ec56                	sd	s5,24(sp)
    80001b4a:	e85a                	sd	s6,16(sp)
    80001b4c:	e45e                	sd	s7,8(sp)
    80001b4e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b50:	00007517          	auipc	a0,0x7
    80001b54:	d1850513          	addi	a0,a0,-744 # 80008868 <digits+0x88>
    80001b58:	00004097          	auipc	ra,0x4
    80001b5c:	6ae080e7          	jalr	1710(ra) # 80006206 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b60:	00008497          	auipc	s1,0x8
    80001b64:	bb048493          	addi	s1,s1,-1104 # 80009710 <proc+0x160>
    80001b68:	0000d917          	auipc	s2,0xd
    80001b6c:	7a890913          	addi	s2,s2,1960 # 8000f310 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b70:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b72:	00006997          	auipc	s3,0x6
    80001b76:	68e98993          	addi	s3,s3,1678 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001b7a:	00006a97          	auipc	s5,0x6
    80001b7e:	68ea8a93          	addi	s5,s5,1678 # 80008208 <etext+0x208>
    printf("\n");
    80001b82:	00007a17          	auipc	s4,0x7
    80001b86:	ce6a0a13          	addi	s4,s4,-794 # 80008868 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b8a:	00006b97          	auipc	s7,0x6
    80001b8e:	6b6b8b93          	addi	s7,s7,1718 # 80008240 <states.1725>
    80001b92:	a00d                	j	80001bb4 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b94:	ed86a583          	lw	a1,-296(a3)
    80001b98:	8556                	mv	a0,s5
    80001b9a:	00004097          	auipc	ra,0x4
    80001b9e:	66c080e7          	jalr	1644(ra) # 80006206 <printf>
    printf("\n");
    80001ba2:	8552                	mv	a0,s4
    80001ba4:	00004097          	auipc	ra,0x4
    80001ba8:	662080e7          	jalr	1634(ra) # 80006206 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bac:	17048493          	addi	s1,s1,368
    80001bb0:	03248163          	beq	s1,s2,80001bd2 <procdump+0x98>
    if(p->state == UNUSED)
    80001bb4:	86a6                	mv	a3,s1
    80001bb6:	ec04a783          	lw	a5,-320(s1)
    80001bba:	dbed                	beqz	a5,80001bac <procdump+0x72>
      state = "???";
    80001bbc:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bbe:	fcfb6be3          	bltu	s6,a5,80001b94 <procdump+0x5a>
    80001bc2:	1782                	slli	a5,a5,0x20
    80001bc4:	9381                	srli	a5,a5,0x20
    80001bc6:	078e                	slli	a5,a5,0x3
    80001bc8:	97de                	add	a5,a5,s7
    80001bca:	6390                	ld	a2,0(a5)
    80001bcc:	f661                	bnez	a2,80001b94 <procdump+0x5a>
      state = "???";
    80001bce:	864e                	mv	a2,s3
    80001bd0:	b7d1                	j	80001b94 <procdump+0x5a>
  }
}
    80001bd2:	60a6                	ld	ra,72(sp)
    80001bd4:	6406                	ld	s0,64(sp)
    80001bd6:	74e2                	ld	s1,56(sp)
    80001bd8:	7942                	ld	s2,48(sp)
    80001bda:	79a2                	ld	s3,40(sp)
    80001bdc:	7a02                	ld	s4,32(sp)
    80001bde:	6ae2                	ld	s5,24(sp)
    80001be0:	6b42                	ld	s6,16(sp)
    80001be2:	6ba2                	ld	s7,8(sp)
    80001be4:	6161                	addi	sp,sp,80
    80001be6:	8082                	ret

0000000080001be8 <swtch>:
    80001be8:	00153023          	sd	ra,0(a0)
    80001bec:	00253423          	sd	sp,8(a0)
    80001bf0:	e900                	sd	s0,16(a0)
    80001bf2:	ed04                	sd	s1,24(a0)
    80001bf4:	03253023          	sd	s2,32(a0)
    80001bf8:	03353423          	sd	s3,40(a0)
    80001bfc:	03453823          	sd	s4,48(a0)
    80001c00:	03553c23          	sd	s5,56(a0)
    80001c04:	05653023          	sd	s6,64(a0)
    80001c08:	05753423          	sd	s7,72(a0)
    80001c0c:	05853823          	sd	s8,80(a0)
    80001c10:	05953c23          	sd	s9,88(a0)
    80001c14:	07a53023          	sd	s10,96(a0)
    80001c18:	07b53423          	sd	s11,104(a0)
    80001c1c:	0005b083          	ld	ra,0(a1)
    80001c20:	0085b103          	ld	sp,8(a1)
    80001c24:	6980                	ld	s0,16(a1)
    80001c26:	6d84                	ld	s1,24(a1)
    80001c28:	0205b903          	ld	s2,32(a1)
    80001c2c:	0285b983          	ld	s3,40(a1)
    80001c30:	0305ba03          	ld	s4,48(a1)
    80001c34:	0385ba83          	ld	s5,56(a1)
    80001c38:	0405bb03          	ld	s6,64(a1)
    80001c3c:	0485bb83          	ld	s7,72(a1)
    80001c40:	0505bc03          	ld	s8,80(a1)
    80001c44:	0585bc83          	ld	s9,88(a1)
    80001c48:	0605bd03          	ld	s10,96(a1)
    80001c4c:	0685bd83          	ld	s11,104(a1)
    80001c50:	8082                	ret

0000000080001c52 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c52:	1141                	addi	sp,sp,-16
    80001c54:	e406                	sd	ra,8(sp)
    80001c56:	e022                	sd	s0,0(sp)
    80001c58:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c5a:	00006597          	auipc	a1,0x6
    80001c5e:	61658593          	addi	a1,a1,1558 # 80008270 <states.1725+0x30>
    80001c62:	0000d517          	auipc	a0,0xd
    80001c66:	54e50513          	addi	a0,a0,1358 # 8000f1b0 <tickslock>
    80001c6a:	00005097          	auipc	ra,0x5
    80001c6e:	c02080e7          	jalr	-1022(ra) # 8000686c <initlock>
}
    80001c72:	60a2                	ld	ra,8(sp)
    80001c74:	6402                	ld	s0,0(sp)
    80001c76:	0141                	addi	sp,sp,16
    80001c78:	8082                	ret

0000000080001c7a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c7a:	1141                	addi	sp,sp,-16
    80001c7c:	e422                	sd	s0,8(sp)
    80001c7e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c80:	00003797          	auipc	a5,0x3
    80001c84:	61078793          	addi	a5,a5,1552 # 80005290 <kernelvec>
    80001c88:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c8c:	6422                	ld	s0,8(sp)
    80001c8e:	0141                	addi	sp,sp,16
    80001c90:	8082                	ret

0000000080001c92 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c92:	1141                	addi	sp,sp,-16
    80001c94:	e406                	sd	ra,8(sp)
    80001c96:	e022                	sd	s0,0(sp)
    80001c98:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c9a:	fffff097          	auipc	ra,0xfffff
    80001c9e:	394080e7          	jalr	916(ra) # 8000102e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ca6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ca8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cac:	00005617          	auipc	a2,0x5
    80001cb0:	35460613          	addi	a2,a2,852 # 80007000 <_trampoline>
    80001cb4:	00005697          	auipc	a3,0x5
    80001cb8:	34c68693          	addi	a3,a3,844 # 80007000 <_trampoline>
    80001cbc:	8e91                	sub	a3,a3,a2
    80001cbe:	040007b7          	lui	a5,0x4000
    80001cc2:	17fd                	addi	a5,a5,-1
    80001cc4:	07b2                	slli	a5,a5,0xc
    80001cc6:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc8:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ccc:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cce:	180026f3          	csrr	a3,satp
    80001cd2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cd4:	7138                	ld	a4,96(a0)
    80001cd6:	6534                	ld	a3,72(a0)
    80001cd8:	6585                	lui	a1,0x1
    80001cda:	96ae                	add	a3,a3,a1
    80001cdc:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cde:	7138                	ld	a4,96(a0)
    80001ce0:	00000697          	auipc	a3,0x0
    80001ce4:	13868693          	addi	a3,a3,312 # 80001e18 <usertrap>
    80001ce8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cea:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cec:	8692                	mv	a3,tp
    80001cee:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cf4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cf8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cfc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d00:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d02:	6f18                	ld	a4,24(a4)
    80001d04:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d08:	6d2c                	ld	a1,88(a0)
    80001d0a:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d0c:	00005717          	auipc	a4,0x5
    80001d10:	38470713          	addi	a4,a4,900 # 80007090 <userret>
    80001d14:	8f11                	sub	a4,a4,a2
    80001d16:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d18:	577d                	li	a4,-1
    80001d1a:	177e                	slli	a4,a4,0x3f
    80001d1c:	8dd9                	or	a1,a1,a4
    80001d1e:	02000537          	lui	a0,0x2000
    80001d22:	157d                	addi	a0,a0,-1
    80001d24:	0536                	slli	a0,a0,0xd
    80001d26:	9782                	jalr	a5
}
    80001d28:	60a2                	ld	ra,8(sp)
    80001d2a:	6402                	ld	s0,0(sp)
    80001d2c:	0141                	addi	sp,sp,16
    80001d2e:	8082                	ret

0000000080001d30 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d30:	1101                	addi	sp,sp,-32
    80001d32:	ec06                	sd	ra,24(sp)
    80001d34:	e822                	sd	s0,16(sp)
    80001d36:	e426                	sd	s1,8(sp)
    80001d38:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d3a:	0000d497          	auipc	s1,0xd
    80001d3e:	47648493          	addi	s1,s1,1142 # 8000f1b0 <tickslock>
    80001d42:	8526                	mv	a0,s1
    80001d44:	00005097          	auipc	ra,0x5
    80001d48:	9ac080e7          	jalr	-1620(ra) # 800066f0 <acquire>
  ticks++;
    80001d4c:	00007517          	auipc	a0,0x7
    80001d50:	2cc50513          	addi	a0,a0,716 # 80009018 <ticks>
    80001d54:	411c                	lw	a5,0(a0)
    80001d56:	2785                	addiw	a5,a5,1
    80001d58:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	b1c080e7          	jalr	-1252(ra) # 80001876 <wakeup>
  release(&tickslock);
    80001d62:	8526                	mv	a0,s1
    80001d64:	00005097          	auipc	ra,0x5
    80001d68:	a5c080e7          	jalr	-1444(ra) # 800067c0 <release>
}
    80001d6c:	60e2                	ld	ra,24(sp)
    80001d6e:	6442                	ld	s0,16(sp)
    80001d70:	64a2                	ld	s1,8(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret

0000000080001d76 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d76:	1101                	addi	sp,sp,-32
    80001d78:	ec06                	sd	ra,24(sp)
    80001d7a:	e822                	sd	s0,16(sp)
    80001d7c:	e426                	sd	s1,8(sp)
    80001d7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d80:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d84:	00074d63          	bltz	a4,80001d9e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d88:	57fd                	li	a5,-1
    80001d8a:	17fe                	slli	a5,a5,0x3f
    80001d8c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d8e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d90:	06f70363          	beq	a4,a5,80001df6 <devintr+0x80>
  }
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6105                	addi	sp,sp,32
    80001d9c:	8082                	ret
     (scause & 0xff) == 9){
    80001d9e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001da2:	46a5                	li	a3,9
    80001da4:	fed792e3          	bne	a5,a3,80001d88 <devintr+0x12>
    int irq = plic_claim();
    80001da8:	00003097          	auipc	ra,0x3
    80001dac:	5f0080e7          	jalr	1520(ra) # 80005398 <plic_claim>
    80001db0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001db2:	47a9                	li	a5,10
    80001db4:	02f50763          	beq	a0,a5,80001de2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001db8:	4785                	li	a5,1
    80001dba:	02f50963          	beq	a0,a5,80001dec <devintr+0x76>
    return 1;
    80001dbe:	4505                	li	a0,1
    } else if(irq){
    80001dc0:	d8f1                	beqz	s1,80001d94 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dc2:	85a6                	mv	a1,s1
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	4b450513          	addi	a0,a0,1204 # 80008278 <states.1725+0x38>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	43a080e7          	jalr	1082(ra) # 80006206 <printf>
      plic_complete(irq);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00003097          	auipc	ra,0x3
    80001dda:	5e6080e7          	jalr	1510(ra) # 800053bc <plic_complete>
    return 1;
    80001dde:	4505                	li	a0,1
    80001de0:	bf55                	j	80001d94 <devintr+0x1e>
      uartintr();
    80001de2:	00005097          	auipc	ra,0x5
    80001de6:	844080e7          	jalr	-1980(ra) # 80006626 <uartintr>
    80001dea:	b7ed                	j	80001dd4 <devintr+0x5e>
      virtio_disk_intr();
    80001dec:	00004097          	auipc	ra,0x4
    80001df0:	ab0080e7          	jalr	-1360(ra) # 8000589c <virtio_disk_intr>
    80001df4:	b7c5                	j	80001dd4 <devintr+0x5e>
    if(cpuid() == 0){
    80001df6:	fffff097          	auipc	ra,0xfffff
    80001dfa:	20c080e7          	jalr	524(ra) # 80001002 <cpuid>
    80001dfe:	c901                	beqz	a0,80001e0e <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e00:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e04:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e06:	14479073          	csrw	sip,a5
    return 2;
    80001e0a:	4509                	li	a0,2
    80001e0c:	b761                	j	80001d94 <devintr+0x1e>
      clockintr();
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	f22080e7          	jalr	-222(ra) # 80001d30 <clockintr>
    80001e16:	b7ed                	j	80001e00 <devintr+0x8a>

0000000080001e18 <usertrap>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	e04a                	sd	s2,0(sp)
    80001e22:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e28:	1007f793          	andi	a5,a5,256
    80001e2c:	e3ad                	bnez	a5,80001e8e <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2e:	00003797          	auipc	a5,0x3
    80001e32:	46278793          	addi	a5,a5,1122 # 80005290 <kernelvec>
    80001e36:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	1f4080e7          	jalr	500(ra) # 8000102e <myproc>
    80001e42:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e44:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e46:	14102773          	csrr	a4,sepc
    80001e4a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e4c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e50:	47a1                	li	a5,8
    80001e52:	04f71c63          	bne	a4,a5,80001eaa <usertrap+0x92>
    if(p->killed)
    80001e56:	591c                	lw	a5,48(a0)
    80001e58:	e3b9                	bnez	a5,80001e9e <usertrap+0x86>
    p->trapframe->epc += 4;
    80001e5a:	70b8                	ld	a4,96(s1)
    80001e5c:	6f1c                	ld	a5,24(a4)
    80001e5e:	0791                	addi	a5,a5,4
    80001e60:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e66:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e6a:	10079073          	csrw	sstatus,a5
    syscall();
    80001e6e:	00000097          	auipc	ra,0x0
    80001e72:	2e0080e7          	jalr	736(ra) # 8000214e <syscall>
  if(p->killed)
    80001e76:	589c                	lw	a5,48(s1)
    80001e78:	ebc1                	bnez	a5,80001f08 <usertrap+0xf0>
  usertrapret();
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	e18080e7          	jalr	-488(ra) # 80001c92 <usertrapret>
}
    80001e82:	60e2                	ld	ra,24(sp)
    80001e84:	6442                	ld	s0,16(sp)
    80001e86:	64a2                	ld	s1,8(sp)
    80001e88:	6902                	ld	s2,0(sp)
    80001e8a:	6105                	addi	sp,sp,32
    80001e8c:	8082                	ret
    panic("usertrap: not from user mode");
    80001e8e:	00006517          	auipc	a0,0x6
    80001e92:	40a50513          	addi	a0,a0,1034 # 80008298 <states.1725+0x58>
    80001e96:	00004097          	auipc	ra,0x4
    80001e9a:	326080e7          	jalr	806(ra) # 800061bc <panic>
      exit(-1);
    80001e9e:	557d                	li	a0,-1
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	aa6080e7          	jalr	-1370(ra) # 80001946 <exit>
    80001ea8:	bf4d                	j	80001e5a <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001eaa:	00000097          	auipc	ra,0x0
    80001eae:	ecc080e7          	jalr	-308(ra) # 80001d76 <devintr>
    80001eb2:	892a                	mv	s2,a0
    80001eb4:	c501                	beqz	a0,80001ebc <usertrap+0xa4>
  if(p->killed)
    80001eb6:	589c                	lw	a5,48(s1)
    80001eb8:	c3a1                	beqz	a5,80001ef8 <usertrap+0xe0>
    80001eba:	a815                	j	80001eee <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ebc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec0:	5c90                	lw	a2,56(s1)
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	3f650513          	addi	a0,a0,1014 # 800082b8 <states.1725+0x78>
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	33c080e7          	jalr	828(ra) # 80006206 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	40e50513          	addi	a0,a0,1038 # 800082e8 <states.1725+0xa8>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	324080e7          	jalr	804(ra) # 80006206 <printf>
    p->killed = 1;
    80001eea:	4785                	li	a5,1
    80001eec:	d89c                	sw	a5,48(s1)
    exit(-1);
    80001eee:	557d                	li	a0,-1
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	a56080e7          	jalr	-1450(ra) # 80001946 <exit>
  if(which_dev == 2)
    80001ef8:	4789                	li	a5,2
    80001efa:	f8f910e3          	bne	s2,a5,80001e7a <usertrap+0x62>
    yield();
    80001efe:	fffff097          	auipc	ra,0xfffff
    80001f02:	7b0080e7          	jalr	1968(ra) # 800016ae <yield>
    80001f06:	bf95                	j	80001e7a <usertrap+0x62>
  int which_dev = 0;
    80001f08:	4901                	li	s2,0
    80001f0a:	b7d5                	j	80001eee <usertrap+0xd6>

0000000080001f0c <kerneltrap>:
{
    80001f0c:	7179                	addi	sp,sp,-48
    80001f0e:	f406                	sd	ra,40(sp)
    80001f10:	f022                	sd	s0,32(sp)
    80001f12:	ec26                	sd	s1,24(sp)
    80001f14:	e84a                	sd	s2,16(sp)
    80001f16:	e44e                	sd	s3,8(sp)
    80001f18:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f1a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f1e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f22:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f26:	1004f793          	andi	a5,s1,256
    80001f2a:	cb85                	beqz	a5,80001f5a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f2c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f30:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f32:	ef85                	bnez	a5,80001f6a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f34:	00000097          	auipc	ra,0x0
    80001f38:	e42080e7          	jalr	-446(ra) # 80001d76 <devintr>
    80001f3c:	cd1d                	beqz	a0,80001f7a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f3e:	4789                	li	a5,2
    80001f40:	06f50a63          	beq	a0,a5,80001fb4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f44:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f48:	10049073          	csrw	sstatus,s1
}
    80001f4c:	70a2                	ld	ra,40(sp)
    80001f4e:	7402                	ld	s0,32(sp)
    80001f50:	64e2                	ld	s1,24(sp)
    80001f52:	6942                	ld	s2,16(sp)
    80001f54:	69a2                	ld	s3,8(sp)
    80001f56:	6145                	addi	sp,sp,48
    80001f58:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f5a:	00006517          	auipc	a0,0x6
    80001f5e:	3ae50513          	addi	a0,a0,942 # 80008308 <states.1725+0xc8>
    80001f62:	00004097          	auipc	ra,0x4
    80001f66:	25a080e7          	jalr	602(ra) # 800061bc <panic>
    panic("kerneltrap: interrupts enabled");
    80001f6a:	00006517          	auipc	a0,0x6
    80001f6e:	3c650513          	addi	a0,a0,966 # 80008330 <states.1725+0xf0>
    80001f72:	00004097          	auipc	ra,0x4
    80001f76:	24a080e7          	jalr	586(ra) # 800061bc <panic>
    printf("scause %p\n", scause);
    80001f7a:	85ce                	mv	a1,s3
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	3d450513          	addi	a0,a0,980 # 80008350 <states.1725+0x110>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	282080e7          	jalr	642(ra) # 80006206 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f90:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f94:	00006517          	auipc	a0,0x6
    80001f98:	3cc50513          	addi	a0,a0,972 # 80008360 <states.1725+0x120>
    80001f9c:	00004097          	auipc	ra,0x4
    80001fa0:	26a080e7          	jalr	618(ra) # 80006206 <printf>
    panic("kerneltrap");
    80001fa4:	00006517          	auipc	a0,0x6
    80001fa8:	3d450513          	addi	a0,a0,980 # 80008378 <states.1725+0x138>
    80001fac:	00004097          	auipc	ra,0x4
    80001fb0:	210080e7          	jalr	528(ra) # 800061bc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	07a080e7          	jalr	122(ra) # 8000102e <myproc>
    80001fbc:	d541                	beqz	a0,80001f44 <kerneltrap+0x38>
    80001fbe:	fffff097          	auipc	ra,0xfffff
    80001fc2:	070080e7          	jalr	112(ra) # 8000102e <myproc>
    80001fc6:	5118                	lw	a4,32(a0)
    80001fc8:	4791                	li	a5,4
    80001fca:	f6f71de3          	bne	a4,a5,80001f44 <kerneltrap+0x38>
    yield();
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	6e0080e7          	jalr	1760(ra) # 800016ae <yield>
    80001fd6:	b7bd                	j	80001f44 <kerneltrap+0x38>

0000000080001fd8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fd8:	1101                	addi	sp,sp,-32
    80001fda:	ec06                	sd	ra,24(sp)
    80001fdc:	e822                	sd	s0,16(sp)
    80001fde:	e426                	sd	s1,8(sp)
    80001fe0:	1000                	addi	s0,sp,32
    80001fe2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fe4:	fffff097          	auipc	ra,0xfffff
    80001fe8:	04a080e7          	jalr	74(ra) # 8000102e <myproc>
  switch (n) {
    80001fec:	4795                	li	a5,5
    80001fee:	0497e163          	bltu	a5,s1,80002030 <argraw+0x58>
    80001ff2:	048a                	slli	s1,s1,0x2
    80001ff4:	00006717          	auipc	a4,0x6
    80001ff8:	3bc70713          	addi	a4,a4,956 # 800083b0 <states.1725+0x170>
    80001ffc:	94ba                	add	s1,s1,a4
    80001ffe:	409c                	lw	a5,0(s1)
    80002000:	97ba                	add	a5,a5,a4
    80002002:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002004:	713c                	ld	a5,96(a0)
    80002006:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002008:	60e2                	ld	ra,24(sp)
    8000200a:	6442                	ld	s0,16(sp)
    8000200c:	64a2                	ld	s1,8(sp)
    8000200e:	6105                	addi	sp,sp,32
    80002010:	8082                	ret
    return p->trapframe->a1;
    80002012:	713c                	ld	a5,96(a0)
    80002014:	7fa8                	ld	a0,120(a5)
    80002016:	bfcd                	j	80002008 <argraw+0x30>
    return p->trapframe->a2;
    80002018:	713c                	ld	a5,96(a0)
    8000201a:	63c8                	ld	a0,128(a5)
    8000201c:	b7f5                	j	80002008 <argraw+0x30>
    return p->trapframe->a3;
    8000201e:	713c                	ld	a5,96(a0)
    80002020:	67c8                	ld	a0,136(a5)
    80002022:	b7dd                	j	80002008 <argraw+0x30>
    return p->trapframe->a4;
    80002024:	713c                	ld	a5,96(a0)
    80002026:	6bc8                	ld	a0,144(a5)
    80002028:	b7c5                	j	80002008 <argraw+0x30>
    return p->trapframe->a5;
    8000202a:	713c                	ld	a5,96(a0)
    8000202c:	6fc8                	ld	a0,152(a5)
    8000202e:	bfe9                	j	80002008 <argraw+0x30>
  panic("argraw");
    80002030:	00006517          	auipc	a0,0x6
    80002034:	35850513          	addi	a0,a0,856 # 80008388 <states.1725+0x148>
    80002038:	00004097          	auipc	ra,0x4
    8000203c:	184080e7          	jalr	388(ra) # 800061bc <panic>

0000000080002040 <fetchaddr>:
{
    80002040:	1101                	addi	sp,sp,-32
    80002042:	ec06                	sd	ra,24(sp)
    80002044:	e822                	sd	s0,16(sp)
    80002046:	e426                	sd	s1,8(sp)
    80002048:	e04a                	sd	s2,0(sp)
    8000204a:	1000                	addi	s0,sp,32
    8000204c:	84aa                	mv	s1,a0
    8000204e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	fde080e7          	jalr	-34(ra) # 8000102e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002058:	693c                	ld	a5,80(a0)
    8000205a:	02f4f863          	bgeu	s1,a5,8000208a <fetchaddr+0x4a>
    8000205e:	00848713          	addi	a4,s1,8
    80002062:	02e7e663          	bltu	a5,a4,8000208e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002066:	46a1                	li	a3,8
    80002068:	8626                	mv	a2,s1
    8000206a:	85ca                	mv	a1,s2
    8000206c:	6d28                	ld	a0,88(a0)
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	d0e080e7          	jalr	-754(ra) # 80000d7c <copyin>
    80002076:	00a03533          	snez	a0,a0
    8000207a:	40a00533          	neg	a0,a0
}
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	64a2                	ld	s1,8(sp)
    80002084:	6902                	ld	s2,0(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret
    return -1;
    8000208a:	557d                	li	a0,-1
    8000208c:	bfcd                	j	8000207e <fetchaddr+0x3e>
    8000208e:	557d                	li	a0,-1
    80002090:	b7fd                	j	8000207e <fetchaddr+0x3e>

0000000080002092 <fetchstr>:
{
    80002092:	7179                	addi	sp,sp,-48
    80002094:	f406                	sd	ra,40(sp)
    80002096:	f022                	sd	s0,32(sp)
    80002098:	ec26                	sd	s1,24(sp)
    8000209a:	e84a                	sd	s2,16(sp)
    8000209c:	e44e                	sd	s3,8(sp)
    8000209e:	1800                	addi	s0,sp,48
    800020a0:	892a                	mv	s2,a0
    800020a2:	84ae                	mv	s1,a1
    800020a4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020a6:	fffff097          	auipc	ra,0xfffff
    800020aa:	f88080e7          	jalr	-120(ra) # 8000102e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020ae:	86ce                	mv	a3,s3
    800020b0:	864a                	mv	a2,s2
    800020b2:	85a6                	mv	a1,s1
    800020b4:	6d28                	ld	a0,88(a0)
    800020b6:	fffff097          	auipc	ra,0xfffff
    800020ba:	d52080e7          	jalr	-686(ra) # 80000e08 <copyinstr>
  if(err < 0)
    800020be:	00054763          	bltz	a0,800020cc <fetchstr+0x3a>
  return strlen(buf);
    800020c2:	8526                	mv	a0,s1
    800020c4:	ffffe097          	auipc	ra,0xffffe
    800020c8:	40e080e7          	jalr	1038(ra) # 800004d2 <strlen>
}
    800020cc:	70a2                	ld	ra,40(sp)
    800020ce:	7402                	ld	s0,32(sp)
    800020d0:	64e2                	ld	s1,24(sp)
    800020d2:	6942                	ld	s2,16(sp)
    800020d4:	69a2                	ld	s3,8(sp)
    800020d6:	6145                	addi	sp,sp,48
    800020d8:	8082                	ret

00000000800020da <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800020da:	1101                	addi	sp,sp,-32
    800020dc:	ec06                	sd	ra,24(sp)
    800020de:	e822                	sd	s0,16(sp)
    800020e0:	e426                	sd	s1,8(sp)
    800020e2:	1000                	addi	s0,sp,32
    800020e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020e6:	00000097          	auipc	ra,0x0
    800020ea:	ef2080e7          	jalr	-270(ra) # 80001fd8 <argraw>
    800020ee:	c088                	sw	a0,0(s1)
  return 0;
}
    800020f0:	4501                	li	a0,0
    800020f2:	60e2                	ld	ra,24(sp)
    800020f4:	6442                	ld	s0,16(sp)
    800020f6:	64a2                	ld	s1,8(sp)
    800020f8:	6105                	addi	sp,sp,32
    800020fa:	8082                	ret

00000000800020fc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800020fc:	1101                	addi	sp,sp,-32
    800020fe:	ec06                	sd	ra,24(sp)
    80002100:	e822                	sd	s0,16(sp)
    80002102:	e426                	sd	s1,8(sp)
    80002104:	1000                	addi	s0,sp,32
    80002106:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	ed0080e7          	jalr	-304(ra) # 80001fd8 <argraw>
    80002110:	e088                	sd	a0,0(s1)
  return 0;
}
    80002112:	4501                	li	a0,0
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000211e:	1101                	addi	sp,sp,-32
    80002120:	ec06                	sd	ra,24(sp)
    80002122:	e822                	sd	s0,16(sp)
    80002124:	e426                	sd	s1,8(sp)
    80002126:	e04a                	sd	s2,0(sp)
    80002128:	1000                	addi	s0,sp,32
    8000212a:	84ae                	mv	s1,a1
    8000212c:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000212e:	00000097          	auipc	ra,0x0
    80002132:	eaa080e7          	jalr	-342(ra) # 80001fd8 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002136:	864a                	mv	a2,s2
    80002138:	85a6                	mv	a1,s1
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	f58080e7          	jalr	-168(ra) # 80002092 <fetchstr>
}
    80002142:	60e2                	ld	ra,24(sp)
    80002144:	6442                	ld	s0,16(sp)
    80002146:	64a2                	ld	s1,8(sp)
    80002148:	6902                	ld	s2,0(sp)
    8000214a:	6105                	addi	sp,sp,32
    8000214c:	8082                	ret

000000008000214e <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000214e:	1101                	addi	sp,sp,-32
    80002150:	ec06                	sd	ra,24(sp)
    80002152:	e822                	sd	s0,16(sp)
    80002154:	e426                	sd	s1,8(sp)
    80002156:	e04a                	sd	s2,0(sp)
    80002158:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	ed4080e7          	jalr	-300(ra) # 8000102e <myproc>
    80002162:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002164:	06053903          	ld	s2,96(a0)
    80002168:	0a893783          	ld	a5,168(s2)
    8000216c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002170:	37fd                	addiw	a5,a5,-1
    80002172:	4751                	li	a4,20
    80002174:	00f76f63          	bltu	a4,a5,80002192 <syscall+0x44>
    80002178:	00369713          	slli	a4,a3,0x3
    8000217c:	00006797          	auipc	a5,0x6
    80002180:	24c78793          	addi	a5,a5,588 # 800083c8 <syscalls>
    80002184:	97ba                	add	a5,a5,a4
    80002186:	639c                	ld	a5,0(a5)
    80002188:	c789                	beqz	a5,80002192 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000218a:	9782                	jalr	a5
    8000218c:	06a93823          	sd	a0,112(s2)
    80002190:	a839                	j	800021ae <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002192:	16048613          	addi	a2,s1,352
    80002196:	5c8c                	lw	a1,56(s1)
    80002198:	00006517          	auipc	a0,0x6
    8000219c:	1f850513          	addi	a0,a0,504 # 80008390 <states.1725+0x150>
    800021a0:	00004097          	auipc	ra,0x4
    800021a4:	066080e7          	jalr	102(ra) # 80006206 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a8:	70bc                	ld	a5,96(s1)
    800021aa:	577d                	li	a4,-1
    800021ac:	fbb8                	sd	a4,112(a5)
  }
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	64a2                	ld	s1,8(sp)
    800021b4:	6902                	ld	s2,0(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800021c2:	fec40593          	addi	a1,s0,-20
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	f12080e7          	jalr	-238(ra) # 800020da <argint>
    return -1;
    800021d0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800021d2:	00054963          	bltz	a0,800021e4 <sys_exit+0x2a>
  exit(n);
    800021d6:	fec42503          	lw	a0,-20(s0)
    800021da:	fffff097          	auipc	ra,0xfffff
    800021de:	76c080e7          	jalr	1900(ra) # 80001946 <exit>
  return 0;  // not reached
    800021e2:	4781                	li	a5,0
}
    800021e4:	853e                	mv	a0,a5
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	6105                	addi	sp,sp,32
    800021ec:	8082                	ret

00000000800021ee <sys_getpid>:

uint64
sys_getpid(void)
{
    800021ee:	1141                	addi	sp,sp,-16
    800021f0:	e406                	sd	ra,8(sp)
    800021f2:	e022                	sd	s0,0(sp)
    800021f4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	e38080e7          	jalr	-456(ra) # 8000102e <myproc>
}
    800021fe:	5d08                	lw	a0,56(a0)
    80002200:	60a2                	ld	ra,8(sp)
    80002202:	6402                	ld	s0,0(sp)
    80002204:	0141                	addi	sp,sp,16
    80002206:	8082                	ret

0000000080002208 <sys_fork>:

uint64
sys_fork(void)
{
    80002208:	1141                	addi	sp,sp,-16
    8000220a:	e406                	sd	ra,8(sp)
    8000220c:	e022                	sd	s0,0(sp)
    8000220e:	0800                	addi	s0,sp,16
  return fork();
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	1ec080e7          	jalr	492(ra) # 800013fc <fork>
}
    80002218:	60a2                	ld	ra,8(sp)
    8000221a:	6402                	ld	s0,0(sp)
    8000221c:	0141                	addi	sp,sp,16
    8000221e:	8082                	ret

0000000080002220 <sys_wait>:

uint64
sys_wait(void)
{
    80002220:	1101                	addi	sp,sp,-32
    80002222:	ec06                	sd	ra,24(sp)
    80002224:	e822                	sd	s0,16(sp)
    80002226:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002228:	fe840593          	addi	a1,s0,-24
    8000222c:	4501                	li	a0,0
    8000222e:	00000097          	auipc	ra,0x0
    80002232:	ece080e7          	jalr	-306(ra) # 800020fc <argaddr>
    80002236:	87aa                	mv	a5,a0
    return -1;
    80002238:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000223a:	0007c863          	bltz	a5,8000224a <sys_wait+0x2a>
  return wait(p);
    8000223e:	fe843503          	ld	a0,-24(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	50c080e7          	jalr	1292(ra) # 8000174e <wait>
}
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	6105                	addi	sp,sp,32
    80002250:	8082                	ret

0000000080002252 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002252:	7179                	addi	sp,sp,-48
    80002254:	f406                	sd	ra,40(sp)
    80002256:	f022                	sd	s0,32(sp)
    80002258:	ec26                	sd	s1,24(sp)
    8000225a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000225c:	fdc40593          	addi	a1,s0,-36
    80002260:	4501                	li	a0,0
    80002262:	00000097          	auipc	ra,0x0
    80002266:	e78080e7          	jalr	-392(ra) # 800020da <argint>
    8000226a:	87aa                	mv	a5,a0
    return -1;
    8000226c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000226e:	0207c063          	bltz	a5,8000228e <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	dbc080e7          	jalr	-580(ra) # 8000102e <myproc>
    8000227a:	4924                	lw	s1,80(a0)
  if(growproc(n) < 0)
    8000227c:	fdc42503          	lw	a0,-36(s0)
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	108080e7          	jalr	264(ra) # 80001388 <growproc>
    80002288:	00054863          	bltz	a0,80002298 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000228c:	8526                	mv	a0,s1
}
    8000228e:	70a2                	ld	ra,40(sp)
    80002290:	7402                	ld	s0,32(sp)
    80002292:	64e2                	ld	s1,24(sp)
    80002294:	6145                	addi	sp,sp,48
    80002296:	8082                	ret
    return -1;
    80002298:	557d                	li	a0,-1
    8000229a:	bfd5                	j	8000228e <sys_sbrk+0x3c>

000000008000229c <sys_sleep>:

uint64
sys_sleep(void)
{
    8000229c:	7139                	addi	sp,sp,-64
    8000229e:	fc06                	sd	ra,56(sp)
    800022a0:	f822                	sd	s0,48(sp)
    800022a2:	f426                	sd	s1,40(sp)
    800022a4:	f04a                	sd	s2,32(sp)
    800022a6:	ec4e                	sd	s3,24(sp)
    800022a8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800022aa:	fcc40593          	addi	a1,s0,-52
    800022ae:	4501                	li	a0,0
    800022b0:	00000097          	auipc	ra,0x0
    800022b4:	e2a080e7          	jalr	-470(ra) # 800020da <argint>
    return -1;
    800022b8:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022ba:	06054563          	bltz	a0,80002324 <sys_sleep+0x88>
  acquire(&tickslock);
    800022be:	0000d517          	auipc	a0,0xd
    800022c2:	ef250513          	addi	a0,a0,-270 # 8000f1b0 <tickslock>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	42a080e7          	jalr	1066(ra) # 800066f0 <acquire>
  ticks0 = ticks;
    800022ce:	00007917          	auipc	s2,0x7
    800022d2:	d4a92903          	lw	s2,-694(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800022d6:	fcc42783          	lw	a5,-52(s0)
    800022da:	cf85                	beqz	a5,80002312 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022dc:	0000d997          	auipc	s3,0xd
    800022e0:	ed498993          	addi	s3,s3,-300 # 8000f1b0 <tickslock>
    800022e4:	00007497          	auipc	s1,0x7
    800022e8:	d3448493          	addi	s1,s1,-716 # 80009018 <ticks>
    if(myproc()->killed){
    800022ec:	fffff097          	auipc	ra,0xfffff
    800022f0:	d42080e7          	jalr	-702(ra) # 8000102e <myproc>
    800022f4:	591c                	lw	a5,48(a0)
    800022f6:	ef9d                	bnez	a5,80002334 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800022f8:	85ce                	mv	a1,s3
    800022fa:	8526                	mv	a0,s1
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	3ee080e7          	jalr	1006(ra) # 800016ea <sleep>
  while(ticks - ticks0 < n){
    80002304:	409c                	lw	a5,0(s1)
    80002306:	412787bb          	subw	a5,a5,s2
    8000230a:	fcc42703          	lw	a4,-52(s0)
    8000230e:	fce7efe3          	bltu	a5,a4,800022ec <sys_sleep+0x50>
  }
  release(&tickslock);
    80002312:	0000d517          	auipc	a0,0xd
    80002316:	e9e50513          	addi	a0,a0,-354 # 8000f1b0 <tickslock>
    8000231a:	00004097          	auipc	ra,0x4
    8000231e:	4a6080e7          	jalr	1190(ra) # 800067c0 <release>
  return 0;
    80002322:	4781                	li	a5,0
}
    80002324:	853e                	mv	a0,a5
    80002326:	70e2                	ld	ra,56(sp)
    80002328:	7442                	ld	s0,48(sp)
    8000232a:	74a2                	ld	s1,40(sp)
    8000232c:	7902                	ld	s2,32(sp)
    8000232e:	69e2                	ld	s3,24(sp)
    80002330:	6121                	addi	sp,sp,64
    80002332:	8082                	ret
      release(&tickslock);
    80002334:	0000d517          	auipc	a0,0xd
    80002338:	e7c50513          	addi	a0,a0,-388 # 8000f1b0 <tickslock>
    8000233c:	00004097          	auipc	ra,0x4
    80002340:	484080e7          	jalr	1156(ra) # 800067c0 <release>
      return -1;
    80002344:	57fd                	li	a5,-1
    80002346:	bff9                	j	80002324 <sys_sleep+0x88>

0000000080002348 <sys_kill>:

uint64
sys_kill(void)
{
    80002348:	1101                	addi	sp,sp,-32
    8000234a:	ec06                	sd	ra,24(sp)
    8000234c:	e822                	sd	s0,16(sp)
    8000234e:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002350:	fec40593          	addi	a1,s0,-20
    80002354:	4501                	li	a0,0
    80002356:	00000097          	auipc	ra,0x0
    8000235a:	d84080e7          	jalr	-636(ra) # 800020da <argint>
    8000235e:	87aa                	mv	a5,a0
    return -1;
    80002360:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002362:	0007c863          	bltz	a5,80002372 <sys_kill+0x2a>
  return kill(pid);
    80002366:	fec42503          	lw	a0,-20(s0)
    8000236a:	fffff097          	auipc	ra,0xfffff
    8000236e:	6b2080e7          	jalr	1714(ra) # 80001a1c <kill>
}
    80002372:	60e2                	ld	ra,24(sp)
    80002374:	6442                	ld	s0,16(sp)
    80002376:	6105                	addi	sp,sp,32
    80002378:	8082                	ret

000000008000237a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000237a:	1101                	addi	sp,sp,-32
    8000237c:	ec06                	sd	ra,24(sp)
    8000237e:	e822                	sd	s0,16(sp)
    80002380:	e426                	sd	s1,8(sp)
    80002382:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002384:	0000d517          	auipc	a0,0xd
    80002388:	e2c50513          	addi	a0,a0,-468 # 8000f1b0 <tickslock>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	364080e7          	jalr	868(ra) # 800066f0 <acquire>
  xticks = ticks;
    80002394:	00007497          	auipc	s1,0x7
    80002398:	c844a483          	lw	s1,-892(s1) # 80009018 <ticks>
  release(&tickslock);
    8000239c:	0000d517          	auipc	a0,0xd
    800023a0:	e1450513          	addi	a0,a0,-492 # 8000f1b0 <tickslock>
    800023a4:	00004097          	auipc	ra,0x4
    800023a8:	41c080e7          	jalr	1052(ra) # 800067c0 <release>
  return xticks;
}
    800023ac:	02049513          	slli	a0,s1,0x20
    800023b0:	9101                	srli	a0,a0,0x20
    800023b2:	60e2                	ld	ra,24(sp)
    800023b4:	6442                	ld	s0,16(sp)
    800023b6:	64a2                	ld	s1,8(sp)
    800023b8:	6105                	addi	sp,sp,32
    800023ba:	8082                	ret

00000000800023bc <binit>:
//   // head.next is most recent, head.prev is least.
//   struct buf head;
// } bcache;

void
binit(void) {
    800023bc:	7179                	addi	sp,sp,-48
    800023be:	f406                	sd	ra,40(sp)
    800023c0:	f022                	sd	s0,32(sp)
    800023c2:	ec26                	sd	s1,24(sp)
    800023c4:	e84a                	sd	s2,16(sp)
    800023c6:	e44e                	sd	s3,8(sp)
    800023c8:	e052                	sd	s4,0(sp)
    800023ca:	1800                	addi	s0,sp,48
  struct buf* b;
  
  for(int i = 0; i < NBUCKET; ++i) {
    800023cc:	00015497          	auipc	s1,0x15
    800023d0:	69c48493          	addi	s1,s1,1692 # 80017a68 <bcache+0x8898>
    800023d4:	00019997          	auipc	s3,0x19
    800023d8:	17c98993          	addi	s3,s3,380 # 8001b550 <itable+0x448>
    initlock(&bcache.buckets[i].lock, "bcache");
    800023dc:	00006917          	auipc	s2,0x6
    800023e0:	09c90913          	addi	s2,s2,156 # 80008478 <syscalls+0xb0>
    800023e4:	85ca                	mv	a1,s2
    800023e6:	8526                	mv	a0,s1
    800023e8:	00004097          	auipc	ra,0x4
    800023ec:	484080e7          	jalr	1156(ra) # 8000686c <initlock>
    // 初始化散列桶的头节点
    bcache.buckets[i].head.prev = &bcache.buckets[i].head;
    800023f0:	b9848793          	addi	a5,s1,-1128
    800023f4:	bef4b423          	sd	a5,-1048(s1)
    bcache.buckets[i].head.next = &bcache.buckets[i].head;
    800023f8:	bef4b823          	sd	a5,-1040(s1)
  for(int i = 0; i < NBUCKET; ++i) {
    800023fc:	48848493          	addi	s1,s1,1160
    80002400:	ff3492e3          	bne	s1,s3,800023e4 <binit+0x28>
  }

  // Create linked list of buffers
  for(b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002404:	0000d497          	auipc	s1,0xd
    80002408:	dcc48493          	addi	s1,s1,-564 # 8000f1d0 <bcache>
    // 利用头插法初始化缓冲区列表,全部放到散列桶0上
    b->next = bcache.buckets[0].head.next;
    8000240c:	00015917          	auipc	s2,0x15
    80002410:	dc490913          	addi	s2,s2,-572 # 800171d0 <bcache+0x8000>
    b->prev = &bcache.buckets[0].head;
    80002414:	00015997          	auipc	s3,0x15
    80002418:	1ec98993          	addi	s3,s3,492 # 80017600 <bcache+0x8430>
    initsleeplock(&b->lock, "buffer");
    8000241c:	00006a17          	auipc	s4,0x6
    80002420:	064a0a13          	addi	s4,s4,100 # 80008480 <syscalls+0xb8>
    b->next = bcache.buckets[0].head.next;
    80002424:	48893783          	ld	a5,1160(s2)
    80002428:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.buckets[0].head;
    8000242a:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    8000242e:	85d2                	mv	a1,s4
    80002430:	01048513          	addi	a0,s1,16
    80002434:	00001097          	auipc	ra,0x1
    80002438:	626080e7          	jalr	1574(ra) # 80003a5a <initsleeplock>
    bcache.buckets[0].head.next->prev = b;
    8000243c:	48893783          	ld	a5,1160(s2)
    80002440:	eba4                	sd	s1,80(a5)
    bcache.buckets[0].head.next = b;
    80002442:	48993423          	sd	s1,1160(s2)
  for(b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002446:	46848493          	addi	s1,s1,1128
    8000244a:	fd349de3          	bne	s1,s3,80002424 <binit+0x68>
  }
}
    8000244e:	70a2                	ld	ra,40(sp)
    80002450:	7402                	ld	s0,32(sp)
    80002452:	64e2                	ld	s1,24(sp)
    80002454:	6942                	ld	s2,16(sp)
    80002456:	69a2                	ld	s3,8(sp)
    80002458:	6a02                	ld	s4,0(sp)
    8000245a:	6145                	addi	sp,sp,48
    8000245c:	8082                	ret

000000008000245e <bread>:


// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000245e:	7175                	addi	sp,sp,-144
    80002460:	e506                	sd	ra,136(sp)
    80002462:	e122                	sd	s0,128(sp)
    80002464:	fca6                	sd	s1,120(sp)
    80002466:	f8ca                	sd	s2,112(sp)
    80002468:	f4ce                	sd	s3,104(sp)
    8000246a:	f0d2                	sd	s4,96(sp)
    8000246c:	ecd6                	sd	s5,88(sp)
    8000246e:	e8da                	sd	s6,80(sp)
    80002470:	e4de                	sd	s7,72(sp)
    80002472:	e0e2                	sd	s8,64(sp)
    80002474:	fc66                	sd	s9,56(sp)
    80002476:	f86a                	sd	s10,48(sp)
    80002478:	f46e                	sd	s11,40(sp)
    8000247a:	0900                	addi	s0,sp,144
    8000247c:	f8a43423          	sd	a0,-120(s0)
    80002480:	8aae                	mv	s5,a1
  int bid = HASH(blockno);
    80002482:	4bb5                	li	s7,13
    80002484:	0375fbbb          	remuw	s7,a1,s7
    80002488:	000b8b1b          	sext.w	s6,s7
    8000248c:	8c5a                	mv	s8,s6
  acquire(&bcache.buckets[bid].lock);
    8000248e:	48800a13          	li	s4,1160
    80002492:	034b0a33          	mul	s4,s6,s4
    80002496:	69a5                	lui	s3,0x9
    80002498:	89898993          	addi	s3,s3,-1896 # 8898 <_entry-0x7fff7768>
    8000249c:	99d2                	add	s3,s3,s4
    8000249e:	0000dc97          	auipc	s9,0xd
    800024a2:	d32c8c93          	addi	s9,s9,-718 # 8000f1d0 <bcache>
    800024a6:	99e6                	add	s3,s3,s9
    800024a8:	854e                	mv	a0,s3
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	246080e7          	jalr	582(ra) # 800066f0 <acquire>
  for(b = bcache.buckets[bid].head.next; b != &bcache.buckets[bid].head; b = b->next){
    800024b2:	014c87b3          	add	a5,s9,s4
    800024b6:	6921                	lui	s2,0x8
    800024b8:	97ca                	add	a5,a5,s2
    800024ba:	4887b483          	ld	s1,1160(a5)
    800024be:	43090913          	addi	s2,s2,1072 # 8430 <_entry-0x7fff7bd0>
    800024c2:	9952                	add	s2,s2,s4
    800024c4:	9966                	add	s2,s2,s9
    800024c6:	03249863          	bne	s1,s2,800024f6 <bread+0x98>
    800024ca:	00db879b          	addiw	a5,s7,13
    800024ce:	f8f43023          	sd	a5,-128(s0)
    for(tmp = bcache.buckets[bid_n].head.next; tmp != &bcache.buckets[bid_n].head; tmp = tmp->next){
    800024d2:	0000db97          	auipc	s7,0xd
    800024d6:	cfeb8b93          	addi	s7,s7,-770 # 8000f1d0 <bcache>
    800024da:	48800d13          	li	s10,1160
    800024de:	6da1                	lui	s11,0x8
    800024e0:	430d8793          	addi	a5,s11,1072 # 8430 <_entry-0x7fff7bd0>
    800024e4:	f6f43c23          	sd	a5,-136(s0)
        release(&bcache.buckets[bid_n].lock);
    800024e8:	6ca5                	lui	s9,0x9
    800024ea:	898c8c93          	addi	s9,s9,-1896 # 8898 <_entry-0x7fff7768>
    800024ee:	a8b5                	j	8000256a <bread+0x10c>
  for(b = bcache.buckets[bid].head.next; b != &bcache.buckets[bid].head; b = b->next){
    800024f0:	6ca4                	ld	s1,88(s1)
    800024f2:	fd248ce3          	beq	s1,s2,800024ca <bread+0x6c>
    if(b->dev == dev && b->blockno == blockno){
    800024f6:	449c                	lw	a5,8(s1)
    800024f8:	f8843703          	ld	a4,-120(s0)
    800024fc:	fee79ae3          	bne	a5,a4,800024f0 <bread+0x92>
    80002500:	44dc                	lw	a5,12(s1)
    80002502:	ff5797e3          	bne	a5,s5,800024f0 <bread+0x92>
      b->refcnt++;
    80002506:	44bc                	lw	a5,72(s1)
    80002508:	2785                	addiw	a5,a5,1
    8000250a:	c4bc                	sw	a5,72(s1)
      b->timestamp = ticks;
    8000250c:	00007797          	auipc	a5,0x7
    80002510:	b0c7a783          	lw	a5,-1268(a5) # 80009018 <ticks>
    80002514:	46f4a023          	sw	a5,1120(s1)
      release(&bcache.buckets[bid].lock);
    80002518:	854e                	mv	a0,s3
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	2a6080e7          	jalr	678(ra) # 800067c0 <release>
      acquiresleep(&b->lock);
    80002522:	01048513          	addi	a0,s1,16
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	56e080e7          	jalr	1390(ra) # 80003a94 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000252e:	409c                	lw	a5,0(s1)
    80002530:	12078263          	beqz	a5,80002654 <bread+0x1f6>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002534:	8526                	mv	a0,s1
    80002536:	60aa                	ld	ra,136(sp)
    80002538:	640a                	ld	s0,128(sp)
    8000253a:	74e6                	ld	s1,120(sp)
    8000253c:	7946                	ld	s2,112(sp)
    8000253e:	79a6                	ld	s3,104(sp)
    80002540:	7a06                	ld	s4,96(sp)
    80002542:	6ae6                	ld	s5,88(sp)
    80002544:	6b46                	ld	s6,80(sp)
    80002546:	6ba6                	ld	s7,72(sp)
    80002548:	6c06                	ld	s8,64(sp)
    8000254a:	7ce2                	ld	s9,56(sp)
    8000254c:	7d42                	ld	s10,48(sp)
    8000254e:	7da2                	ld	s11,40(sp)
    80002550:	6149                	addi	sp,sp,144
    80002552:	8082                	ret
    for(tmp = bcache.buckets[bid_n].head.next; tmp != &bcache.buckets[bid_n].head; tmp = tmp->next){
    80002554:	6fbc                	ld	a5,88(a5)
    80002556:	10e79c63          	bne	a5,a4,8000266e <bread+0x210>
    if(b)
    8000255a:	eca1                	bnez	s1,800025b2 <bread+0x154>
      if(bid_n != bid)
    8000255c:	0d4c1d63          	bne	s8,s4,80002636 <bread+0x1d8>
  for (int i = 0; i<NBUCKET; i++){
    80002560:	2b05                	addiw	s6,s6,1
    80002562:	f8043783          	ld	a5,-128(s0)
    80002566:	0cfb0f63          	beq	s6,a5,80002644 <bread+0x1e6>
    int bid_n = (bid+i)%NBUCKET;
    8000256a:	47b5                	li	a5,13
    8000256c:	02fb6a3b          	remw	s4,s6,a5
    if(bid_n != bid){
    80002570:	034c0163          	beq	s8,s4,80002592 <bread+0x134>
      if(!holding(&bcache.buckets[bid_n].lock))
    80002574:	03aa04b3          	mul	s1,s4,s10
    80002578:	94e6                	add	s1,s1,s9
    8000257a:	94de                	add	s1,s1,s7
    8000257c:	8526                	mv	a0,s1
    8000257e:	00004097          	auipc	ra,0x4
    80002582:	0f8080e7          	jalr	248(ra) # 80006676 <holding>
    80002586:	fd69                	bnez	a0,80002560 <bread+0x102>
        acquire(&bcache.buckets[bid_n].lock);
    80002588:	8526                	mv	a0,s1
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	166080e7          	jalr	358(ra) # 800066f0 <acquire>
    for(tmp = bcache.buckets[bid_n].head.next; tmp != &bcache.buckets[bid_n].head; tmp = tmp->next){
    80002592:	03aa0533          	mul	a0,s4,s10
    80002596:	00ab87b3          	add	a5,s7,a0
    8000259a:	97ee                	add	a5,a5,s11
    8000259c:	4887b783          	ld	a5,1160(a5)
    800025a0:	85aa                	mv	a1,a0
    800025a2:	f7843703          	ld	a4,-136(s0)
    800025a6:	972a                	add	a4,a4,a0
    800025a8:	975e                	add	a4,a4,s7
    800025aa:	fae789e3          	beq	a5,a4,8000255c <bread+0xfe>
    800025ae:	4481                	li	s1,0
    800025b0:	a87d                	j	8000266e <bread+0x210>
      if(bid_n != bid)
    800025b2:	034c1d63          	bne	s8,s4,800025ec <bread+0x18e>
      b->dev = dev;
    800025b6:	f8843783          	ld	a5,-120(s0)
    800025ba:	c49c                	sw	a5,8(s1)
      b->blockno = blockno;
    800025bc:	0154a623          	sw	s5,12(s1)
      b->valid = 0;
    800025c0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025c4:	4785                	li	a5,1
    800025c6:	c4bc                	sw	a5,72(s1)
      b->timestamp = ticks;
    800025c8:	00007797          	auipc	a5,0x7
    800025cc:	a507a783          	lw	a5,-1456(a5) # 80009018 <ticks>
    800025d0:	46f4a023          	sw	a5,1120(s1)
      release(&bcache.buckets[bid].lock);
    800025d4:	854e                	mv	a0,s3
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	1ea080e7          	jalr	490(ra) # 800067c0 <release>
      acquiresleep(&b->lock);
    800025de:	01048513          	addi	a0,s1,16
    800025e2:	00001097          	auipc	ra,0x1
    800025e6:	4b2080e7          	jalr	1202(ra) # 80003a94 <acquiresleep>
      return b;
    800025ea:	b791                	j	8000252e <bread+0xd0>
        b->next->prev = b->prev;
    800025ec:	6cb8                	ld	a4,88(s1)
    800025ee:	68bc                	ld	a5,80(s1)
    800025f0:	eb3c                	sd	a5,80(a4)
        b->prev->next = b->next;
    800025f2:	6cb8                	ld	a4,88(s1)
    800025f4:	efb8                	sd	a4,88(a5)
        b->next = bcache.buckets[bid].head.next;
    800025f6:	0000d517          	auipc	a0,0xd
    800025fa:	bda50513          	addi	a0,a0,-1062 # 8000f1d0 <bcache>
    800025fe:	48800793          	li	a5,1160
    80002602:	02fc0c33          	mul	s8,s8,a5
    80002606:	018507b3          	add	a5,a0,s8
    8000260a:	6c21                	lui	s8,0x8
    8000260c:	9c3e                	add	s8,s8,a5
    8000260e:	488c3783          	ld	a5,1160(s8) # 8488 <_entry-0x7fff7b78>
    80002612:	ecbc                	sd	a5,88(s1)
        b->prev = &bcache.buckets[bid].head;
    80002614:	0524b823          	sd	s2,80(s1)
        bcache.buckets[bid].head.next->prev = b;
    80002618:	488c3783          	ld	a5,1160(s8)
    8000261c:	eba4                	sd	s1,80(a5)
        bcache.buckets[bid].head.next = b; 
    8000261e:	489c3423          	sd	s1,1160(s8)
        release(&bcache.buckets[bid_n].lock); 
    80002622:	67a5                	lui	a5,0x9
    80002624:	89878793          	addi	a5,a5,-1896 # 8898 <_entry-0x7fff7768>
    80002628:	95be                	add	a1,a1,a5
    8000262a:	952e                	add	a0,a0,a1
    8000262c:	00004097          	auipc	ra,0x4
    80002630:	194080e7          	jalr	404(ra) # 800067c0 <release>
    80002634:	b749                	j	800025b6 <bread+0x158>
        release(&bcache.buckets[bid_n].lock);
    80002636:	9566                	add	a0,a0,s9
    80002638:	955e                	add	a0,a0,s7
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	186080e7          	jalr	390(ra) # 800067c0 <release>
    80002642:	bf39                	j	80002560 <bread+0x102>
  panic("bget: no buffers");
    80002644:	00006517          	auipc	a0,0x6
    80002648:	e4450513          	addi	a0,a0,-444 # 80008488 <syscalls+0xc0>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	b70080e7          	jalr	-1168(ra) # 800061bc <panic>
    virtio_disk_rw(b, 0);
    80002654:	4581                	li	a1,0
    80002656:	8526                	mv	a0,s1
    80002658:	00003097          	auipc	ra,0x3
    8000265c:	f6e080e7          	jalr	-146(ra) # 800055c6 <virtio_disk_rw>
    b->valid = 1;
    80002660:	4785                	li	a5,1
    80002662:	c09c                	sw	a5,0(s1)
  return b;
    80002664:	bdc1                	j	80002534 <bread+0xd6>
    80002666:	84be                	mv	s1,a5
    for(tmp = bcache.buckets[bid_n].head.next; tmp != &bcache.buckets[bid_n].head; tmp = tmp->next){
    80002668:	6fbc                	ld	a5,88(a5)
    8000266a:	f4e784e3          	beq	a5,a4,800025b2 <bread+0x154>
      if(tmp->refcnt == 0 && (b == 0 ||(tmp->timestamp < b->timestamp))){
    8000266e:	47b4                	lw	a3,72(a5)
    80002670:	ee0692e3          	bnez	a3,80002554 <bread+0xf6>
    80002674:	d8ed                	beqz	s1,80002666 <bread+0x208>
    80002676:	4607a603          	lw	a2,1120(a5)
    8000267a:	4604a683          	lw	a3,1120(s1)
    8000267e:	fed675e3          	bgeu	a2,a3,80002668 <bread+0x20a>
    80002682:	84be                	mv	s1,a5
    80002684:	b7d5                	j	80002668 <bread+0x20a>

0000000080002686 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002686:	1101                	addi	sp,sp,-32
    80002688:	ec06                	sd	ra,24(sp)
    8000268a:	e822                	sd	s0,16(sp)
    8000268c:	e426                	sd	s1,8(sp)
    8000268e:	1000                	addi	s0,sp,32
    80002690:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002692:	0541                	addi	a0,a0,16
    80002694:	00001097          	auipc	ra,0x1
    80002698:	49a080e7          	jalr	1178(ra) # 80003b2e <holdingsleep>
    8000269c:	cd01                	beqz	a0,800026b4 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000269e:	4585                	li	a1,1
    800026a0:	8526                	mv	a0,s1
    800026a2:	00003097          	auipc	ra,0x3
    800026a6:	f24080e7          	jalr	-220(ra) # 800055c6 <virtio_disk_rw>
}
    800026aa:	60e2                	ld	ra,24(sp)
    800026ac:	6442                	ld	s0,16(sp)
    800026ae:	64a2                	ld	s1,8(sp)
    800026b0:	6105                	addi	sp,sp,32
    800026b2:	8082                	ret
    panic("bwrite");
    800026b4:	00006517          	auipc	a0,0x6
    800026b8:	dec50513          	addi	a0,a0,-532 # 800084a0 <syscalls+0xd8>
    800026bc:	00004097          	auipc	ra,0x4
    800026c0:	b00080e7          	jalr	-1280(ra) # 800061bc <panic>

00000000800026c4 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026c4:	7179                	addi	sp,sp,-48
    800026c6:	f406                	sd	ra,40(sp)
    800026c8:	f022                	sd	s0,32(sp)
    800026ca:	ec26                	sd	s1,24(sp)
    800026cc:	e84a                	sd	s2,16(sp)
    800026ce:	e44e                	sd	s3,8(sp)
    800026d0:	1800                	addi	s0,sp,48
    800026d2:	892a                	mv	s2,a0
  if(!holdingsleep(&b->lock))
    800026d4:	01050993          	addi	s3,a0,16
    800026d8:	854e                	mv	a0,s3
    800026da:	00001097          	auipc	ra,0x1
    800026de:	454080e7          	jalr	1108(ra) # 80003b2e <holdingsleep>
    800026e2:	c525                	beqz	a0,8000274a <brelse+0x86>
    panic("brelse");

  int bid = HASH(b->blockno);
    800026e4:	00c92483          	lw	s1,12(s2)
    800026e8:	47b5                	li	a5,13
    800026ea:	02f4f4bb          	remuw	s1,s1,a5
  releasesleep(&b->lock);
    800026ee:	854e                	mv	a0,s3
    800026f0:	00001097          	auipc	ra,0x1
    800026f4:	3fa080e7          	jalr	1018(ra) # 80003aea <releasesleep>

  acquire(&bcache.buckets[bid].lock);
    800026f8:	48800793          	li	a5,1160
    800026fc:	02f484b3          	mul	s1,s1,a5
    80002700:	67a5                	lui	a5,0x9
    80002702:	89878793          	addi	a5,a5,-1896 # 8898 <_entry-0x7fff7768>
    80002706:	94be                	add	s1,s1,a5
    80002708:	0000d797          	auipc	a5,0xd
    8000270c:	ac878793          	addi	a5,a5,-1336 # 8000f1d0 <bcache>
    80002710:	94be                	add	s1,s1,a5
    80002712:	8526                	mv	a0,s1
    80002714:	00004097          	auipc	ra,0x4
    80002718:	fdc080e7          	jalr	-36(ra) # 800066f0 <acquire>
  
  b->refcnt--;
    8000271c:	04892783          	lw	a5,72(s2)
    80002720:	37fd                	addiw	a5,a5,-1
    80002722:	04f92423          	sw	a5,72(s2)
  b->timestamp = ticks;
    80002726:	00007797          	auipc	a5,0x7
    8000272a:	8f27a783          	lw	a5,-1806(a5) # 80009018 <ticks>
    8000272e:	46f92023          	sw	a5,1120(s2)

  release(&bcache.buckets[bid].lock);
    80002732:	8526                	mv	a0,s1
    80002734:	00004097          	auipc	ra,0x4
    80002738:	08c080e7          	jalr	140(ra) # 800067c0 <release>
  
}
    8000273c:	70a2                	ld	ra,40(sp)
    8000273e:	7402                	ld	s0,32(sp)
    80002740:	64e2                	ld	s1,24(sp)
    80002742:	6942                	ld	s2,16(sp)
    80002744:	69a2                	ld	s3,8(sp)
    80002746:	6145                	addi	sp,sp,48
    80002748:	8082                	ret
    panic("brelse");
    8000274a:	00006517          	auipc	a0,0x6
    8000274e:	d5e50513          	addi	a0,a0,-674 # 800084a8 <syscalls+0xe0>
    80002752:	00004097          	auipc	ra,0x4
    80002756:	a6a080e7          	jalr	-1430(ra) # 800061bc <panic>

000000008000275a <bpin>:

void
bpin(struct buf* b) {
    8000275a:	1101                	addi	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	e04a                	sd	s2,0(sp)
    80002764:	1000                	addi	s0,sp,32
    80002766:	892a                	mv	s2,a0
  int bid = HASH(b->blockno);
    80002768:	4544                	lw	s1,12(a0)
  acquire(&bcache.buckets[bid].lock);
    8000276a:	47b5                	li	a5,13
    8000276c:	02f4f4bb          	remuw	s1,s1,a5
    80002770:	48800793          	li	a5,1160
    80002774:	02f484b3          	mul	s1,s1,a5
    80002778:	67a5                	lui	a5,0x9
    8000277a:	89878793          	addi	a5,a5,-1896 # 8898 <_entry-0x7fff7768>
    8000277e:	94be                	add	s1,s1,a5
    80002780:	0000d797          	auipc	a5,0xd
    80002784:	a5078793          	addi	a5,a5,-1456 # 8000f1d0 <bcache>
    80002788:	94be                	add	s1,s1,a5
    8000278a:	8526                	mv	a0,s1
    8000278c:	00004097          	auipc	ra,0x4
    80002790:	f64080e7          	jalr	-156(ra) # 800066f0 <acquire>
  b->refcnt++;
    80002794:	04892783          	lw	a5,72(s2)
    80002798:	2785                	addiw	a5,a5,1
    8000279a:	04f92423          	sw	a5,72(s2)
  release(&bcache.buckets[bid].lock);
    8000279e:	8526                	mv	a0,s1
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	020080e7          	jalr	32(ra) # 800067c0 <release>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6902                	ld	s2,0(sp)
    800027b0:	6105                	addi	sp,sp,32
    800027b2:	8082                	ret

00000000800027b4 <bunpin>:

void
bunpin(struct buf* b) {
    800027b4:	1101                	addi	sp,sp,-32
    800027b6:	ec06                	sd	ra,24(sp)
    800027b8:	e822                	sd	s0,16(sp)
    800027ba:	e426                	sd	s1,8(sp)
    800027bc:	e04a                	sd	s2,0(sp)
    800027be:	1000                	addi	s0,sp,32
    800027c0:	892a                	mv	s2,a0
  int bid = HASH(b->blockno);
    800027c2:	4544                	lw	s1,12(a0)
  acquire(&bcache.buckets[bid].lock);
    800027c4:	47b5                	li	a5,13
    800027c6:	02f4f4bb          	remuw	s1,s1,a5
    800027ca:	48800793          	li	a5,1160
    800027ce:	02f484b3          	mul	s1,s1,a5
    800027d2:	67a5                	lui	a5,0x9
    800027d4:	89878793          	addi	a5,a5,-1896 # 8898 <_entry-0x7fff7768>
    800027d8:	94be                	add	s1,s1,a5
    800027da:	0000d797          	auipc	a5,0xd
    800027de:	9f678793          	addi	a5,a5,-1546 # 8000f1d0 <bcache>
    800027e2:	94be                	add	s1,s1,a5
    800027e4:	8526                	mv	a0,s1
    800027e6:	00004097          	auipc	ra,0x4
    800027ea:	f0a080e7          	jalr	-246(ra) # 800066f0 <acquire>
  b->refcnt--;
    800027ee:	04892783          	lw	a5,72(s2)
    800027f2:	37fd                	addiw	a5,a5,-1
    800027f4:	04f92423          	sw	a5,72(s2)
  release(&bcache.buckets[bid].lock);
    800027f8:	8526                	mv	a0,s1
    800027fa:	00004097          	auipc	ra,0x4
    800027fe:	fc6080e7          	jalr	-58(ra) # 800067c0 <release>
}
    80002802:	60e2                	ld	ra,24(sp)
    80002804:	6442                	ld	s0,16(sp)
    80002806:	64a2                	ld	s1,8(sp)
    80002808:	6902                	ld	s2,0(sp)
    8000280a:	6105                	addi	sp,sp,32
    8000280c:	8082                	ret

000000008000280e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000280e:	1101                	addi	sp,sp,-32
    80002810:	ec06                	sd	ra,24(sp)
    80002812:	e822                	sd	s0,16(sp)
    80002814:	e426                	sd	s1,8(sp)
    80002816:	e04a                	sd	s2,0(sp)
    80002818:	1000                	addi	s0,sp,32
    8000281a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000281c:	00d5d59b          	srliw	a1,a1,0xd
    80002820:	00019797          	auipc	a5,0x19
    80002824:	8e47a783          	lw	a5,-1820(a5) # 8001b104 <sb+0x1c>
    80002828:	9dbd                	addw	a1,a1,a5
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	c34080e7          	jalr	-972(ra) # 8000245e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002832:	0074f713          	andi	a4,s1,7
    80002836:	4785                	li	a5,1
    80002838:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000283c:	14ce                	slli	s1,s1,0x33
    8000283e:	90d9                	srli	s1,s1,0x36
    80002840:	00950733          	add	a4,a0,s1
    80002844:	06074703          	lbu	a4,96(a4)
    80002848:	00e7f6b3          	and	a3,a5,a4
    8000284c:	c69d                	beqz	a3,8000287a <bfree+0x6c>
    8000284e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002850:	94aa                	add	s1,s1,a0
    80002852:	fff7c793          	not	a5,a5
    80002856:	8ff9                	and	a5,a5,a4
    80002858:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    8000285c:	00001097          	auipc	ra,0x1
    80002860:	118080e7          	jalr	280(ra) # 80003974 <log_write>
  brelse(bp);
    80002864:	854a                	mv	a0,s2
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	e5e080e7          	jalr	-418(ra) # 800026c4 <brelse>
}
    8000286e:	60e2                	ld	ra,24(sp)
    80002870:	6442                	ld	s0,16(sp)
    80002872:	64a2                	ld	s1,8(sp)
    80002874:	6902                	ld	s2,0(sp)
    80002876:	6105                	addi	sp,sp,32
    80002878:	8082                	ret
    panic("freeing free block");
    8000287a:	00006517          	auipc	a0,0x6
    8000287e:	c3650513          	addi	a0,a0,-970 # 800084b0 <syscalls+0xe8>
    80002882:	00004097          	auipc	ra,0x4
    80002886:	93a080e7          	jalr	-1734(ra) # 800061bc <panic>

000000008000288a <balloc>:
{
    8000288a:	711d                	addi	sp,sp,-96
    8000288c:	ec86                	sd	ra,88(sp)
    8000288e:	e8a2                	sd	s0,80(sp)
    80002890:	e4a6                	sd	s1,72(sp)
    80002892:	e0ca                	sd	s2,64(sp)
    80002894:	fc4e                	sd	s3,56(sp)
    80002896:	f852                	sd	s4,48(sp)
    80002898:	f456                	sd	s5,40(sp)
    8000289a:	f05a                	sd	s6,32(sp)
    8000289c:	ec5e                	sd	s7,24(sp)
    8000289e:	e862                	sd	s8,16(sp)
    800028a0:	e466                	sd	s9,8(sp)
    800028a2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800028a4:	00019797          	auipc	a5,0x19
    800028a8:	8487a783          	lw	a5,-1976(a5) # 8001b0ec <sb+0x4>
    800028ac:	cbd1                	beqz	a5,80002940 <balloc+0xb6>
    800028ae:	8baa                	mv	s7,a0
    800028b0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028b2:	00019b17          	auipc	s6,0x19
    800028b6:	836b0b13          	addi	s6,s6,-1994 # 8001b0e8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ba:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800028bc:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028be:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028c0:	6c89                	lui	s9,0x2
    800028c2:	a831                	j	800028de <balloc+0x54>
    brelse(bp);
    800028c4:	854a                	mv	a0,s2
    800028c6:	00000097          	auipc	ra,0x0
    800028ca:	dfe080e7          	jalr	-514(ra) # 800026c4 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ce:	015c87bb          	addw	a5,s9,s5
    800028d2:	00078a9b          	sext.w	s5,a5
    800028d6:	004b2703          	lw	a4,4(s6)
    800028da:	06eaf363          	bgeu	s5,a4,80002940 <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    800028de:	41fad79b          	sraiw	a5,s5,0x1f
    800028e2:	0137d79b          	srliw	a5,a5,0x13
    800028e6:	015787bb          	addw	a5,a5,s5
    800028ea:	40d7d79b          	sraiw	a5,a5,0xd
    800028ee:	01cb2583          	lw	a1,28(s6)
    800028f2:	9dbd                	addw	a1,a1,a5
    800028f4:	855e                	mv	a0,s7
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	b68080e7          	jalr	-1176(ra) # 8000245e <bread>
    800028fe:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002900:	004b2503          	lw	a0,4(s6)
    80002904:	000a849b          	sext.w	s1,s5
    80002908:	8662                	mv	a2,s8
    8000290a:	faa4fde3          	bgeu	s1,a0,800028c4 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000290e:	41f6579b          	sraiw	a5,a2,0x1f
    80002912:	01d7d69b          	srliw	a3,a5,0x1d
    80002916:	00c6873b          	addw	a4,a3,a2
    8000291a:	00777793          	andi	a5,a4,7
    8000291e:	9f95                	subw	a5,a5,a3
    80002920:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002924:	4037571b          	sraiw	a4,a4,0x3
    80002928:	00e906b3          	add	a3,s2,a4
    8000292c:	0606c683          	lbu	a3,96(a3)
    80002930:	00d7f5b3          	and	a1,a5,a3
    80002934:	cd91                	beqz	a1,80002950 <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002936:	2605                	addiw	a2,a2,1
    80002938:	2485                	addiw	s1,s1,1
    8000293a:	fd4618e3          	bne	a2,s4,8000290a <balloc+0x80>
    8000293e:	b759                	j	800028c4 <balloc+0x3a>
  panic("balloc: out of blocks");
    80002940:	00006517          	auipc	a0,0x6
    80002944:	b8850513          	addi	a0,a0,-1144 # 800084c8 <syscalls+0x100>
    80002948:	00004097          	auipc	ra,0x4
    8000294c:	874080e7          	jalr	-1932(ra) # 800061bc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002950:	974a                	add	a4,a4,s2
    80002952:	8fd5                	or	a5,a5,a3
    80002954:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80002958:	854a                	mv	a0,s2
    8000295a:	00001097          	auipc	ra,0x1
    8000295e:	01a080e7          	jalr	26(ra) # 80003974 <log_write>
        brelse(bp);
    80002962:	854a                	mv	a0,s2
    80002964:	00000097          	auipc	ra,0x0
    80002968:	d60080e7          	jalr	-672(ra) # 800026c4 <brelse>
  bp = bread(dev, bno);
    8000296c:	85a6                	mv	a1,s1
    8000296e:	855e                	mv	a0,s7
    80002970:	00000097          	auipc	ra,0x0
    80002974:	aee080e7          	jalr	-1298(ra) # 8000245e <bread>
    80002978:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000297a:	40000613          	li	a2,1024
    8000297e:	4581                	li	a1,0
    80002980:	06050513          	addi	a0,a0,96
    80002984:	ffffe097          	auipc	ra,0xffffe
    80002988:	9ca080e7          	jalr	-1590(ra) # 8000034e <memset>
  log_write(bp);
    8000298c:	854a                	mv	a0,s2
    8000298e:	00001097          	auipc	ra,0x1
    80002992:	fe6080e7          	jalr	-26(ra) # 80003974 <log_write>
  brelse(bp);
    80002996:	854a                	mv	a0,s2
    80002998:	00000097          	auipc	ra,0x0
    8000299c:	d2c080e7          	jalr	-724(ra) # 800026c4 <brelse>
}
    800029a0:	8526                	mv	a0,s1
    800029a2:	60e6                	ld	ra,88(sp)
    800029a4:	6446                	ld	s0,80(sp)
    800029a6:	64a6                	ld	s1,72(sp)
    800029a8:	6906                	ld	s2,64(sp)
    800029aa:	79e2                	ld	s3,56(sp)
    800029ac:	7a42                	ld	s4,48(sp)
    800029ae:	7aa2                	ld	s5,40(sp)
    800029b0:	7b02                	ld	s6,32(sp)
    800029b2:	6be2                	ld	s7,24(sp)
    800029b4:	6c42                	ld	s8,16(sp)
    800029b6:	6ca2                	ld	s9,8(sp)
    800029b8:	6125                	addi	sp,sp,96
    800029ba:	8082                	ret

00000000800029bc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800029bc:	7179                	addi	sp,sp,-48
    800029be:	f406                	sd	ra,40(sp)
    800029c0:	f022                	sd	s0,32(sp)
    800029c2:	ec26                	sd	s1,24(sp)
    800029c4:	e84a                	sd	s2,16(sp)
    800029c6:	e44e                	sd	s3,8(sp)
    800029c8:	e052                	sd	s4,0(sp)
    800029ca:	1800                	addi	s0,sp,48
    800029cc:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029ce:	47ad                	li	a5,11
    800029d0:	04b7fe63          	bgeu	a5,a1,80002a2c <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029d4:	ff45849b          	addiw	s1,a1,-12
    800029d8:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029dc:	0ff00793          	li	a5,255
    800029e0:	0ae7e363          	bltu	a5,a4,80002a86 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029e4:	08852583          	lw	a1,136(a0)
    800029e8:	c5ad                	beqz	a1,80002a52 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029ea:	00092503          	lw	a0,0(s2)
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	a70080e7          	jalr	-1424(ra) # 8000245e <bread>
    800029f6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029f8:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800029fc:	02049593          	slli	a1,s1,0x20
    80002a00:	9181                	srli	a1,a1,0x20
    80002a02:	058a                	slli	a1,a1,0x2
    80002a04:	00b784b3          	add	s1,a5,a1
    80002a08:	0004a983          	lw	s3,0(s1)
    80002a0c:	04098d63          	beqz	s3,80002a66 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002a10:	8552                	mv	a0,s4
    80002a12:	00000097          	auipc	ra,0x0
    80002a16:	cb2080e7          	jalr	-846(ra) # 800026c4 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002a1a:	854e                	mv	a0,s3
    80002a1c:	70a2                	ld	ra,40(sp)
    80002a1e:	7402                	ld	s0,32(sp)
    80002a20:	64e2                	ld	s1,24(sp)
    80002a22:	6942                	ld	s2,16(sp)
    80002a24:	69a2                	ld	s3,8(sp)
    80002a26:	6a02                	ld	s4,0(sp)
    80002a28:	6145                	addi	sp,sp,48
    80002a2a:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a2c:	02059493          	slli	s1,a1,0x20
    80002a30:	9081                	srli	s1,s1,0x20
    80002a32:	048a                	slli	s1,s1,0x2
    80002a34:	94aa                	add	s1,s1,a0
    80002a36:	0584a983          	lw	s3,88(s1)
    80002a3a:	fe0990e3          	bnez	s3,80002a1a <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a3e:	4108                	lw	a0,0(a0)
    80002a40:	00000097          	auipc	ra,0x0
    80002a44:	e4a080e7          	jalr	-438(ra) # 8000288a <balloc>
    80002a48:	0005099b          	sext.w	s3,a0
    80002a4c:	0534ac23          	sw	s3,88(s1)
    80002a50:	b7e9                	j	80002a1a <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a52:	4108                	lw	a0,0(a0)
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	e36080e7          	jalr	-458(ra) # 8000288a <balloc>
    80002a5c:	0005059b          	sext.w	a1,a0
    80002a60:	08b92423          	sw	a1,136(s2)
    80002a64:	b759                	j	800029ea <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a66:	00092503          	lw	a0,0(s2)
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	e20080e7          	jalr	-480(ra) # 8000288a <balloc>
    80002a72:	0005099b          	sext.w	s3,a0
    80002a76:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a7a:	8552                	mv	a0,s4
    80002a7c:	00001097          	auipc	ra,0x1
    80002a80:	ef8080e7          	jalr	-264(ra) # 80003974 <log_write>
    80002a84:	b771                	j	80002a10 <bmap+0x54>
  panic("bmap: out of range");
    80002a86:	00006517          	auipc	a0,0x6
    80002a8a:	a5a50513          	addi	a0,a0,-1446 # 800084e0 <syscalls+0x118>
    80002a8e:	00003097          	auipc	ra,0x3
    80002a92:	72e080e7          	jalr	1838(ra) # 800061bc <panic>

0000000080002a96 <iget>:
{
    80002a96:	7179                	addi	sp,sp,-48
    80002a98:	f406                	sd	ra,40(sp)
    80002a9a:	f022                	sd	s0,32(sp)
    80002a9c:	ec26                	sd	s1,24(sp)
    80002a9e:	e84a                	sd	s2,16(sp)
    80002aa0:	e44e                	sd	s3,8(sp)
    80002aa2:	e052                	sd	s4,0(sp)
    80002aa4:	1800                	addi	s0,sp,48
    80002aa6:	89aa                	mv	s3,a0
    80002aa8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002aaa:	00018517          	auipc	a0,0x18
    80002aae:	65e50513          	addi	a0,a0,1630 # 8001b108 <itable>
    80002ab2:	00004097          	auipc	ra,0x4
    80002ab6:	c3e080e7          	jalr	-962(ra) # 800066f0 <acquire>
  empty = 0;
    80002aba:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002abc:	00018497          	auipc	s1,0x18
    80002ac0:	66c48493          	addi	s1,s1,1644 # 8001b128 <itable+0x20>
    80002ac4:	0001a697          	auipc	a3,0x1a
    80002ac8:	28468693          	addi	a3,a3,644 # 8001cd48 <log>
    80002acc:	a039                	j	80002ada <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ace:	02090b63          	beqz	s2,80002b04 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002ad2:	09048493          	addi	s1,s1,144
    80002ad6:	02d48a63          	beq	s1,a3,80002b0a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ada:	449c                	lw	a5,8(s1)
    80002adc:	fef059e3          	blez	a5,80002ace <iget+0x38>
    80002ae0:	4098                	lw	a4,0(s1)
    80002ae2:	ff3716e3          	bne	a4,s3,80002ace <iget+0x38>
    80002ae6:	40d8                	lw	a4,4(s1)
    80002ae8:	ff4713e3          	bne	a4,s4,80002ace <iget+0x38>
      ip->ref++;
    80002aec:	2785                	addiw	a5,a5,1
    80002aee:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002af0:	00018517          	auipc	a0,0x18
    80002af4:	61850513          	addi	a0,a0,1560 # 8001b108 <itable>
    80002af8:	00004097          	auipc	ra,0x4
    80002afc:	cc8080e7          	jalr	-824(ra) # 800067c0 <release>
      return ip;
    80002b00:	8926                	mv	s2,s1
    80002b02:	a03d                	j	80002b30 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b04:	f7f9                	bnez	a5,80002ad2 <iget+0x3c>
    80002b06:	8926                	mv	s2,s1
    80002b08:	b7e9                	j	80002ad2 <iget+0x3c>
  if(empty == 0)
    80002b0a:	02090c63          	beqz	s2,80002b42 <iget+0xac>
  ip->dev = dev;
    80002b0e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002b12:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002b16:	4785                	li	a5,1
    80002b18:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002b1c:	04092423          	sw	zero,72(s2)
  release(&itable.lock);
    80002b20:	00018517          	auipc	a0,0x18
    80002b24:	5e850513          	addi	a0,a0,1512 # 8001b108 <itable>
    80002b28:	00004097          	auipc	ra,0x4
    80002b2c:	c98080e7          	jalr	-872(ra) # 800067c0 <release>
}
    80002b30:	854a                	mv	a0,s2
    80002b32:	70a2                	ld	ra,40(sp)
    80002b34:	7402                	ld	s0,32(sp)
    80002b36:	64e2                	ld	s1,24(sp)
    80002b38:	6942                	ld	s2,16(sp)
    80002b3a:	69a2                	ld	s3,8(sp)
    80002b3c:	6a02                	ld	s4,0(sp)
    80002b3e:	6145                	addi	sp,sp,48
    80002b40:	8082                	ret
    panic("iget: no inodes");
    80002b42:	00006517          	auipc	a0,0x6
    80002b46:	9b650513          	addi	a0,a0,-1610 # 800084f8 <syscalls+0x130>
    80002b4a:	00003097          	auipc	ra,0x3
    80002b4e:	672080e7          	jalr	1650(ra) # 800061bc <panic>

0000000080002b52 <fsinit>:
fsinit(int dev) {
    80002b52:	7179                	addi	sp,sp,-48
    80002b54:	f406                	sd	ra,40(sp)
    80002b56:	f022                	sd	s0,32(sp)
    80002b58:	ec26                	sd	s1,24(sp)
    80002b5a:	e84a                	sd	s2,16(sp)
    80002b5c:	e44e                	sd	s3,8(sp)
    80002b5e:	1800                	addi	s0,sp,48
    80002b60:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b62:	4585                	li	a1,1
    80002b64:	00000097          	auipc	ra,0x0
    80002b68:	8fa080e7          	jalr	-1798(ra) # 8000245e <bread>
    80002b6c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b6e:	00018997          	auipc	s3,0x18
    80002b72:	57a98993          	addi	s3,s3,1402 # 8001b0e8 <sb>
    80002b76:	02000613          	li	a2,32
    80002b7a:	06050593          	addi	a1,a0,96
    80002b7e:	854e                	mv	a0,s3
    80002b80:	ffffe097          	auipc	ra,0xffffe
    80002b84:	82e080e7          	jalr	-2002(ra) # 800003ae <memmove>
  brelse(bp);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	00000097          	auipc	ra,0x0
    80002b8e:	b3a080e7          	jalr	-1222(ra) # 800026c4 <brelse>
  if(sb.magic != FSMAGIC)
    80002b92:	0009a703          	lw	a4,0(s3)
    80002b96:	102037b7          	lui	a5,0x10203
    80002b9a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b9e:	02f71263          	bne	a4,a5,80002bc2 <fsinit+0x70>
  initlog(dev, &sb);
    80002ba2:	00018597          	auipc	a1,0x18
    80002ba6:	54658593          	addi	a1,a1,1350 # 8001b0e8 <sb>
    80002baa:	854a                	mv	a0,s2
    80002bac:	00001097          	auipc	ra,0x1
    80002bb0:	b4c080e7          	jalr	-1204(ra) # 800036f8 <initlog>
}
    80002bb4:	70a2                	ld	ra,40(sp)
    80002bb6:	7402                	ld	s0,32(sp)
    80002bb8:	64e2                	ld	s1,24(sp)
    80002bba:	6942                	ld	s2,16(sp)
    80002bbc:	69a2                	ld	s3,8(sp)
    80002bbe:	6145                	addi	sp,sp,48
    80002bc0:	8082                	ret
    panic("invalid file system");
    80002bc2:	00006517          	auipc	a0,0x6
    80002bc6:	94650513          	addi	a0,a0,-1722 # 80008508 <syscalls+0x140>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	5f2080e7          	jalr	1522(ra) # 800061bc <panic>

0000000080002bd2 <iinit>:
{
    80002bd2:	7179                	addi	sp,sp,-48
    80002bd4:	f406                	sd	ra,40(sp)
    80002bd6:	f022                	sd	s0,32(sp)
    80002bd8:	ec26                	sd	s1,24(sp)
    80002bda:	e84a                	sd	s2,16(sp)
    80002bdc:	e44e                	sd	s3,8(sp)
    80002bde:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002be0:	00006597          	auipc	a1,0x6
    80002be4:	94058593          	addi	a1,a1,-1728 # 80008520 <syscalls+0x158>
    80002be8:	00018517          	auipc	a0,0x18
    80002bec:	52050513          	addi	a0,a0,1312 # 8001b108 <itable>
    80002bf0:	00004097          	auipc	ra,0x4
    80002bf4:	c7c080e7          	jalr	-900(ra) # 8000686c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bf8:	00018497          	auipc	s1,0x18
    80002bfc:	54048493          	addi	s1,s1,1344 # 8001b138 <itable+0x30>
    80002c00:	0001a997          	auipc	s3,0x1a
    80002c04:	15898993          	addi	s3,s3,344 # 8001cd58 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002c08:	00006917          	auipc	s2,0x6
    80002c0c:	92090913          	addi	s2,s2,-1760 # 80008528 <syscalls+0x160>
    80002c10:	85ca                	mv	a1,s2
    80002c12:	8526                	mv	a0,s1
    80002c14:	00001097          	auipc	ra,0x1
    80002c18:	e46080e7          	jalr	-442(ra) # 80003a5a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002c1c:	09048493          	addi	s1,s1,144
    80002c20:	ff3498e3          	bne	s1,s3,80002c10 <iinit+0x3e>
}
    80002c24:	70a2                	ld	ra,40(sp)
    80002c26:	7402                	ld	s0,32(sp)
    80002c28:	64e2                	ld	s1,24(sp)
    80002c2a:	6942                	ld	s2,16(sp)
    80002c2c:	69a2                	ld	s3,8(sp)
    80002c2e:	6145                	addi	sp,sp,48
    80002c30:	8082                	ret

0000000080002c32 <ialloc>:
{
    80002c32:	715d                	addi	sp,sp,-80
    80002c34:	e486                	sd	ra,72(sp)
    80002c36:	e0a2                	sd	s0,64(sp)
    80002c38:	fc26                	sd	s1,56(sp)
    80002c3a:	f84a                	sd	s2,48(sp)
    80002c3c:	f44e                	sd	s3,40(sp)
    80002c3e:	f052                	sd	s4,32(sp)
    80002c40:	ec56                	sd	s5,24(sp)
    80002c42:	e85a                	sd	s6,16(sp)
    80002c44:	e45e                	sd	s7,8(sp)
    80002c46:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c48:	00018717          	auipc	a4,0x18
    80002c4c:	4ac72703          	lw	a4,1196(a4) # 8001b0f4 <sb+0xc>
    80002c50:	4785                	li	a5,1
    80002c52:	04e7fa63          	bgeu	a5,a4,80002ca6 <ialloc+0x74>
    80002c56:	8aaa                	mv	s5,a0
    80002c58:	8bae                	mv	s7,a1
    80002c5a:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c5c:	00018a17          	auipc	s4,0x18
    80002c60:	48ca0a13          	addi	s4,s4,1164 # 8001b0e8 <sb>
    80002c64:	00048b1b          	sext.w	s6,s1
    80002c68:	0044d593          	srli	a1,s1,0x4
    80002c6c:	018a2783          	lw	a5,24(s4)
    80002c70:	9dbd                	addw	a1,a1,a5
    80002c72:	8556                	mv	a0,s5
    80002c74:	fffff097          	auipc	ra,0xfffff
    80002c78:	7ea080e7          	jalr	2026(ra) # 8000245e <bread>
    80002c7c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c7e:	06050993          	addi	s3,a0,96
    80002c82:	00f4f793          	andi	a5,s1,15
    80002c86:	079a                	slli	a5,a5,0x6
    80002c88:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c8a:	00099783          	lh	a5,0(s3)
    80002c8e:	c785                	beqz	a5,80002cb6 <ialloc+0x84>
    brelse(bp);
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	a34080e7          	jalr	-1484(ra) # 800026c4 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c98:	0485                	addi	s1,s1,1
    80002c9a:	00ca2703          	lw	a4,12(s4)
    80002c9e:	0004879b          	sext.w	a5,s1
    80002ca2:	fce7e1e3          	bltu	a5,a4,80002c64 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	88a50513          	addi	a0,a0,-1910 # 80008530 <syscalls+0x168>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	50e080e7          	jalr	1294(ra) # 800061bc <panic>
      memset(dip, 0, sizeof(*dip));
    80002cb6:	04000613          	li	a2,64
    80002cba:	4581                	li	a1,0
    80002cbc:	854e                	mv	a0,s3
    80002cbe:	ffffd097          	auipc	ra,0xffffd
    80002cc2:	690080e7          	jalr	1680(ra) # 8000034e <memset>
      dip->type = type;
    80002cc6:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	ca8080e7          	jalr	-856(ra) # 80003974 <log_write>
      brelse(bp);
    80002cd4:	854a                	mv	a0,s2
    80002cd6:	00000097          	auipc	ra,0x0
    80002cda:	9ee080e7          	jalr	-1554(ra) # 800026c4 <brelse>
      return iget(dev, inum);
    80002cde:	85da                	mv	a1,s6
    80002ce0:	8556                	mv	a0,s5
    80002ce2:	00000097          	auipc	ra,0x0
    80002ce6:	db4080e7          	jalr	-588(ra) # 80002a96 <iget>
}
    80002cea:	60a6                	ld	ra,72(sp)
    80002cec:	6406                	ld	s0,64(sp)
    80002cee:	74e2                	ld	s1,56(sp)
    80002cf0:	7942                	ld	s2,48(sp)
    80002cf2:	79a2                	ld	s3,40(sp)
    80002cf4:	7a02                	ld	s4,32(sp)
    80002cf6:	6ae2                	ld	s5,24(sp)
    80002cf8:	6b42                	ld	s6,16(sp)
    80002cfa:	6ba2                	ld	s7,8(sp)
    80002cfc:	6161                	addi	sp,sp,80
    80002cfe:	8082                	ret

0000000080002d00 <iupdate>:
{
    80002d00:	1101                	addi	sp,sp,-32
    80002d02:	ec06                	sd	ra,24(sp)
    80002d04:	e822                	sd	s0,16(sp)
    80002d06:	e426                	sd	s1,8(sp)
    80002d08:	e04a                	sd	s2,0(sp)
    80002d0a:	1000                	addi	s0,sp,32
    80002d0c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d0e:	415c                	lw	a5,4(a0)
    80002d10:	0047d79b          	srliw	a5,a5,0x4
    80002d14:	00018597          	auipc	a1,0x18
    80002d18:	3ec5a583          	lw	a1,1004(a1) # 8001b100 <sb+0x18>
    80002d1c:	9dbd                	addw	a1,a1,a5
    80002d1e:	4108                	lw	a0,0(a0)
    80002d20:	fffff097          	auipc	ra,0xfffff
    80002d24:	73e080e7          	jalr	1854(ra) # 8000245e <bread>
    80002d28:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d2a:	06050793          	addi	a5,a0,96
    80002d2e:	40c8                	lw	a0,4(s1)
    80002d30:	893d                	andi	a0,a0,15
    80002d32:	051a                	slli	a0,a0,0x6
    80002d34:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002d36:	04c49703          	lh	a4,76(s1)
    80002d3a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002d3e:	04e49703          	lh	a4,78(s1)
    80002d42:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002d46:	05049703          	lh	a4,80(s1)
    80002d4a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002d4e:	05249703          	lh	a4,82(s1)
    80002d52:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002d56:	48f8                	lw	a4,84(s1)
    80002d58:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d5a:	03400613          	li	a2,52
    80002d5e:	05848593          	addi	a1,s1,88
    80002d62:	0531                	addi	a0,a0,12
    80002d64:	ffffd097          	auipc	ra,0xffffd
    80002d68:	64a080e7          	jalr	1610(ra) # 800003ae <memmove>
  log_write(bp);
    80002d6c:	854a                	mv	a0,s2
    80002d6e:	00001097          	auipc	ra,0x1
    80002d72:	c06080e7          	jalr	-1018(ra) # 80003974 <log_write>
  brelse(bp);
    80002d76:	854a                	mv	a0,s2
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	94c080e7          	jalr	-1716(ra) # 800026c4 <brelse>
}
    80002d80:	60e2                	ld	ra,24(sp)
    80002d82:	6442                	ld	s0,16(sp)
    80002d84:	64a2                	ld	s1,8(sp)
    80002d86:	6902                	ld	s2,0(sp)
    80002d88:	6105                	addi	sp,sp,32
    80002d8a:	8082                	ret

0000000080002d8c <idup>:
{
    80002d8c:	1101                	addi	sp,sp,-32
    80002d8e:	ec06                	sd	ra,24(sp)
    80002d90:	e822                	sd	s0,16(sp)
    80002d92:	e426                	sd	s1,8(sp)
    80002d94:	1000                	addi	s0,sp,32
    80002d96:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d98:	00018517          	auipc	a0,0x18
    80002d9c:	37050513          	addi	a0,a0,880 # 8001b108 <itable>
    80002da0:	00004097          	auipc	ra,0x4
    80002da4:	950080e7          	jalr	-1712(ra) # 800066f0 <acquire>
  ip->ref++;
    80002da8:	449c                	lw	a5,8(s1)
    80002daa:	2785                	addiw	a5,a5,1
    80002dac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dae:	00018517          	auipc	a0,0x18
    80002db2:	35a50513          	addi	a0,a0,858 # 8001b108 <itable>
    80002db6:	00004097          	auipc	ra,0x4
    80002dba:	a0a080e7          	jalr	-1526(ra) # 800067c0 <release>
}
    80002dbe:	8526                	mv	a0,s1
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	64a2                	ld	s1,8(sp)
    80002dc6:	6105                	addi	sp,sp,32
    80002dc8:	8082                	ret

0000000080002dca <ilock>:
{
    80002dca:	1101                	addi	sp,sp,-32
    80002dcc:	ec06                	sd	ra,24(sp)
    80002dce:	e822                	sd	s0,16(sp)
    80002dd0:	e426                	sd	s1,8(sp)
    80002dd2:	e04a                	sd	s2,0(sp)
    80002dd4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002dd6:	c115                	beqz	a0,80002dfa <ilock+0x30>
    80002dd8:	84aa                	mv	s1,a0
    80002dda:	451c                	lw	a5,8(a0)
    80002ddc:	00f05f63          	blez	a5,80002dfa <ilock+0x30>
  acquiresleep(&ip->lock);
    80002de0:	0541                	addi	a0,a0,16
    80002de2:	00001097          	auipc	ra,0x1
    80002de6:	cb2080e7          	jalr	-846(ra) # 80003a94 <acquiresleep>
  if(ip->valid == 0){
    80002dea:	44bc                	lw	a5,72(s1)
    80002dec:	cf99                	beqz	a5,80002e0a <ilock+0x40>
}
    80002dee:	60e2                	ld	ra,24(sp)
    80002df0:	6442                	ld	s0,16(sp)
    80002df2:	64a2                	ld	s1,8(sp)
    80002df4:	6902                	ld	s2,0(sp)
    80002df6:	6105                	addi	sp,sp,32
    80002df8:	8082                	ret
    panic("ilock");
    80002dfa:	00005517          	auipc	a0,0x5
    80002dfe:	74e50513          	addi	a0,a0,1870 # 80008548 <syscalls+0x180>
    80002e02:	00003097          	auipc	ra,0x3
    80002e06:	3ba080e7          	jalr	954(ra) # 800061bc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e0a:	40dc                	lw	a5,4(s1)
    80002e0c:	0047d79b          	srliw	a5,a5,0x4
    80002e10:	00018597          	auipc	a1,0x18
    80002e14:	2f05a583          	lw	a1,752(a1) # 8001b100 <sb+0x18>
    80002e18:	9dbd                	addw	a1,a1,a5
    80002e1a:	4088                	lw	a0,0(s1)
    80002e1c:	fffff097          	auipc	ra,0xfffff
    80002e20:	642080e7          	jalr	1602(ra) # 8000245e <bread>
    80002e24:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e26:	06050593          	addi	a1,a0,96
    80002e2a:	40dc                	lw	a5,4(s1)
    80002e2c:	8bbd                	andi	a5,a5,15
    80002e2e:	079a                	slli	a5,a5,0x6
    80002e30:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e32:	00059783          	lh	a5,0(a1)
    80002e36:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002e3a:	00259783          	lh	a5,2(a1)
    80002e3e:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    80002e42:	00459783          	lh	a5,4(a1)
    80002e46:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002e4a:	00659783          	lh	a5,6(a1)
    80002e4e:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    80002e52:	459c                	lw	a5,8(a1)
    80002e54:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e56:	03400613          	li	a2,52
    80002e5a:	05b1                	addi	a1,a1,12
    80002e5c:	05848513          	addi	a0,s1,88
    80002e60:	ffffd097          	auipc	ra,0xffffd
    80002e64:	54e080e7          	jalr	1358(ra) # 800003ae <memmove>
    brelse(bp);
    80002e68:	854a                	mv	a0,s2
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	85a080e7          	jalr	-1958(ra) # 800026c4 <brelse>
    ip->valid = 1;
    80002e72:	4785                	li	a5,1
    80002e74:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002e76:	04c49783          	lh	a5,76(s1)
    80002e7a:	fbb5                	bnez	a5,80002dee <ilock+0x24>
      panic("ilock: no type");
    80002e7c:	00005517          	auipc	a0,0x5
    80002e80:	6d450513          	addi	a0,a0,1748 # 80008550 <syscalls+0x188>
    80002e84:	00003097          	auipc	ra,0x3
    80002e88:	338080e7          	jalr	824(ra) # 800061bc <panic>

0000000080002e8c <iunlock>:
{
    80002e8c:	1101                	addi	sp,sp,-32
    80002e8e:	ec06                	sd	ra,24(sp)
    80002e90:	e822                	sd	s0,16(sp)
    80002e92:	e426                	sd	s1,8(sp)
    80002e94:	e04a                	sd	s2,0(sp)
    80002e96:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e98:	c905                	beqz	a0,80002ec8 <iunlock+0x3c>
    80002e9a:	84aa                	mv	s1,a0
    80002e9c:	01050913          	addi	s2,a0,16
    80002ea0:	854a                	mv	a0,s2
    80002ea2:	00001097          	auipc	ra,0x1
    80002ea6:	c8c080e7          	jalr	-884(ra) # 80003b2e <holdingsleep>
    80002eaa:	cd19                	beqz	a0,80002ec8 <iunlock+0x3c>
    80002eac:	449c                	lw	a5,8(s1)
    80002eae:	00f05d63          	blez	a5,80002ec8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002eb2:	854a                	mv	a0,s2
    80002eb4:	00001097          	auipc	ra,0x1
    80002eb8:	c36080e7          	jalr	-970(ra) # 80003aea <releasesleep>
}
    80002ebc:	60e2                	ld	ra,24(sp)
    80002ebe:	6442                	ld	s0,16(sp)
    80002ec0:	64a2                	ld	s1,8(sp)
    80002ec2:	6902                	ld	s2,0(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret
    panic("iunlock");
    80002ec8:	00005517          	auipc	a0,0x5
    80002ecc:	69850513          	addi	a0,a0,1688 # 80008560 <syscalls+0x198>
    80002ed0:	00003097          	auipc	ra,0x3
    80002ed4:	2ec080e7          	jalr	748(ra) # 800061bc <panic>

0000000080002ed8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ed8:	7179                	addi	sp,sp,-48
    80002eda:	f406                	sd	ra,40(sp)
    80002edc:	f022                	sd	s0,32(sp)
    80002ede:	ec26                	sd	s1,24(sp)
    80002ee0:	e84a                	sd	s2,16(sp)
    80002ee2:	e44e                	sd	s3,8(sp)
    80002ee4:	e052                	sd	s4,0(sp)
    80002ee6:	1800                	addi	s0,sp,48
    80002ee8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002eea:	05850493          	addi	s1,a0,88
    80002eee:	08850913          	addi	s2,a0,136
    80002ef2:	a021                	j	80002efa <itrunc+0x22>
    80002ef4:	0491                	addi	s1,s1,4
    80002ef6:	01248d63          	beq	s1,s2,80002f10 <itrunc+0x38>
    if(ip->addrs[i]){
    80002efa:	408c                	lw	a1,0(s1)
    80002efc:	dde5                	beqz	a1,80002ef4 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002efe:	0009a503          	lw	a0,0(s3)
    80002f02:	00000097          	auipc	ra,0x0
    80002f06:	90c080e7          	jalr	-1780(ra) # 8000280e <bfree>
      ip->addrs[i] = 0;
    80002f0a:	0004a023          	sw	zero,0(s1)
    80002f0e:	b7dd                	j	80002ef4 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002f10:	0889a583          	lw	a1,136(s3)
    80002f14:	e185                	bnez	a1,80002f34 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002f16:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    80002f1a:	854e                	mv	a0,s3
    80002f1c:	00000097          	auipc	ra,0x0
    80002f20:	de4080e7          	jalr	-540(ra) # 80002d00 <iupdate>
}
    80002f24:	70a2                	ld	ra,40(sp)
    80002f26:	7402                	ld	s0,32(sp)
    80002f28:	64e2                	ld	s1,24(sp)
    80002f2a:	6942                	ld	s2,16(sp)
    80002f2c:	69a2                	ld	s3,8(sp)
    80002f2e:	6a02                	ld	s4,0(sp)
    80002f30:	6145                	addi	sp,sp,48
    80002f32:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f34:	0009a503          	lw	a0,0(s3)
    80002f38:	fffff097          	auipc	ra,0xfffff
    80002f3c:	526080e7          	jalr	1318(ra) # 8000245e <bread>
    80002f40:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f42:	06050493          	addi	s1,a0,96
    80002f46:	46050913          	addi	s2,a0,1120
    80002f4a:	a811                	j	80002f5e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002f4c:	0009a503          	lw	a0,0(s3)
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	8be080e7          	jalr	-1858(ra) # 8000280e <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002f58:	0491                	addi	s1,s1,4
    80002f5a:	01248563          	beq	s1,s2,80002f64 <itrunc+0x8c>
      if(a[j])
    80002f5e:	408c                	lw	a1,0(s1)
    80002f60:	dde5                	beqz	a1,80002f58 <itrunc+0x80>
    80002f62:	b7ed                	j	80002f4c <itrunc+0x74>
    brelse(bp);
    80002f64:	8552                	mv	a0,s4
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	75e080e7          	jalr	1886(ra) # 800026c4 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f6e:	0889a583          	lw	a1,136(s3)
    80002f72:	0009a503          	lw	a0,0(s3)
    80002f76:	00000097          	auipc	ra,0x0
    80002f7a:	898080e7          	jalr	-1896(ra) # 8000280e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f7e:	0809a423          	sw	zero,136(s3)
    80002f82:	bf51                	j	80002f16 <itrunc+0x3e>

0000000080002f84 <iput>:
{
    80002f84:	1101                	addi	sp,sp,-32
    80002f86:	ec06                	sd	ra,24(sp)
    80002f88:	e822                	sd	s0,16(sp)
    80002f8a:	e426                	sd	s1,8(sp)
    80002f8c:	e04a                	sd	s2,0(sp)
    80002f8e:	1000                	addi	s0,sp,32
    80002f90:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f92:	00018517          	auipc	a0,0x18
    80002f96:	17650513          	addi	a0,a0,374 # 8001b108 <itable>
    80002f9a:	00003097          	auipc	ra,0x3
    80002f9e:	756080e7          	jalr	1878(ra) # 800066f0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa2:	4498                	lw	a4,8(s1)
    80002fa4:	4785                	li	a5,1
    80002fa6:	02f70363          	beq	a4,a5,80002fcc <iput+0x48>
  ip->ref--;
    80002faa:	449c                	lw	a5,8(s1)
    80002fac:	37fd                	addiw	a5,a5,-1
    80002fae:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002fb0:	00018517          	auipc	a0,0x18
    80002fb4:	15850513          	addi	a0,a0,344 # 8001b108 <itable>
    80002fb8:	00004097          	auipc	ra,0x4
    80002fbc:	808080e7          	jalr	-2040(ra) # 800067c0 <release>
}
    80002fc0:	60e2                	ld	ra,24(sp)
    80002fc2:	6442                	ld	s0,16(sp)
    80002fc4:	64a2                	ld	s1,8(sp)
    80002fc6:	6902                	ld	s2,0(sp)
    80002fc8:	6105                	addi	sp,sp,32
    80002fca:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fcc:	44bc                	lw	a5,72(s1)
    80002fce:	dff1                	beqz	a5,80002faa <iput+0x26>
    80002fd0:	05249783          	lh	a5,82(s1)
    80002fd4:	fbf9                	bnez	a5,80002faa <iput+0x26>
    acquiresleep(&ip->lock);
    80002fd6:	01048913          	addi	s2,s1,16
    80002fda:	854a                	mv	a0,s2
    80002fdc:	00001097          	auipc	ra,0x1
    80002fe0:	ab8080e7          	jalr	-1352(ra) # 80003a94 <acquiresleep>
    release(&itable.lock);
    80002fe4:	00018517          	auipc	a0,0x18
    80002fe8:	12450513          	addi	a0,a0,292 # 8001b108 <itable>
    80002fec:	00003097          	auipc	ra,0x3
    80002ff0:	7d4080e7          	jalr	2004(ra) # 800067c0 <release>
    itrunc(ip);
    80002ff4:	8526                	mv	a0,s1
    80002ff6:	00000097          	auipc	ra,0x0
    80002ffa:	ee2080e7          	jalr	-286(ra) # 80002ed8 <itrunc>
    ip->type = 0;
    80002ffe:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003002:	8526                	mv	a0,s1
    80003004:	00000097          	auipc	ra,0x0
    80003008:	cfc080e7          	jalr	-772(ra) # 80002d00 <iupdate>
    ip->valid = 0;
    8000300c:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003010:	854a                	mv	a0,s2
    80003012:	00001097          	auipc	ra,0x1
    80003016:	ad8080e7          	jalr	-1320(ra) # 80003aea <releasesleep>
    acquire(&itable.lock);
    8000301a:	00018517          	auipc	a0,0x18
    8000301e:	0ee50513          	addi	a0,a0,238 # 8001b108 <itable>
    80003022:	00003097          	auipc	ra,0x3
    80003026:	6ce080e7          	jalr	1742(ra) # 800066f0 <acquire>
    8000302a:	b741                	j	80002faa <iput+0x26>

000000008000302c <iunlockput>:
{
    8000302c:	1101                	addi	sp,sp,-32
    8000302e:	ec06                	sd	ra,24(sp)
    80003030:	e822                	sd	s0,16(sp)
    80003032:	e426                	sd	s1,8(sp)
    80003034:	1000                	addi	s0,sp,32
    80003036:	84aa                	mv	s1,a0
  iunlock(ip);
    80003038:	00000097          	auipc	ra,0x0
    8000303c:	e54080e7          	jalr	-428(ra) # 80002e8c <iunlock>
  iput(ip);
    80003040:	8526                	mv	a0,s1
    80003042:	00000097          	auipc	ra,0x0
    80003046:	f42080e7          	jalr	-190(ra) # 80002f84 <iput>
}
    8000304a:	60e2                	ld	ra,24(sp)
    8000304c:	6442                	ld	s0,16(sp)
    8000304e:	64a2                	ld	s1,8(sp)
    80003050:	6105                	addi	sp,sp,32
    80003052:	8082                	ret

0000000080003054 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003054:	1141                	addi	sp,sp,-16
    80003056:	e422                	sd	s0,8(sp)
    80003058:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000305a:	411c                	lw	a5,0(a0)
    8000305c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000305e:	415c                	lw	a5,4(a0)
    80003060:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003062:	04c51783          	lh	a5,76(a0)
    80003066:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000306a:	05251783          	lh	a5,82(a0)
    8000306e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003072:	05456783          	lwu	a5,84(a0)
    80003076:	e99c                	sd	a5,16(a1)
}
    80003078:	6422                	ld	s0,8(sp)
    8000307a:	0141                	addi	sp,sp,16
    8000307c:	8082                	ret

000000008000307e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000307e:	497c                	lw	a5,84(a0)
    80003080:	0ed7e963          	bltu	a5,a3,80003172 <readi+0xf4>
{
    80003084:	7159                	addi	sp,sp,-112
    80003086:	f486                	sd	ra,104(sp)
    80003088:	f0a2                	sd	s0,96(sp)
    8000308a:	eca6                	sd	s1,88(sp)
    8000308c:	e8ca                	sd	s2,80(sp)
    8000308e:	e4ce                	sd	s3,72(sp)
    80003090:	e0d2                	sd	s4,64(sp)
    80003092:	fc56                	sd	s5,56(sp)
    80003094:	f85a                	sd	s6,48(sp)
    80003096:	f45e                	sd	s7,40(sp)
    80003098:	f062                	sd	s8,32(sp)
    8000309a:	ec66                	sd	s9,24(sp)
    8000309c:	e86a                	sd	s10,16(sp)
    8000309e:	e46e                	sd	s11,8(sp)
    800030a0:	1880                	addi	s0,sp,112
    800030a2:	8baa                	mv	s7,a0
    800030a4:	8c2e                	mv	s8,a1
    800030a6:	8ab2                	mv	s5,a2
    800030a8:	84b6                	mv	s1,a3
    800030aa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800030ac:	9f35                	addw	a4,a4,a3
    return 0;
    800030ae:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800030b0:	0ad76063          	bltu	a4,a3,80003150 <readi+0xd2>
  if(off + n > ip->size)
    800030b4:	00e7f463          	bgeu	a5,a4,800030bc <readi+0x3e>
    n = ip->size - off;
    800030b8:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030bc:	0a0b0963          	beqz	s6,8000316e <readi+0xf0>
    800030c0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c2:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030c6:	5cfd                	li	s9,-1
    800030c8:	a82d                	j	80003102 <readi+0x84>
    800030ca:	020a1d93          	slli	s11,s4,0x20
    800030ce:	020ddd93          	srli	s11,s11,0x20
    800030d2:	06090613          	addi	a2,s2,96
    800030d6:	86ee                	mv	a3,s11
    800030d8:	963a                	add	a2,a2,a4
    800030da:	85d6                	mv	a1,s5
    800030dc:	8562                	mv	a0,s8
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	9b0080e7          	jalr	-1616(ra) # 80001a8e <either_copyout>
    800030e6:	05950d63          	beq	a0,s9,80003140 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030ea:	854a                	mv	a0,s2
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	5d8080e7          	jalr	1496(ra) # 800026c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030f4:	013a09bb          	addw	s3,s4,s3
    800030f8:	009a04bb          	addw	s1,s4,s1
    800030fc:	9aee                	add	s5,s5,s11
    800030fe:	0569f763          	bgeu	s3,s6,8000314c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003102:	000ba903          	lw	s2,0(s7)
    80003106:	00a4d59b          	srliw	a1,s1,0xa
    8000310a:	855e                	mv	a0,s7
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	8b0080e7          	jalr	-1872(ra) # 800029bc <bmap>
    80003114:	0005059b          	sext.w	a1,a0
    80003118:	854a                	mv	a0,s2
    8000311a:	fffff097          	auipc	ra,0xfffff
    8000311e:	344080e7          	jalr	836(ra) # 8000245e <bread>
    80003122:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003124:	3ff4f713          	andi	a4,s1,1023
    80003128:	40ed07bb          	subw	a5,s10,a4
    8000312c:	413b06bb          	subw	a3,s6,s3
    80003130:	8a3e                	mv	s4,a5
    80003132:	2781                	sext.w	a5,a5
    80003134:	0006861b          	sext.w	a2,a3
    80003138:	f8f679e3          	bgeu	a2,a5,800030ca <readi+0x4c>
    8000313c:	8a36                	mv	s4,a3
    8000313e:	b771                	j	800030ca <readi+0x4c>
      brelse(bp);
    80003140:	854a                	mv	a0,s2
    80003142:	fffff097          	auipc	ra,0xfffff
    80003146:	582080e7          	jalr	1410(ra) # 800026c4 <brelse>
      tot = -1;
    8000314a:	59fd                	li	s3,-1
  }
  return tot;
    8000314c:	0009851b          	sext.w	a0,s3
}
    80003150:	70a6                	ld	ra,104(sp)
    80003152:	7406                	ld	s0,96(sp)
    80003154:	64e6                	ld	s1,88(sp)
    80003156:	6946                	ld	s2,80(sp)
    80003158:	69a6                	ld	s3,72(sp)
    8000315a:	6a06                	ld	s4,64(sp)
    8000315c:	7ae2                	ld	s5,56(sp)
    8000315e:	7b42                	ld	s6,48(sp)
    80003160:	7ba2                	ld	s7,40(sp)
    80003162:	7c02                	ld	s8,32(sp)
    80003164:	6ce2                	ld	s9,24(sp)
    80003166:	6d42                	ld	s10,16(sp)
    80003168:	6da2                	ld	s11,8(sp)
    8000316a:	6165                	addi	sp,sp,112
    8000316c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000316e:	89da                	mv	s3,s6
    80003170:	bff1                	j	8000314c <readi+0xce>
    return 0;
    80003172:	4501                	li	a0,0
}
    80003174:	8082                	ret

0000000080003176 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003176:	497c                	lw	a5,84(a0)
    80003178:	10d7e863          	bltu	a5,a3,80003288 <writei+0x112>
{
    8000317c:	7159                	addi	sp,sp,-112
    8000317e:	f486                	sd	ra,104(sp)
    80003180:	f0a2                	sd	s0,96(sp)
    80003182:	eca6                	sd	s1,88(sp)
    80003184:	e8ca                	sd	s2,80(sp)
    80003186:	e4ce                	sd	s3,72(sp)
    80003188:	e0d2                	sd	s4,64(sp)
    8000318a:	fc56                	sd	s5,56(sp)
    8000318c:	f85a                	sd	s6,48(sp)
    8000318e:	f45e                	sd	s7,40(sp)
    80003190:	f062                	sd	s8,32(sp)
    80003192:	ec66                	sd	s9,24(sp)
    80003194:	e86a                	sd	s10,16(sp)
    80003196:	e46e                	sd	s11,8(sp)
    80003198:	1880                	addi	s0,sp,112
    8000319a:	8b2a                	mv	s6,a0
    8000319c:	8c2e                	mv	s8,a1
    8000319e:	8ab2                	mv	s5,a2
    800031a0:	8936                	mv	s2,a3
    800031a2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    800031a4:	00e687bb          	addw	a5,a3,a4
    800031a8:	0ed7e263          	bltu	a5,a3,8000328c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800031ac:	00043737          	lui	a4,0x43
    800031b0:	0ef76063          	bltu	a4,a5,80003290 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031b4:	0c0b8863          	beqz	s7,80003284 <writei+0x10e>
    800031b8:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031ba:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031be:	5cfd                	li	s9,-1
    800031c0:	a091                	j	80003204 <writei+0x8e>
    800031c2:	02099d93          	slli	s11,s3,0x20
    800031c6:	020ddd93          	srli	s11,s11,0x20
    800031ca:	06048513          	addi	a0,s1,96
    800031ce:	86ee                	mv	a3,s11
    800031d0:	8656                	mv	a2,s5
    800031d2:	85e2                	mv	a1,s8
    800031d4:	953a                	add	a0,a0,a4
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	90e080e7          	jalr	-1778(ra) # 80001ae4 <either_copyin>
    800031de:	07950263          	beq	a0,s9,80003242 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031e2:	8526                	mv	a0,s1
    800031e4:	00000097          	auipc	ra,0x0
    800031e8:	790080e7          	jalr	1936(ra) # 80003974 <log_write>
    brelse(bp);
    800031ec:	8526                	mv	a0,s1
    800031ee:	fffff097          	auipc	ra,0xfffff
    800031f2:	4d6080e7          	jalr	1238(ra) # 800026c4 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031f6:	01498a3b          	addw	s4,s3,s4
    800031fa:	0129893b          	addw	s2,s3,s2
    800031fe:	9aee                	add	s5,s5,s11
    80003200:	057a7663          	bgeu	s4,s7,8000324c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003204:	000b2483          	lw	s1,0(s6)
    80003208:	00a9559b          	srliw	a1,s2,0xa
    8000320c:	855a                	mv	a0,s6
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	7ae080e7          	jalr	1966(ra) # 800029bc <bmap>
    80003216:	0005059b          	sext.w	a1,a0
    8000321a:	8526                	mv	a0,s1
    8000321c:	fffff097          	auipc	ra,0xfffff
    80003220:	242080e7          	jalr	578(ra) # 8000245e <bread>
    80003224:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003226:	3ff97713          	andi	a4,s2,1023
    8000322a:	40ed07bb          	subw	a5,s10,a4
    8000322e:	414b86bb          	subw	a3,s7,s4
    80003232:	89be                	mv	s3,a5
    80003234:	2781                	sext.w	a5,a5
    80003236:	0006861b          	sext.w	a2,a3
    8000323a:	f8f674e3          	bgeu	a2,a5,800031c2 <writei+0x4c>
    8000323e:	89b6                	mv	s3,a3
    80003240:	b749                	j	800031c2 <writei+0x4c>
      brelse(bp);
    80003242:	8526                	mv	a0,s1
    80003244:	fffff097          	auipc	ra,0xfffff
    80003248:	480080e7          	jalr	1152(ra) # 800026c4 <brelse>
  }

  if(off > ip->size)
    8000324c:	054b2783          	lw	a5,84(s6)
    80003250:	0127f463          	bgeu	a5,s2,80003258 <writei+0xe2>
    ip->size = off;
    80003254:	052b2a23          	sw	s2,84(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003258:	855a                	mv	a0,s6
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	aa6080e7          	jalr	-1370(ra) # 80002d00 <iupdate>

  return tot;
    80003262:	000a051b          	sext.w	a0,s4
}
    80003266:	70a6                	ld	ra,104(sp)
    80003268:	7406                	ld	s0,96(sp)
    8000326a:	64e6                	ld	s1,88(sp)
    8000326c:	6946                	ld	s2,80(sp)
    8000326e:	69a6                	ld	s3,72(sp)
    80003270:	6a06                	ld	s4,64(sp)
    80003272:	7ae2                	ld	s5,56(sp)
    80003274:	7b42                	ld	s6,48(sp)
    80003276:	7ba2                	ld	s7,40(sp)
    80003278:	7c02                	ld	s8,32(sp)
    8000327a:	6ce2                	ld	s9,24(sp)
    8000327c:	6d42                	ld	s10,16(sp)
    8000327e:	6da2                	ld	s11,8(sp)
    80003280:	6165                	addi	sp,sp,112
    80003282:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003284:	8a5e                	mv	s4,s7
    80003286:	bfc9                	j	80003258 <writei+0xe2>
    return -1;
    80003288:	557d                	li	a0,-1
}
    8000328a:	8082                	ret
    return -1;
    8000328c:	557d                	li	a0,-1
    8000328e:	bfe1                	j	80003266 <writei+0xf0>
    return -1;
    80003290:	557d                	li	a0,-1
    80003292:	bfd1                	j	80003266 <writei+0xf0>

0000000080003294 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003294:	1141                	addi	sp,sp,-16
    80003296:	e406                	sd	ra,8(sp)
    80003298:	e022                	sd	s0,0(sp)
    8000329a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000329c:	4639                	li	a2,14
    8000329e:	ffffd097          	auipc	ra,0xffffd
    800032a2:	188080e7          	jalr	392(ra) # 80000426 <strncmp>
}
    800032a6:	60a2                	ld	ra,8(sp)
    800032a8:	6402                	ld	s0,0(sp)
    800032aa:	0141                	addi	sp,sp,16
    800032ac:	8082                	ret

00000000800032ae <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032ae:	7139                	addi	sp,sp,-64
    800032b0:	fc06                	sd	ra,56(sp)
    800032b2:	f822                	sd	s0,48(sp)
    800032b4:	f426                	sd	s1,40(sp)
    800032b6:	f04a                	sd	s2,32(sp)
    800032b8:	ec4e                	sd	s3,24(sp)
    800032ba:	e852                	sd	s4,16(sp)
    800032bc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032be:	04c51703          	lh	a4,76(a0)
    800032c2:	4785                	li	a5,1
    800032c4:	00f71a63          	bne	a4,a5,800032d8 <dirlookup+0x2a>
    800032c8:	892a                	mv	s2,a0
    800032ca:	89ae                	mv	s3,a1
    800032cc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ce:	497c                	lw	a5,84(a0)
    800032d0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032d2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032d4:	e79d                	bnez	a5,80003302 <dirlookup+0x54>
    800032d6:	a8a5                	j	8000334e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032d8:	00005517          	auipc	a0,0x5
    800032dc:	29050513          	addi	a0,a0,656 # 80008568 <syscalls+0x1a0>
    800032e0:	00003097          	auipc	ra,0x3
    800032e4:	edc080e7          	jalr	-292(ra) # 800061bc <panic>
      panic("dirlookup read");
    800032e8:	00005517          	auipc	a0,0x5
    800032ec:	29850513          	addi	a0,a0,664 # 80008580 <syscalls+0x1b8>
    800032f0:	00003097          	auipc	ra,0x3
    800032f4:	ecc080e7          	jalr	-308(ra) # 800061bc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f8:	24c1                	addiw	s1,s1,16
    800032fa:	05492783          	lw	a5,84(s2)
    800032fe:	04f4f763          	bgeu	s1,a5,8000334c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003302:	4741                	li	a4,16
    80003304:	86a6                	mv	a3,s1
    80003306:	fc040613          	addi	a2,s0,-64
    8000330a:	4581                	li	a1,0
    8000330c:	854a                	mv	a0,s2
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	d70080e7          	jalr	-656(ra) # 8000307e <readi>
    80003316:	47c1                	li	a5,16
    80003318:	fcf518e3          	bne	a0,a5,800032e8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000331c:	fc045783          	lhu	a5,-64(s0)
    80003320:	dfe1                	beqz	a5,800032f8 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003322:	fc240593          	addi	a1,s0,-62
    80003326:	854e                	mv	a0,s3
    80003328:	00000097          	auipc	ra,0x0
    8000332c:	f6c080e7          	jalr	-148(ra) # 80003294 <namecmp>
    80003330:	f561                	bnez	a0,800032f8 <dirlookup+0x4a>
      if(poff)
    80003332:	000a0463          	beqz	s4,8000333a <dirlookup+0x8c>
        *poff = off;
    80003336:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000333a:	fc045583          	lhu	a1,-64(s0)
    8000333e:	00092503          	lw	a0,0(s2)
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	754080e7          	jalr	1876(ra) # 80002a96 <iget>
    8000334a:	a011                	j	8000334e <dirlookup+0xa0>
  return 0;
    8000334c:	4501                	li	a0,0
}
    8000334e:	70e2                	ld	ra,56(sp)
    80003350:	7442                	ld	s0,48(sp)
    80003352:	74a2                	ld	s1,40(sp)
    80003354:	7902                	ld	s2,32(sp)
    80003356:	69e2                	ld	s3,24(sp)
    80003358:	6a42                	ld	s4,16(sp)
    8000335a:	6121                	addi	sp,sp,64
    8000335c:	8082                	ret

000000008000335e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000335e:	711d                	addi	sp,sp,-96
    80003360:	ec86                	sd	ra,88(sp)
    80003362:	e8a2                	sd	s0,80(sp)
    80003364:	e4a6                	sd	s1,72(sp)
    80003366:	e0ca                	sd	s2,64(sp)
    80003368:	fc4e                	sd	s3,56(sp)
    8000336a:	f852                	sd	s4,48(sp)
    8000336c:	f456                	sd	s5,40(sp)
    8000336e:	f05a                	sd	s6,32(sp)
    80003370:	ec5e                	sd	s7,24(sp)
    80003372:	e862                	sd	s8,16(sp)
    80003374:	e466                	sd	s9,8(sp)
    80003376:	1080                	addi	s0,sp,96
    80003378:	84aa                	mv	s1,a0
    8000337a:	8b2e                	mv	s6,a1
    8000337c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000337e:	00054703          	lbu	a4,0(a0)
    80003382:	02f00793          	li	a5,47
    80003386:	02f70363          	beq	a4,a5,800033ac <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000338a:	ffffe097          	auipc	ra,0xffffe
    8000338e:	ca4080e7          	jalr	-860(ra) # 8000102e <myproc>
    80003392:	15853503          	ld	a0,344(a0)
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	9f6080e7          	jalr	-1546(ra) # 80002d8c <idup>
    8000339e:	89aa                	mv	s3,a0
  while(*path == '/')
    800033a0:	02f00913          	li	s2,47
  len = path - s;
    800033a4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800033a6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800033a8:	4c05                	li	s8,1
    800033aa:	a865                	j	80003462 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800033ac:	4585                	li	a1,1
    800033ae:	4505                	li	a0,1
    800033b0:	fffff097          	auipc	ra,0xfffff
    800033b4:	6e6080e7          	jalr	1766(ra) # 80002a96 <iget>
    800033b8:	89aa                	mv	s3,a0
    800033ba:	b7dd                	j	800033a0 <namex+0x42>
      iunlockput(ip);
    800033bc:	854e                	mv	a0,s3
    800033be:	00000097          	auipc	ra,0x0
    800033c2:	c6e080e7          	jalr	-914(ra) # 8000302c <iunlockput>
      return 0;
    800033c6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033c8:	854e                	mv	a0,s3
    800033ca:	60e6                	ld	ra,88(sp)
    800033cc:	6446                	ld	s0,80(sp)
    800033ce:	64a6                	ld	s1,72(sp)
    800033d0:	6906                	ld	s2,64(sp)
    800033d2:	79e2                	ld	s3,56(sp)
    800033d4:	7a42                	ld	s4,48(sp)
    800033d6:	7aa2                	ld	s5,40(sp)
    800033d8:	7b02                	ld	s6,32(sp)
    800033da:	6be2                	ld	s7,24(sp)
    800033dc:	6c42                	ld	s8,16(sp)
    800033de:	6ca2                	ld	s9,8(sp)
    800033e0:	6125                	addi	sp,sp,96
    800033e2:	8082                	ret
      iunlock(ip);
    800033e4:	854e                	mv	a0,s3
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	aa6080e7          	jalr	-1370(ra) # 80002e8c <iunlock>
      return ip;
    800033ee:	bfe9                	j	800033c8 <namex+0x6a>
      iunlockput(ip);
    800033f0:	854e                	mv	a0,s3
    800033f2:	00000097          	auipc	ra,0x0
    800033f6:	c3a080e7          	jalr	-966(ra) # 8000302c <iunlockput>
      return 0;
    800033fa:	89d2                	mv	s3,s4
    800033fc:	b7f1                	j	800033c8 <namex+0x6a>
  len = path - s;
    800033fe:	40b48633          	sub	a2,s1,a1
    80003402:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003406:	094cd463          	bge	s9,s4,8000348e <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000340a:	4639                	li	a2,14
    8000340c:	8556                	mv	a0,s5
    8000340e:	ffffd097          	auipc	ra,0xffffd
    80003412:	fa0080e7          	jalr	-96(ra) # 800003ae <memmove>
  while(*path == '/')
    80003416:	0004c783          	lbu	a5,0(s1)
    8000341a:	01279763          	bne	a5,s2,80003428 <namex+0xca>
    path++;
    8000341e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003420:	0004c783          	lbu	a5,0(s1)
    80003424:	ff278de3          	beq	a5,s2,8000341e <namex+0xc0>
    ilock(ip);
    80003428:	854e                	mv	a0,s3
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	9a0080e7          	jalr	-1632(ra) # 80002dca <ilock>
    if(ip->type != T_DIR){
    80003432:	04c99783          	lh	a5,76(s3)
    80003436:	f98793e3          	bne	a5,s8,800033bc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000343a:	000b0563          	beqz	s6,80003444 <namex+0xe6>
    8000343e:	0004c783          	lbu	a5,0(s1)
    80003442:	d3cd                	beqz	a5,800033e4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003444:	865e                	mv	a2,s7
    80003446:	85d6                	mv	a1,s5
    80003448:	854e                	mv	a0,s3
    8000344a:	00000097          	auipc	ra,0x0
    8000344e:	e64080e7          	jalr	-412(ra) # 800032ae <dirlookup>
    80003452:	8a2a                	mv	s4,a0
    80003454:	dd51                	beqz	a0,800033f0 <namex+0x92>
    iunlockput(ip);
    80003456:	854e                	mv	a0,s3
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	bd4080e7          	jalr	-1068(ra) # 8000302c <iunlockput>
    ip = next;
    80003460:	89d2                	mv	s3,s4
  while(*path == '/')
    80003462:	0004c783          	lbu	a5,0(s1)
    80003466:	05279763          	bne	a5,s2,800034b4 <namex+0x156>
    path++;
    8000346a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000346c:	0004c783          	lbu	a5,0(s1)
    80003470:	ff278de3          	beq	a5,s2,8000346a <namex+0x10c>
  if(*path == 0)
    80003474:	c79d                	beqz	a5,800034a2 <namex+0x144>
    path++;
    80003476:	85a6                	mv	a1,s1
  len = path - s;
    80003478:	8a5e                	mv	s4,s7
    8000347a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000347c:	01278963          	beq	a5,s2,8000348e <namex+0x130>
    80003480:	dfbd                	beqz	a5,800033fe <namex+0xa0>
    path++;
    80003482:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003484:	0004c783          	lbu	a5,0(s1)
    80003488:	ff279ce3          	bne	a5,s2,80003480 <namex+0x122>
    8000348c:	bf8d                	j	800033fe <namex+0xa0>
    memmove(name, s, len);
    8000348e:	2601                	sext.w	a2,a2
    80003490:	8556                	mv	a0,s5
    80003492:	ffffd097          	auipc	ra,0xffffd
    80003496:	f1c080e7          	jalr	-228(ra) # 800003ae <memmove>
    name[len] = 0;
    8000349a:	9a56                	add	s4,s4,s5
    8000349c:	000a0023          	sb	zero,0(s4)
    800034a0:	bf9d                	j	80003416 <namex+0xb8>
  if(nameiparent){
    800034a2:	f20b03e3          	beqz	s6,800033c8 <namex+0x6a>
    iput(ip);
    800034a6:	854e                	mv	a0,s3
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	adc080e7          	jalr	-1316(ra) # 80002f84 <iput>
    return 0;
    800034b0:	4981                	li	s3,0
    800034b2:	bf19                	j	800033c8 <namex+0x6a>
  if(*path == 0)
    800034b4:	d7fd                	beqz	a5,800034a2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800034b6:	0004c783          	lbu	a5,0(s1)
    800034ba:	85a6                	mv	a1,s1
    800034bc:	b7d1                	j	80003480 <namex+0x122>

00000000800034be <dirlink>:
{
    800034be:	7139                	addi	sp,sp,-64
    800034c0:	fc06                	sd	ra,56(sp)
    800034c2:	f822                	sd	s0,48(sp)
    800034c4:	f426                	sd	s1,40(sp)
    800034c6:	f04a                	sd	s2,32(sp)
    800034c8:	ec4e                	sd	s3,24(sp)
    800034ca:	e852                	sd	s4,16(sp)
    800034cc:	0080                	addi	s0,sp,64
    800034ce:	892a                	mv	s2,a0
    800034d0:	8a2e                	mv	s4,a1
    800034d2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034d4:	4601                	li	a2,0
    800034d6:	00000097          	auipc	ra,0x0
    800034da:	dd8080e7          	jalr	-552(ra) # 800032ae <dirlookup>
    800034de:	e93d                	bnez	a0,80003554 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034e0:	05492483          	lw	s1,84(s2)
    800034e4:	c49d                	beqz	s1,80003512 <dirlink+0x54>
    800034e6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034e8:	4741                	li	a4,16
    800034ea:	86a6                	mv	a3,s1
    800034ec:	fc040613          	addi	a2,s0,-64
    800034f0:	4581                	li	a1,0
    800034f2:	854a                	mv	a0,s2
    800034f4:	00000097          	auipc	ra,0x0
    800034f8:	b8a080e7          	jalr	-1142(ra) # 8000307e <readi>
    800034fc:	47c1                	li	a5,16
    800034fe:	06f51163          	bne	a0,a5,80003560 <dirlink+0xa2>
    if(de.inum == 0)
    80003502:	fc045783          	lhu	a5,-64(s0)
    80003506:	c791                	beqz	a5,80003512 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003508:	24c1                	addiw	s1,s1,16
    8000350a:	05492783          	lw	a5,84(s2)
    8000350e:	fcf4ede3          	bltu	s1,a5,800034e8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003512:	4639                	li	a2,14
    80003514:	85d2                	mv	a1,s4
    80003516:	fc240513          	addi	a0,s0,-62
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	f48080e7          	jalr	-184(ra) # 80000462 <strncpy>
  de.inum = inum;
    80003522:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003526:	4741                	li	a4,16
    80003528:	86a6                	mv	a3,s1
    8000352a:	fc040613          	addi	a2,s0,-64
    8000352e:	4581                	li	a1,0
    80003530:	854a                	mv	a0,s2
    80003532:	00000097          	auipc	ra,0x0
    80003536:	c44080e7          	jalr	-956(ra) # 80003176 <writei>
    8000353a:	872a                	mv	a4,a0
    8000353c:	47c1                	li	a5,16
  return 0;
    8000353e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003540:	02f71863          	bne	a4,a5,80003570 <dirlink+0xb2>
}
    80003544:	70e2                	ld	ra,56(sp)
    80003546:	7442                	ld	s0,48(sp)
    80003548:	74a2                	ld	s1,40(sp)
    8000354a:	7902                	ld	s2,32(sp)
    8000354c:	69e2                	ld	s3,24(sp)
    8000354e:	6a42                	ld	s4,16(sp)
    80003550:	6121                	addi	sp,sp,64
    80003552:	8082                	ret
    iput(ip);
    80003554:	00000097          	auipc	ra,0x0
    80003558:	a30080e7          	jalr	-1488(ra) # 80002f84 <iput>
    return -1;
    8000355c:	557d                	li	a0,-1
    8000355e:	b7dd                	j	80003544 <dirlink+0x86>
      panic("dirlink read");
    80003560:	00005517          	auipc	a0,0x5
    80003564:	03050513          	addi	a0,a0,48 # 80008590 <syscalls+0x1c8>
    80003568:	00003097          	auipc	ra,0x3
    8000356c:	c54080e7          	jalr	-940(ra) # 800061bc <panic>
    panic("dirlink");
    80003570:	00005517          	auipc	a0,0x5
    80003574:	13050513          	addi	a0,a0,304 # 800086a0 <syscalls+0x2d8>
    80003578:	00003097          	auipc	ra,0x3
    8000357c:	c44080e7          	jalr	-956(ra) # 800061bc <panic>

0000000080003580 <namei>:

struct inode*
namei(char *path)
{
    80003580:	1101                	addi	sp,sp,-32
    80003582:	ec06                	sd	ra,24(sp)
    80003584:	e822                	sd	s0,16(sp)
    80003586:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003588:	fe040613          	addi	a2,s0,-32
    8000358c:	4581                	li	a1,0
    8000358e:	00000097          	auipc	ra,0x0
    80003592:	dd0080e7          	jalr	-560(ra) # 8000335e <namex>
}
    80003596:	60e2                	ld	ra,24(sp)
    80003598:	6442                	ld	s0,16(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000359e:	1141                	addi	sp,sp,-16
    800035a0:	e406                	sd	ra,8(sp)
    800035a2:	e022                	sd	s0,0(sp)
    800035a4:	0800                	addi	s0,sp,16
    800035a6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800035a8:	4585                	li	a1,1
    800035aa:	00000097          	auipc	ra,0x0
    800035ae:	db4080e7          	jalr	-588(ra) # 8000335e <namex>
}
    800035b2:	60a2                	ld	ra,8(sp)
    800035b4:	6402                	ld	s0,0(sp)
    800035b6:	0141                	addi	sp,sp,16
    800035b8:	8082                	ret

00000000800035ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035ba:	1101                	addi	sp,sp,-32
    800035bc:	ec06                	sd	ra,24(sp)
    800035be:	e822                	sd	s0,16(sp)
    800035c0:	e426                	sd	s1,8(sp)
    800035c2:	e04a                	sd	s2,0(sp)
    800035c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035c6:	00019917          	auipc	s2,0x19
    800035ca:	78290913          	addi	s2,s2,1922 # 8001cd48 <log>
    800035ce:	02092583          	lw	a1,32(s2)
    800035d2:	03092503          	lw	a0,48(s2)
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	e88080e7          	jalr	-376(ra) # 8000245e <bread>
    800035de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035e0:	03492683          	lw	a3,52(s2)
    800035e4:	d134                	sw	a3,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035e6:	02d05763          	blez	a3,80003614 <write_head+0x5a>
    800035ea:	00019797          	auipc	a5,0x19
    800035ee:	79678793          	addi	a5,a5,1942 # 8001cd80 <log+0x38>
    800035f2:	06450713          	addi	a4,a0,100
    800035f6:	36fd                	addiw	a3,a3,-1
    800035f8:	1682                	slli	a3,a3,0x20
    800035fa:	9281                	srli	a3,a3,0x20
    800035fc:	068a                	slli	a3,a3,0x2
    800035fe:	00019617          	auipc	a2,0x19
    80003602:	78660613          	addi	a2,a2,1926 # 8001cd84 <log+0x3c>
    80003606:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003608:	4390                	lw	a2,0(a5)
    8000360a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000360c:	0791                	addi	a5,a5,4
    8000360e:	0711                	addi	a4,a4,4
    80003610:	fed79ce3          	bne	a5,a3,80003608 <write_head+0x4e>
  }
  bwrite(buf);
    80003614:	8526                	mv	a0,s1
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	070080e7          	jalr	112(ra) # 80002686 <bwrite>
  brelse(buf);
    8000361e:	8526                	mv	a0,s1
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	0a4080e7          	jalr	164(ra) # 800026c4 <brelse>
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003634:	00019797          	auipc	a5,0x19
    80003638:	7487a783          	lw	a5,1864(a5) # 8001cd7c <log+0x34>
    8000363c:	0af05d63          	blez	a5,800036f6 <install_trans+0xc2>
{
    80003640:	7139                	addi	sp,sp,-64
    80003642:	fc06                	sd	ra,56(sp)
    80003644:	f822                	sd	s0,48(sp)
    80003646:	f426                	sd	s1,40(sp)
    80003648:	f04a                	sd	s2,32(sp)
    8000364a:	ec4e                	sd	s3,24(sp)
    8000364c:	e852                	sd	s4,16(sp)
    8000364e:	e456                	sd	s5,8(sp)
    80003650:	e05a                	sd	s6,0(sp)
    80003652:	0080                	addi	s0,sp,64
    80003654:	8b2a                	mv	s6,a0
    80003656:	00019a97          	auipc	s5,0x19
    8000365a:	72aa8a93          	addi	s5,s5,1834 # 8001cd80 <log+0x38>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000365e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003660:	00019997          	auipc	s3,0x19
    80003664:	6e898993          	addi	s3,s3,1768 # 8001cd48 <log>
    80003668:	a035                	j	80003694 <install_trans+0x60>
      bunpin(dbuf);
    8000366a:	8526                	mv	a0,s1
    8000366c:	fffff097          	auipc	ra,0xfffff
    80003670:	148080e7          	jalr	328(ra) # 800027b4 <bunpin>
    brelse(lbuf);
    80003674:	854a                	mv	a0,s2
    80003676:	fffff097          	auipc	ra,0xfffff
    8000367a:	04e080e7          	jalr	78(ra) # 800026c4 <brelse>
    brelse(dbuf);
    8000367e:	8526                	mv	a0,s1
    80003680:	fffff097          	auipc	ra,0xfffff
    80003684:	044080e7          	jalr	68(ra) # 800026c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003688:	2a05                	addiw	s4,s4,1
    8000368a:	0a91                	addi	s5,s5,4
    8000368c:	0349a783          	lw	a5,52(s3)
    80003690:	04fa5963          	bge	s4,a5,800036e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003694:	0209a583          	lw	a1,32(s3)
    80003698:	014585bb          	addw	a1,a1,s4
    8000369c:	2585                	addiw	a1,a1,1
    8000369e:	0309a503          	lw	a0,48(s3)
    800036a2:	fffff097          	auipc	ra,0xfffff
    800036a6:	dbc080e7          	jalr	-580(ra) # 8000245e <bread>
    800036aa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800036ac:	000aa583          	lw	a1,0(s5)
    800036b0:	0309a503          	lw	a0,48(s3)
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	daa080e7          	jalr	-598(ra) # 8000245e <bread>
    800036bc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800036be:	40000613          	li	a2,1024
    800036c2:	06090593          	addi	a1,s2,96
    800036c6:	06050513          	addi	a0,a0,96
    800036ca:	ffffd097          	auipc	ra,0xffffd
    800036ce:	ce4080e7          	jalr	-796(ra) # 800003ae <memmove>
    bwrite(dbuf);  // write dst to disk
    800036d2:	8526                	mv	a0,s1
    800036d4:	fffff097          	auipc	ra,0xfffff
    800036d8:	fb2080e7          	jalr	-78(ra) # 80002686 <bwrite>
    if(recovering == 0)
    800036dc:	f80b1ce3          	bnez	s6,80003674 <install_trans+0x40>
    800036e0:	b769                	j	8000366a <install_trans+0x36>
}
    800036e2:	70e2                	ld	ra,56(sp)
    800036e4:	7442                	ld	s0,48(sp)
    800036e6:	74a2                	ld	s1,40(sp)
    800036e8:	7902                	ld	s2,32(sp)
    800036ea:	69e2                	ld	s3,24(sp)
    800036ec:	6a42                	ld	s4,16(sp)
    800036ee:	6aa2                	ld	s5,8(sp)
    800036f0:	6b02                	ld	s6,0(sp)
    800036f2:	6121                	addi	sp,sp,64
    800036f4:	8082                	ret
    800036f6:	8082                	ret

00000000800036f8 <initlog>:
{
    800036f8:	7179                	addi	sp,sp,-48
    800036fa:	f406                	sd	ra,40(sp)
    800036fc:	f022                	sd	s0,32(sp)
    800036fe:	ec26                	sd	s1,24(sp)
    80003700:	e84a                	sd	s2,16(sp)
    80003702:	e44e                	sd	s3,8(sp)
    80003704:	1800                	addi	s0,sp,48
    80003706:	892a                	mv	s2,a0
    80003708:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000370a:	00019497          	auipc	s1,0x19
    8000370e:	63e48493          	addi	s1,s1,1598 # 8001cd48 <log>
    80003712:	00005597          	auipc	a1,0x5
    80003716:	e8e58593          	addi	a1,a1,-370 # 800085a0 <syscalls+0x1d8>
    8000371a:	8526                	mv	a0,s1
    8000371c:	00003097          	auipc	ra,0x3
    80003720:	150080e7          	jalr	336(ra) # 8000686c <initlock>
  log.start = sb->logstart;
    80003724:	0149a583          	lw	a1,20(s3)
    80003728:	d08c                	sw	a1,32(s1)
  log.size = sb->nlog;
    8000372a:	0109a783          	lw	a5,16(s3)
    8000372e:	d0dc                	sw	a5,36(s1)
  log.dev = dev;
    80003730:	0324a823          	sw	s2,48(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003734:	854a                	mv	a0,s2
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	d28080e7          	jalr	-728(ra) # 8000245e <bread>
  log.lh.n = lh->n;
    8000373e:	513c                	lw	a5,96(a0)
    80003740:	d8dc                	sw	a5,52(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003742:	02f05563          	blez	a5,8000376c <initlog+0x74>
    80003746:	06450713          	addi	a4,a0,100
    8000374a:	00019697          	auipc	a3,0x19
    8000374e:	63668693          	addi	a3,a3,1590 # 8001cd80 <log+0x38>
    80003752:	37fd                	addiw	a5,a5,-1
    80003754:	1782                	slli	a5,a5,0x20
    80003756:	9381                	srli	a5,a5,0x20
    80003758:	078a                	slli	a5,a5,0x2
    8000375a:	06850613          	addi	a2,a0,104
    8000375e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003760:	4310                	lw	a2,0(a4)
    80003762:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003764:	0711                	addi	a4,a4,4
    80003766:	0691                	addi	a3,a3,4
    80003768:	fef71ce3          	bne	a4,a5,80003760 <initlog+0x68>
  brelse(buf);
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	f58080e7          	jalr	-168(ra) # 800026c4 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003774:	4505                	li	a0,1
    80003776:	00000097          	auipc	ra,0x0
    8000377a:	ebe080e7          	jalr	-322(ra) # 80003634 <install_trans>
  log.lh.n = 0;
    8000377e:	00019797          	auipc	a5,0x19
    80003782:	5e07af23          	sw	zero,1534(a5) # 8001cd7c <log+0x34>
  write_head(); // clear the log
    80003786:	00000097          	auipc	ra,0x0
    8000378a:	e34080e7          	jalr	-460(ra) # 800035ba <write_head>
}
    8000378e:	70a2                	ld	ra,40(sp)
    80003790:	7402                	ld	s0,32(sp)
    80003792:	64e2                	ld	s1,24(sp)
    80003794:	6942                	ld	s2,16(sp)
    80003796:	69a2                	ld	s3,8(sp)
    80003798:	6145                	addi	sp,sp,48
    8000379a:	8082                	ret

000000008000379c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000379c:	1101                	addi	sp,sp,-32
    8000379e:	ec06                	sd	ra,24(sp)
    800037a0:	e822                	sd	s0,16(sp)
    800037a2:	e426                	sd	s1,8(sp)
    800037a4:	e04a                	sd	s2,0(sp)
    800037a6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800037a8:	00019517          	auipc	a0,0x19
    800037ac:	5a050513          	addi	a0,a0,1440 # 8001cd48 <log>
    800037b0:	00003097          	auipc	ra,0x3
    800037b4:	f40080e7          	jalr	-192(ra) # 800066f0 <acquire>
  while(1){
    if(log.committing){
    800037b8:	00019497          	auipc	s1,0x19
    800037bc:	59048493          	addi	s1,s1,1424 # 8001cd48 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037c0:	4979                	li	s2,30
    800037c2:	a039                	j	800037d0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800037c4:	85a6                	mv	a1,s1
    800037c6:	8526                	mv	a0,s1
    800037c8:	ffffe097          	auipc	ra,0xffffe
    800037cc:	f22080e7          	jalr	-222(ra) # 800016ea <sleep>
    if(log.committing){
    800037d0:	54dc                	lw	a5,44(s1)
    800037d2:	fbed                	bnez	a5,800037c4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037d4:	549c                	lw	a5,40(s1)
    800037d6:	0017871b          	addiw	a4,a5,1
    800037da:	0007069b          	sext.w	a3,a4
    800037de:	0027179b          	slliw	a5,a4,0x2
    800037e2:	9fb9                	addw	a5,a5,a4
    800037e4:	0017979b          	slliw	a5,a5,0x1
    800037e8:	58d8                	lw	a4,52(s1)
    800037ea:	9fb9                	addw	a5,a5,a4
    800037ec:	00f95963          	bge	s2,a5,800037fe <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037f0:	85a6                	mv	a1,s1
    800037f2:	8526                	mv	a0,s1
    800037f4:	ffffe097          	auipc	ra,0xffffe
    800037f8:	ef6080e7          	jalr	-266(ra) # 800016ea <sleep>
    800037fc:	bfd1                	j	800037d0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037fe:	00019517          	auipc	a0,0x19
    80003802:	54a50513          	addi	a0,a0,1354 # 8001cd48 <log>
    80003806:	d514                	sw	a3,40(a0)
      release(&log.lock);
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	fb8080e7          	jalr	-72(ra) # 800067c0 <release>
      break;
    }
  }
}
    80003810:	60e2                	ld	ra,24(sp)
    80003812:	6442                	ld	s0,16(sp)
    80003814:	64a2                	ld	s1,8(sp)
    80003816:	6902                	ld	s2,0(sp)
    80003818:	6105                	addi	sp,sp,32
    8000381a:	8082                	ret

000000008000381c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000381c:	7139                	addi	sp,sp,-64
    8000381e:	fc06                	sd	ra,56(sp)
    80003820:	f822                	sd	s0,48(sp)
    80003822:	f426                	sd	s1,40(sp)
    80003824:	f04a                	sd	s2,32(sp)
    80003826:	ec4e                	sd	s3,24(sp)
    80003828:	e852                	sd	s4,16(sp)
    8000382a:	e456                	sd	s5,8(sp)
    8000382c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000382e:	00019497          	auipc	s1,0x19
    80003832:	51a48493          	addi	s1,s1,1306 # 8001cd48 <log>
    80003836:	8526                	mv	a0,s1
    80003838:	00003097          	auipc	ra,0x3
    8000383c:	eb8080e7          	jalr	-328(ra) # 800066f0 <acquire>
  log.outstanding -= 1;
    80003840:	549c                	lw	a5,40(s1)
    80003842:	37fd                	addiw	a5,a5,-1
    80003844:	0007891b          	sext.w	s2,a5
    80003848:	d49c                	sw	a5,40(s1)
  if(log.committing)
    8000384a:	54dc                	lw	a5,44(s1)
    8000384c:	efb9                	bnez	a5,800038aa <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000384e:	06091663          	bnez	s2,800038ba <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003852:	00019497          	auipc	s1,0x19
    80003856:	4f648493          	addi	s1,s1,1270 # 8001cd48 <log>
    8000385a:	4785                	li	a5,1
    8000385c:	d4dc                	sw	a5,44(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	00003097          	auipc	ra,0x3
    80003864:	f60080e7          	jalr	-160(ra) # 800067c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003868:	58dc                	lw	a5,52(s1)
    8000386a:	06f04763          	bgtz	a5,800038d8 <end_op+0xbc>
    acquire(&log.lock);
    8000386e:	00019497          	auipc	s1,0x19
    80003872:	4da48493          	addi	s1,s1,1242 # 8001cd48 <log>
    80003876:	8526                	mv	a0,s1
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	e78080e7          	jalr	-392(ra) # 800066f0 <acquire>
    log.committing = 0;
    80003880:	0204a623          	sw	zero,44(s1)
    wakeup(&log);
    80003884:	8526                	mv	a0,s1
    80003886:	ffffe097          	auipc	ra,0xffffe
    8000388a:	ff0080e7          	jalr	-16(ra) # 80001876 <wakeup>
    release(&log.lock);
    8000388e:	8526                	mv	a0,s1
    80003890:	00003097          	auipc	ra,0x3
    80003894:	f30080e7          	jalr	-208(ra) # 800067c0 <release>
}
    80003898:	70e2                	ld	ra,56(sp)
    8000389a:	7442                	ld	s0,48(sp)
    8000389c:	74a2                	ld	s1,40(sp)
    8000389e:	7902                	ld	s2,32(sp)
    800038a0:	69e2                	ld	s3,24(sp)
    800038a2:	6a42                	ld	s4,16(sp)
    800038a4:	6aa2                	ld	s5,8(sp)
    800038a6:	6121                	addi	sp,sp,64
    800038a8:	8082                	ret
    panic("log.committing");
    800038aa:	00005517          	auipc	a0,0x5
    800038ae:	cfe50513          	addi	a0,a0,-770 # 800085a8 <syscalls+0x1e0>
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	90a080e7          	jalr	-1782(ra) # 800061bc <panic>
    wakeup(&log);
    800038ba:	00019497          	auipc	s1,0x19
    800038be:	48e48493          	addi	s1,s1,1166 # 8001cd48 <log>
    800038c2:	8526                	mv	a0,s1
    800038c4:	ffffe097          	auipc	ra,0xffffe
    800038c8:	fb2080e7          	jalr	-78(ra) # 80001876 <wakeup>
  release(&log.lock);
    800038cc:	8526                	mv	a0,s1
    800038ce:	00003097          	auipc	ra,0x3
    800038d2:	ef2080e7          	jalr	-270(ra) # 800067c0 <release>
  if(do_commit){
    800038d6:	b7c9                	j	80003898 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038d8:	00019a97          	auipc	s5,0x19
    800038dc:	4a8a8a93          	addi	s5,s5,1192 # 8001cd80 <log+0x38>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038e0:	00019a17          	auipc	s4,0x19
    800038e4:	468a0a13          	addi	s4,s4,1128 # 8001cd48 <log>
    800038e8:	020a2583          	lw	a1,32(s4)
    800038ec:	012585bb          	addw	a1,a1,s2
    800038f0:	2585                	addiw	a1,a1,1
    800038f2:	030a2503          	lw	a0,48(s4)
    800038f6:	fffff097          	auipc	ra,0xfffff
    800038fa:	b68080e7          	jalr	-1176(ra) # 8000245e <bread>
    800038fe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003900:	000aa583          	lw	a1,0(s5)
    80003904:	030a2503          	lw	a0,48(s4)
    80003908:	fffff097          	auipc	ra,0xfffff
    8000390c:	b56080e7          	jalr	-1194(ra) # 8000245e <bread>
    80003910:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003912:	40000613          	li	a2,1024
    80003916:	06050593          	addi	a1,a0,96
    8000391a:	06048513          	addi	a0,s1,96
    8000391e:	ffffd097          	auipc	ra,0xffffd
    80003922:	a90080e7          	jalr	-1392(ra) # 800003ae <memmove>
    bwrite(to);  // write the log
    80003926:	8526                	mv	a0,s1
    80003928:	fffff097          	auipc	ra,0xfffff
    8000392c:	d5e080e7          	jalr	-674(ra) # 80002686 <bwrite>
    brelse(from);
    80003930:	854e                	mv	a0,s3
    80003932:	fffff097          	auipc	ra,0xfffff
    80003936:	d92080e7          	jalr	-622(ra) # 800026c4 <brelse>
    brelse(to);
    8000393a:	8526                	mv	a0,s1
    8000393c:	fffff097          	auipc	ra,0xfffff
    80003940:	d88080e7          	jalr	-632(ra) # 800026c4 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003944:	2905                	addiw	s2,s2,1
    80003946:	0a91                	addi	s5,s5,4
    80003948:	034a2783          	lw	a5,52(s4)
    8000394c:	f8f94ee3          	blt	s2,a5,800038e8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003950:	00000097          	auipc	ra,0x0
    80003954:	c6a080e7          	jalr	-918(ra) # 800035ba <write_head>
    install_trans(0); // Now install writes to home locations
    80003958:	4501                	li	a0,0
    8000395a:	00000097          	auipc	ra,0x0
    8000395e:	cda080e7          	jalr	-806(ra) # 80003634 <install_trans>
    log.lh.n = 0;
    80003962:	00019797          	auipc	a5,0x19
    80003966:	4007ad23          	sw	zero,1050(a5) # 8001cd7c <log+0x34>
    write_head();    // Erase the transaction from the log
    8000396a:	00000097          	auipc	ra,0x0
    8000396e:	c50080e7          	jalr	-944(ra) # 800035ba <write_head>
    80003972:	bdf5                	j	8000386e <end_op+0x52>

0000000080003974 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003974:	1101                	addi	sp,sp,-32
    80003976:	ec06                	sd	ra,24(sp)
    80003978:	e822                	sd	s0,16(sp)
    8000397a:	e426                	sd	s1,8(sp)
    8000397c:	e04a                	sd	s2,0(sp)
    8000397e:	1000                	addi	s0,sp,32
    80003980:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003982:	00019917          	auipc	s2,0x19
    80003986:	3c690913          	addi	s2,s2,966 # 8001cd48 <log>
    8000398a:	854a                	mv	a0,s2
    8000398c:	00003097          	auipc	ra,0x3
    80003990:	d64080e7          	jalr	-668(ra) # 800066f0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003994:	03492603          	lw	a2,52(s2)
    80003998:	47f5                	li	a5,29
    8000399a:	06c7c563          	blt	a5,a2,80003a04 <log_write+0x90>
    8000399e:	00019797          	auipc	a5,0x19
    800039a2:	3ce7a783          	lw	a5,974(a5) # 8001cd6c <log+0x24>
    800039a6:	37fd                	addiw	a5,a5,-1
    800039a8:	04f65e63          	bge	a2,a5,80003a04 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800039ac:	00019797          	auipc	a5,0x19
    800039b0:	3c47a783          	lw	a5,964(a5) # 8001cd70 <log+0x28>
    800039b4:	06f05063          	blez	a5,80003a14 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800039b8:	4781                	li	a5,0
    800039ba:	06c05563          	blez	a2,80003a24 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039be:	44cc                	lw	a1,12(s1)
    800039c0:	00019717          	auipc	a4,0x19
    800039c4:	3c070713          	addi	a4,a4,960 # 8001cd80 <log+0x38>
  for (i = 0; i < log.lh.n; i++) {
    800039c8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800039ca:	4314                	lw	a3,0(a4)
    800039cc:	04b68c63          	beq	a3,a1,80003a24 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800039d0:	2785                	addiw	a5,a5,1
    800039d2:	0711                	addi	a4,a4,4
    800039d4:	fef61be3          	bne	a2,a5,800039ca <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800039d8:	0631                	addi	a2,a2,12
    800039da:	060a                	slli	a2,a2,0x2
    800039dc:	00019797          	auipc	a5,0x19
    800039e0:	36c78793          	addi	a5,a5,876 # 8001cd48 <log>
    800039e4:	963e                	add	a2,a2,a5
    800039e6:	44dc                	lw	a5,12(s1)
    800039e8:	c61c                	sw	a5,8(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039ea:	8526                	mv	a0,s1
    800039ec:	fffff097          	auipc	ra,0xfffff
    800039f0:	d6e080e7          	jalr	-658(ra) # 8000275a <bpin>
    log.lh.n++;
    800039f4:	00019717          	auipc	a4,0x19
    800039f8:	35470713          	addi	a4,a4,852 # 8001cd48 <log>
    800039fc:	5b5c                	lw	a5,52(a4)
    800039fe:	2785                	addiw	a5,a5,1
    80003a00:	db5c                	sw	a5,52(a4)
    80003a02:	a835                	j	80003a3e <log_write+0xca>
    panic("too big a transaction");
    80003a04:	00005517          	auipc	a0,0x5
    80003a08:	bb450513          	addi	a0,a0,-1100 # 800085b8 <syscalls+0x1f0>
    80003a0c:	00002097          	auipc	ra,0x2
    80003a10:	7b0080e7          	jalr	1968(ra) # 800061bc <panic>
    panic("log_write outside of trans");
    80003a14:	00005517          	auipc	a0,0x5
    80003a18:	bbc50513          	addi	a0,a0,-1092 # 800085d0 <syscalls+0x208>
    80003a1c:	00002097          	auipc	ra,0x2
    80003a20:	7a0080e7          	jalr	1952(ra) # 800061bc <panic>
  log.lh.block[i] = b->blockno;
    80003a24:	00c78713          	addi	a4,a5,12
    80003a28:	00271693          	slli	a3,a4,0x2
    80003a2c:	00019717          	auipc	a4,0x19
    80003a30:	31c70713          	addi	a4,a4,796 # 8001cd48 <log>
    80003a34:	9736                	add	a4,a4,a3
    80003a36:	44d4                	lw	a3,12(s1)
    80003a38:	c714                	sw	a3,8(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a3a:	faf608e3          	beq	a2,a5,800039ea <log_write+0x76>
  }
  release(&log.lock);
    80003a3e:	00019517          	auipc	a0,0x19
    80003a42:	30a50513          	addi	a0,a0,778 # 8001cd48 <log>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	d7a080e7          	jalr	-646(ra) # 800067c0 <release>
}
    80003a4e:	60e2                	ld	ra,24(sp)
    80003a50:	6442                	ld	s0,16(sp)
    80003a52:	64a2                	ld	s1,8(sp)
    80003a54:	6902                	ld	s2,0(sp)
    80003a56:	6105                	addi	sp,sp,32
    80003a58:	8082                	ret

0000000080003a5a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a5a:	1101                	addi	sp,sp,-32
    80003a5c:	ec06                	sd	ra,24(sp)
    80003a5e:	e822                	sd	s0,16(sp)
    80003a60:	e426                	sd	s1,8(sp)
    80003a62:	e04a                	sd	s2,0(sp)
    80003a64:	1000                	addi	s0,sp,32
    80003a66:	84aa                	mv	s1,a0
    80003a68:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a6a:	00005597          	auipc	a1,0x5
    80003a6e:	b8658593          	addi	a1,a1,-1146 # 800085f0 <syscalls+0x228>
    80003a72:	0521                	addi	a0,a0,8
    80003a74:	00003097          	auipc	ra,0x3
    80003a78:	df8080e7          	jalr	-520(ra) # 8000686c <initlock>
  lk->name = name;
    80003a7c:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003a80:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a84:	0204a823          	sw	zero,48(s1)
}
    80003a88:	60e2                	ld	ra,24(sp)
    80003a8a:	6442                	ld	s0,16(sp)
    80003a8c:	64a2                	ld	s1,8(sp)
    80003a8e:	6902                	ld	s2,0(sp)
    80003a90:	6105                	addi	sp,sp,32
    80003a92:	8082                	ret

0000000080003a94 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a94:	1101                	addi	sp,sp,-32
    80003a96:	ec06                	sd	ra,24(sp)
    80003a98:	e822                	sd	s0,16(sp)
    80003a9a:	e426                	sd	s1,8(sp)
    80003a9c:	e04a                	sd	s2,0(sp)
    80003a9e:	1000                	addi	s0,sp,32
    80003aa0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aa2:	00850913          	addi	s2,a0,8
    80003aa6:	854a                	mv	a0,s2
    80003aa8:	00003097          	auipc	ra,0x3
    80003aac:	c48080e7          	jalr	-952(ra) # 800066f0 <acquire>
  while (lk->locked) {
    80003ab0:	409c                	lw	a5,0(s1)
    80003ab2:	cb89                	beqz	a5,80003ac4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ab4:	85ca                	mv	a1,s2
    80003ab6:	8526                	mv	a0,s1
    80003ab8:	ffffe097          	auipc	ra,0xffffe
    80003abc:	c32080e7          	jalr	-974(ra) # 800016ea <sleep>
  while (lk->locked) {
    80003ac0:	409c                	lw	a5,0(s1)
    80003ac2:	fbed                	bnez	a5,80003ab4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003ac4:	4785                	li	a5,1
    80003ac6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003ac8:	ffffd097          	auipc	ra,0xffffd
    80003acc:	566080e7          	jalr	1382(ra) # 8000102e <myproc>
    80003ad0:	5d1c                	lw	a5,56(a0)
    80003ad2:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	cea080e7          	jalr	-790(ra) # 800067c0 <release>
}
    80003ade:	60e2                	ld	ra,24(sp)
    80003ae0:	6442                	ld	s0,16(sp)
    80003ae2:	64a2                	ld	s1,8(sp)
    80003ae4:	6902                	ld	s2,0(sp)
    80003ae6:	6105                	addi	sp,sp,32
    80003ae8:	8082                	ret

0000000080003aea <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003aea:	1101                	addi	sp,sp,-32
    80003aec:	ec06                	sd	ra,24(sp)
    80003aee:	e822                	sd	s0,16(sp)
    80003af0:	e426                	sd	s1,8(sp)
    80003af2:	e04a                	sd	s2,0(sp)
    80003af4:	1000                	addi	s0,sp,32
    80003af6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003af8:	00850913          	addi	s2,a0,8
    80003afc:	854a                	mv	a0,s2
    80003afe:	00003097          	auipc	ra,0x3
    80003b02:	bf2080e7          	jalr	-1038(ra) # 800066f0 <acquire>
  lk->locked = 0;
    80003b06:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b0a:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    80003b0e:	8526                	mv	a0,s1
    80003b10:	ffffe097          	auipc	ra,0xffffe
    80003b14:	d66080e7          	jalr	-666(ra) # 80001876 <wakeup>
  release(&lk->lk);
    80003b18:	854a                	mv	a0,s2
    80003b1a:	00003097          	auipc	ra,0x3
    80003b1e:	ca6080e7          	jalr	-858(ra) # 800067c0 <release>
}
    80003b22:	60e2                	ld	ra,24(sp)
    80003b24:	6442                	ld	s0,16(sp)
    80003b26:	64a2                	ld	s1,8(sp)
    80003b28:	6902                	ld	s2,0(sp)
    80003b2a:	6105                	addi	sp,sp,32
    80003b2c:	8082                	ret

0000000080003b2e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003b2e:	7179                	addi	sp,sp,-48
    80003b30:	f406                	sd	ra,40(sp)
    80003b32:	f022                	sd	s0,32(sp)
    80003b34:	ec26                	sd	s1,24(sp)
    80003b36:	e84a                	sd	s2,16(sp)
    80003b38:	e44e                	sd	s3,8(sp)
    80003b3a:	1800                	addi	s0,sp,48
    80003b3c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003b3e:	00850913          	addi	s2,a0,8
    80003b42:	854a                	mv	a0,s2
    80003b44:	00003097          	auipc	ra,0x3
    80003b48:	bac080e7          	jalr	-1108(ra) # 800066f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b4c:	409c                	lw	a5,0(s1)
    80003b4e:	ef99                	bnez	a5,80003b6c <holdingsleep+0x3e>
    80003b50:	4481                	li	s1,0
  release(&lk->lk);
    80003b52:	854a                	mv	a0,s2
    80003b54:	00003097          	auipc	ra,0x3
    80003b58:	c6c080e7          	jalr	-916(ra) # 800067c0 <release>
  return r;
}
    80003b5c:	8526                	mv	a0,s1
    80003b5e:	70a2                	ld	ra,40(sp)
    80003b60:	7402                	ld	s0,32(sp)
    80003b62:	64e2                	ld	s1,24(sp)
    80003b64:	6942                	ld	s2,16(sp)
    80003b66:	69a2                	ld	s3,8(sp)
    80003b68:	6145                	addi	sp,sp,48
    80003b6a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b6c:	0304a983          	lw	s3,48(s1)
    80003b70:	ffffd097          	auipc	ra,0xffffd
    80003b74:	4be080e7          	jalr	1214(ra) # 8000102e <myproc>
    80003b78:	5d04                	lw	s1,56(a0)
    80003b7a:	413484b3          	sub	s1,s1,s3
    80003b7e:	0014b493          	seqz	s1,s1
    80003b82:	bfc1                	j	80003b52 <holdingsleep+0x24>

0000000080003b84 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b84:	1141                	addi	sp,sp,-16
    80003b86:	e406                	sd	ra,8(sp)
    80003b88:	e022                	sd	s0,0(sp)
    80003b8a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b8c:	00005597          	auipc	a1,0x5
    80003b90:	a7458593          	addi	a1,a1,-1420 # 80008600 <syscalls+0x238>
    80003b94:	00019517          	auipc	a0,0x19
    80003b98:	30450513          	addi	a0,a0,772 # 8001ce98 <ftable>
    80003b9c:	00003097          	auipc	ra,0x3
    80003ba0:	cd0080e7          	jalr	-816(ra) # 8000686c <initlock>
}
    80003ba4:	60a2                	ld	ra,8(sp)
    80003ba6:	6402                	ld	s0,0(sp)
    80003ba8:	0141                	addi	sp,sp,16
    80003baa:	8082                	ret

0000000080003bac <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003bac:	1101                	addi	sp,sp,-32
    80003bae:	ec06                	sd	ra,24(sp)
    80003bb0:	e822                	sd	s0,16(sp)
    80003bb2:	e426                	sd	s1,8(sp)
    80003bb4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003bb6:	00019517          	auipc	a0,0x19
    80003bba:	2e250513          	addi	a0,a0,738 # 8001ce98 <ftable>
    80003bbe:	00003097          	auipc	ra,0x3
    80003bc2:	b32080e7          	jalr	-1230(ra) # 800066f0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bc6:	00019497          	auipc	s1,0x19
    80003bca:	2f248493          	addi	s1,s1,754 # 8001ceb8 <ftable+0x20>
    80003bce:	0001a717          	auipc	a4,0x1a
    80003bd2:	28a70713          	addi	a4,a4,650 # 8001de58 <ftable+0xfc0>
    if(f->ref == 0){
    80003bd6:	40dc                	lw	a5,4(s1)
    80003bd8:	cf99                	beqz	a5,80003bf6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003bda:	02848493          	addi	s1,s1,40
    80003bde:	fee49ce3          	bne	s1,a4,80003bd6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003be2:	00019517          	auipc	a0,0x19
    80003be6:	2b650513          	addi	a0,a0,694 # 8001ce98 <ftable>
    80003bea:	00003097          	auipc	ra,0x3
    80003bee:	bd6080e7          	jalr	-1066(ra) # 800067c0 <release>
  return 0;
    80003bf2:	4481                	li	s1,0
    80003bf4:	a819                	j	80003c0a <filealloc+0x5e>
      f->ref = 1;
    80003bf6:	4785                	li	a5,1
    80003bf8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bfa:	00019517          	auipc	a0,0x19
    80003bfe:	29e50513          	addi	a0,a0,670 # 8001ce98 <ftable>
    80003c02:	00003097          	auipc	ra,0x3
    80003c06:	bbe080e7          	jalr	-1090(ra) # 800067c0 <release>
}
    80003c0a:	8526                	mv	a0,s1
    80003c0c:	60e2                	ld	ra,24(sp)
    80003c0e:	6442                	ld	s0,16(sp)
    80003c10:	64a2                	ld	s1,8(sp)
    80003c12:	6105                	addi	sp,sp,32
    80003c14:	8082                	ret

0000000080003c16 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003c16:	1101                	addi	sp,sp,-32
    80003c18:	ec06                	sd	ra,24(sp)
    80003c1a:	e822                	sd	s0,16(sp)
    80003c1c:	e426                	sd	s1,8(sp)
    80003c1e:	1000                	addi	s0,sp,32
    80003c20:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003c22:	00019517          	auipc	a0,0x19
    80003c26:	27650513          	addi	a0,a0,630 # 8001ce98 <ftable>
    80003c2a:	00003097          	auipc	ra,0x3
    80003c2e:	ac6080e7          	jalr	-1338(ra) # 800066f0 <acquire>
  if(f->ref < 1)
    80003c32:	40dc                	lw	a5,4(s1)
    80003c34:	02f05263          	blez	a5,80003c58 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c38:	2785                	addiw	a5,a5,1
    80003c3a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c3c:	00019517          	auipc	a0,0x19
    80003c40:	25c50513          	addi	a0,a0,604 # 8001ce98 <ftable>
    80003c44:	00003097          	auipc	ra,0x3
    80003c48:	b7c080e7          	jalr	-1156(ra) # 800067c0 <release>
  return f;
}
    80003c4c:	8526                	mv	a0,s1
    80003c4e:	60e2                	ld	ra,24(sp)
    80003c50:	6442                	ld	s0,16(sp)
    80003c52:	64a2                	ld	s1,8(sp)
    80003c54:	6105                	addi	sp,sp,32
    80003c56:	8082                	ret
    panic("filedup");
    80003c58:	00005517          	auipc	a0,0x5
    80003c5c:	9b050513          	addi	a0,a0,-1616 # 80008608 <syscalls+0x240>
    80003c60:	00002097          	auipc	ra,0x2
    80003c64:	55c080e7          	jalr	1372(ra) # 800061bc <panic>

0000000080003c68 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c68:	7139                	addi	sp,sp,-64
    80003c6a:	fc06                	sd	ra,56(sp)
    80003c6c:	f822                	sd	s0,48(sp)
    80003c6e:	f426                	sd	s1,40(sp)
    80003c70:	f04a                	sd	s2,32(sp)
    80003c72:	ec4e                	sd	s3,24(sp)
    80003c74:	e852                	sd	s4,16(sp)
    80003c76:	e456                	sd	s5,8(sp)
    80003c78:	0080                	addi	s0,sp,64
    80003c7a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c7c:	00019517          	auipc	a0,0x19
    80003c80:	21c50513          	addi	a0,a0,540 # 8001ce98 <ftable>
    80003c84:	00003097          	auipc	ra,0x3
    80003c88:	a6c080e7          	jalr	-1428(ra) # 800066f0 <acquire>
  if(f->ref < 1)
    80003c8c:	40dc                	lw	a5,4(s1)
    80003c8e:	06f05163          	blez	a5,80003cf0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c92:	37fd                	addiw	a5,a5,-1
    80003c94:	0007871b          	sext.w	a4,a5
    80003c98:	c0dc                	sw	a5,4(s1)
    80003c9a:	06e04363          	bgtz	a4,80003d00 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c9e:	0004a903          	lw	s2,0(s1)
    80003ca2:	0094ca83          	lbu	s5,9(s1)
    80003ca6:	0104ba03          	ld	s4,16(s1)
    80003caa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003cae:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003cb2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003cb6:	00019517          	auipc	a0,0x19
    80003cba:	1e250513          	addi	a0,a0,482 # 8001ce98 <ftable>
    80003cbe:	00003097          	auipc	ra,0x3
    80003cc2:	b02080e7          	jalr	-1278(ra) # 800067c0 <release>

  if(ff.type == FD_PIPE){
    80003cc6:	4785                	li	a5,1
    80003cc8:	04f90d63          	beq	s2,a5,80003d22 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ccc:	3979                	addiw	s2,s2,-2
    80003cce:	4785                	li	a5,1
    80003cd0:	0527e063          	bltu	a5,s2,80003d10 <fileclose+0xa8>
    begin_op();
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	ac8080e7          	jalr	-1336(ra) # 8000379c <begin_op>
    iput(ff.ip);
    80003cdc:	854e                	mv	a0,s3
    80003cde:	fffff097          	auipc	ra,0xfffff
    80003ce2:	2a6080e7          	jalr	678(ra) # 80002f84 <iput>
    end_op();
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	b36080e7          	jalr	-1226(ra) # 8000381c <end_op>
    80003cee:	a00d                	j	80003d10 <fileclose+0xa8>
    panic("fileclose");
    80003cf0:	00005517          	auipc	a0,0x5
    80003cf4:	92050513          	addi	a0,a0,-1760 # 80008610 <syscalls+0x248>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	4c4080e7          	jalr	1220(ra) # 800061bc <panic>
    release(&ftable.lock);
    80003d00:	00019517          	auipc	a0,0x19
    80003d04:	19850513          	addi	a0,a0,408 # 8001ce98 <ftable>
    80003d08:	00003097          	auipc	ra,0x3
    80003d0c:	ab8080e7          	jalr	-1352(ra) # 800067c0 <release>
  }
}
    80003d10:	70e2                	ld	ra,56(sp)
    80003d12:	7442                	ld	s0,48(sp)
    80003d14:	74a2                	ld	s1,40(sp)
    80003d16:	7902                	ld	s2,32(sp)
    80003d18:	69e2                	ld	s3,24(sp)
    80003d1a:	6a42                	ld	s4,16(sp)
    80003d1c:	6aa2                	ld	s5,8(sp)
    80003d1e:	6121                	addi	sp,sp,64
    80003d20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003d22:	85d6                	mv	a1,s5
    80003d24:	8552                	mv	a0,s4
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	34c080e7          	jalr	844(ra) # 80004072 <pipeclose>
    80003d2e:	b7cd                	j	80003d10 <fileclose+0xa8>

0000000080003d30 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d30:	715d                	addi	sp,sp,-80
    80003d32:	e486                	sd	ra,72(sp)
    80003d34:	e0a2                	sd	s0,64(sp)
    80003d36:	fc26                	sd	s1,56(sp)
    80003d38:	f84a                	sd	s2,48(sp)
    80003d3a:	f44e                	sd	s3,40(sp)
    80003d3c:	0880                	addi	s0,sp,80
    80003d3e:	84aa                	mv	s1,a0
    80003d40:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d42:	ffffd097          	auipc	ra,0xffffd
    80003d46:	2ec080e7          	jalr	748(ra) # 8000102e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d4a:	409c                	lw	a5,0(s1)
    80003d4c:	37f9                	addiw	a5,a5,-2
    80003d4e:	4705                	li	a4,1
    80003d50:	04f76763          	bltu	a4,a5,80003d9e <filestat+0x6e>
    80003d54:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d56:	6c88                	ld	a0,24(s1)
    80003d58:	fffff097          	auipc	ra,0xfffff
    80003d5c:	072080e7          	jalr	114(ra) # 80002dca <ilock>
    stati(f->ip, &st);
    80003d60:	fb840593          	addi	a1,s0,-72
    80003d64:	6c88                	ld	a0,24(s1)
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	2ee080e7          	jalr	750(ra) # 80003054 <stati>
    iunlock(f->ip);
    80003d6e:	6c88                	ld	a0,24(s1)
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	11c080e7          	jalr	284(ra) # 80002e8c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d78:	46e1                	li	a3,24
    80003d7a:	fb840613          	addi	a2,s0,-72
    80003d7e:	85ce                	mv	a1,s3
    80003d80:	05893503          	ld	a0,88(s2)
    80003d84:	ffffd097          	auipc	ra,0xffffd
    80003d88:	f6c080e7          	jalr	-148(ra) # 80000cf0 <copyout>
    80003d8c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d90:	60a6                	ld	ra,72(sp)
    80003d92:	6406                	ld	s0,64(sp)
    80003d94:	74e2                	ld	s1,56(sp)
    80003d96:	7942                	ld	s2,48(sp)
    80003d98:	79a2                	ld	s3,40(sp)
    80003d9a:	6161                	addi	sp,sp,80
    80003d9c:	8082                	ret
  return -1;
    80003d9e:	557d                	li	a0,-1
    80003da0:	bfc5                	j	80003d90 <filestat+0x60>

0000000080003da2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003da2:	7179                	addi	sp,sp,-48
    80003da4:	f406                	sd	ra,40(sp)
    80003da6:	f022                	sd	s0,32(sp)
    80003da8:	ec26                	sd	s1,24(sp)
    80003daa:	e84a                	sd	s2,16(sp)
    80003dac:	e44e                	sd	s3,8(sp)
    80003dae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003db0:	00854783          	lbu	a5,8(a0)
    80003db4:	c3d5                	beqz	a5,80003e58 <fileread+0xb6>
    80003db6:	84aa                	mv	s1,a0
    80003db8:	89ae                	mv	s3,a1
    80003dba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003dbc:	411c                	lw	a5,0(a0)
    80003dbe:	4705                	li	a4,1
    80003dc0:	04e78963          	beq	a5,a4,80003e12 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dc4:	470d                	li	a4,3
    80003dc6:	04e78d63          	beq	a5,a4,80003e20 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003dca:	4709                	li	a4,2
    80003dcc:	06e79e63          	bne	a5,a4,80003e48 <fileread+0xa6>
    ilock(f->ip);
    80003dd0:	6d08                	ld	a0,24(a0)
    80003dd2:	fffff097          	auipc	ra,0xfffff
    80003dd6:	ff8080e7          	jalr	-8(ra) # 80002dca <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dda:	874a                	mv	a4,s2
    80003ddc:	5094                	lw	a3,32(s1)
    80003dde:	864e                	mv	a2,s3
    80003de0:	4585                	li	a1,1
    80003de2:	6c88                	ld	a0,24(s1)
    80003de4:	fffff097          	auipc	ra,0xfffff
    80003de8:	29a080e7          	jalr	666(ra) # 8000307e <readi>
    80003dec:	892a                	mv	s2,a0
    80003dee:	00a05563          	blez	a0,80003df8 <fileread+0x56>
      f->off += r;
    80003df2:	509c                	lw	a5,32(s1)
    80003df4:	9fa9                	addw	a5,a5,a0
    80003df6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003df8:	6c88                	ld	a0,24(s1)
    80003dfa:	fffff097          	auipc	ra,0xfffff
    80003dfe:	092080e7          	jalr	146(ra) # 80002e8c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003e02:	854a                	mv	a0,s2
    80003e04:	70a2                	ld	ra,40(sp)
    80003e06:	7402                	ld	s0,32(sp)
    80003e08:	64e2                	ld	s1,24(sp)
    80003e0a:	6942                	ld	s2,16(sp)
    80003e0c:	69a2                	ld	s3,8(sp)
    80003e0e:	6145                	addi	sp,sp,48
    80003e10:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003e12:	6908                	ld	a0,16(a0)
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	3d2080e7          	jalr	978(ra) # 800041e6 <piperead>
    80003e1c:	892a                	mv	s2,a0
    80003e1e:	b7d5                	j	80003e02 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003e20:	02451783          	lh	a5,36(a0)
    80003e24:	03079693          	slli	a3,a5,0x30
    80003e28:	92c1                	srli	a3,a3,0x30
    80003e2a:	4725                	li	a4,9
    80003e2c:	02d76863          	bltu	a4,a3,80003e5c <fileread+0xba>
    80003e30:	0792                	slli	a5,a5,0x4
    80003e32:	00019717          	auipc	a4,0x19
    80003e36:	fc670713          	addi	a4,a4,-58 # 8001cdf8 <devsw>
    80003e3a:	97ba                	add	a5,a5,a4
    80003e3c:	639c                	ld	a5,0(a5)
    80003e3e:	c38d                	beqz	a5,80003e60 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003e40:	4505                	li	a0,1
    80003e42:	9782                	jalr	a5
    80003e44:	892a                	mv	s2,a0
    80003e46:	bf75                	j	80003e02 <fileread+0x60>
    panic("fileread");
    80003e48:	00004517          	auipc	a0,0x4
    80003e4c:	7d850513          	addi	a0,a0,2008 # 80008620 <syscalls+0x258>
    80003e50:	00002097          	auipc	ra,0x2
    80003e54:	36c080e7          	jalr	876(ra) # 800061bc <panic>
    return -1;
    80003e58:	597d                	li	s2,-1
    80003e5a:	b765                	j	80003e02 <fileread+0x60>
      return -1;
    80003e5c:	597d                	li	s2,-1
    80003e5e:	b755                	j	80003e02 <fileread+0x60>
    80003e60:	597d                	li	s2,-1
    80003e62:	b745                	j	80003e02 <fileread+0x60>

0000000080003e64 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003e64:	715d                	addi	sp,sp,-80
    80003e66:	e486                	sd	ra,72(sp)
    80003e68:	e0a2                	sd	s0,64(sp)
    80003e6a:	fc26                	sd	s1,56(sp)
    80003e6c:	f84a                	sd	s2,48(sp)
    80003e6e:	f44e                	sd	s3,40(sp)
    80003e70:	f052                	sd	s4,32(sp)
    80003e72:	ec56                	sd	s5,24(sp)
    80003e74:	e85a                	sd	s6,16(sp)
    80003e76:	e45e                	sd	s7,8(sp)
    80003e78:	e062                	sd	s8,0(sp)
    80003e7a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003e7c:	00954783          	lbu	a5,9(a0)
    80003e80:	10078663          	beqz	a5,80003f8c <filewrite+0x128>
    80003e84:	892a                	mv	s2,a0
    80003e86:	8aae                	mv	s5,a1
    80003e88:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e8a:	411c                	lw	a5,0(a0)
    80003e8c:	4705                	li	a4,1
    80003e8e:	02e78263          	beq	a5,a4,80003eb2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e92:	470d                	li	a4,3
    80003e94:	02e78663          	beq	a5,a4,80003ec0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e98:	4709                	li	a4,2
    80003e9a:	0ee79163          	bne	a5,a4,80003f7c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e9e:	0ac05d63          	blez	a2,80003f58 <filewrite+0xf4>
    int i = 0;
    80003ea2:	4981                	li	s3,0
    80003ea4:	6b05                	lui	s6,0x1
    80003ea6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003eaa:	6b85                	lui	s7,0x1
    80003eac:	c00b8b9b          	addiw	s7,s7,-1024
    80003eb0:	a861                	j	80003f48 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003eb2:	6908                	ld	a0,16(a0)
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	238080e7          	jalr	568(ra) # 800040ec <pipewrite>
    80003ebc:	8a2a                	mv	s4,a0
    80003ebe:	a045                	j	80003f5e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ec0:	02451783          	lh	a5,36(a0)
    80003ec4:	03079693          	slli	a3,a5,0x30
    80003ec8:	92c1                	srli	a3,a3,0x30
    80003eca:	4725                	li	a4,9
    80003ecc:	0cd76263          	bltu	a4,a3,80003f90 <filewrite+0x12c>
    80003ed0:	0792                	slli	a5,a5,0x4
    80003ed2:	00019717          	auipc	a4,0x19
    80003ed6:	f2670713          	addi	a4,a4,-218 # 8001cdf8 <devsw>
    80003eda:	97ba                	add	a5,a5,a4
    80003edc:	679c                	ld	a5,8(a5)
    80003ede:	cbdd                	beqz	a5,80003f94 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ee0:	4505                	li	a0,1
    80003ee2:	9782                	jalr	a5
    80003ee4:	8a2a                	mv	s4,a0
    80003ee6:	a8a5                	j	80003f5e <filewrite+0xfa>
    80003ee8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	8b0080e7          	jalr	-1872(ra) # 8000379c <begin_op>
      ilock(f->ip);
    80003ef4:	01893503          	ld	a0,24(s2)
    80003ef8:	fffff097          	auipc	ra,0xfffff
    80003efc:	ed2080e7          	jalr	-302(ra) # 80002dca <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003f00:	8762                	mv	a4,s8
    80003f02:	02092683          	lw	a3,32(s2)
    80003f06:	01598633          	add	a2,s3,s5
    80003f0a:	4585                	li	a1,1
    80003f0c:	01893503          	ld	a0,24(s2)
    80003f10:	fffff097          	auipc	ra,0xfffff
    80003f14:	266080e7          	jalr	614(ra) # 80003176 <writei>
    80003f18:	84aa                	mv	s1,a0
    80003f1a:	00a05763          	blez	a0,80003f28 <filewrite+0xc4>
        f->off += r;
    80003f1e:	02092783          	lw	a5,32(s2)
    80003f22:	9fa9                	addw	a5,a5,a0
    80003f24:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f28:	01893503          	ld	a0,24(s2)
    80003f2c:	fffff097          	auipc	ra,0xfffff
    80003f30:	f60080e7          	jalr	-160(ra) # 80002e8c <iunlock>
      end_op();
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	8e8080e7          	jalr	-1816(ra) # 8000381c <end_op>

      if(r != n1){
    80003f3c:	009c1f63          	bne	s8,s1,80003f5a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003f40:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f44:	0149db63          	bge	s3,s4,80003f5a <filewrite+0xf6>
      int n1 = n - i;
    80003f48:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003f4c:	84be                	mv	s1,a5
    80003f4e:	2781                	sext.w	a5,a5
    80003f50:	f8fb5ce3          	bge	s6,a5,80003ee8 <filewrite+0x84>
    80003f54:	84de                	mv	s1,s7
    80003f56:	bf49                	j	80003ee8 <filewrite+0x84>
    int i = 0;
    80003f58:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003f5a:	013a1f63          	bne	s4,s3,80003f78 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f5e:	8552                	mv	a0,s4
    80003f60:	60a6                	ld	ra,72(sp)
    80003f62:	6406                	ld	s0,64(sp)
    80003f64:	74e2                	ld	s1,56(sp)
    80003f66:	7942                	ld	s2,48(sp)
    80003f68:	79a2                	ld	s3,40(sp)
    80003f6a:	7a02                	ld	s4,32(sp)
    80003f6c:	6ae2                	ld	s5,24(sp)
    80003f6e:	6b42                	ld	s6,16(sp)
    80003f70:	6ba2                	ld	s7,8(sp)
    80003f72:	6c02                	ld	s8,0(sp)
    80003f74:	6161                	addi	sp,sp,80
    80003f76:	8082                	ret
    ret = (i == n ? n : -1);
    80003f78:	5a7d                	li	s4,-1
    80003f7a:	b7d5                	j	80003f5e <filewrite+0xfa>
    panic("filewrite");
    80003f7c:	00004517          	auipc	a0,0x4
    80003f80:	6b450513          	addi	a0,a0,1716 # 80008630 <syscalls+0x268>
    80003f84:	00002097          	auipc	ra,0x2
    80003f88:	238080e7          	jalr	568(ra) # 800061bc <panic>
    return -1;
    80003f8c:	5a7d                	li	s4,-1
    80003f8e:	bfc1                	j	80003f5e <filewrite+0xfa>
      return -1;
    80003f90:	5a7d                	li	s4,-1
    80003f92:	b7f1                	j	80003f5e <filewrite+0xfa>
    80003f94:	5a7d                	li	s4,-1
    80003f96:	b7e1                	j	80003f5e <filewrite+0xfa>

0000000080003f98 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f98:	7179                	addi	sp,sp,-48
    80003f9a:	f406                	sd	ra,40(sp)
    80003f9c:	f022                	sd	s0,32(sp)
    80003f9e:	ec26                	sd	s1,24(sp)
    80003fa0:	e84a                	sd	s2,16(sp)
    80003fa2:	e44e                	sd	s3,8(sp)
    80003fa4:	e052                	sd	s4,0(sp)
    80003fa6:	1800                	addi	s0,sp,48
    80003fa8:	84aa                	mv	s1,a0
    80003faa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fac:	0005b023          	sd	zero,0(a1)
    80003fb0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	bf8080e7          	jalr	-1032(ra) # 80003bac <filealloc>
    80003fbc:	e088                	sd	a0,0(s1)
    80003fbe:	c551                	beqz	a0,8000404a <pipealloc+0xb2>
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	bec080e7          	jalr	-1044(ra) # 80003bac <filealloc>
    80003fc8:	00aa3023          	sd	a0,0(s4)
    80003fcc:	c92d                	beqz	a0,8000403e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fce:	ffffc097          	auipc	ra,0xffffc
    80003fd2:	0f4080e7          	jalr	244(ra) # 800000c2 <kalloc>
    80003fd6:	892a                	mv	s2,a0
    80003fd8:	c125                	beqz	a0,80004038 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003fda:	4985                	li	s3,1
    80003fdc:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80003fe0:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003fe4:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003fe8:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003fec:	00004597          	auipc	a1,0x4
    80003ff0:	65458593          	addi	a1,a1,1620 # 80008640 <syscalls+0x278>
    80003ff4:	00003097          	auipc	ra,0x3
    80003ff8:	878080e7          	jalr	-1928(ra) # 8000686c <initlock>
  (*f0)->type = FD_PIPE;
    80003ffc:	609c                	ld	a5,0(s1)
    80003ffe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004002:	609c                	ld	a5,0(s1)
    80004004:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004008:	609c                	ld	a5,0(s1)
    8000400a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000400e:	609c                	ld	a5,0(s1)
    80004010:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004014:	000a3783          	ld	a5,0(s4)
    80004018:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000401c:	000a3783          	ld	a5,0(s4)
    80004020:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004024:	000a3783          	ld	a5,0(s4)
    80004028:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000402c:	000a3783          	ld	a5,0(s4)
    80004030:	0127b823          	sd	s2,16(a5)
  return 0;
    80004034:	4501                	li	a0,0
    80004036:	a025                	j	8000405e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004038:	6088                	ld	a0,0(s1)
    8000403a:	e501                	bnez	a0,80004042 <pipealloc+0xaa>
    8000403c:	a039                	j	8000404a <pipealloc+0xb2>
    8000403e:	6088                	ld	a0,0(s1)
    80004040:	c51d                	beqz	a0,8000406e <pipealloc+0xd6>
    fileclose(*f0);
    80004042:	00000097          	auipc	ra,0x0
    80004046:	c26080e7          	jalr	-986(ra) # 80003c68 <fileclose>
  if(*f1)
    8000404a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000404e:	557d                	li	a0,-1
  if(*f1)
    80004050:	c799                	beqz	a5,8000405e <pipealloc+0xc6>
    fileclose(*f1);
    80004052:	853e                	mv	a0,a5
    80004054:	00000097          	auipc	ra,0x0
    80004058:	c14080e7          	jalr	-1004(ra) # 80003c68 <fileclose>
  return -1;
    8000405c:	557d                	li	a0,-1
}
    8000405e:	70a2                	ld	ra,40(sp)
    80004060:	7402                	ld	s0,32(sp)
    80004062:	64e2                	ld	s1,24(sp)
    80004064:	6942                	ld	s2,16(sp)
    80004066:	69a2                	ld	s3,8(sp)
    80004068:	6a02                	ld	s4,0(sp)
    8000406a:	6145                	addi	sp,sp,48
    8000406c:	8082                	ret
  return -1;
    8000406e:	557d                	li	a0,-1
    80004070:	b7fd                	j	8000405e <pipealloc+0xc6>

0000000080004072 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004072:	1101                	addi	sp,sp,-32
    80004074:	ec06                	sd	ra,24(sp)
    80004076:	e822                	sd	s0,16(sp)
    80004078:	e426                	sd	s1,8(sp)
    8000407a:	e04a                	sd	s2,0(sp)
    8000407c:	1000                	addi	s0,sp,32
    8000407e:	84aa                	mv	s1,a0
    80004080:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004082:	00002097          	auipc	ra,0x2
    80004086:	66e080e7          	jalr	1646(ra) # 800066f0 <acquire>
  if(writable){
    8000408a:	04090263          	beqz	s2,800040ce <pipeclose+0x5c>
    pi->writeopen = 0;
    8000408e:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004092:	22048513          	addi	a0,s1,544
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	7e0080e7          	jalr	2016(ra) # 80001876 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000409e:	2284b783          	ld	a5,552(s1)
    800040a2:	ef9d                	bnez	a5,800040e0 <pipeclose+0x6e>
    release(&pi->lock);
    800040a4:	8526                	mv	a0,s1
    800040a6:	00002097          	auipc	ra,0x2
    800040aa:	71a080e7          	jalr	1818(ra) # 800067c0 <release>
#ifdef LAB_LOCK
    freelock(&pi->lock);
    800040ae:	8526                	mv	a0,s1
    800040b0:	00002097          	auipc	ra,0x2
    800040b4:	758080e7          	jalr	1880(ra) # 80006808 <freelock>
#endif    
    kfree((char*)pi);
    800040b8:	8526                	mv	a0,s1
    800040ba:	ffffc097          	auipc	ra,0xffffc
    800040be:	f62080e7          	jalr	-158(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040c2:	60e2                	ld	ra,24(sp)
    800040c4:	6442                	ld	s0,16(sp)
    800040c6:	64a2                	ld	s1,8(sp)
    800040c8:	6902                	ld	s2,0(sp)
    800040ca:	6105                	addi	sp,sp,32
    800040cc:	8082                	ret
    pi->readopen = 0;
    800040ce:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800040d2:	22448513          	addi	a0,s1,548
    800040d6:	ffffd097          	auipc	ra,0xffffd
    800040da:	7a0080e7          	jalr	1952(ra) # 80001876 <wakeup>
    800040de:	b7c1                	j	8000409e <pipeclose+0x2c>
    release(&pi->lock);
    800040e0:	8526                	mv	a0,s1
    800040e2:	00002097          	auipc	ra,0x2
    800040e6:	6de080e7          	jalr	1758(ra) # 800067c0 <release>
}
    800040ea:	bfe1                	j	800040c2 <pipeclose+0x50>

00000000800040ec <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040ec:	7159                	addi	sp,sp,-112
    800040ee:	f486                	sd	ra,104(sp)
    800040f0:	f0a2                	sd	s0,96(sp)
    800040f2:	eca6                	sd	s1,88(sp)
    800040f4:	e8ca                	sd	s2,80(sp)
    800040f6:	e4ce                	sd	s3,72(sp)
    800040f8:	e0d2                	sd	s4,64(sp)
    800040fa:	fc56                	sd	s5,56(sp)
    800040fc:	f85a                	sd	s6,48(sp)
    800040fe:	f45e                	sd	s7,40(sp)
    80004100:	f062                	sd	s8,32(sp)
    80004102:	ec66                	sd	s9,24(sp)
    80004104:	1880                	addi	s0,sp,112
    80004106:	84aa                	mv	s1,a0
    80004108:	8aae                	mv	s5,a1
    8000410a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	f22080e7          	jalr	-222(ra) # 8000102e <myproc>
    80004114:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004116:	8526                	mv	a0,s1
    80004118:	00002097          	auipc	ra,0x2
    8000411c:	5d8080e7          	jalr	1496(ra) # 800066f0 <acquire>
  while(i < n){
    80004120:	0d405163          	blez	s4,800041e2 <pipewrite+0xf6>
    80004124:	8ba6                	mv	s7,s1
  int i = 0;
    80004126:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004128:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000412a:	22048c93          	addi	s9,s1,544
      sleep(&pi->nwrite, &pi->lock);
    8000412e:	22448c13          	addi	s8,s1,548
    80004132:	a08d                	j	80004194 <pipewrite+0xa8>
      release(&pi->lock);
    80004134:	8526                	mv	a0,s1
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	68a080e7          	jalr	1674(ra) # 800067c0 <release>
      return -1;
    8000413e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004140:	854a                	mv	a0,s2
    80004142:	70a6                	ld	ra,104(sp)
    80004144:	7406                	ld	s0,96(sp)
    80004146:	64e6                	ld	s1,88(sp)
    80004148:	6946                	ld	s2,80(sp)
    8000414a:	69a6                	ld	s3,72(sp)
    8000414c:	6a06                	ld	s4,64(sp)
    8000414e:	7ae2                	ld	s5,56(sp)
    80004150:	7b42                	ld	s6,48(sp)
    80004152:	7ba2                	ld	s7,40(sp)
    80004154:	7c02                	ld	s8,32(sp)
    80004156:	6ce2                	ld	s9,24(sp)
    80004158:	6165                	addi	sp,sp,112
    8000415a:	8082                	ret
      wakeup(&pi->nread);
    8000415c:	8566                	mv	a0,s9
    8000415e:	ffffd097          	auipc	ra,0xffffd
    80004162:	718080e7          	jalr	1816(ra) # 80001876 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004166:	85de                	mv	a1,s7
    80004168:	8562                	mv	a0,s8
    8000416a:	ffffd097          	auipc	ra,0xffffd
    8000416e:	580080e7          	jalr	1408(ra) # 800016ea <sleep>
    80004172:	a839                	j	80004190 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004174:	2244a783          	lw	a5,548(s1)
    80004178:	0017871b          	addiw	a4,a5,1
    8000417c:	22e4a223          	sw	a4,548(s1)
    80004180:	1ff7f793          	andi	a5,a5,511
    80004184:	97a6                	add	a5,a5,s1
    80004186:	f9f44703          	lbu	a4,-97(s0)
    8000418a:	02e78023          	sb	a4,32(a5)
      i++;
    8000418e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004190:	03495d63          	bge	s2,s4,800041ca <pipewrite+0xde>
    if(pi->readopen == 0 || pr->killed){
    80004194:	2284a783          	lw	a5,552(s1)
    80004198:	dfd1                	beqz	a5,80004134 <pipewrite+0x48>
    8000419a:	0309a783          	lw	a5,48(s3)
    8000419e:	fbd9                	bnez	a5,80004134 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800041a0:	2204a783          	lw	a5,544(s1)
    800041a4:	2244a703          	lw	a4,548(s1)
    800041a8:	2007879b          	addiw	a5,a5,512
    800041ac:	faf708e3          	beq	a4,a5,8000415c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041b0:	4685                	li	a3,1
    800041b2:	01590633          	add	a2,s2,s5
    800041b6:	f9f40593          	addi	a1,s0,-97
    800041ba:	0589b503          	ld	a0,88(s3)
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	bbe080e7          	jalr	-1090(ra) # 80000d7c <copyin>
    800041c6:	fb6517e3          	bne	a0,s6,80004174 <pipewrite+0x88>
  wakeup(&pi->nread);
    800041ca:	22048513          	addi	a0,s1,544
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	6a8080e7          	jalr	1704(ra) # 80001876 <wakeup>
  release(&pi->lock);
    800041d6:	8526                	mv	a0,s1
    800041d8:	00002097          	auipc	ra,0x2
    800041dc:	5e8080e7          	jalr	1512(ra) # 800067c0 <release>
  return i;
    800041e0:	b785                	j	80004140 <pipewrite+0x54>
  int i = 0;
    800041e2:	4901                	li	s2,0
    800041e4:	b7dd                	j	800041ca <pipewrite+0xde>

00000000800041e6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041e6:	715d                	addi	sp,sp,-80
    800041e8:	e486                	sd	ra,72(sp)
    800041ea:	e0a2                	sd	s0,64(sp)
    800041ec:	fc26                	sd	s1,56(sp)
    800041ee:	f84a                	sd	s2,48(sp)
    800041f0:	f44e                	sd	s3,40(sp)
    800041f2:	f052                	sd	s4,32(sp)
    800041f4:	ec56                	sd	s5,24(sp)
    800041f6:	e85a                	sd	s6,16(sp)
    800041f8:	0880                	addi	s0,sp,80
    800041fa:	84aa                	mv	s1,a0
    800041fc:	892e                	mv	s2,a1
    800041fe:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	e2e080e7          	jalr	-466(ra) # 8000102e <myproc>
    80004208:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000420a:	8b26                	mv	s6,s1
    8000420c:	8526                	mv	a0,s1
    8000420e:	00002097          	auipc	ra,0x2
    80004212:	4e2080e7          	jalr	1250(ra) # 800066f0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004216:	2204a703          	lw	a4,544(s1)
    8000421a:	2244a783          	lw	a5,548(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000421e:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004222:	02f71463          	bne	a4,a5,8000424a <piperead+0x64>
    80004226:	22c4a783          	lw	a5,556(s1)
    8000422a:	c385                	beqz	a5,8000424a <piperead+0x64>
    if(pr->killed){
    8000422c:	030a2783          	lw	a5,48(s4)
    80004230:	ebc1                	bnez	a5,800042c0 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004232:	85da                	mv	a1,s6
    80004234:	854e                	mv	a0,s3
    80004236:	ffffd097          	auipc	ra,0xffffd
    8000423a:	4b4080e7          	jalr	1204(ra) # 800016ea <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000423e:	2204a703          	lw	a4,544(s1)
    80004242:	2244a783          	lw	a5,548(s1)
    80004246:	fef700e3          	beq	a4,a5,80004226 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424a:	09505263          	blez	s5,800042ce <piperead+0xe8>
    8000424e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004250:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004252:	2204a783          	lw	a5,544(s1)
    80004256:	2244a703          	lw	a4,548(s1)
    8000425a:	02f70d63          	beq	a4,a5,80004294 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000425e:	0017871b          	addiw	a4,a5,1
    80004262:	22e4a023          	sw	a4,544(s1)
    80004266:	1ff7f793          	andi	a5,a5,511
    8000426a:	97a6                	add	a5,a5,s1
    8000426c:	0207c783          	lbu	a5,32(a5)
    80004270:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004274:	4685                	li	a3,1
    80004276:	fbf40613          	addi	a2,s0,-65
    8000427a:	85ca                	mv	a1,s2
    8000427c:	058a3503          	ld	a0,88(s4)
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	a70080e7          	jalr	-1424(ra) # 80000cf0 <copyout>
    80004288:	01650663          	beq	a0,s6,80004294 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000428c:	2985                	addiw	s3,s3,1
    8000428e:	0905                	addi	s2,s2,1
    80004290:	fd3a91e3          	bne	s5,s3,80004252 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004294:	22448513          	addi	a0,s1,548
    80004298:	ffffd097          	auipc	ra,0xffffd
    8000429c:	5de080e7          	jalr	1502(ra) # 80001876 <wakeup>
  release(&pi->lock);
    800042a0:	8526                	mv	a0,s1
    800042a2:	00002097          	auipc	ra,0x2
    800042a6:	51e080e7          	jalr	1310(ra) # 800067c0 <release>
  return i;
}
    800042aa:	854e                	mv	a0,s3
    800042ac:	60a6                	ld	ra,72(sp)
    800042ae:	6406                	ld	s0,64(sp)
    800042b0:	74e2                	ld	s1,56(sp)
    800042b2:	7942                	ld	s2,48(sp)
    800042b4:	79a2                	ld	s3,40(sp)
    800042b6:	7a02                	ld	s4,32(sp)
    800042b8:	6ae2                	ld	s5,24(sp)
    800042ba:	6b42                	ld	s6,16(sp)
    800042bc:	6161                	addi	sp,sp,80
    800042be:	8082                	ret
      release(&pi->lock);
    800042c0:	8526                	mv	a0,s1
    800042c2:	00002097          	auipc	ra,0x2
    800042c6:	4fe080e7          	jalr	1278(ra) # 800067c0 <release>
      return -1;
    800042ca:	59fd                	li	s3,-1
    800042cc:	bff9                	j	800042aa <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ce:	4981                	li	s3,0
    800042d0:	b7d1                	j	80004294 <piperead+0xae>

00000000800042d2 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042d2:	df010113          	addi	sp,sp,-528
    800042d6:	20113423          	sd	ra,520(sp)
    800042da:	20813023          	sd	s0,512(sp)
    800042de:	ffa6                	sd	s1,504(sp)
    800042e0:	fbca                	sd	s2,496(sp)
    800042e2:	f7ce                	sd	s3,488(sp)
    800042e4:	f3d2                	sd	s4,480(sp)
    800042e6:	efd6                	sd	s5,472(sp)
    800042e8:	ebda                	sd	s6,464(sp)
    800042ea:	e7de                	sd	s7,456(sp)
    800042ec:	e3e2                	sd	s8,448(sp)
    800042ee:	ff66                	sd	s9,440(sp)
    800042f0:	fb6a                	sd	s10,432(sp)
    800042f2:	f76e                	sd	s11,424(sp)
    800042f4:	0c00                	addi	s0,sp,528
    800042f6:	84aa                	mv	s1,a0
    800042f8:	dea43c23          	sd	a0,-520(s0)
    800042fc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004300:	ffffd097          	auipc	ra,0xffffd
    80004304:	d2e080e7          	jalr	-722(ra) # 8000102e <myproc>
    80004308:	892a                	mv	s2,a0

  begin_op();
    8000430a:	fffff097          	auipc	ra,0xfffff
    8000430e:	492080e7          	jalr	1170(ra) # 8000379c <begin_op>

  if((ip = namei(path)) == 0){
    80004312:	8526                	mv	a0,s1
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	26c080e7          	jalr	620(ra) # 80003580 <namei>
    8000431c:	c92d                	beqz	a0,8000438e <exec+0xbc>
    8000431e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004320:	fffff097          	auipc	ra,0xfffff
    80004324:	aaa080e7          	jalr	-1366(ra) # 80002dca <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004328:	04000713          	li	a4,64
    8000432c:	4681                	li	a3,0
    8000432e:	e5040613          	addi	a2,s0,-432
    80004332:	4581                	li	a1,0
    80004334:	8526                	mv	a0,s1
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	d48080e7          	jalr	-696(ra) # 8000307e <readi>
    8000433e:	04000793          	li	a5,64
    80004342:	00f51a63          	bne	a0,a5,80004356 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004346:	e5042703          	lw	a4,-432(s0)
    8000434a:	464c47b7          	lui	a5,0x464c4
    8000434e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004352:	04f70463          	beq	a4,a5,8000439a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004356:	8526                	mv	a0,s1
    80004358:	fffff097          	auipc	ra,0xfffff
    8000435c:	cd4080e7          	jalr	-812(ra) # 8000302c <iunlockput>
    end_op();
    80004360:	fffff097          	auipc	ra,0xfffff
    80004364:	4bc080e7          	jalr	1212(ra) # 8000381c <end_op>
  }
  return -1;
    80004368:	557d                	li	a0,-1
}
    8000436a:	20813083          	ld	ra,520(sp)
    8000436e:	20013403          	ld	s0,512(sp)
    80004372:	74fe                	ld	s1,504(sp)
    80004374:	795e                	ld	s2,496(sp)
    80004376:	79be                	ld	s3,488(sp)
    80004378:	7a1e                	ld	s4,480(sp)
    8000437a:	6afe                	ld	s5,472(sp)
    8000437c:	6b5e                	ld	s6,464(sp)
    8000437e:	6bbe                	ld	s7,456(sp)
    80004380:	6c1e                	ld	s8,448(sp)
    80004382:	7cfa                	ld	s9,440(sp)
    80004384:	7d5a                	ld	s10,432(sp)
    80004386:	7dba                	ld	s11,424(sp)
    80004388:	21010113          	addi	sp,sp,528
    8000438c:	8082                	ret
    end_op();
    8000438e:	fffff097          	auipc	ra,0xfffff
    80004392:	48e080e7          	jalr	1166(ra) # 8000381c <end_op>
    return -1;
    80004396:	557d                	li	a0,-1
    80004398:	bfc9                	j	8000436a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000439a:	854a                	mv	a0,s2
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	d56080e7          	jalr	-682(ra) # 800010f2 <proc_pagetable>
    800043a4:	8baa                	mv	s7,a0
    800043a6:	d945                	beqz	a0,80004356 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043a8:	e7042983          	lw	s3,-400(s0)
    800043ac:	e8845783          	lhu	a5,-376(s0)
    800043b0:	c7ad                	beqz	a5,8000441a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043b4:	4b01                	li	s6,0
    if((ph.vaddr % PGSIZE) != 0)
    800043b6:	6c85                	lui	s9,0x1
    800043b8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043bc:	def43823          	sd	a5,-528(s0)
    800043c0:	a42d                	j	800045ea <exec+0x318>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800043c2:	00004517          	auipc	a0,0x4
    800043c6:	28650513          	addi	a0,a0,646 # 80008648 <syscalls+0x280>
    800043ca:	00002097          	auipc	ra,0x2
    800043ce:	df2080e7          	jalr	-526(ra) # 800061bc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043d2:	8756                	mv	a4,s5
    800043d4:	012d86bb          	addw	a3,s11,s2
    800043d8:	4581                	li	a1,0
    800043da:	8526                	mv	a0,s1
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	ca2080e7          	jalr	-862(ra) # 8000307e <readi>
    800043e4:	2501                	sext.w	a0,a0
    800043e6:	1aaa9963          	bne	s5,a0,80004598 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    800043ea:	6785                	lui	a5,0x1
    800043ec:	0127893b          	addw	s2,a5,s2
    800043f0:	77fd                	lui	a5,0xfffff
    800043f2:	01478a3b          	addw	s4,a5,s4
    800043f6:	1f897163          	bgeu	s2,s8,800045d8 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    800043fa:	02091593          	slli	a1,s2,0x20
    800043fe:	9181                	srli	a1,a1,0x20
    80004400:	95ea                	add	a1,a1,s10
    80004402:	855e                	mv	a0,s7
    80004404:	ffffc097          	auipc	ra,0xffffc
    80004408:	2e8080e7          	jalr	744(ra) # 800006ec <walkaddr>
    8000440c:	862a                	mv	a2,a0
    if(pa == 0)
    8000440e:	d955                	beqz	a0,800043c2 <exec+0xf0>
      n = PGSIZE;
    80004410:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004412:	fd9a70e3          	bgeu	s4,s9,800043d2 <exec+0x100>
      n = sz - i;
    80004416:	8ad2                	mv	s5,s4
    80004418:	bf6d                	j	800043d2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000441a:	4901                	li	s2,0
  iunlockput(ip);
    8000441c:	8526                	mv	a0,s1
    8000441e:	fffff097          	auipc	ra,0xfffff
    80004422:	c0e080e7          	jalr	-1010(ra) # 8000302c <iunlockput>
  end_op();
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	3f6080e7          	jalr	1014(ra) # 8000381c <end_op>
  p = myproc();
    8000442e:	ffffd097          	auipc	ra,0xffffd
    80004432:	c00080e7          	jalr	-1024(ra) # 8000102e <myproc>
    80004436:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004438:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    8000443c:	6785                	lui	a5,0x1
    8000443e:	17fd                	addi	a5,a5,-1
    80004440:	993e                	add	s2,s2,a5
    80004442:	757d                	lui	a0,0xfffff
    80004444:	00a977b3          	and	a5,s2,a0
    80004448:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000444c:	6609                	lui	a2,0x2
    8000444e:	963e                	add	a2,a2,a5
    80004450:	85be                	mv	a1,a5
    80004452:	855e                	mv	a0,s7
    80004454:	ffffc097          	auipc	ra,0xffffc
    80004458:	64c080e7          	jalr	1612(ra) # 80000aa0 <uvmalloc>
    8000445c:	8b2a                	mv	s6,a0
  ip = 0;
    8000445e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004460:	12050c63          	beqz	a0,80004598 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004464:	75f9                	lui	a1,0xffffe
    80004466:	95aa                	add	a1,a1,a0
    80004468:	855e                	mv	a0,s7
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	854080e7          	jalr	-1964(ra) # 80000cbe <uvmclear>
  stackbase = sp - PGSIZE;
    80004472:	7c7d                	lui	s8,0xfffff
    80004474:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004476:	e0043783          	ld	a5,-512(s0)
    8000447a:	6388                	ld	a0,0(a5)
    8000447c:	c535                	beqz	a0,800044e8 <exec+0x216>
    8000447e:	e9040993          	addi	s3,s0,-368
    80004482:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004486:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004488:	ffffc097          	auipc	ra,0xffffc
    8000448c:	04a080e7          	jalr	74(ra) # 800004d2 <strlen>
    80004490:	2505                	addiw	a0,a0,1
    80004492:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004496:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000449a:	13896363          	bltu	s2,s8,800045c0 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000449e:	e0043d83          	ld	s11,-512(s0)
    800044a2:	000dba03          	ld	s4,0(s11)
    800044a6:	8552                	mv	a0,s4
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	02a080e7          	jalr	42(ra) # 800004d2 <strlen>
    800044b0:	0015069b          	addiw	a3,a0,1
    800044b4:	8652                	mv	a2,s4
    800044b6:	85ca                	mv	a1,s2
    800044b8:	855e                	mv	a0,s7
    800044ba:	ffffd097          	auipc	ra,0xffffd
    800044be:	836080e7          	jalr	-1994(ra) # 80000cf0 <copyout>
    800044c2:	10054363          	bltz	a0,800045c8 <exec+0x2f6>
    ustack[argc] = sp;
    800044c6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800044ca:	0485                	addi	s1,s1,1
    800044cc:	008d8793          	addi	a5,s11,8
    800044d0:	e0f43023          	sd	a5,-512(s0)
    800044d4:	008db503          	ld	a0,8(s11)
    800044d8:	c911                	beqz	a0,800044ec <exec+0x21a>
    if(argc >= MAXARG)
    800044da:	09a1                	addi	s3,s3,8
    800044dc:	fb3c96e3          	bne	s9,s3,80004488 <exec+0x1b6>
  sz = sz1;
    800044e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e4:	4481                	li	s1,0
    800044e6:	a84d                	j	80004598 <exec+0x2c6>
  sp = sz;
    800044e8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800044ea:	4481                	li	s1,0
  ustack[argc] = 0;
    800044ec:	00349793          	slli	a5,s1,0x3
    800044f0:	f9040713          	addi	a4,s0,-112
    800044f4:	97ba                	add	a5,a5,a4
    800044f6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800044fa:	00148693          	addi	a3,s1,1
    800044fe:	068e                	slli	a3,a3,0x3
    80004500:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004504:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004508:	01897663          	bgeu	s2,s8,80004514 <exec+0x242>
  sz = sz1;
    8000450c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004510:	4481                	li	s1,0
    80004512:	a059                	j	80004598 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004514:	e9040613          	addi	a2,s0,-368
    80004518:	85ca                	mv	a1,s2
    8000451a:	855e                	mv	a0,s7
    8000451c:	ffffc097          	auipc	ra,0xffffc
    80004520:	7d4080e7          	jalr	2004(ra) # 80000cf0 <copyout>
    80004524:	0a054663          	bltz	a0,800045d0 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004528:	060ab783          	ld	a5,96(s5)
    8000452c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004530:	df843783          	ld	a5,-520(s0)
    80004534:	0007c703          	lbu	a4,0(a5)
    80004538:	cf11                	beqz	a4,80004554 <exec+0x282>
    8000453a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000453c:	02f00693          	li	a3,47
    80004540:	a039                	j	8000454e <exec+0x27c>
      last = s+1;
    80004542:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004546:	0785                	addi	a5,a5,1
    80004548:	fff7c703          	lbu	a4,-1(a5)
    8000454c:	c701                	beqz	a4,80004554 <exec+0x282>
    if(*s == '/')
    8000454e:	fed71ce3          	bne	a4,a3,80004546 <exec+0x274>
    80004552:	bfc5                	j	80004542 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004554:	4641                	li	a2,16
    80004556:	df843583          	ld	a1,-520(s0)
    8000455a:	160a8513          	addi	a0,s5,352
    8000455e:	ffffc097          	auipc	ra,0xffffc
    80004562:	f42080e7          	jalr	-190(ra) # 800004a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004566:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    8000456a:	057abc23          	sd	s7,88(s5)
  p->sz = sz;
    8000456e:	056ab823          	sd	s6,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004572:	060ab783          	ld	a5,96(s5)
    80004576:	e6843703          	ld	a4,-408(s0)
    8000457a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000457c:	060ab783          	ld	a5,96(s5)
    80004580:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004584:	85ea                	mv	a1,s10
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	c08080e7          	jalr	-1016(ra) # 8000118e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000458e:	0004851b          	sext.w	a0,s1
    80004592:	bbe1                	j	8000436a <exec+0x98>
    80004594:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004598:	e0843583          	ld	a1,-504(s0)
    8000459c:	855e                	mv	a0,s7
    8000459e:	ffffd097          	auipc	ra,0xffffd
    800045a2:	bf0080e7          	jalr	-1040(ra) # 8000118e <proc_freepagetable>
  if(ip){
    800045a6:	da0498e3          	bnez	s1,80004356 <exec+0x84>
  return -1;
    800045aa:	557d                	li	a0,-1
    800045ac:	bb7d                	j	8000436a <exec+0x98>
    800045ae:	e1243423          	sd	s2,-504(s0)
    800045b2:	b7dd                	j	80004598 <exec+0x2c6>
    800045b4:	e1243423          	sd	s2,-504(s0)
    800045b8:	b7c5                	j	80004598 <exec+0x2c6>
    800045ba:	e1243423          	sd	s2,-504(s0)
    800045be:	bfe9                	j	80004598 <exec+0x2c6>
  sz = sz1;
    800045c0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045c4:	4481                	li	s1,0
    800045c6:	bfc9                	j	80004598 <exec+0x2c6>
  sz = sz1;
    800045c8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045cc:	4481                	li	s1,0
    800045ce:	b7e9                	j	80004598 <exec+0x2c6>
  sz = sz1;
    800045d0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045d4:	4481                	li	s1,0
    800045d6:	b7c9                	j	80004598 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800045d8:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045dc:	2b05                	addiw	s6,s6,1
    800045de:	0389899b          	addiw	s3,s3,56
    800045e2:	e8845783          	lhu	a5,-376(s0)
    800045e6:	e2fb5be3          	bge	s6,a5,8000441c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045ea:	2981                	sext.w	s3,s3
    800045ec:	03800713          	li	a4,56
    800045f0:	86ce                	mv	a3,s3
    800045f2:	e1840613          	addi	a2,s0,-488
    800045f6:	4581                	li	a1,0
    800045f8:	8526                	mv	a0,s1
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	a84080e7          	jalr	-1404(ra) # 8000307e <readi>
    80004602:	03800793          	li	a5,56
    80004606:	f8f517e3          	bne	a0,a5,80004594 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    8000460a:	e1842783          	lw	a5,-488(s0)
    8000460e:	4705                	li	a4,1
    80004610:	fce796e3          	bne	a5,a4,800045dc <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004614:	e4043603          	ld	a2,-448(s0)
    80004618:	e3843783          	ld	a5,-456(s0)
    8000461c:	f8f669e3          	bltu	a2,a5,800045ae <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004620:	e2843783          	ld	a5,-472(s0)
    80004624:	963e                	add	a2,a2,a5
    80004626:	f8f667e3          	bltu	a2,a5,800045b4 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000462a:	85ca                	mv	a1,s2
    8000462c:	855e                	mv	a0,s7
    8000462e:	ffffc097          	auipc	ra,0xffffc
    80004632:	472080e7          	jalr	1138(ra) # 80000aa0 <uvmalloc>
    80004636:	e0a43423          	sd	a0,-504(s0)
    8000463a:	d141                	beqz	a0,800045ba <exec+0x2e8>
    if((ph.vaddr % PGSIZE) != 0)
    8000463c:	e2843d03          	ld	s10,-472(s0)
    80004640:	df043783          	ld	a5,-528(s0)
    80004644:	00fd77b3          	and	a5,s10,a5
    80004648:	fba1                	bnez	a5,80004598 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000464a:	e2042d83          	lw	s11,-480(s0)
    8000464e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004652:	f80c03e3          	beqz	s8,800045d8 <exec+0x306>
    80004656:	8a62                	mv	s4,s8
    80004658:	4901                	li	s2,0
    8000465a:	b345                	j	800043fa <exec+0x128>

000000008000465c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000465c:	7179                	addi	sp,sp,-48
    8000465e:	f406                	sd	ra,40(sp)
    80004660:	f022                	sd	s0,32(sp)
    80004662:	ec26                	sd	s1,24(sp)
    80004664:	e84a                	sd	s2,16(sp)
    80004666:	1800                	addi	s0,sp,48
    80004668:	892e                	mv	s2,a1
    8000466a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000466c:	fdc40593          	addi	a1,s0,-36
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	a6a080e7          	jalr	-1430(ra) # 800020da <argint>
    80004678:	04054063          	bltz	a0,800046b8 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000467c:	fdc42703          	lw	a4,-36(s0)
    80004680:	47bd                	li	a5,15
    80004682:	02e7ed63          	bltu	a5,a4,800046bc <argfd+0x60>
    80004686:	ffffd097          	auipc	ra,0xffffd
    8000468a:	9a8080e7          	jalr	-1624(ra) # 8000102e <myproc>
    8000468e:	fdc42703          	lw	a4,-36(s0)
    80004692:	01a70793          	addi	a5,a4,26
    80004696:	078e                	slli	a5,a5,0x3
    80004698:	953e                	add	a0,a0,a5
    8000469a:	651c                	ld	a5,8(a0)
    8000469c:	c395                	beqz	a5,800046c0 <argfd+0x64>
    return -1;
  if(pfd)
    8000469e:	00090463          	beqz	s2,800046a6 <argfd+0x4a>
    *pfd = fd;
    800046a2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046a6:	4501                	li	a0,0
  if(pf)
    800046a8:	c091                	beqz	s1,800046ac <argfd+0x50>
    *pf = f;
    800046aa:	e09c                	sd	a5,0(s1)
}
    800046ac:	70a2                	ld	ra,40(sp)
    800046ae:	7402                	ld	s0,32(sp)
    800046b0:	64e2                	ld	s1,24(sp)
    800046b2:	6942                	ld	s2,16(sp)
    800046b4:	6145                	addi	sp,sp,48
    800046b6:	8082                	ret
    return -1;
    800046b8:	557d                	li	a0,-1
    800046ba:	bfcd                	j	800046ac <argfd+0x50>
    return -1;
    800046bc:	557d                	li	a0,-1
    800046be:	b7fd                	j	800046ac <argfd+0x50>
    800046c0:	557d                	li	a0,-1
    800046c2:	b7ed                	j	800046ac <argfd+0x50>

00000000800046c4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046c4:	1101                	addi	sp,sp,-32
    800046c6:	ec06                	sd	ra,24(sp)
    800046c8:	e822                	sd	s0,16(sp)
    800046ca:	e426                	sd	s1,8(sp)
    800046cc:	1000                	addi	s0,sp,32
    800046ce:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046d0:	ffffd097          	auipc	ra,0xffffd
    800046d4:	95e080e7          	jalr	-1698(ra) # 8000102e <myproc>
    800046d8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046da:	0d850793          	addi	a5,a0,216 # fffffffffffff0d8 <end+0xffffffff7ffd3e90>
    800046de:	4501                	li	a0,0
    800046e0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046e2:	6398                	ld	a4,0(a5)
    800046e4:	cb19                	beqz	a4,800046fa <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046e6:	2505                	addiw	a0,a0,1
    800046e8:	07a1                	addi	a5,a5,8
    800046ea:	fed51ce3          	bne	a0,a3,800046e2 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046ee:	557d                	li	a0,-1
}
    800046f0:	60e2                	ld	ra,24(sp)
    800046f2:	6442                	ld	s0,16(sp)
    800046f4:	64a2                	ld	s1,8(sp)
    800046f6:	6105                	addi	sp,sp,32
    800046f8:	8082                	ret
      p->ofile[fd] = f;
    800046fa:	01a50793          	addi	a5,a0,26
    800046fe:	078e                	slli	a5,a5,0x3
    80004700:	963e                	add	a2,a2,a5
    80004702:	e604                	sd	s1,8(a2)
      return fd;
    80004704:	b7f5                	j	800046f0 <fdalloc+0x2c>

0000000080004706 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004706:	715d                	addi	sp,sp,-80
    80004708:	e486                	sd	ra,72(sp)
    8000470a:	e0a2                	sd	s0,64(sp)
    8000470c:	fc26                	sd	s1,56(sp)
    8000470e:	f84a                	sd	s2,48(sp)
    80004710:	f44e                	sd	s3,40(sp)
    80004712:	f052                	sd	s4,32(sp)
    80004714:	ec56                	sd	s5,24(sp)
    80004716:	0880                	addi	s0,sp,80
    80004718:	89ae                	mv	s3,a1
    8000471a:	8ab2                	mv	s5,a2
    8000471c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000471e:	fb040593          	addi	a1,s0,-80
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	e7c080e7          	jalr	-388(ra) # 8000359e <nameiparent>
    8000472a:	892a                	mv	s2,a0
    8000472c:	12050f63          	beqz	a0,8000486a <create+0x164>
    return 0;

  ilock(dp);
    80004730:	ffffe097          	auipc	ra,0xffffe
    80004734:	69a080e7          	jalr	1690(ra) # 80002dca <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004738:	4601                	li	a2,0
    8000473a:	fb040593          	addi	a1,s0,-80
    8000473e:	854a                	mv	a0,s2
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	b6e080e7          	jalr	-1170(ra) # 800032ae <dirlookup>
    80004748:	84aa                	mv	s1,a0
    8000474a:	c921                	beqz	a0,8000479a <create+0x94>
    iunlockput(dp);
    8000474c:	854a                	mv	a0,s2
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	8de080e7          	jalr	-1826(ra) # 8000302c <iunlockput>
    ilock(ip);
    80004756:	8526                	mv	a0,s1
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	672080e7          	jalr	1650(ra) # 80002dca <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004760:	2981                	sext.w	s3,s3
    80004762:	4789                	li	a5,2
    80004764:	02f99463          	bne	s3,a5,8000478c <create+0x86>
    80004768:	04c4d783          	lhu	a5,76(s1)
    8000476c:	37f9                	addiw	a5,a5,-2
    8000476e:	17c2                	slli	a5,a5,0x30
    80004770:	93c1                	srli	a5,a5,0x30
    80004772:	4705                	li	a4,1
    80004774:	00f76c63          	bltu	a4,a5,8000478c <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004778:	8526                	mv	a0,s1
    8000477a:	60a6                	ld	ra,72(sp)
    8000477c:	6406                	ld	s0,64(sp)
    8000477e:	74e2                	ld	s1,56(sp)
    80004780:	7942                	ld	s2,48(sp)
    80004782:	79a2                	ld	s3,40(sp)
    80004784:	7a02                	ld	s4,32(sp)
    80004786:	6ae2                	ld	s5,24(sp)
    80004788:	6161                	addi	sp,sp,80
    8000478a:	8082                	ret
    iunlockput(ip);
    8000478c:	8526                	mv	a0,s1
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	89e080e7          	jalr	-1890(ra) # 8000302c <iunlockput>
    return 0;
    80004796:	4481                	li	s1,0
    80004798:	b7c5                	j	80004778 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000479a:	85ce                	mv	a1,s3
    8000479c:	00092503          	lw	a0,0(s2)
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	492080e7          	jalr	1170(ra) # 80002c32 <ialloc>
    800047a8:	84aa                	mv	s1,a0
    800047aa:	c529                	beqz	a0,800047f4 <create+0xee>
  ilock(ip);
    800047ac:	ffffe097          	auipc	ra,0xffffe
    800047b0:	61e080e7          	jalr	1566(ra) # 80002dca <ilock>
  ip->major = major;
    800047b4:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    800047b8:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    800047bc:	4785                	li	a5,1
    800047be:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    800047c2:	8526                	mv	a0,s1
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	53c080e7          	jalr	1340(ra) # 80002d00 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047cc:	2981                	sext.w	s3,s3
    800047ce:	4785                	li	a5,1
    800047d0:	02f98a63          	beq	s3,a5,80004804 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800047d4:	40d0                	lw	a2,4(s1)
    800047d6:	fb040593          	addi	a1,s0,-80
    800047da:	854a                	mv	a0,s2
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	ce2080e7          	jalr	-798(ra) # 800034be <dirlink>
    800047e4:	06054b63          	bltz	a0,8000485a <create+0x154>
  iunlockput(dp);
    800047e8:	854a                	mv	a0,s2
    800047ea:	fffff097          	auipc	ra,0xfffff
    800047ee:	842080e7          	jalr	-1982(ra) # 8000302c <iunlockput>
  return ip;
    800047f2:	b759                	j	80004778 <create+0x72>
    panic("create: ialloc");
    800047f4:	00004517          	auipc	a0,0x4
    800047f8:	e7450513          	addi	a0,a0,-396 # 80008668 <syscalls+0x2a0>
    800047fc:	00002097          	auipc	ra,0x2
    80004800:	9c0080e7          	jalr	-1600(ra) # 800061bc <panic>
    dp->nlink++;  // for ".."
    80004804:	05295783          	lhu	a5,82(s2)
    80004808:	2785                	addiw	a5,a5,1
    8000480a:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    8000480e:	854a                	mv	a0,s2
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	4f0080e7          	jalr	1264(ra) # 80002d00 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004818:	40d0                	lw	a2,4(s1)
    8000481a:	00004597          	auipc	a1,0x4
    8000481e:	e5e58593          	addi	a1,a1,-418 # 80008678 <syscalls+0x2b0>
    80004822:	8526                	mv	a0,s1
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	c9a080e7          	jalr	-870(ra) # 800034be <dirlink>
    8000482c:	00054f63          	bltz	a0,8000484a <create+0x144>
    80004830:	00492603          	lw	a2,4(s2)
    80004834:	00004597          	auipc	a1,0x4
    80004838:	e4c58593          	addi	a1,a1,-436 # 80008680 <syscalls+0x2b8>
    8000483c:	8526                	mv	a0,s1
    8000483e:	fffff097          	auipc	ra,0xfffff
    80004842:	c80080e7          	jalr	-896(ra) # 800034be <dirlink>
    80004846:	f80557e3          	bgez	a0,800047d4 <create+0xce>
      panic("create dots");
    8000484a:	00004517          	auipc	a0,0x4
    8000484e:	e3e50513          	addi	a0,a0,-450 # 80008688 <syscalls+0x2c0>
    80004852:	00002097          	auipc	ra,0x2
    80004856:	96a080e7          	jalr	-1686(ra) # 800061bc <panic>
    panic("create: dirlink");
    8000485a:	00004517          	auipc	a0,0x4
    8000485e:	e3e50513          	addi	a0,a0,-450 # 80008698 <syscalls+0x2d0>
    80004862:	00002097          	auipc	ra,0x2
    80004866:	95a080e7          	jalr	-1702(ra) # 800061bc <panic>
    return 0;
    8000486a:	84aa                	mv	s1,a0
    8000486c:	b731                	j	80004778 <create+0x72>

000000008000486e <sys_dup>:
{
    8000486e:	7179                	addi	sp,sp,-48
    80004870:	f406                	sd	ra,40(sp)
    80004872:	f022                	sd	s0,32(sp)
    80004874:	ec26                	sd	s1,24(sp)
    80004876:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004878:	fd840613          	addi	a2,s0,-40
    8000487c:	4581                	li	a1,0
    8000487e:	4501                	li	a0,0
    80004880:	00000097          	auipc	ra,0x0
    80004884:	ddc080e7          	jalr	-548(ra) # 8000465c <argfd>
    return -1;
    80004888:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000488a:	02054363          	bltz	a0,800048b0 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000488e:	fd843503          	ld	a0,-40(s0)
    80004892:	00000097          	auipc	ra,0x0
    80004896:	e32080e7          	jalr	-462(ra) # 800046c4 <fdalloc>
    8000489a:	84aa                	mv	s1,a0
    return -1;
    8000489c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000489e:	00054963          	bltz	a0,800048b0 <sys_dup+0x42>
  filedup(f);
    800048a2:	fd843503          	ld	a0,-40(s0)
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	370080e7          	jalr	880(ra) # 80003c16 <filedup>
  return fd;
    800048ae:	87a6                	mv	a5,s1
}
    800048b0:	853e                	mv	a0,a5
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	64e2                	ld	s1,24(sp)
    800048b8:	6145                	addi	sp,sp,48
    800048ba:	8082                	ret

00000000800048bc <sys_read>:
{
    800048bc:	7179                	addi	sp,sp,-48
    800048be:	f406                	sd	ra,40(sp)
    800048c0:	f022                	sd	s0,32(sp)
    800048c2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048c4:	fe840613          	addi	a2,s0,-24
    800048c8:	4581                	li	a1,0
    800048ca:	4501                	li	a0,0
    800048cc:	00000097          	auipc	ra,0x0
    800048d0:	d90080e7          	jalr	-624(ra) # 8000465c <argfd>
    return -1;
    800048d4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048d6:	04054163          	bltz	a0,80004918 <sys_read+0x5c>
    800048da:	fe440593          	addi	a1,s0,-28
    800048de:	4509                	li	a0,2
    800048e0:	ffffd097          	auipc	ra,0xffffd
    800048e4:	7fa080e7          	jalr	2042(ra) # 800020da <argint>
    return -1;
    800048e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ea:	02054763          	bltz	a0,80004918 <sys_read+0x5c>
    800048ee:	fd840593          	addi	a1,s0,-40
    800048f2:	4505                	li	a0,1
    800048f4:	ffffe097          	auipc	ra,0xffffe
    800048f8:	808080e7          	jalr	-2040(ra) # 800020fc <argaddr>
    return -1;
    800048fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fe:	00054d63          	bltz	a0,80004918 <sys_read+0x5c>
  return fileread(f, p, n);
    80004902:	fe442603          	lw	a2,-28(s0)
    80004906:	fd843583          	ld	a1,-40(s0)
    8000490a:	fe843503          	ld	a0,-24(s0)
    8000490e:	fffff097          	auipc	ra,0xfffff
    80004912:	494080e7          	jalr	1172(ra) # 80003da2 <fileread>
    80004916:	87aa                	mv	a5,a0
}
    80004918:	853e                	mv	a0,a5
    8000491a:	70a2                	ld	ra,40(sp)
    8000491c:	7402                	ld	s0,32(sp)
    8000491e:	6145                	addi	sp,sp,48
    80004920:	8082                	ret

0000000080004922 <sys_write>:
{
    80004922:	7179                	addi	sp,sp,-48
    80004924:	f406                	sd	ra,40(sp)
    80004926:	f022                	sd	s0,32(sp)
    80004928:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000492a:	fe840613          	addi	a2,s0,-24
    8000492e:	4581                	li	a1,0
    80004930:	4501                	li	a0,0
    80004932:	00000097          	auipc	ra,0x0
    80004936:	d2a080e7          	jalr	-726(ra) # 8000465c <argfd>
    return -1;
    8000493a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493c:	04054163          	bltz	a0,8000497e <sys_write+0x5c>
    80004940:	fe440593          	addi	a1,s0,-28
    80004944:	4509                	li	a0,2
    80004946:	ffffd097          	auipc	ra,0xffffd
    8000494a:	794080e7          	jalr	1940(ra) # 800020da <argint>
    return -1;
    8000494e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004950:	02054763          	bltz	a0,8000497e <sys_write+0x5c>
    80004954:	fd840593          	addi	a1,s0,-40
    80004958:	4505                	li	a0,1
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	7a2080e7          	jalr	1954(ra) # 800020fc <argaddr>
    return -1;
    80004962:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004964:	00054d63          	bltz	a0,8000497e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004968:	fe442603          	lw	a2,-28(s0)
    8000496c:	fd843583          	ld	a1,-40(s0)
    80004970:	fe843503          	ld	a0,-24(s0)
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	4f0080e7          	jalr	1264(ra) # 80003e64 <filewrite>
    8000497c:	87aa                	mv	a5,a0
}
    8000497e:	853e                	mv	a0,a5
    80004980:	70a2                	ld	ra,40(sp)
    80004982:	7402                	ld	s0,32(sp)
    80004984:	6145                	addi	sp,sp,48
    80004986:	8082                	ret

0000000080004988 <sys_close>:
{
    80004988:	1101                	addi	sp,sp,-32
    8000498a:	ec06                	sd	ra,24(sp)
    8000498c:	e822                	sd	s0,16(sp)
    8000498e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004990:	fe040613          	addi	a2,s0,-32
    80004994:	fec40593          	addi	a1,s0,-20
    80004998:	4501                	li	a0,0
    8000499a:	00000097          	auipc	ra,0x0
    8000499e:	cc2080e7          	jalr	-830(ra) # 8000465c <argfd>
    return -1;
    800049a2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049a4:	02054463          	bltz	a0,800049cc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049a8:	ffffc097          	auipc	ra,0xffffc
    800049ac:	686080e7          	jalr	1670(ra) # 8000102e <myproc>
    800049b0:	fec42783          	lw	a5,-20(s0)
    800049b4:	07e9                	addi	a5,a5,26
    800049b6:	078e                	slli	a5,a5,0x3
    800049b8:	97aa                	add	a5,a5,a0
    800049ba:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    800049be:	fe043503          	ld	a0,-32(s0)
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	2a6080e7          	jalr	678(ra) # 80003c68 <fileclose>
  return 0;
    800049ca:	4781                	li	a5,0
}
    800049cc:	853e                	mv	a0,a5
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	6105                	addi	sp,sp,32
    800049d4:	8082                	ret

00000000800049d6 <sys_fstat>:
{
    800049d6:	1101                	addi	sp,sp,-32
    800049d8:	ec06                	sd	ra,24(sp)
    800049da:	e822                	sd	s0,16(sp)
    800049dc:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049de:	fe840613          	addi	a2,s0,-24
    800049e2:	4581                	li	a1,0
    800049e4:	4501                	li	a0,0
    800049e6:	00000097          	auipc	ra,0x0
    800049ea:	c76080e7          	jalr	-906(ra) # 8000465c <argfd>
    return -1;
    800049ee:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800049f0:	02054563          	bltz	a0,80004a1a <sys_fstat+0x44>
    800049f4:	fe040593          	addi	a1,s0,-32
    800049f8:	4505                	li	a0,1
    800049fa:	ffffd097          	auipc	ra,0xffffd
    800049fe:	702080e7          	jalr	1794(ra) # 800020fc <argaddr>
    return -1;
    80004a02:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a04:	00054b63          	bltz	a0,80004a1a <sys_fstat+0x44>
  return filestat(f, st);
    80004a08:	fe043583          	ld	a1,-32(s0)
    80004a0c:	fe843503          	ld	a0,-24(s0)
    80004a10:	fffff097          	auipc	ra,0xfffff
    80004a14:	320080e7          	jalr	800(ra) # 80003d30 <filestat>
    80004a18:	87aa                	mv	a5,a0
}
    80004a1a:	853e                	mv	a0,a5
    80004a1c:	60e2                	ld	ra,24(sp)
    80004a1e:	6442                	ld	s0,16(sp)
    80004a20:	6105                	addi	sp,sp,32
    80004a22:	8082                	ret

0000000080004a24 <sys_link>:
{
    80004a24:	7169                	addi	sp,sp,-304
    80004a26:	f606                	sd	ra,296(sp)
    80004a28:	f222                	sd	s0,288(sp)
    80004a2a:	ee26                	sd	s1,280(sp)
    80004a2c:	ea4a                	sd	s2,272(sp)
    80004a2e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a30:	08000613          	li	a2,128
    80004a34:	ed040593          	addi	a1,s0,-304
    80004a38:	4501                	li	a0,0
    80004a3a:	ffffd097          	auipc	ra,0xffffd
    80004a3e:	6e4080e7          	jalr	1764(ra) # 8000211e <argstr>
    return -1;
    80004a42:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a44:	10054e63          	bltz	a0,80004b60 <sys_link+0x13c>
    80004a48:	08000613          	li	a2,128
    80004a4c:	f5040593          	addi	a1,s0,-176
    80004a50:	4505                	li	a0,1
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	6cc080e7          	jalr	1740(ra) # 8000211e <argstr>
    return -1;
    80004a5a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a5c:	10054263          	bltz	a0,80004b60 <sys_link+0x13c>
  begin_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	d3c080e7          	jalr	-708(ra) # 8000379c <begin_op>
  if((ip = namei(old)) == 0){
    80004a68:	ed040513          	addi	a0,s0,-304
    80004a6c:	fffff097          	auipc	ra,0xfffff
    80004a70:	b14080e7          	jalr	-1260(ra) # 80003580 <namei>
    80004a74:	84aa                	mv	s1,a0
    80004a76:	c551                	beqz	a0,80004b02 <sys_link+0xde>
  ilock(ip);
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	352080e7          	jalr	850(ra) # 80002dca <ilock>
  if(ip->type == T_DIR){
    80004a80:	04c49703          	lh	a4,76(s1)
    80004a84:	4785                	li	a5,1
    80004a86:	08f70463          	beq	a4,a5,80004b0e <sys_link+0xea>
  ip->nlink++;
    80004a8a:	0524d783          	lhu	a5,82(s1)
    80004a8e:	2785                	addiw	a5,a5,1
    80004a90:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	26a080e7          	jalr	618(ra) # 80002d00 <iupdate>
  iunlock(ip);
    80004a9e:	8526                	mv	a0,s1
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	3ec080e7          	jalr	1004(ra) # 80002e8c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004aa8:	fd040593          	addi	a1,s0,-48
    80004aac:	f5040513          	addi	a0,s0,-176
    80004ab0:	fffff097          	auipc	ra,0xfffff
    80004ab4:	aee080e7          	jalr	-1298(ra) # 8000359e <nameiparent>
    80004ab8:	892a                	mv	s2,a0
    80004aba:	c935                	beqz	a0,80004b2e <sys_link+0x10a>
  ilock(dp);
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	30e080e7          	jalr	782(ra) # 80002dca <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ac4:	00092703          	lw	a4,0(s2)
    80004ac8:	409c                	lw	a5,0(s1)
    80004aca:	04f71d63          	bne	a4,a5,80004b24 <sys_link+0x100>
    80004ace:	40d0                	lw	a2,4(s1)
    80004ad0:	fd040593          	addi	a1,s0,-48
    80004ad4:	854a                	mv	a0,s2
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	9e8080e7          	jalr	-1560(ra) # 800034be <dirlink>
    80004ade:	04054363          	bltz	a0,80004b24 <sys_link+0x100>
  iunlockput(dp);
    80004ae2:	854a                	mv	a0,s2
    80004ae4:	ffffe097          	auipc	ra,0xffffe
    80004ae8:	548080e7          	jalr	1352(ra) # 8000302c <iunlockput>
  iput(ip);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	496080e7          	jalr	1174(ra) # 80002f84 <iput>
  end_op();
    80004af6:	fffff097          	auipc	ra,0xfffff
    80004afa:	d26080e7          	jalr	-730(ra) # 8000381c <end_op>
  return 0;
    80004afe:	4781                	li	a5,0
    80004b00:	a085                	j	80004b60 <sys_link+0x13c>
    end_op();
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	d1a080e7          	jalr	-742(ra) # 8000381c <end_op>
    return -1;
    80004b0a:	57fd                	li	a5,-1
    80004b0c:	a891                	j	80004b60 <sys_link+0x13c>
    iunlockput(ip);
    80004b0e:	8526                	mv	a0,s1
    80004b10:	ffffe097          	auipc	ra,0xffffe
    80004b14:	51c080e7          	jalr	1308(ra) # 8000302c <iunlockput>
    end_op();
    80004b18:	fffff097          	auipc	ra,0xfffff
    80004b1c:	d04080e7          	jalr	-764(ra) # 8000381c <end_op>
    return -1;
    80004b20:	57fd                	li	a5,-1
    80004b22:	a83d                	j	80004b60 <sys_link+0x13c>
    iunlockput(dp);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	506080e7          	jalr	1286(ra) # 8000302c <iunlockput>
  ilock(ip);
    80004b2e:	8526                	mv	a0,s1
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	29a080e7          	jalr	666(ra) # 80002dca <ilock>
  ip->nlink--;
    80004b38:	0524d783          	lhu	a5,82(s1)
    80004b3c:	37fd                	addiw	a5,a5,-1
    80004b3e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004b42:	8526                	mv	a0,s1
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	1bc080e7          	jalr	444(ra) # 80002d00 <iupdate>
  iunlockput(ip);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	4de080e7          	jalr	1246(ra) # 8000302c <iunlockput>
  end_op();
    80004b56:	fffff097          	auipc	ra,0xfffff
    80004b5a:	cc6080e7          	jalr	-826(ra) # 8000381c <end_op>
  return -1;
    80004b5e:	57fd                	li	a5,-1
}
    80004b60:	853e                	mv	a0,a5
    80004b62:	70b2                	ld	ra,296(sp)
    80004b64:	7412                	ld	s0,288(sp)
    80004b66:	64f2                	ld	s1,280(sp)
    80004b68:	6952                	ld	s2,272(sp)
    80004b6a:	6155                	addi	sp,sp,304
    80004b6c:	8082                	ret

0000000080004b6e <sys_unlink>:
{
    80004b6e:	7151                	addi	sp,sp,-240
    80004b70:	f586                	sd	ra,232(sp)
    80004b72:	f1a2                	sd	s0,224(sp)
    80004b74:	eda6                	sd	s1,216(sp)
    80004b76:	e9ca                	sd	s2,208(sp)
    80004b78:	e5ce                	sd	s3,200(sp)
    80004b7a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b7c:	08000613          	li	a2,128
    80004b80:	f3040593          	addi	a1,s0,-208
    80004b84:	4501                	li	a0,0
    80004b86:	ffffd097          	auipc	ra,0xffffd
    80004b8a:	598080e7          	jalr	1432(ra) # 8000211e <argstr>
    80004b8e:	18054163          	bltz	a0,80004d10 <sys_unlink+0x1a2>
  begin_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	c0a080e7          	jalr	-1014(ra) # 8000379c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b9a:	fb040593          	addi	a1,s0,-80
    80004b9e:	f3040513          	addi	a0,s0,-208
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	9fc080e7          	jalr	-1540(ra) # 8000359e <nameiparent>
    80004baa:	84aa                	mv	s1,a0
    80004bac:	c979                	beqz	a0,80004c82 <sys_unlink+0x114>
  ilock(dp);
    80004bae:	ffffe097          	auipc	ra,0xffffe
    80004bb2:	21c080e7          	jalr	540(ra) # 80002dca <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004bb6:	00004597          	auipc	a1,0x4
    80004bba:	ac258593          	addi	a1,a1,-1342 # 80008678 <syscalls+0x2b0>
    80004bbe:	fb040513          	addi	a0,s0,-80
    80004bc2:	ffffe097          	auipc	ra,0xffffe
    80004bc6:	6d2080e7          	jalr	1746(ra) # 80003294 <namecmp>
    80004bca:	14050a63          	beqz	a0,80004d1e <sys_unlink+0x1b0>
    80004bce:	00004597          	auipc	a1,0x4
    80004bd2:	ab258593          	addi	a1,a1,-1358 # 80008680 <syscalls+0x2b8>
    80004bd6:	fb040513          	addi	a0,s0,-80
    80004bda:	ffffe097          	auipc	ra,0xffffe
    80004bde:	6ba080e7          	jalr	1722(ra) # 80003294 <namecmp>
    80004be2:	12050e63          	beqz	a0,80004d1e <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004be6:	f2c40613          	addi	a2,s0,-212
    80004bea:	fb040593          	addi	a1,s0,-80
    80004bee:	8526                	mv	a0,s1
    80004bf0:	ffffe097          	auipc	ra,0xffffe
    80004bf4:	6be080e7          	jalr	1726(ra) # 800032ae <dirlookup>
    80004bf8:	892a                	mv	s2,a0
    80004bfa:	12050263          	beqz	a0,80004d1e <sys_unlink+0x1b0>
  ilock(ip);
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	1cc080e7          	jalr	460(ra) # 80002dca <ilock>
  if(ip->nlink < 1)
    80004c06:	05291783          	lh	a5,82(s2)
    80004c0a:	08f05263          	blez	a5,80004c8e <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c0e:	04c91703          	lh	a4,76(s2)
    80004c12:	4785                	li	a5,1
    80004c14:	08f70563          	beq	a4,a5,80004c9e <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004c18:	4641                	li	a2,16
    80004c1a:	4581                	li	a1,0
    80004c1c:	fc040513          	addi	a0,s0,-64
    80004c20:	ffffb097          	auipc	ra,0xffffb
    80004c24:	72e080e7          	jalr	1838(ra) # 8000034e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c28:	4741                	li	a4,16
    80004c2a:	f2c42683          	lw	a3,-212(s0)
    80004c2e:	fc040613          	addi	a2,s0,-64
    80004c32:	4581                	li	a1,0
    80004c34:	8526                	mv	a0,s1
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	540080e7          	jalr	1344(ra) # 80003176 <writei>
    80004c3e:	47c1                	li	a5,16
    80004c40:	0af51563          	bne	a0,a5,80004cea <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c44:	04c91703          	lh	a4,76(s2)
    80004c48:	4785                	li	a5,1
    80004c4a:	0af70863          	beq	a4,a5,80004cfa <sys_unlink+0x18c>
  iunlockput(dp);
    80004c4e:	8526                	mv	a0,s1
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	3dc080e7          	jalr	988(ra) # 8000302c <iunlockput>
  ip->nlink--;
    80004c58:	05295783          	lhu	a5,82(s2)
    80004c5c:	37fd                	addiw	a5,a5,-1
    80004c5e:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    80004c62:	854a                	mv	a0,s2
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	09c080e7          	jalr	156(ra) # 80002d00 <iupdate>
  iunlockput(ip);
    80004c6c:	854a                	mv	a0,s2
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	3be080e7          	jalr	958(ra) # 8000302c <iunlockput>
  end_op();
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	ba6080e7          	jalr	-1114(ra) # 8000381c <end_op>
  return 0;
    80004c7e:	4501                	li	a0,0
    80004c80:	a84d                	j	80004d32 <sys_unlink+0x1c4>
    end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	b9a080e7          	jalr	-1126(ra) # 8000381c <end_op>
    return -1;
    80004c8a:	557d                	li	a0,-1
    80004c8c:	a05d                	j	80004d32 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c8e:	00004517          	auipc	a0,0x4
    80004c92:	a1a50513          	addi	a0,a0,-1510 # 800086a8 <syscalls+0x2e0>
    80004c96:	00001097          	auipc	ra,0x1
    80004c9a:	526080e7          	jalr	1318(ra) # 800061bc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c9e:	05492703          	lw	a4,84(s2)
    80004ca2:	02000793          	li	a5,32
    80004ca6:	f6e7f9e3          	bgeu	a5,a4,80004c18 <sys_unlink+0xaa>
    80004caa:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cae:	4741                	li	a4,16
    80004cb0:	86ce                	mv	a3,s3
    80004cb2:	f1840613          	addi	a2,s0,-232
    80004cb6:	4581                	li	a1,0
    80004cb8:	854a                	mv	a0,s2
    80004cba:	ffffe097          	auipc	ra,0xffffe
    80004cbe:	3c4080e7          	jalr	964(ra) # 8000307e <readi>
    80004cc2:	47c1                	li	a5,16
    80004cc4:	00f51b63          	bne	a0,a5,80004cda <sys_unlink+0x16c>
    if(de.inum != 0)
    80004cc8:	f1845783          	lhu	a5,-232(s0)
    80004ccc:	e7a1                	bnez	a5,80004d14 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cce:	29c1                	addiw	s3,s3,16
    80004cd0:	05492783          	lw	a5,84(s2)
    80004cd4:	fcf9ede3          	bltu	s3,a5,80004cae <sys_unlink+0x140>
    80004cd8:	b781                	j	80004c18 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cda:	00004517          	auipc	a0,0x4
    80004cde:	9e650513          	addi	a0,a0,-1562 # 800086c0 <syscalls+0x2f8>
    80004ce2:	00001097          	auipc	ra,0x1
    80004ce6:	4da080e7          	jalr	1242(ra) # 800061bc <panic>
    panic("unlink: writei");
    80004cea:	00004517          	auipc	a0,0x4
    80004cee:	9ee50513          	addi	a0,a0,-1554 # 800086d8 <syscalls+0x310>
    80004cf2:	00001097          	auipc	ra,0x1
    80004cf6:	4ca080e7          	jalr	1226(ra) # 800061bc <panic>
    dp->nlink--;
    80004cfa:	0524d783          	lhu	a5,82(s1)
    80004cfe:	37fd                	addiw	a5,a5,-1
    80004d00:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004d04:	8526                	mv	a0,s1
    80004d06:	ffffe097          	auipc	ra,0xffffe
    80004d0a:	ffa080e7          	jalr	-6(ra) # 80002d00 <iupdate>
    80004d0e:	b781                	j	80004c4e <sys_unlink+0xe0>
    return -1;
    80004d10:	557d                	li	a0,-1
    80004d12:	a005                	j	80004d32 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004d14:	854a                	mv	a0,s2
    80004d16:	ffffe097          	auipc	ra,0xffffe
    80004d1a:	316080e7          	jalr	790(ra) # 8000302c <iunlockput>
  iunlockput(dp);
    80004d1e:	8526                	mv	a0,s1
    80004d20:	ffffe097          	auipc	ra,0xffffe
    80004d24:	30c080e7          	jalr	780(ra) # 8000302c <iunlockput>
  end_op();
    80004d28:	fffff097          	auipc	ra,0xfffff
    80004d2c:	af4080e7          	jalr	-1292(ra) # 8000381c <end_op>
  return -1;
    80004d30:	557d                	li	a0,-1
}
    80004d32:	70ae                	ld	ra,232(sp)
    80004d34:	740e                	ld	s0,224(sp)
    80004d36:	64ee                	ld	s1,216(sp)
    80004d38:	694e                	ld	s2,208(sp)
    80004d3a:	69ae                	ld	s3,200(sp)
    80004d3c:	616d                	addi	sp,sp,240
    80004d3e:	8082                	ret

0000000080004d40 <sys_open>:

uint64
sys_open(void)
{
    80004d40:	7131                	addi	sp,sp,-192
    80004d42:	fd06                	sd	ra,184(sp)
    80004d44:	f922                	sd	s0,176(sp)
    80004d46:	f526                	sd	s1,168(sp)
    80004d48:	f14a                	sd	s2,160(sp)
    80004d4a:	ed4e                	sd	s3,152(sp)
    80004d4c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d4e:	08000613          	li	a2,128
    80004d52:	f5040593          	addi	a1,s0,-176
    80004d56:	4501                	li	a0,0
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	3c6080e7          	jalr	966(ra) # 8000211e <argstr>
    return -1;
    80004d60:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d62:	0c054163          	bltz	a0,80004e24 <sys_open+0xe4>
    80004d66:	f4c40593          	addi	a1,s0,-180
    80004d6a:	4505                	li	a0,1
    80004d6c:	ffffd097          	auipc	ra,0xffffd
    80004d70:	36e080e7          	jalr	878(ra) # 800020da <argint>
    80004d74:	0a054863          	bltz	a0,80004e24 <sys_open+0xe4>

  begin_op();
    80004d78:	fffff097          	auipc	ra,0xfffff
    80004d7c:	a24080e7          	jalr	-1500(ra) # 8000379c <begin_op>

  if(omode & O_CREATE){
    80004d80:	f4c42783          	lw	a5,-180(s0)
    80004d84:	2007f793          	andi	a5,a5,512
    80004d88:	cbdd                	beqz	a5,80004e3e <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d8a:	4681                	li	a3,0
    80004d8c:	4601                	li	a2,0
    80004d8e:	4589                	li	a1,2
    80004d90:	f5040513          	addi	a0,s0,-176
    80004d94:	00000097          	auipc	ra,0x0
    80004d98:	972080e7          	jalr	-1678(ra) # 80004706 <create>
    80004d9c:	892a                	mv	s2,a0
    if(ip == 0){
    80004d9e:	c959                	beqz	a0,80004e34 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004da0:	04c91703          	lh	a4,76(s2)
    80004da4:	478d                	li	a5,3
    80004da6:	00f71763          	bne	a4,a5,80004db4 <sys_open+0x74>
    80004daa:	04e95703          	lhu	a4,78(s2)
    80004dae:	47a5                	li	a5,9
    80004db0:	0ce7ec63          	bltu	a5,a4,80004e88 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	df8080e7          	jalr	-520(ra) # 80003bac <filealloc>
    80004dbc:	89aa                	mv	s3,a0
    80004dbe:	10050263          	beqz	a0,80004ec2 <sys_open+0x182>
    80004dc2:	00000097          	auipc	ra,0x0
    80004dc6:	902080e7          	jalr	-1790(ra) # 800046c4 <fdalloc>
    80004dca:	84aa                	mv	s1,a0
    80004dcc:	0e054663          	bltz	a0,80004eb8 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004dd0:	04c91703          	lh	a4,76(s2)
    80004dd4:	478d                	li	a5,3
    80004dd6:	0cf70463          	beq	a4,a5,80004e9e <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004dda:	4789                	li	a5,2
    80004ddc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004de0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004de4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004de8:	f4c42783          	lw	a5,-180(s0)
    80004dec:	0017c713          	xori	a4,a5,1
    80004df0:	8b05                	andi	a4,a4,1
    80004df2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004df6:	0037f713          	andi	a4,a5,3
    80004dfa:	00e03733          	snez	a4,a4
    80004dfe:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e02:	4007f793          	andi	a5,a5,1024
    80004e06:	c791                	beqz	a5,80004e12 <sys_open+0xd2>
    80004e08:	04c91703          	lh	a4,76(s2)
    80004e0c:	4789                	li	a5,2
    80004e0e:	08f70f63          	beq	a4,a5,80004eac <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004e12:	854a                	mv	a0,s2
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	078080e7          	jalr	120(ra) # 80002e8c <iunlock>
  end_op();
    80004e1c:	fffff097          	auipc	ra,0xfffff
    80004e20:	a00080e7          	jalr	-1536(ra) # 8000381c <end_op>

  return fd;
}
    80004e24:	8526                	mv	a0,s1
    80004e26:	70ea                	ld	ra,184(sp)
    80004e28:	744a                	ld	s0,176(sp)
    80004e2a:	74aa                	ld	s1,168(sp)
    80004e2c:	790a                	ld	s2,160(sp)
    80004e2e:	69ea                	ld	s3,152(sp)
    80004e30:	6129                	addi	sp,sp,192
    80004e32:	8082                	ret
      end_op();
    80004e34:	fffff097          	auipc	ra,0xfffff
    80004e38:	9e8080e7          	jalr	-1560(ra) # 8000381c <end_op>
      return -1;
    80004e3c:	b7e5                	j	80004e24 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e3e:	f5040513          	addi	a0,s0,-176
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	73e080e7          	jalr	1854(ra) # 80003580 <namei>
    80004e4a:	892a                	mv	s2,a0
    80004e4c:	c905                	beqz	a0,80004e7c <sys_open+0x13c>
    ilock(ip);
    80004e4e:	ffffe097          	auipc	ra,0xffffe
    80004e52:	f7c080e7          	jalr	-132(ra) # 80002dca <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e56:	04c91703          	lh	a4,76(s2)
    80004e5a:	4785                	li	a5,1
    80004e5c:	f4f712e3          	bne	a4,a5,80004da0 <sys_open+0x60>
    80004e60:	f4c42783          	lw	a5,-180(s0)
    80004e64:	dba1                	beqz	a5,80004db4 <sys_open+0x74>
      iunlockput(ip);
    80004e66:	854a                	mv	a0,s2
    80004e68:	ffffe097          	auipc	ra,0xffffe
    80004e6c:	1c4080e7          	jalr	452(ra) # 8000302c <iunlockput>
      end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	9ac080e7          	jalr	-1620(ra) # 8000381c <end_op>
      return -1;
    80004e78:	54fd                	li	s1,-1
    80004e7a:	b76d                	j	80004e24 <sys_open+0xe4>
      end_op();
    80004e7c:	fffff097          	auipc	ra,0xfffff
    80004e80:	9a0080e7          	jalr	-1632(ra) # 8000381c <end_op>
      return -1;
    80004e84:	54fd                	li	s1,-1
    80004e86:	bf79                	j	80004e24 <sys_open+0xe4>
    iunlockput(ip);
    80004e88:	854a                	mv	a0,s2
    80004e8a:	ffffe097          	auipc	ra,0xffffe
    80004e8e:	1a2080e7          	jalr	418(ra) # 8000302c <iunlockput>
    end_op();
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	98a080e7          	jalr	-1654(ra) # 8000381c <end_op>
    return -1;
    80004e9a:	54fd                	li	s1,-1
    80004e9c:	b761                	j	80004e24 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e9e:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ea2:	04e91783          	lh	a5,78(s2)
    80004ea6:	02f99223          	sh	a5,36(s3)
    80004eaa:	bf2d                	j	80004de4 <sys_open+0xa4>
    itrunc(ip);
    80004eac:	854a                	mv	a0,s2
    80004eae:	ffffe097          	auipc	ra,0xffffe
    80004eb2:	02a080e7          	jalr	42(ra) # 80002ed8 <itrunc>
    80004eb6:	bfb1                	j	80004e12 <sys_open+0xd2>
      fileclose(f);
    80004eb8:	854e                	mv	a0,s3
    80004eba:	fffff097          	auipc	ra,0xfffff
    80004ebe:	dae080e7          	jalr	-594(ra) # 80003c68 <fileclose>
    iunlockput(ip);
    80004ec2:	854a                	mv	a0,s2
    80004ec4:	ffffe097          	auipc	ra,0xffffe
    80004ec8:	168080e7          	jalr	360(ra) # 8000302c <iunlockput>
    end_op();
    80004ecc:	fffff097          	auipc	ra,0xfffff
    80004ed0:	950080e7          	jalr	-1712(ra) # 8000381c <end_op>
    return -1;
    80004ed4:	54fd                	li	s1,-1
    80004ed6:	b7b9                	j	80004e24 <sys_open+0xe4>

0000000080004ed8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ed8:	7175                	addi	sp,sp,-144
    80004eda:	e506                	sd	ra,136(sp)
    80004edc:	e122                	sd	s0,128(sp)
    80004ede:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	8bc080e7          	jalr	-1860(ra) # 8000379c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ee8:	08000613          	li	a2,128
    80004eec:	f7040593          	addi	a1,s0,-144
    80004ef0:	4501                	li	a0,0
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	22c080e7          	jalr	556(ra) # 8000211e <argstr>
    80004efa:	02054963          	bltz	a0,80004f2c <sys_mkdir+0x54>
    80004efe:	4681                	li	a3,0
    80004f00:	4601                	li	a2,0
    80004f02:	4585                	li	a1,1
    80004f04:	f7040513          	addi	a0,s0,-144
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	7fe080e7          	jalr	2046(ra) # 80004706 <create>
    80004f10:	cd11                	beqz	a0,80004f2c <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	11a080e7          	jalr	282(ra) # 8000302c <iunlockput>
  end_op();
    80004f1a:	fffff097          	auipc	ra,0xfffff
    80004f1e:	902080e7          	jalr	-1790(ra) # 8000381c <end_op>
  return 0;
    80004f22:	4501                	li	a0,0
}
    80004f24:	60aa                	ld	ra,136(sp)
    80004f26:	640a                	ld	s0,128(sp)
    80004f28:	6149                	addi	sp,sp,144
    80004f2a:	8082                	ret
    end_op();
    80004f2c:	fffff097          	auipc	ra,0xfffff
    80004f30:	8f0080e7          	jalr	-1808(ra) # 8000381c <end_op>
    return -1;
    80004f34:	557d                	li	a0,-1
    80004f36:	b7fd                	j	80004f24 <sys_mkdir+0x4c>

0000000080004f38 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f38:	7135                	addi	sp,sp,-160
    80004f3a:	ed06                	sd	ra,152(sp)
    80004f3c:	e922                	sd	s0,144(sp)
    80004f3e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f40:	fffff097          	auipc	ra,0xfffff
    80004f44:	85c080e7          	jalr	-1956(ra) # 8000379c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f48:	08000613          	li	a2,128
    80004f4c:	f7040593          	addi	a1,s0,-144
    80004f50:	4501                	li	a0,0
    80004f52:	ffffd097          	auipc	ra,0xffffd
    80004f56:	1cc080e7          	jalr	460(ra) # 8000211e <argstr>
    80004f5a:	04054a63          	bltz	a0,80004fae <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004f5e:	f6c40593          	addi	a1,s0,-148
    80004f62:	4505                	li	a0,1
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	176080e7          	jalr	374(ra) # 800020da <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f6c:	04054163          	bltz	a0,80004fae <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004f70:	f6840593          	addi	a1,s0,-152
    80004f74:	4509                	li	a0,2
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	164080e7          	jalr	356(ra) # 800020da <argint>
     argint(1, &major) < 0 ||
    80004f7e:	02054863          	bltz	a0,80004fae <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f82:	f6841683          	lh	a3,-152(s0)
    80004f86:	f6c41603          	lh	a2,-148(s0)
    80004f8a:	458d                	li	a1,3
    80004f8c:	f7040513          	addi	a0,s0,-144
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	776080e7          	jalr	1910(ra) # 80004706 <create>
     argint(2, &minor) < 0 ||
    80004f98:	c919                	beqz	a0,80004fae <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	092080e7          	jalr	146(ra) # 8000302c <iunlockput>
  end_op();
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	87a080e7          	jalr	-1926(ra) # 8000381c <end_op>
  return 0;
    80004faa:	4501                	li	a0,0
    80004fac:	a031                	j	80004fb8 <sys_mknod+0x80>
    end_op();
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	86e080e7          	jalr	-1938(ra) # 8000381c <end_op>
    return -1;
    80004fb6:	557d                	li	a0,-1
}
    80004fb8:	60ea                	ld	ra,152(sp)
    80004fba:	644a                	ld	s0,144(sp)
    80004fbc:	610d                	addi	sp,sp,160
    80004fbe:	8082                	ret

0000000080004fc0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fc0:	7135                	addi	sp,sp,-160
    80004fc2:	ed06                	sd	ra,152(sp)
    80004fc4:	e922                	sd	s0,144(sp)
    80004fc6:	e526                	sd	s1,136(sp)
    80004fc8:	e14a                	sd	s2,128(sp)
    80004fca:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004fcc:	ffffc097          	auipc	ra,0xffffc
    80004fd0:	062080e7          	jalr	98(ra) # 8000102e <myproc>
    80004fd4:	892a                	mv	s2,a0
  
  begin_op();
    80004fd6:	ffffe097          	auipc	ra,0xffffe
    80004fda:	7c6080e7          	jalr	1990(ra) # 8000379c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fde:	08000613          	li	a2,128
    80004fe2:	f6040593          	addi	a1,s0,-160
    80004fe6:	4501                	li	a0,0
    80004fe8:	ffffd097          	auipc	ra,0xffffd
    80004fec:	136080e7          	jalr	310(ra) # 8000211e <argstr>
    80004ff0:	04054b63          	bltz	a0,80005046 <sys_chdir+0x86>
    80004ff4:	f6040513          	addi	a0,s0,-160
    80004ff8:	ffffe097          	auipc	ra,0xffffe
    80004ffc:	588080e7          	jalr	1416(ra) # 80003580 <namei>
    80005000:	84aa                	mv	s1,a0
    80005002:	c131                	beqz	a0,80005046 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	dc6080e7          	jalr	-570(ra) # 80002dca <ilock>
  if(ip->type != T_DIR){
    8000500c:	04c49703          	lh	a4,76(s1)
    80005010:	4785                	li	a5,1
    80005012:	04f71063          	bne	a4,a5,80005052 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005016:	8526                	mv	a0,s1
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	e74080e7          	jalr	-396(ra) # 80002e8c <iunlock>
  iput(p->cwd);
    80005020:	15893503          	ld	a0,344(s2)
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	f60080e7          	jalr	-160(ra) # 80002f84 <iput>
  end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	7f0080e7          	jalr	2032(ra) # 8000381c <end_op>
  p->cwd = ip;
    80005034:	14993c23          	sd	s1,344(s2)
  return 0;
    80005038:	4501                	li	a0,0
}
    8000503a:	60ea                	ld	ra,152(sp)
    8000503c:	644a                	ld	s0,144(sp)
    8000503e:	64aa                	ld	s1,136(sp)
    80005040:	690a                	ld	s2,128(sp)
    80005042:	610d                	addi	sp,sp,160
    80005044:	8082                	ret
    end_op();
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	7d6080e7          	jalr	2006(ra) # 8000381c <end_op>
    return -1;
    8000504e:	557d                	li	a0,-1
    80005050:	b7ed                	j	8000503a <sys_chdir+0x7a>
    iunlockput(ip);
    80005052:	8526                	mv	a0,s1
    80005054:	ffffe097          	auipc	ra,0xffffe
    80005058:	fd8080e7          	jalr	-40(ra) # 8000302c <iunlockput>
    end_op();
    8000505c:	ffffe097          	auipc	ra,0xffffe
    80005060:	7c0080e7          	jalr	1984(ra) # 8000381c <end_op>
    return -1;
    80005064:	557d                	li	a0,-1
    80005066:	bfd1                	j	8000503a <sys_chdir+0x7a>

0000000080005068 <sys_exec>:

uint64
sys_exec(void)
{
    80005068:	7145                	addi	sp,sp,-464
    8000506a:	e786                	sd	ra,456(sp)
    8000506c:	e3a2                	sd	s0,448(sp)
    8000506e:	ff26                	sd	s1,440(sp)
    80005070:	fb4a                	sd	s2,432(sp)
    80005072:	f74e                	sd	s3,424(sp)
    80005074:	f352                	sd	s4,416(sp)
    80005076:	ef56                	sd	s5,408(sp)
    80005078:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000507a:	08000613          	li	a2,128
    8000507e:	f4040593          	addi	a1,s0,-192
    80005082:	4501                	li	a0,0
    80005084:	ffffd097          	auipc	ra,0xffffd
    80005088:	09a080e7          	jalr	154(ra) # 8000211e <argstr>
    return -1;
    8000508c:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    8000508e:	0c054a63          	bltz	a0,80005162 <sys_exec+0xfa>
    80005092:	e3840593          	addi	a1,s0,-456
    80005096:	4505                	li	a0,1
    80005098:	ffffd097          	auipc	ra,0xffffd
    8000509c:	064080e7          	jalr	100(ra) # 800020fc <argaddr>
    800050a0:	0c054163          	bltz	a0,80005162 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800050a4:	10000613          	li	a2,256
    800050a8:	4581                	li	a1,0
    800050aa:	e4040513          	addi	a0,s0,-448
    800050ae:	ffffb097          	auipc	ra,0xffffb
    800050b2:	2a0080e7          	jalr	672(ra) # 8000034e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800050b6:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800050ba:	89a6                	mv	s3,s1
    800050bc:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800050be:	02000a13          	li	s4,32
    800050c2:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800050c6:	00391513          	slli	a0,s2,0x3
    800050ca:	e3040593          	addi	a1,s0,-464
    800050ce:	e3843783          	ld	a5,-456(s0)
    800050d2:	953e                	add	a0,a0,a5
    800050d4:	ffffd097          	auipc	ra,0xffffd
    800050d8:	f6c080e7          	jalr	-148(ra) # 80002040 <fetchaddr>
    800050dc:	02054a63          	bltz	a0,80005110 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800050e0:	e3043783          	ld	a5,-464(s0)
    800050e4:	c3b9                	beqz	a5,8000512a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050e6:	ffffb097          	auipc	ra,0xffffb
    800050ea:	fdc080e7          	jalr	-36(ra) # 800000c2 <kalloc>
    800050ee:	85aa                	mv	a1,a0
    800050f0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050f4:	cd11                	beqz	a0,80005110 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050f6:	6605                	lui	a2,0x1
    800050f8:	e3043503          	ld	a0,-464(s0)
    800050fc:	ffffd097          	auipc	ra,0xffffd
    80005100:	f96080e7          	jalr	-106(ra) # 80002092 <fetchstr>
    80005104:	00054663          	bltz	a0,80005110 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005108:	0905                	addi	s2,s2,1
    8000510a:	09a1                	addi	s3,s3,8
    8000510c:	fb491be3          	bne	s2,s4,800050c2 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005110:	10048913          	addi	s2,s1,256
    80005114:	6088                	ld	a0,0(s1)
    80005116:	c529                	beqz	a0,80005160 <sys_exec+0xf8>
    kfree(argv[i]);
    80005118:	ffffb097          	auipc	ra,0xffffb
    8000511c:	f04080e7          	jalr	-252(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005120:	04a1                	addi	s1,s1,8
    80005122:	ff2499e3          	bne	s1,s2,80005114 <sys_exec+0xac>
  return -1;
    80005126:	597d                	li	s2,-1
    80005128:	a82d                	j	80005162 <sys_exec+0xfa>
      argv[i] = 0;
    8000512a:	0a8e                	slli	s5,s5,0x3
    8000512c:	fc040793          	addi	a5,s0,-64
    80005130:	9abe                	add	s5,s5,a5
    80005132:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005136:	e4040593          	addi	a1,s0,-448
    8000513a:	f4040513          	addi	a0,s0,-192
    8000513e:	fffff097          	auipc	ra,0xfffff
    80005142:	194080e7          	jalr	404(ra) # 800042d2 <exec>
    80005146:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005148:	10048993          	addi	s3,s1,256
    8000514c:	6088                	ld	a0,0(s1)
    8000514e:	c911                	beqz	a0,80005162 <sys_exec+0xfa>
    kfree(argv[i]);
    80005150:	ffffb097          	auipc	ra,0xffffb
    80005154:	ecc080e7          	jalr	-308(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005158:	04a1                	addi	s1,s1,8
    8000515a:	ff3499e3          	bne	s1,s3,8000514c <sys_exec+0xe4>
    8000515e:	a011                	j	80005162 <sys_exec+0xfa>
  return -1;
    80005160:	597d                	li	s2,-1
}
    80005162:	854a                	mv	a0,s2
    80005164:	60be                	ld	ra,456(sp)
    80005166:	641e                	ld	s0,448(sp)
    80005168:	74fa                	ld	s1,440(sp)
    8000516a:	795a                	ld	s2,432(sp)
    8000516c:	79ba                	ld	s3,424(sp)
    8000516e:	7a1a                	ld	s4,416(sp)
    80005170:	6afa                	ld	s5,408(sp)
    80005172:	6179                	addi	sp,sp,464
    80005174:	8082                	ret

0000000080005176 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005176:	7139                	addi	sp,sp,-64
    80005178:	fc06                	sd	ra,56(sp)
    8000517a:	f822                	sd	s0,48(sp)
    8000517c:	f426                	sd	s1,40(sp)
    8000517e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005180:	ffffc097          	auipc	ra,0xffffc
    80005184:	eae080e7          	jalr	-338(ra) # 8000102e <myproc>
    80005188:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    8000518a:	fd840593          	addi	a1,s0,-40
    8000518e:	4501                	li	a0,0
    80005190:	ffffd097          	auipc	ra,0xffffd
    80005194:	f6c080e7          	jalr	-148(ra) # 800020fc <argaddr>
    return -1;
    80005198:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    8000519a:	0e054063          	bltz	a0,8000527a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000519e:	fc840593          	addi	a1,s0,-56
    800051a2:	fd040513          	addi	a0,s0,-48
    800051a6:	fffff097          	auipc	ra,0xfffff
    800051aa:	df2080e7          	jalr	-526(ra) # 80003f98 <pipealloc>
    return -1;
    800051ae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800051b0:	0c054563          	bltz	a0,8000527a <sys_pipe+0x104>
  fd0 = -1;
    800051b4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800051b8:	fd043503          	ld	a0,-48(s0)
    800051bc:	fffff097          	auipc	ra,0xfffff
    800051c0:	508080e7          	jalr	1288(ra) # 800046c4 <fdalloc>
    800051c4:	fca42223          	sw	a0,-60(s0)
    800051c8:	08054c63          	bltz	a0,80005260 <sys_pipe+0xea>
    800051cc:	fc843503          	ld	a0,-56(s0)
    800051d0:	fffff097          	auipc	ra,0xfffff
    800051d4:	4f4080e7          	jalr	1268(ra) # 800046c4 <fdalloc>
    800051d8:	fca42023          	sw	a0,-64(s0)
    800051dc:	06054863          	bltz	a0,8000524c <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051e0:	4691                	li	a3,4
    800051e2:	fc440613          	addi	a2,s0,-60
    800051e6:	fd843583          	ld	a1,-40(s0)
    800051ea:	6ca8                	ld	a0,88(s1)
    800051ec:	ffffc097          	auipc	ra,0xffffc
    800051f0:	b04080e7          	jalr	-1276(ra) # 80000cf0 <copyout>
    800051f4:	02054063          	bltz	a0,80005214 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051f8:	4691                	li	a3,4
    800051fa:	fc040613          	addi	a2,s0,-64
    800051fe:	fd843583          	ld	a1,-40(s0)
    80005202:	0591                	addi	a1,a1,4
    80005204:	6ca8                	ld	a0,88(s1)
    80005206:	ffffc097          	auipc	ra,0xffffc
    8000520a:	aea080e7          	jalr	-1302(ra) # 80000cf0 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000520e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005210:	06055563          	bgez	a0,8000527a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005214:	fc442783          	lw	a5,-60(s0)
    80005218:	07e9                	addi	a5,a5,26
    8000521a:	078e                	slli	a5,a5,0x3
    8000521c:	97a6                	add	a5,a5,s1
    8000521e:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005222:	fc042503          	lw	a0,-64(s0)
    80005226:	0569                	addi	a0,a0,26
    80005228:	050e                	slli	a0,a0,0x3
    8000522a:	9526                	add	a0,a0,s1
    8000522c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005230:	fd043503          	ld	a0,-48(s0)
    80005234:	fffff097          	auipc	ra,0xfffff
    80005238:	a34080e7          	jalr	-1484(ra) # 80003c68 <fileclose>
    fileclose(wf);
    8000523c:	fc843503          	ld	a0,-56(s0)
    80005240:	fffff097          	auipc	ra,0xfffff
    80005244:	a28080e7          	jalr	-1496(ra) # 80003c68 <fileclose>
    return -1;
    80005248:	57fd                	li	a5,-1
    8000524a:	a805                	j	8000527a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000524c:	fc442783          	lw	a5,-60(s0)
    80005250:	0007c863          	bltz	a5,80005260 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005254:	01a78513          	addi	a0,a5,26
    80005258:	050e                	slli	a0,a0,0x3
    8000525a:	9526                	add	a0,a0,s1
    8000525c:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005260:	fd043503          	ld	a0,-48(s0)
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	a04080e7          	jalr	-1532(ra) # 80003c68 <fileclose>
    fileclose(wf);
    8000526c:	fc843503          	ld	a0,-56(s0)
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	9f8080e7          	jalr	-1544(ra) # 80003c68 <fileclose>
    return -1;
    80005278:	57fd                	li	a5,-1
}
    8000527a:	853e                	mv	a0,a5
    8000527c:	70e2                	ld	ra,56(sp)
    8000527e:	7442                	ld	s0,48(sp)
    80005280:	74a2                	ld	s1,40(sp)
    80005282:	6121                	addi	sp,sp,64
    80005284:	8082                	ret
	...

0000000080005290 <kernelvec>:
    80005290:	7111                	addi	sp,sp,-256
    80005292:	e006                	sd	ra,0(sp)
    80005294:	e40a                	sd	sp,8(sp)
    80005296:	e80e                	sd	gp,16(sp)
    80005298:	ec12                	sd	tp,24(sp)
    8000529a:	f016                	sd	t0,32(sp)
    8000529c:	f41a                	sd	t1,40(sp)
    8000529e:	f81e                	sd	t2,48(sp)
    800052a0:	fc22                	sd	s0,56(sp)
    800052a2:	e0a6                	sd	s1,64(sp)
    800052a4:	e4aa                	sd	a0,72(sp)
    800052a6:	e8ae                	sd	a1,80(sp)
    800052a8:	ecb2                	sd	a2,88(sp)
    800052aa:	f0b6                	sd	a3,96(sp)
    800052ac:	f4ba                	sd	a4,104(sp)
    800052ae:	f8be                	sd	a5,112(sp)
    800052b0:	fcc2                	sd	a6,120(sp)
    800052b2:	e146                	sd	a7,128(sp)
    800052b4:	e54a                	sd	s2,136(sp)
    800052b6:	e94e                	sd	s3,144(sp)
    800052b8:	ed52                	sd	s4,152(sp)
    800052ba:	f156                	sd	s5,160(sp)
    800052bc:	f55a                	sd	s6,168(sp)
    800052be:	f95e                	sd	s7,176(sp)
    800052c0:	fd62                	sd	s8,184(sp)
    800052c2:	e1e6                	sd	s9,192(sp)
    800052c4:	e5ea                	sd	s10,200(sp)
    800052c6:	e9ee                	sd	s11,208(sp)
    800052c8:	edf2                	sd	t3,216(sp)
    800052ca:	f1f6                	sd	t4,224(sp)
    800052cc:	f5fa                	sd	t5,232(sp)
    800052ce:	f9fe                	sd	t6,240(sp)
    800052d0:	c3dfc0ef          	jal	ra,80001f0c <kerneltrap>
    800052d4:	6082                	ld	ra,0(sp)
    800052d6:	6122                	ld	sp,8(sp)
    800052d8:	61c2                	ld	gp,16(sp)
    800052da:	7282                	ld	t0,32(sp)
    800052dc:	7322                	ld	t1,40(sp)
    800052de:	73c2                	ld	t2,48(sp)
    800052e0:	7462                	ld	s0,56(sp)
    800052e2:	6486                	ld	s1,64(sp)
    800052e4:	6526                	ld	a0,72(sp)
    800052e6:	65c6                	ld	a1,80(sp)
    800052e8:	6666                	ld	a2,88(sp)
    800052ea:	7686                	ld	a3,96(sp)
    800052ec:	7726                	ld	a4,104(sp)
    800052ee:	77c6                	ld	a5,112(sp)
    800052f0:	7866                	ld	a6,120(sp)
    800052f2:	688a                	ld	a7,128(sp)
    800052f4:	692a                	ld	s2,136(sp)
    800052f6:	69ca                	ld	s3,144(sp)
    800052f8:	6a6a                	ld	s4,152(sp)
    800052fa:	7a8a                	ld	s5,160(sp)
    800052fc:	7b2a                	ld	s6,168(sp)
    800052fe:	7bca                	ld	s7,176(sp)
    80005300:	7c6a                	ld	s8,184(sp)
    80005302:	6c8e                	ld	s9,192(sp)
    80005304:	6d2e                	ld	s10,200(sp)
    80005306:	6dce                	ld	s11,208(sp)
    80005308:	6e6e                	ld	t3,216(sp)
    8000530a:	7e8e                	ld	t4,224(sp)
    8000530c:	7f2e                	ld	t5,232(sp)
    8000530e:	7fce                	ld	t6,240(sp)
    80005310:	6111                	addi	sp,sp,256
    80005312:	10200073          	sret
    80005316:	00000013          	nop
    8000531a:	00000013          	nop
    8000531e:	0001                	nop

0000000080005320 <timervec>:
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	e10c                	sd	a1,0(a0)
    80005326:	e510                	sd	a2,8(a0)
    80005328:	e914                	sd	a3,16(a0)
    8000532a:	6d0c                	ld	a1,24(a0)
    8000532c:	7110                	ld	a2,32(a0)
    8000532e:	6194                	ld	a3,0(a1)
    80005330:	96b2                	add	a3,a3,a2
    80005332:	e194                	sd	a3,0(a1)
    80005334:	4589                	li	a1,2
    80005336:	14459073          	csrw	sip,a1
    8000533a:	6914                	ld	a3,16(a0)
    8000533c:	6510                	ld	a2,8(a0)
    8000533e:	610c                	ld	a1,0(a0)
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	30200073          	mret
	...

000000008000534a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000534a:	1141                	addi	sp,sp,-16
    8000534c:	e422                	sd	s0,8(sp)
    8000534e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005350:	0c0007b7          	lui	a5,0xc000
    80005354:	4705                	li	a4,1
    80005356:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005358:	c3d8                	sw	a4,4(a5)
}
    8000535a:	6422                	ld	s0,8(sp)
    8000535c:	0141                	addi	sp,sp,16
    8000535e:	8082                	ret

0000000080005360 <plicinithart>:

void
plicinithart(void)
{
    80005360:	1141                	addi	sp,sp,-16
    80005362:	e406                	sd	ra,8(sp)
    80005364:	e022                	sd	s0,0(sp)
    80005366:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	c9a080e7          	jalr	-870(ra) # 80001002 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005370:	0085171b          	slliw	a4,a0,0x8
    80005374:	0c0027b7          	lui	a5,0xc002
    80005378:	97ba                	add	a5,a5,a4
    8000537a:	40200713          	li	a4,1026
    8000537e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005382:	00d5151b          	slliw	a0,a0,0xd
    80005386:	0c2017b7          	lui	a5,0xc201
    8000538a:	953e                	add	a0,a0,a5
    8000538c:	00052023          	sw	zero,0(a0)
}
    80005390:	60a2                	ld	ra,8(sp)
    80005392:	6402                	ld	s0,0(sp)
    80005394:	0141                	addi	sp,sp,16
    80005396:	8082                	ret

0000000080005398 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005398:	1141                	addi	sp,sp,-16
    8000539a:	e406                	sd	ra,8(sp)
    8000539c:	e022                	sd	s0,0(sp)
    8000539e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053a0:	ffffc097          	auipc	ra,0xffffc
    800053a4:	c62080e7          	jalr	-926(ra) # 80001002 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053a8:	00d5179b          	slliw	a5,a0,0xd
    800053ac:	0c201537          	lui	a0,0xc201
    800053b0:	953e                	add	a0,a0,a5
  return irq;
}
    800053b2:	4148                	lw	a0,4(a0)
    800053b4:	60a2                	ld	ra,8(sp)
    800053b6:	6402                	ld	s0,0(sp)
    800053b8:	0141                	addi	sp,sp,16
    800053ba:	8082                	ret

00000000800053bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053bc:	1101                	addi	sp,sp,-32
    800053be:	ec06                	sd	ra,24(sp)
    800053c0:	e822                	sd	s0,16(sp)
    800053c2:	e426                	sd	s1,8(sp)
    800053c4:	1000                	addi	s0,sp,32
    800053c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053c8:	ffffc097          	auipc	ra,0xffffc
    800053cc:	c3a080e7          	jalr	-966(ra) # 80001002 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053d0:	00d5151b          	slliw	a0,a0,0xd
    800053d4:	0c2017b7          	lui	a5,0xc201
    800053d8:	97aa                	add	a5,a5,a0
    800053da:	c3c4                	sw	s1,4(a5)
}
    800053dc:	60e2                	ld	ra,24(sp)
    800053de:	6442                	ld	s0,16(sp)
    800053e0:	64a2                	ld	s1,8(sp)
    800053e2:	6105                	addi	sp,sp,32
    800053e4:	8082                	ret

00000000800053e6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053e6:	1141                	addi	sp,sp,-16
    800053e8:	e406                	sd	ra,8(sp)
    800053ea:	e022                	sd	s0,0(sp)
    800053ec:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ee:	479d                	li	a5,7
    800053f0:	06a7c963          	blt	a5,a0,80005462 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    800053f4:	00019797          	auipc	a5,0x19
    800053f8:	c0c78793          	addi	a5,a5,-1012 # 8001e000 <disk>
    800053fc:	00a78733          	add	a4,a5,a0
    80005400:	6789                	lui	a5,0x2
    80005402:	97ba                	add	a5,a5,a4
    80005404:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005408:	e7ad                	bnez	a5,80005472 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000540a:	00451793          	slli	a5,a0,0x4
    8000540e:	0001b717          	auipc	a4,0x1b
    80005412:	bf270713          	addi	a4,a4,-1038 # 80020000 <disk+0x2000>
    80005416:	6314                	ld	a3,0(a4)
    80005418:	96be                	add	a3,a3,a5
    8000541a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    8000541e:	6314                	ld	a3,0(a4)
    80005420:	96be                	add	a3,a3,a5
    80005422:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005426:	6314                	ld	a3,0(a4)
    80005428:	96be                	add	a3,a3,a5
    8000542a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    8000542e:	6318                	ld	a4,0(a4)
    80005430:	97ba                	add	a5,a5,a4
    80005432:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005436:	00019797          	auipc	a5,0x19
    8000543a:	bca78793          	addi	a5,a5,-1078 # 8001e000 <disk>
    8000543e:	97aa                	add	a5,a5,a0
    80005440:	6509                	lui	a0,0x2
    80005442:	953e                	add	a0,a0,a5
    80005444:	4785                	li	a5,1
    80005446:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000544a:	0001b517          	auipc	a0,0x1b
    8000544e:	bce50513          	addi	a0,a0,-1074 # 80020018 <disk+0x2018>
    80005452:	ffffc097          	auipc	ra,0xffffc
    80005456:	424080e7          	jalr	1060(ra) # 80001876 <wakeup>
}
    8000545a:	60a2                	ld	ra,8(sp)
    8000545c:	6402                	ld	s0,0(sp)
    8000545e:	0141                	addi	sp,sp,16
    80005460:	8082                	ret
    panic("free_desc 1");
    80005462:	00003517          	auipc	a0,0x3
    80005466:	28650513          	addi	a0,a0,646 # 800086e8 <syscalls+0x320>
    8000546a:	00001097          	auipc	ra,0x1
    8000546e:	d52080e7          	jalr	-686(ra) # 800061bc <panic>
    panic("free_desc 2");
    80005472:	00003517          	auipc	a0,0x3
    80005476:	28650513          	addi	a0,a0,646 # 800086f8 <syscalls+0x330>
    8000547a:	00001097          	auipc	ra,0x1
    8000547e:	d42080e7          	jalr	-702(ra) # 800061bc <panic>

0000000080005482 <virtio_disk_init>:
{
    80005482:	1101                	addi	sp,sp,-32
    80005484:	ec06                	sd	ra,24(sp)
    80005486:	e822                	sd	s0,16(sp)
    80005488:	e426                	sd	s1,8(sp)
    8000548a:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000548c:	00003597          	auipc	a1,0x3
    80005490:	27c58593          	addi	a1,a1,636 # 80008708 <syscalls+0x340>
    80005494:	0001b517          	auipc	a0,0x1b
    80005498:	c9450513          	addi	a0,a0,-876 # 80020128 <disk+0x2128>
    8000549c:	00001097          	auipc	ra,0x1
    800054a0:	3d0080e7          	jalr	976(ra) # 8000686c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054a4:	100017b7          	lui	a5,0x10001
    800054a8:	4398                	lw	a4,0(a5)
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	747277b7          	lui	a5,0x74727
    800054b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054b4:	0ef71163          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054b8:	100017b7          	lui	a5,0x10001
    800054bc:	43dc                	lw	a5,4(a5)
    800054be:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c0:	4705                	li	a4,1
    800054c2:	0ce79a63          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054c6:	100017b7          	lui	a5,0x10001
    800054ca:	479c                	lw	a5,8(a5)
    800054cc:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800054ce:	4709                	li	a4,2
    800054d0:	0ce79363          	bne	a5,a4,80005596 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054d4:	100017b7          	lui	a5,0x10001
    800054d8:	47d8                	lw	a4,12(a5)
    800054da:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054dc:	554d47b7          	lui	a5,0x554d4
    800054e0:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054e4:	0af71963          	bne	a4,a5,80005596 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054e8:	100017b7          	lui	a5,0x10001
    800054ec:	4705                	li	a4,1
    800054ee:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f0:	470d                	li	a4,3
    800054f2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054f4:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054f6:	c7ffe737          	lui	a4,0xc7ffe
    800054fa:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd3517>
    800054fe:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005500:	2701                	sext.w	a4,a4
    80005502:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005504:	472d                	li	a4,11
    80005506:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005508:	473d                	li	a4,15
    8000550a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    8000550c:	6705                	lui	a4,0x1
    8000550e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005510:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005514:	5bdc                	lw	a5,52(a5)
    80005516:	2781                	sext.w	a5,a5
  if(max == 0)
    80005518:	c7d9                	beqz	a5,800055a6 <virtio_disk_init+0x124>
  if(max < NUM)
    8000551a:	471d                	li	a4,7
    8000551c:	08f77d63          	bgeu	a4,a5,800055b6 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005520:	100014b7          	lui	s1,0x10001
    80005524:	47a1                	li	a5,8
    80005526:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005528:	6609                	lui	a2,0x2
    8000552a:	4581                	li	a1,0
    8000552c:	00019517          	auipc	a0,0x19
    80005530:	ad450513          	addi	a0,a0,-1324 # 8001e000 <disk>
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	e1a080e7          	jalr	-486(ra) # 8000034e <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    8000553c:	00019717          	auipc	a4,0x19
    80005540:	ac470713          	addi	a4,a4,-1340 # 8001e000 <disk>
    80005544:	00c75793          	srli	a5,a4,0xc
    80005548:	2781                	sext.w	a5,a5
    8000554a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000554c:	0001b797          	auipc	a5,0x1b
    80005550:	ab478793          	addi	a5,a5,-1356 # 80020000 <disk+0x2000>
    80005554:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005556:	00019717          	auipc	a4,0x19
    8000555a:	b2a70713          	addi	a4,a4,-1238 # 8001e080 <disk+0x80>
    8000555e:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005560:	0001a717          	auipc	a4,0x1a
    80005564:	aa070713          	addi	a4,a4,-1376 # 8001f000 <disk+0x1000>
    80005568:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    8000556a:	4705                	li	a4,1
    8000556c:	00e78c23          	sb	a4,24(a5)
    80005570:	00e78ca3          	sb	a4,25(a5)
    80005574:	00e78d23          	sb	a4,26(a5)
    80005578:	00e78da3          	sb	a4,27(a5)
    8000557c:	00e78e23          	sb	a4,28(a5)
    80005580:	00e78ea3          	sb	a4,29(a5)
    80005584:	00e78f23          	sb	a4,30(a5)
    80005588:	00e78fa3          	sb	a4,31(a5)
}
    8000558c:	60e2                	ld	ra,24(sp)
    8000558e:	6442                	ld	s0,16(sp)
    80005590:	64a2                	ld	s1,8(sp)
    80005592:	6105                	addi	sp,sp,32
    80005594:	8082                	ret
    panic("could not find virtio disk");
    80005596:	00003517          	auipc	a0,0x3
    8000559a:	18250513          	addi	a0,a0,386 # 80008718 <syscalls+0x350>
    8000559e:	00001097          	auipc	ra,0x1
    800055a2:	c1e080e7          	jalr	-994(ra) # 800061bc <panic>
    panic("virtio disk has no queue 0");
    800055a6:	00003517          	auipc	a0,0x3
    800055aa:	19250513          	addi	a0,a0,402 # 80008738 <syscalls+0x370>
    800055ae:	00001097          	auipc	ra,0x1
    800055b2:	c0e080e7          	jalr	-1010(ra) # 800061bc <panic>
    panic("virtio disk max queue too short");
    800055b6:	00003517          	auipc	a0,0x3
    800055ba:	1a250513          	addi	a0,a0,418 # 80008758 <syscalls+0x390>
    800055be:	00001097          	auipc	ra,0x1
    800055c2:	bfe080e7          	jalr	-1026(ra) # 800061bc <panic>

00000000800055c6 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055c6:	7159                	addi	sp,sp,-112
    800055c8:	f486                	sd	ra,104(sp)
    800055ca:	f0a2                	sd	s0,96(sp)
    800055cc:	eca6                	sd	s1,88(sp)
    800055ce:	e8ca                	sd	s2,80(sp)
    800055d0:	e4ce                	sd	s3,72(sp)
    800055d2:	e0d2                	sd	s4,64(sp)
    800055d4:	fc56                	sd	s5,56(sp)
    800055d6:	f85a                	sd	s6,48(sp)
    800055d8:	f45e                	sd	s7,40(sp)
    800055da:	f062                	sd	s8,32(sp)
    800055dc:	ec66                	sd	s9,24(sp)
    800055de:	e86a                	sd	s10,16(sp)
    800055e0:	1880                	addi	s0,sp,112
    800055e2:	892a                	mv	s2,a0
    800055e4:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800055e6:	00c52c83          	lw	s9,12(a0)
    800055ea:	001c9c9b          	slliw	s9,s9,0x1
    800055ee:	1c82                	slli	s9,s9,0x20
    800055f0:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800055f4:	0001b517          	auipc	a0,0x1b
    800055f8:	b3450513          	addi	a0,a0,-1228 # 80020128 <disk+0x2128>
    800055fc:	00001097          	auipc	ra,0x1
    80005600:	0f4080e7          	jalr	244(ra) # 800066f0 <acquire>
  for(int i = 0; i < 3; i++){
    80005604:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005606:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005608:	00019b97          	auipc	s7,0x19
    8000560c:	9f8b8b93          	addi	s7,s7,-1544 # 8001e000 <disk>
    80005610:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005612:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005614:	8a4e                	mv	s4,s3
    80005616:	a051                	j	8000569a <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005618:	00fb86b3          	add	a3,s7,a5
    8000561c:	96da                	add	a3,a3,s6
    8000561e:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005622:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005624:	0207c563          	bltz	a5,8000564e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005628:	2485                	addiw	s1,s1,1
    8000562a:	0711                	addi	a4,a4,4
    8000562c:	25548063          	beq	s1,s5,8000586c <virtio_disk_rw+0x2a6>
    idx[i] = alloc_desc();
    80005630:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005632:	0001b697          	auipc	a3,0x1b
    80005636:	9e668693          	addi	a3,a3,-1562 # 80020018 <disk+0x2018>
    8000563a:	87d2                	mv	a5,s4
    if(disk.free[i]){
    8000563c:	0006c583          	lbu	a1,0(a3)
    80005640:	fde1                	bnez	a1,80005618 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005642:	2785                	addiw	a5,a5,1
    80005644:	0685                	addi	a3,a3,1
    80005646:	ff879be3          	bne	a5,s8,8000563c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000564a:	57fd                	li	a5,-1
    8000564c:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    8000564e:	02905a63          	blez	s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005652:	f9042503          	lw	a0,-112(s0)
    80005656:	00000097          	auipc	ra,0x0
    8000565a:	d90080e7          	jalr	-624(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    8000565e:	4785                	li	a5,1
    80005660:	0297d163          	bge	a5,s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005664:	f9442503          	lw	a0,-108(s0)
    80005668:	00000097          	auipc	ra,0x0
    8000566c:	d7e080e7          	jalr	-642(ra) # 800053e6 <free_desc>
      for(int j = 0; j < i; j++)
    80005670:	4789                	li	a5,2
    80005672:	0097d863          	bge	a5,s1,80005682 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005676:	f9842503          	lw	a0,-104(s0)
    8000567a:	00000097          	auipc	ra,0x0
    8000567e:	d6c080e7          	jalr	-660(ra) # 800053e6 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005682:	0001b597          	auipc	a1,0x1b
    80005686:	aa658593          	addi	a1,a1,-1370 # 80020128 <disk+0x2128>
    8000568a:	0001b517          	auipc	a0,0x1b
    8000568e:	98e50513          	addi	a0,a0,-1650 # 80020018 <disk+0x2018>
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	058080e7          	jalr	88(ra) # 800016ea <sleep>
  for(int i = 0; i < 3; i++){
    8000569a:	f9040713          	addi	a4,s0,-112
    8000569e:	84ce                	mv	s1,s3
    800056a0:	bf41                	j	80005630 <virtio_disk_rw+0x6a>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056a2:	20058713          	addi	a4,a1,512
    800056a6:	00471693          	slli	a3,a4,0x4
    800056aa:	00019717          	auipc	a4,0x19
    800056ae:	95670713          	addi	a4,a4,-1706 # 8001e000 <disk>
    800056b2:	9736                	add	a4,a4,a3
    800056b4:	4685                	li	a3,1
    800056b6:	0ad72423          	sw	a3,168(a4)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056ba:	20058713          	addi	a4,a1,512
    800056be:	00471693          	slli	a3,a4,0x4
    800056c2:	00019717          	auipc	a4,0x19
    800056c6:	93e70713          	addi	a4,a4,-1730 # 8001e000 <disk>
    800056ca:	9736                	add	a4,a4,a3
    800056cc:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800056d0:	0b973823          	sd	s9,176(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056d4:	7679                	lui	a2,0xffffe
    800056d6:	963e                	add	a2,a2,a5
    800056d8:	0001b697          	auipc	a3,0x1b
    800056dc:	92868693          	addi	a3,a3,-1752 # 80020000 <disk+0x2000>
    800056e0:	6298                	ld	a4,0(a3)
    800056e2:	9732                	add	a4,a4,a2
    800056e4:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056e6:	6298                	ld	a4,0(a3)
    800056e8:	9732                	add	a4,a4,a2
    800056ea:	4541                	li	a0,16
    800056ec:	c708                	sw	a0,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056ee:	6298                	ld	a4,0(a3)
    800056f0:	9732                	add	a4,a4,a2
    800056f2:	4505                	li	a0,1
    800056f4:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800056f8:	f9442703          	lw	a4,-108(s0)
    800056fc:	6288                	ld	a0,0(a3)
    800056fe:	962a                	add	a2,a2,a0
    80005700:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd2dc6>

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005704:	0712                	slli	a4,a4,0x4
    80005706:	6290                	ld	a2,0(a3)
    80005708:	963a                	add	a2,a2,a4
    8000570a:	06090513          	addi	a0,s2,96
    8000570e:	e208                	sd	a0,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005710:	6294                	ld	a3,0(a3)
    80005712:	96ba                	add	a3,a3,a4
    80005714:	40000613          	li	a2,1024
    80005718:	c690                	sw	a2,8(a3)
  if(write)
    8000571a:	140d0063          	beqz	s10,8000585a <virtio_disk_rw+0x294>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    8000571e:	0001b697          	auipc	a3,0x1b
    80005722:	8e26b683          	ld	a3,-1822(a3) # 80020000 <disk+0x2000>
    80005726:	96ba                	add	a3,a3,a4
    80005728:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000572c:	00019817          	auipc	a6,0x19
    80005730:	8d480813          	addi	a6,a6,-1836 # 8001e000 <disk>
    80005734:	0001b517          	auipc	a0,0x1b
    80005738:	8cc50513          	addi	a0,a0,-1844 # 80020000 <disk+0x2000>
    8000573c:	6114                	ld	a3,0(a0)
    8000573e:	96ba                	add	a3,a3,a4
    80005740:	00c6d603          	lhu	a2,12(a3)
    80005744:	00166613          	ori	a2,a2,1
    80005748:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000574c:	f9842683          	lw	a3,-104(s0)
    80005750:	6110                	ld	a2,0(a0)
    80005752:	9732                	add	a4,a4,a2
    80005754:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005758:	20058613          	addi	a2,a1,512
    8000575c:	0612                	slli	a2,a2,0x4
    8000575e:	9642                	add	a2,a2,a6
    80005760:	577d                	li	a4,-1
    80005762:	02e60823          	sb	a4,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005766:	00469713          	slli	a4,a3,0x4
    8000576a:	6114                	ld	a3,0(a0)
    8000576c:	96ba                	add	a3,a3,a4
    8000576e:	03078793          	addi	a5,a5,48
    80005772:	97c2                	add	a5,a5,a6
    80005774:	e29c                	sd	a5,0(a3)
  disk.desc[idx[2]].len = 1;
    80005776:	611c                	ld	a5,0(a0)
    80005778:	97ba                	add	a5,a5,a4
    8000577a:	4685                	li	a3,1
    8000577c:	c794                	sw	a3,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000577e:	611c                	ld	a5,0(a0)
    80005780:	97ba                	add	a5,a5,a4
    80005782:	4809                	li	a6,2
    80005784:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80005788:	611c                	ld	a5,0(a0)
    8000578a:	973e                	add	a4,a4,a5
    8000578c:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005790:	00d92223          	sw	a3,4(s2)
  disk.info[idx[0]].b = b;
    80005794:	03263423          	sd	s2,40(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005798:	6518                	ld	a4,8(a0)
    8000579a:	00275783          	lhu	a5,2(a4)
    8000579e:	8b9d                	andi	a5,a5,7
    800057a0:	0786                	slli	a5,a5,0x1
    800057a2:	97ba                	add	a5,a5,a4
    800057a4:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    800057a8:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ac:	6518                	ld	a4,8(a0)
    800057ae:	00275783          	lhu	a5,2(a4)
    800057b2:	2785                	addiw	a5,a5,1
    800057b4:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057b8:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057bc:	100017b7          	lui	a5,0x10001
    800057c0:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057c4:	00492703          	lw	a4,4(s2)
    800057c8:	4785                	li	a5,1
    800057ca:	02f71163          	bne	a4,a5,800057ec <virtio_disk_rw+0x226>
    sleep(b, &disk.vdisk_lock);
    800057ce:	0001b997          	auipc	s3,0x1b
    800057d2:	95a98993          	addi	s3,s3,-1702 # 80020128 <disk+0x2128>
  while(b->disk == 1) {
    800057d6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057d8:	85ce                	mv	a1,s3
    800057da:	854a                	mv	a0,s2
    800057dc:	ffffc097          	auipc	ra,0xffffc
    800057e0:	f0e080e7          	jalr	-242(ra) # 800016ea <sleep>
  while(b->disk == 1) {
    800057e4:	00492783          	lw	a5,4(s2)
    800057e8:	fe9788e3          	beq	a5,s1,800057d8 <virtio_disk_rw+0x212>
  }

  disk.info[idx[0]].b = 0;
    800057ec:	f9042903          	lw	s2,-112(s0)
    800057f0:	20090793          	addi	a5,s2,512
    800057f4:	00479713          	slli	a4,a5,0x4
    800057f8:	00019797          	auipc	a5,0x19
    800057fc:	80878793          	addi	a5,a5,-2040 # 8001e000 <disk>
    80005800:	97ba                	add	a5,a5,a4
    80005802:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005806:	0001a997          	auipc	s3,0x1a
    8000580a:	7fa98993          	addi	s3,s3,2042 # 80020000 <disk+0x2000>
    8000580e:	00491713          	slli	a4,s2,0x4
    80005812:	0009b783          	ld	a5,0(s3)
    80005816:	97ba                	add	a5,a5,a4
    80005818:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000581c:	854a                	mv	a0,s2
    8000581e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005822:	00000097          	auipc	ra,0x0
    80005826:	bc4080e7          	jalr	-1084(ra) # 800053e6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000582a:	8885                	andi	s1,s1,1
    8000582c:	f0ed                	bnez	s1,8000580e <virtio_disk_rw+0x248>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000582e:	0001b517          	auipc	a0,0x1b
    80005832:	8fa50513          	addi	a0,a0,-1798 # 80020128 <disk+0x2128>
    80005836:	00001097          	auipc	ra,0x1
    8000583a:	f8a080e7          	jalr	-118(ra) # 800067c0 <release>
}
    8000583e:	70a6                	ld	ra,104(sp)
    80005840:	7406                	ld	s0,96(sp)
    80005842:	64e6                	ld	s1,88(sp)
    80005844:	6946                	ld	s2,80(sp)
    80005846:	69a6                	ld	s3,72(sp)
    80005848:	6a06                	ld	s4,64(sp)
    8000584a:	7ae2                	ld	s5,56(sp)
    8000584c:	7b42                	ld	s6,48(sp)
    8000584e:	7ba2                	ld	s7,40(sp)
    80005850:	7c02                	ld	s8,32(sp)
    80005852:	6ce2                	ld	s9,24(sp)
    80005854:	6d42                	ld	s10,16(sp)
    80005856:	6165                	addi	sp,sp,112
    80005858:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000585a:	0001a697          	auipc	a3,0x1a
    8000585e:	7a66b683          	ld	a3,1958(a3) # 80020000 <disk+0x2000>
    80005862:	96ba                	add	a3,a3,a4
    80005864:	4609                	li	a2,2
    80005866:	00c69623          	sh	a2,12(a3)
    8000586a:	b5c9                	j	8000572c <virtio_disk_rw+0x166>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000586c:	f9042583          	lw	a1,-112(s0)
    80005870:	20058793          	addi	a5,a1,512
    80005874:	0792                	slli	a5,a5,0x4
    80005876:	00019517          	auipc	a0,0x19
    8000587a:	83250513          	addi	a0,a0,-1998 # 8001e0a8 <disk+0xa8>
    8000587e:	953e                	add	a0,a0,a5
  if(write)
    80005880:	e20d11e3          	bnez	s10,800056a2 <virtio_disk_rw+0xdc>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005884:	20058713          	addi	a4,a1,512
    80005888:	00471693          	slli	a3,a4,0x4
    8000588c:	00018717          	auipc	a4,0x18
    80005890:	77470713          	addi	a4,a4,1908 # 8001e000 <disk>
    80005894:	9736                	add	a4,a4,a3
    80005896:	0a072423          	sw	zero,168(a4)
    8000589a:	b505                	j	800056ba <virtio_disk_rw+0xf4>

000000008000589c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000589c:	1101                	addi	sp,sp,-32
    8000589e:	ec06                	sd	ra,24(sp)
    800058a0:	e822                	sd	s0,16(sp)
    800058a2:	e426                	sd	s1,8(sp)
    800058a4:	e04a                	sd	s2,0(sp)
    800058a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058a8:	0001b517          	auipc	a0,0x1b
    800058ac:	88050513          	addi	a0,a0,-1920 # 80020128 <disk+0x2128>
    800058b0:	00001097          	auipc	ra,0x1
    800058b4:	e40080e7          	jalr	-448(ra) # 800066f0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058b8:	10001737          	lui	a4,0x10001
    800058bc:	533c                	lw	a5,96(a4)
    800058be:	8b8d                	andi	a5,a5,3
    800058c0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058c2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058c6:	0001a797          	auipc	a5,0x1a
    800058ca:	73a78793          	addi	a5,a5,1850 # 80020000 <disk+0x2000>
    800058ce:	6b94                	ld	a3,16(a5)
    800058d0:	0207d703          	lhu	a4,32(a5)
    800058d4:	0026d783          	lhu	a5,2(a3)
    800058d8:	06f70163          	beq	a4,a5,8000593a <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058dc:	00018917          	auipc	s2,0x18
    800058e0:	72490913          	addi	s2,s2,1828 # 8001e000 <disk>
    800058e4:	0001a497          	auipc	s1,0x1a
    800058e8:	71c48493          	addi	s1,s1,1820 # 80020000 <disk+0x2000>
    __sync_synchronize();
    800058ec:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058f0:	6898                	ld	a4,16(s1)
    800058f2:	0204d783          	lhu	a5,32(s1)
    800058f6:	8b9d                	andi	a5,a5,7
    800058f8:	078e                	slli	a5,a5,0x3
    800058fa:	97ba                	add	a5,a5,a4
    800058fc:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058fe:	20078713          	addi	a4,a5,512
    80005902:	0712                	slli	a4,a4,0x4
    80005904:	974a                	add	a4,a4,s2
    80005906:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000590a:	e731                	bnez	a4,80005956 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000590c:	20078793          	addi	a5,a5,512
    80005910:	0792                	slli	a5,a5,0x4
    80005912:	97ca                	add	a5,a5,s2
    80005914:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005916:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000591a:	ffffc097          	auipc	ra,0xffffc
    8000591e:	f5c080e7          	jalr	-164(ra) # 80001876 <wakeup>

    disk.used_idx += 1;
    80005922:	0204d783          	lhu	a5,32(s1)
    80005926:	2785                	addiw	a5,a5,1
    80005928:	17c2                	slli	a5,a5,0x30
    8000592a:	93c1                	srli	a5,a5,0x30
    8000592c:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005930:	6898                	ld	a4,16(s1)
    80005932:	00275703          	lhu	a4,2(a4)
    80005936:	faf71be3          	bne	a4,a5,800058ec <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000593a:	0001a517          	auipc	a0,0x1a
    8000593e:	7ee50513          	addi	a0,a0,2030 # 80020128 <disk+0x2128>
    80005942:	00001097          	auipc	ra,0x1
    80005946:	e7e080e7          	jalr	-386(ra) # 800067c0 <release>
}
    8000594a:	60e2                	ld	ra,24(sp)
    8000594c:	6442                	ld	s0,16(sp)
    8000594e:	64a2                	ld	s1,8(sp)
    80005950:	6902                	ld	s2,0(sp)
    80005952:	6105                	addi	sp,sp,32
    80005954:	8082                	ret
      panic("virtio_disk_intr status");
    80005956:	00003517          	auipc	a0,0x3
    8000595a:	e2250513          	addi	a0,a0,-478 # 80008778 <syscalls+0x3b0>
    8000595e:	00001097          	auipc	ra,0x1
    80005962:	85e080e7          	jalr	-1954(ra) # 800061bc <panic>

0000000080005966 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80005966:	1141                	addi	sp,sp,-16
    80005968:	e422                	sd	s0,8(sp)
    8000596a:	0800                	addi	s0,sp,16
  return -1;
}
    8000596c:	557d                	li	a0,-1
    8000596e:	6422                	ld	s0,8(sp)
    80005970:	0141                	addi	sp,sp,16
    80005972:	8082                	ret

0000000080005974 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80005974:	7179                	addi	sp,sp,-48
    80005976:	f406                	sd	ra,40(sp)
    80005978:	f022                	sd	s0,32(sp)
    8000597a:	ec26                	sd	s1,24(sp)
    8000597c:	e84a                	sd	s2,16(sp)
    8000597e:	e44e                	sd	s3,8(sp)
    80005980:	e052                	sd	s4,0(sp)
    80005982:	1800                	addi	s0,sp,48
    80005984:	892a                	mv	s2,a0
    80005986:	89ae                	mv	s3,a1
    80005988:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    8000598a:	0001b517          	auipc	a0,0x1b
    8000598e:	67650513          	addi	a0,a0,1654 # 80021000 <stats>
    80005992:	00001097          	auipc	ra,0x1
    80005996:	d5e080e7          	jalr	-674(ra) # 800066f0 <acquire>

  if(stats.sz == 0) {
    8000599a:	0001c797          	auipc	a5,0x1c
    8000599e:	6867a783          	lw	a5,1670(a5) # 80022020 <stats+0x1020>
    800059a2:	cbb5                	beqz	a5,80005a16 <statsread+0xa2>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    800059a4:	0001c797          	auipc	a5,0x1c
    800059a8:	65c78793          	addi	a5,a5,1628 # 80022000 <stats+0x1000>
    800059ac:	53d8                	lw	a4,36(a5)
    800059ae:	539c                	lw	a5,32(a5)
    800059b0:	9f99                	subw	a5,a5,a4
    800059b2:	0007869b          	sext.w	a3,a5

  if (m > 0) {
    800059b6:	06d05e63          	blez	a3,80005a32 <statsread+0xbe>
    if(m > n)
    800059ba:	8a3e                	mv	s4,a5
    800059bc:	00d4d363          	bge	s1,a3,800059c2 <statsread+0x4e>
    800059c0:	8a26                	mv	s4,s1
    800059c2:	000a049b          	sext.w	s1,s4
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    800059c6:	86a6                	mv	a3,s1
    800059c8:	0001b617          	auipc	a2,0x1b
    800059cc:	65860613          	addi	a2,a2,1624 # 80021020 <stats+0x20>
    800059d0:	963a                	add	a2,a2,a4
    800059d2:	85ce                	mv	a1,s3
    800059d4:	854a                	mv	a0,s2
    800059d6:	ffffc097          	auipc	ra,0xffffc
    800059da:	0b8080e7          	jalr	184(ra) # 80001a8e <either_copyout>
    800059de:	57fd                	li	a5,-1
    800059e0:	00f50a63          	beq	a0,a5,800059f4 <statsread+0x80>
      stats.off += m;
    800059e4:	0001c717          	auipc	a4,0x1c
    800059e8:	61c70713          	addi	a4,a4,1564 # 80022000 <stats+0x1000>
    800059ec:	535c                	lw	a5,36(a4)
    800059ee:	014787bb          	addw	a5,a5,s4
    800059f2:	d35c                	sw	a5,36(a4)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    800059f4:	0001b517          	auipc	a0,0x1b
    800059f8:	60c50513          	addi	a0,a0,1548 # 80021000 <stats>
    800059fc:	00001097          	auipc	ra,0x1
    80005a00:	dc4080e7          	jalr	-572(ra) # 800067c0 <release>
  return m;
}
    80005a04:	8526                	mv	a0,s1
    80005a06:	70a2                	ld	ra,40(sp)
    80005a08:	7402                	ld	s0,32(sp)
    80005a0a:	64e2                	ld	s1,24(sp)
    80005a0c:	6942                	ld	s2,16(sp)
    80005a0e:	69a2                	ld	s3,8(sp)
    80005a10:	6a02                	ld	s4,0(sp)
    80005a12:	6145                	addi	sp,sp,48
    80005a14:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    80005a16:	6585                	lui	a1,0x1
    80005a18:	0001b517          	auipc	a0,0x1b
    80005a1c:	60850513          	addi	a0,a0,1544 # 80021020 <stats+0x20>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	f28080e7          	jalr	-216(ra) # 80006948 <statslock>
    80005a28:	0001c797          	auipc	a5,0x1c
    80005a2c:	5ea7ac23          	sw	a0,1528(a5) # 80022020 <stats+0x1020>
    80005a30:	bf95                	j	800059a4 <statsread+0x30>
    stats.sz = 0;
    80005a32:	0001c797          	auipc	a5,0x1c
    80005a36:	5ce78793          	addi	a5,a5,1486 # 80022000 <stats+0x1000>
    80005a3a:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005a3e:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005a42:	54fd                	li	s1,-1
    80005a44:	bf45                	j	800059f4 <statsread+0x80>

0000000080005a46 <statsinit>:

void
statsinit(void)
{
    80005a46:	1141                	addi	sp,sp,-16
    80005a48:	e406                	sd	ra,8(sp)
    80005a4a:	e022                	sd	s0,0(sp)
    80005a4c:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005a4e:	00003597          	auipc	a1,0x3
    80005a52:	d4258593          	addi	a1,a1,-702 # 80008790 <syscalls+0x3c8>
    80005a56:	0001b517          	auipc	a0,0x1b
    80005a5a:	5aa50513          	addi	a0,a0,1450 # 80021000 <stats>
    80005a5e:	00001097          	auipc	ra,0x1
    80005a62:	e0e080e7          	jalr	-498(ra) # 8000686c <initlock>

  devsw[STATS].read = statsread;
    80005a66:	00017797          	auipc	a5,0x17
    80005a6a:	39278793          	addi	a5,a5,914 # 8001cdf8 <devsw>
    80005a6e:	00000717          	auipc	a4,0x0
    80005a72:	f0670713          	addi	a4,a4,-250 # 80005974 <statsread>
    80005a76:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    80005a78:	00000717          	auipc	a4,0x0
    80005a7c:	eee70713          	addi	a4,a4,-274 # 80005966 <statswrite>
    80005a80:	f798                	sd	a4,40(a5)
}
    80005a82:	60a2                	ld	ra,8(sp)
    80005a84:	6402                	ld	s0,0(sp)
    80005a86:	0141                	addi	sp,sp,16
    80005a88:	8082                	ret

0000000080005a8a <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    80005a8a:	1101                	addi	sp,sp,-32
    80005a8c:	ec22                	sd	s0,24(sp)
    80005a8e:	1000                	addi	s0,sp,32
    80005a90:	882a                	mv	a6,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    80005a92:	c299                	beqz	a3,80005a98 <sprintint+0xe>
    80005a94:	0805c163          	bltz	a1,80005b16 <sprintint+0x8c>
    x = -xx;
  else
    x = xx;
    80005a98:	2581                	sext.w	a1,a1
    80005a9a:	4301                	li	t1,0

  i = 0;
    80005a9c:	fe040713          	addi	a4,s0,-32
    80005aa0:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    80005aa2:	2601                	sext.w	a2,a2
    80005aa4:	00003697          	auipc	a3,0x3
    80005aa8:	d0c68693          	addi	a3,a3,-756 # 800087b0 <digits>
    80005aac:	88aa                	mv	a7,a0
    80005aae:	2505                	addiw	a0,a0,1
    80005ab0:	02c5f7bb          	remuw	a5,a1,a2
    80005ab4:	1782                	slli	a5,a5,0x20
    80005ab6:	9381                	srli	a5,a5,0x20
    80005ab8:	97b6                	add	a5,a5,a3
    80005aba:	0007c783          	lbu	a5,0(a5)
    80005abe:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005ac2:	0005879b          	sext.w	a5,a1
    80005ac6:	02c5d5bb          	divuw	a1,a1,a2
    80005aca:	0705                	addi	a4,a4,1
    80005acc:	fec7f0e3          	bgeu	a5,a2,80005aac <sprintint+0x22>

  if(sign)
    80005ad0:	00030b63          	beqz	t1,80005ae6 <sprintint+0x5c>
    buf[i++] = '-';
    80005ad4:	ff040793          	addi	a5,s0,-16
    80005ad8:	97aa                	add	a5,a5,a0
    80005ada:	02d00713          	li	a4,45
    80005ade:	fee78823          	sb	a4,-16(a5)
    80005ae2:	0028851b          	addiw	a0,a7,2

  n = 0;
  while(--i >= 0)
    80005ae6:	02a05c63          	blez	a0,80005b1e <sprintint+0x94>
    80005aea:	fe040793          	addi	a5,s0,-32
    80005aee:	00a78733          	add	a4,a5,a0
    80005af2:	87c2                	mv	a5,a6
    80005af4:	0805                	addi	a6,a6,1
    80005af6:	fff5061b          	addiw	a2,a0,-1
    80005afa:	1602                	slli	a2,a2,0x20
    80005afc:	9201                	srli	a2,a2,0x20
    80005afe:	9642                	add	a2,a2,a6
  *s = c;
    80005b00:	fff74683          	lbu	a3,-1(a4)
    80005b04:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    80005b08:	177d                	addi	a4,a4,-1
    80005b0a:	0785                	addi	a5,a5,1
    80005b0c:	fec79ae3          	bne	a5,a2,80005b00 <sprintint+0x76>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005b10:	6462                	ld	s0,24(sp)
    80005b12:	6105                	addi	sp,sp,32
    80005b14:	8082                	ret
    x = -xx;
    80005b16:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005b1a:	4305                	li	t1,1
    x = -xx;
    80005b1c:	b741                	j	80005a9c <sprintint+0x12>
  while(--i >= 0)
    80005b1e:	4501                	li	a0,0
    80005b20:	bfc5                	j	80005b10 <sprintint+0x86>

0000000080005b22 <snprintf>:

int
snprintf(char *buf, int sz, char *fmt, ...)
{
    80005b22:	7171                	addi	sp,sp,-176
    80005b24:	fc86                	sd	ra,120(sp)
    80005b26:	f8a2                	sd	s0,112(sp)
    80005b28:	f4a6                	sd	s1,104(sp)
    80005b2a:	f0ca                	sd	s2,96(sp)
    80005b2c:	ecce                	sd	s3,88(sp)
    80005b2e:	e8d2                	sd	s4,80(sp)
    80005b30:	e4d6                	sd	s5,72(sp)
    80005b32:	e0da                	sd	s6,64(sp)
    80005b34:	fc5e                	sd	s7,56(sp)
    80005b36:	f862                	sd	s8,48(sp)
    80005b38:	f466                	sd	s9,40(sp)
    80005b3a:	f06a                	sd	s10,32(sp)
    80005b3c:	ec6e                	sd	s11,24(sp)
    80005b3e:	0100                	addi	s0,sp,128
    80005b40:	e414                	sd	a3,8(s0)
    80005b42:	e818                	sd	a4,16(s0)
    80005b44:	ec1c                	sd	a5,24(s0)
    80005b46:	03043023          	sd	a6,32(s0)
    80005b4a:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  if (fmt == 0)
    80005b4e:	ca0d                	beqz	a2,80005b80 <snprintf+0x5e>
    80005b50:	8baa                	mv	s7,a0
    80005b52:	89ae                	mv	s3,a1
    80005b54:	8a32                	mv	s4,a2
    panic("null fmt");

  va_start(ap, fmt);
    80005b56:	00840793          	addi	a5,s0,8
    80005b5a:	f8f43423          	sd	a5,-120(s0)
  int off = 0;
    80005b5e:	4481                	li	s1,0
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b60:	4901                	li	s2,0
    80005b62:	02b05763          	blez	a1,80005b90 <snprintf+0x6e>
    if(c != '%'){
    80005b66:	02500a93          	li	s5,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    80005b6a:	07300b13          	li	s6,115
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
      break;
    case 's':
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s && off < sz; s++)
    80005b6e:	02800d93          	li	s11,40
  *s = c;
    80005b72:	02500d13          	li	s10,37
    switch(c){
    80005b76:	07800c93          	li	s9,120
    80005b7a:	06400c13          	li	s8,100
    80005b7e:	a01d                	j	80005ba4 <snprintf+0x82>
    panic("null fmt");
    80005b80:	00003517          	auipc	a0,0x3
    80005b84:	c2050513          	addi	a0,a0,-992 # 800087a0 <syscalls+0x3d8>
    80005b88:	00000097          	auipc	ra,0x0
    80005b8c:	634080e7          	jalr	1588(ra) # 800061bc <panic>
  int off = 0;
    80005b90:	4481                	li	s1,0
    80005b92:	a86d                	j	80005c4c <snprintf+0x12a>
  *s = c;
    80005b94:	009b8733          	add	a4,s7,s1
    80005b98:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005b9c:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005b9e:	2905                	addiw	s2,s2,1
    80005ba0:	0b34d663          	bge	s1,s3,80005c4c <snprintf+0x12a>
    80005ba4:	012a07b3          	add	a5,s4,s2
    80005ba8:	0007c783          	lbu	a5,0(a5)
    80005bac:	0007871b          	sext.w	a4,a5
    80005bb0:	cfd1                	beqz	a5,80005c4c <snprintf+0x12a>
    if(c != '%'){
    80005bb2:	ff5711e3          	bne	a4,s5,80005b94 <snprintf+0x72>
    c = fmt[++i] & 0xff;
    80005bb6:	2905                	addiw	s2,s2,1
    80005bb8:	012a07b3          	add	a5,s4,s2
    80005bbc:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    80005bc0:	c7d1                	beqz	a5,80005c4c <snprintf+0x12a>
    switch(c){
    80005bc2:	05678c63          	beq	a5,s6,80005c1a <snprintf+0xf8>
    80005bc6:	02fb6763          	bltu	s6,a5,80005bf4 <snprintf+0xd2>
    80005bca:	0b578763          	beq	a5,s5,80005c78 <snprintf+0x156>
    80005bce:	0b879b63          	bne	a5,s8,80005c84 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005bd2:	f8843783          	ld	a5,-120(s0)
    80005bd6:	00878713          	addi	a4,a5,8
    80005bda:	f8e43423          	sd	a4,-120(s0)
    80005bde:	4685                	li	a3,1
    80005be0:	4629                	li	a2,10
    80005be2:	438c                	lw	a1,0(a5)
    80005be4:	009b8533          	add	a0,s7,s1
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	ea2080e7          	jalr	-350(ra) # 80005a8a <sprintint>
    80005bf0:	9ca9                	addw	s1,s1,a0
      break;
    80005bf2:	b775                	j	80005b9e <snprintf+0x7c>
    switch(c){
    80005bf4:	09979863          	bne	a5,s9,80005c84 <snprintf+0x162>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005bf8:	f8843783          	ld	a5,-120(s0)
    80005bfc:	00878713          	addi	a4,a5,8
    80005c00:	f8e43423          	sd	a4,-120(s0)
    80005c04:	4685                	li	a3,1
    80005c06:	4641                	li	a2,16
    80005c08:	438c                	lw	a1,0(a5)
    80005c0a:	009b8533          	add	a0,s7,s1
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	e7c080e7          	jalr	-388(ra) # 80005a8a <sprintint>
    80005c16:	9ca9                	addw	s1,s1,a0
      break;
    80005c18:	b759                	j	80005b9e <snprintf+0x7c>
      if((s = va_arg(ap, char*)) == 0)
    80005c1a:	f8843783          	ld	a5,-120(s0)
    80005c1e:	00878713          	addi	a4,a5,8
    80005c22:	f8e43423          	sd	a4,-120(s0)
    80005c26:	639c                	ld	a5,0(a5)
    80005c28:	c3b1                	beqz	a5,80005c6c <snprintf+0x14a>
      for(; *s && off < sz; s++)
    80005c2a:	0007c703          	lbu	a4,0(a5)
    80005c2e:	db25                	beqz	a4,80005b9e <snprintf+0x7c>
    80005c30:	0134de63          	bge	s1,s3,80005c4c <snprintf+0x12a>
    80005c34:	009b86b3          	add	a3,s7,s1
  *s = c;
    80005c38:	00e68023          	sb	a4,0(a3)
        off += sputc(buf+off, *s);
    80005c3c:	2485                	addiw	s1,s1,1
      for(; *s && off < sz; s++)
    80005c3e:	0785                	addi	a5,a5,1
    80005c40:	0007c703          	lbu	a4,0(a5)
    80005c44:	df29                	beqz	a4,80005b9e <snprintf+0x7c>
    80005c46:	0685                	addi	a3,a3,1
    80005c48:	fe9998e3          	bne	s3,s1,80005c38 <snprintf+0x116>
      off += sputc(buf+off, c);
      break;
    }
  }
  return off;
}
    80005c4c:	8526                	mv	a0,s1
    80005c4e:	70e6                	ld	ra,120(sp)
    80005c50:	7446                	ld	s0,112(sp)
    80005c52:	74a6                	ld	s1,104(sp)
    80005c54:	7906                	ld	s2,96(sp)
    80005c56:	69e6                	ld	s3,88(sp)
    80005c58:	6a46                	ld	s4,80(sp)
    80005c5a:	6aa6                	ld	s5,72(sp)
    80005c5c:	6b06                	ld	s6,64(sp)
    80005c5e:	7be2                	ld	s7,56(sp)
    80005c60:	7c42                	ld	s8,48(sp)
    80005c62:	7ca2                	ld	s9,40(sp)
    80005c64:	7d02                	ld	s10,32(sp)
    80005c66:	6de2                	ld	s11,24(sp)
    80005c68:	614d                	addi	sp,sp,176
    80005c6a:	8082                	ret
        s = "(null)";
    80005c6c:	00003797          	auipc	a5,0x3
    80005c70:	b2c78793          	addi	a5,a5,-1236 # 80008798 <syscalls+0x3d0>
      for(; *s && off < sz; s++)
    80005c74:	876e                	mv	a4,s11
    80005c76:	bf6d                	j	80005c30 <snprintf+0x10e>
  *s = c;
    80005c78:	009b87b3          	add	a5,s7,s1
    80005c7c:	01a78023          	sb	s10,0(a5)
      off += sputc(buf+off, '%');
    80005c80:	2485                	addiw	s1,s1,1
      break;
    80005c82:	bf31                	j	80005b9e <snprintf+0x7c>
  *s = c;
    80005c84:	009b8733          	add	a4,s7,s1
    80005c88:	01a70023          	sb	s10,0(a4)
      off += sputc(buf+off, c);
    80005c8c:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005c90:	975e                	add	a4,a4,s7
    80005c92:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005c96:	2489                	addiw	s1,s1,2
      break;
    80005c98:	b719                	j	80005b9e <snprintf+0x7c>

0000000080005c9a <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005c9a:	1141                	addi	sp,sp,-16
    80005c9c:	e422                	sd	s0,8(sp)
    80005c9e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ca0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ca4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005ca8:	0037979b          	slliw	a5,a5,0x3
    80005cac:	02004737          	lui	a4,0x2004
    80005cb0:	97ba                	add	a5,a5,a4
    80005cb2:	0200c737          	lui	a4,0x200c
    80005cb6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005cba:	000f4637          	lui	a2,0xf4
    80005cbe:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005cc2:	95b2                	add	a1,a1,a2
    80005cc4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005cc6:	00269713          	slli	a4,a3,0x2
    80005cca:	9736                	add	a4,a4,a3
    80005ccc:	00371693          	slli	a3,a4,0x3
    80005cd0:	0001c717          	auipc	a4,0x1c
    80005cd4:	36070713          	addi	a4,a4,864 # 80022030 <timer_scratch>
    80005cd8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005cda:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005cdc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005cde:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ce2:	fffff797          	auipc	a5,0xfffff
    80005ce6:	63e78793          	addi	a5,a5,1598 # 80005320 <timervec>
    80005cea:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005cee:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005cf2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005cf6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005cfa:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005cfe:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005d02:	30479073          	csrw	mie,a5
}
    80005d06:	6422                	ld	s0,8(sp)
    80005d08:	0141                	addi	sp,sp,16
    80005d0a:	8082                	ret

0000000080005d0c <start>:
{
    80005d0c:	1141                	addi	sp,sp,-16
    80005d0e:	e406                	sd	ra,8(sp)
    80005d10:	e022                	sd	s0,0(sp)
    80005d12:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005d14:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005d18:	7779                	lui	a4,0xffffe
    80005d1a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd35b7>
    80005d1e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005d20:	6705                	lui	a4,0x1
    80005d22:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005d26:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005d28:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005d2c:	ffffa797          	auipc	a5,0xffffa
    80005d30:	7d078793          	addi	a5,a5,2000 # 800004fc <main>
    80005d34:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005d38:	4781                	li	a5,0
    80005d3a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005d3e:	67c1                	lui	a5,0x10
    80005d40:	17fd                	addi	a5,a5,-1
    80005d42:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005d46:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005d4a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005d4e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005d52:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005d56:	57fd                	li	a5,-1
    80005d58:	83a9                	srli	a5,a5,0xa
    80005d5a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005d5e:	47bd                	li	a5,15
    80005d60:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	f36080e7          	jalr	-202(ra) # 80005c9a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005d6c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005d70:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005d72:	823e                	mv	tp,a5
  asm volatile("mret");
    80005d74:	30200073          	mret
}
    80005d78:	60a2                	ld	ra,8(sp)
    80005d7a:	6402                	ld	s0,0(sp)
    80005d7c:	0141                	addi	sp,sp,16
    80005d7e:	8082                	ret

0000000080005d80 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005d80:	715d                	addi	sp,sp,-80
    80005d82:	e486                	sd	ra,72(sp)
    80005d84:	e0a2                	sd	s0,64(sp)
    80005d86:	fc26                	sd	s1,56(sp)
    80005d88:	f84a                	sd	s2,48(sp)
    80005d8a:	f44e                	sd	s3,40(sp)
    80005d8c:	f052                	sd	s4,32(sp)
    80005d8e:	ec56                	sd	s5,24(sp)
    80005d90:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005d92:	04c05663          	blez	a2,80005dde <consolewrite+0x5e>
    80005d96:	8a2a                	mv	s4,a0
    80005d98:	84ae                	mv	s1,a1
    80005d9a:	89b2                	mv	s3,a2
    80005d9c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005d9e:	5afd                	li	s5,-1
    80005da0:	4685                	li	a3,1
    80005da2:	8626                	mv	a2,s1
    80005da4:	85d2                	mv	a1,s4
    80005da6:	fbf40513          	addi	a0,s0,-65
    80005daa:	ffffc097          	auipc	ra,0xffffc
    80005dae:	d3a080e7          	jalr	-710(ra) # 80001ae4 <either_copyin>
    80005db2:	01550c63          	beq	a0,s5,80005dca <consolewrite+0x4a>
      break;
    uartputc(c);
    80005db6:	fbf44503          	lbu	a0,-65(s0)
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	78e080e7          	jalr	1934(ra) # 80006548 <uartputc>
  for(i = 0; i < n; i++){
    80005dc2:	2905                	addiw	s2,s2,1
    80005dc4:	0485                	addi	s1,s1,1
    80005dc6:	fd299de3          	bne	s3,s2,80005da0 <consolewrite+0x20>
  }

  return i;
}
    80005dca:	854a                	mv	a0,s2
    80005dcc:	60a6                	ld	ra,72(sp)
    80005dce:	6406                	ld	s0,64(sp)
    80005dd0:	74e2                	ld	s1,56(sp)
    80005dd2:	7942                	ld	s2,48(sp)
    80005dd4:	79a2                	ld	s3,40(sp)
    80005dd6:	7a02                	ld	s4,32(sp)
    80005dd8:	6ae2                	ld	s5,24(sp)
    80005dda:	6161                	addi	sp,sp,80
    80005ddc:	8082                	ret
  for(i = 0; i < n; i++){
    80005dde:	4901                	li	s2,0
    80005de0:	b7ed                	j	80005dca <consolewrite+0x4a>

0000000080005de2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005de2:	7119                	addi	sp,sp,-128
    80005de4:	fc86                	sd	ra,120(sp)
    80005de6:	f8a2                	sd	s0,112(sp)
    80005de8:	f4a6                	sd	s1,104(sp)
    80005dea:	f0ca                	sd	s2,96(sp)
    80005dec:	ecce                	sd	s3,88(sp)
    80005dee:	e8d2                	sd	s4,80(sp)
    80005df0:	e4d6                	sd	s5,72(sp)
    80005df2:	e0da                	sd	s6,64(sp)
    80005df4:	fc5e                	sd	s7,56(sp)
    80005df6:	f862                	sd	s8,48(sp)
    80005df8:	f466                	sd	s9,40(sp)
    80005dfa:	f06a                	sd	s10,32(sp)
    80005dfc:	ec6e                	sd	s11,24(sp)
    80005dfe:	0100                	addi	s0,sp,128
    80005e00:	8b2a                	mv	s6,a0
    80005e02:	8aae                	mv	s5,a1
    80005e04:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005e06:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005e0a:	00024517          	auipc	a0,0x24
    80005e0e:	36650513          	addi	a0,a0,870 # 8002a170 <cons>
    80005e12:	00001097          	auipc	ra,0x1
    80005e16:	8de080e7          	jalr	-1826(ra) # 800066f0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005e1a:	00024497          	auipc	s1,0x24
    80005e1e:	35648493          	addi	s1,s1,854 # 8002a170 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005e22:	89a6                	mv	s3,s1
    80005e24:	00024917          	auipc	s2,0x24
    80005e28:	3ec90913          	addi	s2,s2,1004 # 8002a210 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005e2c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e2e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005e30:	4da9                	li	s11,10
  while(n > 0){
    80005e32:	07405863          	blez	s4,80005ea2 <consoleread+0xc0>
    while(cons.r == cons.w){
    80005e36:	0a04a783          	lw	a5,160(s1)
    80005e3a:	0a44a703          	lw	a4,164(s1)
    80005e3e:	02f71463          	bne	a4,a5,80005e66 <consoleread+0x84>
      if(myproc()->killed){
    80005e42:	ffffb097          	auipc	ra,0xffffb
    80005e46:	1ec080e7          	jalr	492(ra) # 8000102e <myproc>
    80005e4a:	591c                	lw	a5,48(a0)
    80005e4c:	e7b5                	bnez	a5,80005eb8 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80005e4e:	85ce                	mv	a1,s3
    80005e50:	854a                	mv	a0,s2
    80005e52:	ffffc097          	auipc	ra,0xffffc
    80005e56:	898080e7          	jalr	-1896(ra) # 800016ea <sleep>
    while(cons.r == cons.w){
    80005e5a:	0a04a783          	lw	a5,160(s1)
    80005e5e:	0a44a703          	lw	a4,164(s1)
    80005e62:	fef700e3          	beq	a4,a5,80005e42 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005e66:	0017871b          	addiw	a4,a5,1
    80005e6a:	0ae4a023          	sw	a4,160(s1)
    80005e6e:	07f7f713          	andi	a4,a5,127
    80005e72:	9726                	add	a4,a4,s1
    80005e74:	02074703          	lbu	a4,32(a4)
    80005e78:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005e7c:	079c0663          	beq	s8,s9,80005ee8 <consoleread+0x106>
    cbuf = c;
    80005e80:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005e84:	4685                	li	a3,1
    80005e86:	f8f40613          	addi	a2,s0,-113
    80005e8a:	85d6                	mv	a1,s5
    80005e8c:	855a                	mv	a0,s6
    80005e8e:	ffffc097          	auipc	ra,0xffffc
    80005e92:	c00080e7          	jalr	-1024(ra) # 80001a8e <either_copyout>
    80005e96:	01a50663          	beq	a0,s10,80005ea2 <consoleread+0xc0>
    dst++;
    80005e9a:	0a85                	addi	s5,s5,1
    --n;
    80005e9c:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005e9e:	f9bc1ae3          	bne	s8,s11,80005e32 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ea2:	00024517          	auipc	a0,0x24
    80005ea6:	2ce50513          	addi	a0,a0,718 # 8002a170 <cons>
    80005eaa:	00001097          	auipc	ra,0x1
    80005eae:	916080e7          	jalr	-1770(ra) # 800067c0 <release>

  return target - n;
    80005eb2:	414b853b          	subw	a0,s7,s4
    80005eb6:	a811                	j	80005eca <consoleread+0xe8>
        release(&cons.lock);
    80005eb8:	00024517          	auipc	a0,0x24
    80005ebc:	2b850513          	addi	a0,a0,696 # 8002a170 <cons>
    80005ec0:	00001097          	auipc	ra,0x1
    80005ec4:	900080e7          	jalr	-1792(ra) # 800067c0 <release>
        return -1;
    80005ec8:	557d                	li	a0,-1
}
    80005eca:	70e6                	ld	ra,120(sp)
    80005ecc:	7446                	ld	s0,112(sp)
    80005ece:	74a6                	ld	s1,104(sp)
    80005ed0:	7906                	ld	s2,96(sp)
    80005ed2:	69e6                	ld	s3,88(sp)
    80005ed4:	6a46                	ld	s4,80(sp)
    80005ed6:	6aa6                	ld	s5,72(sp)
    80005ed8:	6b06                	ld	s6,64(sp)
    80005eda:	7be2                	ld	s7,56(sp)
    80005edc:	7c42                	ld	s8,48(sp)
    80005ede:	7ca2                	ld	s9,40(sp)
    80005ee0:	7d02                	ld	s10,32(sp)
    80005ee2:	6de2                	ld	s11,24(sp)
    80005ee4:	6109                	addi	sp,sp,128
    80005ee6:	8082                	ret
      if(n < target){
    80005ee8:	000a071b          	sext.w	a4,s4
    80005eec:	fb777be3          	bgeu	a4,s7,80005ea2 <consoleread+0xc0>
        cons.r--;
    80005ef0:	00024717          	auipc	a4,0x24
    80005ef4:	32f72023          	sw	a5,800(a4) # 8002a210 <cons+0xa0>
    80005ef8:	b76d                	j	80005ea2 <consoleread+0xc0>

0000000080005efa <consputc>:
{
    80005efa:	1141                	addi	sp,sp,-16
    80005efc:	e406                	sd	ra,8(sp)
    80005efe:	e022                	sd	s0,0(sp)
    80005f00:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005f02:	10000793          	li	a5,256
    80005f06:	00f50a63          	beq	a0,a5,80005f1a <consputc+0x20>
    uartputc_sync(c);
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	564080e7          	jalr	1380(ra) # 8000646e <uartputc_sync>
}
    80005f12:	60a2                	ld	ra,8(sp)
    80005f14:	6402                	ld	s0,0(sp)
    80005f16:	0141                	addi	sp,sp,16
    80005f18:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005f1a:	4521                	li	a0,8
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	552080e7          	jalr	1362(ra) # 8000646e <uartputc_sync>
    80005f24:	02000513          	li	a0,32
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	546080e7          	jalr	1350(ra) # 8000646e <uartputc_sync>
    80005f30:	4521                	li	a0,8
    80005f32:	00000097          	auipc	ra,0x0
    80005f36:	53c080e7          	jalr	1340(ra) # 8000646e <uartputc_sync>
    80005f3a:	bfe1                	j	80005f12 <consputc+0x18>

0000000080005f3c <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005f3c:	1101                	addi	sp,sp,-32
    80005f3e:	ec06                	sd	ra,24(sp)
    80005f40:	e822                	sd	s0,16(sp)
    80005f42:	e426                	sd	s1,8(sp)
    80005f44:	e04a                	sd	s2,0(sp)
    80005f46:	1000                	addi	s0,sp,32
    80005f48:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005f4a:	00024517          	auipc	a0,0x24
    80005f4e:	22650513          	addi	a0,a0,550 # 8002a170 <cons>
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	79e080e7          	jalr	1950(ra) # 800066f0 <acquire>

  switch(c){
    80005f5a:	47d5                	li	a5,21
    80005f5c:	0af48663          	beq	s1,a5,80006008 <consoleintr+0xcc>
    80005f60:	0297ca63          	blt	a5,s1,80005f94 <consoleintr+0x58>
    80005f64:	47a1                	li	a5,8
    80005f66:	0ef48763          	beq	s1,a5,80006054 <consoleintr+0x118>
    80005f6a:	47c1                	li	a5,16
    80005f6c:	10f49a63          	bne	s1,a5,80006080 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005f70:	ffffc097          	auipc	ra,0xffffc
    80005f74:	bca080e7          	jalr	-1078(ra) # 80001b3a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005f78:	00024517          	auipc	a0,0x24
    80005f7c:	1f850513          	addi	a0,a0,504 # 8002a170 <cons>
    80005f80:	00001097          	auipc	ra,0x1
    80005f84:	840080e7          	jalr	-1984(ra) # 800067c0 <release>
}
    80005f88:	60e2                	ld	ra,24(sp)
    80005f8a:	6442                	ld	s0,16(sp)
    80005f8c:	64a2                	ld	s1,8(sp)
    80005f8e:	6902                	ld	s2,0(sp)
    80005f90:	6105                	addi	sp,sp,32
    80005f92:	8082                	ret
  switch(c){
    80005f94:	07f00793          	li	a5,127
    80005f98:	0af48e63          	beq	s1,a5,80006054 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005f9c:	00024717          	auipc	a4,0x24
    80005fa0:	1d470713          	addi	a4,a4,468 # 8002a170 <cons>
    80005fa4:	0a872783          	lw	a5,168(a4)
    80005fa8:	0a072703          	lw	a4,160(a4)
    80005fac:	9f99                	subw	a5,a5,a4
    80005fae:	07f00713          	li	a4,127
    80005fb2:	fcf763e3          	bltu	a4,a5,80005f78 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005fb6:	47b5                	li	a5,13
    80005fb8:	0cf48763          	beq	s1,a5,80006086 <consoleintr+0x14a>
      consputc(c);
    80005fbc:	8526                	mv	a0,s1
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	f3c080e7          	jalr	-196(ra) # 80005efa <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005fc6:	00024797          	auipc	a5,0x24
    80005fca:	1aa78793          	addi	a5,a5,426 # 8002a170 <cons>
    80005fce:	0a87a703          	lw	a4,168(a5)
    80005fd2:	0017069b          	addiw	a3,a4,1
    80005fd6:	0006861b          	sext.w	a2,a3
    80005fda:	0ad7a423          	sw	a3,168(a5)
    80005fde:	07f77713          	andi	a4,a4,127
    80005fe2:	97ba                	add	a5,a5,a4
    80005fe4:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005fe8:	47a9                	li	a5,10
    80005fea:	0cf48563          	beq	s1,a5,800060b4 <consoleintr+0x178>
    80005fee:	4791                	li	a5,4
    80005ff0:	0cf48263          	beq	s1,a5,800060b4 <consoleintr+0x178>
    80005ff4:	00024797          	auipc	a5,0x24
    80005ff8:	21c7a783          	lw	a5,540(a5) # 8002a210 <cons+0xa0>
    80005ffc:	0807879b          	addiw	a5,a5,128
    80006000:	f6f61ce3          	bne	a2,a5,80005f78 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006004:	863e                	mv	a2,a5
    80006006:	a07d                	j	800060b4 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80006008:	00024717          	auipc	a4,0x24
    8000600c:	16870713          	addi	a4,a4,360 # 8002a170 <cons>
    80006010:	0a872783          	lw	a5,168(a4)
    80006014:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006018:	00024497          	auipc	s1,0x24
    8000601c:	15848493          	addi	s1,s1,344 # 8002a170 <cons>
    while(cons.e != cons.w &&
    80006020:	4929                	li	s2,10
    80006022:	f4f70be3          	beq	a4,a5,80005f78 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80006026:	37fd                	addiw	a5,a5,-1
    80006028:	07f7f713          	andi	a4,a5,127
    8000602c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000602e:	02074703          	lbu	a4,32(a4)
    80006032:	f52703e3          	beq	a4,s2,80005f78 <consoleintr+0x3c>
      cons.e--;
    80006036:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    8000603a:	10000513          	li	a0,256
    8000603e:	00000097          	auipc	ra,0x0
    80006042:	ebc080e7          	jalr	-324(ra) # 80005efa <consputc>
    while(cons.e != cons.w &&
    80006046:	0a84a783          	lw	a5,168(s1)
    8000604a:	0a44a703          	lw	a4,164(s1)
    8000604e:	fcf71ce3          	bne	a4,a5,80006026 <consoleintr+0xea>
    80006052:	b71d                	j	80005f78 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80006054:	00024717          	auipc	a4,0x24
    80006058:	11c70713          	addi	a4,a4,284 # 8002a170 <cons>
    8000605c:	0a872783          	lw	a5,168(a4)
    80006060:	0a472703          	lw	a4,164(a4)
    80006064:	f0f70ae3          	beq	a4,a5,80005f78 <consoleintr+0x3c>
      cons.e--;
    80006068:	37fd                	addiw	a5,a5,-1
    8000606a:	00024717          	auipc	a4,0x24
    8000606e:	1af72723          	sw	a5,430(a4) # 8002a218 <cons+0xa8>
      consputc(BACKSPACE);
    80006072:	10000513          	li	a0,256
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	e84080e7          	jalr	-380(ra) # 80005efa <consputc>
    8000607e:	bded                	j	80005f78 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80006080:	ee048ce3          	beqz	s1,80005f78 <consoleintr+0x3c>
    80006084:	bf21                	j	80005f9c <consoleintr+0x60>
      consputc(c);
    80006086:	4529                	li	a0,10
    80006088:	00000097          	auipc	ra,0x0
    8000608c:	e72080e7          	jalr	-398(ra) # 80005efa <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80006090:	00024797          	auipc	a5,0x24
    80006094:	0e078793          	addi	a5,a5,224 # 8002a170 <cons>
    80006098:	0a87a703          	lw	a4,168(a5)
    8000609c:	0017069b          	addiw	a3,a4,1
    800060a0:	0006861b          	sext.w	a2,a3
    800060a4:	0ad7a423          	sw	a3,168(a5)
    800060a8:	07f77713          	andi	a4,a4,127
    800060ac:	97ba                	add	a5,a5,a4
    800060ae:	4729                	li	a4,10
    800060b0:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    800060b4:	00024797          	auipc	a5,0x24
    800060b8:	16c7a023          	sw	a2,352(a5) # 8002a214 <cons+0xa4>
        wakeup(&cons.r);
    800060bc:	00024517          	auipc	a0,0x24
    800060c0:	15450513          	addi	a0,a0,340 # 8002a210 <cons+0xa0>
    800060c4:	ffffb097          	auipc	ra,0xffffb
    800060c8:	7b2080e7          	jalr	1970(ra) # 80001876 <wakeup>
    800060cc:	b575                	j	80005f78 <consoleintr+0x3c>

00000000800060ce <consoleinit>:

void
consoleinit(void)
{
    800060ce:	1141                	addi	sp,sp,-16
    800060d0:	e406                	sd	ra,8(sp)
    800060d2:	e022                	sd	s0,0(sp)
    800060d4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800060d6:	00002597          	auipc	a1,0x2
    800060da:	6f258593          	addi	a1,a1,1778 # 800087c8 <digits+0x18>
    800060de:	00024517          	auipc	a0,0x24
    800060e2:	09250513          	addi	a0,a0,146 # 8002a170 <cons>
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	786080e7          	jalr	1926(ra) # 8000686c <initlock>

  uartinit();
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	330080e7          	jalr	816(ra) # 8000641e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800060f6:	00017797          	auipc	a5,0x17
    800060fa:	d0278793          	addi	a5,a5,-766 # 8001cdf8 <devsw>
    800060fe:	00000717          	auipc	a4,0x0
    80006102:	ce470713          	addi	a4,a4,-796 # 80005de2 <consoleread>
    80006106:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80006108:	00000717          	auipc	a4,0x0
    8000610c:	c7870713          	addi	a4,a4,-904 # 80005d80 <consolewrite>
    80006110:	ef98                	sd	a4,24(a5)
}
    80006112:	60a2                	ld	ra,8(sp)
    80006114:	6402                	ld	s0,0(sp)
    80006116:	0141                	addi	sp,sp,16
    80006118:	8082                	ret

000000008000611a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000611a:	7179                	addi	sp,sp,-48
    8000611c:	f406                	sd	ra,40(sp)
    8000611e:	f022                	sd	s0,32(sp)
    80006120:	ec26                	sd	s1,24(sp)
    80006122:	e84a                	sd	s2,16(sp)
    80006124:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80006126:	c219                	beqz	a2,8000612c <printint+0x12>
    80006128:	08054663          	bltz	a0,800061b4 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000612c:	2501                	sext.w	a0,a0
    8000612e:	4881                	li	a7,0
    80006130:	fd040693          	addi	a3,s0,-48

  i = 0;
    80006134:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80006136:	2581                	sext.w	a1,a1
    80006138:	00002617          	auipc	a2,0x2
    8000613c:	6a860613          	addi	a2,a2,1704 # 800087e0 <digits>
    80006140:	883a                	mv	a6,a4
    80006142:	2705                	addiw	a4,a4,1
    80006144:	02b577bb          	remuw	a5,a0,a1
    80006148:	1782                	slli	a5,a5,0x20
    8000614a:	9381                	srli	a5,a5,0x20
    8000614c:	97b2                	add	a5,a5,a2
    8000614e:	0007c783          	lbu	a5,0(a5)
    80006152:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006156:	0005079b          	sext.w	a5,a0
    8000615a:	02b5553b          	divuw	a0,a0,a1
    8000615e:	0685                	addi	a3,a3,1
    80006160:	feb7f0e3          	bgeu	a5,a1,80006140 <printint+0x26>

  if(sign)
    80006164:	00088b63          	beqz	a7,8000617a <printint+0x60>
    buf[i++] = '-';
    80006168:	fe040793          	addi	a5,s0,-32
    8000616c:	973e                	add	a4,a4,a5
    8000616e:	02d00793          	li	a5,45
    80006172:	fef70823          	sb	a5,-16(a4)
    80006176:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    8000617a:	02e05763          	blez	a4,800061a8 <printint+0x8e>
    8000617e:	fd040793          	addi	a5,s0,-48
    80006182:	00e784b3          	add	s1,a5,a4
    80006186:	fff78913          	addi	s2,a5,-1
    8000618a:	993a                	add	s2,s2,a4
    8000618c:	377d                	addiw	a4,a4,-1
    8000618e:	1702                	slli	a4,a4,0x20
    80006190:	9301                	srli	a4,a4,0x20
    80006192:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80006196:	fff4c503          	lbu	a0,-1(s1)
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	d60080e7          	jalr	-672(ra) # 80005efa <consputc>
  while(--i >= 0)
    800061a2:	14fd                	addi	s1,s1,-1
    800061a4:	ff2499e3          	bne	s1,s2,80006196 <printint+0x7c>
}
    800061a8:	70a2                	ld	ra,40(sp)
    800061aa:	7402                	ld	s0,32(sp)
    800061ac:	64e2                	ld	s1,24(sp)
    800061ae:	6942                	ld	s2,16(sp)
    800061b0:	6145                	addi	sp,sp,48
    800061b2:	8082                	ret
    x = -xx;
    800061b4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800061b8:	4885                	li	a7,1
    x = -xx;
    800061ba:	bf9d                	j	80006130 <printint+0x16>

00000000800061bc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800061bc:	1101                	addi	sp,sp,-32
    800061be:	ec06                	sd	ra,24(sp)
    800061c0:	e822                	sd	s0,16(sp)
    800061c2:	e426                	sd	s1,8(sp)
    800061c4:	1000                	addi	s0,sp,32
    800061c6:	84aa                	mv	s1,a0
  pr.locking = 0;
    800061c8:	00024797          	auipc	a5,0x24
    800061cc:	0607ac23          	sw	zero,120(a5) # 8002a240 <pr+0x20>
  printf("panic: ");
    800061d0:	00002517          	auipc	a0,0x2
    800061d4:	60050513          	addi	a0,a0,1536 # 800087d0 <digits+0x20>
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	02e080e7          	jalr	46(ra) # 80006206 <printf>
  printf(s);
    800061e0:	8526                	mv	a0,s1
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	024080e7          	jalr	36(ra) # 80006206 <printf>
  printf("\n");
    800061ea:	00002517          	auipc	a0,0x2
    800061ee:	67e50513          	addi	a0,a0,1662 # 80008868 <digits+0x88>
    800061f2:	00000097          	auipc	ra,0x0
    800061f6:	014080e7          	jalr	20(ra) # 80006206 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800061fa:	4785                	li	a5,1
    800061fc:	00003717          	auipc	a4,0x3
    80006200:	e2f72023          	sw	a5,-480(a4) # 8000901c <panicked>
  for(;;)
    80006204:	a001                	j	80006204 <panic+0x48>

0000000080006206 <printf>:
{
    80006206:	7131                	addi	sp,sp,-192
    80006208:	fc86                	sd	ra,120(sp)
    8000620a:	f8a2                	sd	s0,112(sp)
    8000620c:	f4a6                	sd	s1,104(sp)
    8000620e:	f0ca                	sd	s2,96(sp)
    80006210:	ecce                	sd	s3,88(sp)
    80006212:	e8d2                	sd	s4,80(sp)
    80006214:	e4d6                	sd	s5,72(sp)
    80006216:	e0da                	sd	s6,64(sp)
    80006218:	fc5e                	sd	s7,56(sp)
    8000621a:	f862                	sd	s8,48(sp)
    8000621c:	f466                	sd	s9,40(sp)
    8000621e:	f06a                	sd	s10,32(sp)
    80006220:	ec6e                	sd	s11,24(sp)
    80006222:	0100                	addi	s0,sp,128
    80006224:	8a2a                	mv	s4,a0
    80006226:	e40c                	sd	a1,8(s0)
    80006228:	e810                	sd	a2,16(s0)
    8000622a:	ec14                	sd	a3,24(s0)
    8000622c:	f018                	sd	a4,32(s0)
    8000622e:	f41c                	sd	a5,40(s0)
    80006230:	03043823          	sd	a6,48(s0)
    80006234:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80006238:	00024d97          	auipc	s11,0x24
    8000623c:	008dad83          	lw	s11,8(s11) # 8002a240 <pr+0x20>
  if(locking)
    80006240:	020d9b63          	bnez	s11,80006276 <printf+0x70>
  if (fmt == 0)
    80006244:	040a0263          	beqz	s4,80006288 <printf+0x82>
  va_start(ap, fmt);
    80006248:	00840793          	addi	a5,s0,8
    8000624c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006250:	000a4503          	lbu	a0,0(s4)
    80006254:	16050263          	beqz	a0,800063b8 <printf+0x1b2>
    80006258:	4481                	li	s1,0
    if(c != '%'){
    8000625a:	02500a93          	li	s5,37
    switch(c){
    8000625e:	07000b13          	li	s6,112
  consputc('x');
    80006262:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006264:	00002b97          	auipc	s7,0x2
    80006268:	57cb8b93          	addi	s7,s7,1404 # 800087e0 <digits>
    switch(c){
    8000626c:	07300c93          	li	s9,115
    80006270:	06400c13          	li	s8,100
    80006274:	a82d                	j	800062ae <printf+0xa8>
    acquire(&pr.lock);
    80006276:	00024517          	auipc	a0,0x24
    8000627a:	faa50513          	addi	a0,a0,-86 # 8002a220 <pr>
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	472080e7          	jalr	1138(ra) # 800066f0 <acquire>
    80006286:	bf7d                	j	80006244 <printf+0x3e>
    panic("null fmt");
    80006288:	00002517          	auipc	a0,0x2
    8000628c:	51850513          	addi	a0,a0,1304 # 800087a0 <syscalls+0x3d8>
    80006290:	00000097          	auipc	ra,0x0
    80006294:	f2c080e7          	jalr	-212(ra) # 800061bc <panic>
      consputc(c);
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	c62080e7          	jalr	-926(ra) # 80005efa <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800062a0:	2485                	addiw	s1,s1,1
    800062a2:	009a07b3          	add	a5,s4,s1
    800062a6:	0007c503          	lbu	a0,0(a5)
    800062aa:	10050763          	beqz	a0,800063b8 <printf+0x1b2>
    if(c != '%'){
    800062ae:	ff5515e3          	bne	a0,s5,80006298 <printf+0x92>
    c = fmt[++i] & 0xff;
    800062b2:	2485                	addiw	s1,s1,1
    800062b4:	009a07b3          	add	a5,s4,s1
    800062b8:	0007c783          	lbu	a5,0(a5)
    800062bc:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800062c0:	cfe5                	beqz	a5,800063b8 <printf+0x1b2>
    switch(c){
    800062c2:	05678a63          	beq	a5,s6,80006316 <printf+0x110>
    800062c6:	02fb7663          	bgeu	s6,a5,800062f2 <printf+0xec>
    800062ca:	09978963          	beq	a5,s9,8000635c <printf+0x156>
    800062ce:	07800713          	li	a4,120
    800062d2:	0ce79863          	bne	a5,a4,800063a2 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800062d6:	f8843783          	ld	a5,-120(s0)
    800062da:	00878713          	addi	a4,a5,8
    800062de:	f8e43423          	sd	a4,-120(s0)
    800062e2:	4605                	li	a2,1
    800062e4:	85ea                	mv	a1,s10
    800062e6:	4388                	lw	a0,0(a5)
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	e32080e7          	jalr	-462(ra) # 8000611a <printint>
      break;
    800062f0:	bf45                	j	800062a0 <printf+0x9a>
    switch(c){
    800062f2:	0b578263          	beq	a5,s5,80006396 <printf+0x190>
    800062f6:	0b879663          	bne	a5,s8,800063a2 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800062fa:	f8843783          	ld	a5,-120(s0)
    800062fe:	00878713          	addi	a4,a5,8
    80006302:	f8e43423          	sd	a4,-120(s0)
    80006306:	4605                	li	a2,1
    80006308:	45a9                	li	a1,10
    8000630a:	4388                	lw	a0,0(a5)
    8000630c:	00000097          	auipc	ra,0x0
    80006310:	e0e080e7          	jalr	-498(ra) # 8000611a <printint>
      break;
    80006314:	b771                	j	800062a0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80006316:	f8843783          	ld	a5,-120(s0)
    8000631a:	00878713          	addi	a4,a5,8
    8000631e:	f8e43423          	sd	a4,-120(s0)
    80006322:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80006326:	03000513          	li	a0,48
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	bd0080e7          	jalr	-1072(ra) # 80005efa <consputc>
  consputc('x');
    80006332:	07800513          	li	a0,120
    80006336:	00000097          	auipc	ra,0x0
    8000633a:	bc4080e7          	jalr	-1084(ra) # 80005efa <consputc>
    8000633e:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006340:	03c9d793          	srli	a5,s3,0x3c
    80006344:	97de                	add	a5,a5,s7
    80006346:	0007c503          	lbu	a0,0(a5)
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	bb0080e7          	jalr	-1104(ra) # 80005efa <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006352:	0992                	slli	s3,s3,0x4
    80006354:	397d                	addiw	s2,s2,-1
    80006356:	fe0915e3          	bnez	s2,80006340 <printf+0x13a>
    8000635a:	b799                	j	800062a0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000635c:	f8843783          	ld	a5,-120(s0)
    80006360:	00878713          	addi	a4,a5,8
    80006364:	f8e43423          	sd	a4,-120(s0)
    80006368:	0007b903          	ld	s2,0(a5)
    8000636c:	00090e63          	beqz	s2,80006388 <printf+0x182>
      for(; *s; s++)
    80006370:	00094503          	lbu	a0,0(s2)
    80006374:	d515                	beqz	a0,800062a0 <printf+0x9a>
        consputc(*s);
    80006376:	00000097          	auipc	ra,0x0
    8000637a:	b84080e7          	jalr	-1148(ra) # 80005efa <consputc>
      for(; *s; s++)
    8000637e:	0905                	addi	s2,s2,1
    80006380:	00094503          	lbu	a0,0(s2)
    80006384:	f96d                	bnez	a0,80006376 <printf+0x170>
    80006386:	bf29                	j	800062a0 <printf+0x9a>
        s = "(null)";
    80006388:	00002917          	auipc	s2,0x2
    8000638c:	41090913          	addi	s2,s2,1040 # 80008798 <syscalls+0x3d0>
      for(; *s; s++)
    80006390:	02800513          	li	a0,40
    80006394:	b7cd                	j	80006376 <printf+0x170>
      consputc('%');
    80006396:	8556                	mv	a0,s5
    80006398:	00000097          	auipc	ra,0x0
    8000639c:	b62080e7          	jalr	-1182(ra) # 80005efa <consputc>
      break;
    800063a0:	b701                	j	800062a0 <printf+0x9a>
      consputc('%');
    800063a2:	8556                	mv	a0,s5
    800063a4:	00000097          	auipc	ra,0x0
    800063a8:	b56080e7          	jalr	-1194(ra) # 80005efa <consputc>
      consputc(c);
    800063ac:	854a                	mv	a0,s2
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	b4c080e7          	jalr	-1204(ra) # 80005efa <consputc>
      break;
    800063b6:	b5ed                	j	800062a0 <printf+0x9a>
  if(locking)
    800063b8:	020d9163          	bnez	s11,800063da <printf+0x1d4>
}
    800063bc:	70e6                	ld	ra,120(sp)
    800063be:	7446                	ld	s0,112(sp)
    800063c0:	74a6                	ld	s1,104(sp)
    800063c2:	7906                	ld	s2,96(sp)
    800063c4:	69e6                	ld	s3,88(sp)
    800063c6:	6a46                	ld	s4,80(sp)
    800063c8:	6aa6                	ld	s5,72(sp)
    800063ca:	6b06                	ld	s6,64(sp)
    800063cc:	7be2                	ld	s7,56(sp)
    800063ce:	7c42                	ld	s8,48(sp)
    800063d0:	7ca2                	ld	s9,40(sp)
    800063d2:	7d02                	ld	s10,32(sp)
    800063d4:	6de2                	ld	s11,24(sp)
    800063d6:	6129                	addi	sp,sp,192
    800063d8:	8082                	ret
    release(&pr.lock);
    800063da:	00024517          	auipc	a0,0x24
    800063de:	e4650513          	addi	a0,a0,-442 # 8002a220 <pr>
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	3de080e7          	jalr	990(ra) # 800067c0 <release>
}
    800063ea:	bfc9                	j	800063bc <printf+0x1b6>

00000000800063ec <printfinit>:
    ;
}

void
printfinit(void)
{
    800063ec:	1101                	addi	sp,sp,-32
    800063ee:	ec06                	sd	ra,24(sp)
    800063f0:	e822                	sd	s0,16(sp)
    800063f2:	e426                	sd	s1,8(sp)
    800063f4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800063f6:	00024497          	auipc	s1,0x24
    800063fa:	e2a48493          	addi	s1,s1,-470 # 8002a220 <pr>
    800063fe:	00002597          	auipc	a1,0x2
    80006402:	3da58593          	addi	a1,a1,986 # 800087d8 <digits+0x28>
    80006406:	8526                	mv	a0,s1
    80006408:	00000097          	auipc	ra,0x0
    8000640c:	464080e7          	jalr	1124(ra) # 8000686c <initlock>
  pr.locking = 1;
    80006410:	4785                	li	a5,1
    80006412:	d09c                	sw	a5,32(s1)
}
    80006414:	60e2                	ld	ra,24(sp)
    80006416:	6442                	ld	s0,16(sp)
    80006418:	64a2                	ld	s1,8(sp)
    8000641a:	6105                	addi	sp,sp,32
    8000641c:	8082                	ret

000000008000641e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000641e:	1141                	addi	sp,sp,-16
    80006420:	e406                	sd	ra,8(sp)
    80006422:	e022                	sd	s0,0(sp)
    80006424:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006426:	100007b7          	lui	a5,0x10000
    8000642a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000642e:	f8000713          	li	a4,-128
    80006432:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006436:	470d                	li	a4,3
    80006438:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000643c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006440:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006444:	469d                	li	a3,7
    80006446:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000644a:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000644e:	00002597          	auipc	a1,0x2
    80006452:	3aa58593          	addi	a1,a1,938 # 800087f8 <digits+0x18>
    80006456:	00024517          	auipc	a0,0x24
    8000645a:	df250513          	addi	a0,a0,-526 # 8002a248 <uart_tx_lock>
    8000645e:	00000097          	auipc	ra,0x0
    80006462:	40e080e7          	jalr	1038(ra) # 8000686c <initlock>
}
    80006466:	60a2                	ld	ra,8(sp)
    80006468:	6402                	ld	s0,0(sp)
    8000646a:	0141                	addi	sp,sp,16
    8000646c:	8082                	ret

000000008000646e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000646e:	1101                	addi	sp,sp,-32
    80006470:	ec06                	sd	ra,24(sp)
    80006472:	e822                	sd	s0,16(sp)
    80006474:	e426                	sd	s1,8(sp)
    80006476:	1000                	addi	s0,sp,32
    80006478:	84aa                	mv	s1,a0
  push_off();
    8000647a:	00000097          	auipc	ra,0x0
    8000647e:	22a080e7          	jalr	554(ra) # 800066a4 <push_off>

  if(panicked){
    80006482:	00003797          	auipc	a5,0x3
    80006486:	b9a7a783          	lw	a5,-1126(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000648a:	10000737          	lui	a4,0x10000
  if(panicked){
    8000648e:	c391                	beqz	a5,80006492 <uartputc_sync+0x24>
    for(;;)
    80006490:	a001                	j	80006490 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006492:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006496:	0ff7f793          	andi	a5,a5,255
    8000649a:	0207f793          	andi	a5,a5,32
    8000649e:	dbf5                	beqz	a5,80006492 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800064a0:	0ff4f793          	andi	a5,s1,255
    800064a4:	10000737          	lui	a4,0x10000
    800064a8:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800064ac:	00000097          	auipc	ra,0x0
    800064b0:	2b4080e7          	jalr	692(ra) # 80006760 <pop_off>
}
    800064b4:	60e2                	ld	ra,24(sp)
    800064b6:	6442                	ld	s0,16(sp)
    800064b8:	64a2                	ld	s1,8(sp)
    800064ba:	6105                	addi	sp,sp,32
    800064bc:	8082                	ret

00000000800064be <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800064be:	00003717          	auipc	a4,0x3
    800064c2:	b6273703          	ld	a4,-1182(a4) # 80009020 <uart_tx_r>
    800064c6:	00003797          	auipc	a5,0x3
    800064ca:	b627b783          	ld	a5,-1182(a5) # 80009028 <uart_tx_w>
    800064ce:	06e78c63          	beq	a5,a4,80006546 <uartstart+0x88>
{
    800064d2:	7139                	addi	sp,sp,-64
    800064d4:	fc06                	sd	ra,56(sp)
    800064d6:	f822                	sd	s0,48(sp)
    800064d8:	f426                	sd	s1,40(sp)
    800064da:	f04a                	sd	s2,32(sp)
    800064dc:	ec4e                	sd	s3,24(sp)
    800064de:	e852                	sd	s4,16(sp)
    800064e0:	e456                	sd	s5,8(sp)
    800064e2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800064e4:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800064e8:	00024a17          	auipc	s4,0x24
    800064ec:	d60a0a13          	addi	s4,s4,-672 # 8002a248 <uart_tx_lock>
    uart_tx_r += 1;
    800064f0:	00003497          	auipc	s1,0x3
    800064f4:	b3048493          	addi	s1,s1,-1232 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800064f8:	00003997          	auipc	s3,0x3
    800064fc:	b3098993          	addi	s3,s3,-1232 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006500:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006504:	0ff7f793          	andi	a5,a5,255
    80006508:	0207f793          	andi	a5,a5,32
    8000650c:	c785                	beqz	a5,80006534 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000650e:	01f77793          	andi	a5,a4,31
    80006512:	97d2                	add	a5,a5,s4
    80006514:	0207ca83          	lbu	s5,32(a5)
    uart_tx_r += 1;
    80006518:	0705                	addi	a4,a4,1
    8000651a:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000651c:	8526                	mv	a0,s1
    8000651e:	ffffb097          	auipc	ra,0xffffb
    80006522:	358080e7          	jalr	856(ra) # 80001876 <wakeup>
    
    WriteReg(THR, c);
    80006526:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000652a:	6098                	ld	a4,0(s1)
    8000652c:	0009b783          	ld	a5,0(s3)
    80006530:	fce798e3          	bne	a5,a4,80006500 <uartstart+0x42>
  }
}
    80006534:	70e2                	ld	ra,56(sp)
    80006536:	7442                	ld	s0,48(sp)
    80006538:	74a2                	ld	s1,40(sp)
    8000653a:	7902                	ld	s2,32(sp)
    8000653c:	69e2                	ld	s3,24(sp)
    8000653e:	6a42                	ld	s4,16(sp)
    80006540:	6aa2                	ld	s5,8(sp)
    80006542:	6121                	addi	sp,sp,64
    80006544:	8082                	ret
    80006546:	8082                	ret

0000000080006548 <uartputc>:
{
    80006548:	7179                	addi	sp,sp,-48
    8000654a:	f406                	sd	ra,40(sp)
    8000654c:	f022                	sd	s0,32(sp)
    8000654e:	ec26                	sd	s1,24(sp)
    80006550:	e84a                	sd	s2,16(sp)
    80006552:	e44e                	sd	s3,8(sp)
    80006554:	e052                	sd	s4,0(sp)
    80006556:	1800                	addi	s0,sp,48
    80006558:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    8000655a:	00024517          	auipc	a0,0x24
    8000655e:	cee50513          	addi	a0,a0,-786 # 8002a248 <uart_tx_lock>
    80006562:	00000097          	auipc	ra,0x0
    80006566:	18e080e7          	jalr	398(ra) # 800066f0 <acquire>
  if(panicked){
    8000656a:	00003797          	auipc	a5,0x3
    8000656e:	ab27a783          	lw	a5,-1358(a5) # 8000901c <panicked>
    80006572:	c391                	beqz	a5,80006576 <uartputc+0x2e>
    for(;;)
    80006574:	a001                	j	80006574 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006576:	00003797          	auipc	a5,0x3
    8000657a:	ab27b783          	ld	a5,-1358(a5) # 80009028 <uart_tx_w>
    8000657e:	00003717          	auipc	a4,0x3
    80006582:	aa273703          	ld	a4,-1374(a4) # 80009020 <uart_tx_r>
    80006586:	02070713          	addi	a4,a4,32
    8000658a:	02f71b63          	bne	a4,a5,800065c0 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000658e:	00024a17          	auipc	s4,0x24
    80006592:	cbaa0a13          	addi	s4,s4,-838 # 8002a248 <uart_tx_lock>
    80006596:	00003497          	auipc	s1,0x3
    8000659a:	a8a48493          	addi	s1,s1,-1398 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000659e:	00003917          	auipc	s2,0x3
    800065a2:	a8a90913          	addi	s2,s2,-1398 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800065a6:	85d2                	mv	a1,s4
    800065a8:	8526                	mv	a0,s1
    800065aa:	ffffb097          	auipc	ra,0xffffb
    800065ae:	140080e7          	jalr	320(ra) # 800016ea <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800065b2:	00093783          	ld	a5,0(s2)
    800065b6:	6098                	ld	a4,0(s1)
    800065b8:	02070713          	addi	a4,a4,32
    800065bc:	fef705e3          	beq	a4,a5,800065a6 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800065c0:	00024497          	auipc	s1,0x24
    800065c4:	c8848493          	addi	s1,s1,-888 # 8002a248 <uart_tx_lock>
    800065c8:	01f7f713          	andi	a4,a5,31
    800065cc:	9726                	add	a4,a4,s1
    800065ce:	03370023          	sb	s3,32(a4)
      uart_tx_w += 1;
    800065d2:	0785                	addi	a5,a5,1
    800065d4:	00003717          	auipc	a4,0x3
    800065d8:	a4f73a23          	sd	a5,-1452(a4) # 80009028 <uart_tx_w>
      uartstart();
    800065dc:	00000097          	auipc	ra,0x0
    800065e0:	ee2080e7          	jalr	-286(ra) # 800064be <uartstart>
      release(&uart_tx_lock);
    800065e4:	8526                	mv	a0,s1
    800065e6:	00000097          	auipc	ra,0x0
    800065ea:	1da080e7          	jalr	474(ra) # 800067c0 <release>
}
    800065ee:	70a2                	ld	ra,40(sp)
    800065f0:	7402                	ld	s0,32(sp)
    800065f2:	64e2                	ld	s1,24(sp)
    800065f4:	6942                	ld	s2,16(sp)
    800065f6:	69a2                	ld	s3,8(sp)
    800065f8:	6a02                	ld	s4,0(sp)
    800065fa:	6145                	addi	sp,sp,48
    800065fc:	8082                	ret

00000000800065fe <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800065fe:	1141                	addi	sp,sp,-16
    80006600:	e422                	sd	s0,8(sp)
    80006602:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006604:	100007b7          	lui	a5,0x10000
    80006608:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000660c:	8b85                	andi	a5,a5,1
    8000660e:	cb91                	beqz	a5,80006622 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006610:	100007b7          	lui	a5,0x10000
    80006614:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80006618:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000661c:	6422                	ld	s0,8(sp)
    8000661e:	0141                	addi	sp,sp,16
    80006620:	8082                	ret
    return -1;
    80006622:	557d                	li	a0,-1
    80006624:	bfe5                	j	8000661c <uartgetc+0x1e>

0000000080006626 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006626:	1101                	addi	sp,sp,-32
    80006628:	ec06                	sd	ra,24(sp)
    8000662a:	e822                	sd	s0,16(sp)
    8000662c:	e426                	sd	s1,8(sp)
    8000662e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006630:	54fd                	li	s1,-1
    int c = uartgetc();
    80006632:	00000097          	auipc	ra,0x0
    80006636:	fcc080e7          	jalr	-52(ra) # 800065fe <uartgetc>
    if(c == -1)
    8000663a:	00950763          	beq	a0,s1,80006648 <uartintr+0x22>
      break;
    consoleintr(c);
    8000663e:	00000097          	auipc	ra,0x0
    80006642:	8fe080e7          	jalr	-1794(ra) # 80005f3c <consoleintr>
  while(1){
    80006646:	b7f5                	j	80006632 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006648:	00024497          	auipc	s1,0x24
    8000664c:	c0048493          	addi	s1,s1,-1024 # 8002a248 <uart_tx_lock>
    80006650:	8526                	mv	a0,s1
    80006652:	00000097          	auipc	ra,0x0
    80006656:	09e080e7          	jalr	158(ra) # 800066f0 <acquire>
  uartstart();
    8000665a:	00000097          	auipc	ra,0x0
    8000665e:	e64080e7          	jalr	-412(ra) # 800064be <uartstart>
  release(&uart_tx_lock);
    80006662:	8526                	mv	a0,s1
    80006664:	00000097          	auipc	ra,0x0
    80006668:	15c080e7          	jalr	348(ra) # 800067c0 <release>
}
    8000666c:	60e2                	ld	ra,24(sp)
    8000666e:	6442                	ld	s0,16(sp)
    80006670:	64a2                	ld	s1,8(sp)
    80006672:	6105                	addi	sp,sp,32
    80006674:	8082                	ret

0000000080006676 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006676:	411c                	lw	a5,0(a0)
    80006678:	e399                	bnez	a5,8000667e <holding+0x8>
    8000667a:	4501                	li	a0,0
  return r;
}
    8000667c:	8082                	ret
{
    8000667e:	1101                	addi	sp,sp,-32
    80006680:	ec06                	sd	ra,24(sp)
    80006682:	e822                	sd	s0,16(sp)
    80006684:	e426                	sd	s1,8(sp)
    80006686:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006688:	6904                	ld	s1,16(a0)
    8000668a:	ffffb097          	auipc	ra,0xffffb
    8000668e:	988080e7          	jalr	-1656(ra) # 80001012 <mycpu>
    80006692:	40a48533          	sub	a0,s1,a0
    80006696:	00153513          	seqz	a0,a0
}
    8000669a:	60e2                	ld	ra,24(sp)
    8000669c:	6442                	ld	s0,16(sp)
    8000669e:	64a2                	ld	s1,8(sp)
    800066a0:	6105                	addi	sp,sp,32
    800066a2:	8082                	ret

00000000800066a4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800066a4:	1101                	addi	sp,sp,-32
    800066a6:	ec06                	sd	ra,24(sp)
    800066a8:	e822                	sd	s0,16(sp)
    800066aa:	e426                	sd	s1,8(sp)
    800066ac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066ae:	100024f3          	csrr	s1,sstatus
    800066b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800066b6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066b8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800066bc:	ffffb097          	auipc	ra,0xffffb
    800066c0:	956080e7          	jalr	-1706(ra) # 80001012 <mycpu>
    800066c4:	5d3c                	lw	a5,120(a0)
    800066c6:	cf89                	beqz	a5,800066e0 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800066c8:	ffffb097          	auipc	ra,0xffffb
    800066cc:	94a080e7          	jalr	-1718(ra) # 80001012 <mycpu>
    800066d0:	5d3c                	lw	a5,120(a0)
    800066d2:	2785                	addiw	a5,a5,1
    800066d4:	dd3c                	sw	a5,120(a0)
}
    800066d6:	60e2                	ld	ra,24(sp)
    800066d8:	6442                	ld	s0,16(sp)
    800066da:	64a2                	ld	s1,8(sp)
    800066dc:	6105                	addi	sp,sp,32
    800066de:	8082                	ret
    mycpu()->intena = old;
    800066e0:	ffffb097          	auipc	ra,0xffffb
    800066e4:	932080e7          	jalr	-1742(ra) # 80001012 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800066e8:	8085                	srli	s1,s1,0x1
    800066ea:	8885                	andi	s1,s1,1
    800066ec:	dd64                	sw	s1,124(a0)
    800066ee:	bfe9                	j	800066c8 <push_off+0x24>

00000000800066f0 <acquire>:
{
    800066f0:	1101                	addi	sp,sp,-32
    800066f2:	ec06                	sd	ra,24(sp)
    800066f4:	e822                	sd	s0,16(sp)
    800066f6:	e426                	sd	s1,8(sp)
    800066f8:	1000                	addi	s0,sp,32
    800066fa:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800066fc:	00000097          	auipc	ra,0x0
    80006700:	fa8080e7          	jalr	-88(ra) # 800066a4 <push_off>
  if(holding(lk))
    80006704:	8526                	mv	a0,s1
    80006706:	00000097          	auipc	ra,0x0
    8000670a:	f70080e7          	jalr	-144(ra) # 80006676 <holding>
    8000670e:	e911                	bnez	a0,80006722 <acquire+0x32>
    __sync_fetch_and_add(&(lk->n), 1);
    80006710:	4785                	li	a5,1
    80006712:	01c48713          	addi	a4,s1,28
    80006716:	0f50000f          	fence	iorw,ow
    8000671a:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000671e:	4705                	li	a4,1
    80006720:	a839                	j	8000673e <acquire+0x4e>
    panic("acquire");
    80006722:	00002517          	auipc	a0,0x2
    80006726:	0de50513          	addi	a0,a0,222 # 80008800 <digits+0x20>
    8000672a:	00000097          	auipc	ra,0x0
    8000672e:	a92080e7          	jalr	-1390(ra) # 800061bc <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80006732:	01848793          	addi	a5,s1,24
    80006736:	0f50000f          	fence	iorw,ow
    8000673a:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    8000673e:	87ba                	mv	a5,a4
    80006740:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006744:	2781                	sext.w	a5,a5
    80006746:	f7f5                	bnez	a5,80006732 <acquire+0x42>
  __sync_synchronize();
    80006748:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000674c:	ffffb097          	auipc	ra,0xffffb
    80006750:	8c6080e7          	jalr	-1850(ra) # 80001012 <mycpu>
    80006754:	e888                	sd	a0,16(s1)
}
    80006756:	60e2                	ld	ra,24(sp)
    80006758:	6442                	ld	s0,16(sp)
    8000675a:	64a2                	ld	s1,8(sp)
    8000675c:	6105                	addi	sp,sp,32
    8000675e:	8082                	ret

0000000080006760 <pop_off>:

void
pop_off(void)
{
    80006760:	1141                	addi	sp,sp,-16
    80006762:	e406                	sd	ra,8(sp)
    80006764:	e022                	sd	s0,0(sp)
    80006766:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006768:	ffffb097          	auipc	ra,0xffffb
    8000676c:	8aa080e7          	jalr	-1878(ra) # 80001012 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006770:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006774:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006776:	e78d                	bnez	a5,800067a0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006778:	5d3c                	lw	a5,120(a0)
    8000677a:	02f05b63          	blez	a5,800067b0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000677e:	37fd                	addiw	a5,a5,-1
    80006780:	0007871b          	sext.w	a4,a5
    80006784:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006786:	eb09                	bnez	a4,80006798 <pop_off+0x38>
    80006788:	5d7c                	lw	a5,124(a0)
    8000678a:	c799                	beqz	a5,80006798 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000678c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006790:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006794:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006798:	60a2                	ld	ra,8(sp)
    8000679a:	6402                	ld	s0,0(sp)
    8000679c:	0141                	addi	sp,sp,16
    8000679e:	8082                	ret
    panic("pop_off - interruptible");
    800067a0:	00002517          	auipc	a0,0x2
    800067a4:	06850513          	addi	a0,a0,104 # 80008808 <digits+0x28>
    800067a8:	00000097          	auipc	ra,0x0
    800067ac:	a14080e7          	jalr	-1516(ra) # 800061bc <panic>
    panic("pop_off");
    800067b0:	00002517          	auipc	a0,0x2
    800067b4:	07050513          	addi	a0,a0,112 # 80008820 <digits+0x40>
    800067b8:	00000097          	auipc	ra,0x0
    800067bc:	a04080e7          	jalr	-1532(ra) # 800061bc <panic>

00000000800067c0 <release>:
{
    800067c0:	1101                	addi	sp,sp,-32
    800067c2:	ec06                	sd	ra,24(sp)
    800067c4:	e822                	sd	s0,16(sp)
    800067c6:	e426                	sd	s1,8(sp)
    800067c8:	1000                	addi	s0,sp,32
    800067ca:	84aa                	mv	s1,a0
  if(!holding(lk))
    800067cc:	00000097          	auipc	ra,0x0
    800067d0:	eaa080e7          	jalr	-342(ra) # 80006676 <holding>
    800067d4:	c115                	beqz	a0,800067f8 <release+0x38>
  lk->cpu = 0;
    800067d6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800067da:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800067de:	0f50000f          	fence	iorw,ow
    800067e2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800067e6:	00000097          	auipc	ra,0x0
    800067ea:	f7a080e7          	jalr	-134(ra) # 80006760 <pop_off>
}
    800067ee:	60e2                	ld	ra,24(sp)
    800067f0:	6442                	ld	s0,16(sp)
    800067f2:	64a2                	ld	s1,8(sp)
    800067f4:	6105                	addi	sp,sp,32
    800067f6:	8082                	ret
    panic("release");
    800067f8:	00002517          	auipc	a0,0x2
    800067fc:	03050513          	addi	a0,a0,48 # 80008828 <digits+0x48>
    80006800:	00000097          	auipc	ra,0x0
    80006804:	9bc080e7          	jalr	-1604(ra) # 800061bc <panic>

0000000080006808 <freelock>:
{
    80006808:	1101                	addi	sp,sp,-32
    8000680a:	ec06                	sd	ra,24(sp)
    8000680c:	e822                	sd	s0,16(sp)
    8000680e:	e426                	sd	s1,8(sp)
    80006810:	1000                	addi	s0,sp,32
    80006812:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80006814:	00024517          	auipc	a0,0x24
    80006818:	a7450513          	addi	a0,a0,-1420 # 8002a288 <lock_locks>
    8000681c:	00000097          	auipc	ra,0x0
    80006820:	ed4080e7          	jalr	-300(ra) # 800066f0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80006824:	00024717          	auipc	a4,0x24
    80006828:	a8470713          	addi	a4,a4,-1404 # 8002a2a8 <locks>
    8000682c:	4781                	li	a5,0
    8000682e:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80006832:	6314                	ld	a3,0(a4)
    80006834:	00968763          	beq	a3,s1,80006842 <freelock+0x3a>
  for (i = 0; i < NLOCK; i++) {
    80006838:	2785                	addiw	a5,a5,1
    8000683a:	0721                	addi	a4,a4,8
    8000683c:	fec79be3          	bne	a5,a2,80006832 <freelock+0x2a>
    80006840:	a809                	j	80006852 <freelock+0x4a>
      locks[i] = 0;
    80006842:	078e                	slli	a5,a5,0x3
    80006844:	00024717          	auipc	a4,0x24
    80006848:	a6470713          	addi	a4,a4,-1436 # 8002a2a8 <locks>
    8000684c:	97ba                	add	a5,a5,a4
    8000684e:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80006852:	00024517          	auipc	a0,0x24
    80006856:	a3650513          	addi	a0,a0,-1482 # 8002a288 <lock_locks>
    8000685a:	00000097          	auipc	ra,0x0
    8000685e:	f66080e7          	jalr	-154(ra) # 800067c0 <release>
}
    80006862:	60e2                	ld	ra,24(sp)
    80006864:	6442                	ld	s0,16(sp)
    80006866:	64a2                	ld	s1,8(sp)
    80006868:	6105                	addi	sp,sp,32
    8000686a:	8082                	ret

000000008000686c <initlock>:
{
    8000686c:	1101                	addi	sp,sp,-32
    8000686e:	ec06                	sd	ra,24(sp)
    80006870:	e822                	sd	s0,16(sp)
    80006872:	e426                	sd	s1,8(sp)
    80006874:	1000                	addi	s0,sp,32
    80006876:	84aa                	mv	s1,a0
  lk->name = name;
    80006878:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000687a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000687e:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80006882:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80006886:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    8000688a:	00024517          	auipc	a0,0x24
    8000688e:	9fe50513          	addi	a0,a0,-1538 # 8002a288 <lock_locks>
    80006892:	00000097          	auipc	ra,0x0
    80006896:	e5e080e7          	jalr	-418(ra) # 800066f0 <acquire>
  for (i = 0; i < NLOCK; i++) {
    8000689a:	00024717          	auipc	a4,0x24
    8000689e:	a0e70713          	addi	a4,a4,-1522 # 8002a2a8 <locks>
    800068a2:	4781                	li	a5,0
    800068a4:	1f400693          	li	a3,500
    if(locks[i] == 0) {
    800068a8:	6310                	ld	a2,0(a4)
    800068aa:	ce09                	beqz	a2,800068c4 <initlock+0x58>
  for (i = 0; i < NLOCK; i++) {
    800068ac:	2785                	addiw	a5,a5,1
    800068ae:	0721                	addi	a4,a4,8
    800068b0:	fed79ce3          	bne	a5,a3,800068a8 <initlock+0x3c>
  panic("findslot");
    800068b4:	00002517          	auipc	a0,0x2
    800068b8:	f7c50513          	addi	a0,a0,-132 # 80008830 <digits+0x50>
    800068bc:	00000097          	auipc	ra,0x0
    800068c0:	900080e7          	jalr	-1792(ra) # 800061bc <panic>
      locks[i] = lk;
    800068c4:	078e                	slli	a5,a5,0x3
    800068c6:	00024717          	auipc	a4,0x24
    800068ca:	9e270713          	addi	a4,a4,-1566 # 8002a2a8 <locks>
    800068ce:	97ba                	add	a5,a5,a4
    800068d0:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    800068d2:	00024517          	auipc	a0,0x24
    800068d6:	9b650513          	addi	a0,a0,-1610 # 8002a288 <lock_locks>
    800068da:	00000097          	auipc	ra,0x0
    800068de:	ee6080e7          	jalr	-282(ra) # 800067c0 <release>
}
    800068e2:	60e2                	ld	ra,24(sp)
    800068e4:	6442                	ld	s0,16(sp)
    800068e6:	64a2                	ld	s1,8(sp)
    800068e8:	6105                	addi	sp,sp,32
    800068ea:	8082                	ret

00000000800068ec <lockfree_read8>:

// Read a shared 64-bit value without holding a lock
uint64
lockfree_read8(uint64 *addr) {
    800068ec:	1141                	addi	sp,sp,-16
    800068ee:	e422                	sd	s0,8(sp)
    800068f0:	0800                	addi	s0,sp,16
  uint64 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    800068f2:	0ff0000f          	fence
    800068f6:	6108                	ld	a0,0(a0)
    800068f8:	0ff0000f          	fence
  return val;
}
    800068fc:	6422                	ld	s0,8(sp)
    800068fe:	0141                	addi	sp,sp,16
    80006900:	8082                	ret

0000000080006902 <lockfree_read4>:

// Read a shared 32-bit value without holding a lock
int
lockfree_read4(int *addr) {
    80006902:	1141                	addi	sp,sp,-16
    80006904:	e422                	sd	s0,8(sp)
    80006906:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006908:	0ff0000f          	fence
    8000690c:	4108                	lw	a0,0(a0)
    8000690e:	0ff0000f          	fence
  return val;
}
    80006912:	2501                	sext.w	a0,a0
    80006914:	6422                	ld	s0,8(sp)
    80006916:	0141                	addi	sp,sp,16
    80006918:	8082                	ret

000000008000691a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000691a:	4e5c                	lw	a5,28(a2)
    8000691c:	00f04463          	bgtz	a5,80006924 <snprint_lock+0xa>
  int n = 0;
    80006920:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006922:	8082                	ret
{
    80006924:	1141                	addi	sp,sp,-16
    80006926:	e406                	sd	ra,8(sp)
    80006928:	e022                	sd	s0,0(sp)
    8000692a:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000692c:	4e18                	lw	a4,24(a2)
    8000692e:	6614                	ld	a3,8(a2)
    80006930:	00002617          	auipc	a2,0x2
    80006934:	f1060613          	addi	a2,a2,-240 # 80008840 <digits+0x60>
    80006938:	fffff097          	auipc	ra,0xfffff
    8000693c:	1ea080e7          	jalr	490(ra) # 80005b22 <snprintf>
}
    80006940:	60a2                	ld	ra,8(sp)
    80006942:	6402                	ld	s0,0(sp)
    80006944:	0141                	addi	sp,sp,16
    80006946:	8082                	ret

0000000080006948 <statslock>:

int
statslock(char *buf, int sz) {
    80006948:	7159                	addi	sp,sp,-112
    8000694a:	f486                	sd	ra,104(sp)
    8000694c:	f0a2                	sd	s0,96(sp)
    8000694e:	eca6                	sd	s1,88(sp)
    80006950:	e8ca                	sd	s2,80(sp)
    80006952:	e4ce                	sd	s3,72(sp)
    80006954:	e0d2                	sd	s4,64(sp)
    80006956:	fc56                	sd	s5,56(sp)
    80006958:	f85a                	sd	s6,48(sp)
    8000695a:	f45e                	sd	s7,40(sp)
    8000695c:	f062                	sd	s8,32(sp)
    8000695e:	ec66                	sd	s9,24(sp)
    80006960:	e86a                	sd	s10,16(sp)
    80006962:	e46e                	sd	s11,8(sp)
    80006964:	1880                	addi	s0,sp,112
    80006966:	8aaa                	mv	s5,a0
    80006968:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    8000696a:	00024517          	auipc	a0,0x24
    8000696e:	91e50513          	addi	a0,a0,-1762 # 8002a288 <lock_locks>
    80006972:	00000097          	auipc	ra,0x0
    80006976:	d7e080e7          	jalr	-642(ra) # 800066f0 <acquire>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    8000697a:	00002617          	auipc	a2,0x2
    8000697e:	ef660613          	addi	a2,a2,-266 # 80008870 <digits+0x90>
    80006982:	85da                	mv	a1,s6
    80006984:	8556                	mv	a0,s5
    80006986:	fffff097          	auipc	ra,0xfffff
    8000698a:	19c080e7          	jalr	412(ra) # 80005b22 <snprintf>
    8000698e:	892a                	mv	s2,a0
  for(int i = 0; i < NLOCK; i++) {
    80006990:	00024c97          	auipc	s9,0x24
    80006994:	918c8c93          	addi	s9,s9,-1768 # 8002a2a8 <locks>
    80006998:	00025c17          	auipc	s8,0x25
    8000699c:	8b0c0c13          	addi	s8,s8,-1872 # 8002b248 <end>
  n = snprintf(buf, sz, "--- lock kmem/bcache stats\n");
    800069a0:	84e6                	mv	s1,s9
  int tot = 0;
    800069a2:	4a01                	li	s4,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069a4:	00002b97          	auipc	s7,0x2
    800069a8:	ad4b8b93          	addi	s7,s7,-1324 # 80008478 <syscalls+0xb0>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800069ac:	00001d17          	auipc	s10,0x1
    800069b0:	66cd0d13          	addi	s10,s10,1644 # 80008018 <etext+0x18>
    800069b4:	a01d                	j	800069da <statslock+0x92>
      tot += locks[i]->nts;
    800069b6:	0009b603          	ld	a2,0(s3)
    800069ba:	4e1c                	lw	a5,24(a2)
    800069bc:	01478a3b          	addw	s4,a5,s4
      n += snprint_lock(buf +n, sz-n, locks[i]);
    800069c0:	412b05bb          	subw	a1,s6,s2
    800069c4:	012a8533          	add	a0,s5,s2
    800069c8:	00000097          	auipc	ra,0x0
    800069cc:	f52080e7          	jalr	-174(ra) # 8000691a <snprint_lock>
    800069d0:	0125093b          	addw	s2,a0,s2
  for(int i = 0; i < NLOCK; i++) {
    800069d4:	04a1                	addi	s1,s1,8
    800069d6:	05848763          	beq	s1,s8,80006a24 <statslock+0xdc>
    if(locks[i] == 0)
    800069da:	89a6                	mv	s3,s1
    800069dc:	609c                	ld	a5,0(s1)
    800069de:	c3b9                	beqz	a5,80006a24 <statslock+0xdc>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    800069e0:	0087bd83          	ld	s11,8(a5)
    800069e4:	855e                	mv	a0,s7
    800069e6:	ffffa097          	auipc	ra,0xffffa
    800069ea:	aec080e7          	jalr	-1300(ra) # 800004d2 <strlen>
    800069ee:	0005061b          	sext.w	a2,a0
    800069f2:	85de                	mv	a1,s7
    800069f4:	856e                	mv	a0,s11
    800069f6:	ffffa097          	auipc	ra,0xffffa
    800069fa:	a30080e7          	jalr	-1488(ra) # 80000426 <strncmp>
    800069fe:	dd45                	beqz	a0,800069b6 <statslock+0x6e>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006a00:	609c                	ld	a5,0(s1)
    80006a02:	0087bd83          	ld	s11,8(a5)
    80006a06:	856a                	mv	a0,s10
    80006a08:	ffffa097          	auipc	ra,0xffffa
    80006a0c:	aca080e7          	jalr	-1334(ra) # 800004d2 <strlen>
    80006a10:	0005061b          	sext.w	a2,a0
    80006a14:	85ea                	mv	a1,s10
    80006a16:	856e                	mv	a0,s11
    80006a18:	ffffa097          	auipc	ra,0xffffa
    80006a1c:	a0e080e7          	jalr	-1522(ra) # 80000426 <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80006a20:	f955                	bnez	a0,800069d4 <statslock+0x8c>
    80006a22:	bf51                	j	800069b6 <statslock+0x6e>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    80006a24:	00002617          	auipc	a2,0x2
    80006a28:	e6c60613          	addi	a2,a2,-404 # 80008890 <digits+0xb0>
    80006a2c:	412b05bb          	subw	a1,s6,s2
    80006a30:	012a8533          	add	a0,s5,s2
    80006a34:	fffff097          	auipc	ra,0xfffff
    80006a38:	0ee080e7          	jalr	238(ra) # 80005b22 <snprintf>
    80006a3c:	012509bb          	addw	s3,a0,s2
    80006a40:	4b95                	li	s7,5
  int last = 100000000;
    80006a42:	05f5e537          	lui	a0,0x5f5e
    80006a46:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80006a4a:	4c01                	li	s8,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a4c:	00024497          	auipc	s1,0x24
    80006a50:	85c48493          	addi	s1,s1,-1956 # 8002a2a8 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006a54:	1f400913          	li	s2,500
    80006a58:	a881                	j	80006aa8 <statslock+0x160>
    80006a5a:	2705                	addiw	a4,a4,1
    80006a5c:	06a1                	addi	a3,a3,8
    80006a5e:	03270063          	beq	a4,s2,80006a7e <statslock+0x136>
      if(locks[i] == 0)
    80006a62:	629c                	ld	a5,0(a3)
    80006a64:	cf89                	beqz	a5,80006a7e <statslock+0x136>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006a66:	4f90                	lw	a2,24(a5)
    80006a68:	00359793          	slli	a5,a1,0x3
    80006a6c:	97a6                	add	a5,a5,s1
    80006a6e:	639c                	ld	a5,0(a5)
    80006a70:	4f9c                	lw	a5,24(a5)
    80006a72:	fec7d4e3          	bge	a5,a2,80006a5a <statslock+0x112>
    80006a76:	fea652e3          	bge	a2,a0,80006a5a <statslock+0x112>
    80006a7a:	85ba                	mv	a1,a4
    80006a7c:	bff9                	j	80006a5a <statslock+0x112>
        top = i;
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    80006a7e:	058e                	slli	a1,a1,0x3
    80006a80:	00b48d33          	add	s10,s1,a1
    80006a84:	000d3603          	ld	a2,0(s10)
    80006a88:	413b05bb          	subw	a1,s6,s3
    80006a8c:	013a8533          	add	a0,s5,s3
    80006a90:	00000097          	auipc	ra,0x0
    80006a94:	e8a080e7          	jalr	-374(ra) # 8000691a <snprint_lock>
    80006a98:	013509bb          	addw	s3,a0,s3
    last = locks[top]->nts;
    80006a9c:	000d3783          	ld	a5,0(s10)
    80006aa0:	4f88                	lw	a0,24(a5)
  for(int t = 0; t < 5; t++) {
    80006aa2:	3bfd                	addiw	s7,s7,-1
    80006aa4:	000b8663          	beqz	s7,80006ab0 <statslock+0x168>
  int tot = 0;
    80006aa8:	86e6                	mv	a3,s9
    for(int i = 0; i < NLOCK; i++) {
    80006aaa:	8762                	mv	a4,s8
    int top = 0;
    80006aac:	85e2                	mv	a1,s8
    80006aae:	bf55                	j	80006a62 <statslock+0x11a>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006ab0:	86d2                	mv	a3,s4
    80006ab2:	00002617          	auipc	a2,0x2
    80006ab6:	dfe60613          	addi	a2,a2,-514 # 800088b0 <digits+0xd0>
    80006aba:	413b05bb          	subw	a1,s6,s3
    80006abe:	013a8533          	add	a0,s5,s3
    80006ac2:	fffff097          	auipc	ra,0xfffff
    80006ac6:	060080e7          	jalr	96(ra) # 80005b22 <snprintf>
    80006aca:	013509bb          	addw	s3,a0,s3
  release(&lock_locks);  
    80006ace:	00023517          	auipc	a0,0x23
    80006ad2:	7ba50513          	addi	a0,a0,1978 # 8002a288 <lock_locks>
    80006ad6:	00000097          	auipc	ra,0x0
    80006ada:	cea080e7          	jalr	-790(ra) # 800067c0 <release>
  return n;
}
    80006ade:	854e                	mv	a0,s3
    80006ae0:	70a6                	ld	ra,104(sp)
    80006ae2:	7406                	ld	s0,96(sp)
    80006ae4:	64e6                	ld	s1,88(sp)
    80006ae6:	6946                	ld	s2,80(sp)
    80006ae8:	69a6                	ld	s3,72(sp)
    80006aea:	6a06                	ld	s4,64(sp)
    80006aec:	7ae2                	ld	s5,56(sp)
    80006aee:	7b42                	ld	s6,48(sp)
    80006af0:	7ba2                	ld	s7,40(sp)
    80006af2:	7c02                	ld	s8,32(sp)
    80006af4:	6ce2                	ld	s9,24(sp)
    80006af6:	6d42                	ld	s10,16(sp)
    80006af8:	6da2                	ld	s11,8(sp)
    80006afa:	6165                	addi	sp,sp,112
    80006afc:	8082                	ret
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
