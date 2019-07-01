decodifica:

	#CONTADOR DE INSTRUÇÕES, SE FOR -1 O PROGRAMA TODO SERÁ EXECUTADO
	li $t0, -1
	lw $t1, instrucoes_para_serem_executadas
	beq $t0, $t1, continua
	lw $t0, contador_de_instrucoes
	beq $t0, $t1, contador_terminado
	
	continua:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0, $t0, 29 #desloca 29 casas a direita para usar os 3 primeiros digitos para usar o switch.

	beq $t0, $0, funcTypeRJ # se os 3 primeiros bits forem 0, vai para as funções de formato R e Jump
	j funcTypeI #Se não, vai para instruções I
	
	
	#QUANDO O CONTADOR ACABA, IMPRIME UMA INFORMAÇÃO
	
contador_terminado:
	li $t0, 0
	sw $t0, contador_de_instrucoes
	
	li $v0, 4
	la $a0, mensagem_contador
	syscall
	
	j menu
	
funcTypeRJ:


	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0,$t0, 26 #Move os 6 primeiros bits para verificação da função destino
	

	##### seleciona a subparte
	beqz $t0, funcTypeR #Vai para as funções de tipo R
	li $t1, 2
	beq $t0, $t1, funcJ #000010 -> Função Jump
	li $t1, 3
	beq $t0, $t1, funcJal #000011 -> Função Jump And Link
	li $t1, 5
	beq $t0, $t1, funcBne #000101 -> Função Branch if not equal
	
	
	funcJ: #move o registrador pc para outro local dentro de .text

	lw $t0, pc #JUMP: inicio
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6 #retira os bits de endereçamento de função
	
	
	##################COM BASE NA PRÓXIMA INSTRUÇÃO##################################
	#IMPORTANTE: como só se trabalha com endereços multiplos de 4, estrategicamente #
	#a função jump não apresenta seus ultimos 2 bits, que consequentemente são zeros#
	#logo, para achar o endereço completo, é necessário acrescentar, deslocando     #
	#apenas 4 bits a direita ao invês dos 6 que foram deslocados pra esquerda.      #
	#################################################################################
	srl $t0, $t0, 4
	
	##################COM BASE NO PRÓXIMO BLOCO######################################
	#IMPORTANTE: como o jump trabalha locomovendo a variável PC dentro da area      #
	# .text do MIPS, precisamos calcular onde seria esse campo no nosso simulador,  #
	#logo, se desconta o valor inicial dessa área  (0x400000) e se acrescenta o     #
	#valor inicial da area text do nosso simulador.                                 #
	#################################################################################
	addiu $t0, $t0, -0x400000 #O desconto
	lw $t1, text #carrega o endereço da area text simulada
	add $t0, $t1, $t0 #faz a soma para encontrar a nova area
	
	# COMO ESSA FUNÇÃO MEXE DIRETAMENTE COM A VARIAVEL PC, A FUNÇÃO 
	# PROXIMA INSTRUÇÃO, RESPONSAVEL POR MOVER PC NÃO É CHAMADA
	# INDO DIRETAMENTE PRA EXECUÇÃO DA INSTRUÇÃO APONTADA POR JUMP
	sw $t0, pc # Salva esse novo endereço em pc
	jal addCount #add no contador de instruções
	j decodifica #pula pra próxima instrução
	
	
	funcJal: #move o registrador pc, salvando o endereço atual em $ra
	lw $t0, pc #JAL: inicio
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6
	srl $t0, $t0, 4 #LER LINHA 33 DESTE ARQUIVO.
	
	
	addiu $t0, $t0, -0x400000 #LER LINHA 41 DESTE ARQUIVO
	lw $t1, text
	add $t0, $t1, $t0 
	
	lw $t1, pc #$t1 <- o endereço da instrução sendo executada, que está em pc
	
	sw $t0, pc # o endereço da proxima instrução a ser executada -> $t0
	
	
	######################################################################################################
	#                          ________________                                                          #
	#                         |END. ATUAL      |-----_                                                   #
	#                         |________________|      \                                                  #
	#MAS SALVA ESSE EM $RA--->|P/ SALV. EM $RA |       \                                                 #
	#                         |________________|        \ PULA PC PRA CÁ                                 #
	#                         |       ...      |       _/                                                #
	#                         |________________|     _/                                                  #
	#                         |PROX. INST.     |<---/                                                    #
	#                         |________________|                                                         #
	#                                                                                                    #
	######################################################################################################
	
	addi $a0, $t1, 4 #CARREGA PARA SALVAR EM $ra DO SIMULADOR, 
	li $a1, 31 #numero do registrador ra
	jal salvaNoRegistrador
	
	jal addCount
	j decodifica

	funcBne: #pula para tal instrução se os valores comparados forem diferentes
	
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6 # |---6--|**5**|**5**|*********16******|
	srl $s0, $t0, 27 # |**5**|------------------27----------------| #### REGISTRADOR DE OPERAÇÃO
	sll $t0, $t0, 5 # |--5--|**5**|*********16******|
	srl $s1, $t0, 27 # |**5**|----------16-------|  ##### REGISTRADOR DE SALVAMENTO
	
	
	
	move $a0, $s0 #BNE: inicio #move o endereço do registrador rs
	jal carregaRegistrador
	move $s0, $v0 #move o conteudo do registrador rs
	
	
	move $a0, $s1 #prepara para carregar 0 registrador rt
	jal carregaRegistrador
	move $s1, $v0 #pos função
	
	bne $s0, $s1, bneConfirmada #se os registradores são iguais vai para a proxima instrução, se não, tem que pular
	
	j proxInstrucao
	
	##################
	# BNE nos dá o número de instruções a se pular ou voltar
	# multiplica por 4 utilizando deslocamento, para saber o numero de endereços a se pular
	##################
	bneConfirmada:
	lw $t2, pc
	lw $t1, 0($t2)
	sll $t1, $t1, 16
	srl $t1, $t1, 14
	
	addu $t0, $t2, $t1 # Variavel PC + Endereço a pular
	
	sw $t0, pc
	
	j proxInstrucao
	
	
	
	####
	
funcTypeI:


	lw $t0, pc #carrega em $t0 o endereço de pc ###################################
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6 # |---6--|**5**|**5**|*********16******|
	srl $s0, $t0, 27 # |**5**|------------------27----------------| #### REGISTRADOR DE OPERAÇÃO
	sll $t0, $t0, 5 # |--5--|**5**|*********16******|
	srl $s1, $t0, 27 # |**5**|----------16-------|  ##### REGISTRADOR DE SALVAMENTO
	sll $t0, $t0, 5 # |--5--|*********16******|
	srl $s2, $t0, 16 # |*********16******|   #####NUMERO IMEDIATO

				
	#########SWITCH DE FUNCS ####################
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0, $t0, 26
	
	
	# * addi e addiu chamam addi de qualquer modo, detectando valor negativo, é encaminhado para addiu
	#
	#
	
	
	
	
	
	funcSwSwitch:
	li $t1, 43
	bne $t0, $t1, funcAddiSwitch
	jal funcSw
	j postFunc
	
	funcAddiSwitch:
	
	sw $t0, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	lw $t0, -4($sp)
	
	li $t1, 8
	bne $t0, $t1, funcAddiuSwitch #Compara o endereçamento de função da instrução com o endereço para Addiu
	jal funcAddi 
	j postFunc
	
	funcAddiuSwitch:
	li $t1, 9
	bne $t0, $t1, funcOriSwitch
	jal funcAddi
	j postFunc
	
	funcOriSwitch:
	li $t1, 13
	bne $t0, $t1, funcLuiSwitch
	jal funcOri
	j postFunc
	
	funcLuiSwitch:
	li $t1, 15
	bne $t0, $t1,funcMulSwitch
	jal funcLui
	j postFunc
	
	funcMulSwitch:
	li $t1, 28
	bne $t0, $t1,funcLwSwitch
	jal funcMul
	j postFunc
	
	funcLwSwitch:
	li $t1, 35
	bne $t0, $t1,postFunc
	jal funcLw	 
	
	
	######## APOS EXECUTAR A FUNÇÃO, É EXECUTADO O POST, QUE PREPARA OS REGISTRADORES PARA SALVAR O VALOR CONSEGUIDO PELA FUNÇÃO
	postFunc:	
	move $a0, $s3	
	move $a1, $s1
	jal salvaNoRegistrador
	j proxInstrucao

	######################### FUNÇÕES
	funcAddi:
	srl $t0, $s2, 15          # {
	li $t1, 1                 # { AVALIA O PRIMEIRO BIT DA SEQUENCIA PARA VER SE É NEGATIVO, SE SIM, ENCAMINHA PARA ADDIU
	beq $t1, $t0, funcAddiu	  # {
	
	add $s3, $s0, $s2  #FAZ A SOMA
	move $t0, $0
	jr $ra
		
	funcAddiu:
	
	lui $t1, 0xffff #CARREGA O VALOR NEGATIVO NOS 16 BITS SUPERIORES
	or $s2, $s2, $t1 #Cria o valor total do registrador
	addu $s3, $s0, $s2
	move $t0, $0 
	jr $ra
		
	funcOri: #Faz OR entre um registrador e um valor imediato
	or $s3, $s0, $s2 
	move $t0, $0 
	jr $ra
	
	funcLui: #carrega o valor imediato nos 4 primeiros bytes da instrução
	sll $s3, $s2, 16
	move $t0, $0
	jr $ra 
	
	funcMul: #carrega o valor imediato nos 4 primeiros bytes da instrução
	
	
	srl $s2, $s2, 11 #adquire os 5 bits do registrador
	
	sw $ra, -4($sp)
	move $a0, $s1 #prepara para função
	jal carregaRegistrador
	move $s1, $v0 #pos função
	lw $ra, -4($sp)
	
	mul  $s3, $s0, $s1 #OPERAÇÃO
	
	move $s1, $s2	
	move $t0, $0
	jr $ra 
	
	funcLw: #função LW
	
	addu $t0, $s0, $s2 
	lw $s3, 0($t0)
	move $t0, $0 
	jr $ra
	
	funcSw:#Da pra usar a função salvaNoRegistrador em funcOrg.asm
	
	
	move $a0, $s1 #prepara para função
	jal carregaRegistrador
	move $s1, $v0 #pos função
	
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
			
	addu $s0, $s0, $s2
	
	sw $s1, 0($s0)
	
	j proxInstrucao 


funcTypeR:

	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 26
	srl $s3, $t0, 26
	
	lw $t0, pc #carrega em $t0 o endereço de pc ###################################
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6 # |---6--|**5**|**5**|**5**|****11******|
	srl $s0, $t0, 27 # |**5**|------------------27----------------| #### REGISTRADOR DE OPERAÇÃO
	sll $t0, $t0, 5 # |--5--|**5**|**5**|****11******|
	srl $s1, $t0, 27 # |**5**|----------16-------|  ##### REGISTRADOR DE SALVAMENTO
	sll $t0, $t0, 5 # |--5--|**5**|****11******|
	srl $s2, $t0, 27 # |**5**|----11-------|  #####REGISTRADOR DE OPERAÇÃO 2

	
	
	
	
	##### seleciona a função
	li $t1, 8
	beq $s3, $t1, funcJr
	li $t1, 12
	beq $s3, $t1, funcSyscall
	li $t1, 32
	beq $s3, $t1, funcAdd
	li $t1, 33
	beq $s3, $t1, funcAddu
	
	funcJr:
		
	sw $ra, -4($sp)
	move $a0, $s0 #manda numero do registrador pra função
	jal carregaRegistrador
	move $s0, $v0 #captura endereço do registrador
	lw $ra, -4($sp)	
	
	sw $s0, pc #Joga pra variavel pc o novo endereço pra ir
	
	jal addCount # Chama a função contadora
	j decodifica
	
	
	funcAdd:

	sw $ra, -4($sp)
	
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	
	move $a0, $s1 #prepara para função
	jal carregaRegistrador
	move $s1, $v0 #pos função
	
	lw $ra, -4($sp)	
	
	
	add $a0, $s0, $s1
	move $a1, $s2
	jal salvaNoRegistrador
	j proxInstrucao
	
	
	funcAddu:
	
	
	sw $ra, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	move $a0, $s1 #prepara para função
	jal carregaRegistrador
	move $s1, $v0 #pos função
	lw $ra, -4($sp)	
	
	
	addu $a0, $s0, $s1
	move $a1, $s2
	jal salvaNoRegistrador
	j proxInstrucao
	
	
	funcSyscall:
	
	li $a0, 4               # {
	jal carregaRegistrador  # { carrega valor de $a0
	move $t0, $v0           # {
	sw $t0, -4($sp) #salva esse valor para usar depois
	li $a0, 2 
	jal carregaRegistrador #O valor que está em $v0 continua para ser usado em syscall
	lw $t0, -4($sp)
	move $a0, $t0 #Carrega o valor para $a0 ser utlizado no syscall
		
	syscall

	j proxInstrucao

