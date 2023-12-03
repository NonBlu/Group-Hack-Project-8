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

@as_bitCounter
D=A
@0
M=A //create an incrememnter responsible for tracking how many bits are entered

@ge_currentColumn //tracks cursor
M=0

@KBD
M=0 //when there is no input, kbd is set to a value less than 1
(as_getKey) //infinite loop that runs until a valid input is pressed

    @KBD    // get value of keyboard
    D=M

    @as_getKey
    D;JLE //if user enters a value, kbd will no longer be -1 

    //user has entered a key, must now validaate input

    //if statements to validate input
    //first check if as_bitCounter is <=16 
    @as_userInput
    M=D
    @as_bitCounter
    D=M
    @16
    D=A-D //if bit counter is 16, will be 0. if bit counter is less than 16, will be positive
    @as_checkOneZero
    D;JGE //executes if bits <=16. jumps if greater than or equal to 0

    (as_checkOneZero) //checks if input is 0 or 1 
        @as_userInput
        D=M

        //if zero, then jump to kp_outputKey 
