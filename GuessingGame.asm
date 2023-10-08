;Assignment 4 Question 2:
;Alan To
;Simulate a guessing game. The program has stored the value 'n' between 0-9. 
;The program will keep asking the user to guess a number between 0 and 9. 
;If program encounters any non-digit character, the program should output 'Invalid input'


;Label          Opcodes         Operands        Comments
                
                .ORIG           x3000               
                                                ;R0 is used for input/output
                AND             R1, R1, #0      ;clear out R1 register
                AND             R2, R2, #0      ;clear out R2 register. This will be our counter for guesses.
                AND             R3, R3, #0      ;Clear out R3 register. 
                AND             R4, R4, #0      ;clear out R4 register
                
                LD              R3, Zero        ;Load ASCII zero in R3
                NOT             R3, R3,         ;store the complement of Zero in R1
                ADD             R3, R3, #1      ;the complement of Zero is used to test when to quit loop
                
                
                                                ;First thing we want to do is prompt for input, capture input and echo input
                LEA             R0, Prompt      ;We don't want to load data into register. We want to load a memory address. R0 <- PROMPT
                PUTS                            ;PUTS automatically looks in R0 and display the prompt in console.
                GETC                            ;this captures what the user types. User input and stores it in R0. R0 will be ASCII value of what user typed
                OUT                             ;This will output what the user input was from getc.
                BRnzp           FirstLoop
                
Loop            LEA             R0, GuessAgain  
                PUTS
                GETC
                OUT
                
                
                
FirstLoop       LD              R3, Zero        ;Load ASCII zero in R3
                NOT             R3, R3,         ;store the complement of Zero in R1
                ADD             R3, R3, #1      ;the complement of Zero is used to test when to quit loop

                AND             R4, R4, #0      ;clear out R4 register
                ADD             R4, R3, R0      ;R4 <- -48 + R0. Will store the input that user put in.
                
                ADD             R3, R3, R0      ;subtract input from ASCII 0
                BRn             InvalidInput    ;If negative, Invalid input because it's below the range
                
                AND             R3, R3, #0      ;clear R3
                LD              R3, Nine        ;add 57 for ASCII 9 to check if it's within 9
                NOT             R3, R3          ;invert R3
                ADD             R3, R3, #1      ;add 1 for 2's comp of negative 9
                ADD             R3, R3, R0
                BRp             InvalidInput    ;if pos, Invalid input because it's above the range
                
                
                LD              R1, Number      ;R1 will be the number we have to guess. R1 <- Number
                NOT             R1, R1          ;We're trying to turn the number we're trying to guess into negative
                ADD             R1, R1, #1      ;2 comp
                ADD             R1, R4, R1      ;R1 <- R0 - R1. If R1 < 0 3 -7, means guess was too low.
                
                                                ;If R1 < 0, the guess was too low.
                                                ;If R1 > 0, the guess was too high.
                                                ;If R1 == 0, they guessed correctly.
                
                                                
                BRz             RightAnswer     ;when they guess it right, we'll go out of the loop because it's our last time guessing.
                
                BRn             LowCase         
                LEA             R0, High        ;We're here if user guess was high
                PUTS
                ADD             R2, R2, #1
                BRnzp           Again
                
                ;If R1 > 0, the guess was too high.
                ;If R1 == 0, they guessed correctly.
LowCase         LEA             R0, Low         ;We're here if our user guess was low
                PUTS
                ADD             R2, R2, #1
                BRnzp           Again
                
              ;  BRnzp           RightAnswer     ;when they guess it right, we'll go out of the loop because it's our last time guessing.
                
Again           AND             R0, R0, #0      ;clear R0.
                ADD             R1, R1, #0      ;doing this for the branch instruction
                BRnp            Loop            ;if negative or positive, we go back to ask the prompt again.
                
                
InvalidInput    LEA             R0, Invalid
                PUTS
                ADD             R2, R2, #1
                BRnzp           Loop
                
                
RightAnswer     LEA             R0, Correct     ;when they guess it correctly
                PUTS
                ADD             R2, R2, #1
                AND             R0, R0, #0      ;clear out R0 for guesses
                LD              R0, Zero        ;Load ASCII value for 0, to offset with number of guesses
                ADD             R0, R0, R2      ;Add the amount of guesses. R0 <- R2
                OUT                             ;write the number of guesses
                LEA             R0, Guesses   
                PUTS
                
                
                HALT
Number          .FILL           #7
Prompt          .STRINGZ        "\nGuess a number 0 to 9: "
Correct         .STRINGZ        "\nYou guessed correctly! It took you "
Guesses         .STRINGZ        " guesses!"
;Wrong           .STRINGZ        "\nYou guessed wrong, try again."
Low             .STRINGZ        "\nYour guess was too low."
High            .STRINGZ        "\nYour guess was too high."
Invalid         .STRINGZ        "\nInvalid guess. Insert a number from 1 to 9"
GuessAgain      .STRINGZ        "\nGuess again: "
Zero            .FILL           x0030         ; hex value for ASCII character 0
MIN             .FILL           #-48
Nine             .FILL          #57
                .END