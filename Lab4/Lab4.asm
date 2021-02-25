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
#                        Saved Registers:
# $s0 - file name
# $s1 - address of opened file (file descriptor)
# $s2 - amount of items in stack
# $s3 - position of the file
# $s4 - matching pairs
############################################################################
.data
    enterMsg:           .asciiz "You entered the file:\n"
    errorInvalidArg:    .asciiz "ERROR: Invalid program argument.\n"
    errorMisMatch1msg:     .asciiz "ERROR - There is a brace mismatch: "
    errorMisMatch2msg:     .asciiz " at index "
    errorStack:         .asciiz "ERROR - Brace(s) still on stack: "
    successmsg:         .asciiz "SUCCESS: There are "
    successmsg2:        .asciiz " pairs of braces."
    newline:            .asciiz "\n"
    filebuffer:         .space 2
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

    # Open File
    move $a0, $s0      # move file name to arguments
    li $a1, 0          # set to read
    li $a2, 0          # set mode to 0
    li $v0, 13         # prepare to open_file
    syscall
    move $s1, $v0      # save file descriptor to $s1, address of opened file
    li $s2, 0          # $s2 stack counter
    li $s3, 0          # $s3 current file position
    li $s4, 0          # $s4 matching pairs
    loopBuffer:
    jal readFileToBuffer # read file to buffer. Will return amount of bytes in buffer in $v0
    beqz $v0, fileFinished
    move $a0, $v0        # pass bytes in buffer to readFile
    jal readFile         # read each byte of buffer
    j loopBuffer

############################################################################
# Procedure: readFile
# Description: for each byte in current buffer save to stack if bracket and check if brace mismatch exists
# registers to be used:
#   $t0 - counter for times looped through current buffer,
#   $t1 - max amount of loops
#   $t2 - file buffer
#   $t3 - byte we are looking at
#   $t4 - top byte from stack
#   $t5 - temporarily save $ra in this register
############################################################################
readFile:
    li $t0, 0          # $t0 is the amount of times we looped through current buffer
    move $t1, $a0      # $t1 is max amount of times we can loop
    la $t2, filebuffer # load address of file buffer to $t2
    # Start loop
    readFileLoop:
    beq $t0, $t1, return # if reached max amount of loops return
    
    lb $t3, ($t2) # $t3 is the byte we are looking at

    # Check if byte is an open bracket ([{
    # ascii for ([{ is 40, 91, 123 respectively
    beq $t3, 40, openbyte
    nop
    beq $t3, 91, openbyte
    nop
    beq $t3, 123, openbyte
    nop
    afteropenbyte:
    # Check if byte is a closed bracket
    # ascii for )]} is 41, 93, 125 respectively
    beq $t3, 41, closebyte
    nop
    beq $t3, 93, closebyte
    nop
    beq $t3, 125, closebyte
    nop
    afterclosebyte:
    addi $t0, $t0, 1 # add 1 to counter
    addi $t2, $t2, 1 # add 1 to file address
    addi $s3, $s3, 1 # add 1 to file position
    j readFileLoop

    # openbyte: Add $t3 to stack since it is an open byte
    openbyte:
    addi $sp, $sp, -1 # make space in the stack for 1 byte
    sb $t3, ($sp) # store $t3 to stack
    addi $s2, $s2, 1 # add 1 to stack counter
    j afteropenbyte
    
    # closebyte: Check if there is matching byte in stack. If byte exists pop from stack. Else error and exit
    closebyte:
    beqz $s2, printMisMatchError # print mis match error if no items in stack
    nop
    lb $t4, ($sp) # store top of stack in $t4

    # check for ()
    bne $t3, 41, closebyte2 # if current bracket is not ) go to close byte 2
    nop
    bne $t4, 40, closebyte2 # if not ( go to close byte 2
    nop
    move $t5, $ra # save ra in r5
    jal popStack # go to popstack
    move $ra, $t5 # restore ra
    j afterclosebyte

    closebyte2: # check for []
    bne $t3, 93, closebyte3
    nop 
    bne $t4, 91, closebyte3
    nop
    move $t5, $ra # save ra in r5
    jal popStack # go to popstack
    move $ra, $t5 # restore ra
    j afterclosebyte

    closebyte3: # check for {}
    bne $t3, 125, closebyte4
    nop
    bne $t4, 123, closebyte4
    nop
    move $t5, $ra # save ra in r5
    jal popStack # go to popstack
    move $ra, $t5 # restore ra
    j afterclosebyte

    closebyte4: # if none of the brace pairs are matching print mismatch error
    j printMisMatchError

    popStack:
    addi $sp, $sp, 1 # adding space back to stack
    addi $s4, $s4, 1 # add 1 to matching pairs
    addi $s2, $s2, -1 # remove 1 brace from brace counter
    jr $ra
############################################################################
# Procedure: readFile
# Description: read the file to buffer
# registers to be used:
#   $s1 - address of opened file
#   $v1 - return amount of bytes in buffer
############################################################################
readFileToBuffer:
    move $a0, $s1
    la $a1, filebuffer
    li $a2, 2
    li $v0, 14
    syscall
    jr $ra
############################################################################
# Procedure: fileFinished
# Description: check if stack still has braces and print appropriate message
# registers to be used:
#   $s2 - total amount of braces in stack
#   $s1 - file descriptor
#   $t0 - counter for stack
############################################################################
fileFinished:
    move $a0, $s1
    li $v0, 16
    syscall # Close the open file
    beqz $s2, printSuccess
    li $t0, 0

    # If stack is not empty print error message with the stack error message
    la $a0, errorStack
    li $v0, 4
    syscall # print first part of message
    stackloop:
        beq $t0, $s2, afterstackloop
        lb $a0, ($sp) # load top of stack to $a0
        addi $sp, $sp, 1 # add 1 to stack
        li $v0, 11
        syscall # print character
        addi $t0, $t0, 1
        j stackloop

    afterstackloop:
    la $a0, newline
    li $v0, 4
    syscall
    j Exit

printSuccess:
    la $a0, successmsg
    li $v0, 4
    syscall # print first part of message message
    
    move $a0, $s4
    li $v0, 1
    syscall # print matching pairs ($s4)

    la $a0, successmsg2
    li $v0, 4
    syscall # print second part of message

    la $a0, newline
    li $v0, 4
    syscall # print newline

    j Exit
############################################################################
# Procedure: firstNumber
# Description: Check if the first character is a number and if true then print error
# registers to be used:
#   $t0 - first character
#   $t1, $t2 - Boolean to check if character falls between specific ascii range
#   $t3 - AND of $t1, $t2
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
    j printInvalidArg

############################################################################
# Procedure: validFileName
# Description: Checks if each character is valid, a-z A-Z 0-9 . _ 
# AND checks if length is greater than 20
# registers to be used:
#   $t0 - filename
#   $t1 - counter for length of file
#   $t2 - current character
#   $t3, $t4 - Boolean to check if character falls specific between ascii range
#   $t5 - AND of $t3, $t4
############################################################################
validFileName:
    move $t0, $s0      # t0 is filename
    li $t1, 0          # t1 is counter for length of file
    validFileNameLoop:
        lb $t2, 0($t0) # t2 is current character
        beqz $t2, return # if we are done with string return
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
        j printInvalidArg

############################################################################
# Procedure: printMisMatchError - Only works when called only from readFile
# Description: prints mismatch error
# registers to be used:
#   $s3 - position in file
#   $t3 - Bracket that is mismatched. Value set in readFile
############################################################################
printMisMatchError:
    la $a0, errorMisMatch1msg
    li $v0, 4
    syscall # print first part of error message

    move $a0, $t3
    li $v0, 11
    syscall # print the character that is mismatched

    la $a0, errorMisMatch2msg
    li $v0, 4
    syscall # print the second part of error message

    move $a0, $s3
    li $v0, 1
    syscall # print the index of the mismatch

    la $a0, newline
    li $v0, 4
    syscall # new line
    j Exit

printInvalidArg:
    la $a0, errorInvalidArg
    li $v0, 4
    syscall
    j Exit

return:
    jr $ra
Exit:
    li $v0, 10         # preparation to exit
    syscall            # exit the program
