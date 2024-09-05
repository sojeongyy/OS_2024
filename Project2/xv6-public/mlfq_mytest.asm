
_mlfq_mytest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    else
        printf(1, "[RESULT] FAILED Test Group %d: %d/%d\n", gid, test_passed, test_count);
}

int main(int argc, char *argv[])
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 10             	sub    $0x10,%esp
    test_group(1);
      15:	6a 01                	push   $0x1
      17:	e8 a4 13 00 00       	call   13c0 <test_group>
    test_group(2);
      1c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      23:	e8 98 13 00 00       	call   13c0 <test_group>
    test_group(3);
      28:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
      2f:	e8 8c 13 00 00       	call   13c0 <test_group>

    exit();
      34:	e8 9a 1c 00 00       	call   1cd3 <exit>
      39:	66 90                	xchg   %ax,%ax
      3b:	66 90                	xchg   %ax,%ax
      3d:	66 90                	xchg   %ax,%ax
      3f:	90                   	nop

00000040 <init_test>:
{
      40:	f3 0f 1e fb          	endbr32 
    success = 1;
      44:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
      4b:	00 00 00 
        counter[i] = 0;
      4e:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
      55:	00 00 00 
      58:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
      5f:	00 00 00 
      62:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
      69:	00 00 00 
      6c:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
      73:	00 00 00 
      76:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
      7d:	00 00 00 
}
      80:	c3                   	ret    
      81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      8f:	90                   	nop

00000090 <init_counter>:
{
      90:	f3 0f 1e fb          	endbr32 
        counter[i] = 0;
      94:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
      9b:	00 00 00 
      9e:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
      a5:	00 00 00 
      a8:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
      af:	00 00 00 
      b2:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
      b9:	00 00 00 
      bc:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
      c3:	00 00 00 
}
      c6:	c3                   	ret    
      c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ce:	66 90                	xchg   %ax,%ax

000000d0 <print_counter>:
{
      d0:	f3 0f 1e fb          	endbr32 
      d4:	55                   	push   %ebp
      d5:	89 e5                	mov    %esp,%ebp
      d7:	53                   	push   %ebx
    for (int i = 0; i < NUM_QUEUE - 1; i++)
      d8:	31 db                	xor    %ebx,%ebx
{
      da:	83 ec 04             	sub    $0x4,%esp
    printf(1, "Process pid %d exited\n", getpid());
      dd:	e8 71 1c 00 00       	call   1d53 <getpid>
      e2:	83 ec 04             	sub    $0x4,%esp
      e5:	50                   	push   %eax
      e6:	68 d8 21 00 00       	push   $0x21d8
      eb:	6a 01                	push   $0x1
      ed:	e8 7e 1d 00 00       	call   1e70 <printf>
      f2:	83 c4 10             	add    $0x10,%esp
        printf(1, "L%d:  %d\n", i, counter[i]);
      f5:	ff 34 9d b8 2e 00 00 	pushl  0x2eb8(,%ebx,4)
      fc:	53                   	push   %ebx
    for (int i = 0; i < NUM_QUEUE - 1; i++)
      fd:	83 c3 01             	add    $0x1,%ebx
        printf(1, "L%d:  %d\n", i, counter[i]);
     100:	68 ef 21 00 00       	push   $0x21ef
     105:	6a 01                	push   $0x1
     107:	e8 64 1d 00 00       	call   1e70 <printf>
    for (int i = 0; i < NUM_QUEUE - 1; i++)
     10c:	83 c4 10             	add    $0x10,%esp
     10f:	83 fb 04             	cmp    $0x4,%ebx
     112:	75 e1                	jne    f5 <print_counter+0x25>
    printf(1, "MoQ: %d\n\n", counter[NUM_QUEUE - 1]);
     114:	83 ec 04             	sub    $0x4,%esp
     117:	ff 35 c8 2e 00 00    	pushl  0x2ec8
     11d:	68 f9 21 00 00       	push   $0x21f9
     122:	6a 01                	push   $0x1
     124:	e8 47 1d 00 00       	call   1e70 <printf>
}
     129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     12c:	83 c4 10             	add    $0x10,%esp
     12f:	c9                   	leave  
     130:	c3                   	ret    
     131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     13f:	90                   	nop

00000140 <increment_counter>:
{
     140:	f3 0f 1e fb          	endbr32 
     144:	55                   	push   %ebp
     145:	89 e5                	mov    %esp,%ebp
     147:	83 ec 08             	sub    $0x8,%esp
    int lev = getlev();
     14a:	e8 3c 1c 00 00       	call   1d8b <getlev>
    if (lev == 99)
     14f:	83 f8 63             	cmp    $0x63,%eax
     152:	74 0c                	je     160 <increment_counter+0x20>
        counter[lev]++;
     154:	83 04 85 b8 2e 00 00 	addl   $0x1,0x2eb8(,%eax,4)
     15b:	01 
}
     15c:	c9                   	leave  
     15d:	c3                   	ret    
     15e:	66 90                	xchg   %ax,%ax
        counter[NUM_QUEUE - 1]++;
     160:	83 05 c8 2e 00 00 01 	addl   $0x1,0x2ec8
}
     167:	c9                   	leave  
     168:	c3                   	ret    
     169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000170 <quit>:
{
     170:	f3 0f 1e fb          	endbr32 
     174:	55                   	push   %ebp
     175:	89 e5                	mov    %esp,%ebp
     177:	83 ec 08             	sub    $0x8,%esp
    exit();
     17a:	e8 54 1b 00 00       	call   1cd3 <exit>
     17f:	90                   	nop

00000180 <getlev_create_children>:
{
     180:	f3 0f 1e fb          	endbr32 
     184:	55                   	push   %ebp
     185:	89 e5                	mov    %esp,%ebp
     187:	56                   	push   %esi
     188:	53                   	push   %ebx
     189:	8b 5d 08             	mov    0x8(%ebp),%ebx
    (*target) = fork();
     18c:	e8 3a 1b 00 00       	call   1ccb <fork>
     191:	8b 55 0c             	mov    0xc(%ebp),%edx
     194:	89 02                	mov    %eax,(%edx)
    if ((*target) < 0)
     196:	85 c0                	test   %eax,%eax
     198:	0f 88 dc 00 00 00    	js     27a <getlev_create_children+0xfa>
    if ((*target) == 0)
     19e:	0f 85 a1 00 00 00    	jne    245 <getlev_create_children+0xc5>
        counter[i] = 0;
     1a4:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     1ab:	00 00 00 
     1ae:	be f4 01 00 00       	mov    $0x1f4,%esi
     1b3:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     1ba:	00 00 00 
     1bd:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     1c4:	00 00 00 
     1c7:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     1ce:	00 00 00 
     1d1:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     1d8:	00 00 00 
        for (int i = 0; i < NUM_SLOOP; i++)
     1db:	eb 08                	jmp    1e5 <getlev_create_children+0x65>
     1dd:	8d 76 00             	lea    0x0(%esi),%esi
                yield();
     1e0:	e8 9e 1b 00 00       	call   1d83 <yield>
            while (getlev() != level)
     1e5:	e8 a1 1b 00 00       	call   1d8b <getlev>
     1ea:	39 c3                	cmp    %eax,%ebx
     1ec:	75 f2                	jne    1e0 <getlev_create_children+0x60>
            increment_counter();
     1ee:	e8 4d ff ff ff       	call   140 <increment_counter>
        for (int i = 0; i < NUM_SLOOP; i++)
     1f3:	83 ee 01             	sub    $0x1,%esi
     1f6:	75 ed                	jne    1e5 <getlev_create_children+0x65>
        TEST_EQ_INT(getlev(), level);
     1f8:	e8 8e 1b 00 00       	call   1d8b <getlev>
     1fd:	39 c3                	cmp    %eax,%ebx
     1ff:	74 28                	je     229 <getlev_create_children+0xa9>
     201:	e8 85 1b 00 00       	call   1d8b <getlev>
     206:	83 ec 0c             	sub    $0xc,%esp
     209:	50                   	push   %eax
     20a:	68 10 22 00 00       	push   $0x2210
     20f:	53                   	push   %ebx
     210:	68 34 23 00 00       	push   $0x2334
     215:	6a 01                	push   $0x1
     217:	e8 54 1c 00 00       	call   1e70 <printf>
     21c:	83 c4 20             	add    $0x20,%esp
     21f:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     226:	00 00 00 
        if (getlev() != level)
     229:	e8 5d 1b 00 00       	call   1d8b <getlev>
     22e:	39 c3                	cmp    %eax,%ebx
     230:	75 0e                	jne    240 <getlev_create_children+0xc0>
        TEST_GE_INT(counter[level], NUM_SLOOP - 10);
     232:	8b 04 9d b8 2e 00 00 	mov    0x2eb8(,%ebx,4),%eax
     239:	3d e9 01 00 00       	cmp    $0x1e9,%eax
     23e:	7e 11                	jle    251 <getlev_create_children+0xd1>
    exit();
     240:	e8 8e 1a 00 00       	call   1cd3 <exit>
}
     245:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 1;
     248:	b8 01 00 00 00       	mov    $0x1,%eax
}
     24d:	5b                   	pop    %ebx
     24e:	5e                   	pop    %esi
     24f:	5d                   	pop    %ebp
     250:	c3                   	ret    
        TEST_GE_INT(counter[level], NUM_SLOOP - 10);
     251:	83 ec 0c             	sub    $0xc,%esp
     254:	50                   	push   %eax
     255:	68 19 22 00 00       	push   $0x2219
     25a:	68 ea 01 00 00       	push   $0x1ea
     25f:	68 58 23 00 00       	push   $0x2358
     264:	6a 01                	push   $0x1
     266:	e8 05 1c 00 00       	call   1e70 <printf>
     26b:	83 c4 20             	add    $0x20,%esp
     26e:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     275:	00 00 00 
     278:	eb c6                	jmp    240 <getlev_create_children+0xc0>
        printf(1, "fork failed\n");
     27a:	83 ec 08             	sub    $0x8,%esp
     27d:	68 03 22 00 00       	push   $0x2203
     282:	6a 01                	push   $0x1
     284:	e8 e7 1b 00 00       	call   1e70 <printf>
        return 0;
     289:	83 c4 10             	add    $0x10,%esp
}
     28c:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
     28f:	31 c0                	xor    %eax,%eax
}
     291:	5b                   	pop    %ebx
     292:	5e                   	pop    %esi
     293:	5d                   	pop    %ebp
     294:	c3                   	ret    
     295:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002a0 <setpriority_create_children>:
{
     2a0:	f3 0f 1e fb          	endbr32 
     2a4:	55                   	push   %ebp
     2a5:	89 e5                	mov    %esp,%ebp
     2a7:	56                   	push   %esi
     2a8:	53                   	push   %ebx
     2a9:	8b 75 0c             	mov    0xc(%ebp),%esi
     2ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
    (*target) = fork();
     2af:	e8 17 1a 00 00       	call   1ccb <fork>
     2b4:	89 06                	mov    %eax,(%esi)
    if ((*target) < 0)
     2b6:	85 c0                	test   %eax,%eax
     2b8:	78 0e                	js     2c8 <setpriority_create_children+0x28>
    if ((*target) == 0)
     2ba:	74 25                	je     2e1 <setpriority_create_children+0x41>
}
     2bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
     2bf:	5b                   	pop    %ebx
     2c0:	5e                   	pop    %esi
     2c1:	5d                   	pop    %ebp
     2c2:	c3                   	ret    
     2c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     2c7:	90                   	nop
        printf(1, "fork failed\n");
     2c8:	c7 45 0c 03 22 00 00 	movl   $0x2203,0xc(%ebp)
     2cf:	c7 45 08 01 00 00 00 	movl   $0x1,0x8(%ebp)
}
     2d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     2d9:	5b                   	pop    %ebx
     2da:	5e                   	pop    %esi
     2db:	5d                   	pop    %ebp
        printf(1, "fork failed\n");
     2dc:	e9 8f 1b 00 00       	jmp    1e70 <printf>
        counter[i] = 0;
     2e1:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     2e8:	00 00 00 
     2eb:	be a0 86 01 00       	mov    $0x186a0,%esi
     2f0:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     2f7:	00 00 00 
     2fa:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     301:	00 00 00 
     304:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     30b:	00 00 00 
     30e:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     315:	00 00 00 
        for (int i = 0; i < NUM_LOOP; i++)
     318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     31f:	90                   	nop
            setpriority(getpid(), priority);
     320:	e8 2e 1a 00 00       	call   1d53 <getpid>
     325:	83 ec 08             	sub    $0x8,%esp
     328:	53                   	push   %ebx
     329:	50                   	push   %eax
     32a:	e8 64 1a 00 00       	call   1d93 <setpriority>
            increment_counter();
     32f:	e8 0c fe ff ff       	call   140 <increment_counter>
        for (int i = 0; i < NUM_LOOP; i++)
     334:	83 c4 10             	add    $0x10,%esp
     337:	83 ee 01             	sub    $0x1,%esi
     33a:	75 e4                	jne    320 <setpriority_create_children+0x80>
    exit();
     33c:	e8 92 19 00 00       	call   1cd3 <exit>
     341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     34f:	90                   	nop

00000350 <test_yield>:
{
     350:	f3 0f 1e fb          	endbr32 
     354:	55                   	push   %ebp
     355:	89 e5                	mov    %esp,%ebp
     357:	53                   	push   %ebx
     358:	83 ec 14             	sub    $0x14,%esp
    pid1 = fork();
     35b:	e8 6b 19 00 00       	call   1ccb <fork>
    if (pid1 < 0)
     360:	85 c0                	test   %eax,%eax
     362:	0f 88 80 00 00 00    	js     3e8 <test_yield+0x98>
    if (pid1 == 0)
     368:	0f 84 d9 00 00 00    	je     447 <test_yield+0xf7>
     36e:	89 c3                	mov    %eax,%ebx
    pid2 = fork();
     370:	e8 56 19 00 00       	call   1ccb <fork>
    if (pid2 < 0)
     375:	85 c0                	test   %eax,%eax
     377:	78 6f                	js     3e8 <test_yield+0x98>
    if (pid2 == 0)
     379:	0f 84 82 00 00 00    	je     401 <test_yield+0xb1>
    int expected[3] = {pid2, pid1, -1};
     37f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     382:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
     389:	89 5d f0             	mov    %ebx,-0x10(%ebp)
     38c:	8d 5d ec             	lea    -0x14(%ebp),%ebx
     38f:	90                   	nop
    while ((exited = wait()))
     390:	e8 46 19 00 00       	call   1cdb <wait>
     395:	85 c0                	test   %eax,%eax
     397:	74 3f                	je     3d8 <test_yield+0x88>
        TEST_EQ_INT(exited, expected[i]);
     399:	8b 13                	mov    (%ebx),%edx
     39b:	39 c2                	cmp    %eax,%edx
     39d:	74 31                	je     3d0 <test_yield+0x80>
     39f:	83 ec 0c             	sub    $0xc,%esp
     3a2:	50                   	push   %eax
     3a3:	68 28 22 00 00       	push   $0x2228
     3a8:	52                   	push   %edx
     3a9:	68 34 23 00 00       	push   $0x2334
     3ae:	6a 01                	push   $0x1
     3b0:	e8 bb 1a 00 00       	call   1e70 <printf>
}
     3b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        TEST_EQ_INT(exited, expected[i]);
     3b8:	83 c4 20             	add    $0x20,%esp
            return 0;
     3bb:	31 c0                	xor    %eax,%eax
        TEST_EQ_INT(exited, expected[i]);
     3bd:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     3c4:	00 00 00 
}
     3c7:	c9                   	leave  
     3c8:	c3                   	ret    
     3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (exited == -1)
     3d0:	83 c3 04             	add    $0x4,%ebx
     3d3:	83 fa ff             	cmp    $0xffffffff,%edx
     3d6:	75 b8                	jne    390 <test_yield+0x40>
    return success;
     3d8:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     3dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3e0:	c9                   	leave  
     3e1:	c3                   	ret    
     3e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "fork failed\n");
     3e8:	83 ec 08             	sub    $0x8,%esp
     3eb:	68 03 22 00 00       	push   $0x2203
     3f0:	6a 01                	push   $0x1
     3f2:	e8 79 1a 00 00       	call   1e70 <printf>
}
     3f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return 0;
     3fa:	83 c4 10             	add    $0x10,%esp
     3fd:	31 c0                	xor    %eax,%eax
}
     3ff:	c9                   	leave  
     400:	c3                   	ret    
        counter[i] = 0;
     401:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     408:	00 00 00 
     40b:	bb a0 86 01 00       	mov    $0x186a0,%ebx
     410:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     417:	00 00 00 
     41a:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     421:	00 00 00 
     424:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     42b:	00 00 00 
     42e:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     435:	00 00 00 
            increment_counter();
     438:	e8 03 fd ff ff       	call   140 <increment_counter>
        for (int i = 0; i < NUM_LOOP; i++)
     43d:	83 eb 01             	sub    $0x1,%ebx
     440:	75 f6                	jne    438 <test_yield+0xe8>
    exit();
     442:	e8 8c 18 00 00       	call   1cd3 <exit>
        counter[i] = 0;
     447:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     44e:	00 00 00 
     451:	bb a0 86 01 00       	mov    $0x186a0,%ebx
     456:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     45d:	00 00 00 
     460:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     467:	00 00 00 
     46a:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     471:	00 00 00 
     474:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     47b:	00 00 00 
            increment_counter();
     47e:	e8 bd fc ff ff       	call   140 <increment_counter>
            yield();
     483:	e8 fb 18 00 00       	call   1d83 <yield>
        for (int i = 0; i < NUM_LOOP; i++)
     488:	83 eb 01             	sub    $0x1,%ebx
     48b:	75 f1                	jne    47e <test_yield+0x12e>
     48d:	eb b3                	jmp    442 <test_yield+0xf2>
     48f:	90                   	nop

00000490 <test_yield_opposite>:
{
     490:	f3 0f 1e fb          	endbr32 
     494:	55                   	push   %ebp
     495:	89 e5                	mov    %esp,%ebp
     497:	53                   	push   %ebx
     498:	83 ec 14             	sub    $0x14,%esp
    pid1 = fork();
     49b:	e8 2b 18 00 00       	call   1ccb <fork>
    if (pid1 < 0)
     4a0:	85 c0                	test   %eax,%eax
     4a2:	0f 88 80 00 00 00    	js     528 <test_yield_opposite+0x98>
    if (pid1 == 0)
     4a8:	0f 84 de 00 00 00    	je     58c <test_yield_opposite+0xfc>
     4ae:	89 c3                	mov    %eax,%ebx
    pid2 = fork();
     4b0:	e8 16 18 00 00       	call   1ccb <fork>
    if (pid2 < 0)
     4b5:	85 c0                	test   %eax,%eax
     4b7:	78 6f                	js     528 <test_yield_opposite+0x98>
    if (pid2 == 0)
     4b9:	0f 84 82 00 00 00    	je     541 <test_yield_opposite+0xb1>
    int expected[3] = {pid1, pid2, -1};
     4bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
     4c2:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
     4c9:	89 5d ec             	mov    %ebx,-0x14(%ebp)
     4cc:	8d 5d ec             	lea    -0x14(%ebp),%ebx
     4cf:	90                   	nop
    while ((exited = wait()))
     4d0:	e8 06 18 00 00       	call   1cdb <wait>
     4d5:	85 c0                	test   %eax,%eax
     4d7:	74 3f                	je     518 <test_yield_opposite+0x88>
        TEST_EQ_INT(exited, expected[i]);
     4d9:	8b 13                	mov    (%ebx),%edx
     4db:	39 c2                	cmp    %eax,%edx
     4dd:	74 31                	je     510 <test_yield_opposite+0x80>
     4df:	83 ec 0c             	sub    $0xc,%esp
     4e2:	50                   	push   %eax
     4e3:	68 28 22 00 00       	push   $0x2228
     4e8:	52                   	push   %edx
     4e9:	68 34 23 00 00       	push   $0x2334
     4ee:	6a 01                	push   $0x1
     4f0:	e8 7b 19 00 00       	call   1e70 <printf>
}
     4f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        TEST_EQ_INT(exited, expected[i]);
     4f8:	83 c4 20             	add    $0x20,%esp
            return 0;
     4fb:	31 c0                	xor    %eax,%eax
        TEST_EQ_INT(exited, expected[i]);
     4fd:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     504:	00 00 00 
}
     507:	c9                   	leave  
     508:	c3                   	ret    
     509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (exited == -1)
     510:	83 c3 04             	add    $0x4,%ebx
     513:	83 fa ff             	cmp    $0xffffffff,%edx
     516:	75 b8                	jne    4d0 <test_yield_opposite+0x40>
    return success;
     518:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     51d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     520:	c9                   	leave  
     521:	c3                   	ret    
     522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "fork failed\n");
     528:	83 ec 08             	sub    $0x8,%esp
     52b:	68 03 22 00 00       	push   $0x2203
     530:	6a 01                	push   $0x1
     532:	e8 39 19 00 00       	call   1e70 <printf>
}
     537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return 0;
     53a:	83 c4 10             	add    $0x10,%esp
     53d:	31 c0                	xor    %eax,%eax
}
     53f:	c9                   	leave  
     540:	c3                   	ret    
        counter[i] = 0;
     541:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     548:	00 00 00 
     54b:	bb a0 86 01 00       	mov    $0x186a0,%ebx
     550:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     557:	00 00 00 
     55a:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     561:	00 00 00 
     564:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     56b:	00 00 00 
     56e:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     575:	00 00 00 
            increment_counter();
     578:	e8 c3 fb ff ff       	call   140 <increment_counter>
            yield();
     57d:	e8 01 18 00 00       	call   1d83 <yield>
        for (int i = 0; i < NUM_LOOP; i++)
     582:	83 eb 01             	sub    $0x1,%ebx
     585:	75 f1                	jne    578 <test_yield_opposite+0xe8>
    exit();
     587:	e8 47 17 00 00       	call   1cd3 <exit>
        counter[i] = 0;
     58c:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     593:	00 00 00 
     596:	bb a0 86 01 00       	mov    $0x186a0,%ebx
     59b:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     5a2:	00 00 00 
     5a5:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     5ac:	00 00 00 
     5af:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     5b6:	00 00 00 
     5b9:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     5c0:	00 00 00 
            increment_counter();
     5c3:	e8 78 fb ff ff       	call   140 <increment_counter>
        for (int i = 0; i < NUM_LOOP; i++)
     5c8:	83 eb 01             	sub    $0x1,%ebx
     5cb:	75 f6                	jne    5c3 <test_yield_opposite+0x133>
     5cd:	eb b8                	jmp    587 <test_yield_opposite+0xf7>
     5cf:	90                   	nop

000005d0 <test_getlev>:
{
     5d0:	f3 0f 1e fb          	endbr32 
     5d4:	55                   	push   %ebp
     5d5:	89 e5                	mov    %esp,%ebp
     5d7:	56                   	push   %esi
    int success = 0;
     5d8:	31 f6                	xor    %esi,%esi
{
     5da:	53                   	push   %ebx
     5db:	31 db                	xor    %ebx,%ebx
     5dd:	83 ec 10             	sub    $0x10,%esp
        if (i == 1)
     5e0:	83 fb 01             	cmp    $0x1,%ebx
     5e3:	74 25                	je     60a <test_getlev+0x3a>
        else if (i == 2)
     5e5:	83 fb 02             	cmp    $0x2,%ebx
     5e8:	74 56                	je     640 <test_getlev+0x70>
            success += getlev_create_children(i, &pid[i]);
     5ea:	83 ec 08             	sub    $0x8,%esp
     5ed:	8d 44 9d e8          	lea    -0x18(%ebp,%ebx,4),%eax
     5f1:	50                   	push   %eax
     5f2:	53                   	push   %ebx
     5f3:	e8 88 fb ff ff       	call   180 <getlev_create_children>
    for (int i = 0; i < 4; i++)
     5f8:	83 c4 10             	add    $0x10,%esp
            success += getlev_create_children(i, &pid[i]);
     5fb:	01 c6                	add    %eax,%esi
    for (int i = 0; i < 4; i++)
     5fd:	83 fb 03             	cmp    $0x3,%ebx
     600:	74 1e                	je     620 <test_getlev+0x50>
     602:	83 c3 01             	add    $0x1,%ebx
        if (i == 1)
     605:	83 fb 01             	cmp    $0x1,%ebx
     608:	75 db                	jne    5e5 <test_getlev+0x15>
            if (getpid() & 1)
     60a:	e8 44 17 00 00       	call   1d53 <getpid>
     60f:	a8 01                	test   $0x1,%al
     611:	74 65                	je     678 <test_getlev+0xa8>
                success += getlev_create_children(i, &pid[i]);
     613:	83 ec 08             	sub    $0x8,%esp
     616:	8d 45 ec             	lea    -0x14(%ebp),%eax
     619:	eb 4b                	jmp    666 <test_getlev+0x96>
     61b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     61f:	90                   	nop
    while (wait() != -1)
     620:	e8 b6 16 00 00       	call   1cdb <wait>
     625:	83 f8 ff             	cmp    $0xffffffff,%eax
     628:	75 f6                	jne    620 <test_getlev+0x50>
    return (success == 4);
     62a:	31 c0                	xor    %eax,%eax
     62c:	83 fe 04             	cmp    $0x4,%esi
     62f:	0f 94 c0             	sete   %al
}
     632:	8d 65 f8             	lea    -0x8(%ebp),%esp
     635:	5b                   	pop    %ebx
     636:	5e                   	pop    %esi
     637:	5d                   	pop    %ebp
     638:	c3                   	ret    
     639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (getpid() & 1)
     640:	e8 0e 17 00 00       	call   1d53 <getpid>
     645:	a8 01                	test   $0x1,%al
     647:	74 17                	je     660 <test_getlev+0x90>
                success += getlev_create_children(i, &pid[i]);
     649:	83 ec 08             	sub    $0x8,%esp
     64c:	8d 45 f0             	lea    -0x10(%ebp),%eax
     64f:	50                   	push   %eax
     650:	6a 02                	push   $0x2
     652:	e8 29 fb ff ff       	call   180 <getlev_create_children>
     657:	83 c4 10             	add    $0x10,%esp
     65a:	01 c6                	add    %eax,%esi
     65c:	eb a4                	jmp    602 <test_getlev+0x32>
     65e:	66 90                	xchg   %ax,%ax
                success += getlev_create_children(i - 1, &pid[i]);
     660:	83 ec 08             	sub    $0x8,%esp
     663:	8d 45 f0             	lea    -0x10(%ebp),%eax
     666:	50                   	push   %eax
     667:	6a 01                	push   $0x1
     669:	e8 12 fb ff ff       	call   180 <getlev_create_children>
     66e:	83 c4 10             	add    $0x10,%esp
     671:	01 c6                	add    %eax,%esi
     673:	eb 8d                	jmp    602 <test_getlev+0x32>
     675:	8d 76 00             	lea    0x0(%esi),%esi
                success += getlev_create_children(i + 1, &pid[i]);
     678:	83 ec 08             	sub    $0x8,%esp
     67b:	8d 45 ec             	lea    -0x14(%ebp),%eax
     67e:	eb cf                	jmp    64f <test_getlev+0x7f>

00000680 <test_setpriority>:
{
     680:	f3 0f 1e fb          	endbr32 
     684:	55                   	push   %ebp
     685:	89 e5                	mov    %esp,%ebp
     687:	53                   	push   %ebx
    setpriority_create_children(0, &pid[0]);
     688:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     68b:	8d 5d ec             	lea    -0x14(%ebp),%ebx
{
     68e:	83 ec 2c             	sub    $0x2c,%esp
    setpriority_create_children(0, &pid[0]);
     691:	50                   	push   %eax
     692:	6a 00                	push   $0x0
     694:	e8 07 fc ff ff       	call   2a0 <setpriority_create_children>
    setpriority_create_children(10, &pid[1]);
     699:	58                   	pop    %eax
     69a:	8d 45 e8             	lea    -0x18(%ebp),%eax
     69d:	5a                   	pop    %edx
     69e:	50                   	push   %eax
     69f:	6a 0a                	push   $0xa
     6a1:	e8 fa fb ff ff       	call   2a0 <setpriority_create_children>
    int expected[3] = {pid[1], pid[0], -1};
     6a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6a9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    while ((exited = wait()))
     6b0:	83 c4 10             	add    $0x10,%esp
    int expected[3] = {pid[1], pid[0], -1};
     6b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while ((exited = wait()))
     6c0:	e8 16 16 00 00       	call   1cdb <wait>
     6c5:	85 c0                	test   %eax,%eax
     6c7:	74 3f                	je     708 <test_setpriority+0x88>
        TEST_EQ_INT(exited, expected[i]);
     6c9:	8b 13                	mov    (%ebx),%edx
     6cb:	39 c2                	cmp    %eax,%edx
     6cd:	74 31                	je     700 <test_setpriority+0x80>
     6cf:	83 ec 0c             	sub    $0xc,%esp
     6d2:	50                   	push   %eax
     6d3:	68 28 22 00 00       	push   $0x2228
     6d8:	52                   	push   %edx
     6d9:	68 34 23 00 00       	push   $0x2334
     6de:	6a 01                	push   $0x1
     6e0:	e8 8b 17 00 00       	call   1e70 <printf>
}
     6e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        TEST_EQ_INT(exited, expected[i]);
     6e8:	83 c4 20             	add    $0x20,%esp
            return 0;
     6eb:	31 c0                	xor    %eax,%eax
        TEST_EQ_INT(exited, expected[i]);
     6ed:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     6f4:	00 00 00 
}
     6f7:	c9                   	leave  
     6f8:	c3                   	ret    
     6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (exited == -1)
     700:	83 c3 04             	add    $0x4,%ebx
     703:	83 fa ff             	cmp    $0xffffffff,%edx
     706:	75 b8                	jne    6c0 <test_setpriority+0x40>
    return success;
     708:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     70d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     710:	c9                   	leave  
     711:	c3                   	ret    
     712:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000720 <test_monopoly>:
{
     720:	f3 0f 1e fb          	endbr32 
     724:	55                   	push   %ebp
     725:	89 e5                	mov    %esp,%ebp
     727:	57                   	push   %edi
     728:	56                   	push   %esi
    for (int i = 0; i < 3; i++)
     729:	31 f6                	xor    %esi,%esi
{
     72b:	53                   	push   %ebx
     72c:	83 ec 4c             	sub    $0x4c,%esp
        pid[i] = fork();
     72f:	e8 97 15 00 00       	call   1ccb <fork>
     734:	89 44 b5 b4          	mov    %eax,-0x4c(%ebp,%esi,4)
     738:	89 c3                	mov    %eax,%ebx
        if (pid[i] < 0)
     73a:	85 c0                	test   %eax,%eax
     73c:	0f 88 86 00 00 00    	js     7c8 <test_monopoly+0xa8>
        if (pid[i] == 0)
     742:	0f 84 98 00 00 00    	je     7e0 <test_monopoly+0xc0>
    for (int i = 0; i < 3; i++)
     748:	83 c6 01             	add    $0x1,%esi
     74b:	83 fe 03             	cmp    $0x3,%esi
     74e:	75 df                	jne    72f <test_monopoly+0xf>
    int expected[4] = {pid[0], pid[1], pid[2], -1};
     750:	8b 45 b4             	mov    -0x4c(%ebp),%eax
     753:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
    while ((exited = wait()))
     75a:	8d 5d d0             	lea    -0x30(%ebp),%ebx
    int expected[4] = {pid[0], pid[1], pid[2], -1};
     75d:	89 45 d0             	mov    %eax,-0x30(%ebp)
     760:	8b 45 b8             	mov    -0x48(%ebp),%eax
     763:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     766:	8b 45 bc             	mov    -0x44(%ebp),%eax
     769:	89 45 d8             	mov    %eax,-0x28(%ebp)
     76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while ((exited = wait()))
     770:	e8 66 15 00 00       	call   1cdb <wait>
     775:	85 c0                	test   %eax,%eax
     777:	74 3f                	je     7b8 <test_monopoly+0x98>
        TEST_EQ_INT(exited, expected[i]);
     779:	8b 13                	mov    (%ebx),%edx
     77b:	39 c2                	cmp    %eax,%edx
     77d:	74 31                	je     7b0 <test_monopoly+0x90>
     77f:	83 ec 0c             	sub    $0xc,%esp
     782:	50                   	push   %eax
     783:	68 28 22 00 00       	push   $0x2228
     788:	52                   	push   %edx
     789:	68 34 23 00 00       	push   $0x2334
     78e:	6a 01                	push   $0x1
     790:	e8 db 16 00 00       	call   1e70 <printf>
     795:	83 c4 20             	add    $0x20,%esp
            return 0;
     798:	31 c0                	xor    %eax,%eax
        TEST_EQ_INT(exited, expected[i]);
     79a:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     7a1:	00 00 00 
}
     7a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7a7:	5b                   	pop    %ebx
     7a8:	5e                   	pop    %esi
     7a9:	5f                   	pop    %edi
     7aa:	5d                   	pop    %ebp
     7ab:	c3                   	ret    
     7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (exited == -1)
     7b0:	83 c3 04             	add    $0x4,%ebx
     7b3:	83 fa ff             	cmp    $0xffffffff,%edx
     7b6:	75 b8                	jne    770 <test_monopoly+0x50>
    return success;
     7b8:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     7bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7c0:	5b                   	pop    %ebx
     7c1:	5e                   	pop    %esi
     7c2:	5f                   	pop    %edi
     7c3:	5d                   	pop    %ebp
     7c4:	c3                   	ret    
     7c5:	8d 76 00             	lea    0x0(%esi),%esi
            printf(1, "fork failed\n");
     7c8:	83 ec 08             	sub    $0x8,%esp
     7cb:	68 03 22 00 00       	push   $0x2203
     7d0:	6a 01                	push   $0x1
     7d2:	e8 99 16 00 00       	call   1e70 <printf>
            return 0;
     7d7:	83 c4 10             	add    $0x10,%esp
     7da:	31 c0                	xor    %eax,%eax
     7dc:	eb c6                	jmp    7a4 <test_monopoly+0x84>
     7de:	66 90                	xchg   %ax,%ax
            switch (i)
     7e0:	83 fe 02             	cmp    $0x2,%esi
     7e3:	0f 85 f3 00 00 00    	jne    8dc <test_monopoly+0x1bc>
        counter[i] = 0;
     7e9:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     7f0:	00 00 00 
                ret[0] = setmonopoly(pid[0], STD_NUM);
     7f3:	83 ec 08             	sub    $0x8,%esp
     7f6:	68 2e 1b 86 78       	push   $0x78861b2e
     7fb:	ff 75 b4             	pushl  -0x4c(%ebp)
        counter[i] = 0;
     7fe:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     805:	00 00 00 
     808:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     80f:	00 00 00 
     812:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     819:	00 00 00 
     81c:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     823:	00 00 00 
                ret[0] = setmonopoly(pid[0], STD_NUM);
     826:	e8 70 15 00 00       	call   1d9b <setmonopoly>
     82b:	89 c6                	mov    %eax,%esi
                ret[1] = setmonopoly(-1, STD_NUM);
     82d:	58                   	pop    %eax
     82e:	5a                   	pop    %edx
     82f:	68 2e 1b 86 78       	push   $0x78861b2e
     834:	6a ff                	push   $0xffffffff
     836:	e8 60 15 00 00       	call   1d9b <setmonopoly>
                ret[2] = setmonopoly(pid[1], 0);
     83b:	8b 7d b8             	mov    -0x48(%ebp),%edi
     83e:	59                   	pop    %ecx
                ret[1] = setmonopoly(-1, STD_NUM);
     83f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                ret[2] = setmonopoly(pid[1], 0);
     842:	58                   	pop    %eax
     843:	6a 00                	push   $0x0
     845:	57                   	push   %edi
     846:	e8 50 15 00 00       	call   1d9b <setmonopoly>
     84b:	89 45 d8             	mov    %eax,-0x28(%ebp)
                ret[3] = setmonopoly(pid[1], STD_NUM);
     84e:	58                   	pop    %eax
     84f:	5a                   	pop    %edx
     850:	68 2e 1b 86 78       	push   $0x78861b2e
     855:	57                   	push   %edi
     856:	e8 40 15 00 00       	call   1d9b <setmonopoly>
                int expected[4] = {1, -1, -2, 2};
     85b:	c7 45 c4 ff ff ff ff 	movl   $0xffffffff,-0x3c(%ebp)
     862:	83 c4 10             	add    $0x10,%esp
     865:	c7 45 c8 fe ff ff ff 	movl   $0xfffffffe,-0x38(%ebp)
     86c:	c7 45 cc 02 00 00 00 	movl   $0x2,-0x34(%ebp)
                ret[3] = setmonopoly(pid[1], STD_NUM);
     873:	89 45 dc             	mov    %eax,-0x24(%ebp)
                int expected[4] = {1, -1, -2, 2};
     876:	b8 01 00 00 00       	mov    $0x1,%eax
                    TEST_EQ_INT(ret[j], expected[j]);
     87b:	39 f0                	cmp    %esi,%eax
     87d:	74 31                	je     8b0 <test_monopoly+0x190>
     87f:	83 ec 0c             	sub    $0xc,%esp
     882:	56                   	push   %esi
     883:	68 2f 22 00 00       	push   $0x222f
     888:	50                   	push   %eax
     889:	68 34 23 00 00       	push   $0x2334
     88e:	6a 01                	push   $0x1
     890:	e8 db 15 00 00       	call   1e70 <printf>
                        monopolize();
     895:	83 c4 20             	add    $0x20,%esp
                    TEST_EQ_INT(ret[j], expected[j]);
     898:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     89f:	00 00 00 
                        monopolize();
     8a2:	e8 fc 14 00 00       	call   1da3 <monopolize>
    exit();
     8a7:	e8 27 14 00 00       	call   1cd3 <exit>
     8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                for (int j = 0; j < 4; j++)
     8b0:	83 c3 01             	add    $0x1,%ebx
     8b3:	83 fb 04             	cmp    $0x4,%ebx
     8b6:	74 0a                	je     8c2 <test_monopoly+0x1a2>
     8b8:	8b 74 9d d0          	mov    -0x30(%ebp,%ebx,4),%esi
     8bc:	8b 44 9d c0          	mov    -0x40(%ebp,%ebx,4),%eax
     8c0:	eb b9                	jmp    87b <test_monopoly+0x15b>
                monopolize();
     8c2:	e8 dc 14 00 00       	call   1da3 <monopolize>
     8c7:	bb a0 86 01 00       	mov    $0x186a0,%ebx
     8cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                    increment_counter();
     8d0:	e8 6b f8 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
     8d5:	83 eb 01             	sub    $0x1,%ebx
     8d8:	75 f6                	jne    8d0 <test_monopoly+0x1b0>
     8da:	eb cb                	jmp    8a7 <test_monopoly+0x187>
		sleep(10);
     8dc:	83 ec 0c             	sub    $0xc,%esp
        counter[i] = 0;
     8df:	bb a0 86 01 00       	mov    $0x186a0,%ebx
		sleep(10);
     8e4:	6a 0a                	push   $0xa
     8e6:	e8 78 14 00 00       	call   1d63 <sleep>
        counter[i] = 0;
     8eb:	83 c4 10             	add    $0x10,%esp
     8ee:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     8f5:	00 00 00 
     8f8:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     8ff:	00 00 00 
     902:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     909:	00 00 00 
     90c:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     913:	00 00 00 
     916:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     91d:	00 00 00 
                    increment_counter();
     920:	e8 1b f8 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
     925:	83 eb 01             	sub    $0x1,%ebx
     928:	75 f6                	jne    920 <test_monopoly+0x200>
     92a:	e9 78 ff ff ff       	jmp    8a7 <test_monopoly+0x187>
     92f:	90                   	nop

00000930 <test_demote>:
{
     930:	f3 0f 1e fb          	endbr32 
     934:	55                   	push   %ebp
     935:	89 e5                	mov    %esp,%ebp
     937:	56                   	push   %esi
     938:	53                   	push   %ebx
     939:	83 ec 10             	sub    $0x10,%esp
        pid[i] = fork();
     93c:	e8 8a 13 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     941:	85 c0                	test   %eax,%eax
     943:	0f 88 97 00 00 00    	js     9e0 <test_demote+0xb0>
        if (pid[i] == 0)
     949:	0f 84 ac 00 00 00    	je     9fb <test_demote+0xcb>
        pid[i] = fork();
     94f:	e8 77 13 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     954:	85 c0                	test   %eax,%eax
     956:	0f 88 84 00 00 00    	js     9e0 <test_demote+0xb0>
        if (pid[i] == 0)
     95c:	0f 84 99 00 00 00    	je     9fb <test_demote+0xcb>
    pid[2] = fork();
     962:	e8 64 13 00 00       	call   1ccb <fork>
    if (pid[2] < 0)
     967:	85 c0                	test   %eax,%eax
     969:	78 75                	js     9e0 <test_demote+0xb0>
    if (pid[2] == 0)
     96b:	0f 84 0f 01 00 00    	je     a80 <test_demote+0x150>
    int expected[2] = {pid[2], -1};
     971:	89 45 f0             	mov    %eax,-0x10(%ebp)
     974:	8d 75 f0             	lea    -0x10(%ebp),%esi
     977:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    exited = wait();
     97e:	e8 58 13 00 00       	call   1cdb <wait>
    exited = wait();
     983:	e8 53 13 00 00       	call   1cdb <wait>
    while ((exited = wait()))
     988:	eb 37                	jmp    9c1 <test_demote+0x91>
     98a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        TEST_EQ_INT(exited, expected[i]);
     990:	8b 06                	mov    (%esi),%eax
     992:	39 d8                	cmp    %ebx,%eax
     994:	74 23                	je     9b9 <test_demote+0x89>
     996:	83 ec 0c             	sub    $0xc,%esp
     999:	53                   	push   %ebx
     99a:	68 28 22 00 00       	push   $0x2228
     99f:	50                   	push   %eax
     9a0:	68 34 23 00 00       	push   $0x2334
     9a5:	6a 01                	push   $0x1
     9a7:	e8 c4 14 00 00       	call   1e70 <printf>
     9ac:	83 c4 20             	add    $0x20,%esp
     9af:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     9b6:	00 00 00 
        if (exited == -1)
     9b9:	83 c6 04             	add    $0x4,%esi
     9bc:	83 fb ff             	cmp    $0xffffffff,%ebx
     9bf:	74 0b                	je     9cc <test_demote+0x9c>
    while ((exited = wait()))
     9c1:	e8 15 13 00 00       	call   1cdb <wait>
     9c6:	89 c3                	mov    %eax,%ebx
     9c8:	85 c0                	test   %eax,%eax
     9ca:	75 c4                	jne    990 <test_demote+0x60>
    return success;
     9cc:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     9d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
     9d4:	5b                   	pop    %ebx
     9d5:	5e                   	pop    %esi
     9d6:	5d                   	pop    %ebp
     9d7:	c3                   	ret    
     9d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9df:	90                   	nop
            printf(1, "fork failed\n");
     9e0:	83 ec 08             	sub    $0x8,%esp
     9e3:	68 03 22 00 00       	push   $0x2203
     9e8:	6a 01                	push   $0x1
     9ea:	e8 81 14 00 00       	call   1e70 <printf>
            return 0;
     9ef:	83 c4 10             	add    $0x10,%esp
}
     9f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 0;
     9f5:	31 c0                	xor    %eax,%eax
}
     9f7:	5b                   	pop    %ebx
     9f8:	5e                   	pop    %esi
     9f9:	5d                   	pop    %ebp
     9fa:	c3                   	ret    
        counter[i] = 0;
     9fb:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     a02:	00 00 00 
     a05:	bb 10 27 00 00       	mov    $0x2710,%ebx
     a0a:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     a11:	00 00 00 
     a14:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     a1b:	00 00 00 
     a1e:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     a25:	00 00 00 
     a28:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     a2f:	00 00 00 
                increment_counter();
     a32:	e8 09 f7 ff ff       	call   140 <increment_counter>
            for (int j = 0; j < NUM_MLOOP; j++)
     a37:	83 eb 01             	sub    $0x1,%ebx
     a3a:	75 f6                	jne    a32 <test_demote+0x102>
            if (((getpid() % 2 == 1) && counter[2] > 0) || ((getpid() % 2 == 0) && counter[1] > 0))
     a3c:	e8 12 13 00 00       	call   1d53 <getpid>
     a41:	b9 02 00 00 00       	mov    $0x2,%ecx
     a46:	99                   	cltd   
     a47:	f7 f9                	idiv   %ecx
     a49:	83 ea 01             	sub    $0x1,%edx
     a4c:	75 1e                	jne    a6c <test_demote+0x13c>
     a4e:	83 3d c0 2e 00 00 00 	cmpl   $0x0,0x2ec0
     a55:	7e 15                	jle    a6c <test_demote+0x13c>
                sleep(700);
     a57:	83 ec 0c             	sub    $0xc,%esp
     a5a:	68 bc 02 00 00       	push   $0x2bc
     a5f:	e8 ff 12 00 00       	call   1d63 <sleep>
     a64:	83 c4 10             	add    $0x10,%esp
    exit();
     a67:	e8 67 12 00 00       	call   1cd3 <exit>
            if (((getpid() % 2 == 1) && counter[2] > 0) || ((getpid() % 2 == 0) && counter[1] > 0))
     a6c:	e8 e2 12 00 00       	call   1d53 <getpid>
     a71:	a8 01                	test   $0x1,%al
     a73:	75 f2                	jne    a67 <test_demote+0x137>
     a75:	83 3d bc 2e 00 00 00 	cmpl   $0x0,0x2ebc
     a7c:	7f d9                	jg     a57 <test_demote+0x127>
     a7e:	eb e7                	jmp    a67 <test_demote+0x137>
        sleep(500);
     a80:	83 ec 0c             	sub    $0xc,%esp
     a83:	68 f4 01 00 00       	push   $0x1f4
     a88:	e8 d6 12 00 00       	call   1d63 <sleep>
        exit();
     a8d:	e8 41 12 00 00       	call   1cd3 <exit>
     a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000aa0 <test_roundrobin>:
{
     aa0:	f3 0f 1e fb          	endbr32 
     aa4:	55                   	push   %ebp
     aa5:	89 e5                	mov    %esp,%ebp
     aa7:	56                   	push   %esi
     aa8:	53                   	push   %ebx
     aa9:	83 ec 10             	sub    $0x10,%esp
        pid[i] = fork();
     aac:	e8 1a 12 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     ab1:	85 c0                	test   %eax,%eax
     ab3:	78 73                	js     b28 <test_roundrobin+0x88>
     ab5:	89 c3                	mov    %eax,%ebx
        if (pid[i] == 0)
     ab7:	0f 84 86 00 00 00    	je     b43 <test_roundrobin+0xa3>
        pid[i] = fork();
     abd:	e8 09 12 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     ac2:	85 c0                	test   %eax,%eax
     ac4:	78 62                	js     b28 <test_roundrobin+0x88>
        if (pid[i] == 0)
     ac6:	74 76                	je     b3e <test_roundrobin+0x9e>
    int expected[3] = {pid[1], pid[0], -1};
     ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     acb:	8d 75 ec             	lea    -0x14(%ebp),%esi
     ace:	89 5d f0             	mov    %ebx,-0x10(%ebp)
     ad1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    while ((exited = wait()))
     ad8:	eb 37                	jmp    b11 <test_roundrobin+0x71>
     ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        TEST_EQ_INT(exited, expected[i]);
     ae0:	8b 06                	mov    (%esi),%eax
     ae2:	39 d8                	cmp    %ebx,%eax
     ae4:	74 23                	je     b09 <test_roundrobin+0x69>
     ae6:	83 ec 0c             	sub    $0xc,%esp
     ae9:	53                   	push   %ebx
     aea:	68 28 22 00 00       	push   $0x2228
     aef:	50                   	push   %eax
     af0:	68 34 23 00 00       	push   $0x2334
     af5:	6a 01                	push   $0x1
     af7:	e8 74 13 00 00       	call   1e70 <printf>
     afc:	83 c4 20             	add    $0x20,%esp
     aff:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     b06:	00 00 00 
        if (exited == -1)
     b09:	83 c6 04             	add    $0x4,%esi
     b0c:	83 fb ff             	cmp    $0xffffffff,%ebx
     b0f:	74 0b                	je     b1c <test_roundrobin+0x7c>
    while ((exited = wait()))
     b11:	e8 c5 11 00 00       	call   1cdb <wait>
     b16:	89 c3                	mov    %eax,%ebx
     b18:	85 c0                	test   %eax,%eax
     b1a:	75 c4                	jne    ae0 <test_roundrobin+0x40>
    return success;
     b1c:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b24:	5b                   	pop    %ebx
     b25:	5e                   	pop    %esi
     b26:	5d                   	pop    %ebp
     b27:	c3                   	ret    
            printf(1, "fork failed\n");
     b28:	83 ec 08             	sub    $0x8,%esp
     b2b:	68 03 22 00 00       	push   $0x2203
     b30:	6a 01                	push   $0x1
     b32:	e8 39 13 00 00       	call   1e70 <printf>
            return 0;
     b37:	83 c4 10             	add    $0x10,%esp
     b3a:	31 c0                	xor    %eax,%eax
     b3c:	eb e3                	jmp    b21 <test_roundrobin+0x81>
    for (int i = 0; i < 2; i++)
     b3e:	bb 01 00 00 00       	mov    $0x1,%ebx
            sleep(10); // wait for other process to get ready
     b43:	83 ec 0c             	sub    $0xc,%esp
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
     b46:	83 c3 01             	add    $0x1,%ebx
     b49:	31 f6                	xor    %esi,%esi
        counter[i] = 0;
     b4b:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     b52:	00 00 00 
            sleep(10); // wait for other process to get ready
     b55:	6a 0a                	push   $0xa
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
     b57:	0f af db             	imul   %ebx,%ebx
        counter[i] = 0;
     b5a:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     b61:	00 00 00 
     b64:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     b6b:	00 00 00 
     b6e:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     b75:	00 00 00 
     b78:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     b7f:	00 00 00 
            sleep(10); // wait for other process to get ready
     b82:	e8 dc 11 00 00       	call   1d63 <sleep>
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
     b87:	b8 05 00 00 00       	mov    $0x5,%eax
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	29 d8                	sub    %ebx,%eax
     b91:	69 d8 f4 01 00 00    	imul   $0x1f4,%eax,%ebx
                sleep(1);
     b97:	83 ec 0c             	sub    $0xc,%esp
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
     b9a:	83 c6 01             	add    $0x1,%esi
                sleep(1);
     b9d:	6a 01                	push   $0x1
     b9f:	e8 bf 11 00 00       	call   1d63 <sleep>
                increment_counter();
     ba4:	e8 97 f5 ff ff       	call   140 <increment_counter>
            for (int j = 0; j < (5 - (i + 1) * (i + 1)) * NUM_SLOOP; j++)
     ba9:	83 c4 10             	add    $0x10,%esp
     bac:	39 f3                	cmp    %esi,%ebx
     bae:	75 e7                	jne    b97 <test_roundrobin+0xf7>
    exit();
     bb0:	e8 1e 11 00 00       	call   1cd3 <exit>
     bb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000bc0 <test_priority_L3>:
{
     bc0:	f3 0f 1e fb          	endbr32 
     bc4:	55                   	push   %ebp
     bc5:	89 e5                	mov    %esp,%ebp
     bc7:	57                   	push   %edi
     bc8:	56                   	push   %esi
     bc9:	53                   	push   %ebx
     bca:	83 ec 1c             	sub    $0x1c,%esp
        pid[i] = fork();
     bcd:	e8 f9 10 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     bd2:	85 c0                	test   %eax,%eax
     bd4:	78 73                	js     c49 <test_priority_L3+0x89>
     bd6:	89 c3                	mov    %eax,%ebx
        if (pid[i] == 0)
     bd8:	0f 84 86 00 00 00    	je     c64 <test_priority_L3+0xa4>
        pid[i] = fork();
     bde:	e8 e8 10 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     be3:	85 c0                	test   %eax,%eax
     be5:	78 62                	js     c49 <test_priority_L3+0x89>
        if (pid[i] == 0)
     be7:	74 76                	je     c5f <test_priority_L3+0x9f>
    int expected[3] = {pid[1], pid[0], -1};
     be9:	89 45 dc             	mov    %eax,-0x24(%ebp)
     bec:	8d 75 dc             	lea    -0x24(%ebp),%esi
     bef:	89 5d e0             	mov    %ebx,-0x20(%ebp)
     bf2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
    while ((exited = wait()))
     bf9:	eb 36                	jmp    c31 <test_priority_L3+0x71>
     bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     bff:	90                   	nop
        TEST_EQ_INT(exited, expected[i]);
     c00:	8b 06                	mov    (%esi),%eax
     c02:	39 d8                	cmp    %ebx,%eax
     c04:	74 23                	je     c29 <test_priority_L3+0x69>
     c06:	83 ec 0c             	sub    $0xc,%esp
     c09:	53                   	push   %ebx
     c0a:	68 28 22 00 00       	push   $0x2228
     c0f:	50                   	push   %eax
     c10:	68 34 23 00 00       	push   $0x2334
     c15:	6a 01                	push   $0x1
     c17:	e8 54 12 00 00       	call   1e70 <printf>
     c1c:	83 c4 20             	add    $0x20,%esp
     c1f:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     c26:	00 00 00 
        if (exited == -1)
     c29:	83 c6 04             	add    $0x4,%esi
     c2c:	83 fb ff             	cmp    $0xffffffff,%ebx
     c2f:	74 0b                	je     c3c <test_priority_L3+0x7c>
    while ((exited = wait()))
     c31:	e8 a5 10 00 00       	call   1cdb <wait>
     c36:	89 c3                	mov    %eax,%ebx
     c38:	85 c0                	test   %eax,%eax
     c3a:	75 c4                	jne    c00 <test_priority_L3+0x40>
    return success;
     c3c:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c44:	5b                   	pop    %ebx
     c45:	5e                   	pop    %esi
     c46:	5f                   	pop    %edi
     c47:	5d                   	pop    %ebp
     c48:	c3                   	ret    
            printf(1, "fork failed\n");
     c49:	83 ec 08             	sub    $0x8,%esp
     c4c:	68 03 22 00 00       	push   $0x2203
     c51:	6a 01                	push   $0x1
     c53:	e8 18 12 00 00       	call   1e70 <printf>
            return 0;
     c58:	83 c4 10             	add    $0x10,%esp
     c5b:	31 c0                	xor    %eax,%eax
     c5d:	eb e2                	jmp    c41 <test_priority_L3+0x81>
    for (int i = 0; i < 2; i++)
     c5f:	bb 01 00 00 00       	mov    $0x1,%ebx
            sleep(10);
     c64:	83 ec 0c             	sub    $0xc,%esp
            for (int j = 0; j < (2 * i + 3) * NUM_MLOOP; j++)
     c67:	8d 34 1b             	lea    (%ebx,%ebx,1),%esi
     c6a:	31 ff                	xor    %edi,%edi
        counter[i] = 0;
     c6c:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     c73:	00 00 00 
            sleep(10);
     c76:	6a 0a                	push   $0xa
            for (int j = 0; j < (2 * i + 3) * NUM_MLOOP; j++)
     c78:	83 c6 03             	add    $0x3,%esi
     c7b:	83 c3 01             	add    $0x1,%ebx
     c7e:	69 f6 10 27 00 00    	imul   $0x2710,%esi,%esi
        counter[i] = 0;
     c84:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     c8b:	00 00 00 
     c8e:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     c95:	00 00 00 
     c98:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     c9f:	00 00 00 
     ca2:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     ca9:	00 00 00 
            sleep(10);
     cac:	e8 b2 10 00 00       	call   1d63 <sleep>
            for (int j = 0; j < (2 * i + 3) * NUM_MLOOP; j++)
     cb1:	83 c4 10             	add    $0x10,%esp
                setpriority(getpid(), i + 1);
     cb4:	e8 9a 10 00 00       	call   1d53 <getpid>
     cb9:	83 ec 08             	sub    $0x8,%esp
     cbc:	53                   	push   %ebx
     cbd:	50                   	push   %eax
     cbe:	e8 d0 10 00 00       	call   1d93 <setpriority>
                while (getlev() != 3)
     cc3:	83 c4 10             	add    $0x10,%esp
     cc6:	e8 c0 10 00 00       	call   1d8b <getlev>
     ccb:	83 f8 03             	cmp    $0x3,%eax
     cce:	75 f6                	jne    cc6 <test_priority_L3+0x106>
                increment_counter();
     cd0:	e8 6b f4 ff ff       	call   140 <increment_counter>
            for (int j = 0; j < (2 * i + 3) * NUM_MLOOP; j++)
     cd5:	83 c7 01             	add    $0x1,%edi
     cd8:	39 f7                	cmp    %esi,%edi
     cda:	75 d8                	jne    cb4 <test_priority_L3+0xf4>
    exit();
     cdc:	e8 f2 0f 00 00       	call   1cd3 <exit>
     ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cef:	90                   	nop

00000cf0 <test_priority_others>:
{
     cf0:	f3 0f 1e fb          	endbr32 
     cf4:	55                   	push   %ebp
     cf5:	89 e5                	mov    %esp,%ebp
     cf7:	56                   	push   %esi
     cf8:	53                   	push   %ebx
    for (int i = 0; i < 3; i++)
     cf9:	31 db                	xor    %ebx,%ebx
{
     cfb:	83 ec 20             	sub    $0x20,%esp
        pid[i] = fork();
     cfe:	e8 c8 0f 00 00       	call   1ccb <fork>
     d03:	89 44 9d dc          	mov    %eax,-0x24(%ebp,%ebx,4)
        if (pid[i] < 0)
     d07:	85 c0                	test   %eax,%eax
     d09:	0f 88 81 00 00 00    	js     d90 <test_priority_others+0xa0>
        if (pid[i] == 0)
     d0f:	0f 84 91 00 00 00    	je     da6 <test_priority_others+0xb6>
    for (int i = 0; i < 3; i++)
     d15:	83 c3 01             	add    $0x1,%ebx
     d18:	83 fb 03             	cmp    $0x3,%ebx
     d1b:	75 e1                	jne    cfe <test_priority_others+0xe>
    int expected[4] = {pid[2], pid[1], pid[0], -1};
     d1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d20:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    while ((exited = wait()))
     d27:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int expected[4] = {pid[2], pid[1], pid[0], -1};
     d2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d33:	8b 45 dc             	mov    -0x24(%ebp),%eax
     d36:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((exited = wait()))
     d39:	eb 36                	jmp    d71 <test_priority_others+0x81>
     d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d3f:	90                   	nop
        TEST_EQ_INT(exited, expected[i]);
     d40:	8b 06                	mov    (%esi),%eax
     d42:	39 d8                	cmp    %ebx,%eax
     d44:	74 23                	je     d69 <test_priority_others+0x79>
     d46:	83 ec 0c             	sub    $0xc,%esp
     d49:	53                   	push   %ebx
     d4a:	68 28 22 00 00       	push   $0x2228
     d4f:	50                   	push   %eax
     d50:	68 34 23 00 00       	push   $0x2334
     d55:	6a 01                	push   $0x1
     d57:	e8 14 11 00 00       	call   1e70 <printf>
     d5c:	83 c4 20             	add    $0x20,%esp
     d5f:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     d66:	00 00 00 
        if (exited == -1)
     d69:	83 c6 04             	add    $0x4,%esi
     d6c:	83 fb ff             	cmp    $0xffffffff,%ebx
     d6f:	74 0b                	je     d7c <test_priority_others+0x8c>
    while ((exited = wait()))
     d71:	e8 65 0f 00 00       	call   1cdb <wait>
     d76:	89 c3                	mov    %eax,%ebx
     d78:	85 c0                	test   %eax,%eax
     d7a:	75 c4                	jne    d40 <test_priority_others+0x50>
    return success;
     d7c:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d84:	5b                   	pop    %ebx
     d85:	5e                   	pop    %esi
     d86:	5d                   	pop    %ebp
     d87:	c3                   	ret    
     d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d8f:	90                   	nop
            printf(1, "fork failed\n");
     d90:	83 ec 08             	sub    $0x8,%esp
     d93:	68 03 22 00 00       	push   $0x2203
     d98:	6a 01                	push   $0x1
     d9a:	e8 d1 10 00 00       	call   1e70 <printf>
            return 0;
     d9f:	83 c4 10             	add    $0x10,%esp
     da2:	31 c0                	xor    %eax,%eax
     da4:	eb db                	jmp    d81 <test_priority_others+0x91>
        counter[i] = 0;
     da6:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     dad:	00 00 00 
            sleep(10);
     db0:	83 ec 0c             	sub    $0xc,%esp
     db3:	6a 0a                	push   $0xa
        counter[i] = 0;
     db5:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     dbc:	00 00 00 
     dbf:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     dc6:	00 00 00 
     dc9:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     dd0:	00 00 00 
     dd3:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     dda:	00 00 00 
            sleep(10);
     ddd:	e8 81 0f 00 00       	call   1d63 <sleep>
            if (i == 0)
     de2:	83 c4 10             	add    $0x10,%esp
     de5:	85 db                	test   %ebx,%ebx
     de7:	75 33                	jne    e1c <test_priority_others+0x12c>
     de9:	bb 50 c3 00 00       	mov    $0xc350,%ebx
     dee:	66 90                	xchg   %ax,%ax
                    while (getlev() != 3)
     df0:	e8 96 0f 00 00       	call   1d8b <getlev>
     df5:	83 f8 03             	cmp    $0x3,%eax
     df8:	75 f6                	jne    df0 <test_priority_others+0x100>
                    setpriority(getpid(), 0);
     dfa:	e8 54 0f 00 00       	call   1d53 <getpid>
     dff:	83 ec 08             	sub    $0x8,%esp
     e02:	6a 00                	push   $0x0
     e04:	50                   	push   %eax
     e05:	e8 89 0f 00 00       	call   1d93 <setpriority>
                    increment_counter();
     e0a:	e8 31 f3 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < 5 * NUM_MLOOP; j++)
     e0f:	83 c4 10             	add    $0x10,%esp
     e12:	83 eb 01             	sub    $0x1,%ebx
     e15:	75 d9                	jne    df0 <test_priority_others+0x100>
    exit();
     e17:	e8 b7 0e 00 00       	call   1cd3 <exit>
            else if (i == 1)
     e1c:	83 eb 01             	sub    $0x1,%ebx
     e1f:	74 4f                	je     e70 <test_priority_others+0x180>
     e21:	bb 10 27 00 00       	mov    $0x2710,%ebx
     e26:	eb 20                	jmp    e48 <test_priority_others+0x158>
     e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e2f:	90                   	nop
                        setpriority(getpid(), 10);
     e30:	e8 1e 0f 00 00       	call   1d53 <getpid>
     e35:	83 ec 08             	sub    $0x8,%esp
     e38:	6a 0a                	push   $0xa
     e3a:	50                   	push   %eax
     e3b:	e8 53 0f 00 00       	call   1d93 <setpriority>
                        yield();
     e40:	e8 3e 0f 00 00       	call   1d83 <yield>
     e45:	83 c4 10             	add    $0x10,%esp
                    while (getlev() != 0)
     e48:	e8 3e 0f 00 00       	call   1d8b <getlev>
     e4d:	85 c0                	test   %eax,%eax
     e4f:	75 df                	jne    e30 <test_priority_others+0x140>
                    setpriority(getpid(), 10);
     e51:	e8 fd 0e 00 00       	call   1d53 <getpid>
     e56:	83 ec 08             	sub    $0x8,%esp
     e59:	6a 0a                	push   $0xa
     e5b:	50                   	push   %eax
     e5c:	e8 32 0f 00 00       	call   1d93 <setpriority>
                    increment_counter();
     e61:	e8 da f2 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_MLOOP; j++)
     e66:	83 c4 10             	add    $0x10,%esp
     e69:	83 eb 01             	sub    $0x1,%ebx
     e6c:	75 da                	jne    e48 <test_priority_others+0x158>
     e6e:	eb a7                	jmp    e17 <test_priority_others+0x127>
     e70:	bb 30 75 00 00       	mov    $0x7530,%ebx
     e75:	eb 1c                	jmp    e93 <test_priority_others+0x1a3>
     e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e7e:	66 90                	xchg   %ax,%ax
                        setpriority(getpid(), 5);
     e80:	e8 ce 0e 00 00       	call   1d53 <getpid>
     e85:	83 ec 08             	sub    $0x8,%esp
     e88:	6a 05                	push   $0x5
     e8a:	50                   	push   %eax
     e8b:	e8 03 0f 00 00       	call   1d93 <setpriority>
     e90:	83 c4 10             	add    $0x10,%esp
                    while (getlev() != 0)
     e93:	e8 f3 0e 00 00       	call   1d8b <getlev>
     e98:	85 c0                	test   %eax,%eax
     e9a:	75 e4                	jne    e80 <test_priority_others+0x190>
                    setpriority(getpid(), 5);
     e9c:	e8 b2 0e 00 00       	call   1d53 <getpid>
     ea1:	83 ec 08             	sub    $0x8,%esp
     ea4:	6a 05                	push   $0x5
     ea6:	50                   	push   %eax
     ea7:	e8 e7 0e 00 00       	call   1d93 <setpriority>
                    increment_counter();
     eac:	e8 8f f2 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < 3 * NUM_MLOOP; j++)
     eb1:	83 c4 10             	add    $0x10,%esp
     eb4:	83 eb 01             	sub    $0x1,%ebx
     eb7:	75 da                	jne    e93 <test_priority_others+0x1a3>
     eb9:	e9 59 ff ff ff       	jmp    e17 <test_priority_others+0x127>
     ebe:	66 90                	xchg   %ax,%ax

00000ec0 <test_priority_reduce>:
{
     ec0:	f3 0f 1e fb          	endbr32 
     ec4:	55                   	push   %ebp
     ec5:	89 e5                	mov    %esp,%ebp
     ec7:	56                   	push   %esi
     ec8:	53                   	push   %ebx
     ec9:	83 ec 10             	sub    $0x10,%esp
        pid[i] = fork();
     ecc:	e8 fa 0d 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     ed1:	85 c0                	test   %eax,%eax
     ed3:	78 7b                	js     f50 <test_priority_reduce+0x90>
        if (pid[i] == 0)
     ed5:	0f 84 19 01 00 00    	je     ff4 <test_priority_reduce+0x134>
     edb:	89 c3                	mov    %eax,%ebx
        pid[i] = fork();
     edd:	e8 e9 0d 00 00       	call   1ccb <fork>
        if (pid[i] < 0)
     ee2:	85 c0                	test   %eax,%eax
     ee4:	78 6a                	js     f50 <test_priority_reduce+0x90>
        if (pid[i] == 0)
     ee6:	74 7e                	je     f66 <test_priority_reduce+0xa6>
    int expected[4] = {pid[1], pid[0], -1};
     ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eef:	8d 75 e8             	lea    -0x18(%ebp),%esi
     ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ef5:	89 5d ec             	mov    %ebx,-0x14(%ebp)
     ef8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
    while ((exited = wait()))
     eff:	eb 38                	jmp    f39 <test_priority_reduce+0x79>
     f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        TEST_EQ_INT(exited, expected[i]);
     f08:	8b 06                	mov    (%esi),%eax
     f0a:	39 d8                	cmp    %ebx,%eax
     f0c:	74 23                	je     f31 <test_priority_reduce+0x71>
     f0e:	83 ec 0c             	sub    $0xc,%esp
     f11:	53                   	push   %ebx
     f12:	68 28 22 00 00       	push   $0x2228
     f17:	50                   	push   %eax
     f18:	68 34 23 00 00       	push   $0x2334
     f1d:	6a 01                	push   $0x1
     f1f:	e8 4c 0f 00 00       	call   1e70 <printf>
     f24:	83 c4 20             	add    $0x20,%esp
     f27:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
     f2e:	00 00 00 
        if (exited == -1)
     f31:	83 c6 04             	add    $0x4,%esi
     f34:	83 fb ff             	cmp    $0xffffffff,%ebx
     f37:	74 0b                	je     f44 <test_priority_reduce+0x84>
    while ((exited = wait()))
     f39:	e8 9d 0d 00 00       	call   1cdb <wait>
     f3e:	89 c3                	mov    %eax,%ebx
     f40:	85 c0                	test   %eax,%eax
     f42:	75 c4                	jne    f08 <test_priority_reduce+0x48>
    return success;
     f44:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
     f49:	8d 65 f8             	lea    -0x8(%ebp),%esp
     f4c:	5b                   	pop    %ebx
     f4d:	5e                   	pop    %esi
     f4e:	5d                   	pop    %ebp
     f4f:	c3                   	ret    
            printf(1, "fork failed\n");
     f50:	83 ec 08             	sub    $0x8,%esp
     f53:	68 03 22 00 00       	push   $0x2203
     f58:	6a 01                	push   $0x1
     f5a:	e8 11 0f 00 00       	call   1e70 <printf>
            return 0;
     f5f:	83 c4 10             	add    $0x10,%esp
     f62:	31 c0                	xor    %eax,%eax
     f64:	eb e3                	jmp    f49 <test_priority_reduce+0x89>
            sleep(10);
     f66:	83 ec 0c             	sub    $0xc,%esp
     f69:	bb a0 86 01 00       	mov    $0x186a0,%ebx
        counter[i] = 0;
     f6e:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
     f75:	00 00 00 
            sleep(10);
     f78:	6a 0a                	push   $0xa
        counter[i] = 0;
     f7a:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
     f81:	00 00 00 
     f84:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
     f8b:	00 00 00 
     f8e:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
     f95:	00 00 00 
     f98:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
     f9f:	00 00 00 
            sleep(10);
     fa2:	e8 bc 0d 00 00       	call   1d63 <sleep>
     fa7:	83 c4 10             	add    $0x10,%esp
     faa:	eb 1c                	jmp    fc8 <test_priority_reduce+0x108>
     fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                        setpriority(getpid(), 5);
     fb0:	e8 9e 0d 00 00       	call   1d53 <getpid>
     fb5:	83 ec 08             	sub    $0x8,%esp
     fb8:	6a 05                	push   $0x5
     fba:	50                   	push   %eax
     fbb:	e8 d3 0d 00 00       	call   1d93 <setpriority>
                        yield();
     fc0:	e8 be 0d 00 00       	call   1d83 <yield>
     fc5:	83 c4 10             	add    $0x10,%esp
                    while (getlev() != 3)
     fc8:	e8 be 0d 00 00       	call   1d8b <getlev>
     fcd:	83 f8 03             	cmp    $0x3,%eax
     fd0:	75 de                	jne    fb0 <test_priority_reduce+0xf0>
                    setpriority(getpid(), 5);
     fd2:	e8 7c 0d 00 00       	call   1d53 <getpid>
     fd7:	83 ec 08             	sub    $0x8,%esp
     fda:	6a 05                	push   $0x5
     fdc:	50                   	push   %eax
     fdd:	e8 b1 0d 00 00       	call   1d93 <setpriority>
                    increment_counter();
     fe2:	e8 59 f1 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
     fe7:	83 c4 10             	add    $0x10,%esp
     fea:	83 eb 01             	sub    $0x1,%ebx
     fed:	75 d9                	jne    fc8 <test_priority_reduce+0x108>
    exit();
     fef:	e8 df 0c 00 00       	call   1cd3 <exit>
            sleep(10);
     ff4:	83 ec 0c             	sub    $0xc,%esp
                setpriority(getpid(), 10);
     ff7:	bb a0 86 01 00       	mov    $0x186a0,%ebx
        counter[i] = 0;
     ffc:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1003:	00 00 00 
            sleep(10);
    1006:	6a 0a                	push   $0xa
        counter[i] = 0;
    1008:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    100f:	00 00 00 
    1012:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1019:	00 00 00 
    101c:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1023:	00 00 00 
    1026:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    102d:	00 00 00 
            sleep(10);
    1030:	e8 2e 0d 00 00       	call   1d63 <sleep>
                setpriority(getpid(), 10);
    1035:	e8 19 0d 00 00       	call   1d53 <getpid>
    103a:	5a                   	pop    %edx
    103b:	59                   	pop    %ecx
    103c:	6a 0a                	push   $0xa
    103e:	50                   	push   %eax
    103f:	e8 4f 0d 00 00       	call   1d93 <setpriority>
    1044:	83 c4 10             	add    $0x10,%esp
    1047:	eb 0c                	jmp    1055 <test_priority_reduce+0x195>
    1049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        yield();
    1050:	e8 2e 0d 00 00       	call   1d83 <yield>
                    while (getlev() != 3)
    1055:	e8 31 0d 00 00       	call   1d8b <getlev>
    105a:	83 f8 03             	cmp    $0x3,%eax
    105d:	75 f1                	jne    1050 <test_priority_reduce+0x190>
                    increment_counter();
    105f:	e8 dc f0 ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
    1064:	83 eb 01             	sub    $0x1,%ebx
    1067:	75 ec                	jne    1055 <test_priority_reduce+0x195>
    1069:	eb 84                	jmp    fef <test_priority_reduce+0x12f>
    106b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    106f:	90                   	nop

00001070 <test_sleeping_process>:
{
    1070:	f3 0f 1e fb          	endbr32 
    1074:	55                   	push   %ebp
    1075:	89 e5                	mov    %esp,%ebp
    1077:	56                   	push   %esi
    1078:	53                   	push   %ebx
    for (int i = 0; i < 3; i++)
    1079:	31 db                	xor    %ebx,%ebx
{
    107b:	83 ec 20             	sub    $0x20,%esp
        pid[i] = fork();
    107e:	e8 48 0c 00 00       	call   1ccb <fork>
    1083:	89 44 9d dc          	mov    %eax,-0x24(%ebp,%ebx,4)
        if (pid[i] < 0)
    1087:	85 c0                	test   %eax,%eax
    1089:	0f 88 81 00 00 00    	js     1110 <test_sleeping_process+0xa0>
        if (pid[i] == 0)
    108f:	0f 84 91 00 00 00    	je     1126 <test_sleeping_process+0xb6>
    for (int i = 0; i < 3; i++)
    1095:	83 c3 01             	add    $0x1,%ebx
    1098:	83 fb 03             	cmp    $0x3,%ebx
    109b:	75 e1                	jne    107e <test_sleeping_process+0xe>
    int expected[4] = {pid[0], pid[1], pid[2], -1};
    109d:	8b 45 dc             	mov    -0x24(%ebp),%eax
    10a0:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
    while ((exited = wait()))
    10a7:	8d 75 e8             	lea    -0x18(%ebp),%esi
    int expected[4] = {pid[0], pid[1], pid[2], -1};
    10aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    10ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
    10b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while ((exited = wait()))
    10b9:	eb 36                	jmp    10f1 <test_sleeping_process+0x81>
    10bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10bf:	90                   	nop
        TEST_EQ_INT(exited, expected[i]);
    10c0:	8b 06                	mov    (%esi),%eax
    10c2:	39 d8                	cmp    %ebx,%eax
    10c4:	74 23                	je     10e9 <test_sleeping_process+0x79>
    10c6:	83 ec 0c             	sub    $0xc,%esp
    10c9:	53                   	push   %ebx
    10ca:	68 28 22 00 00       	push   $0x2228
    10cf:	50                   	push   %eax
    10d0:	68 34 23 00 00       	push   $0x2334
    10d5:	6a 01                	push   $0x1
    10d7:	e8 94 0d 00 00       	call   1e70 <printf>
    10dc:	83 c4 20             	add    $0x20,%esp
    10df:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
    10e6:	00 00 00 
        if (exited == -1)
    10e9:	83 c6 04             	add    $0x4,%esi
    10ec:	83 fb ff             	cmp    $0xffffffff,%ebx
    10ef:	74 0b                	je     10fc <test_sleeping_process+0x8c>
    while ((exited = wait()))
    10f1:	e8 e5 0b 00 00       	call   1cdb <wait>
    10f6:	89 c3                	mov    %eax,%ebx
    10f8:	85 c0                	test   %eax,%eax
    10fa:	75 c4                	jne    10c0 <test_sleeping_process+0x50>
    return success;
    10fc:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
    1101:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1104:	5b                   	pop    %ebx
    1105:	5e                   	pop    %esi
    1106:	5d                   	pop    %ebp
    1107:	c3                   	ret    
    1108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    110f:	90                   	nop
            printf(1, "fork failed\n");
    1110:	83 ec 08             	sub    $0x8,%esp
    1113:	68 03 22 00 00       	push   $0x2203
    1118:	6a 01                	push   $0x1
    111a:	e8 51 0d 00 00       	call   1e70 <printf>
            return 0;
    111f:	83 c4 10             	add    $0x10,%esp
    1122:	31 c0                	xor    %eax,%eax
    1124:	eb db                	jmp    1101 <test_sleeping_process+0x91>
        counter[i] = 0;
    1126:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    112d:	00 00 00 
    1130:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1137:	00 00 00 
    113a:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1141:	00 00 00 
    1144:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    114b:	00 00 00 
    114e:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1155:	00 00 00 
            if (i == 0)
    1158:	85 db                	test   %ebx,%ebx
    115a:	74 5d                	je     11b9 <test_sleeping_process+0x149>
            else if (i == 1)
    115c:	83 eb 01             	sub    $0x1,%ebx
    115f:	74 3a                	je     119b <test_sleeping_process+0x12b>
                setmonopoly(pid[0], STD_NUM);
    1161:	50                   	push   %eax
                monopolize();
    1162:	bb a0 86 01 00       	mov    $0x186a0,%ebx
                setmonopoly(pid[0], STD_NUM);
    1167:	50                   	push   %eax
    1168:	68 2e 1b 86 78       	push   $0x78861b2e
    116d:	ff 75 dc             	pushl  -0x24(%ebp)
    1170:	e8 26 0c 00 00       	call   1d9b <setmonopoly>
                setmonopoly(pid[1], STD_NUM);
    1175:	5a                   	pop    %edx
    1176:	59                   	pop    %ecx
    1177:	68 2e 1b 86 78       	push   $0x78861b2e
    117c:	ff 75 e0             	pushl  -0x20(%ebp)
    117f:	e8 17 0c 00 00       	call   1d9b <setmonopoly>
                monopolize();
    1184:	e8 1a 0c 00 00       	call   1da3 <monopolize>
    1189:	83 c4 10             	add    $0x10,%esp
                    increment_counter();
    118c:	e8 af ef ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
    1191:	83 eb 01             	sub    $0x1,%ebx
    1194:	75 f6                	jne    118c <test_sleeping_process+0x11c>
    exit();
    1196:	e8 38 0b 00 00       	call   1cd3 <exit>
                sleep(5);
    119b:	83 ec 0c             	sub    $0xc,%esp
    119e:	bb a0 86 01 00       	mov    $0x186a0,%ebx
    11a3:	6a 05                	push   $0x5
    11a5:	e8 b9 0b 00 00       	call   1d63 <sleep>
    11aa:	83 c4 10             	add    $0x10,%esp
                    increment_counter();
    11ad:	e8 8e ef ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
    11b2:	83 eb 01             	sub    $0x1,%ebx
    11b5:	75 f6                	jne    11ad <test_sleeping_process+0x13d>
    11b7:	eb dd                	jmp    1196 <test_sleeping_process+0x126>
                sleep(10);
    11b9:	83 ec 0c             	sub    $0xc,%esp
    11bc:	bb a0 86 01 00       	mov    $0x186a0,%ebx
    11c1:	6a 0a                	push   $0xa
    11c3:	e8 9b 0b 00 00       	call   1d63 <sleep>
    11c8:	83 c4 10             	add    $0x10,%esp
                    increment_counter();
    11cb:	e8 70 ef ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
    11d0:	83 eb 01             	sub    $0x1,%ebx
    11d3:	75 f6                	jne    11cb <test_sleeping_process+0x15b>
    11d5:	eb bf                	jmp    1196 <test_sleeping_process+0x126>
    11d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11de:	66 90                	xchg   %ax,%ax

000011e0 <test_unmonopolize>:
{
    11e0:	f3 0f 1e fb          	endbr32 
    11e4:	55                   	push   %ebp
    11e5:	89 e5                	mov    %esp,%ebp
    11e7:	56                   	push   %esi
    11e8:	53                   	push   %ebx
    for (int i = 0; i < 9; i++)
    11e9:	31 db                	xor    %ebx,%ebx
{
    11eb:	83 ec 40             	sub    $0x40,%esp
    11ee:	66 90                	xchg   %ax,%ax
        pid[i] = fork();
    11f0:	e8 d6 0a 00 00       	call   1ccb <fork>
    11f5:	89 44 9d d0          	mov    %eax,-0x30(%ebp,%ebx,4)
        if (pid[i] < 0)
    11f9:	85 c0                	test   %eax,%eax
    11fb:	0f 88 a7 00 00 00    	js     12a8 <test_unmonopolize+0xc8>
        if (pid[i] == 0)
    1201:	0f 84 bc 00 00 00    	je     12c3 <test_unmonopolize+0xe3>
    for (int i = 0; i < 9; i++)
    1207:	83 c3 01             	add    $0x1,%ebx
    120a:	83 fb 09             	cmp    $0x9,%ebx
    120d:	75 e1                	jne    11f0 <test_unmonopolize+0x10>
    int expected[6] = {pid[0], pid[2], pid[4], pid[6], pid[8], -1};
    120f:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1212:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
    int i = 0;
    1219:	31 f6                	xor    %esi,%esi
    int expected[6] = {pid[0], pid[2], pid[4], pid[6], pid[8], -1};
    121b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    121e:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1221:	89 45 bc             	mov    %eax,-0x44(%ebp)
    1224:	8b 45 e0             	mov    -0x20(%ebp),%eax
    1227:	89 45 c0             	mov    %eax,-0x40(%ebp)
    122a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    122d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    1230:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1233:	89 45 c8             	mov    %eax,-0x38(%ebp)
    1236:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123d:	8d 76 00             	lea    0x0(%esi),%esi
    while ((exited = wait()))
    1240:	e8 96 0a 00 00       	call   1cdb <wait>
    1245:	89 c3                	mov    %eax,%ebx
    1247:	85 c0                	test   %eax,%eax
    1249:	74 4c                	je     1297 <test_unmonopolize+0xb7>
        if(i <= 4 && (exited == pid[1] || exited == pid[3] || exited == pid[5] || exited == pid[7])){
    124b:	83 fe 04             	cmp    $0x4,%esi
    124e:	7f 14                	jg     1264 <test_unmonopolize+0x84>
    1250:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
    1253:	74 eb                	je     1240 <test_unmonopolize+0x60>
    1255:	39 5d dc             	cmp    %ebx,-0x24(%ebp)
    1258:	74 e6                	je     1240 <test_unmonopolize+0x60>
    125a:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
    125d:	74 e1                	je     1240 <test_unmonopolize+0x60>
    125f:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
    1262:	74 dc                	je     1240 <test_unmonopolize+0x60>
        TEST_EQ_INT(exited, expected[i]);
    1264:	8b 44 b5 b8          	mov    -0x48(%ebp,%esi,4),%eax
    1268:	39 d8                	cmp    %ebx,%eax
    126a:	74 23                	je     128f <test_unmonopolize+0xaf>
    126c:	83 ec 0c             	sub    $0xc,%esp
    126f:	53                   	push   %ebx
    1270:	68 28 22 00 00       	push   $0x2228
    1275:	50                   	push   %eax
    1276:	68 34 23 00 00       	push   $0x2334
    127b:	6a 01                	push   $0x1
    127d:	e8 ee 0b 00 00       	call   1e70 <printf>
    1282:	83 c4 20             	add    $0x20,%esp
    1285:	c7 05 a8 2e 00 00 00 	movl   $0x0,0x2ea8
    128c:	00 00 00 
        i++;
    128f:	83 c6 01             	add    $0x1,%esi
        if (exited == -1)
    1292:	83 fb ff             	cmp    $0xffffffff,%ebx
    1295:	75 a9                	jne    1240 <test_unmonopolize+0x60>
    return success;
    1297:	a1 a8 2e 00 00       	mov    0x2ea8,%eax
}
    129c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    129f:	5b                   	pop    %ebx
    12a0:	5e                   	pop    %esi
    12a1:	5d                   	pop    %ebp
    12a2:	c3                   	ret    
    12a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    12a7:	90                   	nop
            printf(1, "fork failed\n");
    12a8:	83 ec 08             	sub    $0x8,%esp
    12ab:	68 03 22 00 00       	push   $0x2203
    12b0:	6a 01                	push   $0x1
    12b2:	e8 b9 0b 00 00       	call   1e70 <printf>
            return 0;
    12b7:	83 c4 10             	add    $0x10,%esp
}
    12ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
            return 0;
    12bd:	31 c0                	xor    %eax,%eax
}
    12bf:	5b                   	pop    %ebx
    12c0:	5e                   	pop    %esi
    12c1:	5d                   	pop    %ebp
    12c2:	c3                   	ret    
        counter[i] = 0;
    12c3:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    12ca:	00 00 00 
    12cd:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    12d4:	00 00 00 
    12d7:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    12de:	00 00 00 
    12e1:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    12e8:	00 00 00 
    12eb:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    12f2:	00 00 00 
            if (i==8)
    12f5:	83 fb 08             	cmp    $0x8,%ebx
    12f8:	74 5f                	je     1359 <test_unmonopolize+0x179>
                if(i&1){
    12fa:	83 e3 01             	and    $0x1,%ebx
    12fd:	74 32                	je     1331 <test_unmonopolize+0x151>
                    sleep(100);
    12ff:	83 ec 0c             	sub    $0xc,%esp
    1302:	bb 10 27 00 00       	mov    $0x2710,%ebx
    1307:	6a 64                	push   $0x64
    1309:	e8 55 0a 00 00       	call   1d63 <sleep>
    130e:	83 c4 10             	add    $0x10,%esp
    1311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                        yield();
    1318:	e8 66 0a 00 00       	call   1d83 <yield>
                        increment_counter();
    131d:	e8 1e ee ff ff       	call   140 <increment_counter>
                    for (int j = 0; j < NUM_MLOOP; j++)
    1322:	83 eb 01             	sub    $0x1,%ebx
    1325:	75 f1                	jne    1318 <test_unmonopolize+0x138>
                    monopolize();
    1327:	e8 77 0a 00 00       	call   1da3 <monopolize>
    exit();
    132c:	e8 a2 09 00 00       	call   1cd3 <exit>
                    sleep(10);
    1331:	83 ec 0c             	sub    $0xc,%esp
    1334:	bb a0 86 01 00       	mov    $0x186a0,%ebx
    1339:	6a 0a                	push   $0xa
    133b:	e8 23 0a 00 00       	call   1d63 <sleep>
    1340:	83 c4 10             	add    $0x10,%esp
    1343:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1347:	90                   	nop
                        increment_counter();
    1348:	e8 f3 ed ff ff       	call   140 <increment_counter>
                    for (int j = 0; j < NUM_LOOP; j++)
    134d:	83 eb 01             	sub    $0x1,%ebx
    1350:	75 f6                	jne    1348 <test_unmonopolize+0x168>
                    unmonopolize();
    1352:	e8 54 0a 00 00       	call   1dab <unmonopolize>
    1357:	eb d3                	jmp    132c <test_unmonopolize+0x14c>
                setmonopoly(pid[0], STD_NUM);
    1359:	50                   	push   %eax
    135a:	50                   	push   %eax
    135b:	68 2e 1b 86 78       	push   $0x78861b2e
    1360:	ff 75 d0             	pushl  -0x30(%ebp)
    1363:	e8 33 0a 00 00       	call   1d9b <setmonopoly>
                setmonopoly(pid[2], STD_NUM);
    1368:	5a                   	pop    %edx
    1369:	59                   	pop    %ecx
    136a:	68 2e 1b 86 78       	push   $0x78861b2e
    136f:	ff 75 d8             	pushl  -0x28(%ebp)
    1372:	e8 24 0a 00 00       	call   1d9b <setmonopoly>
                setmonopoly(pid[4], STD_NUM);
    1377:	5b                   	pop    %ebx
    1378:	5e                   	pop    %esi
    1379:	68 2e 1b 86 78       	push   $0x78861b2e
    137e:	ff 75 e0             	pushl  -0x20(%ebp)
                monopolize();
    1381:	bb a0 86 01 00       	mov    $0x186a0,%ebx
                setmonopoly(pid[4], STD_NUM);
    1386:	e8 10 0a 00 00       	call   1d9b <setmonopoly>
                setmonopoly(pid[6], STD_NUM);
    138b:	58                   	pop    %eax
    138c:	5a                   	pop    %edx
    138d:	68 2e 1b 86 78       	push   $0x78861b2e
    1392:	ff 75 e8             	pushl  -0x18(%ebp)
    1395:	e8 01 0a 00 00       	call   1d9b <setmonopoly>
                monopolize();
    139a:	e8 04 0a 00 00       	call   1da3 <monopolize>
    139f:	83 c4 10             	add    $0x10,%esp
                    yield();
    13a2:	e8 dc 09 00 00       	call   1d83 <yield>
                    increment_counter();
    13a7:	e8 94 ed ff ff       	call   140 <increment_counter>
                for (int j = 0; j < NUM_LOOP; j++)
    13ac:	83 eb 01             	sub    $0x1,%ebx
    13af:	75 f1                	jne    13a2 <test_unmonopolize+0x1c2>
    13b1:	e9 76 ff ff ff       	jmp    132c <test_unmonopolize+0x14c>
    13b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13bd:	8d 76 00             	lea    0x0(%esi),%esi

000013c0 <test_group>:
{
    13c0:	f3 0f 1e fb          	endbr32 
    13c4:	55                   	push   %ebp
    13c5:	89 e5                	mov    %esp,%ebp
    13c7:	56                   	push   %esi
    13c8:	8b 75 08             	mov    0x8(%ebp),%esi
    13cb:	53                   	push   %ebx
    switch (gid)
    13cc:	83 fe 02             	cmp    $0x2,%esi
    13cf:	0f 84 03 04 00 00    	je     17d8 <test_group+0x418>
    13d5:	83 fe 03             	cmp    $0x3,%esi
    13d8:	0f 84 e2 02 00 00    	je     16c0 <test_group+0x300>
    13de:	83 fe 01             	cmp    $0x1,%esi
    13e1:	74 35                	je     1418 <test_group+0x58>
        printf(1, "Invalid test group\n");
    13e3:	83 ec 08             	sub    $0x8,%esp
    13e6:	68 1e 23 00 00       	push   $0x231e
    13eb:	6a 01                	push   $0x1
    13ed:	e8 7e 0a 00 00       	call   1e70 <printf>
    13f2:	83 c4 10             	add    $0x10,%esp
    int test_count = 0;
    13f5:	31 c0                	xor    %eax,%eax
        printf(1, "[RESULT] PASSED Test Group %d: All tests passed %d/%d.\n", gid, test_passed, test_count);
    13f7:	83 ec 0c             	sub    $0xc,%esp
    13fa:	50                   	push   %eax
    13fb:	50                   	push   %eax
    13fc:	56                   	push   %esi
    13fd:	68 04 28 00 00       	push   $0x2804
    1402:	6a 01                	push   $0x1
    1404:	e8 67 0a 00 00       	call   1e70 <printf>
    1409:	83 c4 20             	add    $0x20,%esp
}
    140c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    140f:	5b                   	pop    %ebx
    1410:	5e                   	pop    %esi
    1411:	5d                   	pop    %ebp
    1412:	c3                   	ret    
    1413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1417:	90                   	nop
        printf(1, "======================\n[TEST]\nTest Group 1 [ System Calls ]\n\n");
    1418:	83 ec 08             	sub    $0x8,%esp
    141b:	68 8c 23 00 00       	push   $0x238c
    1420:	6a 01                	push   $0x1
    1422:	e8 49 0a 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1427:	59                   	pop    %ecx
    1428:	5b                   	pop    %ebx
    1429:	68 cc 23 00 00       	push   $0x23cc
    142e:	6a 01                	push   $0x1
    success = 1;
    1430:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    1437:	00 00 00 
        counter[i] = 0;
    143a:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1441:	00 00 00 
    1444:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    144b:	00 00 00 
    144e:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1455:	00 00 00 
    1458:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    145f:	00 00 00 
    1462:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1469:	00 00 00 
        printf(1, "====================================\n");
    146c:	e8 ff 09 00 00       	call   1e70 <printf>
        printf(1, "Test 1: yield - 1\n");
    1471:	58                   	pop    %eax
    1472:	5a                   	pop    %edx
    1473:	68 36 22 00 00       	push   $0x2236
    1478:	6a 01                	push   $0x1
    147a:	e8 f1 09 00 00       	call   1e70 <printf>
        printf(1, "Desc: larger pid should be finished first\n");
    147f:	59                   	pop    %ecx
    1480:	5b                   	pop    %ebx
    1481:	68 f4 23 00 00       	push   $0x23f4
    1486:	6a 01                	push   $0x1
    1488:	e8 e3 09 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    148d:	58                   	pop    %eax
    148e:	5a                   	pop    %edx
    148f:	68 cc 23 00 00       	push   $0x23cc
    1494:	6a 01                	push   $0x1
    1496:	e8 d5 09 00 00       	call   1e70 <printf>
        test_passed += test_yield();
    149b:	e8 b0 ee ff ff       	call   350 <test_yield>
        printf(1, "====================================\n");
    14a0:	59                   	pop    %ecx
    success = 1;
    14a1:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    14a8:	00 00 00 
        counter[i] = 0;
    14ab:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    14b2:	00 00 00 
        test_passed += test_yield();
    14b5:	89 c3                	mov    %eax,%ebx
        printf(1, "====================================\n");
    14b7:	58                   	pop    %eax
    14b8:	68 cc 23 00 00       	push   $0x23cc
    14bd:	6a 01                	push   $0x1
        counter[i] = 0;
    14bf:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    14c6:	00 00 00 
    14c9:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    14d0:	00 00 00 
    14d3:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    14da:	00 00 00 
    14dd:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    14e4:	00 00 00 
        printf(1, "====================================\n");
    14e7:	e8 84 09 00 00       	call   1e70 <printf>
        printf(1, "Test 2: yield - 2\n");
    14ec:	58                   	pop    %eax
    14ed:	5a                   	pop    %edx
    14ee:	68 49 22 00 00       	push   $0x2249
    14f3:	6a 01                	push   $0x1
    14f5:	e8 76 09 00 00       	call   1e70 <printf>
        printf(1, "Desc: smaller pid should be finished first\n");
    14fa:	59                   	pop    %ecx
    14fb:	58                   	pop    %eax
    14fc:	68 20 24 00 00       	push   $0x2420
    1501:	6a 01                	push   $0x1
    1503:	e8 68 09 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1508:	58                   	pop    %eax
    1509:	5a                   	pop    %edx
    150a:	68 cc 23 00 00       	push   $0x23cc
    150f:	6a 01                	push   $0x1
    1511:	e8 5a 09 00 00       	call   1e70 <printf>
        test_passed += test_yield_opposite();
    1516:	e8 75 ef ff ff       	call   490 <test_yield_opposite>
        printf(1, "====================================\n");
    151b:	59                   	pop    %ecx
    success = 1;
    151c:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    1523:	00 00 00 
        counter[i] = 0;
    1526:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    152d:	00 00 00 
        test_passed += test_yield_opposite();
    1530:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    1532:	58                   	pop    %eax
    1533:	68 cc 23 00 00       	push   $0x23cc
    1538:	6a 01                	push   $0x1
        counter[i] = 0;
    153a:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1541:	00 00 00 
    1544:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    154b:	00 00 00 
    154e:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1555:	00 00 00 
    1558:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    155f:	00 00 00 
        printf(1, "====================================\n");
    1562:	e8 09 09 00 00       	call   1e70 <printf>
        printf(1, "Test 3: getlev\n");
    1567:	58                   	pop    %eax
    1568:	5a                   	pop    %edx
    1569:	68 5c 22 00 00       	push   $0x225c
    156e:	6a 01                	push   $0x1
    1570:	e8 fb 08 00 00       	call   1e70 <printf>
        printf(1, "Desc: process should be finished in the order of L0, L1, L2, L3\n");
    1575:	59                   	pop    %ecx
    1576:	58                   	pop    %eax
    1577:	68 4c 24 00 00       	push   $0x244c
    157c:	6a 01                	push   $0x1
    157e:	e8 ed 08 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1583:	58                   	pop    %eax
    1584:	5a                   	pop    %edx
    1585:	68 cc 23 00 00       	push   $0x23cc
    158a:	6a 01                	push   $0x1
    158c:	e8 df 08 00 00       	call   1e70 <printf>
        test_passed += test_getlev();
    1591:	e8 3a f0 ff ff       	call   5d0 <test_getlev>
        printf(1, "====================================\n");
    1596:	59                   	pop    %ecx
    success = 1;
    1597:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    159e:	00 00 00 
        counter[i] = 0;
    15a1:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    15a8:	00 00 00 
        test_passed += test_getlev();
    15ab:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    15ad:	58                   	pop    %eax
    15ae:	68 cc 23 00 00       	push   $0x23cc
    15b3:	6a 01                	push   $0x1
        counter[i] = 0;
    15b5:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    15bc:	00 00 00 
    15bf:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    15c6:	00 00 00 
    15c9:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    15d0:	00 00 00 
    15d3:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    15da:	00 00 00 
        printf(1, "====================================\n");
    15dd:	e8 8e 08 00 00       	call   1e70 <printf>
        printf(1, "Test 4: setpriority\n");
    15e2:	58                   	pop    %eax
    15e3:	5a                   	pop    %edx
    15e4:	68 6c 22 00 00       	push   $0x226c
    15e9:	6a 01                	push   $0x1
    15eb:	e8 80 08 00 00       	call   1e70 <printf>
        printf(1, "Desc: pid with higher number should be finished first\n");
    15f0:	59                   	pop    %ecx
    15f1:	58                   	pop    %eax
    15f2:	68 90 24 00 00       	push   $0x2490
    15f7:	6a 01                	push   $0x1
    15f9:	e8 72 08 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    15fe:	58                   	pop    %eax
    15ff:	5a                   	pop    %edx
    1600:	68 cc 23 00 00       	push   $0x23cc
    1605:	6a 01                	push   $0x1
    1607:	e8 64 08 00 00       	call   1e70 <printf>
        test_passed += test_setpriority();
    160c:	e8 6f f0 ff ff       	call   680 <test_setpriority>
        printf(1, "====================================\n");
    1611:	59                   	pop    %ecx
    success = 1;
    1612:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    1619:	00 00 00 
        counter[i] = 0;
    161c:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1623:	00 00 00 
        test_passed += test_setpriority();
    1626:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    1628:	58                   	pop    %eax
    1629:	68 cc 23 00 00       	push   $0x23cc
    162e:	6a 01                	push   $0x1
        counter[i] = 0;
    1630:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1637:	00 00 00 
    163a:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1641:	00 00 00 
    1644:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    164b:	00 00 00 
    164e:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1655:	00 00 00 
        printf(1, "====================================\n");
    1658:	e8 13 08 00 00       	call   1e70 <printf>
        printf(1, "Test 5: setmonopoly, monopolize and unmonopolize\n");
    165d:	58                   	pop    %eax
    165e:	5a                   	pop    %edx
    165f:	68 c8 24 00 00       	push   $0x24c8
    1664:	6a 01                	push   $0x1
    1666:	e8 05 08 00 00       	call   1e70 <printf>
        printf(1, "Desc: test if the return values of setmonopoly() is right\nadditionally, test if monopolize() and unmonopolize() works\n");
    166b:	59                   	pop    %ecx
    166c:	58                   	pop    %eax
    166d:	68 fc 24 00 00       	push   $0x24fc
    1672:	6a 01                	push   $0x1
    1674:	e8 f7 07 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1679:	58                   	pop    %eax
    167a:	5a                   	pop    %edx
    167b:	68 cc 23 00 00       	push   $0x23cc
    1680:	6a 01                	push   $0x1
    1682:	e8 e9 07 00 00       	call   1e70 <printf>
        test_passed += test_monopoly();
    1687:	e8 94 f0 ff ff       	call   720 <test_monopoly>
        break;
    168c:	83 c4 10             	add    $0x10,%esp
        test_count++;
    168f:	ba 05 00 00 00       	mov    $0x5,%edx
        test_passed += test_monopoly();
    1694:	01 d8                	add    %ebx,%eax
    if (test_count == test_passed)
    1696:	39 c2                	cmp    %eax,%edx
    1698:	0f 84 59 fd ff ff    	je     13f7 <test_group+0x37>
        printf(1, "[RESULT] FAILED Test Group %d: %d/%d\n", gid, test_passed, test_count);
    169e:	83 ec 0c             	sub    $0xc,%esp
    16a1:	52                   	push   %edx
    16a2:	50                   	push   %eax
    16a3:	56                   	push   %esi
    16a4:	68 3c 28 00 00       	push   $0x283c
    16a9:	6a 01                	push   $0x1
    16ab:	e8 c0 07 00 00       	call   1e70 <printf>
    16b0:	83 c4 20             	add    $0x20,%esp
}
    16b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    16b6:	5b                   	pop    %ebx
    16b7:	5e                   	pop    %esi
    16b8:	5d                   	pop    %ebp
    16b9:	c3                   	ret    
    16ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "======================\n[TEST]\nTest Group 3 [ MoQ Specification ]\n\n");
    16c0:	83 ec 08             	sub    $0x8,%esp
    16c3:	68 58 27 00 00       	push   $0x2758
    16c8:	6a 01                	push   $0x1
    16ca:	e8 a1 07 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    16cf:	58                   	pop    %eax
    16d0:	5a                   	pop    %edx
    16d1:	68 cc 23 00 00       	push   $0x23cc
    16d6:	6a 01                	push   $0x1
    success = 1;
    16d8:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    16df:	00 00 00 
        counter[i] = 0;
    16e2:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    16e9:	00 00 00 
    16ec:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    16f3:	00 00 00 
    16f6:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    16fd:	00 00 00 
    1700:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1707:	00 00 00 
    170a:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1711:	00 00 00 
        printf(1, "====================================\n");
    1714:	e8 57 07 00 00       	call   1e70 <printf>
        printf(1, "Test 1: sleeping process\n");
    1719:	59                   	pop    %ecx
    171a:	5b                   	pop    %ebx
    171b:	68 ee 22 00 00       	push   $0x22ee
    1720:	6a 01                	push   $0x1
    1722:	e8 49 07 00 00       	call   1e70 <printf>
        printf(1, "Desc: MoQ is FCFS, sleeping should not allow next process to run\n");
    1727:	58                   	pop    %eax
    1728:	5a                   	pop    %edx
    1729:	68 9c 27 00 00       	push   $0x279c
    172e:	6a 01                	push   $0x1
    1730:	e8 3b 07 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1735:	59                   	pop    %ecx
    1736:	5b                   	pop    %ebx
    1737:	68 cc 23 00 00       	push   $0x23cc
    173c:	6a 01                	push   $0x1
    173e:	e8 2d 07 00 00       	call   1e70 <printf>
        test_passed += test_sleeping_process();
    1743:	e8 28 f9 ff ff       	call   1070 <test_sleeping_process>
    success = 1;
    1748:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    174f:	00 00 00 
        counter[i] = 0;
    1752:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1759:	00 00 00 
        test_passed += test_sleeping_process();
    175c:	89 c3                	mov    %eax,%ebx
        printf(1, "====================================\n");
    175e:	58                   	pop    %eax
        counter[i] = 0;
    175f:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1766:	00 00 00 
        printf(1, "====================================\n");
    1769:	5a                   	pop    %edx
    176a:	68 cc 23 00 00       	push   $0x23cc
    176f:	6a 01                	push   $0x1
        counter[i] = 0;
    1771:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1778:	00 00 00 
    177b:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1782:	00 00 00 
    1785:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    178c:	00 00 00 
        printf(1, "====================================\n");
    178f:	e8 dc 06 00 00       	call   1e70 <printf>
        printf(1, "Test 2: unmonopolize\n");
    1794:	59                   	pop    %ecx
    1795:	58                   	pop    %eax
    1796:	68 08 23 00 00       	push   $0x2308
    179b:	6a 01                	push   $0x1
    179d:	e8 ce 06 00 00       	call   1e70 <printf>
        printf(1, "Desc: test if unmonopolize() works\n");
    17a2:	58                   	pop    %eax
    17a3:	5a                   	pop    %edx
    17a4:	68 e0 27 00 00       	push   $0x27e0
    17a9:	6a 01                	push   $0x1
    17ab:	e8 c0 06 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    17b0:	59                   	pop    %ecx
    17b1:	58                   	pop    %eax
    17b2:	68 cc 23 00 00       	push   $0x23cc
    17b7:	6a 01                	push   $0x1
    17b9:	e8 b2 06 00 00       	call   1e70 <printf>
        test_passed += test_unmonopolize();
    17be:	e8 1d fa ff ff       	call   11e0 <test_unmonopolize>
        break;
    17c3:	83 c4 10             	add    $0x10,%esp
        test_count++;
    17c6:	ba 02 00 00 00       	mov    $0x2,%edx
        test_passed += test_unmonopolize();
    17cb:	01 d8                	add    %ebx,%eax
        break;
    17cd:	e9 c4 fe ff ff       	jmp    1696 <test_group+0x2d6>
    17d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printf(1, "======================\n[TEST]\nTest Group 2 [ MLFQ specification ]\n");
    17d8:	83 ec 08             	sub    $0x8,%esp
    17db:	68 74 25 00 00       	push   $0x2574
    17e0:	6a 01                	push   $0x1
    17e2:	e8 89 06 00 00       	call   1e70 <printf>
        printf(1, "This test group assumes that all system calls are working fine.\n\n");
    17e7:	58                   	pop    %eax
    17e8:	5a                   	pop    %edx
    17e9:	68 b8 25 00 00       	push   $0x25b8
    17ee:	6a 01                	push   $0x1
    17f0:	e8 7b 06 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    17f5:	59                   	pop    %ecx
    17f6:	5b                   	pop    %ebx
    17f7:	68 cc 23 00 00       	push   $0x23cc
    17fc:	6a 01                	push   $0x1
    success = 1;
    17fe:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    1805:	00 00 00 
        counter[i] = 0;
    1808:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    180f:	00 00 00 
    1812:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1819:	00 00 00 
    181c:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1823:	00 00 00 
    1826:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    182d:	00 00 00 
    1830:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1837:	00 00 00 
        printf(1, "====================================\n");
    183a:	e8 31 06 00 00       	call   1e70 <printf>
        printf(1, "Test 1: demotion\n");
    183f:	58                   	pop    %eax
    1840:	5a                   	pop    %edx
    1841:	68 81 22 00 00       	push   $0x2281
    1846:	6a 01                	push   $0x1
    1848:	e8 23 06 00 00       	call   1e70 <printf>
        printf(1, "Desc: process in L0 should correctly demote to L1 and L2\n");
    184d:	59                   	pop    %ecx
    184e:	5b                   	pop    %ebx
    184f:	68 fc 25 00 00       	push   $0x25fc
    1854:	6a 01                	push   $0x1
    1856:	e8 15 06 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    185b:	58                   	pop    %eax
    185c:	5a                   	pop    %edx
    185d:	68 cc 23 00 00       	push   $0x23cc
    1862:	6a 01                	push   $0x1
    1864:	e8 07 06 00 00       	call   1e70 <printf>
        test_passed += test_demote();
    1869:	e8 c2 f0 ff ff       	call   930 <test_demote>
        printf(1, "====================================\n");
    186e:	59                   	pop    %ecx
    success = 1;
    186f:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    1876:	00 00 00 
        counter[i] = 0;
    1879:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1880:	00 00 00 
        test_passed += test_demote();
    1883:	89 c3                	mov    %eax,%ebx
        printf(1, "====================================\n");
    1885:	58                   	pop    %eax
    1886:	68 cc 23 00 00       	push   $0x23cc
    188b:	6a 01                	push   $0x1
        counter[i] = 0;
    188d:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1894:	00 00 00 
    1897:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    189e:	00 00 00 
    18a1:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    18a8:	00 00 00 
    18ab:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    18b2:	00 00 00 
        printf(1, "====================================\n");
    18b5:	e8 b6 05 00 00       	call   1e70 <printf>
        printf(1, "Test 2: roundrobin\n");
    18ba:	58                   	pop    %eax
    18bb:	5a                   	pop    %edx
    18bc:	68 93 22 00 00       	push   $0x2293
    18c1:	6a 01                	push   $0x1
    18c3:	e8 a8 05 00 00       	call   1e70 <printf>
        printf(1, "Desc: if round robin works correctly shortest job should end first\n");
    18c8:	59                   	pop    %ecx
    18c9:	58                   	pop    %eax
    18ca:	68 38 26 00 00       	push   $0x2638
    18cf:	6a 01                	push   $0x1
    18d1:	e8 9a 05 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    18d6:	58                   	pop    %eax
    18d7:	5a                   	pop    %edx
    18d8:	68 cc 23 00 00       	push   $0x23cc
    18dd:	6a 01                	push   $0x1
    18df:	e8 8c 05 00 00       	call   1e70 <printf>
        test_passed += test_roundrobin();
    18e4:	e8 b7 f1 ff ff       	call   aa0 <test_roundrobin>
        printf(1, "====================================\n");
    18e9:	59                   	pop    %ecx
    success = 1;
    18ea:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    18f1:	00 00 00 
        counter[i] = 0;
    18f4:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    18fb:	00 00 00 
        test_passed += test_roundrobin();
    18fe:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    1900:	58                   	pop    %eax
    1901:	68 cc 23 00 00       	push   $0x23cc
    1906:	6a 01                	push   $0x1
        counter[i] = 0;
    1908:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    190f:	00 00 00 
    1912:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1919:	00 00 00 
    191c:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1923:	00 00 00 
    1926:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    192d:	00 00 00 
        printf(1, "====================================\n");
    1930:	e8 3b 05 00 00       	call   1e70 <printf>
        printf(1, "Test 3: priority L3\n");
    1935:	58                   	pop    %eax
    1936:	5a                   	pop    %edx
    1937:	68 a7 22 00 00       	push   $0x22a7
    193c:	6a 01                	push   $0x1
    193e:	e8 2d 05 00 00       	call   1e70 <printf>
        printf(1, "Desc: test if priority works correctly in L3, higher pid has higher priority\n");
    1943:	59                   	pop    %ecx
    1944:	58                   	pop    %eax
    1945:	68 7c 26 00 00       	push   $0x267c
    194a:	6a 01                	push   $0x1
    194c:	e8 1f 05 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1951:	58                   	pop    %eax
    1952:	5a                   	pop    %edx
    1953:	68 cc 23 00 00       	push   $0x23cc
    1958:	6a 01                	push   $0x1
    195a:	e8 11 05 00 00       	call   1e70 <printf>
        test_passed += test_priority_L3();
    195f:	e8 5c f2 ff ff       	call   bc0 <test_priority_L3>
        printf(1, "====================================\n");
    1964:	59                   	pop    %ecx
    success = 1;
    1965:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    196c:	00 00 00 
        counter[i] = 0;
    196f:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    1976:	00 00 00 
        test_passed += test_priority_L3();
    1979:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    197b:	58                   	pop    %eax
    197c:	68 cc 23 00 00       	push   $0x23cc
    1981:	6a 01                	push   $0x1
        counter[i] = 0;
    1983:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    198a:	00 00 00 
    198d:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1994:	00 00 00 
    1997:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    199e:	00 00 00 
    19a1:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    19a8:	00 00 00 
        printf(1, "====================================\n");
    19ab:	e8 c0 04 00 00       	call   1e70 <printf>
        printf(1, "Test 4: priority others\n");
    19b0:	58                   	pop    %eax
    19b1:	5a                   	pop    %edx
    19b2:	68 bc 22 00 00       	push   $0x22bc
    19b7:	6a 01                	push   $0x1
    19b9:	e8 b2 04 00 00       	call   1e70 <printf>
        printf(1, "Desc: priority should have no effect in other queue\n");
    19be:	59                   	pop    %ecx
    19bf:	58                   	pop    %eax
    19c0:	68 cc 26 00 00       	push   $0x26cc
    19c5:	6a 01                	push   $0x1
    19c7:	e8 a4 04 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    19cc:	58                   	pop    %eax
    19cd:	5a                   	pop    %edx
    19ce:	68 cc 23 00 00       	push   $0x23cc
    19d3:	6a 01                	push   $0x1
    19d5:	e8 96 04 00 00       	call   1e70 <printf>
        test_passed += test_priority_others();
    19da:	e8 11 f3 ff ff       	call   cf0 <test_priority_others>
        printf(1, "====================================\n");
    19df:	59                   	pop    %ecx
    success = 1;
    19e0:	c7 05 a8 2e 00 00 01 	movl   $0x1,0x2ea8
    19e7:	00 00 00 
        counter[i] = 0;
    19ea:	c7 05 b8 2e 00 00 00 	movl   $0x0,0x2eb8
    19f1:	00 00 00 
        test_passed += test_priority_others();
    19f4:	01 c3                	add    %eax,%ebx
        printf(1, "====================================\n");
    19f6:	58                   	pop    %eax
    19f7:	68 cc 23 00 00       	push   $0x23cc
    19fc:	6a 01                	push   $0x1
        counter[i] = 0;
    19fe:	c7 05 bc 2e 00 00 00 	movl   $0x0,0x2ebc
    1a05:	00 00 00 
    1a08:	c7 05 c0 2e 00 00 00 	movl   $0x0,0x2ec0
    1a0f:	00 00 00 
    1a12:	c7 05 c4 2e 00 00 00 	movl   $0x0,0x2ec4
    1a19:	00 00 00 
    1a1c:	c7 05 c8 2e 00 00 00 	movl   $0x0,0x2ec8
    1a23:	00 00 00 
        printf(1, "====================================\n");
    1a26:	e8 45 04 00 00       	call   1e70 <printf>
        printf(1, "Test 5: priority reduce\n");
    1a2b:	58                   	pop    %eax
    1a2c:	5a                   	pop    %edx
    1a2d:	68 d5 22 00 00       	push   $0x22d5
    1a32:	6a 01                	push   $0x1
    1a34:	e8 37 04 00 00       	call   1e70 <printf>
        printf(1, "Desc: process's priority should be decreased every time it uses up time quantum\n");
    1a39:	59                   	pop    %ecx
    1a3a:	58                   	pop    %eax
    1a3b:	68 04 27 00 00       	push   $0x2704
    1a40:	6a 01                	push   $0x1
    1a42:	e8 29 04 00 00       	call   1e70 <printf>
        printf(1, "====================================\n");
    1a47:	58                   	pop    %eax
    1a48:	5a                   	pop    %edx
    1a49:	68 cc 23 00 00       	push   $0x23cc
    1a4e:	6a 01                	push   $0x1
    1a50:	e8 1b 04 00 00       	call   1e70 <printf>
        test_passed += test_priority_reduce();
    1a55:	e8 66 f4 ff ff       	call   ec0 <test_priority_reduce>
        test_count++;
    1a5a:	ba 05 00 00 00       	mov    $0x5,%edx
        test_passed += test_priority_reduce();
    1a5f:	01 d8                	add    %ebx,%eax
        break;
    1a61:	83 c4 10             	add    $0x10,%esp
    1a64:	e9 2d fc ff ff       	jmp    1696 <test_group+0x2d6>
    1a69:	66 90                	xchg   %ax,%ax
    1a6b:	66 90                	xchg   %ax,%ax
    1a6d:	66 90                	xchg   %ax,%ax
    1a6f:	90                   	nop

00001a70 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1a70:	f3 0f 1e fb          	endbr32 
    1a74:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1a75:	31 c0                	xor    %eax,%eax
{
    1a77:	89 e5                	mov    %esp,%ebp
    1a79:	53                   	push   %ebx
    1a7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1a7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    1a80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    1a84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    1a87:	83 c0 01             	add    $0x1,%eax
    1a8a:	84 d2                	test   %dl,%dl
    1a8c:	75 f2                	jne    1a80 <strcpy+0x10>
    ;
  return os;
}
    1a8e:	89 c8                	mov    %ecx,%eax
    1a90:	5b                   	pop    %ebx
    1a91:	5d                   	pop    %ebp
    1a92:	c3                   	ret    
    1a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001aa0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1aa0:	f3 0f 1e fb          	endbr32 
    1aa4:	55                   	push   %ebp
    1aa5:	89 e5                	mov    %esp,%ebp
    1aa7:	53                   	push   %ebx
    1aa8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1aab:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    1aae:	0f b6 01             	movzbl (%ecx),%eax
    1ab1:	0f b6 1a             	movzbl (%edx),%ebx
    1ab4:	84 c0                	test   %al,%al
    1ab6:	75 19                	jne    1ad1 <strcmp+0x31>
    1ab8:	eb 26                	jmp    1ae0 <strcmp+0x40>
    1aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1ac0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1ac4:	83 c1 01             	add    $0x1,%ecx
    1ac7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1aca:	0f b6 1a             	movzbl (%edx),%ebx
    1acd:	84 c0                	test   %al,%al
    1acf:	74 0f                	je     1ae0 <strcmp+0x40>
    1ad1:	38 d8                	cmp    %bl,%al
    1ad3:	74 eb                	je     1ac0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1ad5:	29 d8                	sub    %ebx,%eax
}
    1ad7:	5b                   	pop    %ebx
    1ad8:	5d                   	pop    %ebp
    1ad9:	c3                   	ret    
    1ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1ae0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1ae2:	29 d8                	sub    %ebx,%eax
}
    1ae4:	5b                   	pop    %ebx
    1ae5:	5d                   	pop    %ebp
    1ae6:	c3                   	ret    
    1ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1aee:	66 90                	xchg   %ax,%ax

00001af0 <strlen>:

uint
strlen(const char *s)
{
    1af0:	f3 0f 1e fb          	endbr32 
    1af4:	55                   	push   %ebp
    1af5:	89 e5                	mov    %esp,%ebp
    1af7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    1afa:	80 3a 00             	cmpb   $0x0,(%edx)
    1afd:	74 21                	je     1b20 <strlen+0x30>
    1aff:	31 c0                	xor    %eax,%eax
    1b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b08:	83 c0 01             	add    $0x1,%eax
    1b0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    1b0f:	89 c1                	mov    %eax,%ecx
    1b11:	75 f5                	jne    1b08 <strlen+0x18>
    ;
  return n;
}
    1b13:	89 c8                	mov    %ecx,%eax
    1b15:	5d                   	pop    %ebp
    1b16:	c3                   	ret    
    1b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b1e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    1b20:	31 c9                	xor    %ecx,%ecx
}
    1b22:	5d                   	pop    %ebp
    1b23:	89 c8                	mov    %ecx,%eax
    1b25:	c3                   	ret    
    1b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b2d:	8d 76 00             	lea    0x0(%esi),%esi

00001b30 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1b30:	f3 0f 1e fb          	endbr32 
    1b34:	55                   	push   %ebp
    1b35:	89 e5                	mov    %esp,%ebp
    1b37:	57                   	push   %edi
    1b38:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1b3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    1b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1b41:	89 d7                	mov    %edx,%edi
    1b43:	fc                   	cld    
    1b44:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1b46:	89 d0                	mov    %edx,%eax
    1b48:	5f                   	pop    %edi
    1b49:	5d                   	pop    %ebp
    1b4a:	c3                   	ret    
    1b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1b4f:	90                   	nop

00001b50 <strchr>:

char*
strchr(const char *s, char c)
{
    1b50:	f3 0f 1e fb          	endbr32 
    1b54:	55                   	push   %ebp
    1b55:	89 e5                	mov    %esp,%ebp
    1b57:	8b 45 08             	mov    0x8(%ebp),%eax
    1b5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    1b5e:	0f b6 10             	movzbl (%eax),%edx
    1b61:	84 d2                	test   %dl,%dl
    1b63:	75 16                	jne    1b7b <strchr+0x2b>
    1b65:	eb 21                	jmp    1b88 <strchr+0x38>
    1b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b6e:	66 90                	xchg   %ax,%ax
    1b70:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    1b74:	83 c0 01             	add    $0x1,%eax
    1b77:	84 d2                	test   %dl,%dl
    1b79:	74 0d                	je     1b88 <strchr+0x38>
    if(*s == c)
    1b7b:	38 d1                	cmp    %dl,%cl
    1b7d:	75 f1                	jne    1b70 <strchr+0x20>
      return (char*)s;
  return 0;
}
    1b7f:	5d                   	pop    %ebp
    1b80:	c3                   	ret    
    1b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    1b88:	31 c0                	xor    %eax,%eax
}
    1b8a:	5d                   	pop    %ebp
    1b8b:	c3                   	ret    
    1b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001b90 <gets>:

char*
gets(char *buf, int max)
{
    1b90:	f3 0f 1e fb          	endbr32 
    1b94:	55                   	push   %ebp
    1b95:	89 e5                	mov    %esp,%ebp
    1b97:	57                   	push   %edi
    1b98:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1b99:	31 f6                	xor    %esi,%esi
{
    1b9b:	53                   	push   %ebx
    1b9c:	89 f3                	mov    %esi,%ebx
    1b9e:	83 ec 1c             	sub    $0x1c,%esp
    1ba1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1ba4:	eb 33                	jmp    1bd9 <gets+0x49>
    1ba6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1bad:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1bb0:	83 ec 04             	sub    $0x4,%esp
    1bb3:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1bb6:	6a 01                	push   $0x1
    1bb8:	50                   	push   %eax
    1bb9:	6a 00                	push   $0x0
    1bbb:	e8 2b 01 00 00       	call   1ceb <read>
    if(cc < 1)
    1bc0:	83 c4 10             	add    $0x10,%esp
    1bc3:	85 c0                	test   %eax,%eax
    1bc5:	7e 1c                	jle    1be3 <gets+0x53>
      break;
    buf[i++] = c;
    1bc7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1bcb:	83 c7 01             	add    $0x1,%edi
    1bce:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1bd1:	3c 0a                	cmp    $0xa,%al
    1bd3:	74 23                	je     1bf8 <gets+0x68>
    1bd5:	3c 0d                	cmp    $0xd,%al
    1bd7:	74 1f                	je     1bf8 <gets+0x68>
  for(i=0; i+1 < max; ){
    1bd9:	83 c3 01             	add    $0x1,%ebx
    1bdc:	89 fe                	mov    %edi,%esi
    1bde:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1be1:	7c cd                	jl     1bb0 <gets+0x20>
    1be3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    1be5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1be8:	c6 03 00             	movb   $0x0,(%ebx)
}
    1beb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1bee:	5b                   	pop    %ebx
    1bef:	5e                   	pop    %esi
    1bf0:	5f                   	pop    %edi
    1bf1:	5d                   	pop    %ebp
    1bf2:	c3                   	ret    
    1bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1bf7:	90                   	nop
    1bf8:	8b 75 08             	mov    0x8(%ebp),%esi
    1bfb:	8b 45 08             	mov    0x8(%ebp),%eax
    1bfe:	01 de                	add    %ebx,%esi
    1c00:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    1c02:	c6 03 00             	movb   $0x0,(%ebx)
}
    1c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c08:	5b                   	pop    %ebx
    1c09:	5e                   	pop    %esi
    1c0a:	5f                   	pop    %edi
    1c0b:	5d                   	pop    %ebp
    1c0c:	c3                   	ret    
    1c0d:	8d 76 00             	lea    0x0(%esi),%esi

00001c10 <stat>:

int
stat(const char *n, struct stat *st)
{
    1c10:	f3 0f 1e fb          	endbr32 
    1c14:	55                   	push   %ebp
    1c15:	89 e5                	mov    %esp,%ebp
    1c17:	56                   	push   %esi
    1c18:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1c19:	83 ec 08             	sub    $0x8,%esp
    1c1c:	6a 00                	push   $0x0
    1c1e:	ff 75 08             	pushl  0x8(%ebp)
    1c21:	e8 ed 00 00 00       	call   1d13 <open>
  if(fd < 0)
    1c26:	83 c4 10             	add    $0x10,%esp
    1c29:	85 c0                	test   %eax,%eax
    1c2b:	78 2b                	js     1c58 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    1c2d:	83 ec 08             	sub    $0x8,%esp
    1c30:	ff 75 0c             	pushl  0xc(%ebp)
    1c33:	89 c3                	mov    %eax,%ebx
    1c35:	50                   	push   %eax
    1c36:	e8 f0 00 00 00       	call   1d2b <fstat>
  close(fd);
    1c3b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    1c3e:	89 c6                	mov    %eax,%esi
  close(fd);
    1c40:	e8 b6 00 00 00       	call   1cfb <close>
  return r;
    1c45:	83 c4 10             	add    $0x10,%esp
}
    1c48:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1c4b:	89 f0                	mov    %esi,%eax
    1c4d:	5b                   	pop    %ebx
    1c4e:	5e                   	pop    %esi
    1c4f:	5d                   	pop    %ebp
    1c50:	c3                   	ret    
    1c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1c58:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1c5d:	eb e9                	jmp    1c48 <stat+0x38>
    1c5f:	90                   	nop

00001c60 <atoi>:

int
atoi(const char *s)
{
    1c60:	f3 0f 1e fb          	endbr32 
    1c64:	55                   	push   %ebp
    1c65:	89 e5                	mov    %esp,%ebp
    1c67:	53                   	push   %ebx
    1c68:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1c6b:	0f be 02             	movsbl (%edx),%eax
    1c6e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    1c71:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    1c74:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    1c79:	77 1a                	ja     1c95 <atoi+0x35>
    1c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1c7f:	90                   	nop
    n = n*10 + *s++ - '0';
    1c80:	83 c2 01             	add    $0x1,%edx
    1c83:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    1c86:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    1c8a:	0f be 02             	movsbl (%edx),%eax
    1c8d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    1c90:	80 fb 09             	cmp    $0x9,%bl
    1c93:	76 eb                	jbe    1c80 <atoi+0x20>
  return n;
}
    1c95:	89 c8                	mov    %ecx,%eax
    1c97:	5b                   	pop    %ebx
    1c98:	5d                   	pop    %ebp
    1c99:	c3                   	ret    
    1c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001ca0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1ca0:	f3 0f 1e fb          	endbr32 
    1ca4:	55                   	push   %ebp
    1ca5:	89 e5                	mov    %esp,%ebp
    1ca7:	57                   	push   %edi
    1ca8:	8b 45 10             	mov    0x10(%ebp),%eax
    1cab:	8b 55 08             	mov    0x8(%ebp),%edx
    1cae:	56                   	push   %esi
    1caf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1cb2:	85 c0                	test   %eax,%eax
    1cb4:	7e 0f                	jle    1cc5 <memmove+0x25>
    1cb6:	01 d0                	add    %edx,%eax
  dst = vdst;
    1cb8:	89 d7                	mov    %edx,%edi
    1cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1cc0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1cc1:	39 f8                	cmp    %edi,%eax
    1cc3:	75 fb                	jne    1cc0 <memmove+0x20>
  return vdst;
}
    1cc5:	5e                   	pop    %esi
    1cc6:	89 d0                	mov    %edx,%eax
    1cc8:	5f                   	pop    %edi
    1cc9:	5d                   	pop    %ebp
    1cca:	c3                   	ret    

00001ccb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1ccb:	b8 01 00 00 00       	mov    $0x1,%eax
    1cd0:	cd 40                	int    $0x40
    1cd2:	c3                   	ret    

00001cd3 <exit>:
SYSCALL(exit)
    1cd3:	b8 02 00 00 00       	mov    $0x2,%eax
    1cd8:	cd 40                	int    $0x40
    1cda:	c3                   	ret    

00001cdb <wait>:
SYSCALL(wait)
    1cdb:	b8 03 00 00 00       	mov    $0x3,%eax
    1ce0:	cd 40                	int    $0x40
    1ce2:	c3                   	ret    

00001ce3 <pipe>:
SYSCALL(pipe)
    1ce3:	b8 04 00 00 00       	mov    $0x4,%eax
    1ce8:	cd 40                	int    $0x40
    1cea:	c3                   	ret    

00001ceb <read>:
SYSCALL(read)
    1ceb:	b8 05 00 00 00       	mov    $0x5,%eax
    1cf0:	cd 40                	int    $0x40
    1cf2:	c3                   	ret    

00001cf3 <write>:
SYSCALL(write)
    1cf3:	b8 10 00 00 00       	mov    $0x10,%eax
    1cf8:	cd 40                	int    $0x40
    1cfa:	c3                   	ret    

00001cfb <close>:
SYSCALL(close)
    1cfb:	b8 15 00 00 00       	mov    $0x15,%eax
    1d00:	cd 40                	int    $0x40
    1d02:	c3                   	ret    

00001d03 <kill>:
SYSCALL(kill)
    1d03:	b8 06 00 00 00       	mov    $0x6,%eax
    1d08:	cd 40                	int    $0x40
    1d0a:	c3                   	ret    

00001d0b <exec>:
SYSCALL(exec)
    1d0b:	b8 07 00 00 00       	mov    $0x7,%eax
    1d10:	cd 40                	int    $0x40
    1d12:	c3                   	ret    

00001d13 <open>:
SYSCALL(open)
    1d13:	b8 0f 00 00 00       	mov    $0xf,%eax
    1d18:	cd 40                	int    $0x40
    1d1a:	c3                   	ret    

00001d1b <mknod>:
SYSCALL(mknod)
    1d1b:	b8 11 00 00 00       	mov    $0x11,%eax
    1d20:	cd 40                	int    $0x40
    1d22:	c3                   	ret    

00001d23 <unlink>:
SYSCALL(unlink)
    1d23:	b8 12 00 00 00       	mov    $0x12,%eax
    1d28:	cd 40                	int    $0x40
    1d2a:	c3                   	ret    

00001d2b <fstat>:
SYSCALL(fstat)
    1d2b:	b8 08 00 00 00       	mov    $0x8,%eax
    1d30:	cd 40                	int    $0x40
    1d32:	c3                   	ret    

00001d33 <link>:
SYSCALL(link)
    1d33:	b8 13 00 00 00       	mov    $0x13,%eax
    1d38:	cd 40                	int    $0x40
    1d3a:	c3                   	ret    

00001d3b <mkdir>:
SYSCALL(mkdir)
    1d3b:	b8 14 00 00 00       	mov    $0x14,%eax
    1d40:	cd 40                	int    $0x40
    1d42:	c3                   	ret    

00001d43 <chdir>:
SYSCALL(chdir)
    1d43:	b8 09 00 00 00       	mov    $0x9,%eax
    1d48:	cd 40                	int    $0x40
    1d4a:	c3                   	ret    

00001d4b <dup>:
SYSCALL(dup)
    1d4b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1d50:	cd 40                	int    $0x40
    1d52:	c3                   	ret    

00001d53 <getpid>:
SYSCALL(getpid)
    1d53:	b8 0b 00 00 00       	mov    $0xb,%eax
    1d58:	cd 40                	int    $0x40
    1d5a:	c3                   	ret    

00001d5b <sbrk>:
SYSCALL(sbrk)
    1d5b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1d60:	cd 40                	int    $0x40
    1d62:	c3                   	ret    

00001d63 <sleep>:
SYSCALL(sleep)
    1d63:	b8 0d 00 00 00       	mov    $0xd,%eax
    1d68:	cd 40                	int    $0x40
    1d6a:	c3                   	ret    

00001d6b <uptime>:
SYSCALL(uptime)
    1d6b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1d70:	cd 40                	int    $0x40
    1d72:	c3                   	ret    

00001d73 <myfunction>:
SYSCALL(myfunction)
    1d73:	b8 16 00 00 00       	mov    $0x16,%eax
    1d78:	cd 40                	int    $0x40
    1d7a:	c3                   	ret    

00001d7b <getgpid>:
SYSCALL(getgpid)
    1d7b:	b8 17 00 00 00       	mov    $0x17,%eax
    1d80:	cd 40                	int    $0x40
    1d82:	c3                   	ret    

00001d83 <yield>:
SYSCALL(yield)
    1d83:	b8 18 00 00 00       	mov    $0x18,%eax
    1d88:	cd 40                	int    $0x40
    1d8a:	c3                   	ret    

00001d8b <getlev>:
SYSCALL(getlev)
    1d8b:	b8 19 00 00 00       	mov    $0x19,%eax
    1d90:	cd 40                	int    $0x40
    1d92:	c3                   	ret    

00001d93 <setpriority>:
SYSCALL(setpriority)
    1d93:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1d98:	cd 40                	int    $0x40
    1d9a:	c3                   	ret    

00001d9b <setmonopoly>:
SYSCALL(setmonopoly)
    1d9b:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1da0:	cd 40                	int    $0x40
    1da2:	c3                   	ret    

00001da3 <monopolize>:
SYSCALL(monopolize)
    1da3:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1da8:	cd 40                	int    $0x40
    1daa:	c3                   	ret    

00001dab <unmonopolize>:
SYSCALL(unmonopolize)
    1dab:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1db0:	cd 40                	int    $0x40
    1db2:	c3                   	ret    
    1db3:	66 90                	xchg   %ax,%ax
    1db5:	66 90                	xchg   %ax,%ax
    1db7:	66 90                	xchg   %ax,%ax
    1db9:	66 90                	xchg   %ax,%ax
    1dbb:	66 90                	xchg   %ax,%ax
    1dbd:	66 90                	xchg   %ax,%ax
    1dbf:	90                   	nop

00001dc0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1dc0:	55                   	push   %ebp
    1dc1:	89 e5                	mov    %esp,%ebp
    1dc3:	57                   	push   %edi
    1dc4:	56                   	push   %esi
    1dc5:	53                   	push   %ebx
    1dc6:	83 ec 3c             	sub    $0x3c,%esp
    1dc9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    1dcc:	89 d1                	mov    %edx,%ecx
{
    1dce:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1dd1:	85 d2                	test   %edx,%edx
    1dd3:	0f 89 7f 00 00 00    	jns    1e58 <printint+0x98>
    1dd9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    1ddd:	74 79                	je     1e58 <printint+0x98>
    neg = 1;
    1ddf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1de6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1de8:	31 db                	xor    %ebx,%ebx
    1dea:	8d 75 d7             	lea    -0x29(%ebp),%esi
    1ded:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1df0:	89 c8                	mov    %ecx,%eax
    1df2:	31 d2                	xor    %edx,%edx
    1df4:	89 cf                	mov    %ecx,%edi
    1df6:	f7 75 c4             	divl   -0x3c(%ebp)
    1df9:	0f b6 92 6c 28 00 00 	movzbl 0x286c(%edx),%edx
    1e00:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1e03:	89 d8                	mov    %ebx,%eax
    1e05:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1e08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    1e0b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    1e0e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1e11:	76 dd                	jbe    1df0 <printint+0x30>
  if(neg)
    1e13:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1e16:	85 c9                	test   %ecx,%ecx
    1e18:	74 0c                	je     1e26 <printint+0x66>
    buf[i++] = '-';
    1e1a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    1e1f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1e21:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1e26:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1e29:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    1e2d:	eb 07                	jmp    1e36 <printint+0x76>
    1e2f:	90                   	nop
    1e30:	0f b6 13             	movzbl (%ebx),%edx
    1e33:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1e36:	83 ec 04             	sub    $0x4,%esp
    1e39:	88 55 d7             	mov    %dl,-0x29(%ebp)
    1e3c:	6a 01                	push   $0x1
    1e3e:	56                   	push   %esi
    1e3f:	57                   	push   %edi
    1e40:	e8 ae fe ff ff       	call   1cf3 <write>
  while(--i >= 0)
    1e45:	83 c4 10             	add    $0x10,%esp
    1e48:	39 de                	cmp    %ebx,%esi
    1e4a:	75 e4                	jne    1e30 <printint+0x70>
    putc(fd, buf[i]);
}
    1e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1e4f:	5b                   	pop    %ebx
    1e50:	5e                   	pop    %esi
    1e51:	5f                   	pop    %edi
    1e52:	5d                   	pop    %ebp
    1e53:	c3                   	ret    
    1e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1e58:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    1e5f:	eb 87                	jmp    1de8 <printint+0x28>
    1e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1e6f:	90                   	nop

00001e70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1e70:	f3 0f 1e fb          	endbr32 
    1e74:	55                   	push   %ebp
    1e75:	89 e5                	mov    %esp,%ebp
    1e77:	57                   	push   %edi
    1e78:	56                   	push   %esi
    1e79:	53                   	push   %ebx
    1e7a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1e7d:	8b 75 0c             	mov    0xc(%ebp),%esi
    1e80:	0f b6 1e             	movzbl (%esi),%ebx
    1e83:	84 db                	test   %bl,%bl
    1e85:	0f 84 b4 00 00 00    	je     1f3f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    1e8b:	8d 45 10             	lea    0x10(%ebp),%eax
    1e8e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1e91:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1e94:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1e96:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1e99:	eb 33                	jmp    1ece <printf+0x5e>
    1e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1e9f:	90                   	nop
    1ea0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1ea3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1ea8:	83 f8 25             	cmp    $0x25,%eax
    1eab:	74 17                	je     1ec4 <printf+0x54>
  write(fd, &c, 1);
    1ead:	83 ec 04             	sub    $0x4,%esp
    1eb0:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1eb3:	6a 01                	push   $0x1
    1eb5:	57                   	push   %edi
    1eb6:	ff 75 08             	pushl  0x8(%ebp)
    1eb9:	e8 35 fe ff ff       	call   1cf3 <write>
    1ebe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1ec1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1ec4:	0f b6 1e             	movzbl (%esi),%ebx
    1ec7:	83 c6 01             	add    $0x1,%esi
    1eca:	84 db                	test   %bl,%bl
    1ecc:	74 71                	je     1f3f <printf+0xcf>
    c = fmt[i] & 0xff;
    1ece:	0f be cb             	movsbl %bl,%ecx
    1ed1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1ed4:	85 d2                	test   %edx,%edx
    1ed6:	74 c8                	je     1ea0 <printf+0x30>
      }
    } else if(state == '%'){
    1ed8:	83 fa 25             	cmp    $0x25,%edx
    1edb:	75 e7                	jne    1ec4 <printf+0x54>
      if(c == 'd'){
    1edd:	83 f8 64             	cmp    $0x64,%eax
    1ee0:	0f 84 9a 00 00 00    	je     1f80 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1ee6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1eec:	83 f9 70             	cmp    $0x70,%ecx
    1eef:	74 5f                	je     1f50 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1ef1:	83 f8 73             	cmp    $0x73,%eax
    1ef4:	0f 84 d6 00 00 00    	je     1fd0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1efa:	83 f8 63             	cmp    $0x63,%eax
    1efd:	0f 84 8d 00 00 00    	je     1f90 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1f03:	83 f8 25             	cmp    $0x25,%eax
    1f06:	0f 84 b4 00 00 00    	je     1fc0 <printf+0x150>
  write(fd, &c, 1);
    1f0c:	83 ec 04             	sub    $0x4,%esp
    1f0f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1f13:	6a 01                	push   $0x1
    1f15:	57                   	push   %edi
    1f16:	ff 75 08             	pushl  0x8(%ebp)
    1f19:	e8 d5 fd ff ff       	call   1cf3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    1f1e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1f21:	83 c4 0c             	add    $0xc,%esp
    1f24:	6a 01                	push   $0x1
    1f26:	83 c6 01             	add    $0x1,%esi
    1f29:	57                   	push   %edi
    1f2a:	ff 75 08             	pushl  0x8(%ebp)
    1f2d:	e8 c1 fd ff ff       	call   1cf3 <write>
  for(i = 0; fmt[i]; i++){
    1f32:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1f36:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1f39:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    1f3b:	84 db                	test   %bl,%bl
    1f3d:	75 8f                	jne    1ece <printf+0x5e>
    }
  }
}
    1f3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1f42:	5b                   	pop    %ebx
    1f43:	5e                   	pop    %esi
    1f44:	5f                   	pop    %edi
    1f45:	5d                   	pop    %ebp
    1f46:	c3                   	ret    
    1f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1f4e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1f50:	83 ec 0c             	sub    $0xc,%esp
    1f53:	b9 10 00 00 00       	mov    $0x10,%ecx
    1f58:	6a 00                	push   $0x0
    1f5a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1f5d:	8b 45 08             	mov    0x8(%ebp),%eax
    1f60:	8b 13                	mov    (%ebx),%edx
    1f62:	e8 59 fe ff ff       	call   1dc0 <printint>
        ap++;
    1f67:	89 d8                	mov    %ebx,%eax
    1f69:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1f6c:	31 d2                	xor    %edx,%edx
        ap++;
    1f6e:	83 c0 04             	add    $0x4,%eax
    1f71:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1f74:	e9 4b ff ff ff       	jmp    1ec4 <printf+0x54>
    1f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1f80:	83 ec 0c             	sub    $0xc,%esp
    1f83:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1f88:	6a 01                	push   $0x1
    1f8a:	eb ce                	jmp    1f5a <printf+0xea>
    1f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1f90:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1f93:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1f96:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1f98:	6a 01                	push   $0x1
        ap++;
    1f9a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    1f9d:	57                   	push   %edi
    1f9e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1fa1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1fa4:	e8 4a fd ff ff       	call   1cf3 <write>
        ap++;
    1fa9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1fac:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1faf:	31 d2                	xor    %edx,%edx
    1fb1:	e9 0e ff ff ff       	jmp    1ec4 <printf+0x54>
    1fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1fbd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1fc0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1fc3:	83 ec 04             	sub    $0x4,%esp
    1fc6:	e9 59 ff ff ff       	jmp    1f24 <printf+0xb4>
    1fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1fcf:	90                   	nop
        s = (char*)*ap;
    1fd0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1fd3:	8b 18                	mov    (%eax),%ebx
        ap++;
    1fd5:	83 c0 04             	add    $0x4,%eax
    1fd8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1fdb:	85 db                	test   %ebx,%ebx
    1fdd:	74 17                	je     1ff6 <printf+0x186>
        while(*s != 0){
    1fdf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1fe2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1fe4:	84 c0                	test   %al,%al
    1fe6:	0f 84 d8 fe ff ff    	je     1ec4 <printf+0x54>
    1fec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    1fef:	89 de                	mov    %ebx,%esi
    1ff1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1ff4:	eb 1a                	jmp    2010 <printf+0x1a0>
          s = "(null)";
    1ff6:	bb 62 28 00 00       	mov    $0x2862,%ebx
        while(*s != 0){
    1ffb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    1ffe:	b8 28 00 00 00       	mov    $0x28,%eax
    2003:	89 de                	mov    %ebx,%esi
    2005:	8b 5d 08             	mov    0x8(%ebp),%ebx
    2008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    200f:	90                   	nop
  write(fd, &c, 1);
    2010:	83 ec 04             	sub    $0x4,%esp
          s++;
    2013:	83 c6 01             	add    $0x1,%esi
    2016:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    2019:	6a 01                	push   $0x1
    201b:	57                   	push   %edi
    201c:	53                   	push   %ebx
    201d:	e8 d1 fc ff ff       	call   1cf3 <write>
        while(*s != 0){
    2022:	0f b6 06             	movzbl (%esi),%eax
    2025:	83 c4 10             	add    $0x10,%esp
    2028:	84 c0                	test   %al,%al
    202a:	75 e4                	jne    2010 <printf+0x1a0>
    202c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    202f:	31 d2                	xor    %edx,%edx
    2031:	e9 8e fe ff ff       	jmp    1ec4 <printf+0x54>
    2036:	66 90                	xchg   %ax,%ax
    2038:	66 90                	xchg   %ax,%ax
    203a:	66 90                	xchg   %ax,%ax
    203c:	66 90                	xchg   %ax,%ax
    203e:	66 90                	xchg   %ax,%ax

00002040 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    2040:	f3 0f 1e fb          	endbr32 
    2044:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2045:	a1 ac 2e 00 00       	mov    0x2eac,%eax
{
    204a:	89 e5                	mov    %esp,%ebp
    204c:	57                   	push   %edi
    204d:	56                   	push   %esi
    204e:	53                   	push   %ebx
    204f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    2052:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    2054:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2057:	39 c8                	cmp    %ecx,%eax
    2059:	73 15                	jae    2070 <free+0x30>
    205b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    205f:	90                   	nop
    2060:	39 d1                	cmp    %edx,%ecx
    2062:	72 14                	jb     2078 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2064:	39 d0                	cmp    %edx,%eax
    2066:	73 10                	jae    2078 <free+0x38>
{
    2068:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    206a:	8b 10                	mov    (%eax),%edx
    206c:	39 c8                	cmp    %ecx,%eax
    206e:	72 f0                	jb     2060 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2070:	39 d0                	cmp    %edx,%eax
    2072:	72 f4                	jb     2068 <free+0x28>
    2074:	39 d1                	cmp    %edx,%ecx
    2076:	73 f0                	jae    2068 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    2078:	8b 73 fc             	mov    -0x4(%ebx),%esi
    207b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    207e:	39 fa                	cmp    %edi,%edx
    2080:	74 1e                	je     20a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    2082:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    2085:	8b 50 04             	mov    0x4(%eax),%edx
    2088:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    208b:	39 f1                	cmp    %esi,%ecx
    208d:	74 28                	je     20b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    208f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    2091:	5b                   	pop    %ebx
  freep = p;
    2092:	a3 ac 2e 00 00       	mov    %eax,0x2eac
}
    2097:	5e                   	pop    %esi
    2098:	5f                   	pop    %edi
    2099:	5d                   	pop    %ebp
    209a:	c3                   	ret    
    209b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    209f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    20a0:	03 72 04             	add    0x4(%edx),%esi
    20a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    20a6:	8b 10                	mov    (%eax),%edx
    20a8:	8b 12                	mov    (%edx),%edx
    20aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    20ad:	8b 50 04             	mov    0x4(%eax),%edx
    20b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    20b3:	39 f1                	cmp    %esi,%ecx
    20b5:	75 d8                	jne    208f <free+0x4f>
    p->s.size += bp->s.size;
    20b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    20ba:	a3 ac 2e 00 00       	mov    %eax,0x2eac
    p->s.size += bp->s.size;
    20bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    20c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    20c5:	89 10                	mov    %edx,(%eax)
}
    20c7:	5b                   	pop    %ebx
    20c8:	5e                   	pop    %esi
    20c9:	5f                   	pop    %edi
    20ca:	5d                   	pop    %ebp
    20cb:	c3                   	ret    
    20cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000020d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    20d0:	f3 0f 1e fb          	endbr32 
    20d4:	55                   	push   %ebp
    20d5:	89 e5                	mov    %esp,%ebp
    20d7:	57                   	push   %edi
    20d8:	56                   	push   %esi
    20d9:	53                   	push   %ebx
    20da:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20dd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    20e0:	8b 3d ac 2e 00 00    	mov    0x2eac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    20e6:	8d 70 07             	lea    0x7(%eax),%esi
    20e9:	c1 ee 03             	shr    $0x3,%esi
    20ec:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    20ef:	85 ff                	test   %edi,%edi
    20f1:	0f 84 a9 00 00 00    	je     21a0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    20f7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    20f9:	8b 48 04             	mov    0x4(%eax),%ecx
    20fc:	39 f1                	cmp    %esi,%ecx
    20fe:	73 6d                	jae    216d <malloc+0x9d>
    2100:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    2106:	bb 00 10 00 00       	mov    $0x1000,%ebx
    210b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    210e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    2115:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    2118:	eb 17                	jmp    2131 <malloc+0x61>
    211a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2120:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    2122:	8b 4a 04             	mov    0x4(%edx),%ecx
    2125:	39 f1                	cmp    %esi,%ecx
    2127:	73 4f                	jae    2178 <malloc+0xa8>
    2129:	8b 3d ac 2e 00 00    	mov    0x2eac,%edi
    212f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    2131:	39 c7                	cmp    %eax,%edi
    2133:	75 eb                	jne    2120 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    2135:	83 ec 0c             	sub    $0xc,%esp
    2138:	ff 75 e4             	pushl  -0x1c(%ebp)
    213b:	e8 1b fc ff ff       	call   1d5b <sbrk>
  if(p == (char*)-1)
    2140:	83 c4 10             	add    $0x10,%esp
    2143:	83 f8 ff             	cmp    $0xffffffff,%eax
    2146:	74 1b                	je     2163 <malloc+0x93>
  hp->s.size = nu;
    2148:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    214b:	83 ec 0c             	sub    $0xc,%esp
    214e:	83 c0 08             	add    $0x8,%eax
    2151:	50                   	push   %eax
    2152:	e8 e9 fe ff ff       	call   2040 <free>
  return freep;
    2157:	a1 ac 2e 00 00       	mov    0x2eac,%eax
      if((p = morecore(nunits)) == 0)
    215c:	83 c4 10             	add    $0x10,%esp
    215f:	85 c0                	test   %eax,%eax
    2161:	75 bd                	jne    2120 <malloc+0x50>
        return 0;
  }
}
    2163:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    2166:	31 c0                	xor    %eax,%eax
}
    2168:	5b                   	pop    %ebx
    2169:	5e                   	pop    %esi
    216a:	5f                   	pop    %edi
    216b:	5d                   	pop    %ebp
    216c:	c3                   	ret    
    if(p->s.size >= nunits){
    216d:	89 c2                	mov    %eax,%edx
    216f:	89 f8                	mov    %edi,%eax
    2171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    2178:	39 ce                	cmp    %ecx,%esi
    217a:	74 54                	je     21d0 <malloc+0x100>
        p->s.size -= nunits;
    217c:	29 f1                	sub    %esi,%ecx
    217e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    2181:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    2184:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    2187:	a3 ac 2e 00 00       	mov    %eax,0x2eac
}
    218c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    218f:	8d 42 08             	lea    0x8(%edx),%eax
}
    2192:	5b                   	pop    %ebx
    2193:	5e                   	pop    %esi
    2194:	5f                   	pop    %edi
    2195:	5d                   	pop    %ebp
    2196:	c3                   	ret    
    2197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    219e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    21a0:	c7 05 ac 2e 00 00 b0 	movl   $0x2eb0,0x2eac
    21a7:	2e 00 00 
    base.s.size = 0;
    21aa:	bf b0 2e 00 00       	mov    $0x2eb0,%edi
    base.s.ptr = freep = prevp = &base;
    21af:	c7 05 b0 2e 00 00 b0 	movl   $0x2eb0,0x2eb0
    21b6:	2e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    21b9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    21bb:	c7 05 b4 2e 00 00 00 	movl   $0x0,0x2eb4
    21c2:	00 00 00 
    if(p->s.size >= nunits){
    21c5:	e9 36 ff ff ff       	jmp    2100 <malloc+0x30>
    21ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    21d0:	8b 0a                	mov    (%edx),%ecx
    21d2:	89 08                	mov    %ecx,(%eax)
    21d4:	eb b1                	jmp    2187 <malloc+0xb7>
