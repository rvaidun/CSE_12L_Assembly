# Winter 2021 CSE12 Lab5 Template
######################################################
# Created by: Vaidun, Rahul
# rvaidun
# 2 February 2021
#
# Lab 5: Functions and Graphics
# CSE12/L, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2021
#
# Description: This program utilizes macros and procedures to show colors on the bitmap display.
#
# Notes: This program is intended to be run from the MARS IDE.
######################################################
# Macros for instructor use (you shouldn't need these)
######################################################
# 					Pseudocode
# MACROS
# getCoordinates(input,x,y):
# 	x = 0x000000FF and input (create a mask)
# 	y = right logical shift of input by 16
#
# formatCoordinates(output, x, y):
# 	output = left logical shift of x by 16
# 	output = bitwise or of output and y
# 	return output
# getPixelAddress(output x y origin):
# 	output = origin + 4 * (x + 128 * y)
# 	return output
# PROCEDURES
# clear_bitmap(color):
# 	for x from 0 to 128:
# 		for y from 0 to 128:
# 			getPixelAddress(address,x,y,originAddress)
# 			address value  = color
#
# draw_pixel(coordinate, color):
# 	getCoordinates(coordinate, x, y) (x and y get returned)
# 	getPixelAddress(address,x,y,originAddress)
# 	address value = color
#
# get_pixel(coordinate):
# 	getCoordinates(coordinate, x, y)
# 	getPixelAddress(address,x,y,originAddress)
# 	return color at address
#
# draw_horizontal_line(y,color):
# 	for x from 0 to 128:
# 		getPixelAddress(address,x,y,originAddress)
# 		address value = color
#
# draw_vertical_line(x,color):
# 	for y from 0 to 128:
# 		getPixelAddress(address,y,x,originAddress)
# 		address value = color
#
# draw_crosshair(coordinates, newcolor):
# 	getPixelAddress(address,x,y,originAddress)
# 	originalcolor = value at address
# 	draw_horizontal_line(y,color)
# 	draw_vertical_line(x,color)
# 	draw_pixel(coordinates, originalcolor)
######################################################
# 				Register Usage
# All Procedures other than draw_crosshair use only t registers as temporary values
# Procedures use $a registers to take in arguments
# Procedures use $v registers to when returning
######################################################
# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	and %y, %input, 0x000000FF # do an AND of the input and 0x000000FF to create a mask
	srl %x, %input, 16 # do a right logical sift of input by 16 to only keep the XX values
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %output, %x, 16 # Do a left logical shift of %x by 16 to get it in correct position for output
	or %output, %output, %y # Or the output and y since output is now currently all 0 except for XX. Acts as a mask
	
.end_macro 

# Macro that converts pixel coordinate to address
# 	output = origin + 4 * (x + 128 * y)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%origin: register containing address of (0, 0)
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y %origin)
	# YOUR CODE HERE
	mul %output, %y, 128 # multiply y and 128 - store in output
	add %output, %x, %output # add x and output - store in output
	mul %output, %output, 4 # multiply output by 4
	add %output, %output, %origin # add the origin to the output
.end_macro


.data
originAddress: .word 0xFFFF0000

.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
# Register usage:
# 	$t0 - x coordinate
# 	$t1 - y coordinate
# 	$t2 - Origin Address
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0, 0 # x
	lw $t2, originAddress
	clear_bitmap_loop1:
		beq $t0, 128, clear_bitmap_end
		nop
		li $t1, 0 # y
		clear_bitmap_loop2:
			beq $t1, 128, clear_bitmap_loop2_end
			nop

			getPixelAddress($v0,$t0,$t1,$t2)
			sw $a0, 0($v0) # save color to address
			addi $t1, $t1, 1 # increment $t1
			j clear_bitmap_loop2
		clear_bitmap_loop2_end:
		addi $t0, $t0, 1 # increment $t0
		j clear_bitmap_loop1
	clear_bitmap_end:
 	jr $ra

#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
# Register usage:
# 	$t0 - x coordinate
# 	$t1 - y coordinate
# 	$t2 - originAddress
# 	$t3 - output address
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	getCoordinates($a0, $t0, $t1) # x is $t0, y is $t1
	lw $t2, originAddress
	getPixelAddress($t3,$t0,$t1,$t2) # output is $t3
	sw $a1, ($t3) # Store color in t3
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
# Register usage:
# 	$t0 - x coordinate
# 	$t1 - y coordinate
# 	$t2 - originaddress
# 	$t3 pixel address
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	lw $t2, originAddress
	getCoordinates($a0, $t0, $t1) # x is $t0, y is $t1
	getPixelAddress($t3, $t0, $t1, $t2) # output is $t3
	lw $v0, ($t3) # return value at $t3
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
# Register usage:
# 	$t0 - x coordinate
# 	$t1 - pixel address
# 	$t2 - originaddress
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0, 0 # x
	lw $t2, originAddress
	draw_horizontal_line_loop:
		beq $t0, 128, draw_horizontal_line_loop_end
		getPixelAddress($t1, $t0, $a0, $t2) # $t1 is return
		sw $a1, ($t1) # store value at $t1 to $a1
		addi $t0, $t0, 1
		j draw_horizontal_line_loop
	draw_horizontal_line_loop_end:
 	jr $ra


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
# Register usage:
# 	$t0 - y coordinate
# 	$t1 - pixel address
# 	$t2 - originaddress
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	li $t0, 0 # y
	lw $t2, originAddress
	draw_vertical_line_loop:
		beq $t0, 128, draw_vertical_line_loop_end
		getPixelAddress($t1, $a0, $t0, $t2) # $t1 is return
		sw $a1, ($t1) # store value at $t1 to $a1
		addi $t0, $t0, 1
		j draw_vertical_line_loop
	draw_vertical_line_loop_end:
 	jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
# Register usage:
# 	$s0 - Coordinates/origin address
# 	$s1 - color
# 	$s2 - x coordinate
# 	$s3 - y coordinate
# 	$s4 - pixel address
#*****************************************************
draw_crosshair: nop
	push($ra)
	push($s0)
	push($s1)
	push($s2)
	push($s3)
	push($s4)
	push($s5)
	move $s5 $sp

	move $s0 $a0  # store 0x00XX00YY in s0
	move $s1 $a1  # store 0x00RRGGBB in s1
	getCoordinates($a0 $s2 $s3)  # store x and y in s2 and s3 respectively
	
	# get current color of pixel at the intersection, store it in s4
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	lw $s0, originAddress
	 getPixelAddress($s4, $s2, $s3, $s0) # Get pixel address and store in $s4
	 lw $s4, ($s4) # Store value of address $s4 to $s4
	# draw horizontal line (by calling your `draw_horizontal_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s3 # set parameter to y
	move $a1, $s1 # set parameter to 0x00RRGGBB
	jal draw_horizontal_line
	# draw vertical line (by calling your `draw_vertical_line`) function
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	move $a0, $s2 # set parameter to x
	move $a1, $s1 # set parameter to 0x00RRGGBB
	jal draw_vertical_line
	# restore pixel at the intersection to its previous color
	# YOUR CODE HERE, only use the s0-s4 registers (and a, v where appropriate)
	formatCoordinates($s0, $s2, $s3)
	move $a0, $s0 # set parameter to 0x00XX00YY
	move $a1, $s4 # set parameter to color
	jal draw_pixel
	move $sp $s5
	pop($s5)
	pop($s4)
	pop($s3)
	pop($s2)
	pop($s1)
	pop($s0)
	pop($ra)
	jr $ra
