global _start

section .text

_start:

    cmp qword [rsp], 2
    jl  .exit
    mov rsi, [rsp + 16]
    mov rdx, 0

.len:
    cmp byte [rsi + rdx], 0
    je  .print
    inc rdx
    jmp .len

.print:
    mov rax, 1
    mov rdi, 1
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

.exit:
    mov rax, 60
    mov rdi, 0
    syscall

section .rodata
nl: db 10
