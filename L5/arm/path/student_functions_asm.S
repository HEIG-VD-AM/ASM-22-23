@ ASM
@ Author : Alexis Martins

.macro absdif A, B, RES		@ Macro calculating the difference in absolute value

	cmp \A, \B				@ Check which parameter is the biggest and subtract the smallest from the largest
	subge \RES, \A, \B
	sublt \RES, \B, \A

.endm

.macro unpack XY, X, Y		@ Gets X and Y value

	mov \Y, \XY, lsl #16
	mov \Y, \Y, lsr #16
	mov \X, \XY, lsr #16

.endm

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

        @ Retrieving current and destination X and Y values
		unpack r0, r2, r3
		unpack r1, r4, r5

		@ Subtracting X's from each other and Y's from each other
		absdif r2, r4, r6
		absdif r3, r5, r7

		@ Add substraction
		mov r0, r6
		add r0, r7

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

		@ Beginning is equivalent to Manhattan algorithm
   		unpack r0, r2, r3
		unpack r1, r4, r5

		absdif r2, r4, r6
		absdif r3, r5, r7

		@ Multiply differences
		mul r6, r6, r6
		mul r7, r7, r7

		@ Add both multiplications
		mov r0, r6
		add r0, r7

	@@@@@@@@@@@ ----------- @@@@@@@@@@

        ldmfd sp!, {r4-r12, lr}
        mov   sp, r12
        mov   pc, lr

