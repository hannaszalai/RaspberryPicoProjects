#include "hardware/gpio.h"

// Wrapper for gpio_set_dir
// Wrapper function for gpio_set_dir
// This function acts as a simple wrapper around the Pico SDK function gpio_set_dir, which sets the direction (input or output) of a specified GPIO pin.
void link_gpio_set_dir(int pin, int dir)
{
    gpio_set_dir(pin, dir);
}

// Wrapper for gpio_put
// This function acts as a wrapper around the Pico SDK function gpio_put, which sets the logical output value (HIGH or LOW) of a specified GPIO pin.
// If 'value' is 1, the GPIO pin will output a HIGH signal (e.g., turning an LED on).
// If 'value' is 0, the GPIO pin will output a LOW signal (e.g., turning an LED off).
void link_gpio_put(int pin, int value)
{
    gpio_put(pin, value);
}

// Wrapper for gpio_get
// This function acts as a wrapper around the Pico SDK function gpio_get, which reads the current logical value (HIGH or LOW) of a specified GPIO pin.
// The function will return 1 if the pin is currently HIGH (e.g., if a button is pressed).
// The function will return 0 if the pin is currently LOW (e.g., if a button is not pressed).
int link_gpio_get(int pin)
{
    return gpio_get(pin);
}

