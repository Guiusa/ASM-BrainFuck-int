.section .data
.section .bss
	BUFF: .space 100
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

	movq $1, %rax		# syscall write
	movq $1, %rdi		# valor 1 stdout
	movq %rbx, %rdx
	syscall

	popq %rbp
	ret

readStr:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq %rdi, 8(%rsp) # buffer address
	movq %rsi, 16(%rsp) # buffer size

	movq $100, %rdx
	movq BUFF, %rsi
	movq $0, %rdi
	movq $0, %rax
	syscall # reads 100 bytes from stdin, should check if stdin has too much B

	#movq $BUFF, %r8
	#movq 8(%rsp), %rsi
	#readStr_while:
	#mov (%r8), %cl
	#mov %cl, (%rsi)
	#addq $1, %r8
	#addq $1, %rsi

	#cmp $0, %cl
	#je end_readStr_while
	#jmp readStr_while
	#end_readStr_while:

	addq $16, %rsp
	popq %rbp
	ret
