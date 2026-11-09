section .data
    addr:
        dw 2
        db 0x05, 0x39
        dd 0
        dq 0
    one dd 1
    msg db "Listening on port 1337", 10
    msglen equ $ - msg
    file db "messages", 0

section .bss
    buf resb 65536

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
    mov rdx, 2
    mov r10, one
    mov r8, 4
    syscall

    mov rax, 49
    mov rdi, r12
    mov rsi, addr
    mov rdx, 16
    syscall
    test rax, rax
    js .fail

    mov rax, 2
    mov rdi, file
    mov rsi, 1089
    mov rdx, 420
    syscall
    test rax, rax
    js .fail
    mov r13, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall

.loop:
    mov rax, 45
    mov rdi, r12
    mov rsi, buf
    mov rdx, 65536
    xor r10, r10
    xor r8, r8
    xor r9, r9
    syscall
    test rax, rax
    jle .loop

    mov rdx, rax
    mov rax, 1
    mov rdi, r13
    mov rsi, buf
    syscall
    jmp .loop

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
