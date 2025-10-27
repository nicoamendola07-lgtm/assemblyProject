# Monmouth University CS-104 project 1: type command in assembly (Linux)

.intel_syntax noprefix		# Please keep this
.text				# Please keep this
.globl	main			# Please keep this
main:				# Start of the main function
	# In the main function, we will set up the logic to open a file
	# and give ourself space to read the letters in the file we open.
	# main is a special name: it tells the computer that this is the
	# function to execute first.

	# I will break up all the sub-problems into their own little
	# paragraphs. Feel free to come to office hours if you want to
	# debug your program and your thinking with me.

	# Remember when we talked about registers? What are registers?
	# We can also say that registers are effectively built-in variables
	# that we always have access to.
	# On x86_64 machines, we have 16 registers. But we don't need all
	# of them. Here is the list of the ones we need:
	# rax, rbx, rdx, rdi, rsi, rsp
	# All of the registers except for rsp can hold exactly one 64-bit
	# number. rsp is special. When our program starts, it can't hold
	# anything! We need to write code to make it hold data. How much
	# data can rsp hold? As much as we want! It's up to you.

	# There are also a lot (several hundred) instructions that your
	# CPU understands. But we won't need anywhere near that many.
	# Here are the ones we need:
	# mov, add, sub, cmp, jmp, je, jne, jl, jge
	# You may find that you don't even need all of these. That's OK.

	# x86_64 assembly is a little awkward. It uses two operands for
	# arithmetic operations. Let's say we want to add 3 to the rax
	# register. To do that, we would say:
	# add rax, 3
	# That translates to rax <-- rax + 3, or "add 3 to rax and store
	# the result back into rax"
	# The rest are straightforward. Here are some examples:
	# mov rax, rbx (means rax <-- rbx, or "copy the value of rbx
	# into rax
	# cmp rdi, 1 (means "compare the value of rdi with 1")
	# je main (means "jump to the main function if the previous cmp
	# was in fact equal")

	# Let's start by checking to see if we have 2 arguments
	# The number of arguments we have lives in register rdi
	# If we don't have exactly 2 arguments, go to the error function

	cmp rdi, 2
	jne error

	mov	rdi, [rsi + 8]	# Get file name to open

	# The line above puts the file name in the first argument
	# The rdi register always holds the first argument for a function
	# Now, we should tell the open function to read the file
	# How did we say to do that in class?
	# The second argument is always put into the rsi register

	mov	rax, 2		# Put 2 (open) into function number
	syscall			# Call open with 2 arguments

	# Here, we need to check the number that the open
	# function gives back to us.
	# If the number is less than 0, we should go to the error functon
	# Whenever a function gives you back a number, that number will
	# live in the rax register.

	cmp rax, 0
	jl error

	# Now, we should save the number the open function gave back to us
	# Let's save it to the rbx register (for reasons outside this
	# class, it needs to be the rbx register; come talk to me
	# during office hours if you are curious why).
	mov rbx, rax
	# The last sub-problem to solve in the main function is to give
	# ourselves some space to store the letters we read from the file.
	# We will use rsp for this. Remember that when our program starts,
	# rsp can't hold anything. In order to store values into rsp, we
	# need to *subtract* rsp by the amount of data we want to store.
	# I know that sounds weird but just go with it (why it's
	# subtract and not add is beyond the scope of this class).
	# How many bytes do we need to store one ASCII character? Give
	# yourself at least that many bytes of storage space.
	sub rsp, 1
loop:				# Start of the loop function
	# The loop function is where all the real work happens.
	
	# The first sub-problem is putting the value we saved to rbx
	# into the first argument for read.
	mov rdi, rbx
	# Next, we put the value of rsp into the second argument. 
	mov rsi, rsp
	# Finally, we put 1 into rdx. The rdx register is always the
	# third argument for a function.
	mov rdx, 1
	mov	rax, 0		# Put 0 (read) into function number
	syscall			# Call read with 3 arguments

	# Now we check the number the read function gave back to us
	# If it is 0, we should go to the done function because it
	# means we successfully read every character from the file
	# and put every character on the screen.
	# If it is less than 0, we should go to the error function
	# because it means something bad happened.
	cmp rax, 0
	je done
	jl error
	# After we read in a letter, we need to put that letter on
	# the screen.
	# To do that: put 1 in the first argument, put the value of
	# rsp in the second argument, and put 1 in the third argument
	# A 1 in the first argument is shorthand for the screen
	mov rdi, 1
	mov rsi, rsp
	mov rdx, 1
	mov rax, 1
	mov	rax, 1		# Put 1 (write) into function number
	syscall			# Call write with 3 arguments

	# Now we need to check to see if the number we got back from
	# the write function is 1. If it is not equal to 1, then we
	# should go to the error function because it means something
	# bad happened.
	cmp rax, 1
	jne error
	# Last sub-problem for the loop function: if we got all the
	# way here, it means everything was successful for this
	# letter and we should jump back to the top of the loop
	# function so we can do it all again with the next letter.
	jmp loop
done:				# Start of the done function
	# Here, put 0 into the first argument
	# If a program exits with 0, that means it was successful
	mov rdi, 0
	mov	rax, 60		# Put 60 (exit) into function number
	syscall			# Call exit with an argument of 0
error:				# Start of the error function
	mov	rdi, 1		# Put 1 into first argument
	mov	rax, 60		# Put 60 (exit) into function number
	syscall			# Call exit with an argument of 1
