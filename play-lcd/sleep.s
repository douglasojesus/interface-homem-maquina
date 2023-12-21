/*
   Macro que realiza a chamada ao sistema nanosleep,
   suspendendo a execução por ~sec~ segundos e ~nsec~ nanossegundos.
*/
.macro nanoSleep sec nsec
    LDR R0, =\sec @ Carrega o valor dos segundos para o registrador R0
    LDR R1, =\nsec @ Carrega o valor dos nanossegundos para o registrador R1
    MOV R7, #162 @ Número da chamada ao sistema para nanosleep
    SVC 0 @ Chamada ao sistema
.endm
