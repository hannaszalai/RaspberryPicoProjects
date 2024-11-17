#include "pico/stdlib.h"
#include "hardware/regs/sio.h"    // For accessing hardware registers
#include <stdbool.h>              // For using 'true' and 'false'

// Define the GPIO pins
#define LED_PIN 0
#define LED2_PIN 6
#define BUTTON1_PIN 1
#define BUTTON2_PIN 2

// Define the bit masks for the pins
#define LED_MASK (1 << LED_PIN)
#define LED2_MASK (1 << LED2_PIN)
#define BUTTON1_MASK (1 << BUTTON1_PIN)
#define BUTTON2_MASK (1 << BUTTON2_PIN)

int main() {
    // Initialize the GPIO pins
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);  // Set GP0 as output for LED
    gpio_init(LED2_PIN);
    gpio_set_dir(LED2_PIN, GPIO_OUT);  // Set GP6 as output for second LED
    gpio_init(BUTTON1_PIN);
    gpio_set_dir(BUTTON1_PIN, GPIO_IN);  // Set GP1 as input for button
    gpio_pull_up(BUTTON1_PIN);  // Enable pull-up resistor
    gpio_init(BUTTON2_PIN);
    gpio_set_dir(BUTTON2_PIN, GPIO_IN);  // Set GP2 as input for button
    gpio_pull_up(BUTTON2_PIN);  // Enable pull-up resistor

    // Main loop
    while (true) {
        if (!(sio_hw->gpio_in & BUTTON1_MASK)) {  // Button on GP1 pressed
            sio_hw->gpio_set = LED_MASK | LED2_MASK;  // Turn on both LEDs
        }
        if (!(sio_hw->gpio_in & BUTTON2_MASK)) {  // Button on GP2 pressed
            sio_hw->gpio_clr = LED_MASK | LED2_MASK;  // Turn off both LEDs
        }
    }
    return 0;
}

