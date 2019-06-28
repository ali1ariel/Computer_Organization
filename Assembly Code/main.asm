.include "preparaRegistradores.asm"
.include "filereader.asm"
.include "decodificaInstrucoes.asm"
.include "funcOrg.asm"

.data
.align 2	
memoria: .space 4000 #tamanho da memoria para 1000 instruções
.align 2
registradores: .space 128
.align 2
pc: .space 4
.align 2
text: .space 4
.align 2
data: .space 4
count: .word 1
cabecalho: .asciiz "data.bin"      # filename for input
instrucoes: .asciiz "text.bin"      # filename for input
spacio: .asciiz "\n" #valor em ascii do caracter espaço para auxilio na impressão
