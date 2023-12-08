.EQU UART3_RST, 0x02D8 @BUS_SOFT_RST_REG4
.EQU UART3_GATING, 0x006C @BUS_CLK_GATING_REG3
.EQU APB2_CLK_SRC_SEL, 0x0058 @APB2_CFG_REG
.EQU PLL_ENABLE, 0x0028 @PLL_PERIPH0_CTRL_REG

.macro  mapeamentomemoriaccu
    @sys_open
    LDR R0, =fileName @ R0 = nome do arquivo
    MOV R1, #2 @ O_RDWR (permissao de leitura e escrita pra arquivo)
    MOV R7, #5 @ sys_open
    SVC 0
    MOV R4, R0 @ salva o descritor do arquivo.

    @sys_mmap2
    MOV R0, #0 @ NULL (SO escolhe o endereco)
    LDR R1, =pagelen
    LDR R1, [R1] @ tamanho da pagina de memoria
    MOV R2, #3 @ protecao leitura ou escrita
    MOV R3, #1 @ memoria compartilhada
    LDR R5, =gpioaddr @ endereco GPIO / 4096
    LDR R5, [R5]
    MOV R7, #192 @sys_mmap2
    SVC 0
    MOV R8, R0
.endm

.macro configuracaoccu
    @desativo o enable colocando o bit 19 do endereco em 1
    LDR R0, [R8, #UART3_RST]
    MOV R5, #1
    LSL R5, R5, #19
    ORR R0, R0, R5
    STR R0, [R8, #UART3_RST]

    /* 
    @habilitar clock PLL_PERIPH0
    LDR R0, [R8, #APB2_CLK_SRC_SEL]
    MOV R5, #1
    LSL R5, R5, #25
    ORR R0, R0, R5
    STR R0, [R8, #APB2_CLK_SRC_SEL]
    */

    @habilito pll_enable
    LDR R0, [R8, #PLL_ENABLE]
    MOV R5, #1
    LSL R5, R5, #31
    ORR R0, R0, R5
    STR R0, [R8, #PLL_ENABLE] 
    
    
    @habilito PLL_CLK_OUT_EN
    LDR R0, [R8, #PLL_ENABLE]
    MOV R5, #1
    LSL R5, R5, #24
    ORR R0, R0, R5
    STR R0, [R8, #PLL_ENABLE]

    /* 
    @desativo PLL_24M_POST_DIV
    LDR R0, [R8, #PLL_ENABLE]
    MOV R5, #1
    LSL R5, R5, #18
    BIC R0, R0, R5
    STR R0, [R8, #PLL_ENABLE]
    */

    @habilito clock na uart3
    LDR R0, [R8, #UART3_GATING]
    MOV R5, #1
    LSL R5, R5, #19
    ORR R0, R0, R5
    STR R0, [R8, #UART3_GATING]

.endm


