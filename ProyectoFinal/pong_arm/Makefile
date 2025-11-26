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
OBJECTS = startup.o graphics.o score.o ball.o paddle.o gameover.o main.o
TARGET = kernel.elf
BINARY = kernel.bin
# Build rules
all:
	arm-none-eabi-as -mcpu=arm926ej-s -g -o startup.o startup.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o graphics.o graphics.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o score.o score.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o ball.o ball.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o paddle.o paddle.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o gameover.o gameover.s
	arm-none-eabi-as -mcpu=arm926ej-s -g -o main.o main.s
	arm-none-eabi-ld -T linker.ld -o kernel.elf startup.o graphics.o score.o ball.o paddle.o gameover.o main.o
	arm-none-eabi-objcopy -O binary kernel.elf kernel.bin
clean:
	rm -f *.o $(TARGET) $(BINARY)
# Run in QEMU
run: $(BINARY)
	qemu-system-arm -M versatilepb -cpu arm926 -m 128M -kernel kernel.bin -serial stdio
# Run with debugging
debug: $(BINARY)
	qemu-system-arm -M versatilepb -cpu arm926 -nographic -kernel $(BINARY) -s -S
.PHONY: all clean run debug