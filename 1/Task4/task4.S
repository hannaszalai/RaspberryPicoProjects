@ R5 - Counter is 0 on the way to 9, and 1 on the way back to 0

	.EQU	SEG_A, 21      @ GP21 (Segment A)
	.EQU	SEG_B, 20      @ GP20 (Segment B)
	.EQU	SEG_C, 18      @ GP18 (Segment C)
	.EQU	SEG_D, 17      @ GP17 (Segment D)
	.EQU	SEG_E, 16      @ GP16 (Segment E)
	.EQU	SEG_F, 22      @ GP22 (Segment F)
	.EQU	SEG_G, 26      @ GP26 (Segment G)
	.EQU	SEG_DP, 19     @ GP19 (Decimal Point)
	.EQU	GPIO_OUT, 1    @ Direction for GPIO as output
	.EQU	sleep_time, 1000  @ Sleep time constant (in milliseconds)

.thumb_func	@ Necessary because sdk uses BLX
.global main    @ Entry point for the program

main:
@ Initialize all GPIO pins and set them as output for each segment of the display
	MOV	R0, #SEG_A        @ Move segment A pin number to R0
	BL	gpio_init         @ Call gpio_init() function to initialize GPIO for segment A
	MOV	R0, #SEG_A        @ Reload segment A pin number into R0
	MOV	R1, #GPIO_OUT     @ Set direction as output for this pin (R1 = 1)
	BL	link_gpio_set_dir @ Set the GPIO direction for segment A

@ Repeat the same steps for segments B to G
	MOV	R0, #SEG_B
	BL	gpio_init
	MOV	R0, #SEG_B
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir

	MOV	R0, #SEG_C
	BL	gpio_init
	MOV	R0, #SEG_C
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir

	MOV	R0, #SEG_D
	BL	gpio_init
	MOV	R0, #SEG_D
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir

	MOV	R0, #SEG_E
	BL	gpio_init
	MOV	R0, #SEG_E
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir

	MOV	R0, #SEG_F
	BL	gpio_init
	MOV	R0, #SEG_F
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir

	MOV	R0, #SEG_G
	BL	gpio_init
	MOV	R0, #SEG_G
	MOV	R1, #GPIO_OUT
	BL	link_gpio_set_dir
	
	B showZero  @ Jump to showZero function to display digit 0
	
showZero:
	MOV R5, #0  @ Initialize counter R5 to 0 (count up)

@ Display digit '0' on the 7-segment display (ABCDEF segments ON, G segment OFF)
	MOV	R0, #SEG_A
	MOV	R1, #1             @ Set Segment A ON
	BL	link_gpio_put      @ Call link_gpio_put to apply the value

	MOV	R0, #SEG_B
	MOV	R1, #1             @ Set Segment B ON
	BL	link_gpio_put

	MOV	R0, #SEG_C
	MOV	R1, #1             @ Set Segment C ON
	BL	link_gpio_put

	MOV	R0, #SEG_D
	MOV	R1, #1             @ Set Segment D ON
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #1             @ Set Segment E ON
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1             @ Set Segment F ON
	BL	link_gpio_put

	MOV	R0, #SEG_G
	MOV	R1, #0             @ Set Segment G OFF
	BL	link_gpio_put

	@ Delay for a moment to display '0'
	LDR	R0, =sleep_time
	BL	sleep_ms

	@ Move on to displaying '1'
	BL showOne

showOne:
	MOV	R0, #SEG_A
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #0
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms
	
        CMP R5, #0            @ Check if counter is 0 (on the way up)
	BEQ showTwo           @ If yes, continue to display '2'
	BL showZero           @ If no, loop back to display '0' (countdown mode)

showTwo:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0            @ Check if counter is 0
	BEQ showThree         @ If yes, continue to display '3'
	BL showOne            @ Otherwise, loop back to '1'

showThree:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0			@ Check if counter is 0
	BEQ showFour
	BL showTwo
	
showFour:
	MOV	R0, #SEG_A
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0			@ Check if counter is 0
	BEQ showFive
	BL showThree


showFive:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0			@ Check if counter is 0
	BEQ showSix
	BL showFour

showSix:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms
	
	CMP R5, #0			@ Check if counter is 0
	BEQ showSeven
	BL showFive

showSeven:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #0
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #0
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0			@ Check if counter is 0
	BEQ showEight
	BL showSix

showEight:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms

	CMP R5, #0			@ Check if counter is 0
	BEQ showNine
	BL showSeven

showNine:
	MOV	R0, #SEG_A
	MOV	R1, #1
	BL	link_gpio_put

	MOV	R0, #SEG_B
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_C
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_D
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_E
	MOV	R1, #0
	BL	link_gpio_put

	MOV	R0, #SEG_F
	MOV	R1, #1
	BL	link_gpio_put
	
	MOV	R0, #SEG_G
	MOV	R1, #1
	BL	link_gpio_put

	LDR	R0, =sleep_time
	BL	sleep_ms
	
	MOV R5, #1      @ The counting is reversed (1 is assigned)

	BL showEight    @ Next number: 8
