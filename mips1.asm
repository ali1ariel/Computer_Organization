main:
	addi $s2, $0, 4
	addi $s1, $0, 4
	bne $s1, $s2, calt
	addi $s1, $s1, -17
	add $s3, $0, $0
	div $s1, $s2
	mflo $s4
	mtlo $s2
	add $s1, $s2, $s3
	j teste



jumped:
	j calt
	
	
	
teste:
	j jumped

calt:
	jal jumped
	
	
.data
sub1add:  .word teste 
