
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 7c 10 80       	push   $0x80107c20
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 31 4c 00 00       	call   80104c90 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 7c 10 80       	push   $0x80107c27
80100097:	50                   	push   %eax
80100098:	e8 b3 4a 00 00       	call   80104b50 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 23 4d 00 00       	call   80104e10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 69 4d 00 00       	call   80104ed0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 4a 00 00       	call   80104b90 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 7c 10 80       	push   $0x80107c2e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 69 4a 00 00       	call   80104c30 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 7c 10 80       	push   $0x80107c3f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 28 4a 00 00       	call   80104c30 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 d8 49 00 00       	call   80104bf0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 ec 4b 00 00       	call   80104e10 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 5b 4c 00 00       	jmp    80104ed0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 7c 10 80       	push   $0x80107c46
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 5a 4b 00 00       	call   80104e10 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 e6 38 00 00       	call   80103bd0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 11 37 00 00       	call   80103a10 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 bd 4b 00 00       	call   80104ed0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 66 4b 00 00       	call   80104ed0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 7c 10 80       	push   $0x80107c4d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 f3 86 10 80 	movl   $0x801086f3,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 cf 48 00 00       	call   80104cb0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 7c 10 80       	push   $0x80107c61
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 11 63 00 00       	call   80106740 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 26 62 00 00       	call   80106740 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 1a 62 00 00       	call   80106740 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 0e 62 00 00       	call   80106740 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 5a 4a 00 00       	call   80104fc0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 49 00 00       	call   80104f20 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 65 7c 10 80       	push   $0x80107c65
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 90 7c 10 80 	movzbl -0x7fef8370(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 ac 47 00 00       	call   80104e10 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 34 48 00 00       	call   80104ed0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 78 7c 10 80       	mov    $0x80107c78,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 4e 46 00 00       	call   80104e10 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 a3 46 00 00       	call   80104ed0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 7f 7c 10 80       	push   $0x80107c7f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 94 45 00 00       	call   80104e10 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010096f:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100985:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 fc 44 00 00       	call   80104ed0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 8c 33 00 00       	jmp    80103d90 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100a1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100a20:	e8 cb 38 00 00       	call   801042f0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 88 7c 10 80       	push   $0x80107c88
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 47 42 00 00       	call   80104c90 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 19 11 80 40 	movl   $0x80100640,0x8011198c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 19 11 80 90 	movl   $0x80100290,0x80111988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 7b 2f 00 00       	call   80103a10 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 9f 6d 00 00       	call   801078b0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 58 6b 00 00       	call   801076d0 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 52 6a 00 00       	call   80107600 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 40 6c 00 00       	call   80107830 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 99 6a 00 00       	call   801076d0 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 f8 6c 00 00       	call   80107950 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 78 44 00 00       	call   80105120 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 65 44 00 00       	call   80105120 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 e4 6d 00 00       	call   80107ab0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 4a 6b 00 00       	call   80107830 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 78 6d 00 00       	call   80107ab0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 6a 43 00 00       	call   801050e0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 ce 66 00 00       	call   80107470 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 86 6a 00 00       	call   80107830 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 a1 7c 10 80       	push   $0x80107ca1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 ad 7c 10 80       	push   $0x80107cad
80100def:	68 e0 0f 11 80       	push   $0x80110fe0
80100df4:	e8 97 3e 00 00       	call   80104c90 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 e0 0f 11 80       	push   $0x80110fe0
80100e15:	e8 f6 3f 00 00       	call   80104e10 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e41:	e8 8a 40 00 00       	call   80104ed0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 e0 0f 11 80       	push   $0x80110fe0
80100e5a:	e8 71 40 00 00       	call   80104ed0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 e0 0f 11 80       	push   $0x80110fe0
80100e83:	e8 88 3f 00 00       	call   80104e10 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea0:	e8 2b 40 00 00       	call   80104ed0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 b4 7c 10 80       	push   $0x80107cb4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 e0 0f 11 80       	push   $0x80110fe0
80100ed5:	e8 36 3f 00 00       	call   80104e10 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 bb 3f 00 00       	call   80104ed0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 8d 3f 00 00       	jmp    80104ed0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 bc 7c 10 80       	push   $0x80107cbc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 c6 7c 10 80       	push   $0x80107cc6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 cf 7c 10 80       	push   $0x80107ccf
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 d5 7c 10 80       	push   $0x80107cd5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 f8 19 11 80    	add    0x801119f8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 df 7c 10 80       	push   $0x80107cdf
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 f2 7c 10 80       	push   $0x80107cf2
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 06 3c 00 00       	call   80104f20 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 00 1a 11 80       	push   $0x80111a00
8010135a:	e8 b1 3a 00 00       	call   80104e10 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 00 1a 11 80       	push   $0x80111a00
801013c7:	e8 04 3b 00 00       	call   80104ed0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 d6 3a 00 00       	call   80104ed0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 08 7d 10 80       	push   $0x80107d08
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 18 7d 10 80       	push   $0x80107d18
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 96 3a 00 00       	call   80104fc0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 2b 7d 10 80       	push   $0x80107d2b
80101555:	68 00 1a 11 80       	push   $0x80111a00
8010155a:	e8 31 37 00 00       	call   80104c90 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 32 7d 10 80       	push   $0x80107d32
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 d4 35 00 00       	call   80104b50 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 e0 19 11 80       	push   $0x801119e0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 f8 19 11 80    	pushl  0x801119f8
8010159d:	ff 35 f4 19 11 80    	pushl  0x801119f4
801015a3:	ff 35 f0 19 11 80    	pushl  0x801119f0
801015a9:	ff 35 ec 19 11 80    	pushl  0x801119ec
801015af:	ff 35 e8 19 11 80    	pushl  0x801119e8
801015b5:	ff 35 e4 19 11 80    	pushl  0x801119e4
801015bb:	ff 35 e0 19 11 80    	pushl  0x801119e0
801015c1:	68 98 7d 10 80       	push   $0x80107d98
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 bd 38 00 00       	call   80104f20 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 38 7d 10 80       	push   $0x80107d38
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 b6 38 00 00       	call   80104fc0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 00 1a 11 80       	push   $0x80111a00
80101743:	e8 c8 36 00 00       	call   80104e10 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101753:	e8 78 37 00 00       	call   80104ed0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 05 34 00 00       	call   80104b90 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 c3 37 00 00       	call   80104fc0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 50 7d 10 80       	push   $0x80107d50
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 4a 7d 10 80       	push   $0x80107d4a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 d4 33 00 00       	call   80104c30 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 78 33 00 00       	jmp    80104bf0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 5f 7d 10 80       	push   $0x80107d5f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 e7 32 00 00       	call   80104b90 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 2d 33 00 00       	call   80104bf0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ca:	e8 41 35 00 00       	call   80104e10 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 e7 35 00 00       	jmp    80104ed0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 00 1a 11 80       	push   $0x80111a00
801018f8:	e8 13 35 00 00       	call   80104e10 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101907:	e8 c4 35 00 00       	call   80104ed0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 b4 34 00 00       	call   80104fc0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 b8 33 00 00       	call   80104fc0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 89 33 00 00       	call   80105030 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 26 33 00 00       	call   80105030 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 79 7d 10 80       	push   $0x80107d79
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 67 7d 10 80       	push   $0x80107d67
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 81 1c 00 00       	call   80103a10 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 00 1a 11 80       	push   $0x80111a00
80101d9c:	e8 6f 30 00 00       	call   80104e10 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dac:	e8 1f 31 00 00       	call   80104ed0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 a4 31 00 00       	call   80104fc0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 18 31 00 00       	call   80104fc0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 a6 30 00 00       	call   80105080 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 88 7d 10 80       	push   $0x80107d88
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 be 84 10 80       	push   $0x801084be
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 f4 7d 10 80       	push   $0x80107df4
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 eb 7d 10 80       	push   $0x80107deb
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 06 7e 10 80       	push   $0x80107e06
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 27 2b 00 00       	call   80104c90 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 19 2c 00 00       	call   80104e10 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 9e 20 00 00       	call   801042f0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 60 2c 00 00       	call   80104ed0 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 99 29 00 00       	call   80104c30 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 3f 2b 00 00       	call   80104e10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 b2 18 00 00       	call   80103bd0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 95 2b 00 00       	jmp    80104ed0 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 35 7e 10 80       	push   $0x80107e35
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 20 7e 10 80       	push   $0x80107e20
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 0a 7e 10 80       	push   $0x80107e0a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 54 36 11 80    	mov    0x80113654,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 54 7e 10 80       	push   $0x80107e54
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb 48 6b 11 80    	cmp    $0x80116b48,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 75 2a 00 00       	call   80104f20 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 98 36 11 80       	mov    0x80113698,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801024c4:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 60 36 11 80       	push   $0x80113660
801024e0:	e8 2b 29 00 00       	call   80104e10 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 d0 29 00 00       	jmp    80104ed0 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 86 7e 10 80       	push   $0x80107e86
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 8c 7e 10 80       	push   $0x80107e8c
80102574:	68 60 36 11 80       	push   $0x80113660
80102579:	e8 12 27 00 00       	call   80104c90 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 94 36 11 80       	mov    0x80113694,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 60 36 11 80       	push   $0x80113660
80102663:	e8 a8 27 00 00       	call   80104e10 <acquire>
  r = kmem.freelist;
80102668:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010266d:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 60 36 11 80       	push   $0x80113660
80102691:	e8 3a 28 00 00       	call   80104ed0 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a c0 7f 10 80 	movzbl -0x7fef8040(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 c0 7e 10 80 	movzbl -0x7fef8140(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 a0 7e 10 80 	mov    -0x7fef8160(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a c0 7f 10 80 	movzbl -0x7fef8040(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 ac 24 00 00       	call   80104f70 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80102bd4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 c7 23 00 00       	call   80104fc0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102c3d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 c0 80 10 80       	push   $0x801080c0
80102ca3:	68 a0 36 11 80       	push   $0x801136a0
80102ca8:	e8 e3 1f 00 00       	call   80104c90 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102ccb:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 a0 36 11 80       	push   $0x801136a0
80102d3f:	e8 cc 20 00 00       	call   80104e10 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 a0 36 11 80       	push   $0x801136a0
80102d58:	68 a0 36 11 80       	push   $0x801136a0
80102d5d:	e8 6e 0e 00 00       	call   80103bd0 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d73:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102d8f:	68 a0 36 11 80       	push   $0x801136a0
80102d94:	e8 37 21 00 00       	call   80104ed0 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 a0 36 11 80       	push   $0x801136a0
80102db2:	e8 59 20 00 00       	call   80104e10 <acquire>
  log.outstanding -= 1;
80102db7:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102dbc:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 a0 36 11 80       	push   $0x801136a0
80102df0:	e8 db 20 00 00       	call   80104ed0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 a0 36 11 80       	push   $0x801136a0
80102e0a:	e8 01 20 00 00       	call   80104e10 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e16:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 cb 14 00 00       	call   801042f0 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e2c:	e8 9f 20 00 00       	call   80104ed0 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e64:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 37 21 00 00       	call   80104fc0 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 a0 36 11 80       	push   $0x801136a0
80102ed8:	e8 13 14 00 00       	call   801042f0 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102ee4:	e8 e7 1f 00 00       	call   80104ed0 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 c4 80 10 80       	push   $0x801080c4
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 a0 36 11 80       	push   $0x801136a0
80102f52:	e8 b9 1e 00 00       	call   80104e10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 36 1f 00 00       	jmp    80104ed0 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 d3 80 10 80       	push   $0x801080d3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 e9 80 10 80       	push   $0x801080e9
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 04 0a 00 00       	call   801039f0 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 fd 09 00 00       	call   801039f0 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 04 81 10 80       	push   $0x80108104
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 e9 32 00 00       	call   801062f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 74 09 00 00       	call   80103980 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 c1 17 00 00       	call   801047e0 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 21 44 00 00       	call   80107450 <switchkvm>
  seginit();
8010302f:	e8 8c 43 00 00       	call   801073c0 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 48 6b 11 80       	push   $0x80116b48
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 c6 48 00 00       	call   80107930 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 47 43 00 00       	call   801073c0 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 f3 35 00 00       	call   80106680 <uartinit>
  pinit();         // process table
8010308d:	e8 ce 08 00 00       	call   80103960 <pinit>
  tvinit();        // trap vectors
80103092:	e8 b9 31 00 00       	call   80106250 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 8c b4 10 80       	push   $0x8010b48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 03 1f 00 00       	call   80104fc0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801030c7:	00 00 00 
801030ca:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030cf:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 82 08 00 00       	call   80103980 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010311b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 f9 0d 00 00       	call   80103f60 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 18 81 10 80       	push   $0x80108118
801031a3:	56                   	push   %esi
801031a4:	e8 c7 1d 00 00       	call   80104f70 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 1d 81 10 80       	push   $0x8010811d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 08 1d 00 00       	call   80104f70 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 22 81 10 80       	push   $0x80108122
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 3c 81 10 80       	push   $0x8010813c
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 5b 81 10 80       	push   $0x8010815b
8010346c:	50                   	push   %eax
8010346d:	e8 1e 18 00 00       	call   80104c90 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 f8 18 00 00       	call   80104e10 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 b8 0d 00 00       	call   801042f0 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 73 19 00 00       	jmp    80104ed0 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 77 0d 00 00       	call   801042f0 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 47 19 00 00       	call   80104ed0 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 5a 18 00 00       	call   80104e10 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 13 04 00 00       	call   80103a10 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 e3 0c 00 00       	call   801042f0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 ba 05 00 00       	call   80103bd0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 8f 18 00 00       	call   80104ed0 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 61 0c 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 39 18 00 00       	call   80104ed0 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 51 17 00 00       	call   80104e10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 33 03 00 00       	call   80103a10 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 de 04 00 00       	call   80103bd0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 95 0b 00 00       	call   801042f0 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 6d 17 00 00       	call   80104ed0 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 52 17 00 00       	call   80104ed0 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 c0 3e 11 80       	push   $0x80113ec0
801037a1:	e8 6a 16 00 00       	call   80104e10 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801037b6:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
801037bc:	0f 84 a6 00 00 00    	je     80103868 <allocproc+0xd8>
    if(p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  p->queue_level = -1;
  p->priority = 0;
  p->inMoQ = 0;

  release(&ptable.lock);
801037ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->current_tick = 0;
801037d8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037df:	00 00 00 
  p->pid = nextpid++;
801037e2:	89 43 10             	mov    %eax,0x10(%ebx)
801037e5:	8d 50 01             	lea    0x1(%eax),%edx
  p->next = 0;
801037e8:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801037ef:	00 00 00 
  p->queue_level = -1;
801037f2:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801037f9:	ff ff ff 
  p->priority = 0;
801037fc:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->inMoQ = 0;
80103803:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010380a:	00 00 00 
  release(&ptable.lock);
8010380d:	68 c0 3e 11 80       	push   $0x80113ec0
  p->pid = nextpid++;
80103812:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103818:	e8 b3 16 00 00       	call   80104ed0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010381d:	e8 0e ee ff ff       	call   80102630 <kalloc>
80103822:	83 c4 10             	add    $0x10,%esp
80103825:	89 43 08             	mov    %eax,0x8(%ebx)
80103828:	85 c0                	test   %eax,%eax
8010382a:	74 55                	je     80103881 <allocproc+0xf1>
  }

  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010382c:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103832:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103835:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383a:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010383d:	c7 40 14 3b 62 10 80 	movl   $0x8010623b,0x14(%eax)
  p->context = (struct context*)sp;
80103844:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103847:	6a 14                	push   $0x14
80103849:	6a 00                	push   $0x0
8010384b:	50                   	push   %eax
8010384c:	e8 cf 16 00 00       	call   80104f20 <memset>
  p->context->eip = (uint)forkret;
80103851:	8b 43 1c             	mov    0x1c(%ebx),%eax
  

  return p;
80103854:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103857:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
8010385e:	89 d8                	mov    %ebx,%eax
80103860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103863:	c9                   	leave  
80103864:	c3                   	ret    
80103865:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010386b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010386d:	68 c0 3e 11 80       	push   $0x80113ec0
80103872:	e8 59 16 00 00       	call   80104ed0 <release>
}
80103877:	89 d8                	mov    %ebx,%eax
  return 0;
80103879:	83 c4 10             	add    $0x10,%esp
}
8010387c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387f:	c9                   	leave  
80103880:	c3                   	ret    
    p->state = UNUSED;
80103881:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103888:	31 db                	xor    %ebx,%ebx
}
8010388a:	89 d8                	mov    %ebx,%eax
8010388c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010388f:	c9                   	leave  
80103890:	c3                   	ret    
80103891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103898:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010389f:	90                   	nop

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038aa:	68 c0 3e 11 80       	push   $0x80113ec0
801038af:	e8 1c 16 00 00       	call   80104ed0 <release>

  if (first) {
801038b4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	85 c0                	test   %eax,%eax
801038be:	75 08                	jne    801038c8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038c0:	c9                   	leave  
801038c1:	c3                   	ret    
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038c8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038cf:	00 00 00 
    iinit(ROOTDEV);
801038d2:	83 ec 0c             	sub    $0xc,%esp
801038d5:	6a 01                	push   $0x1
801038d7:	e8 64 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038e3:	e8 a8 f3 ff ff       	call   80102c90 <initlog>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	c9                   	leave  
801038ec:	c3                   	ret    
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <printQueue>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	53                   	push   %ebx
801038f8:	83 ec 0c             	sub    $0xc,%esp
  cprintf("running L[%d]\n", Q.level);
801038fb:	ff 75 18             	pushl  0x18(%ebp)
{
801038fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("running L[%d]\n", Q.level);
80103901:	68 60 81 10 80       	push   $0x80108160
80103906:	e8 a5 cd ff ff       	call   801006b0 <cprintf>
  cprintf("Queue head proc: %d\n", Q.head->pid);
8010390b:	58                   	pop    %eax
8010390c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010390f:	5a                   	pop    %edx
80103910:	ff 70 10             	pushl  0x10(%eax)
80103913:	68 6f 81 10 80       	push   $0x8010816f
80103918:	e8 93 cd ff ff       	call   801006b0 <cprintf>
  cprintf("**process pid: %d**\n", process->pid);
8010391d:	59                   	pop    %ecx
8010391e:	58                   	pop    %eax
8010391f:	ff 73 10             	pushl  0x10(%ebx)
80103922:	68 84 81 10 80       	push   $0x80108184
80103927:	e8 84 cd ff ff       	call   801006b0 <cprintf>
  cprintf("time quantum: %d\n", process->current_tick);
8010392c:	58                   	pop    %eax
8010392d:	5a                   	pop    %edx
8010392e:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
80103934:	68 99 81 10 80       	push   $0x80108199
80103939:	e8 72 cd ff ff       	call   801006b0 <cprintf>
  cprintf("\n");
8010393e:	c7 45 08 f3 86 10 80 	movl   $0x801086f3,0x8(%ebp)
}
80103945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  cprintf("\n");
80103948:	83 c4 10             	add    $0x10,%esp
}
8010394b:	c9                   	leave  
  cprintf("\n");
8010394c:	e9 5f cd ff ff       	jmp    801006b0 <cprintf>
80103951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395f:	90                   	nop

80103960 <pinit>:
{
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010396a:	68 ab 81 10 80       	push   $0x801081ab
8010396f:	68 c0 3e 11 80       	push   $0x80113ec0
80103974:	e8 17 13 00 00       	call   80104c90 <initlock>
}
80103979:	83 c4 10             	add    $0x10,%esp
8010397c:	c9                   	leave  
8010397d:	c3                   	ret    
8010397e:	66 90                	xchg   %ax,%ax

80103980 <mycpu>:
{
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	56                   	push   %esi
80103988:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103989:	9c                   	pushf  
8010398a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010398b:	f6 c4 02             	test   $0x2,%ah
8010398e:	75 4a                	jne    801039da <mycpu+0x5a>
  apicid = lapicid();
80103990:	e8 0b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103995:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
  apicid = lapicid();
8010399b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010399d:	85 f6                	test   %esi,%esi
8010399f:	7e 2c                	jle    801039cd <mycpu+0x4d>
801039a1:	31 d2                	xor    %edx,%edx
801039a3:	eb 0a                	jmp    801039af <mycpu+0x2f>
801039a5:	8d 76 00             	lea    0x0(%esi),%esi
801039a8:	83 c2 01             	add    $0x1,%edx
801039ab:	39 f2                	cmp    %esi,%edx
801039ad:	74 1e                	je     801039cd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801039af:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039b5:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
801039bc:	39 d8                	cmp    %ebx,%eax
801039be:	75 e8                	jne    801039a8 <mycpu+0x28>
}
801039c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039c3:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
801039c9:	5b                   	pop    %ebx
801039ca:	5e                   	pop    %esi
801039cb:	5d                   	pop    %ebp
801039cc:	c3                   	ret    
  panic("unknown apicid\n");
801039cd:	83 ec 0c             	sub    $0xc,%esp
801039d0:	68 b2 81 10 80       	push   $0x801081b2
801039d5:	e8 b6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039da:	83 ec 0c             	sub    $0xc,%esp
801039dd:	68 e0 82 10 80       	push   $0x801082e0
801039e2:	e8 a9 c9 ff ff       	call   80100390 <panic>
801039e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ee:	66 90                	xchg   %ax,%ax

801039f0 <cpuid>:
cpuid() {
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039fa:	e8 81 ff ff ff       	call   80103980 <mycpu>
}
801039ff:	c9                   	leave  
  return mycpu()-cpus;
80103a00:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80103a05:	c1 f8 04             	sar    $0x4,%eax
80103a08:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a0e:	c3                   	ret    
80103a0f:	90                   	nop

80103a10 <myproc>:
myproc(void) {
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	53                   	push   %ebx
80103a18:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a1b:	e8 f0 12 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103a20:	e8 5b ff ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103a25:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a2b:	e8 30 13 00 00       	call   80104d60 <popcli>
}
80103a30:	83 c4 04             	add    $0x4,%esp
80103a33:	89 d8                	mov    %ebx,%eax
80103a35:	5b                   	pop    %ebx
80103a36:	5d                   	pop    %ebp
80103a37:	c3                   	ret    
80103a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3f:	90                   	nop

80103a40 <growproc>:
{
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	56                   	push   %esi
80103a48:	53                   	push   %ebx
80103a49:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a4c:	e8 bf 12 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103a51:	e8 2a ff ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103a56:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a5c:	e8 ff 12 00 00       	call   80104d60 <popcli>
  sz = curproc->sz;
80103a61:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a63:	85 f6                	test   %esi,%esi
80103a65:	7f 19                	jg     80103a80 <growproc+0x40>
  } else if(n < 0){
80103a67:	75 37                	jne    80103aa0 <growproc+0x60>
  switchuvm(curproc);
80103a69:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a6c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a6e:	53                   	push   %ebx
80103a6f:	e8 fc 39 00 00       	call   80107470 <switchuvm>
  return 0;
80103a74:	83 c4 10             	add    $0x10,%esp
80103a77:	31 c0                	xor    %eax,%eax
}
80103a79:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7c:	5b                   	pop    %ebx
80103a7d:	5e                   	pop    %esi
80103a7e:	5d                   	pop    %ebp
80103a7f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 41 3c 00 00       	call   801076d0 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d3                	jne    80103a69 <growproc+0x29>
      return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb dc                	jmp    80103a79 <growproc+0x39>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 51 3d 00 00       	call   80107800 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b3                	jne    80103a69 <growproc+0x29>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x56>
80103ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <sched>:
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	56                   	push   %esi
80103ac8:	53                   	push   %ebx
  pushcli();
80103ac9:	e8 42 12 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103ace:	e8 ad fe ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103ad3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad9:	e8 82 12 00 00       	call   80104d60 <popcli>
  if(!holding(&ptable.lock))
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	68 c0 3e 11 80       	push   $0x80113ec0
80103ae6:	e8 d5 12 00 00       	call   80104dc0 <holding>
80103aeb:	83 c4 10             	add    $0x10,%esp
80103aee:	85 c0                	test   %eax,%eax
80103af0:	74 4f                	je     80103b41 <sched+0x81>
  if(mycpu()->ncli != 1)
80103af2:	e8 89 fe ff ff       	call   80103980 <mycpu>
80103af7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103afe:	75 68                	jne    80103b68 <sched+0xa8>
  if(p->state == RUNNING)
80103b00:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b04:	74 55                	je     80103b5b <sched+0x9b>
80103b06:	9c                   	pushf  
80103b07:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b08:	f6 c4 02             	test   $0x2,%ah
80103b0b:	75 41                	jne    80103b4e <sched+0x8e>
  intena = mycpu()->intena;
80103b0d:	e8 6e fe ff ff       	call   80103980 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b12:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b15:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b1b:	e8 60 fe ff ff       	call   80103980 <mycpu>
80103b20:	83 ec 08             	sub    $0x8,%esp
80103b23:	ff 70 04             	pushl  0x4(%eax)
80103b26:	53                   	push   %ebx
80103b27:	e8 17 16 00 00       	call   80105143 <swtch>
  mycpu()->intena = intena;
80103b2c:	e8 4f fe ff ff       	call   80103980 <mycpu>
}
80103b31:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103b34:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b3d:	5b                   	pop    %ebx
80103b3e:	5e                   	pop    %esi
80103b3f:	5d                   	pop    %ebp
80103b40:	c3                   	ret    
    panic("sched ptable.lock");
80103b41:	83 ec 0c             	sub    $0xc,%esp
80103b44:	68 c2 81 10 80       	push   $0x801081c2
80103b49:	e8 42 c8 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103b4e:	83 ec 0c             	sub    $0xc,%esp
80103b51:	68 ee 81 10 80       	push   $0x801081ee
80103b56:	e8 35 c8 ff ff       	call   80100390 <panic>
    panic("sched running");
80103b5b:	83 ec 0c             	sub    $0xc,%esp
80103b5e:	68 e0 81 10 80       	push   $0x801081e0
80103b63:	e8 28 c8 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	68 d4 81 10 80       	push   $0x801081d4
80103b70:	e8 1b c8 ff ff       	call   80100390 <panic>
80103b75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b80 <yield>:
{
80103b80:	f3 0f 1e fb          	endbr32 
80103b84:	55                   	push   %ebp
80103b85:	89 e5                	mov    %esp,%ebp
80103b87:	53                   	push   %ebx
80103b88:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103b8b:	68 c0 3e 11 80       	push   $0x80113ec0
80103b90:	e8 7b 12 00 00       	call   80104e10 <acquire>
  pushcli();
80103b95:	e8 76 11 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103b9a:	e8 e1 fd ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103b9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba5:	e8 b6 11 00 00       	call   80104d60 <popcli>
  myproc()->state = RUNNABLE;
80103baa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103bb1:	e8 0a ff ff ff       	call   80103ac0 <sched>
  release(&ptable.lock);
80103bb6:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80103bbd:	e8 0e 13 00 00       	call   80104ed0 <release>
}
80103bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bc5:	83 c4 10             	add    $0x10,%esp
80103bc8:	c9                   	leave  
80103bc9:	c3                   	ret    
80103bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bd0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	8b 7d 08             	mov    0x8(%ebp),%edi
80103be0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103be3:	e8 28 11 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103be8:	e8 93 fd ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103bed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf3:	e8 68 11 00 00       	call   80104d60 <popcli>
  struct proc *p = myproc();
  
  if(p == 0)
80103bf8:	85 db                	test   %ebx,%ebx
80103bfa:	0f 84 83 00 00 00    	je     80103c83 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103c00:	85 f6                	test   %esi,%esi
80103c02:	74 72                	je     80103c76 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c04:	81 fe c0 3e 11 80    	cmp    $0x80113ec0,%esi
80103c0a:	74 4c                	je     80103c58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c0c:	83 ec 0c             	sub    $0xc,%esp
80103c0f:	68 c0 3e 11 80       	push   $0x80113ec0
80103c14:	e8 f7 11 00 00       	call   80104e10 <acquire>
    release(lk);
80103c19:	89 34 24             	mov    %esi,(%esp)
80103c1c:	e8 af 12 00 00       	call   80104ed0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c21:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c24:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103c2b:	e8 90 fe ff ff       	call   80103ac0 <sched>

  // Tidy up.
  p->chan = 0;
80103c30:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103c37:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80103c3e:	e8 8d 12 00 00       	call   80104ed0 <release>
    acquire(lk);
80103c43:	89 75 08             	mov    %esi,0x8(%ebp)
80103c46:	83 c4 10             	add    $0x10,%esp
  }
}
80103c49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4c:	5b                   	pop    %ebx
80103c4d:	5e                   	pop    %esi
80103c4e:	5f                   	pop    %edi
80103c4f:	5d                   	pop    %ebp
    acquire(lk);
80103c50:	e9 bb 11 00 00       	jmp    80104e10 <acquire>
80103c55:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103c58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103c62:	e8 59 fe ff ff       	call   80103ac0 <sched>
  p->chan = 0;
80103c67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103c6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c71:	5b                   	pop    %ebx
80103c72:	5e                   	pop    %esi
80103c73:	5f                   	pop    %edi
80103c74:	5d                   	pop    %ebp
80103c75:	c3                   	ret    
    panic("sleep without lk");
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	68 08 82 10 80       	push   $0x80108208
80103c7e:	e8 0d c7 ff ff       	call   80100390 <panic>
    panic("sleep");
80103c83:	83 ec 0c             	sub    $0xc,%esp
80103c86:	68 02 82 10 80       	push   $0x80108202
80103c8b:	e8 00 c7 ff ff       	call   80100390 <panic>

80103c90 <wait>:
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	56                   	push   %esi
80103c98:	53                   	push   %ebx
  pushcli();
80103c99:	e8 72 10 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80103c9e:	e8 dd fc ff ff       	call   80103980 <mycpu>
  p = c->proc;
80103ca3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ca9:	e8 b2 10 00 00       	call   80104d60 <popcli>
  acquire(&ptable.lock);
80103cae:	83 ec 0c             	sub    $0xc,%esp
80103cb1:	68 c0 3e 11 80       	push   $0x80113ec0
80103cb6:	e8 55 11 00 00       	call   80104e10 <acquire>
80103cbb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103cbe:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc0:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
80103cc5:	eb 17                	jmp    80103cde <wait+0x4e>
80103cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cce:	66 90                	xchg   %ax,%ax
80103cd0:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103cd6:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80103cdc:	74 1e                	je     80103cfc <wait+0x6c>
      if(p->parent != curproc)
80103cde:	39 73 14             	cmp    %esi,0x14(%ebx)
80103ce1:	75 ed                	jne    80103cd0 <wait+0x40>
      if(p->state == ZOMBIE){
80103ce3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103ce7:	74 37                	je     80103d20 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ce9:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103cef:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf4:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80103cfa:	75 e2                	jne    80103cde <wait+0x4e>
    if(!havekids || curproc->killed){
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	74 76                	je     80103d76 <wait+0xe6>
80103d00:	8b 46 24             	mov    0x24(%esi),%eax
80103d03:	85 c0                	test   %eax,%eax
80103d05:	75 6f                	jne    80103d76 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d07:	83 ec 08             	sub    $0x8,%esp
80103d0a:	68 c0 3e 11 80       	push   $0x80113ec0
80103d0f:	56                   	push   %esi
80103d10:	e8 bb fe ff ff       	call   80103bd0 <sleep>
    havekids = 0;
80103d15:	83 c4 10             	add    $0x10,%esp
80103d18:	eb a4                	jmp    80103cbe <wait+0x2e>
80103d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103d20:	83 ec 0c             	sub    $0xc,%esp
80103d23:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103d26:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d29:	e8 42 e7 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
80103d2e:	5a                   	pop    %edx
80103d2f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103d32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d39:	e8 f2 3a 00 00       	call   80107830 <freevm>
        release(&ptable.lock);
80103d3e:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
        p->pid = 0;
80103d45:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d4c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d53:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d57:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d5e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d65:	e8 66 11 00 00       	call   80104ed0 <release>
        return pid;
80103d6a:	83 c4 10             	add    $0x10,%esp
}
80103d6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d70:	89 f0                	mov    %esi,%eax
80103d72:	5b                   	pop    %ebx
80103d73:	5e                   	pop    %esi
80103d74:	5d                   	pop    %ebp
80103d75:	c3                   	ret    
      release(&ptable.lock);
80103d76:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103d79:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103d7e:	68 c0 3e 11 80       	push   $0x80113ec0
80103d83:	e8 48 11 00 00       	call   80104ed0 <release>
      return -1;
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	eb e0                	jmp    80103d6d <wait+0xdd>
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi

80103d90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103d90:	f3 0f 1e fb          	endbr32 
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	57                   	push   %edi
80103d98:	56                   	push   %esi
80103d99:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103d9c:	53                   	push   %ebx
80103d9d:	bb 60 3f 11 80       	mov    $0x80113f60,%ebx
80103da2:	83 ec 3c             	sub    $0x3c,%esp
80103da5:	eb 2b                	jmp    80103dd2 <procdump+0x42>
80103da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dae:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	68 f3 86 10 80       	push   $0x801086f3
80103db8:	e8 f3 c8 ff ff       	call   801006b0 <cprintf>
80103dbd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc0:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103dc6:	81 fb 60 63 11 80    	cmp    $0x80116360,%ebx
80103dcc:	0f 84 8e 00 00 00    	je     80103e60 <procdump+0xd0>
    if(p->state == UNUSED)
80103dd2:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103dd5:	85 c0                	test   %eax,%eax
80103dd7:	74 e7                	je     80103dc0 <procdump+0x30>
      state = "???";
80103dd9:	ba 19 82 10 80       	mov    $0x80108219,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103dde:	83 f8 05             	cmp    $0x5,%eax
80103de1:	77 11                	ja     80103df4 <procdump+0x64>
80103de3:	8b 14 85 98 83 10 80 	mov    -0x7fef7c68(,%eax,4),%edx
      state = "???";
80103dea:	b8 19 82 10 80       	mov    $0x80108219,%eax
80103def:	85 d2                	test   %edx,%edx
80103df1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103df4:	53                   	push   %ebx
80103df5:	52                   	push   %edx
80103df6:	ff 73 a4             	pushl  -0x5c(%ebx)
80103df9:	68 1d 82 10 80       	push   $0x8010821d
80103dfe:	e8 ad c8 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80103e03:	83 c4 10             	add    $0x10,%esp
80103e06:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103e0a:	75 a4                	jne    80103db0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103e0c:	83 ec 08             	sub    $0x8,%esp
80103e0f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103e12:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103e15:	50                   	push   %eax
80103e16:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103e19:	8b 40 0c             	mov    0xc(%eax),%eax
80103e1c:	83 c0 08             	add    $0x8,%eax
80103e1f:	50                   	push   %eax
80103e20:	e8 8b 0e 00 00       	call   80104cb0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop
80103e30:	8b 17                	mov    (%edi),%edx
80103e32:	85 d2                	test   %edx,%edx
80103e34:	0f 84 76 ff ff ff    	je     80103db0 <procdump+0x20>
        cprintf(" %p", pc[i]);
80103e3a:	83 ec 08             	sub    $0x8,%esp
80103e3d:	83 c7 04             	add    $0x4,%edi
80103e40:	52                   	push   %edx
80103e41:	68 61 7c 10 80       	push   $0x80107c61
80103e46:	e8 65 c8 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103e4b:	83 c4 10             	add    $0x10,%esp
80103e4e:	39 fe                	cmp    %edi,%esi
80103e50:	75 de                	jne    80103e30 <procdump+0xa0>
80103e52:	e9 59 ff ff ff       	jmp    80103db0 <procdump+0x20>
80103e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e5e:	66 90                	xchg   %ax,%ax
  }
}
80103e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e63:	5b                   	pop    %ebx
80103e64:	5e                   	pop    %esi
80103e65:	5f                   	pop    %edi
80103e66:	5d                   	pop    %ebp
80103e67:	c3                   	ret    
80103e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6f:	90                   	nop

80103e70 <initializing_Queue>:




void initializing_Queue(void)
{
80103e70:	f3 0f 1e fb          	endbr32 
    for (int i = 0; i < 4; i++)
    {
       L[i].level = i;
80103e74:	c7 05 ac 3d 11 80 00 	movl   $0x0,0x80113dac
80103e7b:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80103e7e:	c7 05 a8 3d 11 80 02 	movl   $0x2,0x80113da8
80103e85:	00 00 00 
       L[i].level = i;
80103e88:	c7 05 f0 3d 11 80 01 	movl   $0x1,0x80113df0
80103e8f:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80103e92:	c7 05 ec 3d 11 80 04 	movl   $0x4,0x80113dec
80103e99:	00 00 00 
       L[i].level = i;
80103e9c:	c7 05 34 3e 11 80 02 	movl   $0x2,0x80113e34
80103ea3:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80103ea6:	c7 05 30 3e 11 80 06 	movl   $0x6,0x80113e30
80103ead:	00 00 00 
       L[i].level = i;
80103eb0:	c7 05 78 3e 11 80 03 	movl   $0x3,0x80113e78
80103eb7:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80103eba:	c7 05 74 3e 11 80 08 	movl   $0x8,0x80113e74
80103ec1:	00 00 00 
    }
   
    MoQ.level = 4;
80103ec4:	c7 05 4c 3d 11 80 04 	movl   $0x4,0x80113d4c
80103ecb:	00 00 00 
}
80103ece:	c3                   	ret    
80103ecf:	90                   	nop

80103ed0 <pushQueue>:


void pushQueue(struct Queue *queue, struct proc *process)
{
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	57                   	push   %edi
80103ed8:	56                   	push   %esi
80103ed9:	53                   	push   %ebx
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ee0:	8b 75 08             	mov    0x8(%ebp),%esi
    if (process->queue_level != -1)
80103ee3:	83 bb 80 00 00 00 ff 	cmpl   $0xffffffff,0x80(%ebx)
80103eea:	75 4c                	jne    80103f38 <pushQueue+0x68>
	return;   
    
 
    if (queue->level < 0 || queue->level > 4)
80103eec:	83 7e 0c 04          	cmpl   $0x4,0xc(%esi)
80103ef0:	77 4e                	ja     80103f40 <pushQueue+0x70>
    {
        cprintf("MLFQ PUSH failed : level error\n");
	return;
    }

    acquire(&queue->queueLock);
80103ef2:	83 ec 0c             	sub    $0xc,%esp
80103ef5:	8d 7e 10             	lea    0x10(%esi),%edi
80103ef8:	57                   	push   %edi
80103ef9:	e8 12 0f 00 00       	call   80104e10 <acquire>
    process->next = 0;
    if (queue->head == 0) // when queue is empty!
80103efe:	83 c4 10             	add    $0x10,%esp
    process->next = 0;
80103f01:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103f08:	00 00 00 
    if (queue->head == 0) // when queue is empty!
80103f0b:	8b 06                	mov    (%esi),%eax
80103f0d:	85 c0                	test   %eax,%eax
80103f0f:	74 47                	je     80103f58 <pushQueue+0x88>
        queue->head = process;
        queue->tail = process;
    }
    else // when queue is not empty, push process in tail..
    {
        queue->tail->next = process;
80103f11:	8b 46 04             	mov    0x4(%esi),%eax
80103f14:	89 98 88 00 00 00    	mov    %ebx,0x88(%eax)
        queue->tail = process;
80103f1a:	89 5e 04             	mov    %ebx,0x4(%esi)
    }
    
    process->queue_level = queue->level;
80103f1d:	8b 46 0c             	mov    0xc(%esi),%eax
80103f20:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    
    release(&queue->queueLock);
80103f26:	89 7d 08             	mov    %edi,0x8(%ebp)
}
80103f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f2c:	5b                   	pop    %ebx
80103f2d:	5e                   	pop    %esi
80103f2e:	5f                   	pop    %edi
80103f2f:	5d                   	pop    %ebp
    release(&queue->queueLock);
80103f30:	e9 9b 0f 00 00       	jmp    80104ed0 <release>
80103f35:	8d 76 00             	lea    0x0(%esi),%esi
}
80103f38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f3b:	5b                   	pop    %ebx
80103f3c:	5e                   	pop    %esi
80103f3d:	5f                   	pop    %edi
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    
        cprintf("MLFQ PUSH failed : level error\n");
80103f40:	c7 45 08 08 83 10 80 	movl   $0x80108308,0x8(%ebp)
}
80103f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f4a:	5b                   	pop    %ebx
80103f4b:	5e                   	pop    %esi
80103f4c:	5f                   	pop    %edi
80103f4d:	5d                   	pop    %ebp
        cprintf("MLFQ PUSH failed : level error\n");
80103f4e:	e9 5d c7 ff ff       	jmp    801006b0 <cprintf>
80103f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f57:	90                   	nop
        queue->head = process;
80103f58:	89 1e                	mov    %ebx,(%esi)
        queue->tail = process;
80103f5a:	89 5e 04             	mov    %ebx,0x4(%esi)
80103f5d:	eb be                	jmp    80103f1d <pushQueue+0x4d>
80103f5f:	90                   	nop

80103f60 <userinit>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	53                   	push   %ebx
80103f68:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f6b:	e8 20 f8 ff ff       	call   80103790 <allocproc>
80103f70:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f72:	a3 bc b5 10 80       	mov    %eax,0x8010b5bc
  if((p->pgdir = setupkvm()) == 0)
80103f77:	e8 34 39 00 00       	call   801078b0 <setupkvm>
80103f7c:	89 43 04             	mov    %eax,0x4(%ebx)
80103f7f:	85 c0                	test   %eax,%eax
80103f81:	0f 84 ca 00 00 00    	je     80104051 <userinit+0xf1>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f87:	83 ec 04             	sub    $0x4,%esp
80103f8a:	68 2c 00 00 00       	push   $0x2c
80103f8f:	68 60 b4 10 80       	push   $0x8010b460
80103f94:	50                   	push   %eax
80103f95:	e8 e6 35 00 00       	call   80107580 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f9a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f9d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103fa3:	6a 4c                	push   $0x4c
80103fa5:	6a 00                	push   $0x0
80103fa7:	ff 73 18             	pushl  0x18(%ebx)
80103faa:	e8 71 0f 00 00       	call   80104f20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103faf:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fb7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103fba:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103fbf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103fc3:	8b 43 18             	mov    0x18(%ebx),%eax
80103fc6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103fca:	8b 43 18             	mov    0x18(%ebx),%eax
80103fcd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fd1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103fd5:	8b 43 18             	mov    0x18(%ebx),%eax
80103fd8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103fdc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103fe0:	8b 43 18             	mov    0x18(%ebx),%eax
80103fe3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103fea:	8b 43 18             	mov    0x18(%ebx),%eax
80103fed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ff4:	8b 43 18             	mov    0x18(%ebx),%eax
80103ff7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ffe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104001:	6a 10                	push   $0x10
80104003:	68 3f 82 10 80       	push   $0x8010823f
80104008:	50                   	push   %eax
80104009:	e8 d2 10 00 00       	call   801050e0 <safestrcpy>
  p->cwd = namei("/");
8010400e:	c7 04 24 48 82 10 80 	movl   $0x80108248,(%esp)
80104015:	e8 16 e0 ff ff       	call   80102030 <namei>
8010401a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010401d:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104024:	e8 e7 0d 00 00       	call   80104e10 <acquire>
  p->state = RUNNABLE;
80104029:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  pushQueue(&L[0], p); //push new process in L0
80104030:	58                   	pop    %eax
80104031:	5a                   	pop    %edx
80104032:	53                   	push   %ebx
80104033:	68 a0 3d 11 80       	push   $0x80113da0
80104038:	e8 93 fe ff ff       	call   80103ed0 <pushQueue>
  release(&ptable.lock);
8010403d:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104044:	e8 87 0e 00 00       	call   80104ed0 <release>
}
80104049:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010404c:	83 c4 10             	add    $0x10,%esp
8010404f:	c9                   	leave  
80104050:	c3                   	ret    
    panic("userinit: out of memory?");
80104051:	83 ec 0c             	sub    $0xc,%esp
80104054:	68 26 82 10 80       	push   $0x80108226
80104059:	e8 32 c3 ff ff       	call   80100390 <panic>
8010405e:	66 90                	xchg   %ax,%ax

80104060 <fork>:
{
80104060:	f3 0f 1e fb          	endbr32 
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	57                   	push   %edi
80104068:	56                   	push   %esi
80104069:	53                   	push   %ebx
8010406a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010406d:	e8 9e 0c 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80104072:	e8 09 f9 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104077:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010407d:	e8 de 0c 00 00       	call   80104d60 <popcli>
  if((np = allocproc()) == 0){
80104082:	e8 09 f7 ff ff       	call   80103790 <allocproc>
80104087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010408a:	85 c0                	test   %eax,%eax
8010408c:	0f 84 c8 00 00 00    	je     8010415a <fork+0xfa>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104092:	83 ec 08             	sub    $0x8,%esp
80104095:	ff 33                	pushl  (%ebx)
80104097:	89 c7                	mov    %eax,%edi
80104099:	ff 73 04             	pushl  0x4(%ebx)
8010409c:	e8 df 38 00 00       	call   80107980 <copyuvm>
801040a1:	83 c4 10             	add    $0x10,%esp
801040a4:	89 47 04             	mov    %eax,0x4(%edi)
801040a7:	85 c0                	test   %eax,%eax
801040a9:	0f 84 b2 00 00 00    	je     80104161 <fork+0x101>
  np->sz = curproc->sz;
801040af:	8b 03                	mov    (%ebx),%eax
801040b1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040b4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801040b6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801040b9:	89 c8                	mov    %ecx,%eax
801040bb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801040be:	b9 13 00 00 00       	mov    $0x13,%ecx
801040c3:	8b 73 18             	mov    0x18(%ebx),%esi
801040c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040c8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040ca:	8b 40 18             	mov    0x18(%eax),%eax
801040cd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801040d8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040dc:	85 c0                	test   %eax,%eax
801040de:	74 13                	je     801040f3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	50                   	push   %eax
801040e4:	e8 87 cd ff ff       	call   80100e70 <filedup>
801040e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040ec:	83 c4 10             	add    $0x10,%esp
801040ef:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801040f3:	83 c6 01             	add    $0x1,%esi
801040f6:	83 fe 10             	cmp    $0x10,%esi
801040f9:	75 dd                	jne    801040d8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
801040fb:	83 ec 0c             	sub    $0xc,%esp
801040fe:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104101:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104104:	e8 27 d6 ff ff       	call   80101730 <idup>
80104109:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010410c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010410f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104112:	8d 47 6c             	lea    0x6c(%edi),%eax
80104115:	6a 10                	push   $0x10
80104117:	53                   	push   %ebx
80104118:	50                   	push   %eax
80104119:	e8 c2 0f 00 00       	call   801050e0 <safestrcpy>
  pid = np->pid;
8010411e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104121:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104128:	e8 e3 0c 00 00       	call   80104e10 <acquire>
  np->state = RUNNABLE;
8010412d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  pushQueue(&L[0], np); //push child process in L0
80104134:	58                   	pop    %eax
80104135:	5a                   	pop    %edx
80104136:	57                   	push   %edi
80104137:	68 a0 3d 11 80       	push   $0x80113da0
8010413c:	e8 8f fd ff ff       	call   80103ed0 <pushQueue>
  release(&ptable.lock);
80104141:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104148:	e8 83 0d 00 00       	call   80104ed0 <release>
  return pid;
8010414d:	83 c4 10             	add    $0x10,%esp
}
80104150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104153:	89 d8                	mov    %ebx,%eax
80104155:	5b                   	pop    %ebx
80104156:	5e                   	pop    %esi
80104157:	5f                   	pop    %edi
80104158:	5d                   	pop    %ebp
80104159:	c3                   	ret    
    return -1;
8010415a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010415f:	eb ef                	jmp    80104150 <fork+0xf0>
    kfree(np->kstack);
80104161:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	ff 73 08             	pushl  0x8(%ebx)
8010416a:	e8 01 e3 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
8010416f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104176:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104179:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104180:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104185:	eb c9                	jmp    80104150 <fork+0xf0>
80104187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010418e:	66 90                	xchg   %ax,%ax

80104190 <wakeup1>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	89 c6                	mov    %eax,%esi
80104196:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104197:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
8010419c:	eb 10                	jmp    801041ae <wakeup1+0x1e>
8010419e:	66 90                	xchg   %ax,%ax
801041a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801041a6:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
801041ac:	74 31                	je     801041df <wakeup1+0x4f>
    if(p->state == SLEEPING && p->chan == chan)
801041ae:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801041b2:	75 ec                	jne    801041a0 <wakeup1+0x10>
801041b4:	39 73 20             	cmp    %esi,0x20(%ebx)
801041b7:	75 e7                	jne    801041a0 <wakeup1+0x10>
        pushQueue(&L[0], p); //push process that wakes up to L0 queue.
801041b9:	83 ec 08             	sub    $0x8,%esp
	p->state = RUNNABLE;
801041bc:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
        pushQueue(&L[0], p); //push process that wakes up to L0 queue.
801041c3:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
        pushQueue(&L[0], p); //push process that wakes up to L0 queue.
801041ca:	68 a0 3d 11 80       	push   $0x80113da0
801041cf:	e8 fc fc ff ff       	call   80103ed0 <pushQueue>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d7:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
801041dd:	75 cf                	jne    801041ae <wakeup1+0x1e>
}
801041df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e2:	5b                   	pop    %ebx
801041e3:	5e                   	pop    %esi
801041e4:	5d                   	pop    %ebp
801041e5:	c3                   	ret    
801041e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ed:	8d 76 00             	lea    0x0(%esi),%esi

801041f0 <exit>:
{
801041f0:	f3 0f 1e fb          	endbr32 
801041f4:	55                   	push   %ebp
801041f5:	89 e5                	mov    %esp,%ebp
801041f7:	57                   	push   %edi
801041f8:	56                   	push   %esi
801041f9:	53                   	push   %ebx
801041fa:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801041fd:	e8 0e 0b 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80104202:	e8 79 f7 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104207:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010420d:	e8 4e 0b 00 00       	call   80104d60 <popcli>
  if(curproc == initproc)
80104212:	8d 5e 28             	lea    0x28(%esi),%ebx
80104215:	8d 7e 68             	lea    0x68(%esi),%edi
80104218:	39 35 bc b5 10 80    	cmp    %esi,0x8010b5bc
8010421e:	0f 84 b5 00 00 00    	je     801042d9 <exit+0xe9>
80104224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104228:	8b 03                	mov    (%ebx),%eax
8010422a:	85 c0                	test   %eax,%eax
8010422c:	74 12                	je     80104240 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	50                   	push   %eax
80104232:	e8 89 cc ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104237:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010423d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104240:	83 c3 04             	add    $0x4,%ebx
80104243:	39 fb                	cmp    %edi,%ebx
80104245:	75 e1                	jne    80104228 <exit+0x38>
  begin_op();
80104247:	e8 e4 ea ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
8010424c:	83 ec 0c             	sub    $0xc,%esp
8010424f:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104252:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
  iput(curproc->cwd);
80104257:	e8 34 d6 ff ff       	call   80101890 <iput>
  end_op();
8010425c:	e8 3f eb ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80104261:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104268:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
8010426f:	e8 9c 0b 00 00       	call   80104e10 <acquire>
  wakeup1(curproc->parent);
80104274:	8b 46 14             	mov    0x14(%esi),%eax
80104277:	e8 14 ff ff ff       	call   80104190 <wakeup1>
8010427c:	83 c4 10             	add    $0x10,%esp
8010427f:	eb 15                	jmp    80104296 <exit+0xa6>
80104281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104288:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010428e:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104294:	74 2a                	je     801042c0 <exit+0xd0>
    if(p->parent == curproc){
80104296:	39 73 14             	cmp    %esi,0x14(%ebx)
80104299:	75 ed                	jne    80104288 <exit+0x98>
      p->parent = initproc;
8010429b:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
      if(p->state == ZOMBIE)
801042a0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
      p->parent = initproc;
801042a4:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801042a7:	75 df                	jne    80104288 <exit+0x98>
        wakeup1(initproc);
801042a9:	e8 e2 fe ff ff       	call   80104190 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ae:	81 c3 90 00 00 00    	add    $0x90,%ebx
801042b4:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
801042ba:	75 da                	jne    80104296 <exit+0xa6>
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  curproc->state = ZOMBIE;
801042c0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801042c7:	e8 f4 f7 ff ff       	call   80103ac0 <sched>
  panic("zombie exit");
801042cc:	83 ec 0c             	sub    $0xc,%esp
801042cf:	68 57 82 10 80       	push   $0x80108257
801042d4:	e8 b7 c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042d9:	83 ec 0c             	sub    $0xc,%esp
801042dc:	68 4a 82 10 80       	push   $0x8010824a
801042e1:	e8 aa c0 ff ff       	call   80100390 <panic>
801042e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ed:	8d 76 00             	lea    0x0(%esi),%esi

801042f0 <wakeup>:
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	53                   	push   %ebx
801042f8:	83 ec 10             	sub    $0x10,%esp
801042fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042fe:	68 c0 3e 11 80       	push   $0x80113ec0
80104303:	e8 08 0b 00 00       	call   80104e10 <acquire>
  wakeup1(chan);
80104308:	89 d8                	mov    %ebx,%eax
8010430a:	e8 81 fe ff ff       	call   80104190 <wakeup1>
  release(&ptable.lock);
8010430f:	c7 45 08 c0 3e 11 80 	movl   $0x80113ec0,0x8(%ebp)
}
80104316:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&ptable.lock);
80104319:	83 c4 10             	add    $0x10,%esp
}
8010431c:	c9                   	leave  
  release(&ptable.lock);
8010431d:	e9 ae 0b 00 00       	jmp    80104ed0 <release>
80104322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104330 <kill>:
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	53                   	push   %ebx
80104338:	83 ec 10             	sub    $0x10,%esp
8010433b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433e:	68 c0 3e 11 80       	push   $0x80113ec0
80104343:	e8 c8 0a 00 00       	call   80104e10 <acquire>
80104348:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010434b:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
80104350:	eb 12                	jmp    80104364 <kill+0x34>
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104358:	05 90 00 00 00       	add    $0x90,%eax
8010435d:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
80104362:	74 2c                	je     80104390 <kill+0x60>
    if(p->pid == pid){
80104364:	39 58 10             	cmp    %ebx,0x10(%eax)
80104367:	75 ef                	jne    80104358 <kill+0x28>
      if(p->state == SLEEPING){
80104369:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010436d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING){
80104374:	74 3a                	je     801043b0 <kill+0x80>
      release(&ptable.lock);
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	68 c0 3e 11 80       	push   $0x80113ec0
8010437e:	e8 4d 0b 00 00       	call   80104ed0 <release>
}
80104383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104386:	83 c4 10             	add    $0x10,%esp
80104389:	31 c0                	xor    %eax,%eax
}
8010438b:	c9                   	leave  
8010438c:	c3                   	ret    
8010438d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104390:	83 ec 0c             	sub    $0xc,%esp
80104393:	68 c0 3e 11 80       	push   $0x80113ec0
80104398:	e8 33 0b 00 00       	call   80104ed0 <release>
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043a0:	83 c4 10             	add    $0x10,%esp
801043a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
801043aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	pushQueue(&L[0], p); //push to L0 queue
801043b0:	83 ec 08             	sub    $0x8,%esp
        p->state = RUNNABLE;
801043b3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
	p->queue_level = -1;
801043ba:	c7 80 80 00 00 00 ff 	movl   $0xffffffff,0x80(%eax)
801043c1:	ff ff ff 
	pushQueue(&L[0], p); //push to L0 queue
801043c4:	50                   	push   %eax
801043c5:	68 a0 3d 11 80       	push   $0x80113da0
801043ca:	e8 01 fb ff ff       	call   80103ed0 <pushQueue>
801043cf:	83 c4 10             	add    $0x10,%esp
801043d2:	eb a2                	jmp    80104376 <kill+0x46>
801043d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop

801043e0 <popQueue>:


void popQueue(struct Queue *queue, struct proc *process)
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	57                   	push   %edi
801043e8:	56                   	push   %esi
801043e9:	53                   	push   %ebx
801043ea:	83 ec 0c             	sub    $0xc,%esp
801043ed:	8b 75 08             	mov    0x8(%ebp),%esi
801043f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (queue->level < 0 || queue->level > 4 || process->queue_level != queue->level)
801043f3:	8b 46 0c             	mov    0xc(%esi),%eax
801043f6:	83 f8 04             	cmp    $0x4,%eax
801043f9:	77 75                	ja     80104470 <popQueue+0x90>
801043fb:	3b 83 80 00 00 00    	cmp    0x80(%ebx),%eax
80104401:	75 6d                	jne    80104470 <popQueue+0x90>
    {    
	cprintf("POP failed: level error\n");
	return;
    }
    if (queue->head == 0) //queue is empty 
80104403:	8b 06                	mov    (%esi),%eax
80104405:	85 c0                	test   %eax,%eax
80104407:	0f 84 a3 00 00 00    	je     801044b0 <popQueue+0xd0>
    { 
        cprintf("POP failed : queue is empty\n");
	return;
    }
	
    acquire(&queue->queueLock);
8010440d:	83 ec 0c             	sub    $0xc,%esp
80104410:	8d 7e 10             	lea    0x10(%esi),%edi
80104413:	57                   	push   %edi
80104414:	e8 f7 09 00 00       	call   80104e10 <acquire>
    if (process == queue->head) // if proces is head of queue
80104419:	8b 06                	mov    (%esi),%eax
8010441b:	83 c4 10             	add    $0x10,%esp
8010441e:	39 c3                	cmp    %eax,%ebx
80104420:	74 7e                	je     801044a0 <popQueue+0xc0>
80104422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	    queue->head = process->next;
    }
    else // process is not head process.
    {
        struct proc *prev_proc = queue->head;
        while (prev_proc->next != process) // find previous process in queue
80104428:	89 c2                	mov    %eax,%edx
8010442a:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104430:	39 c3                	cmp    %eax,%ebx
80104432:	75 f4                	jne    80104428 <popQueue+0x48>
            prev_proc = prev_proc->next;
	
	if (process == queue->tail) //process is in queue tail
80104434:	3b 5e 04             	cmp    0x4(%esi),%ebx
80104437:	74 4f                	je     80104488 <popQueue+0xa8>
	{
	    queue->tail = prev_proc;
	    prev_proc->next = 0;
	}
	else
	    prev_proc->next = process->next;
80104439:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010443f:	89 82 88 00 00 00    	mov    %eax,0x88(%edx)
    }
    process->next = 0;
80104445:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
8010444c:	00 00 00 
    process->queue_level = -1;
8010444f:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
80104456:	ff ff ff 
    release(&queue->queueLock); 
80104459:	89 7d 08             	mov    %edi,0x8(%ebp)
}
8010445c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010445f:	5b                   	pop    %ebx
80104460:	5e                   	pop    %esi
80104461:	5f                   	pop    %edi
80104462:	5d                   	pop    %ebp
    release(&queue->queueLock); 
80104463:	e9 68 0a 00 00       	jmp    80104ed0 <release>
80104468:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446f:	90                   	nop
	cprintf("POP failed: level error\n");
80104470:	c7 45 08 63 82 10 80 	movl   $0x80108263,0x8(%ebp)
}
80104477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447a:	5b                   	pop    %ebx
8010447b:	5e                   	pop    %esi
8010447c:	5f                   	pop    %edi
8010447d:	5d                   	pop    %ebp
        cprintf("POP failed : queue is empty\n");
8010447e:	e9 2d c2 ff ff       	jmp    801006b0 <cprintf>
80104483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104487:	90                   	nop
	    queue->tail = prev_proc;
80104488:	89 56 04             	mov    %edx,0x4(%esi)
	    prev_proc->next = 0;
8010448b:	c7 82 88 00 00 00 00 	movl   $0x0,0x88(%edx)
80104492:	00 00 00 
80104495:	eb ae                	jmp    80104445 <popQueue+0x65>
80104497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010449e:	66 90                	xchg   %ax,%ax
	if (process->next == 0) //this queue will be empty after pop
801044a0:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801044a6:	85 c0                	test   %eax,%eax
801044a8:	74 16                	je     801044c0 <popQueue+0xe0>
	    queue->head = process->next;
801044aa:	89 06                	mov    %eax,(%esi)
801044ac:	eb 97                	jmp    80104445 <popQueue+0x65>
801044ae:	66 90                	xchg   %ax,%ax
        cprintf("POP failed : queue is empty\n");
801044b0:	c7 45 08 7c 82 10 80 	movl   $0x8010827c,0x8(%ebp)
801044b7:	eb be                	jmp    80104477 <popQueue+0x97>
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	    queue->head = 0;
801044c0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	    queue->tail = 0;
801044c6:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
801044cd:	e9 73 ff ff ff       	jmp    80104445 <popQueue+0x65>
801044d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044e0 <getlev>:


// 프로세스가 속한 큐의 레벨을 반환합니다.
// MoQ에 속한 프로세스인 경우 99를 반환합니다.
int getlev(void)
{
801044e0:	f3 0f 1e fb          	endbr32 
801044e4:	55                   	push   %ebp
801044e5:	89 e5                	mov    %esp,%ebp
801044e7:	53                   	push   %ebx
801044e8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801044eb:	e8 20 08 00 00       	call   80104d10 <pushcli>
  c = mycpu();
801044f0:	e8 8b f4 ff ff       	call   80103980 <mycpu>
  p = c->proc;
801044f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044fb:	e8 60 08 00 00       	call   80104d60 <popcli>
  return p;
80104500:	b8 63 00 00 00       	mov    $0x63,%eax
    if (myproc()->queue_level == 4) return 99; //process in MoQ
80104505:	83 bb 80 00 00 00 04 	cmpl   $0x4,0x80(%ebx)
8010450c:	74 1b                	je     80104529 <getlev+0x49>
  pushcli();
8010450e:	e8 fd 07 00 00       	call   80104d10 <pushcli>
  c = mycpu();
80104513:	e8 68 f4 ff ff       	call   80103980 <mycpu>
  p = c->proc;
80104518:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010451e:	e8 3d 08 00 00       	call   80104d60 <popcli>
    return myproc()->queue_level;
80104523:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
}
80104529:	83 c4 04             	add    $0x4,%esp
8010452c:	5b                   	pop    %ebx
8010452d:	5d                   	pop    %ebp
8010452e:	c3                   	ret    
8010452f:	90                   	nop

80104530 <setpriority>:
/*특정 pid를 가지는 프로세스의 priority를 설정합니다.
priority 설정에 성공한 경우 0을 반환합니다.
주어진 pid를 가진 프로세스가 존재하지 않는 경우 - 1을 반환합니다.
priority가 0 이상 10 이하의 정수가 아닌 경우 - 2를 반환합니다.*/
int setpriority(int pid, int priority)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	8b 75 0c             	mov    0xc(%ebp),%esi
8010453b:	53                   	push   %ebx
8010453c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (priority > 10 || priority < 0)
8010453f:	83 fe 0a             	cmp    $0xa,%esi
80104542:	77 74                	ja     801045b8 <setpriority+0x88>
        return -2;
    }

    struct proc *p;

    acquire(&ptable.lock);
80104544:	83 ec 0c             	sub    $0xc,%esp
80104547:	68 c0 3e 11 80       	push   $0x80113ec0
8010454c:	e8 bf 08 00 00       	call   80104e10 <acquire>
80104551:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104554:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
80104559:	eb 11                	jmp    8010456c <setpriority+0x3c>
8010455b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop
80104560:	05 90 00 00 00       	add    $0x90,%eax
80104565:	3d f4 62 11 80       	cmp    $0x801162f4,%eax
8010456a:	74 24                	je     80104590 <setpriority+0x60>
    {
        if (p->pid == pid)
8010456c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010456f:	75 ef                	jne    80104560 <setpriority+0x30>
        {
            p->priority = priority;
            release(&ptable.lock);
80104571:	83 ec 0c             	sub    $0xc,%esp
            p->priority = priority;
80104574:	89 70 7c             	mov    %esi,0x7c(%eax)
            release(&ptable.lock);
80104577:	68 c0 3e 11 80       	push   $0x80113ec0
8010457c:	e8 4f 09 00 00       	call   80104ed0 <release>
            return 0;
80104581:	83 c4 10             	add    $0x10,%esp
80104584:	31 c0                	xor    %eax,%eax
    }

    release(&ptable.lock);
    cprintf("setpriority failed : pid error\n");
    return -1;
}
80104586:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104589:	5b                   	pop    %ebx
8010458a:	5e                   	pop    %esi
8010458b:	5d                   	pop    %ebp
8010458c:	c3                   	ret    
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80104590:	83 ec 0c             	sub    $0xc,%esp
80104593:	68 c0 3e 11 80       	push   $0x80113ec0
80104598:	e8 33 09 00 00       	call   80104ed0 <release>
    cprintf("setpriority failed : pid error\n");
8010459d:	c7 04 24 54 83 10 80 	movl   $0x80108354,(%esp)
801045a4:	e8 07 c1 ff ff       	call   801006b0 <cprintf>
    return -1;
801045a9:	83 c4 10             	add    $0x10,%esp
}
801045ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801045af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b4:	5b                   	pop    %ebx
801045b5:	5e                   	pop    %esi
801045b6:	5d                   	pop    %ebp
801045b7:	c3                   	ret    
	cprintf("setpriority failed : priority range error\n");
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 28 83 10 80       	push   $0x80108328
801045c0:	e8 eb c0 ff ff       	call   801006b0 <cprintf>
        return -2;
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
801045cd:	eb b7                	jmp    80104586 <setpriority+0x56>
801045cf:	90                   	nop

801045d0 <priority_boosting>:



//priority boosting for starvation
void priority_boosting(void)
{
801045d0:	f3 0f 1e fb          	endbr32 
    if (is_monopolize_called) //not activate when monopoly scheduling 
801045d4:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801045da:	85 c9                	test   %ecx,%ecx
801045dc:	74 02                	je     801045e0 <priority_boosting+0x10>
801045de:	c3                   	ret    
801045df:	90                   	nop
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
	return;

    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
801045e4:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
{
801045e9:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
801045ec:	68 c0 3e 11 80       	push   $0x80113ec0
801045f1:	e8 1a 08 00 00       	call   80104e10 <acquire>
801045f6:	83 c4 10             	add    $0x10,%esp
801045f9:	eb 13                	jmp    8010460e <priority_boosting+0x3e>
801045fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045ff:	90                   	nop
    for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104600:	81 c3 90 00 00 00    	add    $0x90,%ebx
80104606:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
8010460c:	74 48                	je     80104656 <priority_boosting+0x86>
    {
	if (p->queue_level == 1 || p->queue_level == 2 || p->queue_level == 3)
8010460e:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80104614:	8d 50 ff             	lea    -0x1(%eax),%edx
80104617:	83 fa 02             	cmp    $0x2,%edx
8010461a:	77 e4                	ja     80104600 <priority_boosting+0x30>
	{    
	     p->current_tick = 0;
8010461c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104623:	00 00 00 
	     popQueue(&L[p->queue_level], p);
80104626:	6b c0 44             	imul   $0x44,%eax,%eax
80104629:	83 ec 08             	sub    $0x8,%esp
8010462c:	53                   	push   %ebx
8010462d:	05 a0 3d 11 80       	add    $0x80113da0,%eax
80104632:	50                   	push   %eax
80104633:	e8 a8 fd ff ff       	call   801043e0 <popQueue>
	     pushQueue(&L[0], p);
80104638:	58                   	pop    %eax
80104639:	5a                   	pop    %edx
8010463a:	53                   	push   %ebx
8010463b:	68 a0 3d 11 80       	push   $0x80113da0
    for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
80104640:	81 c3 90 00 00 00    	add    $0x90,%ebx
	     pushQueue(&L[0], p);
80104646:	e8 85 f8 ff ff       	call   80103ed0 <pushQueue>
8010464b:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p< &ptable.proc[NPROC]; p++)
8010464e:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
80104654:	75 b8                	jne    8010460e <priority_boosting+0x3e>
	}
    }
    release(&ptable.lock);
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 c0 3e 11 80       	push   $0x80113ec0
8010465e:	e8 6d 08 00 00       	call   80104ed0 <release>
}
80104663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    release(&ptable.lock);
80104666:	83 c4 10             	add    $0x10,%esp
}
80104669:	c9                   	leave  
8010466a:	c3                   	ret    
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <setmonopoly>:
// 특정 pid의 프로세스를 MoQ로 이동한다. 인자로 독점 자격을 증명할 암호(학번)
// 암호가 일치하면 MoQ의 크기 반환(MoQ 내부에 존재하는 종료되지 않은 프로세스의 개수)
// pid가 존재하지 않은 프로세스면 -1
// 암호가 일치하지 않으면 -2
int setmonopoly(int pid, int password)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	56                   	push   %esi
    if (password != 2022054702)
80104678:	81 7d 0c 2e 1b 86 78 	cmpl   $0x78861b2e,0xc(%ebp)
{
8010467f:	8b 75 08             	mov    0x8(%ebp),%esi
80104682:	53                   	push   %ebx
    if (password != 2022054702)
80104683:	0f 85 c1 00 00 00    	jne    8010474a <setmonopoly+0xda>
    {
	cprintf("MoQ PUSH failed : wrong password\n");
        return -2;
    }

    acquire(&ptable.lock);
80104689:	83 ec 0c             	sub    $0xc,%esp
    struct proc *p;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010468c:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
    acquire(&ptable.lock);
80104691:	68 c0 3e 11 80       	push   $0x80113ec0
80104696:	e8 75 07 00 00       	call   80104e10 <acquire>
8010469b:	83 c4 10             	add    $0x10,%esp
8010469e:	eb 0e                	jmp    801046ae <setmonopoly+0x3e>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046a0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801046a6:	81 fb f4 62 11 80    	cmp    $0x801162f4,%ebx
801046ac:	74 72                	je     80104720 <setmonopoly+0xb0>
    {
        if (p->pid == pid)
801046ae:	39 73 10             	cmp    %esi,0x10(%ebx)
801046b1:	75 ed                	jne    801046a0 <setmonopoly+0x30>
        {
            popQueue(&L[p->queue_level], p); 
801046b3:	83 ec 08             	sub    $0x8,%esp
801046b6:	53                   	push   %ebx
801046b7:	6b 83 80 00 00 00 44 	imul   $0x44,0x80(%ebx),%eax
801046be:	05 a0 3d 11 80       	add    $0x80113da0,%eax
801046c3:	50                   	push   %eax
801046c4:	e8 17 fd ff ff       	call   801043e0 <popQueue>
	    p->inMoQ = 1;
801046c9:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
801046d0:	00 00 00 
	    pushQueue(&MoQ, p); //p->queue_level = 4;
801046d3:	58                   	pop    %eax
801046d4:	5a                   	pop    %edx
801046d5:	53                   	push   %ebx
	    

            int MoQ_size = 0;
801046d6:	31 db                	xor    %ebx,%ebx
	    pushQueue(&MoQ, p); //p->queue_level = 4;
801046d8:	68 40 3d 11 80       	push   $0x80113d40
801046dd:	e8 ee f7 ff ff       	call   80103ed0 <pushQueue>
            for (struct proc *i = MoQ.head; i != 0; i = i->next)
801046e2:	a1 40 3d 11 80       	mov    0x80113d40,%eax
801046e7:	83 c4 10             	add    $0x10,%esp
801046ea:	85 c0                	test   %eax,%eax
801046ec:	74 17                	je     80104705 <setmonopoly+0x95>
801046ee:	66 90                	xchg   %ax,%ax
            {
                if (i->state == RUNNABLE)
                    MoQ_size++;
801046f0:	31 d2                	xor    %edx,%edx
801046f2:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
            for (struct proc *i = MoQ.head; i != 0; i = i->next)
801046f6:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
                    MoQ_size++;
801046fc:	0f 94 c2             	sete   %dl
801046ff:	01 d3                	add    %edx,%ebx
            for (struct proc *i = MoQ.head; i != 0; i = i->next)
80104701:	85 c0                	test   %eax,%eax
80104703:	75 eb                	jne    801046f0 <setmonopoly+0x80>
            }
	    release(&ptable.lock);
80104705:	83 ec 0c             	sub    $0xc,%esp
80104708:	68 c0 3e 11 80       	push   $0x80113ec0
8010470d:	e8 be 07 00 00       	call   80104ed0 <release>
            return MoQ_size;
80104712:	83 c4 10             	add    $0x10,%esp
    }
   
    release(&ptable.lock);
    cprintf("MoQ PUSH faild : wrong pid\n");
    return -1;
}
80104715:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104718:	89 d8                	mov    %ebx,%eax
8010471a:	5b                   	pop    %ebx
8010471b:	5e                   	pop    %esi
8010471c:	5d                   	pop    %ebp
8010471d:	c3                   	ret    
8010471e:	66 90                	xchg   %ax,%ax
    release(&ptable.lock);
80104720:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80104723:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    release(&ptable.lock);
80104728:	68 c0 3e 11 80       	push   $0x80113ec0
8010472d:	e8 9e 07 00 00       	call   80104ed0 <release>
    cprintf("MoQ PUSH faild : wrong pid\n");
80104732:	c7 04 24 99 82 10 80 	movl   $0x80108299,(%esp)
80104739:	e8 72 bf ff ff       	call   801006b0 <cprintf>
    return -1;
8010473e:	83 c4 10             	add    $0x10,%esp
}
80104741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104744:	89 d8                	mov    %ebx,%eax
80104746:	5b                   	pop    %ebx
80104747:	5e                   	pop    %esi
80104748:	5d                   	pop    %ebp
80104749:	c3                   	ret    
	cprintf("MoQ PUSH failed : wrong password\n");
8010474a:	83 ec 0c             	sub    $0xc,%esp
        return -2;
8010474d:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
	cprintf("MoQ PUSH failed : wrong password\n");
80104752:	68 74 83 10 80       	push   $0x80108374
80104757:	e8 54 bf ff ff       	call   801006b0 <cprintf>
        return -2;
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	eb b4                	jmp    80104715 <setmonopoly+0xa5>
80104761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476f:	90                   	nop

80104770 <monopolize>:



// MoQ의 프로세스가 cpu를 독점하여 사용하도록 설정한다.
void monopolize(void)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	83 ec 14             	sub    $0x14,%esp
    acquire(&MoQ.queueLock);
8010477a:	68 50 3d 11 80       	push   $0x80113d50
8010477f:	e8 8c 06 00 00       	call   80104e10 <acquire>
    is_monopolize_called = 1; //set
    release(&MoQ.queueLock);
80104784:	c7 04 24 50 3d 11 80 	movl   $0x80113d50,(%esp)
    is_monopolize_called = 1; //set
8010478b:	c7 05 b8 b5 10 80 01 	movl   $0x1,0x8010b5b8
80104792:	00 00 00 
    release(&MoQ.queueLock);
80104795:	e8 36 07 00 00       	call   80104ed0 <release>
    
}
8010479a:	83 c4 10             	add    $0x10,%esp
8010479d:	c9                   	leave  
8010479e:	c3                   	ret    
8010479f:	90                   	nop

801047a0 <unmonopolize>:


//exit MoQ
void unmonopolize(void)
{
801047a0:	f3 0f 1e fb          	endbr32 
801047a4:	55                   	push   %ebp
801047a5:	89 e5                	mov    %esp,%ebp
801047a7:	83 ec 14             	sub    $0x14,%esp
    acquire(&MoQ.queueLock);
801047aa:	68 50 3d 11 80       	push   $0x80113d50
801047af:	e8 5c 06 00 00       	call   80104e10 <acquire>
    is_monopolize_called = 0;
    ticks = 0;
    release(&MoQ.queueLock);
801047b4:	c7 04 24 50 3d 11 80 	movl   $0x80113d50,(%esp)
    is_monopolize_called = 0;
801047bb:	c7 05 b8 b5 10 80 00 	movl   $0x0,0x8010b5b8
801047c2:	00 00 00 
    ticks = 0;
801047c5:	c7 05 40 6b 11 80 00 	movl   $0x0,0x80116b40
801047cc:	00 00 00 
    release(&MoQ.queueLock);
801047cf:	e8 fc 06 00 00       	call   80104ed0 <release>
}
801047d4:	83 c4 10             	add    $0x10,%esp
801047d7:	c9                   	leave  
801047d8:	c3                   	ret    
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <scheduler>:
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	57                   	push   %edi
801047e8:	56                   	push   %esi
801047e9:	53                   	push   %ebx
801047ea:	83 ec 1c             	sub    $0x1c,%esp
    struct cpu *c = mycpu();
801047ed:	e8 8e f1 ff ff       	call   80103980 <mycpu>
       L[i].level = i;
801047f2:	c7 05 ac 3d 11 80 00 	movl   $0x0,0x80113dac
801047f9:	00 00 00 
    c->proc = 0;
801047fc:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104803:	00 00 00 
    struct cpu *c = mycpu();
80104806:	89 c6                	mov    %eax,%esi
       L[i].time_quantum = 2 * i + 2;
80104808:	8d 40 04             	lea    0x4(%eax),%eax
8010480b:	c7 05 a8 3d 11 80 02 	movl   $0x2,0x80113da8
80104812:	00 00 00 
       L[i].level = i;
80104815:	c7 05 f0 3d 11 80 01 	movl   $0x1,0x80113df0
8010481c:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
8010481f:	c7 05 ec 3d 11 80 04 	movl   $0x4,0x80113dec
80104826:	00 00 00 
       L[i].level = i;
80104829:	c7 05 34 3e 11 80 02 	movl   $0x2,0x80113e34
80104830:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80104833:	c7 05 30 3e 11 80 06 	movl   $0x6,0x80113e30
8010483a:	00 00 00 
       L[i].level = i;
8010483d:	c7 05 78 3e 11 80 03 	movl   $0x3,0x80113e78
80104844:	00 00 00 
       L[i].time_quantum = 2 * i + 2;
80104847:	c7 05 74 3e 11 80 08 	movl   $0x8,0x80113e74
8010484e:	00 00 00 
    MoQ.level = 4;
80104851:	c7 05 4c 3d 11 80 04 	movl   $0x4,0x80113d4c
80104858:	00 00 00 
8010485b:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010485e:	66 90                	xchg   %ax,%ax
  asm volatile("sti");
80104860:	fb                   	sti    
        acquire(&ptable.lock);
80104861:	83 ec 0c             	sub    $0xc,%esp
80104864:	68 c0 3e 11 80       	push   $0x80113ec0
80104869:	e8 a2 05 00 00       	call   80104e10 <acquire>
	if (is_monopolize_called) //when monopolize system called
8010486e:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80104873:	83 c4 10             	add    $0x10,%esp
80104876:	85 c0                	test   %eax,%eax
80104878:	0f 84 8a 00 00 00    	je     80104908 <scheduler+0x128>
	    for (p = MoQ.head; p != 0; p = p->next) 
8010487e:	8b 1d 40 3d 11 80    	mov    0x80113d40,%ebx
80104884:	85 db                	test   %ebx,%ebx
80104886:	75 12                	jne    8010489a <scheduler+0xba>
80104888:	eb 63                	jmp    801048ed <scheduler+0x10d>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104890:	8b 9b 88 00 00 00    	mov    0x88(%ebx),%ebx
80104896:	85 db                	test   %ebx,%ebx
80104898:	74 53                	je     801048ed <scheduler+0x10d>
        	if (p->state == RUNNABLE)
8010489a:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010489e:	75 f0                	jne    80104890 <scheduler+0xb0>
    	    switchuvm(p);
801048a0:	83 ec 0c             	sub    $0xc,%esp
    	    c->proc = p;
801048a3:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
    	    switchuvm(p);
801048a9:	53                   	push   %ebx
801048aa:	e8 c1 2b 00 00       	call   80107470 <switchuvm>
    	    p->state = RUNNING;
801048af:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    	    swtch(&(c->scheduler), p->context);
801048b6:	58                   	pop    %eax
801048b7:	5a                   	pop    %edx
801048b8:	ff 73 1c             	pushl  0x1c(%ebx)
801048bb:	ff 75 e0             	pushl  -0x20(%ebp)
801048be:	e8 80 08 00 00       	call   80105143 <swtch>
    	    switchkvm();
801048c3:	e8 88 2b 00 00       	call   80107450 <switchkvm>
	    if (p->state == ZOMBIE) 
801048c8:	83 c4 10             	add    $0x10,%esp
    	    c->proc = 0;
801048cb:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801048d2:	00 00 00 
	    if (p->state == ZOMBIE) 
801048d5:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801048d9:	0f 84 c1 01 00 00    	je     80104aa0 <scheduler+0x2c0>
	    if (MoQ.head == 0)
801048df:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
801048e5:	85 c9                	test   %ecx,%ecx
801048e7:	0f 84 dc 01 00 00    	je     80104ac9 <scheduler+0x2e9>
        release(&ptable.lock);
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	68 c0 3e 11 80       	push   $0x80113ec0
801048f5:	e8 d6 05 00 00       	call   80104ed0 <release>
801048fa:	83 c4 10             	add    $0x10,%esp
801048fd:	e9 5e ff ff ff       	jmp    80104860 <scheduler+0x80>
80104902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010490b:	bf a0 3d 11 80       	mov    $0x80113da0,%edi
               if (L[i].head != 0) //if L[i] is not empty.
80104910:	8b 1f                	mov    (%edi),%ebx
80104912:	85 db                	test   %ebx,%ebx
80104914:	0f 85 64 01 00 00    	jne    80104a7e <scheduler+0x29e>
           for (int i = 0; i < 3; i++) // L[0], L[1], L[2]
8010491a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010491e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104921:	83 c7 44             	add    $0x44,%edi
80104924:	83 f8 03             	cmp    $0x3,%eax
80104927:	75 e7                	jne    80104910 <scheduler+0x130>
           if (L[1].head == 0 && L[2].head == 0 && L[3].head != 0)
80104929:	a1 e4 3d 11 80       	mov    0x80113de4,%eax
8010492e:	85 c0                	test   %eax,%eax
80104930:	75 bb                	jne    801048ed <scheduler+0x10d>
80104932:	a1 28 3e 11 80       	mov    0x80113e28,%eax
80104937:	85 c0                	test   %eax,%eax
80104939:	75 b2                	jne    801048ed <scheduler+0x10d>
8010493b:	8b 1d 6c 3e 11 80    	mov    0x80113e6c,%ebx
80104941:	85 db                	test   %ebx,%ebx
80104943:	74 a8                	je     801048ed <scheduler+0x10d>
	       int highest_priority = L[3].head->priority;
80104945:	8b 4b 7c             	mov    0x7c(%ebx),%ecx
80104948:	89 d8                	mov    %ebx,%eax
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		   if (tmp->state != RUNNABLE || tmp == 0) continue;
80104950:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104954:	75 0b                	jne    80104961 <scheduler+0x181>
                   if (tmp->priority > highest_priority)
80104956:	8b 50 7c             	mov    0x7c(%eax),%edx
80104959:	39 ca                	cmp    %ecx,%edx
8010495b:	7e 04                	jle    80104961 <scheduler+0x181>
8010495d:	89 d1                	mov    %edx,%ecx
8010495f:	89 c3                	mov    %eax,%ebx
	       for (tmp = L[3].head; tmp != 0; tmp = tmp->next)
80104961:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104967:	85 c0                	test   %eax,%eax
80104969:	75 e5                	jne    80104950 <scheduler+0x170>
               switchuvm(p);
8010496b:	83 ec 0c             	sub    $0xc,%esp
	       c->proc = p;
8010496e:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
               switchuvm(p);
80104974:	53                   	push   %ebx
80104975:	e8 f6 2a 00 00       	call   80107470 <switchuvm>
               p->current_tick++;
8010497a:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
               p->state = RUNNING;
80104981:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
               swtch(&(c->scheduler), p->context);
80104988:	59                   	pop    %ecx
80104989:	5f                   	pop    %edi
8010498a:	ff 73 1c             	pushl  0x1c(%ebx)
8010498d:	ff 75 e0             	pushl  -0x20(%ebp)
80104990:	e8 ae 07 00 00       	call   80105143 <swtch>
               switchkvm();
80104995:	e8 b6 2a 00 00       	call   80107450 <switchkvm>
               if (p->state == ZOMBIE)
8010499a:	83 c4 10             	add    $0x10,%esp
               c->proc = 0;
8010499d:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801049a4:	00 00 00 
               if (p->state == ZOMBIE)
801049a7:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801049ab:	0f 84 7b 01 00 00    	je     80104b2c <scheduler+0x34c>
               else if (p->current_tick >= L[3].time_quantum)
801049b1:	a1 74 3e 11 80       	mov    0x80113e74,%eax
801049b6:	39 83 84 00 00 00    	cmp    %eax,0x84(%ebx)
801049bc:	0f 8c 2b ff ff ff    	jl     801048ed <scheduler+0x10d>
                   p->current_tick = 0;
801049c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801049c9:	00 00 00 
                   if (p->priority > 0)
801049cc:	8b 43 7c             	mov    0x7c(%ebx),%eax
801049cf:	85 c0                	test   %eax,%eax
801049d1:	0f 8e 16 ff ff ff    	jle    801048ed <scheduler+0x10d>
                        p->priority--; 
801049d7:	83 e8 01             	sub    $0x1,%eax
801049da:	89 43 7c             	mov    %eax,0x7c(%ebx)
801049dd:	e9 0b ff ff ff       	jmp    801048ed <scheduler+0x10d>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                       switchuvm(p);
801049e8:	83 ec 0c             	sub    $0xc,%esp
                       c->proc = p;
801049eb:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
                       switchuvm(p);
801049f1:	53                   	push   %ebx
801049f2:	e8 79 2a 00 00       	call   80107470 <switchuvm>
                       p->current_tick++;
801049f7:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
                       p->state = RUNNING;
801049fe:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
                       swtch(&(c->scheduler), p->context);
80104a05:	58                   	pop    %eax
80104a06:	5a                   	pop    %edx
80104a07:	ff 73 1c             	pushl  0x1c(%ebx)
80104a0a:	ff 75 e0             	pushl  -0x20(%ebp)
80104a0d:	e8 31 07 00 00       	call   80105143 <swtch>
                       switchkvm();
80104a12:	e8 39 2a 00 00       	call   80107450 <switchkvm>
                       if (p->state == ZOMBIE)
80104a17:	83 c4 10             	add    $0x10,%esp
                       c->proc = 0;
80104a1a:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104a21:	00 00 00 
                       if (p->state == ZOMBIE)
80104a24:	8b 43 0c             	mov    0xc(%ebx),%eax
80104a27:	83 f8 05             	cmp    $0x5,%eax
80104a2a:	74 64                	je     80104a90 <scheduler+0x2b0>
                       else if (p->current_tick >= L[i].time_quantum && p->state == RUNNABLE)
80104a2c:	8b 57 08             	mov    0x8(%edi),%edx
80104a2f:	39 93 84 00 00 00    	cmp    %edx,0x84(%ebx)
80104a35:	7c 39                	jl     80104a70 <scheduler+0x290>
80104a37:	83 f8 03             	cmp    $0x3,%eax
80104a3a:	75 34                	jne    80104a70 <scheduler+0x290>
		       	   p->current_tick = 0;
80104a3c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104a43:	00 00 00 
                           if (i == 0)
80104a46:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104a49:	85 c9                	test   %ecx,%ecx
80104a4b:	0f 84 82 00 00 00    	je     80104ad3 <scheduler+0x2f3>
                               popQueue(&L[i], p);
80104a51:	83 ec 08             	sub    $0x8,%esp
80104a54:	53                   	push   %ebx
80104a55:	57                   	push   %edi
80104a56:	e8 85 f9 ff ff       	call   801043e0 <popQueue>
			       pushQueue(&L[3], p);
80104a5b:	58                   	pop    %eax
80104a5c:	5a                   	pop    %edx
80104a5d:	53                   	push   %ebx
80104a5e:	68 6c 3e 11 80       	push   $0x80113e6c
80104a63:	e8 68 f4 ff ff       	call   80103ed0 <pushQueue>
80104a68:	83 c4 10             	add    $0x10,%esp
80104a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a6f:	90                   	nop
                   for (p = L[i].head; p != 0; p = p->next)
80104a70:	8b 9b 88 00 00 00    	mov    0x88(%ebx),%ebx
80104a76:	85 db                	test   %ebx,%ebx
80104a78:	0f 84 9c fe ff ff    	je     8010491a <scheduler+0x13a>
                       if (p->state != RUNNABLE) 
80104a7e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104a82:	75 ec                	jne    80104a70 <scheduler+0x290>
80104a84:	e9 5f ff ff ff       	jmp    801049e8 <scheduler+0x208>
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                           popQueue(&L[i], p); 
80104a90:	83 ec 08             	sub    $0x8,%esp
80104a93:	53                   	push   %ebx
80104a94:	57                   	push   %edi
80104a95:	e8 46 f9 ff ff       	call   801043e0 <popQueue>
80104a9a:	83 c4 10             	add    $0x10,%esp
80104a9d:	eb d1                	jmp    80104a70 <scheduler+0x290>
80104a9f:	90                   	nop
        	popQueue(&MoQ, p);
80104aa0:	83 ec 08             	sub    $0x8,%esp
80104aa3:	53                   	push   %ebx
80104aa4:	68 40 3d 11 80       	push   $0x80113d40
80104aa9:	e8 32 f9 ff ff       	call   801043e0 <popQueue>
	    if (MoQ.head == 0)
80104aae:	8b 0d 40 3d 11 80    	mov    0x80113d40,%ecx
        	p->inMoQ = 0;
80104ab4:	83 c4 10             	add    $0x10,%esp
80104ab7:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80104abe:	00 00 00 
	    if (MoQ.head == 0)
80104ac1:	85 c9                	test   %ecx,%ecx
80104ac3:	0f 85 24 fe ff ff    	jne    801048ed <scheduler+0x10d>
                unmonopolize();
80104ac9:	e8 d2 fc ff ff       	call   801047a0 <unmonopolize>
80104ace:	e9 1a fe ff ff       	jmp    801048ed <scheduler+0x10d>
			       popQueue(&L[0], p);
80104ad3:	83 ec 08             	sub    $0x8,%esp
80104ad6:	53                   	push   %ebx
80104ad7:	68 a0 3d 11 80       	push   $0x80113da0
80104adc:	e8 ff f8 ff ff       	call   801043e0 <popQueue>
                               if (p->pid % 2 == 0)
80104ae1:	8b 43 10             	mov    0x10(%ebx),%eax
80104ae4:	83 c4 10             	add    $0x10,%esp
80104ae7:	a8 01                	test   $0x1,%al
80104ae9:	74 2b                	je     80104b16 <scheduler+0x336>
                               else if (p->pid % 2 == 1)
80104aeb:	89 c1                	mov    %eax,%ecx
80104aed:	c1 e9 1f             	shr    $0x1f,%ecx
80104af0:	01 c8                	add    %ecx,%eax
80104af2:	83 e0 01             	and    $0x1,%eax
80104af5:	29 c8                	sub    %ecx,%eax
80104af7:	83 f8 01             	cmp    $0x1,%eax
80104afa:	0f 85 70 ff ff ff    	jne    80104a70 <scheduler+0x290>
                                   pushQueue(&L[1], p);
80104b00:	83 ec 08             	sub    $0x8,%esp
80104b03:	53                   	push   %ebx
80104b04:	68 e4 3d 11 80       	push   $0x80113de4
80104b09:	e8 c2 f3 ff ff       	call   80103ed0 <pushQueue>
80104b0e:	83 c4 10             	add    $0x10,%esp
80104b11:	e9 5a ff ff ff       	jmp    80104a70 <scheduler+0x290>
                                   pushQueue(&L[2], p);
80104b16:	83 ec 08             	sub    $0x8,%esp
80104b19:	53                   	push   %ebx
80104b1a:	68 28 3e 11 80       	push   $0x80113e28
80104b1f:	e8 ac f3 ff ff       	call   80103ed0 <pushQueue>
80104b24:	83 c4 10             	add    $0x10,%esp
80104b27:	e9 44 ff ff ff       	jmp    80104a70 <scheduler+0x290>
                   popQueue(&L[3], p);
80104b2c:	83 ec 08             	sub    $0x8,%esp
80104b2f:	53                   	push   %ebx
80104b30:	68 6c 3e 11 80       	push   $0x80113e6c
80104b35:	e8 a6 f8 ff ff       	call   801043e0 <popQueue>
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	e9 ab fd ff ff       	jmp    801048ed <scheduler+0x10d>
80104b42:	66 90                	xchg   %ax,%ax
80104b44:	66 90                	xchg   %ax,%ax
80104b46:	66 90                	xchg   %ax,%ax
80104b48:	66 90                	xchg   %ax,%ax
80104b4a:	66 90                	xchg   %ax,%ax
80104b4c:	66 90                	xchg   %ax,%ax
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	53                   	push   %ebx
80104b58:	83 ec 0c             	sub    $0xc,%esp
80104b5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b5e:	68 b0 83 10 80       	push   $0x801083b0
80104b63:	8d 43 04             	lea    0x4(%ebx),%eax
80104b66:	50                   	push   %eax
80104b67:	e8 24 01 00 00       	call   80104c90 <initlock>
  lk->name = name;
80104b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104b6f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b75:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b78:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b7f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    
80104b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	56                   	push   %esi
80104b98:	53                   	push   %ebx
80104b99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b9c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	56                   	push   %esi
80104ba3:	e8 68 02 00 00       	call   80104e10 <acquire>
  while (lk->locked) {
80104ba8:	8b 13                	mov    (%ebx),%edx
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 d2                	test   %edx,%edx
80104baf:	74 1a                	je     80104bcb <acquiresleep+0x3b>
80104bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104bb8:	83 ec 08             	sub    $0x8,%esp
80104bbb:	56                   	push   %esi
80104bbc:	53                   	push   %ebx
80104bbd:	e8 0e f0 ff ff       	call   80103bd0 <sleep>
  while (lk->locked) {
80104bc2:	8b 03                	mov    (%ebx),%eax
80104bc4:	83 c4 10             	add    $0x10,%esp
80104bc7:	85 c0                	test   %eax,%eax
80104bc9:	75 ed                	jne    80104bb8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104bcb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104bd1:	e8 3a ee ff ff       	call   80103a10 <myproc>
80104bd6:	8b 40 10             	mov    0x10(%eax),%eax
80104bd9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104bdc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104bdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104be2:	5b                   	pop    %ebx
80104be3:	5e                   	pop    %esi
80104be4:	5d                   	pop    %ebp
  release(&lk->lk);
80104be5:	e9 e6 02 00 00       	jmp    80104ed0 <release>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bf0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	56                   	push   %esi
80104bf8:	53                   	push   %ebx
80104bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bfc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bff:	83 ec 0c             	sub    $0xc,%esp
80104c02:	56                   	push   %esi
80104c03:	e8 08 02 00 00       	call   80104e10 <acquire>
  lk->locked = 0;
80104c08:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c0e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c15:	89 1c 24             	mov    %ebx,(%esp)
80104c18:	e8 d3 f6 ff ff       	call   801042f0 <wakeup>
  release(&lk->lk);
80104c1d:	89 75 08             	mov    %esi,0x8(%ebp)
80104c20:	83 c4 10             	add    $0x10,%esp
}
80104c23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c26:	5b                   	pop    %ebx
80104c27:	5e                   	pop    %esi
80104c28:	5d                   	pop    %ebp
  release(&lk->lk);
80104c29:	e9 a2 02 00 00       	jmp    80104ed0 <release>
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	57                   	push   %edi
80104c38:	31 ff                	xor    %edi,%edi
80104c3a:	56                   	push   %esi
80104c3b:	53                   	push   %ebx
80104c3c:	83 ec 18             	sub    $0x18,%esp
80104c3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c42:	8d 73 04             	lea    0x4(%ebx),%esi
80104c45:	56                   	push   %esi
80104c46:	e8 c5 01 00 00       	call   80104e10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c4b:	8b 03                	mov    (%ebx),%eax
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	85 c0                	test   %eax,%eax
80104c52:	75 1c                	jne    80104c70 <holdingsleep+0x40>
  release(&lk->lk);
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	56                   	push   %esi
80104c58:	e8 73 02 00 00       	call   80104ed0 <release>
  return r;
}
80104c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c60:	89 f8                	mov    %edi,%eax
80104c62:	5b                   	pop    %ebx
80104c63:	5e                   	pop    %esi
80104c64:	5f                   	pop    %edi
80104c65:	5d                   	pop    %ebp
80104c66:	c3                   	ret    
80104c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104c70:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104c73:	e8 98 ed ff ff       	call   80103a10 <myproc>
80104c78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c7b:	0f 94 c0             	sete   %al
80104c7e:	0f b6 c0             	movzbl %al,%eax
80104c81:	89 c7                	mov    %eax,%edi
80104c83:	eb cf                	jmp    80104c54 <holdingsleep+0x24>
80104c85:	66 90                	xchg   %ax,%ax
80104c87:	66 90                	xchg   %ax,%ax
80104c89:	66 90                	xchg   %ax,%ax
80104c8b:	66 90                	xchg   %ax,%ax
80104c8d:	66 90                	xchg   %ax,%ax
80104c8f:	90                   	nop

80104c90 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ca3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ca6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104cad:	5d                   	pop    %ebp
80104cae:	c3                   	ret    
80104caf:	90                   	nop

80104cb0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cb5:	31 d2                	xor    %edx,%edx
{
80104cb7:	89 e5                	mov    %esp,%ebp
80104cb9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cba:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104cc0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104cc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cc7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104cc8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104cce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cd4:	77 1a                	ja     80104cf0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cd6:	8b 58 04             	mov    0x4(%eax),%ebx
80104cd9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104cdc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104cdf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ce1:	83 fa 0a             	cmp    $0xa,%edx
80104ce4:	75 e2                	jne    80104cc8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ce6:	5b                   	pop    %ebx
80104ce7:	5d                   	pop    %ebp
80104ce8:	c3                   	ret    
80104ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104cf0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104cf3:	8d 51 28             	lea    0x28(%ecx),%edx
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d06:	83 c0 04             	add    $0x4,%eax
80104d09:	39 d0                	cmp    %edx,%eax
80104d0b:	75 f3                	jne    80104d00 <getcallerpcs+0x50>
}
80104d0d:	5b                   	pop    %ebx
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret    

80104d10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d10:	f3 0f 1e fb          	endbr32 
80104d14:	55                   	push   %ebp
80104d15:	89 e5                	mov    %esp,%ebp
80104d17:	53                   	push   %ebx
80104d18:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d1b:	9c                   	pushf  
80104d1c:	5b                   	pop    %ebx
  asm volatile("cli");
80104d1d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d1e:	e8 5d ec ff ff       	call   80103980 <mycpu>
80104d23:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d29:	85 c0                	test   %eax,%eax
80104d2b:	74 13                	je     80104d40 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d2d:	e8 4e ec ff ff       	call   80103980 <mycpu>
80104d32:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d39:	83 c4 04             	add    $0x4,%esp
80104d3c:	5b                   	pop    %ebx
80104d3d:	5d                   	pop    %ebp
80104d3e:	c3                   	ret    
80104d3f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d40:	e8 3b ec ff ff       	call   80103980 <mycpu>
80104d45:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d4b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d51:	eb da                	jmp    80104d2d <pushcli+0x1d>
80104d53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d60 <popcli>:

void
popcli(void)
{
80104d60:	f3 0f 1e fb          	endbr32 
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d6a:	9c                   	pushf  
80104d6b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d6c:	f6 c4 02             	test   $0x2,%ah
80104d6f:	75 31                	jne    80104da2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d71:	e8 0a ec ff ff       	call   80103980 <mycpu>
80104d76:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104d7d:	78 30                	js     80104daf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d7f:	e8 fc eb ff ff       	call   80103980 <mycpu>
80104d84:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d8a:	85 d2                	test   %edx,%edx
80104d8c:	74 02                	je     80104d90 <popcli+0x30>
    sti();
}
80104d8e:	c9                   	leave  
80104d8f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d90:	e8 eb eb ff ff       	call   80103980 <mycpu>
80104d95:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d9b:	85 c0                	test   %eax,%eax
80104d9d:	74 ef                	je     80104d8e <popcli+0x2e>
  asm volatile("sti");
80104d9f:	fb                   	sti    
}
80104da0:	c9                   	leave  
80104da1:	c3                   	ret    
    panic("popcli - interruptible");
80104da2:	83 ec 0c             	sub    $0xc,%esp
80104da5:	68 bb 83 10 80       	push   $0x801083bb
80104daa:	e8 e1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104daf:	83 ec 0c             	sub    $0xc,%esp
80104db2:	68 d2 83 10 80       	push   $0x801083d2
80104db7:	e8 d4 b5 ff ff       	call   80100390 <panic>
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104dc0 <holding>:
{
80104dc0:	f3 0f 1e fb          	endbr32 
80104dc4:	55                   	push   %ebp
80104dc5:	89 e5                	mov    %esp,%ebp
80104dc7:	56                   	push   %esi
80104dc8:	53                   	push   %ebx
80104dc9:	8b 75 08             	mov    0x8(%ebp),%esi
80104dcc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104dce:	e8 3d ff ff ff       	call   80104d10 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104dd3:	8b 06                	mov    (%esi),%eax
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	75 0f                	jne    80104de8 <holding+0x28>
  popcli();
80104dd9:	e8 82 ff ff ff       	call   80104d60 <popcli>
}
80104dde:	89 d8                	mov    %ebx,%eax
80104de0:	5b                   	pop    %ebx
80104de1:	5e                   	pop    %esi
80104de2:	5d                   	pop    %ebp
80104de3:	c3                   	ret    
80104de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104de8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104deb:	e8 90 eb ff ff       	call   80103980 <mycpu>
80104df0:	39 c3                	cmp    %eax,%ebx
80104df2:	0f 94 c3             	sete   %bl
  popcli();
80104df5:	e8 66 ff ff ff       	call   80104d60 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104dfa:	0f b6 db             	movzbl %bl,%ebx
}
80104dfd:	89 d8                	mov    %ebx,%eax
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e10 <acquire>:
{
80104e10:	f3 0f 1e fb          	endbr32 
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	56                   	push   %esi
80104e18:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e19:	e8 f2 fe ff ff       	call   80104d10 <pushcli>
  if(holding(lk))
80104e1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e21:	83 ec 0c             	sub    $0xc,%esp
80104e24:	53                   	push   %ebx
80104e25:	e8 96 ff ff ff       	call   80104dc0 <holding>
80104e2a:	83 c4 10             	add    $0x10,%esp
80104e2d:	85 c0                	test   %eax,%eax
80104e2f:	0f 85 7f 00 00 00    	jne    80104eb4 <acquire+0xa4>
80104e35:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e37:	ba 01 00 00 00       	mov    $0x1,%edx
80104e3c:	eb 05                	jmp    80104e43 <acquire+0x33>
80104e3e:	66 90                	xchg   %ax,%ax
80104e40:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e43:	89 d0                	mov    %edx,%eax
80104e45:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e48:	85 c0                	test   %eax,%eax
80104e4a:	75 f4                	jne    80104e40 <acquire+0x30>
  __sync_synchronize();
80104e4c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e51:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e54:	e8 27 eb ff ff       	call   80103980 <mycpu>
80104e59:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e5c:	89 e8                	mov    %ebp,%eax
80104e5e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e60:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104e66:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104e6c:	77 22                	ja     80104e90 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104e6e:	8b 50 04             	mov    0x4(%eax),%edx
80104e71:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104e75:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104e78:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104e7a:	83 fe 0a             	cmp    $0xa,%esi
80104e7d:	75 e1                	jne    80104e60 <acquire+0x50>
}
80104e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e82:	5b                   	pop    %ebx
80104e83:	5e                   	pop    %esi
80104e84:	5d                   	pop    %ebp
80104e85:	c3                   	ret    
80104e86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e8d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104e90:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104e94:	83 c3 34             	add    $0x34,%ebx
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ea6:	83 c0 04             	add    $0x4,%eax
80104ea9:	39 d8                	cmp    %ebx,%eax
80104eab:	75 f3                	jne    80104ea0 <acquire+0x90>
}
80104ead:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104eb0:	5b                   	pop    %ebx
80104eb1:	5e                   	pop    %esi
80104eb2:	5d                   	pop    %ebp
80104eb3:	c3                   	ret    
    panic("acquire");
80104eb4:	83 ec 0c             	sub    $0xc,%esp
80104eb7:	68 d9 83 10 80       	push   $0x801083d9
80104ebc:	e8 cf b4 ff ff       	call   80100390 <panic>
80104ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecf:	90                   	nop

80104ed0 <release>:
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	53                   	push   %ebx
80104ed8:	83 ec 10             	sub    $0x10,%esp
80104edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104ede:	53                   	push   %ebx
80104edf:	e8 dc fe ff ff       	call   80104dc0 <holding>
80104ee4:	83 c4 10             	add    $0x10,%esp
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	74 22                	je     80104f0d <release+0x3d>
  lk->pcs[0] = 0;
80104eeb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104ef2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ef9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104efe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f07:	c9                   	leave  
  popcli();
80104f08:	e9 53 fe ff ff       	jmp    80104d60 <popcli>
    panic("release");
80104f0d:	83 ec 0c             	sub    $0xc,%esp
80104f10:	68 e1 83 10 80       	push   $0x801083e1
80104f15:	e8 76 b4 ff ff       	call   80100390 <panic>
80104f1a:	66 90                	xchg   %ax,%ax
80104f1c:	66 90                	xchg   %ax,%ax
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	57                   	push   %edi
80104f28:	8b 55 08             	mov    0x8(%ebp),%edx
80104f2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f2e:	53                   	push   %ebx
80104f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f32:	89 d7                	mov    %edx,%edi
80104f34:	09 cf                	or     %ecx,%edi
80104f36:	83 e7 03             	and    $0x3,%edi
80104f39:	75 25                	jne    80104f60 <memset+0x40>
    c &= 0xFF;
80104f3b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f3e:	c1 e0 18             	shl    $0x18,%eax
80104f41:	89 fb                	mov    %edi,%ebx
80104f43:	c1 e9 02             	shr    $0x2,%ecx
80104f46:	c1 e3 10             	shl    $0x10,%ebx
80104f49:	09 d8                	or     %ebx,%eax
80104f4b:	09 f8                	or     %edi,%eax
80104f4d:	c1 e7 08             	shl    $0x8,%edi
80104f50:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f52:	89 d7                	mov    %edx,%edi
80104f54:	fc                   	cld    
80104f55:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f57:	5b                   	pop    %ebx
80104f58:	89 d0                	mov    %edx,%eax
80104f5a:	5f                   	pop    %edi
80104f5b:	5d                   	pop    %ebp
80104f5c:	c3                   	ret    
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104f60:	89 d7                	mov    %edx,%edi
80104f62:	fc                   	cld    
80104f63:	f3 aa                	rep stos %al,%es:(%edi)
80104f65:	5b                   	pop    %ebx
80104f66:	89 d0                	mov    %edx,%eax
80104f68:	5f                   	pop    %edi
80104f69:	5d                   	pop    %ebp
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop

80104f70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104f70:	f3 0f 1e fb          	endbr32 
80104f74:	55                   	push   %ebp
80104f75:	89 e5                	mov    %esp,%ebp
80104f77:	56                   	push   %esi
80104f78:	8b 75 10             	mov    0x10(%ebp),%esi
80104f7b:	8b 55 08             	mov    0x8(%ebp),%edx
80104f7e:	53                   	push   %ebx
80104f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104f82:	85 f6                	test   %esi,%esi
80104f84:	74 2a                	je     80104fb0 <memcmp+0x40>
80104f86:	01 c6                	add    %eax,%esi
80104f88:	eb 10                	jmp    80104f9a <memcmp+0x2a>
80104f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f90:	83 c0 01             	add    $0x1,%eax
80104f93:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f96:	39 f0                	cmp    %esi,%eax
80104f98:	74 16                	je     80104fb0 <memcmp+0x40>
    if(*s1 != *s2)
80104f9a:	0f b6 0a             	movzbl (%edx),%ecx
80104f9d:	0f b6 18             	movzbl (%eax),%ebx
80104fa0:	38 d9                	cmp    %bl,%cl
80104fa2:	74 ec                	je     80104f90 <memcmp+0x20>
      return *s1 - *s2;
80104fa4:	0f b6 c1             	movzbl %cl,%eax
80104fa7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104fa9:	5b                   	pop    %ebx
80104faa:	5e                   	pop    %esi
80104fab:	5d                   	pop    %ebp
80104fac:	c3                   	ret    
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
80104fb0:	5b                   	pop    %ebx
  return 0;
80104fb1:	31 c0                	xor    %eax,%eax
}
80104fb3:	5e                   	pop    %esi
80104fb4:	5d                   	pop    %ebp
80104fb5:	c3                   	ret    
80104fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi

80104fc0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	57                   	push   %edi
80104fc8:	8b 55 08             	mov    0x8(%ebp),%edx
80104fcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104fce:	56                   	push   %esi
80104fcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104fd2:	39 d6                	cmp    %edx,%esi
80104fd4:	73 2a                	jae    80105000 <memmove+0x40>
80104fd6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104fd9:	39 fa                	cmp    %edi,%edx
80104fdb:	73 23                	jae    80105000 <memmove+0x40>
80104fdd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104fe0:	85 c9                	test   %ecx,%ecx
80104fe2:	74 13                	je     80104ff7 <memmove+0x37>
80104fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104fe8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104fec:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104fef:	83 e8 01             	sub    $0x1,%eax
80104ff2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104ff5:	75 f1                	jne    80104fe8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104ff7:	5e                   	pop    %esi
80104ff8:	89 d0                	mov    %edx,%eax
80104ffa:	5f                   	pop    %edi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret    
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105000:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105003:	89 d7                	mov    %edx,%edi
80105005:	85 c9                	test   %ecx,%ecx
80105007:	74 ee                	je     80104ff7 <memmove+0x37>
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105010:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105011:	39 f0                	cmp    %esi,%eax
80105013:	75 fb                	jne    80105010 <memmove+0x50>
}
80105015:	5e                   	pop    %esi
80105016:	89 d0                	mov    %edx,%eax
80105018:	5f                   	pop    %edi
80105019:	5d                   	pop    %ebp
8010501a:	c3                   	ret    
8010501b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010501f:	90                   	nop

80105020 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105020:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105024:	eb 9a                	jmp    80104fc0 <memmove>
80105026:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010502d:	8d 76 00             	lea    0x0(%esi),%esi

80105030 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105030:	f3 0f 1e fb          	endbr32 
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
80105037:	56                   	push   %esi
80105038:	8b 75 10             	mov    0x10(%ebp),%esi
8010503b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010503e:	53                   	push   %ebx
8010503f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105042:	85 f6                	test   %esi,%esi
80105044:	74 32                	je     80105078 <strncmp+0x48>
80105046:	01 c6                	add    %eax,%esi
80105048:	eb 14                	jmp    8010505e <strncmp+0x2e>
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105050:	38 da                	cmp    %bl,%dl
80105052:	75 14                	jne    80105068 <strncmp+0x38>
    n--, p++, q++;
80105054:	83 c0 01             	add    $0x1,%eax
80105057:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010505a:	39 f0                	cmp    %esi,%eax
8010505c:	74 1a                	je     80105078 <strncmp+0x48>
8010505e:	0f b6 11             	movzbl (%ecx),%edx
80105061:	0f b6 18             	movzbl (%eax),%ebx
80105064:	84 d2                	test   %dl,%dl
80105066:	75 e8                	jne    80105050 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105068:	0f b6 c2             	movzbl %dl,%eax
8010506b:	29 d8                	sub    %ebx,%eax
}
8010506d:	5b                   	pop    %ebx
8010506e:	5e                   	pop    %esi
8010506f:	5d                   	pop    %ebp
80105070:	c3                   	ret    
80105071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105078:	5b                   	pop    %ebx
    return 0;
80105079:	31 c0                	xor    %eax,%eax
}
8010507b:	5e                   	pop    %esi
8010507c:	5d                   	pop    %ebp
8010507d:	c3                   	ret    
8010507e:	66 90                	xchg   %ax,%ax

80105080 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	57                   	push   %edi
80105088:	56                   	push   %esi
80105089:	8b 75 08             	mov    0x8(%ebp),%esi
8010508c:	53                   	push   %ebx
8010508d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105090:	89 f2                	mov    %esi,%edx
80105092:	eb 1b                	jmp    801050af <strncpy+0x2f>
80105094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105098:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010509c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010509f:	83 c2 01             	add    $0x1,%edx
801050a2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801050a6:	89 f9                	mov    %edi,%ecx
801050a8:	88 4a ff             	mov    %cl,-0x1(%edx)
801050ab:	84 c9                	test   %cl,%cl
801050ad:	74 09                	je     801050b8 <strncpy+0x38>
801050af:	89 c3                	mov    %eax,%ebx
801050b1:	83 e8 01             	sub    $0x1,%eax
801050b4:	85 db                	test   %ebx,%ebx
801050b6:	7f e0                	jg     80105098 <strncpy+0x18>
    ;
  while(n-- > 0)
801050b8:	89 d1                	mov    %edx,%ecx
801050ba:	85 c0                	test   %eax,%eax
801050bc:	7e 15                	jle    801050d3 <strncpy+0x53>
801050be:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801050c0:	83 c1 01             	add    $0x1,%ecx
801050c3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801050c7:	89 c8                	mov    %ecx,%eax
801050c9:	f7 d0                	not    %eax
801050cb:	01 d0                	add    %edx,%eax
801050cd:	01 d8                	add    %ebx,%eax
801050cf:	85 c0                	test   %eax,%eax
801050d1:	7f ed                	jg     801050c0 <strncpy+0x40>
  return os;
}
801050d3:	5b                   	pop    %ebx
801050d4:	89 f0                	mov    %esi,%eax
801050d6:	5e                   	pop    %esi
801050d7:	5f                   	pop    %edi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801050e0:	f3 0f 1e fb          	endbr32 
801050e4:	55                   	push   %ebp
801050e5:	89 e5                	mov    %esp,%ebp
801050e7:	56                   	push   %esi
801050e8:	8b 55 10             	mov    0x10(%ebp),%edx
801050eb:	8b 75 08             	mov    0x8(%ebp),%esi
801050ee:	53                   	push   %ebx
801050ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801050f2:	85 d2                	test   %edx,%edx
801050f4:	7e 21                	jle    80105117 <safestrcpy+0x37>
801050f6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801050fa:	89 f2                	mov    %esi,%edx
801050fc:	eb 12                	jmp    80105110 <safestrcpy+0x30>
801050fe:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105100:	0f b6 08             	movzbl (%eax),%ecx
80105103:	83 c0 01             	add    $0x1,%eax
80105106:	83 c2 01             	add    $0x1,%edx
80105109:	88 4a ff             	mov    %cl,-0x1(%edx)
8010510c:	84 c9                	test   %cl,%cl
8010510e:	74 04                	je     80105114 <safestrcpy+0x34>
80105110:	39 d8                	cmp    %ebx,%eax
80105112:	75 ec                	jne    80105100 <safestrcpy+0x20>
    ;
  *s = 0;
80105114:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105117:	89 f0                	mov    %esi,%eax
80105119:	5b                   	pop    %ebx
8010511a:	5e                   	pop    %esi
8010511b:	5d                   	pop    %ebp
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi

80105120 <strlen>:

int
strlen(const char *s)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105125:	31 c0                	xor    %eax,%eax
{
80105127:	89 e5                	mov    %esp,%ebp
80105129:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010512c:	80 3a 00             	cmpb   $0x0,(%edx)
8010512f:	74 10                	je     80105141 <strlen+0x21>
80105131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105138:	83 c0 01             	add    $0x1,%eax
8010513b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010513f:	75 f7                	jne    80105138 <strlen+0x18>
    ;
  return n;
}
80105141:	5d                   	pop    %ebp
80105142:	c3                   	ret    

80105143 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105143:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105147:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010514b:	55                   	push   %ebp
  pushl %ebx
8010514c:	53                   	push   %ebx
  pushl %esi
8010514d:	56                   	push   %esi
  pushl %edi
8010514e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010514f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105151:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105153:	5f                   	pop    %edi
  popl %esi
80105154:	5e                   	pop    %esi
  popl %ebx
80105155:	5b                   	pop    %ebx
  popl %ebp
80105156:	5d                   	pop    %ebp
  ret
80105157:	c3                   	ret    
80105158:	66 90                	xchg   %ax,%ax
8010515a:	66 90                	xchg   %ax,%ax
8010515c:	66 90                	xchg   %ax,%ax
8010515e:	66 90                	xchg   %ax,%ax

80105160 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	53                   	push   %ebx
80105168:	83 ec 04             	sub    $0x4,%esp
8010516b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010516e:	e8 9d e8 ff ff       	call   80103a10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105173:	8b 00                	mov    (%eax),%eax
80105175:	39 d8                	cmp    %ebx,%eax
80105177:	76 17                	jbe    80105190 <fetchint+0x30>
80105179:	8d 53 04             	lea    0x4(%ebx),%edx
8010517c:	39 d0                	cmp    %edx,%eax
8010517e:	72 10                	jb     80105190 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105180:	8b 45 0c             	mov    0xc(%ebp),%eax
80105183:	8b 13                	mov    (%ebx),%edx
80105185:	89 10                	mov    %edx,(%eax)
  return 0;
80105187:	31 c0                	xor    %eax,%eax
}
80105189:	83 c4 04             	add    $0x4,%esp
8010518c:	5b                   	pop    %ebx
8010518d:	5d                   	pop    %ebp
8010518e:	c3                   	ret    
8010518f:	90                   	nop
    return -1;
80105190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105195:	eb f2                	jmp    80105189 <fetchint+0x29>
80105197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	53                   	push   %ebx
801051a8:	83 ec 04             	sub    $0x4,%esp
801051ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051ae:	e8 5d e8 ff ff       	call   80103a10 <myproc>

  if(addr >= curproc->sz)
801051b3:	39 18                	cmp    %ebx,(%eax)
801051b5:	76 31                	jbe    801051e8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801051b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051be:	39 d3                	cmp    %edx,%ebx
801051c0:	73 26                	jae    801051e8 <fetchstr+0x48>
801051c2:	89 d8                	mov    %ebx,%eax
801051c4:	eb 11                	jmp    801051d7 <fetchstr+0x37>
801051c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051cd:	8d 76 00             	lea    0x0(%esi),%esi
801051d0:	83 c0 01             	add    $0x1,%eax
801051d3:	39 c2                	cmp    %eax,%edx
801051d5:	76 11                	jbe    801051e8 <fetchstr+0x48>
    if(*s == 0)
801051d7:	80 38 00             	cmpb   $0x0,(%eax)
801051da:	75 f4                	jne    801051d0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801051dc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801051df:	29 d8                	sub    %ebx,%eax
}
801051e1:	5b                   	pop    %ebx
801051e2:	5d                   	pop    %ebp
801051e3:	c3                   	ret    
801051e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051e8:	83 c4 04             	add    $0x4,%esp
    return -1;
801051eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f0:	5b                   	pop    %ebx
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret    
801051f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105200 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105200:	f3 0f 1e fb          	endbr32 
80105204:	55                   	push   %ebp
80105205:	89 e5                	mov    %esp,%ebp
80105207:	56                   	push   %esi
80105208:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105209:	e8 02 e8 ff ff       	call   80103a10 <myproc>
8010520e:	8b 55 08             	mov    0x8(%ebp),%edx
80105211:	8b 40 18             	mov    0x18(%eax),%eax
80105214:	8b 40 44             	mov    0x44(%eax),%eax
80105217:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010521a:	e8 f1 e7 ff ff       	call   80103a10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010521f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105222:	8b 00                	mov    (%eax),%eax
80105224:	39 c6                	cmp    %eax,%esi
80105226:	73 18                	jae    80105240 <argint+0x40>
80105228:	8d 53 08             	lea    0x8(%ebx),%edx
8010522b:	39 d0                	cmp    %edx,%eax
8010522d:	72 11                	jb     80105240 <argint+0x40>
  *ip = *(int*)(addr);
8010522f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105232:	8b 53 04             	mov    0x4(%ebx),%edx
80105235:	89 10                	mov    %edx,(%eax)
  return 0;
80105237:	31 c0                	xor    %eax,%eax
}
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5d                   	pop    %ebp
8010523c:	c3                   	ret    
8010523d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105245:	eb f2                	jmp    80105239 <argint+0x39>
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105250:	f3 0f 1e fb          	endbr32 
80105254:	55                   	push   %ebp
80105255:	89 e5                	mov    %esp,%ebp
80105257:	56                   	push   %esi
80105258:	53                   	push   %ebx
80105259:	83 ec 10             	sub    $0x10,%esp
8010525c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010525f:	e8 ac e7 ff ff       	call   80103a10 <myproc>
 
  if(argint(n, &i) < 0)
80105264:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105267:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105269:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526c:	50                   	push   %eax
8010526d:	ff 75 08             	pushl  0x8(%ebp)
80105270:	e8 8b ff ff ff       	call   80105200 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105275:	83 c4 10             	add    $0x10,%esp
80105278:	85 c0                	test   %eax,%eax
8010527a:	78 24                	js     801052a0 <argptr+0x50>
8010527c:	85 db                	test   %ebx,%ebx
8010527e:	78 20                	js     801052a0 <argptr+0x50>
80105280:	8b 16                	mov    (%esi),%edx
80105282:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105285:	39 c2                	cmp    %eax,%edx
80105287:	76 17                	jbe    801052a0 <argptr+0x50>
80105289:	01 c3                	add    %eax,%ebx
8010528b:	39 da                	cmp    %ebx,%edx
8010528d:	72 11                	jb     801052a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010528f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105292:	89 02                	mov    %eax,(%edx)
  return 0;
80105294:	31 c0                	xor    %eax,%eax
}
80105296:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105299:	5b                   	pop    %ebx
8010529a:	5e                   	pop    %esi
8010529b:	5d                   	pop    %ebp
8010529c:	c3                   	ret    
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a5:	eb ef                	jmp    80105296 <argptr+0x46>
801052a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ae:	66 90                	xchg   %ax,%ax

801052b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052bd:	50                   	push   %eax
801052be:	ff 75 08             	pushl  0x8(%ebp)
801052c1:	e8 3a ff ff ff       	call   80105200 <argint>
801052c6:	83 c4 10             	add    $0x10,%esp
801052c9:	85 c0                	test   %eax,%eax
801052cb:	78 13                	js     801052e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801052cd:	83 ec 08             	sub    $0x8,%esp
801052d0:	ff 75 0c             	pushl  0xc(%ebp)
801052d3:	ff 75 f4             	pushl  -0xc(%ebp)
801052d6:	e8 c5 fe ff ff       	call   801051a0 <fetchstr>
801052db:	83 c4 10             	add    $0x10,%esp
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    
801052e0:	c9                   	leave  
    return -1;
801052e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e6:	c3                   	ret    
801052e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <syscall>:
[SYS_unmonopolize] sys_unmonopolize,
};

void
syscall(void)
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	53                   	push   %ebx
801052f8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801052fb:	e8 10 e7 ff ff       	call   80103a10 <myproc>
80105300:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105302:	8b 40 18             	mov    0x18(%eax),%eax
80105305:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105308:	8d 50 ff             	lea    -0x1(%eax),%edx
8010530b:	83 fa 1c             	cmp    $0x1c,%edx
8010530e:	77 20                	ja     80105330 <syscall+0x40>
80105310:	8b 14 85 20 84 10 80 	mov    -0x7fef7be0(,%eax,4),%edx
80105317:	85 d2                	test   %edx,%edx
80105319:	74 15                	je     80105330 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010531b:	ff d2                	call   *%edx
8010531d:	89 c2                	mov    %eax,%edx
8010531f:	8b 43 18             	mov    0x18(%ebx),%eax
80105322:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105325:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105328:	c9                   	leave  
80105329:	c3                   	ret    
8010532a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105330:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105331:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105334:	50                   	push   %eax
80105335:	ff 73 10             	pushl  0x10(%ebx)
80105338:	68 e9 83 10 80       	push   $0x801083e9
8010533d:	e8 6e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105342:	8b 43 18             	mov    0x18(%ebx),%eax
80105345:	83 c4 10             	add    $0x10,%esp
80105348:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010534f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105352:	c9                   	leave  
80105353:	c3                   	ret    
80105354:	66 90                	xchg   %ax,%ax
80105356:	66 90                	xchg   %ax,%ax
80105358:	66 90                	xchg   %ax,%ax
8010535a:	66 90                	xchg   %ax,%ax
8010535c:	66 90                	xchg   %ax,%ax
8010535e:	66 90                	xchg   %ax,%ax

80105360 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105365:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105368:	53                   	push   %ebx
80105369:	83 ec 34             	sub    $0x34,%esp
8010536c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010536f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105372:	57                   	push   %edi
80105373:	50                   	push   %eax
{
80105374:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105377:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010537a:	e8 d1 cc ff ff       	call   80102050 <nameiparent>
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	85 c0                	test   %eax,%eax
80105384:	0f 84 46 01 00 00    	je     801054d0 <create+0x170>
    return 0;
  ilock(dp);
8010538a:	83 ec 0c             	sub    $0xc,%esp
8010538d:	89 c3                	mov    %eax,%ebx
8010538f:	50                   	push   %eax
80105390:	e8 cb c3 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105395:	83 c4 0c             	add    $0xc,%esp
80105398:	6a 00                	push   $0x0
8010539a:	57                   	push   %edi
8010539b:	53                   	push   %ebx
8010539c:	e8 0f c9 ff ff       	call   80101cb0 <dirlookup>
801053a1:	83 c4 10             	add    $0x10,%esp
801053a4:	89 c6                	mov    %eax,%esi
801053a6:	85 c0                	test   %eax,%eax
801053a8:	74 56                	je     80105400 <create+0xa0>
    iunlockput(dp);
801053aa:	83 ec 0c             	sub    $0xc,%esp
801053ad:	53                   	push   %ebx
801053ae:	e8 4d c6 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
801053b3:	89 34 24             	mov    %esi,(%esp)
801053b6:	e8 a5 c3 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053bb:	83 c4 10             	add    $0x10,%esp
801053be:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801053c3:	75 1b                	jne    801053e0 <create+0x80>
801053c5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801053ca:	75 14                	jne    801053e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801053cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053cf:	89 f0                	mov    %esi,%eax
801053d1:	5b                   	pop    %ebx
801053d2:	5e                   	pop    %esi
801053d3:	5f                   	pop    %edi
801053d4:	5d                   	pop    %ebp
801053d5:	c3                   	ret    
801053d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053e0:	83 ec 0c             	sub    $0xc,%esp
801053e3:	56                   	push   %esi
    return 0;
801053e4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801053e6:	e8 15 c6 ff ff       	call   80101a00 <iunlockput>
    return 0;
801053eb:	83 c4 10             	add    $0x10,%esp
}
801053ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f1:	89 f0                	mov    %esi,%eax
801053f3:	5b                   	pop    %ebx
801053f4:	5e                   	pop    %esi
801053f5:	5f                   	pop    %edi
801053f6:	5d                   	pop    %ebp
801053f7:	c3                   	ret    
801053f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105400:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105404:	83 ec 08             	sub    $0x8,%esp
80105407:	50                   	push   %eax
80105408:	ff 33                	pushl  (%ebx)
8010540a:	e8 d1 c1 ff ff       	call   801015e0 <ialloc>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	89 c6                	mov    %eax,%esi
80105414:	85 c0                	test   %eax,%eax
80105416:	0f 84 cd 00 00 00    	je     801054e9 <create+0x189>
  ilock(ip);
8010541c:	83 ec 0c             	sub    $0xc,%esp
8010541f:	50                   	push   %eax
80105420:	e8 3b c3 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105425:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105429:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010542d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105431:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105435:	b8 01 00 00 00       	mov    $0x1,%eax
8010543a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010543e:	89 34 24             	mov    %esi,(%esp)
80105441:	e8 5a c2 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010544e:	74 30                	je     80105480 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105450:	83 ec 04             	sub    $0x4,%esp
80105453:	ff 76 04             	pushl  0x4(%esi)
80105456:	57                   	push   %edi
80105457:	53                   	push   %ebx
80105458:	e8 13 cb ff ff       	call   80101f70 <dirlink>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 78                	js     801054dc <create+0x17c>
  iunlockput(dp);
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	53                   	push   %ebx
80105468:	e8 93 c5 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010546d:	83 c4 10             	add    $0x10,%esp
}
80105470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105473:	89 f0                	mov    %esi,%eax
80105475:	5b                   	pop    %ebx
80105476:	5e                   	pop    %esi
80105477:	5f                   	pop    %edi
80105478:	5d                   	pop    %ebp
80105479:	c3                   	ret    
8010547a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105480:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105483:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105488:	53                   	push   %ebx
80105489:	e8 12 c2 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010548e:	83 c4 0c             	add    $0xc,%esp
80105491:	ff 76 04             	pushl  0x4(%esi)
80105494:	68 b4 84 10 80       	push   $0x801084b4
80105499:	56                   	push   %esi
8010549a:	e8 d1 ca ff ff       	call   80101f70 <dirlink>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	85 c0                	test   %eax,%eax
801054a4:	78 18                	js     801054be <create+0x15e>
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	ff 73 04             	pushl  0x4(%ebx)
801054ac:	68 b3 84 10 80       	push   $0x801084b3
801054b1:	56                   	push   %esi
801054b2:	e8 b9 ca ff ff       	call   80101f70 <dirlink>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	85 c0                	test   %eax,%eax
801054bc:	79 92                	jns    80105450 <create+0xf0>
      panic("create dots");
801054be:	83 ec 0c             	sub    $0xc,%esp
801054c1:	68 a7 84 10 80       	push   $0x801084a7
801054c6:	e8 c5 ae ff ff       	call   80100390 <panic>
801054cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
}
801054d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801054d3:	31 f6                	xor    %esi,%esi
}
801054d5:	5b                   	pop    %ebx
801054d6:	89 f0                	mov    %esi,%eax
801054d8:	5e                   	pop    %esi
801054d9:	5f                   	pop    %edi
801054da:	5d                   	pop    %ebp
801054db:	c3                   	ret    
    panic("create: dirlink");
801054dc:	83 ec 0c             	sub    $0xc,%esp
801054df:	68 b6 84 10 80       	push   $0x801084b6
801054e4:	e8 a7 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801054e9:	83 ec 0c             	sub    $0xc,%esp
801054ec:	68 98 84 10 80       	push   $0x80108498
801054f1:	e8 9a ae ff ff       	call   80100390 <panic>
801054f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054fd:	8d 76 00             	lea    0x0(%esi),%esi

80105500 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	89 d6                	mov    %edx,%esi
80105506:	53                   	push   %ebx
80105507:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105509:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010550c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010550f:	50                   	push   %eax
80105510:	6a 00                	push   $0x0
80105512:	e8 e9 fc ff ff       	call   80105200 <argint>
80105517:	83 c4 10             	add    $0x10,%esp
8010551a:	85 c0                	test   %eax,%eax
8010551c:	78 2a                	js     80105548 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010551e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105522:	77 24                	ja     80105548 <argfd.constprop.0+0x48>
80105524:	e8 e7 e4 ff ff       	call   80103a10 <myproc>
80105529:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010552c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105530:	85 c0                	test   %eax,%eax
80105532:	74 14                	je     80105548 <argfd.constprop.0+0x48>
  if(pfd)
80105534:	85 db                	test   %ebx,%ebx
80105536:	74 02                	je     8010553a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105538:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010553a:	89 06                	mov    %eax,(%esi)
  return 0;
8010553c:	31 c0                	xor    %eax,%eax
}
8010553e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105541:	5b                   	pop    %ebx
80105542:	5e                   	pop    %esi
80105543:	5d                   	pop    %ebp
80105544:	c3                   	ret    
80105545:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	eb ef                	jmp    8010553e <argfd.constprop.0+0x3e>
8010554f:	90                   	nop

80105550 <sys_dup>:
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105555:	31 c0                	xor    %eax,%eax
{
80105557:	89 e5                	mov    %esp,%ebp
80105559:	56                   	push   %esi
8010555a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010555b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010555e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105561:	e8 9a ff ff ff       	call   80105500 <argfd.constprop.0>
80105566:	85 c0                	test   %eax,%eax
80105568:	78 1e                	js     80105588 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010556a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010556d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010556f:	e8 9c e4 ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105578:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010557c:	85 d2                	test   %edx,%edx
8010557e:	74 20                	je     801055a0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105580:	83 c3 01             	add    $0x1,%ebx
80105583:	83 fb 10             	cmp    $0x10,%ebx
80105586:	75 f0                	jne    80105578 <sys_dup+0x28>
}
80105588:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010558b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105590:	89 d8                	mov    %ebx,%eax
80105592:	5b                   	pop    %ebx
80105593:	5e                   	pop    %esi
80105594:	5d                   	pop    %ebp
80105595:	c3                   	ret    
80105596:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055a0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055a4:	83 ec 0c             	sub    $0xc,%esp
801055a7:	ff 75 f4             	pushl  -0xc(%ebp)
801055aa:	e8 c1 b8 ff ff       	call   80100e70 <filedup>
  return fd;
801055af:	83 c4 10             	add    $0x10,%esp
}
801055b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055b5:	89 d8                	mov    %ebx,%eax
801055b7:	5b                   	pop    %ebx
801055b8:	5e                   	pop    %esi
801055b9:	5d                   	pop    %ebp
801055ba:	c3                   	ret    
801055bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055bf:	90                   	nop

801055c0 <sys_read>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055c5:	31 c0                	xor    %eax,%eax
{
801055c7:	89 e5                	mov    %esp,%ebp
801055c9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055cc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801055cf:	e8 2c ff ff ff       	call   80105500 <argfd.constprop.0>
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 48                	js     80105620 <sys_read+0x60>
801055d8:	83 ec 08             	sub    $0x8,%esp
801055db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 02                	push   $0x2
801055e1:	e8 1a fc ff ff       	call   80105200 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 33                	js     80105620 <sys_read+0x60>
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055f3:	ff 75 f0             	pushl  -0x10(%ebp)
801055f6:	50                   	push   %eax
801055f7:	6a 01                	push   $0x1
801055f9:	e8 52 fc ff ff       	call   80105250 <argptr>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	78 1b                	js     80105620 <sys_read+0x60>
  return fileread(f, p, n);
80105605:	83 ec 04             	sub    $0x4,%esp
80105608:	ff 75 f0             	pushl  -0x10(%ebp)
8010560b:	ff 75 f4             	pushl  -0xc(%ebp)
8010560e:	ff 75 ec             	pushl  -0x14(%ebp)
80105611:	e8 da b9 ff ff       	call   80100ff0 <fileread>
80105616:	83 c4 10             	add    $0x10,%esp
}
80105619:	c9                   	leave  
8010561a:	c3                   	ret    
8010561b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010561f:	90                   	nop
80105620:	c9                   	leave  
    return -1;
80105621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105626:	c3                   	ret    
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_write>:
{
80105630:	f3 0f 1e fb          	endbr32 
80105634:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105635:	31 c0                	xor    %eax,%eax
{
80105637:	89 e5                	mov    %esp,%ebp
80105639:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010563c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010563f:	e8 bc fe ff ff       	call   80105500 <argfd.constprop.0>
80105644:	85 c0                	test   %eax,%eax
80105646:	78 48                	js     80105690 <sys_write+0x60>
80105648:	83 ec 08             	sub    $0x8,%esp
8010564b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010564e:	50                   	push   %eax
8010564f:	6a 02                	push   $0x2
80105651:	e8 aa fb ff ff       	call   80105200 <argint>
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	85 c0                	test   %eax,%eax
8010565b:	78 33                	js     80105690 <sys_write+0x60>
8010565d:	83 ec 04             	sub    $0x4,%esp
80105660:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105663:	ff 75 f0             	pushl  -0x10(%ebp)
80105666:	50                   	push   %eax
80105667:	6a 01                	push   $0x1
80105669:	e8 e2 fb ff ff       	call   80105250 <argptr>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	85 c0                	test   %eax,%eax
80105673:	78 1b                	js     80105690 <sys_write+0x60>
  return filewrite(f, p, n);
80105675:	83 ec 04             	sub    $0x4,%esp
80105678:	ff 75 f0             	pushl  -0x10(%ebp)
8010567b:	ff 75 f4             	pushl  -0xc(%ebp)
8010567e:	ff 75 ec             	pushl  -0x14(%ebp)
80105681:	e8 0a ba ff ff       	call   80101090 <filewrite>
80105686:	83 c4 10             	add    $0x10,%esp
}
80105689:	c9                   	leave  
8010568a:	c3                   	ret    
8010568b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010568f:	90                   	nop
80105690:	c9                   	leave  
    return -1;
80105691:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105696:	c3                   	ret    
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_close>:
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056aa:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b0:	e8 4b fe ff ff       	call   80105500 <argfd.constprop.0>
801056b5:	85 c0                	test   %eax,%eax
801056b7:	78 27                	js     801056e0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056b9:	e8 52 e3 ff ff       	call   80103a10 <myproc>
801056be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801056c1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801056c4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801056cb:	00 
  fileclose(f);
801056cc:	ff 75 f4             	pushl  -0xc(%ebp)
801056cf:	e8 ec b7 ff ff       	call   80100ec0 <fileclose>
  return 0;
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	31 c0                	xor    %eax,%eax
}
801056d9:	c9                   	leave  
801056da:	c3                   	ret    
801056db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056df:	90                   	nop
801056e0:	c9                   	leave  
    return -1;
801056e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e6:	c3                   	ret    
801056e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_fstat>:
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056f5:	31 c0                	xor    %eax,%eax
{
801056f7:	89 e5                	mov    %esp,%ebp
801056f9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056fc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801056ff:	e8 fc fd ff ff       	call   80105500 <argfd.constprop.0>
80105704:	85 c0                	test   %eax,%eax
80105706:	78 30                	js     80105738 <sys_fstat+0x48>
80105708:	83 ec 04             	sub    $0x4,%esp
8010570b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010570e:	6a 14                	push   $0x14
80105710:	50                   	push   %eax
80105711:	6a 01                	push   $0x1
80105713:	e8 38 fb ff ff       	call   80105250 <argptr>
80105718:	83 c4 10             	add    $0x10,%esp
8010571b:	85 c0                	test   %eax,%eax
8010571d:	78 19                	js     80105738 <sys_fstat+0x48>
  return filestat(f, st);
8010571f:	83 ec 08             	sub    $0x8,%esp
80105722:	ff 75 f4             	pushl  -0xc(%ebp)
80105725:	ff 75 f0             	pushl  -0x10(%ebp)
80105728:	e8 73 b8 ff ff       	call   80100fa0 <filestat>
8010572d:	83 c4 10             	add    $0x10,%esp
}
80105730:	c9                   	leave  
80105731:	c3                   	ret    
80105732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105738:	c9                   	leave  
    return -1;
80105739:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_link>:
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	57                   	push   %edi
80105748:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105749:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010574c:	53                   	push   %ebx
8010574d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105750:	50                   	push   %eax
80105751:	6a 00                	push   $0x0
80105753:	e8 58 fb ff ff       	call   801052b0 <argstr>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	0f 88 ff 00 00 00    	js     80105862 <sys_link+0x122>
80105763:	83 ec 08             	sub    $0x8,%esp
80105766:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105769:	50                   	push   %eax
8010576a:	6a 01                	push   $0x1
8010576c:	e8 3f fb ff ff       	call   801052b0 <argstr>
80105771:	83 c4 10             	add    $0x10,%esp
80105774:	85 c0                	test   %eax,%eax
80105776:	0f 88 e6 00 00 00    	js     80105862 <sys_link+0x122>
  begin_op();
8010577c:	e8 af d5 ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105781:	83 ec 0c             	sub    $0xc,%esp
80105784:	ff 75 d4             	pushl  -0x2c(%ebp)
80105787:	e8 a4 c8 ff ff       	call   80102030 <namei>
8010578c:	83 c4 10             	add    $0x10,%esp
8010578f:	89 c3                	mov    %eax,%ebx
80105791:	85 c0                	test   %eax,%eax
80105793:	0f 84 e8 00 00 00    	je     80105881 <sys_link+0x141>
  ilock(ip);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 be bf ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057aa:	0f 84 b9 00 00 00    	je     80105869 <sys_link+0x129>
  iupdate(ip);
801057b0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057b3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057b8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057bb:	53                   	push   %ebx
801057bc:	e8 df be ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801057c1:	89 1c 24             	mov    %ebx,(%esp)
801057c4:	e8 77 c0 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801057c9:	58                   	pop    %eax
801057ca:	5a                   	pop    %edx
801057cb:	57                   	push   %edi
801057cc:	ff 75 d0             	pushl  -0x30(%ebp)
801057cf:	e8 7c c8 ff ff       	call   80102050 <nameiparent>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	89 c6                	mov    %eax,%esi
801057d9:	85 c0                	test   %eax,%eax
801057db:	74 5f                	je     8010583c <sys_link+0xfc>
  ilock(dp);
801057dd:	83 ec 0c             	sub    $0xc,%esp
801057e0:	50                   	push   %eax
801057e1:	e8 7a bf ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057e6:	8b 03                	mov    (%ebx),%eax
801057e8:	83 c4 10             	add    $0x10,%esp
801057eb:	39 06                	cmp    %eax,(%esi)
801057ed:	75 41                	jne    80105830 <sys_link+0xf0>
801057ef:	83 ec 04             	sub    $0x4,%esp
801057f2:	ff 73 04             	pushl  0x4(%ebx)
801057f5:	57                   	push   %edi
801057f6:	56                   	push   %esi
801057f7:	e8 74 c7 ff ff       	call   80101f70 <dirlink>
801057fc:	83 c4 10             	add    $0x10,%esp
801057ff:	85 c0                	test   %eax,%eax
80105801:	78 2d                	js     80105830 <sys_link+0xf0>
  iunlockput(dp);
80105803:	83 ec 0c             	sub    $0xc,%esp
80105806:	56                   	push   %esi
80105807:	e8 f4 c1 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010580c:	89 1c 24             	mov    %ebx,(%esp)
8010580f:	e8 7c c0 ff ff       	call   80101890 <iput>
  end_op();
80105814:	e8 87 d5 ff ff       	call   80102da0 <end_op>
  return 0;
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	31 c0                	xor    %eax,%eax
}
8010581e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105821:	5b                   	pop    %ebx
80105822:	5e                   	pop    %esi
80105823:	5f                   	pop    %edi
80105824:	5d                   	pop    %ebp
80105825:	c3                   	ret    
80105826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	56                   	push   %esi
80105834:	e8 c7 c1 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105839:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	53                   	push   %ebx
80105840:	e8 1b bf ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105845:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010584a:	89 1c 24             	mov    %ebx,(%esp)
8010584d:	e8 4e be ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105852:	89 1c 24             	mov    %ebx,(%esp)
80105855:	e8 a6 c1 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010585a:	e8 41 d5 ff ff       	call   80102da0 <end_op>
  return -1;
8010585f:	83 c4 10             	add    $0x10,%esp
80105862:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105867:	eb b5                	jmp    8010581e <sys_link+0xde>
    iunlockput(ip);
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	53                   	push   %ebx
8010586d:	e8 8e c1 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105872:	e8 29 d5 ff ff       	call   80102da0 <end_op>
    return -1;
80105877:	83 c4 10             	add    $0x10,%esp
8010587a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587f:	eb 9d                	jmp    8010581e <sys_link+0xde>
    end_op();
80105881:	e8 1a d5 ff ff       	call   80102da0 <end_op>
    return -1;
80105886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588b:	eb 91                	jmp    8010581e <sys_link+0xde>
8010588d:	8d 76 00             	lea    0x0(%esi),%esi

80105890 <sys_unlink>:
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	57                   	push   %edi
80105898:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105899:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010589c:	53                   	push   %ebx
8010589d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058a0:	50                   	push   %eax
801058a1:	6a 00                	push   $0x0
801058a3:	e8 08 fa ff ff       	call   801052b0 <argstr>
801058a8:	83 c4 10             	add    $0x10,%esp
801058ab:	85 c0                	test   %eax,%eax
801058ad:	0f 88 7d 01 00 00    	js     80105a30 <sys_unlink+0x1a0>
  begin_op();
801058b3:	e8 78 d4 ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058b8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058bb:	83 ec 08             	sub    $0x8,%esp
801058be:	53                   	push   %ebx
801058bf:	ff 75 c0             	pushl  -0x40(%ebp)
801058c2:	e8 89 c7 ff ff       	call   80102050 <nameiparent>
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	89 c6                	mov    %eax,%esi
801058cc:	85 c0                	test   %eax,%eax
801058ce:	0f 84 66 01 00 00    	je     80105a3a <sys_unlink+0x1aa>
  ilock(dp);
801058d4:	83 ec 0c             	sub    $0xc,%esp
801058d7:	50                   	push   %eax
801058d8:	e8 83 be ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801058dd:	58                   	pop    %eax
801058de:	5a                   	pop    %edx
801058df:	68 b4 84 10 80       	push   $0x801084b4
801058e4:	53                   	push   %ebx
801058e5:	e8 a6 c3 ff ff       	call   80101c90 <namecmp>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	0f 84 03 01 00 00    	je     801059f8 <sys_unlink+0x168>
801058f5:	83 ec 08             	sub    $0x8,%esp
801058f8:	68 b3 84 10 80       	push   $0x801084b3
801058fd:	53                   	push   %ebx
801058fe:	e8 8d c3 ff ff       	call   80101c90 <namecmp>
80105903:	83 c4 10             	add    $0x10,%esp
80105906:	85 c0                	test   %eax,%eax
80105908:	0f 84 ea 00 00 00    	je     801059f8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010590e:	83 ec 04             	sub    $0x4,%esp
80105911:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105914:	50                   	push   %eax
80105915:	53                   	push   %ebx
80105916:	56                   	push   %esi
80105917:	e8 94 c3 ff ff       	call   80101cb0 <dirlookup>
8010591c:	83 c4 10             	add    $0x10,%esp
8010591f:	89 c3                	mov    %eax,%ebx
80105921:	85 c0                	test   %eax,%eax
80105923:	0f 84 cf 00 00 00    	je     801059f8 <sys_unlink+0x168>
  ilock(ip);
80105929:	83 ec 0c             	sub    $0xc,%esp
8010592c:	50                   	push   %eax
8010592d:	e8 2e be ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010593a:	0f 8e 23 01 00 00    	jle    80105a63 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105940:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105945:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105948:	74 66                	je     801059b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010594a:	83 ec 04             	sub    $0x4,%esp
8010594d:	6a 10                	push   $0x10
8010594f:	6a 00                	push   $0x0
80105951:	57                   	push   %edi
80105952:	e8 c9 f5 ff ff       	call   80104f20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105957:	6a 10                	push   $0x10
80105959:	ff 75 c4             	pushl  -0x3c(%ebp)
8010595c:	57                   	push   %edi
8010595d:	56                   	push   %esi
8010595e:	e8 fd c1 ff ff       	call   80101b60 <writei>
80105963:	83 c4 20             	add    $0x20,%esp
80105966:	83 f8 10             	cmp    $0x10,%eax
80105969:	0f 85 e7 00 00 00    	jne    80105a56 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010596f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105974:	0f 84 96 00 00 00    	je     80105a10 <sys_unlink+0x180>
  iunlockput(dp);
8010597a:	83 ec 0c             	sub    $0xc,%esp
8010597d:	56                   	push   %esi
8010597e:	e8 7d c0 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105983:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105988:	89 1c 24             	mov    %ebx,(%esp)
8010598b:	e8 10 bd ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105990:	89 1c 24             	mov    %ebx,(%esp)
80105993:	e8 68 c0 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105998:	e8 03 d4 ff ff       	call   80102da0 <end_op>
  return 0;
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	31 c0                	xor    %eax,%eax
}
801059a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a5:	5b                   	pop    %ebx
801059a6:	5e                   	pop    %esi
801059a7:	5f                   	pop    %edi
801059a8:	5d                   	pop    %ebp
801059a9:	c3                   	ret    
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059b4:	76 94                	jbe    8010594a <sys_unlink+0xba>
801059b6:	ba 20 00 00 00       	mov    $0x20,%edx
801059bb:	eb 0b                	jmp    801059c8 <sys_unlink+0x138>
801059bd:	8d 76 00             	lea    0x0(%esi),%esi
801059c0:	83 c2 10             	add    $0x10,%edx
801059c3:	39 53 58             	cmp    %edx,0x58(%ebx)
801059c6:	76 82                	jbe    8010594a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059c8:	6a 10                	push   $0x10
801059ca:	52                   	push   %edx
801059cb:	57                   	push   %edi
801059cc:	53                   	push   %ebx
801059cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801059d0:	e8 8b c0 ff ff       	call   80101a60 <readi>
801059d5:	83 c4 10             	add    $0x10,%esp
801059d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801059db:	83 f8 10             	cmp    $0x10,%eax
801059de:	75 69                	jne    80105a49 <sys_unlink+0x1b9>
    if(de.inum != 0)
801059e0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801059e5:	74 d9                	je     801059c0 <sys_unlink+0x130>
    iunlockput(ip);
801059e7:	83 ec 0c             	sub    $0xc,%esp
801059ea:	53                   	push   %ebx
801059eb:	e8 10 c0 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059f7:	90                   	nop
  iunlockput(dp);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	56                   	push   %esi
801059fc:	e8 ff bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a01:	e8 9a d3 ff ff       	call   80102da0 <end_op>
  return -1;
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a0e:	eb 92                	jmp    801059a2 <sys_unlink+0x112>
    iupdate(dp);
80105a10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a13:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a18:	56                   	push   %esi
80105a19:	e8 82 bc ff ff       	call   801016a0 <iupdate>
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	e9 54 ff ff ff       	jmp    8010597a <sys_unlink+0xea>
80105a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a35:	e9 68 ff ff ff       	jmp    801059a2 <sys_unlink+0x112>
    end_op();
80105a3a:	e8 61 d3 ff ff       	call   80102da0 <end_op>
    return -1;
80105a3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a44:	e9 59 ff ff ff       	jmp    801059a2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a49:	83 ec 0c             	sub    $0xc,%esp
80105a4c:	68 d8 84 10 80       	push   $0x801084d8
80105a51:	e8 3a a9 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a56:	83 ec 0c             	sub    $0xc,%esp
80105a59:	68 ea 84 10 80       	push   $0x801084ea
80105a5e:	e8 2d a9 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105a63:	83 ec 0c             	sub    $0xc,%esp
80105a66:	68 c6 84 10 80       	push   $0x801084c6
80105a6b:	e8 20 a9 ff ff       	call   80100390 <panic>

80105a70 <sys_open>:

int
sys_open(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a79:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a7c:	53                   	push   %ebx
80105a7d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a80:	50                   	push   %eax
80105a81:	6a 00                	push   $0x0
80105a83:	e8 28 f8 ff ff       	call   801052b0 <argstr>
80105a88:	83 c4 10             	add    $0x10,%esp
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	0f 88 8a 00 00 00    	js     80105b1d <sys_open+0xad>
80105a93:	83 ec 08             	sub    $0x8,%esp
80105a96:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a99:	50                   	push   %eax
80105a9a:	6a 01                	push   $0x1
80105a9c:	e8 5f f7 ff ff       	call   80105200 <argint>
80105aa1:	83 c4 10             	add    $0x10,%esp
80105aa4:	85 c0                	test   %eax,%eax
80105aa6:	78 75                	js     80105b1d <sys_open+0xad>
    return -1;

  begin_op();
80105aa8:	e8 83 d2 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
80105aad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ab1:	75 75                	jne    80105b28 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ab3:	83 ec 0c             	sub    $0xc,%esp
80105ab6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ab9:	e8 72 c5 ff ff       	call   80102030 <namei>
80105abe:	83 c4 10             	add    $0x10,%esp
80105ac1:	89 c6                	mov    %eax,%esi
80105ac3:	85 c0                	test   %eax,%eax
80105ac5:	74 7e                	je     80105b45 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105ac7:	83 ec 0c             	sub    $0xc,%esp
80105aca:	50                   	push   %eax
80105acb:	e8 90 bc ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ad0:	83 c4 10             	add    $0x10,%esp
80105ad3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ad8:	0f 84 c2 00 00 00    	je     80105ba0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ade:	e8 1d b3 ff ff       	call   80100e00 <filealloc>
80105ae3:	89 c7                	mov    %eax,%edi
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	74 23                	je     80105b0c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105ae9:	e8 22 df ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105af0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105af4:	85 d2                	test   %edx,%edx
80105af6:	74 60                	je     80105b58 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105af8:	83 c3 01             	add    $0x1,%ebx
80105afb:	83 fb 10             	cmp    $0x10,%ebx
80105afe:	75 f0                	jne    80105af0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	57                   	push   %edi
80105b04:	e8 b7 b3 ff ff       	call   80100ec0 <fileclose>
80105b09:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b0c:	83 ec 0c             	sub    $0xc,%esp
80105b0f:	56                   	push   %esi
80105b10:	e8 eb be ff ff       	call   80101a00 <iunlockput>
    end_op();
80105b15:	e8 86 d2 ff ff       	call   80102da0 <end_op>
    return -1;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b22:	eb 6d                	jmp    80105b91 <sys_open+0x121>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b28:	83 ec 0c             	sub    $0xc,%esp
80105b2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b2e:	31 c9                	xor    %ecx,%ecx
80105b30:	ba 02 00 00 00       	mov    $0x2,%edx
80105b35:	6a 00                	push   $0x0
80105b37:	e8 24 f8 ff ff       	call   80105360 <create>
    if(ip == 0){
80105b3c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b3f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b41:	85 c0                	test   %eax,%eax
80105b43:	75 99                	jne    80105ade <sys_open+0x6e>
      end_op();
80105b45:	e8 56 d2 ff ff       	call   80102da0 <end_op>
      return -1;
80105b4a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b4f:	eb 40                	jmp    80105b91 <sys_open+0x121>
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b58:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b5b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b5f:	56                   	push   %esi
80105b60:	e8 db bc ff ff       	call   80101840 <iunlock>
  end_op();
80105b65:	e8 36 d2 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
80105b6a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b73:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b76:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b79:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b7b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b82:	f7 d0                	not    %eax
80105b84:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b87:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b8a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b8d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b94:	89 d8                	mov    %ebx,%eax
80105b96:	5b                   	pop    %ebx
80105b97:	5e                   	pop    %esi
80105b98:	5f                   	pop    %edi
80105b99:	5d                   	pop    %ebp
80105b9a:	c3                   	ret    
80105b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b9f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ba0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ba3:	85 c9                	test   %ecx,%ecx
80105ba5:	0f 84 33 ff ff ff    	je     80105ade <sys_open+0x6e>
80105bab:	e9 5c ff ff ff       	jmp    80105b0c <sys_open+0x9c>

80105bb0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bba:	e8 71 d1 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bbf:	83 ec 08             	sub    $0x8,%esp
80105bc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bc5:	50                   	push   %eax
80105bc6:	6a 00                	push   $0x0
80105bc8:	e8 e3 f6 ff ff       	call   801052b0 <argstr>
80105bcd:	83 c4 10             	add    $0x10,%esp
80105bd0:	85 c0                	test   %eax,%eax
80105bd2:	78 34                	js     80105c08 <sys_mkdir+0x58>
80105bd4:	83 ec 0c             	sub    $0xc,%esp
80105bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bda:	31 c9                	xor    %ecx,%ecx
80105bdc:	ba 01 00 00 00       	mov    $0x1,%edx
80105be1:	6a 00                	push   $0x0
80105be3:	e8 78 f7 ff ff       	call   80105360 <create>
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	85 c0                	test   %eax,%eax
80105bed:	74 19                	je     80105c08 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bef:	83 ec 0c             	sub    $0xc,%esp
80105bf2:	50                   	push   %eax
80105bf3:	e8 08 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105bf8:	e8 a3 d1 ff ff       	call   80102da0 <end_op>
  return 0;
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	31 c0                	xor    %eax,%eax
}
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    
80105c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c08:	e8 93 d1 ff ff       	call   80102da0 <end_op>
    return -1;
80105c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c12:	c9                   	leave  
80105c13:	c3                   	ret    
80105c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <sys_mknod>:

int
sys_mknod(void)
{
80105c20:	f3 0f 1e fb          	endbr32 
80105c24:	55                   	push   %ebp
80105c25:	89 e5                	mov    %esp,%ebp
80105c27:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c2a:	e8 01 d1 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c2f:	83 ec 08             	sub    $0x8,%esp
80105c32:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c35:	50                   	push   %eax
80105c36:	6a 00                	push   $0x0
80105c38:	e8 73 f6 ff ff       	call   801052b0 <argstr>
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	85 c0                	test   %eax,%eax
80105c42:	78 64                	js     80105ca8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c44:	83 ec 08             	sub    $0x8,%esp
80105c47:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c4a:	50                   	push   %eax
80105c4b:	6a 01                	push   $0x1
80105c4d:	e8 ae f5 ff ff       	call   80105200 <argint>
  if((argstr(0, &path)) < 0 ||
80105c52:	83 c4 10             	add    $0x10,%esp
80105c55:	85 c0                	test   %eax,%eax
80105c57:	78 4f                	js     80105ca8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c59:	83 ec 08             	sub    $0x8,%esp
80105c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c5f:	50                   	push   %eax
80105c60:	6a 02                	push   $0x2
80105c62:	e8 99 f5 ff ff       	call   80105200 <argint>
     argint(1, &major) < 0 ||
80105c67:	83 c4 10             	add    $0x10,%esp
80105c6a:	85 c0                	test   %eax,%eax
80105c6c:	78 3a                	js     80105ca8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c6e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c79:	ba 03 00 00 00       	mov    $0x3,%edx
80105c7e:	50                   	push   %eax
80105c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c82:	e8 d9 f6 ff ff       	call   80105360 <create>
     argint(2, &minor) < 0 ||
80105c87:	83 c4 10             	add    $0x10,%esp
80105c8a:	85 c0                	test   %eax,%eax
80105c8c:	74 1a                	je     80105ca8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c8e:	83 ec 0c             	sub    $0xc,%esp
80105c91:	50                   	push   %eax
80105c92:	e8 69 bd ff ff       	call   80101a00 <iunlockput>
  end_op();
80105c97:	e8 04 d1 ff ff       	call   80102da0 <end_op>
  return 0;
80105c9c:	83 c4 10             	add    $0x10,%esp
80105c9f:	31 c0                	xor    %eax,%eax
}
80105ca1:	c9                   	leave  
80105ca2:	c3                   	ret    
80105ca3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca7:	90                   	nop
    end_op();
80105ca8:	e8 f3 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105cad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb2:	c9                   	leave  
80105cb3:	c3                   	ret    
80105cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cbf:	90                   	nop

80105cc0 <sys_chdir>:

int
sys_chdir(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	56                   	push   %esi
80105cc8:	53                   	push   %ebx
80105cc9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ccc:	e8 3f dd ff ff       	call   80103a10 <myproc>
80105cd1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105cd3:	e8 58 d0 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105cd8:	83 ec 08             	sub    $0x8,%esp
80105cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cde:	50                   	push   %eax
80105cdf:	6a 00                	push   $0x0
80105ce1:	e8 ca f5 ff ff       	call   801052b0 <argstr>
80105ce6:	83 c4 10             	add    $0x10,%esp
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	78 73                	js     80105d60 <sys_chdir+0xa0>
80105ced:	83 ec 0c             	sub    $0xc,%esp
80105cf0:	ff 75 f4             	pushl  -0xc(%ebp)
80105cf3:	e8 38 c3 ff ff       	call   80102030 <namei>
80105cf8:	83 c4 10             	add    $0x10,%esp
80105cfb:	89 c3                	mov    %eax,%ebx
80105cfd:	85 c0                	test   %eax,%eax
80105cff:	74 5f                	je     80105d60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d01:	83 ec 0c             	sub    $0xc,%esp
80105d04:	50                   	push   %eax
80105d05:	e8 56 ba ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d12:	75 2c                	jne    80105d40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d14:	83 ec 0c             	sub    $0xc,%esp
80105d17:	53                   	push   %ebx
80105d18:	e8 23 bb ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105d1d:	58                   	pop    %eax
80105d1e:	ff 76 68             	pushl  0x68(%esi)
80105d21:	e8 6a bb ff ff       	call   80101890 <iput>
  end_op();
80105d26:	e8 75 d0 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
80105d2b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d2e:	83 c4 10             	add    $0x10,%esp
80105d31:	31 c0                	xor    %eax,%eax
}
80105d33:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d36:	5b                   	pop    %ebx
80105d37:	5e                   	pop    %esi
80105d38:	5d                   	pop    %ebp
80105d39:	c3                   	ret    
80105d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	53                   	push   %ebx
80105d44:	e8 b7 bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d49:	e8 52 d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105d4e:	83 c4 10             	add    $0x10,%esp
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb db                	jmp    80105d33 <sys_chdir+0x73>
80105d58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d5f:	90                   	nop
    end_op();
80105d60:	e8 3b d0 ff ff       	call   80102da0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d6a:	eb c7                	jmp    80105d33 <sys_chdir+0x73>
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_exec>:

int
sys_exec(void)
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	57                   	push   %edi
80105d78:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d79:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d7f:	53                   	push   %ebx
80105d80:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d86:	50                   	push   %eax
80105d87:	6a 00                	push   $0x0
80105d89:	e8 22 f5 ff ff       	call   801052b0 <argstr>
80105d8e:	83 c4 10             	add    $0x10,%esp
80105d91:	85 c0                	test   %eax,%eax
80105d93:	0f 88 8b 00 00 00    	js     80105e24 <sys_exec+0xb4>
80105d99:	83 ec 08             	sub    $0x8,%esp
80105d9c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105da2:	50                   	push   %eax
80105da3:	6a 01                	push   $0x1
80105da5:	e8 56 f4 ff ff       	call   80105200 <argint>
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	85 c0                	test   %eax,%eax
80105daf:	78 73                	js     80105e24 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105db1:	83 ec 04             	sub    $0x4,%esp
80105db4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105dba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105dbc:	68 80 00 00 00       	push   $0x80
80105dc1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105dc7:	6a 00                	push   $0x0
80105dc9:	50                   	push   %eax
80105dca:	e8 51 f1 ff ff       	call   80104f20 <memset>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105dd8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105dde:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	57                   	push   %edi
80105de9:	01 f0                	add    %esi,%eax
80105deb:	50                   	push   %eax
80105dec:	e8 6f f3 ff ff       	call   80105160 <fetchint>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	78 2c                	js     80105e24 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105df8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105dfe:	85 c0                	test   %eax,%eax
80105e00:	74 36                	je     80105e38 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e02:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e08:	83 ec 08             	sub    $0x8,%esp
80105e0b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e0e:	52                   	push   %edx
80105e0f:	50                   	push   %eax
80105e10:	e8 8b f3 ff ff       	call   801051a0 <fetchstr>
80105e15:	83 c4 10             	add    $0x10,%esp
80105e18:	85 c0                	test   %eax,%eax
80105e1a:	78 08                	js     80105e24 <sys_exec+0xb4>
  for(i=0;; i++){
80105e1c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e1f:	83 fb 20             	cmp    $0x20,%ebx
80105e22:	75 b4                	jne    80105dd8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e2c:	5b                   	pop    %ebx
80105e2d:	5e                   	pop    %esi
80105e2e:	5f                   	pop    %edi
80105e2f:	5d                   	pop    %ebp
80105e30:	c3                   	ret    
80105e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e38:	83 ec 08             	sub    $0x8,%esp
80105e3b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e41:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e48:	00 00 00 00 
  return exec(path, argv);
80105e4c:	50                   	push   %eax
80105e4d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e53:	e8 28 ac ff ff       	call   80100a80 <exec>
80105e58:	83 c4 10             	add    $0x10,%esp
}
80105e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e5e:	5b                   	pop    %ebx
80105e5f:	5e                   	pop    %esi
80105e60:	5f                   	pop    %edi
80105e61:	5d                   	pop    %ebp
80105e62:	c3                   	ret    
80105e63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e70 <sys_pipe>:

int
sys_pipe(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
80105e74:	55                   	push   %ebp
80105e75:	89 e5                	mov    %esp,%ebp
80105e77:	57                   	push   %edi
80105e78:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e79:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e7c:	53                   	push   %ebx
80105e7d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e80:	6a 08                	push   $0x8
80105e82:	50                   	push   %eax
80105e83:	6a 00                	push   $0x0
80105e85:	e8 c6 f3 ff ff       	call   80105250 <argptr>
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	85 c0                	test   %eax,%eax
80105e8f:	78 4e                	js     80105edf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e91:	83 ec 08             	sub    $0x8,%esp
80105e94:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e97:	50                   	push   %eax
80105e98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e9b:	50                   	push   %eax
80105e9c:	e8 4f d5 ff ff       	call   801033f0 <pipealloc>
80105ea1:	83 c4 10             	add    $0x10,%esp
80105ea4:	85 c0                	test   %eax,%eax
80105ea6:	78 37                	js     80105edf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ea8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105eab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ead:	e8 5e db ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105eb8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ebc:	85 f6                	test   %esi,%esi
80105ebe:	74 30                	je     80105ef0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105ec0:	83 c3 01             	add    $0x1,%ebx
80105ec3:	83 fb 10             	cmp    $0x10,%ebx
80105ec6:	75 f0                	jne    80105eb8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 e0             	pushl  -0x20(%ebp)
80105ece:	e8 ed af ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105ed3:	58                   	pop    %eax
80105ed4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ed7:	e8 e4 af ff ff       	call   80100ec0 <fileclose>
    return -1;
80105edc:	83 c4 10             	add    $0x10,%esp
80105edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee4:	eb 5b                	jmp    80105f41 <sys_pipe+0xd1>
80105ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105ef0:	8d 73 08             	lea    0x8(%ebx),%esi
80105ef3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ef7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105efa:	e8 11 db ff ff       	call   80103a10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eff:	31 d2                	xor    %edx,%edx
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f08:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f0c:	85 c9                	test   %ecx,%ecx
80105f0e:	74 20                	je     80105f30 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f10:	83 c2 01             	add    $0x1,%edx
80105f13:	83 fa 10             	cmp    $0x10,%edx
80105f16:	75 f0                	jne    80105f08 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f18:	e8 f3 da ff ff       	call   80103a10 <myproc>
80105f1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f24:	00 
80105f25:	eb a1                	jmp    80105ec8 <sys_pipe+0x58>
80105f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f30:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f37:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f39:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f3c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f3f:	31 c0                	xor    %eax,%eax
}
80105f41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f44:	5b                   	pop    %ebx
80105f45:	5e                   	pop    %esi
80105f46:	5f                   	pop    %edi
80105f47:	5d                   	pop    %ebp
80105f48:	c3                   	ret    
80105f49:	66 90                	xchg   %ax,%ax
80105f4b:	66 90                	xchg   %ax,%ax
80105f4d:	66 90                	xchg   %ax,%ax
80105f4f:	90                   	nop

80105f50 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
  return fork();
80105f54:	e9 07 e1 ff ff       	jmp    80104060 <fork>
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_exit>:
}

int
sys_exit(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f6a:	e8 81 e2 ff ff       	call   801041f0 <exit>
  return 0;  // not reached
}
80105f6f:	31 c0                	xor    %eax,%eax
80105f71:	c9                   	leave  
80105f72:	c3                   	ret    
80105f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f80 <sys_wait>:

int
sys_wait(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
  return wait();
80105f84:	e9 07 dd ff ff       	jmp    80103c90 <wait>
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_kill>:
}

int
sys_kill(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9d:	50                   	push   %eax
80105f9e:	6a 00                	push   $0x0
80105fa0:	e8 5b f2 ff ff       	call   80105200 <argint>
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	78 14                	js     80105fc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fac:	83 ec 0c             	sub    $0xc,%esp
80105faf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb2:	e8 79 e3 ff ff       	call   80104330 <kill>
80105fb7:	83 c4 10             	add    $0x10,%esp
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fc0:	c9                   	leave  
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_getpid>:

int
sys_getpid(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fda:	e8 31 da ff ff       	call   80103a10 <myproc>
80105fdf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fe2:	c9                   	leave  
80105fe3:	c3                   	ret    
80105fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop

80105ff0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ffb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffe:	50                   	push   %eax
80105fff:	6a 00                	push   $0x0
80106001:	e8 fa f1 ff ff       	call   80105200 <argint>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	78 23                	js     80106030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010600d:	e8 fe d9 ff ff       	call   80103a10 <myproc>
  if(growproc(n) < 0)
80106012:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106015:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106017:	ff 75 f4             	pushl  -0xc(%ebp)
8010601a:	e8 21 da ff ff       	call   80103a40 <growproc>
8010601f:	83 c4 10             	add    $0x10,%esp
80106022:	85 c0                	test   %eax,%eax
80106024:	78 0a                	js     80106030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106026:	89 d8                	mov    %ebx,%eax
80106028:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010602b:	c9                   	leave  
8010602c:	c3                   	ret    
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106035:	eb ef                	jmp    80106026 <sys_sbrk+0x36>
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_sleep>:

int
sys_sleep(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106048:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010604b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010604e:	50                   	push   %eax
8010604f:	6a 00                	push   $0x0
80106051:	e8 aa f1 ff ff       	call   80105200 <argint>
80106056:	83 c4 10             	add    $0x10,%esp
80106059:	85 c0                	test   %eax,%eax
8010605b:	0f 88 86 00 00 00    	js     801060e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106061:	83 ec 0c             	sub    $0xc,%esp
80106064:	68 00 63 11 80       	push   $0x80116300
80106069:	e8 a2 ed ff ff       	call   80104e10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010606e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106071:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
  while(ticks - ticks0 < n){
80106077:	83 c4 10             	add    $0x10,%esp
8010607a:	85 d2                	test   %edx,%edx
8010607c:	75 23                	jne    801060a1 <sys_sleep+0x61>
8010607e:	eb 50                	jmp    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	68 00 63 11 80       	push   $0x80116300
80106088:	68 40 6b 11 80       	push   $0x80116b40
8010608d:	e8 3e db ff ff       	call   80103bd0 <sleep>
  while(ticks - ticks0 < n){
80106092:	a1 40 6b 11 80       	mov    0x80116b40,%eax
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	29 d8                	sub    %ebx,%eax
8010609c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010609f:	73 2f                	jae    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
801060a1:	e8 6a d9 ff ff       	call   80103a10 <myproc>
801060a6:	8b 40 24             	mov    0x24(%eax),%eax
801060a9:	85 c0                	test   %eax,%eax
801060ab:	74 d3                	je     80106080 <sys_sleep+0x40>
      release(&tickslock);
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 00 63 11 80       	push   $0x80116300
801060b5:	e8 16 ee ff ff       	call   80104ed0 <release>
  }
  release(&tickslock);
  return 0;
}
801060ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 00 63 11 80       	push   $0x80116300
801060d8:	e8 f3 ed ff ff       	call   80104ed0 <release>
  return 0;
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
    return -1;
801060e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ec:	eb f4                	jmp    801060e2 <sys_sleep+0xa2>
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	53                   	push   %ebx
801060f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060fb:	68 00 63 11 80       	push   $0x80116300
80106100:	e8 0b ed ff ff       	call   80104e10 <acquire>
  xticks = ticks;
80106105:	8b 1d 40 6b 11 80    	mov    0x80116b40,%ebx
  release(&tickslock);
8010610b:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80106112:	e8 b9 ed ff ff       	call   80104ed0 <release>
  return xticks;
}
80106117:	89 d8                	mov    %ebx,%eax
80106119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    
8010611e:	66 90                	xchg   %ax,%ax

80106120 <sys_yield>:

int sys_yield(void)
{
80106120:	f3 0f 1e fb          	endbr32 
80106124:	55                   	push   %ebp
80106125:	89 e5                	mov    %esp,%ebp
80106127:	83 ec 08             	sub    $0x8,%esp
    yield();
8010612a:	e8 51 da ff ff       	call   80103b80 <yield>
    return 0;
}
8010612f:	31 c0                	xor    %eax,%eax
80106131:	c9                   	leave  
80106132:	c3                   	ret    
80106133:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106140 <sys_getlev>:

int sys_getlev(void)
{
80106140:	f3 0f 1e fb          	endbr32 
    return getlev();
80106144:	e9 97 e3 ff ff       	jmp    801044e0 <getlev>
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_setpriority>:
}

int sys_setpriority(void)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	83 ec 20             	sub    $0x20,%esp
    int pid;
    int priority;
    
    if (argint(0, &pid) < 0 || argint(1, &priority) < 0)
8010615a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010615d:	50                   	push   %eax
8010615e:	6a 00                	push   $0x0
80106160:	e8 9b f0 ff ff       	call   80105200 <argint>
80106165:	83 c4 10             	add    $0x10,%esp
80106168:	85 c0                	test   %eax,%eax
8010616a:	78 2c                	js     80106198 <sys_setpriority+0x48>
8010616c:	83 ec 08             	sub    $0x8,%esp
8010616f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106172:	50                   	push   %eax
80106173:	6a 01                	push   $0x1
80106175:	e8 86 f0 ff ff       	call   80105200 <argint>
8010617a:	83 c4 10             	add    $0x10,%esp
8010617d:	85 c0                	test   %eax,%eax
8010617f:	78 17                	js     80106198 <sys_setpriority+0x48>
        return -1;

    return setpriority(pid, priority);
80106181:	83 ec 08             	sub    $0x8,%esp
80106184:	ff 75 f4             	pushl  -0xc(%ebp)
80106187:	ff 75 f0             	pushl  -0x10(%ebp)
8010618a:	e8 a1 e3 ff ff       	call   80104530 <setpriority>
8010618f:	83 c4 10             	add    $0x10,%esp
}
80106192:	c9                   	leave  
80106193:	c3                   	ret    
80106194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106198:	c9                   	leave  
        return -1;
80106199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010619e:	c3                   	ret    
8010619f:	90                   	nop

801061a0 <sys_setmonopoly>:

int sys_setmonopoly(void)
{
801061a0:	f3 0f 1e fb          	endbr32 
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 20             	sub    $0x20,%esp
    int pid;
    int password;

    if (argint(0, &pid) < 0 || argint(1, &password) < 0)
801061aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ad:	50                   	push   %eax
801061ae:	6a 00                	push   $0x0
801061b0:	e8 4b f0 ff ff       	call   80105200 <argint>
801061b5:	83 c4 10             	add    $0x10,%esp
801061b8:	85 c0                	test   %eax,%eax
801061ba:	78 2c                	js     801061e8 <sys_setmonopoly+0x48>
801061bc:	83 ec 08             	sub    $0x8,%esp
801061bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061c2:	50                   	push   %eax
801061c3:	6a 01                	push   $0x1
801061c5:	e8 36 f0 ff ff       	call   80105200 <argint>
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	85 c0                	test   %eax,%eax
801061cf:	78 17                	js     801061e8 <sys_setmonopoly+0x48>
        return -1;

    return setmonopoly(pid, password);
801061d1:	83 ec 08             	sub    $0x8,%esp
801061d4:	ff 75 f4             	pushl  -0xc(%ebp)
801061d7:	ff 75 f0             	pushl  -0x10(%ebp)
801061da:	e8 91 e4 ff ff       	call   80104670 <setmonopoly>
801061df:	83 c4 10             	add    $0x10,%esp
}
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061e8:	c9                   	leave  
        return -1;
801061e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061ee:	c3                   	ret    
801061ef:	90                   	nop

801061f0 <sys_monopolize>:

int sys_monopolize(void)
{
801061f0:	f3 0f 1e fb          	endbr32 
801061f4:	55                   	push   %ebp
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	83 ec 08             	sub    $0x8,%esp
    monopolize();
801061fa:	e8 71 e5 ff ff       	call   80104770 <monopolize>
    return 0;
}
801061ff:	31 c0                	xor    %eax,%eax
80106201:	c9                   	leave  
80106202:	c3                   	ret    
80106203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106210 <sys_unmonopolize>:

int sys_unmonopolize(void)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	83 ec 08             	sub    $0x8,%esp
    unmonopolize();
8010621a:	e8 81 e5 ff ff       	call   801047a0 <unmonopolize>
    return 0;
}
8010621f:	31 c0                	xor    %eax,%eax
80106221:	c9                   	leave  
80106222:	c3                   	ret    

80106223 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106223:	1e                   	push   %ds
  pushl %es
80106224:	06                   	push   %es
  pushl %fs
80106225:	0f a0                	push   %fs
  pushl %gs
80106227:	0f a8                	push   %gs
  pushal
80106229:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010622a:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010622e:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106230:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106232:	54                   	push   %esp
  call trap
80106233:	e8 e8 00 00 00       	call   80106320 <trap>
  addl $4, %esp
80106238:	83 c4 04             	add    $0x4,%esp

8010623b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010623b:	61                   	popa   
  popl %gs
8010623c:	0f a9                	pop    %gs
  popl %fs
8010623e:	0f a1                	pop    %fs
  popl %es
80106240:	07                   	pop    %es
  popl %ds
80106241:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106242:	83 c4 08             	add    $0x8,%esp
  iret
80106245:	cf                   	iret   
80106246:	66 90                	xchg   %ax,%ax
80106248:	66 90                	xchg   %ax,%ax
8010624a:	66 90                	xchg   %ax,%ax
8010624c:	66 90                	xchg   %ax,%ax
8010624e:	66 90                	xchg   %ax,%ax

80106250 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106255:	31 c0                	xor    %eax,%eax
{
80106257:	89 e5                	mov    %esp,%ebp
80106259:	83 ec 08             	sub    $0x8,%esp
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106260:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106267:	c7 04 c5 42 63 11 80 	movl   $0x8e000008,-0x7fee9cbe(,%eax,8)
8010626e:	08 00 00 8e 
80106272:	66 89 14 c5 40 63 11 	mov    %dx,-0x7fee9cc0(,%eax,8)
80106279:	80 
8010627a:	c1 ea 10             	shr    $0x10,%edx
8010627d:	66 89 14 c5 46 63 11 	mov    %dx,-0x7fee9cba(,%eax,8)
80106284:	80 
  for(i = 0; i < 256; i++)
80106285:	83 c0 01             	add    $0x1,%eax
80106288:	3d 00 01 00 00       	cmp    $0x100,%eax
8010628d:	75 d1                	jne    80106260 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010628f:	a1 08 b1 10 80       	mov    0x8010b108,%eax
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);
  initlock(&tickslock, "time");
80106294:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106297:	c7 05 42 65 11 80 08 	movl   $0xef000008,0x80116542
8010629e:	00 00 ef 
  initlock(&tickslock, "time");
801062a1:	68 f9 84 10 80       	push   $0x801084f9
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801062a6:	66 a3 40 65 11 80    	mov    %ax,0x80116540
801062ac:	c1 e8 10             	shr    $0x10,%eax
801062af:	66 a3 46 65 11 80    	mov    %ax,0x80116546
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);
801062b5:	a1 08 b2 10 80       	mov    0x8010b208,%eax
  initlock(&tickslock, "time");
801062ba:	68 00 63 11 80       	push   $0x80116300
  SETGATE(idt[128], 1, SEG_KCODE<<3, vectors[128], DPL_USER);
801062bf:	66 a3 40 67 11 80    	mov    %ax,0x80116740
801062c5:	c1 e8 10             	shr    $0x10,%eax
801062c8:	c7 05 42 67 11 80 08 	movl   $0xef000008,0x80116742
801062cf:	00 00 ef 
801062d2:	66 a3 46 67 11 80    	mov    %ax,0x80116746
  initlock(&tickslock, "time");
801062d8:	e8 b3 e9 ff ff       	call   80104c90 <initlock>
}
801062dd:	83 c4 10             	add    $0x10,%esp
801062e0:	c9                   	leave  
801062e1:	c3                   	ret    
801062e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062f0 <idtinit>:

void
idtinit(void)
{
801062f0:	f3 0f 1e fb          	endbr32 
801062f4:	55                   	push   %ebp
  pd[0] = size-1;
801062f5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801062fa:	89 e5                	mov    %esp,%ebp
801062fc:	83 ec 10             	sub    $0x10,%esp
801062ff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106303:	b8 40 63 11 80       	mov    $0x80116340,%eax
80106308:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010630c:	c1 e8 10             	shr    $0x10,%eax
8010630f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106313:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106316:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106319:	c9                   	leave  
8010631a:	c3                   	ret    
8010631b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010631f:	90                   	nop

80106320 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
80106325:	89 e5                	mov    %esp,%ebp
80106327:	57                   	push   %edi
80106328:	56                   	push   %esi
80106329:	53                   	push   %ebx
8010632a:	83 ec 1c             	sub    $0x1c,%esp
8010632d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106330:	8b 43 30             	mov    0x30(%ebx),%eax
80106333:	83 f8 40             	cmp    $0x40,%eax
80106336:	0f 84 44 01 00 00    	je     80106480 <trap+0x160>
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }
  if(tf->trapno == 128){
8010633c:	3d 80 00 00 00       	cmp    $0x80,%eax
80106341:	0f 84 e9 01 00 00    	je     80106530 <trap+0x210>
	cprintf("user interrupt 128 called\n");
	exit();
  }

  switch(tf->trapno){
80106347:	83 e8 20             	sub    $0x20,%eax
8010634a:	83 f8 1f             	cmp    $0x1f,%eax
8010634d:	77 11                	ja     80106360 <trap+0x40>
8010634f:	3e ff 24 85 bc 85 10 	notrack jmp *-0x7fef7a44(,%eax,4)
80106356:	80 
80106357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010635e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106360:	e8 ab d6 ff ff       	call   80103a10 <myproc>
80106365:	8b 7b 38             	mov    0x38(%ebx),%edi
80106368:	85 c0                	test   %eax,%eax
8010636a:	0f 84 59 02 00 00    	je     801065c9 <trap+0x2a9>
80106370:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106374:	0f 84 4f 02 00 00    	je     801065c9 <trap+0x2a9>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010637a:	0f 20 d1             	mov    %cr2,%ecx
8010637d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106380:	e8 6b d6 ff ff       	call   801039f0 <cpuid>
80106385:	8b 73 30             	mov    0x30(%ebx),%esi
80106388:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010638b:	8b 43 34             	mov    0x34(%ebx),%eax
8010638e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106391:	e8 7a d6 ff ff       	call   80103a10 <myproc>
80106396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106399:	e8 72 d6 ff ff       	call   80103a10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010639e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801063a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801063a4:	51                   	push   %ecx
801063a5:	57                   	push   %edi
801063a6:	52                   	push   %edx
801063a7:	ff 75 e4             	pushl  -0x1c(%ebp)
801063aa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801063ab:	8b 75 e0             	mov    -0x20(%ebp),%esi
801063ae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801063b1:	56                   	push   %esi
801063b2:	ff 70 10             	pushl  0x10(%eax)
801063b5:	68 78 85 10 80       	push   $0x80108578
801063ba:	e8 f1 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801063bf:	83 c4 20             	add    $0x20,%esp
801063c2:	e8 49 d6 ff ff       	call   80103a10 <myproc>
801063c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ce:	e8 3d d6 ff ff       	call   80103a10 <myproc>
801063d3:	85 c0                	test   %eax,%eax
801063d5:	74 1d                	je     801063f4 <trap+0xd4>
801063d7:	e8 34 d6 ff ff       	call   80103a10 <myproc>
801063dc:	8b 50 24             	mov    0x24(%eax),%edx
801063df:	85 d2                	test   %edx,%edx
801063e1:	74 11                	je     801063f4 <trap+0xd4>
801063e3:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801063e7:	83 e0 03             	and    $0x3,%eax
801063ea:	66 83 f8 03          	cmp    $0x3,%ax
801063ee:	0f 84 5c 01 00 00    	je     80106550 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801063f4:	e8 17 d6 ff ff       	call   80103a10 <myproc>
801063f9:	85 c0                	test   %eax,%eax
801063fb:	74 0b                	je     80106408 <trap+0xe8>
801063fd:	e8 0e d6 ff ff       	call   80103a10 <myproc>
80106402:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106406:	74 30                	je     80106438 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106408:	e8 03 d6 ff ff       	call   80103a10 <myproc>
8010640d:	85 c0                	test   %eax,%eax
8010640f:	74 19                	je     8010642a <trap+0x10a>
80106411:	e8 fa d5 ff ff       	call   80103a10 <myproc>
80106416:	8b 40 24             	mov    0x24(%eax),%eax
80106419:	85 c0                	test   %eax,%eax
8010641b:	74 0d                	je     8010642a <trap+0x10a>
8010641d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106421:	83 e0 03             	and    $0x3,%eax
80106424:	66 83 f8 03          	cmp    $0x3,%ax
80106428:	74 7f                	je     801064a9 <trap+0x189>
    exit();
}
8010642a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010642d:	5b                   	pop    %ebx
8010642e:	5e                   	pop    %esi
8010642f:	5f                   	pop    %edi
80106430:	5d                   	pop    %ebp
80106431:	c3                   	ret    
80106432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106438:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010643c:	75 ca                	jne    80106408 <trap+0xe8>
    yield();
8010643e:	e8 3d d7 ff ff       	call   80103b80 <yield>
80106443:	eb c3                	jmp    80106408 <trap+0xe8>
80106445:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106448:	8b 7b 38             	mov    0x38(%ebx),%edi
8010644b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010644f:	e8 9c d5 ff ff       	call   801039f0 <cpuid>
80106454:	57                   	push   %edi
80106455:	56                   	push   %esi
80106456:	50                   	push   %eax
80106457:	68 20 85 10 80       	push   $0x80108520
8010645c:	e8 4f a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106461:	e8 5a c4 ff ff       	call   801028c0 <lapiceoi>
    break;
80106466:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106469:	e8 a2 d5 ff ff       	call   80103a10 <myproc>
8010646e:	85 c0                	test   %eax,%eax
80106470:	0f 85 61 ff ff ff    	jne    801063d7 <trap+0xb7>
80106476:	e9 79 ff ff ff       	jmp    801063f4 <trap+0xd4>
8010647b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010647f:	90                   	nop
    if(myproc()->killed)
80106480:	e8 8b d5 ff ff       	call   80103a10 <myproc>
80106485:	8b 70 24             	mov    0x24(%eax),%esi
80106488:	85 f6                	test   %esi,%esi
8010648a:	0f 85 18 01 00 00    	jne    801065a8 <trap+0x288>
    myproc()->tf = tf;
80106490:	e8 7b d5 ff ff       	call   80103a10 <myproc>
80106495:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106498:	e8 53 ee ff ff       	call   801052f0 <syscall>
    if(myproc()->killed)
8010649d:	e8 6e d5 ff ff       	call   80103a10 <myproc>
801064a2:	8b 48 24             	mov    0x24(%eax),%ecx
801064a5:	85 c9                	test   %ecx,%ecx
801064a7:	74 81                	je     8010642a <trap+0x10a>
}
801064a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064ac:	5b                   	pop    %ebx
801064ad:	5e                   	pop    %esi
801064ae:	5f                   	pop    %edi
801064af:	5d                   	pop    %ebp
      exit();
801064b0:	e9 3b dd ff ff       	jmp    801041f0 <exit>
801064b5:	8d 76 00             	lea    0x0(%esi),%esi
    kbdintr();
801064b8:	e8 c3 c2 ff ff       	call   80102780 <kbdintr>
    lapiceoi();
801064bd:	e8 fe c3 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c2:	e8 49 d5 ff ff       	call   80103a10 <myproc>
801064c7:	85 c0                	test   %eax,%eax
801064c9:	0f 85 08 ff ff ff    	jne    801063d7 <trap+0xb7>
801064cf:	e9 20 ff ff ff       	jmp    801063f4 <trap+0xd4>
801064d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801064d8:	e8 13 d5 ff ff       	call   801039f0 <cpuid>
801064dd:	85 c0                	test   %eax,%eax
801064df:	74 7f                	je     80106560 <trap+0x240>
    lapiceoi();
801064e1:	e8 da c3 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064e6:	e8 25 d5 ff ff       	call   80103a10 <myproc>
801064eb:	85 c0                	test   %eax,%eax
801064ed:	0f 85 e4 fe ff ff    	jne    801063d7 <trap+0xb7>
801064f3:	e9 fc fe ff ff       	jmp    801063f4 <trap+0xd4>
801064f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ff:	90                   	nop
    uartintr();
80106500:	e8 6b 02 00 00       	call   80106770 <uartintr>
    lapiceoi();
80106505:	e8 b6 c3 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010650a:	e8 01 d5 ff ff       	call   80103a10 <myproc>
8010650f:	85 c0                	test   %eax,%eax
80106511:	0f 85 c0 fe ff ff    	jne    801063d7 <trap+0xb7>
80106517:	e9 d8 fe ff ff       	jmp    801063f4 <trap+0xd4>
8010651c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80106520:	e8 bb bc ff ff       	call   801021e0 <ideintr>
80106525:	eb ba                	jmp    801064e1 <trap+0x1c1>
80106527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010652e:	66 90                	xchg   %ax,%ax
	cprintf("user interrupt 128 called\n");
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	68 fe 84 10 80       	push   $0x801084fe
80106538:	e8 73 a1 ff ff       	call   801006b0 <cprintf>
	exit();
8010653d:	e8 ae dc ff ff       	call   801041f0 <exit>
80106542:	8b 43 30             	mov    0x30(%ebx),%eax
80106545:	83 c4 10             	add    $0x10,%esp
80106548:	e9 fa fd ff ff       	jmp    80106347 <trap+0x27>
8010654d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106550:	e8 9b dc ff ff       	call   801041f0 <exit>
80106555:	e9 9a fe ff ff       	jmp    801063f4 <trap+0xd4>
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	68 00 63 11 80       	push   $0x80116300
80106568:	e8 a3 e8 ff ff       	call   80104e10 <acquire>
      ticks++;
8010656d:	a1 40 6b 11 80       	mov    0x80116b40,%eax
      if(ticks >= 100)
80106572:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106575:	83 c0 01             	add    $0x1,%eax
80106578:	a3 40 6b 11 80       	mov    %eax,0x80116b40
      if(ticks >= 100)
8010657d:	83 f8 63             	cmp    $0x63,%eax
80106580:	77 36                	ja     801065b8 <trap+0x298>
      wakeup(&ticks);
80106582:	83 ec 0c             	sub    $0xc,%esp
80106585:	68 40 6b 11 80       	push   $0x80116b40
8010658a:	e8 61 dd ff ff       	call   801042f0 <wakeup>
      release(&tickslock);
8010658f:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80106596:	e8 35 e9 ff ff       	call   80104ed0 <release>
8010659b:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010659e:	e9 3e ff ff ff       	jmp    801064e1 <trap+0x1c1>
801065a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065a7:	90                   	nop
      exit();
801065a8:	e8 43 dc ff ff       	call   801041f0 <exit>
801065ad:	e9 de fe ff ff       	jmp    80106490 <trap+0x170>
801065b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	priority_boosting();
801065b8:	e8 13 e0 ff ff       	call   801045d0 <priority_boosting>
        ticks = 0;
801065bd:	c7 05 40 6b 11 80 00 	movl   $0x0,0x80116b40
801065c4:	00 00 00 
801065c7:	eb b9                	jmp    80106582 <trap+0x262>
801065c9:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801065cc:	e8 1f d4 ff ff       	call   801039f0 <cpuid>
801065d1:	83 ec 0c             	sub    $0xc,%esp
801065d4:	56                   	push   %esi
801065d5:	57                   	push   %edi
801065d6:	50                   	push   %eax
801065d7:	ff 73 30             	pushl  0x30(%ebx)
801065da:	68 44 85 10 80       	push   $0x80108544
801065df:	e8 cc a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801065e4:	83 c4 14             	add    $0x14,%esp
801065e7:	68 19 85 10 80       	push   $0x80108519
801065ec:	e8 9f 9d ff ff       	call   80100390 <panic>
801065f1:	66 90                	xchg   %ax,%ax
801065f3:	66 90                	xchg   %ax,%ax
801065f5:	66 90                	xchg   %ax,%ax
801065f7:	66 90                	xchg   %ax,%ax
801065f9:	66 90                	xchg   %ax,%ax
801065fb:	66 90                	xchg   %ax,%ax
801065fd:	66 90                	xchg   %ax,%ax
801065ff:	90                   	nop

80106600 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106600:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106604:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80106609:	85 c0                	test   %eax,%eax
8010660b:	74 1b                	je     80106628 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010660d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106612:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106613:	a8 01                	test   $0x1,%al
80106615:	74 11                	je     80106628 <uartgetc+0x28>
80106617:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010661c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010661d:	0f b6 c0             	movzbl %al,%eax
80106620:	c3                   	ret    
80106621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010662d:	c3                   	ret    
8010662e:	66 90                	xchg   %ax,%ax

80106630 <uartputc.part.0>:
uartputc(int c)
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	57                   	push   %edi
80106634:	89 c7                	mov    %eax,%edi
80106636:	56                   	push   %esi
80106637:	be fd 03 00 00       	mov    $0x3fd,%esi
8010663c:	53                   	push   %ebx
8010663d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106642:	83 ec 0c             	sub    $0xc,%esp
80106645:	eb 1b                	jmp    80106662 <uartputc.part.0+0x32>
80106647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010664e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106650:	83 ec 0c             	sub    $0xc,%esp
80106653:	6a 0a                	push   $0xa
80106655:	e8 86 c2 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010665a:	83 c4 10             	add    $0x10,%esp
8010665d:	83 eb 01             	sub    $0x1,%ebx
80106660:	74 07                	je     80106669 <uartputc.part.0+0x39>
80106662:	89 f2                	mov    %esi,%edx
80106664:	ec                   	in     (%dx),%al
80106665:	a8 20                	test   $0x20,%al
80106667:	74 e7                	je     80106650 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106669:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010666e:	89 f8                	mov    %edi,%eax
80106670:	ee                   	out    %al,(%dx)
}
80106671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106674:	5b                   	pop    %ebx
80106675:	5e                   	pop    %esi
80106676:	5f                   	pop    %edi
80106677:	5d                   	pop    %ebp
80106678:	c3                   	ret    
80106679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106680 <uartinit>:
{
80106680:	f3 0f 1e fb          	endbr32 
80106684:	55                   	push   %ebp
80106685:	31 c9                	xor    %ecx,%ecx
80106687:	89 c8                	mov    %ecx,%eax
80106689:	89 e5                	mov    %esp,%ebp
8010668b:	57                   	push   %edi
8010668c:	56                   	push   %esi
8010668d:	53                   	push   %ebx
8010668e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106693:	89 da                	mov    %ebx,%edx
80106695:	83 ec 0c             	sub    $0xc,%esp
80106698:	ee                   	out    %al,(%dx)
80106699:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010669e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066a3:	89 fa                	mov    %edi,%edx
801066a5:	ee                   	out    %al,(%dx)
801066a6:	b8 0c 00 00 00       	mov    $0xc,%eax
801066ab:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066b0:	ee                   	out    %al,(%dx)
801066b1:	be f9 03 00 00       	mov    $0x3f9,%esi
801066b6:	89 c8                	mov    %ecx,%eax
801066b8:	89 f2                	mov    %esi,%edx
801066ba:	ee                   	out    %al,(%dx)
801066bb:	b8 03 00 00 00       	mov    $0x3,%eax
801066c0:	89 fa                	mov    %edi,%edx
801066c2:	ee                   	out    %al,(%dx)
801066c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801066c8:	89 c8                	mov    %ecx,%eax
801066ca:	ee                   	out    %al,(%dx)
801066cb:	b8 01 00 00 00       	mov    $0x1,%eax
801066d0:	89 f2                	mov    %esi,%edx
801066d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066d3:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066d8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801066d9:	3c ff                	cmp    $0xff,%al
801066db:	74 52                	je     8010672f <uartinit+0xaf>
  uart = 1;
801066dd:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801066e4:	00 00 00 
801066e7:	89 da                	mov    %ebx,%edx
801066e9:	ec                   	in     (%dx),%al
801066ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801066f0:	83 ec 08             	sub    $0x8,%esp
801066f3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801066f8:	bb 3c 86 10 80       	mov    $0x8010863c,%ebx
  ioapicenable(IRQ_COM1, 0);
801066fd:	6a 00                	push   $0x0
801066ff:	6a 04                	push   $0x4
80106701:	e8 2a bd ff ff       	call   80102430 <ioapicenable>
80106706:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106709:	b8 78 00 00 00       	mov    $0x78,%eax
8010670e:	eb 04                	jmp    80106714 <uartinit+0x94>
80106710:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106714:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
8010671a:	85 d2                	test   %edx,%edx
8010671c:	74 08                	je     80106726 <uartinit+0xa6>
    uartputc(*p);
8010671e:	0f be c0             	movsbl %al,%eax
80106721:	e8 0a ff ff ff       	call   80106630 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106726:	89 f0                	mov    %esi,%eax
80106728:	83 c3 01             	add    $0x1,%ebx
8010672b:	84 c0                	test   %al,%al
8010672d:	75 e1                	jne    80106710 <uartinit+0x90>
}
8010672f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106732:	5b                   	pop    %ebx
80106733:	5e                   	pop    %esi
80106734:	5f                   	pop    %edi
80106735:	5d                   	pop    %ebp
80106736:	c3                   	ret    
80106737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010673e:	66 90                	xchg   %ax,%ax

80106740 <uartputc>:
{
80106740:	f3 0f 1e fb          	endbr32 
80106744:	55                   	push   %ebp
  if(!uart)
80106745:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
8010674b:	89 e5                	mov    %esp,%ebp
8010674d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106750:	85 d2                	test   %edx,%edx
80106752:	74 0c                	je     80106760 <uartputc+0x20>
}
80106754:	5d                   	pop    %ebp
80106755:	e9 d6 fe ff ff       	jmp    80106630 <uartputc.part.0>
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106760:	5d                   	pop    %ebp
80106761:	c3                   	ret    
80106762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106770 <uartintr>:

void
uartintr(void)
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010677a:	68 00 66 10 80       	push   $0x80106600
8010677f:	e8 dc a0 ff ff       	call   80100860 <consoleintr>
}
80106784:	83 c4 10             	add    $0x10,%esp
80106787:	c9                   	leave  
80106788:	c3                   	ret    

80106789 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106789:	6a 00                	push   $0x0
  pushl $0
8010678b:	6a 00                	push   $0x0
  jmp alltraps
8010678d:	e9 91 fa ff ff       	jmp    80106223 <alltraps>

80106792 <vector1>:
.globl vector1
vector1:
  pushl $0
80106792:	6a 00                	push   $0x0
  pushl $1
80106794:	6a 01                	push   $0x1
  jmp alltraps
80106796:	e9 88 fa ff ff       	jmp    80106223 <alltraps>

8010679b <vector2>:
.globl vector2
vector2:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $2
8010679d:	6a 02                	push   $0x2
  jmp alltraps
8010679f:	e9 7f fa ff ff       	jmp    80106223 <alltraps>

801067a4 <vector3>:
.globl vector3
vector3:
  pushl $0
801067a4:	6a 00                	push   $0x0
  pushl $3
801067a6:	6a 03                	push   $0x3
  jmp alltraps
801067a8:	e9 76 fa ff ff       	jmp    80106223 <alltraps>

801067ad <vector4>:
.globl vector4
vector4:
  pushl $0
801067ad:	6a 00                	push   $0x0
  pushl $4
801067af:	6a 04                	push   $0x4
  jmp alltraps
801067b1:	e9 6d fa ff ff       	jmp    80106223 <alltraps>

801067b6 <vector5>:
.globl vector5
vector5:
  pushl $0
801067b6:	6a 00                	push   $0x0
  pushl $5
801067b8:	6a 05                	push   $0x5
  jmp alltraps
801067ba:	e9 64 fa ff ff       	jmp    80106223 <alltraps>

801067bf <vector6>:
.globl vector6
vector6:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $6
801067c1:	6a 06                	push   $0x6
  jmp alltraps
801067c3:	e9 5b fa ff ff       	jmp    80106223 <alltraps>

801067c8 <vector7>:
.globl vector7
vector7:
  pushl $0
801067c8:	6a 00                	push   $0x0
  pushl $7
801067ca:	6a 07                	push   $0x7
  jmp alltraps
801067cc:	e9 52 fa ff ff       	jmp    80106223 <alltraps>

801067d1 <vector8>:
.globl vector8
vector8:
  pushl $8
801067d1:	6a 08                	push   $0x8
  jmp alltraps
801067d3:	e9 4b fa ff ff       	jmp    80106223 <alltraps>

801067d8 <vector9>:
.globl vector9
vector9:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $9
801067da:	6a 09                	push   $0x9
  jmp alltraps
801067dc:	e9 42 fa ff ff       	jmp    80106223 <alltraps>

801067e1 <vector10>:
.globl vector10
vector10:
  pushl $10
801067e1:	6a 0a                	push   $0xa
  jmp alltraps
801067e3:	e9 3b fa ff ff       	jmp    80106223 <alltraps>

801067e8 <vector11>:
.globl vector11
vector11:
  pushl $11
801067e8:	6a 0b                	push   $0xb
  jmp alltraps
801067ea:	e9 34 fa ff ff       	jmp    80106223 <alltraps>

801067ef <vector12>:
.globl vector12
vector12:
  pushl $12
801067ef:	6a 0c                	push   $0xc
  jmp alltraps
801067f1:	e9 2d fa ff ff       	jmp    80106223 <alltraps>

801067f6 <vector13>:
.globl vector13
vector13:
  pushl $13
801067f6:	6a 0d                	push   $0xd
  jmp alltraps
801067f8:	e9 26 fa ff ff       	jmp    80106223 <alltraps>

801067fd <vector14>:
.globl vector14
vector14:
  pushl $14
801067fd:	6a 0e                	push   $0xe
  jmp alltraps
801067ff:	e9 1f fa ff ff       	jmp    80106223 <alltraps>

80106804 <vector15>:
.globl vector15
vector15:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $15
80106806:	6a 0f                	push   $0xf
  jmp alltraps
80106808:	e9 16 fa ff ff       	jmp    80106223 <alltraps>

8010680d <vector16>:
.globl vector16
vector16:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $16
8010680f:	6a 10                	push   $0x10
  jmp alltraps
80106811:	e9 0d fa ff ff       	jmp    80106223 <alltraps>

80106816 <vector17>:
.globl vector17
vector17:
  pushl $17
80106816:	6a 11                	push   $0x11
  jmp alltraps
80106818:	e9 06 fa ff ff       	jmp    80106223 <alltraps>

8010681d <vector18>:
.globl vector18
vector18:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $18
8010681f:	6a 12                	push   $0x12
  jmp alltraps
80106821:	e9 fd f9 ff ff       	jmp    80106223 <alltraps>

80106826 <vector19>:
.globl vector19
vector19:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $19
80106828:	6a 13                	push   $0x13
  jmp alltraps
8010682a:	e9 f4 f9 ff ff       	jmp    80106223 <alltraps>

8010682f <vector20>:
.globl vector20
vector20:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $20
80106831:	6a 14                	push   $0x14
  jmp alltraps
80106833:	e9 eb f9 ff ff       	jmp    80106223 <alltraps>

80106838 <vector21>:
.globl vector21
vector21:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $21
8010683a:	6a 15                	push   $0x15
  jmp alltraps
8010683c:	e9 e2 f9 ff ff       	jmp    80106223 <alltraps>

80106841 <vector22>:
.globl vector22
vector22:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $22
80106843:	6a 16                	push   $0x16
  jmp alltraps
80106845:	e9 d9 f9 ff ff       	jmp    80106223 <alltraps>

8010684a <vector23>:
.globl vector23
vector23:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $23
8010684c:	6a 17                	push   $0x17
  jmp alltraps
8010684e:	e9 d0 f9 ff ff       	jmp    80106223 <alltraps>

80106853 <vector24>:
.globl vector24
vector24:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $24
80106855:	6a 18                	push   $0x18
  jmp alltraps
80106857:	e9 c7 f9 ff ff       	jmp    80106223 <alltraps>

8010685c <vector25>:
.globl vector25
vector25:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $25
8010685e:	6a 19                	push   $0x19
  jmp alltraps
80106860:	e9 be f9 ff ff       	jmp    80106223 <alltraps>

80106865 <vector26>:
.globl vector26
vector26:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $26
80106867:	6a 1a                	push   $0x1a
  jmp alltraps
80106869:	e9 b5 f9 ff ff       	jmp    80106223 <alltraps>

8010686e <vector27>:
.globl vector27
vector27:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $27
80106870:	6a 1b                	push   $0x1b
  jmp alltraps
80106872:	e9 ac f9 ff ff       	jmp    80106223 <alltraps>

80106877 <vector28>:
.globl vector28
vector28:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $28
80106879:	6a 1c                	push   $0x1c
  jmp alltraps
8010687b:	e9 a3 f9 ff ff       	jmp    80106223 <alltraps>

80106880 <vector29>:
.globl vector29
vector29:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $29
80106882:	6a 1d                	push   $0x1d
  jmp alltraps
80106884:	e9 9a f9 ff ff       	jmp    80106223 <alltraps>

80106889 <vector30>:
.globl vector30
vector30:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $30
8010688b:	6a 1e                	push   $0x1e
  jmp alltraps
8010688d:	e9 91 f9 ff ff       	jmp    80106223 <alltraps>

80106892 <vector31>:
.globl vector31
vector31:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $31
80106894:	6a 1f                	push   $0x1f
  jmp alltraps
80106896:	e9 88 f9 ff ff       	jmp    80106223 <alltraps>

8010689b <vector32>:
.globl vector32
vector32:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $32
8010689d:	6a 20                	push   $0x20
  jmp alltraps
8010689f:	e9 7f f9 ff ff       	jmp    80106223 <alltraps>

801068a4 <vector33>:
.globl vector33
vector33:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $33
801068a6:	6a 21                	push   $0x21
  jmp alltraps
801068a8:	e9 76 f9 ff ff       	jmp    80106223 <alltraps>

801068ad <vector34>:
.globl vector34
vector34:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $34
801068af:	6a 22                	push   $0x22
  jmp alltraps
801068b1:	e9 6d f9 ff ff       	jmp    80106223 <alltraps>

801068b6 <vector35>:
.globl vector35
vector35:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $35
801068b8:	6a 23                	push   $0x23
  jmp alltraps
801068ba:	e9 64 f9 ff ff       	jmp    80106223 <alltraps>

801068bf <vector36>:
.globl vector36
vector36:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $36
801068c1:	6a 24                	push   $0x24
  jmp alltraps
801068c3:	e9 5b f9 ff ff       	jmp    80106223 <alltraps>

801068c8 <vector37>:
.globl vector37
vector37:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $37
801068ca:	6a 25                	push   $0x25
  jmp alltraps
801068cc:	e9 52 f9 ff ff       	jmp    80106223 <alltraps>

801068d1 <vector38>:
.globl vector38
vector38:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $38
801068d3:	6a 26                	push   $0x26
  jmp alltraps
801068d5:	e9 49 f9 ff ff       	jmp    80106223 <alltraps>

801068da <vector39>:
.globl vector39
vector39:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $39
801068dc:	6a 27                	push   $0x27
  jmp alltraps
801068de:	e9 40 f9 ff ff       	jmp    80106223 <alltraps>

801068e3 <vector40>:
.globl vector40
vector40:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $40
801068e5:	6a 28                	push   $0x28
  jmp alltraps
801068e7:	e9 37 f9 ff ff       	jmp    80106223 <alltraps>

801068ec <vector41>:
.globl vector41
vector41:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $41
801068ee:	6a 29                	push   $0x29
  jmp alltraps
801068f0:	e9 2e f9 ff ff       	jmp    80106223 <alltraps>

801068f5 <vector42>:
.globl vector42
vector42:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $42
801068f7:	6a 2a                	push   $0x2a
  jmp alltraps
801068f9:	e9 25 f9 ff ff       	jmp    80106223 <alltraps>

801068fe <vector43>:
.globl vector43
vector43:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $43
80106900:	6a 2b                	push   $0x2b
  jmp alltraps
80106902:	e9 1c f9 ff ff       	jmp    80106223 <alltraps>

80106907 <vector44>:
.globl vector44
vector44:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $44
80106909:	6a 2c                	push   $0x2c
  jmp alltraps
8010690b:	e9 13 f9 ff ff       	jmp    80106223 <alltraps>

80106910 <vector45>:
.globl vector45
vector45:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $45
80106912:	6a 2d                	push   $0x2d
  jmp alltraps
80106914:	e9 0a f9 ff ff       	jmp    80106223 <alltraps>

80106919 <vector46>:
.globl vector46
vector46:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $46
8010691b:	6a 2e                	push   $0x2e
  jmp alltraps
8010691d:	e9 01 f9 ff ff       	jmp    80106223 <alltraps>

80106922 <vector47>:
.globl vector47
vector47:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $47
80106924:	6a 2f                	push   $0x2f
  jmp alltraps
80106926:	e9 f8 f8 ff ff       	jmp    80106223 <alltraps>

8010692b <vector48>:
.globl vector48
vector48:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $48
8010692d:	6a 30                	push   $0x30
  jmp alltraps
8010692f:	e9 ef f8 ff ff       	jmp    80106223 <alltraps>

80106934 <vector49>:
.globl vector49
vector49:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $49
80106936:	6a 31                	push   $0x31
  jmp alltraps
80106938:	e9 e6 f8 ff ff       	jmp    80106223 <alltraps>

8010693d <vector50>:
.globl vector50
vector50:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $50
8010693f:	6a 32                	push   $0x32
  jmp alltraps
80106941:	e9 dd f8 ff ff       	jmp    80106223 <alltraps>

80106946 <vector51>:
.globl vector51
vector51:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $51
80106948:	6a 33                	push   $0x33
  jmp alltraps
8010694a:	e9 d4 f8 ff ff       	jmp    80106223 <alltraps>

8010694f <vector52>:
.globl vector52
vector52:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $52
80106951:	6a 34                	push   $0x34
  jmp alltraps
80106953:	e9 cb f8 ff ff       	jmp    80106223 <alltraps>

80106958 <vector53>:
.globl vector53
vector53:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $53
8010695a:	6a 35                	push   $0x35
  jmp alltraps
8010695c:	e9 c2 f8 ff ff       	jmp    80106223 <alltraps>

80106961 <vector54>:
.globl vector54
vector54:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $54
80106963:	6a 36                	push   $0x36
  jmp alltraps
80106965:	e9 b9 f8 ff ff       	jmp    80106223 <alltraps>

8010696a <vector55>:
.globl vector55
vector55:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $55
8010696c:	6a 37                	push   $0x37
  jmp alltraps
8010696e:	e9 b0 f8 ff ff       	jmp    80106223 <alltraps>

80106973 <vector56>:
.globl vector56
vector56:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $56
80106975:	6a 38                	push   $0x38
  jmp alltraps
80106977:	e9 a7 f8 ff ff       	jmp    80106223 <alltraps>

8010697c <vector57>:
.globl vector57
vector57:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $57
8010697e:	6a 39                	push   $0x39
  jmp alltraps
80106980:	e9 9e f8 ff ff       	jmp    80106223 <alltraps>

80106985 <vector58>:
.globl vector58
vector58:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $58
80106987:	6a 3a                	push   $0x3a
  jmp alltraps
80106989:	e9 95 f8 ff ff       	jmp    80106223 <alltraps>

8010698e <vector59>:
.globl vector59
vector59:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $59
80106990:	6a 3b                	push   $0x3b
  jmp alltraps
80106992:	e9 8c f8 ff ff       	jmp    80106223 <alltraps>

80106997 <vector60>:
.globl vector60
vector60:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $60
80106999:	6a 3c                	push   $0x3c
  jmp alltraps
8010699b:	e9 83 f8 ff ff       	jmp    80106223 <alltraps>

801069a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $61
801069a2:	6a 3d                	push   $0x3d
  jmp alltraps
801069a4:	e9 7a f8 ff ff       	jmp    80106223 <alltraps>

801069a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $62
801069ab:	6a 3e                	push   $0x3e
  jmp alltraps
801069ad:	e9 71 f8 ff ff       	jmp    80106223 <alltraps>

801069b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $63
801069b4:	6a 3f                	push   $0x3f
  jmp alltraps
801069b6:	e9 68 f8 ff ff       	jmp    80106223 <alltraps>

801069bb <vector64>:
.globl vector64
vector64:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $64
801069bd:	6a 40                	push   $0x40
  jmp alltraps
801069bf:	e9 5f f8 ff ff       	jmp    80106223 <alltraps>

801069c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $65
801069c6:	6a 41                	push   $0x41
  jmp alltraps
801069c8:	e9 56 f8 ff ff       	jmp    80106223 <alltraps>

801069cd <vector66>:
.globl vector66
vector66:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $66
801069cf:	6a 42                	push   $0x42
  jmp alltraps
801069d1:	e9 4d f8 ff ff       	jmp    80106223 <alltraps>

801069d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $67
801069d8:	6a 43                	push   $0x43
  jmp alltraps
801069da:	e9 44 f8 ff ff       	jmp    80106223 <alltraps>

801069df <vector68>:
.globl vector68
vector68:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $68
801069e1:	6a 44                	push   $0x44
  jmp alltraps
801069e3:	e9 3b f8 ff ff       	jmp    80106223 <alltraps>

801069e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $69
801069ea:	6a 45                	push   $0x45
  jmp alltraps
801069ec:	e9 32 f8 ff ff       	jmp    80106223 <alltraps>

801069f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $70
801069f3:	6a 46                	push   $0x46
  jmp alltraps
801069f5:	e9 29 f8 ff ff       	jmp    80106223 <alltraps>

801069fa <vector71>:
.globl vector71
vector71:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $71
801069fc:	6a 47                	push   $0x47
  jmp alltraps
801069fe:	e9 20 f8 ff ff       	jmp    80106223 <alltraps>

80106a03 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $72
80106a05:	6a 48                	push   $0x48
  jmp alltraps
80106a07:	e9 17 f8 ff ff       	jmp    80106223 <alltraps>

80106a0c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $73
80106a0e:	6a 49                	push   $0x49
  jmp alltraps
80106a10:	e9 0e f8 ff ff       	jmp    80106223 <alltraps>

80106a15 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $74
80106a17:	6a 4a                	push   $0x4a
  jmp alltraps
80106a19:	e9 05 f8 ff ff       	jmp    80106223 <alltraps>

80106a1e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $75
80106a20:	6a 4b                	push   $0x4b
  jmp alltraps
80106a22:	e9 fc f7 ff ff       	jmp    80106223 <alltraps>

80106a27 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $76
80106a29:	6a 4c                	push   $0x4c
  jmp alltraps
80106a2b:	e9 f3 f7 ff ff       	jmp    80106223 <alltraps>

80106a30 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $77
80106a32:	6a 4d                	push   $0x4d
  jmp alltraps
80106a34:	e9 ea f7 ff ff       	jmp    80106223 <alltraps>

80106a39 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $78
80106a3b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a3d:	e9 e1 f7 ff ff       	jmp    80106223 <alltraps>

80106a42 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $79
80106a44:	6a 4f                	push   $0x4f
  jmp alltraps
80106a46:	e9 d8 f7 ff ff       	jmp    80106223 <alltraps>

80106a4b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $80
80106a4d:	6a 50                	push   $0x50
  jmp alltraps
80106a4f:	e9 cf f7 ff ff       	jmp    80106223 <alltraps>

80106a54 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $81
80106a56:	6a 51                	push   $0x51
  jmp alltraps
80106a58:	e9 c6 f7 ff ff       	jmp    80106223 <alltraps>

80106a5d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a5d:	6a 00                	push   $0x0
  pushl $82
80106a5f:	6a 52                	push   $0x52
  jmp alltraps
80106a61:	e9 bd f7 ff ff       	jmp    80106223 <alltraps>

80106a66 <vector83>:
.globl vector83
vector83:
  pushl $0
80106a66:	6a 00                	push   $0x0
  pushl $83
80106a68:	6a 53                	push   $0x53
  jmp alltraps
80106a6a:	e9 b4 f7 ff ff       	jmp    80106223 <alltraps>

80106a6f <vector84>:
.globl vector84
vector84:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $84
80106a71:	6a 54                	push   $0x54
  jmp alltraps
80106a73:	e9 ab f7 ff ff       	jmp    80106223 <alltraps>

80106a78 <vector85>:
.globl vector85
vector85:
  pushl $0
80106a78:	6a 00                	push   $0x0
  pushl $85
80106a7a:	6a 55                	push   $0x55
  jmp alltraps
80106a7c:	e9 a2 f7 ff ff       	jmp    80106223 <alltraps>

80106a81 <vector86>:
.globl vector86
vector86:
  pushl $0
80106a81:	6a 00                	push   $0x0
  pushl $86
80106a83:	6a 56                	push   $0x56
  jmp alltraps
80106a85:	e9 99 f7 ff ff       	jmp    80106223 <alltraps>

80106a8a <vector87>:
.globl vector87
vector87:
  pushl $0
80106a8a:	6a 00                	push   $0x0
  pushl $87
80106a8c:	6a 57                	push   $0x57
  jmp alltraps
80106a8e:	e9 90 f7 ff ff       	jmp    80106223 <alltraps>

80106a93 <vector88>:
.globl vector88
vector88:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $88
80106a95:	6a 58                	push   $0x58
  jmp alltraps
80106a97:	e9 87 f7 ff ff       	jmp    80106223 <alltraps>

80106a9c <vector89>:
.globl vector89
vector89:
  pushl $0
80106a9c:	6a 00                	push   $0x0
  pushl $89
80106a9e:	6a 59                	push   $0x59
  jmp alltraps
80106aa0:	e9 7e f7 ff ff       	jmp    80106223 <alltraps>

80106aa5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106aa5:	6a 00                	push   $0x0
  pushl $90
80106aa7:	6a 5a                	push   $0x5a
  jmp alltraps
80106aa9:	e9 75 f7 ff ff       	jmp    80106223 <alltraps>

80106aae <vector91>:
.globl vector91
vector91:
  pushl $0
80106aae:	6a 00                	push   $0x0
  pushl $91
80106ab0:	6a 5b                	push   $0x5b
  jmp alltraps
80106ab2:	e9 6c f7 ff ff       	jmp    80106223 <alltraps>

80106ab7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $92
80106ab9:	6a 5c                	push   $0x5c
  jmp alltraps
80106abb:	e9 63 f7 ff ff       	jmp    80106223 <alltraps>

80106ac0 <vector93>:
.globl vector93
vector93:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $93
80106ac2:	6a 5d                	push   $0x5d
  jmp alltraps
80106ac4:	e9 5a f7 ff ff       	jmp    80106223 <alltraps>

80106ac9 <vector94>:
.globl vector94
vector94:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $94
80106acb:	6a 5e                	push   $0x5e
  jmp alltraps
80106acd:	e9 51 f7 ff ff       	jmp    80106223 <alltraps>

80106ad2 <vector95>:
.globl vector95
vector95:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $95
80106ad4:	6a 5f                	push   $0x5f
  jmp alltraps
80106ad6:	e9 48 f7 ff ff       	jmp    80106223 <alltraps>

80106adb <vector96>:
.globl vector96
vector96:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $96
80106add:	6a 60                	push   $0x60
  jmp alltraps
80106adf:	e9 3f f7 ff ff       	jmp    80106223 <alltraps>

80106ae4 <vector97>:
.globl vector97
vector97:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $97
80106ae6:	6a 61                	push   $0x61
  jmp alltraps
80106ae8:	e9 36 f7 ff ff       	jmp    80106223 <alltraps>

80106aed <vector98>:
.globl vector98
vector98:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $98
80106aef:	6a 62                	push   $0x62
  jmp alltraps
80106af1:	e9 2d f7 ff ff       	jmp    80106223 <alltraps>

80106af6 <vector99>:
.globl vector99
vector99:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $99
80106af8:	6a 63                	push   $0x63
  jmp alltraps
80106afa:	e9 24 f7 ff ff       	jmp    80106223 <alltraps>

80106aff <vector100>:
.globl vector100
vector100:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $100
80106b01:	6a 64                	push   $0x64
  jmp alltraps
80106b03:	e9 1b f7 ff ff       	jmp    80106223 <alltraps>

80106b08 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $101
80106b0a:	6a 65                	push   $0x65
  jmp alltraps
80106b0c:	e9 12 f7 ff ff       	jmp    80106223 <alltraps>

80106b11 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $102
80106b13:	6a 66                	push   $0x66
  jmp alltraps
80106b15:	e9 09 f7 ff ff       	jmp    80106223 <alltraps>

80106b1a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $103
80106b1c:	6a 67                	push   $0x67
  jmp alltraps
80106b1e:	e9 00 f7 ff ff       	jmp    80106223 <alltraps>

80106b23 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $104
80106b25:	6a 68                	push   $0x68
  jmp alltraps
80106b27:	e9 f7 f6 ff ff       	jmp    80106223 <alltraps>

80106b2c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $105
80106b2e:	6a 69                	push   $0x69
  jmp alltraps
80106b30:	e9 ee f6 ff ff       	jmp    80106223 <alltraps>

80106b35 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $106
80106b37:	6a 6a                	push   $0x6a
  jmp alltraps
80106b39:	e9 e5 f6 ff ff       	jmp    80106223 <alltraps>

80106b3e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $107
80106b40:	6a 6b                	push   $0x6b
  jmp alltraps
80106b42:	e9 dc f6 ff ff       	jmp    80106223 <alltraps>

80106b47 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $108
80106b49:	6a 6c                	push   $0x6c
  jmp alltraps
80106b4b:	e9 d3 f6 ff ff       	jmp    80106223 <alltraps>

80106b50 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $109
80106b52:	6a 6d                	push   $0x6d
  jmp alltraps
80106b54:	e9 ca f6 ff ff       	jmp    80106223 <alltraps>

80106b59 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $110
80106b5b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b5d:	e9 c1 f6 ff ff       	jmp    80106223 <alltraps>

80106b62 <vector111>:
.globl vector111
vector111:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $111
80106b64:	6a 6f                	push   $0x6f
  jmp alltraps
80106b66:	e9 b8 f6 ff ff       	jmp    80106223 <alltraps>

80106b6b <vector112>:
.globl vector112
vector112:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $112
80106b6d:	6a 70                	push   $0x70
  jmp alltraps
80106b6f:	e9 af f6 ff ff       	jmp    80106223 <alltraps>

80106b74 <vector113>:
.globl vector113
vector113:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $113
80106b76:	6a 71                	push   $0x71
  jmp alltraps
80106b78:	e9 a6 f6 ff ff       	jmp    80106223 <alltraps>

80106b7d <vector114>:
.globl vector114
vector114:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $114
80106b7f:	6a 72                	push   $0x72
  jmp alltraps
80106b81:	e9 9d f6 ff ff       	jmp    80106223 <alltraps>

80106b86 <vector115>:
.globl vector115
vector115:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $115
80106b88:	6a 73                	push   $0x73
  jmp alltraps
80106b8a:	e9 94 f6 ff ff       	jmp    80106223 <alltraps>

80106b8f <vector116>:
.globl vector116
vector116:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $116
80106b91:	6a 74                	push   $0x74
  jmp alltraps
80106b93:	e9 8b f6 ff ff       	jmp    80106223 <alltraps>

80106b98 <vector117>:
.globl vector117
vector117:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $117
80106b9a:	6a 75                	push   $0x75
  jmp alltraps
80106b9c:	e9 82 f6 ff ff       	jmp    80106223 <alltraps>

80106ba1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $118
80106ba3:	6a 76                	push   $0x76
  jmp alltraps
80106ba5:	e9 79 f6 ff ff       	jmp    80106223 <alltraps>

80106baa <vector119>:
.globl vector119
vector119:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $119
80106bac:	6a 77                	push   $0x77
  jmp alltraps
80106bae:	e9 70 f6 ff ff       	jmp    80106223 <alltraps>

80106bb3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $120
80106bb5:	6a 78                	push   $0x78
  jmp alltraps
80106bb7:	e9 67 f6 ff ff       	jmp    80106223 <alltraps>

80106bbc <vector121>:
.globl vector121
vector121:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $121
80106bbe:	6a 79                	push   $0x79
  jmp alltraps
80106bc0:	e9 5e f6 ff ff       	jmp    80106223 <alltraps>

80106bc5 <vector122>:
.globl vector122
vector122:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $122
80106bc7:	6a 7a                	push   $0x7a
  jmp alltraps
80106bc9:	e9 55 f6 ff ff       	jmp    80106223 <alltraps>

80106bce <vector123>:
.globl vector123
vector123:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $123
80106bd0:	6a 7b                	push   $0x7b
  jmp alltraps
80106bd2:	e9 4c f6 ff ff       	jmp    80106223 <alltraps>

80106bd7 <vector124>:
.globl vector124
vector124:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $124
80106bd9:	6a 7c                	push   $0x7c
  jmp alltraps
80106bdb:	e9 43 f6 ff ff       	jmp    80106223 <alltraps>

80106be0 <vector125>:
.globl vector125
vector125:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $125
80106be2:	6a 7d                	push   $0x7d
  jmp alltraps
80106be4:	e9 3a f6 ff ff       	jmp    80106223 <alltraps>

80106be9 <vector126>:
.globl vector126
vector126:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $126
80106beb:	6a 7e                	push   $0x7e
  jmp alltraps
80106bed:	e9 31 f6 ff ff       	jmp    80106223 <alltraps>

80106bf2 <vector127>:
.globl vector127
vector127:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $127
80106bf4:	6a 7f                	push   $0x7f
  jmp alltraps
80106bf6:	e9 28 f6 ff ff       	jmp    80106223 <alltraps>

80106bfb <vector128>:
.globl vector128
vector128:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $128
80106bfd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c02:	e9 1c f6 ff ff       	jmp    80106223 <alltraps>

80106c07 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $129
80106c09:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c0e:	e9 10 f6 ff ff       	jmp    80106223 <alltraps>

80106c13 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $130
80106c15:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c1a:	e9 04 f6 ff ff       	jmp    80106223 <alltraps>

80106c1f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $131
80106c21:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c26:	e9 f8 f5 ff ff       	jmp    80106223 <alltraps>

80106c2b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $132
80106c2d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c32:	e9 ec f5 ff ff       	jmp    80106223 <alltraps>

80106c37 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $133
80106c39:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c3e:	e9 e0 f5 ff ff       	jmp    80106223 <alltraps>

80106c43 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $134
80106c45:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c4a:	e9 d4 f5 ff ff       	jmp    80106223 <alltraps>

80106c4f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $135
80106c51:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c56:	e9 c8 f5 ff ff       	jmp    80106223 <alltraps>

80106c5b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $136
80106c5d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106c62:	e9 bc f5 ff ff       	jmp    80106223 <alltraps>

80106c67 <vector137>:
.globl vector137
vector137:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $137
80106c69:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106c6e:	e9 b0 f5 ff ff       	jmp    80106223 <alltraps>

80106c73 <vector138>:
.globl vector138
vector138:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $138
80106c75:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106c7a:	e9 a4 f5 ff ff       	jmp    80106223 <alltraps>

80106c7f <vector139>:
.globl vector139
vector139:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $139
80106c81:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106c86:	e9 98 f5 ff ff       	jmp    80106223 <alltraps>

80106c8b <vector140>:
.globl vector140
vector140:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $140
80106c8d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106c92:	e9 8c f5 ff ff       	jmp    80106223 <alltraps>

80106c97 <vector141>:
.globl vector141
vector141:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $141
80106c99:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106c9e:	e9 80 f5 ff ff       	jmp    80106223 <alltraps>

80106ca3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $142
80106ca5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106caa:	e9 74 f5 ff ff       	jmp    80106223 <alltraps>

80106caf <vector143>:
.globl vector143
vector143:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $143
80106cb1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cb6:	e9 68 f5 ff ff       	jmp    80106223 <alltraps>

80106cbb <vector144>:
.globl vector144
vector144:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $144
80106cbd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106cc2:	e9 5c f5 ff ff       	jmp    80106223 <alltraps>

80106cc7 <vector145>:
.globl vector145
vector145:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $145
80106cc9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106cce:	e9 50 f5 ff ff       	jmp    80106223 <alltraps>

80106cd3 <vector146>:
.globl vector146
vector146:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $146
80106cd5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106cda:	e9 44 f5 ff ff       	jmp    80106223 <alltraps>

80106cdf <vector147>:
.globl vector147
vector147:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $147
80106ce1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ce6:	e9 38 f5 ff ff       	jmp    80106223 <alltraps>

80106ceb <vector148>:
.globl vector148
vector148:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $148
80106ced:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106cf2:	e9 2c f5 ff ff       	jmp    80106223 <alltraps>

80106cf7 <vector149>:
.globl vector149
vector149:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $149
80106cf9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106cfe:	e9 20 f5 ff ff       	jmp    80106223 <alltraps>

80106d03 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $150
80106d05:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d0a:	e9 14 f5 ff ff       	jmp    80106223 <alltraps>

80106d0f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $151
80106d11:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d16:	e9 08 f5 ff ff       	jmp    80106223 <alltraps>

80106d1b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $152
80106d1d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d22:	e9 fc f4 ff ff       	jmp    80106223 <alltraps>

80106d27 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $153
80106d29:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d2e:	e9 f0 f4 ff ff       	jmp    80106223 <alltraps>

80106d33 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $154
80106d35:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d3a:	e9 e4 f4 ff ff       	jmp    80106223 <alltraps>

80106d3f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $155
80106d41:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d46:	e9 d8 f4 ff ff       	jmp    80106223 <alltraps>

80106d4b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $156
80106d4d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d52:	e9 cc f4 ff ff       	jmp    80106223 <alltraps>

80106d57 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $157
80106d59:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d5e:	e9 c0 f4 ff ff       	jmp    80106223 <alltraps>

80106d63 <vector158>:
.globl vector158
vector158:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $158
80106d65:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106d6a:	e9 b4 f4 ff ff       	jmp    80106223 <alltraps>

80106d6f <vector159>:
.globl vector159
vector159:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $159
80106d71:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106d76:	e9 a8 f4 ff ff       	jmp    80106223 <alltraps>

80106d7b <vector160>:
.globl vector160
vector160:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $160
80106d7d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106d82:	e9 9c f4 ff ff       	jmp    80106223 <alltraps>

80106d87 <vector161>:
.globl vector161
vector161:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $161
80106d89:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106d8e:	e9 90 f4 ff ff       	jmp    80106223 <alltraps>

80106d93 <vector162>:
.globl vector162
vector162:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $162
80106d95:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106d9a:	e9 84 f4 ff ff       	jmp    80106223 <alltraps>

80106d9f <vector163>:
.globl vector163
vector163:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $163
80106da1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106da6:	e9 78 f4 ff ff       	jmp    80106223 <alltraps>

80106dab <vector164>:
.globl vector164
vector164:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $164
80106dad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106db2:	e9 6c f4 ff ff       	jmp    80106223 <alltraps>

80106db7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $165
80106db9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dbe:	e9 60 f4 ff ff       	jmp    80106223 <alltraps>

80106dc3 <vector166>:
.globl vector166
vector166:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $166
80106dc5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106dca:	e9 54 f4 ff ff       	jmp    80106223 <alltraps>

80106dcf <vector167>:
.globl vector167
vector167:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $167
80106dd1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106dd6:	e9 48 f4 ff ff       	jmp    80106223 <alltraps>

80106ddb <vector168>:
.globl vector168
vector168:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $168
80106ddd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106de2:	e9 3c f4 ff ff       	jmp    80106223 <alltraps>

80106de7 <vector169>:
.globl vector169
vector169:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $169
80106de9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106dee:	e9 30 f4 ff ff       	jmp    80106223 <alltraps>

80106df3 <vector170>:
.globl vector170
vector170:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $170
80106df5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106dfa:	e9 24 f4 ff ff       	jmp    80106223 <alltraps>

80106dff <vector171>:
.globl vector171
vector171:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $171
80106e01:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e06:	e9 18 f4 ff ff       	jmp    80106223 <alltraps>

80106e0b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $172
80106e0d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e12:	e9 0c f4 ff ff       	jmp    80106223 <alltraps>

80106e17 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $173
80106e19:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e1e:	e9 00 f4 ff ff       	jmp    80106223 <alltraps>

80106e23 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $174
80106e25:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e2a:	e9 f4 f3 ff ff       	jmp    80106223 <alltraps>

80106e2f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $175
80106e31:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e36:	e9 e8 f3 ff ff       	jmp    80106223 <alltraps>

80106e3b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $176
80106e3d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e42:	e9 dc f3 ff ff       	jmp    80106223 <alltraps>

80106e47 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $177
80106e49:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e4e:	e9 d0 f3 ff ff       	jmp    80106223 <alltraps>

80106e53 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $178
80106e55:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e5a:	e9 c4 f3 ff ff       	jmp    80106223 <alltraps>

80106e5f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $179
80106e61:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106e66:	e9 b8 f3 ff ff       	jmp    80106223 <alltraps>

80106e6b <vector180>:
.globl vector180
vector180:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $180
80106e6d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106e72:	e9 ac f3 ff ff       	jmp    80106223 <alltraps>

80106e77 <vector181>:
.globl vector181
vector181:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $181
80106e79:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106e7e:	e9 a0 f3 ff ff       	jmp    80106223 <alltraps>

80106e83 <vector182>:
.globl vector182
vector182:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $182
80106e85:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106e8a:	e9 94 f3 ff ff       	jmp    80106223 <alltraps>

80106e8f <vector183>:
.globl vector183
vector183:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $183
80106e91:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106e96:	e9 88 f3 ff ff       	jmp    80106223 <alltraps>

80106e9b <vector184>:
.globl vector184
vector184:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $184
80106e9d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ea2:	e9 7c f3 ff ff       	jmp    80106223 <alltraps>

80106ea7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $185
80106ea9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106eae:	e9 70 f3 ff ff       	jmp    80106223 <alltraps>

80106eb3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $186
80106eb5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106eba:	e9 64 f3 ff ff       	jmp    80106223 <alltraps>

80106ebf <vector187>:
.globl vector187
vector187:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $187
80106ec1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ec6:	e9 58 f3 ff ff       	jmp    80106223 <alltraps>

80106ecb <vector188>:
.globl vector188
vector188:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $188
80106ecd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106ed2:	e9 4c f3 ff ff       	jmp    80106223 <alltraps>

80106ed7 <vector189>:
.globl vector189
vector189:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $189
80106ed9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106ede:	e9 40 f3 ff ff       	jmp    80106223 <alltraps>

80106ee3 <vector190>:
.globl vector190
vector190:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $190
80106ee5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106eea:	e9 34 f3 ff ff       	jmp    80106223 <alltraps>

80106eef <vector191>:
.globl vector191
vector191:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $191
80106ef1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106ef6:	e9 28 f3 ff ff       	jmp    80106223 <alltraps>

80106efb <vector192>:
.globl vector192
vector192:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $192
80106efd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f02:	e9 1c f3 ff ff       	jmp    80106223 <alltraps>

80106f07 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $193
80106f09:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f0e:	e9 10 f3 ff ff       	jmp    80106223 <alltraps>

80106f13 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $194
80106f15:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f1a:	e9 04 f3 ff ff       	jmp    80106223 <alltraps>

80106f1f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $195
80106f21:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f26:	e9 f8 f2 ff ff       	jmp    80106223 <alltraps>

80106f2b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $196
80106f2d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f32:	e9 ec f2 ff ff       	jmp    80106223 <alltraps>

80106f37 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $197
80106f39:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f3e:	e9 e0 f2 ff ff       	jmp    80106223 <alltraps>

80106f43 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $198
80106f45:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f4a:	e9 d4 f2 ff ff       	jmp    80106223 <alltraps>

80106f4f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $199
80106f51:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f56:	e9 c8 f2 ff ff       	jmp    80106223 <alltraps>

80106f5b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $200
80106f5d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106f62:	e9 bc f2 ff ff       	jmp    80106223 <alltraps>

80106f67 <vector201>:
.globl vector201
vector201:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $201
80106f69:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106f6e:	e9 b0 f2 ff ff       	jmp    80106223 <alltraps>

80106f73 <vector202>:
.globl vector202
vector202:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $202
80106f75:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106f7a:	e9 a4 f2 ff ff       	jmp    80106223 <alltraps>

80106f7f <vector203>:
.globl vector203
vector203:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $203
80106f81:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106f86:	e9 98 f2 ff ff       	jmp    80106223 <alltraps>

80106f8b <vector204>:
.globl vector204
vector204:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $204
80106f8d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106f92:	e9 8c f2 ff ff       	jmp    80106223 <alltraps>

80106f97 <vector205>:
.globl vector205
vector205:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $205
80106f99:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106f9e:	e9 80 f2 ff ff       	jmp    80106223 <alltraps>

80106fa3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $206
80106fa5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106faa:	e9 74 f2 ff ff       	jmp    80106223 <alltraps>

80106faf <vector207>:
.globl vector207
vector207:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $207
80106fb1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106fb6:	e9 68 f2 ff ff       	jmp    80106223 <alltraps>

80106fbb <vector208>:
.globl vector208
vector208:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $208
80106fbd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106fc2:	e9 5c f2 ff ff       	jmp    80106223 <alltraps>

80106fc7 <vector209>:
.globl vector209
vector209:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $209
80106fc9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106fce:	e9 50 f2 ff ff       	jmp    80106223 <alltraps>

80106fd3 <vector210>:
.globl vector210
vector210:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $210
80106fd5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106fda:	e9 44 f2 ff ff       	jmp    80106223 <alltraps>

80106fdf <vector211>:
.globl vector211
vector211:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $211
80106fe1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106fe6:	e9 38 f2 ff ff       	jmp    80106223 <alltraps>

80106feb <vector212>:
.globl vector212
vector212:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $212
80106fed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ff2:	e9 2c f2 ff ff       	jmp    80106223 <alltraps>

80106ff7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $213
80106ff9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106ffe:	e9 20 f2 ff ff       	jmp    80106223 <alltraps>

80107003 <vector214>:
.globl vector214
vector214:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $214
80107005:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010700a:	e9 14 f2 ff ff       	jmp    80106223 <alltraps>

8010700f <vector215>:
.globl vector215
vector215:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $215
80107011:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107016:	e9 08 f2 ff ff       	jmp    80106223 <alltraps>

8010701b <vector216>:
.globl vector216
vector216:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $216
8010701d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107022:	e9 fc f1 ff ff       	jmp    80106223 <alltraps>

80107027 <vector217>:
.globl vector217
vector217:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $217
80107029:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010702e:	e9 f0 f1 ff ff       	jmp    80106223 <alltraps>

80107033 <vector218>:
.globl vector218
vector218:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $218
80107035:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010703a:	e9 e4 f1 ff ff       	jmp    80106223 <alltraps>

8010703f <vector219>:
.globl vector219
vector219:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $219
80107041:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107046:	e9 d8 f1 ff ff       	jmp    80106223 <alltraps>

8010704b <vector220>:
.globl vector220
vector220:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $220
8010704d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107052:	e9 cc f1 ff ff       	jmp    80106223 <alltraps>

80107057 <vector221>:
.globl vector221
vector221:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $221
80107059:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010705e:	e9 c0 f1 ff ff       	jmp    80106223 <alltraps>

80107063 <vector222>:
.globl vector222
vector222:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $222
80107065:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010706a:	e9 b4 f1 ff ff       	jmp    80106223 <alltraps>

8010706f <vector223>:
.globl vector223
vector223:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $223
80107071:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107076:	e9 a8 f1 ff ff       	jmp    80106223 <alltraps>

8010707b <vector224>:
.globl vector224
vector224:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $224
8010707d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107082:	e9 9c f1 ff ff       	jmp    80106223 <alltraps>

80107087 <vector225>:
.globl vector225
vector225:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $225
80107089:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010708e:	e9 90 f1 ff ff       	jmp    80106223 <alltraps>

80107093 <vector226>:
.globl vector226
vector226:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $226
80107095:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010709a:	e9 84 f1 ff ff       	jmp    80106223 <alltraps>

8010709f <vector227>:
.globl vector227
vector227:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $227
801070a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070a6:	e9 78 f1 ff ff       	jmp    80106223 <alltraps>

801070ab <vector228>:
.globl vector228
vector228:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $228
801070ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070b2:	e9 6c f1 ff ff       	jmp    80106223 <alltraps>

801070b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $229
801070b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070be:	e9 60 f1 ff ff       	jmp    80106223 <alltraps>

801070c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $230
801070c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801070ca:	e9 54 f1 ff ff       	jmp    80106223 <alltraps>

801070cf <vector231>:
.globl vector231
vector231:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $231
801070d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801070d6:	e9 48 f1 ff ff       	jmp    80106223 <alltraps>

801070db <vector232>:
.globl vector232
vector232:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $232
801070dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801070e2:	e9 3c f1 ff ff       	jmp    80106223 <alltraps>

801070e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $233
801070e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801070ee:	e9 30 f1 ff ff       	jmp    80106223 <alltraps>

801070f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $234
801070f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801070fa:	e9 24 f1 ff ff       	jmp    80106223 <alltraps>

801070ff <vector235>:
.globl vector235
vector235:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $235
80107101:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107106:	e9 18 f1 ff ff       	jmp    80106223 <alltraps>

8010710b <vector236>:
.globl vector236
vector236:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $236
8010710d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107112:	e9 0c f1 ff ff       	jmp    80106223 <alltraps>

80107117 <vector237>:
.globl vector237
vector237:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $237
80107119:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010711e:	e9 00 f1 ff ff       	jmp    80106223 <alltraps>

80107123 <vector238>:
.globl vector238
vector238:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $238
80107125:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010712a:	e9 f4 f0 ff ff       	jmp    80106223 <alltraps>

8010712f <vector239>:
.globl vector239
vector239:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $239
80107131:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107136:	e9 e8 f0 ff ff       	jmp    80106223 <alltraps>

8010713b <vector240>:
.globl vector240
vector240:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $240
8010713d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107142:	e9 dc f0 ff ff       	jmp    80106223 <alltraps>

80107147 <vector241>:
.globl vector241
vector241:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $241
80107149:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010714e:	e9 d0 f0 ff ff       	jmp    80106223 <alltraps>

80107153 <vector242>:
.globl vector242
vector242:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $242
80107155:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010715a:	e9 c4 f0 ff ff       	jmp    80106223 <alltraps>

8010715f <vector243>:
.globl vector243
vector243:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $243
80107161:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107166:	e9 b8 f0 ff ff       	jmp    80106223 <alltraps>

8010716b <vector244>:
.globl vector244
vector244:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $244
8010716d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107172:	e9 ac f0 ff ff       	jmp    80106223 <alltraps>

80107177 <vector245>:
.globl vector245
vector245:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $245
80107179:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010717e:	e9 a0 f0 ff ff       	jmp    80106223 <alltraps>

80107183 <vector246>:
.globl vector246
vector246:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $246
80107185:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010718a:	e9 94 f0 ff ff       	jmp    80106223 <alltraps>

8010718f <vector247>:
.globl vector247
vector247:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $247
80107191:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107196:	e9 88 f0 ff ff       	jmp    80106223 <alltraps>

8010719b <vector248>:
.globl vector248
vector248:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $248
8010719d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071a2:	e9 7c f0 ff ff       	jmp    80106223 <alltraps>

801071a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $249
801071a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071ae:	e9 70 f0 ff ff       	jmp    80106223 <alltraps>

801071b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $250
801071b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071ba:	e9 64 f0 ff ff       	jmp    80106223 <alltraps>

801071bf <vector251>:
.globl vector251
vector251:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $251
801071c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801071c6:	e9 58 f0 ff ff       	jmp    80106223 <alltraps>

801071cb <vector252>:
.globl vector252
vector252:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $252
801071cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801071d2:	e9 4c f0 ff ff       	jmp    80106223 <alltraps>

801071d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $253
801071d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801071de:	e9 40 f0 ff ff       	jmp    80106223 <alltraps>

801071e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $254
801071e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801071ea:	e9 34 f0 ff ff       	jmp    80106223 <alltraps>

801071ef <vector255>:
.globl vector255
vector255:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $255
801071f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801071f6:	e9 28 f0 ff ff       	jmp    80106223 <alltraps>
801071fb:	66 90                	xchg   %ax,%ax
801071fd:	66 90                	xchg   %ax,%ax
801071ff:	90                   	nop

80107200 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107207:	c1 ea 16             	shr    $0x16,%edx
{
8010720a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010720b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010720e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107211:	8b 1f                	mov    (%edi),%ebx
80107213:	f6 c3 01             	test   $0x1,%bl
80107216:	74 28                	je     80107240 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107218:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010721e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107224:	89 f0                	mov    %esi,%eax
}
80107226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107229:	c1 e8 0a             	shr    $0xa,%eax
8010722c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107231:	01 d8                	add    %ebx,%eax
}
80107233:	5b                   	pop    %ebx
80107234:	5e                   	pop    %esi
80107235:	5f                   	pop    %edi
80107236:	5d                   	pop    %ebp
80107237:	c3                   	ret    
80107238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010723f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107240:	85 c9                	test   %ecx,%ecx
80107242:	74 2c                	je     80107270 <walkpgdir+0x70>
80107244:	e8 e7 b3 ff ff       	call   80102630 <kalloc>
80107249:	89 c3                	mov    %eax,%ebx
8010724b:	85 c0                	test   %eax,%eax
8010724d:	74 21                	je     80107270 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010724f:	83 ec 04             	sub    $0x4,%esp
80107252:	68 00 10 00 00       	push   $0x1000
80107257:	6a 00                	push   $0x0
80107259:	50                   	push   %eax
8010725a:	e8 c1 dc ff ff       	call   80104f20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010725f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107265:	83 c4 10             	add    $0x10,%esp
80107268:	83 c8 07             	or     $0x7,%eax
8010726b:	89 07                	mov    %eax,(%edi)
8010726d:	eb b5                	jmp    80107224 <walkpgdir+0x24>
8010726f:	90                   	nop
}
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
8010727a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107280 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	57                   	push   %edi
80107284:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107286:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010728a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010728b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107290:	89 d6                	mov    %edx,%esi
{
80107292:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107293:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107299:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010729c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010729f:	8b 45 08             	mov    0x8(%ebp),%eax
801072a2:	29 f0                	sub    %esi,%eax
801072a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072a7:	eb 1f                	jmp    801072c8 <mappages+0x48>
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072b0:	f6 00 01             	testb  $0x1,(%eax)
801072b3:	75 45                	jne    801072fa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072b5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072b8:	83 cb 01             	or     $0x1,%ebx
801072bb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072bd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801072c0:	74 2e                	je     801072f0 <mappages+0x70>
      break;
    a += PGSIZE;
801072c2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801072c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801072cb:	b9 01 00 00 00       	mov    $0x1,%ecx
801072d0:	89 f2                	mov    %esi,%edx
801072d2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801072d5:	89 f8                	mov    %edi,%eax
801072d7:	e8 24 ff ff ff       	call   80107200 <walkpgdir>
801072dc:	85 c0                	test   %eax,%eax
801072de:	75 d0                	jne    801072b0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801072e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801072e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072e8:	5b                   	pop    %ebx
801072e9:	5e                   	pop    %esi
801072ea:	5f                   	pop    %edi
801072eb:	5d                   	pop    %ebp
801072ec:	c3                   	ret    
801072ed:	8d 76 00             	lea    0x0(%esi),%esi
801072f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801072f3:	31 c0                	xor    %eax,%eax
}
801072f5:	5b                   	pop    %ebx
801072f6:	5e                   	pop    %esi
801072f7:	5f                   	pop    %edi
801072f8:	5d                   	pop    %ebp
801072f9:	c3                   	ret    
      panic("remap");
801072fa:	83 ec 0c             	sub    $0xc,%esp
801072fd:	68 44 86 10 80       	push   $0x80108644
80107302:	e8 89 90 ff ff       	call   80100390 <panic>
80107307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010730e:	66 90                	xchg   %ax,%ax

80107310 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	57                   	push   %edi
80107314:	56                   	push   %esi
80107315:	89 c6                	mov    %eax,%esi
80107317:	53                   	push   %ebx
80107318:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010731a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107320:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010732c:	39 da                	cmp    %ebx,%edx
8010732e:	73 5b                	jae    8010738b <deallocuvm.part.0+0x7b>
80107330:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107333:	89 d7                	mov    %edx,%edi
80107335:	eb 14                	jmp    8010734b <deallocuvm.part.0+0x3b>
80107337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733e:	66 90                	xchg   %ax,%ax
80107340:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107346:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107349:	76 40                	jbe    8010738b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010734b:	31 c9                	xor    %ecx,%ecx
8010734d:	89 fa                	mov    %edi,%edx
8010734f:	89 f0                	mov    %esi,%eax
80107351:	e8 aa fe ff ff       	call   80107200 <walkpgdir>
80107356:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107358:	85 c0                	test   %eax,%eax
8010735a:	74 44                	je     801073a0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010735c:	8b 00                	mov    (%eax),%eax
8010735e:	a8 01                	test   $0x1,%al
80107360:	74 de                	je     80107340 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107362:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107367:	74 47                	je     801073b0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107369:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010736c:	05 00 00 00 80       	add    $0x80000000,%eax
80107371:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107377:	50                   	push   %eax
80107378:	e8 f3 b0 ff ff       	call   80102470 <kfree>
      *pte = 0;
8010737d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107383:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107386:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107389:	77 c0                	ja     8010734b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010738b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010738e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107391:	5b                   	pop    %ebx
80107392:	5e                   	pop    %esi
80107393:	5f                   	pop    %edi
80107394:	5d                   	pop    %ebp
80107395:	c3                   	ret    
80107396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010739d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073a0:	89 fa                	mov    %edi,%edx
801073a2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801073a8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801073ae:	eb 96                	jmp    80107346 <deallocuvm.part.0+0x36>
        panic("kfree");
801073b0:	83 ec 0c             	sub    $0xc,%esp
801073b3:	68 86 7e 10 80       	push   $0x80107e86
801073b8:	e8 d3 8f ff ff       	call   80100390 <panic>
801073bd:	8d 76 00             	lea    0x0(%esi),%esi

801073c0 <seginit>:
{
801073c0:	f3 0f 1e fb          	endbr32 
801073c4:	55                   	push   %ebp
801073c5:	89 e5                	mov    %esp,%ebp
801073c7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801073ca:	e8 21 c6 ff ff       	call   801039f0 <cpuid>
  pd[0] = size-1;
801073cf:	ba 2f 00 00 00       	mov    $0x2f,%edx
801073d4:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801073da:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801073de:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
801073e5:	ff 00 00 
801073e8:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
801073ef:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801073f2:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
801073f9:	ff 00 00 
801073fc:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80107403:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107406:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
8010740d:	ff 00 00 
80107410:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80107417:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010741a:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80107421:	ff 00 00 
80107424:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
8010742b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010742e:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80107433:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107437:	c1 e8 10             	shr    $0x10,%eax
8010743a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010743e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107441:	0f 01 10             	lgdtl  (%eax)
}
80107444:	c9                   	leave  
80107445:	c3                   	ret    
80107446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010744d:	8d 76 00             	lea    0x0(%esi),%esi

80107450 <switchkvm>:
{
80107450:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107454:	a1 44 6b 11 80       	mov    0x80116b44,%eax
80107459:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010745e:	0f 22 d8             	mov    %eax,%cr3
}
80107461:	c3                   	ret    
80107462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107470 <switchuvm>:
{
80107470:	f3 0f 1e fb          	endbr32 
80107474:	55                   	push   %ebp
80107475:	89 e5                	mov    %esp,%ebp
80107477:	57                   	push   %edi
80107478:	56                   	push   %esi
80107479:	53                   	push   %ebx
8010747a:	83 ec 1c             	sub    $0x1c,%esp
8010747d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107480:	85 f6                	test   %esi,%esi
80107482:	0f 84 cb 00 00 00    	je     80107553 <switchuvm+0xe3>
  if(p->kstack == 0)
80107488:	8b 46 08             	mov    0x8(%esi),%eax
8010748b:	85 c0                	test   %eax,%eax
8010748d:	0f 84 da 00 00 00    	je     8010756d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107493:	8b 46 04             	mov    0x4(%esi),%eax
80107496:	85 c0                	test   %eax,%eax
80107498:	0f 84 c2 00 00 00    	je     80107560 <switchuvm+0xf0>
  pushcli();
8010749e:	e8 6d d8 ff ff       	call   80104d10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074a3:	e8 d8 c4 ff ff       	call   80103980 <mycpu>
801074a8:	89 c3                	mov    %eax,%ebx
801074aa:	e8 d1 c4 ff ff       	call   80103980 <mycpu>
801074af:	89 c7                	mov    %eax,%edi
801074b1:	e8 ca c4 ff ff       	call   80103980 <mycpu>
801074b6:	83 c7 08             	add    $0x8,%edi
801074b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074bc:	e8 bf c4 ff ff       	call   80103980 <mycpu>
801074c1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801074c4:	ba 67 00 00 00       	mov    $0x67,%edx
801074c9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801074d0:	83 c0 08             	add    $0x8,%eax
801074d3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801074da:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074df:	83 c1 08             	add    $0x8,%ecx
801074e2:	c1 e8 18             	shr    $0x18,%eax
801074e5:	c1 e9 10             	shr    $0x10,%ecx
801074e8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801074ee:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801074f4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801074f9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107500:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107505:	e8 76 c4 ff ff       	call   80103980 <mycpu>
8010750a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107511:	e8 6a c4 ff ff       	call   80103980 <mycpu>
80107516:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010751a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010751d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107523:	e8 58 c4 ff ff       	call   80103980 <mycpu>
80107528:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010752b:	e8 50 c4 ff ff       	call   80103980 <mycpu>
80107530:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107534:	b8 28 00 00 00       	mov    $0x28,%eax
80107539:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010753c:	8b 46 04             	mov    0x4(%esi),%eax
8010753f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107544:	0f 22 d8             	mov    %eax,%cr3
}
80107547:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010754a:	5b                   	pop    %ebx
8010754b:	5e                   	pop    %esi
8010754c:	5f                   	pop    %edi
8010754d:	5d                   	pop    %ebp
  popcli();
8010754e:	e9 0d d8 ff ff       	jmp    80104d60 <popcli>
    panic("switchuvm: no process");
80107553:	83 ec 0c             	sub    $0xc,%esp
80107556:	68 4a 86 10 80       	push   $0x8010864a
8010755b:	e8 30 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107560:	83 ec 0c             	sub    $0xc,%esp
80107563:	68 75 86 10 80       	push   $0x80108675
80107568:	e8 23 8e ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010756d:	83 ec 0c             	sub    $0xc,%esp
80107570:	68 60 86 10 80       	push   $0x80108660
80107575:	e8 16 8e ff ff       	call   80100390 <panic>
8010757a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107580 <inituvm>:
{
80107580:	f3 0f 1e fb          	endbr32 
80107584:	55                   	push   %ebp
80107585:	89 e5                	mov    %esp,%ebp
80107587:	57                   	push   %edi
80107588:	56                   	push   %esi
80107589:	53                   	push   %ebx
8010758a:	83 ec 1c             	sub    $0x1c,%esp
8010758d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107590:	8b 75 10             	mov    0x10(%ebp),%esi
80107593:	8b 7d 08             	mov    0x8(%ebp),%edi
80107596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107599:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010759f:	77 4b                	ja     801075ec <inituvm+0x6c>
  mem = kalloc();
801075a1:	e8 8a b0 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
801075a6:	83 ec 04             	sub    $0x4,%esp
801075a9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075ae:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075b0:	6a 00                	push   $0x0
801075b2:	50                   	push   %eax
801075b3:	e8 68 d9 ff ff       	call   80104f20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075b8:	58                   	pop    %eax
801075b9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075bf:	5a                   	pop    %edx
801075c0:	6a 06                	push   $0x6
801075c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075c7:	31 d2                	xor    %edx,%edx
801075c9:	50                   	push   %eax
801075ca:	89 f8                	mov    %edi,%eax
801075cc:	e8 af fc ff ff       	call   80107280 <mappages>
  memmove(mem, init, sz);
801075d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d4:	89 75 10             	mov    %esi,0x10(%ebp)
801075d7:	83 c4 10             	add    $0x10,%esp
801075da:	89 5d 08             	mov    %ebx,0x8(%ebp)
801075dd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801075e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e3:	5b                   	pop    %ebx
801075e4:	5e                   	pop    %esi
801075e5:	5f                   	pop    %edi
801075e6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801075e7:	e9 d4 d9 ff ff       	jmp    80104fc0 <memmove>
    panic("inituvm: more than a page");
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	68 89 86 10 80       	push   $0x80108689
801075f4:	e8 97 8d ff ff       	call   80100390 <panic>
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107600 <loaduvm>:
{
80107600:	f3 0f 1e fb          	endbr32 
80107604:	55                   	push   %ebp
80107605:	89 e5                	mov    %esp,%ebp
80107607:	57                   	push   %edi
80107608:	56                   	push   %esi
80107609:	53                   	push   %ebx
8010760a:	83 ec 1c             	sub    $0x1c,%esp
8010760d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107610:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107613:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107618:	0f 85 99 00 00 00    	jne    801076b7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010761e:	01 f0                	add    %esi,%eax
80107620:	89 f3                	mov    %esi,%ebx
80107622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107625:	8b 45 14             	mov    0x14(%ebp),%eax
80107628:	01 f0                	add    %esi,%eax
8010762a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010762d:	85 f6                	test   %esi,%esi
8010762f:	75 15                	jne    80107646 <loaduvm+0x46>
80107631:	eb 6d                	jmp    801076a0 <loaduvm+0xa0>
80107633:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107637:	90                   	nop
80107638:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010763e:	89 f0                	mov    %esi,%eax
80107640:	29 d8                	sub    %ebx,%eax
80107642:	39 c6                	cmp    %eax,%esi
80107644:	76 5a                	jbe    801076a0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107646:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107649:	8b 45 08             	mov    0x8(%ebp),%eax
8010764c:	31 c9                	xor    %ecx,%ecx
8010764e:	29 da                	sub    %ebx,%edx
80107650:	e8 ab fb ff ff       	call   80107200 <walkpgdir>
80107655:	85 c0                	test   %eax,%eax
80107657:	74 51                	je     801076aa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107659:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010765b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010765e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107663:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107668:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010766e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107671:	29 d9                	sub    %ebx,%ecx
80107673:	05 00 00 00 80       	add    $0x80000000,%eax
80107678:	57                   	push   %edi
80107679:	51                   	push   %ecx
8010767a:	50                   	push   %eax
8010767b:	ff 75 10             	pushl  0x10(%ebp)
8010767e:	e8 dd a3 ff ff       	call   80101a60 <readi>
80107683:	83 c4 10             	add    $0x10,%esp
80107686:	39 f8                	cmp    %edi,%eax
80107688:	74 ae                	je     80107638 <loaduvm+0x38>
}
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010768d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107692:	5b                   	pop    %ebx
80107693:	5e                   	pop    %esi
80107694:	5f                   	pop    %edi
80107695:	5d                   	pop    %ebp
80107696:	c3                   	ret    
80107697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010769e:	66 90                	xchg   %ax,%ax
801076a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076a3:	31 c0                	xor    %eax,%eax
}
801076a5:	5b                   	pop    %ebx
801076a6:	5e                   	pop    %esi
801076a7:	5f                   	pop    %edi
801076a8:	5d                   	pop    %ebp
801076a9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076aa:	83 ec 0c             	sub    $0xc,%esp
801076ad:	68 a3 86 10 80       	push   $0x801086a3
801076b2:	e8 d9 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076b7:	83 ec 0c             	sub    $0xc,%esp
801076ba:	68 44 87 10 80       	push   $0x80108744
801076bf:	e8 cc 8c ff ff       	call   80100390 <panic>
801076c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop

801076d0 <allocuvm>:
{
801076d0:	f3 0f 1e fb          	endbr32 
801076d4:	55                   	push   %ebp
801076d5:	89 e5                	mov    %esp,%ebp
801076d7:	57                   	push   %edi
801076d8:	56                   	push   %esi
801076d9:	53                   	push   %ebx
801076da:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801076dd:	8b 45 10             	mov    0x10(%ebp),%eax
{
801076e0:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801076e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801076e6:	85 c0                	test   %eax,%eax
801076e8:	0f 88 b2 00 00 00    	js     801077a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801076ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801076f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801076f4:	0f 82 96 00 00 00    	jb     80107790 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801076fa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107700:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107706:	39 75 10             	cmp    %esi,0x10(%ebp)
80107709:	77 40                	ja     8010774b <allocuvm+0x7b>
8010770b:	e9 83 00 00 00       	jmp    80107793 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107710:	83 ec 04             	sub    $0x4,%esp
80107713:	68 00 10 00 00       	push   $0x1000
80107718:	6a 00                	push   $0x0
8010771a:	50                   	push   %eax
8010771b:	e8 00 d8 ff ff       	call   80104f20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107720:	58                   	pop    %eax
80107721:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107727:	5a                   	pop    %edx
80107728:	6a 06                	push   $0x6
8010772a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010772f:	89 f2                	mov    %esi,%edx
80107731:	50                   	push   %eax
80107732:	89 f8                	mov    %edi,%eax
80107734:	e8 47 fb ff ff       	call   80107280 <mappages>
80107739:	83 c4 10             	add    $0x10,%esp
8010773c:	85 c0                	test   %eax,%eax
8010773e:	78 78                	js     801077b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107740:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107746:	39 75 10             	cmp    %esi,0x10(%ebp)
80107749:	76 48                	jbe    80107793 <allocuvm+0xc3>
    mem = kalloc();
8010774b:	e8 e0 ae ff ff       	call   80102630 <kalloc>
80107750:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107752:	85 c0                	test   %eax,%eax
80107754:	75 ba                	jne    80107710 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107756:	83 ec 0c             	sub    $0xc,%esp
80107759:	68 c1 86 10 80       	push   $0x801086c1
8010775e:	e8 4d 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107763:	8b 45 0c             	mov    0xc(%ebp),%eax
80107766:	83 c4 10             	add    $0x10,%esp
80107769:	39 45 10             	cmp    %eax,0x10(%ebp)
8010776c:	74 32                	je     801077a0 <allocuvm+0xd0>
8010776e:	8b 55 10             	mov    0x10(%ebp),%edx
80107771:	89 c1                	mov    %eax,%ecx
80107773:	89 f8                	mov    %edi,%eax
80107775:	e8 96 fb ff ff       	call   80107310 <deallocuvm.part.0>
      return 0;
8010777a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107781:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107784:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107787:	5b                   	pop    %ebx
80107788:	5e                   	pop    %esi
80107789:	5f                   	pop    %edi
8010778a:	5d                   	pop    %ebp
8010778b:	c3                   	ret    
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107796:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107799:	5b                   	pop    %ebx
8010779a:	5e                   	pop    %esi
8010779b:	5f                   	pop    %edi
8010779c:	5d                   	pop    %ebp
8010779d:	c3                   	ret    
8010779e:	66 90                	xchg   %ax,%ax
    return 0;
801077a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ad:	5b                   	pop    %ebx
801077ae:	5e                   	pop    %esi
801077af:	5f                   	pop    %edi
801077b0:	5d                   	pop    %ebp
801077b1:	c3                   	ret    
801077b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077b8:	83 ec 0c             	sub    $0xc,%esp
801077bb:	68 d9 86 10 80       	push   $0x801086d9
801077c0:	e8 eb 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801077c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801077c8:	83 c4 10             	add    $0x10,%esp
801077cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ce:	74 0c                	je     801077dc <allocuvm+0x10c>
801077d0:	8b 55 10             	mov    0x10(%ebp),%edx
801077d3:	89 c1                	mov    %eax,%ecx
801077d5:	89 f8                	mov    %edi,%eax
801077d7:	e8 34 fb ff ff       	call   80107310 <deallocuvm.part.0>
      kfree(mem);
801077dc:	83 ec 0c             	sub    $0xc,%esp
801077df:	53                   	push   %ebx
801077e0:	e8 8b ac ff ff       	call   80102470 <kfree>
      return 0;
801077e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801077ec:	83 c4 10             	add    $0x10,%esp
}
801077ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077f5:	5b                   	pop    %ebx
801077f6:	5e                   	pop    %esi
801077f7:	5f                   	pop    %edi
801077f8:	5d                   	pop    %ebp
801077f9:	c3                   	ret    
801077fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107800 <deallocuvm>:
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	8b 55 0c             	mov    0xc(%ebp),%edx
8010780a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010780d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107810:	39 d1                	cmp    %edx,%ecx
80107812:	73 0c                	jae    80107820 <deallocuvm+0x20>
}
80107814:	5d                   	pop    %ebp
80107815:	e9 f6 fa ff ff       	jmp    80107310 <deallocuvm.part.0>
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107820:	89 d0                	mov    %edx,%eax
80107822:	5d                   	pop    %ebp
80107823:	c3                   	ret    
80107824:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010782b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010782f:	90                   	nop

80107830 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107830:	f3 0f 1e fb          	endbr32 
80107834:	55                   	push   %ebp
80107835:	89 e5                	mov    %esp,%ebp
80107837:	57                   	push   %edi
80107838:	56                   	push   %esi
80107839:	53                   	push   %ebx
8010783a:	83 ec 0c             	sub    $0xc,%esp
8010783d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107840:	85 f6                	test   %esi,%esi
80107842:	74 55                	je     80107899 <freevm+0x69>
  if(newsz >= oldsz)
80107844:	31 c9                	xor    %ecx,%ecx
80107846:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010784b:	89 f0                	mov    %esi,%eax
8010784d:	89 f3                	mov    %esi,%ebx
8010784f:	e8 bc fa ff ff       	call   80107310 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107854:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010785a:	eb 0b                	jmp    80107867 <freevm+0x37>
8010785c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107860:	83 c3 04             	add    $0x4,%ebx
80107863:	39 df                	cmp    %ebx,%edi
80107865:	74 23                	je     8010788a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107867:	8b 03                	mov    (%ebx),%eax
80107869:	a8 01                	test   $0x1,%al
8010786b:	74 f3                	je     80107860 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010786d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107872:	83 ec 0c             	sub    $0xc,%esp
80107875:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107878:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010787d:	50                   	push   %eax
8010787e:	e8 ed ab ff ff       	call   80102470 <kfree>
80107883:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107886:	39 df                	cmp    %ebx,%edi
80107888:	75 dd                	jne    80107867 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010788a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010788d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107890:	5b                   	pop    %ebx
80107891:	5e                   	pop    %esi
80107892:	5f                   	pop    %edi
80107893:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107894:	e9 d7 ab ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
80107899:	83 ec 0c             	sub    $0xc,%esp
8010789c:	68 f5 86 10 80       	push   $0x801086f5
801078a1:	e8 ea 8a ff ff       	call   80100390 <panic>
801078a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ad:	8d 76 00             	lea    0x0(%esi),%esi

801078b0 <setupkvm>:
{
801078b0:	f3 0f 1e fb          	endbr32 
801078b4:	55                   	push   %ebp
801078b5:	89 e5                	mov    %esp,%ebp
801078b7:	56                   	push   %esi
801078b8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078b9:	e8 72 ad ff ff       	call   80102630 <kalloc>
801078be:	89 c6                	mov    %eax,%esi
801078c0:	85 c0                	test   %eax,%eax
801078c2:	74 42                	je     80107906 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801078c4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078c7:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801078cc:	68 00 10 00 00       	push   $0x1000
801078d1:	6a 00                	push   $0x0
801078d3:	50                   	push   %eax
801078d4:	e8 47 d6 ff ff       	call   80104f20 <memset>
801078d9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801078dc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078df:	83 ec 08             	sub    $0x8,%esp
801078e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078e5:	ff 73 0c             	pushl  0xc(%ebx)
801078e8:	8b 13                	mov    (%ebx),%edx
801078ea:	50                   	push   %eax
801078eb:	29 c1                	sub    %eax,%ecx
801078ed:	89 f0                	mov    %esi,%eax
801078ef:	e8 8c f9 ff ff       	call   80107280 <mappages>
801078f4:	83 c4 10             	add    $0x10,%esp
801078f7:	85 c0                	test   %eax,%eax
801078f9:	78 15                	js     80107910 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078fb:	83 c3 10             	add    $0x10,%ebx
801078fe:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107904:	75 d6                	jne    801078dc <setupkvm+0x2c>
}
80107906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107909:	89 f0                	mov    %esi,%eax
8010790b:	5b                   	pop    %ebx
8010790c:	5e                   	pop    %esi
8010790d:	5d                   	pop    %ebp
8010790e:	c3                   	ret    
8010790f:	90                   	nop
      freevm(pgdir);
80107910:	83 ec 0c             	sub    $0xc,%esp
80107913:	56                   	push   %esi
      return 0;
80107914:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107916:	e8 15 ff ff ff       	call   80107830 <freevm>
      return 0;
8010791b:	83 c4 10             	add    $0x10,%esp
}
8010791e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107921:	89 f0                	mov    %esi,%eax
80107923:	5b                   	pop    %ebx
80107924:	5e                   	pop    %esi
80107925:	5d                   	pop    %ebp
80107926:	c3                   	ret    
80107927:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010792e:	66 90                	xchg   %ax,%ax

80107930 <kvmalloc>:
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010793a:	e8 71 ff ff ff       	call   801078b0 <setupkvm>
8010793f:	a3 44 6b 11 80       	mov    %eax,0x80116b44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107944:	05 00 00 00 80       	add    $0x80000000,%eax
80107949:	0f 22 d8             	mov    %eax,%cr3
}
8010794c:	c9                   	leave  
8010794d:	c3                   	ret    
8010794e:	66 90                	xchg   %ax,%ax

80107950 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107955:	31 c9                	xor    %ecx,%ecx
{
80107957:	89 e5                	mov    %esp,%ebp
80107959:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010795c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010795f:	8b 45 08             	mov    0x8(%ebp),%eax
80107962:	e8 99 f8 ff ff       	call   80107200 <walkpgdir>
  if(pte == 0)
80107967:	85 c0                	test   %eax,%eax
80107969:	74 05                	je     80107970 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010796b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010796e:	c9                   	leave  
8010796f:	c3                   	ret    
    panic("clearpteu");
80107970:	83 ec 0c             	sub    $0xc,%esp
80107973:	68 06 87 10 80       	push   $0x80108706
80107978:	e8 13 8a ff ff       	call   80100390 <panic>
8010797d:	8d 76 00             	lea    0x0(%esi),%esi

80107980 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107980:	f3 0f 1e fb          	endbr32 
80107984:	55                   	push   %ebp
80107985:	89 e5                	mov    %esp,%ebp
80107987:	57                   	push   %edi
80107988:	56                   	push   %esi
80107989:	53                   	push   %ebx
8010798a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010798d:	e8 1e ff ff ff       	call   801078b0 <setupkvm>
80107992:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107995:	85 c0                	test   %eax,%eax
80107997:	0f 84 9b 00 00 00    	je     80107a38 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010799d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079a0:	85 c9                	test   %ecx,%ecx
801079a2:	0f 84 90 00 00 00    	je     80107a38 <copyuvm+0xb8>
801079a8:	31 f6                	xor    %esi,%esi
801079aa:	eb 46                	jmp    801079f2 <copyuvm+0x72>
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079b0:	83 ec 04             	sub    $0x4,%esp
801079b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079b9:	68 00 10 00 00       	push   $0x1000
801079be:	57                   	push   %edi
801079bf:	50                   	push   %eax
801079c0:	e8 fb d5 ff ff       	call   80104fc0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801079c5:	58                   	pop    %eax
801079c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801079cc:	5a                   	pop    %edx
801079cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801079d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079d5:	89 f2                	mov    %esi,%edx
801079d7:	50                   	push   %eax
801079d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079db:	e8 a0 f8 ff ff       	call   80107280 <mappages>
801079e0:	83 c4 10             	add    $0x10,%esp
801079e3:	85 c0                	test   %eax,%eax
801079e5:	78 61                	js     80107a48 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801079e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801079ed:	39 75 0c             	cmp    %esi,0xc(%ebp)
801079f0:	76 46                	jbe    80107a38 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801079f2:	8b 45 08             	mov    0x8(%ebp),%eax
801079f5:	31 c9                	xor    %ecx,%ecx
801079f7:	89 f2                	mov    %esi,%edx
801079f9:	e8 02 f8 ff ff       	call   80107200 <walkpgdir>
801079fe:	85 c0                	test   %eax,%eax
80107a00:	74 61                	je     80107a63 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107a02:	8b 00                	mov    (%eax),%eax
80107a04:	a8 01                	test   $0x1,%al
80107a06:	74 4e                	je     80107a56 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107a08:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a0a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a12:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a18:	e8 13 ac ff ff       	call   80102630 <kalloc>
80107a1d:	89 c3                	mov    %eax,%ebx
80107a1f:	85 c0                	test   %eax,%eax
80107a21:	75 8d                	jne    801079b0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107a23:	83 ec 0c             	sub    $0xc,%esp
80107a26:	ff 75 e0             	pushl  -0x20(%ebp)
80107a29:	e8 02 fe ff ff       	call   80107830 <freevm>
  return 0;
80107a2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a35:	83 c4 10             	add    $0x10,%esp
}
80107a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a3e:	5b                   	pop    %ebx
80107a3f:	5e                   	pop    %esi
80107a40:	5f                   	pop    %edi
80107a41:	5d                   	pop    %ebp
80107a42:	c3                   	ret    
80107a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a47:	90                   	nop
      kfree(mem);
80107a48:	83 ec 0c             	sub    $0xc,%esp
80107a4b:	53                   	push   %ebx
80107a4c:	e8 1f aa ff ff       	call   80102470 <kfree>
      goto bad;
80107a51:	83 c4 10             	add    $0x10,%esp
80107a54:	eb cd                	jmp    80107a23 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a56:	83 ec 0c             	sub    $0xc,%esp
80107a59:	68 2a 87 10 80       	push   $0x8010872a
80107a5e:	e8 2d 89 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107a63:	83 ec 0c             	sub    $0xc,%esp
80107a66:	68 10 87 10 80       	push   $0x80108710
80107a6b:	e8 20 89 ff ff       	call   80100390 <panic>

80107a70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a70:	f3 0f 1e fb          	endbr32 
80107a74:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a75:	31 c9                	xor    %ecx,%ecx
{
80107a77:	89 e5                	mov    %esp,%ebp
80107a79:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a7f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a82:	e8 79 f7 ff ff       	call   80107200 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a87:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107a89:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107a8a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107a91:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107a94:	05 00 00 00 80       	add    $0x80000000,%eax
80107a99:	83 fa 05             	cmp    $0x5,%edx
80107a9c:	ba 00 00 00 00       	mov    $0x0,%edx
80107aa1:	0f 45 c2             	cmovne %edx,%eax
}
80107aa4:	c3                   	ret    
80107aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ab0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ab0:	f3 0f 1e fb          	endbr32 
80107ab4:	55                   	push   %ebp
80107ab5:	89 e5                	mov    %esp,%ebp
80107ab7:	57                   	push   %edi
80107ab8:	56                   	push   %esi
80107ab9:	53                   	push   %ebx
80107aba:	83 ec 0c             	sub    $0xc,%esp
80107abd:	8b 75 14             	mov    0x14(%ebp),%esi
80107ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ac3:	85 f6                	test   %esi,%esi
80107ac5:	75 3c                	jne    80107b03 <copyout+0x53>
80107ac7:	eb 67                	jmp    80107b30 <copyout+0x80>
80107ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ad3:	89 fb                	mov    %edi,%ebx
80107ad5:	29 d3                	sub    %edx,%ebx
80107ad7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107add:	39 f3                	cmp    %esi,%ebx
80107adf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ae2:	29 fa                	sub    %edi,%edx
80107ae4:	83 ec 04             	sub    $0x4,%esp
80107ae7:	01 c2                	add    %eax,%edx
80107ae9:	53                   	push   %ebx
80107aea:	ff 75 10             	pushl  0x10(%ebp)
80107aed:	52                   	push   %edx
80107aee:	e8 cd d4 ff ff       	call   80104fc0 <memmove>
    len -= n;
    buf += n;
80107af3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107af6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107afc:	83 c4 10             	add    $0x10,%esp
80107aff:	29 de                	sub    %ebx,%esi
80107b01:	74 2d                	je     80107b30 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b03:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b05:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b08:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b0b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b11:	57                   	push   %edi
80107b12:	ff 75 08             	pushl  0x8(%ebp)
80107b15:	e8 56 ff ff ff       	call   80107a70 <uva2ka>
    if(pa0 == 0)
80107b1a:	83 c4 10             	add    $0x10,%esp
80107b1d:	85 c0                	test   %eax,%eax
80107b1f:	75 af                	jne    80107ad0 <copyout+0x20>
  }
  return 0;
}
80107b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b29:	5b                   	pop    %ebx
80107b2a:	5e                   	pop    %esi
80107b2b:	5f                   	pop    %edi
80107b2c:	5d                   	pop    %ebp
80107b2d:	c3                   	ret    
80107b2e:	66 90                	xchg   %ax,%ax
80107b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b33:	31 c0                	xor    %eax,%eax
}
80107b35:	5b                   	pop    %ebx
80107b36:	5e                   	pop    %esi
80107b37:	5f                   	pop    %edi
80107b38:	5d                   	pop    %ebp
80107b39:	c3                   	ret    
80107b3a:	66 90                	xchg   %ax,%ax
80107b3c:	66 90                	xchg   %ax,%ax
80107b3e:	66 90                	xchg   %ax,%ax

80107b40 <myfunction>:
#include "types.h"
#include "defs.h"

int myfunction(char *str){
80107b40:	f3 0f 1e fb          	endbr32 
80107b44:	55                   	push   %ebp
80107b45:	89 e5                	mov    %esp,%ebp
80107b47:	83 ec 10             	sub    $0x10,%esp
	cprintf("%s\n", str);
80107b4a:	ff 75 08             	pushl  0x8(%ebp)
80107b4d:	68 67 87 10 80       	push   $0x80108767
80107b52:	e8 59 8b ff ff       	call   801006b0 <cprintf>
	return 0xABCDABCD;
}
80107b57:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80107b5c:	c9                   	leave  
80107b5d:	c3                   	ret    
80107b5e:	66 90                	xchg   %ax,%ax

80107b60 <sys_myfunction>:

int sys_myfunction(void){
80107b60:	f3 0f 1e fb          	endbr32 
80107b64:	55                   	push   %ebp
80107b65:	89 e5                	mov    %esp,%ebp
80107b67:	83 ec 20             	sub    $0x20,%esp
	char *str;
	if(argstr(0, &str)<0)
80107b6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107b6d:	50                   	push   %eax
80107b6e:	6a 00                	push   $0x0
80107b70:	e8 3b d7 ff ff       	call   801052b0 <argstr>
80107b75:	83 c4 10             	add    $0x10,%esp
80107b78:	89 c2                	mov    %eax,%edx
80107b7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b7f:	85 d2                	test   %edx,%edx
80107b81:	78 18                	js     80107b9b <sys_myfunction+0x3b>
	cprintf("%s\n", str);
80107b83:	83 ec 08             	sub    $0x8,%esp
80107b86:	ff 75 f4             	pushl  -0xc(%ebp)
80107b89:	68 67 87 10 80       	push   $0x80108767
80107b8e:	e8 1d 8b ff ff       	call   801006b0 <cprintf>
		return -1;

	return myfunction(str);
80107b93:	83 c4 10             	add    $0x10,%esp
80107b96:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80107b9b:	c9                   	leave  
80107b9c:	c3                   	ret    
80107b9d:	66 90                	xchg   %ax,%ax
80107b9f:	90                   	nop

80107ba0 <getgpid>:
#include "proc.h"




int getgpid(void){
80107ba0:	f3 0f 1e fb          	endbr32 
80107ba4:	55                   	push   %ebp
80107ba5:	89 e5                	mov    %esp,%ebp
80107ba7:	83 ec 14             	sub    $0x14,%esp

        cprintf("My student id is 2022054702\n");
80107baa:	68 6b 87 10 80       	push   $0x8010876b
80107baf:	e8 fc 8a ff ff       	call   801006b0 <cprintf>
        cprintf("My pid is %d\n", myproc()->pid);
80107bb4:	e8 57 be ff ff       	call   80103a10 <myproc>
80107bb9:	5a                   	pop    %edx
80107bba:	59                   	pop    %ecx
80107bbb:	ff 70 10             	pushl  0x10(%eax)
80107bbe:	68 88 87 10 80       	push   $0x80108788
80107bc3:	e8 e8 8a ff ff       	call   801006b0 <cprintf>
        cprintf("My gpid is %d\n", myproc()->parent->parent->pid); 
80107bc8:	e8 43 be ff ff       	call   80103a10 <myproc>
80107bcd:	5a                   	pop    %edx
80107bce:	59                   	pop    %ecx
80107bcf:	8b 40 14             	mov    0x14(%eax),%eax
80107bd2:	8b 40 14             	mov    0x14(%eax),%eax
80107bd5:	ff 70 10             	pushl  0x10(%eax)
80107bd8:	68 96 87 10 80       	push   $0x80108796
80107bdd:	e8 ce 8a ff ff       	call   801006b0 <cprintf>
	
	return 0;
}
80107be2:	31 c0                	xor    %eax,%eax
80107be4:	c9                   	leave  
80107be5:	c3                   	ret    
80107be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bed:	8d 76 00             	lea    0x0(%esi),%esi

80107bf0 <sys_getgpid>:

int sys_getgpid(void){
80107bf0:	f3 0f 1e fb          	endbr32 
80107bf4:	55                   	push   %ebp
80107bf5:	89 e5                	mov    %esp,%ebp
80107bf7:	83 ec 08             	sub    $0x8,%esp
	
	getgpid();
80107bfa:	e8 a1 ff ff ff       	call   80107ba0 <getgpid>
	return 0;
}
80107bff:	31 c0                	xor    %eax,%eax
80107c01:	c9                   	leave  
80107c02:	c3                   	ret    
