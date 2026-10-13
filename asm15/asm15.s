section .bss
    buf resb 4096

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne .usage

    mov rsi, [rsp + 16]
    xor r12, r12
    xor r13, r13

    mov al, [rsi]
    cmp al, '-'
    jne .plus
    mov r13, 1
    inc rsi
    jmp .first

.plus:
    cmp al, '+'
    jne .first
    inc rsi

.first:
    cmp byte [rsi], 0
    je .bad
    mov rbx, 26

.parse:
    movzx ecx, byte [rsi]
    test cl, cl
    jz .sign
    sub ecx, '0'
    cmp ecx, 9
    ja .bad
    mov rax, r12
    imul rax, rax, 10
    add rax, rcx
    xor edx, edx
    div rbx
    mov r12, rdx
    inc rsi
    jmp .parse

.sign:
    test r13, r13
    jz .read
    test r12, r12
    jz .read
    mov rax, 26
    sub rax, r12
    mov r12, rax

.read:
    mov rax, 0
    mov rdi, 0
    mov rsi, buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .ok
    mov r14, rax
    xor rcx, rcx

.next:
    cmp rcx, r14
    jge .write
    movzx eax, byte [buf + rcx]
    cmp al, 'a'
    jb .upper
    cmp al, 'z'
    ja .store
    mov dl, 'a'
    jmp .shift

.upper:
    cmp al, 'A'
    jb .store
    cmp al, 'Z'
    ja .store
    mov dl, 'A'

.shift:
    sub al, dl
    add al, r12b
    cmp al, 26
    jb .wrap
    sub al, 26

.wrap:
    add al, dl

.store:
    mov [buf + rcx], al
    inc rcx
    jmp .next

.write:
    mov rax, 1
    mov rdi, 1
    mov rsi, buf
    mov rdx, r14
    syscall
    jmp .read

.ok:
    xor rdi, rdi
    jmp .exit

.usage:
    mov rdi, 2
    jmp .exit

.bad:
    mov rdi, 1

.exit:
    mov rax, 60
    syscall
