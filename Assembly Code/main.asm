.include "preparaRegistradores.asm"
.include "filereader.asm"
.include "macro.asm"
.include "menu.asm"
.include "decodificaInstrucoes.asm"
.include "funcOrg.asm"

.data
.align 2
	
memoria: .space 4000 #tamanho da memoria para 1000 instruções
registradores: .space 128
pc: .space 4
text: .space 4
data: .space 4

contador_de_instrucoes: .word 0
instrucoes_para_serem_executadas: .space 4
endereco_para_imprimir: .space 4
quantidade_de_enderecos: .space 4

buffer: .space 20
contador_potencia: .space 4


cabecalho: .asciiz "data.bin"      # filename for input
instrucoes: .asciiz "text.bin"      # filename for input

menu1: .asciiz "O que se pode fazer, digite corretamente pois não há verificacao de erros (sorry) \n executar tudo ou o que restou: digite 'e'\n executar um número de instruções -> 'r <numero_de_instrucoes>'\nexemplo: r 15 (em decimal)\n imprimir registradores -> 'd'\n imprimir memória -> 'm <endereco_inicial> <posicoes_apos>'\nexemplo: m 100107d0 15 (endereco hex, insts dec)\n\npara pausar, pause apos apertar okay, e volte 1 instrucao para ver o terminal"
mensagem_contador: .asciiz "\n'Contador terminado, voltando ao menu!'\n"
registrador_texto: .asciiz "O registrador "
endereco_texto: .asciiz "O endereco "
contem_texto: .asciiz " contem '"
fecha_texto: .asciiz "'.\n"
nada: .asciiz "Opção incorreta, nada a se fazer\n"
zero: .word 0
