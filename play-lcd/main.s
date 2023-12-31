/* Diretivas de inclusão */
.include "gpio.s"
.include "sleep.s"
.include "lcd_escrita.s"
.include "lcd_config.s"
.include "uart.s"
.include "ccu.s"
.include "split.s"

.global _start

.macro _end
    MOV R0, #0
    MOV R7, #1
    SVC 0
.endm

/* Rotina de inicialização */
_start:
    MapeamentoMemoria
    /* Definição dos botões */
    GPIOPinEntrada b1 @ botão alongado
    GPIOPinEntrada b2 @ botão do meio
    GPIOPinEntrada b3 @ botão mais a direita antes do espaço
    setLCDPinsSaida
    inicializacao
    habilitarSegundaLinha @ liga a segunda linha do display

    MOV R13, #0
    MOV R6, #0
    MOV R9, #0

    B carrega_situacao

    /* R6 é o segundo dígito */
    /* R9 é o primeiro dígito */
    /* R12 é o índice/guarda o valor de fato */

    /* Função para esperar que o usuário pressione algum botão */
    espera:
        MOV R10, #0

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ selecionar_opcao

        GPIOPinEstado b3
        CMP R1, #0
        BEQ incrementa

        b espera

    selecionar_opcao:
        /* Se botão ainda estiver pressionado, continua em escolher_sensor */
        nanoSleep timeZero time500ms

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ selecionar_opcao

        MOV R12, #1
        b escolher_sensor

    /* Função para verificar */
    escolher_sensor:
        moveCursorSegundaLinha

        MOV R10, #0

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa_sensor

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ ativar_uart

        GPIOPinEstado b3
        CMP R1, #0
        BEQ incrementa_sensor

        b escrever_sensor

    ativar_uart:
        nanoSleep timeZero time500ms

        GPIOPinEstado b2
        CMP R1, #0 
        BEQ ativar_uart

        mapeamentomemoriaccu
        configuracaoccu
        mapeamento_uart
        configuracaouart
        UartPin uart_tx
        UartPin uart_rx

        /* Contador que tem o comando a ser executado */
        UART_TX R13 
        /* Contador que tem o endereço do sensor */
        UART_TX R12

        MOV R13, #0 

        nanoSleep time1s timeZero

        UART_RX

        /* r6 = primeiro digito de resposta */
        MOV R6, R9

        UART_RX

        /* r11 = segundo digito de resposta */
        MOV R11, R9

        MapeamentoMemoria

        CMP R6, #0x1F
        BEQ sensor_com_problema

        CMP R6, #0x2F
        BEQ sensor_inexistente

        CMP R6, #0x3F
        BEQ requisicao_inexistente

        CMP R6, #0x07
        BEQ sensor_funcionando

        catchDigits

        EscreverLCD R9
        EscreverLCD R6

        b intermediario

    intermediario:
        GPIOPinEstado b2
        CMP R1, #0
        BEQ intermediario

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ espera

        GPIOPinEstado b3
        CMP R1, #0
        BEQ espera

        b intermediario

    incrementa:
        /* Se botão ainda estiver pressionado, continua em incrementa */
        nanoSleep timeZero time500ms

        GPIOPinEstado b3
        CMP R1, #0 
        BEQ incrementa 

        CMP R13, #4 
        BEQ espera

        ADD R13, R13, #1

        limparDisplay

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

    /* Função que decrementa o numero da tela */
    decrementa:
        /* Se botão ainda estiver pressionado, continua em incrementa */
        nanoSleep timeZero time500ms

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa

        CMP R13, #0 
        BEQ espera

        SUB R13, R13, #1

        limparDisplay

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

    /* Função que incrementa o numero do sensor */
    incrementa_sensor:
        /* Se botão ainda estiver pressionado, continua em incrementa_sensor */
        nanoSleep timeZero time500ms

        GPIOPinEstado b3
        CMP R1, #0 
        BEQ incrementa_sensor 

        CMP R12, #32
        BEQ escolher_sensor

        ADD R12, R12, #1

        B escrever_sensor

    /* Função que decrementa o numero do sensor */
    decrementa_sensor:
        /* Se botão ainda estiver pressionado, continua em decrementa_sensor */
        nanoSleep timeZero time500ms

        GPIOPinEstado b1
        CMP R1, #0 
        BEQ decrementa_sensor

        CMP R12, #1
        BEQ escolher_sensor

        SUB R12, R12, #1

        B escrever_sensor

    /* Função para escrever na primeira linha do display */
    exibicao_lcd:
        LDR R11, [R12, R10]
        EscreverCharLCD R11
        ADD R10, R10, #1
        CMP R10, #16
        BEQ espera
        B exibicao_lcd

    escrever_sensor:
        MOV R6, R12
        catchDigits
        EscreverLCD R9
        EscreverLCD R6
        B escolher_sensor    

    sensor_com_problema:
        limparDisplay
        LDR R12, =problema_sensor
        B exibicao_lcd

    sensor_inexistente:
        limparDisplay
        LDR R12, =inexistente_sensor
        B exibicao_lcd

    requisicao_inexistente:
        limparDisplay
        LDR R12, =inexistente_requisicao
        B exibicao_lcd

    sensor_funcionando:
        limparDisplay
        LDR R12, =funcionando_sensor
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
    situacao: .ascii "Situacao Sensor "
    temperatura_atual: .ascii " Temperatura A. " 
    umidade_atual: .ascii " Umidade Atual  "
    temperatura_cont: .ascii " Temperatura C. " 
    umidade_cont: .ascii "Umidade Continua"
    problema_sensor: .ascii "Sensor com Prob."
    inexistente_sensor: .ascii "Sen. inexistente"
    inexistente_requisicao: .ascii "Req. inexistente"
    funcionando_sensor: .ascii "Sen. funcionando"

    uartaddr: .word 0x01C28 @ endereço base da uart0
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

    /* Labels com o nome de um pino da Orange PI PC Plus contêm 4 palavras */
    /* Word 1: offset do registrador de função do pino */
    /* Word 2: offset do pino no registrador de função (LSB) */
    /* Word 3: offset do pino no registrador de dados */
    /* Word 4: offset do registrador de dados do pino */

    /* LED Vermelho */
    PA9:
        .word 0x4
        .word 0x4
        .word 0x9
        .word 0x10

    /* LED Azul */
    PA8:
        .word 0x4
        .word 0x0
        .word 0x8
        .word 0x10
        
    /* PG7 - DB7 */
    d7:
        .word 0xD8
        .word 0x1C
        .word 0x7
        .word 0xE8

    /* PG6 - DB6 */
    d6:
        .word 0xD8
        .word 0x18
        .word 0x6
        .word 0xE8

    /* PG9 - DB5 */
    d5:
        .word 0xDC
        .word 0x4
        .word 0x9
        .word 0xE8

    /* PG8 - DB4 */
    d4:
        .word 0xDC
        .word 0x0
        .word 0x8
        .word 0xE8

    /* PA18 - Enable */
    E:
        .word 0x8
        .word 0x8
        .word 0x12
        .word 0x10

    /* PA2 - RS */
    RS:
        .word 0x0
        .word 0x8
        .word 0x2
        .word 0x10

    /* RW - GROUND */

    /* Botão alongado */
    b1:
        .word 0x0
        .word 0x1C
        .word 0x7
        .word 0x10

    /* Botão do meio */
    b2:
        .word 0x4
        .word 0x8
        .word 0xA
        .word 0x10

    /* Botão da esquerda */
    b3:
        .word 0x8
        .word 0x10
        .word 0x14
        .word 0x10

    uart_rx:
        .word 0x4
        .word 0x18
        .word 0xe
        .word 0x10 

    uart_tx:
        .word 0x4
        .word 0x14
        .word 0xd
        .word 0x10
