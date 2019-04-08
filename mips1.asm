main:
	addi $s2, $t1, 37
	addi $s1, $0, 4
	slti $t1, $t2, 10
	andi $t1, $t2, 10
	ori $t1, $t2, 10
	xori $t1, $t2, 10
	lui $t1, 10

	lw $t1, sub1add
	addiu $s1, $s1, -17
	add $s3, $0, $0
	div $s1, $s2
	mflo $s4
	mtlo $s2
	add $s1, $s2, $s3
	addi $t1, $t1, 5
	bgtz $t1, jumped
	blez $t1, teste



jumped:
	jal calt
	
	
	
teste:
	jal jumped

calt:
	jal jumped
	
	
.data
sub1add:  .word teste 
