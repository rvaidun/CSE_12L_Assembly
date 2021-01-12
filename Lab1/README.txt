Rahul Vaidun
rvaidun
Winter 2021
Lab 4:
-----------
DESCRIPTION
This lab utilizes the program MMLogic to build 3 different circuits. The first circuit connects 4 input switches to a 7 segment display allowing you to display numbers from 0-15. The second circuitsolves follows the following truth table:

in_3 in_2 in_1 in_0  |  b_2  b_1  b_0
 0    0    0    0    |   0    0    0
 0    0    0    1    |   1    1    0
 0    0    1    0    |   1    0    0
 0    0    1    1    |   0    1    0
 0    1    0    0    |   0    0    0
 0    1    0    1    |   1    1    0
 0    1    1    0    |   1    0    0
 0    1    1    1    |   0    1    0
 1    0    0    0    |   0    0    0
 1    0    0    1    |   1    1    0
 1    0    1    0    |   1    0    0
 1    0    1    1    |   0    1    0
 1    1    0    0    |   0    0    0
 1    1    0    1    |   1    1    0
 1    1    1    0    |   1    0    0
 1    1    1    1    |   0    1    0
The third circuit solves the following circuit using Sum of Products (SOP)

in_2 in_1 in_0  | c_0
 0    0    0    |  1
 0    0    1    |  0
 0    1    0    |  0
 0    1    1    |  1
 1    0    0    |  0
 1    0    1    |  1
 1    1    0    |  1
 1    1    1    |  0

This is also done using only NAND gates and only NOR gates.
-----------
FILES
-
Lab4.lgi
This file is the MMLogic schematic file. The file contains the input switches, outputs and circuits. 
-----------
INSTRUCTIONS
This program is intended to be run using the MMLogic Simulator. Click the green play button to run the simulation.