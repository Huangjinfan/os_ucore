
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 70 5d 00 00       	call   105dc6 <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 60 5f 10 00 	movl   $0x105f60,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 7c 5f 10 00 	movl   $0x105f7c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 63 42 00 00       	call   1042e7 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 fe 17 00 00       	call   10188c <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 81 5f 10 00 	movl   $0x105f81,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 8f 5f 10 00 	movl   $0x105f8f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 9d 5f 10 00 	movl   $0x105f9d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 ab 5f 10 00 	movl   $0x105fab,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 b9 5f 10 00 	movl   $0x105fb9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 07 60 10 00 	movl   $0x106007,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 a8 52 00 00       	call   1055df <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 0c 60 10 00    	movl   $0x10600c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 0c 60 10 00 	movl   $0x10600c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 50 72 10 00 	movl   $0x107250,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 70 1e 11 00 	movl   $0x111e70,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 71 1e 11 00 	movl   $0x111e71,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 c2 48 11 00 	movl   $0x1148c2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 4e 55 00 00       	call   105c3a <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 16 60 10 00 	movl   $0x106016,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 2f 60 10 00 	movl   $0x10602f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 4f 5f 10 	movl   $0x105f4f,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 47 60 10 00 	movl   $0x106047,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 5f 60 10 00 	movl   $0x10605f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 77 60 10 00 	movl   $0x106077,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 90 60 10 00 	movl   $0x106090,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 ba 60 10 00 	movl   $0x1060ba,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 d6 60 10 00 	movl   $0x1060d6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 e8 60 10 00 	movl   $0x1060e8,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 04 61 10 00 	movl   $0x106104,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>
	uint32_t ebp = read_ebp(), eip = read_eip();
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a36:	c7 04 24 0c 61 10 00 	movl   $0x10610c,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
        print_debuginfo(eip - 1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp(), eip = read_eip();
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6b:	74 0a                	je     100a77 <print_stackframe+0xbd>
  100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a71:	0f 8e 68 ff ff ff    	jle    1009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
	}
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 90 61 10 00 	movl   $0x106190,(%esp)
  100ab2:	e8 50 51 00 00       	call   105c07 <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 95 61 10 00 	movl   $0x106195,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 90 61 10 00 	movl   $0x106190,(%esp)
  100b1f:	e8 e3 50 00 00       	call   105c07 <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 df 4f 00 00       	call   105b68 <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 b3 61 10 00 	movl   $0x1061b3,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 cc 61 10 00 	movl   $0x1061cc,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 f4 61 10 00 	movl   $0x1061f4,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 30 0e 00 00       	call   101a44 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 19 62 10 00 	movl   $0x106219,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 1d 62 10 00 	movl   $0x10621d,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 26 62 10 00 	movl   $0x106226,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 42 62 10 00 	movl   $0x106242,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 44 62 10 00 	movl   $0x106244,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 42 62 10 00 	movl   $0x106242,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 0b 4c 00 00       	call   105e05 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 7d 62 10 00 	movl   $0x10627d,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 89 62 10 00 	movl   $0x106289,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 c0 62 10 00 	movl   $0x1062c0,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10188a:	c9                   	leave  
  10188b:	c3                   	ret    

0010188c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10188c:	55                   	push   %ebp
  10188d:	89 e5                	mov    %esp,%ebp
  10188f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101892:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101899:	e9 c3 00 00 00       	jmp    101961 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10189e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a1:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018a8:	89 c2                	mov    %eax,%edx
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018b4:	00 
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018bf:	00 08 00 
  1018c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c5:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018cc:	00 
  1018cd:	83 e2 e0             	and    $0xffffffe0,%edx
  1018d0:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e1:	00 
  1018e2:	83 e2 1f             	and    $0x1f,%edx
  1018e5:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1018f6:	00 
  1018f7:	83 e2 f0             	and    $0xfffffff0,%edx
  1018fa:	83 ca 0e             	or     $0xe,%edx
  1018fd:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101904:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101907:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190e:	00 
  10190f:	83 e2 ef             	and    $0xffffffef,%edx
  101912:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 9f             	and    $0xffffff9f,%edx
  101927:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101938:	00 
  101939:	83 ca 80             	or     $0xffffff80,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10194d:	c1 e8 10             	shr    $0x10,%eax
  101950:	89 c2                	mov    %eax,%edx
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10195c:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10195d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101961:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101964:	3d ff 00 00 00       	cmp    $0xff,%eax
  101969:	0f 86 2f ff ff ff    	jbe    10189e <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10196f:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101974:	66 a3 88 84 11 00    	mov    %ax,0x118488
  10197a:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  101981:	08 00 
  101983:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  10198a:	83 e0 e0             	and    $0xffffffe0,%eax
  10198d:	a2 8c 84 11 00       	mov    %al,0x11848c
  101992:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101999:	83 e0 1f             	and    $0x1f,%eax
  10199c:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019a1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019a8:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ab:	83 c8 0e             	or     $0xe,%eax
  1019ae:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019b3:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019ba:	83 e0 ef             	and    $0xffffffef,%eax
  1019bd:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c2:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c9:	83 c8 60             	or     $0x60,%eax
  1019cc:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d8:	83 c8 80             	or     $0xffffff80,%eax
  1019db:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019e0:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019e5:	c1 e8 10             	shr    $0x10,%eax
  1019e8:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019ee:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019f8:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  1019fb:	c9                   	leave  
  1019fc:	c3                   	ret    

001019fd <trapname>:

static const char *
trapname(int trapno) {
  1019fd:	55                   	push   %ebp
  1019fe:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a00:	8b 45 08             	mov    0x8(%ebp),%eax
  101a03:	83 f8 13             	cmp    $0x13,%eax
  101a06:	77 0c                	ja     101a14 <trapname+0x17>
        return excnames[trapno];
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	8b 04 85 20 66 10 00 	mov    0x106620(,%eax,4),%eax
  101a12:	eb 18                	jmp    101a2c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a14:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a18:	7e 0d                	jle    101a27 <trapname+0x2a>
  101a1a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a1e:	7f 07                	jg     101a27 <trapname+0x2a>
        return "Hardware Interrupt";
  101a20:	b8 ca 62 10 00       	mov    $0x1062ca,%eax
  101a25:	eb 05                	jmp    101a2c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a27:	b8 dd 62 10 00       	mov    $0x1062dd,%eax
}
  101a2c:	5d                   	pop    %ebp
  101a2d:	c3                   	ret    

00101a2e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a2e:	55                   	push   %ebp
  101a2f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a38:	66 83 f8 08          	cmp    $0x8,%ax
  101a3c:	0f 94 c0             	sete   %al
  101a3f:	0f b6 c0             	movzbl %al,%eax
}
  101a42:	5d                   	pop    %ebp
  101a43:	c3                   	ret    

00101a44 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a44:	55                   	push   %ebp
  101a45:	89 e5                	mov    %esp,%ebp
  101a47:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 1e 63 10 00 	movl   $0x10631e,(%esp)
  101a58:	e8 df e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	89 04 24             	mov    %eax,(%esp)
  101a63:	e8 a1 01 00 00       	call   101c09 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a6f:	0f b7 c0             	movzwl %ax,%eax
  101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a76:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  101a7d:	e8 ba e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a89:	0f b7 c0             	movzwl %ax,%eax
  101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a90:	c7 04 24 42 63 10 00 	movl   $0x106342,(%esp)
  101a97:	e8 a0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aa3:	0f b7 c0             	movzwl %ax,%eax
  101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aaa:	c7 04 24 55 63 10 00 	movl   $0x106355,(%esp)
  101ab1:	e8 86 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101abd:	0f b7 c0             	movzwl %ax,%eax
  101ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac4:	c7 04 24 68 63 10 00 	movl   $0x106368,(%esp)
  101acb:	e8 6c e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad3:	8b 40 30             	mov    0x30(%eax),%eax
  101ad6:	89 04 24             	mov    %eax,(%esp)
  101ad9:	e8 1f ff ff ff       	call   1019fd <trapname>
  101ade:	8b 55 08             	mov    0x8(%ebp),%edx
  101ae1:	8b 52 30             	mov    0x30(%edx),%edx
  101ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ae8:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aec:	c7 04 24 7b 63 10 00 	movl   $0x10637b,(%esp)
  101af3:	e8 44 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 40 34             	mov    0x34(%eax),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 8d 63 10 00 	movl   $0x10638d,(%esp)
  101b09:	e8 2e e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	8b 40 38             	mov    0x38(%eax),%eax
  101b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b18:	c7 04 24 9c 63 10 00 	movl   $0x10639c,(%esp)
  101b1f:	e8 18 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b24:	8b 45 08             	mov    0x8(%ebp),%eax
  101b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2b:	0f b7 c0             	movzwl %ax,%eax
  101b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b32:	c7 04 24 ab 63 10 00 	movl   $0x1063ab,(%esp)
  101b39:	e8 fe e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 40             	mov    0x40(%eax),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 be 63 10 00 	movl   $0x1063be,(%esp)
  101b4f:	e8 e8 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b5b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b62:	eb 3e                	jmp    101ba2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b64:	8b 45 08             	mov    0x8(%ebp),%eax
  101b67:	8b 50 40             	mov    0x40(%eax),%edx
  101b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b6d:	21 d0                	and    %edx,%eax
  101b6f:	85 c0                	test   %eax,%eax
  101b71:	74 28                	je     101b9b <print_trapframe+0x157>
  101b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b76:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	74 1a                	je     101b9b <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b84:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 cd 63 10 00 	movl   $0x1063cd,(%esp)
  101b96:	e8 a1 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b9f:	d1 65 f0             	shll   -0x10(%ebp)
  101ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba5:	83 f8 17             	cmp    $0x17,%eax
  101ba8:	76 ba                	jbe    101b64 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101baa:	8b 45 08             	mov    0x8(%ebp),%eax
  101bad:	8b 40 40             	mov    0x40(%eax),%eax
  101bb0:	25 00 30 00 00       	and    $0x3000,%eax
  101bb5:	c1 e8 0c             	shr    $0xc,%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 d1 63 10 00 	movl   $0x1063d1,(%esp)
  101bc3:	e8 74 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	89 04 24             	mov    %eax,(%esp)
  101bce:	e8 5b fe ff ff       	call   101a2e <trap_in_kernel>
  101bd3:	85 c0                	test   %eax,%eax
  101bd5:	75 30                	jne    101c07 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 40 44             	mov    0x44(%eax),%eax
  101bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be1:	c7 04 24 da 63 10 00 	movl   $0x1063da,(%esp)
  101be8:	e8 4f e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bed:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf0:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf4:	0f b7 c0             	movzwl %ax,%eax
  101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfb:	c7 04 24 e9 63 10 00 	movl   $0x1063e9,(%esp)
  101c02:	e8 35 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c07:	c9                   	leave  
  101c08:	c3                   	ret    

00101c09 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c09:	55                   	push   %ebp
  101c0a:	89 e5                	mov    %esp,%ebp
  101c0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c12:	8b 00                	mov    (%eax),%eax
  101c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c18:	c7 04 24 fc 63 10 00 	movl   $0x1063fc,(%esp)
  101c1f:	e8 18 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c24:	8b 45 08             	mov    0x8(%ebp),%eax
  101c27:	8b 40 04             	mov    0x4(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 0b 64 10 00 	movl   $0x10640b,(%esp)
  101c35:	e8 02 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	8b 40 08             	mov    0x8(%eax),%eax
  101c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c44:	c7 04 24 1a 64 10 00 	movl   $0x10641a,(%esp)
  101c4b:	e8 ec e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c50:	8b 45 08             	mov    0x8(%ebp),%eax
  101c53:	8b 40 0c             	mov    0xc(%eax),%eax
  101c56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5a:	c7 04 24 29 64 10 00 	movl   $0x106429,(%esp)
  101c61:	e8 d6 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 10             	mov    0x10(%eax),%eax
  101c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c70:	c7 04 24 38 64 10 00 	movl   $0x106438,(%esp)
  101c77:	e8 c0 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7f:	8b 40 14             	mov    0x14(%eax),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 47 64 10 00 	movl   $0x106447,(%esp)
  101c8d:	e8 aa e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 18             	mov    0x18(%eax),%eax
  101c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9c:	c7 04 24 56 64 10 00 	movl   $0x106456,(%esp)
  101ca3:	e8 94 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  101cab:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cae:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb2:	c7 04 24 65 64 10 00 	movl   $0x106465,(%esp)
  101cb9:	e8 7e e6 ff ff       	call   10033c <cprintf>
}
  101cbe:	c9                   	leave  
  101cbf:	c3                   	ret    

00101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc0:	55                   	push   %ebp
  101cc1:	89 e5                	mov    %esp,%ebp
  101cc3:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 30             	mov    0x30(%eax),%eax
  101ccc:	83 f8 2f             	cmp    $0x2f,%eax
  101ccf:	77 21                	ja     101cf2 <trap_dispatch+0x32>
  101cd1:	83 f8 2e             	cmp    $0x2e,%eax
  101cd4:	0f 83 04 01 00 00    	jae    101dde <trap_dispatch+0x11e>
  101cda:	83 f8 21             	cmp    $0x21,%eax
  101cdd:	0f 84 81 00 00 00    	je     101d64 <trap_dispatch+0xa4>
  101ce3:	83 f8 24             	cmp    $0x24,%eax
  101ce6:	74 56                	je     101d3e <trap_dispatch+0x7e>
  101ce8:	83 f8 20             	cmp    $0x20,%eax
  101ceb:	74 16                	je     101d03 <trap_dispatch+0x43>
  101ced:	e9 b4 00 00 00       	jmp    101da6 <trap_dispatch+0xe6>
  101cf2:	83 e8 78             	sub    $0x78,%eax
  101cf5:	83 f8 01             	cmp    $0x1,%eax
  101cf8:	0f 87 a8 00 00 00    	ja     101da6 <trap_dispatch+0xe6>
  101cfe:	e9 87 00 00 00       	jmp    101d8a <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d03:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d08:	83 c0 01             	add    $0x1,%eax
  101d0b:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d10:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d16:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d1b:	89 c8                	mov    %ecx,%eax
  101d1d:	f7 e2                	mul    %edx
  101d1f:	89 d0                	mov    %edx,%eax
  101d21:	c1 e8 05             	shr    $0x5,%eax
  101d24:	6b c0 64             	imul   $0x64,%eax,%eax
  101d27:	29 c1                	sub    %eax,%ecx
  101d29:	89 c8                	mov    %ecx,%eax
  101d2b:	85 c0                	test   %eax,%eax
  101d2d:	75 0a                	jne    101d39 <trap_dispatch+0x79>
            print_ticks();
  101d2f:	e8 3c fb ff ff       	call   101870 <print_ticks>
        }
        break;
  101d34:	e9 a6 00 00 00       	jmp    101ddf <trap_dispatch+0x11f>
  101d39:	e9 a1 00 00 00       	jmp    101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d3e:	e8 f1 f8 ff ff       	call   101634 <cons_getc>
  101d43:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d46:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d4a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d56:	c7 04 24 74 64 10 00 	movl   $0x106474,(%esp)
  101d5d:	e8 da e5 ff ff       	call   10033c <cprintf>
        break;
  101d62:	eb 7b                	jmp    101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d64:	e8 cb f8 ff ff       	call   101634 <cons_getc>
  101d69:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d6c:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d70:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d74:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7c:	c7 04 24 86 64 10 00 	movl   $0x106486,(%esp)
  101d83:	e8 b4 e5 ff ff       	call   10033c <cprintf>
        break;
  101d88:	eb 55                	jmp    101ddf <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d8a:	c7 44 24 08 95 64 10 	movl   $0x106495,0x8(%esp)
  101d91:	00 
  101d92:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  101d99:	00 
  101d9a:	c7 04 24 a5 64 10 00 	movl   $0x1064a5,(%esp)
  101da1:	e8 20 ef ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101da6:	8b 45 08             	mov    0x8(%ebp),%eax
  101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dad:	0f b7 c0             	movzwl %ax,%eax
  101db0:	83 e0 03             	and    $0x3,%eax
  101db3:	85 c0                	test   %eax,%eax
  101db5:	75 28                	jne    101ddf <trap_dispatch+0x11f>
            print_trapframe(tf);
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	89 04 24             	mov    %eax,(%esp)
  101dbd:	e8 82 fc ff ff       	call   101a44 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dc2:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  101dc9:	00 
  101dca:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101dd1:	00 
  101dd2:	c7 04 24 a5 64 10 00 	movl   $0x1064a5,(%esp)
  101dd9:	e8 e8 ee ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dde:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ddf:	c9                   	leave  
  101de0:	c3                   	ret    

00101de1 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101de1:	55                   	push   %ebp
  101de2:	89 e5                	mov    %esp,%ebp
  101de4:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	89 04 24             	mov    %eax,(%esp)
  101ded:	e8 ce fe ff ff       	call   101cc0 <trap_dispatch>
}
  101df2:	c9                   	leave  
  101df3:	c3                   	ret    

00101df4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101df4:	1e                   	push   %ds
    pushl %es
  101df5:	06                   	push   %es
    pushl %fs
  101df6:	0f a0                	push   %fs
    pushl %gs
  101df8:	0f a8                	push   %gs
    pushal
  101dfa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dfb:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e00:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e02:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e04:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e05:	e8 d7 ff ff ff       	call   101de1 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e0a:	5c                   	pop    %esp

00101e0b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e0b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e0c:	0f a9                	pop    %gs
    popl %fs
  101e0e:	0f a1                	pop    %fs
    popl %es
  101e10:	07                   	pop    %es
    popl %ds
  101e11:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e12:	83 c4 08             	add    $0x8,%esp
    iret
  101e15:	cf                   	iret   

00101e16 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e16:	6a 00                	push   $0x0
  pushl $0
  101e18:	6a 00                	push   $0x0
  jmp __alltraps
  101e1a:	e9 d5 ff ff ff       	jmp    101df4 <__alltraps>

00101e1f <vector1>:
.globl vector1
vector1:
  pushl $0
  101e1f:	6a 00                	push   $0x0
  pushl $1
  101e21:	6a 01                	push   $0x1
  jmp __alltraps
  101e23:	e9 cc ff ff ff       	jmp    101df4 <__alltraps>

00101e28 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e28:	6a 00                	push   $0x0
  pushl $2
  101e2a:	6a 02                	push   $0x2
  jmp __alltraps
  101e2c:	e9 c3 ff ff ff       	jmp    101df4 <__alltraps>

00101e31 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e31:	6a 00                	push   $0x0
  pushl $3
  101e33:	6a 03                	push   $0x3
  jmp __alltraps
  101e35:	e9 ba ff ff ff       	jmp    101df4 <__alltraps>

00101e3a <vector4>:
.globl vector4
vector4:
  pushl $0
  101e3a:	6a 00                	push   $0x0
  pushl $4
  101e3c:	6a 04                	push   $0x4
  jmp __alltraps
  101e3e:	e9 b1 ff ff ff       	jmp    101df4 <__alltraps>

00101e43 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $5
  101e45:	6a 05                	push   $0x5
  jmp __alltraps
  101e47:	e9 a8 ff ff ff       	jmp    101df4 <__alltraps>

00101e4c <vector6>:
.globl vector6
vector6:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $6
  101e4e:	6a 06                	push   $0x6
  jmp __alltraps
  101e50:	e9 9f ff ff ff       	jmp    101df4 <__alltraps>

00101e55 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e55:	6a 00                	push   $0x0
  pushl $7
  101e57:	6a 07                	push   $0x7
  jmp __alltraps
  101e59:	e9 96 ff ff ff       	jmp    101df4 <__alltraps>

00101e5e <vector8>:
.globl vector8
vector8:
  pushl $8
  101e5e:	6a 08                	push   $0x8
  jmp __alltraps
  101e60:	e9 8f ff ff ff       	jmp    101df4 <__alltraps>

00101e65 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e65:	6a 09                	push   $0x9
  jmp __alltraps
  101e67:	e9 88 ff ff ff       	jmp    101df4 <__alltraps>

00101e6c <vector10>:
.globl vector10
vector10:
  pushl $10
  101e6c:	6a 0a                	push   $0xa
  jmp __alltraps
  101e6e:	e9 81 ff ff ff       	jmp    101df4 <__alltraps>

00101e73 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e73:	6a 0b                	push   $0xb
  jmp __alltraps
  101e75:	e9 7a ff ff ff       	jmp    101df4 <__alltraps>

00101e7a <vector12>:
.globl vector12
vector12:
  pushl $12
  101e7a:	6a 0c                	push   $0xc
  jmp __alltraps
  101e7c:	e9 73 ff ff ff       	jmp    101df4 <__alltraps>

00101e81 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e81:	6a 0d                	push   $0xd
  jmp __alltraps
  101e83:	e9 6c ff ff ff       	jmp    101df4 <__alltraps>

00101e88 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e88:	6a 0e                	push   $0xe
  jmp __alltraps
  101e8a:	e9 65 ff ff ff       	jmp    101df4 <__alltraps>

00101e8f <vector15>:
.globl vector15
vector15:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $15
  101e91:	6a 0f                	push   $0xf
  jmp __alltraps
  101e93:	e9 5c ff ff ff       	jmp    101df4 <__alltraps>

00101e98 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $16
  101e9a:	6a 10                	push   $0x10
  jmp __alltraps
  101e9c:	e9 53 ff ff ff       	jmp    101df4 <__alltraps>

00101ea1 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ea1:	6a 11                	push   $0x11
  jmp __alltraps
  101ea3:	e9 4c ff ff ff       	jmp    101df4 <__alltraps>

00101ea8 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $18
  101eaa:	6a 12                	push   $0x12
  jmp __alltraps
  101eac:	e9 43 ff ff ff       	jmp    101df4 <__alltraps>

00101eb1 <vector19>:
.globl vector19
vector19:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $19
  101eb3:	6a 13                	push   $0x13
  jmp __alltraps
  101eb5:	e9 3a ff ff ff       	jmp    101df4 <__alltraps>

00101eba <vector20>:
.globl vector20
vector20:
  pushl $0
  101eba:	6a 00                	push   $0x0
  pushl $20
  101ebc:	6a 14                	push   $0x14
  jmp __alltraps
  101ebe:	e9 31 ff ff ff       	jmp    101df4 <__alltraps>

00101ec3 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ec3:	6a 00                	push   $0x0
  pushl $21
  101ec5:	6a 15                	push   $0x15
  jmp __alltraps
  101ec7:	e9 28 ff ff ff       	jmp    101df4 <__alltraps>

00101ecc <vector22>:
.globl vector22
vector22:
  pushl $0
  101ecc:	6a 00                	push   $0x0
  pushl $22
  101ece:	6a 16                	push   $0x16
  jmp __alltraps
  101ed0:	e9 1f ff ff ff       	jmp    101df4 <__alltraps>

00101ed5 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ed5:	6a 00                	push   $0x0
  pushl $23
  101ed7:	6a 17                	push   $0x17
  jmp __alltraps
  101ed9:	e9 16 ff ff ff       	jmp    101df4 <__alltraps>

00101ede <vector24>:
.globl vector24
vector24:
  pushl $0
  101ede:	6a 00                	push   $0x0
  pushl $24
  101ee0:	6a 18                	push   $0x18
  jmp __alltraps
  101ee2:	e9 0d ff ff ff       	jmp    101df4 <__alltraps>

00101ee7 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ee7:	6a 00                	push   $0x0
  pushl $25
  101ee9:	6a 19                	push   $0x19
  jmp __alltraps
  101eeb:	e9 04 ff ff ff       	jmp    101df4 <__alltraps>

00101ef0 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ef0:	6a 00                	push   $0x0
  pushl $26
  101ef2:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ef4:	e9 fb fe ff ff       	jmp    101df4 <__alltraps>

00101ef9 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ef9:	6a 00                	push   $0x0
  pushl $27
  101efb:	6a 1b                	push   $0x1b
  jmp __alltraps
  101efd:	e9 f2 fe ff ff       	jmp    101df4 <__alltraps>

00101f02 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f02:	6a 00                	push   $0x0
  pushl $28
  101f04:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f06:	e9 e9 fe ff ff       	jmp    101df4 <__alltraps>

00101f0b <vector29>:
.globl vector29
vector29:
  pushl $0
  101f0b:	6a 00                	push   $0x0
  pushl $29
  101f0d:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f0f:	e9 e0 fe ff ff       	jmp    101df4 <__alltraps>

00101f14 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f14:	6a 00                	push   $0x0
  pushl $30
  101f16:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f18:	e9 d7 fe ff ff       	jmp    101df4 <__alltraps>

00101f1d <vector31>:
.globl vector31
vector31:
  pushl $0
  101f1d:	6a 00                	push   $0x0
  pushl $31
  101f1f:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f21:	e9 ce fe ff ff       	jmp    101df4 <__alltraps>

00101f26 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f26:	6a 00                	push   $0x0
  pushl $32
  101f28:	6a 20                	push   $0x20
  jmp __alltraps
  101f2a:	e9 c5 fe ff ff       	jmp    101df4 <__alltraps>

00101f2f <vector33>:
.globl vector33
vector33:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $33
  101f31:	6a 21                	push   $0x21
  jmp __alltraps
  101f33:	e9 bc fe ff ff       	jmp    101df4 <__alltraps>

00101f38 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $34
  101f3a:	6a 22                	push   $0x22
  jmp __alltraps
  101f3c:	e9 b3 fe ff ff       	jmp    101df4 <__alltraps>

00101f41 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $35
  101f43:	6a 23                	push   $0x23
  jmp __alltraps
  101f45:	e9 aa fe ff ff       	jmp    101df4 <__alltraps>

00101f4a <vector36>:
.globl vector36
vector36:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $36
  101f4c:	6a 24                	push   $0x24
  jmp __alltraps
  101f4e:	e9 a1 fe ff ff       	jmp    101df4 <__alltraps>

00101f53 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $37
  101f55:	6a 25                	push   $0x25
  jmp __alltraps
  101f57:	e9 98 fe ff ff       	jmp    101df4 <__alltraps>

00101f5c <vector38>:
.globl vector38
vector38:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $38
  101f5e:	6a 26                	push   $0x26
  jmp __alltraps
  101f60:	e9 8f fe ff ff       	jmp    101df4 <__alltraps>

00101f65 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $39
  101f67:	6a 27                	push   $0x27
  jmp __alltraps
  101f69:	e9 86 fe ff ff       	jmp    101df4 <__alltraps>

00101f6e <vector40>:
.globl vector40
vector40:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $40
  101f70:	6a 28                	push   $0x28
  jmp __alltraps
  101f72:	e9 7d fe ff ff       	jmp    101df4 <__alltraps>

00101f77 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $41
  101f79:	6a 29                	push   $0x29
  jmp __alltraps
  101f7b:	e9 74 fe ff ff       	jmp    101df4 <__alltraps>

00101f80 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $42
  101f82:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f84:	e9 6b fe ff ff       	jmp    101df4 <__alltraps>

00101f89 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $43
  101f8b:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f8d:	e9 62 fe ff ff       	jmp    101df4 <__alltraps>

00101f92 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $44
  101f94:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f96:	e9 59 fe ff ff       	jmp    101df4 <__alltraps>

00101f9b <vector45>:
.globl vector45
vector45:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $45
  101f9d:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f9f:	e9 50 fe ff ff       	jmp    101df4 <__alltraps>

00101fa4 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $46
  101fa6:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fa8:	e9 47 fe ff ff       	jmp    101df4 <__alltraps>

00101fad <vector47>:
.globl vector47
vector47:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $47
  101faf:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fb1:	e9 3e fe ff ff       	jmp    101df4 <__alltraps>

00101fb6 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $48
  101fb8:	6a 30                	push   $0x30
  jmp __alltraps
  101fba:	e9 35 fe ff ff       	jmp    101df4 <__alltraps>

00101fbf <vector49>:
.globl vector49
vector49:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $49
  101fc1:	6a 31                	push   $0x31
  jmp __alltraps
  101fc3:	e9 2c fe ff ff       	jmp    101df4 <__alltraps>

00101fc8 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $50
  101fca:	6a 32                	push   $0x32
  jmp __alltraps
  101fcc:	e9 23 fe ff ff       	jmp    101df4 <__alltraps>

00101fd1 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $51
  101fd3:	6a 33                	push   $0x33
  jmp __alltraps
  101fd5:	e9 1a fe ff ff       	jmp    101df4 <__alltraps>

00101fda <vector52>:
.globl vector52
vector52:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $52
  101fdc:	6a 34                	push   $0x34
  jmp __alltraps
  101fde:	e9 11 fe ff ff       	jmp    101df4 <__alltraps>

00101fe3 <vector53>:
.globl vector53
vector53:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $53
  101fe5:	6a 35                	push   $0x35
  jmp __alltraps
  101fe7:	e9 08 fe ff ff       	jmp    101df4 <__alltraps>

00101fec <vector54>:
.globl vector54
vector54:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $54
  101fee:	6a 36                	push   $0x36
  jmp __alltraps
  101ff0:	e9 ff fd ff ff       	jmp    101df4 <__alltraps>

00101ff5 <vector55>:
.globl vector55
vector55:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $55
  101ff7:	6a 37                	push   $0x37
  jmp __alltraps
  101ff9:	e9 f6 fd ff ff       	jmp    101df4 <__alltraps>

00101ffe <vector56>:
.globl vector56
vector56:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $56
  102000:	6a 38                	push   $0x38
  jmp __alltraps
  102002:	e9 ed fd ff ff       	jmp    101df4 <__alltraps>

00102007 <vector57>:
.globl vector57
vector57:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $57
  102009:	6a 39                	push   $0x39
  jmp __alltraps
  10200b:	e9 e4 fd ff ff       	jmp    101df4 <__alltraps>

00102010 <vector58>:
.globl vector58
vector58:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $58
  102012:	6a 3a                	push   $0x3a
  jmp __alltraps
  102014:	e9 db fd ff ff       	jmp    101df4 <__alltraps>

00102019 <vector59>:
.globl vector59
vector59:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $59
  10201b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10201d:	e9 d2 fd ff ff       	jmp    101df4 <__alltraps>

00102022 <vector60>:
.globl vector60
vector60:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $60
  102024:	6a 3c                	push   $0x3c
  jmp __alltraps
  102026:	e9 c9 fd ff ff       	jmp    101df4 <__alltraps>

0010202b <vector61>:
.globl vector61
vector61:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $61
  10202d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10202f:	e9 c0 fd ff ff       	jmp    101df4 <__alltraps>

00102034 <vector62>:
.globl vector62
vector62:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $62
  102036:	6a 3e                	push   $0x3e
  jmp __alltraps
  102038:	e9 b7 fd ff ff       	jmp    101df4 <__alltraps>

0010203d <vector63>:
.globl vector63
vector63:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $63
  10203f:	6a 3f                	push   $0x3f
  jmp __alltraps
  102041:	e9 ae fd ff ff       	jmp    101df4 <__alltraps>

00102046 <vector64>:
.globl vector64
vector64:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $64
  102048:	6a 40                	push   $0x40
  jmp __alltraps
  10204a:	e9 a5 fd ff ff       	jmp    101df4 <__alltraps>

0010204f <vector65>:
.globl vector65
vector65:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $65
  102051:	6a 41                	push   $0x41
  jmp __alltraps
  102053:	e9 9c fd ff ff       	jmp    101df4 <__alltraps>

00102058 <vector66>:
.globl vector66
vector66:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $66
  10205a:	6a 42                	push   $0x42
  jmp __alltraps
  10205c:	e9 93 fd ff ff       	jmp    101df4 <__alltraps>

00102061 <vector67>:
.globl vector67
vector67:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $67
  102063:	6a 43                	push   $0x43
  jmp __alltraps
  102065:	e9 8a fd ff ff       	jmp    101df4 <__alltraps>

0010206a <vector68>:
.globl vector68
vector68:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $68
  10206c:	6a 44                	push   $0x44
  jmp __alltraps
  10206e:	e9 81 fd ff ff       	jmp    101df4 <__alltraps>

00102073 <vector69>:
.globl vector69
vector69:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $69
  102075:	6a 45                	push   $0x45
  jmp __alltraps
  102077:	e9 78 fd ff ff       	jmp    101df4 <__alltraps>

0010207c <vector70>:
.globl vector70
vector70:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $70
  10207e:	6a 46                	push   $0x46
  jmp __alltraps
  102080:	e9 6f fd ff ff       	jmp    101df4 <__alltraps>

00102085 <vector71>:
.globl vector71
vector71:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $71
  102087:	6a 47                	push   $0x47
  jmp __alltraps
  102089:	e9 66 fd ff ff       	jmp    101df4 <__alltraps>

0010208e <vector72>:
.globl vector72
vector72:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $72
  102090:	6a 48                	push   $0x48
  jmp __alltraps
  102092:	e9 5d fd ff ff       	jmp    101df4 <__alltraps>

00102097 <vector73>:
.globl vector73
vector73:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $73
  102099:	6a 49                	push   $0x49
  jmp __alltraps
  10209b:	e9 54 fd ff ff       	jmp    101df4 <__alltraps>

001020a0 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $74
  1020a2:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020a4:	e9 4b fd ff ff       	jmp    101df4 <__alltraps>

001020a9 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $75
  1020ab:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020ad:	e9 42 fd ff ff       	jmp    101df4 <__alltraps>

001020b2 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $76
  1020b4:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020b6:	e9 39 fd ff ff       	jmp    101df4 <__alltraps>

001020bb <vector77>:
.globl vector77
vector77:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $77
  1020bd:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020bf:	e9 30 fd ff ff       	jmp    101df4 <__alltraps>

001020c4 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $78
  1020c6:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020c8:	e9 27 fd ff ff       	jmp    101df4 <__alltraps>

001020cd <vector79>:
.globl vector79
vector79:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $79
  1020cf:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020d1:	e9 1e fd ff ff       	jmp    101df4 <__alltraps>

001020d6 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $80
  1020d8:	6a 50                	push   $0x50
  jmp __alltraps
  1020da:	e9 15 fd ff ff       	jmp    101df4 <__alltraps>

001020df <vector81>:
.globl vector81
vector81:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $81
  1020e1:	6a 51                	push   $0x51
  jmp __alltraps
  1020e3:	e9 0c fd ff ff       	jmp    101df4 <__alltraps>

001020e8 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $82
  1020ea:	6a 52                	push   $0x52
  jmp __alltraps
  1020ec:	e9 03 fd ff ff       	jmp    101df4 <__alltraps>

001020f1 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $83
  1020f3:	6a 53                	push   $0x53
  jmp __alltraps
  1020f5:	e9 fa fc ff ff       	jmp    101df4 <__alltraps>

001020fa <vector84>:
.globl vector84
vector84:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $84
  1020fc:	6a 54                	push   $0x54
  jmp __alltraps
  1020fe:	e9 f1 fc ff ff       	jmp    101df4 <__alltraps>

00102103 <vector85>:
.globl vector85
vector85:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $85
  102105:	6a 55                	push   $0x55
  jmp __alltraps
  102107:	e9 e8 fc ff ff       	jmp    101df4 <__alltraps>

0010210c <vector86>:
.globl vector86
vector86:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $86
  10210e:	6a 56                	push   $0x56
  jmp __alltraps
  102110:	e9 df fc ff ff       	jmp    101df4 <__alltraps>

00102115 <vector87>:
.globl vector87
vector87:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $87
  102117:	6a 57                	push   $0x57
  jmp __alltraps
  102119:	e9 d6 fc ff ff       	jmp    101df4 <__alltraps>

0010211e <vector88>:
.globl vector88
vector88:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $88
  102120:	6a 58                	push   $0x58
  jmp __alltraps
  102122:	e9 cd fc ff ff       	jmp    101df4 <__alltraps>

00102127 <vector89>:
.globl vector89
vector89:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $89
  102129:	6a 59                	push   $0x59
  jmp __alltraps
  10212b:	e9 c4 fc ff ff       	jmp    101df4 <__alltraps>

00102130 <vector90>:
.globl vector90
vector90:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $90
  102132:	6a 5a                	push   $0x5a
  jmp __alltraps
  102134:	e9 bb fc ff ff       	jmp    101df4 <__alltraps>

00102139 <vector91>:
.globl vector91
vector91:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $91
  10213b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10213d:	e9 b2 fc ff ff       	jmp    101df4 <__alltraps>

00102142 <vector92>:
.globl vector92
vector92:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $92
  102144:	6a 5c                	push   $0x5c
  jmp __alltraps
  102146:	e9 a9 fc ff ff       	jmp    101df4 <__alltraps>

0010214b <vector93>:
.globl vector93
vector93:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $93
  10214d:	6a 5d                	push   $0x5d
  jmp __alltraps
  10214f:	e9 a0 fc ff ff       	jmp    101df4 <__alltraps>

00102154 <vector94>:
.globl vector94
vector94:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $94
  102156:	6a 5e                	push   $0x5e
  jmp __alltraps
  102158:	e9 97 fc ff ff       	jmp    101df4 <__alltraps>

0010215d <vector95>:
.globl vector95
vector95:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $95
  10215f:	6a 5f                	push   $0x5f
  jmp __alltraps
  102161:	e9 8e fc ff ff       	jmp    101df4 <__alltraps>

00102166 <vector96>:
.globl vector96
vector96:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $96
  102168:	6a 60                	push   $0x60
  jmp __alltraps
  10216a:	e9 85 fc ff ff       	jmp    101df4 <__alltraps>

0010216f <vector97>:
.globl vector97
vector97:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $97
  102171:	6a 61                	push   $0x61
  jmp __alltraps
  102173:	e9 7c fc ff ff       	jmp    101df4 <__alltraps>

00102178 <vector98>:
.globl vector98
vector98:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $98
  10217a:	6a 62                	push   $0x62
  jmp __alltraps
  10217c:	e9 73 fc ff ff       	jmp    101df4 <__alltraps>

00102181 <vector99>:
.globl vector99
vector99:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $99
  102183:	6a 63                	push   $0x63
  jmp __alltraps
  102185:	e9 6a fc ff ff       	jmp    101df4 <__alltraps>

0010218a <vector100>:
.globl vector100
vector100:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $100
  10218c:	6a 64                	push   $0x64
  jmp __alltraps
  10218e:	e9 61 fc ff ff       	jmp    101df4 <__alltraps>

00102193 <vector101>:
.globl vector101
vector101:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $101
  102195:	6a 65                	push   $0x65
  jmp __alltraps
  102197:	e9 58 fc ff ff       	jmp    101df4 <__alltraps>

0010219c <vector102>:
.globl vector102
vector102:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $102
  10219e:	6a 66                	push   $0x66
  jmp __alltraps
  1021a0:	e9 4f fc ff ff       	jmp    101df4 <__alltraps>

001021a5 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $103
  1021a7:	6a 67                	push   $0x67
  jmp __alltraps
  1021a9:	e9 46 fc ff ff       	jmp    101df4 <__alltraps>

001021ae <vector104>:
.globl vector104
vector104:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $104
  1021b0:	6a 68                	push   $0x68
  jmp __alltraps
  1021b2:	e9 3d fc ff ff       	jmp    101df4 <__alltraps>

001021b7 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $105
  1021b9:	6a 69                	push   $0x69
  jmp __alltraps
  1021bb:	e9 34 fc ff ff       	jmp    101df4 <__alltraps>

001021c0 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $106
  1021c2:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021c4:	e9 2b fc ff ff       	jmp    101df4 <__alltraps>

001021c9 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $107
  1021cb:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021cd:	e9 22 fc ff ff       	jmp    101df4 <__alltraps>

001021d2 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $108
  1021d4:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021d6:	e9 19 fc ff ff       	jmp    101df4 <__alltraps>

001021db <vector109>:
.globl vector109
vector109:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $109
  1021dd:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021df:	e9 10 fc ff ff       	jmp    101df4 <__alltraps>

001021e4 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $110
  1021e6:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021e8:	e9 07 fc ff ff       	jmp    101df4 <__alltraps>

001021ed <vector111>:
.globl vector111
vector111:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $111
  1021ef:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021f1:	e9 fe fb ff ff       	jmp    101df4 <__alltraps>

001021f6 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $112
  1021f8:	6a 70                	push   $0x70
  jmp __alltraps
  1021fa:	e9 f5 fb ff ff       	jmp    101df4 <__alltraps>

001021ff <vector113>:
.globl vector113
vector113:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $113
  102201:	6a 71                	push   $0x71
  jmp __alltraps
  102203:	e9 ec fb ff ff       	jmp    101df4 <__alltraps>

00102208 <vector114>:
.globl vector114
vector114:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $114
  10220a:	6a 72                	push   $0x72
  jmp __alltraps
  10220c:	e9 e3 fb ff ff       	jmp    101df4 <__alltraps>

00102211 <vector115>:
.globl vector115
vector115:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $115
  102213:	6a 73                	push   $0x73
  jmp __alltraps
  102215:	e9 da fb ff ff       	jmp    101df4 <__alltraps>

0010221a <vector116>:
.globl vector116
vector116:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $116
  10221c:	6a 74                	push   $0x74
  jmp __alltraps
  10221e:	e9 d1 fb ff ff       	jmp    101df4 <__alltraps>

00102223 <vector117>:
.globl vector117
vector117:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $117
  102225:	6a 75                	push   $0x75
  jmp __alltraps
  102227:	e9 c8 fb ff ff       	jmp    101df4 <__alltraps>

0010222c <vector118>:
.globl vector118
vector118:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $118
  10222e:	6a 76                	push   $0x76
  jmp __alltraps
  102230:	e9 bf fb ff ff       	jmp    101df4 <__alltraps>

00102235 <vector119>:
.globl vector119
vector119:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $119
  102237:	6a 77                	push   $0x77
  jmp __alltraps
  102239:	e9 b6 fb ff ff       	jmp    101df4 <__alltraps>

0010223e <vector120>:
.globl vector120
vector120:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $120
  102240:	6a 78                	push   $0x78
  jmp __alltraps
  102242:	e9 ad fb ff ff       	jmp    101df4 <__alltraps>

00102247 <vector121>:
.globl vector121
vector121:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $121
  102249:	6a 79                	push   $0x79
  jmp __alltraps
  10224b:	e9 a4 fb ff ff       	jmp    101df4 <__alltraps>

00102250 <vector122>:
.globl vector122
vector122:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $122
  102252:	6a 7a                	push   $0x7a
  jmp __alltraps
  102254:	e9 9b fb ff ff       	jmp    101df4 <__alltraps>

00102259 <vector123>:
.globl vector123
vector123:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $123
  10225b:	6a 7b                	push   $0x7b
  jmp __alltraps
  10225d:	e9 92 fb ff ff       	jmp    101df4 <__alltraps>

00102262 <vector124>:
.globl vector124
vector124:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $124
  102264:	6a 7c                	push   $0x7c
  jmp __alltraps
  102266:	e9 89 fb ff ff       	jmp    101df4 <__alltraps>

0010226b <vector125>:
.globl vector125
vector125:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $125
  10226d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10226f:	e9 80 fb ff ff       	jmp    101df4 <__alltraps>

00102274 <vector126>:
.globl vector126
vector126:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $126
  102276:	6a 7e                	push   $0x7e
  jmp __alltraps
  102278:	e9 77 fb ff ff       	jmp    101df4 <__alltraps>

0010227d <vector127>:
.globl vector127
vector127:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $127
  10227f:	6a 7f                	push   $0x7f
  jmp __alltraps
  102281:	e9 6e fb ff ff       	jmp    101df4 <__alltraps>

00102286 <vector128>:
.globl vector128
vector128:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $128
  102288:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10228d:	e9 62 fb ff ff       	jmp    101df4 <__alltraps>

00102292 <vector129>:
.globl vector129
vector129:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $129
  102294:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102299:	e9 56 fb ff ff       	jmp    101df4 <__alltraps>

0010229e <vector130>:
.globl vector130
vector130:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $130
  1022a0:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022a5:	e9 4a fb ff ff       	jmp    101df4 <__alltraps>

001022aa <vector131>:
.globl vector131
vector131:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $131
  1022ac:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022b1:	e9 3e fb ff ff       	jmp    101df4 <__alltraps>

001022b6 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $132
  1022b8:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022bd:	e9 32 fb ff ff       	jmp    101df4 <__alltraps>

001022c2 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $133
  1022c4:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022c9:	e9 26 fb ff ff       	jmp    101df4 <__alltraps>

001022ce <vector134>:
.globl vector134
vector134:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $134
  1022d0:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022d5:	e9 1a fb ff ff       	jmp    101df4 <__alltraps>

001022da <vector135>:
.globl vector135
vector135:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $135
  1022dc:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022e1:	e9 0e fb ff ff       	jmp    101df4 <__alltraps>

001022e6 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $136
  1022e8:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022ed:	e9 02 fb ff ff       	jmp    101df4 <__alltraps>

001022f2 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $137
  1022f4:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022f9:	e9 f6 fa ff ff       	jmp    101df4 <__alltraps>

001022fe <vector138>:
.globl vector138
vector138:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $138
  102300:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102305:	e9 ea fa ff ff       	jmp    101df4 <__alltraps>

0010230a <vector139>:
.globl vector139
vector139:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $139
  10230c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102311:	e9 de fa ff ff       	jmp    101df4 <__alltraps>

00102316 <vector140>:
.globl vector140
vector140:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $140
  102318:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10231d:	e9 d2 fa ff ff       	jmp    101df4 <__alltraps>

00102322 <vector141>:
.globl vector141
vector141:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $141
  102324:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102329:	e9 c6 fa ff ff       	jmp    101df4 <__alltraps>

0010232e <vector142>:
.globl vector142
vector142:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $142
  102330:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102335:	e9 ba fa ff ff       	jmp    101df4 <__alltraps>

0010233a <vector143>:
.globl vector143
vector143:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $143
  10233c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102341:	e9 ae fa ff ff       	jmp    101df4 <__alltraps>

00102346 <vector144>:
.globl vector144
vector144:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $144
  102348:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10234d:	e9 a2 fa ff ff       	jmp    101df4 <__alltraps>

00102352 <vector145>:
.globl vector145
vector145:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $145
  102354:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102359:	e9 96 fa ff ff       	jmp    101df4 <__alltraps>

0010235e <vector146>:
.globl vector146
vector146:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $146
  102360:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102365:	e9 8a fa ff ff       	jmp    101df4 <__alltraps>

0010236a <vector147>:
.globl vector147
vector147:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $147
  10236c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102371:	e9 7e fa ff ff       	jmp    101df4 <__alltraps>

00102376 <vector148>:
.globl vector148
vector148:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $148
  102378:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10237d:	e9 72 fa ff ff       	jmp    101df4 <__alltraps>

00102382 <vector149>:
.globl vector149
vector149:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $149
  102384:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102389:	e9 66 fa ff ff       	jmp    101df4 <__alltraps>

0010238e <vector150>:
.globl vector150
vector150:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $150
  102390:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102395:	e9 5a fa ff ff       	jmp    101df4 <__alltraps>

0010239a <vector151>:
.globl vector151
vector151:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $151
  10239c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023a1:	e9 4e fa ff ff       	jmp    101df4 <__alltraps>

001023a6 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $152
  1023a8:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023ad:	e9 42 fa ff ff       	jmp    101df4 <__alltraps>

001023b2 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $153
  1023b4:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023b9:	e9 36 fa ff ff       	jmp    101df4 <__alltraps>

001023be <vector154>:
.globl vector154
vector154:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $154
  1023c0:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023c5:	e9 2a fa ff ff       	jmp    101df4 <__alltraps>

001023ca <vector155>:
.globl vector155
vector155:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $155
  1023cc:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023d1:	e9 1e fa ff ff       	jmp    101df4 <__alltraps>

001023d6 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $156
  1023d8:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023dd:	e9 12 fa ff ff       	jmp    101df4 <__alltraps>

001023e2 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $157
  1023e4:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023e9:	e9 06 fa ff ff       	jmp    101df4 <__alltraps>

001023ee <vector158>:
.globl vector158
vector158:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $158
  1023f0:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023f5:	e9 fa f9 ff ff       	jmp    101df4 <__alltraps>

001023fa <vector159>:
.globl vector159
vector159:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $159
  1023fc:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102401:	e9 ee f9 ff ff       	jmp    101df4 <__alltraps>

00102406 <vector160>:
.globl vector160
vector160:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $160
  102408:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10240d:	e9 e2 f9 ff ff       	jmp    101df4 <__alltraps>

00102412 <vector161>:
.globl vector161
vector161:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $161
  102414:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102419:	e9 d6 f9 ff ff       	jmp    101df4 <__alltraps>

0010241e <vector162>:
.globl vector162
vector162:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $162
  102420:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102425:	e9 ca f9 ff ff       	jmp    101df4 <__alltraps>

0010242a <vector163>:
.globl vector163
vector163:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $163
  10242c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102431:	e9 be f9 ff ff       	jmp    101df4 <__alltraps>

00102436 <vector164>:
.globl vector164
vector164:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $164
  102438:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10243d:	e9 b2 f9 ff ff       	jmp    101df4 <__alltraps>

00102442 <vector165>:
.globl vector165
vector165:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $165
  102444:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102449:	e9 a6 f9 ff ff       	jmp    101df4 <__alltraps>

0010244e <vector166>:
.globl vector166
vector166:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $166
  102450:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102455:	e9 9a f9 ff ff       	jmp    101df4 <__alltraps>

0010245a <vector167>:
.globl vector167
vector167:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $167
  10245c:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102461:	e9 8e f9 ff ff       	jmp    101df4 <__alltraps>

00102466 <vector168>:
.globl vector168
vector168:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $168
  102468:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10246d:	e9 82 f9 ff ff       	jmp    101df4 <__alltraps>

00102472 <vector169>:
.globl vector169
vector169:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $169
  102474:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102479:	e9 76 f9 ff ff       	jmp    101df4 <__alltraps>

0010247e <vector170>:
.globl vector170
vector170:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $170
  102480:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102485:	e9 6a f9 ff ff       	jmp    101df4 <__alltraps>

0010248a <vector171>:
.globl vector171
vector171:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $171
  10248c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102491:	e9 5e f9 ff ff       	jmp    101df4 <__alltraps>

00102496 <vector172>:
.globl vector172
vector172:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $172
  102498:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10249d:	e9 52 f9 ff ff       	jmp    101df4 <__alltraps>

001024a2 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $173
  1024a4:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024a9:	e9 46 f9 ff ff       	jmp    101df4 <__alltraps>

001024ae <vector174>:
.globl vector174
vector174:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $174
  1024b0:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024b5:	e9 3a f9 ff ff       	jmp    101df4 <__alltraps>

001024ba <vector175>:
.globl vector175
vector175:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $175
  1024bc:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024c1:	e9 2e f9 ff ff       	jmp    101df4 <__alltraps>

001024c6 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $176
  1024c8:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024cd:	e9 22 f9 ff ff       	jmp    101df4 <__alltraps>

001024d2 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $177
  1024d4:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024d9:	e9 16 f9 ff ff       	jmp    101df4 <__alltraps>

001024de <vector178>:
.globl vector178
vector178:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $178
  1024e0:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024e5:	e9 0a f9 ff ff       	jmp    101df4 <__alltraps>

001024ea <vector179>:
.globl vector179
vector179:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $179
  1024ec:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024f1:	e9 fe f8 ff ff       	jmp    101df4 <__alltraps>

001024f6 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $180
  1024f8:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024fd:	e9 f2 f8 ff ff       	jmp    101df4 <__alltraps>

00102502 <vector181>:
.globl vector181
vector181:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $181
  102504:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102509:	e9 e6 f8 ff ff       	jmp    101df4 <__alltraps>

0010250e <vector182>:
.globl vector182
vector182:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $182
  102510:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102515:	e9 da f8 ff ff       	jmp    101df4 <__alltraps>

0010251a <vector183>:
.globl vector183
vector183:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $183
  10251c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102521:	e9 ce f8 ff ff       	jmp    101df4 <__alltraps>

00102526 <vector184>:
.globl vector184
vector184:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $184
  102528:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10252d:	e9 c2 f8 ff ff       	jmp    101df4 <__alltraps>

00102532 <vector185>:
.globl vector185
vector185:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $185
  102534:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102539:	e9 b6 f8 ff ff       	jmp    101df4 <__alltraps>

0010253e <vector186>:
.globl vector186
vector186:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $186
  102540:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102545:	e9 aa f8 ff ff       	jmp    101df4 <__alltraps>

0010254a <vector187>:
.globl vector187
vector187:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $187
  10254c:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102551:	e9 9e f8 ff ff       	jmp    101df4 <__alltraps>

00102556 <vector188>:
.globl vector188
vector188:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $188
  102558:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10255d:	e9 92 f8 ff ff       	jmp    101df4 <__alltraps>

00102562 <vector189>:
.globl vector189
vector189:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $189
  102564:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102569:	e9 86 f8 ff ff       	jmp    101df4 <__alltraps>

0010256e <vector190>:
.globl vector190
vector190:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $190
  102570:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102575:	e9 7a f8 ff ff       	jmp    101df4 <__alltraps>

0010257a <vector191>:
.globl vector191
vector191:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $191
  10257c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102581:	e9 6e f8 ff ff       	jmp    101df4 <__alltraps>

00102586 <vector192>:
.globl vector192
vector192:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $192
  102588:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10258d:	e9 62 f8 ff ff       	jmp    101df4 <__alltraps>

00102592 <vector193>:
.globl vector193
vector193:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $193
  102594:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102599:	e9 56 f8 ff ff       	jmp    101df4 <__alltraps>

0010259e <vector194>:
.globl vector194
vector194:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $194
  1025a0:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025a5:	e9 4a f8 ff ff       	jmp    101df4 <__alltraps>

001025aa <vector195>:
.globl vector195
vector195:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $195
  1025ac:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025b1:	e9 3e f8 ff ff       	jmp    101df4 <__alltraps>

001025b6 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $196
  1025b8:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025bd:	e9 32 f8 ff ff       	jmp    101df4 <__alltraps>

001025c2 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $197
  1025c4:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025c9:	e9 26 f8 ff ff       	jmp    101df4 <__alltraps>

001025ce <vector198>:
.globl vector198
vector198:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $198
  1025d0:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025d5:	e9 1a f8 ff ff       	jmp    101df4 <__alltraps>

001025da <vector199>:
.globl vector199
vector199:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $199
  1025dc:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025e1:	e9 0e f8 ff ff       	jmp    101df4 <__alltraps>

001025e6 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $200
  1025e8:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025ed:	e9 02 f8 ff ff       	jmp    101df4 <__alltraps>

001025f2 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $201
  1025f4:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025f9:	e9 f6 f7 ff ff       	jmp    101df4 <__alltraps>

001025fe <vector202>:
.globl vector202
vector202:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $202
  102600:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102605:	e9 ea f7 ff ff       	jmp    101df4 <__alltraps>

0010260a <vector203>:
.globl vector203
vector203:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $203
  10260c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102611:	e9 de f7 ff ff       	jmp    101df4 <__alltraps>

00102616 <vector204>:
.globl vector204
vector204:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $204
  102618:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10261d:	e9 d2 f7 ff ff       	jmp    101df4 <__alltraps>

00102622 <vector205>:
.globl vector205
vector205:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $205
  102624:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102629:	e9 c6 f7 ff ff       	jmp    101df4 <__alltraps>

0010262e <vector206>:
.globl vector206
vector206:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $206
  102630:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102635:	e9 ba f7 ff ff       	jmp    101df4 <__alltraps>

0010263a <vector207>:
.globl vector207
vector207:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $207
  10263c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102641:	e9 ae f7 ff ff       	jmp    101df4 <__alltraps>

00102646 <vector208>:
.globl vector208
vector208:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $208
  102648:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10264d:	e9 a2 f7 ff ff       	jmp    101df4 <__alltraps>

00102652 <vector209>:
.globl vector209
vector209:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $209
  102654:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102659:	e9 96 f7 ff ff       	jmp    101df4 <__alltraps>

0010265e <vector210>:
.globl vector210
vector210:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $210
  102660:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102665:	e9 8a f7 ff ff       	jmp    101df4 <__alltraps>

0010266a <vector211>:
.globl vector211
vector211:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $211
  10266c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102671:	e9 7e f7 ff ff       	jmp    101df4 <__alltraps>

00102676 <vector212>:
.globl vector212
vector212:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $212
  102678:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10267d:	e9 72 f7 ff ff       	jmp    101df4 <__alltraps>

00102682 <vector213>:
.globl vector213
vector213:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $213
  102684:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102689:	e9 66 f7 ff ff       	jmp    101df4 <__alltraps>

0010268e <vector214>:
.globl vector214
vector214:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $214
  102690:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102695:	e9 5a f7 ff ff       	jmp    101df4 <__alltraps>

0010269a <vector215>:
.globl vector215
vector215:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $215
  10269c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026a1:	e9 4e f7 ff ff       	jmp    101df4 <__alltraps>

001026a6 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $216
  1026a8:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026ad:	e9 42 f7 ff ff       	jmp    101df4 <__alltraps>

001026b2 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $217
  1026b4:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026b9:	e9 36 f7 ff ff       	jmp    101df4 <__alltraps>

001026be <vector218>:
.globl vector218
vector218:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $218
  1026c0:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026c5:	e9 2a f7 ff ff       	jmp    101df4 <__alltraps>

001026ca <vector219>:
.globl vector219
vector219:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $219
  1026cc:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026d1:	e9 1e f7 ff ff       	jmp    101df4 <__alltraps>

001026d6 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $220
  1026d8:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026dd:	e9 12 f7 ff ff       	jmp    101df4 <__alltraps>

001026e2 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $221
  1026e4:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026e9:	e9 06 f7 ff ff       	jmp    101df4 <__alltraps>

001026ee <vector222>:
.globl vector222
vector222:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $222
  1026f0:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026f5:	e9 fa f6 ff ff       	jmp    101df4 <__alltraps>

001026fa <vector223>:
.globl vector223
vector223:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $223
  1026fc:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102701:	e9 ee f6 ff ff       	jmp    101df4 <__alltraps>

00102706 <vector224>:
.globl vector224
vector224:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $224
  102708:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10270d:	e9 e2 f6 ff ff       	jmp    101df4 <__alltraps>

00102712 <vector225>:
.globl vector225
vector225:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $225
  102714:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102719:	e9 d6 f6 ff ff       	jmp    101df4 <__alltraps>

0010271e <vector226>:
.globl vector226
vector226:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $226
  102720:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102725:	e9 ca f6 ff ff       	jmp    101df4 <__alltraps>

0010272a <vector227>:
.globl vector227
vector227:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $227
  10272c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102731:	e9 be f6 ff ff       	jmp    101df4 <__alltraps>

00102736 <vector228>:
.globl vector228
vector228:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $228
  102738:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10273d:	e9 b2 f6 ff ff       	jmp    101df4 <__alltraps>

00102742 <vector229>:
.globl vector229
vector229:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $229
  102744:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102749:	e9 a6 f6 ff ff       	jmp    101df4 <__alltraps>

0010274e <vector230>:
.globl vector230
vector230:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $230
  102750:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102755:	e9 9a f6 ff ff       	jmp    101df4 <__alltraps>

0010275a <vector231>:
.globl vector231
vector231:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $231
  10275c:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102761:	e9 8e f6 ff ff       	jmp    101df4 <__alltraps>

00102766 <vector232>:
.globl vector232
vector232:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $232
  102768:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10276d:	e9 82 f6 ff ff       	jmp    101df4 <__alltraps>

00102772 <vector233>:
.globl vector233
vector233:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $233
  102774:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102779:	e9 76 f6 ff ff       	jmp    101df4 <__alltraps>

0010277e <vector234>:
.globl vector234
vector234:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $234
  102780:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102785:	e9 6a f6 ff ff       	jmp    101df4 <__alltraps>

0010278a <vector235>:
.globl vector235
vector235:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $235
  10278c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102791:	e9 5e f6 ff ff       	jmp    101df4 <__alltraps>

00102796 <vector236>:
.globl vector236
vector236:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $236
  102798:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10279d:	e9 52 f6 ff ff       	jmp    101df4 <__alltraps>

001027a2 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $237
  1027a4:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027a9:	e9 46 f6 ff ff       	jmp    101df4 <__alltraps>

001027ae <vector238>:
.globl vector238
vector238:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $238
  1027b0:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027b5:	e9 3a f6 ff ff       	jmp    101df4 <__alltraps>

001027ba <vector239>:
.globl vector239
vector239:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $239
  1027bc:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027c1:	e9 2e f6 ff ff       	jmp    101df4 <__alltraps>

001027c6 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $240
  1027c8:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027cd:	e9 22 f6 ff ff       	jmp    101df4 <__alltraps>

001027d2 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $241
  1027d4:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027d9:	e9 16 f6 ff ff       	jmp    101df4 <__alltraps>

001027de <vector242>:
.globl vector242
vector242:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $242
  1027e0:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027e5:	e9 0a f6 ff ff       	jmp    101df4 <__alltraps>

001027ea <vector243>:
.globl vector243
vector243:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $243
  1027ec:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027f1:	e9 fe f5 ff ff       	jmp    101df4 <__alltraps>

001027f6 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $244
  1027f8:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027fd:	e9 f2 f5 ff ff       	jmp    101df4 <__alltraps>

00102802 <vector245>:
.globl vector245
vector245:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $245
  102804:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102809:	e9 e6 f5 ff ff       	jmp    101df4 <__alltraps>

0010280e <vector246>:
.globl vector246
vector246:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $246
  102810:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102815:	e9 da f5 ff ff       	jmp    101df4 <__alltraps>

0010281a <vector247>:
.globl vector247
vector247:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $247
  10281c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102821:	e9 ce f5 ff ff       	jmp    101df4 <__alltraps>

00102826 <vector248>:
.globl vector248
vector248:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $248
  102828:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10282d:	e9 c2 f5 ff ff       	jmp    101df4 <__alltraps>

00102832 <vector249>:
.globl vector249
vector249:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $249
  102834:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102839:	e9 b6 f5 ff ff       	jmp    101df4 <__alltraps>

0010283e <vector250>:
.globl vector250
vector250:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $250
  102840:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102845:	e9 aa f5 ff ff       	jmp    101df4 <__alltraps>

0010284a <vector251>:
.globl vector251
vector251:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $251
  10284c:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102851:	e9 9e f5 ff ff       	jmp    101df4 <__alltraps>

00102856 <vector252>:
.globl vector252
vector252:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $252
  102858:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10285d:	e9 92 f5 ff ff       	jmp    101df4 <__alltraps>

00102862 <vector253>:
.globl vector253
vector253:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $253
  102864:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102869:	e9 86 f5 ff ff       	jmp    101df4 <__alltraps>

0010286e <vector254>:
.globl vector254
vector254:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $254
  102870:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102875:	e9 7a f5 ff ff       	jmp    101df4 <__alltraps>

0010287a <vector255>:
.globl vector255
vector255:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $255
  10287c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102881:	e9 6e f5 ff ff       	jmp    101df4 <__alltraps>

00102886 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102886:	55                   	push   %ebp
  102887:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102889:	8b 55 08             	mov    0x8(%ebp),%edx
  10288c:	a1 64 89 11 00       	mov    0x118964,%eax
  102891:	29 c2                	sub    %eax,%edx
  102893:	89 d0                	mov    %edx,%eax
  102895:	c1 f8 02             	sar    $0x2,%eax
  102898:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10289e:	5d                   	pop    %ebp
  10289f:	c3                   	ret    

001028a0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028a0:	55                   	push   %ebp
  1028a1:	89 e5                	mov    %esp,%ebp
  1028a3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1028a9:	89 04 24             	mov    %eax,(%esp)
  1028ac:	e8 d5 ff ff ff       	call   102886 <page2ppn>
  1028b1:	c1 e0 0c             	shl    $0xc,%eax
}
  1028b4:	c9                   	leave  
  1028b5:	c3                   	ret    

001028b6 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028b6:	55                   	push   %ebp
  1028b7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1028bc:	8b 00                	mov    (%eax),%eax
}
  1028be:	5d                   	pop    %ebp
  1028bf:	c3                   	ret    

001028c0 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028c0:	55                   	push   %ebp
  1028c1:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028c9:	89 10                	mov    %edx,(%eax)
}
  1028cb:	5d                   	pop    %ebp
  1028cc:	c3                   	ret    

001028cd <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028cd:	55                   	push   %ebp
  1028ce:	89 e5                	mov    %esp,%ebp
  1028d0:	83 ec 10             	sub    $0x10,%esp
  1028d3:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028e0:	89 50 04             	mov    %edx,0x4(%eax)
  1028e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028e6:	8b 50 04             	mov    0x4(%eax),%edx
  1028e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028ec:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028ee:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1028f5:	00 00 00 
}
  1028f8:	c9                   	leave  
  1028f9:	c3                   	ret    

001028fa <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028fa:	55                   	push   %ebp
  1028fb:	89 e5                	mov    %esp,%ebp
  1028fd:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102900:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102904:	75 24                	jne    10292a <default_init_memmap+0x30>
  102906:	c7 44 24 0c 70 66 10 	movl   $0x106670,0xc(%esp)
  10290d:	00 
  10290e:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102915:	00 
  102916:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10291d:	00 
  10291e:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102925:	e8 9c e3 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  10292a:	8b 45 08             	mov    0x8(%ebp),%eax
  10292d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102930:	e9 dc 00 00 00       	jmp    102a11 <default_init_memmap+0x117>
        assert(PageReserved(p));
  102935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102938:	83 c0 04             	add    $0x4,%eax
  10293b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102942:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102948:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10294b:	0f a3 10             	bt     %edx,(%eax)
  10294e:	19 c0                	sbb    %eax,%eax
  102950:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102953:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102957:	0f 95 c0             	setne  %al
  10295a:	0f b6 c0             	movzbl %al,%eax
  10295d:	85 c0                	test   %eax,%eax
  10295f:	75 24                	jne    102985 <default_init_memmap+0x8b>
  102961:	c7 44 24 0c a1 66 10 	movl   $0x1066a1,0xc(%esp)
  102968:	00 
  102969:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102970:	00 
  102971:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102978:	00 
  102979:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102980:	e8 41 e3 ff ff       	call   100cc6 <__panic>
	//ËÆæÁΩÆÊ†áÂøó‰Ωç
        p->flags = 0;
  102985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102988:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  10298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102992:	83 c0 04             	add    $0x4,%eax
  102995:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10299c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10299f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029a5:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  1029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ab:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  1029b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029b9:	00 
  1029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bd:	89 04 24             	mov    %eax,(%esp)
  1029c0:	e8 fb fe ff ff       	call   1028c0 <set_page_ref>
	//Â∞ÜÁ©∫Èó≤È°µÊèíÂÖ•ÈìæË°®
        list_add_before(&free_list, &(p->page_link));
  1029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029c8:	83 c0 0c             	add    $0xc,%eax
  1029cb:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1029d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029d8:	8b 00                	mov    (%eax),%eax
  1029da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1029dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1029e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1029e9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029ec:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029ef:	89 10                	mov    %edx,(%eax)
  1029f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029f4:	8b 10                	mov    (%eax),%edx
  1029f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a02:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a08:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a0b:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a0d:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a11:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a14:	89 d0                	mov    %edx,%eax
  102a16:	c1 e0 02             	shl    $0x2,%eax
  102a19:	01 d0                	add    %edx,%eax
  102a1b:	c1 e0 02             	shl    $0x2,%eax
  102a1e:	89 c2                	mov    %eax,%edx
  102a20:	8b 45 08             	mov    0x8(%ebp),%eax
  102a23:	01 d0                	add    %edx,%eax
  102a25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a28:	0f 85 07 ff ff ff    	jne    102935 <default_init_memmap+0x3b>
        set_page_ref(p, 0);
	//Â∞ÜÁ©∫Èó≤È°µÊèíÂÖ•ÈìæË°®
        list_add_before(&free_list, &(p->page_link));
    }
    //ÁªüËÆ°Á©∫Èó≤È°µÊï∞
    nr_free += n;
  102a2e:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a37:	01 d0                	add    %edx,%eax
  102a39:	a3 58 89 11 00       	mov    %eax,0x118958
    //first block
    base->property = n;
  102a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a44:	89 50 08             	mov    %edx,0x8(%eax)
}
  102a47:	c9                   	leave  
  102a48:	c3                   	ret    

00102a49 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a49:	55                   	push   %ebp
  102a4a:	89 e5                	mov    %esp,%ebp
  102a4c:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a53:	75 24                	jne    102a79 <default_alloc_pages+0x30>
  102a55:	c7 44 24 0c 70 66 10 	movl   $0x106670,0xc(%esp)
  102a5c:	00 
  102a5d:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102a64:	00 
  102a65:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a6c:	00 
  102a6d:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102a74:	e8 4d e2 ff ff       	call   100cc6 <__panic>
    if (n > nr_free) {
  102a79:	a1 58 89 11 00       	mov    0x118958,%eax
  102a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a81:	73 0a                	jae    102a8d <default_alloc_pages+0x44>
        return NULL;
  102a83:	b8 00 00 00 00       	mov    $0x0,%eax
  102a88:	e9 37 01 00 00       	jmp    102bc4 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
  102a8d:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    //Êü•ÊâæÂêàÈÄÇÂùó
    while((le=list_next(le)) != &free_list) {
  102a94:	e9 0a 01 00 00       	jmp    102ba3 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
  102a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a9c:	83 e8 0c             	sub    $0xc,%eax
  102a9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
  102aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102aa5:	8b 40 08             	mov    0x8(%eax),%eax
  102aa8:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aab:	0f 82 f2 00 00 00    	jb     102ba3 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
  102ab1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ab8:	eb 7c                	jmp    102b36 <default_alloc_pages+0xed>
  102aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102abd:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ac0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ac3:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
  102ac6:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
  102ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102acc:	83 e8 0c             	sub    $0xc,%eax
  102acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
  102ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ad5:	83 c0 04             	add    $0x4,%eax
  102ad8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102adf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102ae2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ae5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ae8:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
  102aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102aee:	83 c0 04             	add    $0x4,%eax
  102af1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102af8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102afb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102afe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b01:	0f b3 10             	btr    %edx,(%eax)
  102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b07:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b0a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b0d:	8b 40 04             	mov    0x4(%eax),%eax
  102b10:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b13:	8b 12                	mov    (%edx),%edx
  102b15:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b18:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b1b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b1e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b21:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b27:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b2a:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
  102b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    //Êü•ÊâæÂêàÈÄÇÂùó
    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
  102b32:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b39:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b3c:	0f 82 78 ff ff ff    	jb     102aba <default_alloc_pages+0x71>
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        //Â¶ÇÊûúÈ°µÂùóËøáÂ§ßÂàôÂàÜÂâ≤ÂêéÂÜçÁî®
        if(p->property>n){
  102b42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b45:	8b 40 08             	mov    0x8(%eax),%eax
  102b48:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b4b:	76 12                	jbe    102b5f <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
  102b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b50:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b56:	8b 40 08             	mov    0x8(%eax),%eax
  102b59:	2b 45 08             	sub    0x8(%ebp),%eax
  102b5c:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
  102b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b62:	83 c0 04             	add    $0x4,%eax
  102b65:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102b6c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102b6f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b72:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b75:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
  102b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b7b:	83 c0 04             	add    $0x4,%eax
  102b7e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102b85:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b88:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b8b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b8e:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
  102b91:	a1 58 89 11 00       	mov    0x118958,%eax
  102b96:	2b 45 08             	sub    0x8(%ebp),%eax
  102b99:	a3 58 89 11 00       	mov    %eax,0x118958
        return p;
  102b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ba1:	eb 21                	jmp    102bc4 <default_alloc_pages+0x17b>
  102ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba6:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ba9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102bac:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;
    //Êü•ÊâæÂêàÈÄÇÂùó
    while((le=list_next(le)) != &free_list) {
  102baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bb2:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102bb9:	0f 85 da fe ff ff    	jne    102a99 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
  102bbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bc4:	c9                   	leave  
  102bc5:	c3                   	ret    

00102bc6 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bc6:	55                   	push   %ebp
  102bc7:	89 e5                	mov    %esp,%ebp
  102bc9:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bd0:	75 24                	jne    102bf6 <default_free_pages+0x30>
  102bd2:	c7 44 24 0c 70 66 10 	movl   $0x106670,0xc(%esp)
  102bd9:	00 
  102bda:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102be1:	00 
  102be2:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102be9:	00 
  102bea:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102bf1:	e8 d0 e0 ff ff       	call   100cc6 <__panic>
    //Ê£ÄÊü•Ê†áÂøó‰ΩçÊ≠£Á°ÆÊÄß
    assert(PageReserved(base));
  102bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf9:	83 c0 04             	add    $0x4,%eax
  102bfc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c03:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c09:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c0c:	0f a3 10             	bt     %edx,(%eax)
  102c0f:	19 c0                	sbb    %eax,%eax
  102c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c14:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c18:	0f 95 c0             	setne  %al
  102c1b:	0f b6 c0             	movzbl %al,%eax
  102c1e:	85 c0                	test   %eax,%eax
  102c20:	75 24                	jne    102c46 <default_free_pages+0x80>
  102c22:	c7 44 24 0c b1 66 10 	movl   $0x1066b1,0xc(%esp)
  102c29:	00 
  102c2a:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102c31:	00 
  102c32:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  102c39:	00 
  102c3a:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102c41:	e8 80 e0 ff ff       	call   100cc6 <__panic>
    list_entry_t *le = &free_list;
  102c46:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    struct Page * p;
    //Êü•ÊâæÊèíÂÖ•‰ΩçÁΩÆle
    while((le=list_next(le)) != &free_list) {
  102c4d:	eb 13                	jmp    102c62 <default_free_pages+0x9c>
      p = le2page(le, page_link);
  102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c52:	83 e8 0c             	sub    $0xc,%eax
  102c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
  102c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c5e:	76 02                	jbe    102c62 <default_free_pages+0x9c>
        break;
  102c60:	eb 18                	jmp    102c7a <default_free_pages+0xb4>
  102c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c6b:	8b 40 04             	mov    0x4(%eax),%eax
    //Ê£ÄÊü•Ê†áÂøó‰ΩçÊ≠£Á°ÆÊÄß
    assert(PageReserved(base));
    list_entry_t *le = &free_list;
    struct Page * p;
    //Êü•ÊâæÊèíÂÖ•‰ΩçÁΩÆle
    while((le=list_next(le)) != &free_list) {
  102c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c71:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102c78:	75 d5                	jne    102c4f <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c80:	eb 4b                	jmp    102ccd <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
  102c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c85:	8d 50 0c             	lea    0xc(%eax),%edx
  102c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102c8e:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c94:	8b 00                	mov    (%eax),%eax
  102c96:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c99:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102c9c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c9f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ca2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ca5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ca8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cab:	89 10                	mov    %edx,(%eax)
  102cad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cb0:	8b 10                	mov    (%eax),%edx
  102cb2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cb5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cbb:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102cbe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cc1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cc4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cc7:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
  102cc9:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cd0:	89 d0                	mov    %edx,%eax
  102cd2:	c1 e0 02             	shl    $0x2,%eax
  102cd5:	01 d0                	add    %edx,%eax
  102cd7:	c1 e0 02             	shl    $0x2,%eax
  102cda:	89 c2                	mov    %eax,%edx
  102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdf:	01 d0                	add    %edx,%eax
  102ce1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102ce4:	77 9c                	ja     102c82 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  102ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102cf0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102cf7:	00 
  102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfb:	89 04 24             	mov    %eax,(%esp)
  102cfe:	e8 bd fb ff ff       	call   1028c0 <set_page_ref>
    ClearPageProperty(base);
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	83 c0 04             	add    $0x4,%eax
  102d09:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d10:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d16:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d19:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1f:	83 c0 04             	add    $0x4,%eax
  102d22:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102d29:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d2c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d2f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d32:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d3b:	89 50 08             	mov    %edx,0x8(%eax)
    //ÂêëÈ´òÂú∞ÂùÄÂêàÂπ∂
    p = le2page(le,page_link) ;
  102d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d41:	83 e8 0c             	sub    $0xc,%eax
  102d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
  102d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d4a:	89 d0                	mov    %edx,%eax
  102d4c:	c1 e0 02             	shl    $0x2,%eax
  102d4f:	01 d0                	add    %edx,%eax
  102d51:	c1 e0 02             	shl    $0x2,%eax
  102d54:	89 c2                	mov    %eax,%edx
  102d56:	8b 45 08             	mov    0x8(%ebp),%eax
  102d59:	01 d0                	add    %edx,%eax
  102d5b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d5e:	75 1e                	jne    102d7e <default_free_pages+0x1b8>
      base->property += p->property;
  102d60:	8b 45 08             	mov    0x8(%ebp),%eax
  102d63:	8b 50 08             	mov    0x8(%eax),%edx
  102d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d69:	8b 40 08             	mov    0x8(%eax),%eax
  102d6c:	01 c2                	add    %eax,%edx
  102d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d71:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
  102d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d81:	83 c0 0c             	add    $0xc,%eax
  102d84:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d87:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d8a:	8b 00                	mov    (%eax),%eax
  102d8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  102d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d92:	83 e8 0c             	sub    $0xc,%eax
  102d95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
  102d98:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102d9f:	74 57                	je     102df8 <default_free_pages+0x232>
  102da1:	8b 45 08             	mov    0x8(%ebp),%eax
  102da4:	83 e8 14             	sub    $0x14,%eax
  102da7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102daa:	75 4c                	jne    102df8 <default_free_pages+0x232>
      while(le!=&free_list){
  102dac:	eb 41                	jmp    102def <default_free_pages+0x229>
        if(p->property){
  102dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db1:	8b 40 08             	mov    0x8(%eax),%eax
  102db4:	85 c0                	test   %eax,%eax
  102db6:	74 20                	je     102dd8 <default_free_pages+0x212>
          p->property += base->property;
  102db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbb:	8b 50 08             	mov    0x8(%eax),%edx
  102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc1:	8b 40 08             	mov    0x8(%eax),%eax
  102dc4:	01 c2                	add    %eax,%edx
  102dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc9:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
  102dd6:	eb 20                	jmp    102df8 <default_free_pages+0x232>
  102dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102de1:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
  102de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
  102de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de9:	83 e8 0c             	sub    $0xc,%eax
  102dec:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
  102def:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102df6:	75 b6                	jne    102dae <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
  102df8:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e01:	01 d0                	add    %edx,%eax
  102e03:	a3 58 89 11 00       	mov    %eax,0x118958
    return ;
  102e08:	90                   	nop
}
  102e09:	c9                   	leave  
  102e0a:	c3                   	ret    

00102e0b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e0b:	55                   	push   %ebp
  102e0c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e0e:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e13:	5d                   	pop    %ebp
  102e14:	c3                   	ret    

00102e15 <basic_check>:

static void
basic_check(void) {
  102e15:	55                   	push   %ebp
  102e16:	89 e5                	mov    %esp,%ebp
  102e18:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e35:	e8 9d 0e 00 00       	call   103cd7 <alloc_pages>
  102e3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e41:	75 24                	jne    102e67 <basic_check+0x52>
  102e43:	c7 44 24 0c c4 66 10 	movl   $0x1066c4,0xc(%esp)
  102e4a:	00 
  102e4b:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102e52:	00 
  102e53:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102e5a:	00 
  102e5b:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102e62:	e8 5f de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e6e:	e8 64 0e 00 00       	call   103cd7 <alloc_pages>
  102e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e7a:	75 24                	jne    102ea0 <basic_check+0x8b>
  102e7c:	c7 44 24 0c e0 66 10 	movl   $0x1066e0,0xc(%esp)
  102e83:	00 
  102e84:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102e8b:	00 
  102e8c:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102e93:	00 
  102e94:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102e9b:	e8 26 de ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ea7:	e8 2b 0e 00 00       	call   103cd7 <alloc_pages>
  102eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102eb3:	75 24                	jne    102ed9 <basic_check+0xc4>
  102eb5:	c7 44 24 0c fc 66 10 	movl   $0x1066fc,0xc(%esp)
  102ebc:	00 
  102ebd:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102ec4:	00 
  102ec5:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102ecc:	00 
  102ecd:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102ed4:	e8 ed dd ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102edc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102edf:	74 10                	je     102ef1 <basic_check+0xdc>
  102ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ee7:	74 08                	je     102ef1 <basic_check+0xdc>
  102ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102eef:	75 24                	jne    102f15 <basic_check+0x100>
  102ef1:	c7 44 24 0c 18 67 10 	movl   $0x106718,0xc(%esp)
  102ef8:	00 
  102ef9:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102f00:	00 
  102f01:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102f08:	00 
  102f09:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102f10:	e8 b1 dd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f18:	89 04 24             	mov    %eax,(%esp)
  102f1b:	e8 96 f9 ff ff       	call   1028b6 <page_ref>
  102f20:	85 c0                	test   %eax,%eax
  102f22:	75 1e                	jne    102f42 <basic_check+0x12d>
  102f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f27:	89 04 24             	mov    %eax,(%esp)
  102f2a:	e8 87 f9 ff ff       	call   1028b6 <page_ref>
  102f2f:	85 c0                	test   %eax,%eax
  102f31:	75 0f                	jne    102f42 <basic_check+0x12d>
  102f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f36:	89 04 24             	mov    %eax,(%esp)
  102f39:	e8 78 f9 ff ff       	call   1028b6 <page_ref>
  102f3e:	85 c0                	test   %eax,%eax
  102f40:	74 24                	je     102f66 <basic_check+0x151>
  102f42:	c7 44 24 0c 3c 67 10 	movl   $0x10673c,0xc(%esp)
  102f49:	00 
  102f4a:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102f51:	00 
  102f52:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  102f59:	00 
  102f5a:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102f61:	e8 60 dd ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f69:	89 04 24             	mov    %eax,(%esp)
  102f6c:	e8 2f f9 ff ff       	call   1028a0 <page2pa>
  102f71:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f77:	c1 e2 0c             	shl    $0xc,%edx
  102f7a:	39 d0                	cmp    %edx,%eax
  102f7c:	72 24                	jb     102fa2 <basic_check+0x18d>
  102f7e:	c7 44 24 0c 78 67 10 	movl   $0x106778,0xc(%esp)
  102f85:	00 
  102f86:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102f8d:	00 
  102f8e:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  102f95:	00 
  102f96:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102f9d:	e8 24 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa5:	89 04 24             	mov    %eax,(%esp)
  102fa8:	e8 f3 f8 ff ff       	call   1028a0 <page2pa>
  102fad:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fb3:	c1 e2 0c             	shl    $0xc,%edx
  102fb6:	39 d0                	cmp    %edx,%eax
  102fb8:	72 24                	jb     102fde <basic_check+0x1c9>
  102fba:	c7 44 24 0c 95 67 10 	movl   $0x106795,0xc(%esp)
  102fc1:	00 
  102fc2:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  102fc9:	00 
  102fca:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  102fd1:	00 
  102fd2:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  102fd9:	e8 e8 dc ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe1:	89 04 24             	mov    %eax,(%esp)
  102fe4:	e8 b7 f8 ff ff       	call   1028a0 <page2pa>
  102fe9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fef:	c1 e2 0c             	shl    $0xc,%edx
  102ff2:	39 d0                	cmp    %edx,%eax
  102ff4:	72 24                	jb     10301a <basic_check+0x205>
  102ff6:	c7 44 24 0c b2 67 10 	movl   $0x1067b2,0xc(%esp)
  102ffd:	00 
  102ffe:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103005:	00 
  103006:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  10300d:	00 
  10300e:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103015:	e8 ac dc ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  10301a:	a1 50 89 11 00       	mov    0x118950,%eax
  10301f:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103025:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103028:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10302b:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103032:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103035:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103038:	89 50 04             	mov    %edx,0x4(%eax)
  10303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303e:	8b 50 04             	mov    0x4(%eax),%edx
  103041:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103044:	89 10                	mov    %edx,(%eax)
  103046:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103050:	8b 40 04             	mov    0x4(%eax),%eax
  103053:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103056:	0f 94 c0             	sete   %al
  103059:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10305c:	85 c0                	test   %eax,%eax
  10305e:	75 24                	jne    103084 <basic_check+0x26f>
  103060:	c7 44 24 0c cf 67 10 	movl   $0x1067cf,0xc(%esp)
  103067:	00 
  103068:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10306f:	00 
  103070:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  103077:	00 
  103078:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10307f:	e8 42 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  103084:	a1 58 89 11 00       	mov    0x118958,%eax
  103089:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10308c:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103093:	00 00 00 

    assert(alloc_page() == NULL);
  103096:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10309d:	e8 35 0c 00 00       	call   103cd7 <alloc_pages>
  1030a2:	85 c0                	test   %eax,%eax
  1030a4:	74 24                	je     1030ca <basic_check+0x2b5>
  1030a6:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  1030ad:	00 
  1030ae:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1030b5:	00 
  1030b6:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  1030bd:	00 
  1030be:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1030c5:	e8 fc db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  1030ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030d1:	00 
  1030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030d5:	89 04 24             	mov    %eax,(%esp)
  1030d8:	e8 32 0c 00 00       	call   103d0f <free_pages>
    free_page(p1);
  1030dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030e4:	00 
  1030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e8:	89 04 24             	mov    %eax,(%esp)
  1030eb:	e8 1f 0c 00 00       	call   103d0f <free_pages>
    free_page(p2);
  1030f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030f7:	00 
  1030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030fb:	89 04 24             	mov    %eax,(%esp)
  1030fe:	e8 0c 0c 00 00       	call   103d0f <free_pages>
    assert(nr_free == 3);
  103103:	a1 58 89 11 00       	mov    0x118958,%eax
  103108:	83 f8 03             	cmp    $0x3,%eax
  10310b:	74 24                	je     103131 <basic_check+0x31c>
  10310d:	c7 44 24 0c fb 67 10 	movl   $0x1067fb,0xc(%esp)
  103114:	00 
  103115:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10311c:	00 
  10311d:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103124:	00 
  103125:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10312c:	e8 95 db ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103131:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103138:	e8 9a 0b 00 00       	call   103cd7 <alloc_pages>
  10313d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103140:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103144:	75 24                	jne    10316a <basic_check+0x355>
  103146:	c7 44 24 0c c4 66 10 	movl   $0x1066c4,0xc(%esp)
  10314d:	00 
  10314e:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103155:	00 
  103156:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  10315d:	00 
  10315e:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103165:	e8 5c db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10316a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103171:	e8 61 0b 00 00       	call   103cd7 <alloc_pages>
  103176:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103179:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10317d:	75 24                	jne    1031a3 <basic_check+0x38e>
  10317f:	c7 44 24 0c e0 66 10 	movl   $0x1066e0,0xc(%esp)
  103186:	00 
  103187:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10318e:	00 
  10318f:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  103196:	00 
  103197:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10319e:	e8 23 db ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031aa:	e8 28 0b 00 00       	call   103cd7 <alloc_pages>
  1031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031b6:	75 24                	jne    1031dc <basic_check+0x3c7>
  1031b8:	c7 44 24 0c fc 66 10 	movl   $0x1066fc,0xc(%esp)
  1031bf:	00 
  1031c0:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1031c7:	00 
  1031c8:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1031cf:	00 
  1031d0:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1031d7:	e8 ea da ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  1031dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e3:	e8 ef 0a 00 00       	call   103cd7 <alloc_pages>
  1031e8:	85 c0                	test   %eax,%eax
  1031ea:	74 24                	je     103210 <basic_check+0x3fb>
  1031ec:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  1031f3:	00 
  1031f4:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1031fb:	00 
  1031fc:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  103203:	00 
  103204:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10320b:	e8 b6 da ff ff       	call   100cc6 <__panic>

    free_page(p0);
  103210:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103217:	00 
  103218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10321b:	89 04 24             	mov    %eax,(%esp)
  10321e:	e8 ec 0a 00 00       	call   103d0f <free_pages>
  103223:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10322a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10322d:	8b 40 04             	mov    0x4(%eax),%eax
  103230:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103233:	0f 94 c0             	sete   %al
  103236:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103239:	85 c0                	test   %eax,%eax
  10323b:	74 24                	je     103261 <basic_check+0x44c>
  10323d:	c7 44 24 0c 08 68 10 	movl   $0x106808,0xc(%esp)
  103244:	00 
  103245:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10324c:	00 
  10324d:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  103254:	00 
  103255:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10325c:	e8 65 da ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103268:	e8 6a 0a 00 00       	call   103cd7 <alloc_pages>
  10326d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103273:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103276:	74 24                	je     10329c <basic_check+0x487>
  103278:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  10327f:	00 
  103280:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103287:	00 
  103288:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  10328f:	00 
  103290:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103297:	e8 2a da ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032a3:	e8 2f 0a 00 00       	call   103cd7 <alloc_pages>
  1032a8:	85 c0                	test   %eax,%eax
  1032aa:	74 24                	je     1032d0 <basic_check+0x4bb>
  1032ac:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  1032b3:	00 
  1032b4:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1032bb:	00 
  1032bc:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  1032c3:	00 
  1032c4:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1032cb:	e8 f6 d9 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1032d0:	a1 58 89 11 00       	mov    0x118958,%eax
  1032d5:	85 c0                	test   %eax,%eax
  1032d7:	74 24                	je     1032fd <basic_check+0x4e8>
  1032d9:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  1032e0:	00 
  1032e1:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1032e8:	00 
  1032e9:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  1032f0:	00 
  1032f1:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1032f8:	e8 c9 d9 ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  1032fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103303:	a3 50 89 11 00       	mov    %eax,0x118950
  103308:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103311:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103316:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10331d:	00 
  10331e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103321:	89 04 24             	mov    %eax,(%esp)
  103324:	e8 e6 09 00 00       	call   103d0f <free_pages>
    free_page(p1);
  103329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103330:	00 
  103331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103334:	89 04 24             	mov    %eax,(%esp)
  103337:	e8 d3 09 00 00       	call   103d0f <free_pages>
    free_page(p2);
  10333c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103343:	00 
  103344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103347:	89 04 24             	mov    %eax,(%esp)
  10334a:	e8 c0 09 00 00       	call   103d0f <free_pages>
}
  10334f:	c9                   	leave  
  103350:	c3                   	ret    

00103351 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103351:	55                   	push   %ebp
  103352:	89 e5                	mov    %esp,%ebp
  103354:	53                   	push   %ebx
  103355:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10335b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103362:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103369:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103370:	eb 6b                	jmp    1033dd <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103375:	83 e8 0c             	sub    $0xc,%eax
  103378:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337e:	83 c0 04             	add    $0x4,%eax
  103381:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103388:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10338b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10338e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103391:	0f a3 10             	bt     %edx,(%eax)
  103394:	19 c0                	sbb    %eax,%eax
  103396:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103399:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10339d:	0f 95 c0             	setne  %al
  1033a0:	0f b6 c0             	movzbl %al,%eax
  1033a3:	85 c0                	test   %eax,%eax
  1033a5:	75 24                	jne    1033cb <default_check+0x7a>
  1033a7:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1033ae:	00 
  1033af:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1033b6:	00 
  1033b7:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1033be:	00 
  1033bf:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1033c6:	e8 fb d8 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  1033cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d2:	8b 50 08             	mov    0x8(%eax),%edx
  1033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d8:	01 d0                	add    %edx,%eax
  1033da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033e6:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033ec:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1033f3:	0f 85 79 ff ff ff    	jne    103372 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033f9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033fc:	e8 40 09 00 00       	call   103d41 <nr_free_pages>
  103401:	39 c3                	cmp    %eax,%ebx
  103403:	74 24                	je     103429 <default_check+0xd8>
  103405:	c7 44 24 0c 56 68 10 	movl   $0x106856,0xc(%esp)
  10340c:	00 
  10340d:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103414:	00 
  103415:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  10341c:	00 
  10341d:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103424:	e8 9d d8 ff ff       	call   100cc6 <__panic>

    basic_check();
  103429:	e8 e7 f9 ff ff       	call   102e15 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10342e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103435:	e8 9d 08 00 00       	call   103cd7 <alloc_pages>
  10343a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10343d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103441:	75 24                	jne    103467 <default_check+0x116>
  103443:	c7 44 24 0c 6f 68 10 	movl   $0x10686f,0xc(%esp)
  10344a:	00 
  10344b:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103452:	00 
  103453:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  10345a:	00 
  10345b:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103462:	e8 5f d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  103467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10346a:	83 c0 04             	add    $0x4,%eax
  10346d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103474:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103477:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10347a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10347d:	0f a3 10             	bt     %edx,(%eax)
  103480:	19 c0                	sbb    %eax,%eax
  103482:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103485:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103489:	0f 95 c0             	setne  %al
  10348c:	0f b6 c0             	movzbl %al,%eax
  10348f:	85 c0                	test   %eax,%eax
  103491:	74 24                	je     1034b7 <default_check+0x166>
  103493:	c7 44 24 0c 7a 68 10 	movl   $0x10687a,0xc(%esp)
  10349a:	00 
  10349b:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1034a2:	00 
  1034a3:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  1034aa:	00 
  1034ab:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1034b2:	e8 0f d8 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  1034b7:	a1 50 89 11 00       	mov    0x118950,%eax
  1034bc:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034c2:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034c5:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034c8:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034d2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034d5:	89 50 04             	mov    %edx,0x4(%eax)
  1034d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034db:	8b 50 04             	mov    0x4(%eax),%edx
  1034de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034e1:	89 10                	mov    %edx,(%eax)
  1034e3:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034ed:	8b 40 04             	mov    0x4(%eax),%eax
  1034f0:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034f3:	0f 94 c0             	sete   %al
  1034f6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034f9:	85 c0                	test   %eax,%eax
  1034fb:	75 24                	jne    103521 <default_check+0x1d0>
  1034fd:	c7 44 24 0c cf 67 10 	movl   $0x1067cf,0xc(%esp)
  103504:	00 
  103505:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10350c:	00 
  10350d:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103514:	00 
  103515:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10351c:	e8 a5 d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103528:	e8 aa 07 00 00       	call   103cd7 <alloc_pages>
  10352d:	85 c0                	test   %eax,%eax
  10352f:	74 24                	je     103555 <default_check+0x204>
  103531:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  103538:	00 
  103539:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103540:	00 
  103541:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  103548:	00 
  103549:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103550:	e8 71 d7 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  103555:	a1 58 89 11 00       	mov    0x118958,%eax
  10355a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10355d:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103564:	00 00 00 

    free_pages(p0 + 2, 3);
  103567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10356a:	83 c0 28             	add    $0x28,%eax
  10356d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103574:	00 
  103575:	89 04 24             	mov    %eax,(%esp)
  103578:	e8 92 07 00 00       	call   103d0f <free_pages>
    assert(alloc_pages(4) == NULL);
  10357d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103584:	e8 4e 07 00 00       	call   103cd7 <alloc_pages>
  103589:	85 c0                	test   %eax,%eax
  10358b:	74 24                	je     1035b1 <default_check+0x260>
  10358d:	c7 44 24 0c 8c 68 10 	movl   $0x10688c,0xc(%esp)
  103594:	00 
  103595:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10359c:	00 
  10359d:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1035a4:	00 
  1035a5:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1035ac:	e8 15 d7 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035b4:	83 c0 28             	add    $0x28,%eax
  1035b7:	83 c0 04             	add    $0x4,%eax
  1035ba:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035c7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035ca:	0f a3 10             	bt     %edx,(%eax)
  1035cd:	19 c0                	sbb    %eax,%eax
  1035cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035d2:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035d6:	0f 95 c0             	setne  %al
  1035d9:	0f b6 c0             	movzbl %al,%eax
  1035dc:	85 c0                	test   %eax,%eax
  1035de:	74 0e                	je     1035ee <default_check+0x29d>
  1035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e3:	83 c0 28             	add    $0x28,%eax
  1035e6:	8b 40 08             	mov    0x8(%eax),%eax
  1035e9:	83 f8 03             	cmp    $0x3,%eax
  1035ec:	74 24                	je     103612 <default_check+0x2c1>
  1035ee:	c7 44 24 0c a4 68 10 	movl   $0x1068a4,0xc(%esp)
  1035f5:	00 
  1035f6:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1035fd:	00 
  1035fe:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103605:	00 
  103606:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10360d:	e8 b4 d6 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103612:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103619:	e8 b9 06 00 00       	call   103cd7 <alloc_pages>
  10361e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103621:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103625:	75 24                	jne    10364b <default_check+0x2fa>
  103627:	c7 44 24 0c d0 68 10 	movl   $0x1068d0,0xc(%esp)
  10362e:	00 
  10362f:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103636:	00 
  103637:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  10363e:	00 
  10363f:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103646:	e8 7b d6 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  10364b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103652:	e8 80 06 00 00       	call   103cd7 <alloc_pages>
  103657:	85 c0                	test   %eax,%eax
  103659:	74 24                	je     10367f <default_check+0x32e>
  10365b:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  103662:	00 
  103663:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10366a:	00 
  10366b:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103672:	00 
  103673:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10367a:	e8 47 d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  10367f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103682:	83 c0 28             	add    $0x28,%eax
  103685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103688:	74 24                	je     1036ae <default_check+0x35d>
  10368a:	c7 44 24 0c ee 68 10 	movl   $0x1068ee,0xc(%esp)
  103691:	00 
  103692:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103699:	00 
  10369a:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  1036a1:	00 
  1036a2:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1036a9:	e8 18 d6 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  1036ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b1:	83 c0 14             	add    $0x14,%eax
  1036b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036be:	00 
  1036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c2:	89 04 24             	mov    %eax,(%esp)
  1036c5:	e8 45 06 00 00       	call   103d0f <free_pages>
    free_pages(p1, 3);
  1036ca:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036d1:	00 
  1036d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036d5:	89 04 24             	mov    %eax,(%esp)
  1036d8:	e8 32 06 00 00       	call   103d0f <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036e0:	83 c0 04             	add    $0x4,%eax
  1036e3:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036ea:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036f0:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036f3:	0f a3 10             	bt     %edx,(%eax)
  1036f6:	19 c0                	sbb    %eax,%eax
  1036f8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036fb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036ff:	0f 95 c0             	setne  %al
  103702:	0f b6 c0             	movzbl %al,%eax
  103705:	85 c0                	test   %eax,%eax
  103707:	74 0b                	je     103714 <default_check+0x3c3>
  103709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10370c:	8b 40 08             	mov    0x8(%eax),%eax
  10370f:	83 f8 01             	cmp    $0x1,%eax
  103712:	74 24                	je     103738 <default_check+0x3e7>
  103714:	c7 44 24 0c fc 68 10 	movl   $0x1068fc,0xc(%esp)
  10371b:	00 
  10371c:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103723:	00 
  103724:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  10372b:	00 
  10372c:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103733:	e8 8e d5 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10373b:	83 c0 04             	add    $0x4,%eax
  10373e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103745:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103748:	8b 45 90             	mov    -0x70(%ebp),%eax
  10374b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10374e:	0f a3 10             	bt     %edx,(%eax)
  103751:	19 c0                	sbb    %eax,%eax
  103753:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103756:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10375a:	0f 95 c0             	setne  %al
  10375d:	0f b6 c0             	movzbl %al,%eax
  103760:	85 c0                	test   %eax,%eax
  103762:	74 0b                	je     10376f <default_check+0x41e>
  103764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103767:	8b 40 08             	mov    0x8(%eax),%eax
  10376a:	83 f8 03             	cmp    $0x3,%eax
  10376d:	74 24                	je     103793 <default_check+0x442>
  10376f:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  103776:	00 
  103777:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10377e:	00 
  10377f:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  103786:	00 
  103787:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10378e:	e8 33 d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103793:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10379a:	e8 38 05 00 00       	call   103cd7 <alloc_pages>
  10379f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037a5:	83 e8 14             	sub    $0x14,%eax
  1037a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037ab:	74 24                	je     1037d1 <default_check+0x480>
  1037ad:	c7 44 24 0c 4a 69 10 	movl   $0x10694a,0xc(%esp)
  1037b4:	00 
  1037b5:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1037bc:	00 
  1037bd:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  1037c4:	00 
  1037c5:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1037cc:	e8 f5 d4 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  1037d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037d8:	00 
  1037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037dc:	89 04 24             	mov    %eax,(%esp)
  1037df:	e8 2b 05 00 00       	call   103d0f <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037eb:	e8 e7 04 00 00       	call   103cd7 <alloc_pages>
  1037f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037f6:	83 c0 14             	add    $0x14,%eax
  1037f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037fc:	74 24                	je     103822 <default_check+0x4d1>
  1037fe:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  103805:	00 
  103806:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10380d:	00 
  10380e:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103815:	00 
  103816:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10381d:	e8 a4 d4 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  103822:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103829:	00 
  10382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10382d:	89 04 24             	mov    %eax,(%esp)
  103830:	e8 da 04 00 00       	call   103d0f <free_pages>
    free_page(p2);
  103835:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10383c:	00 
  10383d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103840:	89 04 24             	mov    %eax,(%esp)
  103843:	e8 c7 04 00 00       	call   103d0f <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103848:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10384f:	e8 83 04 00 00       	call   103cd7 <alloc_pages>
  103854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10385b:	75 24                	jne    103881 <default_check+0x530>
  10385d:	c7 44 24 0c 88 69 10 	movl   $0x106988,0xc(%esp)
  103864:	00 
  103865:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10386c:	00 
  10386d:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103874:	00 
  103875:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10387c:	e8 45 d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103888:	e8 4a 04 00 00       	call   103cd7 <alloc_pages>
  10388d:	85 c0                	test   %eax,%eax
  10388f:	74 24                	je     1038b5 <default_check+0x564>
  103891:	c7 44 24 0c e6 67 10 	movl   $0x1067e6,0xc(%esp)
  103898:	00 
  103899:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1038a0:	00 
  1038a1:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1038a8:	00 
  1038a9:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1038b0:	e8 11 d4 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  1038b5:	a1 58 89 11 00       	mov    0x118958,%eax
  1038ba:	85 c0                	test   %eax,%eax
  1038bc:	74 24                	je     1038e2 <default_check+0x591>
  1038be:	c7 44 24 0c 39 68 10 	movl   $0x106839,0xc(%esp)
  1038c5:	00 
  1038c6:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  1038cd:	00 
  1038ce:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  1038d5:	00 
  1038d6:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  1038dd:	e8 e4 d3 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  1038e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038e5:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1038ea:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038ed:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038f0:	a3 50 89 11 00       	mov    %eax,0x118950
  1038f5:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1038fb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103902:	00 
  103903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103906:	89 04 24             	mov    %eax,(%esp)
  103909:	e8 01 04 00 00       	call   103d0f <free_pages>

    le = &free_list;
  10390e:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103915:	eb 1d                	jmp    103934 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10391a:	83 e8 0c             	sub    $0xc,%eax
  10391d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103920:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10392a:	8b 40 08             	mov    0x8(%eax),%eax
  10392d:	29 c2                	sub    %eax,%edx
  10392f:	89 d0                	mov    %edx,%eax
  103931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103937:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10393a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10393d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103940:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103943:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10394a:	75 cb                	jne    103917 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10394c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103950:	74 24                	je     103976 <default_check+0x625>
  103952:	c7 44 24 0c a6 69 10 	movl   $0x1069a6,0xc(%esp)
  103959:	00 
  10395a:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  103961:	00 
  103962:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  103969:	00 
  10396a:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  103971:	e8 50 d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  103976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10397a:	74 24                	je     1039a0 <default_check+0x64f>
  10397c:	c7 44 24 0c b1 69 10 	movl   $0x1069b1,0xc(%esp)
  103983:	00 
  103984:	c7 44 24 08 76 66 10 	movl   $0x106676,0x8(%esp)
  10398b:	00 
  10398c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  103993:	00 
  103994:	c7 04 24 8b 66 10 00 	movl   $0x10668b,(%esp)
  10399b:	e8 26 d3 ff ff       	call   100cc6 <__panic>
}
  1039a0:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039a6:	5b                   	pop    %ebx
  1039a7:	5d                   	pop    %ebp
  1039a8:	c3                   	ret    

001039a9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039a9:	55                   	push   %ebp
  1039aa:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1039af:	a1 64 89 11 00       	mov    0x118964,%eax
  1039b4:	29 c2                	sub    %eax,%edx
  1039b6:	89 d0                	mov    %edx,%eax
  1039b8:	c1 f8 02             	sar    $0x2,%eax
  1039bb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039c1:	5d                   	pop    %ebp
  1039c2:	c3                   	ret    

001039c3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039c3:	55                   	push   %ebp
  1039c4:	89 e5                	mov    %esp,%ebp
  1039c6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cc:	89 04 24             	mov    %eax,(%esp)
  1039cf:	e8 d5 ff ff ff       	call   1039a9 <page2ppn>
  1039d4:	c1 e0 0c             	shl    $0xc,%eax
}
  1039d7:	c9                   	leave  
  1039d8:	c3                   	ret    

001039d9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039d9:	55                   	push   %ebp
  1039da:	89 e5                	mov    %esp,%ebp
  1039dc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039df:	8b 45 08             	mov    0x8(%ebp),%eax
  1039e2:	c1 e8 0c             	shr    $0xc,%eax
  1039e5:	89 c2                	mov    %eax,%edx
  1039e7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039ec:	39 c2                	cmp    %eax,%edx
  1039ee:	72 1c                	jb     103a0c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039f0:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  1039f7:	00 
  1039f8:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039ff:	00 
  103a00:	c7 04 24 0b 6a 10 00 	movl   $0x106a0b,(%esp)
  103a07:	e8 ba d2 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  103a0c:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a12:	8b 45 08             	mov    0x8(%ebp),%eax
  103a15:	c1 e8 0c             	shr    $0xc,%eax
  103a18:	89 c2                	mov    %eax,%edx
  103a1a:	89 d0                	mov    %edx,%eax
  103a1c:	c1 e0 02             	shl    $0x2,%eax
  103a1f:	01 d0                	add    %edx,%eax
  103a21:	c1 e0 02             	shl    $0x2,%eax
  103a24:	01 c8                	add    %ecx,%eax
}
  103a26:	c9                   	leave  
  103a27:	c3                   	ret    

00103a28 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a28:	55                   	push   %ebp
  103a29:	89 e5                	mov    %esp,%ebp
  103a2b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a31:	89 04 24             	mov    %eax,(%esp)
  103a34:	e8 8a ff ff ff       	call   1039c3 <page2pa>
  103a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a3f:	c1 e8 0c             	shr    $0xc,%eax
  103a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a45:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a4d:	72 23                	jb     103a72 <page2kva+0x4a>
  103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a56:	c7 44 24 08 1c 6a 10 	movl   $0x106a1c,0x8(%esp)
  103a5d:	00 
  103a5e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a65:	00 
  103a66:	c7 04 24 0b 6a 10 00 	movl   $0x106a0b,(%esp)
  103a6d:	e8 54 d2 ff ff       	call   100cc6 <__panic>
  103a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a75:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a7a:	c9                   	leave  
  103a7b:	c3                   	ret    

00103a7c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a7c:	55                   	push   %ebp
  103a7d:	89 e5                	mov    %esp,%ebp
  103a7f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a82:	8b 45 08             	mov    0x8(%ebp),%eax
  103a85:	83 e0 01             	and    $0x1,%eax
  103a88:	85 c0                	test   %eax,%eax
  103a8a:	75 1c                	jne    103aa8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a8c:	c7 44 24 08 40 6a 10 	movl   $0x106a40,0x8(%esp)
  103a93:	00 
  103a94:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a9b:	00 
  103a9c:	c7 04 24 0b 6a 10 00 	movl   $0x106a0b,(%esp)
  103aa3:	e8 1e d2 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  103aab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ab0:	89 04 24             	mov    %eax,(%esp)
  103ab3:	e8 21 ff ff ff       	call   1039d9 <pa2page>
}
  103ab8:	c9                   	leave  
  103ab9:	c3                   	ret    

00103aba <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103aba:	55                   	push   %ebp
  103abb:	89 e5                	mov    %esp,%ebp
  103abd:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ac8:	89 04 24             	mov    %eax,(%esp)
  103acb:	e8 09 ff ff ff       	call   1039d9 <pa2page>
}
  103ad0:	c9                   	leave  
  103ad1:	c3                   	ret    

00103ad2 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103ad2:	55                   	push   %ebp
  103ad3:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad8:	8b 00                	mov    (%eax),%eax
}
  103ada:	5d                   	pop    %ebp
  103adb:	c3                   	ret    

00103adc <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103adc:	55                   	push   %ebp
  103add:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103adf:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  103ae5:	89 10                	mov    %edx,(%eax)
}
  103ae7:	5d                   	pop    %ebp
  103ae8:	c3                   	ret    

00103ae9 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103ae9:	55                   	push   %ebp
  103aea:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103aec:	8b 45 08             	mov    0x8(%ebp),%eax
  103aef:	8b 00                	mov    (%eax),%eax
  103af1:	8d 50 01             	lea    0x1(%eax),%edx
  103af4:	8b 45 08             	mov    0x8(%ebp),%eax
  103af7:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103af9:	8b 45 08             	mov    0x8(%ebp),%eax
  103afc:	8b 00                	mov    (%eax),%eax
}
  103afe:	5d                   	pop    %ebp
  103aff:	c3                   	ret    

00103b00 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b00:	55                   	push   %ebp
  103b01:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b03:	8b 45 08             	mov    0x8(%ebp),%eax
  103b06:	8b 00                	mov    (%eax),%eax
  103b08:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b0e:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b10:	8b 45 08             	mov    0x8(%ebp),%eax
  103b13:	8b 00                	mov    (%eax),%eax
}
  103b15:	5d                   	pop    %ebp
  103b16:	c3                   	ret    

00103b17 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b17:	55                   	push   %ebp
  103b18:	89 e5                	mov    %esp,%ebp
  103b1a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b1d:	9c                   	pushf  
  103b1e:	58                   	pop    %eax
  103b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b25:	25 00 02 00 00       	and    $0x200,%eax
  103b2a:	85 c0                	test   %eax,%eax
  103b2c:	74 0c                	je     103b3a <__intr_save+0x23>
        intr_disable();
  103b2e:	e8 76 db ff ff       	call   1016a9 <intr_disable>
        return 1;
  103b33:	b8 01 00 00 00       	mov    $0x1,%eax
  103b38:	eb 05                	jmp    103b3f <__intr_save+0x28>
    }
    return 0;
  103b3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b3f:	c9                   	leave  
  103b40:	c3                   	ret    

00103b41 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b41:	55                   	push   %ebp
  103b42:	89 e5                	mov    %esp,%ebp
  103b44:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b4b:	74 05                	je     103b52 <__intr_restore+0x11>
        intr_enable();
  103b4d:	e8 51 db ff ff       	call   1016a3 <intr_enable>
    }
}
  103b52:	c9                   	leave  
  103b53:	c3                   	ret    

00103b54 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b54:	55                   	push   %ebp
  103b55:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b57:	8b 45 08             	mov    0x8(%ebp),%eax
  103b5a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b5d:	b8 23 00 00 00       	mov    $0x23,%eax
  103b62:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b64:	b8 23 00 00 00       	mov    $0x23,%eax
  103b69:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b6b:	b8 10 00 00 00       	mov    $0x10,%eax
  103b70:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b72:	b8 10 00 00 00       	mov    $0x10,%eax
  103b77:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b79:	b8 10 00 00 00       	mov    $0x10,%eax
  103b7e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b80:	ea 87 3b 10 00 08 00 	ljmp   $0x8,$0x103b87
}
  103b87:	5d                   	pop    %ebp
  103b88:	c3                   	ret    

00103b89 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b89:	55                   	push   %ebp
  103b8a:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b8f:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b94:	5d                   	pop    %ebp
  103b95:	c3                   	ret    

00103b96 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b96:	55                   	push   %ebp
  103b97:	89 e5                	mov    %esp,%ebp
  103b99:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b9c:	b8 00 70 11 00       	mov    $0x117000,%eax
  103ba1:	89 04 24             	mov    %eax,(%esp)
  103ba4:	e8 e0 ff ff ff       	call   103b89 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103ba9:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103bb0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103bb2:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bb9:	68 00 
  103bbb:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bc0:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bc6:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bcb:	c1 e8 10             	shr    $0x10,%eax
  103bce:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bd3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bda:	83 e0 f0             	and    $0xfffffff0,%eax
  103bdd:	83 c8 09             	or     $0x9,%eax
  103be0:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103be5:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bec:	83 e0 ef             	and    $0xffffffef,%eax
  103bef:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf4:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bfb:	83 e0 9f             	and    $0xffffff9f,%eax
  103bfe:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c03:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c0a:	83 c8 80             	or     $0xffffff80,%eax
  103c0d:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c12:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c19:	83 e0 f0             	and    $0xfffffff0,%eax
  103c1c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c21:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c28:	83 e0 ef             	and    $0xffffffef,%eax
  103c2b:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c30:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c37:	83 e0 df             	and    $0xffffffdf,%eax
  103c3a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c3f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c46:	83 c8 40             	or     $0x40,%eax
  103c49:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c4e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c55:	83 e0 7f             	and    $0x7f,%eax
  103c58:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c5d:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c62:	c1 e8 18             	shr    $0x18,%eax
  103c65:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c6a:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c71:	e8 de fe ff ff       	call   103b54 <lgdt>
  103c76:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c7c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c80:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c83:	c9                   	leave  
  103c84:	c3                   	ret    

00103c85 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c85:	55                   	push   %ebp
  103c86:	89 e5                	mov    %esp,%ebp
  103c88:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c8b:	c7 05 5c 89 11 00 d0 	movl   $0x1069d0,0x11895c
  103c92:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c95:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c9a:	8b 00                	mov    (%eax),%eax
  103c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ca0:	c7 04 24 6c 6a 10 00 	movl   $0x106a6c,(%esp)
  103ca7:	e8 90 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103cac:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cb1:	8b 40 04             	mov    0x4(%eax),%eax
  103cb4:	ff d0                	call   *%eax
}
  103cb6:	c9                   	leave  
  103cb7:	c3                   	ret    

00103cb8 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103cb8:	55                   	push   %ebp
  103cb9:	89 e5                	mov    %esp,%ebp
  103cbb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103cbe:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cc3:	8b 40 08             	mov    0x8(%eax),%eax
  103cc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cc9:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ccd:	8b 55 08             	mov    0x8(%ebp),%edx
  103cd0:	89 14 24             	mov    %edx,(%esp)
  103cd3:	ff d0                	call   *%eax
}
  103cd5:	c9                   	leave  
  103cd6:	c3                   	ret    

00103cd7 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cd7:	55                   	push   %ebp
  103cd8:	89 e5                	mov    %esp,%ebp
  103cda:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ce4:	e8 2e fe ff ff       	call   103b17 <__intr_save>
  103ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cec:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  103cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  103cf7:	89 14 24             	mov    %edx,(%esp)
  103cfa:	ff d0                	call   *%eax
  103cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d02:	89 04 24             	mov    %eax,(%esp)
  103d05:	e8 37 fe ff ff       	call   103b41 <__intr_restore>
    return page;
  103d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d0d:	c9                   	leave  
  103d0e:	c3                   	ret    

00103d0f <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d0f:	55                   	push   %ebp
  103d10:	89 e5                	mov    %esp,%ebp
  103d12:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d15:	e8 fd fd ff ff       	call   103b17 <__intr_save>
  103d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d1d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d22:	8b 40 10             	mov    0x10(%eax),%eax
  103d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d28:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  103d2f:	89 14 24             	mov    %edx,(%esp)
  103d32:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d37:	89 04 24             	mov    %eax,(%esp)
  103d3a:	e8 02 fe ff ff       	call   103b41 <__intr_restore>
}
  103d3f:	c9                   	leave  
  103d40:	c3                   	ret    

00103d41 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d41:	55                   	push   %ebp
  103d42:	89 e5                	mov    %esp,%ebp
  103d44:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d47:	e8 cb fd ff ff       	call   103b17 <__intr_save>
  103d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d4f:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d54:	8b 40 14             	mov    0x14(%eax),%eax
  103d57:	ff d0                	call   *%eax
  103d59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d5f:	89 04 24             	mov    %eax,(%esp)
  103d62:	e8 da fd ff ff       	call   103b41 <__intr_restore>
    return ret;
  103d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d6a:	c9                   	leave  
  103d6b:	c3                   	ret    

00103d6c <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d6c:	55                   	push   %ebp
  103d6d:	89 e5                	mov    %esp,%ebp
  103d6f:	57                   	push   %edi
  103d70:	56                   	push   %esi
  103d71:	53                   	push   %ebx
  103d72:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d78:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d7f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d8d:	c7 04 24 83 6a 10 00 	movl   $0x106a83,(%esp)
  103d94:	e8 a3 c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d99:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103da0:	e9 15 01 00 00       	jmp    103eba <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103da5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103da8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dab:	89 d0                	mov    %edx,%eax
  103dad:	c1 e0 02             	shl    $0x2,%eax
  103db0:	01 d0                	add    %edx,%eax
  103db2:	c1 e0 02             	shl    $0x2,%eax
  103db5:	01 c8                	add    %ecx,%eax
  103db7:	8b 50 08             	mov    0x8(%eax),%edx
  103dba:	8b 40 04             	mov    0x4(%eax),%eax
  103dbd:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103dc0:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103dc3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dc9:	89 d0                	mov    %edx,%eax
  103dcb:	c1 e0 02             	shl    $0x2,%eax
  103dce:	01 d0                	add    %edx,%eax
  103dd0:	c1 e0 02             	shl    $0x2,%eax
  103dd3:	01 c8                	add    %ecx,%eax
  103dd5:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dd8:	8b 58 10             	mov    0x10(%eax),%ebx
  103ddb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dde:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103de1:	01 c8                	add    %ecx,%eax
  103de3:	11 da                	adc    %ebx,%edx
  103de5:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103de8:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103deb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103df1:	89 d0                	mov    %edx,%eax
  103df3:	c1 e0 02             	shl    $0x2,%eax
  103df6:	01 d0                	add    %edx,%eax
  103df8:	c1 e0 02             	shl    $0x2,%eax
  103dfb:	01 c8                	add    %ecx,%eax
  103dfd:	83 c0 14             	add    $0x14,%eax
  103e00:	8b 00                	mov    (%eax),%eax
  103e02:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e08:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e0b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e0e:	83 c0 ff             	add    $0xffffffff,%eax
  103e11:	83 d2 ff             	adc    $0xffffffff,%edx
  103e14:	89 c6                	mov    %eax,%esi
  103e16:	89 d7                	mov    %edx,%edi
  103e18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e1e:	89 d0                	mov    %edx,%eax
  103e20:	c1 e0 02             	shl    $0x2,%eax
  103e23:	01 d0                	add    %edx,%eax
  103e25:	c1 e0 02             	shl    $0x2,%eax
  103e28:	01 c8                	add    %ecx,%eax
  103e2a:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e2d:	8b 58 10             	mov    0x10(%eax),%ebx
  103e30:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e36:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e3a:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e3e:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e42:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e45:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e48:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e4c:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e50:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e54:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e58:	c7 04 24 90 6a 10 00 	movl   $0x106a90,(%esp)
  103e5f:	e8 d8 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e64:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e67:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e6a:	89 d0                	mov    %edx,%eax
  103e6c:	c1 e0 02             	shl    $0x2,%eax
  103e6f:	01 d0                	add    %edx,%eax
  103e71:	c1 e0 02             	shl    $0x2,%eax
  103e74:	01 c8                	add    %ecx,%eax
  103e76:	83 c0 14             	add    $0x14,%eax
  103e79:	8b 00                	mov    (%eax),%eax
  103e7b:	83 f8 01             	cmp    $0x1,%eax
  103e7e:	75 36                	jne    103eb6 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e86:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e89:	77 2b                	ja     103eb6 <page_init+0x14a>
  103e8b:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e8e:	72 05                	jb     103e95 <page_init+0x129>
  103e90:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e93:	73 21                	jae    103eb6 <page_init+0x14a>
  103e95:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e99:	77 1b                	ja     103eb6 <page_init+0x14a>
  103e9b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e9f:	72 09                	jb     103eaa <page_init+0x13e>
  103ea1:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103ea8:	77 0c                	ja     103eb6 <page_init+0x14a>
                maxpa = end;
  103eaa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103ead:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103eb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103eb3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103eb6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103eba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ebd:	8b 00                	mov    (%eax),%eax
  103ebf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ec2:	0f 8f dd fe ff ff    	jg     103da5 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103ec8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ecc:	72 1d                	jb     103eeb <page_init+0x17f>
  103ece:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ed2:	77 09                	ja     103edd <page_init+0x171>
  103ed4:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103edb:	76 0e                	jbe    103eeb <page_init+0x17f>
        maxpa = KMEMSIZE;
  103edd:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ee4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103eee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ef1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ef5:	c1 ea 0c             	shr    $0xc,%edx
  103ef8:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103efd:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f04:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f09:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f0c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f0f:	01 d0                	add    %edx,%eax
  103f11:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f14:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f17:	ba 00 00 00 00       	mov    $0x0,%edx
  103f1c:	f7 75 ac             	divl   -0x54(%ebp)
  103f1f:	89 d0                	mov    %edx,%eax
  103f21:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f24:	29 c2                	sub    %eax,%edx
  103f26:	89 d0                	mov    %edx,%eax
  103f28:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f2d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f34:	eb 2f                	jmp    103f65 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f36:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f3f:	89 d0                	mov    %edx,%eax
  103f41:	c1 e0 02             	shl    $0x2,%eax
  103f44:	01 d0                	add    %edx,%eax
  103f46:	c1 e0 02             	shl    $0x2,%eax
  103f49:	01 c8                	add    %ecx,%eax
  103f4b:	83 c0 04             	add    $0x4,%eax
  103f4e:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f55:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f58:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f5b:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f5e:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f61:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f65:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f68:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f6d:	39 c2                	cmp    %eax,%edx
  103f6f:	72 c5                	jb     103f36 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f71:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f77:	89 d0                	mov    %edx,%eax
  103f79:	c1 e0 02             	shl    $0x2,%eax
  103f7c:	01 d0                	add    %edx,%eax
  103f7e:	c1 e0 02             	shl    $0x2,%eax
  103f81:	89 c2                	mov    %eax,%edx
  103f83:	a1 64 89 11 00       	mov    0x118964,%eax
  103f88:	01 d0                	add    %edx,%eax
  103f8a:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f8d:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f94:	77 23                	ja     103fb9 <page_init+0x24d>
  103f96:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f99:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f9d:	c7 44 24 08 c0 6a 10 	movl   $0x106ac0,0x8(%esp)
  103fa4:	00 
  103fa5:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103fac:	00 
  103fad:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  103fb4:	e8 0d cd ff ff       	call   100cc6 <__panic>
  103fb9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fbc:	05 00 00 00 40       	add    $0x40000000,%eax
  103fc1:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fc4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fcb:	e9 74 01 00 00       	jmp    104144 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fd0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fd6:	89 d0                	mov    %edx,%eax
  103fd8:	c1 e0 02             	shl    $0x2,%eax
  103fdb:	01 d0                	add    %edx,%eax
  103fdd:	c1 e0 02             	shl    $0x2,%eax
  103fe0:	01 c8                	add    %ecx,%eax
  103fe2:	8b 50 08             	mov    0x8(%eax),%edx
  103fe5:	8b 40 04             	mov    0x4(%eax),%eax
  103fe8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103feb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ff1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ff4:	89 d0                	mov    %edx,%eax
  103ff6:	c1 e0 02             	shl    $0x2,%eax
  103ff9:	01 d0                	add    %edx,%eax
  103ffb:	c1 e0 02             	shl    $0x2,%eax
  103ffe:	01 c8                	add    %ecx,%eax
  104000:	8b 48 0c             	mov    0xc(%eax),%ecx
  104003:	8b 58 10             	mov    0x10(%eax),%ebx
  104006:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104009:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10400c:	01 c8                	add    %ecx,%eax
  10400e:	11 da                	adc    %ebx,%edx
  104010:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104013:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104016:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104019:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10401c:	89 d0                	mov    %edx,%eax
  10401e:	c1 e0 02             	shl    $0x2,%eax
  104021:	01 d0                	add    %edx,%eax
  104023:	c1 e0 02             	shl    $0x2,%eax
  104026:	01 c8                	add    %ecx,%eax
  104028:	83 c0 14             	add    $0x14,%eax
  10402b:	8b 00                	mov    (%eax),%eax
  10402d:	83 f8 01             	cmp    $0x1,%eax
  104030:	0f 85 0a 01 00 00    	jne    104140 <page_init+0x3d4>
            if (begin < freemem) {
  104036:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104039:	ba 00 00 00 00       	mov    $0x0,%edx
  10403e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104041:	72 17                	jb     10405a <page_init+0x2ee>
  104043:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104046:	77 05                	ja     10404d <page_init+0x2e1>
  104048:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10404b:	76 0d                	jbe    10405a <page_init+0x2ee>
                begin = freemem;
  10404d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104050:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104053:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10405a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10405e:	72 1d                	jb     10407d <page_init+0x311>
  104060:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104064:	77 09                	ja     10406f <page_init+0x303>
  104066:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10406d:	76 0e                	jbe    10407d <page_init+0x311>
                end = KMEMSIZE;
  10406f:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104076:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10407d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104080:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104083:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104086:	0f 87 b4 00 00 00    	ja     104140 <page_init+0x3d4>
  10408c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10408f:	72 09                	jb     10409a <page_init+0x32e>
  104091:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104094:	0f 83 a6 00 00 00    	jae    104140 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  10409a:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040a4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040a7:	01 d0                	add    %edx,%eax
  1040a9:	83 e8 01             	sub    $0x1,%eax
  1040ac:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040af:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040b2:	ba 00 00 00 00       	mov    $0x0,%edx
  1040b7:	f7 75 9c             	divl   -0x64(%ebp)
  1040ba:	89 d0                	mov    %edx,%eax
  1040bc:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040bf:	29 c2                	sub    %eax,%edx
  1040c1:	89 d0                	mov    %edx,%eax
  1040c3:	ba 00 00 00 00       	mov    $0x0,%edx
  1040c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040d1:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040d4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040d7:	ba 00 00 00 00       	mov    $0x0,%edx
  1040dc:	89 c7                	mov    %eax,%edi
  1040de:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040e4:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040e7:	89 d0                	mov    %edx,%eax
  1040e9:	83 e0 00             	and    $0x0,%eax
  1040ec:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040ef:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040f2:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040f8:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104101:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104104:	77 3a                	ja     104140 <page_init+0x3d4>
  104106:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104109:	72 05                	jb     104110 <page_init+0x3a4>
  10410b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10410e:	73 30                	jae    104140 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104110:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104113:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104116:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104119:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10411c:	29 c8                	sub    %ecx,%eax
  10411e:	19 da                	sbb    %ebx,%edx
  104120:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104124:	c1 ea 0c             	shr    $0xc,%edx
  104127:	89 c3                	mov    %eax,%ebx
  104129:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10412c:	89 04 24             	mov    %eax,(%esp)
  10412f:	e8 a5 f8 ff ff       	call   1039d9 <pa2page>
  104134:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104138:	89 04 24             	mov    %eax,(%esp)
  10413b:	e8 78 fb ff ff       	call   103cb8 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104140:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104144:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104147:	8b 00                	mov    (%eax),%eax
  104149:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10414c:	0f 8f 7e fe ff ff    	jg     103fd0 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104152:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104158:	5b                   	pop    %ebx
  104159:	5e                   	pop    %esi
  10415a:	5f                   	pop    %edi
  10415b:	5d                   	pop    %ebp
  10415c:	c3                   	ret    

0010415d <enable_paging>:

static void
enable_paging(void) {
  10415d:	55                   	push   %ebp
  10415e:	89 e5                	mov    %esp,%ebp
  104160:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  104163:	a1 60 89 11 00       	mov    0x118960,%eax
  104168:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  10416b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10416e:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104171:	0f 20 c0             	mov    %cr0,%eax
  104174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  104177:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10417a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  10417d:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104184:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10418b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  10418e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104191:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104194:	c9                   	leave  
  104195:	c3                   	ret    

00104196 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104196:	55                   	push   %ebp
  104197:	89 e5                	mov    %esp,%ebp
  104199:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10419c:	8b 45 14             	mov    0x14(%ebp),%eax
  10419f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041a2:	31 d0                	xor    %edx,%eax
  1041a4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041a9:	85 c0                	test   %eax,%eax
  1041ab:	74 24                	je     1041d1 <boot_map_segment+0x3b>
  1041ad:	c7 44 24 0c f2 6a 10 	movl   $0x106af2,0xc(%esp)
  1041b4:	00 
  1041b5:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1041bc:	00 
  1041bd:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041c4:	00 
  1041c5:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1041cc:	e8 f5 ca ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041d1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041db:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041e0:	89 c2                	mov    %eax,%edx
  1041e2:	8b 45 10             	mov    0x10(%ebp),%eax
  1041e5:	01 c2                	add    %eax,%edx
  1041e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041ea:	01 d0                	add    %edx,%eax
  1041ec:	83 e8 01             	sub    $0x1,%eax
  1041ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1041fa:	f7 75 f0             	divl   -0x10(%ebp)
  1041fd:	89 d0                	mov    %edx,%eax
  1041ff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104202:	29 c2                	sub    %eax,%edx
  104204:	89 d0                	mov    %edx,%eax
  104206:	c1 e8 0c             	shr    $0xc,%eax
  104209:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10420c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10420f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104215:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10421a:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10421d:	8b 45 14             	mov    0x14(%ebp),%eax
  104220:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10422b:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10422e:	eb 6b                	jmp    10429b <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104237:	00 
  104238:	8b 45 0c             	mov    0xc(%ebp),%eax
  10423b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10423f:	8b 45 08             	mov    0x8(%ebp),%eax
  104242:	89 04 24             	mov    %eax,(%esp)
  104245:	e8 cc 01 00 00       	call   104416 <get_pte>
  10424a:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10424d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104251:	75 24                	jne    104277 <boot_map_segment+0xe1>
  104253:	c7 44 24 0c 1e 6b 10 	movl   $0x106b1e,0xc(%esp)
  10425a:	00 
  10425b:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104262:	00 
  104263:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  10426a:	00 
  10426b:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104272:	e8 4f ca ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  104277:	8b 45 18             	mov    0x18(%ebp),%eax
  10427a:	8b 55 14             	mov    0x14(%ebp),%edx
  10427d:	09 d0                	or     %edx,%eax
  10427f:	83 c8 01             	or     $0x1,%eax
  104282:	89 c2                	mov    %eax,%edx
  104284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104287:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10428d:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104294:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10429b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10429f:	75 8f                	jne    104230 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042a1:	c9                   	leave  
  1042a2:	c3                   	ret    

001042a3 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042a3:	55                   	push   %ebp
  1042a4:	89 e5                	mov    %esp,%ebp
  1042a6:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042a9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042b0:	e8 22 fa ff ff       	call   103cd7 <alloc_pages>
  1042b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042bc:	75 1c                	jne    1042da <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042be:	c7 44 24 08 2b 6b 10 	movl   $0x106b2b,0x8(%esp)
  1042c5:	00 
  1042c6:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042cd:	00 
  1042ce:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1042d5:	e8 ec c9 ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  1042da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042dd:	89 04 24             	mov    %eax,(%esp)
  1042e0:	e8 43 f7 ff ff       	call   103a28 <page2kva>
}
  1042e5:	c9                   	leave  
  1042e6:	c3                   	ret    

001042e7 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042e7:	55                   	push   %ebp
  1042e8:	89 e5                	mov    %esp,%ebp
  1042ea:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042ed:	e8 93 f9 ff ff       	call   103c85 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042f2:	e8 75 fa ff ff       	call   103d6c <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042f7:	e8 66 04 00 00       	call   104762 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042fc:	e8 a2 ff ff ff       	call   1042a3 <boot_alloc_page>
  104301:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104306:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10430b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104312:	00 
  104313:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10431a:	00 
  10431b:	89 04 24             	mov    %eax,(%esp)
  10431e:	e8 a3 1a 00 00       	call   105dc6 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104323:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104328:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10432b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104332:	77 23                	ja     104357 <pmm_init+0x70>
  104334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10433b:	c7 44 24 08 c0 6a 10 	movl   $0x106ac0,0x8(%esp)
  104342:	00 
  104343:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10434a:	00 
  10434b:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104352:	e8 6f c9 ff ff       	call   100cc6 <__panic>
  104357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10435a:	05 00 00 00 40       	add    $0x40000000,%eax
  10435f:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  104364:	e8 17 04 00 00       	call   104780 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104369:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10436e:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104374:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104379:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10437c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104383:	77 23                	ja     1043a8 <pmm_init+0xc1>
  104385:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104388:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10438c:	c7 44 24 08 c0 6a 10 	movl   $0x106ac0,0x8(%esp)
  104393:	00 
  104394:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  10439b:	00 
  10439c:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1043a3:	e8 1e c9 ff ff       	call   100cc6 <__panic>
  1043a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ab:	05 00 00 00 40       	add    $0x40000000,%eax
  1043b0:	83 c8 03             	or     $0x3,%eax
  1043b3:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043b5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ba:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043c1:	00 
  1043c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043c9:	00 
  1043ca:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043d1:	38 
  1043d2:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043d9:	c0 
  1043da:	89 04 24             	mov    %eax,(%esp)
  1043dd:	e8 b4 fd ff ff       	call   104196 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043e2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043e7:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043ed:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043f3:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043f5:	e8 63 fd ff ff       	call   10415d <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043fa:	e8 97 f7 ff ff       	call   103b96 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043ff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104404:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10440a:	e8 0c 0a 00 00       	call   104e1b <check_boot_pgdir>

    print_pgdir();
  10440f:	e8 94 0e 00 00       	call   1052a8 <print_pgdir>

}
  104414:	c9                   	leave  
  104415:	c3                   	ret    

00104416 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104416:	55                   	push   %ebp
  104417:	89 e5                	mov    %esp,%ebp
  104419:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)]; //≥¢ ‘ªÒ»°“≥±Ì
  10441c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10441f:	c1 e8 16             	shr    $0x16,%eax
  104422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104429:	8b 45 08             	mov    0x8(%ebp),%eax
  10442c:	01 d0                	add    %edx,%eax
  10442e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) { //»ÙªÒ»°≤ª≥…π¶‘Ú…Í«Î“ª“≥
  104431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104434:	8b 00                	mov    (%eax),%eax
  104436:	83 e0 01             	and    $0x1,%eax
  104439:	85 c0                	test   %eax,%eax
  10443b:	0f 85 af 00 00 00    	jne    1044f0 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  104441:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104445:	74 15                	je     10445c <get_pte+0x46>
  104447:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10444e:	e8 84 f8 ff ff       	call   103cd7 <alloc_pages>
  104453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10445a:	75 0a                	jne    104466 <get_pte+0x50>
            return NULL;
  10445c:	b8 00 00 00 00       	mov    $0x0,%eax
  104461:	e9 e6 00 00 00       	jmp    10454c <get_pte+0x136>
        }
        set_page_ref(page, 1);
  104466:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10446d:	00 
  10446e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104471:	89 04 24             	mov    %eax,(%esp)
  104474:	e8 63 f6 ff ff       	call   103adc <set_page_ref>
        uintptr_t pa = page2pa(page); //ªÒ»°œﬂ–‘µÿ÷∑
  104479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10447c:	89 04 24             	mov    %eax,(%esp)
  10447f:	e8 3f f5 ff ff       	call   1039c3 <page2pa>
  104484:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  104487:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10448a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10448d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104490:	c1 e8 0c             	shr    $0xc,%eax
  104493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104496:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10449b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10449e:	72 23                	jb     1044c3 <get_pte+0xad>
  1044a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044a7:	c7 44 24 08 1c 6a 10 	movl   $0x106a1c,0x8(%esp)
  1044ae:	00 
  1044af:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
  1044b6:	00 
  1044b7:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1044be:	e8 03 c8 ff ff       	call   100cc6 <__panic>
  1044c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044c6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044cb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044d2:	00 
  1044d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044da:	00 
  1044db:	89 04 24             	mov    %eax,(%esp)
  1044de:	e8 e3 18 00 00       	call   105dc6 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  1044e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044e6:	83 c8 07             	or     $0x7,%eax
  1044e9:	89 c2                	mov    %eax,%edx
  1044eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ee:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)]; //∑µªÿ“≥±ÌŒª÷√
  1044f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044f3:	8b 00                	mov    (%eax),%eax
  1044f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1044fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104500:	c1 e8 0c             	shr    $0xc,%eax
  104503:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104506:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10450b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10450e:	72 23                	jb     104533 <get_pte+0x11d>
  104510:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104513:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104517:	c7 44 24 08 1c 6a 10 	movl   $0x106a1c,0x8(%esp)
  10451e:	00 
  10451f:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  104526:	00 
  104527:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  10452e:	e8 93 c7 ff ff       	call   100cc6 <__panic>
  104533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104536:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10453b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10453e:	c1 ea 0c             	shr    $0xc,%edx
  104541:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104547:	c1 e2 02             	shl    $0x2,%edx
  10454a:	01 d0                	add    %edx,%eax
}
  10454c:	c9                   	leave  
  10454d:	c3                   	ret    

0010454e <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10454e:	55                   	push   %ebp
  10454f:	89 e5                	mov    %esp,%ebp
  104551:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104554:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10455b:	00 
  10455c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10455f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104563:	8b 45 08             	mov    0x8(%ebp),%eax
  104566:	89 04 24             	mov    %eax,(%esp)
  104569:	e8 a8 fe ff ff       	call   104416 <get_pte>
  10456e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104571:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104575:	74 08                	je     10457f <get_page+0x31>
        *ptep_store = ptep;
  104577:	8b 45 10             	mov    0x10(%ebp),%eax
  10457a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10457d:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10457f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104583:	74 1b                	je     1045a0 <get_page+0x52>
  104585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104588:	8b 00                	mov    (%eax),%eax
  10458a:	83 e0 01             	and    $0x1,%eax
  10458d:	85 c0                	test   %eax,%eax
  10458f:	74 0f                	je     1045a0 <get_page+0x52>
        return pte2page(*ptep);
  104591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104594:	8b 00                	mov    (%eax),%eax
  104596:	89 04 24             	mov    %eax,(%esp)
  104599:	e8 de f4 ff ff       	call   103a7c <pte2page>
  10459e:	eb 05                	jmp    1045a5 <get_page+0x57>
    }
    return NULL;
  1045a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045a5:	c9                   	leave  
  1045a6:	c3                   	ret    

001045a7 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045a7:	55                   	push   %ebp
  1045a8:	89 e5                	mov    %esp,%ebp
  1045aa:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) { //≈–∂œ“≥±Ì»Îø⁄ «∑Ò¥Ê‘⁄
  1045ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1045b0:	8b 00                	mov    (%eax),%eax
  1045b2:	83 e0 01             	and    $0x1,%eax
  1045b5:	85 c0                	test   %eax,%eax
  1045b7:	74 4d                	je     104606 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  1045b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1045bc:	8b 00                	mov    (%eax),%eax
  1045be:	89 04 24             	mov    %eax,(%esp)
  1045c1:	e8 b6 f4 ff ff       	call   103a7c <pte2page>
  1045c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) { //»ÙΩˆ±ª“˝”√1¥Œ‘Úø… Õ∑≈∏√“≥£¨∑Ò‘Ú≤ª––
  1045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045cc:	89 04 24             	mov    %eax,(%esp)
  1045cf:	e8 2c f5 ff ff       	call   103b00 <page_ref_dec>
  1045d4:	85 c0                	test   %eax,%eax
  1045d6:	75 13                	jne    1045eb <page_remove_pte+0x44>
            free_page(page);
  1045d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045df:	00 
  1045e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e3:	89 04 24             	mov    %eax,(%esp)
  1045e6:	e8 24 f7 ff ff       	call   103d0f <free_pages>
        }
        *ptep = 0;
  1045eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  1045f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1045fe:	89 04 24             	mov    %eax,(%esp)
  104601:	e8 ff 00 00 00       	call   104705 <tlb_invalidate>
    }
}
  104606:	c9                   	leave  
  104607:	c3                   	ret    

00104608 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104608:	55                   	push   %ebp
  104609:	89 e5                	mov    %esp,%ebp
  10460b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10460e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104615:	00 
  104616:	8b 45 0c             	mov    0xc(%ebp),%eax
  104619:	89 44 24 04          	mov    %eax,0x4(%esp)
  10461d:	8b 45 08             	mov    0x8(%ebp),%eax
  104620:	89 04 24             	mov    %eax,(%esp)
  104623:	e8 ee fd ff ff       	call   104416 <get_pte>
  104628:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10462b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10462f:	74 19                	je     10464a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104634:	89 44 24 08          	mov    %eax,0x8(%esp)
  104638:	8b 45 0c             	mov    0xc(%ebp),%eax
  10463b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10463f:	8b 45 08             	mov    0x8(%ebp),%eax
  104642:	89 04 24             	mov    %eax,(%esp)
  104645:	e8 5d ff ff ff       	call   1045a7 <page_remove_pte>
    }
}
  10464a:	c9                   	leave  
  10464b:	c3                   	ret    

0010464c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10464c:	55                   	push   %ebp
  10464d:	89 e5                	mov    %esp,%ebp
  10464f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104652:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104659:	00 
  10465a:	8b 45 10             	mov    0x10(%ebp),%eax
  10465d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104661:	8b 45 08             	mov    0x8(%ebp),%eax
  104664:	89 04 24             	mov    %eax,(%esp)
  104667:	e8 aa fd ff ff       	call   104416 <get_pte>
  10466c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10466f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104673:	75 0a                	jne    10467f <page_insert+0x33>
        return -E_NO_MEM;
  104675:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10467a:	e9 84 00 00 00       	jmp    104703 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10467f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104682:	89 04 24             	mov    %eax,(%esp)
  104685:	e8 5f f4 ff ff       	call   103ae9 <page_ref_inc>
    if (*ptep & PTE_P) {
  10468a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10468d:	8b 00                	mov    (%eax),%eax
  10468f:	83 e0 01             	and    $0x1,%eax
  104692:	85 c0                	test   %eax,%eax
  104694:	74 3e                	je     1046d4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104699:	8b 00                	mov    (%eax),%eax
  10469b:	89 04 24             	mov    %eax,(%esp)
  10469e:	e8 d9 f3 ff ff       	call   103a7c <pte2page>
  1046a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046a9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046ac:	75 0d                	jne    1046bb <page_insert+0x6f>
            page_ref_dec(page);
  1046ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b1:	89 04 24             	mov    %eax,(%esp)
  1046b4:	e8 47 f4 ff ff       	call   103b00 <page_ref_dec>
  1046b9:	eb 19                	jmp    1046d4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1046c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1046cc:	89 04 24             	mov    %eax,(%esp)
  1046cf:	e8 d3 fe ff ff       	call   1045a7 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046d7:	89 04 24             	mov    %eax,(%esp)
  1046da:	e8 e4 f2 ff ff       	call   1039c3 <page2pa>
  1046df:	0b 45 14             	or     0x14(%ebp),%eax
  1046e2:	83 c8 01             	or     $0x1,%eax
  1046e5:	89 c2                	mov    %eax,%edx
  1046e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ea:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1046ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1046f6:	89 04 24             	mov    %eax,(%esp)
  1046f9:	e8 07 00 00 00       	call   104705 <tlb_invalidate>
    return 0;
  1046fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104703:	c9                   	leave  
  104704:	c3                   	ret    

00104705 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104705:	55                   	push   %ebp
  104706:	89 e5                	mov    %esp,%ebp
  104708:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10470b:	0f 20 d8             	mov    %cr3,%eax
  10470e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104711:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104714:	89 c2                	mov    %eax,%edx
  104716:	8b 45 08             	mov    0x8(%ebp),%eax
  104719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10471c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104723:	77 23                	ja     104748 <tlb_invalidate+0x43>
  104725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104728:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10472c:	c7 44 24 08 c0 6a 10 	movl   $0x106ac0,0x8(%esp)
  104733:	00 
  104734:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  10473b:	00 
  10473c:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104743:	e8 7e c5 ff ff       	call   100cc6 <__panic>
  104748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10474b:	05 00 00 00 40       	add    $0x40000000,%eax
  104750:	39 c2                	cmp    %eax,%edx
  104752:	75 0c                	jne    104760 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104754:	8b 45 0c             	mov    0xc(%ebp),%eax
  104757:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10475a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10475d:	0f 01 38             	invlpg (%eax)
    }
}
  104760:	c9                   	leave  
  104761:	c3                   	ret    

00104762 <check_alloc_page>:

static void
check_alloc_page(void) {
  104762:	55                   	push   %ebp
  104763:	89 e5                	mov    %esp,%ebp
  104765:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104768:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10476d:	8b 40 18             	mov    0x18(%eax),%eax
  104770:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104772:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104779:	e8 be bb ff ff       	call   10033c <cprintf>
}
  10477e:	c9                   	leave  
  10477f:	c3                   	ret    

00104780 <check_pgdir>:

static void
check_pgdir(void) {
  104780:	55                   	push   %ebp
  104781:	89 e5                	mov    %esp,%ebp
  104783:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104786:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10478b:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104790:	76 24                	jbe    1047b6 <check_pgdir+0x36>
  104792:	c7 44 24 0c 63 6b 10 	movl   $0x106b63,0xc(%esp)
  104799:	00 
  10479a:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1047a1:	00 
  1047a2:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  1047a9:	00 
  1047aa:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1047b1:	e8 10 c5 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047b6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047bb:	85 c0                	test   %eax,%eax
  1047bd:	74 0e                	je     1047cd <check_pgdir+0x4d>
  1047bf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047c4:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047c9:	85 c0                	test   %eax,%eax
  1047cb:	74 24                	je     1047f1 <check_pgdir+0x71>
  1047cd:	c7 44 24 0c 80 6b 10 	movl   $0x106b80,0xc(%esp)
  1047d4:	00 
  1047d5:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1047dc:	00 
  1047dd:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  1047e4:	00 
  1047e5:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1047ec:	e8 d5 c4 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1047f1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047fd:	00 
  1047fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104805:	00 
  104806:	89 04 24             	mov    %eax,(%esp)
  104809:	e8 40 fd ff ff       	call   10454e <get_page>
  10480e:	85 c0                	test   %eax,%eax
  104810:	74 24                	je     104836 <check_pgdir+0xb6>
  104812:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  104819:	00 
  10481a:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104821:	00 
  104822:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104829:	00 
  10482a:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104831:	e8 90 c4 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104836:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10483d:	e8 95 f4 ff ff       	call   103cd7 <alloc_pages>
  104842:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104845:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10484a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104851:	00 
  104852:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104859:	00 
  10485a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10485d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104861:	89 04 24             	mov    %eax,(%esp)
  104864:	e8 e3 fd ff ff       	call   10464c <page_insert>
  104869:	85 c0                	test   %eax,%eax
  10486b:	74 24                	je     104891 <check_pgdir+0x111>
  10486d:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  104874:	00 
  104875:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  10487c:	00 
  10487d:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104884:	00 
  104885:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  10488c:	e8 35 c4 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104891:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104896:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10489d:	00 
  10489e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048a5:	00 
  1048a6:	89 04 24             	mov    %eax,(%esp)
  1048a9:	e8 68 fb ff ff       	call   104416 <get_pte>
  1048ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048b5:	75 24                	jne    1048db <check_pgdir+0x15b>
  1048b7:	c7 44 24 0c 0c 6c 10 	movl   $0x106c0c,0xc(%esp)
  1048be:	00 
  1048bf:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1048c6:	00 
  1048c7:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1048ce:	00 
  1048cf:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1048d6:	e8 eb c3 ff ff       	call   100cc6 <__panic>
    assert(pte2page(*ptep) == p1);
  1048db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048de:	8b 00                	mov    (%eax),%eax
  1048e0:	89 04 24             	mov    %eax,(%esp)
  1048e3:	e8 94 f1 ff ff       	call   103a7c <pte2page>
  1048e8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048eb:	74 24                	je     104911 <check_pgdir+0x191>
  1048ed:	c7 44 24 0c 39 6c 10 	movl   $0x106c39,0xc(%esp)
  1048f4:	00 
  1048f5:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1048fc:	00 
  1048fd:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104904:	00 
  104905:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  10490c:	e8 b5 c3 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  104911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104914:	89 04 24             	mov    %eax,(%esp)
  104917:	e8 b6 f1 ff ff       	call   103ad2 <page_ref>
  10491c:	83 f8 01             	cmp    $0x1,%eax
  10491f:	74 24                	je     104945 <check_pgdir+0x1c5>
  104921:	c7 44 24 0c 4f 6c 10 	movl   $0x106c4f,0xc(%esp)
  104928:	00 
  104929:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104930:	00 
  104931:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104938:	00 
  104939:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104940:	e8 81 c3 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104945:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10494a:	8b 00                	mov    (%eax),%eax
  10494c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104951:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104957:	c1 e8 0c             	shr    $0xc,%eax
  10495a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10495d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104962:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104965:	72 23                	jb     10498a <check_pgdir+0x20a>
  104967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10496a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10496e:	c7 44 24 08 1c 6a 10 	movl   $0x106a1c,0x8(%esp)
  104975:	00 
  104976:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  10497d:	00 
  10497e:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104985:	e8 3c c3 ff ff       	call   100cc6 <__panic>
  10498a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10498d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104992:	83 c0 04             	add    $0x4,%eax
  104995:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104998:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10499d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049a4:	00 
  1049a5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049ac:	00 
  1049ad:	89 04 24             	mov    %eax,(%esp)
  1049b0:	e8 61 fa ff ff       	call   104416 <get_pte>
  1049b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049b8:	74 24                	je     1049de <check_pgdir+0x25e>
  1049ba:	c7 44 24 0c 64 6c 10 	movl   $0x106c64,0xc(%esp)
  1049c1:	00 
  1049c2:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1049c9:	00 
  1049ca:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1049d1:	00 
  1049d2:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1049d9:	e8 e8 c2 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  1049de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049e5:	e8 ed f2 ff ff       	call   103cd7 <alloc_pages>
  1049ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1049ed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049f2:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1049f9:	00 
  1049fa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a01:	00 
  104a02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a05:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a09:	89 04 24             	mov    %eax,(%esp)
  104a0c:	e8 3b fc ff ff       	call   10464c <page_insert>
  104a11:	85 c0                	test   %eax,%eax
  104a13:	74 24                	je     104a39 <check_pgdir+0x2b9>
  104a15:	c7 44 24 0c 8c 6c 10 	movl   $0x106c8c,0xc(%esp)
  104a1c:	00 
  104a1d:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104a24:	00 
  104a25:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104a2c:	00 
  104a2d:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104a34:	e8 8d c2 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a39:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a3e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a45:	00 
  104a46:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a4d:	00 
  104a4e:	89 04 24             	mov    %eax,(%esp)
  104a51:	e8 c0 f9 ff ff       	call   104416 <get_pte>
  104a56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a5d:	75 24                	jne    104a83 <check_pgdir+0x303>
  104a5f:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104a66:	00 
  104a67:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104a6e:	00 
  104a6f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104a76:	00 
  104a77:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104a7e:	e8 43 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  104a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a86:	8b 00                	mov    (%eax),%eax
  104a88:	83 e0 04             	and    $0x4,%eax
  104a8b:	85 c0                	test   %eax,%eax
  104a8d:	75 24                	jne    104ab3 <check_pgdir+0x333>
  104a8f:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  104a96:	00 
  104a97:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104a9e:	00 
  104a9f:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104aa6:	00 
  104aa7:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104aae:	e8 13 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  104ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ab6:	8b 00                	mov    (%eax),%eax
  104ab8:	83 e0 02             	and    $0x2,%eax
  104abb:	85 c0                	test   %eax,%eax
  104abd:	75 24                	jne    104ae3 <check_pgdir+0x363>
  104abf:	c7 44 24 0c 02 6d 10 	movl   $0x106d02,0xc(%esp)
  104ac6:	00 
  104ac7:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104ace:	00 
  104acf:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ad6:	00 
  104ad7:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104ade:	e8 e3 c1 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ae3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ae8:	8b 00                	mov    (%eax),%eax
  104aea:	83 e0 04             	and    $0x4,%eax
  104aed:	85 c0                	test   %eax,%eax
  104aef:	75 24                	jne    104b15 <check_pgdir+0x395>
  104af1:	c7 44 24 0c 10 6d 10 	movl   $0x106d10,0xc(%esp)
  104af8:	00 
  104af9:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104b00:	00 
  104b01:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104b08:	00 
  104b09:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104b10:	e8 b1 c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  104b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b18:	89 04 24             	mov    %eax,(%esp)
  104b1b:	e8 b2 ef ff ff       	call   103ad2 <page_ref>
  104b20:	83 f8 01             	cmp    $0x1,%eax
  104b23:	74 24                	je     104b49 <check_pgdir+0x3c9>
  104b25:	c7 44 24 0c 26 6d 10 	movl   $0x106d26,0xc(%esp)
  104b2c:	00 
  104b2d:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104b34:	00 
  104b35:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104b3c:	00 
  104b3d:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104b44:	e8 7d c1 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b49:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b4e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b55:	00 
  104b56:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b5d:	00 
  104b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b61:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b65:	89 04 24             	mov    %eax,(%esp)
  104b68:	e8 df fa ff ff       	call   10464c <page_insert>
  104b6d:	85 c0                	test   %eax,%eax
  104b6f:	74 24                	je     104b95 <check_pgdir+0x415>
  104b71:	c7 44 24 0c 38 6d 10 	movl   $0x106d38,0xc(%esp)
  104b78:	00 
  104b79:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104b80:	00 
  104b81:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b88:	00 
  104b89:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104b90:	e8 31 c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  104b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b98:	89 04 24             	mov    %eax,(%esp)
  104b9b:	e8 32 ef ff ff       	call   103ad2 <page_ref>
  104ba0:	83 f8 02             	cmp    $0x2,%eax
  104ba3:	74 24                	je     104bc9 <check_pgdir+0x449>
  104ba5:	c7 44 24 0c 64 6d 10 	movl   $0x106d64,0xc(%esp)
  104bac:	00 
  104bad:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104bb4:	00 
  104bb5:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104bbc:	00 
  104bbd:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104bc4:	e8 fd c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104bc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bcc:	89 04 24             	mov    %eax,(%esp)
  104bcf:	e8 fe ee ff ff       	call   103ad2 <page_ref>
  104bd4:	85 c0                	test   %eax,%eax
  104bd6:	74 24                	je     104bfc <check_pgdir+0x47c>
  104bd8:	c7 44 24 0c 76 6d 10 	movl   $0x106d76,0xc(%esp)
  104bdf:	00 
  104be0:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104be7:	00 
  104be8:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104bef:	00 
  104bf0:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104bf7:	e8 ca c0 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104bfc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c01:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c08:	00 
  104c09:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c10:	00 
  104c11:	89 04 24             	mov    %eax,(%esp)
  104c14:	e8 fd f7 ff ff       	call   104416 <get_pte>
  104c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c20:	75 24                	jne    104c46 <check_pgdir+0x4c6>
  104c22:	c7 44 24 0c c4 6c 10 	movl   $0x106cc4,0xc(%esp)
  104c29:	00 
  104c2a:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104c31:	00 
  104c32:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104c39:	00 
  104c3a:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104c41:	e8 80 c0 ff ff       	call   100cc6 <__panic>
    assert(pte2page(*ptep) == p1);
  104c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c49:	8b 00                	mov    (%eax),%eax
  104c4b:	89 04 24             	mov    %eax,(%esp)
  104c4e:	e8 29 ee ff ff       	call   103a7c <pte2page>
  104c53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c56:	74 24                	je     104c7c <check_pgdir+0x4fc>
  104c58:	c7 44 24 0c 39 6c 10 	movl   $0x106c39,0xc(%esp)
  104c5f:	00 
  104c60:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104c67:	00 
  104c68:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c6f:	00 
  104c70:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104c77:	e8 4a c0 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c7f:	8b 00                	mov    (%eax),%eax
  104c81:	83 e0 04             	and    $0x4,%eax
  104c84:	85 c0                	test   %eax,%eax
  104c86:	74 24                	je     104cac <check_pgdir+0x52c>
  104c88:	c7 44 24 0c 88 6d 10 	movl   $0x106d88,0xc(%esp)
  104c8f:	00 
  104c90:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104c97:	00 
  104c98:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104c9f:	00 
  104ca0:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104ca7:	e8 1a c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104cac:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cb8:	00 
  104cb9:	89 04 24             	mov    %eax,(%esp)
  104cbc:	e8 47 f9 ff ff       	call   104608 <page_remove>
    assert(page_ref(p1) == 1);
  104cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cc4:	89 04 24             	mov    %eax,(%esp)
  104cc7:	e8 06 ee ff ff       	call   103ad2 <page_ref>
  104ccc:	83 f8 01             	cmp    $0x1,%eax
  104ccf:	74 24                	je     104cf5 <check_pgdir+0x575>
  104cd1:	c7 44 24 0c 4f 6c 10 	movl   $0x106c4f,0xc(%esp)
  104cd8:	00 
  104cd9:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104ce0:	00 
  104ce1:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104ce8:	00 
  104ce9:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104cf0:	e8 d1 bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104cf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cf8:	89 04 24             	mov    %eax,(%esp)
  104cfb:	e8 d2 ed ff ff       	call   103ad2 <page_ref>
  104d00:	85 c0                	test   %eax,%eax
  104d02:	74 24                	je     104d28 <check_pgdir+0x5a8>
  104d04:	c7 44 24 0c 76 6d 10 	movl   $0x106d76,0xc(%esp)
  104d0b:	00 
  104d0c:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104d13:	00 
  104d14:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104d1b:	00 
  104d1c:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104d23:	e8 9e bf ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d28:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d2d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d34:	00 
  104d35:	89 04 24             	mov    %eax,(%esp)
  104d38:	e8 cb f8 ff ff       	call   104608 <page_remove>
    assert(page_ref(p1) == 0);
  104d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d40:	89 04 24             	mov    %eax,(%esp)
  104d43:	e8 8a ed ff ff       	call   103ad2 <page_ref>
  104d48:	85 c0                	test   %eax,%eax
  104d4a:	74 24                	je     104d70 <check_pgdir+0x5f0>
  104d4c:	c7 44 24 0c 9d 6d 10 	movl   $0x106d9d,0xc(%esp)
  104d53:	00 
  104d54:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104d5b:	00 
  104d5c:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104d63:	00 
  104d64:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104d6b:	e8 56 bf ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104d70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d73:	89 04 24             	mov    %eax,(%esp)
  104d76:	e8 57 ed ff ff       	call   103ad2 <page_ref>
  104d7b:	85 c0                	test   %eax,%eax
  104d7d:	74 24                	je     104da3 <check_pgdir+0x623>
  104d7f:	c7 44 24 0c 76 6d 10 	movl   $0x106d76,0xc(%esp)
  104d86:	00 
  104d87:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104d8e:	00 
  104d8f:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104d96:	00 
  104d97:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104d9e:	e8 23 bf ff ff       	call   100cc6 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104da3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104da8:	8b 00                	mov    (%eax),%eax
  104daa:	89 04 24             	mov    %eax,(%esp)
  104dad:	e8 08 ed ff ff       	call   103aba <pde2page>
  104db2:	89 04 24             	mov    %eax,(%esp)
  104db5:	e8 18 ed ff ff       	call   103ad2 <page_ref>
  104dba:	83 f8 01             	cmp    $0x1,%eax
  104dbd:	74 24                	je     104de3 <check_pgdir+0x663>
  104dbf:	c7 44 24 0c b0 6d 10 	movl   $0x106db0,0xc(%esp)
  104dc6:	00 
  104dc7:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104dce:	00 
  104dcf:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104dd6:	00 
  104dd7:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104dde:	e8 e3 be ff ff       	call   100cc6 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104de3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104de8:	8b 00                	mov    (%eax),%eax
  104dea:	89 04 24             	mov    %eax,(%esp)
  104ded:	e8 c8 ec ff ff       	call   103aba <pde2page>
  104df2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104df9:	00 
  104dfa:	89 04 24             	mov    %eax,(%esp)
  104dfd:	e8 0d ef ff ff       	call   103d0f <free_pages>
    boot_pgdir[0] = 0;
  104e02:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e0d:	c7 04 24 d7 6d 10 00 	movl   $0x106dd7,(%esp)
  104e14:	e8 23 b5 ff ff       	call   10033c <cprintf>
}
  104e19:	c9                   	leave  
  104e1a:	c3                   	ret    

00104e1b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e1b:	55                   	push   %ebp
  104e1c:	89 e5                	mov    %esp,%ebp
  104e1e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e21:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e28:	e9 ca 00 00 00       	jmp    104ef7 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e36:	c1 e8 0c             	shr    $0xc,%eax
  104e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e3c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e41:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e44:	72 23                	jb     104e69 <check_boot_pgdir+0x4e>
  104e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e49:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e4d:	c7 44 24 08 1c 6a 10 	movl   $0x106a1c,0x8(%esp)
  104e54:	00 
  104e55:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104e5c:	00 
  104e5d:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104e64:	e8 5d be ff ff       	call   100cc6 <__panic>
  104e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e6c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e71:	89 c2                	mov    %eax,%edx
  104e73:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e7f:	00 
  104e80:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e84:	89 04 24             	mov    %eax,(%esp)
  104e87:	e8 8a f5 ff ff       	call   104416 <get_pte>
  104e8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e93:	75 24                	jne    104eb9 <check_boot_pgdir+0x9e>
  104e95:	c7 44 24 0c f4 6d 10 	movl   $0x106df4,0xc(%esp)
  104e9c:	00 
  104e9d:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104ea4:	00 
  104ea5:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104eac:	00 
  104ead:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104eb4:	e8 0d be ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ebc:	8b 00                	mov    (%eax),%eax
  104ebe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ec3:	89 c2                	mov    %eax,%edx
  104ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ec8:	39 c2                	cmp    %eax,%edx
  104eca:	74 24                	je     104ef0 <check_boot_pgdir+0xd5>
  104ecc:	c7 44 24 0c 31 6e 10 	movl   $0x106e31,0xc(%esp)
  104ed3:	00 
  104ed4:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104edb:	00 
  104edc:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104ee3:	00 
  104ee4:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104eeb:	e8 d6 bd ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ef0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104efa:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104eff:	39 c2                	cmp    %eax,%edx
  104f01:	0f 82 26 ff ff ff    	jb     104e2d <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f07:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f0c:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f11:	8b 00                	mov    (%eax),%eax
  104f13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f18:	89 c2                	mov    %eax,%edx
  104f1a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f22:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f29:	77 23                	ja     104f4e <check_boot_pgdir+0x133>
  104f2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f32:	c7 44 24 08 c0 6a 10 	movl   $0x106ac0,0x8(%esp)
  104f39:	00 
  104f3a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f41:	00 
  104f42:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104f49:	e8 78 bd ff ff       	call   100cc6 <__panic>
  104f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f51:	05 00 00 00 40       	add    $0x40000000,%eax
  104f56:	39 c2                	cmp    %eax,%edx
  104f58:	74 24                	je     104f7e <check_boot_pgdir+0x163>
  104f5a:	c7 44 24 0c 48 6e 10 	movl   $0x106e48,0xc(%esp)
  104f61:	00 
  104f62:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104f69:	00 
  104f6a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f71:	00 
  104f72:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104f79:	e8 48 bd ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104f7e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f83:	8b 00                	mov    (%eax),%eax
  104f85:	85 c0                	test   %eax,%eax
  104f87:	74 24                	je     104fad <check_boot_pgdir+0x192>
  104f89:	c7 44 24 0c 7c 6e 10 	movl   $0x106e7c,0xc(%esp)
  104f90:	00 
  104f91:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104f98:	00 
  104f99:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104fa0:	00 
  104fa1:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  104fa8:	e8 19 bd ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fb4:	e8 1e ed ff ff       	call   103cd7 <alloc_pages>
  104fb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fbc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fc1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fc8:	00 
  104fc9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104fd0:	00 
  104fd1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fd4:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fd8:	89 04 24             	mov    %eax,(%esp)
  104fdb:	e8 6c f6 ff ff       	call   10464c <page_insert>
  104fe0:	85 c0                	test   %eax,%eax
  104fe2:	74 24                	je     105008 <check_boot_pgdir+0x1ed>
  104fe4:	c7 44 24 0c 90 6e 10 	movl   $0x106e90,0xc(%esp)
  104feb:	00 
  104fec:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  104ff3:	00 
  104ff4:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104ffb:	00 
  104ffc:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  105003:	e8 be bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  105008:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10500b:	89 04 24             	mov    %eax,(%esp)
  10500e:	e8 bf ea ff ff       	call   103ad2 <page_ref>
  105013:	83 f8 01             	cmp    $0x1,%eax
  105016:	74 24                	je     10503c <check_boot_pgdir+0x221>
  105018:	c7 44 24 0c be 6e 10 	movl   $0x106ebe,0xc(%esp)
  10501f:	00 
  105020:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  105027:	00 
  105028:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  10502f:	00 
  105030:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  105037:	e8 8a bc ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10503c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105041:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105048:	00 
  105049:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105050:	00 
  105051:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105054:	89 54 24 04          	mov    %edx,0x4(%esp)
  105058:	89 04 24             	mov    %eax,(%esp)
  10505b:	e8 ec f5 ff ff       	call   10464c <page_insert>
  105060:	85 c0                	test   %eax,%eax
  105062:	74 24                	je     105088 <check_boot_pgdir+0x26d>
  105064:	c7 44 24 0c d0 6e 10 	movl   $0x106ed0,0xc(%esp)
  10506b:	00 
  10506c:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  105073:	00 
  105074:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  10507b:	00 
  10507c:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  105083:	e8 3e bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  105088:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10508b:	89 04 24             	mov    %eax,(%esp)
  10508e:	e8 3f ea ff ff       	call   103ad2 <page_ref>
  105093:	83 f8 02             	cmp    $0x2,%eax
  105096:	74 24                	je     1050bc <check_boot_pgdir+0x2a1>
  105098:	c7 44 24 0c 07 6f 10 	movl   $0x106f07,0xc(%esp)
  10509f:	00 
  1050a0:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1050a7:	00 
  1050a8:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1050af:	00 
  1050b0:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  1050b7:	e8 0a bc ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  1050bc:	c7 45 dc 18 6f 10 00 	movl   $0x106f18,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050ca:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050d1:	e8 19 0a 00 00       	call   105aef <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050d6:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1050dd:	00 
  1050de:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050e5:	e8 7e 0a 00 00       	call   105b68 <strcmp>
  1050ea:	85 c0                	test   %eax,%eax
  1050ec:	74 24                	je     105112 <check_boot_pgdir+0x2f7>
  1050ee:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  1050f5:	00 
  1050f6:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  1050fd:	00 
  1050fe:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105105:	00 
  105106:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  10510d:	e8 b4 bb ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105112:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105115:	89 04 24             	mov    %eax,(%esp)
  105118:	e8 0b e9 ff ff       	call   103a28 <page2kva>
  10511d:	05 00 01 00 00       	add    $0x100,%eax
  105122:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105125:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10512c:	e8 66 09 00 00       	call   105a97 <strlen>
  105131:	85 c0                	test   %eax,%eax
  105133:	74 24                	je     105159 <check_boot_pgdir+0x33e>
  105135:	c7 44 24 0c 68 6f 10 	movl   $0x106f68,0xc(%esp)
  10513c:	00 
  10513d:	c7 44 24 08 09 6b 10 	movl   $0x106b09,0x8(%esp)
  105144:	00 
  105145:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  10514c:	00 
  10514d:	c7 04 24 e4 6a 10 00 	movl   $0x106ae4,(%esp)
  105154:	e8 6d bb ff ff       	call   100cc6 <__panic>

    free_page(p);
  105159:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105160:	00 
  105161:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105164:	89 04 24             	mov    %eax,(%esp)
  105167:	e8 a3 eb ff ff       	call   103d0f <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10516c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105171:	8b 00                	mov    (%eax),%eax
  105173:	89 04 24             	mov    %eax,(%esp)
  105176:	e8 3f e9 ff ff       	call   103aba <pde2page>
  10517b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105182:	00 
  105183:	89 04 24             	mov    %eax,(%esp)
  105186:	e8 84 eb ff ff       	call   103d0f <free_pages>
    boot_pgdir[0] = 0;
  10518b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105196:	c7 04 24 8c 6f 10 00 	movl   $0x106f8c,(%esp)
  10519d:	e8 9a b1 ff ff       	call   10033c <cprintf>
}
  1051a2:	c9                   	leave  
  1051a3:	c3                   	ret    

001051a4 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051a4:	55                   	push   %ebp
  1051a5:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1051aa:	83 e0 04             	and    $0x4,%eax
  1051ad:	85 c0                	test   %eax,%eax
  1051af:	74 07                	je     1051b8 <perm2str+0x14>
  1051b1:	b8 75 00 00 00       	mov    $0x75,%eax
  1051b6:	eb 05                	jmp    1051bd <perm2str+0x19>
  1051b8:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051bd:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051c2:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051cc:	83 e0 02             	and    $0x2,%eax
  1051cf:	85 c0                	test   %eax,%eax
  1051d1:	74 07                	je     1051da <perm2str+0x36>
  1051d3:	b8 77 00 00 00       	mov    $0x77,%eax
  1051d8:	eb 05                	jmp    1051df <perm2str+0x3b>
  1051da:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051df:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1051e4:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1051eb:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1051f0:	5d                   	pop    %ebp
  1051f1:	c3                   	ret    

001051f2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1051f2:	55                   	push   %ebp
  1051f3:	89 e5                	mov    %esp,%ebp
  1051f5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1051f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1051fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051fe:	72 0a                	jb     10520a <get_pgtable_items+0x18>
        return 0;
  105200:	b8 00 00 00 00       	mov    $0x0,%eax
  105205:	e9 9c 00 00 00       	jmp    1052a6 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10520a:	eb 04                	jmp    105210 <get_pgtable_items+0x1e>
        start ++;
  10520c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105210:	8b 45 10             	mov    0x10(%ebp),%eax
  105213:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105216:	73 18                	jae    105230 <get_pgtable_items+0x3e>
  105218:	8b 45 10             	mov    0x10(%ebp),%eax
  10521b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105222:	8b 45 14             	mov    0x14(%ebp),%eax
  105225:	01 d0                	add    %edx,%eax
  105227:	8b 00                	mov    (%eax),%eax
  105229:	83 e0 01             	and    $0x1,%eax
  10522c:	85 c0                	test   %eax,%eax
  10522e:	74 dc                	je     10520c <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105230:	8b 45 10             	mov    0x10(%ebp),%eax
  105233:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105236:	73 69                	jae    1052a1 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105238:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10523c:	74 08                	je     105246 <get_pgtable_items+0x54>
            *left_store = start;
  10523e:	8b 45 18             	mov    0x18(%ebp),%eax
  105241:	8b 55 10             	mov    0x10(%ebp),%edx
  105244:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105246:	8b 45 10             	mov    0x10(%ebp),%eax
  105249:	8d 50 01             	lea    0x1(%eax),%edx
  10524c:	89 55 10             	mov    %edx,0x10(%ebp)
  10524f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105256:	8b 45 14             	mov    0x14(%ebp),%eax
  105259:	01 d0                	add    %edx,%eax
  10525b:	8b 00                	mov    (%eax),%eax
  10525d:	83 e0 07             	and    $0x7,%eax
  105260:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105263:	eb 04                	jmp    105269 <get_pgtable_items+0x77>
            start ++;
  105265:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105269:	8b 45 10             	mov    0x10(%ebp),%eax
  10526c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10526f:	73 1d                	jae    10528e <get_pgtable_items+0x9c>
  105271:	8b 45 10             	mov    0x10(%ebp),%eax
  105274:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10527b:	8b 45 14             	mov    0x14(%ebp),%eax
  10527e:	01 d0                	add    %edx,%eax
  105280:	8b 00                	mov    (%eax),%eax
  105282:	83 e0 07             	and    $0x7,%eax
  105285:	89 c2                	mov    %eax,%edx
  105287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10528a:	39 c2                	cmp    %eax,%edx
  10528c:	74 d7                	je     105265 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10528e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105292:	74 08                	je     10529c <get_pgtable_items+0xaa>
            *right_store = start;
  105294:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105297:	8b 55 10             	mov    0x10(%ebp),%edx
  10529a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10529c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10529f:	eb 05                	jmp    1052a6 <get_pgtable_items+0xb4>
    }
    return 0;
  1052a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052a6:	c9                   	leave  
  1052a7:	c3                   	ret    

001052a8 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052a8:	55                   	push   %ebp
  1052a9:	89 e5                	mov    %esp,%ebp
  1052ab:	57                   	push   %edi
  1052ac:	56                   	push   %esi
  1052ad:	53                   	push   %ebx
  1052ae:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052b1:	c7 04 24 ac 6f 10 00 	movl   $0x106fac,(%esp)
  1052b8:	e8 7f b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052c4:	e9 fa 00 00 00       	jmp    1053c3 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052cc:	89 04 24             	mov    %eax,(%esp)
  1052cf:	e8 d0 fe ff ff       	call   1051a4 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052d7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052da:	29 d1                	sub    %edx,%ecx
  1052dc:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052de:	89 d6                	mov    %edx,%esi
  1052e0:	c1 e6 16             	shl    $0x16,%esi
  1052e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052e6:	89 d3                	mov    %edx,%ebx
  1052e8:	c1 e3 16             	shl    $0x16,%ebx
  1052eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052ee:	89 d1                	mov    %edx,%ecx
  1052f0:	c1 e1 16             	shl    $0x16,%ecx
  1052f3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1052f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052f9:	29 d7                	sub    %edx,%edi
  1052fb:	89 fa                	mov    %edi,%edx
  1052fd:	89 44 24 14          	mov    %eax,0x14(%esp)
  105301:	89 74 24 10          	mov    %esi,0x10(%esp)
  105305:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105309:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10530d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105311:	c7 04 24 dd 6f 10 00 	movl   $0x106fdd,(%esp)
  105318:	e8 1f b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10531d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105320:	c1 e0 0a             	shl    $0xa,%eax
  105323:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105326:	eb 54                	jmp    10537c <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105328:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10532b:	89 04 24             	mov    %eax,(%esp)
  10532e:	e8 71 fe ff ff       	call   1051a4 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105333:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105336:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105339:	29 d1                	sub    %edx,%ecx
  10533b:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10533d:	89 d6                	mov    %edx,%esi
  10533f:	c1 e6 0c             	shl    $0xc,%esi
  105342:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105345:	89 d3                	mov    %edx,%ebx
  105347:	c1 e3 0c             	shl    $0xc,%ebx
  10534a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10534d:	c1 e2 0c             	shl    $0xc,%edx
  105350:	89 d1                	mov    %edx,%ecx
  105352:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105355:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105358:	29 d7                	sub    %edx,%edi
  10535a:	89 fa                	mov    %edi,%edx
  10535c:	89 44 24 14          	mov    %eax,0x14(%esp)
  105360:	89 74 24 10          	mov    %esi,0x10(%esp)
  105364:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105368:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10536c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105370:	c7 04 24 fc 6f 10 00 	movl   $0x106ffc,(%esp)
  105377:	e8 c0 af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10537c:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105381:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105384:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105387:	89 ce                	mov    %ecx,%esi
  105389:	c1 e6 0a             	shl    $0xa,%esi
  10538c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10538f:	89 cb                	mov    %ecx,%ebx
  105391:	c1 e3 0a             	shl    $0xa,%ebx
  105394:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105397:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10539b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10539e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053a2:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053ae:	89 1c 24             	mov    %ebx,(%esp)
  1053b1:	e8 3c fe ff ff       	call   1051f2 <get_pgtable_items>
  1053b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053bd:	0f 85 65 ff ff ff    	jne    105328 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053c3:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053cb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053ce:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053d2:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053d5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053e1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1053e8:	00 
  1053e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053f0:	e8 fd fd ff ff       	call   1051f2 <get_pgtable_items>
  1053f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053fc:	0f 85 c7 fe ff ff    	jne    1052c9 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105402:	c7 04 24 20 70 10 00 	movl   $0x107020,(%esp)
  105409:	e8 2e af ff ff       	call   10033c <cprintf>
}
  10540e:	83 c4 4c             	add    $0x4c,%esp
  105411:	5b                   	pop    %ebx
  105412:	5e                   	pop    %esi
  105413:	5f                   	pop    %edi
  105414:	5d                   	pop    %ebp
  105415:	c3                   	ret    

00105416 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105416:	55                   	push   %ebp
  105417:	89 e5                	mov    %esp,%ebp
  105419:	83 ec 58             	sub    $0x58,%esp
  10541c:	8b 45 10             	mov    0x10(%ebp),%eax
  10541f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105422:	8b 45 14             	mov    0x14(%ebp),%eax
  105425:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105428:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10542b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10542e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105431:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105434:	8b 45 18             	mov    0x18(%ebp),%eax
  105437:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10543a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10543d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105440:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105443:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10544c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105450:	74 1c                	je     10546e <printnum+0x58>
  105452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105455:	ba 00 00 00 00       	mov    $0x0,%edx
  10545a:	f7 75 e4             	divl   -0x1c(%ebp)
  10545d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105463:	ba 00 00 00 00       	mov    $0x0,%edx
  105468:	f7 75 e4             	divl   -0x1c(%ebp)
  10546b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10546e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105471:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105474:	f7 75 e4             	divl   -0x1c(%ebp)
  105477:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10547a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10547d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105480:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105483:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105486:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105489:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10548c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10548f:	8b 45 18             	mov    0x18(%ebp),%eax
  105492:	ba 00 00 00 00       	mov    $0x0,%edx
  105497:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10549a:	77 56                	ja     1054f2 <printnum+0xdc>
  10549c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10549f:	72 05                	jb     1054a6 <printnum+0x90>
  1054a1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054a4:	77 4c                	ja     1054f2 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054a6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054ac:	8b 45 20             	mov    0x20(%ebp),%eax
  1054af:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054b3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054b7:	8b 45 18             	mov    0x18(%ebp),%eax
  1054ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054c8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1054d6:	89 04 24             	mov    %eax,(%esp)
  1054d9:	e8 38 ff ff ff       	call   105416 <printnum>
  1054de:	eb 1c                	jmp    1054fc <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054e7:	8b 45 20             	mov    0x20(%ebp),%eax
  1054ea:	89 04 24             	mov    %eax,(%esp)
  1054ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f0:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1054f2:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1054f6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054fa:	7f e4                	jg     1054e0 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1054fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054ff:	05 d4 70 10 00       	add    $0x1070d4,%eax
  105504:	0f b6 00             	movzbl (%eax),%eax
  105507:	0f be c0             	movsbl %al,%eax
  10550a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10550d:	89 54 24 04          	mov    %edx,0x4(%esp)
  105511:	89 04 24             	mov    %eax,(%esp)
  105514:	8b 45 08             	mov    0x8(%ebp),%eax
  105517:	ff d0                	call   *%eax
}
  105519:	c9                   	leave  
  10551a:	c3                   	ret    

0010551b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10551b:	55                   	push   %ebp
  10551c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10551e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105522:	7e 14                	jle    105538 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105524:	8b 45 08             	mov    0x8(%ebp),%eax
  105527:	8b 00                	mov    (%eax),%eax
  105529:	8d 48 08             	lea    0x8(%eax),%ecx
  10552c:	8b 55 08             	mov    0x8(%ebp),%edx
  10552f:	89 0a                	mov    %ecx,(%edx)
  105531:	8b 50 04             	mov    0x4(%eax),%edx
  105534:	8b 00                	mov    (%eax),%eax
  105536:	eb 30                	jmp    105568 <getuint+0x4d>
    }
    else if (lflag) {
  105538:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10553c:	74 16                	je     105554 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10553e:	8b 45 08             	mov    0x8(%ebp),%eax
  105541:	8b 00                	mov    (%eax),%eax
  105543:	8d 48 04             	lea    0x4(%eax),%ecx
  105546:	8b 55 08             	mov    0x8(%ebp),%edx
  105549:	89 0a                	mov    %ecx,(%edx)
  10554b:	8b 00                	mov    (%eax),%eax
  10554d:	ba 00 00 00 00       	mov    $0x0,%edx
  105552:	eb 14                	jmp    105568 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105554:	8b 45 08             	mov    0x8(%ebp),%eax
  105557:	8b 00                	mov    (%eax),%eax
  105559:	8d 48 04             	lea    0x4(%eax),%ecx
  10555c:	8b 55 08             	mov    0x8(%ebp),%edx
  10555f:	89 0a                	mov    %ecx,(%edx)
  105561:	8b 00                	mov    (%eax),%eax
  105563:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105568:	5d                   	pop    %ebp
  105569:	c3                   	ret    

0010556a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10556a:	55                   	push   %ebp
  10556b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10556d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105571:	7e 14                	jle    105587 <getint+0x1d>
        return va_arg(*ap, long long);
  105573:	8b 45 08             	mov    0x8(%ebp),%eax
  105576:	8b 00                	mov    (%eax),%eax
  105578:	8d 48 08             	lea    0x8(%eax),%ecx
  10557b:	8b 55 08             	mov    0x8(%ebp),%edx
  10557e:	89 0a                	mov    %ecx,(%edx)
  105580:	8b 50 04             	mov    0x4(%eax),%edx
  105583:	8b 00                	mov    (%eax),%eax
  105585:	eb 28                	jmp    1055af <getint+0x45>
    }
    else if (lflag) {
  105587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10558b:	74 12                	je     10559f <getint+0x35>
        return va_arg(*ap, long);
  10558d:	8b 45 08             	mov    0x8(%ebp),%eax
  105590:	8b 00                	mov    (%eax),%eax
  105592:	8d 48 04             	lea    0x4(%eax),%ecx
  105595:	8b 55 08             	mov    0x8(%ebp),%edx
  105598:	89 0a                	mov    %ecx,(%edx)
  10559a:	8b 00                	mov    (%eax),%eax
  10559c:	99                   	cltd   
  10559d:	eb 10                	jmp    1055af <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10559f:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a2:	8b 00                	mov    (%eax),%eax
  1055a4:	8d 48 04             	lea    0x4(%eax),%ecx
  1055a7:	8b 55 08             	mov    0x8(%ebp),%edx
  1055aa:	89 0a                	mov    %ecx,(%edx)
  1055ac:	8b 00                	mov    (%eax),%eax
  1055ae:	99                   	cltd   
    }
}
  1055af:	5d                   	pop    %ebp
  1055b0:	c3                   	ret    

001055b1 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055b1:	55                   	push   %ebp
  1055b2:	89 e5                	mov    %esp,%ebp
  1055b4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055b7:	8d 45 14             	lea    0x14(%ebp),%eax
  1055ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1055c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d5:	89 04 24             	mov    %eax,(%esp)
  1055d8:	e8 02 00 00 00       	call   1055df <vprintfmt>
    va_end(ap);
}
  1055dd:	c9                   	leave  
  1055de:	c3                   	ret    

001055df <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055df:	55                   	push   %ebp
  1055e0:	89 e5                	mov    %esp,%ebp
  1055e2:	56                   	push   %esi
  1055e3:	53                   	push   %ebx
  1055e4:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055e7:	eb 18                	jmp    105601 <vprintfmt+0x22>
            if (ch == '\0') {
  1055e9:	85 db                	test   %ebx,%ebx
  1055eb:	75 05                	jne    1055f2 <vprintfmt+0x13>
                return;
  1055ed:	e9 d1 03 00 00       	jmp    1059c3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1055f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055f9:	89 1c 24             	mov    %ebx,(%esp)
  1055fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ff:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105601:	8b 45 10             	mov    0x10(%ebp),%eax
  105604:	8d 50 01             	lea    0x1(%eax),%edx
  105607:	89 55 10             	mov    %edx,0x10(%ebp)
  10560a:	0f b6 00             	movzbl (%eax),%eax
  10560d:	0f b6 d8             	movzbl %al,%ebx
  105610:	83 fb 25             	cmp    $0x25,%ebx
  105613:	75 d4                	jne    1055e9 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105615:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105619:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105623:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105626:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10562d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105630:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105633:	8b 45 10             	mov    0x10(%ebp),%eax
  105636:	8d 50 01             	lea    0x1(%eax),%edx
  105639:	89 55 10             	mov    %edx,0x10(%ebp)
  10563c:	0f b6 00             	movzbl (%eax),%eax
  10563f:	0f b6 d8             	movzbl %al,%ebx
  105642:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105645:	83 f8 55             	cmp    $0x55,%eax
  105648:	0f 87 44 03 00 00    	ja     105992 <vprintfmt+0x3b3>
  10564e:	8b 04 85 f8 70 10 00 	mov    0x1070f8(,%eax,4),%eax
  105655:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105657:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10565b:	eb d6                	jmp    105633 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10565d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105661:	eb d0                	jmp    105633 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105663:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10566a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10566d:	89 d0                	mov    %edx,%eax
  10566f:	c1 e0 02             	shl    $0x2,%eax
  105672:	01 d0                	add    %edx,%eax
  105674:	01 c0                	add    %eax,%eax
  105676:	01 d8                	add    %ebx,%eax
  105678:	83 e8 30             	sub    $0x30,%eax
  10567b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10567e:	8b 45 10             	mov    0x10(%ebp),%eax
  105681:	0f b6 00             	movzbl (%eax),%eax
  105684:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105687:	83 fb 2f             	cmp    $0x2f,%ebx
  10568a:	7e 0b                	jle    105697 <vprintfmt+0xb8>
  10568c:	83 fb 39             	cmp    $0x39,%ebx
  10568f:	7f 06                	jg     105697 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105691:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105695:	eb d3                	jmp    10566a <vprintfmt+0x8b>
            goto process_precision;
  105697:	eb 33                	jmp    1056cc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105699:	8b 45 14             	mov    0x14(%ebp),%eax
  10569c:	8d 50 04             	lea    0x4(%eax),%edx
  10569f:	89 55 14             	mov    %edx,0x14(%ebp)
  1056a2:	8b 00                	mov    (%eax),%eax
  1056a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056a7:	eb 23                	jmp    1056cc <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056a9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056ad:	79 0c                	jns    1056bb <vprintfmt+0xdc>
                width = 0;
  1056af:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056b6:	e9 78 ff ff ff       	jmp    105633 <vprintfmt+0x54>
  1056bb:	e9 73 ff ff ff       	jmp    105633 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056c0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056c7:	e9 67 ff ff ff       	jmp    105633 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056d0:	79 12                	jns    1056e4 <vprintfmt+0x105>
                width = precision, precision = -1;
  1056d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056d8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056df:	e9 4f ff ff ff       	jmp    105633 <vprintfmt+0x54>
  1056e4:	e9 4a ff ff ff       	jmp    105633 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056e9:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1056ed:	e9 41 ff ff ff       	jmp    105633 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1056f2:	8b 45 14             	mov    0x14(%ebp),%eax
  1056f5:	8d 50 04             	lea    0x4(%eax),%edx
  1056f8:	89 55 14             	mov    %edx,0x14(%ebp)
  1056fb:	8b 00                	mov    (%eax),%eax
  1056fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  105700:	89 54 24 04          	mov    %edx,0x4(%esp)
  105704:	89 04 24             	mov    %eax,(%esp)
  105707:	8b 45 08             	mov    0x8(%ebp),%eax
  10570a:	ff d0                	call   *%eax
            break;
  10570c:	e9 ac 02 00 00       	jmp    1059bd <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105711:	8b 45 14             	mov    0x14(%ebp),%eax
  105714:	8d 50 04             	lea    0x4(%eax),%edx
  105717:	89 55 14             	mov    %edx,0x14(%ebp)
  10571a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10571c:	85 db                	test   %ebx,%ebx
  10571e:	79 02                	jns    105722 <vprintfmt+0x143>
                err = -err;
  105720:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105722:	83 fb 06             	cmp    $0x6,%ebx
  105725:	7f 0b                	jg     105732 <vprintfmt+0x153>
  105727:	8b 34 9d b8 70 10 00 	mov    0x1070b8(,%ebx,4),%esi
  10572e:	85 f6                	test   %esi,%esi
  105730:	75 23                	jne    105755 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105736:	c7 44 24 08 e5 70 10 	movl   $0x1070e5,0x8(%esp)
  10573d:	00 
  10573e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105741:	89 44 24 04          	mov    %eax,0x4(%esp)
  105745:	8b 45 08             	mov    0x8(%ebp),%eax
  105748:	89 04 24             	mov    %eax,(%esp)
  10574b:	e8 61 fe ff ff       	call   1055b1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105750:	e9 68 02 00 00       	jmp    1059bd <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105755:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105759:	c7 44 24 08 ee 70 10 	movl   $0x1070ee,0x8(%esp)
  105760:	00 
  105761:	8b 45 0c             	mov    0xc(%ebp),%eax
  105764:	89 44 24 04          	mov    %eax,0x4(%esp)
  105768:	8b 45 08             	mov    0x8(%ebp),%eax
  10576b:	89 04 24             	mov    %eax,(%esp)
  10576e:	e8 3e fe ff ff       	call   1055b1 <printfmt>
            }
            break;
  105773:	e9 45 02 00 00       	jmp    1059bd <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105778:	8b 45 14             	mov    0x14(%ebp),%eax
  10577b:	8d 50 04             	lea    0x4(%eax),%edx
  10577e:	89 55 14             	mov    %edx,0x14(%ebp)
  105781:	8b 30                	mov    (%eax),%esi
  105783:	85 f6                	test   %esi,%esi
  105785:	75 05                	jne    10578c <vprintfmt+0x1ad>
                p = "(null)";
  105787:	be f1 70 10 00       	mov    $0x1070f1,%esi
            }
            if (width > 0 && padc != '-') {
  10578c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105790:	7e 3e                	jle    1057d0 <vprintfmt+0x1f1>
  105792:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105796:	74 38                	je     1057d0 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105798:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10579b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10579e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057a2:	89 34 24             	mov    %esi,(%esp)
  1057a5:	e8 15 03 00 00       	call   105abf <strnlen>
  1057aa:	29 c3                	sub    %eax,%ebx
  1057ac:	89 d8                	mov    %ebx,%eax
  1057ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057b1:	eb 17                	jmp    1057ca <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057b3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057be:	89 04 24             	mov    %eax,(%esp)
  1057c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057c6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057ce:	7f e3                	jg     1057b3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057d0:	eb 38                	jmp    10580a <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057d2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057d6:	74 1f                	je     1057f7 <vprintfmt+0x218>
  1057d8:	83 fb 1f             	cmp    $0x1f,%ebx
  1057db:	7e 05                	jle    1057e2 <vprintfmt+0x203>
  1057dd:	83 fb 7e             	cmp    $0x7e,%ebx
  1057e0:	7e 15                	jle    1057f7 <vprintfmt+0x218>
                    putch('?', putdat);
  1057e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1057f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f3:	ff d0                	call   *%eax
  1057f5:	eb 0f                	jmp    105806 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1057f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057fe:	89 1c 24             	mov    %ebx,(%esp)
  105801:	8b 45 08             	mov    0x8(%ebp),%eax
  105804:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105806:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10580a:	89 f0                	mov    %esi,%eax
  10580c:	8d 70 01             	lea    0x1(%eax),%esi
  10580f:	0f b6 00             	movzbl (%eax),%eax
  105812:	0f be d8             	movsbl %al,%ebx
  105815:	85 db                	test   %ebx,%ebx
  105817:	74 10                	je     105829 <vprintfmt+0x24a>
  105819:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10581d:	78 b3                	js     1057d2 <vprintfmt+0x1f3>
  10581f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105823:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105827:	79 a9                	jns    1057d2 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105829:	eb 17                	jmp    105842 <vprintfmt+0x263>
                putch(' ', putdat);
  10582b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105832:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105839:	8b 45 08             	mov    0x8(%ebp),%eax
  10583c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10583e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105842:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105846:	7f e3                	jg     10582b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105848:	e9 70 01 00 00       	jmp    1059bd <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10584d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105850:	89 44 24 04          	mov    %eax,0x4(%esp)
  105854:	8d 45 14             	lea    0x14(%ebp),%eax
  105857:	89 04 24             	mov    %eax,(%esp)
  10585a:	e8 0b fd ff ff       	call   10556a <getint>
  10585f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105862:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10586b:	85 d2                	test   %edx,%edx
  10586d:	79 26                	jns    105895 <vprintfmt+0x2b6>
                putch('-', putdat);
  10586f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105872:	89 44 24 04          	mov    %eax,0x4(%esp)
  105876:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10587d:	8b 45 08             	mov    0x8(%ebp),%eax
  105880:	ff d0                	call   *%eax
                num = -(long long)num;
  105882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105885:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105888:	f7 d8                	neg    %eax
  10588a:	83 d2 00             	adc    $0x0,%edx
  10588d:	f7 da                	neg    %edx
  10588f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105892:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105895:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10589c:	e9 a8 00 00 00       	jmp    105949 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058a8:	8d 45 14             	lea    0x14(%ebp),%eax
  1058ab:	89 04 24             	mov    %eax,(%esp)
  1058ae:	e8 68 fc ff ff       	call   10551b <getuint>
  1058b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058c0:	e9 84 00 00 00       	jmp    105949 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1058cf:	89 04 24             	mov    %eax,(%esp)
  1058d2:	e8 44 fc ff ff       	call   10551b <getuint>
  1058d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058dd:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058e4:	eb 63                	jmp    105949 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1058e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ed:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1058f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f7:	ff d0                	call   *%eax
            putch('x', putdat);
  1058f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105900:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105907:	8b 45 08             	mov    0x8(%ebp),%eax
  10590a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10590c:	8b 45 14             	mov    0x14(%ebp),%eax
  10590f:	8d 50 04             	lea    0x4(%eax),%edx
  105912:	89 55 14             	mov    %edx,0x14(%ebp)
  105915:	8b 00                	mov    (%eax),%eax
  105917:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10591a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105921:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105928:	eb 1f                	jmp    105949 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10592a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10592d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105931:	8d 45 14             	lea    0x14(%ebp),%eax
  105934:	89 04 24             	mov    %eax,(%esp)
  105937:	e8 df fb ff ff       	call   10551b <getuint>
  10593c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10593f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105942:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105949:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10594d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105950:	89 54 24 18          	mov    %edx,0x18(%esp)
  105954:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105957:	89 54 24 14          	mov    %edx,0x14(%esp)
  10595b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10595f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105962:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105965:	89 44 24 08          	mov    %eax,0x8(%esp)
  105969:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10596d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105970:	89 44 24 04          	mov    %eax,0x4(%esp)
  105974:	8b 45 08             	mov    0x8(%ebp),%eax
  105977:	89 04 24             	mov    %eax,(%esp)
  10597a:	e8 97 fa ff ff       	call   105416 <printnum>
            break;
  10597f:	eb 3c                	jmp    1059bd <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105981:	8b 45 0c             	mov    0xc(%ebp),%eax
  105984:	89 44 24 04          	mov    %eax,0x4(%esp)
  105988:	89 1c 24             	mov    %ebx,(%esp)
  10598b:	8b 45 08             	mov    0x8(%ebp),%eax
  10598e:	ff d0                	call   *%eax
            break;
  105990:	eb 2b                	jmp    1059bd <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105992:	8b 45 0c             	mov    0xc(%ebp),%eax
  105995:	89 44 24 04          	mov    %eax,0x4(%esp)
  105999:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a3:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059a9:	eb 04                	jmp    1059af <vprintfmt+0x3d0>
  1059ab:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059af:	8b 45 10             	mov    0x10(%ebp),%eax
  1059b2:	83 e8 01             	sub    $0x1,%eax
  1059b5:	0f b6 00             	movzbl (%eax),%eax
  1059b8:	3c 25                	cmp    $0x25,%al
  1059ba:	75 ef                	jne    1059ab <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059bc:	90                   	nop
        }
    }
  1059bd:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059be:	e9 3e fc ff ff       	jmp    105601 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059c3:	83 c4 40             	add    $0x40,%esp
  1059c6:	5b                   	pop    %ebx
  1059c7:	5e                   	pop    %esi
  1059c8:	5d                   	pop    %ebp
  1059c9:	c3                   	ret    

001059ca <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059ca:	55                   	push   %ebp
  1059cb:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d0:	8b 40 08             	mov    0x8(%eax),%eax
  1059d3:	8d 50 01             	lea    0x1(%eax),%edx
  1059d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d9:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059df:	8b 10                	mov    (%eax),%edx
  1059e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e4:	8b 40 04             	mov    0x4(%eax),%eax
  1059e7:	39 c2                	cmp    %eax,%edx
  1059e9:	73 12                	jae    1059fd <sprintputch+0x33>
        *b->buf ++ = ch;
  1059eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ee:	8b 00                	mov    (%eax),%eax
  1059f0:	8d 48 01             	lea    0x1(%eax),%ecx
  1059f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059f6:	89 0a                	mov    %ecx,(%edx)
  1059f8:	8b 55 08             	mov    0x8(%ebp),%edx
  1059fb:	88 10                	mov    %dl,(%eax)
    }
}
  1059fd:	5d                   	pop    %ebp
  1059fe:	c3                   	ret    

001059ff <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1059ff:	55                   	push   %ebp
  105a00:	89 e5                	mov    %esp,%ebp
  105a02:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a05:	8d 45 14             	lea    0x14(%ebp),%eax
  105a08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a12:	8b 45 10             	mov    0x10(%ebp),%eax
  105a15:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a20:	8b 45 08             	mov    0x8(%ebp),%eax
  105a23:	89 04 24             	mov    %eax,(%esp)
  105a26:	e8 08 00 00 00       	call   105a33 <vsnprintf>
  105a2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a31:	c9                   	leave  
  105a32:	c3                   	ret    

00105a33 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a33:	55                   	push   %ebp
  105a34:	89 e5                	mov    %esp,%ebp
  105a36:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a39:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a42:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a45:	8b 45 08             	mov    0x8(%ebp),%eax
  105a48:	01 d0                	add    %edx,%eax
  105a4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a58:	74 0a                	je     105a64 <vsnprintf+0x31>
  105a5a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a60:	39 c2                	cmp    %eax,%edx
  105a62:	76 07                	jbe    105a6b <vsnprintf+0x38>
        return -E_INVAL;
  105a64:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a69:	eb 2a                	jmp    105a95 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  105a6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a72:	8b 45 10             	mov    0x10(%ebp),%eax
  105a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a79:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a80:	c7 04 24 ca 59 10 00 	movl   $0x1059ca,(%esp)
  105a87:	e8 53 fb ff ff       	call   1055df <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a8f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a95:	c9                   	leave  
  105a96:	c3                   	ret    

00105a97 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a97:	55                   	push   %ebp
  105a98:	89 e5                	mov    %esp,%ebp
  105a9a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a9d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105aa4:	eb 04                	jmp    105aaa <strlen+0x13>
        cnt ++;
  105aa6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  105aad:	8d 50 01             	lea    0x1(%eax),%edx
  105ab0:	89 55 08             	mov    %edx,0x8(%ebp)
  105ab3:	0f b6 00             	movzbl (%eax),%eax
  105ab6:	84 c0                	test   %al,%al
  105ab8:	75 ec                	jne    105aa6 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105aba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105abd:	c9                   	leave  
  105abe:	c3                   	ret    

00105abf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105abf:	55                   	push   %ebp
  105ac0:	89 e5                	mov    %esp,%ebp
  105ac2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ac5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105acc:	eb 04                	jmp    105ad2 <strnlen+0x13>
        cnt ++;
  105ace:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ad5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105ad8:	73 10                	jae    105aea <strnlen+0x2b>
  105ada:	8b 45 08             	mov    0x8(%ebp),%eax
  105add:	8d 50 01             	lea    0x1(%eax),%edx
  105ae0:	89 55 08             	mov    %edx,0x8(%ebp)
  105ae3:	0f b6 00             	movzbl (%eax),%eax
  105ae6:	84 c0                	test   %al,%al
  105ae8:	75 e4                	jne    105ace <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105aea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105aed:	c9                   	leave  
  105aee:	c3                   	ret    

00105aef <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105aef:	55                   	push   %ebp
  105af0:	89 e5                	mov    %esp,%ebp
  105af2:	57                   	push   %edi
  105af3:	56                   	push   %esi
  105af4:	83 ec 20             	sub    $0x20,%esp
  105af7:	8b 45 08             	mov    0x8(%ebp),%eax
  105afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b00:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b09:	89 d1                	mov    %edx,%ecx
  105b0b:	89 c2                	mov    %eax,%edx
  105b0d:	89 ce                	mov    %ecx,%esi
  105b0f:	89 d7                	mov    %edx,%edi
  105b11:	ac                   	lods   %ds:(%esi),%al
  105b12:	aa                   	stos   %al,%es:(%edi)
  105b13:	84 c0                	test   %al,%al
  105b15:	75 fa                	jne    105b11 <strcpy+0x22>
  105b17:	89 fa                	mov    %edi,%edx
  105b19:	89 f1                	mov    %esi,%ecx
  105b1b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b1e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b27:	83 c4 20             	add    $0x20,%esp
  105b2a:	5e                   	pop    %esi
  105b2b:	5f                   	pop    %edi
  105b2c:	5d                   	pop    %ebp
  105b2d:	c3                   	ret    

00105b2e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b2e:	55                   	push   %ebp
  105b2f:	89 e5                	mov    %esp,%ebp
  105b31:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b34:	8b 45 08             	mov    0x8(%ebp),%eax
  105b37:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b3a:	eb 21                	jmp    105b5d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b3f:	0f b6 10             	movzbl (%eax),%edx
  105b42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b45:	88 10                	mov    %dl,(%eax)
  105b47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b4a:	0f b6 00             	movzbl (%eax),%eax
  105b4d:	84 c0                	test   %al,%al
  105b4f:	74 04                	je     105b55 <strncpy+0x27>
            src ++;
  105b51:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b59:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b61:	75 d9                	jne    105b3c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b66:	c9                   	leave  
  105b67:	c3                   	ret    

00105b68 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b68:	55                   	push   %ebp
  105b69:	89 e5                	mov    %esp,%ebp
  105b6b:	57                   	push   %edi
  105b6c:	56                   	push   %esi
  105b6d:	83 ec 20             	sub    $0x20,%esp
  105b70:	8b 45 08             	mov    0x8(%ebp),%eax
  105b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b82:	89 d1                	mov    %edx,%ecx
  105b84:	89 c2                	mov    %eax,%edx
  105b86:	89 ce                	mov    %ecx,%esi
  105b88:	89 d7                	mov    %edx,%edi
  105b8a:	ac                   	lods   %ds:(%esi),%al
  105b8b:	ae                   	scas   %es:(%edi),%al
  105b8c:	75 08                	jne    105b96 <strcmp+0x2e>
  105b8e:	84 c0                	test   %al,%al
  105b90:	75 f8                	jne    105b8a <strcmp+0x22>
  105b92:	31 c0                	xor    %eax,%eax
  105b94:	eb 04                	jmp    105b9a <strcmp+0x32>
  105b96:	19 c0                	sbb    %eax,%eax
  105b98:	0c 01                	or     $0x1,%al
  105b9a:	89 fa                	mov    %edi,%edx
  105b9c:	89 f1                	mov    %esi,%ecx
  105b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ba1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ba4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105baa:	83 c4 20             	add    $0x20,%esp
  105bad:	5e                   	pop    %esi
  105bae:	5f                   	pop    %edi
  105baf:	5d                   	pop    %ebp
  105bb0:	c3                   	ret    

00105bb1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bb1:	55                   	push   %ebp
  105bb2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bb4:	eb 0c                	jmp    105bc2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bb6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bbe:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bc2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bc6:	74 1a                	je     105be2 <strncmp+0x31>
  105bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcb:	0f b6 00             	movzbl (%eax),%eax
  105bce:	84 c0                	test   %al,%al
  105bd0:	74 10                	je     105be2 <strncmp+0x31>
  105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd5:	0f b6 10             	movzbl (%eax),%edx
  105bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bdb:	0f b6 00             	movzbl (%eax),%eax
  105bde:	38 c2                	cmp    %al,%dl
  105be0:	74 d4                	je     105bb6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105be6:	74 18                	je     105c00 <strncmp+0x4f>
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	0f b6 00             	movzbl (%eax),%eax
  105bee:	0f b6 d0             	movzbl %al,%edx
  105bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf4:	0f b6 00             	movzbl (%eax),%eax
  105bf7:	0f b6 c0             	movzbl %al,%eax
  105bfa:	29 c2                	sub    %eax,%edx
  105bfc:	89 d0                	mov    %edx,%eax
  105bfe:	eb 05                	jmp    105c05 <strncmp+0x54>
  105c00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c05:	5d                   	pop    %ebp
  105c06:	c3                   	ret    

00105c07 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c07:	55                   	push   %ebp
  105c08:	89 e5                	mov    %esp,%ebp
  105c0a:	83 ec 04             	sub    $0x4,%esp
  105c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c10:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c13:	eb 14                	jmp    105c29 <strchr+0x22>
        if (*s == c) {
  105c15:	8b 45 08             	mov    0x8(%ebp),%eax
  105c18:	0f b6 00             	movzbl (%eax),%eax
  105c1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c1e:	75 05                	jne    105c25 <strchr+0x1e>
            return (char *)s;
  105c20:	8b 45 08             	mov    0x8(%ebp),%eax
  105c23:	eb 13                	jmp    105c38 <strchr+0x31>
        }
        s ++;
  105c25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c29:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2c:	0f b6 00             	movzbl (%eax),%eax
  105c2f:	84 c0                	test   %al,%al
  105c31:	75 e2                	jne    105c15 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c38:	c9                   	leave  
  105c39:	c3                   	ret    

00105c3a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c3a:	55                   	push   %ebp
  105c3b:	89 e5                	mov    %esp,%ebp
  105c3d:	83 ec 04             	sub    $0x4,%esp
  105c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c43:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c46:	eb 11                	jmp    105c59 <strfind+0x1f>
        if (*s == c) {
  105c48:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4b:	0f b6 00             	movzbl (%eax),%eax
  105c4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c51:	75 02                	jne    105c55 <strfind+0x1b>
            break;
  105c53:	eb 0e                	jmp    105c63 <strfind+0x29>
        }
        s ++;
  105c55:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c59:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5c:	0f b6 00             	movzbl (%eax),%eax
  105c5f:	84 c0                	test   %al,%al
  105c61:	75 e5                	jne    105c48 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c63:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c66:	c9                   	leave  
  105c67:	c3                   	ret    

00105c68 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c68:	55                   	push   %ebp
  105c69:	89 e5                	mov    %esp,%ebp
  105c6b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c75:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c7c:	eb 04                	jmp    105c82 <strtol+0x1a>
        s ++;
  105c7e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c82:	8b 45 08             	mov    0x8(%ebp),%eax
  105c85:	0f b6 00             	movzbl (%eax),%eax
  105c88:	3c 20                	cmp    $0x20,%al
  105c8a:	74 f2                	je     105c7e <strtol+0x16>
  105c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c8f:	0f b6 00             	movzbl (%eax),%eax
  105c92:	3c 09                	cmp    $0x9,%al
  105c94:	74 e8                	je     105c7e <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105c96:	8b 45 08             	mov    0x8(%ebp),%eax
  105c99:	0f b6 00             	movzbl (%eax),%eax
  105c9c:	3c 2b                	cmp    $0x2b,%al
  105c9e:	75 06                	jne    105ca6 <strtol+0x3e>
        s ++;
  105ca0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ca4:	eb 15                	jmp    105cbb <strtol+0x53>
    }
    else if (*s == '-') {
  105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca9:	0f b6 00             	movzbl (%eax),%eax
  105cac:	3c 2d                	cmp    $0x2d,%al
  105cae:	75 0b                	jne    105cbb <strtol+0x53>
        s ++, neg = 1;
  105cb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cb4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cbf:	74 06                	je     105cc7 <strtol+0x5f>
  105cc1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cc5:	75 24                	jne    105ceb <strtol+0x83>
  105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  105cca:	0f b6 00             	movzbl (%eax),%eax
  105ccd:	3c 30                	cmp    $0x30,%al
  105ccf:	75 1a                	jne    105ceb <strtol+0x83>
  105cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd4:	83 c0 01             	add    $0x1,%eax
  105cd7:	0f b6 00             	movzbl (%eax),%eax
  105cda:	3c 78                	cmp    $0x78,%al
  105cdc:	75 0d                	jne    105ceb <strtol+0x83>
        s += 2, base = 16;
  105cde:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105ce2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105ce9:	eb 2a                	jmp    105d15 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105ceb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cef:	75 17                	jne    105d08 <strtol+0xa0>
  105cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf4:	0f b6 00             	movzbl (%eax),%eax
  105cf7:	3c 30                	cmp    $0x30,%al
  105cf9:	75 0d                	jne    105d08 <strtol+0xa0>
        s ++, base = 8;
  105cfb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cff:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d06:	eb 0d                	jmp    105d15 <strtol+0xad>
    }
    else if (base == 0) {
  105d08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d0c:	75 07                	jne    105d15 <strtol+0xad>
        base = 10;
  105d0e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d15:	8b 45 08             	mov    0x8(%ebp),%eax
  105d18:	0f b6 00             	movzbl (%eax),%eax
  105d1b:	3c 2f                	cmp    $0x2f,%al
  105d1d:	7e 1b                	jle    105d3a <strtol+0xd2>
  105d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d22:	0f b6 00             	movzbl (%eax),%eax
  105d25:	3c 39                	cmp    $0x39,%al
  105d27:	7f 11                	jg     105d3a <strtol+0xd2>
            dig = *s - '0';
  105d29:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2c:	0f b6 00             	movzbl (%eax),%eax
  105d2f:	0f be c0             	movsbl %al,%eax
  105d32:	83 e8 30             	sub    $0x30,%eax
  105d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d38:	eb 48                	jmp    105d82 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3d:	0f b6 00             	movzbl (%eax),%eax
  105d40:	3c 60                	cmp    $0x60,%al
  105d42:	7e 1b                	jle    105d5f <strtol+0xf7>
  105d44:	8b 45 08             	mov    0x8(%ebp),%eax
  105d47:	0f b6 00             	movzbl (%eax),%eax
  105d4a:	3c 7a                	cmp    $0x7a,%al
  105d4c:	7f 11                	jg     105d5f <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d51:	0f b6 00             	movzbl (%eax),%eax
  105d54:	0f be c0             	movsbl %al,%eax
  105d57:	83 e8 57             	sub    $0x57,%eax
  105d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d5d:	eb 23                	jmp    105d82 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d62:	0f b6 00             	movzbl (%eax),%eax
  105d65:	3c 40                	cmp    $0x40,%al
  105d67:	7e 3d                	jle    105da6 <strtol+0x13e>
  105d69:	8b 45 08             	mov    0x8(%ebp),%eax
  105d6c:	0f b6 00             	movzbl (%eax),%eax
  105d6f:	3c 5a                	cmp    $0x5a,%al
  105d71:	7f 33                	jg     105da6 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d73:	8b 45 08             	mov    0x8(%ebp),%eax
  105d76:	0f b6 00             	movzbl (%eax),%eax
  105d79:	0f be c0             	movsbl %al,%eax
  105d7c:	83 e8 37             	sub    $0x37,%eax
  105d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d85:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d88:	7c 02                	jl     105d8c <strtol+0x124>
            break;
  105d8a:	eb 1a                	jmp    105da6 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105d8c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d93:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d97:	89 c2                	mov    %eax,%edx
  105d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d9c:	01 d0                	add    %edx,%eax
  105d9e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105da1:	e9 6f ff ff ff       	jmp    105d15 <strtol+0xad>

    if (endptr) {
  105da6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105daa:	74 08                	je     105db4 <strtol+0x14c>
        *endptr = (char *) s;
  105dac:	8b 45 0c             	mov    0xc(%ebp),%eax
  105daf:	8b 55 08             	mov    0x8(%ebp),%edx
  105db2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105db4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105db8:	74 07                	je     105dc1 <strtol+0x159>
  105dba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dbd:	f7 d8                	neg    %eax
  105dbf:	eb 03                	jmp    105dc4 <strtol+0x15c>
  105dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105dc4:	c9                   	leave  
  105dc5:	c3                   	ret    

00105dc6 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105dc6:	55                   	push   %ebp
  105dc7:	89 e5                	mov    %esp,%ebp
  105dc9:	57                   	push   %edi
  105dca:	83 ec 24             	sub    $0x24,%esp
  105dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd0:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105dd3:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  105dda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105ddd:	88 45 f7             	mov    %al,-0x9(%ebp)
  105de0:	8b 45 10             	mov    0x10(%ebp),%eax
  105de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105de6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105de9:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ded:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105df0:	89 d7                	mov    %edx,%edi
  105df2:	f3 aa                	rep stos %al,%es:(%edi)
  105df4:	89 fa                	mov    %edi,%edx
  105df6:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105df9:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105dfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105dff:	83 c4 24             	add    $0x24,%esp
  105e02:	5f                   	pop    %edi
  105e03:	5d                   	pop    %ebp
  105e04:	c3                   	ret    

00105e05 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e05:	55                   	push   %ebp
  105e06:	89 e5                	mov    %esp,%ebp
  105e08:	57                   	push   %edi
  105e09:	56                   	push   %esi
  105e0a:	53                   	push   %ebx
  105e0b:	83 ec 30             	sub    $0x30,%esp
  105e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  105e1d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e26:	73 42                	jae    105e6a <memmove+0x65>
  105e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e31:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e37:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e3d:	c1 e8 02             	shr    $0x2,%eax
  105e40:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e48:	89 d7                	mov    %edx,%edi
  105e4a:	89 c6                	mov    %eax,%esi
  105e4c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e4e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e51:	83 e1 03             	and    $0x3,%ecx
  105e54:	74 02                	je     105e58 <memmove+0x53>
  105e56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e58:	89 f0                	mov    %esi,%eax
  105e5a:	89 fa                	mov    %edi,%edx
  105e5c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e5f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e62:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e68:	eb 36                	jmp    105ea0 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e73:	01 c2                	add    %eax,%edx
  105e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e78:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e7e:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e84:	89 c1                	mov    %eax,%ecx
  105e86:	89 d8                	mov    %ebx,%eax
  105e88:	89 d6                	mov    %edx,%esi
  105e8a:	89 c7                	mov    %eax,%edi
  105e8c:	fd                   	std    
  105e8d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e8f:	fc                   	cld    
  105e90:	89 f8                	mov    %edi,%eax
  105e92:	89 f2                	mov    %esi,%edx
  105e94:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e97:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ea0:	83 c4 30             	add    $0x30,%esp
  105ea3:	5b                   	pop    %ebx
  105ea4:	5e                   	pop    %esi
  105ea5:	5f                   	pop    %edi
  105ea6:	5d                   	pop    %ebp
  105ea7:	c3                   	ret    

00105ea8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ea8:	55                   	push   %ebp
  105ea9:	89 e5                	mov    %esp,%ebp
  105eab:	57                   	push   %edi
  105eac:	56                   	push   %esi
  105ead:	83 ec 20             	sub    $0x20,%esp
  105eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  105ebf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ec5:	c1 e8 02             	shr    $0x2,%eax
  105ec8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ed0:	89 d7                	mov    %edx,%edi
  105ed2:	89 c6                	mov    %eax,%esi
  105ed4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ed6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105ed9:	83 e1 03             	and    $0x3,%ecx
  105edc:	74 02                	je     105ee0 <memcpy+0x38>
  105ede:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ee0:	89 f0                	mov    %esi,%eax
  105ee2:	89 fa                	mov    %edi,%edx
  105ee4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ee7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105eea:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105ef0:	83 c4 20             	add    $0x20,%esp
  105ef3:	5e                   	pop    %esi
  105ef4:	5f                   	pop    %edi
  105ef5:	5d                   	pop    %ebp
  105ef6:	c3                   	ret    

00105ef7 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105ef7:	55                   	push   %ebp
  105ef8:	89 e5                	mov    %esp,%ebp
  105efa:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105efd:	8b 45 08             	mov    0x8(%ebp),%eax
  105f00:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f03:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f09:	eb 30                	jmp    105f3b <memcmp+0x44>
        if (*s1 != *s2) {
  105f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f0e:	0f b6 10             	movzbl (%eax),%edx
  105f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f14:	0f b6 00             	movzbl (%eax),%eax
  105f17:	38 c2                	cmp    %al,%dl
  105f19:	74 18                	je     105f33 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f1e:	0f b6 00             	movzbl (%eax),%eax
  105f21:	0f b6 d0             	movzbl %al,%edx
  105f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f27:	0f b6 00             	movzbl (%eax),%eax
  105f2a:	0f b6 c0             	movzbl %al,%eax
  105f2d:	29 c2                	sub    %eax,%edx
  105f2f:	89 d0                	mov    %edx,%eax
  105f31:	eb 1a                	jmp    105f4d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f33:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f37:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  105f3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f41:	89 55 10             	mov    %edx,0x10(%ebp)
  105f44:	85 c0                	test   %eax,%eax
  105f46:	75 c3                	jne    105f0b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f4d:	c9                   	leave  
  105f4e:	c3                   	ret    
