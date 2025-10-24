# STM32C071RB Target Configuration

# MCU specific settings
MCU = cortex-m0plus
ARCH = armv6-m

# Memory configuration
FLASH_SIZE = 128K
RAM_SIZE = 12K

# Target specific source files (relative to target directory)
TARGET_SOURCES = gpio.c startup.c

# Linker script (relative to target directory)
LDSCRIPT = linker.ld

# Additional flags (optional)
TARGET_CFLAGS = 
TARGET_LDFLAGS =