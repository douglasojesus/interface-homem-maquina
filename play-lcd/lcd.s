/*
======================================================
        Altera o modo dos pinos conectados
        no LCD em modo de saida
======================================================
*/
.macro setLCDPinsSaida
    GPIOPinSaida E
    GPIOPinSaida RS
    GPIOPinSaida d7
    GPIOPinSaida d6
    GPIOPinSaida d5
    GPIOPinSaida d4
.endm

/*
======================================================
        Da um pulso no pino conectado ao enable (E)
        do display LCD
======================================================
*/
.macro enable
    GPIOPinBaixo E
    nanoSleep timeZero, time1ms
    GPIOPinAlto E
    nanoSleep timeZero, time1ms
    GPIOPinBaixo E
.endm


/*
======================================================
        Realiza a inicialização do display LCD
        (com base nas instrucoes do datasheet dele)
======================================================
*/
.macro inicializacao
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
    nanoSleep timeZero, time5ms

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable    
    nanoSleep timeZero, time150us

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    enable

    GPIOPinAlto d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    enable

    GPIOPinAlto d4
    enable

    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    enable

    GPIOPinBaixo d6
    GPIOPinBaixo d5
    enable

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    .ltorg
.endm

/*
======================================================
        Executa a instrucao de clear do LCD
======================================================
*/
.macro limparDisplay
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable
    
    GPIOPinAlto d4
    enable
.endm

@ configuraçõe da instrução pra setar a segunda linah do display 
@ a segunda linha está 40 bits a mais que a base da primeira
.macro habilitarSegundaLinha
    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d7
    enable
.endm

@ move o cursor para o inicio da segunda linha
.macro moveCursorSegundaLinha
    GPIOPinBaixo RS

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    enable

.endm

/*
======================================================
    Manda o upper bits da coluna da matriz da tabela
    de dados do LCD para o LCD
    (Usada como auxiliar em WriteLCD)
======================================================
*/
.macro prefixNumeroDisplay
    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
.endm

/*
======================================================
    Escreve um numero no display LCD
======================================================
*/
.macro EscreverLCD valor

    GPIOPinAlto RS
    prefixNumeroDisplay

    @ D4    
    mov r1, #0b00001      
    and r1, \valor          @0001 & 0011 -> 0001
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D5
    mov r1, #0b00010   
    and r1, \valor          @ 0010 & 0011 -> 0010
    lsr r1, #1              @ Desloca o bit 1x para direita  -> 0001
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D6
    mov r1, #0b00100      
    and r1, \valor          @ 0100 & 0101 -> 0100
    lsr r1, #2              @ Desloca o bit 2x para direita  -> 0001
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D7
    mov r1, #0b01000      
    and r1, \valor          @ 01000 & 01000 -> 01000
    lsr r1, #3              @ Desloca o bit 3x para direita  -> 00001
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn    
    enable
.endm


/*
======================================================
    Liga o display LCD, exibe o cursor e o torna
    piscante
======================================================
*/
.macro displayLigado
    GPIOPinBaixo RS
    
    GPIOPinBaixo d7 
    GPIOPinBaixo d5 
    GPIOPinBaixo d6 
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
.endm


/*
======================================================
    Desliga o display LCD
======================================================
*/
.macro displayDesligado
    GPIOPinBaixo RS
    
    GPIOPinBaixo d7 
    GPIOPinBaixo d5 
    GPIOPinBaixo d6 
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d7
    enable
.endm



/*
======================================================
    Desloca o cursor do display LCD para a direita
======================================================
*/
.macro cursorDeslocaDireita
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinAlto d4
    enable

    GPIOPinAlto d6
    enable
.endm


/*
======================================================
    Executa a instrucao Return Home no display
    LCD
======================================================
*/
.macro returnHome
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPina d5
    enable
.endm


/*
======================================================
    Escreve um caractere no display LCD

    O Hexadecimal, de acordo com a table do LCD
    deve vir do seguinte formato |0x upper lower|
======================================================
*/
.macro EscreverCharLCD hex
    MOV R9, \hex
    GPIOPinAlto RS

    MOV R2, #7
    BL getBitEstado
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #6
    BL getBitEstado
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #5
    BL getBitEstado
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #4
    BL getBitEstado
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    enable

    MOV R2, #3
    BL getBitEstado
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #2
    BL getBitEstado
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #1
    BL getBitEstado
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    MOV R2, #0
    BL getBitEstado
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    enable
.endm


/*
======================================================
    Seta o cursor do display para uma posicao especifica
    a partir do inicio.

    ~pos~ tem de estar entre 1 e 32
======================================================
*/
.macro setLCDCursor posicao
    MOV R0, \posicao
    returnHome
    WHILE:
        cursorDeslocaDireita
        nanoSleep timeZero, time150us
        SUB R0, #1
        CMP R0, #0
        BGT WHILE
.endm