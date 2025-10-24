# Root Makefile for ARM Cortex-M0+ Blink Project
# Usage: make TARGET=stm32c071 or make TARGET=mspm0c1104

# Default target if none specified
TARGET ?= stm32c071

# Directories
SRC_DIR = src
TARGET_DIR = targets/$(TARGET)
BUILD_DIR = build/$(TARGET)

# Toolchain
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# Include target-specific configuration
include $(TARGET_DIR)/target.mk

# Common source files
COMMON_SOURCES = $(SRC_DIR)/main.c

# All sources (common + target-specific, with paths)
SOURCES = $(COMMON_SOURCES) $(addprefix $(TARGET_DIR)/, $(TARGET_SOURCES))

# Output files
ELF = $(BUILD_DIR)/$(TARGET)-blink.elf
BIN = $(BUILD_DIR)/$(TARGET)-blink.bin
HEX = $(BUILD_DIR)/$(TARGET)-blink.hex
SREC = $(BUILD_DIR)/$(TARGET)-blink.srec
MAP = $(BUILD_DIR)/$(TARGET)-blink.map

# Compiler flags (freestanding)
CFLAGS = -mcpu=$(MCU) -mthumb
CFLAGS += -O0 -g3
CFLAGS += -Wall -Wextra
CFLAGS += -ffreestanding
CFLAGS += $(TARGET_CFLAGS)

# Linker flags (freestanding - no C library)
LDFLAGS = -mcpu=$(MCU) -mthumb
LDFLAGS += -T $(TARGET_DIR)/$(LDSCRIPT)
LDFLAGS += -Wl,-Map=$(MAP)
LDFLAGS += -nostdlib
LDFLAGS += -ffreestanding
LDFLAGS += $(TARGET_LDFLAGS)

# Default target
.PHONY: all
all: $(ELF) $(BIN) $(HEX) $(SREC)
	@echo ========================================
	@echo Build complete for $(TARGET)
	@echo ========================================
	$(SIZE) $(ELF)

# Build ELF
$(ELF): $(SOURCES) $(TARGET_DIR)/$(LDSCRIPT) | $(BUILD_DIR)
	@echo Building for target: $(TARGET)
	$(CC) $(CFLAGS) $(SOURCES) $(LDFLAGS) -o $@

# Generate binary
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

# Generate hex
$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

# Generate S-record
$(SREC): $(ELF)
	$(OBJCOPY) -O srec $< $@

# Create build directory (Windows compatible)
$(BUILD_DIR):
	-@if not exist build mkdir build 2>nul
	-@if not exist "build\$(TARGET)" mkdir "build\$(TARGET)" 2>nul

# Clean current target
.PHONY: clean
clean:
	-@if exist "build\$(TARGET)" rmdir /s /q "build\$(TARGET)" 2>nul
	@echo Cleaned $(TARGET)

# Clean all targets
.PHONY: clean-all
clean-all:
	-@if exist build rmdir /s /q build 2>nul
	@echo Cleaned all targets

# Help
.PHONY: help
help:
	@echo ARM Cortex-M0+ Blink Project
	@echo.
	@echo Usage:
	@echo   make TARGET=stm32c071     - Build for STM32C071RB
	@echo   make TARGET=mspm0c1104    - Build for TI MSPM0C1104
	@echo   make clean                - Clean current target
	@echo   make clean-all            - Clean all targets
	@echo.
	@echo Available targets:
	@echo   stm32c071
	@echo   mspm0c1104 (coming soon)