#include <stdio.h>
#include <pthread.h>

int shared_resource = 0;

#define NUM_ITERS 100
#define NUM_THREADS 900

void lock(int tid);
void unlock(int tid);
void init(void);

typedef struct {
  volatile int selected[NUM_THREADS]; // show if a thread can go to critical section
  volatile int ticket[NUM_THREADS]; // thread with min ticket can go to critical section
} mutex_t;

mutex_t mutex;

void init(void) // mutex initializing
{
  for (int i=0; i<NUM_THREADS; i++) {
	mutex.selected[i] = 0;
	mutex.ticket[i] = 0;
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

void lock(int tid)
{
  mutex.selected[tid] = 1;
  mutex.ticket[tid] = maxticket(mutex.ticket, NUM_THREADS) + 1;
  mutex.selected[tid] = 0;

  for (int i=0; i<NUM_THREADS; i++) {
	if (i == tid) continue;

	while (mutex.selected[i]); // thread i is selected! so waiting
	while ((mutex.ticket[i] != 0) && (mutex.ticket[i] < mutex.ticket[tid] || (mutex.ticket[i] == mutex.ticket[tid] && i < tid)));
  }   
}

void unlock(int tid)
{
  mutex.ticket[tid] = 0;
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
