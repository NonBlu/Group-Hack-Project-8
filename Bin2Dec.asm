//========================================================================================================
// Bin2Dec.asm
//========================================================================================================
// Created by: Aiden Sallows, Aidan Ramirez, Caroline Zheng, Koki Pettigrew
//========================================================================================================
// The purpose of this function is to receive a 16 digit binary number in 2's complement.
// The program will then convert this binary value to a decimal value
// The decimal value will also be preceeded by a +/- to indicicate whether it is positive or negative. 
// The user can enter on of the following keys:
// 1 - enters a 1 into the program. Can only be done if less than 16 binary digits have been entered.
// 0 - enters a 0 into the program. Can only be done if less than 16 binary digits have been entered.
// c - clears the screen, resetting the process of entering a binary number.
// q - clears the screen and ends the program.
// enter - can only be used once all 16 binary digits have been entered. This executes the conversion
//         of the binary number to decimal. If pressed again after this, it will reset the program
//         back to the beginning
//=======================================================================================================

//=======================================================================================================
// Variables
// ge_currentColumn  - Tracks the cursor/column
// as_processBufBool - Determines whether or not the buffer has been processed. 
//                     Used for enter key parsing
// as_userInput      - Stores the ASCII value of the key the user has entered
//=======================================================================================================

//Variable Initialization
@ge_currentColumn 
M=0

@as_processBufBool
M=0

//Sets the function call to return to main once completed
@main
D=A
@as_mainReturn
M=D

//Execute as_getKey function
@as_getKey
0;JMP

//=======================================================================================================
// main
//=======================================================================================================
// Contains parsing statements that determine which function to execute, depending on the key the
// user entered. 
//=======================================================================================================
(main)
    //first check if ge_currentColumn is <=15
    //This is to determine if the user has already entered in 16 bits 
    @ge_currentColumn
    D=M
    @15
    D=A-D // 16 - (any num <= 16) will be >= 0

    //Calls the as_checkOneZero function if bits <= 16
    @as_checkOneZero
    D;JGE 

    //ELSE bits are greater than 16 entered OR entry was not a 0 or 1
    (as_continueInputValidation)
        //Now we check to see if a backspace was entered
        //if so, execute cz_backspace
        @as_getKey //if input is a 129, call cz_delBuf, then return to as_getKey
        D=A
        @cz_return
        M=D //kp_return will now return to as_getKey

        @129
        D=A
        @as_userInput
        D=M-D //129-129 = 0
        @cz_delBuf
        D;JEQ

        //Else, backspace has not been entered

        //now check if c has been entered
        //if input is a 67, call as_clearBuf, then return to as_getKey
        @as_getKey 
        D=A
        @as_return
        M=D //kp_return will now return to as_getKey

        @67
        D=A
        @as_userInput
        D=M-D //67-67 = 0
        @as_clearBuf
        D;JEQ //executes jump if input is 67

        //Else, c has not been entered
        
        //now check if q has been entered
        //if input is a 81, call as_clearBuf, then end the program
        @END 
        D=A
        @as_return
        M=D //as_return will now return to as_getKey

        @81
        D=A
        @as_userInput
        D=M-D //81-81 = 0
        @as_clearBuf
        D;JEQ //executes jump if input is 81

        //Else, q has not been entered

        //Now check to see if bits = 16 and enter has been pressed (input 128)

        //first check if bits is 16 or greater
        //if bits is not 16 or greater, return back to as_getKey

        @ge_currentColumn
        D=M
        @16
        D=A-D
        @as_getKey
        D;JGT //executes if bits is not 16 or greater

        //Else, bits must be 16, which means we check for enter key
        //if enter key has not been pressed, return back to as_getKey
        @128
        D=A
        @as_userInput
        D=M-D //userinput-128 = 0
        @as_getKey
        D;JNE //executes jump if input is not enter

        //This must mean bits is 16 and enter key has been pressed!
        
        //Now we check to see if buf has already been processed.
        //if as_processBufBool = 1, then set it to 0 and execute as_clearBuf
        @as_getKey 
        D=A
        @as_return
        M=D //as_return will now return to as_getKey

        @as_processBufBool
        D=M

        @as_clearBuf
        D;JGT 
        //ELSE, buffer has not been processed
        //Now we call processBuf

        //Set the return of ar_processBuf to kp_outputAll
        //This will then cause the converted decimal number
        // to be output to the screen
        @kp_outputAll
        D=A
        @ar_return
        M=D //ar_return will now return to kp_outputAll

        //call ar_processBuf!
        @ar_processBuf
        0;JMP 
//========================================================================================================
// as_getKey
//========================================================================================================
// Created by: Aiden Sallows
//========================================================================================================
// Scans the keyboard for a user input.
// @KBD will always equal 0 unless the user pressed a key.
// The first loop will break when it detects a keyboard value being entered
// The second loop will break when it detects that a key is no longer being pressed.
//=======================================================================================================
// Variables
//=======================================================================================================
// as_userInput - stores the ASCII value of the character the user has entered.
//=======================================================================================================
(as_getKey) //infinite loop that runs until a valid input is pressed
    @KBD    // get value of keyboard
    D=M

    @as_getKey
    D;JLE //if user enters a value, kbd will no longer be 0
    
    //store user input
    @as_userInput
    M=D
    //Now wait for user to release key
        (as_releaseKey)
        @KBD
        D=M

        //once the keyboard is detected as 0, this loop will break
        @as_releaseKey
        D;JNE
    
    //return to main!
    @as_mainReturn
    A=M
    0;JMP
//========================================================================================================
// ar_processBuf
//========================================================================================================
// Created by: Aidan Ramirez
//========================================================================================================
// 
//=======================================================================================================
// Variables
//=======================================================================================================
//
//=======================================================================================================
(ar_processBuf)
    @as_processBufBool
    M=1 //bool that indicates processBuf has occured

    @ar_decSign
    M=1
    @6
    D=A
    @ar_decTenThous
    M=D
    @4
    D=A
    @ar_decThous
    M=D
    @3
    D=A
    @ar_decHund
    M=D

    @9
    D=A
    @ar_decTens
    M=D

    @4
    D=A
    @ar_decOnes
    M=D

    @ar_return
    A=M
    0;JMP
//========================================================================================================
// as_checkOneZero
//========================================================================================================
// Created by: Aiden Sallows, Koki Pettigrew
//========================================================================================================
// Determines whether the value entered by the user is a 0 or a 1.
// if 0: execute ge_output_0 and then proceed to cz_addBuf
// if 1: execute ge_output_1 and then proceed to cz_addBuf
// else: return back to as_continueInputValidation
//=======================================================================================================
// Variables
//=======================================================================================================
// as_userInput - stores the ASCII value of the character the user has entered.
//=======================================================================================================
(as_checkOneZero) //checks if userInput is 48 or 49 
                      //worked on by Aiden and Koki
    @cz_addBuf //if input is a 48, call kp_outputKey
    D=A
    @ge_output_return
    M=D //kp_return will now return to cz_addBuf

    @48
    D=A
    @as_userInput
    D=M-D //48-48 = 0
    @ge_output_0
    D;JEQ //executes jump if input is 48 (48 equals 0)
        
    //ELSE
    //execute if equal to 49
    D=D-1 //if it is 1, now it is 0
    @ge_output_1
    D;JEQ //executes jump if input was 49

    //ELSE input was not 0 or 1, jump to continue input validation
    @as_continueInputValidation
    0;JMP

//========================================================================================================
// as_clearBuf
//========================================================================================================
// Created by: Aiden Sallows
//========================================================================================================
// Clears the screen and returns the cursor back to the beginning
// This is done through a decrementing loop
// Once finished, screen will be blank, and ge_currentColumn = 0
// Sets as_processBufBool = 0
//=======================================================================================================
// Variables
//=======================================================================================================
// ge_currentColumn  - Tracks the cursor/column
// as_processBufBool - Determines whether or not the buffer has been processed. 
//                     Used for enter key parsing
//=======================================================================================================
(as_clearBuf)   
    //set back to 0 to indicate buffer has not been processed
    @as_processBufBool
    M=0

    //Loop
    //This loop will continue until ge_currentColumn is less than 0
    //As it runs, it will output a blank in the current column, 
    // and then decrement the column
    (as_clearBufLoop)
        //execute ge_output_s function to output a blank
        @as_clearBufLoopCont
        D=A
        @ge_output_return
        M=D
        @ge_output_s
        0;JMP 

        (as_clearBufLoopCont)
        //then decrement current column
        @ge_currentColumn
        M=M-1
        D=M
        @as_clearBufLoop
        D;JGE//Breaks when ge_currentColumn < 0

    //incremement ge_currentColumn back to 0 since it is -1 right now
    @ge_currentColumn
    M=M+1 

    //reset user input
    @as_userInput
    M=0 

    @as_return
    A=M
    0;JMP

//========================================================================================================
// cz_addBuf
//========================================================================================================
// Created by: Caroline Zheng, Aiden Sallows
//========================================================================================================
// Receives the ASCII value entered by the user.
// It will then convert this value into binary.
// Then, using a pointer that points to R0, and incrementing this pointer by ge_currentColumn
// we will store the binary value entered by the 0 into its respective register (R0-R15)
// Finally, it will increment ge_currentColumn
//=======================================================================================================
// Variables
//=======================================================================================================
// as_userInput      - stores the ASCII value of the character the user has entered.
// ge_currentColumn  - Tracks the cursor/column.
// as_processBufBool - Determines whether or not the buffer has been processed. 
//                     Used for enter key parsing.
// as_currentBuf     - Pointer variable used to traverse R0-R15 registers.
// cz_holdPlace      - holds the current location of the register that will be modified.
//=======================================================================================================
(cz_addBuf)

    //Convert ASCII value to binary
    //This is done by subtracting 48 from the ASCII value
    //If the ASCII value is 49, then the binary value is 1
    //If the ASCII value is 48, then the binary value is 0
    @as_userInput
    D=M
    @48
    D=D-A
    @as_toBuf
    M=D
    
    //Initialize as_currentBuf pointer to point at R0
    @0
    D=A
    @as_currentBuf
    M=D 

    //now increment this pointer based on ge_currentColumn
    @as_currentBuf
    D=M
    @ge_currentColumn
    D=D+M 
    //now we have access to register pertaining to column
    //A register currently holds contents of R#, we need store as_userInput into R#
    //M[A] = # is how we store input into R#

    //holds pointer of R#
    @cz_holdPlace 
    M=D

    //take user input and store into R#
    @as_toBuf 
    D=M
    @cz_holdPlace
    A=M
    M=D 
    
    //now we have stored user input into correct register
    //now increment ge_currentColumn then return
    @ge_currentColumn
    M=M+1

    @as_getKey
    0;JMP
//========================================================================================================
// kp_outputAll
//========================================================================================================
// Created by: Koki Pettigrew
//========================================================================================================
// Outputs the decimal value of the converted binary number.
// this will be represented as so:
// ->SXXXXXX
// S : the sign of the decimal value
// X : the decimal value 
// It will then return to as_getKey
//=======================================================================================================
// Variables
//=======================================================================================================
// ge_currentColumn  - Tracks the cursor/column.
// ar_decSign        - sign value of the decimal number
// ar_decTenThous    - ten thousands place of the decimal number
// ar_decThous       - thousands place of the decimal number
// ar_decHund        - hun
// ar_decTens
// ar_decOnes
//=======================================================================================================
(kp_outputAll)

    @16
    D=A
    @ge_currentColumn
    M=D //sets column to 16

    @kp_greaterSign
    D=A
    @ge_output_return
    M=D
    @ge_output_-
    0;JMP //execute eaton function to place a - at column 16

    (kp_greaterSign)

        @17
        D=A
        @ge_currentColumn
        M=D //sets column to 17

        @kp_decSign
        D=A
        @ge_output_return
        M=D
        @ge_output_g
        0;JMP //execute eaton function to place a > at column 17

    (kp_decSign)

        @18
        D=A
        @ge_currentColumn
        M=D //sets column to 18

        @kp_tenThous
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decSign
        D=M //now decide if dec is positive or negative

        @ge_output_+
        D;JEQ //if ar_decSign is 0, output +

        @ge_output_-
        0;JMP //else, output a -

    (kp_tenThous)

        @19
        D=A
        @ge_currentColumn
        M=D //sets column to 19

        @kp_thous
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decTenThous
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decTenThous

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 19

    (kp_thous)

        @20
        D=A
        @ge_currentColumn
        M=D //sets column to 20

        @kp_hund
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decThous
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decThous

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 20

    (kp_hund)
        @21
        D=A
        @ge_currentColumn
        M=D //sets column to 21

        @kp_tens
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decHund
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decHund

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 21

    (kp_tens)
        @22
        D=A
        @ge_currentColumn
        M=D //sets column to 22

        @kp_ones
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decTens
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decTens

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 22

    (kp_ones)
        @23
        D=A
        @ge_currentColumn
        M=D //sets column to 23

        @as_getKey
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decOnes
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decThous

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 17


(kp_outputDec) //this function will receive an input variable labeled kp_currentDec
               //it will execude a switch statement calling one of ge_output_X
    @kp_currentDec
    D=M
    @ge_output_0
    D;JEQ //if kp_currentDec = 0, then output 0 at ge_currentColumn

    D=D-1
    @ge_output_1
    D;JEQ //if kp_currentDec = 1, then output 1 at ge_currentColumn

    D=D-1
    @ge_output_2
    D;JEQ //if kp_currentDec = 2, then output 2 at ge_currentColumn

    D=D-1
    @ge_output_3
    D;JEQ //if kp_currentDec = 3, then output 3 at ge_currentColumn

    D=D-1
    @ge_output_4
    D;JEQ //if kp_currentDec = 4, then output 4 at ge_currentColumn

    D=D-1
    @ge_output_5
    D;JEQ //if kp_currentDec = 5, then output 5 at ge_currentColumn

    D=D-1
    @ge_output_6
    D;JEQ //if kp_currentDec = 6, then output 6 at ge_currentColumn

    D=D-1
    @ge_output_7
    D;JEQ //if kp_currentDec = 7, then output 7 at ge_currentColumn

    D=D-1
    @ge_output_8
    D;JEQ //if kp_currentDec = 8, then output 8 at ge_currentColumn

    D=D-1
    @ge_output_9
    D;JEQ //if kp_currentDec = 9, then output 9 at ge_currentColumn
    
    @kp_return
    A=M
    0;JMP //ends function


//==============EATON'S CODE=====================================
// ge_continue_output
// this helper function ge_continue_output outputs the character defined by
// frontRow1 through initialized below it in the functions ge_output_X
(ge_continue_output)
//
// ***constants***
//
// ge_rowOffset - number of words to move to the next row of pixels
@32
D=A
@ge_rowOffset
M=D
// end of constants
//

//
// ***key variables***
//

// ge_currentRow - variable holding the display memory address to be written,
//                 which starts at the fourth row of pixels (SCREEN + 3 x rowOffset) 
//                 offset by the current column and
//                 increments row by row to draw the character
//               - initialized to the beginning of the fourth row in screen memory
//                 plus the current column
@SCREEN
D=A
@ge_rowOffset
// offset to the fourth row
D=D+M
D=D+M
D=D+M
// add the current column
@ge_currentColumn
D=D+M
@ge_currentRow
M=D
//


// write the first row of pixels
// load pattern in D via A
@ge_fontRow1
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//

// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow2
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow3
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow4
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow5
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow6
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow7
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow8
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow9
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//



// return from function
@ge_output_return
A=M
0;JMP



//
// individual function ge_output_X definitions which are 
// just font definitions for the helper function above
//

//ge_output_0
(ge_output_0)
//do Output.create(12,30,51,51,51,51,51,30,12); // 0

@12
D=A
@ge_fontRow1
M=D

@30
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@51
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@30
D=A
@ge_fontRow8
M=D

@12
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_0

//ge_output_1
(ge_output_1)
//do Output.create(12,14,15,12,12,12,12,12,63); // 1

@12
D=A
@ge_fontRow1
M=D

@14
D=A
@ge_fontRow2
M=D

@15
D=A
@ge_fontRow3
M=D

@12
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@12
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@63
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_1

//ge_output_2
(ge_output_2)
//do Output.create(30,51,48,24,12,6,3,51,63);   // 2

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@24
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@6
D=A
@ge_fontRow6
M=D

@3
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@63
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_2


//ge_output_3
(ge_output_3)
//do Output.create(30,51,48,48,28,48,48,51,30); // 3

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@48
D=A
@ge_fontRow4
M=D

@28
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_3

//ge_output_4
(ge_output_4)
//do Output.create(16,24,28,26,25,63,24,24,60); // 4

@16
D=A
@ge_fontRow1
M=D

@24
D=A
@ge_fontRow2
M=D

@28
D=A
@ge_fontRow3
M=D

@26
D=A
@ge_fontRow4
M=D

@25
D=A
@ge_fontRow5
M=D

@63
D=A
@ge_fontRow6
M=D

@24
D=A
@ge_fontRow7
M=D

@24
D=A
@ge_fontRow8
M=D

@60
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_4

//ge_output_5
(ge_output_5)
//do Output.create(63,3,3,31,48,48,48,51,30);   // 5

@63
D=A
@ge_fontRow1
M=D

@3
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@31
D=A
@ge_fontRow4
M=D

@48
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_5

//ge_output_6
(ge_output_6)
//do Output.create(28,6,3,3,31,51,51,51,30);    // 6

@28
D=A
@ge_fontRow1
M=D

@6
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@3
D=A
@ge_fontRow4
M=D

@31
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_6

//ge_output_7
(ge_output_7)
//do Output.create(63,49,48,48,24,12,12,12,12); // 7

@63
D=A
@ge_fontRow1
M=D

@49
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@48
D=A
@ge_fontRow4
M=D

@24
D=A
@ge_fontRow5
M=D

@12
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@12
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_7


//ge_output_8
(ge_output_8)
//do Output.create(30,51,51,51,30,51,51,51,30); // 8

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@30
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_8



//ge_output_9
(ge_output_9)
//do Output.create(30,51,51,51,62,48,48,24,14); // 9

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@62
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@25
D=A
@ge_fontRow8
M=D

@14
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_9


//ge_output_s
(ge_output_s)
//do Output.create(0,0,0,0,0,0,0,0,0); // space

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@0
D=A
@ge_fontRow4
M=D

@0 // temporarily change to 255 so you can see it
D=A
@ge_fontRow5
M=D

@0
D=A
@ge_fontRow6
M=D

@0
D=A
@ge_fontRow7
M=D

@0
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_s



//ge_output_-
(ge_output_-)
//do Output.create(0,0,0,0,0,63,0,0,0);         // -

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@0
D=A
@ge_fontRow4
M=D

@0
D=A
@ge_fontRow5
M=D

@63 // use 16128 to have minus to the right of the word
D=A
@ge_fontRow6
M=D

@0
D=A
@ge_fontRow7
M=D

@0
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_-


//ge_output_g
(ge_output_g)
//do Output.create(0,0,3,6,12,24,12,6,3);       // >

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@6
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@24
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@6
D=A
@ge_fontRow8
M=D

@3
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_g


//ge_output_+
(ge_output_+)
//do Output.create(0,0,0,12,12,63,12,12,0);     // +

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@12
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@63
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_+

(END)
    @END
    0;JMP  