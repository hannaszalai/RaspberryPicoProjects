@ R0 - First parameter to printf
@ R1 - Second parameter to printf
@ R7 - Index counter
@

.thumb_func              @ Necessary because SDK uses BLX
.global main             @ Provide program starting address to linker

main:
    MOV    R7, #100           @ Initialize counter to 100
    BL     stdio_init_all      @ Initialize uart or usb for printf

loop:
    LDR    R0, =helloworld    @ Load address of helloworld string
    MOV    R1, R7             @ Move the counter to second parameter (R1)
    BL     printf             @ Call printf function to print the message

    LDR    R0, =1000          @ Load 1000 milliseconds (1 second) into R0
    BL     sleep_ms           @ Call sleep_ms to sleep for 1 second

    SUB    R7, #1             @ Decrement counter by 1

    CMP    R7, #0             @ Check if counter has reached 0
    BGE    loop               @ If counter is >= 0, continue the loop

    MOV    R7, #100           @ Reset counter to 100 when it reaches -1
    B      loop               @ Repeat the loop

.data
       .align  4              @ Necessary alignment
helloworld: .asciz   "Hello World %d\n"

