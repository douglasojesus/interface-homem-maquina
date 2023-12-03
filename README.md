# Projeto Módulo Integrador de Sistemas Digitais - Problema 02

## Objetivo
O objetivo deste projeto é criar uma interface para o usuário utilizando uma Single Board Computer (SBC) Orange Pi, linguagem Assembly e um Display LCD HD44780. Este projeto é uma extensão do Problema 01, onde implementamos a comunicação serial usando UART e interagimos com o computador através do terminal de comando.

## Descrição Geral

### Componentes Principais
1. **SBC Orange Pi:**
   - Utilizamos a Orange Pi como plataforma de desenvolvimento.

2. **Linguagem Assembly:**
   - O código do projeto é escrito em Assembly, aproveitando a capacidade de baixo nível dessa linguagem para interagir diretamente com o hardware da Orange Pi.

3. **Display LCD HD44780:**
   - Implementamos a interface de usuário usando um Display LCD HD44780, conectado à Orange Pi. O LCD fornece uma saída visual para o usuário, exibindo informações sobre o sistema.

### Metas previstas

1. **UART:**
   - Implementação da comunicação serial (UART) para interação entre a Orange Pi e outros dispositivos. Definição de macros e funções relacionadas à UART, garantindo a comunicação eficiente e confiável.

2. **GPIO:**
   - Configuração dos pinos GPIO da Orange Pi para interação com outros periféricos, como o Display LCD.

3. **Display LCD:**
   - Desenvolvimento de funções e macros específicas para controlar o Display LCD HD44780. Isso inclui a inicialização, escrita de caracteres, posicionamento do cursor e controle geral do display.

4. **Interface do Usuário:**
   - Criação uma interface de usuário básica no Display LCD para fornecer informações sobre o sistema. Isso inclui a exibição de dados relacionados a sensores, temperatura, umidade, etc.

5. **Controle de Fluxo:**
   - Implementação de um controle de fluxo no código principal para interagir com o usuário por meio de botões físicos ou outros dispositivos de entrada conectados à Orange Pi.

### Estrutura do Projeto

- **`gpio.s`:**
   - Define funções e macros relacionadas à configuração e manipulação de pinos GPIO.

- **`sleep.s`:**
   - Implementa funções para realizar pausas e temporizações, garantindo a sincronização adequada em operações assíncronas.

- **`lcd.s`:**
   - Contém código relacionado ao controle do Display LCD HD44780, incluindo inicialização, escrita de caracteres, controle do cursor, etc.

- **`uart.s`:**
    - Contém código relacionado à configuração e operação da comunicação serial UART. Isso inclui a inicialização da UART, envio e recebimento de dados.

- **`main.s`:**
   - Arquivo principal que integra todos os módulos e implementa a lógica central do programa. Controla a interação com o usuário, a exibição no LCD e as operações relacionadas aos sensores.

### Uso do Projeto

1. **Compilação:**
   - Certifique-se de ter um ambiente de desenvolvimento Assembly configurado para a Orange Pi.
   - Compile o projeto usando o assembler adequado para a sua plataforma.

2. **Carregamento na Orange Pi:**
   - Carregue o binário gerado na Orange Pi.

3. **Execução:**
   - Execute o programa principal (`main.s`) na Orange Pi.

4. **Interaja com o Sistema:**
   - Utilize os botões ou dispositivos de entrada conectados para interagir com a interface do usuário no Display LCD.

### Observações Importantes

- **Configuração dos Pinos:**
   - Verifique se a configuração dos pinos GPIO e outras interfaces (UART, LCD) está correta para a sua Orange Pi específica.

- **Documentação:**
   - Consulte a documentação específica da Orange Pi para obter detalhes sobre registradores, pinouts e outros aspectos do hardware.

