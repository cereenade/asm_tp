section .rodata
digits: db "0123456789ABCDEF"

section .bss
buf: resb 32

section .text
global _start

_start:
    mov rdi, [rsp]
    cmp rdi, 4
    jne .usage
    lea r14, [rsp+16]
    mov rbx, [r14]
    call parse
    mov r12, rax
    mov rbx, [r14+8]
    call parse
    mov r13, rax
    mov rbx, [r14+16]
    call parse
    mov rcx, r12
    cmp r13, rcx
    jle .skip1
    mov rcx, r13
.skip1:
    cmp rax, rcx
    jle .skip2
    mov rcx, rax
.skip2:
    mov rax, rcx
    lea rsi, [buf+30]
    mov r8, 0
    xor r9, r9
    test rax, rax
    jns .abs_ok
    mov r9, 1
    neg rax
.abs_ok:
    test rax, rax
    jnz .conv
    mov byte [rsi], '0'
    dec rsi
    inc r8
    jmp .after
.conv:
    xor rdx, rdx
    mov rcx, 10
    div rcx
    mov dil, [digits+rdx]
    mov [rsi], dil
    dec rsi
    inc r8
    test rax, rax
    jnz .conv
.after:
    inc rsi
    test r9, r9
    je .print
    dec rsi
    mov byte [rsi], '-'
    inc r8
.print:
    mov rdx, r8
    mov rax, 1
    mov rdi, 1
    syscall
    mov byte [buf+30], 10
    mov rax, 1
    mov rdi, 1
    lea rsi, [buf+30]
    mov rdx, 1
    syscall
    xor rdi, rdi
    jmp .exit
.usage:
    mov rdi, 2
.exit:
    mov rax, 60
    syscall

parse:
    xor rax, rax
    xor r10, r10
    mov dl, [rbx]
    cmp dl, '-'
    jne .loop
    mov r10, 1
    inc rbx
    cmp byte [rbx], 0
    je .bad
.loop:
    movzx rdx, byte [rbx]
    test dl, dl
    je .end
    cmp dl, '0'
    jb .bad
    cmp dl, '9'
    ja .bad
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rbx
    jmp .loop
.end:
    test r10, r10
    je .ok
    neg rax
.ok:
    ret
.bad:
    mov rdi, 1
    mov rax, 60
    syscall
