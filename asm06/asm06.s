global _start

section .text

_start:
    cmp qword [rsp], 3
    jl .exit

    mov rsi, [rsp + 16]
    call atoi
    mov r12, rax

    mov rsi, [rsp + 24]
    call atoi

    add rax, r12
    call print_num

.exit:
    mov rax, 60
    mov rdi, 0
    syscall

atoi:
    mov rax, 0
    mov r8, 1
    cmp byte [rsi], '-'
    jne .loop
    mov r8, -1
    inc rsi

.loop:
    movzx rcx, byte [rsi]
    cmp rcx, 0
    je .done
    sub rcx, '0'
    imul rax, rax, 10
    add rax, rcx
    inc rsi
    jmp .loop

.done:
    imul rax, r8
    ret

print_num:
    mov rdi, buf + 30
    mov byte [rdi], 10
    mov r9, 1
    mov r8, 0
    cmp rax, 0
    jge .digits
    mov r8, 1
    neg rax

.digits:
    mov rdx, 0
    mov rcx, 10
    div rcx
    add rdx, '0'
    dec rdi
    mov [rdi], dl
    inc r9
    cmp rax, 0
    jne .digits

    cmp r8, 0
    je .write
    dec rdi
    mov byte [rdi], '-'
    inc r9

.write:
    mov rax, 1
    mov rsi, rdi
    mov rdi, 1
    mov rdx, r9
    syscall
    ret

section .bss
buf: resb 32
