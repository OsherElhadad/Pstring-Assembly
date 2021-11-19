.text	#the beginnig of the code
.globl	run_main 	#the label "run_main" is used to state the initial point of this program
	.type	run_main, @function	# the label "run_main" representing the beginning of a function
run_main:	# the run_main function:
	pushq	%rbp		#save the old frame pointer
	movq	%rsp,	%rbp	#create the new frame pointer

	movq	$str,%rdi	#the string is the only paramter passed to the printf function (remember- first parameter goes in %rdi).
	movq	$0,%rax
	call	printf		#calling to printf AFTER we passed its parameters.

	#return from printf:
	movq	$0, %rax         #return value is zero (just like in c - we tell the OS that this program finished seccessfully)
	movq	%rbp, %rsp	#restore the old stack pointer - release all used memory.
	popq	%rbp		#restore old frame pointer (the caller function frame)
	ret			#return to caller function (OS)