##########################################################################
# Created by: Vaidun, Rahul
# rvaidun
# 2 February 2021
#
# Lab 3: ASCII-risks (Asterisks)
# CSE12/L, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2021
#
# Description: This program will print out a pattern with numbers and stars (asterisks).
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################
#                            Pseudocode
# infinite loop:
# 	prompt user to enter height of pattern
# 	if number greater than 0:
# 		printTriangle
# 		break the infinte loop
#		else print error message
#
# printTrinagle:
# for x from 0 to height:
# 	for y from 0 to (x+1)*2-1:
# 		if y equals x: print x+1
#		else: print a star
#		if y+1 not equal to end point for the loop ((x+1)*2-1): print a tab
# 	print a newline
##########################################################################
#                         Register Usage
# $s0: user input (height) also stopping point for outer loop
# $t0: counter for outside loop (x in the pseudocode)
# $t1:  counter for inner loop (y in the pseudocode)
# $t2: stopping point for the inner loop
# $t3: $t1 + 1, used to check if tab is necessary
##########################################################################
.data
	prompt:		.asciiz "Enter the height of the pattern (must be greater than 0):\t"
	star:		.asciiz "*"
	newline:	.asciiz "\n"
	tab:		.asciiz "\t"
	errmsg:		.asciiz "Invalid entry!\n"

.text
main:
	la $a0, prompt 	               # $a0 = address of prompt
	li $v0, 4                      # preparation to call print_string()
	syscall                        # call print_string()
	
	li $v0, 5                      # preparation to call read_int()	
	syscall                        # call read_int()
	move $s0, $v0                  # $s0 = height of pattern
	
	bgt $s0, $zero, printTriangle  # if $s0 > 0, go to printTriangle Else error message and go to main
	nop
	la $a0, errmsg                 # $a0 = address of errmsg
	li $v0, 4                      # preparation to call print_string()
	syscall                        # call print_string()
	j main
printTriangle:
	li $t0, 0                      # $t0 is x, counter for outside loop, $s0 is end
	start_outer_loop:
		beq $t0, $s0, Exit         # if $t0 is equal to $s0 exit
		nop
	###################### inner loop #######################
		li $t1, 0                       # beginning of inner loop (y)
		addi $t2, $t0, 1                # add $t0 and $t1 and store in $t2
		mul  $t2, $t2, 2                # multiply $t2 and $t2 and store in $t2
		addi $t2, $t2, -1               # subtract 1 from $t2, $t2 is stopping point for inner loop
		start_inner_loop:
			beq $t1, $t2, end_inner_loop   # stop inner loop if $t1 = $t2
			nop
			beq $t0, $t1, printNum         # if $t0 = $t1 print the current height ($t0+1)
			nop
			inner_after_printNum:
			bne $t0, $t1, printStar        # if $t1 not equal to $t1 print a star
			nop
			inner_after_printStar:
			addi $t3, $t1, 1               # $t3 = $t1 + 1 (y+1)
			bne $t3, $t2, printTab         # if $t3 not equal to $t2 then print a tab
			nop
			inner_after_printTab:
			addi $t1, $t1, 1               # increment counter for inner loop
			b start_inner_loop             # go back to start of inner loop
			nop
		end_inner_loop:
	###################### inner loop #######################
	la $a0, newline                # set $a0 to newline
	li $v0, 4                      # prepare system to print_string()
	syscall                        # call print_string()
	addi $t0, $t0, 1               # increment counter
	b start_outer_loop             # go back to start of outer loop
	nop

printNum:
	addi $a0, $t0, 1               # store addition of register $t0 and 1 in $a0
	li $v0, 1                      # prepare system to print_int()
	syscall                        # call print_int()
	b inner_after_printNum         # go back to inner loop
	nop
printStar:
	la $a0, star                   # load star address to $a0  
	li $v0, 4                      # prepare system for print_string()
	syscall                        # call print_string()
	b inner_after_printStar        # go back to inner loop
	nop
printTab:
	la $a0, tab                    # load tab address to $a0
	li $v0, 4                      # prepare system for print_string()
	syscall                        # call print_string
	b inner_after_printTab         # go back to inner loop
	nop

Exit:
	li $v0, 10                     # preparation to exit
	syscall                        # exit the program
