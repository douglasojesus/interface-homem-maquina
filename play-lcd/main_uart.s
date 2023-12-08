.include "uart.s"
.include "ccu.s"
.include "gpio.s"

.global _start

_start:
    MapeamentoMemoria
    mapeamentomemoriaccu
    configuracaoccu
    mapeamento_uart
    set_pin_uart UART_TX
    configuracaouart 

    UART_TX #0b101010
            
end:   
    mov     R0, #0      
    mov     R7, #1      
    svc     0  

.data  
    fileName: .asciz  "/dev/mem"
    uartaddr: .word 0x01C28 @endereço base da uart0
    gpioaddr: .word 0x01C20 @endereço base da uart0
    pagelen: .word 0x1000

    UART_TX:
        .word 0x4
        .word 0x18
        .word 0xe
        .word 0x10 

    UART_RX:
        .word 0x4
        .word 0x14
        .word 0xd
        .word 0x10