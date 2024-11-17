#include "pico/stdlib.h"

#define LED_PIN 0
#define BUTTON1_PIN 1
#define BUTTON2_PIN 2

int main() {
    // Initialize the GPIO pins
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);  // Set GP0 as output for LED
    gpio_init(BUTTON1_PIN);
    gpio_set_dir(BUTTON1_PIN, GPIO_IN);  // Set GP1 as input for button
    gpio_pull_up(BUTTON1_PIN);  // Enable pull-up resistor on GP1
    gpio_init(BUTTON2_PIN);
    gpio_set_dir(BUTTON2_PIN, GPIO_IN);  // Set GP2 as input for button
    gpio_pull_up(BUTTON2_PIN);  // Enable pull-up resistor on GP2

    while (true) {
        if (gpio_get(BUTTON1_PIN) == 0) {  // Button on GP1 pressed
            gpio_put(LED_PIN, 1);  // Turn on LED
        }
        if (gpio_get(BUTTON2_PIN) == 0) {  // Button on GP2 pressed
            gpio_put(LED_PIN, 0);  // Turn off LED
        }
    }
    return 0;
}

