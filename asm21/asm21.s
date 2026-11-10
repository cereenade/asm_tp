section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .usage

    mov rsi, [rsp + 16]
    xor rdx, rdx

.len:
    cmp byte [rsi + rdx], 0
    je .alloc
    inc rdx
    jmp .len

.alloc:
    test rdx, rdx
    jz .usage
    mov r12, rsi
    mov r13, rdx

    mov rax, 9
    xor rdi, rdi
    mov rsi, rdx
    mov rdx, 7
    mov r10, 0x22
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax
    js .fail
    mov r14, rax

    mov rdi, r14
    mov rsi, r12
    mov rcx, r13
    rep movsb

    jmp r14

.usage:
    mov rax, 60
    mov rdi, 2
    syscall

.fail:
    mov rax, 60
    mov rdi, 1
    syscall
