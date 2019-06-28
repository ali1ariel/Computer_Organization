######## TEXT E PC
la $t0, memoria #carrega o endereço de memória para o $t0
la $t1, data
sw $t0, 0($t1) #é carregado o valor inicial da memória no .text, onde irá as instruções
######## DATA
addi $t0, $t0, 2000 #metade do vetor de memória
la $t1, text
sw $t0, 0($t1) #é carregado o valor do vetor que representa data, onde irá os dados.
la $t1, pc #Carrega o vetor de registradores
sw $t0, 0($t1) #é carregado o valor inicial da memória no pc
######## STACK POINTER
la $t2, registradores
li $t3, 29 #carrega a posição 29 que se procura
sll $t3, $t3, 2 #move 2 casas a esquerda, localizando o endereço dentro do vetor
add $t1, $t2, $t3 #$t1 = Endereço Base do vetor + Endereço no vetor
addi $t0, $t0, 1996
sw $t0, 0($t1)
#######
