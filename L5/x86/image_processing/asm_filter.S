        # Authors : Alexis Martins
        # File    : asm_filter.S
        # Date    :
        # AT&T Syntax

#include "image_processing.h"

.globl asm_filter
.type asm_filter, @function
.extern edge_detection_3x3

.macro pixel_pos_offset reg						# Calculates the offset for a given pixel position

        movl  (y), \reg
        imull (width), \reg
        addl  (x), \reg
.endm

.macro check_borders pos min max 				# Check if the given position is between the limits

        cmpl \min, \pos 						# Checks the min side
        je copy_pixel

        cmpl \max, \pos						# Checks the max side
        je copy_pixel
.endm

.text
        # Function arguments :
        # ebp + 8  : address of source image data (pointer to unsigned 8 bits)
        # ebp + 12 : address of destination image data (already allocated)
        # ebp + 16 : width of the image (signed 32 bits)
        # ebp + 20 : height of the image (signed 32 bits)
        # ebp + 24 : x position of pixel (signed 32 bits)
        # ebp + 28 : y position of pixel (signed 32 bits)

asm_filter:
        pushl %ebp                      		# Save old stack frame
        movl  %esp, %ebp                		# Set new stack base
        pushl %esi                      		# Save registers
        pushl %edi                      		# Save registers
        pushl %ebx                      		# Save registers

        # Copy of the arguments for easier access
        movl 8(%ebp),   %esi            		# esi is for source
        movl 12(%ebp),  %edi            		# edi is for destination

        movl 16(%ebp),  %eax
        movl %eax,      (width)         		# width holds the width parameter
        movl 20(%ebp),  %eax
        movl %eax,      (height)        		# height holds the height parameter
        movl 24(%ebp),  %eax
        movl %eax,      (x)             		# x holds the x position
        movl 28(%ebp),  %eax
        movl %eax,      (y)             		# y holds the y position


check_if_on_border:

        # TODO : Check if the current pixel is on the border of the image
        # when on border jump to copy_pixel else continue

        movl (x), %eax
		movl (width), %ebx
		decl %ebx
		movl $0, %ecx

		check_borders %eax, %ecx, %ebx

        movl (y), %eax
		movl (height), %ebx
		decl %ebx

		check_borders %eax, %ecx, %ebx

conv_filter:

        # TODO : Implement the convolution filter

		# Description of the iteration for each matrix :
		#
		#   Pixel matrix from the picture   		 	Edge detection matrix
		#   +-----+-----+-----+  						+-----+-----+-----+
		#   |     |     |     |  						|  x -->    |     |
		#   +-----+-----+-----+  						+-----+-----+-----+
		#   |     |     |     |  						|     |     |     |
		#   +-----+-----+-----+  						+-----+-----+-----+
		#   |     |    <-- x  |  						|     |     |     |
		#   +-----+-----+-----+  						+-----+-----+-----+


		pixel_pos_offset %ebx					# Calculates pixel offset
		movl %esi, %ecx							# Stores base address of the picture in ecx
		addl %ebx, %ecx							# Moves to the pixel at the position (x,y)
		incl  %ecx								# The two next instructions will move the pointer to the pixel on the lower right corner of the current pixel
		addl (width), %ecx

		movl $edge_detection_3x3, %eax			# Get the edge detection matrix address

		movl $0, %edx							# Init the register that stores the result
        movl $0, (line_cnt)						# Init the line iterator for the line_loop
        movl $0, (element_cnt)					# Init the element iterator for the element_loop

		line_loop:
			element_loop:
				movl %edx, (accumulator_buffer)	# Stores the value of the accumulator to use edx below
				movsbl (%eax), %ebx				# Gets the current byte from the kernel and extends the sign (values can be negative)
				movzbl (%ecx), %edx				# Gets the current byte from the picture and extends with zeros (value 0-255)
				imull %edx, %ebx				# Multiply both values
				movl (accumulator_buffer), %edx	# Gets the temporary value of the accumulator back from the buffer
				addl %ebx, %edx					# Add the current multiplication to the accumulator
				incl %eax						# Go to the next value in the kernel matrix (forward)
				decl %ecx						# Go to the next value the picture matrix (backward)
				incl element_cnt				# Increments element counter on the line
				cmpl $MATRIX_SIDE,(element_cnt)	# Check if reached the end of the current line
				jne element_loop				# If the end is not reached yet, do another iteration

			incl (line_cnt)						# Increment counter to pass to the next line
			movl $0, (element_cnt)				# Reset element counter
			addl $MATRIX_SIDE, %ecx				# The two next instructions are for replacing the pointer at the end of the next line
			subl (width), %ecx
			cmpl $MATRIX_SIDE, (line_cnt)		# Check if we have iterated over the whole matrix
			jne line_loop						# If we are not at the end start a loop_line


		check_neg:								# Checks if the value is negative and apply an absolute value, otherwise jumps to the next check
			cmpl $0, %edx
			jge check_max
			negl %edx

		check_max:								# Check if we are greater than the maximum and set value to max, otherwise jumps to the end part
			cmpl $MAX_BYTE, %edx
			jle end_if
			movl $MAX_BYTE, %edx

		end_if:									# Copy the result in the res space and set the value of the pixel at the destination address
			movl %edx, (res)

			pixel_pos_offset %ecx

			movl %edi, %ebx
	        addl  %ecx, %ebx
            movl %edx, (%ebx)



exit:
	    popl %ebx                       		# Restore registers
	    popl %edi       	        			# Restore registers
		popl %esi                       		# Restore registers
		leave                           		# Restore stack frame
		ret                             		# Return to caller

copy_pixel:

		# TODO : Copy pixel from source to destination image

	    pixel_pos_offset %ecx					# Calculates the offset for the position (x,y)

		movl %esi, %eax							# The two following instrutions place the pointer on the right pixel (source)
	    addl  %ecx, %eax

		movl %edi, %ebx							# The two following instrutions place the pointer on the right pixel (dest)
	    addl  %ecx, %ebx

		movl (%eax), %ecx						# Copy from source to dest
	    movl %ecx, (%ebx)

    jmp exit                        			# exit

.bss
        # Block Started by Symbol Section
        # space is 4 bytes because the values are 32 bit

width:                                  # image width
        .space 4
height:                                 # image height
        .space 4
x:                                      # x position of pixel
        .space 4
y:                                      # y position of pixel
        .space 4
res:                                    # result of convolution
        .space 4
line_cnt:								# Loop iterator for each line
		.space 4
element_cnt:							# Loop iterator for each element in a line
		.space 4
accumulator_buffer:						# Temporary stores the accumulator to use the edx register (which is the register with accumulator value)
		.space 4

.data

.equiv MATRIX_SIDE, 3					# Side of a matrix
.equiv MAX_BYTE, 	255					# Maximal value used for a pixel
