@ ASM
@ Author : Alexis Martins

@@ @brief uint32_t discrete_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the discrete distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global discrete_distance_asm
discrete_distance_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

@@@@@@@@@@@ A completer @@@@@@@@@@

	@ Comparaison des deux positions, 0 si égales, 1 sinon
	cmp r0, r1
	moveq r0, #0
	movne r0, #1

@@@@@@@@@@@ ----------- @@@@@@@@@@

    ldmfd sp!, {r4-r12, lr}
    mov   sp, r12
    mov   pc, lr

@@ @brief uint32_t hamming_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Hamming distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global hamming_distance_asm
hamming_distance_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

    @@@@@@@@@@@ A completer @@@@@@@@@@

    @ Stock le résultat qui sera retourné dans r0
    mov r4, #0

	@ Récupération de Y grâce à un masque
	movw r5, #0xFFFF
	and r2, r0, r5
	and r3, r1, r5

	@ Compraison des positions X, ajout de 1 au résultat si différentes
	cmp r2, r3
	addne r4, #1

	@ Récupération de X grâce à un shift à droite de 16 positions
    mov r2, r0, lsr #16
    mov r3, r1, lsr #16

	@ Compraison des positions X, ajout de 1 au résultat si différentes
	cmp r2, r3
	addne r4, #1

    mov r0, r4

@@@@@@@@@@@ ----------- @@@@@@@@@@

    ldmfd sp!, {r4-r12, lr}
    mov   sp, r12
    mov   pc, lr

@@ @brief uint32_t manhattan_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Manhattan distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global manhattan_distance_asm
manhattan_distance_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

    @@@@@@@@@@@ A completer @@@@@@@@@@

	@ Stock le résultat qui sera retourné dans r0
	mov r4, #0

	@ Récupération de Y grâce à un masque
	movw r5, #0xFFFF
	and r2, r0, r5
	and r3, r1, r5

	@ Compare les valeurs pour vérifier laquelle est plus grande. Soustrait la plus petite à la plus grande
	@ La différence est mise dans le registre stockant le résultat
    cmp r2, r3
    subge r4, r2, r3
   	sublt r4, r3, r2

	@ Récupération de X grâce à un shift à droite de 16 positions
   	mov r2, r0, lsr #16
    mov r3, r1, lsr #16

	@ Compare les valeurs pour vérifier laquelle est plus grande. Soustrait la plus petite à la plus grande.
	@ Résultat stocké dans un registre intermédiaire pour ne pas overwrite le résultat courant dans r4
    cmp r2, r3
    subge r2, r2, r3
   	sublt r2, r3, r2

	@ Calcul du résultat final
	add r4, r4, r2

    mov r0, r4

@@@@@@@@@@@ ----------- @@@@@@@@@@

    ldmfd sp!, {r4-r12, lr}
    mov   sp, r12
    mov   pc, lr

@@ @brief uint32_t ssd_semi_distance_asm(const uint32_t a, const uint32_t b)
@@ Computes the Sum of Squared Differences semi distance between a and b
@@ @param a (r0)
@@ @param b (r1)
@@ @return distance in r0
.global ssd_semi_distance_asm
ssd_semi_distance_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

    @@@@@@@@@@@ A completer @@@@@@@@@@

	@ Stock le résultat qui sera retourné dans r0
	mov r4, #0

	@ Récupération de Y grâce à un masque
	movw r5, #0xFFFF
	and r2, r0, r5
	and r3, r1, r5

	@ Compare les valeurs pour vérifier laquelle est plus grande. Soustrait la plus petite à la plus grande
	@ La différence est mise dans le registre stockant le résultat
    cmp r2, r3
    subge r4, r2, r3
   	sublt r4, r3, r2

	@ Mise au carré de la différence des positions Y
   	mul r4, r4, r4

	@ Récupération de X grâce à un shift à droite de 16 positions
   	mov r2, r0, lsr #16
    mov r3, r1, lsr #16

	@ Compare les valeurs pour vérifier laquelle est plus grande. Soustrait la plus petite à la plus grande.
	@ Résultat stocké dans un registre intermédiaire pour ne pas overwrite le résultat courant dans r4
    cmp r2, r3
    subge r2, r2, r3
   	sublt r2, r3, r2

	@ Mise au carré de la différence des positions X
	mul r2, r2, r2

	@ Calcul du résultat final
	add r4, r4, r2

    mov r0, r4

@@@@@@@@@@@ ----------- @@@@@@@@@@

    ldmfd sp!, {r4-r12, lr}
    mov   sp, r12
    mov   pc, lr




@@ @brief uint32_t get_directions_asm(const char* map, const uint32_t position)
@@ Returns possible directions given a position on a map
@@ @param pointer on map (r0)
@@ @param position (r1)
@@ @return possible directions
.equiv MAP_SIZE_X, 8
.equiv MAP_SIZE_Y, 10
.equiv WALL, 0x57
.equiv NORTH_MASK, 0x8
.equiv EAST_MASK, 0x2
.equiv WEST_MASK, 0x1
.equiv SOUTH_MASK, 0x4

.global get_directions_asm
get_directions_asm:
	mov   r12, sp
    stmfd sp!, {r4-r12, lr}

    @@@@@@@@@@@ A completer @@@@@@@@@@

	@ Récupérer X et Y du joueur
	lsr r2, r1, #16      @ r2 contient X
	movw r5, #0xFFFF
    and r3, r1, r5		 @ r3 contient Y

	@ Stocke les directions possibles
	mov r4, #0

	@ Stocke la largeur de map dans un registre pour l'utilisée dans l'opérations de multiplication (ne prend que des registres)
	mov r6, #MAP_SIZE_Y

	@ Calcul de l'offset du joueur sur la map
	mla r5, r6, r2, r3

	@ Ajout de l'offset à l'adresse de base de la map pour avoir l'adresse en mémoire du joueur
	add r5, r0

check_north:

	@ Vérifie qu'on ne soit pas collé au bord supérieur de la map, si c'est le cas on passe au check suivant
	cmp   r2, #0
	beq   check_east

	@ Monte vers le nord d'une case
	sub r7, r5, #MAP_SIZE_Y

	@ Récupère le caractère qui se situe à l'adresse de la nouvelle case
	ldrb r7, [r7]

	@ Vérifie si c'est un mur, si ce n'est pas le cas on modifie le registre des directions possibles
	cmp r7, #WALL
	orrne r4, r4, #NORTH_MASK


check_east:

	@ Vérifie qu'on ne soit pas collé au bord droit de la map, si c'est le cas on passe au check suivant
	cmp   r3, #(MAP_SIZE_Y - 1)
	beq   check_west

	@ Avance vers la droite d'une case
	add r7, r5, #1

	@ Récupère le caractère qui se situe à l'adresse de la nouvelle case
	ldrb r7, [r7]

	@ Vérifie si c'est un mur, si ce n'est pas le cas on modifie le registre des directions possibles
	cmp r7, #WALL
	orrne r4, r4, #EAST_MASK

check_west:

	@ Vérifie qu'on ne soit pas collé au bord gauche de la map, si c'est le cas on passe au check suivant
	cmp   r3, #0
	beq   check_south

	@ Avance vers la gauche d'une case
	sub r7, r5, #1

	@ Récupère le caractère qui se situe à l'adresse de la nouvelle case
	ldrb r7, [r7]

	@ Vérifie si c'est un mur, si ce n'est pas le cas on modifie le registre des directions possibles
	cmp r7, #WALL
	orrne r4, r4, #WEST_MASK

check_south:

	@ Vérifie qu'on ne soit pas collé au bord inférieur de la map, si c'est le cas on passe au check suivant
	cmp   r2, #(MAP_SIZE_X - 1)
	beq   result

	@ Descend vers le sud d'une case
	add r7, r5, #MAP_SIZE_Y

	@ Récupère le caractère qui se situe à l'adresse de la nouvelle case
	ldrb r7, [r7]

	@ Vérifie si c'est un mur, si ce n'est pas le cas on modifie le registre des directions possibles
	cmp r7, #WALL
	orrne r4, r4, #SOUTH_MASK

result:

	@ Copie du résultat final dans le registre de retour
    mov r0, r4

@@@@@@@@@@@ ----------- @@@@@@@@@@

    ldmfd sp!, {r4-r12, lr}
    mov   sp, r12
    mov   pc, lr
