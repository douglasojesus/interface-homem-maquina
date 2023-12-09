.include "uart.s"
.include "ccu.s"
.include "gpio.s"
.include "sleep.s"

.global _start

_start:
    MapeamentoMemoria
    mapeamentomemoriaccu
    configuracaoccu
    mapeamento_uart
    configuracaouart
    set_pin_uart uart_tx
    set_pin_uart uart_rx
    GPIOPinSaida PA8
     

    UART_TX #0x00
    UART_TX #0x0F

    nanoSleep time1s timeZero

    UART_RX

    CMP R0, #0x07
    BEQ acenderled

    acenderled:
        GPIOPinAlto PA8
        b end
            
end:   
    mov     R0, #0      
    mov     R7, #1      
    svc     0  

.data  
    fileName: .asciz  "/dev/mem"
    uartaddr: .word 0x01C28 @endereço base da uart0
    gpioaddr: .word 0x01C20 @endereço base da uart0
    pagelen: .word 0x1000

    time1s: .word 1  @ 1s

    time1ms: .word 1000000 @ 1ms
    time500ms: .word 500000000 @500ms

    time850ms: .word 850000000 @850ms

    time950ms: .word 950000000 @850ms

    time170ms: .word 170000000 @ 170ms

    timeZero: .word 0 @ zero
   
    time1d55ms: .word 1500000 @ 1.5ms

    time5ms: .word 5000000 @ 5 ms

    time150us: .word 150000 @ 150us
    
    /*
    ======================================================
       Todas as labels com o nome de um pino da
        Orange PI PC Plus contem 4 ~words~

        Word 1: offset do registrador de funcao do pino
        Word 2: offset do pino no registrador de funcao (LSB)
        Word 3: offset do pino no registrador de dados
        Word 3: offset do registrador de dados do pino
    ======================================================
    */

    @ LED Vermelho
    PA9:
        .word 0x4
        .word 0x4
        .word 0x9
        .word 0x10
    

    @ LED Azul
    PA8:
        .word 0x4
        .word 0x0
        .word 0x8
        .word 0x10
        
    @PG7 - DB7
    d7:
        .word 0xD8
        .word 0x1C
        .word 0x7
        .word 0xE8

    @PG6 - DB6
    d6:
        .word 0xD8
        .word 0x18
        .word 0x6
        .word 0xE8

    @PG9 - DB5
    d5:
        .word 0xDC
        .word 0x4
        .word 0x9
        .word 0xE8

    @PG8 - DB4
    d4:
        .word 0xDC
        .word 0x0
        .word 0x8
        .word 0xE8
    
    @PA18 - Enable
    E:
        .word 0x8
        .word 0x8
        .word 0x12
        .word 0x10

    @PA2 - RS
    RS:
        .word 0x0
        .word 0x8
        .word 0x2
        .word 0x10

    @RW
    @GROUND

    @ botão alongado
    b1:
        .word 0x0
        .word 0x1C
        .word 0x7
        .word 0x10

    @ botão do meio
    b2:
        .word 0x4
        .word 0x8
        .word 0xA
        .word 0x10

    @ botão da esquerda
    b3:
        .word 0x8
        .word 0x10
        .word 0x14
        .word 0x10

    uart_tx:
        .word 0x4
        .word 0x18
        .word 0xe
        .word 0x10 

    uart_rx:
        .word 0x4
        .word 0x14
        .word 0xd
        .word 0x10

