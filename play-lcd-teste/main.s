.include "gpio.s"
.include "sleep.s"
.include "lcd.s"

.global _start
/*
======================================================
	syscall exit
======================================================
*/
.macro _end
    MOV R0, #0
    MOV R7, #1
    SVC 0
.endm

_start:
    MemoryMap
	GPIOPinIn b1 @ botão alongado
	GPIOPinIn b2 @ botão do meio
	GPIOPinIn b3 @ botão mais a direita antes do espaço
	setLCDPinsOut
	init
    twoLine @ liga a segunda linha do display

	CarregaPalavraR12 palavra

	MOV R5, #0 @R5 = 0 ("Temperatura Atual")
	@ precisa fazer verificação. pois se r5 = 0, não pode decrementar.
	@ e se r5 = 3, nao pode incrementar.

	espera:
		@moveCursorSegundaLinha
		MOV R10, #0

		@ só vai mudar de tela se um dos dois botões for acionado
		@ se botão b1 for acionado, há desvio para decrementa
        GPIOPinState b1
        CMP R1, #0 @ botão apertado
        BEQ decrementa 

		@ se botão b3 for acionado, há desvio para incrementa
		GPIOPinState b3
		CMP R1, #0 @ botão apertado
		BEQ incrementa

		@ se R5 == 0: temperatura atual
		@ se R5 == 1: umidade atual
		@ se R5 == 2: temperatura contínua
		@ se R5 == 3: umidade contínua

		CMP R5, #0 @ compara R5 com 0
		BEQ carrega_temp_atual @ se R5 for igual a 0, desvia para carrega_temp_atual
		CMP R5, #1 
		BEQ carrega_umi_atual
		CMP R5, #2
		BEQ carrega_temp_cont
		CMP R5, #3
		BEQ carrega_umi_cont

		exibicao_lcd

        b espera

	incrementa:
		clearDisplay
		ADD R5, R5, #1
		B espera

	decrementa:
		clearDisplay
		SUB R5, R5, #1
		B espera

	exibicao_lcd:
        @ percorre a palavra letra por letra
        LDR R11, [R12, R10]
        WriteCharLCD R11 @ escreve a letra no local certo e aumenta o ponteiro +1
        ADD R10, R10, #1 @ incrementa o r10
        @ se ja atingiu o tamanho da palavra, vai para espera
		@ se não, continua exibindo
        CMP R10, #20
        BEQ espera 	@ na espera o texto não é limpado, por isso pode voltar
        B exibicao_lcd

	carrega_temp_atual:
		LDR R12, =temperatura_atual

	carrega_umi_atual:
		LDR R12, =umidade_atual

	carrega_temp_cont:
		LDR R12, =temperatura_cont

	carrega_umi_cont:
		LDR R12, =umidade_cont

	EXIT:
		_end

.data
    temperatura_atual: .ascii "Temperatura Atual   \n" 
	umidade_atual: .ascii "Umidade Atual       \n"
	temperatura_cont: .ascii "Temperatura Contínua\n" 
	umidade_cont: .ascii "Umidade Contínua    \n"

    fileName: .asciz "/dev/mem" @ caminho do arquivo que representa a memoria RAM
    gpioaddr: .word 0x1C20 @ endereco base GPIO / 4096
    pagelen: .word 0x1000 @ tamanho da pagina
    
	time1s: .word 1  @ 1s

	time1ms: .word 1000000 @ 1ms

	time850ms: .word 850000000 @850ms

    time950ms: .word 950000000 @850ms

	time170ms: .word 170000000 @ 170ms

	timeZero: .word 0 @ zero
   
	time1d55ms: .word 1500000 @ 1.5ms

	time5ms: .word 5000000 @ 5 ms

	time150us: .word 150000 @ 150us
	
	/*
	======================================================
       Todas as labels com o nome de um pino da
		Orange PI PC Plus contem 4 ~words~

		Word 1: offset do registrador de funcao do pino
		Word 2: offset do pino no registrador de funcao (LSB)
		Word 3: offset do pino no registrador de dados
		Word 3: offset do registrador de dados do pino
	======================================================
	*/

    @ LED Vermelho
    PA9:
		.word 0x4
		.word 0x4
		.word 0x9
		.word 0x10
	

    @ LED Azul
    PA8:
		.word 0x4
		.word 0x0
		.word 0x8
		.word 0x10
		
	@PG7 - DB7
	d7:
		.word 0xD8
		.word 0x1C
		.word 0x7
		.word 0xE8

	@PG6 - DB6
	d6:
		.word 0xD8
		.word 0x18
		.word 0x6
		.word 0xE8

	@PG9 - DB5
	d5:
		.word 0xDC
		.word 0x4
		.word 0x9
		.word 0xE8

	@PG8 - DB4
	d4:
		.word 0xDC
		.word 0x0
		.word 0x8
		.word 0xE8
	
	@PA18 - Enable
	E:
		.word 0x8
		.word 0x8
		.word 0x12
    	.word 0x10

	@PA2 - RS
	RS:
		.word 0x0
		.word 0x8
		.word 0x2
    	.word 0x10

	@RW
	@GROUND

	@ botão alongado
	b1:
		.word 0x0
		.word 0x1C
		.word 0x7
		.word 0x10

	@ botão do meio
	b2:
		.word 0x4
		.word 0x8
		.word 0xA
		.word 0x10

	@ botão da esquerda
	b3:
		.word 0x8
		.word 0x10
		.word 0x14
		.word 0x10