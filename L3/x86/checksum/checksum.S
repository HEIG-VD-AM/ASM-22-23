# Author : Alexis Martins

.global parity_word
.global check_parity

# int parity_word(int value)
# input value in eax
# output in eax
parity_word:
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        movl 8(%ebp), %eax              # copy the argument in eax
        pushl %ebx

        ########## A completer ##########

		movl %eax, %ebx

		shrl $8, %ebx
		movw %bx, %cx
		shrl $16, %ebx

		xorb %cl, %bl
		xorb %ch, %bl

		movb %bl, %al

        popl %ebx
        leave                           # Restore stack frame
        ret                             # Return to caller

# int check_word(int value)
# input value in eax
# output in eax
check_parity:
        pushl %ebp                      # Save old stack frame
        movl  %esp, %ebp                # Set new stack base
        movl 8(%ebp), %eax              # copy the argument in eax
        pushl %ebx

        ########## A completer ##########

		movl %eax, %ebx

		shrl $8, %ebx
		movw %bx, %cx
		shrl $16, %ebx

		xorb %cl, %bl
		xorb %ch, %bl

		movl %eax, %edx
		movb %bl, %dl

		subl %edx, %eax

        popl %ebx
        leave                           # Restore stack frame
        ret                             # Return to caller
