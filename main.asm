; Program Name: Assignment 5 - Kernel Functions
; Copyright (C) 2026 Aman Khajuria
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License version 3 as
; published by the Free Software Foundation.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; A copy of the GNU General Public License v3 is available at:
; https://www.gnu.org/licenses/
;
; Author Information:
; Name: Aman Khajuria
; CWID: 812144988
; Section: CPSC 240-7
; Email: akhajuria@csu.fullerton.edu
;
; Program Information:
; Name: Assignment 5 - Kernel Functions
; Languages: x86-64 Assembly and Bash
; Start Date: November 17, 2026
; Completion Date: November 17, 2026
;
; Program's Purpose:
; This program demonstrates the use of Linux kernel system calls
; for input and output in x86-64 assembly. The program prompts
; the user for their full name and two integers, multiplies the
; integers, and displays their product. It also displays a
; personalized greeting and farewell message.
;
; Project Information:
; Files: main.asm, kernel.asm, atoi.asm, itoa.asm, r.sh
; Developing Computer: Windows 11, Ubuntu via WSL
; Status: Completed and tested
;
; Translator Information:
; Assembler: NASM, elf64
; Linker: GNU ld
; Operating System: Ubuntu via WSL

extern printString
extern readString
extern atoi
extern itoa

global _start

section .data

    ; Constants
    sys_exit     equ 60
    exit_success equ 0
    line_feed    equ 10
    null         equ 0

    ; Messages
    name_prompt db "Please enter your full name: ", null
    thank_message db "Thank you ", null

    first_prompt db "Please enter the first integer: ", null
    second_prompt db "Please enter the second integer: ", null

    product_message db "The product of these two integers is ", null
    farewell_message db "Have a nice career ", null

    new_line db line_feed, null
    double_new_line db line_feed, line_feed, null

section .bss

    ; Input buffers
    name_buffer resb 100
    first_buffer resb 50
    second_buffer resb 50

    ; Output buffer
    product_buffer resb 21

    ; Integer storage
    first_number resq 1
    second_number resq 1
    product resq 1

section .text

_start:

    ; Ask for the user's full name
    mov rdi, name_prompt
    call printString

    mov rdi, name_buffer
    mov rsi, 100
    call readString

    ; Print two newlines
    mov rdi, double_new_line
    call printString

    ; Thank the user
    mov rdi, thank_message
    call printString

    mov rdi, name_buffer
    call printString

    mov rdi, double_new_line
    call printString

    ; Read the first integer
    mov rdi, first_prompt
    call printString

    mov rdi, first_buffer
    mov rsi, 50
    call readString

    ; Convert ASCII to integer
    mov rdi, first_buffer
    call atoi

    mov [first_number], rax

    mov rdi, double_new_line
    call printString

    ; Read the second integer
    mov rdi, second_prompt
    call printString

    mov rdi, second_buffer
    mov rsi, 50
    call readString

    ; Convert ASCII to integer
    mov rdi, second_buffer
    call atoi

    mov [second_number], rax

    mov rdi, double_new_line
    call printString

    ; Multiply the two integers
    mov rax, [first_number]
    mov rbx, [second_number]

    imul rax, rbx

    mov [product], rax

    ; Convert product into ASCII
    mov rdi, [product]
    mov rsi, product_buffer
    call itoa

    ; Save the returned string address
    mov r12, rax

    ; Display the product
    mov rdi, product_message
    call printString

    mov rdi, r12
    call printString

    mov rdi, double_new_line
    call printString

    ; Farewell message
    mov rdi, farewell_message
    call printString

    mov rdi, name_buffer
    call printString

    mov rdi, new_line
    call printString

    ; Exit program
    mov rax, sys_exit
    mov rdi, exit_success
    syscall
