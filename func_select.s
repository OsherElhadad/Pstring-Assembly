    #Osher Elhadad

.section .rodata
str_pstrlen:        .string	"first pstring length: %d, second pstring length: %d\n"
str_replace_char:   .string	"old char: %c, new char: %c, first string: %s, second string: %s\n"
str_pstrijcpy:      .string	"length: %d, string: %s\n"
str_swap_case:      .string	"length: %d, string: %s\n"
str_pstrijcmp:      .string	"compare result: %d\n"
str_def:            .string	"invalid option!\n"
str_scan_num:       .string      "%d"
str_scan_char:      .string      "%c"
str_scan_str:       .string      "%s"

    .align 8                                    # Align address to multiple of 8
.CasesArray:
        .quad .L_pstrlen                        # Case 50\60: pstrlen
        .quad .L_def                            # Case 51: defult
        .quad .L_replace_char                   # Case 52: replace_char
        .quad .L_pstrijcpy                      # Case 53: pstrijcpy
        .quad .L_swap_case                      # Case 54: swap_case
        .quad .L_pstrijcmp                      # Case 55: pstrijcmp

.text                                           #the beginnig of the code
.globl	run_func
	.type	run_func, @function	                #the label "run_func" representing the beginning of a function
# void run_func(int option, pstring* p1, pstring* p2)
# option in %edi, p1 in %rsi, p2 in %rdx
run_func:                                       # the run_func function:
	    pushq	%rbp	                        #save the old frame pointer
	    movq	%rsp, %rbp                      #create the new frame pointer
        pushq    %rbx                           #save collee register
        pushq    %r12                           #save collee register
        pushq    %r13                           #save collee register
        movq     %rsi, %rbx                     #copy p1 to local_p1
        movq     %rdx, %r12                     #copy p2 to local_p2
        subq     $8, %rsp                       #add 8 bytes to the stack

        subl    $50, %edi                       #compute option = option - 50
        movl    %edi, %ecx                      #compute option2 = option
        subl    $10, %ecx                       #compare option2 = option2 - 10
        cmove   %ecx, %edi                      #if option2 = 0 (hte original option is 60), then option = option2.
        cmpl    $5, %edi                        #compare option : 5
        ja      .L_def                          #if option > 5
        jmp     *.CasesArray(, %edi, 8)         #jump to the option of the switch case
        
.L_pstrlen:
        movq    %rbx, %rdi                      #pass to pstrlen local_p1
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movb    %al, (%rsp)                     #save in the stack len(p1)
        movq    %r12, %rdi                      #pass to pstrlen local_p2
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movzbl   %al, %edx                      #save in l2 = len(p2)
        movzbl   (%rsp), %esi                   #save in l1 = len(p1) (from the stack)
        movq	$str_pstrlen, %rdi              #the str_pstrlen is the first paramter passed to the printf function
	    xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp      .Done

.L_replace_char:
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_str, %rdi             #the str_scan_str is the first paramter passed to the scanf function
        movq    %rsp, %rsi                      #pass the pointer address of rsp (the stack)- old char to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_str, %rdi             #the str_scan_str is the first paramter passed to the scanf function
        leaq    1(%rsp), %rsi                   #pass the pointer address of rsp + 1 (the stack)- new char to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        movq    %rbx, %rdi                      #pass to replaceChar local_p1
        movb    (%rsp), %sil                    #pass to replaceChar the old char we got in the stack
        movb    1(%rsp), %dl                    #pass to replaceChar the new char we got in the stack
        call    replaceChar                     #call: Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
        
        movq    %rax, %r13                      #save the returned Pstring in r13
        movq    %r12, %rdi                      #pass to replaceChar local_p2
        movb    (%rsp), %sil                    #pass to replaceChar the old char we got in the stack
        movb    1(%rsp), %dl                    #pass to replaceChar the new char we got in the stack
        call    replaceChar                     #call: Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
        
	    movq	$str_replace_char, %rdi         #the str_replace_char is the first paramter passed to the printf function
	    movb    (%rsp), %sil                    #pass to printf the old char we got in the stack
        movb    1(%rsp), %dl                    #pass to printf the new char we got in the stack
        leaq    1(%r13), %rcx                   #pass to printf local_p1 (after the first size char)
        leaq    1(%rax), %r8                    #pass to printf local_p2 (after the first size char)
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_pstrijcpy:
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        movq    %rsp, %rsi                      #pass the pointer address of rsp (the stack)- address of i, to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        leaq    4(%rsp), %rsi                   #pass the pointer address of rsp + 4 (the stack)- address of j, to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        movq    %rbx, %rdi                      #pass local_p1 to dst in pstrijcpy
        movq    %r12, %rsi                      #pass local_p2 to src in pstrijcpy
        movb    (%rsp), %dl                     #pass i from stack to pstrijcpy
        movb    4(%rsp), %cl                    #pass j from stack to pstrijcpy
        call    pstrijcpy                       #call: Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
        movq    %rbx, %rdi                      #pass to pstrlen local_p1
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movq	$str_pstrijcpy, %rdi            #the str_pstrijcpy is the first paramter passed to the printf function
        movzbl  %al, %esi                       #pass len(p1) to printf
        leaq    1(%rbx), %rdx                   #pass to printf local_p1 (after the first size char)
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.

        movq    %r12, %rdi                      #pass to pstrlen p2
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movq	$str_pstrijcpy, %rdi            #the str_pstrijcpy is the first paramter passed to the printf function
        movzbl  %al, %esi                       #pass len(p2) to printf
        leaq    1(%r12), %rdx                   #pass to printf local_p2 (after the first size char)
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_swap_case:
        
        movq    %rbx, %rdi                      #pass to swapCase local_p1
        call    swapCase                        #call: Pstring* swapCase(Pstring* pstr)
        
        movq    %r12, %rdi                      #pass to swapCase local_p2
        call    swapCase                        #call: Pstring* swapCase(Pstring* pstr)
        
        movq    %rbx, %rdi                      #pass to pstrlen local_p1
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movq	$str_swap_case, %rdi            #the str_swap_case is the first paramter passed to the printf function
        movzbl  %al, %esi                       #pass len(local_p1) to printf
        leaq    1(%rbx), %rdx                   #pass to printf local_p1 (after the first size char)
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.

        movq    %r12, %rdi                      #pass to pstrlen local_p2
        call    pstrlen                         #call: char pstrlen(Pstring* pstr)
        
        movq	$str_swap_case, %rdi            #the str_swap_case is the first paramter passed to the printf function
        movzbl  %al, %esi                       #pass len(local_p2) to printf
        leaq    1(%r12), %rdx                   #pass to printf local_p2 (after the first size char)
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp      .Done
        
.L_pstrijcmp:
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        movq    %rsp, %rsi                      #pass the pointer address of rsp (the stack)- address of i, to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        leaq    4(%rsp), %rsi                   #pass the pointer address of rsp (the stack)- address of j, to scanf
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        movq    %rbx, %rdi                      #pass to pstrijcmp local_p1
        movq    %r12, %rsi                      #pass to pstrijcmp local_p2
        movb    (%rsp), %dl                     #pass i from stack to pstrijcpy
        movb    4(%rsp), %cl                    #pass j from stack to pstrijcpy
        call    pstrijcmp                       #call: int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)
        
	    movq	$str_pstrijcmp, %rdi            #the str_pstrijcmp is the first paramter passed to the printf function
	    movl    %eax, %esi                      #pass to printf the returned int from pstrijcmp
        xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        jmp      .Done

.L_def:
	    movq	$str_def, %rdi                  #the str_def is the first paramter passed to the printf function
	    xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #calling to printf AFTER we passed its parameters.

.Done:
        addq     $8, %rsp                       #deallocate 8 bytes from the stack
        popq     %r13                           #get the collee value back
	    popq	%r12                            #get the collee value back
	    popq	%rbx                            #get the collee value back
	    movq	%rbp, %rsp                      #restore the old stack pointer - release all used memory.
	    popq	%rbp	                        #restore old frame pointer (the caller function frame)
	    ret		                                #return to caller function
