Rahul Vaidun
rvaidun
Winter 2021
Lab 4: Syntax Checker

-----------
DESCRIPTION

This program will tell you if the ([{ of a particular file are matching and have )]}
This program accepts a program argument. The program argument should be the file name

-----------
FILES

-
Lab4.asm
This file is the assembly file and contains the MIPS assembly code to check the braces
-
test1.txt
1st Test file for the syntax checker
-
test2.txt
2nd Test file for the syntax checker
-
test3.txt
3rd Test file for the syntax checker
-----------
INSTRUCTIONS
This program is intended to be run using MARS IDE for MIPS.
1. Open the MARS MIPS simulator
2. From the simulator go to file -> open and open the Lab4.asm file
3. From the menu bar go to Run -> Assemble
4. Now go to Run -> Go
5. The program output is in the bottom console.

You can also run the program from the Command Line with the following command:
java -jar PATH_TO_JAR_FILE Lab4.asm  nc pa TEST.txt
"nc" specifies not to print the copyright message
everything after the "pa" are the Program Arguments, in this case "TEST.txt"