.macro catchDigits
    mov r10, #10 @r10=10
    sdiv r9, r12, r10 @r9= primeiro digito 

    mul r10, r9, r10
    sub r12, r12, r10 @r6= segundo digito
.endm