.include "uart.s"

.global _start

_start:
        mapeamento_uart
        configuracao
        UART_TX
  
             
_end:   mov     R0, #0      
        mov     R7, #1      
        svc     0  

.data

devMen:   .asciz  "/dev/mem"