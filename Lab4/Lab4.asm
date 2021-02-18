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
    j Exit
### Check if the first character is a number and if true then print error ###
firstNumber:
    # Check for uppsercase letters
    lb $t0, 0($s0)     # $t0 = first character of file name
    sge $t1, $t0, 65   # if $t0 >= 65 then $t1 = 1 else $t1 = 0
    sle $t2, $t0, 90   # if $t0 <= 90 then $t2 = 1 else $t2 = 0
    and $t3, $t1, $t2
    bne $t2, $t3, firstNumber2
    nop
    jr $ra
    firstNumber2:
    # Check for lowercase letters
    sge $t1, $t0, 97   # if $t0 >= 65 then $t1 = 1 else $t1 = 0
    sle $t2, $t0, 122   # if $t0 <= 90 then $t2 = 1 else $t2 = 0
    and $t3, $t1, $t2
    bne $t2, $t3, firstNumber3
    nop
    jr $ra
    firstNumber3:
    # print error message and exit
    la $a0, errorInvalidArg
    li $v0, 4
    syscall
    j Exit
Exit:
    li $v0, 10         # preparation to exit
    syscall            # exit the program