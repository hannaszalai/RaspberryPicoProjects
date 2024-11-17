.thumb_func
.global main

main:
    BL  stdio_init_all            @ Initialize UART or USB I/O

loop:
    LDR R0, =my_array             @ Load array base address into R0
    MOV R1, #8                    @ Load number of elements (8) into R1
    BL  average                   @ Call the average subroutine, result in R0 (sum / 8)
    
    MOV R1, R0                    @ Move average result into R1 for printf
    LDR R0, =message_str          @ Load message string address into R0
    BL  printf                    @ Call printf to print average value
    B   loop                      @ Infinite loop

@ Subroutine to calculate the average of an array
.thumb_func
average:
    PUSH {LR}                     @ Save the Link Register (LR) onto the stack, preserving the return address
    MOV R2, #0                    @ Initialize R2 to 0. This register will hold the running sum of array elements

average_loop:
    LDR R3, [R0]                  @ Load the value pointed to by R0 (current array element) into register R3
    ADD R0, R0, #4                @ Increment R0 by 4 to point to the next element
    ADD R2, R2, R3                @ Add the value in R3 (current array element) to R2 (running sum)
    SUB R1, R1, #1                @ Subtract 1 from R1 (the counter of elements left to process)
    CMP R1, #0                    @ Compare element count with 0 to see if we've processed all elements
    BNE average_loop              @ Repeat until all elements are processed (until R1 is 0)

    MOV R0, R2                    @ Move the sum of the array (stored in R2) into R0 (which is used for return values)
    LSR R0, R0, #3                @ Divide sum by 8 (right shift by 3)
    POP {PC}                      @ Restore the Link Register (LR) from the stack and return to the calling function
                                  @ (POPing into PC causes the program to return)

.data
.align 4
message_str: .asciz "Average value: %d\n"
.align 4
my_array: .word 10, 20, 30, 40, 50, 60, 70, 80  @ Array of 8 elements
