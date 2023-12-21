/*
   Macro responsável por extrair os dígitos de um número representado por R6.
   O primeiro dígito é armazenado em R9 e o segundo dígito em R6.
*/
.macro catchDigits
    mov r9, #0          @ Inicializa R9 (primeiro dígito) como zero
    mov r10, #10        @ Inicializa R10 com o valor 10
    sdiv r9, r6, r10    @ R9 recebe o resultado da divisão inteira de R6 por 10 (primeiro dígito)
    
    mul r10, r9, r10    @ R10 armazena o resultado da multiplicação de R9 por 10
    sub r6, r6, r10     @ R6 recebe o resultado da subtração de R6 por R10 (segundo dígito)
.endm
