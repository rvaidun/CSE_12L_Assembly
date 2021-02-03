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
#        			 	Pseudocode
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
.data
	prompt:		.asciiz "Enter the height of the pattern (must be greater than 0):\t"
	star:		.asciiz "*"
	newline:	.asciiz "\n"
	tab:		.asciiz "\t"
	errmsg:		.asciiz "Invalid entry!\n"

.text
main:
	la $a0, prompt # $a0 = address of prompt
	li $v0, 4 # preparation to call print_string()
	syscall # call print_string()
	
	li $v0, 5 # preparation to call read_int()	
	syscall # call read_int()
	move $s0, $v0 # $s0 = height of pattern
	
	bgt $s0, $zero, printTriangle # if $s0 > 0, go to printTriangle Else error message and go to main
	la $a0, errmsg # $a0 = address of errmsg
	li $v0, 4 # preparation to call print_string()
	syscall # call print_string()
	j main
printTriangle:
	li $t0, 0 # $t0 is x, counter for outside loop, $s0 is end
	start_outer_loop:
		beq $t0, $s0, Exit
	# start inner loop
		li $t1, 0 # beginning of inner loop (y)
		addi $t2, $t0, 1
		mul $t2, $t2, 2
		addi $t2, $t2, -1 # $t2 is stopping point for inner loop
		start_inner_loop:
			beq $t1, $t2, end_inner_loop # stop inner loop if $t1 = $t2
			beq $t0, $t1, printNum # if $t0 = $t1 print the current height ($t0+1)
			inner_after_printNum:
			bne $t0, $t1, printStar # if $t1 not equal to $t1 print a star
			inner_after_printStar:
			addi $t3, $t1, 1 # $t3 = $t1 + 1 (y+1_
			bne $t3, $t2, printTab # if $t3 not equal to $t2 then print a tab
			inner_after_printTab:
			addi $t1, $t1, 1 # increment counter for inner loop
			b start_inner_loop # go back to start of inner loop
		end_inner_loop:
	# end inner loop, back in outer loop
	la $a0, newline # set $a0 to newline
	li $v0, 4 # prepare system to print_string()
	syscall # call print_string()
	addi $t0, $t0, 1 # increment counter
	b start_outer_loop # go back to start of outer loop

printNum:
	addi $a0, $t0, 1 # store addition of register $t0 and 1 in $a0
	li $v0, 1 # prepare system to print_int()
	syscall # call print_int()
	j inner_after_printNum # go back to inner loop
printStar:
	la $a0, star # load star address to $a0 
	li $v0, 4 # prepare system for print_string()
	syscall # call print_string()
	j inner_after_printStar # go back to inner loop
printTab:
	la $a0, tab # load tab address to $a0
	li $v0, 4 # prepare system for print_string()
	syscall # call print_string
	j inner_after_printTab # go back to inner loop

Exit:
	li $v0, 10 # preparation to exit
	syscall # exit the program