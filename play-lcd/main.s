.include "gpio.s"
.include "sleep.s"
.include "lcd.s"

.global _start

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
    habilitarSegundaLinha
    
    MOV R13, #-1
    MOV R14, #-1

    espera:

        MOV R10, #0

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ escolhe_Sensor

        GPIOPinEstado b3
        CMP R1, #0
        BEQ incrementa

        b espera
        
    incrementa:

        CMP R13, #4 
        BEQ espera

        @ se botão ainda estiver pressionado, continua em incrementa
        GPIOPinEstado b3
        CMP R1, #0 
        BEQ incrementa 

        ADD R13, R13, #1

        CMP R13, #0 
        BEQ carrega_situacao

        CMP R13, #1 
        BEQ carrega_temp_atual
        
        CMP R13, #2 
        BEQ carrega_umi_atual
        
        CMP R13, #3
        BEQ carrega_temp_cont
        
        CMP R13, #4
        BEQ carrega_umi_cont

        B espera

    decrementa:

        CMP R13, #0 
        BEQ espera 

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa
        
        SUB R13, R13, #1

        CMP R13, #0 
        BEQ carrega_situacao

        CMP R13, #1 
        BEQ carrega_temp_atual
        
        CMP R13, #2 
        BEQ carrega_umi_atual
        
        CMP R13, #3
        BEQ carrega_temp_cont
        
        CMP R13, #4
        BEQ carrega_umi_cont

        B espera

@label para verificar qual botão foi selecionado no momento de escolher um sensor
    escolhe_Sensor:
        MOV R15, #0

        MOV R10, #0

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa_Sensor

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ escolhe_Sensor @Função final

        GPIOPinEstado b3
        CMP R1, #0
        BEQ incrementa_Sensor

        b escolhe_Sensor

@FUNÇÃO PARA INCREMENTAR O NUMERO DO SENSOR A SER UTILIZADO
    incrementa_Sensor:

        CMP R14, #31 
        BEQ escolhe_Sensor

        @ se botão ainda estiver pressionado, continua em incrementa
        GPIOPinEstado b3
        CMP R1, #0 
        BEQ incrementa_Sensor 

        ADD R14, R14, #1

        CMP R13, #0 
        BEQ carrega_situacao

        CMP R13, #1 
        BEQ carrega_temp_atual
        
        CMP R13, #2 
        BEQ carrega_umi_atual
        
        CMP R13, #3
        BEQ carrega_temp_cont
        
        CMP R13, #4
        BEQ carrega_umi_cont

@função que decrementa o numero do sensor a ser utilizado
    decrementa_Sensor:

        CMP R14, #31 
        BEQ escolhe_Sensor

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa_Sensor
        
        SUB R14, R14, #1

        CMP R13, #0 
        BEQ carrega_situacao

        CMP R13, #1 
        BEQ carrega_temp_atual
        
        CMP R13, #2 
        BEQ carrega_umi_atual
        
        CMP R13, #3
        BEQ carrega_temp_cont
        
        CMP R13, #4
        BEQ carrega_umi_cont

    exibicao_lcd:
        LDR R11, [R12, R10]
        EscreverCharLCD R11
        ADD R10, R10, #1
        CMP R10, #16
        BEQ verifica_retorno
        B exibicao_lcd
    
    verifica_retorno:
        ADD R15, R15, #1
        CMP R14, #-1
        BEQ espera
        CMP R15, #2
        BEQ escolhe_Sensor
        B carrega_sensor

    carrega_situacao:
        LDR R12, =situacao
        limparDisplay
        B exibicao_lcd

    carrega_temp_atual:
        LDR R12, =temperatura_atual
        limparDisplay
        B exibicao_lcd

    carrega_umi_atual:
        LDR R12, =umidade_atual
        limparDisplay
        B exibicao_lcd

    carrega_temp_cont:
        LDR R12, =temperatura_cont
        limparDisplay
        B exibicao_lcd

    carrega_umi_cont:
        LDR R12, =umidade_cont
        limparDisplay
        B exibicao_lcd
    carrega_sensor:
        LDR R12, =sensor
        moveCursorSegundaLinha
        B exibicao_lcd  

    EXIT:
        _end

.data
    situacao: .ascii "Situacao Sensor "
    temperatura_atual: .ascii " Temperatura A. " 
    umidade_atual: .ascii " Umidade Atual  "
    temperatura_cont: .ascii " Temperatura C. " 
    umidade_cont: .ascii "Umidade Continua"
    sensor: .ascii "sensor numero - "

    fileName: .asciz "/dev/mem" @ caminho do arquivo que representa a memoria RAM
    gpioaddr: .word 0x1C20 @ endereco base GPIO / 4096
    pagelen: .word 0x1000 @ tamanho da pagina
    
    time1s: .word 1  @ 1s

    time1ms: .word 1000000 @ 1ms
    time500ms: .word 500000000 @500ms

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

