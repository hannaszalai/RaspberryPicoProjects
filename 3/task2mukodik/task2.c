#include <stdio.h>
#include "pico/stdlib.h"

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
    gpio_put(LED1_PIN, counter & 0x01);
    gpio_put(LED2_PIN, (counter >> 1) & 0x01);
    gpio_put(LED3_PIN, (counter >> 2) & 0x01);
    gpio_put(LED4_PIN, (counter >> 3) & 0x01);
}

// Debounce function to ensure stable button press readings
bool debounce(uint gpio_pin) {
    if (!gpio_get(gpio_pin)) {
        sleep_ms(50);  // Short delay to debounce
        if (!gpio_get(gpio_pin)) {
            return true;  // Button confirmed pressed
        }
    }
    return false;  // Button not pressed or noise
}

int main() {
    stdio_init_all();
    printf("Program started...\n");

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

    // Initialize the LEDs to reflect the starting value of the counter
    update_leds();

    // Main loop to poll buttons
    while (1) {
        // Check if increment button is pressed
        if (debounce(BUTTON_INC_PIN)) {
            printf("Increment button pressed!\n");
            if (counter < 15) {  // Max value is 1111 in binary
                counter++;
                update_leds();
                printf("Counter incremented to %d\n", counter);
            }
            sleep_ms(200);  // Extra delay to avoid multiple triggers
        }

        // Check if decrement button is pressed
        if (debounce(BUTTON_DEC_PIN)) {
            printf("Decrement button pressed!\n");
            if (counter > 0) {  // Min value is 0000 in binary
                counter--;
                update_leds();
                printf("Counter decremented to %d\n", counter);
            }
            sleep_ms(200);  // Extra delay to avoid multiple triggers
        }
    }

    return 0;
}

