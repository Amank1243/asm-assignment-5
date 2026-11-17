

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
; Languages: x86-64 Assembly
; Start Date: November 17, 2026
; Completion Date: November 17, 2026
;
; Program's Purpose:
; This file provides input and output functions using Linux
; kernel system calls. The printString function displays
; null-terminated strings using syscall 1 (write). The
; readString function reads characters from standard input
; using syscall 0 (read), stores them in a buffer, and
; null-terminates the resulting string.
;
; Project Information:
; Files: main.asm, kernel.asm, atoi.asm, itoa.asm, r.sh
; Developing Computer: Windows 11, Ubuntu via WSL
; Status: Completed and tested
; Source: Adapted from supplemental pure_assembly.asm
;         example provided by Dianella Sy.
;
; Translator Information:
; Assembler: NASM, elf64
; Linker: GNU ld
; Operating System: Ubuntu via WSL


global printString
global readString

section .data
    null       equ 0
    line_feed  equ 10
    stdin      equ 0
    stdout     equ 1
    sys_read   equ 0
    sys_write  equ 1

section .bss
    character resb 1

section .text

; printString
; Input:  rdi = address of null-terminated string
; Output: nothing
printString:
    push rbx

    mov rbx, rdi
    xor rdx, rdx

string_count_loop:
    cmp byte [rbx], null
    je string_count_done

    inc rdx
    inc rbx
    jmp string_count_loop

string_count_done:
    cmp rdx, 0
    je print_done

    mov rax, sys_write
    mov rsi, rdi
    mov rdi, stdout
    syscall

print_done:
    pop rbx
    ret


; readString
; Input:  rdi = address of destination buffer
;         rsi = buffer capacity in bytes
; Output: rax = number of characters stored
; Notes:  Reserves one byte for the null terminator.
;         Discards excess input until newline.
readString:
    push rbx
    push r12
    push r13

    mov rbx, rdi
    mov r13, rsi
    xor r12, r12

read_character:
    mov rax, sys_read
    mov rdi, stdin
    lea rsi, [rel character]
    mov rdx, 1
    syscall

    ; Stop on EOF or a read error.
    cmp rax, 1
    jne read_done

    mov al, [character]

    cmp al, line_feed
    je read_done

    ; Check whether there is room for this character.
    mov rdx, r13
    dec rdx
    cmp r12, rdx
    jae read_character

    mov [rbx + r12], al
    inc r12
    jmp read_character

read_done:
    mov byte [rbx + r12], null
    mov rax, r12

    pop r13
    pop r12
    pop rbx
    ret
