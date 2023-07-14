.global asm_matrix_distance_simd
.type asm_matrix_distance_simd, @function

.text
    

# Functions parameters : image_container* img, image_container* kernel, int x, int y
asm_matrix_distance_simd:
#   @@@@@@@@@@@ A completer @@@@@@@@@@

	# Epilogue
	push  %ebp
	mov   %esp, %ebp
    subl $4, %esp 		# Variable locale pour la somme finale

	push %ebx

	# Chargement de l'adresse de l'image
	movl 8(%ebp), %eax

	# Récupère image_width passé en arguments et le met dans la zone mémoire
	movl (%eax), %ecx
	movl %ecx, image_width

	# Récupère image_height passé en arguments et le met dans la zone mémoire
	movl 4(%eax), %ecx
	movl %ecx, image_height

	# Chargement de l'adresse du kernel
	movl 12(%ebp), %eax

	# Récupère kernel_width passé en arguments et le met dans la zone mémoire
	movl (%eax), %ecx
	movl %ecx, kernel_width

	# Récupère kernel_height passé en arguments et le met dans la zone mémoire
	movl 4(%eax), %ecx
	movl %ecx, kernel_height

	# Récupère x passé en arguments et le met dans la zone mémoire
	movl 16(%ebp), %eax
	movl %eax, x

	# Récupère y passé en arguments et le met dans la zone mémoire
	movl 20(%ebp), %eax
	movl %eax, y

	movl $0, ky			# Initialise ky

    movl $0, -4(%ebp)	# Initialise la somme à 0


	loop_ky:

		movl kernel_height, %eax
		cmp ky, %eax
		je end

		# kx
		movl $0, kx

		loop_kx:

			movl 8(%ebp), %ebx       	# Charge l'argument contenant le pointeur sur l'image
			movl 12(%ebx), %ebx      	# Charge l'adresse du pointeur sur data

			# Calcul de l'offset de l'image
			movl kx, %ecx
			addl x, %ecx
			movl ky, %edx
			addl y, %edx
			imull image_width, %edx
			addl %edx, %ecx

			addl %ecx, %ebx				# Ajout de l'offset
			pmovzxbd (%ebx), %xmm1		# Récupération des 4 pixels


			movl 12(%ebp), %eax      	# Charge l'argument contenant le pointeur sur le kernel
			movl 12(%eax), %eax      	# Charge l'adresse du pointeur sur data

			# Calcul de l'offset du kernel
			addl kx, %eax
			movl ky, %ebx
			imull kernel_width, %ebx

			addl %ebx, %eax				# Ajout de l'offset

			pmovzxbd (%eax), %xmm2		# Récupération des 4 pixels de l'image

			psubd %xmm2, %xmm1			# Soustractions des 4 pixels

			pmulld %xmm1, %xmm1			# Multiplication des 4 pixels

			phaddd %xmm1, %xmm1			# Addition des pixels horizontalement
			phaddd %xmm1, %xmm1			# Addition des pixels horizontalement

			movd %xmm1, %eax			# Déplace la valeur de la somme dans un registre 32 bits
			addl %eax, -4(%ebp)			# Addition à la somme finale

			addl $4, kx					# Incrément de 4 pixels

			# Comparaison si on est en bout d'image (horizontalement)
			movl kernel_width, %eax
			cmp kx, %eax
			jne loop_kx

			incl ky						# Incrémente verticalement
			jmp loop_ky


	end :

		movl -4(%ebp), %eax				# Stocke la valeur de retour
		pop %ebx
	    leave
	    ret

#   @@@@@@@@@@@ ----------- @@@@@@@@@@


.data

kernel_width:
    .space 4

kernel_height:
    .space 4

image_width:
    .space 4

image_height:
    .space 4
kx:
    .space 4
ky:
    .space 4
x: 
    .space 4
y: 
    .space 4
