#include <stdio.h>

typedef struct Botao {
    int acionado;
} Botao;

void fazNada() {
    return;
}

int main() {
    int R1 = 0;
    int R2 = 0;
    Botao incrementa;
    Botao decrementa;
    char entrada;

    while (1) {
        printf("\nincrementa(i) ou decrementa(d)? ");
        scanf(" %c", &entrada);  // Adicionado espaço para limpar o buffer de entrada.

        if (entrada == 'i') {
            incrementa.acionado = 1;
            decrementa.acionado = 0;
        } else if (entrada == 'd') {
            incrementa.acionado = 0;
            decrementa.acionado = 1;
        }

        if (incrementa.acionado) {
            if (R2 == 3 && R1 == 2) {
                fazNada();
            } else if (R1 == 9 && R2 != 3) {
                R1 = 0;
                R2++;
            } else {
                R1++;
            }
        } else if (decrementa.acionado) {
            if (R1 == 0 && R2 == 0) {
                fazNada();
            } else if (R1 == 0) {
                R1 = 9;
                R2--;
            } else {
                R1--;
            }
        }

        printf("R2: %d - R1: %d\n", R2, R1);
    }

    return 0; 
}

