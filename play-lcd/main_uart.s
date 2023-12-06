.include "uart.s"

.global _start

_start:
        UART_Mapeamento
        UART_Config
        UART_tx_byte  
             
_end:   mov     R0, #0      
        mov     R7, #1      
        svc     0  

.data

devMen:   .asciz  "/dev/mem"

