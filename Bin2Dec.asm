//Your program will accept only six keys from the keyboard:  0, 1, Enter, Backspace, c, and q 
//(Note: Enter is ASCII decimal 128 and Backspace is ASCII decimal 129). Any other input will be ignored.
//
//Your program will accept and display 16 binary digits (although the user can Backspace at any point to
// make corrections) followed by an Enter. If a Backspace is input, then the previous input digit will be
// erased (on the display and optionally in memory). If more than 16 bits are entered, then anything
// after 16 will be ignored (and not displayed). If c is entered at any time, then the entire line 
//(and optionally in memory) will be cleared. If q is entered at any time, then your program will clear
// the line and terminate (i.e. go into an infinite loop) immediately.
//
//Once the Enter is received after the 16 binary digits, your program will output a right arrow (a minus
// - followed by greater than >) followed by the decimal equivalent (with a + for positive numbers,
// including zero,  and a - for negative numbers and NO leading spaces) and will then wait for an Enter
// (ignoring any other input except c for clear and q for quit). Once an Enter is received, the displayed
// line will be cleared and your program will wait for new binary digit input


//One group needs to handle user input, and storing into R0 through R15
//The other needs to handle receiving from R0 through R15 and displaying result
//One member does input validation
//One member does input storage
//One member does conversion to decimal
//One member outputs to program



//first step is grab input validation 
//recieve input
//input validation
//if correct input, display on screen
//or do command

@ge_currentColumn //tracks cursor
M=0

@as_processBufBool //boolean that is equal to 1 if processBuf function has been executed
M=0

(as_getKey) //infinite loop that runs until a valid input is pressed
    @KBD    // get value of keyboard
    D=M

    @as_getKey
    D;JLE //if user enters a value, kbd will no longer be -1 

    //user has entered a key, must now validaate input

    //store user input
    @as_userInput
    M=D

    //if statements to validate input
    //first check if ge_currentColumn is <=15 
    @ge_currentColumn
    D=M
    @15
    D=A-D //if 15 bits entered, will be 0.This is because current column is 15
          //if current column is 16, then this means no more inputs can occur.
          //this is represented as D<0
    @as_checkOneZero
    D;JGE //executes if bits <=16. jumps if greater than or equal to 0

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
        D;JEQ //executes jump if input is 129
        //Else, backspace has not been entered

        //now check if c has been entered
        @as_getKey //if input is a 67, call as_clearBuf, then return to as_getKey
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
        @END //if input is a 81, call as_clearBuf, then end the program
        D=A
        @as_return
        M=D //kp_return will now return to as_getKey

        @81
        D=A
        @as_userInput
        D=M-D //81-81 = 0
        @as_clearBuf
        D;JEQ //executes jump if input is 81

        //Else, q has not been entered

        //Now check to see if bits = 16 and enter has been pressed (input is 128)

        //first check if bits is 16
        //if bits is not 16, return back to as_getKey

        @ge_currentColumn
        D=M
        @16
        D=A-D
        @as_getKey
        D;JNE //executes if bits is not 16

        //Then, bits must be 16, which means we check for enter key
        @128
        D=A
        @as_userInput
        D=M-D //userinput-128 = 0
        @as_getKey
        D;JNE //executes jump if input is not enter

        //This must mean bits is 16 and enter key has been pressed!
        
        //Now we check to see if buf has already been processed.
        //if as_processBufBool = 1, then set it to 0 and clear buf
        //else set it to 1 and proceed

        @as_processBufBool
        D=M

        @as_restart
        D;JGT //if as_processBufBool is greater than 0 (1), 
              //then restart program by clearing buf, restarting cols, set processbufbool to 0 and jumping to getKey

        //ELSE, buffer has not been processed
        //Now we call processBuf
        @as_processBufBool
        M=1 //bool that indicates processBuf has occured

        @as_getKey //set return value to as_getKey
        D=A
        @ar_return
        M=D //ar_return will now return to as_getKey

        @ar_processBuf
        0;JMP //jump to process buf!

    (as_checkOneZero) //checks if userInput is 48 or 49 
        @cz_addBuf //if input is a 48, call kp_outputKey
        D=A
        @kp_return
        M=D //kp_return will now return to cz_addBuf

        @48
        D=A
        @as_userInput
        D=M-D //48-48 = 0
        @kp_outputKey
        D;JEQ //executes jump if input is 48 (48 equals 0)
        
        //ELSE
        //execute if equal to 49
        D=D-1 //if it is 1, now it is 0
        D;JEQ //executes jump if input was 49

        //ELSE input was not 0 or 1, jump to continue input validation
        @as_continueInputValidation
        0;JMP
    
(as_restart) //this function will clear buffer, set processbufbool to 0, and return to key
    @as_processBufBool
    M=0

    @as_getKey 
    D=A
    @as_return
    M=D //as_return will now return to as_getKey

    @as_clearBuf
    0;JMP //executes jump to clear buf, function will return to getKey when done

(END)
    @END
    0;JMP  