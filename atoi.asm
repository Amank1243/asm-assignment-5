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
; This file converts a null-terminated ASCII string into
; a signed 64-bit integer. The atoi function processes
; individual ASCII digits, converts them into numeric values,
; and constructs the integer using multiplication and addition.
; The function also supports positive and negative signs.
; The converted integer is returned in the rax register.
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


global atoi

section .text

atoi:
    xor rax, rax        ; Initialize result to 0
    xor rcx, rcx        ; Character index
    xor r8, r8          ; Negative number flag

    ; Check for a negative sign
    cmp byte [rdi], '-'
    jne check_positive

    mov r8, 1
    inc rcx
    jmp convert_loop

check_positive:
    cmp byte [rdi], '+'
    jne convert_loop

    inc rcx

convert_loop:
    movzx rdx, byte [rdi + rcx]

    ; Stop at null terminator or non-digit
    cmp dl, '0'
    jb conversion_done

    cmp dl, '9'
    ja conversion_done

    ; Convert ASCII character into digit
    sub rdx, '0'

    ; result = result * 10 + digit
    imul rax, rax, 10
    add rax, rdx

    inc rcx
    jmp convert_loop

conversion_done:
    ; Apply negative sign if necessary
    cmp r8, 1
    jne atoi_done

    neg rax

atoi_done:
    ret
