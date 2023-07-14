/*
 * exo1.c - String allocation and copy exercise
 *
 * Author(s) : Name Surname, Name Surname
 */

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

char *allocate_string(const char *string, int length) {
    // TODO
	char* ptr = (char*) calloc(length, sizeof(char));

	if(ptr == 0) {
		printf("Erreur de pointeur");
		exit(-1);
	}

	for(int i = 0; i < length; i++) {

		*(ptr + i) = *(string + i);
	}

	return ptr;
}

int main(int argc, char **argv) {
    printf("Welcome to ASM\n");

    const char* toCopy = "test";
    char* string = allocate_string("test", strlen(toCopy));

    printf("%s\n", string);

    return 0;
}
