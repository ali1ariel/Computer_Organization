.macro potencia (%numeroBase, %numeroPotencia)
	li $t6, 1
	loop:
		beqz %numeroPotencia, fim_loop
		mul $t6, $t6, %numeroBase
		addiu %numeroPotencia,  %numeroPotencia, -1
	j loop
	fim_loop:
	move $v0, $t6
	j end
	potencia_zero:
	end:
.end_macro
