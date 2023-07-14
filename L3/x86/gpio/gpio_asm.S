 # Author : Alexis Martins

.global asm_config_register

# int asm_config_register(int gpio_reg)
# input gpio_reg in eax
# output in eax
asm_config_register:
        pushl %ebp                # Save old stack frame
        movl  %esp, %ebp          # Set new stack base
        movl  8(%ebp), %eax       # copy the argument in eax
        pushl %ebx

        ########## A completer ##########

		movl %eax, %edx

        # gpio_reg &= ~(unsigned int)0x1;
        andl $0xFFFFFFFE, %edx

		# gpio_reg |= 0xF << 4;
		orl $0x000000F0, %edx

		# gpio_reg &= ~UPPER_BYTE_MASK;
        andl $0x00FFFFFF, %edx

		# gpio_reg |= (0x66 << 3*8);
        orl $0x66000000, %edx

		# gpio_reg /= 8;
        sarl $3, %edx

        # gpio_reg = (gpio_reg | 0xA5) & (0xFFEEDD << 3);
        movl $0xFFEEDD, %ebx

        sall $3, %ebx

        movl $0x000000A5, %ecx

        orl %edx, %ecx

        andl %ebx, %ecx

        movl %ecx, %edx

        movl %edx, %eax


exit:
        popl  %ebx
        leave                     # Restore stack frame
        ret                       # Return to caller
