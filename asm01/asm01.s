global _start

section .data
    msg     db  "1337", 10
    msglen  equ $ - msg

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall

    mov rax, 60
    mov rdi, 0
    syscall


