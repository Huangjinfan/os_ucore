## Lab5实验报告

### 练习0：填写已有实验

	Done！

### 练习1： 加载应用程序并执行

####练习1.0：请在实验报告中简要说明你的设计实现过程

	加载应用程序需要正确地设置栈帧：

```
     * NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So
     *          tf_cs should be USER_CS segment (see memlayout.h)
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
```

####练习1.1: 当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

	执行switch_to切换进程之后，返回到fortret函数，然后调用fortrets，
	传递参数tf，后面iret的时候，会返回到tf指向的位置。
	tf已经在load_icode中设置为用户态的段，所以就返回到用户态，并开始执行用户态程序。

###练习2: 父进程复制自己的内存空间给子进程

####练习2.0:请补充copy_range的实现，确保能够正确执行

	已补充，能正常执行。

	如果上述前3步执行没有成功，则需要做对应的出错处理，把相关已经占有的内存释放掉。
	在第5步里，为了防止多线程不同步问题，需要暂时关中断。

###练习2.1: 请在实验报告中简要说明如何设计实现”Copy on Write 机制“，给出概要设计，鼓励给出详细设计。

	在dup_mmap中复制mm_struct的时候，直接复制vma的指针，并将对应页的引用计数加一，把页设为只读。
	两个mm_struct共享同一份vma列表，没有发生真实的内存复制。发生缺页的时候，如果引用计数大于1，说明有多个进程共享同一个只读页。
	此时复制物理页（新构建的物理页引用计数为1，可写），让当前进程的页表指向新的页。
	原来的页的引用计数减一，如果减到了1，那么将那一页设为可写。

###练习3：阅读分析源代码，理解进程执行 fork/exec/wait/exit 的实现，以及系统调用的实现

####练习3.1： 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？

	fork：创建一个新的进程，把父进程的当前状态复制之后，令新的进程状态为RUNNABLE。
	exec：将进程的mm置为NULL，然后调用load_icode，将用户进程拷贝进来，为用户进程建立处于用户态的新的内存空间以及用户栈，然后转到用户态执行。 如果load_icode失败，则会调用do_exit退出。
	wait：如果找到了符合条件的子进程，则回收子进程的资源并正常返回；否则如果子进程正在运行，则通过schedule让自己变为SLEEPING，等到下次被唤醒的时候再去寻找子进程。
	exit：首先回收大部分资源，并将当前进程设成ZOMBIE状态，然后查看父进程，如果在等待状态，则唤醒父进程； 接着遍历自己的子进程，把他们的父进程均设置为initproc，如果子进程有ZOMBIE状态且initproc为等待状态则唤醒initproc。

####练习3.2： 请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）

```
PROC_UNINIT(创建)                       PROC_ZOMBIE(结束)
      |                                        ^
      | do_fork                                | do_exit
      v                schedule                |
PROC_RUNNABLE(就绪)-------------------> PROC_RUNNING(运行)
      ^                                        |
      |                                        | do_wait
      |              wakeup_proc               v
      --------------------------------- PROC_SLEEPING(等待)
```

### 重要的知识点
	1. ELF文件的加载，用户进程内存的分配
	2. 虚拟地址和物理页的映射建立
	3. 中断服务例程，特权级的切换
	4. copy on write机制。

### 重要但实验不涉及的知识点
	原理课上讲过的僵尸进程在实验中没有出现
	
