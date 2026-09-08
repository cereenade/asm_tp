section .text
	global _start
section .data
    msg db "1337", 10
    msg_len equ $ - msg

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jl fail

    mov rsi, [rsp + 16]

    cmp byte [rsi], '4'
    jne fail
    cmp byte [rsi + 1], '2'
    jne fail
    cmp byte [rsi + 2], 0
    jne fail
    jmp equal

fail:
    mov rax, 60
    mov rdi, 1
    syscall

equal:
    mov rsi, msg
    mov rdx, msg_len
    jmp print

print:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
