@ ASM
@ Author :

@@ @brief void show_backtrace() prints the backtrace up to main()
.global show_backtrace
show_backtrace:
        stmfd sp!, {fp, lr}
        add fp, sp, #4

        @@@@@@@@@@@ A completer @@@@@@@@@@

        ldr r0, =backtrace_string
        bl printf

		mov r2, fp					@ Récupère la valeur de fp (adresse de lr)
		movw r5, #1025
		loop:

			ldr r0, =format_string	@ Stocke la string de formatage
			ldr r1, [r2]			@ Récupère l'adresse de retour stockée dans lr
			cmp r1, #-1				@ Condition de fin d'exécution (fin de pile atteinte)
			beq end					@ Saut fin
			stmfd sp!, {r2}			@ Sauvegarde de r2 pour que la fonction printf n'écrive par dessus
			bl printf				@ Appel à printf
			ldmfd sp!, {r2}			@ Restaure r2
			ldr r2, [r2, #-4]		@ Récupère le fp précédent
			b loop					@ Boucle tant que le bas de la pile n'est pas atteint

		end:

	@@@@@@@@@@@ ----------- @@@@@@@@@@
        sub sp, fp, #4
        ldmfd sp!, {fp, pc}

.data

backtrace_string:
        .string "\nBacktrace :\n----\n"

format_string:
        .string "Previous link register : 0x%p\n"
