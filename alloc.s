# EXEMPLO DA ESTRUTURA DE DADOS DO NODO
#	struct node {
#		long ocp;			Nodo ocupado ou não
#		long size;			Tamanho do nodo
#		void data[size]		seção de dados alocada
#	}
# malloc(10) - 1|10|BBBBBBBBBB
.section .data
    TopoInicialHeap: .quad 0
	TopoHeap: .quad 0
	STR_HT: .string "################"
	STR_A:	.string "+"
	STR_F:	.string "-"
.section .text
.globl firstAlloc
.globl lastAlloc
.globl allocBlk
.globl freeBlk
.globl printHeap

#	void iniciaAlocador()	####################################################
#	inicia o brk	############################################################
firstAlloc:
    pushq %rbp
    movq %rsp, %rbp

    movq $12, %rax # syscall brk
	movq $0, %rdi
    syscall

	# armazena o retorno da syscall em TopoInicialHeap e TopoHeap
    movq %rax, TopoInicialHeap
	movq %rax, TopoHeap

    popq %rbp
    ret
################################################################################



#	void finalizaAlocador()	####################################################
#	finaliza o alocador retornando pro valor inicial do brk	####################
lastAlloc:
	pushq %rbp
	movq %rsp, %rbp

	# mata todos os bytes alocados retornando o valor do brk pro inicial
	movq $12, %rax
	movq TopoInicialHeap, %rdi 
	movq %rdi, TopoHeap
	syscall
	
	popq %rbp
	ret
################################################################################



#	void* firstFit()	############################################################
#	procura pelo primeiro nodo livre a partir do topoInicialHeap	################
firstFit:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq $0, -8(%rbp) # valor do ponteiro a ser retornado (começa em null)
	movq %rdi, -16(%rbp) # tamanho minimo do nodo

	movq TopoInicialHeap, %rdi # ocp do primeiro nodo
	
	init_while:
	cmpq %rdi, TopoHeap # Se verdadeiro, chegou ao fim sem achar nodos livres
	je fim_lista

	cmpq $0, (%rdi) # checa para ocp vazio
	jne continue
	movq %rdi, %rdx
	addq $8, %rdx
	movq (%rdx), %rdx
	cmpq %rdx, -16(%rbp) # checa se tamanho cabe
	jbe retorna_nodo
	
	continue:
	addq $8, %rdi
	movq (%rdi), %rcx
	addq $8, %rdi 
	addq %rcx, %rdi # %rdi contém endereço do início do próximo nodo
	
	jmp init_while
	fim_lista:
	movq -8(%rbp), %rdi
	jmp return

 	retorna_nodo:	
	addq $16, %rdi # soma 16 para apontar para data	

	return:
	movq %rdi, %rax
	addq $16, %rsp
	popq %rbp
	ret
################################################################################



# void* worst_fit
# void* aumenta_brk(long s) ####################################################
# Aloca nodo no fim da heap, aumentando o valor de brk #########################
aumenta_brk:
	pushq %rbp
	movq %rsp, %rbp
	
	subq $16, %rsp # alocando espaço para variáveis locais
	movq %rdi, -8(%rbp) # valor do argumento com tamanho do bloco
	movq TopoHeap, %rdx
	movq %rdx, -16(%rbp) # Salvando o endereço de ocp do bloco a ser alocado

	movq TopoHeap, %rdi # topo atual da heap
	addq -8(%rbp), %rdi # + adicionar tamanho do bloco a ser alocado
	addq $16, %rdi # + adicionar tamanho das variáveis de controle do nodo
	movq $12, %rax
	syscall
	
	movq %rax, TopoHeap

	# Bloco já alocado, adicionar valores corretos no controle #################

	movq -16(%rbp), %rbx # %rbx contém o endereço de ocp do bloco
	movq %rbx, %rcx 
	addq $8, %rcx # %rcx contém o endereço de size do bloco

	movq $1, (%rbx) # coloca o valor 1 em ocp do bloco
	movq -8(%rbp), %rbx
	movq %rbx, (%rcx) # coloca o tamanho do bloco em size

	movq %rcx, %rax
	addq $8, %rax # Salvando inicio dos dados para retorno em var

	addq $16, %rsp
	
	popq %rbp
	ret 
################################################################################



# void* aloca_vazio(void* p, long size) ########################################
# Recebe um endereço, coloca 1 em ocp e cria nodo ##############################
# vazio com o resto (se tiver) #################################################
aloca_vazio:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	movq %rdi, -8(%rsp)

	movq $1, -16(%rdi)
	movq -8(%rdi), %rcx # tamanho nodo encontrado
	subq %rsi, %rcx
	cmpq $16, %rcx # vê se sobra é maior que o necessário para header
	jle aloca_tudo	

	movq %rsi, -8(%rdi)
	addq %rsi, %rdi
	
	movq $0, (%rdi)
	subq $16, %rcx
	movq %rcx, 8(%rdi)
	
	aloca_tudo:
	movq -8(%rsp), %rax
	addq $16, %rsp
	popq %rbp
	ret
################################################################################



#	void* alocaMem(long s)	####################################################
#	recebe o número de bytes a ser alocado em s	################################
#	aloca o nodo e retorna o ponteiro para o início dos dados do nodo	########
allocBlk:
	pushq %rbp
	movq %rsp, %rbp

	pushq %rdi
	call firstFit
	popq %rdi
	cmpq $0, %rax
	je aloca_novo

	movq %rdi, %rsi
	movq %rax, %rdi
	call aloca_vazio
	jmp retorno
	

	aloca_novo:
	call aumenta_brk
	retorno:
	popq %rbp
	ret
################################################################################



#	void liberaMem(void* p)	####################################################
#	muda o valor de ocp do nodo para 0	########################################
freeBlk:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rbp # retorno: 1 se for desalocado, 0 se já tiver desalocado
	movq $0, -8(%rbp)

	movq %rdi, %rbx
	subq $16, %rbx
	movq (%rbx), %rcx # %rcx contém o valor do ocp do nodo

	cmpq $0, %rcx
	je fim_alocado
	movq $0, (%rbx)
	movq $1, -8(%rbp)

	fim_alocado:
	movq -8(%rbp), %rax
	addq $8, %rbp
	popq %rbp


	call mergeNodes
	call mergeNodes

	ret
################################################################################



# 	void mergeNodes() ##########################################################
mergeNodes:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp

	movq TopoInicialHeap, %rax
	movq %rax, -8(%rsp)
	
	while:
		movq -8(%rsp), %rdi # ponteiro nodo p1
		movq (%rdi), %rbx # ocp de p1
		movq 8(%rdi), %rcx # size de p1
	
		cmpq TopoHeap, %rdi
		je fim

		cmpq $0, %rbx
		jne iter
		
		movq %rdi, %rdx
		addq $16, %rdx 
		addq %rcx, %rdx # ponteiro nodo p2

		cmpq TopoHeap, %rdx
		je fim

		cmpq $0, (%rdx)
		jne iter

		movq 8(%rdx), %rax # size de p2
		addq %rax, %rcx 
		addq $16, %rcx # rcx contém o tamanho do novo bloco
		
		movq %rcx, 8(%rdi)
		
		iter:
			addq %rcx, %rdi
			addq $16, %rdi
			movq %rdi, -8(%rsp)
			jmp while

	fim:
	addq $8, %rsp
	pop %rbp
	ret
################################################################################



# void Print() #################################################################
printHeap:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	
	movq TopoInicialHeap, %rbx
	movq %rbx, -16(%rsp)
	movq TopoHeap, %rbx
	movq %rbx, -8(%rsp)

	movq -16(%rsp), %rbx 
	while_exterior:
		cmpq %rbx, -8(%rsp)
		je topo 	

		movq $1, %rax
		movq $1, %rdi # set up to write instruction

		movq $16, %rdx
		movq $STR_HT, %rsi # printando os 16 # de um nodo
		syscall

		cmpq $1, (%rbx)	# se tem 1 printa "+", se não printa "-"
		je alocado
		movq $STR_F, %rsi
		jmp fim_if
		alocado:
		movq $STR_A, %rsi
		fim_if:

		addq $8, %rbx
		movq (%rbx), %r9 # salvando o tamanho
	
		movq $0, %r10
		movq $1, %rdx
		while_size: # while(cnt < node->size)
		cmpq %r10, %r9
		je fim_while
			movq $1, %rax
			syscall
			addq $1, %r10
			jmp while_size
		fim_while:
		
		addq $8, %rbx
		addq %r9, %rbx	# proximo nodo
		jmp while_exterior
	
	topo:
	movq $1, %rax # valor syscall write
	movq $1, %rdi # arquivo apontado (stdin)
	movq $1, %rdx # tamanho string 
	push $'\n'	
	movq %rsp, %rsi # string
	syscall
	movq $1, %rax
	syscall
	popq %rsi


	addq $16, %rsp
	pop %rbp
	ret
################################################################################

