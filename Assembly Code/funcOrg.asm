carregaRegistrador:
	move $t0, $a0 
	sll $t0, $t0, 2 #mult p/ 4
	la $t1, registradores
	add $t0, $t0, $t1 #$t0 = EB + posição do vetor
	lw $t0, 0($t0) #Conteúdo do registrador
	move $v0, $t0
	jr $ra
	
salvaNoRegistrador:
	move $t0, $a0
	move $t1, $a1
	sll $t1, $t1, 2
	la $t2, registradores
	add $t1, $t1, $t2
	sw $t0, 0($t1)
	jr $ra
	
proxInstrucao:
	lw $t0, pc
	addi $t1, $t0, 4 # O endereço atual de pc + 4
	sw $t1, pc
	jal addCount # Chama a função contadora
	j decodifica
	
addCount:
	lw $t0, contador_de_instrucoes
	addi $t0, $t0, 1 #adiciona 1 ao contador
	sw $t0, contador_de_instrucoes
	jr $ra
