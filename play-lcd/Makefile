all:
	as -o main.o main.s
	ld -s -o main main.o
	sudo ./main

teste:
	as -o main_test.o main_test.s
	ld -s -o main_test main_test.o
	sudo ./main_test
 
clean:
	rm -f main.o main main_uart main_test.o main_test ideia_continuo ideia_continuo.o main_test.s main_com_encerramento_cont.s main_test.s ideia_continuo.s
	