## 1. Design

구현해야 할 큐는 4개이다. L0, L1, L2, L3이고, 각 큐는 2, 4, 6, 8의 time quantum을 가지고 있다. 
처음 실행된 프로세스는 모두 L0에 들어간다. 
우선 큐의 구조체를 만들어야 할 것이다. 이후 큐 구조체를 요소로 가지는 크기가 4인 배열을 선언하여 큐 4개를 정의한다. 
각 큐에 대한 정보를 먼저 초기화한다. 이를 위해 큐 구조체 내에는 head, tail 뿐만 아니라 time quantum, process 구조체 배열 등이 포함될 것이다. 

큐 내로 프로세스가 push, pop 되므로 먼저 push, pop을 구현하는 함수를 만든다. 이때 큐가 emtpy한지 또는 full한지 확인하는 함수도 구현한다. 

L0, L1, L2 큐는 RR 정책을 따른다. 이때 L0 큐의 RUNNABLE한 process를 스케쥴링한다. L0 큐에 RUNNABLE한 프로세스가 없을 경우, L1의 프로세스를 스케줄링하고, L1에도 없을 경우 L2의 프로세스를 스케쥴링한다. 



## 2. implement
# Queue 
```c
typedef struct Queue
{
    int head; // Q 배열에서 가장 첫번째 프로세스 있는 인덱스, 하나 빠지면 증가 -> 머리부터 하나씩 빠지는 거임
    int tail; // 추가되면 증가
    int time_quantum;
    struct proc *Q[NPROC]; // Queue는 Process 변수로 채워진다!
    int level;             // 0, 1, 2, 3
} *Queue;
```
큐의 push, pop 등을 위한 head, tail 변수를 선언하였다. 또한 각 큐마다 time_quantum이 다르므로 이에 대한 변수도 선언하였으며, 큐 내에 있는 프로세스를 위한 프로세스 배열도 선언하였다. 이때 최대 길이는 NPROC를 이용하여 64이다. 마지막으로 Queue의 level도 선언하였다. 

이러한 queue 구조체를 가지는 크기가 4인 배열을 선언하였다. 
```c
Queue L[4];
```
아래는 각 queue를 초기화해주는 함수이다. 
```c
void initializing_Queue(void)
{
    for (int i = 0; i < 4; i++)
    {
        L[i]->time_quantum = 2 * i + 2;
        L[i]->head = 0;
        L[i]->tail = -1; // 각 L[i] 큐는 비워져있다.
    }
}
```
큐의 push, pop 등의 함수를 보기 전에, process 구조체에 추가한 변수들을 먼저 보자.
```c
typedef struct proc
{
    // uint sz;                     // Size of process memory (bytes)
    // pde_t* pgdir;                // Page table
    char *kstack;            // Bottom of kernel stack for this process
    enum procstate state;    // Process state
    int pid;                 // Process ID
    struct proc *parent;     // Parent process
    struct trapframe *tf;    // Trap frame for current syscall
    struct context *context; // swtch() here to run process
    void *chan;              // If non-zero, sleeping on chan
    int killed;              // If non-zero, have been killed
    // struct file *ofile[NOFILE];  // Open files
    struct inode *cwd; // Current directory
    char name[16];     // Process name (debugging)

    int priority; // 0~10
    int queue_level;
    int current_tick;
};
```
아래 3개가 새로 추가한 변수이다. priority는 L[3] queue에서 사용할 변수이고, queue_level 변수는 해당 프로세스가 존재하는 queue의 level을 가리킨다. 마지막으로 current_tick은 프로세스가 execute 시작된 후 지난 시간을 나타내며, queue의 time_quantum과의 비교를 위해 사용된다. 

이제 Queue와 관련된 함수들을 보자.

```c
int pushQueue(Queue Queue, struct proc *process)
{
    // Queue level의 오류
    if (Queue->level < 0 || Queue->level > 3)
    {
        cprintf("level exceed");
        return -2;
    }
    Queue->tail++;

    // when queue is full
    if (Queue->tail >= NPROC)
    {
        cprintf("Queue is full");
        return -1;
    }
    Queue->Q[Queue->tail] = process;
    process->state = RUNNABLE;
    process->queue_level = Queue->level;
    process->current_tick = 0;
    process->queue_level = Queue->level;

    return 1;
}
```
먼저 queue에 push하는 함수이다. queue가 full하거나 queue level에 오류가 있지 않는 이상, queue의 tail에 프로세스가 하나 추가된다. push가 성공하면, 해당 프로세스의 변수들을 초기화해주고 1을 return한다. 그 외에 level에 오류가 있다면 -2를, queue가 full하다면 -1을 return한다. 

이 pushQueue함수는 allocproc 함수에서 사용된다. 
```c
pushQueue(L[0], p);
```
처음 프로세스가 들어갈 때는 무조건 레벨이 가장 높은 큐(L[0])에 들어간다.


```c
int emptyQueue(Queue Queue)
{
    if (Queue->head > Queue->tail)
    {
        return 1; // empty queue
    }
    return 0;
}

// 특정 큐에 프로세스를 빼주는 함수
int popQueue(Queue Queue)
{
    if (Queue->level < 0 || Queue->level > 3)
    {
        cprintf("level exceed");
        return -2;
    }
    if (emptyQueue(Queue))
    {
        return -1;
    }

    Queue->head++;

    return 1;
}
```
위에는 Queue가 empty한지 확인해주는 함수와 pop하는 함수이다. queue에서 pop할 때 queue의 level에 문제가 있다면 -2를, empty하다면 -1을, 그게 아니면 1을 return한다. 


```c
// time quantum 내에 못 끝낸 process는 다음 큐로 넘어간다.
void moveQueue(Queue Queue, struct proc *process)
{
    // L0에서 이동
    if (Queue->level == 0)
    {
        if (process->pid % 2 == 0)
        {
            pushQueue(L[2], process);
        }
        else
        {
            pushQueue(L[1], process);
        }
    }
    else if (Queue->level == 1 || Queue->level == 2)
    {
        pushQueue(L[3], process);
    }
    process->current_tick = 0;
}
```
마지막으로 queue간의 프로세스 이동을 구현한 함수이다. L[0]에서 이동할 경우, 이동할 프로세스의 pid의 홀짝에 따라 이동하는 queue가 달라진다. L[1] 또는 L[2]에서 이동할 경우 무조건 L[3]으로 이동한다. 프로세스가 이동한 후에는 프로세스의 current_tick을 0으로 초기화해준다.

  
