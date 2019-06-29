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
	lw $t0, pc #######################carrega em $t0 o endereço de pc
	addi $t1, $t0, 4
	sw $t1, pc
	lw $t0, count
	addi $t0, $t0, 1
	sw $t0, count
	j decodifica
	
	
