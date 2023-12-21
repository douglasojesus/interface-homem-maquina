/*
   Definições de endereços dos registradores UART
*/
.EQU UART_RBR,  0x0000 @ Registro de Buffer de Recebimento UART
.EQU UART_THR,  0x0000 @ Registro de Retenção de Transmissão UART
.EQU UART_DLL,  0x0000 @ Registro Baixo de Travamento do Divisor UART
.EQU UART_DLH,  0x0004 @ Registro Alto da Travamento do Divisor UART
.EQU UART_IER,  0x0004 @ Registro de Ativação de Interrupção UART
.EQU UART_IIR,  0x0008 @ Registro de Identidade de Interrupção UART
.EQU UART_FCR,  0x0008 @ Registro de Controle UART FIFO
.EQU UART_LCR,  0x000C @ Registro de Controle de Linha UART
.EQU UART_MCR,  0x0010 @ Registro de Controle de Modem UART
.EQU UART_LSR,  0x0014 @ Registro de Status de Linha UART
.EQU UART_MSR,  0x0018 @ Registro de Status de Modem UART
.EQU UART_SCH,  0x001C @ Registro de Rascunho UART
.EQU UART_USR,  0x007C @ Registro de Status UART
.EQU UART_TFL,  0x0080 @ Nível FIFO de Transmissão UART
.EQU UART_RFL,  0x0084 @ UART_RFL 
.EQU UART_HALT, 0x00A4 @ Registro de Interrupção UART TX

/*
   Macro que realiza o mapeamento dos registradores UART na memória
*/
.macro mapeamento_uart
    @ sys_open
    LDR R0, =fileName @ R0 = nome do arquivo
    MOV R1, #2 @ O_RDWR (permissão de leitura e escrita para arquivo)
    MOV R7, #5 @ sys_open
    SVC 0
    MOV R4, R0 @ salva o descritor do arquivo.

    @ sys_mmap2
    MOV R0, #0 @ NULL (SO escolhe o endereço)
    LDR R1, =pagelen
    LDR R1, [R1] @ tamanho da página de memória
    MOV R2, #3 @ proteção leitura ou escrita
    MOV R3, #1 @ memória compartilhada
    LDR R5, =uartaddr @ endereço GPIO / 4096
    LDR R5, [R5]
    MOV R7, #192 @ sys_mmap2
    SVC 0
    MOV R8, R0
    ADD R8, #0xC00 @ endereço base
.endm

/*
   Macro que configura os pinos relacionados à UART
*/
.macro UartPin pin
    LDR R0, =\pin @ carrega o endereço de memória de ~pin~
    LDR R1, [R0, #0] @ offset do registrador de função do pino
    LDR R2, [R0, #4] @ offset do pino no registrador de função (LSB)
    LDR R5, [R8, R1] @ conteúdo do registrador de dados do pino
    
    MOV R0, #0b111 @ máscara para limpar 3 bits
    LSL R0, R2 @ desloca @111 para posição do pino no registrador
    BIC R5, R0 @ limpa os 3 bits da posição
    MOV R0, #1 @ move 1 para R0
    LSL R0, R2 @ desloca o bit para a posição de pino no registrador de função
    ORR R5, R0 @ adiciona o valor 1 na posição anteriormente deslocada
    
    STR R5, [R8, R1] @ armazena o novo valor do registrador de função na memória
.endm

/*
   Macro que realiza a configuração inicial da UART
*/
.macro configuracaouart
    @ habilito para escrever no dlh e dll
    LDR R0, [R8, #UART_LCR]
    MOV R5, #0b1
    LSL R5, R5, #7
    ORR R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @ habilito chcfg_at_busy
    LDR R0, [R8, #UART_HALT]
    MOV R5, #0b1
    LSL R5, R5, #1
    ORR R0, R0, R5
    STR R0, [R8, #UART_HALT]

    @ bits altos do divisor
    LDR R0, [R8, #UART_DLH]
    MOV R5, #0b11111111
    BIC R0, R0, R5
    MOV R5, #0b00010000
    ORR R0, R0, R5
    STR R0, [R8, #UART_DLH]

    @ bits baixos do divisor
    LDR R0, [R8, #UART_DLL]
    MOV R5, #0b11111111
    BIC R0, R0, R5
    MOV R5, #0b00000000
    ORR R0, R0, R5
    STR R0, [R8, #UART_DLL]

    @ ativo change_update
    LDR R0, [R8, #UART_HALT]
    MOV R5, #0b1
    LSL R5, R5, #2
    ORR R0, R0, R5
    STR R0, [R8, #UART_HALT]

    @ desabilita o dll e habilita o rbr
    LDR R0, [R8, #UART_LCR]
    MOV R5, #0b1
    LSL R5, R5, #7
    BIC R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @ configuro UART para 8 bits
    LDR R0, [R8, #UART_LCR]
    MOV R5, #0b11
    ORR R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @ habilito FIFO
    LDR R0, [R8, #UART_FCR]
    MOV R5, #0b1
    ORR R0, R0, R5
    STR R0, [R8, #UART_FCR]
.endm

/*
   Macro para realizar a leitura do registrador de buffer de recebimento UART (UART_RX)
*/
.macro UART_RX
    ldr R9, [r8, #UART_RBR]
.endm

/*
   Macro para realizar a escrita no registrador de retenção de transmissão UART (UART_TX)
   Parâmetros:
   - hex: Valor a ser transmitido
*/
.macro UART_TX hex
    mov R9, \hex
    str R9, [r8, #UART_THR]
.endm
