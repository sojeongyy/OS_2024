// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

uint refCount[PHYSTOP / PGSIZE];
uint count_fp;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  count_fp = 0; // initialize countfp to 0
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE) {
    refCount[V2P(p) / PGSIZE] = 0; // 초기화
    kfree(p);
  }
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
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

  if (refCount[V2P(v) / PGSIZE] == 0) { // page free, freelist return
    memset(v, 1, PGSIZE);
    r->next = kmem.freelist;
    count_fp++;
    kmem.freelist = r;
  }

  
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    refCount[V2P((char*)r) / PGSIZE] = 1;
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}

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

int 
get_refc(uint pa)
{
  if (pa >= PHYSTOP || pa < V2P(end))
    panic("reference count failed");
  
  return refCount[pa / PGSIZE];
}

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

/*
int
countvp(void)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  uint sz = curproc->sz;
  uint count = 0;

  uint va;
  for (va = 0; va < sz; va += PGSIZE) {
    if (va >= KERNBASE) continue; // don't include kernel page
  
    pte_t *pte = walkpgdir(pgdir, (char *)va, 0);
    if (pte && ((pte) & PTE_P) && ((pte) & PTE_U))
      count++;
  }

  return count;
}

int
countpp(void)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  uint sz = curproc->sz;
  uint count = 0;

  // look up page table
  for (int i = 0; i < NPDENTRIES; i++) {
    if (pgdir[i] & PTE_P)
      count++;
  }

  return count;
}
*/

int
countptp(void)
{
  struct proc *curproc = myproc();
  pde_t *pgdir = curproc->pgdir;
  uint count = 0;


  for (int i = 0; i < NPDENTRIES; i++) {
        if (pgdir[i] & PTE_P) {
            // 페이지 디렉토리 엔트리가 유효한 경우
            count++;  // 페이지 디렉토리 엔트리를 위해 사용된 페이지 수 증가

            pte_t *pgtab = (pte_t*)P2V(PTE_ADDR(pgdir[i]));  // 페이지 테이블 주소

            // 페이지 테이블 순회
            for (int j = 0; j < NPTENTRIES; j++) {
                if (pgtab[j] & PTE_P) {
                    count++;  // 유효한 페이지 테이블 엔트리를 위해 사용된 페이지 수 증가
                }
            }
        }
    }

    return count;  // 할당된 총 페이지 수 반환
}





