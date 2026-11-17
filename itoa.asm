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
; This file converts a signed 64-bit integer into a
; null-terminated ASCII string. The itoa function repeatedly
; divides the integer by 10 to extract its decimal digits.
; The digits are converted into ASCII characters and stored
; in reverse order within an output buffer. The function
; also handles zero and negative integers and returns the
; address of the resulting string in the rax register.
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


global itoa

section .text

itoa:
    ; Preserve registers
    push rbx
    push r12

    ; Copy integer into rax
    mov rax, rdi

    ; Point to the end of the output buffer
    mov rbx, rsi
    add rbx, 20

    ; Null terminate the string
    mov byte [rbx], 0

    ; Initialize negative flag
    mov r12, 0

    ; Check if number is negative
    cmp rax, 0
    jge conversion_start

    ; Remember negative sign
    mov r12, 1

    ; Convert to unsigned magnitude
    neg rax

conversion_start:
    ; Set divisor to 10
    mov rcx, 10

convert_digit:
    ; Clear upper portion of dividend
    mov rdx, 0

    ; Divide by 10
    ; Quotient goes into rax
    ; Remainder goes into rdx
    div rcx

    ; Convert remainder into ASCII
    add dl, '0'

    ; Move backward through buffer
    dec rbx

    ; Store digit
    mov byte [rbx], dl

    ; Repeat until quotient is zero
    cmp rax, 0
    jne convert_digit

    ; Check whether a minus sign is needed
    cmp r12, 1
    jne conversion_done

    ; Add negative sign
    dec rbx
    mov byte [rbx], '-'

conversion_done:
    ; Return address of ASCII string
    mov rax, rbx

    ; Restore registers
    pop r12
    pop rbx

    ret
