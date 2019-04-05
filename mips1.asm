main:
	addi $s2, $0, 4
	addi $s1, $0, 3
	addi $s2, $s2, 3
	addi $s1, $s1, -17
	add $s3, $0, $0
	div $s1, $s2
	mflo $s4
	mtlo $s2
	add $s1, $s2, $s3
	j jumped


jumped:
	lw $t1, sub1add
	jalr $s1, $t1
	syscall
	
	
	
teste:
	jr $s1	

calt:
	jal jumped
	
	
.data
sub1add:  .word teste 