#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"




int getgpid(void){

        cprintf("My student id is 2022054702\n");
        cprintf("My pid is %d\n", myproc()->pid);
        cprintf("My gpid is %d\n", myproc()->parent->parent->pid); 
	
	return 0;
}

int sys_getgpid(void){
	
	getgpid();
	return 0;
}
