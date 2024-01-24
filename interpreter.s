.data
	PILE: .fill 800
	TOP: .quad 0

.section .text
.globl execute_bf
.globl push
.globl pop

# void push(void* p) ###########################################################
# pushes an address to PILE and updates TOP ####################################
push:
	pushq %rbp
	movq %rsp, %rbp

	leaq PILE, %rbx
	movq TOP, %rcx
	addq %rcx, %rbx
	movq %rdi, (%rbx)

	movq TOP, %rbx
	addq $8, %rbx
	movq %rbx, TOP

	popq %rbp
	ret
################################################################################



# void* pop() ##################################################################
# pops TOP position and updates it #############################################
pop:
	pushq %rbp
	movq %rsp, %rbp

	movq TOP, %rbx
	subq $8, %rbx
	movq %rbx, TOP

	leaq PILE, %rcx
	addq %rbx, %rcx
	movq (%rcx), %rax

	popq %rbp
	ret
################################################################################



# int execute_bf(char* program, char* strip, char* prnt_bff) ###################
# reads program, returns the number of executed instructions ###################
execute_bf:
	pushq %rbp
	movq %rsp, %rbp
	
	subq $24, %rsp
	movq %rdi, 8(%rsp)
	movq %rsi, 16(%rsp)
	movq %rdx, 24(%rsp)

	movq $0, %rbx

	popq %rbp
	ret
################################################################################
