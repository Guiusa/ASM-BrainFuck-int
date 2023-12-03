.section .data

.section .text
.globl printar
printar:
	push %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi
	movq $1, %rax
	movq $1, %rdi
	movq $10, %rdx
	syscall

	popq %rbp
	ret
