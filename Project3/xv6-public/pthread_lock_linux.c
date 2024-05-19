#include <stdio.h>
#include <pthread.h>

int shared_resource = 0;

#define NUM_ITERS 100
#define NUM_THREADS 950

void lock(int tid);
void unlock(int tid);
void init(void);


volatile int selected[NUM_THREADS]; // show if a thread can go to critical section
volatile int ticket[NUM_THREADS]; // thread with min ticket can go to critical section




void init(void) // mutex initializing
{
  for (int i=0; i<NUM_THREADS; i++) {
	selected[i] = 0;
	ticket[i] = 0;
  }
}

int maxticket(volatile int arr[], int size)
{
  int max = 0;
  for (int i=0; i<size; i++) {
	if (arr[i] >= max)
		max = arr[i];
  }

  return max;
}

// show if a thread with tid has to wait
int isWait(int i, int tid)
{
  if (ticket[i] < ticket[tid]) return 1;
  else if (ticket[i] == ticket[tid]) {
	if (i < tid) return 1;
  }

  return 0;
}

void lock(int tid)
{
  selected[tid] = 1;
  ticket[tid] = maxticket(ticket, NUM_THREADS) + 1;
  selected[tid] = 0;

  for (int i=0; i<NUM_THREADS; i++) {
        if (i == tid) continue;

        while (selected[i]); // thread i is selected! so waiting
        while ((ticket[i] != 0) && isWait(i, tid));
  }
}
void unlock(int tid)
{
  ticket[tid] = 0;
}

void* thread_func(void* arg) {
    int tid = *(int*)arg;

    lock(tid);
    
        for(int i = 0; i < NUM_ITERS; i++)    shared_resource++;
    
    unlock(tid);
    
    pthread_exit(NULL);
}

int main() {
    int n = NUM_THREADS;
    pthread_t threads[n];
    int tids[n];
    
    init();

    for (int i = 0; i < n; i++) {
        tids[i] = i;
        pthread_create(&threads[i], NULL, thread_func, &tids[i]);
    }
    
    for (int i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("shared: %d\n", shared_resource);
    
    return 0;
}
