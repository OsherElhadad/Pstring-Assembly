.section .rodata
str_pstrlen:        .string	"first pstring length: %d, second pstring length: %d\n"
str_replace_char:   .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
str_pstrijcpy:      .string	"length: %d, string: %s\n"
str_swap_case:      .string	"length: %d, string: %s\n "
str_pstrijcmp:      .string	"compare result: %d\n"
str_def:            .string	"invalid option!\n"
str_scan_num:       .string      "%d"
str_scan_char:      .string      "%c"

    .align 8                    # Align address to multiple of 8
.CasesArray:
        .quad .L_pstrlen        # Case 50\60: pstrlen
        .quad .L_def            # Case 51: defult
        .quad .L_replace_char   # Case 52: replace_char
        .quad .L_pstrijcpy      # Case 53: pstrijcpy
        .quad .L_swap_case      # Case 54: swap_case
        .quad .L_pstrijcmp      # Case 55: pstrijcmp

.text                           #the beginnig of the code
.globl	main 	       #the label "run_func" is used to state the initial point of this program
	.type	run_func, @function	# the label "run_func" representing the beginning of a function
# void run_func(int option, pstring* p1, pstring* p2);
# option in %edi, p1 in %rsi, p2 in %rdx
main:
    movq %rsp, %rbp #for correct debugging                       # the run_func function:
	pushq	%rbp	       #save the old frame pointer
	movq	%rsp, %rbp     #create the new frame pointer
        pushq    %rbx
        pushq    %r12
        pushq    %r13
        movq     %rsi, %rbx     #copy p1 to local_p1
        movq     %rdx, %r12     #copy p2 to local_p2
        subq     $8, %rsp


        xorq    %rax, %rax
        movl    %edi, %ecx
        movq    $str_scan_num, %rdi
        movq    %rsp, %rsi
        call    scanf
        movl    (%rsp), %edi


        subl    $50, %edi       #compute option = option - 50
        movl    %edi, %ecx      #compute option2 = option
        subl    $10, %ecx       #compare option2 : option2 - 10
        cmove   %ecx, %edi      #if option2 = 0 (hte original option is 60), then option = option2.
        cmpl    $5, %edi        #compare option : 5
        ja      .L_def
        jmp     *.CasesArray(, %edi, 8)
        
.L_pstrlen:
        movq    %rbx, %rdi      #pass to pstrlen p1
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movb    %al, (%rsp)       #save in l1 = len(p1)
        movq    %r12, %rdi      #pass to pstrlen p2
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movzbl   %al, %edx       #save in l2 = len(p2)
        movzbl   (%rsp), %esi    #save in l1 = len(p1)
        movq	$str_pstrlen, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        jmp      .Done

.L_replace_char:
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        movq    %rsp, %rsi
        call    scanf
        
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        leaq    1(%rsp), %rsi
        call    scanf
        
        movq    %rbx, %rdi      #pass to pstrlen p1
        movb    (%rsp), %sil
        movb    1(%rsp), %dl
        call    replaceChar        #call: char pstrlen(Pstring* pstr)
        
        movq    %rax, %r13       #save in l1 = len(p1)
        movq    %r12, %rdi      #pass to pstrlen p2
        movb    (%rsp), %sil
        movb    1(%rsp), %dl
        call    replaceChar        #call: char pstrlen(Pstring* pstr)
        
	movq	$str_replace_char, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	movb    (%rsp), %sil
        movb    1(%rsp), %dl
        movq    %r13, %rcx
        movq    %rax, %r8
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_pstrijcpy:
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        movq    %rsp, %rsi  # i
        call    scanf
        
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        leaq    1(%rsp), %rsi   # j
        call    scanf
        
        movq    %rbx, %rdi      #pass p1 to dst
        movq    %r12, %rsi      #pass p1 to dst
        movb    (%rsp), %dl
        movb    1(%rsp), %cl
        call    pstrijcpy        #call: char pstrlen(Pstring* pstr)
        movq    %rbx, %rdi      #pass to pstrlen p1
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movq	$str_pstrijcpy, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).   
        movzbl  %al, %esi       #save in l1 = len(p1)
        movq    %rbx, %rdx
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.

        movq    %r12, %rdi      #pass to pstrlen p2
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movq	$str_pstrijcpy, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).   
        movzbl  %al, %esi       #save in l1 = len(p1)
        movq    %r12, %rdx
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_swap_case:
        
        	movq    %r12, %rdi      #pass to pstrlen p1
        call    swapCase        #call: char pstrlen(Pstring* pstr)
        
        movq    %rbx, %rdi      #pass to pstrlen p1
        call    swapCase        #call: char pstrlen(Pstring* pstr)
        
        movq    %rbx, %rdi      #pass to pstrlen p1
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movq	$str_swap_case, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).   
        movzbl  %al, %esi       #save in l1 = len(p1)
        movq    %rbx, %rdx
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.

        movq    %r12, %rdi      #pass to pstrlen p2
        call    pstrlen        #call: char pstrlen(Pstring* pstr)
        
        movq	$str_swap_case, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).   
        movzbl  %al, %esi       #save in l1 = len(p1)
        movq    %r12, %rdx
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_pstrijcmp:
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        movq    %rsp, %rsi  # i
        call    scanf
        
        xorq    %rax, %rax
        movq    $str_scan_char, %rdi
        leaq    1(%rsp), %rsi   # j
        call    scanf
        
        movq    %rbx, %rdi      #pass to pstrlen p1
        movq    %r12, %rsi      #pass to pstrlen p2
        movb    (%rsp), %dl
        movb    1(%rsp), %cl
        call    pstrijcmp        #call: char pstrlen(Pstring* pstr)
        
	movq	$str_pstrijcmp, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	movl    %eax, %esi
        xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        jmp      .Done

.L_def:
	movq	$str_def, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.

.Done:
        addq     $8, %rsp
        popq     %r13
	popq	%r12
	popq	%rbx
	movq	%rbp, %rsp     #restore the old stack pointer - release all used memory.
	popq	%rbp	       #restore old frame pointer (the caller function frame)
	ret		       #return to caller function (OS)

.globl	pstrlen 	       #the label "run_func" is used to state the initial point of this program
	.type	pstrlen, @function	# the label "run_func" representing the beginning of a function
pstrlen:
        ret
