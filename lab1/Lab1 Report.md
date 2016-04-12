# Lab1 Report

---  

##练习1
###1.1 操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
    生成ucore.img的相关代码为:
    
```
 # create ucore.img
UCOREIMG	:= $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img) 
```
    即为了生成ucore.img，首先需要生成bootblock、kernel；
    为了生成bootblock，首先需要生成bootasm.o、bootmain.o、sign；
    为了生成kernel，首先需要 kernel.ld init.o readline.o stdio.o；
    依次查看相关代码即可。

###1.2 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?
    一个磁盘主引导扇区只有512字节。且第510个（倒数第二个）字节是0x55，第511个（倒数第一个）字节是0xAA。
    
##练习2
###2.1 从CPU加电后执行的第一条指令开始,单步跟踪BIOS的执行。
    修改 lab1/tools/gdbinit,内容为:

```
set architecture i8086
target remote :1234

```
    在 lab1目录下，执行make debug,再看到gdb的调试界面(gdb)后，在gdb调试界面下执行如下命令si即可单步跟踪BIOS，改写Makefile文件如下，并删除`tools/gdbinit`中的`continue`行。
```
debug: $(UCOREIMG)
		$(V)$(TERMINAL) -e "$(QEMU) -S -s -d in_asm -D $(BINDIR)/q.log -parallel stdio -hda $< -serial null"
		$(V)sleep 2
		$(V)$(TERMINAL) -e "gdb -q -tui -x tools/gdbinit"
```

###2.2 在初始化位置0x7c00设置实地址断点,测试断点正常。

    在tools/gdbinit结尾加上
```
    set architecture i8086 
	b *0x7c00 
	c          
	x /2i $pc  
	set architecture i386 
```
	
    运行"make debug"即可。

###2.3 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

    在tools/gdbinit结尾加上
```
	b *0x7c00
	c
	x /10i $pc
```
    比较可得知二者相同。

###2.4 自己找一个bootloader或内核中的代码位置，设置断点并进行测试。
    从0x7c10作为断点进行测试并看结果。

##练习3
###3.1 请分析bootloader是如何完成从实模式进入保护模式的。

    从`%cs=0 $pc=0x7c00`进入，后会清理环境：将flag和段寄存器置0
```
	.code16
	    cli
	    cld
	    xorw %ax, %ax
	    movw %ax, %ds
	    movw %ax, %es
	    movw %ax, %ss
```

    开启A20：通过将键盘控制器上的A20线置于高电位，全部32条地址线可用，可以访问4G的内存空间。
```
	seta20.1:               # 
	    inb $0x64, %al      # 
	    testb $0x2, %al     #
	    jnz seta20.1        #
	
	    movb $0xd1, %al     # 
	    outb %al, $0x64     #
	
	seta20.1:               # 
	    inb $0x64, %al      # 
	    testb $0x2, %al     #
	    jnz seta20.1        #
	
	    movb $0xdf, %al     # 
	    outb %al, $0x60     # 
```

    初始化GDT表
```
	    lgdt gdtdesc
```

    通过将cr0寄存器PE位置1开启保护模式
```
	    movl %cr0, %eax
	    orl $CR0_PE_ON, %eax
	    movl %eax, %cr0
```

    通过长跳转更新cs的基地址
```
	 ljmp $PROT_MODE_CSEG, $protcseg
	.code32
	protcseg:
```

    设置段寄存器，并建立堆栈
```
	    movw $PROT_MODE_DSEG, %ax
	    movw %ax, %ds
	    movw %ax, %es
	    movw %ax, %fs
	    movw %ax, %gs
	    movw %ax, %ss
	    movl $0x0, %ebp
	    movl $start, %esp
```

    转到保护模式完成，进入boot主方法
```
	    call bootmain
```

##练习4
###4.1 通过阅读bootmain.c，了解bootloader如何加载ELF文件。 
    首先通过readsect函数从设备的第secno扇区读取数据到dst位置
```
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}
```
    readseg简单包装了readsect，可以从设备读取任意长度的内容。
```
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```
    在bootmain函数中，
```
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}
```

##练习5
###5.1 实现函数调用堆栈跟踪函数 
    ss:ebp指向的堆栈位置储存着caller的ebp，以此为线索可以得到所有使用堆栈的函数ebp；ss:ebp+4指向caller调用时的eip，ss:ebp+8等是（可能的）参数，输出中，堆栈最深一层为
```
	ebp:0x00007bf8 eip:0x00007d68 \
		args:0x00000000 0x00000000 0x00000000 0x00007c4f
	    <unknow>: -- 0x00007d67 --
```

    其对应的是第一个使用堆栈的函数，bootmain.c中的bootmain。bootloader设置的堆栈从0x7c00开始，使用"call bootmain"转入bootmain函数。call指令压栈，所以bootmain中ebp为0x7bf8。

##6 完善中断初始化和处理

###6.1 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

    中断向量表一个表项占用8字节，其中2-3字节是段选择子，0-1字节和6-7字节拼成位移，两者联合便是中断处理程序的入口地址。

###6.2 见代码
###6.3 见代码