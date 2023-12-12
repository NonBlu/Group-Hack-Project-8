//execute 1 * 10^4
//store into R0

// (as_mult)

//     @as_multInc
//     M=0 //initializes i to 0

//     @as_multProduct
//     M=0//initializes R2 to 0

//     //works if R0 is negative, needs to work if R1 is negative
//     (as_multLoop)
//         @as_multInc //if (i == R1 go to END)
//         D=M
//         @as_multNum2
//         D=D-M

//         @as_return
//         A=M
//         D;JEQ //return when done

//         //ELSE

//         @as_multNum2 //if positive, incrememnt i
//         D=M
//         @as_multPositive
//         D;JGT

//         @as_multNum1
//         D=M
//         @as_multProduct
//         M=M-D //Take contents of R0 and subtract them from R2

//         @as_multInc //else decrement i
//         M=M-1

//         @as_multLoop
//         0;JMP

//         (as_multPositive)
//             @as_multNum1
//             D=M
//             @as_multProduct
//             M=D+M //Take contents of R0 and add them to R2

//             @as_multInc
//             M=M+1 //i++

//             @as_multLoop
//             0;JMP
@10
D=A
@as_powBase
M=D

@2
D=A
@as_powRaise
M=D

@END
D=A
@as_return
M=D

@as_pow
0;JMP


(as_pow)
    //create a function that outputs the value z = x raised to the power of y
    @as_powInc
    M=0 //initialize i to 0
    @as_powOutput
    M=1 //initializes R5
    (as_powLoop)
        @as_powInc //if i equals R4 
        D=M
        @as_powRaise
        D=D-M
        @as_return
        A=M
        D;JEQ  //from torey cgbubg JEQ JLT

        //ELSE
        @as_powNext
        D=A
        @as_powReturn
        M=D

        @as_powMult
        0;JMP //executes multiply function

        (as_powNext)
        @as_powMultProduct
        D=M
        @as_powOutput
        M=D //stores contents of R2 into R5

        @as_powInc
        M=M+1 //i++

        @as_powLoop
        0;JMP

    (as_powMult) //multiply function
        @as_powMultInc
        M=0//initialize j to 0

        @as_powOutput
        D=M
        @as_powMultNum1
        M=D //take contents of R5 and store them into R0

        @as_powMultProduct
        M=0 //initializes product to 0
        @as_powMultInc
        M=0 //initializes incrementor to 0
        (as_powMultLoop)
            @as_powMultInc //if (j == R3 go to END)
            D=M
            @as_powBase
            D=D-M
            @as_powEndFunc
            D;JEQ

            @as_powBase //if R1 is positive, increment i
            D=M
            @as_powPositive
            D;JGT

            @as_powMultNum1
            D=M
            @as_powMultProduct
            M=M-D //Take contents of R0 and subtract them from R2

            @as_powMultInc //else decrement j
            M=M-1

            @as_powMultLoop
            0;JMP

            (as_powPositive)
                @as_powMultNum1
                D=M
                @as_powMultProduct
                M=D+M //Take contents of R0 and add them to R2

                @as_powMultInc
                M=M+1 //j++

                @as_powMultLoop
                0;JMP

            (as_powEndFunc)
                @as_powReturn
                A=M
                0;JMP

(END)
@END
0;JMP

