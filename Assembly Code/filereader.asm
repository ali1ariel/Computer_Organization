.text
carrega_memoria:
la $s0, memoria #S0 é sempre a memória
li $s1, 4000 #S1 é a memoria disponivel


j ler_

abre_arquivo:
  li   $v0, 13       # syscall
  
  li   $a1, 0        # modo leitura
  li   $a2, 0
  syscall            # file descriptor em $v
  move $t0, $v0      # salva o file descriptor 


ler_arquivo:
  li   $v0, 14       # syscall
  move $a0, $t0      # file descriptor 
  lw $a1, -4($sp)
  li $a2, 1000     # tamanho do buffer
  syscall            # ler do arquivo

fecha_arquivo:
  li   $v0, 16       # syscal
  move $a0, $t0     # file descriptor
  syscall            # fecha
  jr $ra
  


ler_:
   la   $a0, cabecalho  # nome do arquivo
   lw $t0, data
   sw $t0, -4($sp)
   jal abre_arquivo

   la   $a0, instrucoes  # nome do arquivo
   lw $t0, text
   sw $t0, -4($sp)
   jal abre_arquivo
   