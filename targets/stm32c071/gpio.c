// STM32C071RB GPIO implementation
// LED on PA5 (Arduino D13 on Nucleo board)

#include <stdint.h>

// STM32C071RB Memory Map
#define RCC_BASE        0x40021000
#define GPIOA_BASE      0x50000000

// RCC Registers
#define RCC_IOPENR      (*(volatile uint32_t *)(RCC_BASE + 0x34))

// GPIOA Registers
#define GPIOA_MODER     (*(volatile uint32_t *)(GPIOA_BASE + 0x00))
#define GPIOA_ODR       (*(volatile uint32_t *)(GPIOA_BASE + 0x14))

void gpio_init(void) {
    // Enable GPIOA clock
    RCC_IOPENR |= (1 << 0);
    
    // Set PA5 as output (bits 11:10 = 01)
    GPIOA_MODER &= ~(3 << 10);  // Clear bits
    GPIOA_MODER |= (1 << 10);   // Set as output
}

void gpio_toggle(void) {
    GPIOA_ODR ^= (1 << 5);  // Toggle PA5
}

void delay(uint32_t count) {
    while(count--) {
        __asm__("nop");
    }
}