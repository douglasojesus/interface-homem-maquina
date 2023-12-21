/*
   Realiza a inicialização do display LCD
   (com base nas instruções do datasheet dele)
*/
.macro inicializacao
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
    nanoSleep timeZero, time5ms

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable 
    nanoSleep timeZero, time150us

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    enable

    GPIOPinAlto d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    enable

    GPIOPinAlto d4
    enable

    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    enable

    GPIOPinBaixo d6
    GPIOPinBaixo d5
    enable

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    .ltorg
.endm

/*
   Da um pulso no pino conectado ao enable (E)
   do display LCD
*/
.macro enable
    GPIOPinBaixo E
    nanoSleep timeZero, time1ms
    GPIOPinAlto E
    nanoSleep timeZero, time1ms
    GPIOPinBaixo E
.endm

/*
   Executa a instrução de clear do LCD
*/
.macro limparDisplay
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d4
    enable
    .ltorg
.endm

/*
   Configurações da instrução para setar a segunda linha do display 
   A segunda linha está 40 bits a mais que a base da primeira
*/
.macro habilitarSegundaLinha
    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d7
    enable
.endm

/*
   Move o cursor para o início da segunda linha
*/
.macro moveCursorSegundaLinha
    GPIOPinBaixo RS

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinBaixo d5
    GPIOPinBaixo d4
    enable

    GPIOPinBaixo d7
    GPIOPinBaixo d6
    enable
.endm

/*
   Manda o upper bits da coluna da matriz da tabela
   de dados do LCD para o LCD
   (Usada como auxiliar em WriteLCD)
*/
.macro prefixNumeroDisplay
    GPIOPinBaixo d7
    GPIOPinBaixo d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
.endm

/*
   Altera o modo dos pinos conectados
   no LCD em modo de saída
*/
.macro setLCDPinsSaida
    GPIOPinSaida E
    GPIOPinSaida RS
    GPIOPinSaida d7
    GPIOPinSaida d6
    GPIOPinSaida d5
    GPIOPinSaida d4
.endm

/*
   Liga o display LCD, exibe o cursor e o torna
   piscante
*/
.macro displayLigado
    GPIOPinBaixo RS

    GPIOPinBaixo d7 
    GPIOPinBaixo d5 
    GPIOPinBaixo d6 
    GPIOPinBaixo d4
    enable

    GPIOPinAlto d7
    GPIOPinAlto d6
    GPIOPinAlto d5
    GPIOPinAlto d4
    enable
.endm

/*
   Desloca o cursor do display LCD para a direita
*/
.macro cursorDeslocaDireita
    GPIOPinBaixo RS

    GPIOPinBaixo d7
    GPIOPinBaixo d6 

    GPIOPinBaixo d5
    GPIOPinAlto d4
    enable

    GPIOPinAlto d6
    enable
.endm
