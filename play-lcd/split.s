.macro catchDigits
    mov r9, #0
    mov r10, #10 @r10=10
    sdiv r9, r6, r10 @r9= primeiro digito 

    mul r10, r9, r10
    sub r6, r6, r10 @r6= segundo digito
.endm

