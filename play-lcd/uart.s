.EQU UART_RBR,  0x0000 @registro de buffer de recebimento uart
.EQU UART_THR,  0x0000 @registro de retenção de transmissão uart
.EQU UART_DLL,  0x0000 @registro baixo de trava do divisor uart
.EQU UART_DLH,  0x0004 @registro alto da trava do divisor uart
.EQU UART_IER,  0x0004 @registro de ativação de interrupção uart
.EQU UART_IIR,  0x0008 @registro de identidade de interrupção uart
.EQU UART_FCR,  0x0008 @registro de controle uart FIFO
.EQU UART_LCR,  0x000C @registro de controle de linha uart
.EQU UART_MCR,  0x0010 @registro de controle de moden uart
.EQU UART_LSR,  0x0014 @registro de status de linha uart
.EQU UART_MSR,  0x0018 @registro de status de moden uart
.EQU UART_SCH,  0x001C @registro de rascunho uart
.EQU UART_USR,  0x007C @registro de status uart
.EQU UART_TFL,  0x0080 @nível FIFO de tranmissão uart
.EQU UART_RFL,  0x0084 @uart_RFL 
.EQU UART_HALT, 0x00A4 @uart interrompe registro de tx

.macro mapeamento_uart
    @sys_open
    LDR R0, =fileName @ R0 = nome do arquivo
    MOV R1, #2 @ O_RDWR (permissao de leitura e escrita pra arquivo)
    MOV R7, #5 @ sys_open
    SVC 0
    MOV R4, R0 @ salva o descritor do arquivo.

    @sys_mmap2
    MOV R0, #0 @ NULL (SO escolhe o endereco)
    LDR R1, =pagelen
    LDR R1, [R1] @ tamanho da pagina de memoria
    MOV R2, #3 @ protecao leitura ou escrita
    MOV R3, #1 @ memoria compartilhada
    LDR R5, =uartaddr @ endereco GPIO / 4096
    LDR R5, [R5]
    MOV R7, #192 @sys_mmap2
    SVC 0
    MOV R8, R0
    ADD R8, #0xC00 @ endereco base
.endm

.macro set_pin_uart tx
    ldr r0, =\tx
    ldr r1, [r0]
    ldr r3, [r0, #4]
    ldr r2, [r8, r1]

    mov r4, #0b111
    lsl r4, r3
    bic r2, r4
    mov r4, #0b011
    lsl r4, r3
    orr r2, r4

    str r2, [r8, r1]
.endm
/* 
lcr configurar o tamanho do dado para enviar (0x11 para 8bits)
ok usar uart_dlh para setar os bits mais significativos do baud rate divisor = (clk/16*9600)    
ok usar uart_dll para setar os bits menos significativos do baud rate
verificar enable
ativar e desativar fifo e outras interrupcoes
transmitir thr 
receber pelo rbr*/
.macro configuracaouart

    @habilito para escrever no dlh e dll 
    LDR R0, [R8, #UART_LCR]
    MOV R5, #0b1
    LSL R5, R5, #7
    ORR R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @habilito chcfg_at_busy
    LDR R0, [R8, #UART_HALT]
    MOV R5, #0b1
    LSL R5, R5, #1
    ORR R0, R0, R5
    STR R0, [R8, #UART_HALT]

    @bits altos do divisor
    LDR R0, [R8, #UART_DLH]
    MOV R5, #0b11111111
    BIC R0, R0, R5
    MOV R5, #0b00010000
    ORR R0, R0, R5
    STR R0, [R8, #UART_DLH]

    @bits baixos do divisor
    LDR R0, [R8, #UART_DLL]
    MOV R5, #0b11111111
    BIC R0, R0, R5
    MOV R5, #0b00000000
    ORR R0, R0, R5
    STR R0, [R8, #UART_DLL]

    @ativo change_update 
    LDR R0, [R8, #UART_HALT]
    MOV R5, #0b1
    LSL R5, R5, #2
    ORR R0, R0, R5
    STR R0, [R8, #UART_HALT]

    @desabilita o dll e habilita o rbr
    LDR R0, [R8, #UART_LCR]
    MOV R5, #1
    LSL R5, R5, #7
    BIC R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @configuro uart para 8bits
    LDR R0, [R8, #UART_LCR]
    MOV R5, #0b11
    ORR R0, R0, R5
    STR R0, [R8, #UART_LCR]

    @habilito fifo
    LDR R0, [R8, #UART_FCR]
    MOV R5, #0b1
    ORR R0, R0, R5
    STR R0, [R8, #UART_FCR]

.endm

.macro UART_RX
    ldr r0, [r8, #UART_RBR]
.endm

.macro UART_TX hex
    mov r0, \hex
    str r0, [r8, #UART_THR]
.endm

