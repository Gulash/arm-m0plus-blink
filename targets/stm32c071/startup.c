// Minimal startup for STM32C071RB
#include <stdint.h>

// Stack top (end of RAM - 12KB for STM32C071RB)
#define STACK_TOP 0x20003000

// Forward declarations
void Reset_Handler(void);
void Default_Handler(void);

// Weak aliases for all exceptions/interrupts
void NMI_Handler(void) __attribute__((weak, alias("Default_Handler")));
void HardFault_Handler(void) __attribute__((weak, alias("Default_Handler")));

// External reference to main
extern int main(void);

// Vector table
__attribute__((section(".isr_vector")))
void (* const vector_table[])(void) = {
    (void (*)(void))STACK_TOP,  // Initial Stack Pointer
    Reset_Handler,               // Reset Handler
    NMI_Handler,                 // NMI Handler
    HardFault_Handler,           // Hard Fault Handler
};

// Reset handler - entry point after reset
void Reset_Handler(void) {
    // Call main
    main();
    
    // Infinite loop if main returns
    while(1);
}

// Default handler for unused interrupts
void Default_Handler(void) {
    while(1);
}