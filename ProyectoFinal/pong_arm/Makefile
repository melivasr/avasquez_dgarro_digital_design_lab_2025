# Makefile for ARM bare-metal development

# Toolchain
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJCOPY = arm-none-eabi-objcopy

# Flags
ASFLAGS = -mcpu=arm926ej-s -g
LDFLAGS = -T linker.ld

# Files
OBJECTS = startup.o main.o
TARGET = kernel.elf
BINARY = kernel.bin

# Build rules
all: $(BINARY)

$(BINARY): $(TARGET)
	$(OBJCOPY) -O binary $< $@

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f *.o $(TARGET) $(BINARY)

# Run in QEMU
run: $(BINARY)
	qemu-system-arm -M versatilepb -cpu arm926 -m 128M -kernel kernel.bin -serial stdio

# Run with debugging
debug: $(BINARY)
	qemu-system-arm -M versatilepb -cpu arm926 -nographic -kernel $(BINARY) -s -S

.PHONY: all clean run debug
