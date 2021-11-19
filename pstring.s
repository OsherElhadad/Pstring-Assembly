.section .rodata
str_invalid:        .string	"invalid input!\n"

.text	#the beginnig of the code
.globl	pstrlen 	#the label "run_main" is used to state the initial point of this program
	.type	pstrlen, @function	# the label "run_main" representing the beginning of a function
pstrlen:	# the run_main function:
	movb   (%rdi), %al
	ret			#return to caller function (OS)


.globl	replaceChar 	#the label "run_main" is used to state the initial point of this program
	.type	replaceChar, @function	# the label "run_main" representing the beginning of a function
replaceChar:	# the run_main function: rdi, sil, dl
        xorq    %rax, %rax
	movb   (%rdi), %al
.While1:
        cmpb    $0, %al
        je      .Done1
        cmpb    (%rdi, %rax), %sil
        cmove   %dl, (%rdi, %rax)
        decb    %al
        jmp     .While1
.Done1:
        movq    %rdi, %rax
	ret			#return to caller function (OS)


.globl	pstrijcpy 	#the label "run_main" is used to state the initial point of this program
	.type	pstrijcpy, @function	# the label "run_main" representing the beginning of a function
pstrijcpy:	# the run_main function: rdi, rsi, dl, cl
        xorq    %r8, %r8
	movb   (%rdi), %r8b
        xorq    %r9, %r9
	movb   (%rsi), %r9b
        cmpb    %dl, %cl    #j<i
        jb      .Error2
        cmpb    %dl, %r8b    #p1.length<i
        jb      .Error2
        cmpb    %dl, %r9b    #p2.length<i
        jb      .Error2
        cmpb    %cl, %r8b    #p1.length<j
        jb      .Error2
        cmpb    %cl, %r9b    #p2.length<j
        jb      .Error2
        
        movzbq  %dl, %rdx
.While2:
        cmpb    %dl, %cl    #j<i
        jb      .Done2
        movb    (%rsi, %rdx), %r8b
        movb    %r8b, (%rdi, %rdx)
        incb    %dl
        jmp     .While2
        
.Error2:
        movq	$str_invalid, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        
.Done2:
        movq    %rdi, %rax
	ret			#return to caller function (OS)


.globl	swapCase 	#the label "run_main" is used to state the initial point of this program
	.type	swapCase, @function	# the label "run_main" representing the beginning of a function
swapCase:	# the run_main function: rdi
        xorq    %rax, %rax
	movb   (%rdi), %al
.While3:
        cmpb    $0, %al
        je      .Done3
        movb    (%rdi, %rax), %dl
        cmpb    $122, %dl
        ja      .Next3
        cmpb    $65, %dl
        jb      .Next3
        cmpb    $91, %dl
        jb      .Upper_Case
        cmpb    $96, %dl
        ja      .Lower_Case
        jmp     .Next3
        
.Lower_Case:
        subb    $32, %dl
        movb    %dl, (%rdi, %rax)
        jmp     .Next3
.Upper_Case:
        addb    $32, %dl
        movb    %dl, (%rdi, %rax)
.Next3:
        decb    %al
        jmp     .While3
.Done3:
        movq    %rdi, %rax
	ret			#return to caller function (OS)


.globl	pstrijcmp 	#the label "run_main" is used to state the initial point of this program
	.type	pstrijcmp, @function	# the label "run_main" representing the beginning of a function
pstrijcmp:	# the run_main function: rdi, rsi, dl, cl
        xorq    %r8, %r8
	movb   (%rdi), %r8b
        xorq    %r9, %r9
	movb   (%rsi), %r9b
        cmpb    %dl, %cl    #j<i
        jb      .Error4
        cmpb    %dl, %r8b    #p1.length<i
        jb      .Error4
        cmpb    %dl, %r9b    #p2.length<i
        jb      .Error4
        cmpb    %cl, %r8b    #p1.length<j
        jb      .Error4
        cmpb    %cl, %r9b    #p2.length<j
        jb      .Error4
        
        movzbq  %dl, %rdx
.While4:
        cmpb    %dl, %cl    #j<i
        jb      .Done4
        movb    (%rsi, %rdx), %r8b
        movb    %r8b, (%rdi, %rdx)
        incb    %dl
        jmp     .While4
        
.Error4:
        movq	$str_invalid, %rdi    #the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	xorq	%rax, %rax     #compute %rax = 0
	call	printf	       #calling to printf AFTER we passed its parameters.
        movl    $-2, %eax
        
.Done4:
	ret			#return to caller function (OS)
