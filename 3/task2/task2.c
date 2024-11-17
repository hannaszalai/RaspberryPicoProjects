#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/irq.h"
#include "hardware/gpio.h"

// Define LED and button GPIO pins
#define LED1_PIN 1
#define LED2_PIN 2
#define LED3_PIN 3
#define LED4_PIN 4
#define BUTTON_INC_PIN 5
#define BUTTON_DEC_PIN 6

// Counter value
volatile uint8_t counter = 0;

// Function to update the LEDs to display the counter value
void update_leds() {
    gpio_put(LED1_PIN, counter & 0x01);  // least sign
    gpio_put(LED2_PIN, (counter >> 1) & 0x01); // second bit
    gpio_put(LED3_PIN, (counter >> 2) & 0x01); // third bit
    gpio_put(LED4_PIN, (counter >> 3) & 0x01); // most significant bit
}

// Interrupt handler for increment button
void button_inc_isr(uint gpio, uint32_t events) {
    if (counter < 15) {
        counter++;
        update_leds();
        printf("Counter incremented to %d\n", counter);
    }
}

// Interrupt handler for decrement button
void button_dec_isr(uint gpio, uint32_t events) {
    if (counter > 0) {
        counter--;
        update_leds();
        printf("Counter decremented to %d\n", counter);
    }
}

int main() {
    stdio_init_all();
    printf("Program with interrupts started...\n");

    // Initialize LED pins
    gpio_init(LED1_PIN);
    gpio_set_dir(LED1_PIN, GPIO_OUT);
    gpio_init(LED2_PIN);
    gpio_set_dir(LED2_PIN, GPIO_OUT);
    gpio_init(LED3_PIN);
    gpio_set_dir(LED3_PIN, GPIO_OUT);
    gpio_init(LED4_PIN);
    gpio_set_dir(LED4_PIN, GPIO_OUT);

    // Initialize button pins
    gpio_init(BUTTON_INC_PIN);
    gpio_set_dir(BUTTON_INC_PIN, GPIO_IN);
    gpio_pull_up(BUTTON_INC_PIN);  // Enable internal pull-up resistor

    gpio_init(BUTTON_DEC_PIN);
    gpio_set_dir(BUTTON_DEC_PIN, GPIO_IN);
    gpio_pull_up(BUTTON_DEC_PIN);  // Enable internal pull-up resistor

    // Set up interrupts for button press
    gpio_set_irq_enabled_with_callback(BUTTON_INC_PIN, GPIO_IRQ_EDGE_FALL, true, &button_inc_isr);
    gpio_set_irq_enabled_with_callback(BUTTON_DEC_PIN, GPIO_IRQ_EDGE_FALL, true, &button_dec_isr);

    // Initialize the LEDs to reflect the starting value of the counter
    update_leds();

    // Main loop does nothing, interrupts handle the button presses
    while (1) {
        tight_loop_contents();  // Keeps the processor in low power mode while waiting for interrupts
    }

    return 0;
}

