@ Assembler program to implement a custom LED sequence.
@ Using GP0 for Green, GP1 for Yellow, and GP2 for Red.

.EQU   LED_GREEN, 0      @ GP0 for Green
.EQU   LED_YELLOW, 1     @ GP1 for Yellow
.EQU   LED_RED, 2        @ GP2 for Red
.EQU   GPIO_OUT, 1
.EQU   sleep_time, 1000  @ Delay time (1000 ms)

.thumb_func               @ Necessary because SDK uses BLX
.global main              @ Provide program starting address

main:
    @ Initialize Green LED (GP0)
    MOV    R0, #LED_GREEN
    BL     gpio_init
    MOV    R0, #LED_GREEN
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

    @ Initialize Yellow LED (GP1)
    MOV    R0, #LED_YELLOW
    BL     gpio_init
    MOV    R0, #LED_YELLOW
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

    @ Initialize Red LED (GP2)
    MOV    R0, #LED_RED
    BL     gpio_init
    MOV    R0, #LED_RED
    MOV    R1, #GPIO_OUT
    BL     link_gpio_set_dir

loop:
    @ Sequence 1: Green
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Green
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 2: Yellow
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Yellow
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 3: Green and Yellow
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 4: Red
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Red
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 5: Red and Green
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 6: Red and Yellow
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 7: Red, Yellow, and Green
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off all
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Add additional sequences
    @ Sequence 8: Red, Yellow, and Green
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off all
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 9: Yellow and Red
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 10: Red and Green
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 11: Red
    MOV    R0, #LED_RED
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Red
    MOV    R0, #LED_RED
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 12: Yellow and Green
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off both
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 13: Yellow
    MOV    R0, #LED_YELLOW
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Yellow
    MOV    R0, #LED_YELLOW
    MOV    R1, #0
    BL     link_gpio_put

    @ Sequence 14: Green
    MOV    R0, #LED_GREEN
    MOV    R1, #1
    BL     link_gpio_put
    LDR    R0, =sleep_time
    BL     sleep_ms

    @ Turn off Green
    MOV    R0, #LED_GREEN
    MOV    R1, #0
    BL     link_gpio_put

    B      loop            @ Repeat the sequence

