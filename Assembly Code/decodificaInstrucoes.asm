decodifica:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	srl $t0, $t0, 29 #desloca 29 casas a direita para usar os 3 primeiros digitos para usar o switch.

	##############

	beq $t0, $0, op000
	li $t1, 1
	beq $t0, $t1, op001
	li $t1, 4
	beq $t0, $t1, op100
	li $t1, 5
	beq $t0, $t1, op101




op000:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 3
	srl $t0,$t0, 29
	
	##### seleciona a subparte
	beq $t0, $0, funcRFormat
	li $t1, 2
	beq $t0, $t1, funcJ
	li $t1, 3
	beq $t0, $t1, funcJal
	li $t1, 5
	beq $t0, $t1, funcBne
	
	
	funcJ:

	funcJal:

	funcBne:

op001:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 3
	srl $t0, $t0, 29
	
	##### seleciona a subparte
	beq $t0, $0, funcAddi
	li $t1, 1
	beq $t0, $t1, funcAddi
	li $t1, 5
	beq $t0, $t1, funcOri
	li $t1, 7
	beq $t0, $t1, funcLui

	funcAddi:
		lw $t0, pc #carrega em $t0 o endereço de pc ###################################
		lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
		sll $t0, $t0, 6 # |---6--|**5**|**5**|*********16******|
		srl $s0, $t0, 27 # |**5**|------------------27----------------| #### REGISTRADOR DE OPERAÇÃO
		sll $t0, $t0, 5 # |--5--|**5**|*********16******|
		srl $s1, $t0, 27 # |**5**|----------16-------|  ##### REGISTRADOR DE SALVAMENTO
		sll $t0, $t0, 5 # |--5--|*********16******|
		srl $s2, $t0, 16 # |*********16******|   #####NUMERO IMEDIATO
	
		move $a0, $s0 #prepara para função
		jal carregaRegistrador
		move $s0, $v0 #pos função
		
		srl $t0, $s0, 15
		li $t1, 1
		
		bne $t1, $t0, notNegative
		lui $t1, 0xffff
		or $s2, $s2, $t1
		notNegative:
		addu $t0, $s0, $s2 #OPERAÇÃO REALIZADA
		
		move $a0, $t0
		move $a1, $s1
		jal salvaNoRegistrador
		j proxInstrucao
	
	
	
	funcAddiu:	

	funcOri:

	funcLui:

op100:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 3
	srl $t0, $t0, 29

	funcLw:

op101:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 3
	srl $t0, $t0, 29
 
	funcSw:#Da pra usar a função salvaNoRegistrador em funcOrg.asm


funcRFormat:
	lw $t0, pc #carrega em $t0 o endereço de pc
	lw $t0, 0($t0) #carrega o endereço que está dentro da variavel pc
	sll $t0, $t0, 26
	srl $t0, $t0, 26
	
	
	
	##### seleciona a função
	li $t1, 8
	beq $t0, $0, funcJr
	li $t1, 24
	beq $t0, $t1, funcMult
	li $t1, 32
	beq $t0, $t1, funcAdd
	li $t1, 33
	beq $t0, $t1, funcAddu
	
	funcJr:

	funcMult:

	funcAdd:

	funcAddu:

