.section .data

.section .text
.globl printStr
.globl read
printStr:
	push %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi		# string location
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

	movq $1, %rax		# syscall write
	movq $1, %rdi		# valor 1 stdout
	movq %rbx, %rdx
	syscall

	popq %rbp
	ret

readStr:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi
	movq $2, %rax		# syscall read
	movq $0, %rdi		# valor 0 stdin
	movq $10, %rdx
	syscall

	popq %rbp
	ret
