    #Osher Elhadad

.section .rodata
str_invalid:        .string	"invalid input!\n"
.text	                                        #the beginnig of the code
.globl	pstrlen 
	.type	pstrlen, @function	                # the label "pstrlen" representing the beginning of a function
# char pstrlen(Pstring* pstr)
# p1 in %rdi
pstrlen:                            	        # the pstrlen function:
	    movb   (%rdi), %al                      #return the first size char of a pstring p1
	    ret                                     #return to caller function 3077 4400


.globl	replaceChar
	.type	replaceChar, @function	            #the label "replaceChar" representing the beginning of a function
# Pstring* replaceChar(Pstring* pstr, char oldChar, char newChar)
# p1 in %rdi, oldChar in %sil, newChar in %dl
replaceChar:	                                #the replaceChar function:
        xorq    %rax, %rax                      #compute %rax = 0
	    movb   (%rdi), %al                      #get the first size char of a pstring p1 in l1

.While1:
        cmpb    $0, %al                         #compare l1 to 0
        je      .Done1                          #if al = 0 then jmp to Done1
        movzbq  %sil, %rsi                      #add 0's in the end of %sil
        movzbq  %dl, %rdx                       #add 0's in the end of %dl
        movq    %rdx, %rcx                      #move newChar into c1
        movzbq  (%rdi, %rax), %r8               #move p1[l1] to c2
        cmpb    %r8b, %sil                      #compare oldChar to c2
        cmovne  %r8, %rdx                       #if c2 != oldChar, then move c2 to newChar
        movb    %dl, (%rdi, %rax)               #move newChar
        movq    %rcx, %rdx                      #move c1 into newChar
        decb    %al                             #l1 = l1 - 1
        jmp     .While1
        
.Done1:
        movq    %rdi, %rax                      #return p1
	    ret                                     #return to caller function


.globl	pstrijcpy
	.type	pstrijcpy, @function	            # the label "pstrijcpy" representing the beginning of a function
# Pstring* pstrijcpy(Pstring* dst, Pstring* src, char i, char j)
# p1 in %rdi, p2 in %rsi, i in %dl, j in %cl
pstrijcpy:	                                    # the run_main function:
        xorq    %r8, %r8                        #compute a = 0
	    movb   (%rdi), %r8b                     #compute a = len(p1)
        xorq    %r9, %r9                        #compute b = 0
	    movb   (%rsi), %r9b                     #compute b = len(p2)
        cmpb    %dl, %cl                        #compare j : i
        jb      .Error2                         #if j < i, then Error2
        cmpb    %dl, %r8b                       #compare len(p1) : i
        jbe      .Error2                        #if len(p1) <= i, then Error2
        cmpb    %dl, %r9b                       #compare len(p2) : i
        jbe      .Error2                        #if len(p2) <= i, then Error2
        cmpb    %cl, %r8b                       #compare len(p1) : j
        jbe      .Error2                        #if len(p1) <= j, then Error2
        cmpb    %cl, %r9b                       #compare len(p2) : j
        jbe      .Error2                        #if len(p2) <= j, then Error2
        
        movzbq  %dl, %rdx                       #add 0's in the end of %dl
        
.While2:
        cmpb    %dl, %cl                        #compare j : i
        jb      .Done2                          #if j < i, then Done2
        movb    1(%rsi, %rdx), %r8b             #move p1[i+1] to temp
        movb    %r8b, 1(%rdi, %rdx)             #move temp to p2[i+1]
        incb    %dl                             #compute i = i + 1
        jmp     .While2
        
.Error2:
        movq	$str_invalid, %rdi              #the str_invalid is the first paramter passed to the printf function
	    xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #call to printf AFTER we passed its parameters.
        
.Done2:
        movq    %rdi, %rax                      #return p1
	    ret		                                #return to caller function


.globl	swapCase
	.type	swapCase, @function	                #the label "swapCase" representing the beginning of a function
# Pstring* swapCase(Pstring* pstr)
# p1 in %rdi
swapCase:	                                    #the run_main function: rdi
        xorq    %rax, %rax                      #compute i = 0
	    movb   (%rdi), %al                      #get the first size char of a pstring p1 in i

.While3:
        cmpb    $0, %al                         #compare i : 0
        je      .Done3                          #if i = 0, then Done3
        movb    (%rdi, %rax), %dl               #move p1[i] to c1
        cmpb    $122, %dl                       #compare c1 : 122 (the last letter in english in ascii - z)
        ja      .Next3                          #if c1 > 122, then Next3 (not a letter in english)
        cmpb    $65, %dl                        #compare c1 : 65 (the first letter in english in ascii - A)
        jb      .Next3                          #if c1 < 65, then Next3 (not a letter in english)
        cmpb    $91, %dl                        #compare c1 : 91 (the last upper letter in english in ascii)
        jb      .Upper_Case                     #if c1 < 91, then it is a upperCase
        cmpb    $96, %dl                        #compare c1 : 96 (the first lower letter in english in ascii)
        ja      .Lower_Case                     #if c1 > 96, then it is a lowerCase
        jmp     .Next3
               
.Lower_Case:
        subb    $32, %dl                        #compute c1 - 32 (from lower to upper)
        movb    %dl, (%rdi, %rax)               #move the upper back to p[i]
        jmp     .Next3
        
.Upper_Case:
        addb    $32, %dl                        #compute c1 + 32 (from upper to lower)
        movb    %dl, (%rdi, %rax)               #move the lower back to p[i]
        
.Next3:
        decb    %al                             #compute i = i - 1
        jmp     .While3
        
        
.Done3:
        movq    %rdi, %rax                      #return p1
	    ret		                                #return to caller function


.globl	pstrijcmp
	.type	pstrijcmp, @function	            #the label "pstrijcmp" representing the beginning of a function
# int pstrijcmp(Pstring* pstr1, Pstring* pstr2, char i, char j)
# p1 in %rdi, p2 in %rsi, i in %dl, j in %cl
pstrijcmp:	                                    #the run_main function:
        xorq    %r8, %r8                        #compute a = 0
	    movb   (%rdi), %r8b                     #compute a = len(p1)
        xorq    %r9, %r9                        #compute b = 0
	    movb   (%rsi), %r9b                     #compute b = len(p2)
        cmpb    %dl, %cl                        #compare j : i
        jb      .Error4                         #if j < i, then Error2
        cmpb    %dl, %r8b                       #compare len(p1) : i
        jbe      .Error4                        #if len(p1) <= i, then Error2
        cmpb    %dl, %r9b                       #compare len(p2) : i
        jbe      .Error4                        #if len(p2) <= i, then Error2
        cmpb    %cl, %r8b                       #compare len(p1) : j
        jbe      .Error4                        #if len(p1) <= j, then Error2
        cmpb    %cl, %r9b                       #compare len(p2) : j
        jbe      .Error4                        #if len(p2) <= j, then Error2
        
        movzbq  %dl, %rdx                       #add 0's in the end of %dl
        
.While4:
        cmpb    %dl, %cl                        #compare j : i
        jb      .Equal4                         #if j < i, then Equal4
        movb    1(%rsi, %rdx), %r8b             #move p2[i+1] to temp
        cmpb    1(%rdi, %rdx), %r8b             #compare p1[i+1] : temp
        jb      .P1i_greater_p2i                #if temp < p1[i+1], then p1 is greater then p2
        cmpb    1(%rdi, %rdx), %r8b             #compare p1[i+1] : temp
        ja      .P2i_greater_p1i                #if temp > p1[i+1], then p2 is greater then p1
        
        incb    %dl                             #compute i = i + 1
        jmp     .While4
        
.Error4:
        movq	$str_invalid, %rdi              #the str_invalid is the first paramter passed to the printf function
	    xorq	%rax, %rax                      #compute %rax = 0
	    call	printf	                        #calling to printf AFTER we passed its parameters.
        movl    $-2, %eax                       #return -2 (error)
        jmp     .Done4
        
.Equal4:
        xorl    %eax, %eax                      #return 0 (equals)
        jmp     .Done4
        
.P1i_greater_p2i:
        movl    $1, %eax                        #return 1 (p1 is greater then p2)
        jmp     .Done4
        
.P2i_greater_p1i:
        movl    $-1, %eax                       #return 1 (p2 is greater then p1)
        
.Done4:
	    ret			                            #return to caller function
