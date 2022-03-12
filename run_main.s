    #318969748 Osher Elhadad

.section .rodata
str_scan_num:       .string      "%d"
str_scan_str:       .string      "%s"

.text	                                        #the beginnig of the code
.globl	run_main
	.type	run_main, @function	                # the label "run_main" representing the beginning of a function
# void run_main()
run_main:	                                    # the run_main function:
	    pushq	%rbp		                    #save the old frame pointer
	    movq	%rsp,	%rbp	                #create the new frame pointer
        subq     $512, %rsp                     #allocate 512 bytes to the stack (2 pstrings)

	    xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        movq    %rsp, %rsi                      #move &p1 to scanf (the first byte is the size)
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rdi, %rdi                      #compute %rdi = 0
        movb    (%rsp), %dil                    #move size from the stack to s1
        movb    $0, 1(%rsp, %rdi)               #put 0 in p1[s1+1] in the end of p1
        
        movq    $str_scan_str, %rdi             #the str_scan_str is the first paramter passed to the scanf function
        xorq    %rax, %rax                      #compute %rax = 0
        leaq    1(%rsp), %rsi                   #move &(p1+1) to scanf (get the sting)
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        leaq    256(%rsp), %rsi                 #move &p2 to scanf (the first byte is the size)
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        xorq    %rdi, %rdi                      #compute %rdi = 0
        movb    256(%rsp), %dil                 #move size from the stack to s2
        movb    $0, 257(%rsp, %rdi)             #put 0 in p2[s2+1] in the end of p2
        
        movq    $str_scan_str, %rdi             #the str_scan_str is the first paramter passed to the scanf function
        xorq    %rax, %rax                      #compute %rax = 0
        leaq    257(%rsp), %rsi                 #move &(p2+1) to scanf (get the sting)
        call    scanf                           #call to scanf AFTER we passed its parameters.
        
        subq    $16, %rsp                       #allocate 16 bytes to the stack (2 pstrings)
        xorq    %rax, %rax                      #compute %rax = 0
        movq    $str_scan_num, %rdi             #the str_scan_num is the first paramter passed to the scanf function
        movq    %rsp, %rsi                      #pass to scanf &option
        call    scanf                           #call to scanf AFTER we passed its parameters.
        movl    (%rsp), %edi                    #pass to run_func option
        addq    $16, %rsp                       #deallocate 16 bytes to the stack (2 pstrings)
        movq    %rsp, %rsi                      #pass p1 to run_func
        leaq    256(%rsp), %rdx                 #pass p2 to run_func
        call    run_func                        #call: void run_func(int option, pstring* p1, pstring* p2)
        

        xorq     %rax, %rax                     #compute %rax = 0
        addq     $512, %rsp                     #deallocate 512 bytes to the stack (2 pstrings)
	    movq	%rbp, %rsp                      #restore the old stack pointer - release all used memory.
	    popq	%rbp	                        #restore old frame pointer (the caller function frame)
	    ret		                                #return to caller function
