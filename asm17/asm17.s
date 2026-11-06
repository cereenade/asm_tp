section .data
    new db "H4CK"

section .bss
    buf resb 1048576

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .usage

    mov rax, 2
    mov rdi, [rsp + 16]
    mov rsi, 2
    xor rdx, rdx
    syscall
    test rax, rax
    js .fail
    mov r12, rax
    xor r13, r13

.read:
    mov rdx, 1048576
    sub rdx, r13
    jz .search
    mov rax, 0
    mov rdi, r12
    lea rsi, [buf + r13]
    syscall
    test rax, rax
    js .fail
    jz .search
    add r13, rax
    jmp .read

.search:
    cmp r13, 4
    jl .fail
    xor rcx, rcx
    lea rdx, [r13 - 4]

.loop:
    cmp rcx, rdx
    jg .fail
    cmp dword [buf + rcx], "1337"
    je .patch
    inc rcx
    jmp .loop

.patch:
    mov rax, 18
    mov rdi, r12
    mov rsi, new
    mov rdx, 4
    mov r10, rcx
    syscall
    cmp rax, 4
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
