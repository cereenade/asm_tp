global _start

section .data
    msg     db  "1337", 10
    msglen equ $ - msg


section .text
	global _start
section .data
    right db "1337", 10
    right_len equ $ - right

section .text
    global _start

_start:
    cmp qword [rsp], 2
    jne fail

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
    mov rsi, right
    mov rdx, right_len
    jmp print

print:
    mov rax, 1
    mov rdi, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
