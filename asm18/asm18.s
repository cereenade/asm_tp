section .data
    addr:
        dw 2
        db 0x05, 0x39
        db 127, 0, 0, 1
        dq 0
    tv:
        dq 1
        dq 0
    req db "Hello", 10
    reqlen equ $ - req

section .bss
    buf resb 4096

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 2
    xor rdx, rdx
    syscall
    test rax, rax
    js .fail
    mov r12, rax

    mov rax, 54
    mov rdi, r12
    mov rsi, 1
    mov rdx, 20
    mov r10, tv
    mov r8, 16
    syscall
    test rax, rax
    js .fail

    mov rax, 44
    mov rdi, r12
    mov rsi, req
    mov rdx, reqlen
    xor r10, r10
    mov r8, addr
    mov r9, 16
    syscall
    test rax, rax
    js .fail

    mov rax, 45
    mov rdi, r12
    mov rsi, buf
    mov rdx, 4096
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    test rax, rax
    jle .fail
    mov r13, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, r13
    syscall

    mov rax, 3
    mov rdi, r12
    syscall

    xor rdi, rdi
    jmp .exit

.fail:
    mov rdi, 1

.exit:
    mov rax, 60
    syscall
