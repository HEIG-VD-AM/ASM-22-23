#     ___   _____ __  ______   ____ ___  ___ 
#    /   | / ___//  |/  /__ \ / __ \__ \|__ \
#   / /| | \__ \/ /|_/ /__/ // / / /_/ /__/ /
#  / ___ |___/ / /  / // __// /_/ / __// __/ 
# /_/  |_/____/_/  /_//____/\____/____/____/ 
#
# Author : Alexis Martins

.text

## @brief uint32_t fib_asm(uint32_t n)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global silly_fib_asm
.type fib_asm, @function
silly_fib_asm:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    pushl %ebp
    movl %esp, %ebp
    subl $4, %esp       	# Réserve de l'espace pour des variables locales

    movl 8(%ebp), %eax  	# Charge n dans eax

    cmpl $2, %eax       	# Vérifie si n est plus que deux
    jl n_less_2

    subl $1, %eax       	# Calcule n-1
    pushl %eax          	# Sauvegarde eax sur la stack (retour de fonction)
    call silly_fib_asm  	# Premier appel à fib avec n-1
    addl $4, %esp       	# Remise en état de la stack

    movl %eax, -4(%ebp) 	# Stocke le résultat intermédiaire dans une variable locale

    movl 8(%ebp), %eax  	# Charge n dans eax
    subl $2, %eax       	# Calcule n-2
    pushl %eax          	# Sauvegarde eax sur la stack (retour de fonction)
    call silly_fib_asm  	# Premier appel à fib avec n-2
    addl $4, %esp       	# Remise en état de la stack

    addl -4(%ebp), %eax 	# Ajoute la valeur intermédiaire à eax

    jmp end

	n_less_2:
	    movl 8(%ebp), %eax	# Stocke n dans le registre de retour

	end:
	    leave
    	ret

#   @@@@@@@@@@@ ----------- @@@@@@@@@@

## @brief uint32_t fib_asm(uint32_t n, uint32_t a = 0, uint32_t b = 1)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @param a,b used for recursion
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global fib_asm
.type fib_asm, @function
fib_asm:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    pushl %ebp
    movl %esp, %ebp
    subl  $12, %esp				# Réservation des variables locales

    movl  8(%ebp), %eax			# Copie du 1st argument en var locale
    movl  %eax, -4(%ebp)

    movl  12(%ebp), %eax		# Copie du 2nd argument en var locale
    movl  %eax, -8(%ebp)

    movl  16(%ebp), %eax		# Copie du 3rd argument en var locale
    movl  %eax, -12(%ebp)

	cmpl $0, -4(%ebp)			# Vérifie si n est égal à 0 si ce n'est pas le cas on fait le check de 1. Sinon on retourne a
    jne check_one
    movl -8(%ebp), %eax
    jmp fib_end

	check_one:					# Vérifie si n est égal à 1 si ce n'est pas le cas on fait la recursion. Sinon on retourne  b
		cmpl $1, -4(%ebp)
	    jne recursive
	    movl -12(%ebp), %eax
	    jmp fib_end

	recursive:

		addl -8(%ebp), %eax		# Addition de a + b pour le passer à fib via la pile
		pushl %eax

		movl -12(%ebp), %eax	# Permet de passer b via la stack à l'appel recursif
		pushl %eax

		movl -4(%ebp), %eax		#  Récupère n et y soutrait un pour le passer à fib via la pile
		subl $1, %eax
		pushl %eax

	    call fib_asm  			# Appel recursif de fib
	    addl $12, %esp       	# Remise en état de la stack

	fib_end:
	    leave
    	ret
#   @@@@@@@@@@@ ----------- @@@@@@@@@@

## @brief uint32_t fib_asm(uint32_t n, uint32_t a = 0, uint32_t b = 1)
## Computes the nth Fibonacci number recursively
## Fib(0) = 0, Fib(1) = 1, Fib(n) = Fib(n-1) + Fib(n-2) for n > 1
## @param n the nth number we want as a result
## @param a,b used for recursion
## @return the nth Fibonacci number 0, 1, 1, 2, 3, 5, 8 etc...
.global fib_asm_tail
.type fib_asm_tail, @function
fib_asm_tail:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

    pushl %ebp
    movl %esp, %ebp
    subl  $16, %esp

    movl  8(%ebp), %eax			# Copie du 1st argument en var locale
    movl  %eax, -4(%ebp)

    movl  12(%ebp), %eax		# Copie du 2nd argument en var locale
    movl  %eax, -8(%ebp)

    movl  16(%ebp), %eax		# Copie du 3rd argument en var locale
    movl  %eax, -12(%ebp)

	cmpl $0, -4(%ebp)			# Vérifie si n est égal à 0 si ce n'est pas le cas on fait le check de 1. Sinon on retourne a
    jne check_one_tail
    movl -8(%ebp), %eax
    jmp fib_tail_end

	check_one_tail:				# Vérifie si n est égal à 1 si ce n'est pas le cas on fait la recursion. Sinon on retourne  b
	cmpl $1, -4(%ebp)
    jne fib_loop
    movl -12(%ebp), %eax
    jmp fib_tail_end

	fib_loop:

    	cmpl  $0, -4(%ebp)		# Condition d'arrêt de la boucle lorsque n est égal à 0
		je    fib_tail_end

	    movl  -12(%ebp), %eax	# Additionne a et b et le stocke temporairement
	    addl  -8(%ebp), %eax
	    movl  %eax, -16(%ebp)

	    movl  -12(%ebp), %eax	# On met b à l'emplacement de a
	    movl  %eax, -8(%ebp)

	    movl  -16(%ebp), %eax	# On met l'addition précédente dans la place de b
	    movl  %eax, -12(%ebp)

	    decl  -4(%ebp)			# On décrémente n
		movl  -8(%ebp), %eax	# On stocke dans le registre de retour la valeur de temporaire/finale
	    jmp   fib_loop

	fib_tail_end:
	    leave
    	ret

#   @@@@@@@@@@@ ----------- @@@@@@@@@@
