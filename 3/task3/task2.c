#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/gpio.h"
#include "hardware/timer.h"

// Define LED and button GPIO pins
#define LED1_PIN 1
#define LED2_PIN 2
#define LED3_PIN 3
#define LED4_PIN 4
#define RESET_BUTTON_PIN 0

// Counter value
volatile uint8_t counter = 0;
volatile bool stop_counter = false;

// Function to update the LEDs to display the counter value
void update_leds() {
    gpio_put(LED1_PIN, counter & 0x01);
    gpio_put(LED2_PIN, (counter >> 1) & 0x01);
    gpio_put(LED3_PIN, (counter >> 2) & 0x01);
    gpio_put(LED4_PIN, (counter >> 3) & 0x01);
}

// Timer callback function to increment the counter
bool repeating_timer_callback(struct repeating_timer *t) {
    if (!stop_counter) {
        if (counter < 15) {
            counter++;
            update_leds();
            printf("Counter incremented to %d\n", counter);
        } else {
            stop_counter = true;  // Stop the counter when it reaches 1111 (15)
        }
    }
    return true;  // Continue the timer
}

// Interrupt handler for the reset button
void reset_button_isr(uint gpio, uint32_t events) {
    printf("Reset button pressed!\n");
    counter = 0;  // Reset the counter to 0000
    stop_counter = false;  // Resume counting
    update_leds();
}

int main() {
    stdio_init_all();
    printf("Program with timer interrupt and reset button started...\n");

    // Initialize LED pins
    gpio_init(LED1_PIN);
    gpio_set_dir(LED1_PIN, GPIO_OUT);
    gpio_init(LED2_PIN);
    gpio_set_dir(LED2_PIN, GPIO_OUT);
    gpio_init(LED3_PIN);
    gpio_set_dir(LED3_PIN, GPIO_OUT);
    gpio_init(LED4_PIN);
    gpio_set_dir(LED4_PIN, GPIO_OUT);

    // Initialize reset button pin
    gpio_init(RESET_BUTTON_PIN);
    gpio_set_dir(RESET_BUTTON_PIN, GPIO_IN);
    gpio_pull_up(RESET_BUTTON_PIN);  // Enable internal pull-up resistor

    // Set up interrupt for reset button
    gpio_set_irq_enabled_with_callback(RESET_BUTTON_PIN, GPIO_IRQ_EDGE_FALL, true, &reset_button_isr);

    // Set up a repeating timer for 1-second interval
    struct repeating_timer timer;
    add_repeating_timer_ms(1000, repeating_timer_callback, NULL, &timer);

    // Initialize the LEDs to reflect the starting value of the counter
    update_leds();

    // Main loop does nothing, interrupts handle everything
    while (1) {
        tight_loop_contents();  // Keeps the processor in low power mode while waiting for interrupts
    }

    return 0;
}

