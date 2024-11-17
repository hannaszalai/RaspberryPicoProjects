    @ Assembler program to flash three LEDs connected to the
    @ Raspberry Pi Pico GPIO port like a traffic light with red, yellow, and green phases.

    .EQU   LED_PIN1, 0      @ GP0 for Green LED
    .EQU   LED_PIN2, 1      @ GP1 for Yellow LED
    .EQU   LED_PIN3, 2      @ GP2 for Red LED
    .EQU   GPIO_OUT, 1
    .EQU   sleep_time_red, 3000     @ Red light duration (3 seconds)
    .EQU   sleep_time_red_yellow, 1000  @ Red and Yellow light duration (1 second)
    .EQU   sleep_time_green, 3000   @ Green light duration (3 seconds)
    .EQU   sleep_time_yellow, 1000   @ Yellow light duration (1 second)

    .thumb_func              @ Necessary because sdk uses BLX
    .global main             @ Provide program starting address

main:
    @ Initialize GP0 (Green LED)
    MOV    R0, #LED_PIN1
    BL     gpio_init
    MOV    R0, #LED_PIN1
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

    @ Initialize GP1 (Yellow LED)
    MOV    R0, #LED_PIN2
    BL     gpio_init
    MOV    R0, #LED_PIN2
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

    @ Initialize GP2 (Red LED)
    MOV    R0, #LED_PIN3
    BL     gpio_init
    MOV    R0, #LED_PIN3
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

loop:
    @ Turn on Red LED
    MOV    R0, #LED_PIN3
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time_red
    BL     sleep_ms

    @ Turn on Yellow LED while Red is still on
    MOV    R0, #LED_PIN2
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time_red_yellow
    BL     sleep_ms

    @ Turn off Red and Yellow LEDs
    MOV    R0, #LED_PIN3
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_PIN2
    MOV    R1, #0
    BL     link_gpio_put

    @ Turn on Green LED
    MOV    R0, #LED_PIN1
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time_green
    BL     sleep_ms

    @ Turn off Green LED
    MOV    R0, #LED_PIN1
    MOV    R1, #0
    BL     link_gpio_put

    @ Turn on Yellow LED
    MOV    R0, #LED_PIN2
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time_yellow
    BL     sleep_ms

    @ Turn off Yellow LED
    MOV    R0, #LED_PIN2
    MOV    R1, #0
    BL     link_gpio_put

    @ Repeat the loop
    B      loop

