section .data
    msg db "Hello Universe!", 10
    len equ $ - msg

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .usage

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 577
    mov rdx, 420
    syscall
    test rax, rax
    js .fail
    mov r12, rax

    mov rax, 1
    mov rdi, r12
    mov rsi, msg
    mov rdx, len
    syscall
    cmp rax, len
    jne .fail

    mov rax, 3
    mov rdi, r12
    syscall

    xor rdi, rdi
    jmp .exit

.usage:
    mov rdi, 2
    jmp .exit

.fail:
    mov rdi, 1

.exit:
    mov rax, 60
    syscall
