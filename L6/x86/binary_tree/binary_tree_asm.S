# Author : Prenom Nom

.global traverse_tree_asm

.extern printf

# Macro that will print what is at the end of string_ptr (char *)
# with an extra space at the end (through the format string used).
.macro PUT_S string_ptr
    pushal
    push \string_ptr
    push $format_string
    call printf
    add  $0x8, %esp
    popal
.endm

## @brief void traverse_tree_asm(Node *root);
## Traverses a binary search tree in natural order and prints data if available
##
## @param Node *root the root of the tree to traverse and prints
traverse_tree_asm:
        # Intro
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        pushal                          # Save all registers
        movl  8(%ebp), %eax             # copy the argument in eax
	####### Student code below
	
        # TODO
        #
        # Note : It is a good idea to write the algorithm in pseudo code
        #        on paper before you start, this is not difficult but also
        #        not easy. Prepare a strategy, then finally write the assembly
        #        Have fun !
        #
        # Pseudo-code parcours infixe d'un ABR :
        # URL :https://rperrot.developpez.com/articles/algo/structures/arbres/
        #
		# procedure parcours_prof_infixe( T : arbre )
		#
		#	si non EstVide(T) alors
		#
		#		parcours_prof_infixe(FilsGauche(T));
		#		traiter_racine(T);
		#		parcours_prof_infixe(FilsDroit(T));
		#
		#	fin si

		movl %eax, %ecx			# Copie du paramètre pour travailler sur une copie (bonne pratique)
		movl $0, %edx			# On instancie un compteur (permet de savoir le nombre d'éléments dans la pile)

		left:
			cmpl $0, 8(%ecx)	# Vérifie si le noeud courant possède un enfant gauche
			je print_node		# Si ce n'est pas le cas, alors on saute à l'affichage du noeud courant

			pushl %ecx			# S'il possède un enfant, alors le noeud courant est mis sur la pile
			incl %edx			# On incrémente le compteur de noeud sur la pile
			movl 8(%ecx), %ecx	# Met à jour le noeud courant comme étant l'enfant gauche
			jmp left			# Refait la boucle pour vérifier s'il reste encore un enfant gauche

		print_node:
			movl 4(%ecx), %ebx	# Récupère le pointeur sur string (donnée) stockée dans le noeud
			PUT_S %ebx			# Affichage de la data

		right:
			cmpl $0, 12(%ecx)	# Vérifie si le noeud courant possède un enfant droit
			je get_parent		# Si ce n'est pas le cas, il effectue un branchement vers la partie pernettant de remonter ou terminer le programme
			movl 12(%ecx), %ecx # Met à jour le noeud courant comme étant l'enfant droit
			jmp left			# Recommence la boucle entière (traite l'enfant droit comme si c'était une racine)

		get_parent:
			cmpl $0, %edx		# Condition d'arrêt du parcours de l'ABR, si plus personne n'est sur la pile à ce moment alors tout à été parcouru
			je end				# Saut de terminaison
			popl %ecx			# Récupère le prochain noeud à traiter qui était sur la pile
			decl %edx			# Décrémente le compteur de noeud
			jmp print_node		# Saute à l'affichage du noeud


		end:


	######## End of student code
        # Outro
        popal                           # Restore all register
        leave                           # Restore stack frame
        ret                             # Return to caller

.data
format_string:
    .string "%s "
example_string:
    .string "Hello from ASM !"
