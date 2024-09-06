# Project4 Wiki

# Design

메모리 낭비를 줄이기 위해 Copy-on-Write 기술을 구현한다. 

Initial Sharing과 making a copy on write operation을 구현한다. 

## 1. Initial Sharing

물리 페이지의 참조 횟수를 알기 위해서는 새로운 자료구조를 사용한다. 

이를 위해서 refCount[] 배열을 사용한다. 해당 배열은 각 물리 페이지의 참조 횟수를 저장한다. 

배열 크기는 TOP physical memory 주소를 가리키는 PHYSTOP을 각 페이지의 크기를 가리키는 PHYSIZE(4096)로 나누어서 페이지의 개수를 배열의 크기로 가지게 한다.

- 참조 횟수가 증가 또는 1로 설정되는 경우
    1. 어떠한 페이지가 처음으로 어떤 프로세스에 의해 할당될 때 → 1로 할당
    2. 추가 프로세스가 이미 존재하는 페이지를 가리킬 때 → 1 증가
- 참조 횟수가 감소되는 경우
    1. 프로세스가 더 이상 페이지를 가리키지 않을 때 → 1 감소
    2. 참조 횟수가 0이 되면 페이지를 free 시키고 freelist로 반환

refCount 배열은 kalloc.c에서 구현한다. 

그 외 incr_refc, decr_refc, get_refc 함수도 kalloc.c에서 구현한다. 증가, 감소시키는 함수는 lock을 사용해서 함수 내에서 동기화해준다. 

CoW 를 구현하면 fork()의 원리가 상당히 바뀌는데, 자식 프로세스와 부모 프로세스가 동일한 물리 페이지를 가리키도록 바꿔야 한다. 즉, 새로운 메모리를 할당하여 복사하는 것이 아니다. 이를 위해서는 fork() 함수 내에서 사용하는 copyuvm 함수를 수정해야 한다. 

- 기존 copyuvm 함수
    
    `memmove(mem, (char*)P2V(pa), PGSIZE);` 을 사용해 부모 프로세스의 페이지 내용을 자식 프로세스로 복사한다. 부모 프로세스의 페이지 테이블 엔트리 주소인 pa를 가상주소로 변환 후 자식 프로세스의 mem 주소에 복사한다. 
    
    **`mappages(d, (void*)i, PGSIZE, V2P(mem), flags)`** 을 사용해 자식 프로세스의 페이지 테이블에 새로 복사한 페이지를 매핑한다. 
    

새로운 copyuvm 함수에서는 memmove 함수를 사용하지 않고, mappages 함수만 사용하여 자식 프로세스의 페이지 테이블이 부모 프로세스와 동일한 물리페이지를 가리키도록만 하면 된다.

## 2. Make a copy

해당 부분은 CoW_handler 함수에서 대부분 구현 가능하다. 

부모 또는 자식 프로세스가 읽기 전용으로 된 페이지에 쓰기를 시도할 때 페이지 폴트가 발생하고, 해당 폴트를 처리하기 위해 CoW_handler가 호출된다. 

이를 위해서는 trap.c에서 우선적으로 페이지 폴트 케이스를 추가해야 한다. 

CoW_handler에서는 새로운 메모리를 할당한 후 user memory의 복사본을 만들어서 새로운 페이지에 복사해야 한다. 이때 해당 페이지의 참조 횟수가 1인지 1보다 큰 지에 따라서 약간 구현이 달라진다.

- 참조 횟수가 1보다 클 때
    - 부모 프로세스의 페이지 내용을 새로운 페이지로 복사한다.
    - 기존 페이지의 참조 횟수는 감소, 새로운 페이지 참조 횟수는 증가시킨다.
    - 권한 변경
- 참조 횟수가 1일 때
    - 해당 페이지를 딱 하나의 프로세스만이 참조하고 있다는 뜻이므로, 그냥 해당 페이지를 쓰면 된다.
    - 권한만 변경

# Implement

## 1. Initial Sharing

## kalloc.c

```c
uint refCount[PHYSTOP / PGSIZE]; // reference count array
```

페이지의 참조횟수를 나타내는 배열 refCount이다. 배열 크기는 physical memory의 페이지 개수이다. 

- freerange

```c
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
    refCount[V2P(p) / PGSIZE] = 0; // initialize reference count of physical pages 
    kfree(p);
  }
}
```

freerange 함수는 특정 범위의 메모리 페이지를 해제하는 역할을 한다.

해당 범위의 페이지의 참조 횟수를 모두 0으로 초기화해주었다. 

- kfree

```c
void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");

  if(kmem.use_lock)
    acquire(&kmem.lock);

  r = (struct run*)v;

  if (refCount[V2P(v) / PGSIZE] > 0) 
    refCount[V2P(v) / PGSIZE]--;
    
  if (refCount[V2P(v) / PGSIZE] == 0) { // add to freelist
      memset(v, 1, PGSIZE);
      r->next = kmem.freelist;
      kmem.freelist = r;
  }
  
  
  if(kmem.use_lock)
    release(&kmem.lock);
}
```

인자로 받은 메모리 페이지를 해제한다. 해당 페이지의 참조 횟수가 0보다 클 때만 참조 횟수를 감소시켜준다. 

감소시켜준 후 만약 참조 횟수가 0이 된다면, 해당 페이지를 freelist에 넣어줘야 한다. 메모리 페이지의 모든 바이트를 1로 바꿔준 후 해제시켜주었다. 

- kalloc

```c
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  
  r = kmem.freelist;

  if(r) {
    kmem.freelist = r->next; // not freelist anymore..
    refCount[V2P((char*)r) / PGSIZE] = 1;
  }

  if(kmem.use_lock)
    release(&kmem.lock);

  return (char*)r;
}
```

freelist가 비어있지 않을 때 freelist에서 페이지를 가져와서 할당시켜준다. 그리고 해당 페이지의 참조 횟수를 1로 설정해준다. 

- incr_refc, dec_refc

```c
void
incr_refc(uint pa) // increase 참조 count of pa
{
  if (pa >= PHYSTOP || pa < V2P(end)) 
    panic("reference count failed");
    
  acquire(&kmem.lock);
  refCount[pa / PGSIZE]++;
  release(&kmem.lock);
}

void
decr_refc(uint pa) // increase 참조 count of pa
{
  if (pa >= PHYSTOP || pa < V2P(end)) 
    panic("reference count failed");

  acquire(&kmem.lock);
  refCount[pa / PGSIZE]--;
  release(&kmem.lock);
}
```

physical address를 인자로 받았을 때, 해당 페이지의 참조 횟수를 1만큼 증가 또는 감소시켜준다. 이때 동시에 다수의 프로세스가 refCount에 접근하지 못하도록 lock을 사용해 동기화를 해준다. 

이때 인자로 받은 주소가 physical address 주소 범위를 벗어났다면 범위가 잘못된 것이므로 panic처리 해주었다.

- get_refc

```c
int 
get_refc(uint pa)
{
  if (pa >= PHYSTOP || pa < V2P(end))
    panic("reference count failed");
  
  return refCount[pa / PGSIZE];
}
```

인자로 받은 주소의 페이지의 참조 횟수를 반환한다. 

## vm.c

- copyuvm

```c
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");

    *pte &= ~PTE_W; // cannot write
    flags = PTE_FLAGS(*pte); 
    pa = PTE_ADDR(*pte);

    if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) { // page table mapping
      panic("copyuvm failed!");
    } 

    incr_refc(pa); // child process reference
  }

  lcr3(V2P(pgdir));
  return d;
}
```

**`pde_t *d;`**: 새로운 페이지 디렉토리 포인터
**`pte_t *pte;`**: 페이지 테이블 엔트리 포인터 

for문 내에서 walkpgdir 함수를 사용하여 부모 프로세스의 페이지 디렉토리 **`pgdir`**에서 가상 주소 i에 해당하는 페이지 테이블 엔트리를 선언한다. 

우선 기존 xv6-public에 있던 에러 처리를 해준 후, 해당 페이지의 읽기 권한을 뺏는다. 

그 후 자식 프로세스의 page table이 부모 프로세스와 같은 페이지를 가리키도록 해야 하므로, `mappages(d, (void*)i, PGSIZE, pa, flags)` 를 사용한다.  

새로운 페이지 디렉토리 d에 PGSIZE 크기의 해당 페이지를 flags와 함께 매핑하는 것이다.

매핑시킨 후 해당 페이지의 참조 횟수를 1 증가시켜준다. 

return 전에  `lcr3(V2P(pgdir));` 을 사용하여 TLB flush를 해준다. 

## 2. Make a copy

### trap.c

80번 줄에 페이지 폴트 핸들러가 호출되는 case를 추가해준다. 

```c
case T_PGFLT:
    CoW_handler();
    break; 
```

T_PGFLT은 traps.h에서 14로 정의되어있다.

```c
#define T_PGFLT         14      // page fault
```

### vm.c

- CoW_handler

```c
void 
CoW_handler(void)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  uint va = rcr2(); // virtual address where page fault happened

  pte_t *pte = walkpgdir(pgdir, (void *)va, 0); // page entry
  uint pa = PTE_ADDR(*pte);
  int count = get_refc(pa);

  if (!pte || !(*pte)) {
    panic("CoW_handler: page not found");
  }

  if (va >= KERNBASE || va < 0) {
    panic("CoW_handler: wrong virtual address");
  }

  if (count == 1) { // just use that page
    *pte |= PTE_W; // can write!
    lcr3(V2P(pgdir));
    return;
  }

  else if (count > 1) { // copy

    char *new_page = kalloc(); // mem reference count = 1
    if (new_page == 0) {
      curproc->killed = 1;
      cprintf("failed : kalloc()");
      return;
    }
    
    memmove(new_page, (char*)P2V(pa), PGSIZE); // copy!!
    *pte = PTE_U | PTE_W | PTE_P | V2P(new_page);
    decr_refc(pa);
    
    lcr3(V2P(pgdir));
    return;   
  }
  
  else panic("CoW_handler error!");
}
```

CoW_handler 함수를 사용해 페이지 폴트를 처리한다. 

전체적으로는 어떠한 페이지에 쓰기를 시도할 때, 해당 페이지를 복사하는 것이 목표이다. 

그러기 위해서 우선 현재 프로세스의 페이지 테이블 엔트리를 가져와야 한다. 

`pte_t *pte = walkpgdir(pgdir, (void *)va, 0);` :  walkpgdir 함수를 사용하여 가상 주소 va에 해당하는 페이지 테이블 엔트리(pte)를 가져온다.

```c
if (!pte || !(*pte)) {
    panic("CoW_handler: page not found");
  }

  if (va >= KERNBASE || va < 0) {
    panic("CoW_handler: wrong virtual address");
  }
```

이 코드로 페이지 엔트리가 유효한지와 가상주소가 커널영역에 있는지, 음수인지의 유무에 따라 panic을 발생시킨다. 

```c
  if (count == 1) { // just use that page
    *pte |= PTE_W; // can write!
    lcr3(V2P(pgdir));
    return;
  }
```

`int count = get_refc(pa);` 에서 해당 페이지의 참조횟수가 1회이면, 페이지 복사없이 그냥 권한만 바꿔주고 해당 페이지를 그대로 사용하면 된다. 그렇기에 읽기 권한으로만 바꿔준 후 TLB flush를 하고 끝낸다. 

```c
else if (count > 1) { // copy

    char *new_page = kalloc(); // mem reference count = 1
    if (new_page == 0) {
      curproc->killed = 1;
      cprintf("failed : kalloc()");
      return;
    }
    
    memmove(new_page, (char*)P2V(pa), PGSIZE); // copy!!
    *pte = PTE_U | PTE_W | PTE_P | V2P(new_page);
    decr_refc(pa);
    
    lcr3(V2P(pgdir));
    return;   
  }
```

1회보다 많다면 페이지를 복사해야 한다. 

새로운 페이지를 위해 kalloc함수로 할당해준다. 그러면 내가 수정한 kalloc 함수에 의해 새로운 페이지의 참조횟수는 자연스럽게 1로 설정된다. 

그 후 새로운 페이지가 제대로 할당된 것이 확인되면 memmove 함수를 사용해 PGSIZE 크기의 pa 주소의 페이지의 내용을 가지는 새로운 페이지를 new_page에 복사한다. 

그 후 새로운 페이지의 모든 권한도 세팅해준다. 기존 페이지의 참조횟수는 1 감소시켜야 한다. 마지막으로 TLB flush후 끝낸다.

## count system calls 구현

1. countfp : kalloc.c에 구현

```c
int
countfp(void)
{
  struct run *r;
  int count = 0;

  acquire(&kmem.lock);

  r = kmem.freelist;
  while (r) {
    count++;
    r = r->next;
  }

  release(&kmem.lock);

  return count;
}
```

countfp 시스템콜은 시스템에 존재하는 free page의 총 개수를 반환한다. free page는 freelist 안에 저장되어있으므로, freelist 리스트의 요소 개수를 세면 된다. 

kmem을 사용하기 위해 kalloc.c에서 구현하였다.

1. countvp: vm.c에 구현

```c
int
countvp(void)
{
  uint size = myproc()->sz;
  int vp_num;
  if (size % PGSIZE == 0)
		vp_num = size / PGSIZE;
  else
		vp_num = size / PGSIZE + 1;
 
  return vp_num;
}
```

이 시스템콜은 현재 프로세스의 user memory에 할당된 가상 페이지의 수를 반환한다. 

가상 페이지의 크기는 PGSIZE, 즉 4096이므로 PGSIZE를 현재 프로세스의 사이즈에서 나누면 개수가 나온다. 이때 나누어 떨어지지 않으면 마지막 페이지가 일부만 차지하고 있다는 뜻인데, 이때 +1을 해준다.

1. countpp: vm.c에 구현

```c
int
countpp(void)
{ 
  pde_t *pgdir = myproc()->pgdir;
  uint size = myproc()->sz;
  int count = 0;

  // look up page table
  uint va;
  for (va = 0; va < size; va += PGSIZE) {
    if (va >= KERNBASE) 
			continue; // don't include kernel page

    pte_t *pte = walkpgdir(pgdir, (char*)va, 0);
    if (pte && ((*pte) & PTE_P))
      	count++;
  }

  return count;
}
```

이 시스템 콜은 현재 프로세스의 페이지 테이블을 탐색하여 유효한 물리 주소가 할당된 page table entry 수를 반환한다. 그러기 위해서 현재 프로세스의 페이지 디렉토리를 가져와 순회해야 하는데, `walkpgdir` 함수를 이용해 현재 프로세스 내의 각 페이지 가상 주소에 따른 page table entry를 pte 변수로 가져온다. page table entry가 존재하고, 페이지가 유효한 경우 count를 하나 추가해준다. 

walkpgdir함수를 사용하기 위해 vm.c에 구현하였다. 

1. countptp: kalloc.c에 구현

```c
// num of pages allocated by page table
int
countptp(void)
{
  pde_t *pgdir = myproc()->pgdir;
  int count = 0;

  for (int i = 0; i < NPDENTRIES; i++) { // allocated by page table
    if (pgdir[i] & PTE_P) 
      count++;
  }

  count++; // page used in page directory..
  return count;
}
```

이 시스템 콜은 현재 프로세스의 페이지 디렉토리에서 할당된 페이지 수를 계산한다. 이때 NPDENTRIES, 즉 페이지 디렉토리의 수를 사용하여 현재 프로세스의 페이지 디렉토리를 순회한다. 순회하면서 해당 페이지 디렉토리 엔트리가 유효한지 확인할 경우 count를 추가해준다. 

명세에서 페이지 디렉토리에 사용된 페이지도 포함하라고 했으므로 마지막에 1을 추가로 더해준다. 

# Result

- build command
    
    ./bootxv6.sh
    
    아래는 [bootxv6.sh](http://bootxv6.sh) 파일 내용이다. 
    
    ![Untitled](Untitled.png)
    

![Untitled](Untitled%201.png)

test0, 1, 2, 3, 모두 정상적으로 pass가 뜨고, 종료도 잘 되었다. 

# Trouble Shooting

1. kfree 함수 내에서 참조 횟수를 줄이기 위해 처음에는 decr_refc 함수를 사용했었다. 그런데 panic acquire 에러가 떴다. 알고보니 kfree 함수 내에서 kmem.lock을 사용하고 있는데 decr_refc 함수를 중간에 부르면 해당 함수 안에서도 lock을 걸기 때문에 두 번 acquire 된 것이 원인이었다. 

1. countpp 시스템 콜 구현을 처음에는 kalloc.c에서 구현하였다. 그런데 walkpgdir 함수가 해당 파일에 정의가 되어있지 않다는 이유로 오류가 발생하였고, 그래서 처음에는 walkpgdir 함수를 다른 파일에도 쓸 수 있게끔 defs.h에 작성하였다. 그런데 이번에는 defs.h에서 walkpgdir 함수 내에서 사용하는 pte_t type이 정의가 안되었다고 해서, pte_t type이 정의되어 있는 mmu.h를 include 시켰으나 헤더끼리 충돌이 일어났다. 결국 countpp 구현을 vm.c에서 하였다.  

# 참고

xv6-public 압축해제하면 환경에 따라 권한이 변경될 때가 있는 것 같습니다..

make하기 전에 chmod 777 -R xv6-public으로 권한 설정해주시면 감사하겠습니다..

한 학기동안 감사했습니다..
