section .bss
    buf resb 4097

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
    jz .exit
    cmp byte [buf + r12 - 1], 10
    jne .reverse
    dec r12

.reverse:
    xor rcx, rcx
    lea rdx, [r12 - 1]

.swap:
    cmp rcx, rdx
    jge .print
    mov al, [buf + rcx]
    mov bl, [buf + rdx]
    mov [buf + rcx], bl
    mov [buf + rdx], al
    inc rcx
    dec rdx
    jmp .swap

.print:
    mov byte [buf + r12], 10
    inc r12
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, r12
    syscall

.exit:
    mov rax, 60
    xor rdi, rdi
    syscall
