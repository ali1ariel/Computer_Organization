main:
	addi $s2, $t1, 37
	addi $s1, $0, 4
	bne $s1, $s2, calt
	beq $s1, $s2, jumped
	beq $s1, $s2, teste
	lw $t1, sub1add
	addi $s1, $s1, -17
	add $s3, $0, $0
	div $s1, $s2
	mflo $s4
	mtlo $s2
	add $s1, $s2, $s3
	j teste



jumped:
	jal calt
	
	
	
teste:
	jal jumped

calt:
	jal jumped
	
	
.data
sub1add:  .word teste 
