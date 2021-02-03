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
#        												Pseudocode
# infinite loop:
# 	prompt user to enter height of pattern
# 	if number greater than 0:
# 		printTriangle
# 		break the infinte loop
#		else print error message
# printTrinagle:
# for x from 0 to height:
# 	for y from 0 to (x1)*2-1:
# 		if y equals x print x+1 and a tab
#			else print a star and a tab
# 	print a newline
.data
	prompt:		.asciiz "Enter the height of the pattern (must be greater than 0): "
	star:		.asciiz "*\t"
	newline:	.asciiz "\n"
	tab:		.asciiz "\t"
	errmsg:		.asciiz "Invalid entry!\n"

.text
main:
	j ValidNum
	
	j Exit

ValidNum:
	la $a0, prompt # $a0 = address of prompt
	li $v0, 4 # preparation to call print_string()
	syscall # call print_string()
	
	li $v0, 5 # preparation to call read_int()	
	syscall # call read_int()
	move $s0, $v0 # $s0 = height of pattern
	
	bgt $s0, $zero, printTriangle # if $s0 > 0, go to printTriangle Else error message and go to ValidNum
	la $a0, errmsg # $a0 = address of errmsg
	li $v0, 4 # preparation to call print_string()
	syscall # call print_string()
	j ValidNum
printTriangle:
	li $t0, 0 # $t0 is x, counter for outside loop, $s0 is end
	start_outer_loop:
		beq $t0, $s0, end_outer_loop
	# Inner loop
	li $t1, 0 # Beginning of inner loop (y)
	addi $t2, $t0, 1
	mul $t2, $t2, 2
	addi $t2, $t2, -1 #$t2 is stopping point for inner loop
	start_inner_loop:
		beq $t1, $t2, end_inner_loop
		beq $t0, $t1, printNum
		inner_after_printNum:
		bne $t0, $t1, printStar
		inner_after_printStar:
		addi $t1, $t1, 1 # Increment counter

printNum:
	move $a0, $t0 # $a0 = x
	li $v0, 1 # prepare system to print_int()
	syscall # call print_int()
	j inner_after_printNum
printStar:
	move $a0, star
	li $v0, 4
	syscall

Exit:
	li $v0, 10 # preparation to exit
	syscall # exit the program