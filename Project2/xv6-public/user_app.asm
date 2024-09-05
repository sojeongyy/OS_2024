
_user_app:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	f3 0f 1e fb          	endbr32 
  __asm__("int $128");
   4:	cd 80                	int    $0x80
  return 0;
}
   6:	31 c0                	xor    %eax,%eax
   8:	c3                   	ret    
   9:	66 90                	xchg   %ax,%ax
   b:	66 90                	xchg   %ax,%ax
   d:	66 90                	xchg   %ax,%ax
   f:	90                   	nop

00000010 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  10:	f3 0f 1e fb          	endbr32 
  14:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  15:	31 c0                	xor    %eax,%eax
{
  17:	89 e5                	mov    %esp,%ebp
  19:	53                   	push   %ebx
  1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
  20:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  24:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  27:	83 c0 01             	add    $0x1,%eax
  2a:	84 d2                	test   %dl,%dl
  2c:	75 f2                	jne    20 <strcpy+0x10>
    ;
  return os;
}
  2e:	89 c8                	mov    %ecx,%eax
  30:	5b                   	pop    %ebx
  31:	5d                   	pop    %ebp
  32:	c3                   	ret    
  33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	f3 0f 1e fb          	endbr32 
  44:	55                   	push   %ebp
  45:	89 e5                	mov    %esp,%ebp
  47:	53                   	push   %ebx
  48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  4e:	0f b6 01             	movzbl (%ecx),%eax
  51:	0f b6 1a             	movzbl (%edx),%ebx
  54:	84 c0                	test   %al,%al
  56:	75 19                	jne    71 <strcmp+0x31>
  58:	eb 26                	jmp    80 <strcmp+0x40>
  5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  60:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
  64:	83 c1 01             	add    $0x1,%ecx
  67:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  6a:	0f b6 1a             	movzbl (%edx),%ebx
  6d:	84 c0                	test   %al,%al
  6f:	74 0f                	je     80 <strcmp+0x40>
  71:	38 d8                	cmp    %bl,%al
  73:	74 eb                	je     60 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
  75:	29 d8                	sub    %ebx,%eax
}
  77:	5b                   	pop    %ebx
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  80:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  82:	29 d8                	sub    %ebx,%eax
}
  84:	5b                   	pop    %ebx
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    
  87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8e:	66 90                	xchg   %ax,%ax

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  9a:	80 3a 00             	cmpb   $0x0,(%edx)
  9d:	74 21                	je     c0 <strlen+0x30>
  9f:	31 c0                	xor    %eax,%eax
  a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  a8:	83 c0 01             	add    $0x1,%eax
  ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  af:	89 c1                	mov    %eax,%ecx
  b1:	75 f5                	jne    a8 <strlen+0x18>
    ;
  return n;
}
  b3:	89 c8                	mov    %ecx,%eax
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    
  b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
  c0:	31 c9                	xor    %ecx,%ecx
}
  c2:	5d                   	pop    %ebp
  c3:	89 c8                	mov    %ecx,%eax
  c5:	c3                   	ret    
  c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  cd:	8d 76 00             	lea    0x0(%esi),%esi

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
  d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	89 d7                	mov    %edx,%edi
  e3:	fc                   	cld    
  e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e6:	89 d0                	mov    %edx,%eax
  e8:	5f                   	pop    %edi
  e9:	5d                   	pop    %ebp
  ea:	c3                   	ret    
  eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ef:	90                   	nop

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	f3 0f 1e fb          	endbr32 
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  fe:	0f b6 10             	movzbl (%eax),%edx
 101:	84 d2                	test   %dl,%dl
 103:	75 16                	jne    11b <strchr+0x2b>
 105:	eb 21                	jmp    128 <strchr+0x38>
 107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 10e:	66 90                	xchg   %ax,%ax
 110:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 114:	83 c0 01             	add    $0x1,%eax
 117:	84 d2                	test   %dl,%dl
 119:	74 0d                	je     128 <strchr+0x38>
    if(*s == c)
 11b:	38 d1                	cmp    %dl,%cl
 11d:	75 f1                	jne    110 <strchr+0x20>
      return (char*)s;
  return 0;
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    
 121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 128:	31 c0                	xor    %eax,%eax
}
 12a:	5d                   	pop    %ebp
 12b:	c3                   	ret    
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 139:	31 f6                	xor    %esi,%esi
{
 13b:	53                   	push   %ebx
 13c:	89 f3                	mov    %esi,%ebx
 13e:	83 ec 1c             	sub    $0x1c,%esp
 141:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 144:	eb 33                	jmp    179 <gets+0x49>
 146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 150:	83 ec 04             	sub    $0x4,%esp
 153:	8d 45 e7             	lea    -0x19(%ebp),%eax
 156:	6a 01                	push   $0x1
 158:	50                   	push   %eax
 159:	6a 00                	push   $0x0
 15b:	e8 2b 01 00 00       	call   28b <read>
    if(cc < 1)
 160:	83 c4 10             	add    $0x10,%esp
 163:	85 c0                	test   %eax,%eax
 165:	7e 1c                	jle    183 <gets+0x53>
      break;
    buf[i++] = c;
 167:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 16b:	83 c7 01             	add    $0x1,%edi
 16e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 171:	3c 0a                	cmp    $0xa,%al
 173:	74 23                	je     198 <gets+0x68>
 175:	3c 0d                	cmp    $0xd,%al
 177:	74 1f                	je     198 <gets+0x68>
  for(i=0; i+1 < max; ){
 179:	83 c3 01             	add    $0x1,%ebx
 17c:	89 fe                	mov    %edi,%esi
 17e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 181:	7c cd                	jl     150 <gets+0x20>
 183:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 185:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 188:	c6 03 00             	movb   $0x0,(%ebx)
}
 18b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 18e:	5b                   	pop    %ebx
 18f:	5e                   	pop    %esi
 190:	5f                   	pop    %edi
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    
 193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 197:	90                   	nop
 198:	8b 75 08             	mov    0x8(%ebp),%esi
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	01 de                	add    %ebx,%esi
 1a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 1a2:	c6 03 00             	movb   $0x0,(%ebx)
}
 1a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1a8:	5b                   	pop    %ebx
 1a9:	5e                   	pop    %esi
 1aa:	5f                   	pop    %edi
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
 1ad:	8d 76 00             	lea    0x0(%esi),%esi

000001b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
 1b5:	89 e5                	mov    %esp,%ebp
 1b7:	56                   	push   %esi
 1b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b9:	83 ec 08             	sub    $0x8,%esp
 1bc:	6a 00                	push   $0x0
 1be:	ff 75 08             	pushl  0x8(%ebp)
 1c1:	e8 ed 00 00 00       	call   2b3 <open>
  if(fd < 0)
 1c6:	83 c4 10             	add    $0x10,%esp
 1c9:	85 c0                	test   %eax,%eax
 1cb:	78 2b                	js     1f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1cd:	83 ec 08             	sub    $0x8,%esp
 1d0:	ff 75 0c             	pushl  0xc(%ebp)
 1d3:	89 c3                	mov    %eax,%ebx
 1d5:	50                   	push   %eax
 1d6:	e8 f0 00 00 00       	call   2cb <fstat>
  close(fd);
 1db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1de:	89 c6                	mov    %eax,%esi
  close(fd);
 1e0:	e8 b6 00 00 00       	call   29b <close>
  return r;
 1e5:	83 c4 10             	add    $0x10,%esp
}
 1e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1eb:	89 f0                	mov    %esi,%eax
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 1f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1fd:	eb e9                	jmp    1e8 <stat+0x38>
 1ff:	90                   	nop

00000200 <atoi>:

int
atoi(const char *s)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	53                   	push   %ebx
 208:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 20b:	0f be 02             	movsbl (%edx),%eax
 20e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 211:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 214:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 219:	77 1a                	ja     235 <atoi+0x35>
 21b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 21f:	90                   	nop
    n = n*10 + *s++ - '0';
 220:	83 c2 01             	add    $0x1,%edx
 223:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 226:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 22a:	0f be 02             	movsbl (%edx),%eax
 22d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 230:	80 fb 09             	cmp    $0x9,%bl
 233:	76 eb                	jbe    220 <atoi+0x20>
  return n;
}
 235:	89 c8                	mov    %ecx,%eax
 237:	5b                   	pop    %ebx
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	f3 0f 1e fb          	endbr32 
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	8b 45 10             	mov    0x10(%ebp),%eax
 24b:	8b 55 08             	mov    0x8(%ebp),%edx
 24e:	56                   	push   %esi
 24f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 252:	85 c0                	test   %eax,%eax
 254:	7e 0f                	jle    265 <memmove+0x25>
 256:	01 d0                	add    %edx,%eax
  dst = vdst;
 258:	89 d7                	mov    %edx,%edi
 25a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 260:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 261:	39 f8                	cmp    %edi,%eax
 263:	75 fb                	jne    260 <memmove+0x20>
  return vdst;
}
 265:	5e                   	pop    %esi
 266:	89 d0                	mov    %edx,%eax
 268:	5f                   	pop    %edi
 269:	5d                   	pop    %ebp
 26a:	c3                   	ret    

0000026b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <exit>:
SYSCALL(exit)
 273:	b8 02 00 00 00       	mov    $0x2,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <wait>:
SYSCALL(wait)
 27b:	b8 03 00 00 00       	mov    $0x3,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <pipe>:
SYSCALL(pipe)
 283:	b8 04 00 00 00       	mov    $0x4,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <read>:
SYSCALL(read)
 28b:	b8 05 00 00 00       	mov    $0x5,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <write>:
SYSCALL(write)
 293:	b8 10 00 00 00       	mov    $0x10,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <close>:
SYSCALL(close)
 29b:	b8 15 00 00 00       	mov    $0x15,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <kill>:
SYSCALL(kill)
 2a3:	b8 06 00 00 00       	mov    $0x6,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <exec>:
SYSCALL(exec)
 2ab:	b8 07 00 00 00       	mov    $0x7,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <open>:
SYSCALL(open)
 2b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <mknod>:
SYSCALL(mknod)
 2bb:	b8 11 00 00 00       	mov    $0x11,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <unlink>:
SYSCALL(unlink)
 2c3:	b8 12 00 00 00       	mov    $0x12,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <fstat>:
SYSCALL(fstat)
 2cb:	b8 08 00 00 00       	mov    $0x8,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <link>:
SYSCALL(link)
 2d3:	b8 13 00 00 00       	mov    $0x13,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mkdir>:
SYSCALL(mkdir)
 2db:	b8 14 00 00 00       	mov    $0x14,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <chdir>:
SYSCALL(chdir)
 2e3:	b8 09 00 00 00       	mov    $0x9,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <dup>:
SYSCALL(dup)
 2eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <getpid>:
SYSCALL(getpid)
 2f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <sbrk>:
SYSCALL(sbrk)
 2fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <sleep>:
SYSCALL(sleep)
 303:	b8 0d 00 00 00       	mov    $0xd,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <uptime>:
SYSCALL(uptime)
 30b:	b8 0e 00 00 00       	mov    $0xe,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <myfunction>:
SYSCALL(myfunction)
 313:	b8 16 00 00 00       	mov    $0x16,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <getgpid>:
SYSCALL(getgpid)
 31b:	b8 17 00 00 00       	mov    $0x17,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <yield>:
SYSCALL(yield)
 323:	b8 18 00 00 00       	mov    $0x18,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <getlev>:
SYSCALL(getlev)
 32b:	b8 19 00 00 00       	mov    $0x19,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <setpriority>:
SYSCALL(setpriority)
 333:	b8 1a 00 00 00       	mov    $0x1a,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <setmonopoly>:
SYSCALL(setmonopoly)
 33b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <monopolize>:
SYSCALL(monopolize)
 343:	b8 1c 00 00 00       	mov    $0x1c,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <unmonopolize>:
SYSCALL(unmonopolize)
 34b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    
 353:	66 90                	xchg   %ax,%ax
 355:	66 90                	xchg   %ax,%ax
 357:	66 90                	xchg   %ax,%ax
 359:	66 90                	xchg   %ax,%ax
 35b:	66 90                	xchg   %ax,%ax
 35d:	66 90                	xchg   %ax,%ax
 35f:	90                   	nop

00000360 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	56                   	push   %esi
 365:	53                   	push   %ebx
 366:	83 ec 3c             	sub    $0x3c,%esp
 369:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 36c:	89 d1                	mov    %edx,%ecx
{
 36e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 371:	85 d2                	test   %edx,%edx
 373:	0f 89 7f 00 00 00    	jns    3f8 <printint+0x98>
 379:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 37d:	74 79                	je     3f8 <printint+0x98>
    neg = 1;
 37f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 386:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 388:	31 db                	xor    %ebx,%ebx
 38a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 38d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 390:	89 c8                	mov    %ecx,%eax
 392:	31 d2                	xor    %edx,%edx
 394:	89 cf                	mov    %ecx,%edi
 396:	f7 75 c4             	divl   -0x3c(%ebp)
 399:	0f b6 92 80 07 00 00 	movzbl 0x780(%edx),%edx
 3a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 3a3:	89 d8                	mov    %ebx,%eax
 3a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 3a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 3ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 3ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 3b1:	76 dd                	jbe    390 <printint+0x30>
  if(neg)
 3b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 3b6:	85 c9                	test   %ecx,%ecx
 3b8:	74 0c                	je     3c6 <printint+0x66>
    buf[i++] = '-';
 3ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 3bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 3c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 3c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 3c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 3cd:	eb 07                	jmp    3d6 <printint+0x76>
 3cf:	90                   	nop
 3d0:	0f b6 13             	movzbl (%ebx),%edx
 3d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 3d6:	83 ec 04             	sub    $0x4,%esp
 3d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 3dc:	6a 01                	push   $0x1
 3de:	56                   	push   %esi
 3df:	57                   	push   %edi
 3e0:	e8 ae fe ff ff       	call   293 <write>
  while(--i >= 0)
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	39 de                	cmp    %ebx,%esi
 3ea:	75 e4                	jne    3d0 <printint+0x70>
    putc(fd, buf[i]);
}
 3ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ef:	5b                   	pop    %ebx
 3f0:	5e                   	pop    %esi
 3f1:	5f                   	pop    %edi
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    
 3f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 3ff:	eb 87                	jmp    388 <printint+0x28>
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40f:	90                   	nop

00000410 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	57                   	push   %edi
 418:	56                   	push   %esi
 419:	53                   	push   %ebx
 41a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 41d:	8b 75 0c             	mov    0xc(%ebp),%esi
 420:	0f b6 1e             	movzbl (%esi),%ebx
 423:	84 db                	test   %bl,%bl
 425:	0f 84 b4 00 00 00    	je     4df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 42b:	8d 45 10             	lea    0x10(%ebp),%eax
 42e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 431:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 434:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 436:	89 45 d0             	mov    %eax,-0x30(%ebp)
 439:	eb 33                	jmp    46e <printf+0x5e>
 43b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 43f:	90                   	nop
 440:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 443:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 448:	83 f8 25             	cmp    $0x25,%eax
 44b:	74 17                	je     464 <printf+0x54>
  write(fd, &c, 1);
 44d:	83 ec 04             	sub    $0x4,%esp
 450:	88 5d e7             	mov    %bl,-0x19(%ebp)
 453:	6a 01                	push   $0x1
 455:	57                   	push   %edi
 456:	ff 75 08             	pushl  0x8(%ebp)
 459:	e8 35 fe ff ff       	call   293 <write>
 45e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 461:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 464:	0f b6 1e             	movzbl (%esi),%ebx
 467:	83 c6 01             	add    $0x1,%esi
 46a:	84 db                	test   %bl,%bl
 46c:	74 71                	je     4df <printf+0xcf>
    c = fmt[i] & 0xff;
 46e:	0f be cb             	movsbl %bl,%ecx
 471:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 474:	85 d2                	test   %edx,%edx
 476:	74 c8                	je     440 <printf+0x30>
      }
    } else if(state == '%'){
 478:	83 fa 25             	cmp    $0x25,%edx
 47b:	75 e7                	jne    464 <printf+0x54>
      if(c == 'd'){
 47d:	83 f8 64             	cmp    $0x64,%eax
 480:	0f 84 9a 00 00 00    	je     520 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 486:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 48c:	83 f9 70             	cmp    $0x70,%ecx
 48f:	74 5f                	je     4f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 491:	83 f8 73             	cmp    $0x73,%eax
 494:	0f 84 d6 00 00 00    	je     570 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 49a:	83 f8 63             	cmp    $0x63,%eax
 49d:	0f 84 8d 00 00 00    	je     530 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a3:	83 f8 25             	cmp    $0x25,%eax
 4a6:	0f 84 b4 00 00 00    	je     560 <printf+0x150>
  write(fd, &c, 1);
 4ac:	83 ec 04             	sub    $0x4,%esp
 4af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 4b3:	6a 01                	push   $0x1
 4b5:	57                   	push   %edi
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 d5 fd ff ff       	call   293 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 4be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 4c1:	83 c4 0c             	add    $0xc,%esp
 4c4:	6a 01                	push   $0x1
 4c6:	83 c6 01             	add    $0x1,%esi
 4c9:	57                   	push   %edi
 4ca:	ff 75 08             	pushl  0x8(%ebp)
 4cd:	e8 c1 fd ff ff       	call   293 <write>
  for(i = 0; fmt[i]; i++){
 4d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 4d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 4d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 4db:	84 db                	test   %bl,%bl
 4dd:	75 8f                	jne    46e <printf+0x5e>
    }
  }
}
 4df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4e2:	5b                   	pop    %ebx
 4e3:	5e                   	pop    %esi
 4e4:	5f                   	pop    %edi
 4e5:	5d                   	pop    %ebp
 4e6:	c3                   	ret    
 4e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 4f0:	83 ec 0c             	sub    $0xc,%esp
 4f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f8:	6a 00                	push   $0x0
 4fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	8b 13                	mov    (%ebx),%edx
 502:	e8 59 fe ff ff       	call   360 <printint>
        ap++;
 507:	89 d8                	mov    %ebx,%eax
 509:	83 c4 10             	add    $0x10,%esp
      state = 0;
 50c:	31 d2                	xor    %edx,%edx
        ap++;
 50e:	83 c0 04             	add    $0x4,%eax
 511:	89 45 d0             	mov    %eax,-0x30(%ebp)
 514:	e9 4b ff ff ff       	jmp    464 <printf+0x54>
 519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 520:	83 ec 0c             	sub    $0xc,%esp
 523:	b9 0a 00 00 00       	mov    $0xa,%ecx
 528:	6a 01                	push   $0x1
 52a:	eb ce                	jmp    4fa <printf+0xea>
 52c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 530:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 533:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 536:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 538:	6a 01                	push   $0x1
        ap++;
 53a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 53d:	57                   	push   %edi
 53e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 541:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 544:	e8 4a fd ff ff       	call   293 <write>
        ap++;
 549:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 54c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54f:	31 d2                	xor    %edx,%edx
 551:	e9 0e ff ff ff       	jmp    464 <printf+0x54>
 556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 560:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 563:	83 ec 04             	sub    $0x4,%esp
 566:	e9 59 ff ff ff       	jmp    4c4 <printf+0xb4>
 56b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
        s = (char*)*ap;
 570:	8b 45 d0             	mov    -0x30(%ebp),%eax
 573:	8b 18                	mov    (%eax),%ebx
        ap++;
 575:	83 c0 04             	add    $0x4,%eax
 578:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 57b:	85 db                	test   %ebx,%ebx
 57d:	74 17                	je     596 <printf+0x186>
        while(*s != 0){
 57f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 582:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 584:	84 c0                	test   %al,%al
 586:	0f 84 d8 fe ff ff    	je     464 <printf+0x54>
 58c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 58f:	89 de                	mov    %ebx,%esi
 591:	8b 5d 08             	mov    0x8(%ebp),%ebx
 594:	eb 1a                	jmp    5b0 <printf+0x1a0>
          s = "(null)";
 596:	bb 78 07 00 00       	mov    $0x778,%ebx
        while(*s != 0){
 59b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 59e:	b8 28 00 00 00       	mov    $0x28,%eax
 5a3:	89 de                	mov    %ebx,%esi
 5a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5b3:	83 c6 01             	add    $0x1,%esi
 5b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b9:	6a 01                	push   $0x1
 5bb:	57                   	push   %edi
 5bc:	53                   	push   %ebx
 5bd:	e8 d1 fc ff ff       	call   293 <write>
        while(*s != 0){
 5c2:	0f b6 06             	movzbl (%esi),%eax
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	84 c0                	test   %al,%al
 5ca:	75 e4                	jne    5b0 <printf+0x1a0>
 5cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 5cf:	31 d2                	xor    %edx,%edx
 5d1:	e9 8e fe ff ff       	jmp    464 <printf+0x54>
 5d6:	66 90                	xchg   %ax,%ax
 5d8:	66 90                	xchg   %ax,%ax
 5da:	66 90                	xchg   %ax,%ax
 5dc:	66 90                	xchg   %ax,%ax
 5de:	66 90                	xchg   %ax,%ax

000005e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e0:	f3 0f 1e fb          	endbr32 
 5e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e5:	a1 18 0a 00 00       	mov    0xa18,%eax
{
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	57                   	push   %edi
 5ed:	56                   	push   %esi
 5ee:	53                   	push   %ebx
 5ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 5f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	39 c8                	cmp    %ecx,%eax
 5f9:	73 15                	jae    610 <free+0x30>
 5fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ff:	90                   	nop
 600:	39 d1                	cmp    %edx,%ecx
 602:	72 14                	jb     618 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 604:	39 d0                	cmp    %edx,%eax
 606:	73 10                	jae    618 <free+0x38>
{
 608:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60a:	8b 10                	mov    (%eax),%edx
 60c:	39 c8                	cmp    %ecx,%eax
 60e:	72 f0                	jb     600 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 610:	39 d0                	cmp    %edx,%eax
 612:	72 f4                	jb     608 <free+0x28>
 614:	39 d1                	cmp    %edx,%ecx
 616:	73 f0                	jae    608 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 618:	8b 73 fc             	mov    -0x4(%ebx),%esi
 61b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 61e:	39 fa                	cmp    %edi,%edx
 620:	74 1e                	je     640 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 622:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 625:	8b 50 04             	mov    0x4(%eax),%edx
 628:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 62b:	39 f1                	cmp    %esi,%ecx
 62d:	74 28                	je     657 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 62f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 631:	5b                   	pop    %ebx
  freep = p;
 632:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 637:	5e                   	pop    %esi
 638:	5f                   	pop    %edi
 639:	5d                   	pop    %ebp
 63a:	c3                   	ret    
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 640:	03 72 04             	add    0x4(%edx),%esi
 643:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 646:	8b 10                	mov    (%eax),%edx
 648:	8b 12                	mov    (%edx),%edx
 64a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 64d:	8b 50 04             	mov    0x4(%eax),%edx
 650:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 653:	39 f1                	cmp    %esi,%ecx
 655:	75 d8                	jne    62f <free+0x4f>
    p->s.size += bp->s.size;
 657:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 65a:	a3 18 0a 00 00       	mov    %eax,0xa18
    p->s.size += bp->s.size;
 65f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 662:	8b 53 f8             	mov    -0x8(%ebx),%edx
 665:	89 10                	mov    %edx,(%eax)
}
 667:	5b                   	pop    %ebx
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 670:	f3 0f 1e fb          	endbr32 
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	57                   	push   %edi
 678:	56                   	push   %esi
 679:	53                   	push   %ebx
 67a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 680:	8b 3d 18 0a 00 00    	mov    0xa18,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 686:	8d 70 07             	lea    0x7(%eax),%esi
 689:	c1 ee 03             	shr    $0x3,%esi
 68c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 68f:	85 ff                	test   %edi,%edi
 691:	0f 84 a9 00 00 00    	je     740 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 697:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 699:	8b 48 04             	mov    0x4(%eax),%ecx
 69c:	39 f1                	cmp    %esi,%ecx
 69e:	73 6d                	jae    70d <malloc+0x9d>
 6a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 6a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 6b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 6b8:	eb 17                	jmp    6d1 <malloc+0x61>
 6ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 6c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 6c5:	39 f1                	cmp    %esi,%ecx
 6c7:	73 4f                	jae    718 <malloc+0xa8>
 6c9:	8b 3d 18 0a 00 00    	mov    0xa18,%edi
 6cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6d1:	39 c7                	cmp    %eax,%edi
 6d3:	75 eb                	jne    6c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 6d5:	83 ec 0c             	sub    $0xc,%esp
 6d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 6db:	e8 1b fc ff ff       	call   2fb <sbrk>
  if(p == (char*)-1)
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6e6:	74 1b                	je     703 <malloc+0x93>
  hp->s.size = nu;
 6e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	83 ec 0c             	sub    $0xc,%esp
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	50                   	push   %eax
 6f2:	e8 e9 fe ff ff       	call   5e0 <free>
  return freep;
 6f7:	a1 18 0a 00 00       	mov    0xa18,%eax
      if((p = morecore(nunits)) == 0)
 6fc:	83 c4 10             	add    $0x10,%esp
 6ff:	85 c0                	test   %eax,%eax
 701:	75 bd                	jne    6c0 <malloc+0x50>
        return 0;
  }
}
 703:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 706:	31 c0                	xor    %eax,%eax
}
 708:	5b                   	pop    %ebx
 709:	5e                   	pop    %esi
 70a:	5f                   	pop    %edi
 70b:	5d                   	pop    %ebp
 70c:	c3                   	ret    
    if(p->s.size >= nunits){
 70d:	89 c2                	mov    %eax,%edx
 70f:	89 f8                	mov    %edi,%eax
 711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 718:	39 ce                	cmp    %ecx,%esi
 71a:	74 54                	je     770 <malloc+0x100>
        p->s.size -= nunits;
 71c:	29 f1                	sub    %esi,%ecx
 71e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 721:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 724:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 727:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 72c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 72f:	8d 42 08             	lea    0x8(%edx),%eax
}
 732:	5b                   	pop    %ebx
 733:	5e                   	pop    %esi
 734:	5f                   	pop    %edi
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 740:	c7 05 18 0a 00 00 1c 	movl   $0xa1c,0xa18
 747:	0a 00 00 
    base.s.size = 0;
 74a:	bf 1c 0a 00 00       	mov    $0xa1c,%edi
    base.s.ptr = freep = prevp = &base;
 74f:	c7 05 1c 0a 00 00 1c 	movl   $0xa1c,0xa1c
 756:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 759:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 75b:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 762:	00 00 00 
    if(p->s.size >= nunits){
 765:	e9 36 ff ff ff       	jmp    6a0 <malloc+0x30>
 76a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 770:	8b 0a                	mov    (%edx),%ecx
 772:	89 08                	mov    %ecx,(%eax)
 774:	eb b1                	jmp    727 <malloc+0xb7>
