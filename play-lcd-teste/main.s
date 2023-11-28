
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

	GPIOPinEntrada b1 @ botão do meio => selecionar (Entrada)
	GPIOPinEntrada b2 @ botão mais a direita antes do espaço => pular (Entrada)
	GPIOPinEntrada b0 @ botão alongado => voltar (Entrada)
	setLCDPinsSaida @ Atribuo a todos os pinos do LCD como sendo de Saída
	
	inicializacao
    segundaLinha @ liga a segunda linha do display

    ldr r12, =palavra
    mov r10, #0
    
    @ botões são contadores, quando clica muda de indice/página
    @ cada "página" contém uma palavra que define a tela do display atual

    inicio:
        GPIOPinEstado b1
        CMP R1, #0 @ botão apertado
        beq loop
        b inicio
    
    loop:
        @ percorre a palavra letra por letra
        ldr r11, [r12, r10]
        EscreverCharLCDCharLCD R11 @ escreve a letra no local certo e aumenta o ponteiro +1

        add r10, r10, #1 @ incrementa o r10
        
        @ verifica se ja atingiu o tamanho da palavra
        cmp r10, #41
        beq EXIT
        b loop


	EXIT:
        /*
        nanoSleep time1s, timeZero
        clearDisplay
        nanoSleep time1s, timeZero
        mov r10, #0
        b loop
        */
		_end

.data
    palavra: .ascii "Temperatura                             Z\n" 


    fileName: .asciz "/dev/mem" @ caminho do arquivo que representa a memoria RAM
    gpioaddr: .word 0x1C20 @ endereco base GPIO / 4096
    pagelen: .word 0x1000 @ tamanho da pagina
    
	time1s: .word 1  @ 1s

	time1ms: .word 1000000 @ 1ms

	time850ms: .word 850000000 @850ms

    time950ms: .word 950000000 @950ms

	time170ms: .word 170000000 @ 170ms

	timeZero: .word 0 @ zero
   
	time1d55ms: .word 1500000 @ 1.5ms

	time5ms: .word 5000000 @ 5 ms

	time150us: .word 150000 @ 150us
	
	/*
	======================================================
       Todas as labels com o nome de um pino da
		Orange PI PC Plus contem 4 ~words~

		Word 1: offset do registrador de função do pino
		Word 2: offset do pino no registrador de função (LSB)
		Word 3: offset do pino no registrador de dados
		Word 3: offset do registrador de dados do pino
	======================================================
	*/

    @PA9 - LED Azul Lógica invertida
    LEDAZUL:
		.word 0x4
		.word 0x4
		.word 0x9
		.word 0x10

    @PA8 - LED Vermelho Lógica normal
    LEDVERMELHO:
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

	@PA2
	RS:
		.word 0x0
		.word 0x8
		.word 0x2
    	.word 0x10

	@PA7 Botão alongado => voltar
	b0:
		.word 0x0
		.word 0x1C
		.word 0x7
		.word 0x10

	@PA10 - Botão do meio => selecionar
	b1:
		.word 0x4
		.word 0x8
		.word 0xA
		.word 0x10

	@PA20 - Botão da direita antes do espaço => pular
	b2:
		.word 0x8
		.word 0x10
		.word 0x14
		.word 0x10
