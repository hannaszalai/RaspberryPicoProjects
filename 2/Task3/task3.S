#include "hardware/regs/addressmap.h"
#include "hardware/regs/sio.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/pads_bank0.h"

.thumb_func
.global main

.EQU LED_PIN, 0   
.EQU BUTTON_PIN1, 1
.EQU BUTTON_PIN2, 2

.EQU GPIO_IN, 0          @ Define GPIO_IN as 0 (input direction)
.EQU GPIO_OUT, 1         @ Define GPIO_OUT as 1 (output direction)

.thumb_func
.global main
.align 4

main:
    MOV R0, #LED_PIN      @ Move LED_PIN (0) into R0
    BL gpioinit           @ Branch with Link to 'gpioinit' function to initialize GPIO0 for LED control
    
    MOV R0, #BUTTON_PIN1     @ Move BUTTON_PIN1 (1) into R0
    BL gpio_init          @ Call the SDK function gpio_init to initialize GPIO1
    MOV R0, #BUTTON_PIN1     @ Move BUTTON_PIN1 (1) into R0 (set up again for direction config)
    MOV R1, #GPIO_IN      @ Move GPIO_IN (0) into R1 (set GPIO1 as input)
    BL link_gpio_set_dir  @ Call the 'link_gpio_set_dir' function to set GPIO1 as input

    MOV R0, #BUTTON_PIN2     @ Move BUTTON_PIN2 (2) into R0 (select GPIO2)
    BL gpio_init          @ Call the SDK function gpio_init to initialize GPIO2
    MOV R0, #BUTTON_PIN2     @ Move BUTTON_PIN2 (2) into R0 (set up again for direction config)
    MOV R1, #GPIO_IN      @ Move GPIO_IN (0) into R1 (set GPIO2 as input)
    BL link_gpio_set_dir  @ Call the 'link_gpio_set_dir' function to set GPIO2 as input

    LDR R4, =1                @ Load immediate value 1 into R4

wait_on:  
    MOV R0, #BUTTON_PIN1     @ Move BUTTON_PIN1 (1) into R0 to check if button 1 is pressed
    LDR R2, gpiobase      @ Load the base address of the GPIO registers into R2
    LDR R1, [R2, #SIO_GPIO_IN_OFFSET]  @ Load the current state of all GPIO pins (GPIO input register) into R1
    LSL R3, R4, #BUTTON_PIN1 @ Shift R4 (1) left by BUTTON_PIN1 to create a bitmask for GPIO1 (button 1)
    AND R1, R1, R3        @ Perform a bitwise AND to check if the button 1 is pressed (masked bit will be 1 if pressed)
    CMP R1, #0            @ Compare the result with 0 (check if the button is not pressed)
    BEQ wait_on           @ If button 1 is not pressed (R1 == 0), branch to 'wait_on' to keep checking

turn_on:
    MOV R3, #1            @ Move the value 1 into R3 (this will be the value to set GPIO0 high)
    LSL R3, R3, #0        @ Shift R3 left by 0 (no change, since GPIO0 is the target)
    STR R3, [R2, #SIO_GPIO_OUT_SET_OFFSET]  @ Write 1 to the GPIO output set register, setting GPIO0 high (turn on LED)
    
    B wait_off            @ Branch to 'wait_off' to wait for button 2 to be pressed

wait_off:
    MOV R0, #BUTTON_PIN2     @ Move BUTTON_PIN2 (2) into R0 to check if button 2 is pressed
    LDR R2, gpiobase      @ Load the base address of the GPIO registers into R2
    LDR R1, [R2, #SIO_GPIO_IN_OFFSET]  @ Load the current state of all GPIO pins (GPIO input register) into R1
    LSL R3, R4, #BUTTON_PIN2 @ Shift R4 (1) left by BUTTON_PIN2 to create a bitmask for GPIO2 (button 2)
    AND R1, R1, R3        @ Perform a bitwise AND to check if the button 2 is pressed (masked bit will be 1 if pressed)
    CMP R1, #0            @ Compare the result with 0 (check if the button is not pressed)
    BEQ wait_off          @ If button 2 is not pressed (R1 == 0), branch to 'wait_off' to keep checking

turn_off:
    MOV R3, #1            @ Move the value 1 into R3 (this will be the value to clear GPIO0)
    LSL R3, R3, #0        @ Shift R3 left by 0 (no change, since GPIO0 is the target)
    STR R3, [R2, #SIO_GPIO_OUT_CLR_OFFSET]  @ Write 1 to the GPIO output clear register, clearing GPIO0 (turn off LED)

    B wait_on             @ Branch back to 'wait_on' to wait for button 1 to be pressed again

@ Purpose: Initialize a GPIO pin for SIO (Software-controlled I/O)
@ Inputs: r0 = pin number to initialize
gpioinit:
    MOV R3, #1            @ Move the value 1 into R3 (used to set GPIO direction)
    LSL R3, R0            @ Shift R3 left by the pin number (R0), creating a bitmask for the pin
    LDR R2, gpiobase      @ Load the base address of the GPIO registers into R2
    STR R3, [R2, #SIO_GPIO_OE_SET_OFFSET]  @ Set the pin as an output (write to the output enable set register)
    STR R3, [R2, #SIO_GPIO_OUT_CLR_OFFSET] @ Clear the pin's output (start with LED off)

    @ Configure the pin for input by setting PADS_BANK0_IE_BITS (input enable)
    LDR R2, padsbank0     @ Load the base address of the Pads Bank 0 registers into R2
    LSL R3, R0, #2        @ Shift the pin number (R0) left by 2 (to access the correct PADS_BANK0 register)
    ADD R2, R3            @ Add the offset to the base address of Pads Bank 0
    MOV R1, #PADS_BANK0_GPIO0_IE_BITS @ Move input enable bits into R1
    LDR R4, setoffset     @ Load the set register offset into R4
    ORR R2, R4            @ Perform bitwise OR to set the input enable bits in the correct register
    STR R1, [R2, #PADS_BANK0_GPIO0_OFFSET]  @ Write to the PADS_BANK0 register to enable input

    @ Set the pin's function to SIO (Software I/O control)
    LSL R0, #3            @ Shift the pin number left by 3 (calculate the correct IO_BANK0 control register offset)
    LDR R2, iobank0       @ Load the base address of IO Bank 0 registers into R2
    ADD R2, R0            @ Add the pin's offset to the base address
    MOV R1, #IO_BANK0_GPIO0_CTRL_FUNCSEL_VALUE_SIO_0  @ Move the function select value for SIO into R1
    STR R1, [R2, #IO_BANK0_GPIO0_CTRL_OFFSET]  @ Write to the control register to set the function to SIO
    BX LR                 @ Return from the function by branching to the address stored in the Link Register (LR)

.align 4
gpiobase: .word SIO_BASE @ Define the base address for GPIO registers (SIO)
iobank0: .word IO_BANK0_BASE @ Define the base address for IO Bank 0 registers
padsbank0: .word PADS_BANK0_BASE @ Define the base address for Pads Bank 0 registers
setoffset: .word REG_ALIAS_SET_BITS @ Define the set bits offset for modifying the registers

