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
    MapeamentoMemoria
	GPIOPinEntrada b1 @ botão alongado
	GPIOPinEntrada b2 @ botão do meio
	GPIOPinEntrada b3 @ botão mais a direita antes do espaço
	setLCDPinsSaida
	inicializacao
    habilitarSegundaLinha @ liga a segunda linha do display

	MOV R13, #0 

	espera:
	
		

		MOV R10, #0

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa 

		GPIOPinEstado b3
		CMP R1, #0
		BEQ incrementa

        @ se R13 == 0: situação sensor
		@ se R13 == 1: temperatura atual
		@ se R13 == 2: umidade atual
		@ se R13 == 3: temperatura contínua
		@ se R13 == 4: umidade contínua

        /*CMP R13, #0 
		BEQ carrega_situacao 

		CMP R13, #1 
		BEQ carrega_temp_atual 
		
		CMP R13, #2 
		BEQ carrega_umi_atual
		
		CMP R13, #3
		BEQ carrega_temp_cont
		
		CMP R13, #4
		BEQ carrega_umi_cont*/

		limparDisplay
		EscreverLCD R13

		b espera
		
	incrementa:
		nanoSleep time5ms, timeZero
		CMP R13, #4 @ verificar se R13 não é 4
        BEQ espera @ se for 4, não incrementa
        ADD R13, R13, #1
        B espera

	decrementa:
		nanoSleep time5ms, timeZero
		CMP R13, #0 @ verificar se R13 não é 0
        BEQ espera @ se for 0, não decrementa
        SUB R13, R13, #1
        B espera
	
	exibicao_lcd:
        @ percorre a palavra letra por letra
        LDR R11, [R12, R10]
        EscreverCharLCD R11 @ escreve a letra no local certo e aumenta o ponteiro +1
        ADD R10, R10, #1 @ incrementa o r10
        @ se ja atingiu o tamanho da palavra, vai para espera
		@ se não, continua exibindo
        CMP R10, #14
        BEQ espera 	@ na espera o texto não é limpado, por isso pode voltar
        B exibicao_lcd

    carrega_situacao:
		LDR R12, =situacao
		B exibicao_lcd

	carrega_temp_atual:	
		LDR R12, =temperatura_atual
		B exibicao_lcd

	carrega_umi_atual:
		LDR R12, =umidade_atual
		B exibicao_lcd

	carrega_temp_cont:
		LDR R12, =temperatura_cont
		B exibicao_lcd

	carrega_umi_cont:
		LDR R12, =umidade_cont
		B exibicao_lcd

	EXIT:
		_end

.data
    situacao: .ascii "Situacao Sens."
    temperatura_atual: .ascii "Temp. Atual   " 
	umidade_atual: .ascii "Umi. Atual    "
	temperatura_cont: .ascii "Temp. Contínua" 
	umidade_cont: .ascii "Umi. Contínua "

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
