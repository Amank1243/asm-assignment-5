
#!/bin/bash

# Program Name: Assignment 5 - Kernel Functions
# Course: CPSC 240, Fall 2026
# Purpose: Assemble, link, and execute the program.

# Stop if any command fails
set -e

echo "Remove old executable files if there are any"
rm -f *.out

echo "Assemble the X86 file main.asm"
nasm -f elf64 -l main.lis -o main.o main.asm

echo "Assemble the X86 file kernel.asm"
nasm -f elf64 -l kernel.lis -o kernel.o kernel.asm

echo "Assemble the X86 file atoi.asm"
nasm -f elf64 -l atoi.lis -o atoi.o atoi.asm

echo "Assemble the X86 file itoa.asm"
nasm -f elf64 -l itoa.lis -o itoa.o itoa.asm

echo "Link the four object files"
ld -o go.out main.o kernel.o atoi.o itoa.o -g

echo "The Kernel Functions program will now run"
./go.out
