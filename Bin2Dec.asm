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

@ar_input
M=0
    //initialize variables
    @ar_decSign
    M=0

    @ar_decTenThous
    M=0

    @ar_decThous
    M=0

    @ar_decHund
    M=0

    @ar_decTens
    M=0

    @ar_decOnes
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
        //Now check to see if backspace is entered
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
// cz_delBuf
//========================================================================================================
// Created by: Caroline Zheng
//========================================================================================================
// Once a backspace has been received from the user, this function will execute.
// The function will check if buffer has been processed. If it has, then the program will return back
// to as_getKey.
// Else, decrement ge_currentColumn and output a blank!
// Then, return to as_getKey
//=======================================================================================================
// Variables
//=======================================================================================================
// ge_currentColumn  - Tracks the cursor/column
// as_processBufBool - Determines whether or not the buffer has been processed. 
//                     Used for enter key parsing
//=======================================================================================================
(cz_delBuf)
    //checks to see if buffer has been processed
    //if it has, do nothing and get new key
    //if ge_currentColumn == 0, then jump to getKey

    @ge_currentColumn
    D=M
    @as_getKey
    D;JEQ
    
    @as_processBufBool
    D=M

    @as_getKey
    D;JGT
 
    @ge_currentColumn
    //Decrements Column
    M=M-1

    @as_getKey //set return to cz_return
    D=A
    @ge_output_return
    M=D

    @ge_output_s
    0;JMP //Execute eaton function to output a blank
//========================================================================================================
// ar_processBuf
//========================================================================================================
// Created by: Aidan Ramirez
//========================================================================================================
// Given 16 inputs,, each input will be stored in variables R[0..15]. 
// The function detects whether a 1 or 0 value is present, where a value of 1 adds its respective decimal
// value into a single variable named input. Negative variables and special cases are accounted for with 
// the use of if-statements and 2's complement. The function will output the correct single binary word 
// from these single inputs through the variable ar_decimalWord. 
//=======================================================================================================
// Variables
//=======================================================================================================
// ar_input - single binary word that accumulates the values stored in the inputs, later to be transferred
//            into R16
//  ar_decNegativeBool - marker to determine whether a change regarding a negative binary number must 
//                       be completed
// ar_decimalWord - output for the function. Input is assigned to this variable once all of the changes
                    have occured, meaning the word is complete and ready for conversion.
//=======================================================================================================
(ar_processBuf)
    @ar_input
    M=0

    //check if sign is negative.
    //if it is negative, set @as_decNegativeBool to 1
    //else, have it be 0
    @as_decNegativeBool
    M=0

    //Check R0 to see the binary is positive or negative
    @R0
    D=M
    //If it is 0 jump to ar_add_16384
    @ar_Add_32768
    D;JEQ

    //Else, we are dealing with a negative number
    @as_decNegativeBool
    M=1
    (ar_Add_32768)

        //Check if R1 has a value of 1
        // If not, jump straight to Add_16384, there is no value here
        
        @R0
        D=M
        @ar_Add_16384
        D;JEQ

        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_32768
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @16384
        D=-A
        @ar_input
        M=D+M
        @16384
        D=-A
        @ar_input
        M=D+M //do double because 16384 + 16384 = 32768 

        @as_decNegativeBool
        M=0
    
        //continue to 16384
        @ar_Add_16384
        0;JMP

        (as_positive_Add_32768)
        // @16384
        // D=A
        // @ar_input
        // M=D+M

        //continue to 16384
        @ar_Add_16384
        0;JMP
    
    (ar_Add_16384)

        //Check if R1 has a value of 1
        // If not, jump straight to Add_8192, there is no value here
        
        @R1
        D=M
        @ar_Add_8192
        D;JEQ

        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_16384
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @16384
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
    
        //continue to 8192
        @ar_Add_8192
        0;JMP

        (as_positive_Add_16384)
        @16384
        D=A
        @ar_input
        M=D+M

        //continue to 8192
        @ar_Add_8192
        0;JMP

    (ar_Add_8192)
        //Check if R2 has a value of 1
        // If not, jump straight to Add_8192, there is no value here
        
        @R2
        D=M
        @ar_Add_4096
        D;JEQ

        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_8192
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @8192
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 4096
        @ar_Add_4096
        0;JMP

        (as_positive_Add_8192)
        
        // Else, add equivalent amount to ar_input
        
        @8192
        D=A
        @ar_input
        M=D+M

        //continue to 4096
        @ar_Add_4096
        0;JMP


    (ar_Add_4096)
    //Check if R3 has a value of 1
        // If not, jump straight to Add_2048, there is no value here
        
        @R3
        D=M
        @ar_Add_2048
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_4096
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @4096
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 2048
        @ar_Add_2048
        0;JMP

        (as_positive_Add_4096)
        // Else, add equivalent amount to ar_input
        @4096
        D=A
        @ar_input
        M=D+M

        //continue to 2048
        @ar_Add_2048
        0;JMP



    (ar_Add_2048)
        //Check if R4 has a value of 1
        // If not, jump straight to Add_512, there is no value here
        
        @R4
        D=M
        @ar_Add_1024
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_2048
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @2048
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 1024
        @ar_Add_1024
        0;JMP

        (as_positive_Add_2048)
        // Else, add equivalent amount to ar_input
        @2048
        D=A
        @ar_input
        M=D+M

        //continue to 1024
        @ar_Add_1024
        0;JMP


    (ar_Add_1024)
        //Check if R5 has a value of 1
        // If not, jump straight to Add_512, there is no value here
        
        @R5
        D=M
        @ar_Add_512
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_1024
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @1024
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 512
        @ar_Add_512
        0;JMP

        (as_positive_Add_1024)
        // Else, add equivalent amount to ar_input
        @1024
        D=A
        @ar_input
        M=D+M

        //continue to 512
        @ar_Add_512
        0;JMP


    (ar_Add_512)
        //Check if R6 has a value of 1
        // If not, jump straight to Add_256, there is no value here
        
        @R6
        D=M
        @ar_Add_256
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_512
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @512
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 256
        @ar_Add_256
        0;JMP

        (as_positive_Add_512)
        // Else, add equivalent amount to ar_input
        @512
        D=A
        @ar_input
        M=D+M

        //continue to 256
        @ar_Add_256
        0;JMP

    (ar_Add_256)
        //Check if R7 has a value of 1
        // If not, jump straight to Add_128, there is no value here
        
        @R7
        D=M
        @ar_Add_128
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_256
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @256
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 128
        @ar_Add_128
        0;JMP

        (as_positive_Add_256)
        // Else, add equivalent amount to ar_input
        @256
        D=A
        @ar_input
        M=D+M

        //continue to 128
        @ar_Add_128
        0;JMP


    (ar_Add_128)
        //Check if R8 has a value of 1
        // If not, jump straight to Add_64, there is no value here
        
        @R8
        D=M
        @ar_Add_64
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_128
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @128
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 64
        @ar_Add_64
        0;JMP

        (as_positive_Add_128)
        // Else, add equivalent amount to ar_input
        @128
        D=A
        @ar_input
        M=D+M

        //continue to 64
        @ar_Add_64
        0;JMP


    (ar_Add_64)
    //Check if R9 has a value of 1
        // If not, jump straight to Add_32, there is no value here
        
        @R9
        D=M
        @ar_Add_32
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_64
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @64
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 32
        @ar_Add_32
        0;JMP

        (as_positive_Add_64)
        // Else, add equivalent amount to ar_input
        @64
        D=A
        @ar_input
        M=D+M

        //continue to 32
        @ar_Add_32
        0;JMP

    (ar_Add_32)
        //Check if R10 has a value of 1
        // If not, jump straight to Add_16, there is no value here
        
        @R10
        D=M
        @ar_Add_16
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_32
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @32
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 16
        @ar_Add_16
        0;JMP

        (as_positive_Add_32)
        // Else, add equivalent amount to ar_input
        @32
        D=A
        @ar_input
        M=D+M

        //continue to 16
        @ar_Add_16
        0;JMP

    (ar_Add_16)
    //Check if R11 has a value of 1
        // If not, jump straight to Add_8, there is no value here
        
        @R11
        D=M
        @ar_Add_8
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_16
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @16
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 8
        @ar_Add_8
        0;JMP

        (as_positive_Add_16)
        // Else, add equivalent amount to ar_input
        @16
        D=A
        @ar_input
        M=D+M

        //continue to 8
        @ar_Add_8
        0;JMP

    (ar_Add_8)
        //Check if R12 has a value of 1
        // If not, jump straight to Add_4, there is no value here
        
        @R12
        D=M
        @ar_Add_4
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_8
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @8
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 4
        @ar_Add_4
        0;JMP

        (as_positive_Add_8)
        // Else, add equivalent amount to ar_input
        @8
        D=A
        @ar_input
        M=D+M

        //continue to 4
        @ar_Add_4
        0;JMP

    (ar_Add_4)
        //Check if R13 has a value of 1
        // If not, jump straight to Add_2, there is no value here
        
        @R13
        D=M
        @ar_Add_2
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_4
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @4
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 2
        @ar_Add_2
        0;JMP

        (as_positive_Add_4)
        // Else, add equivalent amount to ar_input
        @4
        D=A
        @ar_input
        M=D+M

        //continue to 2
        @ar_Add_2
        0;JMP


    (ar_Add_2)
        //Check if R14 has a value of 1
        // If not, jump straight to Add_1, there is no value here
        
        @R14
        D=M
        @ar_Add_1
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_2
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @2
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to 1
        @ar_Add_1
        0;JMP

        (as_positive_Add_2)
        // Else, add equivalent amount to ar_input
        @2
        D=A
        @ar_input
        M=D+M

        //continue to 1
        @ar_Add_1
        0;JMP


    (ar_Add_1)
        //Check if R15 has a value of 1
        // If not, jump straight to SORTDEC, there is no value here
        
        @R15
        D=M
        @ar_CheckSignBit
        D;JEQ
        //Check to see if leading nonzero bit has been negated
        //if yes, skip
        //else, negate value and set as_decNegativeBool to 1
        @as_decNegativeBool
        D=M
        @as_positive_Add_1
        D;JEQ //if value is 1, means we must negate.
        
        //Else, negate input and add to value
        @1
        D=-A
        @ar_input
        M=D+M
        @as_decNegativeBool
        M=0
        //continue to ar_CheckSignBit
        @ar_CheckSignBit
        0;JMP

        (as_positive_Add_1)
        // Else, add equivalent amount to ar_input
        @1
        D=A
        @ar_input
        M=D+M

        //continue to SORTDEC
        @ar_CheckSignBit
        0;JMP

    (ar_CheckSignBit)

        //Check R0 to see the binary is positive or negative
        @R0
        D=M
        //If it is 0 jump to ENTER_R16
        @ar_ENTER_R16
        D;JEQ

        //Check for special case
        @ar_input
        D=M
        
        //If equal to zero, jump to special case
        @ar_SpecialCase
        D;JEQ
        
        //Else begin 2's complement on ar_input

        // 1's complement
        // @ar_input 
        // D=M
        // D=-D
        // M=D
        //     //Add 1
        // @ar_input 
        // M=M+1
        
        //Jump to ENTER_R16
        @ar_ENTER_R16
        0;JMP

    (ar_SpecialCase)
        @16384
        D=-A
        
        @ar_decimalWord
        M=D
        
        @16384
        D=-A

        @ar_decimalWord
        M=D+M

        @as_splitDecimalWord
        0;JMP


    (ar_ENTER_R16)
        @ar_input 
        D=M
        @ar_decimalWord
        M=D

    //Now our decimal word has been stored in ar_decimalWord

//========================================================================================================
// as_splitDecimalWord
//========================================================================================================
// Created by: Aidan Ramirez
//========================================================================================================
// Given a decimal word, the digits are marked and placed into their respective positions, ready to 
// identified for output. This is done through repetitious division of the decimal eqiuvalent of the binary
// word by powers of 10, each quotient marked into its approrpriate equation. 
//=======================================================================================================
// Variables
//=======================================================================================================
// ar_processBufBool - indicates processBuf has occured, used for later functions. 
// ar_decTenThous - Number in Ten Thousands Digit
// ar_decThous - Number in Thousands Digit
// ar_decHund - Number in Hundreds digit
// ar_decTen - Number in Tens digit
// ar_decOnes - Number in Ones digit
// ar_decSign - Holds a 1 or 0 to represent a negative or positive decimal respectively.
// ar_quotient - Holds quotient to place into appropriate digit functions during division phase
// ar_dividend - Holds number to be divided to find ar_quotient
// ar_divisor - Holds number to divide by to find ar_quotient
// ar_remainder - Holds the remainder after division, either replacing ar_dividend or ar_decOnes 
//                eventually
// as_algoReturn - Returns value of quotient after the algo function is run, representing an output. 
//=======================================================================================================
    (as_splitDecimalWord)
    @as_processBufBool
    M=1 //bool that indicates processBuf has occured

    //initialize variables
    @ar_decSign
    M=0

    @ar_decTenThous
    M=0

    @ar_decThous
    M=0

    @ar_decHund
    M=0

    @ar_decTens
    M=0

    @ar_decOnes
    M=0

    //evaluate decimalword value
    @ar_decimalWord
    D=M

    //if dividend is 0, end program.
    @ar_return
    A=M
    D;JEQ

    //else check if dividend is negative
    @ar_BeginDiv //jump if decimal word is greater than 0
    D;JGT

    //Else it must be negative
    @ar_decSign
    M=1 //now indicates that decimal word is negative
    @ar_decimalWord
    M=-M //temp word is now positive

    (ar_BeginDiv)
        //Dividend is always going to be positive
        //Set divisor to 10,000 then store quotiant into ar_decTenThous
        //then set dividend = remainder and lower divisor by one dec place
        //repeat
        @ar_quotient
        M=0 //quotient = 0

        @ar_decimalWord
        D=M
        @ar_dividend
        M=D //ar_dividend = ar_tempWord

        @10000
        D=A
        @ar_divisor
        M=D //ar_divisor = 10000

        @ar_decTenThousAlgo
        D=A
        @as_algoReturn
        M=D //set as_algoReturn to ar_decTenThousAlgo

        @as_ALGO1
        0;JMP

        (ar_decTenThousAlgo)
            //right now ar_quotient holds value of ar_decTenThous
            //compute:
            //ar_decTenThous = ar_quotient
            //ar_quotient = 0
            //ar_dividend = ar_remainder
            //ar_divisor = 1000
            //call algo 1
            @ar_quotient
            D=M
            @ar_decTenThous
            M=D //ar_decTenThous = ar_quotient

            @ar_quotient
            M=0 //ar_quotient = 0

            @ar_remainder
            D=M
            @ar_dividend
            M=D //ar_dividend = ar_remainder

            @1000
            D=A
            @ar_divisor
            M=D //ar_divisor = 1000

            @ar_decThousAlgo
            D=A
            @as_algoReturn
            M=D //set as_algoReturn to ar_decTenThousAlgo

            @as_ALGO1
            0;JMP

        (ar_decThousAlgo)
            //right now ar_quotient holds value of ar_decThous
            //compute:
            //ar_decThous = ar_quotient
            //ar_quotient = 0
            //ar_dividend = ar_remainder
            //ar_divisor = 1000
            //call algo 1
            @ar_quotient
            D=M
            @ar_decThous
            M=D //ar_decThous = ar_quotient

            @ar_quotient
            M=0 //ar_quotient = 0

            @ar_remainder
            D=M
            @ar_dividend
            M=D //ar_dividend = ar_remainder

            @100
            D=A
            @ar_divisor
            M=D //ar_divisor = 100

            @ar_decHundAlgo
            D=A
            @as_algoReturn
            M=D //set as_algoReturn to ar_decHundAlgo

            @as_ALGO1
            0;JMP
        (ar_decHundAlgo)
            //right now ar_quotient holds value of ar_decHund
            //compute:
            //ar_decHund= ar_quotient
            //ar_quotient = 0
            //ar_dividend = ar_remainder
            //ar_divisor = 10
            //call algo 1
            @ar_quotient
            D=M
            @ar_decHund
            M=D //ar_decTenThous = ar_quotient

            @ar_quotient
            M=0 //ar_quotient = 0

            @ar_remainder
            D=M
            @ar_dividend
            M=D //ar_dividend = ar_remainder

            @10
            D=A
            @ar_divisor
            M=D //ar_divisor = 10

            @ar_decTensAlgo
            D=A
            @as_algoReturn
            M=D //set as_algoReturn to ar_decHundAlgo

            @as_ALGO1
            0;JMP
        (ar_decTensAlgo)
            //right now ar_quotient holds value of ar_decTens
            //compute:
            //ar_decTens = ar_quotient
            //ar_decOnes = ar_remainder
            @ar_quotient
            D=M
            @ar_decTens
            M=D //ar_decTenThous = ar_quotient

            @ar_remainder
            D=M
            @ar_decOnes
            M=D
            //Now done!
            @ar_return
            A=M
            0;JMP


(as_ALGO1)
@ar_dividend
D=M
@ar_remainder
M=D //store contents of dividend into remainder

(as_ALGO1LOOP)
    @ar_divisor
    D=M //get divisor
    @ar_remainder
    M=M-D //remainder = remainder - divisor
    @ar_quotient
    M=M+1 //quotiant++

    @ar_remainder
    D=M
    @as_ALGO1LOOP
    D;JGT //loop while remainder is greater than 0

    //else if remainder is negative, fix remainder
    @ar_remainder
    D=M
    @as_ENDFUNC
    D;JGE

    //Else, fix
    @ar_divisor
    D=M //get divisor
    @ar_remainder
    M=D+M //remainder = remainder + divisor
    @ar_quotient
    M=M-1 //quotiant--

    (as_ENDFUNC)
        @as_algoReturn
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
// ar_decHund        - hundreds place of the decimal number
// ar_decTens        - tens place of the decimal number
// ar_decOnes        - ones place of the decimal number
// as_leadingZeroBool- initialized at 1, changes to 0 when it encounters a leading zero
//=======================================================================================================
(kp_outputAll)
    @as_leadingZeroBool
    M=0

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

        @ge_currentColumn
        M=M+1 //sets column to 19

        @kp_thous
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decTenThous
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decTenThous

        //if (0){
        //  if(bool) {
        //      cout << 0
        //  } else
        //  { do nothing }
        // }else {
        // bool = 1    
        //}

        //d contains value
        @as_checkOutputZeroTenThous
        D;JEQ //if output is 0, check to see if its a leading zero

        //ELSE
        //Set as_leadingZeroBool to 1 and proceed
        @as_leadingZeroBool
        M=1

        @kp_outputDec
        0;JMP //execute eaton function to place a > at column 19

        (as_checkOutputZeroTenThous)
            //int is a zero
            //check if its a leading zero
            @as_leadingZeroBool
            D=M
            @kp_outputDec
            D;JGT //if bool is 1, then go ahead and output 0

            //ELSE, decrement column and move on
            @ge_currentColumn
            M=M-1
    (kp_thous)

        @ge_currentColumn
        M=M+1 //inc column

        @kp_hund
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decThous
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decThous

        //if (0){
        //  if(bool) {
        //      cout << 0
        //  } else
        //  { do nothing }
        // }else {
        // bool = 1    
        //}

        //d contains value
        @as_checkOutputZeroThous
        D;JEQ //if output is 0, check to see if its a leading zero

        //ELSE
        //Set as_leadingZeroBool to 1 and proceed
        @as_leadingZeroBool
        M=1

        @kp_outputDec
        0;JMP

        (as_checkOutputZeroThous)
            //int is a zero
            //check if its a leading zero
            @as_leadingZeroBool
            D=M
            @kp_outputDec
            D;JGT //if bool is 1, then go ahead and output 0

            //ELSE, decrement column and move on
            @ge_currentColumn
            M=M-1

    (kp_hund)
        @ge_currentColumn
        M=M+1 //inc column

        @kp_tens
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decHund
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decThous

        //if (0){
        //  if(bool) {
        //      cout << 0
        //  } else
        //  { do nothing }
        // }else {
        // bool = 1    
        //}

        //d contains value
        @as_checkOutputZeroHund
        D;JEQ //if output is 0, check to see if its a leading zero

        //ELSE
        //Set as_leadingZeroBool to 1 and proceed
        @as_leadingZeroBool
        M=1

        @kp_outputDec
        0;JMP

        (as_checkOutputZeroHund)
            //int is a zero
            //check if its a leading zero
            @as_leadingZeroBool
            D=M
            @kp_outputDec
            D;JGT //if bool is 1, then go ahead and output 0

            //ELSE, decrement column and move on
            @ge_currentColumn
            M=M-1

    (kp_tens)
        @ge_currentColumn
        M=M+1 //inc column

        @kp_ones
        D=A
        @ge_output_return
        M=D //sets return

        @ar_decTens
        D=M
        @kp_currentDec
        M=D //kp_currentDec = ar_decThous

        //if (0){
        //  if(bool) {
        //      cout << 0
        //  } else
        //  { do nothing }
        // }else {
        // bool = 1    
        //}

        //d contains value
        @as_checkOutputZeroTens
        D;JEQ //if output is 0, check to see if its a leading zero

        //ELSE
        //Set as_leadingZeroBool to 1 and proceed
        @as_leadingZeroBool
        M=1

        @kp_outputDec
        0;JMP

        (as_checkOutputZeroTens)
            //int is a zero
            //check if its a leading zero
            @as_leadingZeroBool
            D=M
            @kp_outputDec
            D;JGT //if bool is 1, then go ahead and output 0

            //ELSE, decrement column and move on
            @ge_currentColumn
            M=M-1

    (kp_ones)
        @ge_currentColumn
        M=M+1 //inc column

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
