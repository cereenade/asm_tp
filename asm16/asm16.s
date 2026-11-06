section .bss
    hdr resb 64

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .usage

    mov rax, 2
    mov rdi, [rsp + 16]
    xor rsi, rsi
    xor rdx, rdx
    syscall
    test rax, rax
    js .usage
    mov r12, rax

    mov rax, 0
    mov rdi, r12
    mov rsi, hdr
    mov rdx, 64
    syscall
    mov r13, rax

    mov rax, 3
    mov rdi, r12
    syscall

    test r13, r13
    js .usage
    cmp r13, 20
    jl .no

    cmp dword [hdr], 0x464C457F
    jne .no
    cmp byte [hdr + 4], 2
    jne .no
    cmp byte [hdr + 5], 1
    jne .no
    cmp byte [hdr + 6], 1
    jne .no
    cmp word [hdr + 18], 0x3E
    jne .no

    xor rdi, rdi
    jmp .exit

.no:
    mov rdi, 1
    jmp .exit

.usage:
    mov rdi, 2

.exit:
    mov rax, 60
    syscall
