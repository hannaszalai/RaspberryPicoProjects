#include "hardware/gpio.h"

// Function to set the direction of a specific GPIO pin
// Parameters:
//   - pin: The GPIO pin number to configure
//   - dir: The direction to set (0 for input, 1 for output)
void link_gpio_set_dir(int pin, int dir) {
    gpio_set_dir(pin, dir);
}

