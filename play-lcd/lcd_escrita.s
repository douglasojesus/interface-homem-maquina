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
    and r1, \valor @0001 & 0011 -> 0001
    LDR R0, =d4
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D5
    mov r1, #0b00010 
    and r1, \valor @ 0010 & 0011 -> 0010
    lsr r1, #1 @ Desloca o bit 1x para direita -> 0001
    LDR R0, =d5
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D6
    mov r1, #0b00100 
    and r1, \valor @ 0100 & 0101 -> 0100
    lsr r1, #2 @ Desloca o bit 2x para direita -> 0001
    LDR R0, =d6
    LDR R7, [R0, #8]
    BL GPIOPinTurn

    @ D7 MOV R6, #0x0f 

    mov r1, #0b01000 
    and r1, \valor @ 01000 & 01000 -> 01000
    lsr r1, #3 @ Desloca o bit 3x para direita -> 00001
    LDR R0, =d7
    LDR R7, [R0, #8]
    BL GPIOPinTurn 
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
    MOV R6, #0x0f 

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




