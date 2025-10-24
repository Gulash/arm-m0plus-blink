// Generic main - works for any Cortex-M0+ target
#include <stdint.h>

// Target-specific functions (implemented in targets/xxx/gpio.c)
extern void gpio_init(void);
extern void gpio_toggle(void);
extern void delay(uint32_t count);

int main(void) {
    gpio_init();
    
    while(1) {
        gpio_toggle();
        delay(500000);
    }
    
    return 0;
}