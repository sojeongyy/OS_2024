/*******************************
Copyright 2020011776 Ingyu Bang
DO NOT MODIFY AND SHARE
*******************************/

#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_LOOP 100000
#define NUM_MLOOP 10000
#define NUM_MLOOP2 5000
#define NUM_SLOOP 500
#define NUM_XSLOOP 100
#define NUM_SLEEP 500

#define NUM_QUEUE 5

#define DEBUG 0

#define STD_NUM 2022054702

#define NAME(x) (#x)
#define TEST_EQ_INT(var, val)                                                         \
    if ((var) != (val))                                                               \
    {                                                                                 \
        printf(1, "[ERROR] Expected %d for %s, got %d\n", (val), (NAME(var)), (var)); \
        success = 0;                                                                  \
    };

#define TEST_LE_INT(var, val)                                                                   \
    if ((var) > (val))                                                                          \
    {                                                                                           \
        printf(1, "[ERROR] Expected less than %d for %s, got %d\n", (val), (NAME(var)), (var)); \
        success = 0;                                                                            \
    };

#define TEST_GE_INT(var, val)                                                                      \
    if ((var) < (val))                                                                             \
    {                                                                                              \
        printf(1, "[ERROR] Expected greater than %d for %s, got %d\n", (val), (NAME(var)), (var)); \
        success = 0;                                                                               \
    };

int counter[NUM_QUEUE];
int success = 1;

// Util Functions

void init_test()
{
    success = 1;
    for (int i = 0; i < NUM_QUEUE; i++)
    {
        counter[i] = 0;
    }
}

void init_counter()
{
    for (int i = 0; i < NUM_QUEUE; i++)
    {
        counter[i] = 0;
    }
}

void print_counter()
{
    printf(1, "Process pid %d exited\n", getpid());
    for (int i = 0; i < NUM_QUEUE - 1; i++)
    {
        printf(1, "L%d:  %d\n", i, counter[i]);
    }
    printf(1, "MoQ: %d\n\n", counter[NUM_QUEUE - 1]);
}

void increment_counter()
{
    int lev = getlev();
    if (lev == 99)
        counter[NUM_QUEUE - 1]++;
    else
        counter[lev]++;
}

void quit()
{
    if (DEBUG)
        print_counter();
    exit();
}

// Create Child Processes

int getlev_create_children(int level, int *target)
{
    (*target) = fork();
    if ((*target) < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if ((*target) == 0)
    {
        init_counter();
        for (int i = 0; i < NUM_SLOOP; i++)
        {
            while (getlev() != level)
            {
                yield();
            }

            increment_counter();
        }

        TEST_EQ_INT(getlev(), level);
        if (getlev() != level)
        {
            quit();
            return 0;
        }
        TEST_GE_INT(counter[level], NUM_SLOOP - 10);
        if (counter[level] != NUM_SLOOP)
        {
            quit();
            return 0;
        }

        quit();
    }

    return 1;
}

void setpriority_create_children(int priority, int *target)
{
    (*target) = fork();
    if ((*target) < 0)
    {
        printf(1, "fork failed\n");
        return;
    }

    if ((*target) == 0)
    {
        init_counter();

        for (int i = 0; i < NUM_LOOP; i++)
        {
            setpriority(getpid(), priority);
            increment_counter();
        }

        quit();
    }
}

// Test Group 1 [SYSTEM CALLS]

int test_yield(void)
{
    int pid1, pid2;

    pid1 = fork();

    if (pid1 < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if (pid1 == 0)
    {
        init_counter();
        for (int i = 0; i < NUM_LOOP; i++)
        {
            increment_counter();
            yield();
        }
        quit();
    }

    pid2 = fork();

    if (pid2 < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if (pid2 == 0)
    {
        init_counter();
        for (int i = 0; i < NUM_LOOP; i++)
        {
            increment_counter();
        }
        quit();
    }

    int exited = 0;
    int expected[3] = {pid2, pid1, -1};
    int i = 0;

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        if (exited != expected[i++])
        {
            return 0;
        }
        if (exited == -1)
            break;
    }

    return success;
}

int test_yield_opposite(void)
{
    int pid1, pid2;

    pid1 = fork();

    if (pid1 < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if (pid1 == 0)
    {
        init_counter();
        for (int i = 0; i < NUM_LOOP; i++)
        {
            increment_counter();
        }
        quit();
    }

    pid2 = fork();

    if (pid2 < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if (pid2 == 0)
    {
        init_counter();
        for (int i = 0; i < NUM_LOOP; i++)
        {
            increment_counter();
            yield();
        }
        quit();
    }

    int exited = 0;
    int expected[3] = {pid1, pid2, -1};
    int i = 0;

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        if (exited != expected[i++])
        {
            return 0;
        }
        if (exited == -1)
            break;
    }

    return success;
}

int test_getlev(void)
{
    int pid[4];

    int success = 0;

    for (int i = 0; i < 4; i++)
    {
        if (i == 1)
        {
            if (getpid() & 1)
                success += getlev_create_children(i, &pid[i]);
            else
                success += getlev_create_children(i + 1, &pid[i]);
        }
        else if (i == 2)
        {
            if (getpid() & 1)
                success += getlev_create_children(i, &pid[i]);
            else
                success += getlev_create_children(i - 1, &pid[i]);
        }
        else
        {
            success += getlev_create_children(i, &pid[i]);
        }
    }

    while (wait() != -1)
        ;

    return (success == 4);
}

int test_setpriority(void)
{
    int pid[2];

    setpriority_create_children(0, &pid[0]);
    setpriority_create_children(10, &pid[1]);
    int exited = 0;
    int expected[3] = {pid[1], pid[0], -1};
    int i = 0;

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        if (exited != expected[i++])
        {
            return 0;
        }

        if (exited == -1)
            break;
    }

    return success;
}

int test_monopoly(void)
{
    int pid[3];

    for (int i = 0; i < 3; i++)
    {
        pid[i] = fork();

        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }

        if (pid[i] == 0)
        {
            switch (i)
            {
            case 0:
            case 1:
		sleep(10);
                init_counter();
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    increment_counter();
                }
                quit();
                break;
            case 2:
                init_counter();

                int ret[6];
                ret[0] = setmonopoly(pid[0], STD_NUM);
                ret[1] = setmonopoly(-1, STD_NUM);
                ret[2] = setmonopoly(pid[1], 0);
                ret[3] = setmonopoly(pid[1], STD_NUM);
                //ret[4] = setmonopoly(pid[0], STD_NUM);
                //ret[5] = setmonopoly(getpid(), STD_NUM);

                int expected[4] = {1, -1, -2, 2};
                for (int j = 0; j < 4; j++)
                {
                    TEST_EQ_INT(ret[j], expected[j]);
                    if (ret[j] != expected[j])
                    {
                        monopolize();
                        quit();
                    }
                }

                monopolize();
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    increment_counter();
                }
                quit();
                break;
            }
        }
    }

    int exited = 0;
    int expected[4] = {pid[0], pid[1], pid[2], -1};
    int i = 0;

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        if (exited != expected[i++])
        {
            return 0;
        }

        if (exited == -1)
            break;
    }

    return success;
}

// Test Group 2 [MLFQ Specification]

int test_demote(void)
{
    int pid[3];

    for (int i = 0; i < 2; i++)
    {
        pid[i] = fork();

        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }

        if (pid[i] == 0)
        {
            init_counter();
            for (int j = 0; j < NUM_MLOOP; j++)
            {
                increment_counter();
            }

            if (((getpid() % 2 == 1) && counter[2] > 0) || ((getpid() % 2 == 0) && counter[1] > 0))
            {
                sleep(700);
            }

            quit();
        }
    }

    pid[2] = fork();

    if (pid[2] < 0)
    {
        printf(1, "fork failed\n");
        return 0;
    }

    if (pid[2] == 0)
    {
        sleep(500);
        exit();
    }

    int exited = 0;
    int expected[2] = {pid[2], -1};
    int i = 0;

    exited = wait();
    exited = wait();

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;

        if (exited == -1)
            break;
    }

    return success;
}

int test_roundrobin(void)
{
    int pid[2];

    for (int i = 0; i < 2; i++)
    {
        pid[i] = fork();

        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }

        if (pid[i] == 0)
        {
            init_counter();
            sleep(10); // wait for other process to get ready
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
            {
                sleep(1);
                increment_counter();
            }

            quit();
        }
    }

    int exited = 0;
    int expected[3] = {pid[1], pid[0], -1};
    int i = 0;

    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;

        if (exited == -1)
            break;
    }

    return success;
}

int test_priority_L3()
{
    int pid[2];

    for (int i = 0; i < 2; i++)
    {
        pid[i] = fork();
        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }
        if (pid[i] == 0)
        {
            init_counter();
            sleep(10);
            for (int j = 0; j < (2 * i + 3) * NUM_MLOOP; j++)
            {
                // printf(1, "Process %d: progress: %d/%d\n", getpid(), j, (2*i+3) * NUM_MLOOP);
                int dummy = 0;
                setpriority(getpid(), i + 1);
                while (getlev() != 3)
                {
                    dummy++;
                }
                increment_counter();
            }
            quit();
        }
    }

    int exited = 0;
    int expected[3] = {pid[1], pid[0], -1};

    int i = 0;
    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;
        if (exited == -1)
            break;
    }

    return success;
}

int test_priority_others()
{
    int pid[3];

    for (int i = 0; i < 3; i++)
    {
        pid[i] = fork();
        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }
        if (pid[i] == 0)
        {
            init_counter();
            sleep(10);

            if (i == 0)
            {
                for (int j = 0; j < 5 * NUM_MLOOP; j++)
                {
                    int dummy = 0;
                    while (getlev() != 3)
                    {
                        dummy++;
                    }
                    setpriority(getpid(), 0);
                    increment_counter();
                }
            }
            else if (i == 1)
            {
                for (int j = 0; j < 3 * NUM_MLOOP; j++)
                {
                    int dummy = 0;
                    while (getlev() != 0)
                    {
                        setpriority(getpid(), 5);
                        dummy++;
                    }
                    setpriority(getpid(), 5);
                    increment_counter();
                }
            }
            else if (i == 2)
            {
                for (int j = 0; j < NUM_MLOOP; j++)
                {
                    while (getlev() != 0)
                    {
                        setpriority(getpid(), 10);
                        yield();
                    }
                    setpriority(getpid(), 10);
                    increment_counter();
                }
            }

            quit();
        }
    }

    int exited = 0;
    int expected[4] = {pid[2], pid[1], pid[0], -1};

    int i = 0;
    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;
        if (exited == -1)
            break;
    }

    return success;
}

int test_priority_reduce(void)
{
    int pid[2];

    for (int i = 0; i < 2; i++)
    {
        pid[i] = fork();
        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }
        if (pid[i] == 0)
        {
            init_counter();
            sleep(10);

            if (i == 0)
            {
                setpriority(getpid(), 10);
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    while (getlev() != 3)
                    {
                        yield();
                    }
                    increment_counter();
                }
            }
            else if (i == 1)
            {
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    while (getlev() != 3)
                    {
                        setpriority(getpid(), 5);
                        yield();
                    }
                    setpriority(getpid(), 5);
                    increment_counter();
                }
            }

            quit();
        }
    }

    int exited = 0;
    int expected[4] = {pid[1], pid[0], -1};

    int i = 0;
    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;
        if (exited == -1)
            break;
    }

    return success;
}

// Test Group 3 [MoQ Specification]

int test_sleeping_process(void)
{
    int pid[3];

    for (int i = 0; i < 3; i++)
    {
        pid[i] = fork();
        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }
        if (pid[i] == 0)
        {
            init_counter();

            if (i == 0)
            {
                sleep(10);
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    increment_counter();
                }
            }
            else if (i == 1)
            {
                sleep(5);
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    increment_counter();
                }
            }
            else if (i == 2)
            {
                setmonopoly(pid[0], STD_NUM);
                setmonopoly(pid[1], STD_NUM);
                monopolize();
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    increment_counter();
                }
            }
            quit();
        }
    }

    int exited = 0;
    int expected[4] = {pid[0], pid[1], pid[2], -1};

    int i = 0;
    while ((exited = wait()))
    {
        TEST_EQ_INT(exited, expected[i]);
        i++;
        if (exited == -1)
            break;
    }

    return success;
}

int test_unmonopolize(void)
{
    int pid[10];

    for (int i = 0; i < 9; i++)
    {
        pid[i] = fork();
        if (pid[i] < 0)
        {
            printf(1, "fork failed\n");
            return 0;
        }
        if (pid[i] == 0)
        {
            init_counter();
            if (i==8)
            {
                setmonopoly(pid[0], STD_NUM);
                setmonopoly(pid[2], STD_NUM);
                setmonopoly(pid[4], STD_NUM);
                setmonopoly(pid[6], STD_NUM);
                monopolize();
                for (int j = 0; j < NUM_LOOP; j++)
                {
                    yield();
                    increment_counter();
                }
            }
            else
            {
                if(i&1){
                    sleep(100);
                    for (int j = 0; j < NUM_MLOOP; j++)
                    {
                        yield();
                        increment_counter();
                    }
                    monopolize();
                } else {
                    sleep(10);
                    for (int j = 0; j < NUM_LOOP; j++)
                    {
                        increment_counter();
                    }
                    unmonopolize();
                }
                
            }
            quit();
        }
    }

    int exited = 0;
    int expected[6] = {pid[0], pid[2], pid[4], pid[6], pid[8], -1};

    int i = 0;
    while ((exited = wait()))
    {
        if(i <= 4 && (exited == pid[1] || exited == pid[3] || exited == pid[5] || exited == pid[7])){
            continue;
        }
        TEST_EQ_INT(exited, expected[i]);
        i++;
        if (exited == -1)
            break;
    }

    return success;
}

// Actual Test

void test_group(int gid)
{
    int test_count = 0;
    int test_passed = 0;

    switch (gid)
    {
    case 1:
        printf(1, "======================\n[TEST]\nTest Group 1 [ System Calls ]\n\n");
        test_count = 0;
        test_passed = 0;

        // yield
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 1: yield - 1\n");
        printf(1, "Desc: larger pid should be finished first\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_yield();

        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 2: yield - 2\n");
        printf(1, "Desc: smaller pid should be finished first\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_yield_opposite();

        // getlev
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 3: getlev\n");
        printf(1, "Desc: process should be finished in the order of L0, L1, L2, L3\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_getlev();

        // setpriority
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 4: setpriority\n");
        printf(1, "Desc: pid with higher number should be finished first\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_setpriority();

        // setmonopoly return value
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 5: setmonopoly, monopolize and unmonopolize\n");
        printf(1, "Desc: test if the return values of setmonopoly() is right\nadditionally, test if monopolize() and unmonopolize() works\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_monopoly();

        break;

    case 2:
        printf(1, "======================\n[TEST]\nTest Group 2 [ MLFQ specification ]\n");
        printf(1, "This test group assumes that all system calls are working fine.\n\n");
        test_count = 0;
        test_passed = 0;

        // demotion
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 1: demotion\n");
        printf(1, "Desc: process in L0 should correctly demote to L1 and L2\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_demote();

        // roundrobin
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 2: roundrobin\n");
        printf(1, "Desc: if round robin works correctly shortest job should end first\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_roundrobin();

        // priority L3
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 3: priority L3\n");
        printf(1, "Desc: test if priority works correctly in L3, higher pid has higher priority\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_priority_L3();

        // priority others
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 4: priority others\n");
        printf(1, "Desc: priority should have no effect in other queue\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_priority_others();

        // priority reduce
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 5: priority reduce\n");
        printf(1, "Desc: process's priority should be decreased every time it uses up time quantum\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_priority_reduce();

        break;

    case 3:
        printf(1, "======================\n[TEST]\nTest Group 3 [ MoQ Specification ]\n\n");
        test_count = 0;
        test_passed = 0;

        // sleeping process
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 1: sleeping process\n");
        printf(1, "Desc: MoQ is FCFS, sleeping should not allow next process to run\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_sleeping_process();

        // unmonopolize
        init_test();
        printf(1, "====================================\n");
        printf(1, "Test 2: unmonopolize\n");
        printf(1, "Desc: test if unmonopolize() works\n");
        printf(1, "====================================\n");
        test_count++;
        test_passed += test_unmonopolize();
        break;
    default:
        printf(1, "Invalid test group\n");
        break;
    }

    if (test_count == test_passed)
        printf(1, "[RESULT] PASSED Test Group %d: All tests passed %d/%d.\n", gid, test_passed, test_count);
    else
        printf(1, "[RESULT] FAILED Test Group %d: %d/%d\n", gid, test_passed, test_count);
}

int main(int argc, char *argv[])
{
    test_group(1);
    test_group(2);
    test_group(3);

    exit();
}
