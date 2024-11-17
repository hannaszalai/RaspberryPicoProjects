    .EQU    LED_PIN1, 0          @ Define constant LED_PIN1 to GPIO pin 0 (used for LED control)
    
    .EQU    BUT_PIN1, 1          @ Define constant BUT_PIN1 to GPIO pin 1 (used for button 1, to turn the LED on)
    .EQU    BUT_PIN2, 2          @ Define constant BUT_PIN2 to GPIO pin 2 (used for button 2, to turn the LED off)
    
    .EQU    GPIO_IN, 0           @ Define constant GPIO_IN to represent GPIO input direction (0 for input)
    .EQU    GPIO_OUT, 1          @ Define constant GPIO_OUT to represent GPIO output direction (1 for output)
    
    
.thumb_func
.global main


main:
    MOV R0, #LED_PIN1             @ Move the value of LED_PIN1 (GPIO pin 0) into register R0
    BL  gpio_init                 @ Call the gpio_init function to initialize GPIO pin 0 (for LED)
    MOV R0, #LED_PIN1             @ Move the value of LED_PIN1 (GPIO pin 0) into register R0 again
    MOV R1, #GPIO_OUT             @ Move the value GPIO_OUT (1) into register R1 to indicate that this pin will be an output
    BL  link_gpio_set_dir         @ Call link_gpio_set_dir to set the direction of GPIO pin 0 (LED_PIN1) as output
    
    MOV R0, #BUT_PIN1             @ Move the value of BUT_PIN1 (GPIO pin 1) into register R0
    BL  gpio_init                 @ Call gpio_init to initialize GPIO pin 1 (for Button 1)
    MOV R0, #BUT_PIN1             @ Move the value of BUT_PIN1 into register R0 again
    MOV R1, #GPIO_IN              @ Move the value GPIO_IN (0) into register R1 to indicate that this pin will be an input
    BL  link_gpio_set_dir         @ Call link_gpio_set_dir to set the direction of GPIO pin 1 (BUT_PIN1) as input
    
    MOV R0, #BUT_PIN2             @ Move the value of BUT_PIN2 (GPIO pin 2) into register R0
    BL  gpio_init                 @ Call gpio_init to initialize GPIO pin 2 (for Button 2)
    MOV R0, #BUT_PIN2             @ Move the value of BUT_PIN2 into register R0 again
    MOV R1, #GPIO_IN              @ Move the value GPIO_IN (0) into register R1 to indicate that this pin will be an input
    BL  link_gpio_set_dir         @ Call link_gpio_set_dir to set the direction of GPIO pin 2 (BUT_PIN2) as input

    
    
wait_on:  
    MOV R0, #BUT_PIN1             @ Move the value of BUT_PIN1 (GPIO pin 1) into register R0
    BL  link_gpio_get             @ Call link_gpio_get to read the current state of GPIO pin 1 (Button 1)
    CMP R0, #1                    @ Compare the value in R0 with 1 (check if Button 1 is pressed)
    BEQ turn_on                   @ If Button 1 is pressed (R0 == 1), branch to the 'turn_on' section
    B   wait_on                   @ If Button 1 is not pressed, keep looping back to wait_on
    
    
turn_on:
    MOV R0, #LED_PIN1             @ Move the value of LED_PIN1 (GPIO pin 0) into register R0
    MOV R1, #1                    @ Move the value 1 (HIGH) into register R1 to turn the LED on
    BL  link_gpio_put             @ Call link_gpio_put to set GPIO pin 0 (LED_PIN1) to HIGH (turn the LED on)
    B   wait_off                  @ Branch to 'wait_off' to start checking for Button 2 (to turn the LED off)
    
    
turn_off:
    MOV R0, #LED_PIN1             @ Move the value of LED_PIN1 (GPIO pin 0) into register R0
    MOV R1, #0                    @ Move the value 0 (LOW) into register R1 to turn the LED off
    BL  link_gpio_put             @ Call link_gpio_put to set GPIO pin 0 (LED_PIN1) to LOW (turn the LED off)
    B   wait_on                   @ Branch back to 'wait_on' to start checking for Button 1 again (to turn the LED on)
    
    
wait_off:
    MOV R0, #BUT_PIN2             @ Move the value of BUT_PIN2 (GPIO pin 2) into register R0
    BL  link_gpio_get             @ Call link_gpio_get to read the current state of GPIO pin 2 (Button 2)
    CMP R0, #1                    @ Compare the value in R0 with 1 (check if Button 2 is pressed)
    BEQ turn_off                  @ If Button 2 is pressed (R0 == 1), branch to the 'turn_off' section
    B   wait_off                  @ If Button 2 is not pressed, keep looping back to wait_off
