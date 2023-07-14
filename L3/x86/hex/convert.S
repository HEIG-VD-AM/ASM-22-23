# Author : Alexis Martins

.global char_to_hex
.equiv ZERO, 48
.equiv X, 120
.equiv LIMIT, 10
.equiv BASE, 16
.equiv HEX_0, 0x30
.equiv HEX_A, 0x37

char_to_hex:
	pushl %ebp                # Save old stack frame
	movl  %esp, %ebp          # Set new stack base
	movl  8(%ebp), %eax       # copy the argument in eax
	pushl %ebx

	########## A completer ##########

	mov %eax, %ebx

	# Création de la première partie du nombre "0x"
	movb $ZERO, %ch
	movb $X, %cl
	sall $BASE, %ecx


	# Boucle qui soustrait 16 à la lettre passée jusqu'à tomber sur un nombre < 16. Ce nombre composera les 8 LSB.
	# Ce calcul donne directement la réponse de sortie. Ex : A
	# ecx = 0x41
	# Il faut encore transformer le 1 et le 4 en valeurs affichables (existantes dans la table ASCII), car ici ils correspondent à des caractères blanks.
	loop:
		movl %ebx, %edx
		subl $BASE, %ebx
		incb %ch
		cmpl $BASE, %edx
		jns loop
	other_stuff:
		decb %ch
		movb %dl, %cl

	# Ajustement de la valeur en ajoutant les valeurs manquantes pour qu'on tombe sur le bon caractère en ASCII.
	cmpb $LIMIT, %ch
	js unitech
	dizainech:
		addb $HEX_A, %ch
		jmp next
	unitech:
		addb $HEX_0, %ch

	next:
		cmpb $LIMIT, %cl
		js unitecl
		dizainecl:
			addb $HEX_A, %cl
			jmp end
		unitecl:
			addb $HEX_0, %cl

	end:
		mov %ecx, %eax

out:
    popl %ebx
    leave                     # Restore stack frame
    ret                       # Return to caller

