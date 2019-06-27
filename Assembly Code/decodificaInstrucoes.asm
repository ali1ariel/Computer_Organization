decodifica:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0, $t0, 29 #desloca 29 casas a direita para usar os 3 primeiros digitos para usar o switch.

	##############
	beq $t0, $0, funcTypeRJ
	j funcTypeI
	
funcTypeRJ:

	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 6
	srl $s0,$t0, 4
	
	##### seleciona a subparte
	beq $t0, $0, funcTypeR
	li $t1, 2
	beq $t0, $t1, funcJ
	li $t1, 3
	beq $t0, $t1, funcJal
	li $t1, 5
	beq $t0, $t1, funcBne	
	
	funcJ: #move o registrador pc para outro local dentro de .text
	
	###CONVERSÃO DE ENDEREÇO
	

	funcJal: #move o registrador pc, salvando o endereço atual em $ra

	funcBne: #pula para tal instrução se os valores comparados forem diferentes
	
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

				
		###### FUNCSSS
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0, $t0, 26
	
	
	funcSwSwitch:
	li $t1, 43
	bne $t0, $t1, funcAddiSwitch
	jal funcSw
	
	funcAddiSwitch:
	
	sw $t0, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	lw $t0, -4($sp)
	
	li $t1, 8
	bne $s0, $s1, funcAddiuSwitch
	jal funcAddi 
	
	funcAddiuSwitch:
	li $t1, 9
	bne $t0, $t1, funcOriSwitch
	jal funcAddi
	
	funcOriSwitch:
	li $t1, 13
	bne $t0, $t1, funcLuiSwitch
	jal funcOri
	
	funcLuiSwitch:
	li $t1, 15
	bne $t0, $t1,funcMulSwitch
	jal funcLui
	
	funcMulSwitch:
	li $t1, 28
	bne $t0, $t1,funcLwSwitch
	jal funcMul
	
	funcLwSwitch:
	li $t1, 35
	bne $t0, $t1,postFunc
	jal funcLw	 
	
	postFunc:
			
	move $a0, $s3	
	move $a1, $s1
	jal salvaNoRegistrador
	j proxInstrucao


	funcAddi:
	srl $t0, $s0, 15
	li $t1, 1
	beq $t1, $t0, funcAddiu
	add $s3, $s0, $s2 
	move $t0, $0
	jr $ra
		
	funcAddiu:	#RESOLVER PROBLEMA ENTRE ADD E ADDU
	
	lui $t1, 0xffff###########################################################
	or $s2, $s2, $t1
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
	
	srl $s2, $s2, 11
	
	sw $ra, -4($sp)
	move $a0, $s2 #prepara para função
	jal carregaRegistrador
	move $s2, $v0 #pos função
	lw $ra, -4($sp)
	
	mul $s3, $s0, $s2
		
	move $t0, $0
	jr $ra 
	
	funcLw: ####
	add $t0, $s0, $s2
	la $s3, 0($t0)
	move $t0, $0 
	jr $ra
	
	funcSw:#Da pra usar a função salvaNoRegistrador em funcOrg.asm
	
	sw $ra, -4($sp)
	
	move $a0, $s1 #prepara para função
	jal carregaRegistrador
	move $s1, $v0 #pos função
	
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	
	lw $ra, -4($sp)
			
	addu $s0, $s0, $s2
	
	sw $s1, 0($s0)
	
	j proxInstrucao


funcTypeR:

	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 27
	srl $t0, $t0, 27
	
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
	beq $t0, $0, funcJr
	li $t1, 12
	beq $t0, $0, funcSyscall
	li $t1, 32
	beq $t0, $t1, funcAdd
	li $t1, 33
	beq $t0, $t1, funcAddu
	
	funcJr:
	
	sw $ra, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	lw $ra, -4($sp)	
	
	sw $s0, pc
	
	j proxInstrucao
	
	
	funcAdd:

	sw $ra, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	move $a0, $s2 #prepara para função
	jal carregaRegistrador
	move $s2, $v0 #pos função
	lw $ra, -4($sp)	
	
	
	add $a0, $s0, $s2
	move $a1, $s1
	jal salvaNoRegistrador
	j proxInstrucao
	
	
	funcAddu:
	
	
	sw $ra, -4($sp)
	move $a0, $s0 #prepara para função
	jal carregaRegistrador
	move $s0, $v0 #pos função
	move $a0, $s2 #prepara para função
	jal carregaRegistrador
	move $s2, $v0 #pos função
	lw $ra, -4($sp)	
	
	
	addu $a0, $s0, $s2
	move $a1, $s1
	jal salvaNoRegistrador
	j proxInstrucao
	
	
	funcSyscall:
	
	li $a0, 4
	jal carregaRegistrador
	move $t0, $v0 #pos função
	li $a0, 2 
	jal carregaRegistrador

	move $a0, $t0
	
	syscall

	j proxInstrucao

