#include <stdio.h>
#include <stdlib.h>
#include <proc.h>


Queue L[4]; //L0, L1, L2, L3

void initializing_Queue(void)
{
  for (int i=0; i<4; i++)
  {
	L[i].time_quantum = 2*i + 2;
	L[i].head = 0;
	L[i].tail = -1;
  }
}

void pushQueue(Queue Queue, struct proc process)
{
  Queue.tail++;
  Queue.Q[Queue->tail] = process;
}


