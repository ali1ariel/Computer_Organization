.text
carrega_memoria:
la $s0, memoria #S0 é sempre a memória
li $s1, 4000 #S1 é a memoria disponivel
li $s2, 0 #S2 é a memória consumida

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
  
   la   $t1, memoria   # endereço do buffer para leitura
   add $a1, $t1, $s2
  
  
  move $a2, $s1     # tamanho do buffer
  syscall            # ler do arquivo
  add $s2, $s2, $v0   #A quantidade de caracteres lidos
  sub $s1, $s1, $v0   #A memória restante

fecha_arquivo:
  li   $v0, 16       # syscal
  move $a0, $t0     # file descriptor
  syscall            # fecha
  jr $ra
  


ler_:
   la   $a0, instrucoes  # nome do arquivo
   jal abre_arquivo
   
   la   $a0, cabecalho  # nome do arquivo
   jal abre_arquivo
