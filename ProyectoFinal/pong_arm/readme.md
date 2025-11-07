# Instructions for installing QEMU using Linux

## Step 1: Install Required Tools


### Update package list
``sudo apt update``
### Install QEMU for ARM
``sudo apt install qemu-system-arm``

### Install ARM cross-compiler toolchain
`sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi`

### Install build tools (if not already installed)
`sudo apt install build-essential gdb-multiarch`

## Step 2: Verify installation

### Check QEMU version
`qemu-system-arm --version`

### Check compiler
`arm-none-eabi-gcc --version`

### List available ARM machines in QEMU
`qemu-system-arm -machine help`

## To run the game

### compile
`make`

### run

`make run`
