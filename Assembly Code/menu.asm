menu: 
	
	jal limpa_buffer
	
	li $v0, 54 #O valor que está em $v0 continua para ser usado em syscall
	la $a0, menu1 #Carrega o valor para $a0 ser utlizado no syscall
	la $a1, buffer
	li $a2, 20
	syscall
	
	li $v0, 4 #O valor que está em $v0 continua para ser usado em syscall
	la $a0, buffer #Carrega o valor para $a0 ser utlizado no syscall
	syscall
	
	
	######PAUSA DE 1 SEGUNDO
	li $v0, 32
	li $a0, 1000
	syscall
	
decodifica_menu:
	la $t0, buffer
	lb $t0, 0($t0)
	
	#ACHA O VALOR
	addiu $t0, $t0, -97
	####################### SWITCH DO MENU
	
	li $t1, 17
	bne $t0, $t1, exec
	j insts
	exec:
	li $t1, 4
	bne $t0, $t1, regs
	j executa
	regs:
	li $t1, 3
	bne $t0, $t1, memos
	j impressao_de_registradores
	
	memos:
	li $t1, 12
	bne $t0, $t1, nada_a_fazer
	j imprime_enderecos
	
	nada_a_fazer:
	la $a0, nada
	li $v0, 4
	syscall
	
	j menu
	
	#######################
	insts: #
	la $t0, buffer
	li $t1, 10 #indica new line
	
	#PROCURA  O FIM DA STRING DIGITADA
	procura_Fim:
		lb $t2, 0($t0) #carrega valor ascii
		li $t4, 0 
		beq $t2, $t1, achou_fim #fim da palavra
		addiu $t0, $t0, 1 #continua procurando
	j procura_Fim
	
	achou_fim:
	# A QUANTIDADE DE INSTRUÇÕES ESTÁ NA POTENCIA DE 10
	li $t5, 10 #indica a base da potencia, para transformar a string em valor
	sw $t5, -4($sp)
	sw $t0, -12($sp)
	
	jal potencias
	
	sw $v0, instrucoes_para_serem_executadas
	li $t0, 0
	sw $t0, contador_potencia
	
	j decodifica
	
	
	########################
	#COLOCA -1 PARA ENTENDER QUE DEVE SER EXECUTADO TUDO!
	executa:
	li $t0, -1
	sw $t0, instrucoes_para_serem_executadas
		
	j decodifica
	
	###############################ENDEREÇOS PARA IMPRIMIR
	imprime_enderecos:
	
	
	la $t0, buffer
	li $t1, 10 #indica new line
	
	novo_procura_espaco:
		lb $t2, 0($t0) #carrega valor ascii
		li $t4, 0 
		beq $t2, $t1, novo_achou_fim #fim da palavra
		addiu $t0, $t0, 1 #continua procurando
	j novo_procura_espaco
	novo_achou_fim:
	
	li $t5, 10 #indica a base da potencia, para transformar a string em valor
	sw $t5, -4($sp)
	sw $t0, -12($sp)
	
	jal potencias
	
	sw $v0, quantidade_de_enderecos
	li $t1, 0
	sw $t1, contador_potencia
	
	
	li $t5, 16 #indica a base da potencia, pois os endereços estão em hexadecimal
	li $t4, 0
	sw $t5, -4($sp)
	sw $t0, -12($sp)
	
	jal potencias
	
	sw $v0, endereco_para_imprimir
	li $t1, 0
	sw $t1, contador_potencia
	
	j impressao_de_enderecos
	j menu
	
	
	################################	
	potencias:
	lw $t5, -4($sp)
	lw $t0, -12($sp)
	inicia_calculo:
	
	addiu $t0, $t0, -1
	lw $t1, contador_potencia
	lb $t2, 0($t0)
	li $t3, 32
	beq $t3, $t2, fim_potencia
	
	addiu $t2, $t2, -48 #VALOR
	
	li $t3, 9
	slt $t3, $t2, $t3
	bnez $t3, not_hex
	addiu $t2, $t2, -39
	not_hex:
	sw $t0, -12($sp)
	sw $t2, -8($sp)
	sw $t4, -4($sp)
	
	potencia ($t5, $t1)
	
	lw $t4, -4($sp)
	lw $t2, -8($sp)
	lw $t0, -12($sp)
	
	mul $t2, $t2, $v0
	add $t4, $t4, $t2
	
	lw $t1, contador_potencia
	addi $t1, $t1, 1
	sw $t1, contador_potencia
	j inicia_calculo
	fim_potencia:
	move $v0, $t4
	jr $ra

	#######IMPRESSÃO DE ENDEREÇOS
	impressao_de_enderecos:
	lw $t0, endereco_para_imprimir
	lw $t1, quantidade_de_enderecos
	li $t2, 0
	
	loop_impressao:
	beq $t2, $t1, fim_loop_impressao
	
	la $a0, endereco_texto
	li $v0, 4
	syscall
	 
	move $a0, $t0
	li $v0, 34
	syscall
	la $a0, contem_texto
	li $v0, 4
	syscall
	 
	lw $a0, 0($t0)
	li $v0, 34
	syscall
	
	la $a0, fecha_texto
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4	
	addi $t2, $t2, 1
	j loop_impressao	
	fim_loop_impressao:
	
	j menu
	
	
	#######IMPRESSÃO DE REGISTRADORES
	impressao_de_registradores:
	la $t0, registradores
	li $t1, 31
	li $t2, 0
	
	loop_impressao_reg:
	beq $t2, $t1, fim_loop_impressao_reg
	
	la $a0, registrador_texto
	li $v0, 4
	syscall
	 
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, contem_texto
	li $v0, 4
	syscall
	 
	lw $a0, 0($t0)
	li $v0, 34
	syscall
	
	la $a0, fecha_texto
	li $v0, 4
	syscall
	
	addi $t0, $t0, 4	
	addi $t2, $t2, 1
	j loop_impressao_reg	
	fim_loop_impressao_reg:
	
	j menu
	
	
limpa_buffer:
	lw $t1, zero
	sw $t1, buffer
	jr $ra