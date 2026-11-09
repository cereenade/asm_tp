section .data
    addr:
        dw 2
        db 0x10, 0x92
        dd 0
        dq 0
    one dd 1
    msg db "Listening on port 4242", 10
    msglen equ $ - msg
    pong db "PONG", 10
    bye db "Goodbye!", 10
    unk db "Unknown command", 10
    unklen equ $ - unk

section .bss
    buf resb 4096

section .text
    global _start

_start:
    mov rax, 41
    mov rdi, 2
    mov rsi, 1
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

    mov rax, 50
    mov rdi, r12
    mov rsi, 16
    syscall
    test rax, rax
    js .fail

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall

.accept:
    mov rax, 43
    mov rdi, r12
    xor rsi, rsi
    xor rdx, rdx
    syscall
    test rax, rax
    js .accept
    mov r13, rax
    xor r14, r14

.read:
    mov rdx, 4096
    sub rdx, r14
    jnz .doread
    xor r14, r14
    mov rdx, 4096

.doread:
    mov rax, 0
    mov rdi, r13
    lea rsi, [buf + r14]
    syscall
    test rax, rax
    jle .close
    add r14, rax
    xor r15, r15

.scan:
    mov rcx, r15

.find:
    cmp rcx, r14
    jge .shift
    cmp byte [buf + rcx], 10
    je .line
    inc rcx
    jmp .find

.line:
    mov rbx, rcx
    lea rsi, [buf + r15]
    mov rdx, rcx
    sub rdx, r15
    test rdx, rdx
    jz .unknown
    cmp byte [rsi + rdx - 1], 13
    jne .cmd
    dec rdx

.cmd:
    cmp rdx, 4
    jne .rev
    cmp dword [rsi], "PING"
    je .pong
    cmp dword [rsi], "EXIT"
    je .bye
    jmp .unknown

.rev:
    cmp rdx, 8
    jl .unknown
    cmp dword [rsi], "REVE"
    jne .unknown
    cmp dword [rsi + 4], "RSE "
    jne .unknown
    add rsi, 8
    sub rdx, 8
    mov rdi, rsi
    lea r8, [rsi + rdx - 1]

.swap:
    cmp rdi, r8
    jge .revdone
    mov al, [rdi]
    mov r9b, [r8]
    mov [rdi], r9b
    mov [r8], al
    inc rdi
    dec r8
    jmp .swap

.revdone:
    mov byte [rsi + rdx], 10
    inc rdx
    call send
    jmp .next

.pong:
    mov rsi, pong
    mov rdx, 5
    call send
    jmp .next

.unknown:
    mov rsi, unk
    mov rdx, unklen
    call send
    jmp .next

.bye:
    mov rsi, bye
    mov rdx, 9
    call send
    jmp .close

.next:
    lea r15, [rbx + 1]
    jmp .scan

.shift:
    mov rax, r14
    sub rax, r15
    mov rcx, rax
    lea rsi, [buf + r15]
    mov rdi, buf
    rep movsb
    mov r14, rax
    jmp .read

.close:
    mov rax, 3
    mov rdi, r13
    syscall
    jmp .accept

.fail:
    mov rax, 60
    mov rdi, 1
    syscall

send:
    mov rax, 44
    mov rdi, r13
    mov r10, 0x4000
    xor r8, r8
    xor r9, r9
    syscall
    ret
