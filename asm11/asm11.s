section .bss
buf: resb 4096
out: resb 32

section .text
global _start

_start:
    xor r12, r12

.read:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .done
    mov rcx, rax
    xor rbx, rbx

.scan:
    mov al, [buf+rbx]
    cmp al, 'a'
    je .vowel
    cmp al, 'e'
    je .vowel
    cmp al, 'i'
    je .vowel
    cmp al, 'o'
    je .vowel
    cmp al, 'u'
    je .vowel
    jmp .next

.vowel:
    inc r12

.next:
    inc rbx
    cmp rbx, rcx
    jne .scan
    jmp .read

.done:
    mov rax, r12
    mov byte [out+31], 10
    lea rsi, [out+30]
    xor r8, r8
    test rax, rax
    jnz .conv
    mov byte [rsi], '0'
    dec rsi
    inc r8
    jmp .print

.conv:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    inc r8
    test rax, rax
    jnz .conv

.print:
    inc rsi
    mov rdx, r8
    inc rdx
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
