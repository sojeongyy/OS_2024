#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_THREADS 4
#define MAX_NUM 40000000

int arr[MAX_NUM];

int check_sorted(int n)
{
    int i;
    for (i = 0; i < n; i++)
        if (arr[i] != i)
            return 0;
    return 1;
}

// Implement your solution here

void merge(int left, int mid, int right) {
    int i, j, k;
    int n1 = mid - left + 1;
    int n2 = right - mid;

    int L[n1], R[n2];

    for (i = 0; i < n1; i++)
        L[i] = arr[left + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[mid + 1 + j];

    i = 0;
    j = 0;
    k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

void* merge_sort(void* arg) {
    int thread_id = *((int*)arg);
    int chunk_size = MAX_NUM / NUM_THREADS;
    int left = thread_id * chunk_size;
    int right = (thread_id == NUM_THREADS - 1) ? MAX_NUM - 1 : left + chunk_size - 1;

    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort(&left);
        merge_sort(&mid);
        merge_sort(&right);
        merge(left, mid, right);
    }

    pthread_exit(NULL);
}

void* thread_merge(void* arg){
  long tid 


///////////////////////////////

int main(void)
{
    srand((unsigned int)time(NULL));
    const int n = MAX_NUM;
    int i;

    for (i = 0; i < n; i++)
        arr[i] = i;
    for (i = n - 1; i >= 1; i--)
    {
        int j = rand() % (i + 1);
        int t = arr[i];
        arr[i] = arr[j];
        arr[j] = t;
    }

    printf("Sorting %d elements...\n", n);

    // Create threads and execute.
    long t1 = 1, t2 = 2, t3 = 3, t4 = 4;
    pthread_create(&threads[0], NULL, thread_merge, (void *)t1);
    pthread_create(&threads[1], NULL, thread_merge, (void *)t2);
    pthread_create(&threads[2], NULL, thread_merge, (void *)t3);
    pthread_create(&threads[3], NULL, thread_merge, (void *)t4);

    for(i = 0; i<NUM_THREADS; i++){
	pthread_join(threads[i], NULL);
    }

    merge(0, MAX_NUM / 4 - 1, 2*(MAX_NUM / 4)-1);
    merge(2*(MAX_NUM / 4), 3*(MAX_NUM/4)-1, MAX_NUM-1);

    merge(0, 2*(MAX_NUM / 4)-1, MAX_NUM - 1);
    //////////////////////////////

    if (!check_sorted(n))
    {
        printf("Sort failed!\n");
        return 0;
    }

    printf("Ok %d elements sorted\n", n);
    return 0;
}

