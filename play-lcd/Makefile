all:
    as -o main.o main.s
    ld -s -o main main.o
    sudo ./main
    
teste:
    as -o main_test.o main_test.s
    ld -s -o main_test main_test.o
    sudo ./main_test

teste2:
    as -o main_test2.o main_test2.s
    ld -s -o main_test2 main_test2.o
    sudo ./main_test2
    
ideia:
    as -o ideia_continuo.o ideia_continuo.s
    ld -s -o ideia_continuo ideia_continuo.o
    sudo ./ideia_continuo

clean:
    rm -f main.o main main_uart main_test.o main_test ideia_continuo.o ideia_continuo main_test2 main_test2.o 
    