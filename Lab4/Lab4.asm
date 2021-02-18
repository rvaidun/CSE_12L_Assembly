##########################################################################
# Created by: Vaidun, Rahul
# rvaidun
# 2 February 2021
#
# Lab 4: Syntax Checker
# CSE12/L, Computer Systems and Assembly Language
# UC Santa Cruz, Winter 2021
#
# Description: This program will print take a file name as an argument and perform syntax checks.
#
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################
#                            Pseudocode
# print "You entered file " arg
# if first character of arg is digit or "." or "_": print "ERROR: Invalid program argument." exit
# if length of arg > 20: print "ERROR: Invalid program argument." exit
# allowed_characters = abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890._
# for c in arg:
#   if c not in in allowed_characters: print "ERROR: Invalid program argument." exit
# open file and store to variable (file)
# if length of file == 0 print "SUCCESS: There are 0 pairs of braces."
# for char in file:
#   if char is an opening bracket ({[ then add char to stack
# else if char is an closing bracket, )}]:
#       if (length of stack > 0) AND char is the same as last character saved to stack:
#           pop from stack
#       else print "ERROR - There is a brace mismatch: {char} at index {i}\n"
# if length of stack == 0 print "SUCCESS: There are {count} pairs of braces.\n
# else: print "ERROR - Brace(s) still on stack: {braces}\n"
##########################################################################
.data
    enterMsg:           .asciiz "You entered the file:\n"
    errorInvalidArg:    .asciiz "ERROR: Invalid program argument.\n"
    errorMisMatch1:     .asciiz "ERROR - There is a brace mismatch: "
    errorMisMatch2:     .asciiz " at index "
    errorStack:         .asciiz "ERROR - Brace(s) still on stack: "
    newline:            .asciiz "\n"
.text
main:
    la $a0, enterMsg
    li $v0, 4
    syscall            # print enterMsg
    
    lw $s0, 0($a1)     # $s0 is the filename
    move $a0, $s0
    li $v0, 4
    syscall            # print the file name

    la $a0, newline
    li $v0, 4
    syscall            # print new line
    la $a0, newline
    li $v0, 4
    syscall            # print new line

    jal firstNumber

    jal validFileName
    j Exit
############################################################################
# Procedure: firstNumber
# Description: Check if the first character is a number and if true then print error
# registers to be used:
#   $t0 is first character
#   $t1, $t2, $t3 are used to check of number falls in the proper ascii range
#   $ra to jump register to main
############################################################################
firstNumber:
    # Check for uppsercase letters
    lb $t0, 0($s0)     # $t0 = first character of file name
    sge $t1, $t0, 65   # if $t0 >= 65 then $t1 = 1 else $t1 = 0
    sle $t2, $t0, 90   # if $t0 <= 90 then $t2 = 1 else $t2 = 0
    and $t3, $t1, $t2  # $t1 ^ $t2 stored in $t3
    beq $t3, 1, return # if $t3 is true go to main
    nop
    # Check for lowercase letters
    sge $t1, $t0, 97   # if $t0 >= 65 then $t1 = 1 else $t1 = 0
    sle $t2, $t0, 122  # if $t0 <= 90 then $t2 = 1 else $t2 = 0
    and $t3, $t1, $t2  # $t1 ^ $t2 stored in $t3
    beq $t3, 1, return # if $t3 is true go to main
    nop
    # print error message and exit
    la $a0, errorInvalidArg
    li $v0, 4
    syscall
    j Exit

############################################################################
# Procedure: validFileName
# Description: Checks if each character is valid, a-z A-Z 0-9 . _ 
# AND checks if length is greater than 20
# registers to be used:
#   $t0 is first character
#   $t1, $t2, $t3 are used to check of number falls in the proper ascii range
#   $ra to jump register to main
############################################################################
validFileName:
    move $t0, $s0      # t0 is filename
    li $t1, 0          # t1 is counter for length of file
    validFileNameLoop:
        lb $t2, 0($t0) # t2 is current character
        addi $t1, $t1, 1 # increment counter
        beq $t1, 20, printInvalidArg
        addi $t0, $t0, 1 # increment file name


        # Check for uppsercase letters. ascii A-Z is 65-90 decimal
        sge $t3, $t2, 65   # if $t2 >= 65 then $t3 = 1 else $t3 = 0
        sle $t4, $t2, 90   # if $t2 <= 90 then $t4 = 1 else $t4 = 0
        and $t5, $t3, $t4  # t3 ^ $t4 stored in $t5
        beq $t5, 1, validFileNameLoop # if $t5 is true go to top of loop
        nop
        # Check for lowercase letters. ascii a-z is 97-122 decimal
        sge $t3, $t2, 97   
        sle $t4, $t2, 122   
        and $t5, $t3, $t4
        beq $t5, 1, validFileNameLoop
        nop
        # Checks for numbers. ascii 0-9 is 48-57 decimal
        sge $t3, $t2, 48   
        sle $t4, $t2, 57   
        and $t5, $t3, $t4  
        beq $t5, 1, validFileNameLoop
        nop
        # Checks for periods. ascii . is 46
        seq $t3, $t2, 46
        beq $t3, 1, validFileNameLoop
        nop
        # Checks for underscore. ascii _ is 95
        seq $t3, $t2, 95
        beq $t3, 1, validFileNameLoop
        nop

        # if none of the checks pass print error exit
        printInvalidArg:
        la $a0, errorInvalidArg
        li $v0, 4
        syscall
        j Exit

    validCharacter:
    

return:
    jr $ra
Exit:
    li $v0, 10         # preparation to exit
    syscall            # exit the program
