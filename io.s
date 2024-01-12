.section .data
	.globl BUFF
	BUFF: .fill 512
	BUFF_S: .quad 512
	EOF: .word 255
.section .text
.globl printStr
.globl readStr
.globl returnBuff

printStr:
	push %rbp
	movq %rsp, %rbp

	movq %rdi, %r9
	
	movq $0, %rbx
	while_printStr:
	mov (%r9), %cl
	cmp $0, %cl
	je end_while_printStr
	
	addq $1, %rbx
	addq $1, %r9
	jmp while_printStr
	end_while_printStr:

	movq %rdi, %rsi
	movq $1, %rax		# syscall write
	movq $1, %rdi		# valor 1 stdout
	movq %rbx, %rdx
	syscall

	popq %rbp
	ret

readBUFF:
	pushq %rbp
	movq %rsp, %rbp

	movq $0, %rdi
	leaq BUFF, %rsi
	movq BUFF_S, %rdx
	movq $0, %rax
	syscall

	popq %rbp
	ret

readStr:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq %rdi, %rax 	 	# destiny Buffer Address
	movq %rdi, %r8			# save first address
	movq %rsi, -16(%rbp)	# destiny Buffer Size
	movq $0, %rbx		 	# destiny buffer occupied bytes (counter)
	
	readStr_read_BUFF:
		movq %rax, -8(%rbp)
	# READING IN BUFFER ########################################################	
		call readBUFF			
	# BUFF BYTES COPIED TO DESTINY BUFFER ######################################
		movq -8(%rbp), %rax  	# current destiny buffer pointer
		leaq BUFF, %rcx 		# BUFF pointer
		movq $0, %rdx			# counter of BUFF bytes
		readStr_iter_BUFF:
			mov (%rcx), %r9b
			cmp $10, %r9b
			je readStr_end_iter_BUFF
				
			mov %r9b, (%rax) 	# writes current char in destiny buffer
			addq $1, %rax
			addq $1, %rbx
			addq $1, %rcx
			addq $1, %rdx

			movq -16(%rbp), %r9
			cmpq %r9, %rbx		# input > destiny buffer
			ja readStr_input_bigger

			movq BUFF_S, %r9 			# aux for comparision
			cmpq %r9, %rdx				# input > BUFF_S : reads more
			je readStr_read_BUFF
	
			jmp readStr_iter_BUFF
		# CLEAR STDIN AND RETURNS NULL #########################################
			readStr_input_bigger:
			movq $0, %rbx
			movw $0, (%r8)
	
			movq $1, %rax
			movq %r8, %rsi
			movq $0, %rdi
			movq $1, %rdx
			syscall

		readStr_end_iter_BUFF:
	movq %rbx, %rax
	addq $16, %rsp
	popq %rbp
	ret
