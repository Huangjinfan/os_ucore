
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 f0 11 c0       	mov    $0xc011f000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 0b 12 c0       	mov    $0xc0120bb0,%edx
c0100035:	b8 68 fa 11 c0       	mov    $0xc011fa68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 fa 11 c0 	movl   $0xc011fa68,(%esp)
c0100051:	e8 39 85 00 00       	call   c010858f <memset>

    cons_init();                // init the console
c0100056:	e8 c6 14 00 00       	call   c0101521 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 20 87 10 c0 	movl   $0xc0108720,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 3c 87 10 c0 	movl   $0xc010873c,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 4f 4a 00 00       	call   c0104ad3 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 76 1e 00 00       	call   c0101eff <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 c8 1f 00 00       	call   c0102056 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 6d 70 00 00       	call   c0107100 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 ba 15 00 00       	call   c0101652 <ide_init>
    swap_init();                // init swap
c0100098:	e8 5e 5c 00 00       	call   c0105cfb <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 35 0c 00 00       	call   c0100cd7 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 c6 1d 00 00       	call   c0101e6d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 3e 0b 00 00       	call   c0100c09 <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 41 87 10 c0 	movl   $0xc0108741,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 4f 87 10 c0 	movl   $0xc010874f,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 5d 87 10 c0 	movl   $0xc010875d,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 87 10 c0 	movl   $0xc010876b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 79 87 10 c0 	movl   $0xc0108779,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 fa 11 c0       	mov    %eax,0xc011fa80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 88 87 10 c0 	movl   $0xc0108788,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 a8 87 10 c0 	movl   $0xc01087a8,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 c7 87 10 c0 	movl   $0xc01087c7,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 fa 11 c0    	mov    %dl,-0x3fee0560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 fa 11 c0       	add    $0xc011faa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 fa 11 c0       	mov    $0xc011faa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 44 12 00 00       	call   c010154d <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 8a 79 00 00       	call   c0107cd0 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 cb 11 00 00       	call   c010154d <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 ab 11 00 00       	call   c0101589 <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 cc 87 10 c0    	movl   $0xc01087cc,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 cc 87 10 c0 	movl   $0xc01087cc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 24 a6 10 c0 	movl   $0xc010a624,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 5c 8e 11 c0 	movl   $0xc0118e5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 5d 8e 11 c0 	movl   $0xc0118e5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 d5 c6 11 c0 	movl   $0xc011c6d5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 08 7d 00 00       	call   c0108403 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 d6 87 10 c0 	movl   $0xc01087d6,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 ef 87 10 c0 	movl   $0xc01087ef,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 18 87 10 	movl   $0xc0108718,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 07 88 10 c0 	movl   $0xc0108807,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 fa 11 	movl   $0xc011fa68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 1f 88 10 c0 	movl   $0xc010881f,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 0b 12 	movl   $0xc0120bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 37 88 10 c0 	movl   $0xc0108837,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 50 88 10 c0 	movl   $0xc0108850,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 7a 88 10 c0 	movl   $0xc010887a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 96 88 10 c0 	movl   $0xc0108896,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c01009cc:	5d                   	pop    %ebp
c01009cd:	c3                   	ret    

c01009ce <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c01009ce:	55                   	push   %ebp
c01009cf:	89 e5                	mov    %esp,%ebp
c01009d1:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c01009d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009db:	eb 0c                	jmp    c01009e9 <parse+0x1b>
            *buf ++ = '\0';
c01009dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e0:	8d 50 01             	lea    0x1(%eax),%edx
c01009e3:	89 55 08             	mov    %edx,0x8(%ebp)
c01009e6:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ec:	0f b6 00             	movzbl (%eax),%eax
c01009ef:	84 c0                	test   %al,%al
c01009f1:	74 1d                	je     c0100a10 <parse+0x42>
c01009f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f6:	0f b6 00             	movzbl (%eax),%eax
c01009f9:	0f be c0             	movsbl %al,%eax
c01009fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a00:	c7 04 24 28 89 10 c0 	movl   $0xc0108928,(%esp)
c0100a07:	e8 c4 79 00 00       	call   c01083d0 <strchr>
c0100a0c:	85 c0                	test   %eax,%eax
c0100a0e:	75 cd                	jne    c01009dd <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a13:	0f b6 00             	movzbl (%eax),%eax
c0100a16:	84 c0                	test   %al,%al
c0100a18:	75 02                	jne    c0100a1c <parse+0x4e>
            break;
c0100a1a:	eb 67                	jmp    c0100a83 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a1c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a20:	75 14                	jne    c0100a36 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a22:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100a29:	00 
c0100a2a:	c7 04 24 2d 89 10 c0 	movl   $0xc010892d,(%esp)
c0100a31:	e8 15 f9 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a39:	8d 50 01             	lea    0x1(%eax),%edx
c0100a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100a3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a49:	01 c2                	add    %eax,%edx
c0100a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4e:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a50:	eb 04                	jmp    c0100a56 <parse+0x88>
            buf ++;
c0100a52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a59:	0f b6 00             	movzbl (%eax),%eax
c0100a5c:	84 c0                	test   %al,%al
c0100a5e:	74 1d                	je     c0100a7d <parse+0xaf>
c0100a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a63:	0f b6 00             	movzbl (%eax),%eax
c0100a66:	0f be c0             	movsbl %al,%eax
c0100a69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a6d:	c7 04 24 28 89 10 c0 	movl   $0xc0108928,(%esp)
c0100a74:	e8 57 79 00 00       	call   c01083d0 <strchr>
c0100a79:	85 c0                	test   %eax,%eax
c0100a7b:	74 d5                	je     c0100a52 <parse+0x84>
            buf ++;
        }
    }
c0100a7d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a7e:	e9 66 ff ff ff       	jmp    c01009e9 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a86:	c9                   	leave  
c0100a87:	c3                   	ret    

c0100a88 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a88:	55                   	push   %ebp
c0100a89:	89 e5                	mov    %esp,%ebp
c0100a8b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a8e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a98:	89 04 24             	mov    %eax,(%esp)
c0100a9b:	e8 2e ff ff ff       	call   c01009ce <parse>
c0100aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100aa3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100aa7:	75 0a                	jne    c0100ab3 <runcmd+0x2b>
        return 0;
c0100aa9:	b8 00 00 00 00       	mov    $0x0,%eax
c0100aae:	e9 85 00 00 00       	jmp    c0100b38 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100aba:	eb 5c                	jmp    c0100b18 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100abc:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100abf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ac2:	89 d0                	mov    %edx,%eax
c0100ac4:	01 c0                	add    %eax,%eax
c0100ac6:	01 d0                	add    %edx,%eax
c0100ac8:	c1 e0 02             	shl    $0x2,%eax
c0100acb:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100ad0:	8b 00                	mov    (%eax),%eax
c0100ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ad6:	89 04 24             	mov    %eax,(%esp)
c0100ad9:	e8 53 78 00 00       	call   c0108331 <strcmp>
c0100ade:	85 c0                	test   %eax,%eax
c0100ae0:	75 32                	jne    c0100b14 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ae5:	89 d0                	mov    %edx,%eax
c0100ae7:	01 c0                	add    %eax,%eax
c0100ae9:	01 d0                	add    %edx,%eax
c0100aeb:	c1 e0 02             	shl    $0x2,%eax
c0100aee:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100af3:	8b 40 08             	mov    0x8(%eax),%eax
c0100af6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100af9:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100afc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100aff:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b03:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100b06:	83 c2 04             	add    $0x4,%edx
c0100b09:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b0d:	89 0c 24             	mov    %ecx,(%esp)
c0100b10:	ff d0                	call   *%eax
c0100b12:	eb 24                	jmp    c0100b38 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b1b:	83 f8 02             	cmp    $0x2,%eax
c0100b1e:	76 9c                	jbe    c0100abc <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b20:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b27:	c7 04 24 4b 89 10 c0 	movl   $0xc010894b,(%esp)
c0100b2e:	e8 18 f8 ff ff       	call   c010034b <cprintf>
    return 0;
c0100b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b38:	c9                   	leave  
c0100b39:	c3                   	ret    

c0100b3a <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100b3a:	55                   	push   %ebp
c0100b3b:	89 e5                	mov    %esp,%ebp
c0100b3d:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100b40:	c7 04 24 64 89 10 c0 	movl   $0xc0108964,(%esp)
c0100b47:	e8 ff f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100b4c:	c7 04 24 8c 89 10 c0 	movl   $0xc010898c,(%esp)
c0100b53:	e8 f3 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b5c:	74 0b                	je     c0100b69 <kmonitor+0x2f>
        print_trapframe(tf);
c0100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b61:	89 04 24             	mov    %eax,(%esp)
c0100b64:	e8 39 15 00 00       	call   c01020a2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b69:	c7 04 24 b1 89 10 c0 	movl   $0xc01089b1,(%esp)
c0100b70:	e8 cd f6 ff ff       	call   c0100242 <readline>
c0100b75:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7c:	74 18                	je     c0100b96 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b88:	89 04 24             	mov    %eax,(%esp)
c0100b8b:	e8 f8 fe ff ff       	call   c0100a88 <runcmd>
c0100b90:	85 c0                	test   %eax,%eax
c0100b92:	79 02                	jns    c0100b96 <kmonitor+0x5c>
                break;
c0100b94:	eb 02                	jmp    c0100b98 <kmonitor+0x5e>
            }
        }
    }
c0100b96:	eb d1                	jmp    c0100b69 <kmonitor+0x2f>
}
c0100b98:	c9                   	leave  
c0100b99:	c3                   	ret    

c0100b9a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b9a:	55                   	push   %ebp
c0100b9b:	89 e5                	mov    %esp,%ebp
c0100b9d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ba0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ba7:	eb 3f                	jmp    c0100be8 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bac:	89 d0                	mov    %edx,%eax
c0100bae:	01 c0                	add    %eax,%eax
c0100bb0:	01 d0                	add    %edx,%eax
c0100bb2:	c1 e0 02             	shl    $0x2,%eax
c0100bb5:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100bba:	8b 48 04             	mov    0x4(%eax),%ecx
c0100bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bc0:	89 d0                	mov    %edx,%eax
c0100bc2:	01 c0                	add    %eax,%eax
c0100bc4:	01 d0                	add    %edx,%eax
c0100bc6:	c1 e0 02             	shl    $0x2,%eax
c0100bc9:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100bce:	8b 00                	mov    (%eax),%eax
c0100bd0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd8:	c7 04 24 b5 89 10 c0 	movl   $0xc01089b5,(%esp)
c0100bdf:	e8 67 f7 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100beb:	83 f8 02             	cmp    $0x2,%eax
c0100bee:	76 b9                	jbe    c0100ba9 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf5:	c9                   	leave  
c0100bf6:	c3                   	ret    

c0100bf7 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100bf7:	55                   	push   %ebp
c0100bf8:	89 e5                	mov    %esp,%ebp
c0100bfa:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100bfd:	e8 7d fc ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100c02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c07:	c9                   	leave  
c0100c08:	c3                   	ret    

c0100c09 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c09:	55                   	push   %ebp
c0100c0a:	89 e5                	mov    %esp,%ebp
c0100c0c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c0f:	e8 b5 fd ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100c14:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c19:	c9                   	leave  
c0100c1a:	c3                   	ret    

c0100c1b <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c1b:	55                   	push   %ebp
c0100c1c:	89 e5                	mov    %esp,%ebp
c0100c1e:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100c21:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
c0100c26:	85 c0                	test   %eax,%eax
c0100c28:	74 02                	je     c0100c2c <__panic+0x11>
        goto panic_dead;
c0100c2a:	eb 48                	jmp    c0100c74 <__panic+0x59>
    }
    is_panic = 1;
c0100c2c:	c7 05 a0 fe 11 c0 01 	movl   $0x1,0xc011fea0
c0100c33:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100c36:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c3f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4a:	c7 04 24 be 89 10 c0 	movl   $0xc01089be,(%esp)
c0100c51:	e8 f5 f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c60:	89 04 24             	mov    %eax,(%esp)
c0100c63:	e8 b0 f6 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100c68:	c7 04 24 da 89 10 c0 	movl   $0xc01089da,(%esp)
c0100c6f:	e8 d7 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100c74:	e8 fa 11 00 00       	call   c0101e73 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100c80:	e8 b5 fe ff ff       	call   c0100b3a <kmonitor>
    }
c0100c85:	eb f2                	jmp    c0100c79 <__panic+0x5e>

c0100c87 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100c87:	55                   	push   %ebp
c0100c88:	89 e5                	mov    %esp,%ebp
c0100c8a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100c8d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100c93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c96:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca1:	c7 04 24 dc 89 10 c0 	movl   $0xc01089dc,(%esp)
c0100ca8:	e8 9e f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb4:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cb7:	89 04 24             	mov    %eax,(%esp)
c0100cba:	e8 59 f6 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100cbf:	c7 04 24 da 89 10 c0 	movl   $0xc01089da,(%esp)
c0100cc6:	e8 80 f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100cd0:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
}
c0100cd5:	5d                   	pop    %ebp
c0100cd6:	c3                   	ret    

c0100cd7 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cd7:	55                   	push   %ebp
c0100cd8:	89 e5                	mov    %esp,%ebp
c0100cda:	83 ec 28             	sub    $0x28,%esp
c0100cdd:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100ce3:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ce7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ceb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100cef:	ee                   	out    %al,(%dx)
c0100cf0:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100cf6:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100cfa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100cfe:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d02:	ee                   	out    %al,(%dx)
c0100d03:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100d09:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100d0d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d11:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d15:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d16:	c7 05 bc 0a 12 c0 00 	movl   $0x0,0xc0120abc
c0100d1d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d20:	c7 04 24 fa 89 10 c0 	movl   $0xc01089fa,(%esp)
c0100d27:	e8 1f f6 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100d2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d33:	e8 99 11 00 00       	call   c0101ed1 <pic_enable>
}
c0100d38:	c9                   	leave  
c0100d39:	c3                   	ret    

c0100d3a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d3a:	55                   	push   %ebp
c0100d3b:	89 e5                	mov    %esp,%ebp
c0100d3d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d40:	9c                   	pushf  
c0100d41:	58                   	pop    %eax
c0100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d48:	25 00 02 00 00       	and    $0x200,%eax
c0100d4d:	85 c0                	test   %eax,%eax
c0100d4f:	74 0c                	je     c0100d5d <__intr_save+0x23>
        intr_disable();
c0100d51:	e8 1d 11 00 00       	call   c0101e73 <intr_disable>
        return 1;
c0100d56:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d5b:	eb 05                	jmp    c0100d62 <__intr_save+0x28>
    }
    return 0;
c0100d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d62:	c9                   	leave  
c0100d63:	c3                   	ret    

c0100d64 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
c0100d67:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d6e:	74 05                	je     c0100d75 <__intr_restore+0x11>
        intr_enable();
c0100d70:	e8 f8 10 00 00       	call   c0101e6d <intr_enable>
    }
}
c0100d75:	c9                   	leave  
c0100d76:	c3                   	ret    

c0100d77 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d77:	55                   	push   %ebp
c0100d78:	89 e5                	mov    %esp,%ebp
c0100d7a:	83 ec 10             	sub    $0x10,%esp
c0100d7d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d83:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d87:	89 c2                	mov    %eax,%edx
c0100d89:	ec                   	in     (%dx),%al
c0100d8a:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100d8d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d93:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d97:	89 c2                	mov    %eax,%edx
c0100d99:	ec                   	in     (%dx),%al
c0100d9a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d9d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100da3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100da7:	89 c2                	mov    %eax,%edx
c0100da9:	ec                   	in     (%dx),%al
c0100daa:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100dad:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100db3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100db7:	89 c2                	mov    %eax,%edx
c0100db9:	ec                   	in     (%dx),%al
c0100dba:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100dbd:	c9                   	leave  
c0100dbe:	c3                   	ret    

c0100dbf <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100dbf:	55                   	push   %ebp
c0100dc0:	89 e5                	mov    %esp,%ebp
c0100dc2:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100dc5:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dcf:	0f b7 00             	movzwl (%eax),%eax
c0100dd2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd9:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dde:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100de1:	0f b7 00             	movzwl (%eax),%eax
c0100de4:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100de8:	74 12                	je     c0100dfc <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100dea:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100df1:	66 c7 05 c6 fe 11 c0 	movw   $0x3b4,0xc011fec6
c0100df8:	b4 03 
c0100dfa:	eb 13                	jmp    c0100e0f <cga_init+0x50>
    } else {
        *cp = was;
c0100dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e03:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e06:	66 c7 05 c6 fe 11 c0 	movw   $0x3d4,0xc011fec6
c0100e0d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e0f:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100e16:	0f b7 c0             	movzwl %ax,%eax
c0100e19:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100e1d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e21:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e29:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e2a:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100e31:	83 c0 01             	add    $0x1,%eax
c0100e34:	0f b7 c0             	movzwl %ax,%eax
c0100e37:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3b:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e3f:	89 c2                	mov    %eax,%edx
c0100e41:	ec                   	in     (%dx),%al
c0100e42:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e45:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e49:	0f b6 c0             	movzbl %al,%eax
c0100e4c:	c1 e0 08             	shl    $0x8,%eax
c0100e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e52:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100e59:	0f b7 c0             	movzwl %ax,%eax
c0100e5c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100e60:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e64:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e68:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e6c:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e6d:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100e74:	83 c0 01             	add    $0x1,%eax
c0100e77:	0f b7 c0             	movzwl %ax,%eax
c0100e7a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e7e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100e82:	89 c2                	mov    %eax,%edx
c0100e84:	ec                   	in     (%dx),%al
c0100e85:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100e88:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e8c:	0f b6 c0             	movzbl %al,%eax
c0100e8f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e95:	a3 c0 fe 11 c0       	mov    %eax,0xc011fec0
    crt_pos = pos;
c0100e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e9d:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
}
c0100ea3:	c9                   	leave  
c0100ea4:	c3                   	ret    

c0100ea5 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100ea5:	55                   	push   %ebp
c0100ea6:	89 e5                	mov    %esp,%ebp
c0100ea8:	83 ec 48             	sub    $0x48,%esp
c0100eab:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100eb1:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb5:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eb9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ebd:	ee                   	out    %al,(%dx)
c0100ebe:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100ec4:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100ec8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ecc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed0:	ee                   	out    %al,(%dx)
c0100ed1:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100ed7:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100edb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100edf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ee3:	ee                   	out    %al,(%dx)
c0100ee4:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100eea:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100eee:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ef2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ef6:	ee                   	out    %al,(%dx)
c0100ef7:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100efd:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100f01:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f05:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f09:	ee                   	out    %al,(%dx)
c0100f0a:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100f10:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100f14:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f18:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f1c:	ee                   	out    %al,(%dx)
c0100f1d:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f23:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100f27:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f2b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f2f:	ee                   	out    %al,(%dx)
c0100f30:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f36:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100f3a:	89 c2                	mov    %eax,%edx
c0100f3c:	ec                   	in     (%dx),%al
c0100f3d:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100f40:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f44:	3c ff                	cmp    $0xff,%al
c0100f46:	0f 95 c0             	setne  %al
c0100f49:	0f b6 c0             	movzbl %al,%eax
c0100f4c:	a3 c8 fe 11 c0       	mov    %eax,0xc011fec8
c0100f51:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f57:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100f5b:	89 c2                	mov    %eax,%edx
c0100f5d:	ec                   	in     (%dx),%al
c0100f5e:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100f61:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100f67:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100f6b:	89 c2                	mov    %eax,%edx
c0100f6d:	ec                   	in     (%dx),%al
c0100f6e:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f71:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0100f76:	85 c0                	test   %eax,%eax
c0100f78:	74 0c                	je     c0100f86 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0100f7a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f81:	e8 4b 0f 00 00       	call   c0101ed1 <pic_enable>
    }
}
c0100f86:	c9                   	leave  
c0100f87:	c3                   	ret    

c0100f88 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f88:	55                   	push   %ebp
c0100f89:	89 e5                	mov    %esp,%ebp
c0100f8b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f95:	eb 09                	jmp    c0100fa0 <lpt_putc_sub+0x18>
        delay();
c0100f97:	e8 db fd ff ff       	call   c0100d77 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f9c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100fa0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100fa6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100faa:	89 c2                	mov    %eax,%edx
c0100fac:	ec                   	in     (%dx),%al
c0100fad:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fb0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100fb4:	84 c0                	test   %al,%al
c0100fb6:	78 09                	js     c0100fc1 <lpt_putc_sub+0x39>
c0100fb8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fbf:	7e d6                	jle    c0100f97 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0100fc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fc4:	0f b6 c0             	movzbl %al,%eax
c0100fc7:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0100fcd:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fd0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fd4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fd8:	ee                   	out    %al,(%dx)
c0100fd9:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100fdf:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fe3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fe7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100feb:	ee                   	out    %al,(%dx)
c0100fec:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0100ff2:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0100ff6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ffa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ffe:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100fff:	c9                   	leave  
c0101000:	c3                   	ret    

c0101001 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101001:	55                   	push   %ebp
c0101002:	89 e5                	mov    %esp,%ebp
c0101004:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101007:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010100b:	74 0d                	je     c010101a <lpt_putc+0x19>
        lpt_putc_sub(c);
c010100d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101010:	89 04 24             	mov    %eax,(%esp)
c0101013:	e8 70 ff ff ff       	call   c0100f88 <lpt_putc_sub>
c0101018:	eb 24                	jmp    c010103e <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c010101a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101021:	e8 62 ff ff ff       	call   c0100f88 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101026:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010102d:	e8 56 ff ff ff       	call   c0100f88 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101032:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101039:	e8 4a ff ff ff       	call   c0100f88 <lpt_putc_sub>
    }
}
c010103e:	c9                   	leave  
c010103f:	c3                   	ret    

c0101040 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101040:	55                   	push   %ebp
c0101041:	89 e5                	mov    %esp,%ebp
c0101043:	53                   	push   %ebx
c0101044:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101047:	8b 45 08             	mov    0x8(%ebp),%eax
c010104a:	b0 00                	mov    $0x0,%al
c010104c:	85 c0                	test   %eax,%eax
c010104e:	75 07                	jne    c0101057 <cga_putc+0x17>
        c |= 0x0700;
c0101050:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101057:	8b 45 08             	mov    0x8(%ebp),%eax
c010105a:	0f b6 c0             	movzbl %al,%eax
c010105d:	83 f8 0a             	cmp    $0xa,%eax
c0101060:	74 4c                	je     c01010ae <cga_putc+0x6e>
c0101062:	83 f8 0d             	cmp    $0xd,%eax
c0101065:	74 57                	je     c01010be <cga_putc+0x7e>
c0101067:	83 f8 08             	cmp    $0x8,%eax
c010106a:	0f 85 88 00 00 00    	jne    c01010f8 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101070:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101077:	66 85 c0             	test   %ax,%ax
c010107a:	74 30                	je     c01010ac <cga_putc+0x6c>
            crt_pos --;
c010107c:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101083:	83 e8 01             	sub    $0x1,%eax
c0101086:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010108c:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c0101091:	0f b7 15 c4 fe 11 c0 	movzwl 0xc011fec4,%edx
c0101098:	0f b7 d2             	movzwl %dx,%edx
c010109b:	01 d2                	add    %edx,%edx
c010109d:	01 c2                	add    %eax,%edx
c010109f:	8b 45 08             	mov    0x8(%ebp),%eax
c01010a2:	b0 00                	mov    $0x0,%al
c01010a4:	83 c8 20             	or     $0x20,%eax
c01010a7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01010aa:	eb 72                	jmp    c010111e <cga_putc+0xde>
c01010ac:	eb 70                	jmp    c010111e <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c01010ae:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01010b5:	83 c0 50             	add    $0x50,%eax
c01010b8:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010be:	0f b7 1d c4 fe 11 c0 	movzwl 0xc011fec4,%ebx
c01010c5:	0f b7 0d c4 fe 11 c0 	movzwl 0xc011fec4,%ecx
c01010cc:	0f b7 c1             	movzwl %cx,%eax
c01010cf:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01010d5:	c1 e8 10             	shr    $0x10,%eax
c01010d8:	89 c2                	mov    %eax,%edx
c01010da:	66 c1 ea 06          	shr    $0x6,%dx
c01010de:	89 d0                	mov    %edx,%eax
c01010e0:	c1 e0 02             	shl    $0x2,%eax
c01010e3:	01 d0                	add    %edx,%eax
c01010e5:	c1 e0 04             	shl    $0x4,%eax
c01010e8:	29 c1                	sub    %eax,%ecx
c01010ea:	89 ca                	mov    %ecx,%edx
c01010ec:	89 d8                	mov    %ebx,%eax
c01010ee:	29 d0                	sub    %edx,%eax
c01010f0:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
        break;
c01010f6:	eb 26                	jmp    c010111e <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010f8:	8b 0d c0 fe 11 c0    	mov    0xc011fec0,%ecx
c01010fe:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101105:	8d 50 01             	lea    0x1(%eax),%edx
c0101108:	66 89 15 c4 fe 11 c0 	mov    %dx,0xc011fec4
c010110f:	0f b7 c0             	movzwl %ax,%eax
c0101112:	01 c0                	add    %eax,%eax
c0101114:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101117:	8b 45 08             	mov    0x8(%ebp),%eax
c010111a:	66 89 02             	mov    %ax,(%edx)
        break;
c010111d:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010111e:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101125:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101129:	76 5b                	jbe    c0101186 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010112b:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c0101130:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101136:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c010113b:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101142:	00 
c0101143:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101147:	89 04 24             	mov    %eax,(%esp)
c010114a:	e8 7f 74 00 00       	call   c01085ce <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010114f:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101156:	eb 15                	jmp    c010116d <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101158:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c010115d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101160:	01 d2                	add    %edx,%edx
c0101162:	01 d0                	add    %edx,%eax
c0101164:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101169:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010116d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101174:	7e e2                	jle    c0101158 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101176:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010117d:	83 e8 50             	sub    $0x50,%eax
c0101180:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101186:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c010118d:	0f b7 c0             	movzwl %ax,%eax
c0101190:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101194:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101198:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010119c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01011a1:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011a8:	66 c1 e8 08          	shr    $0x8,%ax
c01011ac:	0f b6 c0             	movzbl %al,%eax
c01011af:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c01011b6:	83 c2 01             	add    $0x1,%edx
c01011b9:	0f b7 d2             	movzwl %dx,%edx
c01011bc:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01011c0:	88 45 ed             	mov    %al,-0x13(%ebp)
c01011c3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011c7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011cb:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011cc:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c01011d3:	0f b7 c0             	movzwl %ax,%eax
c01011d6:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01011da:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01011de:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011e2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01011e6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011e7:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011ee:	0f b6 c0             	movzbl %al,%eax
c01011f1:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c01011f8:	83 c2 01             	add    $0x1,%edx
c01011fb:	0f b7 d2             	movzwl %dx,%edx
c01011fe:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101202:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101205:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101209:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010120d:	ee                   	out    %al,(%dx)
}
c010120e:	83 c4 34             	add    $0x34,%esp
c0101211:	5b                   	pop    %ebx
c0101212:	5d                   	pop    %ebp
c0101213:	c3                   	ret    

c0101214 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101214:	55                   	push   %ebp
c0101215:	89 e5                	mov    %esp,%ebp
c0101217:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101221:	eb 09                	jmp    c010122c <serial_putc_sub+0x18>
        delay();
c0101223:	e8 4f fb ff ff       	call   c0100d77 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101228:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010122c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101232:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101236:	89 c2                	mov    %eax,%edx
c0101238:	ec                   	in     (%dx),%al
c0101239:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010123c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101240:	0f b6 c0             	movzbl %al,%eax
c0101243:	83 e0 20             	and    $0x20,%eax
c0101246:	85 c0                	test   %eax,%eax
c0101248:	75 09                	jne    c0101253 <serial_putc_sub+0x3f>
c010124a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101251:	7e d0                	jle    c0101223 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101253:	8b 45 08             	mov    0x8(%ebp),%eax
c0101256:	0f b6 c0             	movzbl %al,%eax
c0101259:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010125f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101262:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101266:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010126a:	ee                   	out    %al,(%dx)
}
c010126b:	c9                   	leave  
c010126c:	c3                   	ret    

c010126d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010126d:	55                   	push   %ebp
c010126e:	89 e5                	mov    %esp,%ebp
c0101270:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101273:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101277:	74 0d                	je     c0101286 <serial_putc+0x19>
        serial_putc_sub(c);
c0101279:	8b 45 08             	mov    0x8(%ebp),%eax
c010127c:	89 04 24             	mov    %eax,(%esp)
c010127f:	e8 90 ff ff ff       	call   c0101214 <serial_putc_sub>
c0101284:	eb 24                	jmp    c01012aa <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101286:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010128d:	e8 82 ff ff ff       	call   c0101214 <serial_putc_sub>
        serial_putc_sub(' ');
c0101292:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101299:	e8 76 ff ff ff       	call   c0101214 <serial_putc_sub>
        serial_putc_sub('\b');
c010129e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01012a5:	e8 6a ff ff ff       	call   c0101214 <serial_putc_sub>
    }
}
c01012aa:	c9                   	leave  
c01012ab:	c3                   	ret    

c01012ac <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01012ac:	55                   	push   %ebp
c01012ad:	89 e5                	mov    %esp,%ebp
c01012af:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012b2:	eb 33                	jmp    c01012e7 <cons_intr+0x3b>
        if (c != 0) {
c01012b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012b8:	74 2d                	je     c01012e7 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012ba:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	89 15 e4 00 12 c0    	mov    %edx,0xc01200e4
c01012c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cb:	88 90 e0 fe 11 c0    	mov    %dl,-0x3fee0120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012d1:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c01012d6:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012db:	75 0a                	jne    c01012e7 <cons_intr+0x3b>
                cons.wpos = 0;
c01012dd:	c7 05 e4 00 12 c0 00 	movl   $0x0,0xc01200e4
c01012e4:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01012e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ea:	ff d0                	call   *%eax
c01012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012f3:	75 bf                	jne    c01012b4 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01012f5:	c9                   	leave  
c01012f6:	c3                   	ret    

c01012f7 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012f7:	55                   	push   %ebp
c01012f8:	89 e5                	mov    %esp,%ebp
c01012fa:	83 ec 10             	sub    $0x10,%esp
c01012fd:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101303:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101307:	89 c2                	mov    %eax,%edx
c0101309:	ec                   	in     (%dx),%al
c010130a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010130d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101311:	0f b6 c0             	movzbl %al,%eax
c0101314:	83 e0 01             	and    $0x1,%eax
c0101317:	85 c0                	test   %eax,%eax
c0101319:	75 07                	jne    c0101322 <serial_proc_data+0x2b>
        return -1;
c010131b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101320:	eb 2a                	jmp    c010134c <serial_proc_data+0x55>
c0101322:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101328:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010132c:	89 c2                	mov    %eax,%edx
c010132e:	ec                   	in     (%dx),%al
c010132f:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101332:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101336:	0f b6 c0             	movzbl %al,%eax
c0101339:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010133c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101340:	75 07                	jne    c0101349 <serial_proc_data+0x52>
        c = '\b';
c0101342:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010134c:	c9                   	leave  
c010134d:	c3                   	ret    

c010134e <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010134e:	55                   	push   %ebp
c010134f:	89 e5                	mov    %esp,%ebp
c0101351:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101354:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0101359:	85 c0                	test   %eax,%eax
c010135b:	74 0c                	je     c0101369 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010135d:	c7 04 24 f7 12 10 c0 	movl   $0xc01012f7,(%esp)
c0101364:	e8 43 ff ff ff       	call   c01012ac <cons_intr>
    }
}
c0101369:	c9                   	leave  
c010136a:	c3                   	ret    

c010136b <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010136b:	55                   	push   %ebp
c010136c:	89 e5                	mov    %esp,%ebp
c010136e:	83 ec 38             	sub    $0x38,%esp
c0101371:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101377:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010137b:	89 c2                	mov    %eax,%edx
c010137d:	ec                   	in     (%dx),%al
c010137e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101381:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101385:	0f b6 c0             	movzbl %al,%eax
c0101388:	83 e0 01             	and    $0x1,%eax
c010138b:	85 c0                	test   %eax,%eax
c010138d:	75 0a                	jne    c0101399 <kbd_proc_data+0x2e>
        return -1;
c010138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101394:	e9 59 01 00 00       	jmp    c01014f2 <kbd_proc_data+0x187>
c0101399:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010139f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01013a3:	89 c2                	mov    %eax,%edx
c01013a5:	ec                   	in     (%dx),%al
c01013a6:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c01013a9:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01013ad:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013b0:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013b4:	75 17                	jne    c01013cd <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c01013b6:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01013bb:	83 c8 40             	or     $0x40,%eax
c01013be:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c01013c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01013c8:	e9 25 01 00 00       	jmp    c01014f2 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01013cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d1:	84 c0                	test   %al,%al
c01013d3:	79 47                	jns    c010141c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013d5:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01013da:	83 e0 40             	and    $0x40,%eax
c01013dd:	85 c0                	test   %eax,%eax
c01013df:	75 09                	jne    c01013ea <kbd_proc_data+0x7f>
c01013e1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e5:	83 e0 7f             	and    $0x7f,%eax
c01013e8:	eb 04                	jmp    c01013ee <kbd_proc_data+0x83>
c01013ea:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013ee:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013f5:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01013fc:	83 c8 40             	or     $0x40,%eax
c01013ff:	0f b6 c0             	movzbl %al,%eax
c0101402:	f7 d0                	not    %eax
c0101404:	89 c2                	mov    %eax,%edx
c0101406:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010140b:	21 d0                	and    %edx,%eax
c010140d:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c0101412:	b8 00 00 00 00       	mov    $0x0,%eax
c0101417:	e9 d6 00 00 00       	jmp    c01014f2 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010141c:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101421:	83 e0 40             	and    $0x40,%eax
c0101424:	85 c0                	test   %eax,%eax
c0101426:	74 11                	je     c0101439 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101428:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010142c:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101431:	83 e0 bf             	and    $0xffffffbf,%eax
c0101434:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    }

    shift |= shiftcode[data];
c0101439:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010143d:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c0101444:	0f b6 d0             	movzbl %al,%edx
c0101447:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010144c:	09 d0                	or     %edx,%eax
c010144e:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    shift ^= togglecode[data];
c0101453:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101457:	0f b6 80 60 f1 11 c0 	movzbl -0x3fee0ea0(%eax),%eax
c010145e:	0f b6 d0             	movzbl %al,%edx
c0101461:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101466:	31 d0                	xor    %edx,%eax
c0101468:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8

    c = charcode[shift & (CTL | SHIFT)][data];
c010146d:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101472:	83 e0 03             	and    $0x3,%eax
c0101475:	8b 14 85 60 f5 11 c0 	mov    -0x3fee0aa0(,%eax,4),%edx
c010147c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101480:	01 d0                	add    %edx,%eax
c0101482:	0f b6 00             	movzbl (%eax),%eax
c0101485:	0f b6 c0             	movzbl %al,%eax
c0101488:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010148b:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101490:	83 e0 08             	and    $0x8,%eax
c0101493:	85 c0                	test   %eax,%eax
c0101495:	74 22                	je     c01014b9 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101497:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010149b:	7e 0c                	jle    c01014a9 <kbd_proc_data+0x13e>
c010149d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01014a1:	7f 06                	jg     c01014a9 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c01014a3:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01014a7:	eb 10                	jmp    c01014b9 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c01014a9:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01014ad:	7e 0a                	jle    c01014b9 <kbd_proc_data+0x14e>
c01014af:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014b3:	7f 04                	jg     c01014b9 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c01014b5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014b9:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014be:	f7 d0                	not    %eax
c01014c0:	83 e0 06             	and    $0x6,%eax
c01014c3:	85 c0                	test   %eax,%eax
c01014c5:	75 28                	jne    c01014ef <kbd_proc_data+0x184>
c01014c7:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014ce:	75 1f                	jne    c01014ef <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01014d0:	c7 04 24 15 8a 10 c0 	movl   $0xc0108a15,(%esp)
c01014d7:	e8 6f ee ff ff       	call   c010034b <cprintf>
c01014dc:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01014e2:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014ea:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014ee:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014f2:	c9                   	leave  
c01014f3:	c3                   	ret    

c01014f4 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014f4:	55                   	push   %ebp
c01014f5:	89 e5                	mov    %esp,%ebp
c01014f7:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014fa:	c7 04 24 6b 13 10 c0 	movl   $0xc010136b,(%esp)
c0101501:	e8 a6 fd ff ff       	call   c01012ac <cons_intr>
}
c0101506:	c9                   	leave  
c0101507:	c3                   	ret    

c0101508 <kbd_init>:

static void
kbd_init(void) {
c0101508:	55                   	push   %ebp
c0101509:	89 e5                	mov    %esp,%ebp
c010150b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010150e:	e8 e1 ff ff ff       	call   c01014f4 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101513:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010151a:	e8 b2 09 00 00       	call   c0101ed1 <pic_enable>
}
c010151f:	c9                   	leave  
c0101520:	c3                   	ret    

c0101521 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101521:	55                   	push   %ebp
c0101522:	89 e5                	mov    %esp,%ebp
c0101524:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101527:	e8 93 f8 ff ff       	call   c0100dbf <cga_init>
    serial_init();
c010152c:	e8 74 f9 ff ff       	call   c0100ea5 <serial_init>
    kbd_init();
c0101531:	e8 d2 ff ff ff       	call   c0101508 <kbd_init>
    if (!serial_exists) {
c0101536:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c010153b:	85 c0                	test   %eax,%eax
c010153d:	75 0c                	jne    c010154b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010153f:	c7 04 24 21 8a 10 c0 	movl   $0xc0108a21,(%esp)
c0101546:	e8 00 ee ff ff       	call   c010034b <cprintf>
    }
}
c010154b:	c9                   	leave  
c010154c:	c3                   	ret    

c010154d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010154d:	55                   	push   %ebp
c010154e:	89 e5                	mov    %esp,%ebp
c0101550:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101553:	e8 e2 f7 ff ff       	call   c0100d3a <__intr_save>
c0101558:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010155b:	8b 45 08             	mov    0x8(%ebp),%eax
c010155e:	89 04 24             	mov    %eax,(%esp)
c0101561:	e8 9b fa ff ff       	call   c0101001 <lpt_putc>
        cga_putc(c);
c0101566:	8b 45 08             	mov    0x8(%ebp),%eax
c0101569:	89 04 24             	mov    %eax,(%esp)
c010156c:	e8 cf fa ff ff       	call   c0101040 <cga_putc>
        serial_putc(c);
c0101571:	8b 45 08             	mov    0x8(%ebp),%eax
c0101574:	89 04 24             	mov    %eax,(%esp)
c0101577:	e8 f1 fc ff ff       	call   c010126d <serial_putc>
    }
    local_intr_restore(intr_flag);
c010157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010157f:	89 04 24             	mov    %eax,(%esp)
c0101582:	e8 dd f7 ff ff       	call   c0100d64 <__intr_restore>
}
c0101587:	c9                   	leave  
c0101588:	c3                   	ret    

c0101589 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101589:	55                   	push   %ebp
c010158a:	89 e5                	mov    %esp,%ebp
c010158c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010158f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101596:	e8 9f f7 ff ff       	call   c0100d3a <__intr_save>
c010159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010159e:	e8 ab fd ff ff       	call   c010134e <serial_intr>
        kbd_intr();
c01015a3:	e8 4c ff ff ff       	call   c01014f4 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01015a8:	8b 15 e0 00 12 c0    	mov    0xc01200e0,%edx
c01015ae:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c01015b3:	39 c2                	cmp    %eax,%edx
c01015b5:	74 31                	je     c01015e8 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015b7:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c01015bc:	8d 50 01             	lea    0x1(%eax),%edx
c01015bf:	89 15 e0 00 12 c0    	mov    %edx,0xc01200e0
c01015c5:	0f b6 80 e0 fe 11 c0 	movzbl -0x3fee0120(%eax),%eax
c01015cc:	0f b6 c0             	movzbl %al,%eax
c01015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015d2:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c01015d7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015dc:	75 0a                	jne    c01015e8 <cons_getc+0x5f>
                cons.rpos = 0;
c01015de:	c7 05 e0 00 12 c0 00 	movl   $0x0,0xc01200e0
c01015e5:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015eb:	89 04 24             	mov    %eax,(%esp)
c01015ee:	e8 71 f7 ff ff       	call   c0100d64 <__intr_restore>
    return c;
c01015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 14             	sub    $0x14,%esp
c01015fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101601:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0101605:	90                   	nop
c0101606:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010160a:	83 c0 07             	add    $0x7,%eax
c010160d:	0f b7 c0             	movzwl %ax,%eax
c0101610:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101614:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101618:	89 c2                	mov    %eax,%edx
c010161a:	ec                   	in     (%dx),%al
c010161b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010161e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101622:	0f b6 c0             	movzbl %al,%eax
c0101625:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0101628:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010162b:	25 80 00 00 00       	and    $0x80,%eax
c0101630:	85 c0                	test   %eax,%eax
c0101632:	75 d2                	jne    c0101606 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101634:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101638:	74 11                	je     c010164b <ide_wait_ready+0x53>
c010163a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010163d:	83 e0 21             	and    $0x21,%eax
c0101640:	85 c0                	test   %eax,%eax
c0101642:	74 07                	je     c010164b <ide_wait_ready+0x53>
        return -1;
c0101644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101649:	eb 05                	jmp    c0101650 <ide_wait_ready+0x58>
    }
    return 0;
c010164b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101650:	c9                   	leave  
c0101651:	c3                   	ret    

c0101652 <ide_init>:

void
ide_init(void) {
c0101652:	55                   	push   %ebp
c0101653:	89 e5                	mov    %esp,%ebp
c0101655:	57                   	push   %edi
c0101656:	53                   	push   %ebx
c0101657:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010165d:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101663:	e9 d6 02 00 00       	jmp    c010193e <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101668:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010166c:	c1 e0 03             	shl    $0x3,%eax
c010166f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101676:	29 c2                	sub    %eax,%edx
c0101678:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010167e:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101681:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101685:	66 d1 e8             	shr    %ax
c0101688:	0f b7 c0             	movzwl %ax,%eax
c010168b:	0f b7 04 85 40 8a 10 	movzwl -0x3fef75c0(,%eax,4),%eax
c0101692:	c0 
c0101693:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101697:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010169b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01016a2:	00 
c01016a3:	89 04 24             	mov    %eax,(%esp)
c01016a6:	e8 4d ff ff ff       	call   c01015f8 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c01016ab:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01016af:	83 e0 01             	and    $0x1,%eax
c01016b2:	c1 e0 04             	shl    $0x4,%eax
c01016b5:	83 c8 e0             	or     $0xffffffe0,%eax
c01016b8:	0f b6 c0             	movzbl %al,%eax
c01016bb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01016bf:	83 c2 06             	add    $0x6,%edx
c01016c2:	0f b7 d2             	movzwl %dx,%edx
c01016c5:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c01016c9:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016cc:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01016d0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01016d4:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01016d5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01016d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01016e0:	00 
c01016e1:	89 04 24             	mov    %eax,(%esp)
c01016e4:	e8 0f ff ff ff       	call   c01015f8 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01016e9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01016ed:	83 c0 07             	add    $0x7,%eax
c01016f0:	0f b7 c0             	movzwl %ax,%eax
c01016f3:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01016f7:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01016fb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01016ff:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101703:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101704:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101708:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010170f:	00 
c0101710:	89 04 24             	mov    %eax,(%esp)
c0101713:	e8 e0 fe ff ff       	call   c01015f8 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0101718:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010171c:	83 c0 07             	add    $0x7,%eax
c010171f:	0f b7 c0             	movzwl %ax,%eax
c0101722:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101726:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c010172a:	89 c2                	mov    %eax,%edx
c010172c:	ec                   	in     (%dx),%al
c010172d:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c0101730:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101734:	84 c0                	test   %al,%al
c0101736:	0f 84 f7 01 00 00    	je     c0101933 <ide_init+0x2e1>
c010173c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101740:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101747:	00 
c0101748:	89 04 24             	mov    %eax,(%esp)
c010174b:	e8 a8 fe ff ff       	call   c01015f8 <ide_wait_ready>
c0101750:	85 c0                	test   %eax,%eax
c0101752:	0f 85 db 01 00 00    	jne    c0101933 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101758:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010175c:	c1 e0 03             	shl    $0x3,%eax
c010175f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101766:	29 c2                	sub    %eax,%edx
c0101768:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010176e:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101771:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101775:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101778:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010177e:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101781:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101788:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010178b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010178e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101791:	89 cb                	mov    %ecx,%ebx
c0101793:	89 df                	mov    %ebx,%edi
c0101795:	89 c1                	mov    %eax,%ecx
c0101797:	fc                   	cld    
c0101798:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010179a:	89 c8                	mov    %ecx,%eax
c010179c:	89 fb                	mov    %edi,%ebx
c010179e:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c01017a1:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c01017a4:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c01017aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c01017ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01017b0:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c01017b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c01017b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01017bc:	25 00 00 00 04       	and    $0x4000000,%eax
c01017c1:	85 c0                	test   %eax,%eax
c01017c3:	74 0e                	je     c01017d3 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c01017c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01017c8:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c01017ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01017d1:	eb 09                	jmp    c01017dc <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c01017d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01017d6:	8b 40 78             	mov    0x78(%eax),%eax
c01017d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c01017dc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017e0:	c1 e0 03             	shl    $0x3,%eax
c01017e3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01017ea:	29 c2                	sub    %eax,%edx
c01017ec:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01017f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01017f5:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01017f8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01017fc:	c1 e0 03             	shl    $0x3,%eax
c01017ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101806:	29 c2                	sub    %eax,%edx
c0101808:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c010180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101811:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0101814:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101817:	83 c0 62             	add    $0x62,%eax
c010181a:	0f b7 00             	movzwl (%eax),%eax
c010181d:	0f b7 c0             	movzwl %ax,%eax
c0101820:	25 00 02 00 00       	and    $0x200,%eax
c0101825:	85 c0                	test   %eax,%eax
c0101827:	75 24                	jne    c010184d <ide_init+0x1fb>
c0101829:	c7 44 24 0c 48 8a 10 	movl   $0xc0108a48,0xc(%esp)
c0101830:	c0 
c0101831:	c7 44 24 08 8b 8a 10 	movl   $0xc0108a8b,0x8(%esp)
c0101838:	c0 
c0101839:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101840:	00 
c0101841:	c7 04 24 a0 8a 10 c0 	movl   $0xc0108aa0,(%esp)
c0101848:	e8 ce f3 ff ff       	call   c0100c1b <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010184d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101851:	c1 e0 03             	shl    $0x3,%eax
c0101854:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010185b:	29 c2                	sub    %eax,%edx
c010185d:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101863:	83 c0 0c             	add    $0xc,%eax
c0101866:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186c:	83 c0 36             	add    $0x36,%eax
c010186f:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101872:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101879:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101880:	eb 34                	jmp    c01018b6 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101882:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101885:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101888:	01 c2                	add    %eax,%edx
c010188a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010188d:	8d 48 01             	lea    0x1(%eax),%ecx
c0101890:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101893:	01 c8                	add    %ecx,%eax
c0101895:	0f b6 00             	movzbl (%eax),%eax
c0101898:	88 02                	mov    %al,(%edx)
c010189a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010189d:	8d 50 01             	lea    0x1(%eax),%edx
c01018a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01018a3:	01 c2                	add    %eax,%edx
c01018a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01018a8:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c01018ab:	01 c8                	add    %ecx,%eax
c01018ad:	0f b6 00             	movzbl (%eax),%eax
c01018b0:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c01018b2:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c01018b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01018b9:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c01018bc:	72 c4                	jb     c0101882 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c01018be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01018c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01018c4:	01 d0                	add    %edx,%eax
c01018c6:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c01018c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01018cc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01018cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01018d2:	85 c0                	test   %eax,%eax
c01018d4:	74 0f                	je     c01018e5 <ide_init+0x293>
c01018d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01018d9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01018dc:	01 d0                	add    %edx,%eax
c01018de:	0f b6 00             	movzbl (%eax),%eax
c01018e1:	3c 20                	cmp    $0x20,%al
c01018e3:	74 d9                	je     c01018be <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01018e5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018e9:	c1 e0 03             	shl    $0x3,%eax
c01018ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018f3:	29 c2                	sub    %eax,%edx
c01018f5:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01018fb:	8d 48 0c             	lea    0xc(%eax),%ecx
c01018fe:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101902:	c1 e0 03             	shl    $0x3,%eax
c0101905:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010190c:	29 c2                	sub    %eax,%edx
c010190e:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101914:	8b 50 08             	mov    0x8(%eax),%edx
c0101917:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010191b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010191f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101923:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101927:	c7 04 24 b2 8a 10 c0 	movl   $0xc0108ab2,(%esp)
c010192e:	e8 18 ea ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101933:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101937:	83 c0 01             	add    $0x1,%eax
c010193a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c010193e:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101943:	0f 86 1f fd ff ff    	jbe    c0101668 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101949:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101950:	e8 7c 05 00 00       	call   c0101ed1 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101955:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c010195c:	e8 70 05 00 00       	call   c0101ed1 <pic_enable>
}
c0101961:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101967:	5b                   	pop    %ebx
c0101968:	5f                   	pop    %edi
c0101969:	5d                   	pop    %ebp
c010196a:	c3                   	ret    

c010196b <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c010196b:	55                   	push   %ebp
c010196c:	89 e5                	mov    %esp,%ebp
c010196e:	83 ec 04             	sub    $0x4,%esp
c0101971:	8b 45 08             	mov    0x8(%ebp),%eax
c0101974:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101978:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c010197d:	77 24                	ja     c01019a3 <ide_device_valid+0x38>
c010197f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101983:	c1 e0 03             	shl    $0x3,%eax
c0101986:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010198d:	29 c2                	sub    %eax,%edx
c010198f:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101995:	0f b6 00             	movzbl (%eax),%eax
c0101998:	84 c0                	test   %al,%al
c010199a:	74 07                	je     c01019a3 <ide_device_valid+0x38>
c010199c:	b8 01 00 00 00       	mov    $0x1,%eax
c01019a1:	eb 05                	jmp    c01019a8 <ide_device_valid+0x3d>
c01019a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01019a8:	c9                   	leave  
c01019a9:	c3                   	ret    

c01019aa <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c01019aa:	55                   	push   %ebp
c01019ab:	89 e5                	mov    %esp,%ebp
c01019ad:	83 ec 08             	sub    $0x8,%esp
c01019b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c01019b7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01019bb:	89 04 24             	mov    %eax,(%esp)
c01019be:	e8 a8 ff ff ff       	call   c010196b <ide_device_valid>
c01019c3:	85 c0                	test   %eax,%eax
c01019c5:	74 1b                	je     c01019e2 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c01019c7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c01019cb:	c1 e0 03             	shl    $0x3,%eax
c01019ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019d5:	29 c2                	sub    %eax,%edx
c01019d7:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019dd:	8b 40 08             	mov    0x8(%eax),%eax
c01019e0:	eb 05                	jmp    c01019e7 <ide_device_size+0x3d>
    }
    return 0;
c01019e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01019e7:	c9                   	leave  
c01019e8:	c3                   	ret    

c01019e9 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c01019e9:	55                   	push   %ebp
c01019ea:	89 e5                	mov    %esp,%ebp
c01019ec:	57                   	push   %edi
c01019ed:	53                   	push   %ebx
c01019ee:	83 ec 50             	sub    $0x50,%esp
c01019f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f4:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c01019f8:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c01019ff:	77 24                	ja     c0101a25 <ide_read_secs+0x3c>
c0101a01:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101a06:	77 1d                	ja     c0101a25 <ide_read_secs+0x3c>
c0101a08:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101a0c:	c1 e0 03             	shl    $0x3,%eax
c0101a0f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a16:	29 c2                	sub    %eax,%edx
c0101a18:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a1e:	0f b6 00             	movzbl (%eax),%eax
c0101a21:	84 c0                	test   %al,%al
c0101a23:	75 24                	jne    c0101a49 <ide_read_secs+0x60>
c0101a25:	c7 44 24 0c d0 8a 10 	movl   $0xc0108ad0,0xc(%esp)
c0101a2c:	c0 
c0101a2d:	c7 44 24 08 8b 8a 10 	movl   $0xc0108a8b,0x8(%esp)
c0101a34:	c0 
c0101a35:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101a3c:	00 
c0101a3d:	c7 04 24 a0 8a 10 c0 	movl   $0xc0108aa0,(%esp)
c0101a44:	e8 d2 f1 ff ff       	call   c0100c1b <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101a49:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101a50:	77 0f                	ja     c0101a61 <ide_read_secs+0x78>
c0101a52:	8b 45 14             	mov    0x14(%ebp),%eax
c0101a55:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101a58:	01 d0                	add    %edx,%eax
c0101a5a:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101a5f:	76 24                	jbe    c0101a85 <ide_read_secs+0x9c>
c0101a61:	c7 44 24 0c f8 8a 10 	movl   $0xc0108af8,0xc(%esp)
c0101a68:	c0 
c0101a69:	c7 44 24 08 8b 8a 10 	movl   $0xc0108a8b,0x8(%esp)
c0101a70:	c0 
c0101a71:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101a78:	00 
c0101a79:	c7 04 24 a0 8a 10 c0 	movl   $0xc0108aa0,(%esp)
c0101a80:	e8 96 f1 ff ff       	call   c0100c1b <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101a85:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101a89:	66 d1 e8             	shr    %ax
c0101a8c:	0f b7 c0             	movzwl %ax,%eax
c0101a8f:	0f b7 04 85 40 8a 10 	movzwl -0x3fef75c0(,%eax,4),%eax
c0101a96:	c0 
c0101a97:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101a9b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101a9f:	66 d1 e8             	shr    %ax
c0101aa2:	0f b7 c0             	movzwl %ax,%eax
c0101aa5:	0f b7 04 85 42 8a 10 	movzwl -0x3fef75be(,%eax,4),%eax
c0101aac:	c0 
c0101aad:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ab1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ab5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101abc:	00 
c0101abd:	89 04 24             	mov    %eax,(%esp)
c0101ac0:	e8 33 fb ff ff       	call   c01015f8 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ac5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ac9:	83 c0 02             	add    $0x2,%eax
c0101acc:	0f b7 c0             	movzwl %ax,%eax
c0101acf:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ad3:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ad7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101adb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101adf:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ae0:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ae3:	0f b6 c0             	movzbl %al,%eax
c0101ae6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101aea:	83 c2 02             	add    $0x2,%edx
c0101aed:	0f b7 d2             	movzwl %dx,%edx
c0101af0:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101af4:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101af7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101afb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101aff:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101b00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b03:	0f b6 c0             	movzbl %al,%eax
c0101b06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b0a:	83 c2 03             	add    $0x3,%edx
c0101b0d:	0f b7 d2             	movzwl %dx,%edx
c0101b10:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101b14:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101b17:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101b1b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101b1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101b20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b23:	c1 e8 08             	shr    $0x8,%eax
c0101b26:	0f b6 c0             	movzbl %al,%eax
c0101b29:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b2d:	83 c2 04             	add    $0x4,%edx
c0101b30:	0f b7 d2             	movzwl %dx,%edx
c0101b33:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101b37:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101b3a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101b3e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101b42:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101b43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b46:	c1 e8 10             	shr    $0x10,%eax
c0101b49:	0f b6 c0             	movzbl %al,%eax
c0101b4c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b50:	83 c2 05             	add    $0x5,%edx
c0101b53:	0f b7 d2             	movzwl %dx,%edx
c0101b56:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101b5a:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101b5d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101b61:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101b65:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101b66:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b6a:	83 e0 01             	and    $0x1,%eax
c0101b6d:	c1 e0 04             	shl    $0x4,%eax
c0101b70:	89 c2                	mov    %eax,%edx
c0101b72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101b75:	c1 e8 18             	shr    $0x18,%eax
c0101b78:	83 e0 0f             	and    $0xf,%eax
c0101b7b:	09 d0                	or     %edx,%eax
c0101b7d:	83 c8 e0             	or     $0xffffffe0,%eax
c0101b80:	0f b6 c0             	movzbl %al,%eax
c0101b83:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101b87:	83 c2 06             	add    $0x6,%edx
c0101b8a:	0f b7 d2             	movzwl %dx,%edx
c0101b8d:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101b91:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101b94:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101b98:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101b9c:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101b9d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ba1:	83 c0 07             	add    $0x7,%eax
c0101ba4:	0f b7 c0             	movzwl %ax,%eax
c0101ba7:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101bab:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101baf:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101bb3:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101bb7:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101bbf:	eb 5a                	jmp    c0101c1b <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101bc1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101bc5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101bcc:	00 
c0101bcd:	89 04 24             	mov    %eax,(%esp)
c0101bd0:	e8 23 fa ff ff       	call   c01015f8 <ide_wait_ready>
c0101bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101bd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101bdc:	74 02                	je     c0101be0 <ide_read_secs+0x1f7>
            goto out;
c0101bde:	eb 41                	jmp    c0101c21 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101be0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101be4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101be7:	8b 45 10             	mov    0x10(%ebp),%eax
c0101bea:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101bed:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101bf4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101bf7:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101bfa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101bfd:	89 cb                	mov    %ecx,%ebx
c0101bff:	89 df                	mov    %ebx,%edi
c0101c01:	89 c1                	mov    %eax,%ecx
c0101c03:	fc                   	cld    
c0101c04:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101c06:	89 c8                	mov    %ecx,%eax
c0101c08:	89 fb                	mov    %edi,%ebx
c0101c0a:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101c0d:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c10:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101c14:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101c1b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101c1f:	75 a0                	jne    c0101bc1 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101c24:	83 c4 50             	add    $0x50,%esp
c0101c27:	5b                   	pop    %ebx
c0101c28:	5f                   	pop    %edi
c0101c29:	5d                   	pop    %ebp
c0101c2a:	c3                   	ret    

c0101c2b <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101c2b:	55                   	push   %ebp
c0101c2c:	89 e5                	mov    %esp,%ebp
c0101c2e:	56                   	push   %esi
c0101c2f:	53                   	push   %ebx
c0101c30:	83 ec 50             	sub    $0x50,%esp
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101c3a:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101c41:	77 24                	ja     c0101c67 <ide_write_secs+0x3c>
c0101c43:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101c48:	77 1d                	ja     c0101c67 <ide_write_secs+0x3c>
c0101c4a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c4e:	c1 e0 03             	shl    $0x3,%eax
c0101c51:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101c58:	29 c2                	sub    %eax,%edx
c0101c5a:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101c60:	0f b6 00             	movzbl (%eax),%eax
c0101c63:	84 c0                	test   %al,%al
c0101c65:	75 24                	jne    c0101c8b <ide_write_secs+0x60>
c0101c67:	c7 44 24 0c d0 8a 10 	movl   $0xc0108ad0,0xc(%esp)
c0101c6e:	c0 
c0101c6f:	c7 44 24 08 8b 8a 10 	movl   $0xc0108a8b,0x8(%esp)
c0101c76:	c0 
c0101c77:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101c7e:	00 
c0101c7f:	c7 04 24 a0 8a 10 c0 	movl   $0xc0108aa0,(%esp)
c0101c86:	e8 90 ef ff ff       	call   c0100c1b <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c8b:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c92:	77 0f                	ja     c0101ca3 <ide_write_secs+0x78>
c0101c94:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c97:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c9a:	01 d0                	add    %edx,%eax
c0101c9c:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101ca1:	76 24                	jbe    c0101cc7 <ide_write_secs+0x9c>
c0101ca3:	c7 44 24 0c f8 8a 10 	movl   $0xc0108af8,0xc(%esp)
c0101caa:	c0 
c0101cab:	c7 44 24 08 8b 8a 10 	movl   $0xc0108a8b,0x8(%esp)
c0101cb2:	c0 
c0101cb3:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101cba:	00 
c0101cbb:	c7 04 24 a0 8a 10 c0 	movl   $0xc0108aa0,(%esp)
c0101cc2:	e8 54 ef ff ff       	call   c0100c1b <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101cc7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ccb:	66 d1 e8             	shr    %ax
c0101cce:	0f b7 c0             	movzwl %ax,%eax
c0101cd1:	0f b7 04 85 40 8a 10 	movzwl -0x3fef75c0(,%eax,4),%eax
c0101cd8:	c0 
c0101cd9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101cdd:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ce1:	66 d1 e8             	shr    %ax
c0101ce4:	0f b7 c0             	movzwl %ax,%eax
c0101ce7:	0f b7 04 85 42 8a 10 	movzwl -0x3fef75be(,%eax,4),%eax
c0101cee:	c0 
c0101cef:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101cf3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101cf7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101cfe:	00 
c0101cff:	89 04 24             	mov    %eax,(%esp)
c0101d02:	e8 f1 f8 ff ff       	call   c01015f8 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101d07:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101d0b:	83 c0 02             	add    $0x2,%eax
c0101d0e:	0f b7 c0             	movzwl %ax,%eax
c0101d11:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101d15:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d19:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101d1d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101d21:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101d22:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d25:	0f b6 c0             	movzbl %al,%eax
c0101d28:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d2c:	83 c2 02             	add    $0x2,%edx
c0101d2f:	0f b7 d2             	movzwl %dx,%edx
c0101d32:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101d36:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101d39:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101d3d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101d41:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101d42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d45:	0f b6 c0             	movzbl %al,%eax
c0101d48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d4c:	83 c2 03             	add    $0x3,%edx
c0101d4f:	0f b7 d2             	movzwl %dx,%edx
c0101d52:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101d56:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101d59:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101d5d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101d61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101d62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d65:	c1 e8 08             	shr    $0x8,%eax
c0101d68:	0f b6 c0             	movzbl %al,%eax
c0101d6b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d6f:	83 c2 04             	add    $0x4,%edx
c0101d72:	0f b7 d2             	movzwl %dx,%edx
c0101d75:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101d79:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101d7c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101d80:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101d84:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101d85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d88:	c1 e8 10             	shr    $0x10,%eax
c0101d8b:	0f b6 c0             	movzbl %al,%eax
c0101d8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d92:	83 c2 05             	add    $0x5,%edx
c0101d95:	0f b7 d2             	movzwl %dx,%edx
c0101d98:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d9c:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d9f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101da3:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101da7:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101da8:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dac:	83 e0 01             	and    $0x1,%eax
c0101daf:	c1 e0 04             	shl    $0x4,%eax
c0101db2:	89 c2                	mov    %eax,%edx
c0101db4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101db7:	c1 e8 18             	shr    $0x18,%eax
c0101dba:	83 e0 0f             	and    $0xf,%eax
c0101dbd:	09 d0                	or     %edx,%eax
c0101dbf:	83 c8 e0             	or     $0xffffffe0,%eax
c0101dc2:	0f b6 c0             	movzbl %al,%eax
c0101dc5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dc9:	83 c2 06             	add    $0x6,%edx
c0101dcc:	0f b7 d2             	movzwl %dx,%edx
c0101dcf:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101dd3:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101dd6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101dda:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101dde:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ddf:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101de3:	83 c0 07             	add    $0x7,%eax
c0101de6:	0f b7 c0             	movzwl %ax,%eax
c0101de9:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ded:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101df1:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101df5:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101df9:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101dfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101e01:	eb 5a                	jmp    c0101e5d <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101e03:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101e0e:	00 
c0101e0f:	89 04 24             	mov    %eax,(%esp)
c0101e12:	e8 e1 f7 ff ff       	call   c01015f8 <ide_wait_ready>
c0101e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101e1e:	74 02                	je     c0101e22 <ide_write_secs+0x1f7>
            goto out;
c0101e20:	eb 41                	jmp    c0101e63 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101e22:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e26:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101e29:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e2c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101e2f:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101e36:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101e39:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101e3c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101e3f:	89 cb                	mov    %ecx,%ebx
c0101e41:	89 de                	mov    %ebx,%esi
c0101e43:	89 c1                	mov    %eax,%ecx
c0101e45:	fc                   	cld    
c0101e46:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101e48:	89 c8                	mov    %ecx,%eax
c0101e4a:	89 f3                	mov    %esi,%ebx
c0101e4c:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101e4f:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101e52:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101e56:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101e5d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101e61:	75 a0                	jne    c0101e03 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101e66:	83 c4 50             	add    $0x50,%esp
c0101e69:	5b                   	pop    %ebx
c0101e6a:	5e                   	pop    %esi
c0101e6b:	5d                   	pop    %ebp
c0101e6c:	c3                   	ret    

c0101e6d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101e6d:	55                   	push   %ebp
c0101e6e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101e70:	fb                   	sti    
    sti();
}
c0101e71:	5d                   	pop    %ebp
c0101e72:	c3                   	ret    

c0101e73 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101e73:	55                   	push   %ebp
c0101e74:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101e76:	fa                   	cli    
    cli();
}
c0101e77:	5d                   	pop    %ebp
c0101e78:	c3                   	ret    

c0101e79 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101e79:	55                   	push   %ebp
c0101e7a:	89 e5                	mov    %esp,%ebp
c0101e7c:	83 ec 14             	sub    $0x14,%esp
c0101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e82:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101e86:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101e8a:	66 a3 70 f5 11 c0    	mov    %ax,0xc011f570
    if (did_init) {
c0101e90:	a1 e0 01 12 c0       	mov    0xc01201e0,%eax
c0101e95:	85 c0                	test   %eax,%eax
c0101e97:	74 36                	je     c0101ecf <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101e99:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101e9d:	0f b6 c0             	movzbl %al,%eax
c0101ea0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101ea6:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ea9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101ead:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101eb1:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101eb2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101eb6:	66 c1 e8 08          	shr    $0x8,%ax
c0101eba:	0f b6 c0             	movzbl %al,%eax
c0101ebd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101ec3:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101ec6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101eca:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ece:	ee                   	out    %al,(%dx)
    }
}
c0101ecf:	c9                   	leave  
c0101ed0:	c3                   	ret    

c0101ed1 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101ed1:	55                   	push   %ebp
c0101ed2:	89 e5                	mov    %esp,%ebp
c0101ed4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eda:	ba 01 00 00 00       	mov    $0x1,%edx
c0101edf:	89 c1                	mov    %eax,%ecx
c0101ee1:	d3 e2                	shl    %cl,%edx
c0101ee3:	89 d0                	mov    %edx,%eax
c0101ee5:	f7 d0                	not    %eax
c0101ee7:	89 c2                	mov    %eax,%edx
c0101ee9:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c0101ef0:	21 d0                	and    %edx,%eax
c0101ef2:	0f b7 c0             	movzwl %ax,%eax
c0101ef5:	89 04 24             	mov    %eax,(%esp)
c0101ef8:	e8 7c ff ff ff       	call   c0101e79 <pic_setmask>
}
c0101efd:	c9                   	leave  
c0101efe:	c3                   	ret    

c0101eff <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101eff:	55                   	push   %ebp
c0101f00:	89 e5                	mov    %esp,%ebp
c0101f02:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101f05:	c7 05 e0 01 12 c0 01 	movl   $0x1,0xc01201e0
c0101f0c:	00 00 00 
c0101f0f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f15:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101f19:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f1d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f21:	ee                   	out    %al,(%dx)
c0101f22:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f28:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101f2c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f34:	ee                   	out    %al,(%dx)
c0101f35:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101f3b:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101f3f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101f43:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101f47:	ee                   	out    %al,(%dx)
c0101f48:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101f4e:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101f52:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101f56:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f5a:	ee                   	out    %al,(%dx)
c0101f5b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101f61:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101f65:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101f69:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101f6d:	ee                   	out    %al,(%dx)
c0101f6e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0101f74:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0101f78:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101f7c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101f80:	ee                   	out    %al,(%dx)
c0101f81:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101f87:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101f8b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f8f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f93:	ee                   	out    %al,(%dx)
c0101f94:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101f9a:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0101f9e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101fa2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101fa6:	ee                   	out    %al,(%dx)
c0101fa7:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101fad:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101fb1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101fb5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101fb9:	ee                   	out    %al,(%dx)
c0101fba:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101fc0:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101fc4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101fc8:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101fcc:	ee                   	out    %al,(%dx)
c0101fcd:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101fd3:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101fd7:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101fdb:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fdf:	ee                   	out    %al,(%dx)
c0101fe0:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101fe6:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101fea:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101fee:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101ff2:	ee                   	out    %al,(%dx)
c0101ff3:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101ff9:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101ffd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0102001:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0102005:	ee                   	out    %al,(%dx)
c0102006:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010200c:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0102010:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0102014:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0102018:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102019:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c0102020:	66 83 f8 ff          	cmp    $0xffff,%ax
c0102024:	74 12                	je     c0102038 <pic_init+0x139>
        pic_setmask(irq_mask);
c0102026:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c010202d:	0f b7 c0             	movzwl %ax,%eax
c0102030:	89 04 24             	mov    %eax,(%esp)
c0102033:	e8 41 fe ff ff       	call   c0101e79 <pic_setmask>
    }
}
c0102038:	c9                   	leave  
c0102039:	c3                   	ret    

c010203a <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c010203a:	55                   	push   %ebp
c010203b:	89 e5                	mov    %esp,%ebp
c010203d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102040:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102047:	00 
c0102048:	c7 04 24 40 8b 10 c0 	movl   $0xc0108b40,(%esp)
c010204f:	e8 f7 e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0102054:	c9                   	leave  
c0102055:	c3                   	ret    

c0102056 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102056:	55                   	push   %ebp
c0102057:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0102059:	5d                   	pop    %ebp
c010205a:	c3                   	ret    

c010205b <trapname>:

static const char *
trapname(int trapno) {
c010205b:	55                   	push   %ebp
c010205c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010205e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102061:	83 f8 13             	cmp    $0x13,%eax
c0102064:	77 0c                	ja     c0102072 <trapname+0x17>
        return excnames[trapno];
c0102066:	8b 45 08             	mov    0x8(%ebp),%eax
c0102069:	8b 04 85 20 8f 10 c0 	mov    -0x3fef70e0(,%eax,4),%eax
c0102070:	eb 18                	jmp    c010208a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102072:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102076:	7e 0d                	jle    c0102085 <trapname+0x2a>
c0102078:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010207c:	7f 07                	jg     c0102085 <trapname+0x2a>
        return "Hardware Interrupt";
c010207e:	b8 4a 8b 10 c0       	mov    $0xc0108b4a,%eax
c0102083:	eb 05                	jmp    c010208a <trapname+0x2f>
    }
    return "(unknown trap)";
c0102085:	b8 5d 8b 10 c0       	mov    $0xc0108b5d,%eax
}
c010208a:	5d                   	pop    %ebp
c010208b:	c3                   	ret    

c010208c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010208c:	55                   	push   %ebp
c010208d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010208f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102092:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102096:	66 83 f8 08          	cmp    $0x8,%ax
c010209a:	0f 94 c0             	sete   %al
c010209d:	0f b6 c0             	movzbl %al,%eax
}
c01020a0:	5d                   	pop    %ebp
c01020a1:	c3                   	ret    

c01020a2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01020a2:	55                   	push   %ebp
c01020a3:	89 e5                	mov    %esp,%ebp
c01020a5:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01020a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01020ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01020af:	c7 04 24 9e 8b 10 c0 	movl   $0xc0108b9e,(%esp)
c01020b6:	e8 90 e2 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c01020bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01020be:	89 04 24             	mov    %eax,(%esp)
c01020c1:	e8 a1 01 00 00       	call   c0102267 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01020c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01020c9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01020cd:	0f b7 c0             	movzwl %ax,%eax
c01020d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01020d4:	c7 04 24 af 8b 10 c0 	movl   $0xc0108baf,(%esp)
c01020db:	e8 6b e2 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01020e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01020e3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01020e7:	0f b7 c0             	movzwl %ax,%eax
c01020ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01020ee:	c7 04 24 c2 8b 10 c0 	movl   $0xc0108bc2,(%esp)
c01020f5:	e8 51 e2 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01020fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01020fd:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102101:	0f b7 c0             	movzwl %ax,%eax
c0102104:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102108:	c7 04 24 d5 8b 10 c0 	movl   $0xc0108bd5,(%esp)
c010210f:	e8 37 e2 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102114:	8b 45 08             	mov    0x8(%ebp),%eax
c0102117:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010211b:	0f b7 c0             	movzwl %ax,%eax
c010211e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102122:	c7 04 24 e8 8b 10 c0 	movl   $0xc0108be8,(%esp)
c0102129:	e8 1d e2 ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010212e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102131:	8b 40 30             	mov    0x30(%eax),%eax
c0102134:	89 04 24             	mov    %eax,(%esp)
c0102137:	e8 1f ff ff ff       	call   c010205b <trapname>
c010213c:	8b 55 08             	mov    0x8(%ebp),%edx
c010213f:	8b 52 30             	mov    0x30(%edx),%edx
c0102142:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102146:	89 54 24 04          	mov    %edx,0x4(%esp)
c010214a:	c7 04 24 fb 8b 10 c0 	movl   $0xc0108bfb,(%esp)
c0102151:	e8 f5 e1 ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102156:	8b 45 08             	mov    0x8(%ebp),%eax
c0102159:	8b 40 34             	mov    0x34(%eax),%eax
c010215c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102160:	c7 04 24 0d 8c 10 c0 	movl   $0xc0108c0d,(%esp)
c0102167:	e8 df e1 ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010216c:	8b 45 08             	mov    0x8(%ebp),%eax
c010216f:	8b 40 38             	mov    0x38(%eax),%eax
c0102172:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102176:	c7 04 24 1c 8c 10 c0 	movl   $0xc0108c1c,(%esp)
c010217d:	e8 c9 e1 ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102182:	8b 45 08             	mov    0x8(%ebp),%eax
c0102185:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102189:	0f b7 c0             	movzwl %ax,%eax
c010218c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102190:	c7 04 24 2b 8c 10 c0 	movl   $0xc0108c2b,(%esp)
c0102197:	e8 af e1 ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010219c:	8b 45 08             	mov    0x8(%ebp),%eax
c010219f:	8b 40 40             	mov    0x40(%eax),%eax
c01021a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01021a6:	c7 04 24 3e 8c 10 c0 	movl   $0xc0108c3e,(%esp)
c01021ad:	e8 99 e1 ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01021b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01021b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01021c0:	eb 3e                	jmp    c0102200 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01021c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01021c5:	8b 50 40             	mov    0x40(%eax),%edx
c01021c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01021cb:	21 d0                	and    %edx,%eax
c01021cd:	85 c0                	test   %eax,%eax
c01021cf:	74 28                	je     c01021f9 <print_trapframe+0x157>
c01021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01021d4:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c01021db:	85 c0                	test   %eax,%eax
c01021dd:	74 1a                	je     c01021f9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01021e2:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c01021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01021ed:	c7 04 24 4d 8c 10 c0 	movl   $0xc0108c4d,(%esp)
c01021f4:	e8 52 e1 ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01021f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01021fd:	d1 65 f0             	shll   -0x10(%ebp)
c0102200:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102203:	83 f8 17             	cmp    $0x17,%eax
c0102206:	76 ba                	jbe    c01021c2 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102208:	8b 45 08             	mov    0x8(%ebp),%eax
c010220b:	8b 40 40             	mov    0x40(%eax),%eax
c010220e:	25 00 30 00 00       	and    $0x3000,%eax
c0102213:	c1 e8 0c             	shr    $0xc,%eax
c0102216:	89 44 24 04          	mov    %eax,0x4(%esp)
c010221a:	c7 04 24 51 8c 10 c0 	movl   $0xc0108c51,(%esp)
c0102221:	e8 25 e1 ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c0102226:	8b 45 08             	mov    0x8(%ebp),%eax
c0102229:	89 04 24             	mov    %eax,(%esp)
c010222c:	e8 5b fe ff ff       	call   c010208c <trap_in_kernel>
c0102231:	85 c0                	test   %eax,%eax
c0102233:	75 30                	jne    c0102265 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102235:	8b 45 08             	mov    0x8(%ebp),%eax
c0102238:	8b 40 44             	mov    0x44(%eax),%eax
c010223b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010223f:	c7 04 24 5a 8c 10 c0 	movl   $0xc0108c5a,(%esp)
c0102246:	e8 00 e1 ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010224b:	8b 45 08             	mov    0x8(%ebp),%eax
c010224e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102252:	0f b7 c0             	movzwl %ax,%eax
c0102255:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102259:	c7 04 24 69 8c 10 c0 	movl   $0xc0108c69,(%esp)
c0102260:	e8 e6 e0 ff ff       	call   c010034b <cprintf>
    }
}
c0102265:	c9                   	leave  
c0102266:	c3                   	ret    

c0102267 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102267:	55                   	push   %ebp
c0102268:	89 e5                	mov    %esp,%ebp
c010226a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010226d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102270:	8b 00                	mov    (%eax),%eax
c0102272:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102276:	c7 04 24 7c 8c 10 c0 	movl   $0xc0108c7c,(%esp)
c010227d:	e8 c9 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102282:	8b 45 08             	mov    0x8(%ebp),%eax
c0102285:	8b 40 04             	mov    0x4(%eax),%eax
c0102288:	89 44 24 04          	mov    %eax,0x4(%esp)
c010228c:	c7 04 24 8b 8c 10 c0 	movl   $0xc0108c8b,(%esp)
c0102293:	e8 b3 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102298:	8b 45 08             	mov    0x8(%ebp),%eax
c010229b:	8b 40 08             	mov    0x8(%eax),%eax
c010229e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022a2:	c7 04 24 9a 8c 10 c0 	movl   $0xc0108c9a,(%esp)
c01022a9:	e8 9d e0 ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01022ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b1:	8b 40 0c             	mov    0xc(%eax),%eax
c01022b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022b8:	c7 04 24 a9 8c 10 c0 	movl   $0xc0108ca9,(%esp)
c01022bf:	e8 87 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01022c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c7:	8b 40 10             	mov    0x10(%eax),%eax
c01022ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022ce:	c7 04 24 b8 8c 10 c0 	movl   $0xc0108cb8,(%esp)
c01022d5:	e8 71 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01022da:	8b 45 08             	mov    0x8(%ebp),%eax
c01022dd:	8b 40 14             	mov    0x14(%eax),%eax
c01022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022e4:	c7 04 24 c7 8c 10 c0 	movl   $0xc0108cc7,(%esp)
c01022eb:	e8 5b e0 ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01022f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f3:	8b 40 18             	mov    0x18(%eax),%eax
c01022f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022fa:	c7 04 24 d6 8c 10 c0 	movl   $0xc0108cd6,(%esp)
c0102301:	e8 45 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102306:	8b 45 08             	mov    0x8(%ebp),%eax
c0102309:	8b 40 1c             	mov    0x1c(%eax),%eax
c010230c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102310:	c7 04 24 e5 8c 10 c0 	movl   $0xc0108ce5,(%esp)
c0102317:	e8 2f e0 ff ff       	call   c010034b <cprintf>
}
c010231c:	c9                   	leave  
c010231d:	c3                   	ret    

c010231e <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010231e:	55                   	push   %ebp
c010231f:	89 e5                	mov    %esp,%ebp
c0102321:	53                   	push   %ebx
c0102322:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102325:	8b 45 08             	mov    0x8(%ebp),%eax
c0102328:	8b 40 34             	mov    0x34(%eax),%eax
c010232b:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010232e:	85 c0                	test   %eax,%eax
c0102330:	74 07                	je     c0102339 <print_pgfault+0x1b>
c0102332:	b9 f4 8c 10 c0       	mov    $0xc0108cf4,%ecx
c0102337:	eb 05                	jmp    c010233e <print_pgfault+0x20>
c0102339:	b9 05 8d 10 c0       	mov    $0xc0108d05,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010233e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102341:	8b 40 34             	mov    0x34(%eax),%eax
c0102344:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102347:	85 c0                	test   %eax,%eax
c0102349:	74 07                	je     c0102352 <print_pgfault+0x34>
c010234b:	ba 57 00 00 00       	mov    $0x57,%edx
c0102350:	eb 05                	jmp    c0102357 <print_pgfault+0x39>
c0102352:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102357:	8b 45 08             	mov    0x8(%ebp),%eax
c010235a:	8b 40 34             	mov    0x34(%eax),%eax
c010235d:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102360:	85 c0                	test   %eax,%eax
c0102362:	74 07                	je     c010236b <print_pgfault+0x4d>
c0102364:	b8 55 00 00 00       	mov    $0x55,%eax
c0102369:	eb 05                	jmp    c0102370 <print_pgfault+0x52>
c010236b:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102370:	0f 20 d3             	mov    %cr2,%ebx
c0102373:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102376:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102379:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010237d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102381:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102385:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102389:	c7 04 24 14 8d 10 c0 	movl   $0xc0108d14,(%esp)
c0102390:	e8 b6 df ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102395:	83 c4 34             	add    $0x34,%esp
c0102398:	5b                   	pop    %ebx
c0102399:	5d                   	pop    %ebp
c010239a:	c3                   	ret    

c010239b <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010239b:	55                   	push   %ebp
c010239c:	89 e5                	mov    %esp,%ebp
c010239e:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01023a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a4:	89 04 24             	mov    %eax,(%esp)
c01023a7:	e8 72 ff ff ff       	call   c010231e <print_pgfault>
    if (check_mm_struct != NULL) {
c01023ac:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01023b1:	85 c0                	test   %eax,%eax
c01023b3:	74 28                	je     c01023dd <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01023b5:	0f 20 d0             	mov    %cr2,%eax
c01023b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01023be:	89 c1                	mov    %eax,%ecx
c01023c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023c3:	8b 50 34             	mov    0x34(%eax),%edx
c01023c6:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01023cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01023cf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01023d3:	89 04 24             	mov    %eax,(%esp)
c01023d6:	e8 92 54 00 00       	call   c010786d <do_pgfault>
c01023db:	eb 1c                	jmp    c01023f9 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01023dd:	c7 44 24 08 37 8d 10 	movl   $0xc0108d37,0x8(%esp)
c01023e4:	c0 
c01023e5:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01023ec:	00 
c01023ed:	c7 04 24 4e 8d 10 c0 	movl   $0xc0108d4e,(%esp)
c01023f4:	e8 22 e8 ff ff       	call   c0100c1b <__panic>
}
c01023f9:	c9                   	leave  
c01023fa:	c3                   	ret    

c01023fb <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01023fb:	55                   	push   %ebp
c01023fc:	89 e5                	mov    %esp,%ebp
c01023fe:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102401:	8b 45 08             	mov    0x8(%ebp),%eax
c0102404:	8b 40 30             	mov    0x30(%eax),%eax
c0102407:	83 f8 24             	cmp    $0x24,%eax
c010240a:	0f 84 8b 00 00 00    	je     c010249b <trap_dispatch+0xa0>
c0102410:	83 f8 24             	cmp    $0x24,%eax
c0102413:	77 1c                	ja     c0102431 <trap_dispatch+0x36>
c0102415:	83 f8 20             	cmp    $0x20,%eax
c0102418:	0f 84 1d 01 00 00    	je     c010253b <trap_dispatch+0x140>
c010241e:	83 f8 21             	cmp    $0x21,%eax
c0102421:	0f 84 9a 00 00 00    	je     c01024c1 <trap_dispatch+0xc6>
c0102427:	83 f8 0e             	cmp    $0xe,%eax
c010242a:	74 28                	je     c0102454 <trap_dispatch+0x59>
c010242c:	e9 d2 00 00 00       	jmp    c0102503 <trap_dispatch+0x108>
c0102431:	83 f8 2e             	cmp    $0x2e,%eax
c0102434:	0f 82 c9 00 00 00    	jb     c0102503 <trap_dispatch+0x108>
c010243a:	83 f8 2f             	cmp    $0x2f,%eax
c010243d:	0f 86 fb 00 00 00    	jbe    c010253e <trap_dispatch+0x143>
c0102443:	83 e8 78             	sub    $0x78,%eax
c0102446:	83 f8 01             	cmp    $0x1,%eax
c0102449:	0f 87 b4 00 00 00    	ja     c0102503 <trap_dispatch+0x108>
c010244f:	e9 93 00 00 00       	jmp    c01024e7 <trap_dispatch+0xec>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102454:	8b 45 08             	mov    0x8(%ebp),%eax
c0102457:	89 04 24             	mov    %eax,(%esp)
c010245a:	e8 3c ff ff ff       	call   c010239b <pgfault_handler>
c010245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102462:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102466:	74 2e                	je     c0102496 <trap_dispatch+0x9b>
            print_trapframe(tf);
c0102468:	8b 45 08             	mov    0x8(%ebp),%eax
c010246b:	89 04 24             	mov    %eax,(%esp)
c010246e:	e8 2f fc ff ff       	call   c01020a2 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102473:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102476:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010247a:	c7 44 24 08 5f 8d 10 	movl   $0xc0108d5f,0x8(%esp)
c0102481:	c0 
c0102482:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102489:	00 
c010248a:	c7 04 24 4e 8d 10 c0 	movl   $0xc0108d4e,(%esp)
c0102491:	e8 85 e7 ff ff       	call   c0100c1b <__panic>
        }
        break;
c0102496:	e9 a4 00 00 00       	jmp    c010253f <trap_dispatch+0x144>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c010249b:	e8 e9 f0 ff ff       	call   c0101589 <cons_getc>
c01024a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01024a3:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01024a7:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01024ab:	89 54 24 08          	mov    %edx,0x8(%esp)
c01024af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b3:	c7 04 24 7a 8d 10 c0 	movl   $0xc0108d7a,(%esp)
c01024ba:	e8 8c de ff ff       	call   c010034b <cprintf>
        break;
c01024bf:	eb 7e                	jmp    c010253f <trap_dispatch+0x144>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01024c1:	e8 c3 f0 ff ff       	call   c0101589 <cons_getc>
c01024c6:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01024c9:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01024cd:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01024d1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d9:	c7 04 24 8c 8d 10 c0 	movl   $0xc0108d8c,(%esp)
c01024e0:	e8 66 de ff ff       	call   c010034b <cprintf>
        break;
c01024e5:	eb 58                	jmp    c010253f <trap_dispatch+0x144>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01024e7:	c7 44 24 08 9b 8d 10 	movl   $0xc0108d9b,0x8(%esp)
c01024ee:	c0 
c01024ef:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01024f6:	00 
c01024f7:	c7 04 24 4e 8d 10 c0 	movl   $0xc0108d4e,(%esp)
c01024fe:	e8 18 e7 ff ff       	call   c0100c1b <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102503:	8b 45 08             	mov    0x8(%ebp),%eax
c0102506:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010250a:	0f b7 c0             	movzwl %ax,%eax
c010250d:	83 e0 03             	and    $0x3,%eax
c0102510:	85 c0                	test   %eax,%eax
c0102512:	75 2b                	jne    c010253f <trap_dispatch+0x144>
            print_trapframe(tf);
c0102514:	8b 45 08             	mov    0x8(%ebp),%eax
c0102517:	89 04 24             	mov    %eax,(%esp)
c010251a:	e8 83 fb ff ff       	call   c01020a2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010251f:	c7 44 24 08 ab 8d 10 	movl   $0xc0108dab,0x8(%esp)
c0102526:	c0 
c0102527:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c010252e:	00 
c010252f:	c7 04 24 4e 8d 10 c0 	movl   $0xc0108d4e,(%esp)
c0102536:	e8 e0 e6 ff ff       	call   c0100c1b <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c010253b:	90                   	nop
c010253c:	eb 01                	jmp    c010253f <trap_dispatch+0x144>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010253e:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010253f:	c9                   	leave  
c0102540:	c3                   	ret    

c0102541 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102541:	55                   	push   %ebp
c0102542:	89 e5                	mov    %esp,%ebp
c0102544:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102547:	8b 45 08             	mov    0x8(%ebp),%eax
c010254a:	89 04 24             	mov    %eax,(%esp)
c010254d:	e8 a9 fe ff ff       	call   c01023fb <trap_dispatch>
}
c0102552:	c9                   	leave  
c0102553:	c3                   	ret    

c0102554 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102554:	1e                   	push   %ds
    pushl %es
c0102555:	06                   	push   %es
    pushl %fs
c0102556:	0f a0                	push   %fs
    pushl %gs
c0102558:	0f a8                	push   %gs
    pushal
c010255a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c010255b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102560:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102562:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102564:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102565:	e8 d7 ff ff ff       	call   c0102541 <trap>

    # pop the pushed stack pointer
    popl %esp
c010256a:	5c                   	pop    %esp

c010256b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010256b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010256c:	0f a9                	pop    %gs
    popl %fs
c010256e:	0f a1                	pop    %fs
    popl %es
c0102570:	07                   	pop    %es
    popl %ds
c0102571:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102572:	83 c4 08             	add    $0x8,%esp
    iret
c0102575:	cf                   	iret   

c0102576 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $0
c0102578:	6a 00                	push   $0x0
  jmp __alltraps
c010257a:	e9 d5 ff ff ff       	jmp    c0102554 <__alltraps>

c010257f <vector1>:
.globl vector1
vector1:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $1
c0102581:	6a 01                	push   $0x1
  jmp __alltraps
c0102583:	e9 cc ff ff ff       	jmp    c0102554 <__alltraps>

c0102588 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $2
c010258a:	6a 02                	push   $0x2
  jmp __alltraps
c010258c:	e9 c3 ff ff ff       	jmp    c0102554 <__alltraps>

c0102591 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $3
c0102593:	6a 03                	push   $0x3
  jmp __alltraps
c0102595:	e9 ba ff ff ff       	jmp    c0102554 <__alltraps>

c010259a <vector4>:
.globl vector4
vector4:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $4
c010259c:	6a 04                	push   $0x4
  jmp __alltraps
c010259e:	e9 b1 ff ff ff       	jmp    c0102554 <__alltraps>

c01025a3 <vector5>:
.globl vector5
vector5:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $5
c01025a5:	6a 05                	push   $0x5
  jmp __alltraps
c01025a7:	e9 a8 ff ff ff       	jmp    c0102554 <__alltraps>

c01025ac <vector6>:
.globl vector6
vector6:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $6
c01025ae:	6a 06                	push   $0x6
  jmp __alltraps
c01025b0:	e9 9f ff ff ff       	jmp    c0102554 <__alltraps>

c01025b5 <vector7>:
.globl vector7
vector7:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $7
c01025b7:	6a 07                	push   $0x7
  jmp __alltraps
c01025b9:	e9 96 ff ff ff       	jmp    c0102554 <__alltraps>

c01025be <vector8>:
.globl vector8
vector8:
  pushl $8
c01025be:	6a 08                	push   $0x8
  jmp __alltraps
c01025c0:	e9 8f ff ff ff       	jmp    c0102554 <__alltraps>

c01025c5 <vector9>:
.globl vector9
vector9:
  pushl $9
c01025c5:	6a 09                	push   $0x9
  jmp __alltraps
c01025c7:	e9 88 ff ff ff       	jmp    c0102554 <__alltraps>

c01025cc <vector10>:
.globl vector10
vector10:
  pushl $10
c01025cc:	6a 0a                	push   $0xa
  jmp __alltraps
c01025ce:	e9 81 ff ff ff       	jmp    c0102554 <__alltraps>

c01025d3 <vector11>:
.globl vector11
vector11:
  pushl $11
c01025d3:	6a 0b                	push   $0xb
  jmp __alltraps
c01025d5:	e9 7a ff ff ff       	jmp    c0102554 <__alltraps>

c01025da <vector12>:
.globl vector12
vector12:
  pushl $12
c01025da:	6a 0c                	push   $0xc
  jmp __alltraps
c01025dc:	e9 73 ff ff ff       	jmp    c0102554 <__alltraps>

c01025e1 <vector13>:
.globl vector13
vector13:
  pushl $13
c01025e1:	6a 0d                	push   $0xd
  jmp __alltraps
c01025e3:	e9 6c ff ff ff       	jmp    c0102554 <__alltraps>

c01025e8 <vector14>:
.globl vector14
vector14:
  pushl $14
c01025e8:	6a 0e                	push   $0xe
  jmp __alltraps
c01025ea:	e9 65 ff ff ff       	jmp    c0102554 <__alltraps>

c01025ef <vector15>:
.globl vector15
vector15:
  pushl $0
c01025ef:	6a 00                	push   $0x0
  pushl $15
c01025f1:	6a 0f                	push   $0xf
  jmp __alltraps
c01025f3:	e9 5c ff ff ff       	jmp    c0102554 <__alltraps>

c01025f8 <vector16>:
.globl vector16
vector16:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $16
c01025fa:	6a 10                	push   $0x10
  jmp __alltraps
c01025fc:	e9 53 ff ff ff       	jmp    c0102554 <__alltraps>

c0102601 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102601:	6a 11                	push   $0x11
  jmp __alltraps
c0102603:	e9 4c ff ff ff       	jmp    c0102554 <__alltraps>

c0102608 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $18
c010260a:	6a 12                	push   $0x12
  jmp __alltraps
c010260c:	e9 43 ff ff ff       	jmp    c0102554 <__alltraps>

c0102611 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $19
c0102613:	6a 13                	push   $0x13
  jmp __alltraps
c0102615:	e9 3a ff ff ff       	jmp    c0102554 <__alltraps>

c010261a <vector20>:
.globl vector20
vector20:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $20
c010261c:	6a 14                	push   $0x14
  jmp __alltraps
c010261e:	e9 31 ff ff ff       	jmp    c0102554 <__alltraps>

c0102623 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $21
c0102625:	6a 15                	push   $0x15
  jmp __alltraps
c0102627:	e9 28 ff ff ff       	jmp    c0102554 <__alltraps>

c010262c <vector22>:
.globl vector22
vector22:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $22
c010262e:	6a 16                	push   $0x16
  jmp __alltraps
c0102630:	e9 1f ff ff ff       	jmp    c0102554 <__alltraps>

c0102635 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $23
c0102637:	6a 17                	push   $0x17
  jmp __alltraps
c0102639:	e9 16 ff ff ff       	jmp    c0102554 <__alltraps>

c010263e <vector24>:
.globl vector24
vector24:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $24
c0102640:	6a 18                	push   $0x18
  jmp __alltraps
c0102642:	e9 0d ff ff ff       	jmp    c0102554 <__alltraps>

c0102647 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $25
c0102649:	6a 19                	push   $0x19
  jmp __alltraps
c010264b:	e9 04 ff ff ff       	jmp    c0102554 <__alltraps>

c0102650 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $26
c0102652:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102654:	e9 fb fe ff ff       	jmp    c0102554 <__alltraps>

c0102659 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $27
c010265b:	6a 1b                	push   $0x1b
  jmp __alltraps
c010265d:	e9 f2 fe ff ff       	jmp    c0102554 <__alltraps>

c0102662 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $28
c0102664:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102666:	e9 e9 fe ff ff       	jmp    c0102554 <__alltraps>

c010266b <vector29>:
.globl vector29
vector29:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $29
c010266d:	6a 1d                	push   $0x1d
  jmp __alltraps
c010266f:	e9 e0 fe ff ff       	jmp    c0102554 <__alltraps>

c0102674 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $30
c0102676:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102678:	e9 d7 fe ff ff       	jmp    c0102554 <__alltraps>

c010267d <vector31>:
.globl vector31
vector31:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $31
c010267f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102681:	e9 ce fe ff ff       	jmp    c0102554 <__alltraps>

c0102686 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $32
c0102688:	6a 20                	push   $0x20
  jmp __alltraps
c010268a:	e9 c5 fe ff ff       	jmp    c0102554 <__alltraps>

c010268f <vector33>:
.globl vector33
vector33:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $33
c0102691:	6a 21                	push   $0x21
  jmp __alltraps
c0102693:	e9 bc fe ff ff       	jmp    c0102554 <__alltraps>

c0102698 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $34
c010269a:	6a 22                	push   $0x22
  jmp __alltraps
c010269c:	e9 b3 fe ff ff       	jmp    c0102554 <__alltraps>

c01026a1 <vector35>:
.globl vector35
vector35:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $35
c01026a3:	6a 23                	push   $0x23
  jmp __alltraps
c01026a5:	e9 aa fe ff ff       	jmp    c0102554 <__alltraps>

c01026aa <vector36>:
.globl vector36
vector36:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $36
c01026ac:	6a 24                	push   $0x24
  jmp __alltraps
c01026ae:	e9 a1 fe ff ff       	jmp    c0102554 <__alltraps>

c01026b3 <vector37>:
.globl vector37
vector37:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $37
c01026b5:	6a 25                	push   $0x25
  jmp __alltraps
c01026b7:	e9 98 fe ff ff       	jmp    c0102554 <__alltraps>

c01026bc <vector38>:
.globl vector38
vector38:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $38
c01026be:	6a 26                	push   $0x26
  jmp __alltraps
c01026c0:	e9 8f fe ff ff       	jmp    c0102554 <__alltraps>

c01026c5 <vector39>:
.globl vector39
vector39:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $39
c01026c7:	6a 27                	push   $0x27
  jmp __alltraps
c01026c9:	e9 86 fe ff ff       	jmp    c0102554 <__alltraps>

c01026ce <vector40>:
.globl vector40
vector40:
  pushl $0
c01026ce:	6a 00                	push   $0x0
  pushl $40
c01026d0:	6a 28                	push   $0x28
  jmp __alltraps
c01026d2:	e9 7d fe ff ff       	jmp    c0102554 <__alltraps>

c01026d7 <vector41>:
.globl vector41
vector41:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $41
c01026d9:	6a 29                	push   $0x29
  jmp __alltraps
c01026db:	e9 74 fe ff ff       	jmp    c0102554 <__alltraps>

c01026e0 <vector42>:
.globl vector42
vector42:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $42
c01026e2:	6a 2a                	push   $0x2a
  jmp __alltraps
c01026e4:	e9 6b fe ff ff       	jmp    c0102554 <__alltraps>

c01026e9 <vector43>:
.globl vector43
vector43:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $43
c01026eb:	6a 2b                	push   $0x2b
  jmp __alltraps
c01026ed:	e9 62 fe ff ff       	jmp    c0102554 <__alltraps>

c01026f2 <vector44>:
.globl vector44
vector44:
  pushl $0
c01026f2:	6a 00                	push   $0x0
  pushl $44
c01026f4:	6a 2c                	push   $0x2c
  jmp __alltraps
c01026f6:	e9 59 fe ff ff       	jmp    c0102554 <__alltraps>

c01026fb <vector45>:
.globl vector45
vector45:
  pushl $0
c01026fb:	6a 00                	push   $0x0
  pushl $45
c01026fd:	6a 2d                	push   $0x2d
  jmp __alltraps
c01026ff:	e9 50 fe ff ff       	jmp    c0102554 <__alltraps>

c0102704 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $46
c0102706:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102708:	e9 47 fe ff ff       	jmp    c0102554 <__alltraps>

c010270d <vector47>:
.globl vector47
vector47:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $47
c010270f:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102711:	e9 3e fe ff ff       	jmp    c0102554 <__alltraps>

c0102716 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102716:	6a 00                	push   $0x0
  pushl $48
c0102718:	6a 30                	push   $0x30
  jmp __alltraps
c010271a:	e9 35 fe ff ff       	jmp    c0102554 <__alltraps>

c010271f <vector49>:
.globl vector49
vector49:
  pushl $0
c010271f:	6a 00                	push   $0x0
  pushl $49
c0102721:	6a 31                	push   $0x31
  jmp __alltraps
c0102723:	e9 2c fe ff ff       	jmp    c0102554 <__alltraps>

c0102728 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $50
c010272a:	6a 32                	push   $0x32
  jmp __alltraps
c010272c:	e9 23 fe ff ff       	jmp    c0102554 <__alltraps>

c0102731 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $51
c0102733:	6a 33                	push   $0x33
  jmp __alltraps
c0102735:	e9 1a fe ff ff       	jmp    c0102554 <__alltraps>

c010273a <vector52>:
.globl vector52
vector52:
  pushl $0
c010273a:	6a 00                	push   $0x0
  pushl $52
c010273c:	6a 34                	push   $0x34
  jmp __alltraps
c010273e:	e9 11 fe ff ff       	jmp    c0102554 <__alltraps>

c0102743 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102743:	6a 00                	push   $0x0
  pushl $53
c0102745:	6a 35                	push   $0x35
  jmp __alltraps
c0102747:	e9 08 fe ff ff       	jmp    c0102554 <__alltraps>

c010274c <vector54>:
.globl vector54
vector54:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $54
c010274e:	6a 36                	push   $0x36
  jmp __alltraps
c0102750:	e9 ff fd ff ff       	jmp    c0102554 <__alltraps>

c0102755 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $55
c0102757:	6a 37                	push   $0x37
  jmp __alltraps
c0102759:	e9 f6 fd ff ff       	jmp    c0102554 <__alltraps>

c010275e <vector56>:
.globl vector56
vector56:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $56
c0102760:	6a 38                	push   $0x38
  jmp __alltraps
c0102762:	e9 ed fd ff ff       	jmp    c0102554 <__alltraps>

c0102767 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $57
c0102769:	6a 39                	push   $0x39
  jmp __alltraps
c010276b:	e9 e4 fd ff ff       	jmp    c0102554 <__alltraps>

c0102770 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $58
c0102772:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102774:	e9 db fd ff ff       	jmp    c0102554 <__alltraps>

c0102779 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $59
c010277b:	6a 3b                	push   $0x3b
  jmp __alltraps
c010277d:	e9 d2 fd ff ff       	jmp    c0102554 <__alltraps>

c0102782 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $60
c0102784:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102786:	e9 c9 fd ff ff       	jmp    c0102554 <__alltraps>

c010278b <vector61>:
.globl vector61
vector61:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $61
c010278d:	6a 3d                	push   $0x3d
  jmp __alltraps
c010278f:	e9 c0 fd ff ff       	jmp    c0102554 <__alltraps>

c0102794 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $62
c0102796:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102798:	e9 b7 fd ff ff       	jmp    c0102554 <__alltraps>

c010279d <vector63>:
.globl vector63
vector63:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $63
c010279f:	6a 3f                	push   $0x3f
  jmp __alltraps
c01027a1:	e9 ae fd ff ff       	jmp    c0102554 <__alltraps>

c01027a6 <vector64>:
.globl vector64
vector64:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $64
c01027a8:	6a 40                	push   $0x40
  jmp __alltraps
c01027aa:	e9 a5 fd ff ff       	jmp    c0102554 <__alltraps>

c01027af <vector65>:
.globl vector65
vector65:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $65
c01027b1:	6a 41                	push   $0x41
  jmp __alltraps
c01027b3:	e9 9c fd ff ff       	jmp    c0102554 <__alltraps>

c01027b8 <vector66>:
.globl vector66
vector66:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $66
c01027ba:	6a 42                	push   $0x42
  jmp __alltraps
c01027bc:	e9 93 fd ff ff       	jmp    c0102554 <__alltraps>

c01027c1 <vector67>:
.globl vector67
vector67:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $67
c01027c3:	6a 43                	push   $0x43
  jmp __alltraps
c01027c5:	e9 8a fd ff ff       	jmp    c0102554 <__alltraps>

c01027ca <vector68>:
.globl vector68
vector68:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $68
c01027cc:	6a 44                	push   $0x44
  jmp __alltraps
c01027ce:	e9 81 fd ff ff       	jmp    c0102554 <__alltraps>

c01027d3 <vector69>:
.globl vector69
vector69:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $69
c01027d5:	6a 45                	push   $0x45
  jmp __alltraps
c01027d7:	e9 78 fd ff ff       	jmp    c0102554 <__alltraps>

c01027dc <vector70>:
.globl vector70
vector70:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $70
c01027de:	6a 46                	push   $0x46
  jmp __alltraps
c01027e0:	e9 6f fd ff ff       	jmp    c0102554 <__alltraps>

c01027e5 <vector71>:
.globl vector71
vector71:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $71
c01027e7:	6a 47                	push   $0x47
  jmp __alltraps
c01027e9:	e9 66 fd ff ff       	jmp    c0102554 <__alltraps>

c01027ee <vector72>:
.globl vector72
vector72:
  pushl $0
c01027ee:	6a 00                	push   $0x0
  pushl $72
c01027f0:	6a 48                	push   $0x48
  jmp __alltraps
c01027f2:	e9 5d fd ff ff       	jmp    c0102554 <__alltraps>

c01027f7 <vector73>:
.globl vector73
vector73:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $73
c01027f9:	6a 49                	push   $0x49
  jmp __alltraps
c01027fb:	e9 54 fd ff ff       	jmp    c0102554 <__alltraps>

c0102800 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $74
c0102802:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102804:	e9 4b fd ff ff       	jmp    c0102554 <__alltraps>

c0102809 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $75
c010280b:	6a 4b                	push   $0x4b
  jmp __alltraps
c010280d:	e9 42 fd ff ff       	jmp    c0102554 <__alltraps>

c0102812 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102812:	6a 00                	push   $0x0
  pushl $76
c0102814:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102816:	e9 39 fd ff ff       	jmp    c0102554 <__alltraps>

c010281b <vector77>:
.globl vector77
vector77:
  pushl $0
c010281b:	6a 00                	push   $0x0
  pushl $77
c010281d:	6a 4d                	push   $0x4d
  jmp __alltraps
c010281f:	e9 30 fd ff ff       	jmp    c0102554 <__alltraps>

c0102824 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $78
c0102826:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102828:	e9 27 fd ff ff       	jmp    c0102554 <__alltraps>

c010282d <vector79>:
.globl vector79
vector79:
  pushl $0
c010282d:	6a 00                	push   $0x0
  pushl $79
c010282f:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102831:	e9 1e fd ff ff       	jmp    c0102554 <__alltraps>

c0102836 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102836:	6a 00                	push   $0x0
  pushl $80
c0102838:	6a 50                	push   $0x50
  jmp __alltraps
c010283a:	e9 15 fd ff ff       	jmp    c0102554 <__alltraps>

c010283f <vector81>:
.globl vector81
vector81:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $81
c0102841:	6a 51                	push   $0x51
  jmp __alltraps
c0102843:	e9 0c fd ff ff       	jmp    c0102554 <__alltraps>

c0102848 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $82
c010284a:	6a 52                	push   $0x52
  jmp __alltraps
c010284c:	e9 03 fd ff ff       	jmp    c0102554 <__alltraps>

c0102851 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102851:	6a 00                	push   $0x0
  pushl $83
c0102853:	6a 53                	push   $0x53
  jmp __alltraps
c0102855:	e9 fa fc ff ff       	jmp    c0102554 <__alltraps>

c010285a <vector84>:
.globl vector84
vector84:
  pushl $0
c010285a:	6a 00                	push   $0x0
  pushl $84
c010285c:	6a 54                	push   $0x54
  jmp __alltraps
c010285e:	e9 f1 fc ff ff       	jmp    c0102554 <__alltraps>

c0102863 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $85
c0102865:	6a 55                	push   $0x55
  jmp __alltraps
c0102867:	e9 e8 fc ff ff       	jmp    c0102554 <__alltraps>

c010286c <vector86>:
.globl vector86
vector86:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $86
c010286e:	6a 56                	push   $0x56
  jmp __alltraps
c0102870:	e9 df fc ff ff       	jmp    c0102554 <__alltraps>

c0102875 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102875:	6a 00                	push   $0x0
  pushl $87
c0102877:	6a 57                	push   $0x57
  jmp __alltraps
c0102879:	e9 d6 fc ff ff       	jmp    c0102554 <__alltraps>

c010287e <vector88>:
.globl vector88
vector88:
  pushl $0
c010287e:	6a 00                	push   $0x0
  pushl $88
c0102880:	6a 58                	push   $0x58
  jmp __alltraps
c0102882:	e9 cd fc ff ff       	jmp    c0102554 <__alltraps>

c0102887 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $89
c0102889:	6a 59                	push   $0x59
  jmp __alltraps
c010288b:	e9 c4 fc ff ff       	jmp    c0102554 <__alltraps>

c0102890 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $90
c0102892:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102894:	e9 bb fc ff ff       	jmp    c0102554 <__alltraps>

c0102899 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102899:	6a 00                	push   $0x0
  pushl $91
c010289b:	6a 5b                	push   $0x5b
  jmp __alltraps
c010289d:	e9 b2 fc ff ff       	jmp    c0102554 <__alltraps>

c01028a2 <vector92>:
.globl vector92
vector92:
  pushl $0
c01028a2:	6a 00                	push   $0x0
  pushl $92
c01028a4:	6a 5c                	push   $0x5c
  jmp __alltraps
c01028a6:	e9 a9 fc ff ff       	jmp    c0102554 <__alltraps>

c01028ab <vector93>:
.globl vector93
vector93:
  pushl $0
c01028ab:	6a 00                	push   $0x0
  pushl $93
c01028ad:	6a 5d                	push   $0x5d
  jmp __alltraps
c01028af:	e9 a0 fc ff ff       	jmp    c0102554 <__alltraps>

c01028b4 <vector94>:
.globl vector94
vector94:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $94
c01028b6:	6a 5e                	push   $0x5e
  jmp __alltraps
c01028b8:	e9 97 fc ff ff       	jmp    c0102554 <__alltraps>

c01028bd <vector95>:
.globl vector95
vector95:
  pushl $0
c01028bd:	6a 00                	push   $0x0
  pushl $95
c01028bf:	6a 5f                	push   $0x5f
  jmp __alltraps
c01028c1:	e9 8e fc ff ff       	jmp    c0102554 <__alltraps>

c01028c6 <vector96>:
.globl vector96
vector96:
  pushl $0
c01028c6:	6a 00                	push   $0x0
  pushl $96
c01028c8:	6a 60                	push   $0x60
  jmp __alltraps
c01028ca:	e9 85 fc ff ff       	jmp    c0102554 <__alltraps>

c01028cf <vector97>:
.globl vector97
vector97:
  pushl $0
c01028cf:	6a 00                	push   $0x0
  pushl $97
c01028d1:	6a 61                	push   $0x61
  jmp __alltraps
c01028d3:	e9 7c fc ff ff       	jmp    c0102554 <__alltraps>

c01028d8 <vector98>:
.globl vector98
vector98:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $98
c01028da:	6a 62                	push   $0x62
  jmp __alltraps
c01028dc:	e9 73 fc ff ff       	jmp    c0102554 <__alltraps>

c01028e1 <vector99>:
.globl vector99
vector99:
  pushl $0
c01028e1:	6a 00                	push   $0x0
  pushl $99
c01028e3:	6a 63                	push   $0x63
  jmp __alltraps
c01028e5:	e9 6a fc ff ff       	jmp    c0102554 <__alltraps>

c01028ea <vector100>:
.globl vector100
vector100:
  pushl $0
c01028ea:	6a 00                	push   $0x0
  pushl $100
c01028ec:	6a 64                	push   $0x64
  jmp __alltraps
c01028ee:	e9 61 fc ff ff       	jmp    c0102554 <__alltraps>

c01028f3 <vector101>:
.globl vector101
vector101:
  pushl $0
c01028f3:	6a 00                	push   $0x0
  pushl $101
c01028f5:	6a 65                	push   $0x65
  jmp __alltraps
c01028f7:	e9 58 fc ff ff       	jmp    c0102554 <__alltraps>

c01028fc <vector102>:
.globl vector102
vector102:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $102
c01028fe:	6a 66                	push   $0x66
  jmp __alltraps
c0102900:	e9 4f fc ff ff       	jmp    c0102554 <__alltraps>

c0102905 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102905:	6a 00                	push   $0x0
  pushl $103
c0102907:	6a 67                	push   $0x67
  jmp __alltraps
c0102909:	e9 46 fc ff ff       	jmp    c0102554 <__alltraps>

c010290e <vector104>:
.globl vector104
vector104:
  pushl $0
c010290e:	6a 00                	push   $0x0
  pushl $104
c0102910:	6a 68                	push   $0x68
  jmp __alltraps
c0102912:	e9 3d fc ff ff       	jmp    c0102554 <__alltraps>

c0102917 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102917:	6a 00                	push   $0x0
  pushl $105
c0102919:	6a 69                	push   $0x69
  jmp __alltraps
c010291b:	e9 34 fc ff ff       	jmp    c0102554 <__alltraps>

c0102920 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $106
c0102922:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102924:	e9 2b fc ff ff       	jmp    c0102554 <__alltraps>

c0102929 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102929:	6a 00                	push   $0x0
  pushl $107
c010292b:	6a 6b                	push   $0x6b
  jmp __alltraps
c010292d:	e9 22 fc ff ff       	jmp    c0102554 <__alltraps>

c0102932 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102932:	6a 00                	push   $0x0
  pushl $108
c0102934:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102936:	e9 19 fc ff ff       	jmp    c0102554 <__alltraps>

c010293b <vector109>:
.globl vector109
vector109:
  pushl $0
c010293b:	6a 00                	push   $0x0
  pushl $109
c010293d:	6a 6d                	push   $0x6d
  jmp __alltraps
c010293f:	e9 10 fc ff ff       	jmp    c0102554 <__alltraps>

c0102944 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $110
c0102946:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102948:	e9 07 fc ff ff       	jmp    c0102554 <__alltraps>

c010294d <vector111>:
.globl vector111
vector111:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $111
c010294f:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102951:	e9 fe fb ff ff       	jmp    c0102554 <__alltraps>

c0102956 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $112
c0102958:	6a 70                	push   $0x70
  jmp __alltraps
c010295a:	e9 f5 fb ff ff       	jmp    c0102554 <__alltraps>

c010295f <vector113>:
.globl vector113
vector113:
  pushl $0
c010295f:	6a 00                	push   $0x0
  pushl $113
c0102961:	6a 71                	push   $0x71
  jmp __alltraps
c0102963:	e9 ec fb ff ff       	jmp    c0102554 <__alltraps>

c0102968 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $114
c010296a:	6a 72                	push   $0x72
  jmp __alltraps
c010296c:	e9 e3 fb ff ff       	jmp    c0102554 <__alltraps>

c0102971 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $115
c0102973:	6a 73                	push   $0x73
  jmp __alltraps
c0102975:	e9 da fb ff ff       	jmp    c0102554 <__alltraps>

c010297a <vector116>:
.globl vector116
vector116:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $116
c010297c:	6a 74                	push   $0x74
  jmp __alltraps
c010297e:	e9 d1 fb ff ff       	jmp    c0102554 <__alltraps>

c0102983 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102983:	6a 00                	push   $0x0
  pushl $117
c0102985:	6a 75                	push   $0x75
  jmp __alltraps
c0102987:	e9 c8 fb ff ff       	jmp    c0102554 <__alltraps>

c010298c <vector118>:
.globl vector118
vector118:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $118
c010298e:	6a 76                	push   $0x76
  jmp __alltraps
c0102990:	e9 bf fb ff ff       	jmp    c0102554 <__alltraps>

c0102995 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $119
c0102997:	6a 77                	push   $0x77
  jmp __alltraps
c0102999:	e9 b6 fb ff ff       	jmp    c0102554 <__alltraps>

c010299e <vector120>:
.globl vector120
vector120:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $120
c01029a0:	6a 78                	push   $0x78
  jmp __alltraps
c01029a2:	e9 ad fb ff ff       	jmp    c0102554 <__alltraps>

c01029a7 <vector121>:
.globl vector121
vector121:
  pushl $0
c01029a7:	6a 00                	push   $0x0
  pushl $121
c01029a9:	6a 79                	push   $0x79
  jmp __alltraps
c01029ab:	e9 a4 fb ff ff       	jmp    c0102554 <__alltraps>

c01029b0 <vector122>:
.globl vector122
vector122:
  pushl $0
c01029b0:	6a 00                	push   $0x0
  pushl $122
c01029b2:	6a 7a                	push   $0x7a
  jmp __alltraps
c01029b4:	e9 9b fb ff ff       	jmp    c0102554 <__alltraps>

c01029b9 <vector123>:
.globl vector123
vector123:
  pushl $0
c01029b9:	6a 00                	push   $0x0
  pushl $123
c01029bb:	6a 7b                	push   $0x7b
  jmp __alltraps
c01029bd:	e9 92 fb ff ff       	jmp    c0102554 <__alltraps>

c01029c2 <vector124>:
.globl vector124
vector124:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $124
c01029c4:	6a 7c                	push   $0x7c
  jmp __alltraps
c01029c6:	e9 89 fb ff ff       	jmp    c0102554 <__alltraps>

c01029cb <vector125>:
.globl vector125
vector125:
  pushl $0
c01029cb:	6a 00                	push   $0x0
  pushl $125
c01029cd:	6a 7d                	push   $0x7d
  jmp __alltraps
c01029cf:	e9 80 fb ff ff       	jmp    c0102554 <__alltraps>

c01029d4 <vector126>:
.globl vector126
vector126:
  pushl $0
c01029d4:	6a 00                	push   $0x0
  pushl $126
c01029d6:	6a 7e                	push   $0x7e
  jmp __alltraps
c01029d8:	e9 77 fb ff ff       	jmp    c0102554 <__alltraps>

c01029dd <vector127>:
.globl vector127
vector127:
  pushl $0
c01029dd:	6a 00                	push   $0x0
  pushl $127
c01029df:	6a 7f                	push   $0x7f
  jmp __alltraps
c01029e1:	e9 6e fb ff ff       	jmp    c0102554 <__alltraps>

c01029e6 <vector128>:
.globl vector128
vector128:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $128
c01029e8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01029ed:	e9 62 fb ff ff       	jmp    c0102554 <__alltraps>

c01029f2 <vector129>:
.globl vector129
vector129:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $129
c01029f4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01029f9:	e9 56 fb ff ff       	jmp    c0102554 <__alltraps>

c01029fe <vector130>:
.globl vector130
vector130:
  pushl $0
c01029fe:	6a 00                	push   $0x0
  pushl $130
c0102a00:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102a05:	e9 4a fb ff ff       	jmp    c0102554 <__alltraps>

c0102a0a <vector131>:
.globl vector131
vector131:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $131
c0102a0c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102a11:	e9 3e fb ff ff       	jmp    c0102554 <__alltraps>

c0102a16 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $132
c0102a18:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102a1d:	e9 32 fb ff ff       	jmp    c0102554 <__alltraps>

c0102a22 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102a22:	6a 00                	push   $0x0
  pushl $133
c0102a24:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102a29:	e9 26 fb ff ff       	jmp    c0102554 <__alltraps>

c0102a2e <vector134>:
.globl vector134
vector134:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $134
c0102a30:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102a35:	e9 1a fb ff ff       	jmp    c0102554 <__alltraps>

c0102a3a <vector135>:
.globl vector135
vector135:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $135
c0102a3c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102a41:	e9 0e fb ff ff       	jmp    c0102554 <__alltraps>

c0102a46 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102a46:	6a 00                	push   $0x0
  pushl $136
c0102a48:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102a4d:	e9 02 fb ff ff       	jmp    c0102554 <__alltraps>

c0102a52 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $137
c0102a54:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102a59:	e9 f6 fa ff ff       	jmp    c0102554 <__alltraps>

c0102a5e <vector138>:
.globl vector138
vector138:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $138
c0102a60:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102a65:	e9 ea fa ff ff       	jmp    c0102554 <__alltraps>

c0102a6a <vector139>:
.globl vector139
vector139:
  pushl $0
c0102a6a:	6a 00                	push   $0x0
  pushl $139
c0102a6c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102a71:	e9 de fa ff ff       	jmp    c0102554 <__alltraps>

c0102a76 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $140
c0102a78:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102a7d:	e9 d2 fa ff ff       	jmp    c0102554 <__alltraps>

c0102a82 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $141
c0102a84:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102a89:	e9 c6 fa ff ff       	jmp    c0102554 <__alltraps>

c0102a8e <vector142>:
.globl vector142
vector142:
  pushl $0
c0102a8e:	6a 00                	push   $0x0
  pushl $142
c0102a90:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102a95:	e9 ba fa ff ff       	jmp    c0102554 <__alltraps>

c0102a9a <vector143>:
.globl vector143
vector143:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $143
c0102a9c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102aa1:	e9 ae fa ff ff       	jmp    c0102554 <__alltraps>

c0102aa6 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $144
c0102aa8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102aad:	e9 a2 fa ff ff       	jmp    c0102554 <__alltraps>

c0102ab2 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102ab2:	6a 00                	push   $0x0
  pushl $145
c0102ab4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102ab9:	e9 96 fa ff ff       	jmp    c0102554 <__alltraps>

c0102abe <vector146>:
.globl vector146
vector146:
  pushl $0
c0102abe:	6a 00                	push   $0x0
  pushl $146
c0102ac0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ac5:	e9 8a fa ff ff       	jmp    c0102554 <__alltraps>

c0102aca <vector147>:
.globl vector147
vector147:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $147
c0102acc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102ad1:	e9 7e fa ff ff       	jmp    c0102554 <__alltraps>

c0102ad6 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102ad6:	6a 00                	push   $0x0
  pushl $148
c0102ad8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102add:	e9 72 fa ff ff       	jmp    c0102554 <__alltraps>

c0102ae2 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102ae2:	6a 00                	push   $0x0
  pushl $149
c0102ae4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102ae9:	e9 66 fa ff ff       	jmp    c0102554 <__alltraps>

c0102aee <vector150>:
.globl vector150
vector150:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $150
c0102af0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102af5:	e9 5a fa ff ff       	jmp    c0102554 <__alltraps>

c0102afa <vector151>:
.globl vector151
vector151:
  pushl $0
c0102afa:	6a 00                	push   $0x0
  pushl $151
c0102afc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102b01:	e9 4e fa ff ff       	jmp    c0102554 <__alltraps>

c0102b06 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102b06:	6a 00                	push   $0x0
  pushl $152
c0102b08:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102b0d:	e9 42 fa ff ff       	jmp    c0102554 <__alltraps>

c0102b12 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $153
c0102b14:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102b19:	e9 36 fa ff ff       	jmp    c0102554 <__alltraps>

c0102b1e <vector154>:
.globl vector154
vector154:
  pushl $0
c0102b1e:	6a 00                	push   $0x0
  pushl $154
c0102b20:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102b25:	e9 2a fa ff ff       	jmp    c0102554 <__alltraps>

c0102b2a <vector155>:
.globl vector155
vector155:
  pushl $0
c0102b2a:	6a 00                	push   $0x0
  pushl $155
c0102b2c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102b31:	e9 1e fa ff ff       	jmp    c0102554 <__alltraps>

c0102b36 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $156
c0102b38:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102b3d:	e9 12 fa ff ff       	jmp    c0102554 <__alltraps>

c0102b42 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102b42:	6a 00                	push   $0x0
  pushl $157
c0102b44:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102b49:	e9 06 fa ff ff       	jmp    c0102554 <__alltraps>

c0102b4e <vector158>:
.globl vector158
vector158:
  pushl $0
c0102b4e:	6a 00                	push   $0x0
  pushl $158
c0102b50:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102b55:	e9 fa f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b5a <vector159>:
.globl vector159
vector159:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $159
c0102b5c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102b61:	e9 ee f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b66 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102b66:	6a 00                	push   $0x0
  pushl $160
c0102b68:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102b6d:	e9 e2 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b72 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102b72:	6a 00                	push   $0x0
  pushl $161
c0102b74:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102b79:	e9 d6 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b7e <vector162>:
.globl vector162
vector162:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $162
c0102b80:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102b85:	e9 ca f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b8a <vector163>:
.globl vector163
vector163:
  pushl $0
c0102b8a:	6a 00                	push   $0x0
  pushl $163
c0102b8c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102b91:	e9 be f9 ff ff       	jmp    c0102554 <__alltraps>

c0102b96 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102b96:	6a 00                	push   $0x0
  pushl $164
c0102b98:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102b9d:	e9 b2 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102ba2 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $165
c0102ba4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ba9:	e9 a6 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bae <vector166>:
.globl vector166
vector166:
  pushl $0
c0102bae:	6a 00                	push   $0x0
  pushl $166
c0102bb0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102bb5:	e9 9a f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bba <vector167>:
.globl vector167
vector167:
  pushl $0
c0102bba:	6a 00                	push   $0x0
  pushl $167
c0102bbc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102bc1:	e9 8e f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bc6 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $168
c0102bc8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102bcd:	e9 82 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bd2 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102bd2:	6a 00                	push   $0x0
  pushl $169
c0102bd4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102bd9:	e9 76 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bde <vector170>:
.globl vector170
vector170:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $170
c0102be0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102be5:	e9 6a f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bea <vector171>:
.globl vector171
vector171:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $171
c0102bec:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102bf1:	e9 5e f9 ff ff       	jmp    c0102554 <__alltraps>

c0102bf6 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102bf6:	6a 00                	push   $0x0
  pushl $172
c0102bf8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102bfd:	e9 52 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c02 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $173
c0102c04:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102c09:	e9 46 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c0e <vector174>:
.globl vector174
vector174:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $174
c0102c10:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102c15:	e9 3a f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c1a <vector175>:
.globl vector175
vector175:
  pushl $0
c0102c1a:	6a 00                	push   $0x0
  pushl $175
c0102c1c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102c21:	e9 2e f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c26 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102c26:	6a 00                	push   $0x0
  pushl $176
c0102c28:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102c2d:	e9 22 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c32 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $177
c0102c34:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102c39:	e9 16 f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c3e <vector178>:
.globl vector178
vector178:
  pushl $0
c0102c3e:	6a 00                	push   $0x0
  pushl $178
c0102c40:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102c45:	e9 0a f9 ff ff       	jmp    c0102554 <__alltraps>

c0102c4a <vector179>:
.globl vector179
vector179:
  pushl $0
c0102c4a:	6a 00                	push   $0x0
  pushl $179
c0102c4c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102c51:	e9 fe f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c56 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $180
c0102c58:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102c5d:	e9 f2 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c62 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102c62:	6a 00                	push   $0x0
  pushl $181
c0102c64:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102c69:	e9 e6 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c6e <vector182>:
.globl vector182
vector182:
  pushl $0
c0102c6e:	6a 00                	push   $0x0
  pushl $182
c0102c70:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102c75:	e9 da f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c7a <vector183>:
.globl vector183
vector183:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $183
c0102c7c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102c81:	e9 ce f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c86 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102c86:	6a 00                	push   $0x0
  pushl $184
c0102c88:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102c8d:	e9 c2 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c92 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102c92:	6a 00                	push   $0x0
  pushl $185
c0102c94:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102c99:	e9 b6 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102c9e <vector186>:
.globl vector186
vector186:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $186
c0102ca0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ca5:	e9 aa f8 ff ff       	jmp    c0102554 <__alltraps>

c0102caa <vector187>:
.globl vector187
vector187:
  pushl $0
c0102caa:	6a 00                	push   $0x0
  pushl $187
c0102cac:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102cb1:	e9 9e f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cb6 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102cb6:	6a 00                	push   $0x0
  pushl $188
c0102cb8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102cbd:	e9 92 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cc2 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $189
c0102cc4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102cc9:	e9 86 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cce <vector190>:
.globl vector190
vector190:
  pushl $0
c0102cce:	6a 00                	push   $0x0
  pushl $190
c0102cd0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102cd5:	e9 7a f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cda <vector191>:
.globl vector191
vector191:
  pushl $0
c0102cda:	6a 00                	push   $0x0
  pushl $191
c0102cdc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102ce1:	e9 6e f8 ff ff       	jmp    c0102554 <__alltraps>

c0102ce6 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ce6:	6a 00                	push   $0x0
  pushl $192
c0102ce8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ced:	e9 62 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cf2 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102cf2:	6a 00                	push   $0x0
  pushl $193
c0102cf4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102cf9:	e9 56 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102cfe <vector194>:
.globl vector194
vector194:
  pushl $0
c0102cfe:	6a 00                	push   $0x0
  pushl $194
c0102d00:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102d05:	e9 4a f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d0a <vector195>:
.globl vector195
vector195:
  pushl $0
c0102d0a:	6a 00                	push   $0x0
  pushl $195
c0102d0c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102d11:	e9 3e f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d16 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102d16:	6a 00                	push   $0x0
  pushl $196
c0102d18:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102d1d:	e9 32 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d22 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102d22:	6a 00                	push   $0x0
  pushl $197
c0102d24:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102d29:	e9 26 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d2e <vector198>:
.globl vector198
vector198:
  pushl $0
c0102d2e:	6a 00                	push   $0x0
  pushl $198
c0102d30:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102d35:	e9 1a f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d3a <vector199>:
.globl vector199
vector199:
  pushl $0
c0102d3a:	6a 00                	push   $0x0
  pushl $199
c0102d3c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102d41:	e9 0e f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d46 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102d46:	6a 00                	push   $0x0
  pushl $200
c0102d48:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102d4d:	e9 02 f8 ff ff       	jmp    c0102554 <__alltraps>

c0102d52 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102d52:	6a 00                	push   $0x0
  pushl $201
c0102d54:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102d59:	e9 f6 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d5e <vector202>:
.globl vector202
vector202:
  pushl $0
c0102d5e:	6a 00                	push   $0x0
  pushl $202
c0102d60:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102d65:	e9 ea f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d6a <vector203>:
.globl vector203
vector203:
  pushl $0
c0102d6a:	6a 00                	push   $0x0
  pushl $203
c0102d6c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102d71:	e9 de f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d76 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102d76:	6a 00                	push   $0x0
  pushl $204
c0102d78:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102d7d:	e9 d2 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d82 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102d82:	6a 00                	push   $0x0
  pushl $205
c0102d84:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102d89:	e9 c6 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d8e <vector206>:
.globl vector206
vector206:
  pushl $0
c0102d8e:	6a 00                	push   $0x0
  pushl $206
c0102d90:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102d95:	e9 ba f7 ff ff       	jmp    c0102554 <__alltraps>

c0102d9a <vector207>:
.globl vector207
vector207:
  pushl $0
c0102d9a:	6a 00                	push   $0x0
  pushl $207
c0102d9c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102da1:	e9 ae f7 ff ff       	jmp    c0102554 <__alltraps>

c0102da6 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102da6:	6a 00                	push   $0x0
  pushl $208
c0102da8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102dad:	e9 a2 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102db2 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102db2:	6a 00                	push   $0x0
  pushl $209
c0102db4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102db9:	e9 96 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102dbe <vector210>:
.globl vector210
vector210:
  pushl $0
c0102dbe:	6a 00                	push   $0x0
  pushl $210
c0102dc0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102dc5:	e9 8a f7 ff ff       	jmp    c0102554 <__alltraps>

c0102dca <vector211>:
.globl vector211
vector211:
  pushl $0
c0102dca:	6a 00                	push   $0x0
  pushl $211
c0102dcc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102dd1:	e9 7e f7 ff ff       	jmp    c0102554 <__alltraps>

c0102dd6 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102dd6:	6a 00                	push   $0x0
  pushl $212
c0102dd8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102ddd:	e9 72 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102de2 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102de2:	6a 00                	push   $0x0
  pushl $213
c0102de4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102de9:	e9 66 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102dee <vector214>:
.globl vector214
vector214:
  pushl $0
c0102dee:	6a 00                	push   $0x0
  pushl $214
c0102df0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102df5:	e9 5a f7 ff ff       	jmp    c0102554 <__alltraps>

c0102dfa <vector215>:
.globl vector215
vector215:
  pushl $0
c0102dfa:	6a 00                	push   $0x0
  pushl $215
c0102dfc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102e01:	e9 4e f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e06 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102e06:	6a 00                	push   $0x0
  pushl $216
c0102e08:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102e0d:	e9 42 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e12 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102e12:	6a 00                	push   $0x0
  pushl $217
c0102e14:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102e19:	e9 36 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e1e <vector218>:
.globl vector218
vector218:
  pushl $0
c0102e1e:	6a 00                	push   $0x0
  pushl $218
c0102e20:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102e25:	e9 2a f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e2a <vector219>:
.globl vector219
vector219:
  pushl $0
c0102e2a:	6a 00                	push   $0x0
  pushl $219
c0102e2c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102e31:	e9 1e f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e36 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102e36:	6a 00                	push   $0x0
  pushl $220
c0102e38:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102e3d:	e9 12 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e42 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102e42:	6a 00                	push   $0x0
  pushl $221
c0102e44:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102e49:	e9 06 f7 ff ff       	jmp    c0102554 <__alltraps>

c0102e4e <vector222>:
.globl vector222
vector222:
  pushl $0
c0102e4e:	6a 00                	push   $0x0
  pushl $222
c0102e50:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102e55:	e9 fa f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e5a <vector223>:
.globl vector223
vector223:
  pushl $0
c0102e5a:	6a 00                	push   $0x0
  pushl $223
c0102e5c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102e61:	e9 ee f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e66 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102e66:	6a 00                	push   $0x0
  pushl $224
c0102e68:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102e6d:	e9 e2 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e72 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102e72:	6a 00                	push   $0x0
  pushl $225
c0102e74:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102e79:	e9 d6 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e7e <vector226>:
.globl vector226
vector226:
  pushl $0
c0102e7e:	6a 00                	push   $0x0
  pushl $226
c0102e80:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102e85:	e9 ca f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e8a <vector227>:
.globl vector227
vector227:
  pushl $0
c0102e8a:	6a 00                	push   $0x0
  pushl $227
c0102e8c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102e91:	e9 be f6 ff ff       	jmp    c0102554 <__alltraps>

c0102e96 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102e96:	6a 00                	push   $0x0
  pushl $228
c0102e98:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102e9d:	e9 b2 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102ea2 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102ea2:	6a 00                	push   $0x0
  pushl $229
c0102ea4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102ea9:	e9 a6 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102eae <vector230>:
.globl vector230
vector230:
  pushl $0
c0102eae:	6a 00                	push   $0x0
  pushl $230
c0102eb0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102eb5:	e9 9a f6 ff ff       	jmp    c0102554 <__alltraps>

c0102eba <vector231>:
.globl vector231
vector231:
  pushl $0
c0102eba:	6a 00                	push   $0x0
  pushl $231
c0102ebc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102ec1:	e9 8e f6 ff ff       	jmp    c0102554 <__alltraps>

c0102ec6 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102ec6:	6a 00                	push   $0x0
  pushl $232
c0102ec8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102ecd:	e9 82 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102ed2 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102ed2:	6a 00                	push   $0x0
  pushl $233
c0102ed4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102ed9:	e9 76 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102ede <vector234>:
.globl vector234
vector234:
  pushl $0
c0102ede:	6a 00                	push   $0x0
  pushl $234
c0102ee0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102ee5:	e9 6a f6 ff ff       	jmp    c0102554 <__alltraps>

c0102eea <vector235>:
.globl vector235
vector235:
  pushl $0
c0102eea:	6a 00                	push   $0x0
  pushl $235
c0102eec:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102ef1:	e9 5e f6 ff ff       	jmp    c0102554 <__alltraps>

c0102ef6 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102ef6:	6a 00                	push   $0x0
  pushl $236
c0102ef8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102efd:	e9 52 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f02 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102f02:	6a 00                	push   $0x0
  pushl $237
c0102f04:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102f09:	e9 46 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f0e <vector238>:
.globl vector238
vector238:
  pushl $0
c0102f0e:	6a 00                	push   $0x0
  pushl $238
c0102f10:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102f15:	e9 3a f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f1a <vector239>:
.globl vector239
vector239:
  pushl $0
c0102f1a:	6a 00                	push   $0x0
  pushl $239
c0102f1c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102f21:	e9 2e f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f26 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102f26:	6a 00                	push   $0x0
  pushl $240
c0102f28:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102f2d:	e9 22 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f32 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102f32:	6a 00                	push   $0x0
  pushl $241
c0102f34:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102f39:	e9 16 f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f3e <vector242>:
.globl vector242
vector242:
  pushl $0
c0102f3e:	6a 00                	push   $0x0
  pushl $242
c0102f40:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102f45:	e9 0a f6 ff ff       	jmp    c0102554 <__alltraps>

c0102f4a <vector243>:
.globl vector243
vector243:
  pushl $0
c0102f4a:	6a 00                	push   $0x0
  pushl $243
c0102f4c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102f51:	e9 fe f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f56 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102f56:	6a 00                	push   $0x0
  pushl $244
c0102f58:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102f5d:	e9 f2 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f62 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102f62:	6a 00                	push   $0x0
  pushl $245
c0102f64:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102f69:	e9 e6 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f6e <vector246>:
.globl vector246
vector246:
  pushl $0
c0102f6e:	6a 00                	push   $0x0
  pushl $246
c0102f70:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102f75:	e9 da f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f7a <vector247>:
.globl vector247
vector247:
  pushl $0
c0102f7a:	6a 00                	push   $0x0
  pushl $247
c0102f7c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102f81:	e9 ce f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f86 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102f86:	6a 00                	push   $0x0
  pushl $248
c0102f88:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102f8d:	e9 c2 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f92 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102f92:	6a 00                	push   $0x0
  pushl $249
c0102f94:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102f99:	e9 b6 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102f9e <vector250>:
.globl vector250
vector250:
  pushl $0
c0102f9e:	6a 00                	push   $0x0
  pushl $250
c0102fa0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102fa5:	e9 aa f5 ff ff       	jmp    c0102554 <__alltraps>

c0102faa <vector251>:
.globl vector251
vector251:
  pushl $0
c0102faa:	6a 00                	push   $0x0
  pushl $251
c0102fac:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102fb1:	e9 9e f5 ff ff       	jmp    c0102554 <__alltraps>

c0102fb6 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102fb6:	6a 00                	push   $0x0
  pushl $252
c0102fb8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102fbd:	e9 92 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102fc2 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102fc2:	6a 00                	push   $0x0
  pushl $253
c0102fc4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102fc9:	e9 86 f5 ff ff       	jmp    c0102554 <__alltraps>

c0102fce <vector254>:
.globl vector254
vector254:
  pushl $0
c0102fce:	6a 00                	push   $0x0
  pushl $254
c0102fd0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102fd5:	e9 7a f5 ff ff       	jmp    c0102554 <__alltraps>

c0102fda <vector255>:
.globl vector255
vector255:
  pushl $0
c0102fda:	6a 00                	push   $0x0
  pushl $255
c0102fdc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102fe1:	e9 6e f5 ff ff       	jmp    c0102554 <__alltraps>

c0102fe6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102fe6:	55                   	push   %ebp
c0102fe7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102fe9:	8b 55 08             	mov    0x8(%ebp),%edx
c0102fec:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0102ff1:	29 c2                	sub    %eax,%edx
c0102ff3:	89 d0                	mov    %edx,%eax
c0102ff5:	c1 f8 05             	sar    $0x5,%eax
}
c0102ff8:	5d                   	pop    %ebp
c0102ff9:	c3                   	ret    

c0102ffa <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102ffa:	55                   	push   %ebp
c0102ffb:	89 e5                	mov    %esp,%ebp
c0102ffd:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103000:	8b 45 08             	mov    0x8(%ebp),%eax
c0103003:	89 04 24             	mov    %eax,(%esp)
c0103006:	e8 db ff ff ff       	call   c0102fe6 <page2ppn>
c010300b:	c1 e0 0c             	shl    $0xc,%eax
}
c010300e:	c9                   	leave  
c010300f:	c3                   	ret    

c0103010 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103010:	55                   	push   %ebp
c0103011:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103013:	8b 45 08             	mov    0x8(%ebp),%eax
c0103016:	8b 00                	mov    (%eax),%eax
}
c0103018:	5d                   	pop    %ebp
c0103019:	c3                   	ret    

c010301a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010301a:	55                   	push   %ebp
c010301b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010301d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103020:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103023:	89 10                	mov    %edx,(%eax)
}
c0103025:	5d                   	pop    %ebp
c0103026:	c3                   	ret    

c0103027 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103027:	55                   	push   %ebp
c0103028:	89 e5                	mov    %esp,%ebp
c010302a:	83 ec 10             	sub    $0x10,%esp
c010302d:	c7 45 fc c0 0a 12 c0 	movl   $0xc0120ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103034:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103037:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010303a:	89 50 04             	mov    %edx,0x4(%eax)
c010303d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103040:	8b 50 04             	mov    0x4(%eax),%edx
c0103043:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103046:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103048:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c010304f:	00 00 00 
}
c0103052:	c9                   	leave  
c0103053:	c3                   	ret    

c0103054 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103054:	55                   	push   %ebp
c0103055:	89 e5                	mov    %esp,%ebp
c0103057:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010305a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010305e:	75 24                	jne    c0103084 <default_init_memmap+0x30>
c0103060:	c7 44 24 0c 70 8f 10 	movl   $0xc0108f70,0xc(%esp)
c0103067:	c0 
c0103068:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010306f:	c0 
c0103070:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103077:	00 
c0103078:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010307f:	e8 97 db ff ff       	call   c0100c1b <__panic>
    struct Page *p = base;
c0103084:	8b 45 08             	mov    0x8(%ebp),%eax
c0103087:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010308a:	eb 7d                	jmp    c0103109 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c010308c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010308f:	83 c0 04             	add    $0x4,%eax
c0103092:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103099:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010309c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010309f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01030a2:	0f a3 10             	bt     %edx,(%eax)
c01030a5:	19 c0                	sbb    %eax,%eax
c01030a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01030aa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01030ae:	0f 95 c0             	setne  %al
c01030b1:	0f b6 c0             	movzbl %al,%eax
c01030b4:	85 c0                	test   %eax,%eax
c01030b6:	75 24                	jne    c01030dc <default_init_memmap+0x88>
c01030b8:	c7 44 24 0c a1 8f 10 	movl   $0xc0108fa1,0xc(%esp)
c01030bf:	c0 
c01030c0:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01030c7:	c0 
c01030c8:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01030cf:	00 
c01030d0:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01030d7:	e8 3f db ff ff       	call   c0100c1b <__panic>
        p->flags = p->property = 0;
c01030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030e9:	8b 50 08             	mov    0x8(%eax),%edx
c01030ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030ef:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01030f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01030f9:	00 
c01030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030fd:	89 04 24             	mov    %eax,(%esp)
c0103100:	e8 15 ff ff ff       	call   c010301a <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103105:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103109:	8b 45 0c             	mov    0xc(%ebp),%eax
c010310c:	c1 e0 05             	shl    $0x5,%eax
c010310f:	89 c2                	mov    %eax,%edx
c0103111:	8b 45 08             	mov    0x8(%ebp),%eax
c0103114:	01 d0                	add    %edx,%eax
c0103116:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103119:	0f 85 6d ff ff ff    	jne    c010308c <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c010311f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103122:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103125:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0103128:	8b 45 08             	mov    0x8(%ebp),%eax
c010312b:	83 c0 04             	add    $0x4,%eax
c010312e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103135:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103138:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010313b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010313e:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0103141:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c0103147:	8b 45 0c             	mov    0xc(%ebp),%eax
c010314a:	01 d0                	add    %edx,%eax
c010314c:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    list_add(&free_list, &(base->page_link));
c0103151:	8b 45 08             	mov    0x8(%ebp),%eax
c0103154:	83 c0 0c             	add    $0xc,%eax
c0103157:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
c010315e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103161:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103164:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103167:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010316a:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010316d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103170:	8b 40 04             	mov    0x4(%eax),%eax
c0103173:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103176:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0103179:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010317c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010317f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103182:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103185:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103188:	89 10                	mov    %edx,(%eax)
c010318a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010318d:	8b 10                	mov    (%eax),%edx
c010318f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103192:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103195:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103198:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010319b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010319e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01031a1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01031a4:	89 10                	mov    %edx,(%eax)
}
c01031a6:	c9                   	leave  
c01031a7:	c3                   	ret    

c01031a8 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01031a8:	55                   	push   %ebp
c01031a9:	89 e5                	mov    %esp,%ebp
c01031ab:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01031ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01031b2:	75 24                	jne    c01031d8 <default_alloc_pages+0x30>
c01031b4:	c7 44 24 0c 70 8f 10 	movl   $0xc0108f70,0xc(%esp)
c01031bb:	c0 
c01031bc:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01031c3:	c0 
c01031c4:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c01031cb:	00 
c01031cc:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01031d3:	e8 43 da ff ff       	call   c0100c1b <__panic>
    if (n > nr_free) {
c01031d8:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01031dd:	3b 45 08             	cmp    0x8(%ebp),%eax
c01031e0:	73 0a                	jae    c01031ec <default_alloc_pages+0x44>
        return NULL;
c01031e2:	b8 00 00 00 00       	mov    $0x0,%eax
c01031e7:	e9 23 01 00 00       	jmp    c010330f <default_alloc_pages+0x167>
    }
    struct Page *page = NULL;
c01031ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01031f3:	c7 45 f0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01031fa:	eb 1c                	jmp    c0103218 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01031fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031ff:	83 e8 0c             	sub    $0xc,%eax
c0103202:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0103205:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103208:	8b 40 08             	mov    0x8(%eax),%eax
c010320b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010320e:	72 08                	jb     c0103218 <default_alloc_pages+0x70>
            page = p;
c0103210:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103213:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103216:	eb 18                	jmp    c0103230 <default_alloc_pages+0x88>
c0103218:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010321b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010321e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103221:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103224:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103227:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c010322e:	75 cc                	jne    c01031fc <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0103230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103234:	0f 84 d2 00 00 00    	je     c010330c <default_alloc_pages+0x164>
        list_del(&(page->page_link));
c010323a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010323d:	83 c0 0c             	add    $0xc,%eax
c0103240:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103243:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103246:	8b 40 04             	mov    0x4(%eax),%eax
c0103249:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010324c:	8b 12                	mov    (%edx),%edx
c010324e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0103251:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103254:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103257:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010325a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010325d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103260:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103263:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0103265:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103268:	8b 40 08             	mov    0x8(%eax),%eax
c010326b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010326e:	76 76                	jbe    c01032e6 <default_alloc_pages+0x13e>
            struct Page *p = page + n;
c0103270:	8b 45 08             	mov    0x8(%ebp),%eax
c0103273:	c1 e0 05             	shl    $0x5,%eax
c0103276:	89 c2                	mov    %eax,%edx
c0103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010327b:	01 d0                	add    %edx,%eax
c010327d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0103280:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103283:	8b 40 08             	mov    0x8(%eax),%eax
c0103286:	2b 45 08             	sub    0x8(%ebp),%eax
c0103289:	89 c2                	mov    %eax,%edx
c010328b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010328e:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0103291:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103294:	83 c0 0c             	add    $0xc,%eax
c0103297:	c7 45 d4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x2c(%ebp)
c010329e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01032a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01032a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01032a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032aa:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01032ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01032b0:	8b 40 04             	mov    0x4(%eax),%eax
c01032b3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01032b6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01032b9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01032bc:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01032bf:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01032c2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01032c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01032c8:	89 10                	mov    %edx,(%eax)
c01032ca:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01032cd:	8b 10                	mov    (%eax),%edx
c01032cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01032d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01032d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032d8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01032db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01032de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032e1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01032e4:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c01032e6:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01032eb:	2b 45 08             	sub    0x8(%ebp),%eax
c01032ee:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
        ClearPageProperty(page);
c01032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f6:	83 c0 04             	add    $0x4,%eax
c01032f9:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0103300:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103303:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103306:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103309:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010330f:	c9                   	leave  
c0103310:	c3                   	ret    

c0103311 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103311:	55                   	push   %ebp
c0103312:	89 e5                	mov    %esp,%ebp
c0103314:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c010331a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010331e:	75 24                	jne    c0103344 <default_free_pages+0x33>
c0103320:	c7 44 24 0c 70 8f 10 	movl   $0xc0108f70,0xc(%esp)
c0103327:	c0 
c0103328:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010332f:	c0 
c0103330:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0103337:	00 
c0103338:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010333f:	e8 d7 d8 ff ff       	call   c0100c1b <__panic>
    struct Page *p = base;
c0103344:	8b 45 08             	mov    0x8(%ebp),%eax
c0103347:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010334a:	e9 9d 00 00 00       	jmp    c01033ec <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010334f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103352:	83 c0 04             	add    $0x4,%eax
c0103355:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010335c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010335f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103362:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103365:	0f a3 10             	bt     %edx,(%eax)
c0103368:	19 c0                	sbb    %eax,%eax
c010336a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c010336d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103371:	0f 95 c0             	setne  %al
c0103374:	0f b6 c0             	movzbl %al,%eax
c0103377:	85 c0                	test   %eax,%eax
c0103379:	75 2c                	jne    c01033a7 <default_free_pages+0x96>
c010337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010337e:	83 c0 04             	add    $0x4,%eax
c0103381:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0103388:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010338b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010338e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103391:	0f a3 10             	bt     %edx,(%eax)
c0103394:	19 c0                	sbb    %eax,%eax
c0103396:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0103399:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010339d:	0f 95 c0             	setne  %al
c01033a0:	0f b6 c0             	movzbl %al,%eax
c01033a3:	85 c0                	test   %eax,%eax
c01033a5:	74 24                	je     c01033cb <default_free_pages+0xba>
c01033a7:	c7 44 24 0c b4 8f 10 	movl   $0xc0108fb4,0xc(%esp)
c01033ae:	c0 
c01033af:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01033b6:	c0 
c01033b7:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c01033be:	00 
c01033bf:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01033c6:	e8 50 d8 ff ff       	call   c0100c1b <__panic>
        p->flags = 0;
c01033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01033d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01033dc:	00 
c01033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e0:	89 04 24             	mov    %eax,(%esp)
c01033e3:	e8 32 fc ff ff       	call   c010301a <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01033e8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033ef:	c1 e0 05             	shl    $0x5,%eax
c01033f2:	89 c2                	mov    %eax,%edx
c01033f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01033f7:	01 d0                	add    %edx,%eax
c01033f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01033fc:	0f 85 4d ff ff ff    	jne    c010334f <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0103402:	8b 45 08             	mov    0x8(%ebp),%eax
c0103405:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103408:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010340b:	8b 45 08             	mov    0x8(%ebp),%eax
c010340e:	83 c0 04             	add    $0x4,%eax
c0103411:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103418:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010341b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010341e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103421:	0f ab 10             	bts    %edx,(%eax)
c0103424:	c7 45 cc c0 0a 12 c0 	movl   $0xc0120ac0,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010342b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010342e:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103431:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0103434:	e9 fa 00 00 00       	jmp    c0103533 <default_free_pages+0x222>
        p = le2page(le, page_link);
c0103439:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010343c:	83 e8 0c             	sub    $0xc,%eax
c010343f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103445:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103448:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010344b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010344e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0103451:	8b 45 08             	mov    0x8(%ebp),%eax
c0103454:	8b 40 08             	mov    0x8(%eax),%eax
c0103457:	c1 e0 05             	shl    $0x5,%eax
c010345a:	89 c2                	mov    %eax,%edx
c010345c:	8b 45 08             	mov    0x8(%ebp),%eax
c010345f:	01 d0                	add    %edx,%eax
c0103461:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103464:	75 5a                	jne    c01034c0 <default_free_pages+0x1af>
            base->property += p->property;
c0103466:	8b 45 08             	mov    0x8(%ebp),%eax
c0103469:	8b 50 08             	mov    0x8(%eax),%edx
c010346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010346f:	8b 40 08             	mov    0x8(%eax),%eax
c0103472:	01 c2                	add    %eax,%edx
c0103474:	8b 45 08             	mov    0x8(%ebp),%eax
c0103477:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347d:	83 c0 04             	add    $0x4,%eax
c0103480:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103487:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010348a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010348d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103490:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0103493:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103496:	83 c0 0c             	add    $0xc,%eax
c0103499:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010349c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010349f:	8b 40 04             	mov    0x4(%eax),%eax
c01034a2:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01034a5:	8b 12                	mov    (%edx),%edx
c01034a7:	89 55 b8             	mov    %edx,-0x48(%ebp)
c01034aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01034b0:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034b3:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034b9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034bc:	89 10                	mov    %edx,(%eax)
c01034be:	eb 73                	jmp    c0103533 <default_free_pages+0x222>
        }
        else if (p + p->property == base) {
c01034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c3:	8b 40 08             	mov    0x8(%eax),%eax
c01034c6:	c1 e0 05             	shl    $0x5,%eax
c01034c9:	89 c2                	mov    %eax,%edx
c01034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034ce:	01 d0                	add    %edx,%eax
c01034d0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034d3:	75 5e                	jne    c0103533 <default_free_pages+0x222>
            p->property += base->property;
c01034d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d8:	8b 50 08             	mov    0x8(%eax),%edx
c01034db:	8b 45 08             	mov    0x8(%ebp),%eax
c01034de:	8b 40 08             	mov    0x8(%eax),%eax
c01034e1:	01 c2                	add    %eax,%edx
c01034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e6:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01034e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ec:	83 c0 04             	add    $0x4,%eax
c01034ef:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c01034f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
c01034f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01034ff:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0103502:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103505:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0103508:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010350b:	83 c0 0c             	add    $0xc,%eax
c010350e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103511:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103514:	8b 40 04             	mov    0x4(%eax),%eax
c0103517:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010351a:	8b 12                	mov    (%edx),%edx
c010351c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c010351f:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103522:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103525:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103528:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010352b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010352e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103531:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0103533:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c010353a:	0f 85 f9 fe ff ff    	jne    c0103439 <default_free_pages+0x128>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0103540:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c0103546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103549:	01 d0                	add    %edx,%eax
c010354b:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    list_add(&free_list, &(base->page_link));
c0103550:	8b 45 08             	mov    0x8(%ebp),%eax
c0103553:	83 c0 0c             	add    $0xc,%eax
c0103556:	c7 45 9c c0 0a 12 c0 	movl   $0xc0120ac0,-0x64(%ebp)
c010355d:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103560:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103563:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103566:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103569:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010356c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010356f:	8b 40 04             	mov    0x4(%eax),%eax
c0103572:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103575:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0103578:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010357b:	89 55 88             	mov    %edx,-0x78(%ebp)
c010357e:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103581:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103584:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103587:	89 10                	mov    %edx,(%eax)
c0103589:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010358c:	8b 10                	mov    (%eax),%edx
c010358e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103591:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103594:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103597:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010359a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010359d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01035a0:	8b 55 88             	mov    -0x78(%ebp),%edx
c01035a3:	89 10                	mov    %edx,(%eax)
}
c01035a5:	c9                   	leave  
c01035a6:	c3                   	ret    

c01035a7 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01035a7:	55                   	push   %ebp
c01035a8:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01035aa:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
}
c01035af:	5d                   	pop    %ebp
c01035b0:	c3                   	ret    

c01035b1 <basic_check>:

static void
basic_check(void) {
c01035b1:	55                   	push   %ebp
c01035b2:	89 e5                	mov    %esp,%ebp
c01035b4:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01035b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01035ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035d1:	e8 ca 0e 00 00       	call   c01044a0 <alloc_pages>
c01035d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01035d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01035dd:	75 24                	jne    c0103603 <basic_check+0x52>
c01035df:	c7 44 24 0c d9 8f 10 	movl   $0xc0108fd9,0xc(%esp)
c01035e6:	c0 
c01035e7:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01035ee:	c0 
c01035ef:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c01035f6:	00 
c01035f7:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01035fe:	e8 18 d6 ff ff       	call   c0100c1b <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103603:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010360a:	e8 91 0e 00 00       	call   c01044a0 <alloc_pages>
c010360f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103616:	75 24                	jne    c010363c <basic_check+0x8b>
c0103618:	c7 44 24 0c f5 8f 10 	movl   $0xc0108ff5,0xc(%esp)
c010361f:	c0 
c0103620:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103627:	c0 
c0103628:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010362f:	00 
c0103630:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103637:	e8 df d5 ff ff       	call   c0100c1b <__panic>
    assert((p2 = alloc_page()) != NULL);
c010363c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103643:	e8 58 0e 00 00       	call   c01044a0 <alloc_pages>
c0103648:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010364b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010364f:	75 24                	jne    c0103675 <basic_check+0xc4>
c0103651:	c7 44 24 0c 11 90 10 	movl   $0xc0109011,0xc(%esp)
c0103658:	c0 
c0103659:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103660:	c0 
c0103661:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0103668:	00 
c0103669:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103670:	e8 a6 d5 ff ff       	call   c0100c1b <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103675:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103678:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010367b:	74 10                	je     c010368d <basic_check+0xdc>
c010367d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103680:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103683:	74 08                	je     c010368d <basic_check+0xdc>
c0103685:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103688:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010368b:	75 24                	jne    c01036b1 <basic_check+0x100>
c010368d:	c7 44 24 0c 30 90 10 	movl   $0xc0109030,0xc(%esp)
c0103694:	c0 
c0103695:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010369c:	c0 
c010369d:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c01036a4:	00 
c01036a5:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01036ac:	e8 6a d5 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01036b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036b4:	89 04 24             	mov    %eax,(%esp)
c01036b7:	e8 54 f9 ff ff       	call   c0103010 <page_ref>
c01036bc:	85 c0                	test   %eax,%eax
c01036be:	75 1e                	jne    c01036de <basic_check+0x12d>
c01036c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036c3:	89 04 24             	mov    %eax,(%esp)
c01036c6:	e8 45 f9 ff ff       	call   c0103010 <page_ref>
c01036cb:	85 c0                	test   %eax,%eax
c01036cd:	75 0f                	jne    c01036de <basic_check+0x12d>
c01036cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d2:	89 04 24             	mov    %eax,(%esp)
c01036d5:	e8 36 f9 ff ff       	call   c0103010 <page_ref>
c01036da:	85 c0                	test   %eax,%eax
c01036dc:	74 24                	je     c0103702 <basic_check+0x151>
c01036de:	c7 44 24 0c 54 90 10 	movl   $0xc0109054,0xc(%esp)
c01036e5:	c0 
c01036e6:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01036ed:	c0 
c01036ee:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01036f5:	00 
c01036f6:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01036fd:	e8 19 d5 ff ff       	call   c0100c1b <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103702:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103705:	89 04 24             	mov    %eax,(%esp)
c0103708:	e8 ed f8 ff ff       	call   c0102ffa <page2pa>
c010370d:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c0103713:	c1 e2 0c             	shl    $0xc,%edx
c0103716:	39 d0                	cmp    %edx,%eax
c0103718:	72 24                	jb     c010373e <basic_check+0x18d>
c010371a:	c7 44 24 0c 90 90 10 	movl   $0xc0109090,0xc(%esp)
c0103721:	c0 
c0103722:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103729:	c0 
c010372a:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0103731:	00 
c0103732:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103739:	e8 dd d4 ff ff       	call   c0100c1b <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010373e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103741:	89 04 24             	mov    %eax,(%esp)
c0103744:	e8 b1 f8 ff ff       	call   c0102ffa <page2pa>
c0103749:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010374f:	c1 e2 0c             	shl    $0xc,%edx
c0103752:	39 d0                	cmp    %edx,%eax
c0103754:	72 24                	jb     c010377a <basic_check+0x1c9>
c0103756:	c7 44 24 0c ad 90 10 	movl   $0xc01090ad,0xc(%esp)
c010375d:	c0 
c010375e:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103765:	c0 
c0103766:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c010376d:	00 
c010376e:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103775:	e8 a1 d4 ff ff       	call   c0100c1b <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010377a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010377d:	89 04 24             	mov    %eax,(%esp)
c0103780:	e8 75 f8 ff ff       	call   c0102ffa <page2pa>
c0103785:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010378b:	c1 e2 0c             	shl    $0xc,%edx
c010378e:	39 d0                	cmp    %edx,%eax
c0103790:	72 24                	jb     c01037b6 <basic_check+0x205>
c0103792:	c7 44 24 0c ca 90 10 	movl   $0xc01090ca,0xc(%esp)
c0103799:	c0 
c010379a:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01037a1:	c0 
c01037a2:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c01037a9:	00 
c01037aa:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01037b1:	e8 65 d4 ff ff       	call   c0100c1b <__panic>

    list_entry_t free_list_store = free_list;
c01037b6:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c01037bb:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c01037c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01037c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01037c7:	c7 45 e0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01037ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01037d4:	89 50 04             	mov    %edx,0x4(%eax)
c01037d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037da:	8b 50 04             	mov    0x4(%eax),%edx
c01037dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037e0:	89 10                	mov    %edx,(%eax)
c01037e2:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01037e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037ec:	8b 40 04             	mov    0x4(%eax),%eax
c01037ef:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01037f2:	0f 94 c0             	sete   %al
c01037f5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01037f8:	85 c0                	test   %eax,%eax
c01037fa:	75 24                	jne    c0103820 <basic_check+0x26f>
c01037fc:	c7 44 24 0c e7 90 10 	movl   $0xc01090e7,0xc(%esp)
c0103803:	c0 
c0103804:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010380b:	c0 
c010380c:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0103813:	00 
c0103814:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010381b:	e8 fb d3 ff ff       	call   c0100c1b <__panic>

    unsigned int nr_free_store = nr_free;
c0103820:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103825:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103828:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c010382f:	00 00 00 

    assert(alloc_page() == NULL);
c0103832:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103839:	e8 62 0c 00 00       	call   c01044a0 <alloc_pages>
c010383e:	85 c0                	test   %eax,%eax
c0103840:	74 24                	je     c0103866 <basic_check+0x2b5>
c0103842:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c0103849:	c0 
c010384a:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103851:	c0 
c0103852:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103859:	00 
c010385a:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103861:	e8 b5 d3 ff ff       	call   c0100c1b <__panic>

    free_page(p0);
c0103866:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010386d:	00 
c010386e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103871:	89 04 24             	mov    %eax,(%esp)
c0103874:	e8 92 0c 00 00       	call   c010450b <free_pages>
    free_page(p1);
c0103879:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103880:	00 
c0103881:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103884:	89 04 24             	mov    %eax,(%esp)
c0103887:	e8 7f 0c 00 00       	call   c010450b <free_pages>
    free_page(p2);
c010388c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103893:	00 
c0103894:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103897:	89 04 24             	mov    %eax,(%esp)
c010389a:	e8 6c 0c 00 00       	call   c010450b <free_pages>
    assert(nr_free == 3);
c010389f:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01038a4:	83 f8 03             	cmp    $0x3,%eax
c01038a7:	74 24                	je     c01038cd <basic_check+0x31c>
c01038a9:	c7 44 24 0c 13 91 10 	movl   $0xc0109113,0xc(%esp)
c01038b0:	c0 
c01038b1:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01038b8:	c0 
c01038b9:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01038c0:	00 
c01038c1:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01038c8:	e8 4e d3 ff ff       	call   c0100c1b <__panic>

    assert((p0 = alloc_page()) != NULL);
c01038cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d4:	e8 c7 0b 00 00       	call   c01044a0 <alloc_pages>
c01038d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01038e0:	75 24                	jne    c0103906 <basic_check+0x355>
c01038e2:	c7 44 24 0c d9 8f 10 	movl   $0xc0108fd9,0xc(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01038f9:	00 
c01038fa:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103901:	e8 15 d3 ff ff       	call   c0100c1b <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103906:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010390d:	e8 8e 0b 00 00       	call   c01044a0 <alloc_pages>
c0103912:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103915:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103919:	75 24                	jne    c010393f <basic_check+0x38e>
c010391b:	c7 44 24 0c f5 8f 10 	movl   $0xc0108ff5,0xc(%esp)
c0103922:	c0 
c0103923:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010392a:	c0 
c010392b:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103932:	00 
c0103933:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010393a:	e8 dc d2 ff ff       	call   c0100c1b <__panic>
    assert((p2 = alloc_page()) != NULL);
c010393f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103946:	e8 55 0b 00 00       	call   c01044a0 <alloc_pages>
c010394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010394e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103952:	75 24                	jne    c0103978 <basic_check+0x3c7>
c0103954:	c7 44 24 0c 11 90 10 	movl   $0xc0109011,0xc(%esp)
c010395b:	c0 
c010395c:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103963:	c0 
c0103964:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c010396b:	00 
c010396c:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103973:	e8 a3 d2 ff ff       	call   c0100c1b <__panic>

    assert(alloc_page() == NULL);
c0103978:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010397f:	e8 1c 0b 00 00       	call   c01044a0 <alloc_pages>
c0103984:	85 c0                	test   %eax,%eax
c0103986:	74 24                	je     c01039ac <basic_check+0x3fb>
c0103988:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c010398f:	c0 
c0103990:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103997:	c0 
c0103998:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c010399f:	00 
c01039a0:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01039a7:	e8 6f d2 ff ff       	call   c0100c1b <__panic>

    free_page(p0);
c01039ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039b3:	00 
c01039b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039b7:	89 04 24             	mov    %eax,(%esp)
c01039ba:	e8 4c 0b 00 00       	call   c010450b <free_pages>
c01039bf:	c7 45 d8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x28(%ebp)
c01039c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01039c9:	8b 40 04             	mov    0x4(%eax),%eax
c01039cc:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01039cf:	0f 94 c0             	sete   %al
c01039d2:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01039d5:	85 c0                	test   %eax,%eax
c01039d7:	74 24                	je     c01039fd <basic_check+0x44c>
c01039d9:	c7 44 24 0c 20 91 10 	movl   $0xc0109120,0xc(%esp)
c01039e0:	c0 
c01039e1:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01039e8:	c0 
c01039e9:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01039f0:	00 
c01039f1:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c01039f8:	e8 1e d2 ff ff       	call   c0100c1b <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01039fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a04:	e8 97 0a 00 00       	call   c01044a0 <alloc_pages>
c0103a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a0f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103a12:	74 24                	je     c0103a38 <basic_check+0x487>
c0103a14:	c7 44 24 0c 38 91 10 	movl   $0xc0109138,0xc(%esp)
c0103a1b:	c0 
c0103a1c:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103a23:	c0 
c0103a24:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103a2b:	00 
c0103a2c:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103a33:	e8 e3 d1 ff ff       	call   c0100c1b <__panic>
    assert(alloc_page() == NULL);
c0103a38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a3f:	e8 5c 0a 00 00       	call   c01044a0 <alloc_pages>
c0103a44:	85 c0                	test   %eax,%eax
c0103a46:	74 24                	je     c0103a6c <basic_check+0x4bb>
c0103a48:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c0103a4f:	c0 
c0103a50:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103a57:	c0 
c0103a58:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103a5f:	00 
c0103a60:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103a67:	e8 af d1 ff ff       	call   c0100c1b <__panic>

    assert(nr_free == 0);
c0103a6c:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103a71:	85 c0                	test   %eax,%eax
c0103a73:	74 24                	je     c0103a99 <basic_check+0x4e8>
c0103a75:	c7 44 24 0c 51 91 10 	movl   $0xc0109151,0xc(%esp)
c0103a7c:	c0 
c0103a7d:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103a84:	c0 
c0103a85:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103a8c:	00 
c0103a8d:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103a94:	e8 82 d1 ff ff       	call   c0100c1b <__panic>
    free_list = free_list_store;
c0103a99:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103a9c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103a9f:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0103aa4:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    nr_free = nr_free_store;
c0103aaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103aad:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_page(p);
c0103ab2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ab9:	00 
c0103aba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103abd:	89 04 24             	mov    %eax,(%esp)
c0103ac0:	e8 46 0a 00 00       	call   c010450b <free_pages>
    free_page(p1);
c0103ac5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103acc:	00 
c0103acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ad0:	89 04 24             	mov    %eax,(%esp)
c0103ad3:	e8 33 0a 00 00       	call   c010450b <free_pages>
    free_page(p2);
c0103ad8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103adf:	00 
c0103ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae3:	89 04 24             	mov    %eax,(%esp)
c0103ae6:	e8 20 0a 00 00       	call   c010450b <free_pages>
}
c0103aeb:	c9                   	leave  
c0103aec:	c3                   	ret    

c0103aed <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103aed:	55                   	push   %ebp
c0103aee:	89 e5                	mov    %esp,%ebp
c0103af0:	53                   	push   %ebx
c0103af1:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103afe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103b05:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103b0c:	eb 6b                	jmp    c0103b79 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b11:	83 e8 0c             	sub    $0xc,%eax
c0103b14:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b1a:	83 c0 04             	add    $0x4,%eax
c0103b1d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103b24:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103b27:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103b2a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103b2d:	0f a3 10             	bt     %edx,(%eax)
c0103b30:	19 c0                	sbb    %eax,%eax
c0103b32:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103b35:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103b39:	0f 95 c0             	setne  %al
c0103b3c:	0f b6 c0             	movzbl %al,%eax
c0103b3f:	85 c0                	test   %eax,%eax
c0103b41:	75 24                	jne    c0103b67 <default_check+0x7a>
c0103b43:	c7 44 24 0c 5e 91 10 	movl   $0xc010915e,0xc(%esp)
c0103b4a:	c0 
c0103b4b:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103b52:	c0 
c0103b53:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103b5a:	00 
c0103b5b:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103b62:	e8 b4 d0 ff ff       	call   c0100c1b <__panic>
        count ++, total += p->property;
c0103b67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103b6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103b6e:	8b 50 08             	mov    0x8(%eax),%edx
c0103b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b74:	01 d0                	add    %edx,%eax
c0103b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103b7f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103b82:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103b85:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b88:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c0103b8f:	0f 85 79 ff ff ff    	jne    c0103b0e <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103b95:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103b98:	e8 a0 09 00 00       	call   c010453d <nr_free_pages>
c0103b9d:	39 c3                	cmp    %eax,%ebx
c0103b9f:	74 24                	je     c0103bc5 <default_check+0xd8>
c0103ba1:	c7 44 24 0c 6e 91 10 	movl   $0xc010916e,0xc(%esp)
c0103ba8:	c0 
c0103ba9:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103bb0:	c0 
c0103bb1:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103bb8:	00 
c0103bb9:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103bc0:	e8 56 d0 ff ff       	call   c0100c1b <__panic>

    basic_check();
c0103bc5:	e8 e7 f9 ff ff       	call   c01035b1 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103bca:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103bd1:	e8 ca 08 00 00       	call   c01044a0 <alloc_pages>
c0103bd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103bd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103bdd:	75 24                	jne    c0103c03 <default_check+0x116>
c0103bdf:	c7 44 24 0c 87 91 10 	movl   $0xc0109187,0xc(%esp)
c0103be6:	c0 
c0103be7:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103bee:	c0 
c0103bef:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103bf6:	00 
c0103bf7:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103bfe:	e8 18 d0 ff ff       	call   c0100c1b <__panic>
    assert(!PageProperty(p0));
c0103c03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c06:	83 c0 04             	add    $0x4,%eax
c0103c09:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103c10:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103c13:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103c16:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103c19:	0f a3 10             	bt     %edx,(%eax)
c0103c1c:	19 c0                	sbb    %eax,%eax
c0103c1e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103c21:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103c25:	0f 95 c0             	setne  %al
c0103c28:	0f b6 c0             	movzbl %al,%eax
c0103c2b:	85 c0                	test   %eax,%eax
c0103c2d:	74 24                	je     c0103c53 <default_check+0x166>
c0103c2f:	c7 44 24 0c 92 91 10 	movl   $0xc0109192,0xc(%esp)
c0103c36:	c0 
c0103c37:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103c3e:	c0 
c0103c3f:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103c46:	00 
c0103c47:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103c4e:	e8 c8 cf ff ff       	call   c0100c1b <__panic>

    list_entry_t free_list_store = free_list;
c0103c53:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0103c58:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0103c5e:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103c61:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103c64:	c7 45 b4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103c6b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103c6e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103c71:	89 50 04             	mov    %edx,0x4(%eax)
c0103c74:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103c77:	8b 50 04             	mov    0x4(%eax),%edx
c0103c7a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103c7d:	89 10                	mov    %edx,(%eax)
c0103c7f:	c7 45 b0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103c86:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103c89:	8b 40 04             	mov    0x4(%eax),%eax
c0103c8c:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103c8f:	0f 94 c0             	sete   %al
c0103c92:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103c95:	85 c0                	test   %eax,%eax
c0103c97:	75 24                	jne    c0103cbd <default_check+0x1d0>
c0103c99:	c7 44 24 0c e7 90 10 	movl   $0xc01090e7,0xc(%esp)
c0103ca0:	c0 
c0103ca1:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103ca8:	c0 
c0103ca9:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103cb0:	00 
c0103cb1:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103cb8:	e8 5e cf ff ff       	call   c0100c1b <__panic>
    assert(alloc_page() == NULL);
c0103cbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cc4:	e8 d7 07 00 00       	call   c01044a0 <alloc_pages>
c0103cc9:	85 c0                	test   %eax,%eax
c0103ccb:	74 24                	je     c0103cf1 <default_check+0x204>
c0103ccd:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c0103cd4:	c0 
c0103cd5:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103cdc:	c0 
c0103cdd:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103ce4:	00 
c0103ce5:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103cec:	e8 2a cf ff ff       	call   c0100c1b <__panic>

    unsigned int nr_free_store = nr_free;
c0103cf1:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103cf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103cf9:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103d00:	00 00 00 

    free_pages(p0 + 2, 3);
c0103d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d06:	83 c0 40             	add    $0x40,%eax
c0103d09:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103d10:	00 
c0103d11:	89 04 24             	mov    %eax,(%esp)
c0103d14:	e8 f2 07 00 00       	call   c010450b <free_pages>
    assert(alloc_pages(4) == NULL);
c0103d19:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103d20:	e8 7b 07 00 00       	call   c01044a0 <alloc_pages>
c0103d25:	85 c0                	test   %eax,%eax
c0103d27:	74 24                	je     c0103d4d <default_check+0x260>
c0103d29:	c7 44 24 0c a4 91 10 	movl   $0xc01091a4,0xc(%esp)
c0103d30:	c0 
c0103d31:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103d38:	c0 
c0103d39:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103d40:	00 
c0103d41:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103d48:	e8 ce ce ff ff       	call   c0100c1b <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d50:	83 c0 40             	add    $0x40,%eax
c0103d53:	83 c0 04             	add    $0x4,%eax
c0103d56:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103d5d:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d60:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103d63:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103d66:	0f a3 10             	bt     %edx,(%eax)
c0103d69:	19 c0                	sbb    %eax,%eax
c0103d6b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103d6e:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103d72:	0f 95 c0             	setne  %al
c0103d75:	0f b6 c0             	movzbl %al,%eax
c0103d78:	85 c0                	test   %eax,%eax
c0103d7a:	74 0e                	je     c0103d8a <default_check+0x29d>
c0103d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d7f:	83 c0 40             	add    $0x40,%eax
c0103d82:	8b 40 08             	mov    0x8(%eax),%eax
c0103d85:	83 f8 03             	cmp    $0x3,%eax
c0103d88:	74 24                	je     c0103dae <default_check+0x2c1>
c0103d8a:	c7 44 24 0c bc 91 10 	movl   $0xc01091bc,0xc(%esp)
c0103d91:	c0 
c0103d92:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103d99:	c0 
c0103d9a:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103da1:	00 
c0103da2:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103da9:	e8 6d ce ff ff       	call   c0100c1b <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103dae:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103db5:	e8 e6 06 00 00       	call   c01044a0 <alloc_pages>
c0103dba:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103dbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103dc1:	75 24                	jne    c0103de7 <default_check+0x2fa>
c0103dc3:	c7 44 24 0c e8 91 10 	movl   $0xc01091e8,0xc(%esp)
c0103dca:	c0 
c0103dcb:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103dd2:	c0 
c0103dd3:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103dda:	00 
c0103ddb:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103de2:	e8 34 ce ff ff       	call   c0100c1b <__panic>
    assert(alloc_page() == NULL);
c0103de7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dee:	e8 ad 06 00 00       	call   c01044a0 <alloc_pages>
c0103df3:	85 c0                	test   %eax,%eax
c0103df5:	74 24                	je     c0103e1b <default_check+0x32e>
c0103df7:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c0103dfe:	c0 
c0103dff:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103e06:	c0 
c0103e07:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103e0e:	00 
c0103e0f:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103e16:	e8 00 ce ff ff       	call   c0100c1b <__panic>
    assert(p0 + 2 == p1);
c0103e1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e1e:	83 c0 40             	add    $0x40,%eax
c0103e21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e24:	74 24                	je     c0103e4a <default_check+0x35d>
c0103e26:	c7 44 24 0c 06 92 10 	movl   $0xc0109206,0xc(%esp)
c0103e2d:	c0 
c0103e2e:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103e35:	c0 
c0103e36:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103e3d:	00 
c0103e3e:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103e45:	e8 d1 cd ff ff       	call   c0100c1b <__panic>

    p2 = p0 + 1;
c0103e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e4d:	83 c0 20             	add    $0x20,%eax
c0103e50:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103e53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e5a:	00 
c0103e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e5e:	89 04 24             	mov    %eax,(%esp)
c0103e61:	e8 a5 06 00 00       	call   c010450b <free_pages>
    free_pages(p1, 3);
c0103e66:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103e6d:	00 
c0103e6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103e71:	89 04 24             	mov    %eax,(%esp)
c0103e74:	e8 92 06 00 00       	call   c010450b <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e7c:	83 c0 04             	add    $0x4,%eax
c0103e7f:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103e86:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e89:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103e8c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103e8f:	0f a3 10             	bt     %edx,(%eax)
c0103e92:	19 c0                	sbb    %eax,%eax
c0103e94:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103e97:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103e9b:	0f 95 c0             	setne  %al
c0103e9e:	0f b6 c0             	movzbl %al,%eax
c0103ea1:	85 c0                	test   %eax,%eax
c0103ea3:	74 0b                	je     c0103eb0 <default_check+0x3c3>
c0103ea5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ea8:	8b 40 08             	mov    0x8(%eax),%eax
c0103eab:	83 f8 01             	cmp    $0x1,%eax
c0103eae:	74 24                	je     c0103ed4 <default_check+0x3e7>
c0103eb0:	c7 44 24 0c 14 92 10 	movl   $0xc0109214,0xc(%esp)
c0103eb7:	c0 
c0103eb8:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103ebf:	c0 
c0103ec0:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103ec7:	00 
c0103ec8:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103ecf:	e8 47 cd ff ff       	call   c0100c1b <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103ed4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ed7:	83 c0 04             	add    $0x4,%eax
c0103eda:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103ee1:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ee4:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103ee7:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103eea:	0f a3 10             	bt     %edx,(%eax)
c0103eed:	19 c0                	sbb    %eax,%eax
c0103eef:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103ef2:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103ef6:	0f 95 c0             	setne  %al
c0103ef9:	0f b6 c0             	movzbl %al,%eax
c0103efc:	85 c0                	test   %eax,%eax
c0103efe:	74 0b                	je     c0103f0b <default_check+0x41e>
c0103f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f03:	8b 40 08             	mov    0x8(%eax),%eax
c0103f06:	83 f8 03             	cmp    $0x3,%eax
c0103f09:	74 24                	je     c0103f2f <default_check+0x442>
c0103f0b:	c7 44 24 0c 3c 92 10 	movl   $0xc010923c,0xc(%esp)
c0103f12:	c0 
c0103f13:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103f1a:	c0 
c0103f1b:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103f22:	00 
c0103f23:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103f2a:	e8 ec cc ff ff       	call   c0100c1b <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103f2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f36:	e8 65 05 00 00       	call   c01044a0 <alloc_pages>
c0103f3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f41:	83 e8 20             	sub    $0x20,%eax
c0103f44:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103f47:	74 24                	je     c0103f6d <default_check+0x480>
c0103f49:	c7 44 24 0c 62 92 10 	movl   $0xc0109262,0xc(%esp)
c0103f50:	c0 
c0103f51:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103f60:	00 
c0103f61:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103f68:	e8 ae cc ff ff       	call   c0100c1b <__panic>
    free_page(p0);
c0103f6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f74:	00 
c0103f75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f78:	89 04 24             	mov    %eax,(%esp)
c0103f7b:	e8 8b 05 00 00       	call   c010450b <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103f80:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103f87:	e8 14 05 00 00       	call   c01044a0 <alloc_pages>
c0103f8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f92:	83 c0 20             	add    $0x20,%eax
c0103f95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103f98:	74 24                	je     c0103fbe <default_check+0x4d1>
c0103f9a:	c7 44 24 0c 80 92 10 	movl   $0xc0109280,0xc(%esp)
c0103fa1:	c0 
c0103fa2:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0103fa9:	c0 
c0103faa:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103fb1:	00 
c0103fb2:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0103fb9:	e8 5d cc ff ff       	call   c0100c1b <__panic>

    free_pages(p0, 2);
c0103fbe:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103fc5:	00 
c0103fc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc9:	89 04 24             	mov    %eax,(%esp)
c0103fcc:	e8 3a 05 00 00       	call   c010450b <free_pages>
    free_page(p2);
c0103fd1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fd8:	00 
c0103fd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103fdc:	89 04 24             	mov    %eax,(%esp)
c0103fdf:	e8 27 05 00 00       	call   c010450b <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103fe4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103feb:	e8 b0 04 00 00       	call   c01044a0 <alloc_pages>
c0103ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ff3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ff7:	75 24                	jne    c010401d <default_check+0x530>
c0103ff9:	c7 44 24 0c a0 92 10 	movl   $0xc01092a0,0xc(%esp)
c0104000:	c0 
c0104001:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0104008:	c0 
c0104009:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104010:	00 
c0104011:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0104018:	e8 fe cb ff ff       	call   c0100c1b <__panic>
    assert(alloc_page() == NULL);
c010401d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104024:	e8 77 04 00 00       	call   c01044a0 <alloc_pages>
c0104029:	85 c0                	test   %eax,%eax
c010402b:	74 24                	je     c0104051 <default_check+0x564>
c010402d:	c7 44 24 0c fe 90 10 	movl   $0xc01090fe,0xc(%esp)
c0104034:	c0 
c0104035:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c010403c:	c0 
c010403d:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0104044:	00 
c0104045:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010404c:	e8 ca cb ff ff       	call   c0100c1b <__panic>

    assert(nr_free == 0);
c0104051:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0104056:	85 c0                	test   %eax,%eax
c0104058:	74 24                	je     c010407e <default_check+0x591>
c010405a:	c7 44 24 0c 51 91 10 	movl   $0xc0109151,0xc(%esp)
c0104061:	c0 
c0104062:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0104069:	c0 
c010406a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104071:	00 
c0104072:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0104079:	e8 9d cb ff ff       	call   c0100c1b <__panic>
    nr_free = nr_free_store;
c010407e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104081:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_list = free_list_store;
c0104086:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104089:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010408c:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0104091:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    free_pages(p0, 5);
c0104097:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010409e:	00 
c010409f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a2:	89 04 24             	mov    %eax,(%esp)
c01040a5:	e8 61 04 00 00       	call   c010450b <free_pages>

    le = &free_list;
c01040aa:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01040b1:	eb 1d                	jmp    c01040d0 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01040b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040b6:	83 e8 0c             	sub    $0xc,%eax
c01040b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01040bc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01040c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01040c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01040c6:	8b 40 08             	mov    0x8(%eax),%eax
c01040c9:	29 c2                	sub    %eax,%edx
c01040cb:	89 d0                	mov    %edx,%eax
c01040cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040d3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01040d6:	8b 45 88             	mov    -0x78(%ebp),%eax
c01040d9:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01040dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040df:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c01040e6:	75 cb                	jne    c01040b3 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01040e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040ec:	74 24                	je     c0104112 <default_check+0x625>
c01040ee:	c7 44 24 0c be 92 10 	movl   $0xc01092be,0xc(%esp)
c01040f5:	c0 
c01040f6:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c01040fd:	c0 
c01040fe:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104105:	00 
c0104106:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c010410d:	e8 09 cb ff ff       	call   c0100c1b <__panic>
    assert(total == 0);
c0104112:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104116:	74 24                	je     c010413c <default_check+0x64f>
c0104118:	c7 44 24 0c c9 92 10 	movl   $0xc01092c9,0xc(%esp)
c010411f:	c0 
c0104120:	c7 44 24 08 76 8f 10 	movl   $0xc0108f76,0x8(%esp)
c0104127:	c0 
c0104128:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010412f:	00 
c0104130:	c7 04 24 8b 8f 10 c0 	movl   $0xc0108f8b,(%esp)
c0104137:	e8 df ca ff ff       	call   c0100c1b <__panic>
}
c010413c:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104142:	5b                   	pop    %ebx
c0104143:	5d                   	pop    %ebp
c0104144:	c3                   	ret    

c0104145 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104145:	55                   	push   %ebp
c0104146:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104148:	8b 55 08             	mov    0x8(%ebp),%edx
c010414b:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104150:	29 c2                	sub    %eax,%edx
c0104152:	89 d0                	mov    %edx,%eax
c0104154:	c1 f8 05             	sar    $0x5,%eax
}
c0104157:	5d                   	pop    %ebp
c0104158:	c3                   	ret    

c0104159 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104159:	55                   	push   %ebp
c010415a:	89 e5                	mov    %esp,%ebp
c010415c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010415f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104162:	89 04 24             	mov    %eax,(%esp)
c0104165:	e8 db ff ff ff       	call   c0104145 <page2ppn>
c010416a:	c1 e0 0c             	shl    $0xc,%eax
}
c010416d:	c9                   	leave  
c010416e:	c3                   	ret    

c010416f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010416f:	55                   	push   %ebp
c0104170:	89 e5                	mov    %esp,%ebp
c0104172:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104175:	8b 45 08             	mov    0x8(%ebp),%eax
c0104178:	c1 e8 0c             	shr    $0xc,%eax
c010417b:	89 c2                	mov    %eax,%edx
c010417d:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104182:	39 c2                	cmp    %eax,%edx
c0104184:	72 1c                	jb     c01041a2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104186:	c7 44 24 08 04 93 10 	movl   $0xc0109304,0x8(%esp)
c010418d:	c0 
c010418e:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104195:	00 
c0104196:	c7 04 24 23 93 10 c0 	movl   $0xc0109323,(%esp)
c010419d:	e8 79 ca ff ff       	call   c0100c1b <__panic>
    }
    return &pages[PPN(pa)];
c01041a2:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01041a7:	8b 55 08             	mov    0x8(%ebp),%edx
c01041aa:	c1 ea 0c             	shr    $0xc,%edx
c01041ad:	c1 e2 05             	shl    $0x5,%edx
c01041b0:	01 d0                	add    %edx,%eax
}
c01041b2:	c9                   	leave  
c01041b3:	c3                   	ret    

c01041b4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01041b4:	55                   	push   %ebp
c01041b5:	89 e5                	mov    %esp,%ebp
c01041b7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01041ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01041bd:	89 04 24             	mov    %eax,(%esp)
c01041c0:	e8 94 ff ff ff       	call   c0104159 <page2pa>
c01041c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01041c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041cb:	c1 e8 0c             	shr    $0xc,%eax
c01041ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041d1:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01041d6:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01041d9:	72 23                	jb     c01041fe <page2kva+0x4a>
c01041db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041de:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041e2:	c7 44 24 08 34 93 10 	movl   $0xc0109334,0x8(%esp)
c01041e9:	c0 
c01041ea:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01041f1:	00 
c01041f2:	c7 04 24 23 93 10 c0 	movl   $0xc0109323,(%esp)
c01041f9:	e8 1d ca ff ff       	call   c0100c1b <__panic>
c01041fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104201:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104206:	c9                   	leave  
c0104207:	c3                   	ret    

c0104208 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104208:	55                   	push   %ebp
c0104209:	89 e5                	mov    %esp,%ebp
c010420b:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010420e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104211:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104214:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010421b:	77 23                	ja     c0104240 <kva2page+0x38>
c010421d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104220:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104224:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c010422b:	c0 
c010422c:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0104233:	00 
c0104234:	c7 04 24 23 93 10 c0 	movl   $0xc0109323,(%esp)
c010423b:	e8 db c9 ff ff       	call   c0100c1b <__panic>
c0104240:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104243:	05 00 00 00 40       	add    $0x40000000,%eax
c0104248:	89 04 24             	mov    %eax,(%esp)
c010424b:	e8 1f ff ff ff       	call   c010416f <pa2page>
}
c0104250:	c9                   	leave  
c0104251:	c3                   	ret    

c0104252 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0104252:	55                   	push   %ebp
c0104253:	89 e5                	mov    %esp,%ebp
c0104255:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104258:	8b 45 08             	mov    0x8(%ebp),%eax
c010425b:	83 e0 01             	and    $0x1,%eax
c010425e:	85 c0                	test   %eax,%eax
c0104260:	75 1c                	jne    c010427e <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104262:	c7 44 24 08 7c 93 10 	movl   $0xc010937c,0x8(%esp)
c0104269:	c0 
c010426a:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104271:	00 
c0104272:	c7 04 24 23 93 10 c0 	movl   $0xc0109323,(%esp)
c0104279:	e8 9d c9 ff ff       	call   c0100c1b <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010427e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104281:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104286:	89 04 24             	mov    %eax,(%esp)
c0104289:	e8 e1 fe ff ff       	call   c010416f <pa2page>
}
c010428e:	c9                   	leave  
c010428f:	c3                   	ret    

c0104290 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104290:	55                   	push   %ebp
c0104291:	89 e5                	mov    %esp,%ebp
c0104293:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104296:	8b 45 08             	mov    0x8(%ebp),%eax
c0104299:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010429e:	89 04 24             	mov    %eax,(%esp)
c01042a1:	e8 c9 fe ff ff       	call   c010416f <pa2page>
}
c01042a6:	c9                   	leave  
c01042a7:	c3                   	ret    

c01042a8 <page_ref>:

static inline int
page_ref(struct Page *page) {
c01042a8:	55                   	push   %ebp
c01042a9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01042ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ae:	8b 00                	mov    (%eax),%eax
}
c01042b0:	5d                   	pop    %ebp
c01042b1:	c3                   	ret    

c01042b2 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c01042b2:	55                   	push   %ebp
c01042b3:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01042b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b8:	8b 00                	mov    (%eax),%eax
c01042ba:	8d 50 01             	lea    0x1(%eax),%edx
c01042bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01042c0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01042c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01042c5:	8b 00                	mov    (%eax),%eax
}
c01042c7:	5d                   	pop    %ebp
c01042c8:	c3                   	ret    

c01042c9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01042c9:	55                   	push   %ebp
c01042ca:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01042cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01042cf:	8b 00                	mov    (%eax),%eax
c01042d1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01042d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01042d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01042dc:	8b 00                	mov    (%eax),%eax
}
c01042de:	5d                   	pop    %ebp
c01042df:	c3                   	ret    

c01042e0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01042e0:	55                   	push   %ebp
c01042e1:	89 e5                	mov    %esp,%ebp
c01042e3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01042e6:	9c                   	pushf  
c01042e7:	58                   	pop    %eax
c01042e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01042ee:	25 00 02 00 00       	and    $0x200,%eax
c01042f3:	85 c0                	test   %eax,%eax
c01042f5:	74 0c                	je     c0104303 <__intr_save+0x23>
        intr_disable();
c01042f7:	e8 77 db ff ff       	call   c0101e73 <intr_disable>
        return 1;
c01042fc:	b8 01 00 00 00       	mov    $0x1,%eax
c0104301:	eb 05                	jmp    c0104308 <__intr_save+0x28>
    }
    return 0;
c0104303:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104308:	c9                   	leave  
c0104309:	c3                   	ret    

c010430a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010430a:	55                   	push   %ebp
c010430b:	89 e5                	mov    %esp,%ebp
c010430d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104314:	74 05                	je     c010431b <__intr_restore+0x11>
        intr_enable();
c0104316:	e8 52 db ff ff       	call   c0101e6d <intr_enable>
    }
}
c010431b:	c9                   	leave  
c010431c:	c3                   	ret    

c010431d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010431d:	55                   	push   %ebp
c010431e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104320:	8b 45 08             	mov    0x8(%ebp),%eax
c0104323:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104326:	b8 23 00 00 00       	mov    $0x23,%eax
c010432b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c010432d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104332:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104334:	b8 10 00 00 00       	mov    $0x10,%eax
c0104339:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c010433b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104340:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104342:	b8 10 00 00 00       	mov    $0x10,%eax
c0104347:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104349:	ea 50 43 10 c0 08 00 	ljmp   $0x8,$0xc0104350
}
c0104350:	5d                   	pop    %ebp
c0104351:	c3                   	ret    

c0104352 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104352:	55                   	push   %ebp
c0104353:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104355:	8b 45 08             	mov    0x8(%ebp),%eax
c0104358:	a3 44 0a 12 c0       	mov    %eax,0xc0120a44
}
c010435d:	5d                   	pop    %ebp
c010435e:	c3                   	ret    

c010435f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c010435f:	55                   	push   %ebp
c0104360:	89 e5                	mov    %esp,%ebp
c0104362:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104365:	b8 00 f0 11 c0       	mov    $0xc011f000,%eax
c010436a:	89 04 24             	mov    %eax,(%esp)
c010436d:	e8 e0 ff ff ff       	call   c0104352 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104372:	66 c7 05 48 0a 12 c0 	movw   $0x10,0xc0120a48
c0104379:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010437b:	66 c7 05 28 fa 11 c0 	movw   $0x68,0xc011fa28
c0104382:	68 00 
c0104384:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c0104389:	66 a3 2a fa 11 c0    	mov    %ax,0xc011fa2a
c010438f:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c0104394:	c1 e8 10             	shr    $0x10,%eax
c0104397:	a2 2c fa 11 c0       	mov    %al,0xc011fa2c
c010439c:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01043a3:	83 e0 f0             	and    $0xfffffff0,%eax
c01043a6:	83 c8 09             	or     $0x9,%eax
c01043a9:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01043ae:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01043b5:	83 e0 ef             	and    $0xffffffef,%eax
c01043b8:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01043bd:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01043c4:	83 e0 9f             	and    $0xffffff9f,%eax
c01043c7:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01043cc:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01043d3:	83 c8 80             	or     $0xffffff80,%eax
c01043d6:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01043db:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c01043e2:	83 e0 f0             	and    $0xfffffff0,%eax
c01043e5:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c01043ea:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c01043f1:	83 e0 ef             	and    $0xffffffef,%eax
c01043f4:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c01043f9:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104400:	83 e0 df             	and    $0xffffffdf,%eax
c0104403:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104408:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c010440f:	83 c8 40             	or     $0x40,%eax
c0104412:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104417:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c010441e:	83 e0 7f             	and    $0x7f,%eax
c0104421:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104426:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c010442b:	c1 e8 18             	shr    $0x18,%eax
c010442e:	a2 2f fa 11 c0       	mov    %al,0xc011fa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104433:	c7 04 24 30 fa 11 c0 	movl   $0xc011fa30,(%esp)
c010443a:	e8 de fe ff ff       	call   c010431d <lgdt>
c010443f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104445:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104449:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c010444c:	c9                   	leave  
c010444d:	c3                   	ret    

c010444e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010444e:	55                   	push   %ebp
c010444f:	89 e5                	mov    %esp,%ebp
c0104451:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104454:	c7 05 cc 0a 12 c0 e8 	movl   $0xc01092e8,0xc0120acc
c010445b:	92 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010445e:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104463:	8b 00                	mov    (%eax),%eax
c0104465:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104469:	c7 04 24 a8 93 10 c0 	movl   $0xc01093a8,(%esp)
c0104470:	e8 d6 be ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c0104475:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010447a:	8b 40 04             	mov    0x4(%eax),%eax
c010447d:	ff d0                	call   *%eax
}
c010447f:	c9                   	leave  
c0104480:	c3                   	ret    

c0104481 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104481:	55                   	push   %ebp
c0104482:	89 e5                	mov    %esp,%ebp
c0104484:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104487:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010448c:	8b 40 08             	mov    0x8(%eax),%eax
c010448f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104492:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104496:	8b 55 08             	mov    0x8(%ebp),%edx
c0104499:	89 14 24             	mov    %edx,(%esp)
c010449c:	ff d0                	call   *%eax
}
c010449e:	c9                   	leave  
c010449f:	c3                   	ret    

c01044a0 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01044a0:	55                   	push   %ebp
c01044a1:	89 e5                	mov    %esp,%ebp
c01044a3:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01044a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01044ad:	e8 2e fe ff ff       	call   c01042e0 <__intr_save>
c01044b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01044b5:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01044ba:	8b 40 0c             	mov    0xc(%eax),%eax
c01044bd:	8b 55 08             	mov    0x8(%ebp),%edx
c01044c0:	89 14 24             	mov    %edx,(%esp)
c01044c3:	ff d0                	call   *%eax
c01044c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01044c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044cb:	89 04 24             	mov    %eax,(%esp)
c01044ce:	e8 37 fe ff ff       	call   c010430a <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01044d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d7:	75 2d                	jne    c0104506 <alloc_pages+0x66>
c01044d9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01044dd:	77 27                	ja     c0104506 <alloc_pages+0x66>
c01044df:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c01044e4:	85 c0                	test   %eax,%eax
c01044e6:	74 1e                	je     c0104506 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01044e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01044eb:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01044f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044f7:	00 
c01044f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044fc:	89 04 24             	mov    %eax,(%esp)
c01044ff:	e8 03 19 00 00       	call   c0105e07 <swap_out>
    }
c0104504:	eb a7                	jmp    c01044ad <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104506:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104509:	c9                   	leave  
c010450a:	c3                   	ret    

c010450b <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010450b:	55                   	push   %ebp
c010450c:	89 e5                	mov    %esp,%ebp
c010450e:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104511:	e8 ca fd ff ff       	call   c01042e0 <__intr_save>
c0104516:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104519:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010451e:	8b 40 10             	mov    0x10(%eax),%eax
c0104521:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104524:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104528:	8b 55 08             	mov    0x8(%ebp),%edx
c010452b:	89 14 24             	mov    %edx,(%esp)
c010452e:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104530:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104533:	89 04 24             	mov    %eax,(%esp)
c0104536:	e8 cf fd ff ff       	call   c010430a <__intr_restore>
}
c010453b:	c9                   	leave  
c010453c:	c3                   	ret    

c010453d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010453d:	55                   	push   %ebp
c010453e:	89 e5                	mov    %esp,%ebp
c0104540:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104543:	e8 98 fd ff ff       	call   c01042e0 <__intr_save>
c0104548:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010454b:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104550:	8b 40 14             	mov    0x14(%eax),%eax
c0104553:	ff d0                	call   *%eax
c0104555:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104558:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010455b:	89 04 24             	mov    %eax,(%esp)
c010455e:	e8 a7 fd ff ff       	call   c010430a <__intr_restore>
    return ret;
c0104563:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104566:	c9                   	leave  
c0104567:	c3                   	ret    

c0104568 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104568:	55                   	push   %ebp
c0104569:	89 e5                	mov    %esp,%ebp
c010456b:	57                   	push   %edi
c010456c:	56                   	push   %esi
c010456d:	53                   	push   %ebx
c010456e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104574:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010457b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104582:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104589:	c7 04 24 bf 93 10 c0 	movl   $0xc01093bf,(%esp)
c0104590:	e8 b6 bd ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104595:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010459c:	e9 15 01 00 00       	jmp    c01046b6 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01045a1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01045a4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045a7:	89 d0                	mov    %edx,%eax
c01045a9:	c1 e0 02             	shl    $0x2,%eax
c01045ac:	01 d0                	add    %edx,%eax
c01045ae:	c1 e0 02             	shl    $0x2,%eax
c01045b1:	01 c8                	add    %ecx,%eax
c01045b3:	8b 50 08             	mov    0x8(%eax),%edx
c01045b6:	8b 40 04             	mov    0x4(%eax),%eax
c01045b9:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01045bc:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01045bf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01045c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045c5:	89 d0                	mov    %edx,%eax
c01045c7:	c1 e0 02             	shl    $0x2,%eax
c01045ca:	01 d0                	add    %edx,%eax
c01045cc:	c1 e0 02             	shl    $0x2,%eax
c01045cf:	01 c8                	add    %ecx,%eax
c01045d1:	8b 48 0c             	mov    0xc(%eax),%ecx
c01045d4:	8b 58 10             	mov    0x10(%eax),%ebx
c01045d7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01045da:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01045dd:	01 c8                	add    %ecx,%eax
c01045df:	11 da                	adc    %ebx,%edx
c01045e1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01045e4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01045e7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01045ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01045ed:	89 d0                	mov    %edx,%eax
c01045ef:	c1 e0 02             	shl    $0x2,%eax
c01045f2:	01 d0                	add    %edx,%eax
c01045f4:	c1 e0 02             	shl    $0x2,%eax
c01045f7:	01 c8                	add    %ecx,%eax
c01045f9:	83 c0 14             	add    $0x14,%eax
c01045fc:	8b 00                	mov    (%eax),%eax
c01045fe:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104604:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104607:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010460a:	83 c0 ff             	add    $0xffffffff,%eax
c010460d:	83 d2 ff             	adc    $0xffffffff,%edx
c0104610:	89 c6                	mov    %eax,%esi
c0104612:	89 d7                	mov    %edx,%edi
c0104614:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104617:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010461a:	89 d0                	mov    %edx,%eax
c010461c:	c1 e0 02             	shl    $0x2,%eax
c010461f:	01 d0                	add    %edx,%eax
c0104621:	c1 e0 02             	shl    $0x2,%eax
c0104624:	01 c8                	add    %ecx,%eax
c0104626:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104629:	8b 58 10             	mov    0x10(%eax),%ebx
c010462c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104632:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104636:	89 74 24 14          	mov    %esi,0x14(%esp)
c010463a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010463e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104641:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104644:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104648:	89 54 24 10          	mov    %edx,0x10(%esp)
c010464c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104650:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104654:	c7 04 24 cc 93 10 c0 	movl   $0xc01093cc,(%esp)
c010465b:	e8 eb bc ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104660:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104663:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104666:	89 d0                	mov    %edx,%eax
c0104668:	c1 e0 02             	shl    $0x2,%eax
c010466b:	01 d0                	add    %edx,%eax
c010466d:	c1 e0 02             	shl    $0x2,%eax
c0104670:	01 c8                	add    %ecx,%eax
c0104672:	83 c0 14             	add    $0x14,%eax
c0104675:	8b 00                	mov    (%eax),%eax
c0104677:	83 f8 01             	cmp    $0x1,%eax
c010467a:	75 36                	jne    c01046b2 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010467c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010467f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104682:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104685:	77 2b                	ja     c01046b2 <page_init+0x14a>
c0104687:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010468a:	72 05                	jb     c0104691 <page_init+0x129>
c010468c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010468f:	73 21                	jae    c01046b2 <page_init+0x14a>
c0104691:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104695:	77 1b                	ja     c01046b2 <page_init+0x14a>
c0104697:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010469b:	72 09                	jb     c01046a6 <page_init+0x13e>
c010469d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01046a4:	77 0c                	ja     c01046b2 <page_init+0x14a>
                maxpa = end;
c01046a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01046a9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01046ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01046af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01046b2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01046b6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01046b9:	8b 00                	mov    (%eax),%eax
c01046bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01046be:	0f 8f dd fe ff ff    	jg     c01045a1 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01046c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01046c8:	72 1d                	jb     c01046e7 <page_init+0x17f>
c01046ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01046ce:	77 09                	ja     c01046d9 <page_init+0x171>
c01046d0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01046d7:	76 0e                	jbe    c01046e7 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01046d9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01046e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01046e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01046ed:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01046f1:	c1 ea 0c             	shr    $0xc,%edx
c01046f4:	a3 20 0a 12 c0       	mov    %eax,0xc0120a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01046f9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104700:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c0104705:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104708:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010470b:	01 d0                	add    %edx,%eax
c010470d:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104710:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104713:	ba 00 00 00 00       	mov    $0x0,%edx
c0104718:	f7 75 ac             	divl   -0x54(%ebp)
c010471b:	89 d0                	mov    %edx,%eax
c010471d:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104720:	29 c2                	sub    %eax,%edx
c0104722:	89 d0                	mov    %edx,%eax
c0104724:	a3 d4 0a 12 c0       	mov    %eax,0xc0120ad4

    for (i = 0; i < npage; i ++) {
c0104729:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104730:	eb 27                	jmp    c0104759 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104732:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104737:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010473a:	c1 e2 05             	shl    $0x5,%edx
c010473d:	01 d0                	add    %edx,%eax
c010473f:	83 c0 04             	add    $0x4,%eax
c0104742:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104749:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010474c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010474f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104752:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104755:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104759:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010475c:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104761:	39 c2                	cmp    %eax,%edx
c0104763:	72 cd                	jb     c0104732 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104765:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010476a:	c1 e0 05             	shl    $0x5,%eax
c010476d:	89 c2                	mov    %eax,%edx
c010476f:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104774:	01 d0                	add    %edx,%eax
c0104776:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104779:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104780:	77 23                	ja     c01047a5 <page_init+0x23d>
c0104782:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104785:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104789:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c0104790:	c0 
c0104791:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104798:	00 
c0104799:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01047a0:	e8 76 c4 ff ff       	call   c0100c1b <__panic>
c01047a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01047a8:	05 00 00 00 40       	add    $0x40000000,%eax
c01047ad:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01047b0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01047b7:	e9 74 01 00 00       	jmp    c0104930 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01047bc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047c2:	89 d0                	mov    %edx,%eax
c01047c4:	c1 e0 02             	shl    $0x2,%eax
c01047c7:	01 d0                	add    %edx,%eax
c01047c9:	c1 e0 02             	shl    $0x2,%eax
c01047cc:	01 c8                	add    %ecx,%eax
c01047ce:	8b 50 08             	mov    0x8(%eax),%edx
c01047d1:	8b 40 04             	mov    0x4(%eax),%eax
c01047d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01047d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01047da:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047dd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047e0:	89 d0                	mov    %edx,%eax
c01047e2:	c1 e0 02             	shl    $0x2,%eax
c01047e5:	01 d0                	add    %edx,%eax
c01047e7:	c1 e0 02             	shl    $0x2,%eax
c01047ea:	01 c8                	add    %ecx,%eax
c01047ec:	8b 48 0c             	mov    0xc(%eax),%ecx
c01047ef:	8b 58 10             	mov    0x10(%eax),%ebx
c01047f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01047f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01047f8:	01 c8                	add    %ecx,%eax
c01047fa:	11 da                	adc    %ebx,%edx
c01047fc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01047ff:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104802:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104805:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104808:	89 d0                	mov    %edx,%eax
c010480a:	c1 e0 02             	shl    $0x2,%eax
c010480d:	01 d0                	add    %edx,%eax
c010480f:	c1 e0 02             	shl    $0x2,%eax
c0104812:	01 c8                	add    %ecx,%eax
c0104814:	83 c0 14             	add    $0x14,%eax
c0104817:	8b 00                	mov    (%eax),%eax
c0104819:	83 f8 01             	cmp    $0x1,%eax
c010481c:	0f 85 0a 01 00 00    	jne    c010492c <page_init+0x3c4>
            if (begin < freemem) {
c0104822:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104825:	ba 00 00 00 00       	mov    $0x0,%edx
c010482a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010482d:	72 17                	jb     c0104846 <page_init+0x2de>
c010482f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104832:	77 05                	ja     c0104839 <page_init+0x2d1>
c0104834:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104837:	76 0d                	jbe    c0104846 <page_init+0x2de>
                begin = freemem;
c0104839:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010483c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010483f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104846:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010484a:	72 1d                	jb     c0104869 <page_init+0x301>
c010484c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104850:	77 09                	ja     c010485b <page_init+0x2f3>
c0104852:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104859:	76 0e                	jbe    c0104869 <page_init+0x301>
                end = KMEMSIZE;
c010485b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104862:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104869:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010486c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010486f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104872:	0f 87 b4 00 00 00    	ja     c010492c <page_init+0x3c4>
c0104878:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010487b:	72 09                	jb     c0104886 <page_init+0x31e>
c010487d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104880:	0f 83 a6 00 00 00    	jae    c010492c <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0104886:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010488d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104890:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104893:	01 d0                	add    %edx,%eax
c0104895:	83 e8 01             	sub    $0x1,%eax
c0104898:	89 45 98             	mov    %eax,-0x68(%ebp)
c010489b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010489e:	ba 00 00 00 00       	mov    $0x0,%edx
c01048a3:	f7 75 9c             	divl   -0x64(%ebp)
c01048a6:	89 d0                	mov    %edx,%eax
c01048a8:	8b 55 98             	mov    -0x68(%ebp),%edx
c01048ab:	29 c2                	sub    %eax,%edx
c01048ad:	89 d0                	mov    %edx,%eax
c01048af:	ba 00 00 00 00       	mov    $0x0,%edx
c01048b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01048b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01048ba:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01048bd:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01048c0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01048c3:	ba 00 00 00 00       	mov    $0x0,%edx
c01048c8:	89 c7                	mov    %eax,%edi
c01048ca:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01048d0:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01048d3:	89 d0                	mov    %edx,%eax
c01048d5:	83 e0 00             	and    $0x0,%eax
c01048d8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01048db:	8b 45 80             	mov    -0x80(%ebp),%eax
c01048de:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01048e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01048e4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01048e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01048ea:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01048ed:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01048f0:	77 3a                	ja     c010492c <page_init+0x3c4>
c01048f2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01048f5:	72 05                	jb     c01048fc <page_init+0x394>
c01048f7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01048fa:	73 30                	jae    c010492c <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01048fc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01048ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104902:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104905:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104908:	29 c8                	sub    %ecx,%eax
c010490a:	19 da                	sbb    %ebx,%edx
c010490c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104910:	c1 ea 0c             	shr    $0xc,%edx
c0104913:	89 c3                	mov    %eax,%ebx
c0104915:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104918:	89 04 24             	mov    %eax,(%esp)
c010491b:	e8 4f f8 ff ff       	call   c010416f <pa2page>
c0104920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104924:	89 04 24             	mov    %eax,(%esp)
c0104927:	e8 55 fb ff ff       	call   c0104481 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010492c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104930:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104933:	8b 00                	mov    (%eax),%eax
c0104935:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104938:	0f 8f 7e fe ff ff    	jg     c01047bc <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010493e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104944:	5b                   	pop    %ebx
c0104945:	5e                   	pop    %esi
c0104946:	5f                   	pop    %edi
c0104947:	5d                   	pop    %ebp
c0104948:	c3                   	ret    

c0104949 <enable_paging>:

static void
enable_paging(void) {
c0104949:	55                   	push   %ebp
c010494a:	89 e5                	mov    %esp,%ebp
c010494c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010494f:	a1 d0 0a 12 c0       	mov    0xc0120ad0,%eax
c0104954:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104957:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010495a:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010495d:	0f 20 c0             	mov    %cr0,%eax
c0104960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104963:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104966:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104969:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104970:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104974:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104977:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010497a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104980:	c9                   	leave  
c0104981:	c3                   	ret    

c0104982 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104982:	55                   	push   %ebp
c0104983:	89 e5                	mov    %esp,%ebp
c0104985:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104988:	8b 45 14             	mov    0x14(%ebp),%eax
c010498b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010498e:	31 d0                	xor    %edx,%eax
c0104990:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104995:	85 c0                	test   %eax,%eax
c0104997:	74 24                	je     c01049bd <boot_map_segment+0x3b>
c0104999:	c7 44 24 0c 0a 94 10 	movl   $0xc010940a,0xc(%esp)
c01049a0:	c0 
c01049a1:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01049a8:	c0 
c01049a9:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01049b0:	00 
c01049b1:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01049b8:	e8 5e c2 ff ff       	call   c0100c1b <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01049bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01049c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049c7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049cc:	89 c2                	mov    %eax,%edx
c01049ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01049d1:	01 c2                	add    %eax,%edx
c01049d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d6:	01 d0                	add    %edx,%eax
c01049d8:	83 e8 01             	sub    $0x1,%eax
c01049db:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01049de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e1:	ba 00 00 00 00       	mov    $0x0,%edx
c01049e6:	f7 75 f0             	divl   -0x10(%ebp)
c01049e9:	89 d0                	mov    %edx,%eax
c01049eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01049ee:	29 c2                	sub    %eax,%edx
c01049f0:	89 d0                	mov    %edx,%eax
c01049f2:	c1 e8 0c             	shr    $0xc,%eax
c01049f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01049f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01049fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104a01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a06:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104a09:	8b 45 14             	mov    0x14(%ebp),%eax
c0104a0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104a17:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104a1a:	eb 6b                	jmp    c0104a87 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104a1c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104a23:	00 
c0104a24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a27:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a2e:	89 04 24             	mov    %eax,(%esp)
c0104a31:	e8 cc 01 00 00       	call   c0104c02 <get_pte>
c0104a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104a39:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104a3d:	75 24                	jne    c0104a63 <boot_map_segment+0xe1>
c0104a3f:	c7 44 24 0c 36 94 10 	movl   $0xc0109436,0xc(%esp)
c0104a46:	c0 
c0104a47:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104a4e:	c0 
c0104a4f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104a56:	00 
c0104a57:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104a5e:	e8 b8 c1 ff ff       	call   c0100c1b <__panic>
        *ptep = pa | PTE_P | perm;
c0104a63:	8b 45 18             	mov    0x18(%ebp),%eax
c0104a66:	8b 55 14             	mov    0x14(%ebp),%edx
c0104a69:	09 d0                	or     %edx,%eax
c0104a6b:	83 c8 01             	or     $0x1,%eax
c0104a6e:	89 c2                	mov    %eax,%edx
c0104a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a73:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104a75:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104a79:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104a80:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a8b:	75 8f                	jne    c0104a1c <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104a8d:	c9                   	leave  
c0104a8e:	c3                   	ret    

c0104a8f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104a8f:	55                   	push   %ebp
c0104a90:	89 e5                	mov    %esp,%ebp
c0104a92:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104a95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a9c:	e8 ff f9 ff ff       	call   c01044a0 <alloc_pages>
c0104aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104aa8:	75 1c                	jne    c0104ac6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104aaa:	c7 44 24 08 43 94 10 	movl   $0xc0109443,0x8(%esp)
c0104ab1:	c0 
c0104ab2:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104ab9:	00 
c0104aba:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104ac1:	e8 55 c1 ff ff       	call   c0100c1b <__panic>
    }
    return page2kva(p);
c0104ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac9:	89 04 24             	mov    %eax,(%esp)
c0104acc:	e8 e3 f6 ff ff       	call   c01041b4 <page2kva>
}
c0104ad1:	c9                   	leave  
c0104ad2:	c3                   	ret    

c0104ad3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104ad3:	55                   	push   %ebp
c0104ad4:	89 e5                	mov    %esp,%ebp
c0104ad6:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104ad9:	e8 70 f9 ff ff       	call   c010444e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104ade:	e8 85 fa ff ff       	call   c0104568 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104ae3:	e8 a2 03 00 00       	call   c0104e8a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104ae8:	e8 a2 ff ff ff       	call   c0104a8f <boot_alloc_page>
c0104aed:	a3 24 0a 12 c0       	mov    %eax,0xc0120a24
    memset(boot_pgdir, 0, PGSIZE);
c0104af2:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104af7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104afe:	00 
c0104aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b06:	00 
c0104b07:	89 04 24             	mov    %eax,(%esp)
c0104b0a:	e8 80 3a 00 00       	call   c010858f <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104b0f:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b17:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104b1e:	77 23                	ja     c0104b43 <pmm_init+0x70>
c0104b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b27:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c0104b2e:	c0 
c0104b2f:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104b36:	00 
c0104b37:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104b3e:	e8 d8 c0 ff ff       	call   c0100c1b <__panic>
c0104b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b46:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b4b:	a3 d0 0a 12 c0       	mov    %eax,0xc0120ad0

    check_pgdir();
c0104b50:	e8 53 03 00 00       	call   c0104ea8 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104b55:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104b5a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104b60:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b68:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104b6f:	77 23                	ja     c0104b94 <pmm_init+0xc1>
c0104b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b74:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b78:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c0104b7f:	c0 
c0104b80:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104b87:	00 
c0104b88:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104b8f:	e8 87 c0 ff ff       	call   c0100c1b <__panic>
c0104b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b97:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b9c:	83 c8 03             	or     $0x3,%eax
c0104b9f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104ba1:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104ba6:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104bad:	00 
c0104bae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104bb5:	00 
c0104bb6:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104bbd:	38 
c0104bbe:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104bc5:	c0 
c0104bc6:	89 04 24             	mov    %eax,(%esp)
c0104bc9:	e8 b4 fd ff ff       	call   c0104982 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104bce:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104bd3:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0104bd9:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104bdf:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104be1:	e8 63 fd ff ff       	call   c0104949 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104be6:	e8 74 f7 ff ff       	call   c010435f <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104beb:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104bf6:	e8 48 09 00 00       	call   c0105543 <check_boot_pgdir>

    print_pgdir();
c0104bfb:	e8 d0 0d 00 00       	call   c01059d0 <print_pgdir>

}
c0104c00:	c9                   	leave  
c0104c01:	c3                   	ret    

c0104c02 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104c02:	55                   	push   %ebp
c0104c03:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104c05:	5d                   	pop    %ebp
c0104c06:	c3                   	ret    

c0104c07 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104c07:	55                   	push   %ebp
c0104c08:	89 e5                	mov    %esp,%ebp
c0104c0a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104c0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c14:	00 
c0104c15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c1f:	89 04 24             	mov    %eax,(%esp)
c0104c22:	e8 db ff ff ff       	call   c0104c02 <get_pte>
c0104c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104c2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104c2e:	74 08                	je     c0104c38 <get_page+0x31>
        *ptep_store = ptep;
c0104c30:	8b 45 10             	mov    0x10(%ebp),%eax
c0104c33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104c36:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c3c:	74 1b                	je     c0104c59 <get_page+0x52>
c0104c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c41:	8b 00                	mov    (%eax),%eax
c0104c43:	83 e0 01             	and    $0x1,%eax
c0104c46:	85 c0                	test   %eax,%eax
c0104c48:	74 0f                	je     c0104c59 <get_page+0x52>
        return pte2page(*ptep);
c0104c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c4d:	8b 00                	mov    (%eax),%eax
c0104c4f:	89 04 24             	mov    %eax,(%esp)
c0104c52:	e8 fb f5 ff ff       	call   c0104252 <pte2page>
c0104c57:	eb 05                	jmp    c0104c5e <get_page+0x57>
    }
    return NULL;
c0104c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104c5e:	c9                   	leave  
c0104c5f:	c3                   	ret    

c0104c60 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104c60:	55                   	push   %ebp
c0104c61:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104c63:	5d                   	pop    %ebp
c0104c64:	c3                   	ret    

c0104c65 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104c65:	55                   	push   %ebp
c0104c66:	89 e5                	mov    %esp,%ebp
c0104c68:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104c6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c72:	00 
c0104c73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c7d:	89 04 24             	mov    %eax,(%esp)
c0104c80:	e8 7d ff ff ff       	call   c0104c02 <get_pte>
c0104c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104c88:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104c8c:	74 19                	je     c0104ca7 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104c8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104c91:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104c95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9f:	89 04 24             	mov    %eax,(%esp)
c0104ca2:	e8 b9 ff ff ff       	call   c0104c60 <page_remove_pte>
    }
}
c0104ca7:	c9                   	leave  
c0104ca8:	c3                   	ret    

c0104ca9 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104ca9:	55                   	push   %ebp
c0104caa:	89 e5                	mov    %esp,%ebp
c0104cac:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104caf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104cb6:	00 
c0104cb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0104cba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cc1:	89 04 24             	mov    %eax,(%esp)
c0104cc4:	e8 39 ff ff ff       	call   c0104c02 <get_pte>
c0104cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104cd0:	75 0a                	jne    c0104cdc <page_insert+0x33>
        return -E_NO_MEM;
c0104cd2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104cd7:	e9 84 00 00 00       	jmp    c0104d60 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cdf:	89 04 24             	mov    %eax,(%esp)
c0104ce2:	e8 cb f5 ff ff       	call   c01042b2 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cea:	8b 00                	mov    (%eax),%eax
c0104cec:	83 e0 01             	and    $0x1,%eax
c0104cef:	85 c0                	test   %eax,%eax
c0104cf1:	74 3e                	je     c0104d31 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cf6:	8b 00                	mov    (%eax),%eax
c0104cf8:	89 04 24             	mov    %eax,(%esp)
c0104cfb:	e8 52 f5 ff ff       	call   c0104252 <pte2page>
c0104d00:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d06:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104d09:	75 0d                	jne    c0104d18 <page_insert+0x6f>
            page_ref_dec(page);
c0104d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d0e:	89 04 24             	mov    %eax,(%esp)
c0104d11:	e8 b3 f5 ff ff       	call   c01042c9 <page_ref_dec>
c0104d16:	eb 19                	jmp    c0104d31 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d1b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d29:	89 04 24             	mov    %eax,(%esp)
c0104d2c:	e8 2f ff ff ff       	call   c0104c60 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104d31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d34:	89 04 24             	mov    %eax,(%esp)
c0104d37:	e8 1d f4 ff ff       	call   c0104159 <page2pa>
c0104d3c:	0b 45 14             	or     0x14(%ebp),%eax
c0104d3f:	83 c8 01             	or     $0x1,%eax
c0104d42:	89 c2                	mov    %eax,%edx
c0104d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d47:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104d49:	8b 45 10             	mov    0x10(%ebp),%eax
c0104d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d50:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d53:	89 04 24             	mov    %eax,(%esp)
c0104d56:	e8 07 00 00 00       	call   c0104d62 <tlb_invalidate>
    return 0;
c0104d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104d60:	c9                   	leave  
c0104d61:	c3                   	ret    

c0104d62 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104d62:	55                   	push   %ebp
c0104d63:	89 e5                	mov    %esp,%ebp
c0104d65:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104d68:	0f 20 d8             	mov    %cr3,%eax
c0104d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104d71:	89 c2                	mov    %eax,%edx
c0104d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d79:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104d80:	77 23                	ja     c0104da5 <tlb_invalidate+0x43>
c0104d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d85:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d89:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c0104d90:	c0 
c0104d91:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104d98:	00 
c0104d99:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104da0:	e8 76 be ff ff       	call   c0100c1b <__panic>
c0104da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104da8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104dad:	39 c2                	cmp    %eax,%edx
c0104daf:	75 0c                	jne    c0104dbd <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104db1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dba:	0f 01 38             	invlpg (%eax)
    }
}
c0104dbd:	c9                   	leave  
c0104dbe:	c3                   	ret    

c0104dbf <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0104dbf:	55                   	push   %ebp
c0104dc0:	89 e5                	mov    %esp,%ebp
c0104dc2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0104dc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dcc:	e8 cf f6 ff ff       	call   c01044a0 <alloc_pages>
c0104dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0104dd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104dd8:	0f 84 a7 00 00 00    	je     c0104e85 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0104dde:	8b 45 10             	mov    0x10(%ebp),%eax
c0104de1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104de5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104de8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104def:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df6:	89 04 24             	mov    %eax,(%esp)
c0104df9:	e8 ab fe ff ff       	call   c0104ca9 <page_insert>
c0104dfe:	85 c0                	test   %eax,%eax
c0104e00:	74 1a                	je     c0104e1c <pgdir_alloc_page+0x5d>
            free_page(page);
c0104e02:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e09:	00 
c0104e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e0d:	89 04 24             	mov    %eax,(%esp)
c0104e10:	e8 f6 f6 ff ff       	call   c010450b <free_pages>
            return NULL;
c0104e15:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e1a:	eb 6c                	jmp    c0104e88 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0104e1c:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0104e21:	85 c0                	test   %eax,%eax
c0104e23:	74 60                	je     c0104e85 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0104e25:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0104e2a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e31:	00 
c0104e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e35:	89 54 24 08          	mov    %edx,0x8(%esp)
c0104e39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e40:	89 04 24             	mov    %eax,(%esp)
c0104e43:	e8 73 0f 00 00       	call   c0105dbb <swap_map_swappable>
            page->pra_vaddr=la;
c0104e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e4e:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0104e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e54:	89 04 24             	mov    %eax,(%esp)
c0104e57:	e8 4c f4 ff ff       	call   c01042a8 <page_ref>
c0104e5c:	83 f8 01             	cmp    $0x1,%eax
c0104e5f:	74 24                	je     c0104e85 <pgdir_alloc_page+0xc6>
c0104e61:	c7 44 24 0c 5c 94 10 	movl   $0xc010945c,0xc(%esp)
c0104e68:	c0 
c0104e69:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104e70:	c0 
c0104e71:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0104e78:	00 
c0104e79:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104e80:	e8 96 bd ff ff       	call   c0100c1b <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0104e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e88:	c9                   	leave  
c0104e89:	c3                   	ret    

c0104e8a <check_alloc_page>:

static void
check_alloc_page(void) {
c0104e8a:	55                   	push   %ebp
c0104e8b:	89 e5                	mov    %esp,%ebp
c0104e8d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104e90:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104e95:	8b 40 18             	mov    0x18(%eax),%eax
c0104e98:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104e9a:	c7 04 24 70 94 10 c0 	movl   $0xc0109470,(%esp)
c0104ea1:	e8 a5 b4 ff ff       	call   c010034b <cprintf>
}
c0104ea6:	c9                   	leave  
c0104ea7:	c3                   	ret    

c0104ea8 <check_pgdir>:

static void
check_pgdir(void) {
c0104ea8:	55                   	push   %ebp
c0104ea9:	89 e5                	mov    %esp,%ebp
c0104eab:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104eae:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104eb3:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104eb8:	76 24                	jbe    c0104ede <check_pgdir+0x36>
c0104eba:	c7 44 24 0c 8f 94 10 	movl   $0xc010948f,0xc(%esp)
c0104ec1:	c0 
c0104ec2:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104ec9:	c0 
c0104eca:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104ed1:	00 
c0104ed2:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104ed9:	e8 3d bd ff ff       	call   c0100c1b <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104ede:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104ee3:	85 c0                	test   %eax,%eax
c0104ee5:	74 0e                	je     c0104ef5 <check_pgdir+0x4d>
c0104ee7:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104eec:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104ef1:	85 c0                	test   %eax,%eax
c0104ef3:	74 24                	je     c0104f19 <check_pgdir+0x71>
c0104ef5:	c7 44 24 0c ac 94 10 	movl   $0xc01094ac,0xc(%esp)
c0104efc:	c0 
c0104efd:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104f04:	c0 
c0104f05:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104f0c:	00 
c0104f0d:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104f14:	e8 02 bd ff ff       	call   c0100c1b <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104f19:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104f1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f25:	00 
c0104f26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f2d:	00 
c0104f2e:	89 04 24             	mov    %eax,(%esp)
c0104f31:	e8 d1 fc ff ff       	call   c0104c07 <get_page>
c0104f36:	85 c0                	test   %eax,%eax
c0104f38:	74 24                	je     c0104f5e <check_pgdir+0xb6>
c0104f3a:	c7 44 24 0c e4 94 10 	movl   $0xc01094e4,0xc(%esp)
c0104f41:	c0 
c0104f42:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104f49:	c0 
c0104f4a:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104f51:	00 
c0104f52:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104f59:	e8 bd bc ff ff       	call   c0100c1b <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104f5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f65:	e8 36 f5 ff ff       	call   c01044a0 <alloc_pages>
c0104f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104f6d:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104f72:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104f79:	00 
c0104f7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f81:	00 
c0104f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f85:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f89:	89 04 24             	mov    %eax,(%esp)
c0104f8c:	e8 18 fd ff ff       	call   c0104ca9 <page_insert>
c0104f91:	85 c0                	test   %eax,%eax
c0104f93:	74 24                	je     c0104fb9 <check_pgdir+0x111>
c0104f95:	c7 44 24 0c 0c 95 10 	movl   $0xc010950c,0xc(%esp)
c0104f9c:	c0 
c0104f9d:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104fa4:	c0 
c0104fa5:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104fac:	00 
c0104fad:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104fb4:	e8 62 bc ff ff       	call   c0100c1b <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104fb9:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104fbe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104fc5:	00 
c0104fc6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104fcd:	00 
c0104fce:	89 04 24             	mov    %eax,(%esp)
c0104fd1:	e8 2c fc ff ff       	call   c0104c02 <get_pte>
c0104fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104fdd:	75 24                	jne    c0105003 <check_pgdir+0x15b>
c0104fdf:	c7 44 24 0c 38 95 10 	movl   $0xc0109538,0xc(%esp)
c0104fe6:	c0 
c0104fe7:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0104fee:	c0 
c0104fef:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104ff6:	00 
c0104ff7:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0104ffe:	e8 18 bc ff ff       	call   c0100c1b <__panic>
    assert(pte2page(*ptep) == p1);
c0105003:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105006:	8b 00                	mov    (%eax),%eax
c0105008:	89 04 24             	mov    %eax,(%esp)
c010500b:	e8 42 f2 ff ff       	call   c0104252 <pte2page>
c0105010:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105013:	74 24                	je     c0105039 <check_pgdir+0x191>
c0105015:	c7 44 24 0c 65 95 10 	movl   $0xc0109565,0xc(%esp)
c010501c:	c0 
c010501d:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105024:	c0 
c0105025:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c010502c:	00 
c010502d:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105034:	e8 e2 bb ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p1) == 1);
c0105039:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010503c:	89 04 24             	mov    %eax,(%esp)
c010503f:	e8 64 f2 ff ff       	call   c01042a8 <page_ref>
c0105044:	83 f8 01             	cmp    $0x1,%eax
c0105047:	74 24                	je     c010506d <check_pgdir+0x1c5>
c0105049:	c7 44 24 0c 7b 95 10 	movl   $0xc010957b,0xc(%esp)
c0105050:	c0 
c0105051:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105058:	c0 
c0105059:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0105060:	00 
c0105061:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105068:	e8 ae bb ff ff       	call   c0100c1b <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010506d:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105072:	8b 00                	mov    (%eax),%eax
c0105074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105079:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010507c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010507f:	c1 e8 0c             	shr    $0xc,%eax
c0105082:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105085:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010508a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010508d:	72 23                	jb     c01050b2 <check_pgdir+0x20a>
c010508f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105092:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105096:	c7 44 24 08 34 93 10 	movl   $0xc0109334,0x8(%esp)
c010509d:	c0 
c010509e:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c01050a5:	00 
c01050a6:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01050ad:	e8 69 bb ff ff       	call   c0100c1b <__panic>
c01050b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050b5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01050ba:	83 c0 04             	add    $0x4,%eax
c01050bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01050c0:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01050c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01050cc:	00 
c01050cd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01050d4:	00 
c01050d5:	89 04 24             	mov    %eax,(%esp)
c01050d8:	e8 25 fb ff ff       	call   c0104c02 <get_pte>
c01050dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01050e0:	74 24                	je     c0105106 <check_pgdir+0x25e>
c01050e2:	c7 44 24 0c 90 95 10 	movl   $0xc0109590,0xc(%esp)
c01050e9:	c0 
c01050ea:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01050f1:	c0 
c01050f2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c01050f9:	00 
c01050fa:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105101:	e8 15 bb ff ff       	call   c0100c1b <__panic>

    p2 = alloc_page();
c0105106:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010510d:	e8 8e f3 ff ff       	call   c01044a0 <alloc_pages>
c0105112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105115:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010511a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105121:	00 
c0105122:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105129:	00 
c010512a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010512d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105131:	89 04 24             	mov    %eax,(%esp)
c0105134:	e8 70 fb ff ff       	call   c0104ca9 <page_insert>
c0105139:	85 c0                	test   %eax,%eax
c010513b:	74 24                	je     c0105161 <check_pgdir+0x2b9>
c010513d:	c7 44 24 0c b8 95 10 	movl   $0xc01095b8,0xc(%esp)
c0105144:	c0 
c0105145:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010514c:	c0 
c010514d:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0105154:	00 
c0105155:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010515c:	e8 ba ba ff ff       	call   c0100c1b <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105161:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105166:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010516d:	00 
c010516e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105175:	00 
c0105176:	89 04 24             	mov    %eax,(%esp)
c0105179:	e8 84 fa ff ff       	call   c0104c02 <get_pte>
c010517e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105181:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105185:	75 24                	jne    c01051ab <check_pgdir+0x303>
c0105187:	c7 44 24 0c f0 95 10 	movl   $0xc01095f0,0xc(%esp)
c010518e:	c0 
c010518f:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105196:	c0 
c0105197:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c010519e:	00 
c010519f:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01051a6:	e8 70 ba ff ff       	call   c0100c1b <__panic>
    assert(*ptep & PTE_U);
c01051ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051ae:	8b 00                	mov    (%eax),%eax
c01051b0:	83 e0 04             	and    $0x4,%eax
c01051b3:	85 c0                	test   %eax,%eax
c01051b5:	75 24                	jne    c01051db <check_pgdir+0x333>
c01051b7:	c7 44 24 0c 20 96 10 	movl   $0xc0109620,0xc(%esp)
c01051be:	c0 
c01051bf:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01051c6:	c0 
c01051c7:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c01051ce:	00 
c01051cf:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01051d6:	e8 40 ba ff ff       	call   c0100c1b <__panic>
    assert(*ptep & PTE_W);
c01051db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051de:	8b 00                	mov    (%eax),%eax
c01051e0:	83 e0 02             	and    $0x2,%eax
c01051e3:	85 c0                	test   %eax,%eax
c01051e5:	75 24                	jne    c010520b <check_pgdir+0x363>
c01051e7:	c7 44 24 0c 2e 96 10 	movl   $0xc010962e,0xc(%esp)
c01051ee:	c0 
c01051ef:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01051f6:	c0 
c01051f7:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01051fe:	00 
c01051ff:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105206:	e8 10 ba ff ff       	call   c0100c1b <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010520b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105210:	8b 00                	mov    (%eax),%eax
c0105212:	83 e0 04             	and    $0x4,%eax
c0105215:	85 c0                	test   %eax,%eax
c0105217:	75 24                	jne    c010523d <check_pgdir+0x395>
c0105219:	c7 44 24 0c 3c 96 10 	movl   $0xc010963c,0xc(%esp)
c0105220:	c0 
c0105221:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105228:	c0 
c0105229:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0105230:	00 
c0105231:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105238:	e8 de b9 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p2) == 1);
c010523d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105240:	89 04 24             	mov    %eax,(%esp)
c0105243:	e8 60 f0 ff ff       	call   c01042a8 <page_ref>
c0105248:	83 f8 01             	cmp    $0x1,%eax
c010524b:	74 24                	je     c0105271 <check_pgdir+0x3c9>
c010524d:	c7 44 24 0c 52 96 10 	movl   $0xc0109652,0xc(%esp)
c0105254:	c0 
c0105255:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010525c:	c0 
c010525d:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105264:	00 
c0105265:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010526c:	e8 aa b9 ff ff       	call   c0100c1b <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105271:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105276:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010527d:	00 
c010527e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105285:	00 
c0105286:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105289:	89 54 24 04          	mov    %edx,0x4(%esp)
c010528d:	89 04 24             	mov    %eax,(%esp)
c0105290:	e8 14 fa ff ff       	call   c0104ca9 <page_insert>
c0105295:	85 c0                	test   %eax,%eax
c0105297:	74 24                	je     c01052bd <check_pgdir+0x415>
c0105299:	c7 44 24 0c 64 96 10 	movl   $0xc0109664,0xc(%esp)
c01052a0:	c0 
c01052a1:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01052a8:	c0 
c01052a9:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c01052b0:	00 
c01052b1:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01052b8:	e8 5e b9 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p1) == 2);
c01052bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052c0:	89 04 24             	mov    %eax,(%esp)
c01052c3:	e8 e0 ef ff ff       	call   c01042a8 <page_ref>
c01052c8:	83 f8 02             	cmp    $0x2,%eax
c01052cb:	74 24                	je     c01052f1 <check_pgdir+0x449>
c01052cd:	c7 44 24 0c 90 96 10 	movl   $0xc0109690,0xc(%esp)
c01052d4:	c0 
c01052d5:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01052dc:	c0 
c01052dd:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01052e4:	00 
c01052e5:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01052ec:	e8 2a b9 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p2) == 0);
c01052f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052f4:	89 04 24             	mov    %eax,(%esp)
c01052f7:	e8 ac ef ff ff       	call   c01042a8 <page_ref>
c01052fc:	85 c0                	test   %eax,%eax
c01052fe:	74 24                	je     c0105324 <check_pgdir+0x47c>
c0105300:	c7 44 24 0c a2 96 10 	movl   $0xc01096a2,0xc(%esp)
c0105307:	c0 
c0105308:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010530f:	c0 
c0105310:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105317:	00 
c0105318:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010531f:	e8 f7 b8 ff ff       	call   c0100c1b <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105324:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105329:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105330:	00 
c0105331:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105338:	00 
c0105339:	89 04 24             	mov    %eax,(%esp)
c010533c:	e8 c1 f8 ff ff       	call   c0104c02 <get_pte>
c0105341:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105344:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105348:	75 24                	jne    c010536e <check_pgdir+0x4c6>
c010534a:	c7 44 24 0c f0 95 10 	movl   $0xc01095f0,0xc(%esp)
c0105351:	c0 
c0105352:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105359:	c0 
c010535a:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0105361:	00 
c0105362:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105369:	e8 ad b8 ff ff       	call   c0100c1b <__panic>
    assert(pte2page(*ptep) == p1);
c010536e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105371:	8b 00                	mov    (%eax),%eax
c0105373:	89 04 24             	mov    %eax,(%esp)
c0105376:	e8 d7 ee ff ff       	call   c0104252 <pte2page>
c010537b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010537e:	74 24                	je     c01053a4 <check_pgdir+0x4fc>
c0105380:	c7 44 24 0c 65 95 10 	movl   $0xc0109565,0xc(%esp)
c0105387:	c0 
c0105388:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010538f:	c0 
c0105390:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105397:	00 
c0105398:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010539f:	e8 77 b8 ff ff       	call   c0100c1b <__panic>
    assert((*ptep & PTE_U) == 0);
c01053a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053a7:	8b 00                	mov    (%eax),%eax
c01053a9:	83 e0 04             	and    $0x4,%eax
c01053ac:	85 c0                	test   %eax,%eax
c01053ae:	74 24                	je     c01053d4 <check_pgdir+0x52c>
c01053b0:	c7 44 24 0c b4 96 10 	movl   $0xc01096b4,0xc(%esp)
c01053b7:	c0 
c01053b8:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01053bf:	c0 
c01053c0:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01053c7:	00 
c01053c8:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01053cf:	e8 47 b8 ff ff       	call   c0100c1b <__panic>

    page_remove(boot_pgdir, 0x0);
c01053d4:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01053d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01053e0:	00 
c01053e1:	89 04 24             	mov    %eax,(%esp)
c01053e4:	e8 7c f8 ff ff       	call   c0104c65 <page_remove>
    assert(page_ref(p1) == 1);
c01053e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053ec:	89 04 24             	mov    %eax,(%esp)
c01053ef:	e8 b4 ee ff ff       	call   c01042a8 <page_ref>
c01053f4:	83 f8 01             	cmp    $0x1,%eax
c01053f7:	74 24                	je     c010541d <check_pgdir+0x575>
c01053f9:	c7 44 24 0c 7b 95 10 	movl   $0xc010957b,0xc(%esp)
c0105400:	c0 
c0105401:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105408:	c0 
c0105409:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105410:	00 
c0105411:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105418:	e8 fe b7 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p2) == 0);
c010541d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105420:	89 04 24             	mov    %eax,(%esp)
c0105423:	e8 80 ee ff ff       	call   c01042a8 <page_ref>
c0105428:	85 c0                	test   %eax,%eax
c010542a:	74 24                	je     c0105450 <check_pgdir+0x5a8>
c010542c:	c7 44 24 0c a2 96 10 	movl   $0xc01096a2,0xc(%esp)
c0105433:	c0 
c0105434:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010543b:	c0 
c010543c:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105443:	00 
c0105444:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010544b:	e8 cb b7 ff ff       	call   c0100c1b <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105450:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105455:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010545c:	00 
c010545d:	89 04 24             	mov    %eax,(%esp)
c0105460:	e8 00 f8 ff ff       	call   c0104c65 <page_remove>
    assert(page_ref(p1) == 0);
c0105465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105468:	89 04 24             	mov    %eax,(%esp)
c010546b:	e8 38 ee ff ff       	call   c01042a8 <page_ref>
c0105470:	85 c0                	test   %eax,%eax
c0105472:	74 24                	je     c0105498 <check_pgdir+0x5f0>
c0105474:	c7 44 24 0c c9 96 10 	movl   $0xc01096c9,0xc(%esp)
c010547b:	c0 
c010547c:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105483:	c0 
c0105484:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c010548b:	00 
c010548c:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105493:	e8 83 b7 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p2) == 0);
c0105498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010549b:	89 04 24             	mov    %eax,(%esp)
c010549e:	e8 05 ee ff ff       	call   c01042a8 <page_ref>
c01054a3:	85 c0                	test   %eax,%eax
c01054a5:	74 24                	je     c01054cb <check_pgdir+0x623>
c01054a7:	c7 44 24 0c a2 96 10 	movl   $0xc01096a2,0xc(%esp)
c01054ae:	c0 
c01054af:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01054b6:	c0 
c01054b7:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c01054be:	00 
c01054bf:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01054c6:	e8 50 b7 ff ff       	call   c0100c1b <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01054cb:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01054d0:	8b 00                	mov    (%eax),%eax
c01054d2:	89 04 24             	mov    %eax,(%esp)
c01054d5:	e8 b6 ed ff ff       	call   c0104290 <pde2page>
c01054da:	89 04 24             	mov    %eax,(%esp)
c01054dd:	e8 c6 ed ff ff       	call   c01042a8 <page_ref>
c01054e2:	83 f8 01             	cmp    $0x1,%eax
c01054e5:	74 24                	je     c010550b <check_pgdir+0x663>
c01054e7:	c7 44 24 0c dc 96 10 	movl   $0xc01096dc,0xc(%esp)
c01054ee:	c0 
c01054ef:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01054f6:	c0 
c01054f7:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01054fe:	00 
c01054ff:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105506:	e8 10 b7 ff ff       	call   c0100c1b <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010550b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105510:	8b 00                	mov    (%eax),%eax
c0105512:	89 04 24             	mov    %eax,(%esp)
c0105515:	e8 76 ed ff ff       	call   c0104290 <pde2page>
c010551a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105521:	00 
c0105522:	89 04 24             	mov    %eax,(%esp)
c0105525:	e8 e1 ef ff ff       	call   c010450b <free_pages>
    boot_pgdir[0] = 0;
c010552a:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010552f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105535:	c7 04 24 03 97 10 c0 	movl   $0xc0109703,(%esp)
c010553c:	e8 0a ae ff ff       	call   c010034b <cprintf>
}
c0105541:	c9                   	leave  
c0105542:	c3                   	ret    

c0105543 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105543:	55                   	push   %ebp
c0105544:	89 e5                	mov    %esp,%ebp
c0105546:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105549:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105550:	e9 ca 00 00 00       	jmp    c010561f <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105555:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105558:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010555b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010555e:	c1 e8 0c             	shr    $0xc,%eax
c0105561:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105564:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105569:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010556c:	72 23                	jb     c0105591 <check_boot_pgdir+0x4e>
c010556e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105571:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105575:	c7 44 24 08 34 93 10 	movl   $0xc0109334,0x8(%esp)
c010557c:	c0 
c010557d:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105584:	00 
c0105585:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010558c:	e8 8a b6 ff ff       	call   c0100c1b <__panic>
c0105591:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105594:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105599:	89 c2                	mov    %eax,%edx
c010559b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01055a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055a7:	00 
c01055a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055ac:	89 04 24             	mov    %eax,(%esp)
c01055af:	e8 4e f6 ff ff       	call   c0104c02 <get_pte>
c01055b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055bb:	75 24                	jne    c01055e1 <check_boot_pgdir+0x9e>
c01055bd:	c7 44 24 0c 20 97 10 	movl   $0xc0109720,0xc(%esp)
c01055c4:	c0 
c01055c5:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01055cc:	c0 
c01055cd:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c01055d4:	00 
c01055d5:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01055dc:	e8 3a b6 ff ff       	call   c0100c1b <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01055e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055e4:	8b 00                	mov    (%eax),%eax
c01055e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055eb:	89 c2                	mov    %eax,%edx
c01055ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055f0:	39 c2                	cmp    %eax,%edx
c01055f2:	74 24                	je     c0105618 <check_boot_pgdir+0xd5>
c01055f4:	c7 44 24 0c 5d 97 10 	movl   $0xc010975d,0xc(%esp)
c01055fb:	c0 
c01055fc:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105603:	c0 
c0105604:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c010560b:	00 
c010560c:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105613:	e8 03 b6 ff ff       	call   c0100c1b <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105618:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010561f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105622:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105627:	39 c2                	cmp    %eax,%edx
c0105629:	0f 82 26 ff ff ff    	jb     c0105555 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010562f:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105634:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105639:	8b 00                	mov    (%eax),%eax
c010563b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105640:	89 c2                	mov    %eax,%edx
c0105642:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105647:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010564a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105651:	77 23                	ja     c0105676 <check_boot_pgdir+0x133>
c0105653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105656:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010565a:	c7 44 24 08 58 93 10 	movl   $0xc0109358,0x8(%esp)
c0105661:	c0 
c0105662:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105669:	00 
c010566a:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105671:	e8 a5 b5 ff ff       	call   c0100c1b <__panic>
c0105676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105679:	05 00 00 00 40       	add    $0x40000000,%eax
c010567e:	39 c2                	cmp    %eax,%edx
c0105680:	74 24                	je     c01056a6 <check_boot_pgdir+0x163>
c0105682:	c7 44 24 0c 74 97 10 	movl   $0xc0109774,0xc(%esp)
c0105689:	c0 
c010568a:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105691:	c0 
c0105692:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105699:	00 
c010569a:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01056a1:	e8 75 b5 ff ff       	call   c0100c1b <__panic>

    assert(boot_pgdir[0] == 0);
c01056a6:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01056ab:	8b 00                	mov    (%eax),%eax
c01056ad:	85 c0                	test   %eax,%eax
c01056af:	74 24                	je     c01056d5 <check_boot_pgdir+0x192>
c01056b1:	c7 44 24 0c a8 97 10 	movl   $0xc01097a8,0xc(%esp)
c01056b8:	c0 
c01056b9:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01056c0:	c0 
c01056c1:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c01056c8:	00 
c01056c9:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01056d0:	e8 46 b5 ff ff       	call   c0100c1b <__panic>

    struct Page *p;
    p = alloc_page();
c01056d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01056dc:	e8 bf ed ff ff       	call   c01044a0 <alloc_pages>
c01056e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01056e4:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01056e9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01056f0:	00 
c01056f1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01056f8:	00 
c01056f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01056fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105700:	89 04 24             	mov    %eax,(%esp)
c0105703:	e8 a1 f5 ff ff       	call   c0104ca9 <page_insert>
c0105708:	85 c0                	test   %eax,%eax
c010570a:	74 24                	je     c0105730 <check_boot_pgdir+0x1ed>
c010570c:	c7 44 24 0c bc 97 10 	movl   $0xc01097bc,0xc(%esp)
c0105713:	c0 
c0105714:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010571b:	c0 
c010571c:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105723:	00 
c0105724:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010572b:	e8 eb b4 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p) == 1);
c0105730:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105733:	89 04 24             	mov    %eax,(%esp)
c0105736:	e8 6d eb ff ff       	call   c01042a8 <page_ref>
c010573b:	83 f8 01             	cmp    $0x1,%eax
c010573e:	74 24                	je     c0105764 <check_boot_pgdir+0x221>
c0105740:	c7 44 24 0c ea 97 10 	movl   $0xc01097ea,0xc(%esp)
c0105747:	c0 
c0105748:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010574f:	c0 
c0105750:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105757:	00 
c0105758:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010575f:	e8 b7 b4 ff ff       	call   c0100c1b <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105764:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105769:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105770:	00 
c0105771:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105778:	00 
c0105779:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010577c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105780:	89 04 24             	mov    %eax,(%esp)
c0105783:	e8 21 f5 ff ff       	call   c0104ca9 <page_insert>
c0105788:	85 c0                	test   %eax,%eax
c010578a:	74 24                	je     c01057b0 <check_boot_pgdir+0x26d>
c010578c:	c7 44 24 0c fc 97 10 	movl   $0xc01097fc,0xc(%esp)
c0105793:	c0 
c0105794:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010579b:	c0 
c010579c:	c7 44 24 04 48 02 00 	movl   $0x248,0x4(%esp)
c01057a3:	00 
c01057a4:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01057ab:	e8 6b b4 ff ff       	call   c0100c1b <__panic>
    assert(page_ref(p) == 2);
c01057b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057b3:	89 04 24             	mov    %eax,(%esp)
c01057b6:	e8 ed ea ff ff       	call   c01042a8 <page_ref>
c01057bb:	83 f8 02             	cmp    $0x2,%eax
c01057be:	74 24                	je     c01057e4 <check_boot_pgdir+0x2a1>
c01057c0:	c7 44 24 0c 33 98 10 	movl   $0xc0109833,0xc(%esp)
c01057c7:	c0 
c01057c8:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c01057cf:	c0 
c01057d0:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c01057d7:	00 
c01057d8:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c01057df:	e8 37 b4 ff ff       	call   c0100c1b <__panic>

    const char *str = "ucore: Hello world!!";
c01057e4:	c7 45 dc 44 98 10 c0 	movl   $0xc0109844,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01057eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057f2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01057f9:	e8 ba 2a 00 00       	call   c01082b8 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01057fe:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105805:	00 
c0105806:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010580d:	e8 1f 2b 00 00       	call   c0108331 <strcmp>
c0105812:	85 c0                	test   %eax,%eax
c0105814:	74 24                	je     c010583a <check_boot_pgdir+0x2f7>
c0105816:	c7 44 24 0c 5c 98 10 	movl   $0xc010985c,0xc(%esp)
c010581d:	c0 
c010581e:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105825:	c0 
c0105826:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c010582d:	00 
c010582e:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105835:	e8 e1 b3 ff ff       	call   c0100c1b <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010583a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010583d:	89 04 24             	mov    %eax,(%esp)
c0105840:	e8 6f e9 ff ff       	call   c01041b4 <page2kva>
c0105845:	05 00 01 00 00       	add    $0x100,%eax
c010584a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010584d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105854:	e8 07 2a 00 00       	call   c0108260 <strlen>
c0105859:	85 c0                	test   %eax,%eax
c010585b:	74 24                	je     c0105881 <check_boot_pgdir+0x33e>
c010585d:	c7 44 24 0c 94 98 10 	movl   $0xc0109894,0xc(%esp)
c0105864:	c0 
c0105865:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c010586c:	c0 
c010586d:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0105874:	00 
c0105875:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c010587c:	e8 9a b3 ff ff       	call   c0100c1b <__panic>

    free_page(p);
c0105881:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105888:	00 
c0105889:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010588c:	89 04 24             	mov    %eax,(%esp)
c010588f:	e8 77 ec ff ff       	call   c010450b <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105894:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105899:	8b 00                	mov    (%eax),%eax
c010589b:	89 04 24             	mov    %eax,(%esp)
c010589e:	e8 ed e9 ff ff       	call   c0104290 <pde2page>
c01058a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01058aa:	00 
c01058ab:	89 04 24             	mov    %eax,(%esp)
c01058ae:	e8 58 ec ff ff       	call   c010450b <free_pages>
    boot_pgdir[0] = 0;
c01058b3:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01058b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01058be:	c7 04 24 b8 98 10 c0 	movl   $0xc01098b8,(%esp)
c01058c5:	e8 81 aa ff ff       	call   c010034b <cprintf>
}
c01058ca:	c9                   	leave  
c01058cb:	c3                   	ret    

c01058cc <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01058cc:	55                   	push   %ebp
c01058cd:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01058cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d2:	83 e0 04             	and    $0x4,%eax
c01058d5:	85 c0                	test   %eax,%eax
c01058d7:	74 07                	je     c01058e0 <perm2str+0x14>
c01058d9:	b8 75 00 00 00       	mov    $0x75,%eax
c01058de:	eb 05                	jmp    c01058e5 <perm2str+0x19>
c01058e0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01058e5:	a2 a8 0a 12 c0       	mov    %al,0xc0120aa8
    str[1] = 'r';
c01058ea:	c6 05 a9 0a 12 c0 72 	movb   $0x72,0xc0120aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01058f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f4:	83 e0 02             	and    $0x2,%eax
c01058f7:	85 c0                	test   %eax,%eax
c01058f9:	74 07                	je     c0105902 <perm2str+0x36>
c01058fb:	b8 77 00 00 00       	mov    $0x77,%eax
c0105900:	eb 05                	jmp    c0105907 <perm2str+0x3b>
c0105902:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105907:	a2 aa 0a 12 c0       	mov    %al,0xc0120aaa
    str[3] = '\0';
c010590c:	c6 05 ab 0a 12 c0 00 	movb   $0x0,0xc0120aab
    return str;
c0105913:	b8 a8 0a 12 c0       	mov    $0xc0120aa8,%eax
}
c0105918:	5d                   	pop    %ebp
c0105919:	c3                   	ret    

c010591a <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010591a:	55                   	push   %ebp
c010591b:	89 e5                	mov    %esp,%ebp
c010591d:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105920:	8b 45 10             	mov    0x10(%ebp),%eax
c0105923:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105926:	72 0a                	jb     c0105932 <get_pgtable_items+0x18>
        return 0;
c0105928:	b8 00 00 00 00       	mov    $0x0,%eax
c010592d:	e9 9c 00 00 00       	jmp    c01059ce <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105932:	eb 04                	jmp    c0105938 <get_pgtable_items+0x1e>
        start ++;
c0105934:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105938:	8b 45 10             	mov    0x10(%ebp),%eax
c010593b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010593e:	73 18                	jae    c0105958 <get_pgtable_items+0x3e>
c0105940:	8b 45 10             	mov    0x10(%ebp),%eax
c0105943:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010594a:	8b 45 14             	mov    0x14(%ebp),%eax
c010594d:	01 d0                	add    %edx,%eax
c010594f:	8b 00                	mov    (%eax),%eax
c0105951:	83 e0 01             	and    $0x1,%eax
c0105954:	85 c0                	test   %eax,%eax
c0105956:	74 dc                	je     c0105934 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105958:	8b 45 10             	mov    0x10(%ebp),%eax
c010595b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010595e:	73 69                	jae    c01059c9 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105960:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105964:	74 08                	je     c010596e <get_pgtable_items+0x54>
            *left_store = start;
c0105966:	8b 45 18             	mov    0x18(%ebp),%eax
c0105969:	8b 55 10             	mov    0x10(%ebp),%edx
c010596c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010596e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105971:	8d 50 01             	lea    0x1(%eax),%edx
c0105974:	89 55 10             	mov    %edx,0x10(%ebp)
c0105977:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010597e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105981:	01 d0                	add    %edx,%eax
c0105983:	8b 00                	mov    (%eax),%eax
c0105985:	83 e0 07             	and    $0x7,%eax
c0105988:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010598b:	eb 04                	jmp    c0105991 <get_pgtable_items+0x77>
            start ++;
c010598d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105991:	8b 45 10             	mov    0x10(%ebp),%eax
c0105994:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105997:	73 1d                	jae    c01059b6 <get_pgtable_items+0x9c>
c0105999:	8b 45 10             	mov    0x10(%ebp),%eax
c010599c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01059a3:	8b 45 14             	mov    0x14(%ebp),%eax
c01059a6:	01 d0                	add    %edx,%eax
c01059a8:	8b 00                	mov    (%eax),%eax
c01059aa:	83 e0 07             	and    $0x7,%eax
c01059ad:	89 c2                	mov    %eax,%edx
c01059af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059b2:	39 c2                	cmp    %eax,%edx
c01059b4:	74 d7                	je     c010598d <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01059b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01059ba:	74 08                	je     c01059c4 <get_pgtable_items+0xaa>
            *right_store = start;
c01059bc:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01059bf:	8b 55 10             	mov    0x10(%ebp),%edx
c01059c2:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01059c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059c7:	eb 05                	jmp    c01059ce <get_pgtable_items+0xb4>
    }
    return 0;
c01059c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01059ce:	c9                   	leave  
c01059cf:	c3                   	ret    

c01059d0 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01059d0:	55                   	push   %ebp
c01059d1:	89 e5                	mov    %esp,%ebp
c01059d3:	57                   	push   %edi
c01059d4:	56                   	push   %esi
c01059d5:	53                   	push   %ebx
c01059d6:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01059d9:	c7 04 24 d8 98 10 c0 	movl   $0xc01098d8,(%esp)
c01059e0:	e8 66 a9 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c01059e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01059ec:	e9 fa 00 00 00       	jmp    c0105aeb <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01059f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059f4:	89 04 24             	mov    %eax,(%esp)
c01059f7:	e8 d0 fe ff ff       	call   c01058cc <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01059fc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01059ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a02:	29 d1                	sub    %edx,%ecx
c0105a04:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105a06:	89 d6                	mov    %edx,%esi
c0105a08:	c1 e6 16             	shl    $0x16,%esi
c0105a0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105a0e:	89 d3                	mov    %edx,%ebx
c0105a10:	c1 e3 16             	shl    $0x16,%ebx
c0105a13:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a16:	89 d1                	mov    %edx,%ecx
c0105a18:	c1 e1 16             	shl    $0x16,%ecx
c0105a1b:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105a1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a21:	29 d7                	sub    %edx,%edi
c0105a23:	89 fa                	mov    %edi,%edx
c0105a25:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105a29:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105a2d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105a31:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105a35:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a39:	c7 04 24 09 99 10 c0 	movl   $0xc0109909,(%esp)
c0105a40:	e8 06 a9 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105a45:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a48:	c1 e0 0a             	shl    $0xa,%eax
c0105a4b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105a4e:	eb 54                	jmp    c0105aa4 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a53:	89 04 24             	mov    %eax,(%esp)
c0105a56:	e8 71 fe ff ff       	call   c01058cc <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105a5b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105a5e:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105a61:	29 d1                	sub    %edx,%ecx
c0105a63:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105a65:	89 d6                	mov    %edx,%esi
c0105a67:	c1 e6 0c             	shl    $0xc,%esi
c0105a6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105a6d:	89 d3                	mov    %edx,%ebx
c0105a6f:	c1 e3 0c             	shl    $0xc,%ebx
c0105a72:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105a75:	c1 e2 0c             	shl    $0xc,%edx
c0105a78:	89 d1                	mov    %edx,%ecx
c0105a7a:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105a7d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105a80:	29 d7                	sub    %edx,%edi
c0105a82:	89 fa                	mov    %edi,%edx
c0105a84:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105a88:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105a8c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105a90:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105a94:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a98:	c7 04 24 28 99 10 c0 	movl   $0xc0109928,(%esp)
c0105a9f:	e8 a7 a8 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105aa4:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105aa9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105aac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105aaf:	89 ce                	mov    %ecx,%esi
c0105ab1:	c1 e6 0a             	shl    $0xa,%esi
c0105ab4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105ab7:	89 cb                	mov    %ecx,%ebx
c0105ab9:	c1 e3 0a             	shl    $0xa,%ebx
c0105abc:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105abf:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105ac3:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105ac6:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105aca:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105ace:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ad2:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105ad6:	89 1c 24             	mov    %ebx,(%esp)
c0105ad9:	e8 3c fe ff ff       	call   c010591a <get_pgtable_items>
c0105ade:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ae1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105ae5:	0f 85 65 ff ff ff    	jne    c0105a50 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105aeb:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105af0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105af3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105af6:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105afa:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105afd:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105b01:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b05:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b09:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105b10:	00 
c0105b11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105b18:	e8 fd fd ff ff       	call   c010591a <get_pgtable_items>
c0105b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105b20:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b24:	0f 85 c7 fe ff ff    	jne    c01059f1 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105b2a:	c7 04 24 4c 99 10 c0 	movl   $0xc010994c,(%esp)
c0105b31:	e8 15 a8 ff ff       	call   c010034b <cprintf>
}
c0105b36:	83 c4 4c             	add    $0x4c,%esp
c0105b39:	5b                   	pop    %ebx
c0105b3a:	5e                   	pop    %esi
c0105b3b:	5f                   	pop    %edi
c0105b3c:	5d                   	pop    %ebp
c0105b3d:	c3                   	ret    

c0105b3e <kmalloc>:

void *
kmalloc(size_t n) {
c0105b3e:	55                   	push   %ebp
c0105b3f:	89 e5                	mov    %esp,%ebp
c0105b41:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105b44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105b4b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105b52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105b56:	74 09                	je     c0105b61 <kmalloc+0x23>
c0105b58:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105b5f:	76 24                	jbe    c0105b85 <kmalloc+0x47>
c0105b61:	c7 44 24 0c 7d 99 10 	movl   $0xc010997d,0xc(%esp)
c0105b68:	c0 
c0105b69:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105b70:	c0 
c0105b71:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c0105b78:	00 
c0105b79:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105b80:	e8 96 b0 ff ff       	call   c0100c1b <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b88:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105b8d:	c1 e8 0c             	shr    $0xc,%eax
c0105b90:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b96:	89 04 24             	mov    %eax,(%esp)
c0105b99:	e8 02 e9 ff ff       	call   c01044a0 <alloc_pages>
c0105b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105ba1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105ba5:	75 24                	jne    c0105bcb <kmalloc+0x8d>
c0105ba7:	c7 44 24 0c 94 99 10 	movl   $0xc0109994,0xc(%esp)
c0105bae:	c0 
c0105baf:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105bb6:	c0 
c0105bb7:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c0105bbe:	00 
c0105bbf:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105bc6:	e8 50 b0 ff ff       	call   c0100c1b <__panic>
    ptr=page2kva(base);
c0105bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bce:	89 04 24             	mov    %eax,(%esp)
c0105bd1:	e8 de e5 ff ff       	call   c01041b4 <page2kva>
c0105bd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bdc:	c9                   	leave  
c0105bdd:	c3                   	ret    

c0105bde <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105bde:	55                   	push   %ebp
c0105bdf:	89 e5                	mov    %esp,%ebp
c0105be1:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105be4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105be8:	74 09                	je     c0105bf3 <kfree+0x15>
c0105bea:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105bf1:	76 24                	jbe    c0105c17 <kfree+0x39>
c0105bf3:	c7 44 24 0c 7d 99 10 	movl   $0xc010997d,0xc(%esp)
c0105bfa:	c0 
c0105bfb:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105c02:	c0 
c0105c03:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c0105c0a:	00 
c0105c0b:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105c12:	e8 04 b0 ff ff       	call   c0100c1b <__panic>
    assert(ptr != NULL);
c0105c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c1b:	75 24                	jne    c0105c41 <kfree+0x63>
c0105c1d:	c7 44 24 0c a1 99 10 	movl   $0xc01099a1,0xc(%esp)
c0105c24:	c0 
c0105c25:	c7 44 24 08 21 94 10 	movl   $0xc0109421,0x8(%esp)
c0105c2c:	c0 
c0105c2d:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c0105c34:	00 
c0105c35:	c7 04 24 fc 93 10 c0 	movl   $0xc01093fc,(%esp)
c0105c3c:	e8 da af ff ff       	call   c0100c1b <__panic>
    struct Page *base=NULL;
c0105c41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105c48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4b:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105c50:	c1 e8 0c             	shr    $0xc,%eax
c0105c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c59:	89 04 24             	mov    %eax,(%esp)
c0105c5c:	e8 a7 e5 ff ff       	call   c0104208 <kva2page>
c0105c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c6e:	89 04 24             	mov    %eax,(%esp)
c0105c71:	e8 95 e8 ff ff       	call   c010450b <free_pages>
}
c0105c76:	c9                   	leave  
c0105c77:	c3                   	ret    

c0105c78 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105c78:	55                   	push   %ebp
c0105c79:	89 e5                	mov    %esp,%ebp
c0105c7b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c81:	c1 e8 0c             	shr    $0xc,%eax
c0105c84:	89 c2                	mov    %eax,%edx
c0105c86:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105c8b:	39 c2                	cmp    %eax,%edx
c0105c8d:	72 1c                	jb     c0105cab <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0105c8f:	c7 44 24 08 b0 99 10 	movl   $0xc01099b0,0x8(%esp)
c0105c96:	c0 
c0105c97:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0105c9e:	00 
c0105c9f:	c7 04 24 cf 99 10 c0 	movl   $0xc01099cf,(%esp)
c0105ca6:	e8 70 af ff ff       	call   c0100c1b <__panic>
    }
    return &pages[PPN(pa)];
c0105cab:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0105cb0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105cb3:	c1 ea 0c             	shr    $0xc,%edx
c0105cb6:	c1 e2 05             	shl    $0x5,%edx
c0105cb9:	01 d0                	add    %edx,%eax
}
c0105cbb:	c9                   	leave  
c0105cbc:	c3                   	ret    

c0105cbd <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105cbd:	55                   	push   %ebp
c0105cbe:	89 e5                	mov    %esp,%ebp
c0105cc0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0105cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc6:	83 e0 01             	and    $0x1,%eax
c0105cc9:	85 c0                	test   %eax,%eax
c0105ccb:	75 1c                	jne    c0105ce9 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0105ccd:	c7 44 24 08 e0 99 10 	movl   $0xc01099e0,0x8(%esp)
c0105cd4:	c0 
c0105cd5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105cdc:	00 
c0105cdd:	c7 04 24 cf 99 10 c0 	movl   $0xc01099cf,(%esp)
c0105ce4:	e8 32 af ff ff       	call   c0100c1b <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105ce9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105cf1:	89 04 24             	mov    %eax,(%esp)
c0105cf4:	e8 7f ff ff ff       	call   c0105c78 <pa2page>
}
c0105cf9:	c9                   	leave  
c0105cfa:	c3                   	ret    

c0105cfb <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0105cfb:	55                   	push   %ebp
c0105cfc:	89 e5                	mov    %esp,%ebp
c0105cfe:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0105d01:	e8 d5 1c 00 00       	call   c01079db <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0105d06:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105d0b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0105d10:	76 0c                	jbe    c0105d1e <swap_init+0x23>
c0105d12:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105d17:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0105d1c:	76 25                	jbe    c0105d43 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0105d1e:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105d23:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d27:	c7 44 24 08 01 9a 10 	movl   $0xc0109a01,0x8(%esp)
c0105d2e:	c0 
c0105d2f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0105d36:	00 
c0105d37:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0105d3e:	e8 d8 ae ff ff       	call   c0100c1b <__panic>
     }
     

     sm = &swap_manager_fifo;
c0105d43:	c7 05 b4 0a 12 c0 40 	movl   $0xc011fa40,0xc0120ab4
c0105d4a:	fa 11 c0 
     int r = sm->init();
c0105d4d:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105d52:	8b 40 04             	mov    0x4(%eax),%eax
c0105d55:	ff d0                	call   *%eax
c0105d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0105d5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d5e:	75 26                	jne    c0105d86 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0105d60:	c7 05 ac 0a 12 c0 01 	movl   $0x1,0xc0120aac
c0105d67:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0105d6a:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105d6f:	8b 00                	mov    (%eax),%eax
c0105d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d75:	c7 04 24 2b 9a 10 c0 	movl   $0xc0109a2b,(%esp)
c0105d7c:	e8 ca a5 ff ff       	call   c010034b <cprintf>
          check_swap();
c0105d81:	e8 a4 04 00 00       	call   c010622a <check_swap>
     }

     return r;
c0105d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d89:	c9                   	leave  
c0105d8a:	c3                   	ret    

c0105d8b <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0105d8b:	55                   	push   %ebp
c0105d8c:	89 e5                	mov    %esp,%ebp
c0105d8e:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0105d91:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105d96:	8b 40 08             	mov    0x8(%eax),%eax
c0105d99:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d9c:	89 14 24             	mov    %edx,(%esp)
c0105d9f:	ff d0                	call   *%eax
}
c0105da1:	c9                   	leave  
c0105da2:	c3                   	ret    

c0105da3 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0105da3:	55                   	push   %ebp
c0105da4:	89 e5                	mov    %esp,%ebp
c0105da6:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0105da9:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105dae:	8b 40 0c             	mov    0xc(%eax),%eax
c0105db1:	8b 55 08             	mov    0x8(%ebp),%edx
c0105db4:	89 14 24             	mov    %edx,(%esp)
c0105db7:	ff d0                	call   *%eax
}
c0105db9:	c9                   	leave  
c0105dba:	c3                   	ret    

c0105dbb <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0105dbb:	55                   	push   %ebp
c0105dbc:	89 e5                	mov    %esp,%ebp
c0105dbe:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0105dc1:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105dc6:	8b 40 10             	mov    0x10(%eax),%eax
c0105dc9:	8b 55 14             	mov    0x14(%ebp),%edx
c0105dcc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105dd0:	8b 55 10             	mov    0x10(%ebp),%edx
c0105dd3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105dda:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dde:	8b 55 08             	mov    0x8(%ebp),%edx
c0105de1:	89 14 24             	mov    %edx,(%esp)
c0105de4:	ff d0                	call   *%eax
}
c0105de6:	c9                   	leave  
c0105de7:	c3                   	ret    

c0105de8 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0105de8:	55                   	push   %ebp
c0105de9:	89 e5                	mov    %esp,%ebp
c0105deb:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0105dee:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105df3:	8b 40 14             	mov    0x14(%eax),%eax
c0105df6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105df9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105dfd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e00:	89 14 24             	mov    %edx,(%esp)
c0105e03:	ff d0                	call   *%eax
}
c0105e05:	c9                   	leave  
c0105e06:	c3                   	ret    

c0105e07 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0105e07:	55                   	push   %ebp
c0105e08:	89 e5                	mov    %esp,%ebp
c0105e0a:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0105e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105e14:	e9 5a 01 00 00       	jmp    c0105f73 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0105e19:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105e1e:	8b 40 18             	mov    0x18(%eax),%eax
c0105e21:	8b 55 10             	mov    0x10(%ebp),%edx
c0105e24:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105e28:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0105e2b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e2f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e32:	89 14 24             	mov    %edx,(%esp)
c0105e35:	ff d0                	call   *%eax
c0105e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0105e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e3e:	74 18                	je     c0105e58 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0105e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e47:	c7 04 24 40 9a 10 c0 	movl   $0xc0109a40,(%esp)
c0105e4e:	e8 f8 a4 ff ff       	call   c010034b <cprintf>
c0105e53:	e9 27 01 00 00       	jmp    c0105f7f <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0105e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e5b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105e5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0105e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e64:	8b 40 0c             	mov    0xc(%eax),%eax
c0105e67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e6e:	00 
c0105e6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e76:	89 04 24             	mov    %eax,(%esp)
c0105e79:	e8 84 ed ff ff       	call   c0104c02 <get_pte>
c0105e7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0105e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e84:	8b 00                	mov    (%eax),%eax
c0105e86:	83 e0 01             	and    $0x1,%eax
c0105e89:	85 c0                	test   %eax,%eax
c0105e8b:	75 24                	jne    c0105eb1 <swap_out+0xaa>
c0105e8d:	c7 44 24 0c 6d 9a 10 	movl   $0xc0109a6d,0xc(%esp)
c0105e94:	c0 
c0105e95:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0105e9c:	c0 
c0105e9d:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0105ea4:	00 
c0105ea5:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0105eac:	e8 6a ad ff ff       	call   c0100c1b <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0105eb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105eb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105eb7:	8b 52 1c             	mov    0x1c(%edx),%edx
c0105eba:	c1 ea 0c             	shr    $0xc,%edx
c0105ebd:	83 c2 01             	add    $0x1,%edx
c0105ec0:	c1 e2 08             	shl    $0x8,%edx
c0105ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ec7:	89 14 24             	mov    %edx,(%esp)
c0105eca:	e8 c6 1b 00 00       	call   c0107a95 <swapfs_write>
c0105ecf:	85 c0                	test   %eax,%eax
c0105ed1:	74 34                	je     c0105f07 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0105ed3:	c7 04 24 97 9a 10 c0 	movl   $0xc0109a97,(%esp)
c0105eda:	e8 6c a4 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0105edf:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0105ee4:	8b 40 10             	mov    0x10(%eax),%eax
c0105ee7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105eea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105ef1:	00 
c0105ef2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105ef6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ef9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105efd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f00:	89 14 24             	mov    %edx,(%esp)
c0105f03:	ff d0                	call   *%eax
c0105f05:	eb 68                	jmp    c0105f6f <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0105f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f0a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105f0d:	c1 e8 0c             	shr    $0xc,%eax
c0105f10:	83 c0 01             	add    $0x1,%eax
c0105f13:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f1a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f25:	c7 04 24 b0 9a 10 c0 	movl   $0xc0109ab0,(%esp)
c0105f2c:	e8 1a a4 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0105f31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f34:	8b 40 1c             	mov    0x1c(%eax),%eax
c0105f37:	c1 e8 0c             	shr    $0xc,%eax
c0105f3a:	83 c0 01             	add    $0x1,%eax
c0105f3d:	c1 e0 08             	shl    $0x8,%eax
c0105f40:	89 c2                	mov    %eax,%edx
c0105f42:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105f45:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0105f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105f4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f51:	00 
c0105f52:	89 04 24             	mov    %eax,(%esp)
c0105f55:	e8 b1 e5 ff ff       	call   c010450b <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0105f5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5d:	8b 40 0c             	mov    0xc(%eax),%eax
c0105f60:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105f63:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f67:	89 04 24             	mov    %eax,(%esp)
c0105f6a:	e8 f3 ed ff ff       	call   c0104d62 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0105f6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0105f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f76:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105f79:	0f 85 9a fe ff ff    	jne    c0105e19 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0105f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105f82:	c9                   	leave  
c0105f83:	c3                   	ret    

c0105f84 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0105f84:	55                   	push   %ebp
c0105f85:	89 e5                	mov    %esp,%ebp
c0105f87:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0105f8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f91:	e8 0a e5 ff ff       	call   c01044a0 <alloc_pages>
c0105f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0105f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f9d:	75 24                	jne    c0105fc3 <swap_in+0x3f>
c0105f9f:	c7 44 24 0c f0 9a 10 	movl   $0xc0109af0,0xc(%esp)
c0105fa6:	c0 
c0105fa7:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0105fae:	c0 
c0105faf:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0105fb6:	00 
c0105fb7:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0105fbe:	e8 58 ac ff ff       	call   c0100c1b <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0105fc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc6:	8b 40 0c             	mov    0xc(%eax),%eax
c0105fc9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fd0:	00 
c0105fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105fd4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fd8:	89 04 24             	mov    %eax,(%esp)
c0105fdb:	e8 22 ec ff ff       	call   c0104c02 <get_pte>
c0105fe0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0105fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fe6:	8b 00                	mov    (%eax),%eax
c0105fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105feb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fef:	89 04 24             	mov    %eax,(%esp)
c0105ff2:	e8 2c 1a 00 00       	call   c0107a23 <swapfs_read>
c0105ff7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ffa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105ffe:	74 2a                	je     c010602a <swap_in+0xa6>
     {
        assert(r!=0);
c0106000:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106004:	75 24                	jne    c010602a <swap_in+0xa6>
c0106006:	c7 44 24 0c fd 9a 10 	movl   $0xc0109afd,0xc(%esp)
c010600d:	c0 
c010600e:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106015:	c0 
c0106016:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010601d:	00 
c010601e:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106025:	e8 f1 ab ff ff       	call   c0100c1b <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c010602a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010602d:	8b 00                	mov    (%eax),%eax
c010602f:	c1 e8 08             	shr    $0x8,%eax
c0106032:	89 c2                	mov    %eax,%edx
c0106034:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106037:	89 44 24 08          	mov    %eax,0x8(%esp)
c010603b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010603f:	c7 04 24 04 9b 10 c0 	movl   $0xc0109b04,(%esp)
c0106046:	e8 00 a3 ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c010604b:	8b 45 10             	mov    0x10(%ebp),%eax
c010604e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106051:	89 10                	mov    %edx,(%eax)
     return 0;
c0106053:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106058:	c9                   	leave  
c0106059:	c3                   	ret    

c010605a <check_content_set>:



static inline void
check_content_set(void)
{
c010605a:	55                   	push   %ebp
c010605b:	89 e5                	mov    %esp,%ebp
c010605d:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106060:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106065:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106068:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010606d:	83 f8 01             	cmp    $0x1,%eax
c0106070:	74 24                	je     c0106096 <check_content_set+0x3c>
c0106072:	c7 44 24 0c 42 9b 10 	movl   $0xc0109b42,0xc(%esp)
c0106079:	c0 
c010607a:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106081:	c0 
c0106082:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106089:	00 
c010608a:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106091:	e8 85 ab ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106096:	b8 10 10 00 00       	mov    $0x1010,%eax
c010609b:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010609e:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01060a3:	83 f8 01             	cmp    $0x1,%eax
c01060a6:	74 24                	je     c01060cc <check_content_set+0x72>
c01060a8:	c7 44 24 0c 42 9b 10 	movl   $0xc0109b42,0xc(%esp)
c01060af:	c0 
c01060b0:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01060b7:	c0 
c01060b8:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01060bf:	00 
c01060c0:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01060c7:	e8 4f ab ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01060cc:	b8 00 20 00 00       	mov    $0x2000,%eax
c01060d1:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01060d4:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01060d9:	83 f8 02             	cmp    $0x2,%eax
c01060dc:	74 24                	je     c0106102 <check_content_set+0xa8>
c01060de:	c7 44 24 0c 51 9b 10 	movl   $0xc0109b51,0xc(%esp)
c01060e5:	c0 
c01060e6:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01060ed:	c0 
c01060ee:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01060f5:	00 
c01060f6:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01060fd:	e8 19 ab ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106102:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106107:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010610a:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010610f:	83 f8 02             	cmp    $0x2,%eax
c0106112:	74 24                	je     c0106138 <check_content_set+0xde>
c0106114:	c7 44 24 0c 51 9b 10 	movl   $0xc0109b51,0xc(%esp)
c010611b:	c0 
c010611c:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106123:	c0 
c0106124:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010612b:	00 
c010612c:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106133:	e8 e3 aa ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106138:	b8 00 30 00 00       	mov    $0x3000,%eax
c010613d:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106140:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106145:	83 f8 03             	cmp    $0x3,%eax
c0106148:	74 24                	je     c010616e <check_content_set+0x114>
c010614a:	c7 44 24 0c 60 9b 10 	movl   $0xc0109b60,0xc(%esp)
c0106151:	c0 
c0106152:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106159:	c0 
c010615a:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106161:	00 
c0106162:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106169:	e8 ad aa ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c010616e:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106173:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106176:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010617b:	83 f8 03             	cmp    $0x3,%eax
c010617e:	74 24                	je     c01061a4 <check_content_set+0x14a>
c0106180:	c7 44 24 0c 60 9b 10 	movl   $0xc0109b60,0xc(%esp)
c0106187:	c0 
c0106188:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c010618f:	c0 
c0106190:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106197:	00 
c0106198:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010619f:	e8 77 aa ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01061a4:	b8 00 40 00 00       	mov    $0x4000,%eax
c01061a9:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01061ac:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01061b1:	83 f8 04             	cmp    $0x4,%eax
c01061b4:	74 24                	je     c01061da <check_content_set+0x180>
c01061b6:	c7 44 24 0c 6f 9b 10 	movl   $0xc0109b6f,0xc(%esp)
c01061bd:	c0 
c01061be:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01061c5:	c0 
c01061c6:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01061cd:	00 
c01061ce:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01061d5:	e8 41 aa ff ff       	call   c0100c1b <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01061da:	b8 10 40 00 00       	mov    $0x4010,%eax
c01061df:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01061e2:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01061e7:	83 f8 04             	cmp    $0x4,%eax
c01061ea:	74 24                	je     c0106210 <check_content_set+0x1b6>
c01061ec:	c7 44 24 0c 6f 9b 10 	movl   $0xc0109b6f,0xc(%esp)
c01061f3:	c0 
c01061f4:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01061fb:	c0 
c01061fc:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106203:	00 
c0106204:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010620b:	e8 0b aa ff ff       	call   c0100c1b <__panic>
}
c0106210:	c9                   	leave  
c0106211:	c3                   	ret    

c0106212 <check_content_access>:

static inline int
check_content_access(void)
{
c0106212:	55                   	push   %ebp
c0106213:	89 e5                	mov    %esp,%ebp
c0106215:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106218:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010621d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106220:	ff d0                	call   *%eax
c0106222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106225:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106228:	c9                   	leave  
c0106229:	c3                   	ret    

c010622a <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010622a:	55                   	push   %ebp
c010622b:	89 e5                	mov    %esp,%ebp
c010622d:	53                   	push   %ebx
c010622e:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106238:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010623f:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106246:	eb 6b                	jmp    c01062b3 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106248:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010624b:	83 e8 0c             	sub    $0xc,%eax
c010624e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106254:	83 c0 04             	add    $0x4,%eax
c0106257:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010625e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106261:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106264:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106267:	0f a3 10             	bt     %edx,(%eax)
c010626a:	19 c0                	sbb    %eax,%eax
c010626c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c010626f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106273:	0f 95 c0             	setne  %al
c0106276:	0f b6 c0             	movzbl %al,%eax
c0106279:	85 c0                	test   %eax,%eax
c010627b:	75 24                	jne    c01062a1 <check_swap+0x77>
c010627d:	c7 44 24 0c 7e 9b 10 	movl   $0xc0109b7e,0xc(%esp)
c0106284:	c0 
c0106285:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c010628c:	c0 
c010628d:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106294:	00 
c0106295:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010629c:	e8 7a a9 ff ff       	call   c0100c1b <__panic>
        count ++, total += p->property;
c01062a1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01062a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01062a8:	8b 50 08             	mov    0x8(%eax),%edx
c01062ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062ae:	01 d0                	add    %edx,%eax
c01062b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01062b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01062b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01062bc:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01062bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062c2:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c01062c9:	0f 85 79 ff ff ff    	jne    c0106248 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01062cf:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01062d2:	e8 66 e2 ff ff       	call   c010453d <nr_free_pages>
c01062d7:	39 c3                	cmp    %eax,%ebx
c01062d9:	74 24                	je     c01062ff <check_swap+0xd5>
c01062db:	c7 44 24 0c 8e 9b 10 	movl   $0xc0109b8e,0xc(%esp)
c01062e2:	c0 
c01062e3:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01062ea:	c0 
c01062eb:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01062f2:	00 
c01062f3:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01062fa:	e8 1c a9 ff ff       	call   c0100c1b <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01062ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106302:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106306:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106309:	89 44 24 04          	mov    %eax,0x4(%esp)
c010630d:	c7 04 24 a8 9b 10 c0 	movl   $0xc0109ba8,(%esp)
c0106314:	e8 32 a0 ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106319:	e8 2b 0a 00 00       	call   c0106d49 <mm_create>
c010631e:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106321:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106325:	75 24                	jne    c010634b <check_swap+0x121>
c0106327:	c7 44 24 0c ce 9b 10 	movl   $0xc0109bce,0xc(%esp)
c010632e:	c0 
c010632f:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106336:	c0 
c0106337:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010633e:	00 
c010633f:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106346:	e8 d0 a8 ff ff       	call   c0100c1b <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c010634b:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0106350:	85 c0                	test   %eax,%eax
c0106352:	74 24                	je     c0106378 <check_swap+0x14e>
c0106354:	c7 44 24 0c d9 9b 10 	movl   $0xc0109bd9,0xc(%esp)
c010635b:	c0 
c010635c:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106363:	c0 
c0106364:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c010636b:	00 
c010636c:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106373:	e8 a3 a8 ff ff       	call   c0100c1b <__panic>

     check_mm_struct = mm;
c0106378:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010637b:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106380:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0106386:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106389:	89 50 0c             	mov    %edx,0xc(%eax)
c010638c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010638f:	8b 40 0c             	mov    0xc(%eax),%eax
c0106392:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106395:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106398:	8b 00                	mov    (%eax),%eax
c010639a:	85 c0                	test   %eax,%eax
c010639c:	74 24                	je     c01063c2 <check_swap+0x198>
c010639e:	c7 44 24 0c f1 9b 10 	movl   $0xc0109bf1,0xc(%esp)
c01063a5:	c0 
c01063a6:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01063ad:	c0 
c01063ae:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01063b5:	00 
c01063b6:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01063bd:	e8 59 a8 ff ff       	call   c0100c1b <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01063c2:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01063c9:	00 
c01063ca:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01063d1:	00 
c01063d2:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01063d9:	e8 e3 09 00 00       	call   c0106dc1 <vma_create>
c01063de:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01063e1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01063e5:	75 24                	jne    c010640b <check_swap+0x1e1>
c01063e7:	c7 44 24 0c ff 9b 10 	movl   $0xc0109bff,0xc(%esp)
c01063ee:	c0 
c01063ef:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01063f6:	c0 
c01063f7:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01063fe:	00 
c01063ff:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106406:	e8 10 a8 ff ff       	call   c0100c1b <__panic>

     insert_vma_struct(mm, vma);
c010640b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010640e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106412:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106415:	89 04 24             	mov    %eax,(%esp)
c0106418:	e8 34 0b 00 00       	call   c0106f51 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010641d:	c7 04 24 0c 9c 10 c0 	movl   $0xc0109c0c,(%esp)
c0106424:	e8 22 9f ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c0106429:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106430:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106433:	8b 40 0c             	mov    0xc(%eax),%eax
c0106436:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010643d:	00 
c010643e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106445:	00 
c0106446:	89 04 24             	mov    %eax,(%esp)
c0106449:	e8 b4 e7 ff ff       	call   c0104c02 <get_pte>
c010644e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106451:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106455:	75 24                	jne    c010647b <check_swap+0x251>
c0106457:	c7 44 24 0c 40 9c 10 	movl   $0xc0109c40,0xc(%esp)
c010645e:	c0 
c010645f:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106466:	c0 
c0106467:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010646e:	00 
c010646f:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106476:	e8 a0 a7 ff ff       	call   c0100c1b <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c010647b:	c7 04 24 54 9c 10 c0 	movl   $0xc0109c54,(%esp)
c0106482:	e8 c4 9e ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106487:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010648e:	e9 a3 00 00 00       	jmp    c0106536 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106493:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010649a:	e8 01 e0 ff ff       	call   c01044a0 <alloc_pages>
c010649f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01064a2:	89 04 95 e0 0a 12 c0 	mov    %eax,-0x3fedf520(,%edx,4)
          assert(check_rp[i] != NULL );
c01064a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01064ac:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01064b3:	85 c0                	test   %eax,%eax
c01064b5:	75 24                	jne    c01064db <check_swap+0x2b1>
c01064b7:	c7 44 24 0c 78 9c 10 	movl   $0xc0109c78,0xc(%esp)
c01064be:	c0 
c01064bf:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01064c6:	c0 
c01064c7:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01064ce:	00 
c01064cf:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01064d6:	e8 40 a7 ff ff       	call   c0100c1b <__panic>
          assert(!PageProperty(check_rp[i]));
c01064db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01064de:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01064e5:	83 c0 04             	add    $0x4,%eax
c01064e8:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01064ef:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01064f2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01064f5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01064f8:	0f a3 10             	bt     %edx,(%eax)
c01064fb:	19 c0                	sbb    %eax,%eax
c01064fd:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106500:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106504:	0f 95 c0             	setne  %al
c0106507:	0f b6 c0             	movzbl %al,%eax
c010650a:	85 c0                	test   %eax,%eax
c010650c:	74 24                	je     c0106532 <check_swap+0x308>
c010650e:	c7 44 24 0c 8c 9c 10 	movl   $0xc0109c8c,0xc(%esp)
c0106515:	c0 
c0106516:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c010651d:	c0 
c010651e:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106525:	00 
c0106526:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010652d:	e8 e9 a6 ff ff       	call   c0100c1b <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106532:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106536:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010653a:	0f 8e 53 ff ff ff    	jle    c0106493 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106540:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0106545:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c010654b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010654e:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106551:	c7 45 a8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106558:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010655b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010655e:	89 50 04             	mov    %edx,0x4(%eax)
c0106561:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106564:	8b 50 04             	mov    0x4(%eax),%edx
c0106567:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010656a:	89 10                	mov    %edx,(%eax)
c010656c:	c7 45 a4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106573:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106576:	8b 40 04             	mov    0x4(%eax),%eax
c0106579:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c010657c:	0f 94 c0             	sete   %al
c010657f:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106582:	85 c0                	test   %eax,%eax
c0106584:	75 24                	jne    c01065aa <check_swap+0x380>
c0106586:	c7 44 24 0c a7 9c 10 	movl   $0xc0109ca7,0xc(%esp)
c010658d:	c0 
c010658e:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106595:	c0 
c0106596:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010659d:	00 
c010659e:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01065a5:	e8 71 a6 ff ff       	call   c0100c1b <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01065aa:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01065af:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01065b2:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c01065b9:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01065bc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01065c3:	eb 1e                	jmp    c01065e3 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01065c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01065c8:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01065cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01065d6:	00 
c01065d7:	89 04 24             	mov    %eax,(%esp)
c01065da:	e8 2c df ff ff       	call   c010450b <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01065df:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01065e3:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01065e7:	7e dc                	jle    c01065c5 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01065e9:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01065ee:	83 f8 04             	cmp    $0x4,%eax
c01065f1:	74 24                	je     c0106617 <check_swap+0x3ed>
c01065f3:	c7 44 24 0c c0 9c 10 	movl   $0xc0109cc0,0xc(%esp)
c01065fa:	c0 
c01065fb:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106602:	c0 
c0106603:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010660a:	00 
c010660b:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106612:	e8 04 a6 ff ff       	call   c0100c1b <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106617:	c7 04 24 e4 9c 10 c0 	movl   $0xc0109ce4,(%esp)
c010661e:	e8 28 9d ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106623:	c7 05 b8 0a 12 c0 00 	movl   $0x0,0xc0120ab8
c010662a:	00 00 00 
     
     check_content_set();
c010662d:	e8 28 fa ff ff       	call   c010605a <check_content_set>
     assert( nr_free == 0);         
c0106632:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0106637:	85 c0                	test   %eax,%eax
c0106639:	74 24                	je     c010665f <check_swap+0x435>
c010663b:	c7 44 24 0c 0b 9d 10 	movl   $0xc0109d0b,0xc(%esp)
c0106642:	c0 
c0106643:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c010664a:	c0 
c010664b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106652:	00 
c0106653:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010665a:	e8 bc a5 ff ff       	call   c0100c1b <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010665f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106666:	eb 26                	jmp    c010668e <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106668:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010666b:	c7 04 85 00 0b 12 c0 	movl   $0xffffffff,-0x3fedf500(,%eax,4)
c0106672:	ff ff ff ff 
c0106676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106679:	8b 14 85 00 0b 12 c0 	mov    -0x3fedf500(,%eax,4),%edx
c0106680:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106683:	89 14 85 40 0b 12 c0 	mov    %edx,-0x3fedf4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010668a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010668e:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106692:	7e d4                	jle    c0106668 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010669b:	e9 eb 00 00 00       	jmp    c010678b <check_swap+0x561>
         check_ptep[i]=0;
c01066a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066a3:	c7 04 85 94 0b 12 c0 	movl   $0x0,-0x3fedf46c(,%eax,4)
c01066aa:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01066ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066b1:	83 c0 01             	add    $0x1,%eax
c01066b4:	c1 e0 0c             	shl    $0xc,%eax
c01066b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01066be:	00 
c01066bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066c6:	89 04 24             	mov    %eax,(%esp)
c01066c9:	e8 34 e5 ff ff       	call   c0104c02 <get_pte>
c01066ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01066d1:	89 04 95 94 0b 12 c0 	mov    %eax,-0x3fedf46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01066d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01066db:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c01066e2:	85 c0                	test   %eax,%eax
c01066e4:	75 24                	jne    c010670a <check_swap+0x4e0>
c01066e6:	c7 44 24 0c 18 9d 10 	movl   $0xc0109d18,0xc(%esp)
c01066ed:	c0 
c01066ee:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01066f5:	c0 
c01066f6:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01066fd:	00 
c01066fe:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106705:	e8 11 a5 ff ff       	call   c0100c1b <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010670a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010670d:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106714:	8b 00                	mov    (%eax),%eax
c0106716:	89 04 24             	mov    %eax,(%esp)
c0106719:	e8 9f f5 ff ff       	call   c0105cbd <pte2page>
c010671e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106721:	8b 14 95 e0 0a 12 c0 	mov    -0x3fedf520(,%edx,4),%edx
c0106728:	39 d0                	cmp    %edx,%eax
c010672a:	74 24                	je     c0106750 <check_swap+0x526>
c010672c:	c7 44 24 0c 30 9d 10 	movl   $0xc0109d30,0xc(%esp)
c0106733:	c0 
c0106734:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c010673b:	c0 
c010673c:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106743:	00 
c0106744:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c010674b:	e8 cb a4 ff ff       	call   c0100c1b <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106750:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106753:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c010675a:	8b 00                	mov    (%eax),%eax
c010675c:	83 e0 01             	and    $0x1,%eax
c010675f:	85 c0                	test   %eax,%eax
c0106761:	75 24                	jne    c0106787 <check_swap+0x55d>
c0106763:	c7 44 24 0c 58 9d 10 	movl   $0xc0109d58,0xc(%esp)
c010676a:	c0 
c010676b:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c0106772:	c0 
c0106773:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010677a:	00 
c010677b:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c0106782:	e8 94 a4 ff ff       	call   c0100c1b <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106787:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010678b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010678f:	0f 8e 0b ff ff ff    	jle    c01066a0 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106795:	c7 04 24 74 9d 10 c0 	movl   $0xc0109d74,(%esp)
c010679c:	e8 aa 9b ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01067a1:	e8 6c fa ff ff       	call   c0106212 <check_content_access>
c01067a6:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01067a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01067ad:	74 24                	je     c01067d3 <check_swap+0x5a9>
c01067af:	c7 44 24 0c 9a 9d 10 	movl   $0xc0109d9a,0xc(%esp)
c01067b6:	c0 
c01067b7:	c7 44 24 08 82 9a 10 	movl   $0xc0109a82,0x8(%esp)
c01067be:	c0 
c01067bf:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01067c6:	00 
c01067c7:	c7 04 24 1c 9a 10 c0 	movl   $0xc0109a1c,(%esp)
c01067ce:	e8 48 a4 ff ff       	call   c0100c1b <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01067d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01067da:	eb 1e                	jmp    c01067fa <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01067dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067df:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01067e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067ed:	00 
c01067ee:	89 04 24             	mov    %eax,(%esp)
c01067f1:	e8 15 dd ff ff       	call   c010450b <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01067f6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01067fa:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01067fe:	7e dc                	jle    c01067dc <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106800:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106803:	89 04 24             	mov    %eax,(%esp)
c0106806:	e8 76 08 00 00       	call   c0107081 <mm_destroy>
         
     nr_free = nr_free_store;
c010680b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010680e:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
     free_list = free_list_store;
c0106813:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106816:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106819:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c010681e:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4

     
     le = &free_list;
c0106824:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010682b:	eb 1d                	jmp    c010684a <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c010682d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106830:	83 e8 0c             	sub    $0xc,%eax
c0106833:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106836:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010683a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010683d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106840:	8b 40 08             	mov    0x8(%eax),%eax
c0106843:	29 c2                	sub    %eax,%edx
c0106845:	89 d0                	mov    %edx,%eax
c0106847:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010684a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010684d:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106850:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106853:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106856:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106859:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106860:	75 cb                	jne    c010682d <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106862:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106865:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106869:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010686c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106870:	c7 04 24 a1 9d 10 c0 	movl   $0xc0109da1,(%esp)
c0106877:	e8 cf 9a ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010687c:	c7 04 24 bb 9d 10 c0 	movl   $0xc0109dbb,(%esp)
c0106883:	e8 c3 9a ff ff       	call   c010034b <cprintf>
}
c0106888:	83 c4 74             	add    $0x74,%esp
c010688b:	5b                   	pop    %ebx
c010688c:	5d                   	pop    %ebp
c010688d:	c3                   	ret    

c010688e <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010688e:	55                   	push   %ebp
c010688f:	89 e5                	mov    %esp,%ebp
c0106891:	83 ec 10             	sub    $0x10,%esp
c0106894:	c7 45 fc a4 0b 12 c0 	movl   $0xc0120ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010689b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010689e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01068a1:	89 50 04             	mov    %edx,0x4(%eax)
c01068a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068a7:	8b 50 04             	mov    0x4(%eax),%edx
c01068aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068ad:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01068af:	8b 45 08             	mov    0x8(%ebp),%eax
c01068b2:	c7 40 14 a4 0b 12 c0 	movl   $0xc0120ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01068b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01068be:	c9                   	leave  
c01068bf:	c3                   	ret    

c01068c0 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01068c0:	55                   	push   %ebp
c01068c1:	89 e5                	mov    %esp,%ebp
c01068c3:	83 ec 28             	sub    $0x28,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01068c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01068c9:	8b 40 14             	mov    0x14(%eax),%eax
c01068cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01068cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01068d2:	83 c0 14             	add    $0x14,%eax
c01068d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01068d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068dc:	74 06                	je     c01068e4 <_fifo_map_swappable+0x24>
c01068de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068e2:	75 24                	jne    c0106908 <_fifo_map_swappable+0x48>
c01068e4:	c7 44 24 0c d4 9d 10 	movl   $0xc0109dd4,0xc(%esp)
c01068eb:	c0 
c01068ec:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c01068f3:	c0 
c01068f4:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01068fb:	00 
c01068fc:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106903:	e8 13 a3 ff ff       	call   c0100c1b <__panic>
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    return 0;
c0106908:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010690d:	c9                   	leave  
c010690e:	c3                   	ret    

c010690f <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010690f:	55                   	push   %ebp
c0106910:	89 e5                	mov    %esp,%ebp
c0106912:	83 ec 28             	sub    $0x28,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106915:	8b 45 08             	mov    0x8(%ebp),%eax
c0106918:	8b 40 14             	mov    0x14(%eax),%eax
c010691b:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c010691e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106922:	75 24                	jne    c0106948 <_fifo_swap_out_victim+0x39>
c0106924:	c7 44 24 0c 1b 9e 10 	movl   $0xc0109e1b,0xc(%esp)
c010692b:	c0 
c010692c:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106933:	c0 
c0106934:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
c010693b:	00 
c010693c:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106943:	e8 d3 a2 ff ff       	call   c0100c1b <__panic>
     assert(in_tick==0);
c0106948:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010694c:	74 24                	je     c0106972 <_fifo_swap_out_victim+0x63>
c010694e:	c7 44 24 0c 28 9e 10 	movl   $0xc0109e28,0xc(%esp)
c0106955:	c0 
c0106956:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c010695d:	c0 
c010695e:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106965:	00 
c0106966:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c010696d:	e8 a9 a2 ff ff       	call   c0100c1b <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     return 0;
c0106972:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106977:	c9                   	leave  
c0106978:	c3                   	ret    

c0106979 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106979:	55                   	push   %ebp
c010697a:	89 e5                	mov    %esp,%ebp
c010697c:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c010697f:	c7 04 24 34 9e 10 c0 	movl   $0xc0109e34,(%esp)
c0106986:	e8 c0 99 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c010698b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106990:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106993:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106998:	83 f8 04             	cmp    $0x4,%eax
c010699b:	74 24                	je     c01069c1 <_fifo_check_swap+0x48>
c010699d:	c7 44 24 0c 5a 9e 10 	movl   $0xc0109e5a,0xc(%esp)
c01069a4:	c0 
c01069a5:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c01069ac:	c0 
c01069ad:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
c01069b4:	00 
c01069b5:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c01069bc:	e8 5a a2 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01069c1:	c7 04 24 6c 9e 10 c0 	movl   $0xc0109e6c,(%esp)
c01069c8:	e8 7e 99 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01069cd:	b8 00 10 00 00       	mov    $0x1000,%eax
c01069d2:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01069d5:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01069da:	83 f8 04             	cmp    $0x4,%eax
c01069dd:	74 24                	je     c0106a03 <_fifo_check_swap+0x8a>
c01069df:	c7 44 24 0c 5a 9e 10 	movl   $0xc0109e5a,0xc(%esp)
c01069e6:	c0 
c01069e7:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c01069ee:	c0 
c01069ef:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
c01069f6:	00 
c01069f7:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c01069fe:	e8 18 a2 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106a03:	c7 04 24 94 9e 10 c0 	movl   $0xc0109e94,(%esp)
c0106a0a:	e8 3c 99 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106a0f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106a14:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106a17:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106a1c:	83 f8 04             	cmp    $0x4,%eax
c0106a1f:	74 24                	je     c0106a45 <_fifo_check_swap+0xcc>
c0106a21:	c7 44 24 0c 5a 9e 10 	movl   $0xc0109e5a,0xc(%esp)
c0106a28:	c0 
c0106a29:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106a30:	c0 
c0106a31:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
c0106a38:	00 
c0106a39:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106a40:	e8 d6 a1 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106a45:	c7 04 24 bc 9e 10 c0 	movl   $0xc0109ebc,(%esp)
c0106a4c:	e8 fa 98 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106a51:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106a56:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106a59:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106a5e:	83 f8 04             	cmp    $0x4,%eax
c0106a61:	74 24                	je     c0106a87 <_fifo_check_swap+0x10e>
c0106a63:	c7 44 24 0c 5a 9e 10 	movl   $0xc0109e5a,0xc(%esp)
c0106a6a:	c0 
c0106a6b:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106a72:	c0 
c0106a73:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0106a7a:	00 
c0106a7b:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106a82:	e8 94 a1 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106a87:	c7 04 24 e4 9e 10 c0 	movl   $0xc0109ee4,(%esp)
c0106a8e:	e8 b8 98 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106a93:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106a98:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106a9b:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106aa0:	83 f8 05             	cmp    $0x5,%eax
c0106aa3:	74 24                	je     c0106ac9 <_fifo_check_swap+0x150>
c0106aa5:	c7 44 24 0c 0a 9f 10 	movl   $0xc0109f0a,0xc(%esp)
c0106aac:	c0 
c0106aad:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106ab4:	c0 
c0106ab5:	c7 44 24 04 59 00 00 	movl   $0x59,0x4(%esp)
c0106abc:	00 
c0106abd:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106ac4:	e8 52 a1 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ac9:	c7 04 24 bc 9e 10 c0 	movl   $0xc0109ebc,(%esp)
c0106ad0:	e8 76 98 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106ad5:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ada:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106add:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106ae2:	83 f8 05             	cmp    $0x5,%eax
c0106ae5:	74 24                	je     c0106b0b <_fifo_check_swap+0x192>
c0106ae7:	c7 44 24 0c 0a 9f 10 	movl   $0xc0109f0a,0xc(%esp)
c0106aee:	c0 
c0106aef:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106af6:	c0 
c0106af7:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
c0106afe:	00 
c0106aff:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106b06:	e8 10 a1 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106b0b:	c7 04 24 6c 9e 10 c0 	movl   $0xc0109e6c,(%esp)
c0106b12:	e8 34 98 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106b17:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106b1c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106b1f:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106b24:	83 f8 06             	cmp    $0x6,%eax
c0106b27:	74 24                	je     c0106b4d <_fifo_check_swap+0x1d4>
c0106b29:	c7 44 24 0c 19 9f 10 	movl   $0xc0109f19,0xc(%esp)
c0106b30:	c0 
c0106b31:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106b38:	c0 
c0106b39:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0106b40:	00 
c0106b41:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106b48:	e8 ce a0 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106b4d:	c7 04 24 bc 9e 10 c0 	movl   $0xc0109ebc,(%esp)
c0106b54:	e8 f2 97 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106b59:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106b5e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106b61:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106b66:	83 f8 07             	cmp    $0x7,%eax
c0106b69:	74 24                	je     c0106b8f <_fifo_check_swap+0x216>
c0106b6b:	c7 44 24 0c 28 9f 10 	movl   $0xc0109f28,0xc(%esp)
c0106b72:	c0 
c0106b73:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106b7a:	c0 
c0106b7b:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0106b82:	00 
c0106b83:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106b8a:	e8 8c a0 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106b8f:	c7 04 24 34 9e 10 c0 	movl   $0xc0109e34,(%esp)
c0106b96:	e8 b0 97 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106b9b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106ba0:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106ba3:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106ba8:	83 f8 08             	cmp    $0x8,%eax
c0106bab:	74 24                	je     c0106bd1 <_fifo_check_swap+0x258>
c0106bad:	c7 44 24 0c 37 9f 10 	movl   $0xc0109f37,0xc(%esp)
c0106bb4:	c0 
c0106bb5:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106bbc:	c0 
c0106bbd:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106bc4:	00 
c0106bc5:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106bcc:	e8 4a a0 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106bd1:	c7 04 24 94 9e 10 c0 	movl   $0xc0109e94,(%esp)
c0106bd8:	e8 6e 97 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106bdd:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106be2:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106be5:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106bea:	83 f8 09             	cmp    $0x9,%eax
c0106bed:	74 24                	je     c0106c13 <_fifo_check_swap+0x29a>
c0106bef:	c7 44 24 0c 46 9f 10 	movl   $0xc0109f46,0xc(%esp)
c0106bf6:	c0 
c0106bf7:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106bfe:	c0 
c0106bff:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0106c06:	00 
c0106c07:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106c0e:	e8 08 a0 ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106c13:	c7 04 24 e4 9e 10 c0 	movl   $0xc0109ee4,(%esp)
c0106c1a:	e8 2c 97 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106c1f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106c24:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0106c27:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106c2c:	83 f8 0a             	cmp    $0xa,%eax
c0106c2f:	74 24                	je     c0106c55 <_fifo_check_swap+0x2dc>
c0106c31:	c7 44 24 0c 55 9f 10 	movl   $0xc0109f55,0xc(%esp)
c0106c38:	c0 
c0106c39:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106c40:	c0 
c0106c41:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0106c48:	00 
c0106c49:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106c50:	e8 c6 9f ff ff       	call   c0100c1b <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106c55:	c7 04 24 6c 9e 10 c0 	movl   $0xc0109e6c,(%esp)
c0106c5c:	e8 ea 96 ff ff       	call   c010034b <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c0106c61:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106c66:	0f b6 00             	movzbl (%eax),%eax
c0106c69:	3c 0a                	cmp    $0xa,%al
c0106c6b:	74 24                	je     c0106c91 <_fifo_check_swap+0x318>
c0106c6d:	c7 44 24 0c 68 9f 10 	movl   $0xc0109f68,0xc(%esp)
c0106c74:	c0 
c0106c75:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106c7c:	c0 
c0106c7d:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106c84:	00 
c0106c85:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106c8c:	e8 8a 9f ff ff       	call   c0100c1b <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0106c91:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106c96:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0106c99:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106c9e:	83 f8 0b             	cmp    $0xb,%eax
c0106ca1:	74 24                	je     c0106cc7 <_fifo_check_swap+0x34e>
c0106ca3:	c7 44 24 0c 89 9f 10 	movl   $0xc0109f89,0xc(%esp)
c0106caa:	c0 
c0106cab:	c7 44 24 08 f2 9d 10 	movl   $0xc0109df2,0x8(%esp)
c0106cb2:	c0 
c0106cb3:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0106cba:	00 
c0106cbb:	c7 04 24 07 9e 10 c0 	movl   $0xc0109e07,(%esp)
c0106cc2:	e8 54 9f ff ff       	call   c0100c1b <__panic>
    return 0;
c0106cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ccc:	c9                   	leave  
c0106ccd:	c3                   	ret    

c0106cce <_fifo_init>:


static int
_fifo_init(void)
{
c0106cce:	55                   	push   %ebp
c0106ccf:	89 e5                	mov    %esp,%ebp
    return 0;
c0106cd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cd6:	5d                   	pop    %ebp
c0106cd7:	c3                   	ret    

c0106cd8 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106cd8:	55                   	push   %ebp
c0106cd9:	89 e5                	mov    %esp,%ebp
    return 0;
c0106cdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106ce0:	5d                   	pop    %ebp
c0106ce1:	c3                   	ret    

c0106ce2 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0106ce2:	55                   	push   %ebp
c0106ce3:	89 e5                	mov    %esp,%ebp
c0106ce5:	b8 00 00 00 00       	mov    $0x0,%eax
c0106cea:	5d                   	pop    %ebp
c0106ceb:	c3                   	ret    

c0106cec <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106cec:	55                   	push   %ebp
c0106ced:	89 e5                	mov    %esp,%ebp
c0106cef:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0106cf5:	c1 e8 0c             	shr    $0xc,%eax
c0106cf8:	89 c2                	mov    %eax,%edx
c0106cfa:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0106cff:	39 c2                	cmp    %eax,%edx
c0106d01:	72 1c                	jb     c0106d1f <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106d03:	c7 44 24 08 ac 9f 10 	movl   $0xc0109fac,0x8(%esp)
c0106d0a:	c0 
c0106d0b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106d12:	00 
c0106d13:	c7 04 24 cb 9f 10 c0 	movl   $0xc0109fcb,(%esp)
c0106d1a:	e8 fc 9e ff ff       	call   c0100c1b <__panic>
    }
    return &pages[PPN(pa)];
c0106d1f:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0106d24:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d27:	c1 ea 0c             	shr    $0xc,%edx
c0106d2a:	c1 e2 05             	shl    $0x5,%edx
c0106d2d:	01 d0                	add    %edx,%eax
}
c0106d2f:	c9                   	leave  
c0106d30:	c3                   	ret    

c0106d31 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0106d31:	55                   	push   %ebp
c0106d32:	89 e5                	mov    %esp,%ebp
c0106d34:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106d3f:	89 04 24             	mov    %eax,(%esp)
c0106d42:	e8 a5 ff ff ff       	call   c0106cec <pa2page>
}
c0106d47:	c9                   	leave  
c0106d48:	c3                   	ret    

c0106d49 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0106d49:	55                   	push   %ebp
c0106d4a:	89 e5                	mov    %esp,%ebp
c0106d4c:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0106d4f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0106d56:	e8 e3 ed ff ff       	call   c0105b3e <kmalloc>
c0106d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0106d5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d62:	74 58                	je     c0106dbc <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0106d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106d70:	89 50 04             	mov    %edx,0x4(%eax)
c0106d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d76:	8b 50 04             	mov    0x4(%eax),%edx
c0106d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d7c:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0106d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0106d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0106d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d95:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0106d9c:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0106da1:	85 c0                	test   %eax,%eax
c0106da3:	74 0d                	je     c0106db2 <mm_create+0x69>
c0106da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106da8:	89 04 24             	mov    %eax,(%esp)
c0106dab:	e8 db ef ff ff       	call   c0105d8b <swap_init_mm>
c0106db0:	eb 0a                	jmp    c0106dbc <mm_create+0x73>
        else mm->sm_priv = NULL;
c0106db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106db5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0106dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106dbf:	c9                   	leave  
c0106dc0:	c3                   	ret    

c0106dc1 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0106dc1:	55                   	push   %ebp
c0106dc2:	89 e5                	mov    %esp,%ebp
c0106dc4:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0106dc7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0106dce:	e8 6b ed ff ff       	call   c0105b3e <kmalloc>
c0106dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0106dd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106dda:	74 1b                	je     c0106df7 <vma_create+0x36>
        vma->vm_start = vm_start;
c0106ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ddf:	8b 55 08             	mov    0x8(%ebp),%edx
c0106de2:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0106de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106deb:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0106dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106df1:	8b 55 10             	mov    0x10(%ebp),%edx
c0106df4:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0106df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106dfa:	c9                   	leave  
c0106dfb:	c3                   	ret    

c0106dfc <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0106dfc:	55                   	push   %ebp
c0106dfd:	89 e5                	mov    %esp,%ebp
c0106dff:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0106e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0106e09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106e0d:	0f 84 95 00 00 00    	je     c0106ea8 <find_vma+0xac>
        vma = mm->mmap_cache;
c0106e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e16:	8b 40 08             	mov    0x8(%eax),%eax
c0106e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0106e1c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106e20:	74 16                	je     c0106e38 <find_vma+0x3c>
c0106e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e25:	8b 40 04             	mov    0x4(%eax),%eax
c0106e28:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106e2b:	77 0b                	ja     c0106e38 <find_vma+0x3c>
c0106e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e30:	8b 40 08             	mov    0x8(%eax),%eax
c0106e33:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106e36:	77 61                	ja     c0106e99 <find_vma+0x9d>
                bool found = 0;
c0106e38:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0106e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0106e4b:	eb 28                	jmp    c0106e75 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0106e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e50:	83 e8 10             	sub    $0x10,%eax
c0106e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0106e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e59:	8b 40 04             	mov    0x4(%eax),%eax
c0106e5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106e5f:	77 14                	ja     c0106e75 <find_vma+0x79>
c0106e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106e64:	8b 40 08             	mov    0x8(%eax),%eax
c0106e67:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106e6a:	76 09                	jbe    c0106e75 <find_vma+0x79>
                        found = 1;
c0106e6c:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0106e73:	eb 17                	jmp    c0106e8c <find_vma+0x90>
c0106e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e78:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106e7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e7e:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0106e81:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e87:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106e8a:	75 c1                	jne    c0106e4d <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0106e8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0106e90:	75 07                	jne    c0106e99 <find_vma+0x9d>
                    vma = NULL;
c0106e92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0106e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0106e9d:	74 09                	je     c0106ea8 <find_vma+0xac>
            mm->mmap_cache = vma;
c0106e9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ea2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106ea5:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0106ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0106eab:	c9                   	leave  
c0106eac:	c3                   	ret    

c0106ead <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0106ead:	55                   	push   %ebp
c0106eae:	89 e5                	mov    %esp,%ebp
c0106eb0:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0106eb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106eb6:	8b 50 04             	mov    0x4(%eax),%edx
c0106eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ebc:	8b 40 08             	mov    0x8(%eax),%eax
c0106ebf:	39 c2                	cmp    %eax,%edx
c0106ec1:	72 24                	jb     c0106ee7 <check_vma_overlap+0x3a>
c0106ec3:	c7 44 24 0c d9 9f 10 	movl   $0xc0109fd9,0xc(%esp)
c0106eca:	c0 
c0106ecb:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0106ed2:	c0 
c0106ed3:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106eda:	00 
c0106edb:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0106ee2:	e8 34 9d ff ff       	call   c0100c1b <__panic>
    assert(prev->vm_end <= next->vm_start);
c0106ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0106eea:	8b 50 08             	mov    0x8(%eax),%edx
c0106eed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ef0:	8b 40 04             	mov    0x4(%eax),%eax
c0106ef3:	39 c2                	cmp    %eax,%edx
c0106ef5:	76 24                	jbe    c0106f1b <check_vma_overlap+0x6e>
c0106ef7:	c7 44 24 0c 1c a0 10 	movl   $0xc010a01c,0xc(%esp)
c0106efe:	c0 
c0106eff:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0106f06:	c0 
c0106f07:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0106f0e:	00 
c0106f0f:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0106f16:	e8 00 9d ff ff       	call   c0100c1b <__panic>
    assert(next->vm_start < next->vm_end);
c0106f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f1e:	8b 50 04             	mov    0x4(%eax),%edx
c0106f21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f24:	8b 40 08             	mov    0x8(%eax),%eax
c0106f27:	39 c2                	cmp    %eax,%edx
c0106f29:	72 24                	jb     c0106f4f <check_vma_overlap+0xa2>
c0106f2b:	c7 44 24 0c 3b a0 10 	movl   $0xc010a03b,0xc(%esp)
c0106f32:	c0 
c0106f33:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0106f3a:	c0 
c0106f3b:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0106f42:	00 
c0106f43:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0106f4a:	e8 cc 9c ff ff       	call   c0100c1b <__panic>
}
c0106f4f:	c9                   	leave  
c0106f50:	c3                   	ret    

c0106f51 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0106f51:	55                   	push   %ebp
c0106f52:	89 e5                	mov    %esp,%ebp
c0106f54:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0106f57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f5a:	8b 50 04             	mov    0x4(%eax),%edx
c0106f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f60:	8b 40 08             	mov    0x8(%eax),%eax
c0106f63:	39 c2                	cmp    %eax,%edx
c0106f65:	72 24                	jb     c0106f8b <insert_vma_struct+0x3a>
c0106f67:	c7 44 24 0c 59 a0 10 	movl   $0xc010a059,0xc(%esp)
c0106f6e:	c0 
c0106f6f:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0106f76:	c0 
c0106f77:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106f7e:	00 
c0106f7f:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0106f86:	e8 90 9c ff ff       	call   c0100c1b <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0106f91:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f94:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0106f97:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0106f9d:	eb 21                	jmp    c0106fc0 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0106f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fa2:	83 e8 10             	sub    $0x10,%eax
c0106fa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0106fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106fab:	8b 50 04             	mov    0x4(%eax),%edx
c0106fae:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106fb1:	8b 40 04             	mov    0x4(%eax),%eax
c0106fb4:	39 c2                	cmp    %eax,%edx
c0106fb6:	76 02                	jbe    c0106fba <insert_vma_struct+0x69>
                break;
c0106fb8:	eb 1d                	jmp    c0106fd7 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0106fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106fc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106fc9:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0106fcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106fd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106fd5:	75 c8                	jne    c0106f9f <insert_vma_struct+0x4e>
c0106fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106fda:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0106fdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106fe0:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0106fe3:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0106fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106fe9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106fec:	74 15                	je     c0107003 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0106fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ff1:	8d 50 f0             	lea    -0x10(%eax),%edx
c0106ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ffb:	89 14 24             	mov    %edx,(%esp)
c0106ffe:	e8 aa fe ff ff       	call   c0106ead <check_vma_overlap>
    }
    if (le_next != list) {
c0107003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107006:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107009:	74 15                	je     c0107020 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010700b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010700e:	83 e8 10             	sub    $0x10,%eax
c0107011:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107015:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107018:	89 04 24             	mov    %eax,(%esp)
c010701b:	e8 8d fe ff ff       	call   c0106ead <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107020:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107023:	8b 55 08             	mov    0x8(%ebp),%edx
c0107026:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107028:	8b 45 0c             	mov    0xc(%ebp),%eax
c010702b:	8d 50 10             	lea    0x10(%eax),%edx
c010702e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107031:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107034:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107037:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010703a:	8b 40 04             	mov    0x4(%eax),%eax
c010703d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107040:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107043:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107046:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107049:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010704c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010704f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107052:	89 10                	mov    %edx,(%eax)
c0107054:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107057:	8b 10                	mov    (%eax),%edx
c0107059:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010705c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010705f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107062:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107065:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107068:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010706b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010706e:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107070:	8b 45 08             	mov    0x8(%ebp),%eax
c0107073:	8b 40 10             	mov    0x10(%eax),%eax
c0107076:	8d 50 01             	lea    0x1(%eax),%edx
c0107079:	8b 45 08             	mov    0x8(%ebp),%eax
c010707c:	89 50 10             	mov    %edx,0x10(%eax)
}
c010707f:	c9                   	leave  
c0107080:	c3                   	ret    

c0107081 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107081:	55                   	push   %ebp
c0107082:	89 e5                	mov    %esp,%ebp
c0107084:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107087:	8b 45 08             	mov    0x8(%ebp),%eax
c010708a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010708d:	eb 3e                	jmp    c01070cd <mm_destroy+0x4c>
c010708f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107092:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107095:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107098:	8b 40 04             	mov    0x4(%eax),%eax
c010709b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010709e:	8b 12                	mov    (%edx),%edx
c01070a0:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01070a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01070a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01070a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01070ac:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01070af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01070b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01070b5:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c01070b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070ba:	83 e8 10             	sub    $0x10,%eax
c01070bd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01070c4:	00 
c01070c5:	89 04 24             	mov    %eax,(%esp)
c01070c8:	e8 11 eb ff ff       	call   c0105bde <kfree>
c01070cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01070d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01070d6:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01070d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01070dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01070e2:	75 ab                	jne    c010708f <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01070e4:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01070eb:	00 
c01070ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01070ef:	89 04 24             	mov    %eax,(%esp)
c01070f2:	e8 e7 ea ff ff       	call   c0105bde <kfree>
    mm=NULL;
c01070f7:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01070fe:	c9                   	leave  
c01070ff:	c3                   	ret    

c0107100 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107100:	55                   	push   %ebp
c0107101:	89 e5                	mov    %esp,%ebp
c0107103:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107106:	e8 02 00 00 00       	call   c010710d <check_vmm>
}
c010710b:	c9                   	leave  
c010710c:	c3                   	ret    

c010710d <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010710d:	55                   	push   %ebp
c010710e:	89 e5                	mov    %esp,%ebp
c0107110:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107113:	e8 25 d4 ff ff       	call   c010453d <nr_free_pages>
c0107118:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c010711b:	e8 41 00 00 00       	call   c0107161 <check_vma_struct>
    check_pgfault();
c0107120:	e8 03 05 00 00       	call   c0107628 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c0107125:	e8 13 d4 ff ff       	call   c010453d <nr_free_pages>
c010712a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010712d:	74 24                	je     c0107153 <check_vmm+0x46>
c010712f:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c0107136:	c0 
c0107137:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c010713e:	c0 
c010713f:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0107146:	00 
c0107147:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c010714e:	e8 c8 9a ff ff       	call   c0100c1b <__panic>

    cprintf("check_vmm() succeeded.\n");
c0107153:	c7 04 24 9f a0 10 c0 	movl   $0xc010a09f,(%esp)
c010715a:	e8 ec 91 ff ff       	call   c010034b <cprintf>
}
c010715f:	c9                   	leave  
c0107160:	c3                   	ret    

c0107161 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107161:	55                   	push   %ebp
c0107162:	89 e5                	mov    %esp,%ebp
c0107164:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107167:	e8 d1 d3 ff ff       	call   c010453d <nr_free_pages>
c010716c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010716f:	e8 d5 fb ff ff       	call   c0106d49 <mm_create>
c0107174:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107177:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010717b:	75 24                	jne    c01071a1 <check_vma_struct+0x40>
c010717d:	c7 44 24 0c b7 a0 10 	movl   $0xc010a0b7,0xc(%esp)
c0107184:	c0 
c0107185:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c010718c:	c0 
c010718d:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107194:	00 
c0107195:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c010719c:	e8 7a 9a ff ff       	call   c0100c1b <__panic>

    int step1 = 10, step2 = step1 * 10;
c01071a1:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01071a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01071ab:	89 d0                	mov    %edx,%eax
c01071ad:	c1 e0 02             	shl    $0x2,%eax
c01071b0:	01 d0                	add    %edx,%eax
c01071b2:	01 c0                	add    %eax,%eax
c01071b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01071b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01071ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01071bd:	eb 70                	jmp    c010722f <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01071bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01071c2:	89 d0                	mov    %edx,%eax
c01071c4:	c1 e0 02             	shl    $0x2,%eax
c01071c7:	01 d0                	add    %edx,%eax
c01071c9:	83 c0 02             	add    $0x2,%eax
c01071cc:	89 c1                	mov    %eax,%ecx
c01071ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01071d1:	89 d0                	mov    %edx,%eax
c01071d3:	c1 e0 02             	shl    $0x2,%eax
c01071d6:	01 d0                	add    %edx,%eax
c01071d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01071df:	00 
c01071e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01071e4:	89 04 24             	mov    %eax,(%esp)
c01071e7:	e8 d5 fb ff ff       	call   c0106dc1 <vma_create>
c01071ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01071ef:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01071f3:	75 24                	jne    c0107219 <check_vma_struct+0xb8>
c01071f5:	c7 44 24 0c c2 a0 10 	movl   $0xc010a0c2,0xc(%esp)
c01071fc:	c0 
c01071fd:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107204:	c0 
c0107205:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010720c:	00 
c010720d:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107214:	e8 02 9a ff ff       	call   c0100c1b <__panic>
        insert_vma_struct(mm, vma);
c0107219:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010721c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107220:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107223:	89 04 24             	mov    %eax,(%esp)
c0107226:	e8 26 fd ff ff       	call   c0106f51 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c010722b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010722f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107233:	7f 8a                	jg     c01071bf <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107235:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107238:	83 c0 01             	add    $0x1,%eax
c010723b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010723e:	eb 70                	jmp    c01072b0 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107240:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107243:	89 d0                	mov    %edx,%eax
c0107245:	c1 e0 02             	shl    $0x2,%eax
c0107248:	01 d0                	add    %edx,%eax
c010724a:	83 c0 02             	add    $0x2,%eax
c010724d:	89 c1                	mov    %eax,%ecx
c010724f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107252:	89 d0                	mov    %edx,%eax
c0107254:	c1 e0 02             	shl    $0x2,%eax
c0107257:	01 d0                	add    %edx,%eax
c0107259:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107260:	00 
c0107261:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107265:	89 04 24             	mov    %eax,(%esp)
c0107268:	e8 54 fb ff ff       	call   c0106dc1 <vma_create>
c010726d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107270:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107274:	75 24                	jne    c010729a <check_vma_struct+0x139>
c0107276:	c7 44 24 0c c2 a0 10 	movl   $0xc010a0c2,0xc(%esp)
c010727d:	c0 
c010727e:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107285:	c0 
c0107286:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010728d:	00 
c010728e:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107295:	e8 81 99 ff ff       	call   c0100c1b <__panic>
        insert_vma_struct(mm, vma);
c010729a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010729d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072a4:	89 04 24             	mov    %eax,(%esp)
c01072a7:	e8 a5 fc ff ff       	call   c0106f51 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01072ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01072b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01072b6:	7e 88                	jle    c0107240 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01072b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072bb:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01072be:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01072c1:	8b 40 04             	mov    0x4(%eax),%eax
c01072c4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01072c7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01072ce:	e9 97 00 00 00       	jmp    c010736a <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c01072d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01072d9:	75 24                	jne    c01072ff <check_vma_struct+0x19e>
c01072db:	c7 44 24 0c ce a0 10 	movl   $0xc010a0ce,0xc(%esp)
c01072e2:	c0 
c01072e3:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01072ea:	c0 
c01072eb:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01072f2:	00 
c01072f3:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01072fa:	e8 1c 99 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01072ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107302:	83 e8 10             	sub    $0x10,%eax
c0107305:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010730b:	8b 48 04             	mov    0x4(%eax),%ecx
c010730e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107311:	89 d0                	mov    %edx,%eax
c0107313:	c1 e0 02             	shl    $0x2,%eax
c0107316:	01 d0                	add    %edx,%eax
c0107318:	39 c1                	cmp    %eax,%ecx
c010731a:	75 17                	jne    c0107333 <check_vma_struct+0x1d2>
c010731c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010731f:	8b 48 08             	mov    0x8(%eax),%ecx
c0107322:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107325:	89 d0                	mov    %edx,%eax
c0107327:	c1 e0 02             	shl    $0x2,%eax
c010732a:	01 d0                	add    %edx,%eax
c010732c:	83 c0 02             	add    $0x2,%eax
c010732f:	39 c1                	cmp    %eax,%ecx
c0107331:	74 24                	je     c0107357 <check_vma_struct+0x1f6>
c0107333:	c7 44 24 0c e8 a0 10 	movl   $0xc010a0e8,0xc(%esp)
c010733a:	c0 
c010733b:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107342:	c0 
c0107343:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010734a:	00 
c010734b:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107352:	e8 c4 98 ff ff       	call   c0100c1b <__panic>
c0107357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010735a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010735d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107360:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107363:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107366:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010736a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010736d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107370:	0f 8e 5d ff ff ff    	jle    c01072d3 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107376:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c010737d:	e9 cd 01 00 00       	jmp    c010754f <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107382:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107385:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107389:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010738c:	89 04 24             	mov    %eax,(%esp)
c010738f:	e8 68 fa ff ff       	call   c0106dfc <find_vma>
c0107394:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107397:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010739b:	75 24                	jne    c01073c1 <check_vma_struct+0x260>
c010739d:	c7 44 24 0c 1d a1 10 	movl   $0xc010a11d,0xc(%esp)
c01073a4:	c0 
c01073a5:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01073ac:	c0 
c01073ad:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01073b4:	00 
c01073b5:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01073bc:	e8 5a 98 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01073c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073c4:	83 c0 01             	add    $0x1,%eax
c01073c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01073cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073ce:	89 04 24             	mov    %eax,(%esp)
c01073d1:	e8 26 fa ff ff       	call   c0106dfc <find_vma>
c01073d6:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01073d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01073dd:	75 24                	jne    c0107403 <check_vma_struct+0x2a2>
c01073df:	c7 44 24 0c 2a a1 10 	movl   $0xc010a12a,0xc(%esp)
c01073e6:	c0 
c01073e7:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01073ee:	c0 
c01073ef:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01073f6:	00 
c01073f7:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01073fe:	e8 18 98 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107403:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107406:	83 c0 02             	add    $0x2,%eax
c0107409:	89 44 24 04          	mov    %eax,0x4(%esp)
c010740d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107410:	89 04 24             	mov    %eax,(%esp)
c0107413:	e8 e4 f9 ff ff       	call   c0106dfc <find_vma>
c0107418:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010741b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010741f:	74 24                	je     c0107445 <check_vma_struct+0x2e4>
c0107421:	c7 44 24 0c 37 a1 10 	movl   $0xc010a137,0xc(%esp)
c0107428:	c0 
c0107429:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107430:	c0 
c0107431:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0107438:	00 
c0107439:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107440:	e8 d6 97 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107445:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107448:	83 c0 03             	add    $0x3,%eax
c010744b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010744f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107452:	89 04 24             	mov    %eax,(%esp)
c0107455:	e8 a2 f9 ff ff       	call   c0106dfc <find_vma>
c010745a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c010745d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107461:	74 24                	je     c0107487 <check_vma_struct+0x326>
c0107463:	c7 44 24 0c 44 a1 10 	movl   $0xc010a144,0xc(%esp)
c010746a:	c0 
c010746b:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107472:	c0 
c0107473:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010747a:	00 
c010747b:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107482:	e8 94 97 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107487:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010748a:	83 c0 04             	add    $0x4,%eax
c010748d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107491:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107494:	89 04 24             	mov    %eax,(%esp)
c0107497:	e8 60 f9 ff ff       	call   c0106dfc <find_vma>
c010749c:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010749f:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01074a3:	74 24                	je     c01074c9 <check_vma_struct+0x368>
c01074a5:	c7 44 24 0c 51 a1 10 	movl   $0xc010a151,0xc(%esp)
c01074ac:	c0 
c01074ad:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01074b4:	c0 
c01074b5:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01074bc:	00 
c01074bd:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01074c4:	e8 52 97 ff ff       	call   c0100c1b <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01074c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074cc:	8b 50 04             	mov    0x4(%eax),%edx
c01074cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074d2:	39 c2                	cmp    %eax,%edx
c01074d4:	75 10                	jne    c01074e6 <check_vma_struct+0x385>
c01074d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01074d9:	8b 50 08             	mov    0x8(%eax),%edx
c01074dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01074df:	83 c0 02             	add    $0x2,%eax
c01074e2:	39 c2                	cmp    %eax,%edx
c01074e4:	74 24                	je     c010750a <check_vma_struct+0x3a9>
c01074e6:	c7 44 24 0c 60 a1 10 	movl   $0xc010a160,0xc(%esp)
c01074ed:	c0 
c01074ee:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01074f5:	c0 
c01074f6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01074fd:	00 
c01074fe:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107505:	e8 11 97 ff ff       	call   c0100c1b <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010750a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010750d:	8b 50 04             	mov    0x4(%eax),%edx
c0107510:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107513:	39 c2                	cmp    %eax,%edx
c0107515:	75 10                	jne    c0107527 <check_vma_struct+0x3c6>
c0107517:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010751a:	8b 50 08             	mov    0x8(%eax),%edx
c010751d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107520:	83 c0 02             	add    $0x2,%eax
c0107523:	39 c2                	cmp    %eax,%edx
c0107525:	74 24                	je     c010754b <check_vma_struct+0x3ea>
c0107527:	c7 44 24 0c 90 a1 10 	movl   $0xc010a190,0xc(%esp)
c010752e:	c0 
c010752f:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107536:	c0 
c0107537:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010753e:	00 
c010753f:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107546:	e8 d0 96 ff ff       	call   c0100c1b <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010754b:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010754f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107552:	89 d0                	mov    %edx,%eax
c0107554:	c1 e0 02             	shl    $0x2,%eax
c0107557:	01 d0                	add    %edx,%eax
c0107559:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010755c:	0f 8d 20 fe ff ff    	jge    c0107382 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107562:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107569:	eb 70                	jmp    c01075db <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c010756b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010756e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107572:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107575:	89 04 24             	mov    %eax,(%esp)
c0107578:	e8 7f f8 ff ff       	call   c0106dfc <find_vma>
c010757d:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107580:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107584:	74 27                	je     c01075ad <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107586:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107589:	8b 50 08             	mov    0x8(%eax),%edx
c010758c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010758f:	8b 40 04             	mov    0x4(%eax),%eax
c0107592:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107596:	89 44 24 08          	mov    %eax,0x8(%esp)
c010759a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010759d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075a1:	c7 04 24 c0 a1 10 c0 	movl   $0xc010a1c0,(%esp)
c01075a8:	e8 9e 8d ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c01075ad:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01075b1:	74 24                	je     c01075d7 <check_vma_struct+0x476>
c01075b3:	c7 44 24 0c e5 a1 10 	movl   $0xc010a1e5,0xc(%esp)
c01075ba:	c0 
c01075bb:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01075c2:	c0 
c01075c3:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01075ca:	00 
c01075cb:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01075d2:	e8 44 96 ff ff       	call   c0100c1b <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01075d7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01075db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01075df:	79 8a                	jns    c010756b <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01075e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01075e4:	89 04 24             	mov    %eax,(%esp)
c01075e7:	e8 95 fa ff ff       	call   c0107081 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01075ec:	e8 4c cf ff ff       	call   c010453d <nr_free_pages>
c01075f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01075f4:	74 24                	je     c010761a <check_vma_struct+0x4b9>
c01075f6:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c01075fd:	c0 
c01075fe:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107605:	c0 
c0107606:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010760d:	00 
c010760e:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107615:	e8 01 96 ff ff       	call   c0100c1b <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c010761a:	c7 04 24 fc a1 10 c0 	movl   $0xc010a1fc,(%esp)
c0107621:	e8 25 8d ff ff       	call   c010034b <cprintf>
}
c0107626:	c9                   	leave  
c0107627:	c3                   	ret    

c0107628 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107628:	55                   	push   %ebp
c0107629:	89 e5                	mov    %esp,%ebp
c010762b:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010762e:	e8 0a cf ff ff       	call   c010453d <nr_free_pages>
c0107633:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107636:	e8 0e f7 ff ff       	call   c0106d49 <mm_create>
c010763b:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac
    assert(check_mm_struct != NULL);
c0107640:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0107645:	85 c0                	test   %eax,%eax
c0107647:	75 24                	jne    c010766d <check_pgfault+0x45>
c0107649:	c7 44 24 0c 1b a2 10 	movl   $0xc010a21b,0xc(%esp)
c0107650:	c0 
c0107651:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c0107658:	c0 
c0107659:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107660:	00 
c0107661:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c0107668:	e8 ae 95 ff ff       	call   c0100c1b <__panic>

    struct mm_struct *mm = check_mm_struct;
c010766d:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0107672:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107675:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c010767b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010767e:	89 50 0c             	mov    %edx,0xc(%eax)
c0107681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107684:	8b 40 0c             	mov    0xc(%eax),%eax
c0107687:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010768a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010768d:	8b 00                	mov    (%eax),%eax
c010768f:	85 c0                	test   %eax,%eax
c0107691:	74 24                	je     c01076b7 <check_pgfault+0x8f>
c0107693:	c7 44 24 0c 33 a2 10 	movl   $0xc010a233,0xc(%esp)
c010769a:	c0 
c010769b:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01076a2:	c0 
c01076a3:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01076aa:	00 
c01076ab:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01076b2:	e8 64 95 ff ff       	call   c0100c1b <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01076b7:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01076be:	00 
c01076bf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01076c6:	00 
c01076c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01076ce:	e8 ee f6 ff ff       	call   c0106dc1 <vma_create>
c01076d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01076d6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01076da:	75 24                	jne    c0107700 <check_pgfault+0xd8>
c01076dc:	c7 44 24 0c c2 a0 10 	movl   $0xc010a0c2,0xc(%esp)
c01076e3:	c0 
c01076e4:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01076eb:	c0 
c01076ec:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01076f3:	00 
c01076f4:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01076fb:	e8 1b 95 ff ff       	call   c0100c1b <__panic>

    insert_vma_struct(mm, vma);
c0107700:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107703:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107707:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010770a:	89 04 24             	mov    %eax,(%esp)
c010770d:	e8 3f f8 ff ff       	call   c0106f51 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107712:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107719:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010771c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107720:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107723:	89 04 24             	mov    %eax,(%esp)
c0107726:	e8 d1 f6 ff ff       	call   c0106dfc <find_vma>
c010772b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010772e:	74 24                	je     c0107754 <check_pgfault+0x12c>
c0107730:	c7 44 24 0c 41 a2 10 	movl   $0xc010a241,0xc(%esp)
c0107737:	c0 
c0107738:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c010773f:	c0 
c0107740:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107747:	00 
c0107748:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c010774f:	e8 c7 94 ff ff       	call   c0100c1b <__panic>

    int i, sum = 0;
c0107754:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c010775b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107762:	eb 17                	jmp    c010777b <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107764:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107767:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010776a:	01 d0                	add    %edx,%eax
c010776c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010776f:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107774:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107777:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010777b:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010777f:	7e e3                	jle    c0107764 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107781:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107788:	eb 15                	jmp    c010779f <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c010778a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010778d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107790:	01 d0                	add    %edx,%eax
c0107792:	0f b6 00             	movzbl (%eax),%eax
c0107795:	0f be c0             	movsbl %al,%eax
c0107798:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010779b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010779f:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01077a3:	7e e5                	jle    c010778a <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01077a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01077a9:	74 24                	je     c01077cf <check_pgfault+0x1a7>
c01077ab:	c7 44 24 0c 5b a2 10 	movl   $0xc010a25b,0xc(%esp)
c01077b2:	c0 
c01077b3:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c01077ba:	c0 
c01077bb:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01077c2:	00 
c01077c3:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c01077ca:	e8 4c 94 ff ff       	call   c0100c1b <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01077cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01077d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01077d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01077dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077e4:	89 04 24             	mov    %eax,(%esp)
c01077e7:	e8 79 d4 ff ff       	call   c0104c65 <page_remove>
    free_page(pde2page(pgdir[0]));
c01077ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077ef:	8b 00                	mov    (%eax),%eax
c01077f1:	89 04 24             	mov    %eax,(%esp)
c01077f4:	e8 38 f5 ff ff       	call   c0106d31 <pde2page>
c01077f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107800:	00 
c0107801:	89 04 24             	mov    %eax,(%esp)
c0107804:	e8 02 cd ff ff       	call   c010450b <free_pages>
    pgdir[0] = 0;
c0107809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010780c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107812:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107815:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010781c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010781f:	89 04 24             	mov    %eax,(%esp)
c0107822:	e8 5a f8 ff ff       	call   c0107081 <mm_destroy>
    check_mm_struct = NULL;
c0107827:	c7 05 ac 0b 12 c0 00 	movl   $0x0,0xc0120bac
c010782e:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107831:	e8 07 cd ff ff       	call   c010453d <nr_free_pages>
c0107836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107839:	74 24                	je     c010785f <check_pgfault+0x237>
c010783b:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c0107842:	c0 
c0107843:	c7 44 24 08 f7 9f 10 	movl   $0xc0109ff7,0x8(%esp)
c010784a:	c0 
c010784b:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107852:	00 
c0107853:	c7 04 24 0c a0 10 c0 	movl   $0xc010a00c,(%esp)
c010785a:	e8 bc 93 ff ff       	call   c0100c1b <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010785f:	c7 04 24 64 a2 10 c0 	movl   $0xc010a264,(%esp)
c0107866:	e8 e0 8a ff ff       	call   c010034b <cprintf>
}
c010786b:	c9                   	leave  
c010786c:	c3                   	ret    

c010786d <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010786d:	55                   	push   %ebp
c010786e:	89 e5                	mov    %esp,%ebp
c0107870:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107873:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010787a:	8b 45 10             	mov    0x10(%ebp),%eax
c010787d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107881:	8b 45 08             	mov    0x8(%ebp),%eax
c0107884:	89 04 24             	mov    %eax,(%esp)
c0107887:	e8 70 f5 ff ff       	call   c0106dfc <find_vma>
c010788c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    pgfault_num++;
c010788f:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0107894:	83 c0 01             	add    $0x1,%eax
c0107897:	a3 b8 0a 12 c0       	mov    %eax,0xc0120ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010789c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01078a0:	74 0b                	je     c01078ad <do_pgfault+0x40>
c01078a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078a5:	8b 40 04             	mov    0x4(%eax),%eax
c01078a8:	3b 45 10             	cmp    0x10(%ebp),%eax
c01078ab:	76 18                	jbe    c01078c5 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01078ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01078b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078b4:	c7 04 24 80 a2 10 c0 	movl   $0xc010a280,(%esp)
c01078bb:	e8 8b 8a ff ff       	call   c010034b <cprintf>
        goto failed;
c01078c0:	e9 93 00 00 00       	jmp    c0107958 <do_pgfault+0xeb>
    }
    //check the error_code
    switch (error_code & 3) {
c01078c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078c8:	83 e0 03             	and    $0x3,%eax
c01078cb:	85 c0                	test   %eax,%eax
c01078cd:	74 30                	je     c01078ff <do_pgfault+0x92>
c01078cf:	83 f8 01             	cmp    $0x1,%eax
c01078d2:	74 1d                	je     c01078f1 <do_pgfault+0x84>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01078d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078d7:	8b 40 0c             	mov    0xc(%eax),%eax
c01078da:	83 e0 02             	and    $0x2,%eax
c01078dd:	85 c0                	test   %eax,%eax
c01078df:	75 0e                	jne    c01078ef <do_pgfault+0x82>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01078e1:	c7 04 24 b0 a2 10 c0 	movl   $0xc010a2b0,(%esp)
c01078e8:	e8 5e 8a ff ff       	call   c010034b <cprintf>
            goto failed;
c01078ed:	eb 69                	jmp    c0107958 <do_pgfault+0xeb>
        }
        break;
c01078ef:	eb 29                	jmp    c010791a <do_pgfault+0xad>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c01078f1:	c7 04 24 10 a3 10 c0 	movl   $0xc010a310,(%esp)
c01078f8:	e8 4e 8a ff ff       	call   c010034b <cprintf>
        goto failed;
c01078fd:	eb 59                	jmp    c0107958 <do_pgfault+0xeb>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c01078ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107902:	8b 40 0c             	mov    0xc(%eax),%eax
c0107905:	83 e0 05             	and    $0x5,%eax
c0107908:	85 c0                	test   %eax,%eax
c010790a:	75 0e                	jne    c010791a <do_pgfault+0xad>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c010790c:	c7 04 24 48 a3 10 c0 	movl   $0xc010a348,(%esp)
c0107913:	e8 33 8a ff ff       	call   c010034b <cprintf>
            goto failed;
c0107918:	eb 3e                	jmp    c0107958 <do_pgfault+0xeb>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c010791a:	c7 45 ec 04 00 00 00 	movl   $0x4,-0x14(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107921:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107924:	8b 40 0c             	mov    0xc(%eax),%eax
c0107927:	83 e0 02             	and    $0x2,%eax
c010792a:	85 c0                	test   %eax,%eax
c010792c:	74 04                	je     c0107932 <do_pgfault+0xc5>
        perm |= PTE_W;
c010792e:	83 4d ec 02          	orl    $0x2,-0x14(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107932:	8b 45 10             	mov    0x10(%ebp),%eax
c0107935:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107938:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010793b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107940:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107943:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c010794a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
   ret = 0;
c0107951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107958:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010795b:	c9                   	leave  
c010795c:	c3                   	ret    

c010795d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010795d:	55                   	push   %ebp
c010795e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107960:	8b 55 08             	mov    0x8(%ebp),%edx
c0107963:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0107968:	29 c2                	sub    %eax,%edx
c010796a:	89 d0                	mov    %edx,%eax
c010796c:	c1 f8 05             	sar    $0x5,%eax
}
c010796f:	5d                   	pop    %ebp
c0107970:	c3                   	ret    

c0107971 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107971:	55                   	push   %ebp
c0107972:	89 e5                	mov    %esp,%ebp
c0107974:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107977:	8b 45 08             	mov    0x8(%ebp),%eax
c010797a:	89 04 24             	mov    %eax,(%esp)
c010797d:	e8 db ff ff ff       	call   c010795d <page2ppn>
c0107982:	c1 e0 0c             	shl    $0xc,%eax
}
c0107985:	c9                   	leave  
c0107986:	c3                   	ret    

c0107987 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107987:	55                   	push   %ebp
c0107988:	89 e5                	mov    %esp,%ebp
c010798a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010798d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107990:	89 04 24             	mov    %eax,(%esp)
c0107993:	e8 d9 ff ff ff       	call   c0107971 <page2pa>
c0107998:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010799b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010799e:	c1 e8 0c             	shr    $0xc,%eax
c01079a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079a4:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01079a9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01079ac:	72 23                	jb     c01079d1 <page2kva+0x4a>
c01079ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01079b5:	c7 44 24 08 ac a3 10 	movl   $0xc010a3ac,0x8(%esp)
c01079bc:	c0 
c01079bd:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01079c4:	00 
c01079c5:	c7 04 24 cf a3 10 c0 	movl   $0xc010a3cf,(%esp)
c01079cc:	e8 4a 92 ff ff       	call   c0100c1b <__panic>
c01079d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079d4:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01079d9:	c9                   	leave  
c01079da:	c3                   	ret    

c01079db <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01079db:	55                   	push   %ebp
c01079dc:	89 e5                	mov    %esp,%ebp
c01079de:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01079e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01079e8:	e8 7e 9f ff ff       	call   c010196b <ide_device_valid>
c01079ed:	85 c0                	test   %eax,%eax
c01079ef:	75 1c                	jne    c0107a0d <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01079f1:	c7 44 24 08 dd a3 10 	movl   $0xc010a3dd,0x8(%esp)
c01079f8:	c0 
c01079f9:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107a00:	00 
c0107a01:	c7 04 24 f7 a3 10 c0 	movl   $0xc010a3f7,(%esp)
c0107a08:	e8 0e 92 ff ff       	call   c0100c1b <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107a0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107a14:	e8 91 9f ff ff       	call   c01019aa <ide_device_size>
c0107a19:	c1 e8 03             	shr    $0x3,%eax
c0107a1c:	a3 7c 0b 12 c0       	mov    %eax,0xc0120b7c
}
c0107a21:	c9                   	leave  
c0107a22:	c3                   	ret    

c0107a23 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107a23:	55                   	push   %ebp
c0107a24:	89 e5                	mov    %esp,%ebp
c0107a26:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107a29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a2c:	89 04 24             	mov    %eax,(%esp)
c0107a2f:	e8 53 ff ff ff       	call   c0107987 <page2kva>
c0107a34:	8b 55 08             	mov    0x8(%ebp),%edx
c0107a37:	c1 ea 08             	shr    $0x8,%edx
c0107a3a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a41:	74 0b                	je     c0107a4e <swapfs_read+0x2b>
c0107a43:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107a49:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107a4c:	72 23                	jb     c0107a71 <swapfs_read+0x4e>
c0107a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a51:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107a55:	c7 44 24 08 08 a4 10 	movl   $0xc010a408,0x8(%esp)
c0107a5c:	c0 
c0107a5d:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107a64:	00 
c0107a65:	c7 04 24 f7 a3 10 c0 	movl   $0xc010a3f7,(%esp)
c0107a6c:	e8 aa 91 ff ff       	call   c0100c1b <__panic>
c0107a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a74:	c1 e2 03             	shl    $0x3,%edx
c0107a77:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107a7e:	00 
c0107a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107a83:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107a87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107a8e:	e8 56 9f ff ff       	call   c01019e9 <ide_read_secs>
}
c0107a93:	c9                   	leave  
c0107a94:	c3                   	ret    

c0107a95 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107a95:	55                   	push   %ebp
c0107a96:	89 e5                	mov    %esp,%ebp
c0107a98:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a9e:	89 04 24             	mov    %eax,(%esp)
c0107aa1:	e8 e1 fe ff ff       	call   c0107987 <page2kva>
c0107aa6:	8b 55 08             	mov    0x8(%ebp),%edx
c0107aa9:	c1 ea 08             	shr    $0x8,%edx
c0107aac:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ab3:	74 0b                	je     c0107ac0 <swapfs_write+0x2b>
c0107ab5:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107abb:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107abe:	72 23                	jb     c0107ae3 <swapfs_write+0x4e>
c0107ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107ac7:	c7 44 24 08 08 a4 10 	movl   $0xc010a408,0x8(%esp)
c0107ace:	c0 
c0107acf:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107ad6:	00 
c0107ad7:	c7 04 24 f7 a3 10 c0 	movl   $0xc010a3f7,(%esp)
c0107ade:	e8 38 91 ff ff       	call   c0100c1b <__panic>
c0107ae3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ae6:	c1 e2 03             	shl    $0x3,%edx
c0107ae9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107af0:	00 
c0107af1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107af5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107af9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107b00:	e8 26 a1 ff ff       	call   c0101c2b <ide_write_secs>
}
c0107b05:	c9                   	leave  
c0107b06:	c3                   	ret    

c0107b07 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107b07:	55                   	push   %ebp
c0107b08:	89 e5                	mov    %esp,%ebp
c0107b0a:	83 ec 58             	sub    $0x58,%esp
c0107b0d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b10:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107b13:	8b 45 14             	mov    0x14(%ebp),%eax
c0107b16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107b19:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107b1c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107b1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107b22:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107b25:	8b 45 18             	mov    0x18(%ebp),%eax
c0107b28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b2e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107b31:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b34:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107b3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107b41:	74 1c                	je     c0107b5f <printnum+0x58>
c0107b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b46:	ba 00 00 00 00       	mov    $0x0,%edx
c0107b4b:	f7 75 e4             	divl   -0x1c(%ebp)
c0107b4e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b54:	ba 00 00 00 00       	mov    $0x0,%edx
c0107b59:	f7 75 e4             	divl   -0x1c(%ebp)
c0107b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b65:	f7 75 e4             	divl   -0x1c(%ebp)
c0107b68:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b71:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107b74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107b77:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107b7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b7d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107b80:	8b 45 18             	mov    0x18(%ebp),%eax
c0107b83:	ba 00 00 00 00       	mov    $0x0,%edx
c0107b88:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107b8b:	77 56                	ja     c0107be3 <printnum+0xdc>
c0107b8d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107b90:	72 05                	jb     c0107b97 <printnum+0x90>
c0107b92:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107b95:	77 4c                	ja     c0107be3 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107b97:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107b9a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107b9d:	8b 45 20             	mov    0x20(%ebp),%eax
c0107ba0:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107ba4:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107ba8:	8b 45 18             	mov    0x18(%ebp),%eax
c0107bab:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107bb9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bc7:	89 04 24             	mov    %eax,(%esp)
c0107bca:	e8 38 ff ff ff       	call   c0107b07 <printnum>
c0107bcf:	eb 1c                	jmp    c0107bed <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107bd8:	8b 45 20             	mov    0x20(%ebp),%eax
c0107bdb:	89 04 24             	mov    %eax,(%esp)
c0107bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0107be1:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0107be3:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0107be7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107beb:	7f e4                	jg     c0107bd1 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107bed:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107bf0:	05 a8 a4 10 c0       	add    $0xc010a4a8,%eax
c0107bf5:	0f b6 00             	movzbl (%eax),%eax
c0107bf8:	0f be c0             	movsbl %al,%eax
c0107bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107bfe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c02:	89 04 24             	mov    %eax,(%esp)
c0107c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c08:	ff d0                	call   *%eax
}
c0107c0a:	c9                   	leave  
c0107c0b:	c3                   	ret    

c0107c0c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107c0c:	55                   	push   %ebp
c0107c0d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107c0f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107c13:	7e 14                	jle    c0107c29 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0107c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c18:	8b 00                	mov    (%eax),%eax
c0107c1a:	8d 48 08             	lea    0x8(%eax),%ecx
c0107c1d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c20:	89 0a                	mov    %ecx,(%edx)
c0107c22:	8b 50 04             	mov    0x4(%eax),%edx
c0107c25:	8b 00                	mov    (%eax),%eax
c0107c27:	eb 30                	jmp    c0107c59 <getuint+0x4d>
    }
    else if (lflag) {
c0107c29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107c2d:	74 16                	je     c0107c45 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0107c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c32:	8b 00                	mov    (%eax),%eax
c0107c34:	8d 48 04             	lea    0x4(%eax),%ecx
c0107c37:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c3a:	89 0a                	mov    %ecx,(%edx)
c0107c3c:	8b 00                	mov    (%eax),%eax
c0107c3e:	ba 00 00 00 00       	mov    $0x0,%edx
c0107c43:	eb 14                	jmp    c0107c59 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0107c45:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c48:	8b 00                	mov    (%eax),%eax
c0107c4a:	8d 48 04             	lea    0x4(%eax),%ecx
c0107c4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c50:	89 0a                	mov    %ecx,(%edx)
c0107c52:	8b 00                	mov    (%eax),%eax
c0107c54:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107c59:	5d                   	pop    %ebp
c0107c5a:	c3                   	ret    

c0107c5b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107c5b:	55                   	push   %ebp
c0107c5c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107c5e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107c62:	7e 14                	jle    c0107c78 <getint+0x1d>
        return va_arg(*ap, long long);
c0107c64:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c67:	8b 00                	mov    (%eax),%eax
c0107c69:	8d 48 08             	lea    0x8(%eax),%ecx
c0107c6c:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c6f:	89 0a                	mov    %ecx,(%edx)
c0107c71:	8b 50 04             	mov    0x4(%eax),%edx
c0107c74:	8b 00                	mov    (%eax),%eax
c0107c76:	eb 28                	jmp    c0107ca0 <getint+0x45>
    }
    else if (lflag) {
c0107c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107c7c:	74 12                	je     c0107c90 <getint+0x35>
        return va_arg(*ap, long);
c0107c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c81:	8b 00                	mov    (%eax),%eax
c0107c83:	8d 48 04             	lea    0x4(%eax),%ecx
c0107c86:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c89:	89 0a                	mov    %ecx,(%edx)
c0107c8b:	8b 00                	mov    (%eax),%eax
c0107c8d:	99                   	cltd   
c0107c8e:	eb 10                	jmp    c0107ca0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0107c90:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c93:	8b 00                	mov    (%eax),%eax
c0107c95:	8d 48 04             	lea    0x4(%eax),%ecx
c0107c98:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c9b:	89 0a                	mov    %ecx,(%edx)
c0107c9d:	8b 00                	mov    (%eax),%eax
c0107c9f:	99                   	cltd   
    }
}
c0107ca0:	5d                   	pop    %ebp
c0107ca1:	c3                   	ret    

c0107ca2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0107ca2:	55                   	push   %ebp
c0107ca3:	89 e5                	mov    %esp,%ebp
c0107ca5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0107ca8:	8d 45 14             	lea    0x14(%ebp),%eax
c0107cab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0107cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107cb5:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cb8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cc6:	89 04 24             	mov    %eax,(%esp)
c0107cc9:	e8 02 00 00 00       	call   c0107cd0 <vprintfmt>
    va_end(ap);
}
c0107cce:	c9                   	leave  
c0107ccf:	c3                   	ret    

c0107cd0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0107cd0:	55                   	push   %ebp
c0107cd1:	89 e5                	mov    %esp,%ebp
c0107cd3:	56                   	push   %esi
c0107cd4:	53                   	push   %ebx
c0107cd5:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0107cd8:	eb 18                	jmp    c0107cf2 <vprintfmt+0x22>
            if (ch == '\0') {
c0107cda:	85 db                	test   %ebx,%ebx
c0107cdc:	75 05                	jne    c0107ce3 <vprintfmt+0x13>
                return;
c0107cde:	e9 d1 03 00 00       	jmp    c01080b4 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0107ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cea:	89 1c 24             	mov    %ebx,(%esp)
c0107ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cf0:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0107cf2:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cf5:	8d 50 01             	lea    0x1(%eax),%edx
c0107cf8:	89 55 10             	mov    %edx,0x10(%ebp)
c0107cfb:	0f b6 00             	movzbl (%eax),%eax
c0107cfe:	0f b6 d8             	movzbl %al,%ebx
c0107d01:	83 fb 25             	cmp    $0x25,%ebx
c0107d04:	75 d4                	jne    c0107cda <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0107d06:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0107d0a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0107d11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d14:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0107d17:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0107d1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d21:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0107d24:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d27:	8d 50 01             	lea    0x1(%eax),%edx
c0107d2a:	89 55 10             	mov    %edx,0x10(%ebp)
c0107d2d:	0f b6 00             	movzbl (%eax),%eax
c0107d30:	0f b6 d8             	movzbl %al,%ebx
c0107d33:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0107d36:	83 f8 55             	cmp    $0x55,%eax
c0107d39:	0f 87 44 03 00 00    	ja     c0108083 <vprintfmt+0x3b3>
c0107d3f:	8b 04 85 cc a4 10 c0 	mov    -0x3fef5b34(,%eax,4),%eax
c0107d46:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0107d48:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0107d4c:	eb d6                	jmp    c0107d24 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0107d4e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0107d52:	eb d0                	jmp    c0107d24 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0107d54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0107d5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107d5e:	89 d0                	mov    %edx,%eax
c0107d60:	c1 e0 02             	shl    $0x2,%eax
c0107d63:	01 d0                	add    %edx,%eax
c0107d65:	01 c0                	add    %eax,%eax
c0107d67:	01 d8                	add    %ebx,%eax
c0107d69:	83 e8 30             	sub    $0x30,%eax
c0107d6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0107d6f:	8b 45 10             	mov    0x10(%ebp),%eax
c0107d72:	0f b6 00             	movzbl (%eax),%eax
c0107d75:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0107d78:	83 fb 2f             	cmp    $0x2f,%ebx
c0107d7b:	7e 0b                	jle    c0107d88 <vprintfmt+0xb8>
c0107d7d:	83 fb 39             	cmp    $0x39,%ebx
c0107d80:	7f 06                	jg     c0107d88 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0107d82:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0107d86:	eb d3                	jmp    c0107d5b <vprintfmt+0x8b>
            goto process_precision;
c0107d88:	eb 33                	jmp    c0107dbd <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0107d8a:	8b 45 14             	mov    0x14(%ebp),%eax
c0107d8d:	8d 50 04             	lea    0x4(%eax),%edx
c0107d90:	89 55 14             	mov    %edx,0x14(%ebp)
c0107d93:	8b 00                	mov    (%eax),%eax
c0107d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0107d98:	eb 23                	jmp    c0107dbd <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0107d9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107d9e:	79 0c                	jns    c0107dac <vprintfmt+0xdc>
                width = 0;
c0107da0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0107da7:	e9 78 ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>
c0107dac:	e9 73 ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0107db1:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0107db8:	e9 67 ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0107dbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107dc1:	79 12                	jns    c0107dd5 <vprintfmt+0x105>
                width = precision, precision = -1;
c0107dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107dc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107dc9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0107dd0:	e9 4f ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>
c0107dd5:	e9 4a ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0107dda:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0107dde:	e9 41 ff ff ff       	jmp    c0107d24 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0107de3:	8b 45 14             	mov    0x14(%ebp),%eax
c0107de6:	8d 50 04             	lea    0x4(%eax),%edx
c0107de9:	89 55 14             	mov    %edx,0x14(%ebp)
c0107dec:	8b 00                	mov    (%eax),%eax
c0107dee:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107df1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107df5:	89 04 24             	mov    %eax,(%esp)
c0107df8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dfb:	ff d0                	call   *%eax
            break;
c0107dfd:	e9 ac 02 00 00       	jmp    c01080ae <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0107e02:	8b 45 14             	mov    0x14(%ebp),%eax
c0107e05:	8d 50 04             	lea    0x4(%eax),%edx
c0107e08:	89 55 14             	mov    %edx,0x14(%ebp)
c0107e0b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0107e0d:	85 db                	test   %ebx,%ebx
c0107e0f:	79 02                	jns    c0107e13 <vprintfmt+0x143>
                err = -err;
c0107e11:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0107e13:	83 fb 06             	cmp    $0x6,%ebx
c0107e16:	7f 0b                	jg     c0107e23 <vprintfmt+0x153>
c0107e18:	8b 34 9d 8c a4 10 c0 	mov    -0x3fef5b74(,%ebx,4),%esi
c0107e1f:	85 f6                	test   %esi,%esi
c0107e21:	75 23                	jne    c0107e46 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0107e23:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0107e27:	c7 44 24 08 b9 a4 10 	movl   $0xc010a4b9,0x8(%esp)
c0107e2e:	c0 
c0107e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e36:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e39:	89 04 24             	mov    %eax,(%esp)
c0107e3c:	e8 61 fe ff ff       	call   c0107ca2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0107e41:	e9 68 02 00 00       	jmp    c01080ae <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0107e46:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0107e4a:	c7 44 24 08 c2 a4 10 	movl   $0xc010a4c2,0x8(%esp)
c0107e51:	c0 
c0107e52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e5c:	89 04 24             	mov    %eax,(%esp)
c0107e5f:	e8 3e fe ff ff       	call   c0107ca2 <printfmt>
            }
            break;
c0107e64:	e9 45 02 00 00       	jmp    c01080ae <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0107e69:	8b 45 14             	mov    0x14(%ebp),%eax
c0107e6c:	8d 50 04             	lea    0x4(%eax),%edx
c0107e6f:	89 55 14             	mov    %edx,0x14(%ebp)
c0107e72:	8b 30                	mov    (%eax),%esi
c0107e74:	85 f6                	test   %esi,%esi
c0107e76:	75 05                	jne    c0107e7d <vprintfmt+0x1ad>
                p = "(null)";
c0107e78:	be c5 a4 10 c0       	mov    $0xc010a4c5,%esi
            }
            if (width > 0 && padc != '-') {
c0107e7d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107e81:	7e 3e                	jle    c0107ec1 <vprintfmt+0x1f1>
c0107e83:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0107e87:	74 38                	je     c0107ec1 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107e89:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0107e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e93:	89 34 24             	mov    %esi,(%esp)
c0107e96:	e8 ed 03 00 00       	call   c0108288 <strnlen>
c0107e9b:	29 c3                	sub    %eax,%ebx
c0107e9d:	89 d8                	mov    %ebx,%eax
c0107e9f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ea2:	eb 17                	jmp    c0107ebb <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0107ea4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0107ea8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107eab:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107eaf:	89 04 24             	mov    %eax,(%esp)
c0107eb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eb5:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0107eb7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107ebb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107ebf:	7f e3                	jg     c0107ea4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0107ec1:	eb 38                	jmp    c0107efb <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0107ec3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107ec7:	74 1f                	je     c0107ee8 <vprintfmt+0x218>
c0107ec9:	83 fb 1f             	cmp    $0x1f,%ebx
c0107ecc:	7e 05                	jle    c0107ed3 <vprintfmt+0x203>
c0107ece:	83 fb 7e             	cmp    $0x7e,%ebx
c0107ed1:	7e 15                	jle    c0107ee8 <vprintfmt+0x218>
                    putch('?', putdat);
c0107ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107eda:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0107ee1:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ee4:	ff d0                	call   *%eax
c0107ee6:	eb 0f                	jmp    c0107ef7 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0107ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107eef:	89 1c 24             	mov    %ebx,(%esp)
c0107ef2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ef5:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0107ef7:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107efb:	89 f0                	mov    %esi,%eax
c0107efd:	8d 70 01             	lea    0x1(%eax),%esi
c0107f00:	0f b6 00             	movzbl (%eax),%eax
c0107f03:	0f be d8             	movsbl %al,%ebx
c0107f06:	85 db                	test   %ebx,%ebx
c0107f08:	74 10                	je     c0107f1a <vprintfmt+0x24a>
c0107f0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107f0e:	78 b3                	js     c0107ec3 <vprintfmt+0x1f3>
c0107f10:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0107f14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107f18:	79 a9                	jns    c0107ec3 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0107f1a:	eb 17                	jmp    c0107f33 <vprintfmt+0x263>
                putch(' ', putdat);
c0107f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f23:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107f2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f2d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0107f2f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0107f33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107f37:	7f e3                	jg     c0107f1c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0107f39:	e9 70 01 00 00       	jmp    c01080ae <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0107f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f45:	8d 45 14             	lea    0x14(%ebp),%eax
c0107f48:	89 04 24             	mov    %eax,(%esp)
c0107f4b:	e8 0b fd ff ff       	call   c0107c5b <getint>
c0107f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f53:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0107f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f5c:	85 d2                	test   %edx,%edx
c0107f5e:	79 26                	jns    c0107f86 <vprintfmt+0x2b6>
                putch('-', putdat);
c0107f60:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f67:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0107f6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f71:	ff d0                	call   *%eax
                num = -(long long)num;
c0107f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f79:	f7 d8                	neg    %eax
c0107f7b:	83 d2 00             	adc    $0x0,%edx
c0107f7e:	f7 da                	neg    %edx
c0107f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f83:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0107f86:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0107f8d:	e9 a8 00 00 00       	jmp    c010803a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0107f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f99:	8d 45 14             	lea    0x14(%ebp),%eax
c0107f9c:	89 04 24             	mov    %eax,(%esp)
c0107f9f:	e8 68 fc ff ff       	call   c0107c0c <getuint>
c0107fa4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0107faa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0107fb1:	e9 84 00 00 00       	jmp    c010803a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0107fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fbd:	8d 45 14             	lea    0x14(%ebp),%eax
c0107fc0:	89 04 24             	mov    %eax,(%esp)
c0107fc3:	e8 44 fc ff ff       	call   c0107c0c <getuint>
c0107fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0107fce:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0107fd5:	eb 63                	jmp    c010803a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0107fd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fde:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0107fe5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe8:	ff d0                	call   *%eax
            putch('x', putdat);
c0107fea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107fed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ff1:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0107ff8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ffb:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0107ffd:	8b 45 14             	mov    0x14(%ebp),%eax
c0108000:	8d 50 04             	lea    0x4(%eax),%edx
c0108003:	89 55 14             	mov    %edx,0x14(%ebp)
c0108006:	8b 00                	mov    (%eax),%eax
c0108008:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010800b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0108012:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108019:	eb 1f                	jmp    c010803a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010801b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010801e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108022:	8d 45 14             	lea    0x14(%ebp),%eax
c0108025:	89 04 24             	mov    %eax,(%esp)
c0108028:	e8 df fb ff ff       	call   c0107c0c <getuint>
c010802d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108030:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0108033:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010803a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010803e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108041:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108045:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108048:	89 54 24 14          	mov    %edx,0x14(%esp)
c010804c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0108050:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108053:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108056:	89 44 24 08          	mov    %eax,0x8(%esp)
c010805a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010805e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108061:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108065:	8b 45 08             	mov    0x8(%ebp),%eax
c0108068:	89 04 24             	mov    %eax,(%esp)
c010806b:	e8 97 fa ff ff       	call   c0107b07 <printnum>
            break;
c0108070:	eb 3c                	jmp    c01080ae <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108072:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108075:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108079:	89 1c 24             	mov    %ebx,(%esp)
c010807c:	8b 45 08             	mov    0x8(%ebp),%eax
c010807f:	ff d0                	call   *%eax
            break;
c0108081:	eb 2b                	jmp    c01080ae <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108083:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108086:	89 44 24 04          	mov    %eax,0x4(%esp)
c010808a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108091:	8b 45 08             	mov    0x8(%ebp),%eax
c0108094:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108096:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010809a:	eb 04                	jmp    c01080a0 <vprintfmt+0x3d0>
c010809c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01080a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01080a3:	83 e8 01             	sub    $0x1,%eax
c01080a6:	0f b6 00             	movzbl (%eax),%eax
c01080a9:	3c 25                	cmp    $0x25,%al
c01080ab:	75 ef                	jne    c010809c <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01080ad:	90                   	nop
        }
    }
c01080ae:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01080af:	e9 3e fc ff ff       	jmp    c0107cf2 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01080b4:	83 c4 40             	add    $0x40,%esp
c01080b7:	5b                   	pop    %ebx
c01080b8:	5e                   	pop    %esi
c01080b9:	5d                   	pop    %ebp
c01080ba:	c3                   	ret    

c01080bb <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01080bb:	55                   	push   %ebp
c01080bc:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01080be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080c1:	8b 40 08             	mov    0x8(%eax),%eax
c01080c4:	8d 50 01             	lea    0x1(%eax),%edx
c01080c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080ca:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01080cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080d0:	8b 10                	mov    (%eax),%edx
c01080d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080d5:	8b 40 04             	mov    0x4(%eax),%eax
c01080d8:	39 c2                	cmp    %eax,%edx
c01080da:	73 12                	jae    c01080ee <sprintputch+0x33>
        *b->buf ++ = ch;
c01080dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080df:	8b 00                	mov    (%eax),%eax
c01080e1:	8d 48 01             	lea    0x1(%eax),%ecx
c01080e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01080e7:	89 0a                	mov    %ecx,(%edx)
c01080e9:	8b 55 08             	mov    0x8(%ebp),%edx
c01080ec:	88 10                	mov    %dl,(%eax)
    }
}
c01080ee:	5d                   	pop    %ebp
c01080ef:	c3                   	ret    

c01080f0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01080f0:	55                   	push   %ebp
c01080f1:	89 e5                	mov    %esp,%ebp
c01080f3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01080f6:	8d 45 14             	lea    0x14(%ebp),%eax
c01080f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01080fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108103:	8b 45 10             	mov    0x10(%ebp),%eax
c0108106:	89 44 24 08          	mov    %eax,0x8(%esp)
c010810a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010810d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108111:	8b 45 08             	mov    0x8(%ebp),%eax
c0108114:	89 04 24             	mov    %eax,(%esp)
c0108117:	e8 08 00 00 00       	call   c0108124 <vsnprintf>
c010811c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010811f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108122:	c9                   	leave  
c0108123:	c3                   	ret    

c0108124 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108124:	55                   	push   %ebp
c0108125:	89 e5                	mov    %esp,%ebp
c0108127:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010812a:	8b 45 08             	mov    0x8(%ebp),%eax
c010812d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108130:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108133:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108136:	8b 45 08             	mov    0x8(%ebp),%eax
c0108139:	01 d0                	add    %edx,%eax
c010813b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010813e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108145:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108149:	74 0a                	je     c0108155 <vsnprintf+0x31>
c010814b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010814e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108151:	39 c2                	cmp    %eax,%edx
c0108153:	76 07                	jbe    c010815c <vsnprintf+0x38>
        return -E_INVAL;
c0108155:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010815a:	eb 2a                	jmp    c0108186 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010815c:	8b 45 14             	mov    0x14(%ebp),%eax
c010815f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108163:	8b 45 10             	mov    0x10(%ebp),%eax
c0108166:	89 44 24 08          	mov    %eax,0x8(%esp)
c010816a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010816d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108171:	c7 04 24 bb 80 10 c0 	movl   $0xc01080bb,(%esp)
c0108178:	e8 53 fb ff ff       	call   c0107cd0 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010817d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108180:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108183:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108186:	c9                   	leave  
c0108187:	c3                   	ret    

c0108188 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108188:	55                   	push   %ebp
c0108189:	89 e5                	mov    %esp,%ebp
c010818b:	57                   	push   %edi
c010818c:	56                   	push   %esi
c010818d:	53                   	push   %ebx
c010818e:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108191:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108196:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c010819c:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01081a2:	6b f0 05             	imul   $0x5,%eax,%esi
c01081a5:	01 f7                	add    %esi,%edi
c01081a7:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c01081ac:	f7 e6                	mul    %esi
c01081ae:	8d 34 17             	lea    (%edi,%edx,1),%esi
c01081b1:	89 f2                	mov    %esi,%edx
c01081b3:	83 c0 0b             	add    $0xb,%eax
c01081b6:	83 d2 00             	adc    $0x0,%edx
c01081b9:	89 c7                	mov    %eax,%edi
c01081bb:	83 e7 ff             	and    $0xffffffff,%edi
c01081be:	89 f9                	mov    %edi,%ecx
c01081c0:	0f b7 da             	movzwl %dx,%ebx
c01081c3:	89 0d 60 fa 11 c0    	mov    %ecx,0xc011fa60
c01081c9:	89 1d 64 fa 11 c0    	mov    %ebx,0xc011fa64
    unsigned long long result = (next >> 12);
c01081cf:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c01081d4:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c01081da:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01081de:	c1 ea 0c             	shr    $0xc,%edx
c01081e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01081e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c01081e7:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c01081ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01081f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01081f7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01081fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108200:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108204:	74 1c                	je     c0108222 <rand+0x9a>
c0108206:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108209:	ba 00 00 00 00       	mov    $0x0,%edx
c010820e:	f7 75 dc             	divl   -0x24(%ebp)
c0108211:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0108214:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108217:	ba 00 00 00 00       	mov    $0x0,%edx
c010821c:	f7 75 dc             	divl   -0x24(%ebp)
c010821f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108222:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108225:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108228:	f7 75 dc             	divl   -0x24(%ebp)
c010822b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010822e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108231:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108234:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108237:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010823a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010823d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108240:	83 c4 24             	add    $0x24,%esp
c0108243:	5b                   	pop    %ebx
c0108244:	5e                   	pop    %esi
c0108245:	5f                   	pop    %edi
c0108246:	5d                   	pop    %ebp
c0108247:	c3                   	ret    

c0108248 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0108248:	55                   	push   %ebp
c0108249:	89 e5                	mov    %esp,%ebp
    next = seed;
c010824b:	8b 45 08             	mov    0x8(%ebp),%eax
c010824e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108253:	a3 60 fa 11 c0       	mov    %eax,0xc011fa60
c0108258:	89 15 64 fa 11 c0    	mov    %edx,0xc011fa64
}
c010825e:	5d                   	pop    %ebp
c010825f:	c3                   	ret    

c0108260 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108260:	55                   	push   %ebp
c0108261:	89 e5                	mov    %esp,%ebp
c0108263:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108266:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010826d:	eb 04                	jmp    c0108273 <strlen+0x13>
        cnt ++;
c010826f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108273:	8b 45 08             	mov    0x8(%ebp),%eax
c0108276:	8d 50 01             	lea    0x1(%eax),%edx
c0108279:	89 55 08             	mov    %edx,0x8(%ebp)
c010827c:	0f b6 00             	movzbl (%eax),%eax
c010827f:	84 c0                	test   %al,%al
c0108281:	75 ec                	jne    c010826f <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108286:	c9                   	leave  
c0108287:	c3                   	ret    

c0108288 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108288:	55                   	push   %ebp
c0108289:	89 e5                	mov    %esp,%ebp
c010828b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010828e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108295:	eb 04                	jmp    c010829b <strnlen+0x13>
        cnt ++;
c0108297:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010829b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010829e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01082a1:	73 10                	jae    c01082b3 <strnlen+0x2b>
c01082a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01082a6:	8d 50 01             	lea    0x1(%eax),%edx
c01082a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01082ac:	0f b6 00             	movzbl (%eax),%eax
c01082af:	84 c0                	test   %al,%al
c01082b1:	75 e4                	jne    c0108297 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c01082b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01082b6:	c9                   	leave  
c01082b7:	c3                   	ret    

c01082b8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01082b8:	55                   	push   %ebp
c01082b9:	89 e5                	mov    %esp,%ebp
c01082bb:	57                   	push   %edi
c01082bc:	56                   	push   %esi
c01082bd:	83 ec 20             	sub    $0x20,%esp
c01082c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01082cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01082cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082d2:	89 d1                	mov    %edx,%ecx
c01082d4:	89 c2                	mov    %eax,%edx
c01082d6:	89 ce                	mov    %ecx,%esi
c01082d8:	89 d7                	mov    %edx,%edi
c01082da:	ac                   	lods   %ds:(%esi),%al
c01082db:	aa                   	stos   %al,%es:(%edi)
c01082dc:	84 c0                	test   %al,%al
c01082de:	75 fa                	jne    c01082da <strcpy+0x22>
c01082e0:	89 fa                	mov    %edi,%edx
c01082e2:	89 f1                	mov    %esi,%ecx
c01082e4:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01082e7:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01082ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01082f0:	83 c4 20             	add    $0x20,%esp
c01082f3:	5e                   	pop    %esi
c01082f4:	5f                   	pop    %edi
c01082f5:	5d                   	pop    %ebp
c01082f6:	c3                   	ret    

c01082f7 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01082f7:	55                   	push   %ebp
c01082f8:	89 e5                	mov    %esp,%ebp
c01082fa:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01082fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0108300:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108303:	eb 21                	jmp    c0108326 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0108305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108308:	0f b6 10             	movzbl (%eax),%edx
c010830b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010830e:	88 10                	mov    %dl,(%eax)
c0108310:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108313:	0f b6 00             	movzbl (%eax),%eax
c0108316:	84 c0                	test   %al,%al
c0108318:	74 04                	je     c010831e <strncpy+0x27>
            src ++;
c010831a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010831e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108322:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108326:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010832a:	75 d9                	jne    c0108305 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010832c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010832f:	c9                   	leave  
c0108330:	c3                   	ret    

c0108331 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108331:	55                   	push   %ebp
c0108332:	89 e5                	mov    %esp,%ebp
c0108334:	57                   	push   %edi
c0108335:	56                   	push   %esi
c0108336:	83 ec 20             	sub    $0x20,%esp
c0108339:	8b 45 08             	mov    0x8(%ebp),%eax
c010833c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010833f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108342:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108345:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010834b:	89 d1                	mov    %edx,%ecx
c010834d:	89 c2                	mov    %eax,%edx
c010834f:	89 ce                	mov    %ecx,%esi
c0108351:	89 d7                	mov    %edx,%edi
c0108353:	ac                   	lods   %ds:(%esi),%al
c0108354:	ae                   	scas   %es:(%edi),%al
c0108355:	75 08                	jne    c010835f <strcmp+0x2e>
c0108357:	84 c0                	test   %al,%al
c0108359:	75 f8                	jne    c0108353 <strcmp+0x22>
c010835b:	31 c0                	xor    %eax,%eax
c010835d:	eb 04                	jmp    c0108363 <strcmp+0x32>
c010835f:	19 c0                	sbb    %eax,%eax
c0108361:	0c 01                	or     $0x1,%al
c0108363:	89 fa                	mov    %edi,%edx
c0108365:	89 f1                	mov    %esi,%ecx
c0108367:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010836a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010836d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108370:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108373:	83 c4 20             	add    $0x20,%esp
c0108376:	5e                   	pop    %esi
c0108377:	5f                   	pop    %edi
c0108378:	5d                   	pop    %ebp
c0108379:	c3                   	ret    

c010837a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010837a:	55                   	push   %ebp
c010837b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010837d:	eb 0c                	jmp    c010838b <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010837f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108383:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108387:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010838b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010838f:	74 1a                	je     c01083ab <strncmp+0x31>
c0108391:	8b 45 08             	mov    0x8(%ebp),%eax
c0108394:	0f b6 00             	movzbl (%eax),%eax
c0108397:	84 c0                	test   %al,%al
c0108399:	74 10                	je     c01083ab <strncmp+0x31>
c010839b:	8b 45 08             	mov    0x8(%ebp),%eax
c010839e:	0f b6 10             	movzbl (%eax),%edx
c01083a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083a4:	0f b6 00             	movzbl (%eax),%eax
c01083a7:	38 c2                	cmp    %al,%dl
c01083a9:	74 d4                	je     c010837f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01083ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01083af:	74 18                	je     c01083c9 <strncmp+0x4f>
c01083b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01083b4:	0f b6 00             	movzbl (%eax),%eax
c01083b7:	0f b6 d0             	movzbl %al,%edx
c01083ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083bd:	0f b6 00             	movzbl (%eax),%eax
c01083c0:	0f b6 c0             	movzbl %al,%eax
c01083c3:	29 c2                	sub    %eax,%edx
c01083c5:	89 d0                	mov    %edx,%eax
c01083c7:	eb 05                	jmp    c01083ce <strncmp+0x54>
c01083c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01083ce:	5d                   	pop    %ebp
c01083cf:	c3                   	ret    

c01083d0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01083d0:	55                   	push   %ebp
c01083d1:	89 e5                	mov    %esp,%ebp
c01083d3:	83 ec 04             	sub    $0x4,%esp
c01083d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01083dc:	eb 14                	jmp    c01083f2 <strchr+0x22>
        if (*s == c) {
c01083de:	8b 45 08             	mov    0x8(%ebp),%eax
c01083e1:	0f b6 00             	movzbl (%eax),%eax
c01083e4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01083e7:	75 05                	jne    c01083ee <strchr+0x1e>
            return (char *)s;
c01083e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01083ec:	eb 13                	jmp    c0108401 <strchr+0x31>
        }
        s ++;
c01083ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c01083f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01083f5:	0f b6 00             	movzbl (%eax),%eax
c01083f8:	84 c0                	test   %al,%al
c01083fa:	75 e2                	jne    c01083de <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c01083fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108401:	c9                   	leave  
c0108402:	c3                   	ret    

c0108403 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108403:	55                   	push   %ebp
c0108404:	89 e5                	mov    %esp,%ebp
c0108406:	83 ec 04             	sub    $0x4,%esp
c0108409:	8b 45 0c             	mov    0xc(%ebp),%eax
c010840c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010840f:	eb 11                	jmp    c0108422 <strfind+0x1f>
        if (*s == c) {
c0108411:	8b 45 08             	mov    0x8(%ebp),%eax
c0108414:	0f b6 00             	movzbl (%eax),%eax
c0108417:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010841a:	75 02                	jne    c010841e <strfind+0x1b>
            break;
c010841c:	eb 0e                	jmp    c010842c <strfind+0x29>
        }
        s ++;
c010841e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108422:	8b 45 08             	mov    0x8(%ebp),%eax
c0108425:	0f b6 00             	movzbl (%eax),%eax
c0108428:	84 c0                	test   %al,%al
c010842a:	75 e5                	jne    c0108411 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010842c:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010842f:	c9                   	leave  
c0108430:	c3                   	ret    

c0108431 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108431:	55                   	push   %ebp
c0108432:	89 e5                	mov    %esp,%ebp
c0108434:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010843e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108445:	eb 04                	jmp    c010844b <strtol+0x1a>
        s ++;
c0108447:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010844b:	8b 45 08             	mov    0x8(%ebp),%eax
c010844e:	0f b6 00             	movzbl (%eax),%eax
c0108451:	3c 20                	cmp    $0x20,%al
c0108453:	74 f2                	je     c0108447 <strtol+0x16>
c0108455:	8b 45 08             	mov    0x8(%ebp),%eax
c0108458:	0f b6 00             	movzbl (%eax),%eax
c010845b:	3c 09                	cmp    $0x9,%al
c010845d:	74 e8                	je     c0108447 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010845f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108462:	0f b6 00             	movzbl (%eax),%eax
c0108465:	3c 2b                	cmp    $0x2b,%al
c0108467:	75 06                	jne    c010846f <strtol+0x3e>
        s ++;
c0108469:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010846d:	eb 15                	jmp    c0108484 <strtol+0x53>
    }
    else if (*s == '-') {
c010846f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108472:	0f b6 00             	movzbl (%eax),%eax
c0108475:	3c 2d                	cmp    $0x2d,%al
c0108477:	75 0b                	jne    c0108484 <strtol+0x53>
        s ++, neg = 1;
c0108479:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010847d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108484:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108488:	74 06                	je     c0108490 <strtol+0x5f>
c010848a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010848e:	75 24                	jne    c01084b4 <strtol+0x83>
c0108490:	8b 45 08             	mov    0x8(%ebp),%eax
c0108493:	0f b6 00             	movzbl (%eax),%eax
c0108496:	3c 30                	cmp    $0x30,%al
c0108498:	75 1a                	jne    c01084b4 <strtol+0x83>
c010849a:	8b 45 08             	mov    0x8(%ebp),%eax
c010849d:	83 c0 01             	add    $0x1,%eax
c01084a0:	0f b6 00             	movzbl (%eax),%eax
c01084a3:	3c 78                	cmp    $0x78,%al
c01084a5:	75 0d                	jne    c01084b4 <strtol+0x83>
        s += 2, base = 16;
c01084a7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01084ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01084b2:	eb 2a                	jmp    c01084de <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01084b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01084b8:	75 17                	jne    c01084d1 <strtol+0xa0>
c01084ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01084bd:	0f b6 00             	movzbl (%eax),%eax
c01084c0:	3c 30                	cmp    $0x30,%al
c01084c2:	75 0d                	jne    c01084d1 <strtol+0xa0>
        s ++, base = 8;
c01084c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01084c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01084cf:	eb 0d                	jmp    c01084de <strtol+0xad>
    }
    else if (base == 0) {
c01084d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01084d5:	75 07                	jne    c01084de <strtol+0xad>
        base = 10;
c01084d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01084de:	8b 45 08             	mov    0x8(%ebp),%eax
c01084e1:	0f b6 00             	movzbl (%eax),%eax
c01084e4:	3c 2f                	cmp    $0x2f,%al
c01084e6:	7e 1b                	jle    c0108503 <strtol+0xd2>
c01084e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01084eb:	0f b6 00             	movzbl (%eax),%eax
c01084ee:	3c 39                	cmp    $0x39,%al
c01084f0:	7f 11                	jg     c0108503 <strtol+0xd2>
            dig = *s - '0';
c01084f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01084f5:	0f b6 00             	movzbl (%eax),%eax
c01084f8:	0f be c0             	movsbl %al,%eax
c01084fb:	83 e8 30             	sub    $0x30,%eax
c01084fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108501:	eb 48                	jmp    c010854b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108503:	8b 45 08             	mov    0x8(%ebp),%eax
c0108506:	0f b6 00             	movzbl (%eax),%eax
c0108509:	3c 60                	cmp    $0x60,%al
c010850b:	7e 1b                	jle    c0108528 <strtol+0xf7>
c010850d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108510:	0f b6 00             	movzbl (%eax),%eax
c0108513:	3c 7a                	cmp    $0x7a,%al
c0108515:	7f 11                	jg     c0108528 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108517:	8b 45 08             	mov    0x8(%ebp),%eax
c010851a:	0f b6 00             	movzbl (%eax),%eax
c010851d:	0f be c0             	movsbl %al,%eax
c0108520:	83 e8 57             	sub    $0x57,%eax
c0108523:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108526:	eb 23                	jmp    c010854b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108528:	8b 45 08             	mov    0x8(%ebp),%eax
c010852b:	0f b6 00             	movzbl (%eax),%eax
c010852e:	3c 40                	cmp    $0x40,%al
c0108530:	7e 3d                	jle    c010856f <strtol+0x13e>
c0108532:	8b 45 08             	mov    0x8(%ebp),%eax
c0108535:	0f b6 00             	movzbl (%eax),%eax
c0108538:	3c 5a                	cmp    $0x5a,%al
c010853a:	7f 33                	jg     c010856f <strtol+0x13e>
            dig = *s - 'A' + 10;
c010853c:	8b 45 08             	mov    0x8(%ebp),%eax
c010853f:	0f b6 00             	movzbl (%eax),%eax
c0108542:	0f be c0             	movsbl %al,%eax
c0108545:	83 e8 37             	sub    $0x37,%eax
c0108548:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010854b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010854e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108551:	7c 02                	jl     c0108555 <strtol+0x124>
            break;
c0108553:	eb 1a                	jmp    c010856f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0108555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108559:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010855c:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108560:	89 c2                	mov    %eax,%edx
c0108562:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108565:	01 d0                	add    %edx,%eax
c0108567:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010856a:	e9 6f ff ff ff       	jmp    c01084de <strtol+0xad>

    if (endptr) {
c010856f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108573:	74 08                	je     c010857d <strtol+0x14c>
        *endptr = (char *) s;
c0108575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108578:	8b 55 08             	mov    0x8(%ebp),%edx
c010857b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010857d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108581:	74 07                	je     c010858a <strtol+0x159>
c0108583:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108586:	f7 d8                	neg    %eax
c0108588:	eb 03                	jmp    c010858d <strtol+0x15c>
c010858a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010858d:	c9                   	leave  
c010858e:	c3                   	ret    

c010858f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010858f:	55                   	push   %ebp
c0108590:	89 e5                	mov    %esp,%ebp
c0108592:	57                   	push   %edi
c0108593:	83 ec 24             	sub    $0x24,%esp
c0108596:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108599:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010859c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01085a0:	8b 55 08             	mov    0x8(%ebp),%edx
c01085a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01085a6:	88 45 f7             	mov    %al,-0x9(%ebp)
c01085a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01085ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01085af:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01085b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01085b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01085b9:	89 d7                	mov    %edx,%edi
c01085bb:	f3 aa                	rep stos %al,%es:(%edi)
c01085bd:	89 fa                	mov    %edi,%edx
c01085bf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01085c2:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01085c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01085c8:	83 c4 24             	add    $0x24,%esp
c01085cb:	5f                   	pop    %edi
c01085cc:	5d                   	pop    %ebp
c01085cd:	c3                   	ret    

c01085ce <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01085ce:	55                   	push   %ebp
c01085cf:	89 e5                	mov    %esp,%ebp
c01085d1:	57                   	push   %edi
c01085d2:	56                   	push   %esi
c01085d3:	53                   	push   %ebx
c01085d4:	83 ec 30             	sub    $0x30,%esp
c01085d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01085da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01085dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01085e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01085e6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c01085e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085ec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01085ef:	73 42                	jae    c0108633 <memmove+0x65>
c01085f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01085f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01085fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108600:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108603:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108606:	c1 e8 02             	shr    $0x2,%eax
c0108609:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010860b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010860e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108611:	89 d7                	mov    %edx,%edi
c0108613:	89 c6                	mov    %eax,%esi
c0108615:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108617:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010861a:	83 e1 03             	and    $0x3,%ecx
c010861d:	74 02                	je     c0108621 <memmove+0x53>
c010861f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108621:	89 f0                	mov    %esi,%eax
c0108623:	89 fa                	mov    %edi,%edx
c0108625:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108628:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010862b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010862e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108631:	eb 36                	jmp    c0108669 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108633:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108636:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108639:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010863c:	01 c2                	add    %eax,%edx
c010863e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108641:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0108644:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108647:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010864a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010864d:	89 c1                	mov    %eax,%ecx
c010864f:	89 d8                	mov    %ebx,%eax
c0108651:	89 d6                	mov    %edx,%esi
c0108653:	89 c7                	mov    %eax,%edi
c0108655:	fd                   	std    
c0108656:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108658:	fc                   	cld    
c0108659:	89 f8                	mov    %edi,%eax
c010865b:	89 f2                	mov    %esi,%edx
c010865d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108660:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108663:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108666:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108669:	83 c4 30             	add    $0x30,%esp
c010866c:	5b                   	pop    %ebx
c010866d:	5e                   	pop    %esi
c010866e:	5f                   	pop    %edi
c010866f:	5d                   	pop    %ebp
c0108670:	c3                   	ret    

c0108671 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108671:	55                   	push   %ebp
c0108672:	89 e5                	mov    %esp,%ebp
c0108674:	57                   	push   %edi
c0108675:	56                   	push   %esi
c0108676:	83 ec 20             	sub    $0x20,%esp
c0108679:	8b 45 08             	mov    0x8(%ebp),%eax
c010867c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010867f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108682:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108685:	8b 45 10             	mov    0x10(%ebp),%eax
c0108688:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010868b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010868e:	c1 e8 02             	shr    $0x2,%eax
c0108691:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108693:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108696:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108699:	89 d7                	mov    %edx,%edi
c010869b:	89 c6                	mov    %eax,%esi
c010869d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010869f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01086a2:	83 e1 03             	and    $0x3,%ecx
c01086a5:	74 02                	je     c01086a9 <memcpy+0x38>
c01086a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01086a9:	89 f0                	mov    %esi,%eax
c01086ab:	89 fa                	mov    %edi,%edx
c01086ad:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01086b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01086b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01086b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01086b9:	83 c4 20             	add    $0x20,%esp
c01086bc:	5e                   	pop    %esi
c01086bd:	5f                   	pop    %edi
c01086be:	5d                   	pop    %ebp
c01086bf:	c3                   	ret    

c01086c0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01086c0:	55                   	push   %ebp
c01086c1:	89 e5                	mov    %esp,%ebp
c01086c3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01086c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01086c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01086cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01086d2:	eb 30                	jmp    c0108704 <memcmp+0x44>
        if (*s1 != *s2) {
c01086d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086d7:	0f b6 10             	movzbl (%eax),%edx
c01086da:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01086dd:	0f b6 00             	movzbl (%eax),%eax
c01086e0:	38 c2                	cmp    %al,%dl
c01086e2:	74 18                	je     c01086fc <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01086e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086e7:	0f b6 00             	movzbl (%eax),%eax
c01086ea:	0f b6 d0             	movzbl %al,%edx
c01086ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01086f0:	0f b6 00             	movzbl (%eax),%eax
c01086f3:	0f b6 c0             	movzbl %al,%eax
c01086f6:	29 c2                	sub    %eax,%edx
c01086f8:	89 d0                	mov    %edx,%eax
c01086fa:	eb 1a                	jmp    c0108716 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01086fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108700:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108704:	8b 45 10             	mov    0x10(%ebp),%eax
c0108707:	8d 50 ff             	lea    -0x1(%eax),%edx
c010870a:	89 55 10             	mov    %edx,0x10(%ebp)
c010870d:	85 c0                	test   %eax,%eax
c010870f:	75 c3                	jne    c01086d4 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108711:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108716:	c9                   	leave  
c0108717:	c3                   	ret    
