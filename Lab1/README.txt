Rahul Vaidun
rvaidun
Winter 2021
Lab 1:
-----------
DESCRIPTION
This lab utilizes the program MMLogic to build 5 different circuits for the 3 different parts of the lab. The first circuit solves part A of the lab and connects 4 input switches to a 7 segment display allowing you to display numbers from 0-15. The second circuit solves part B of the lab and it solves follows the following truth table:

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

The third circuit solves the following circuit using Sum of Products (SOP) using AND and OR gates (output to c_0).

in_2 in_1 in_0  | c_0
 0    0    0    |  1
 0    0    1    |  0
 0    1    0    |  0
 0    1    1    |  1
 1    0    0    |  0
 1    0    1    |  1
 1    1    0    |  1
 1    1    1    |  0

The 4th and 5th circuit solve the same truth table using only NAND gates (output to c_1) and only NOR gates (output to c_2) respectively.
-----------
FILES
-
Lab1.lgi
This file is the MMLogic schematic file. The file contains all the input switches, outputs and circuits.
-----------
INSTRUCTIONS
This program is intended to be run using MMLogic. Open MMLogic and click the green play button to run the simulation of the circuit.