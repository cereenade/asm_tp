section .bss
    buf resb 4096

section .text
    global _start

_start:
    xor r12, r12

.read:
    mov rdx, 4096
    sub rdx, r12
    jz .strip
    mov rax, 0
    mov rdi, 0
    lea rsi, [buf + r12]
    syscall
    test rax, rax
    jle .strip
    add r12, rax
    jmp .read

.strip:
    test r12, r12
    jz .yes
    cmp byte [buf + r12 - 1], 10
    jne .check
    dec r12

.check:
    xor rcx, rcx
    lea rdx, [r12 - 1]

.loop:
    cmp rcx, rdx
    jge .yes
    mov al, [buf + rcx]
    cmp al, [buf + rdx]
    jne .no
    inc rcx
    dec rdx
    jmp .loop

.yes:
    xor rdi, rdi
    jmp .exit

.no:
    mov rdi, 1

.exit:
    mov rax, 60
    syscall
