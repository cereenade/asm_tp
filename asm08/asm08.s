section .text
    global _start

_start:
mov rax, [rsp]
cmp rax, 2
jne .err2

mov rsi, [rsp+16]
xor rax, rax
xor rcx, rcx

.parse:
 movzx rdx, byte [rsi]
 test  dl, dl
 jz .parsed
 cmp dl, '0'
 jl .err1
 cmp dl, '9'
 jg .err1
 sub dl, '0'
 imul rax, rax, 10
 add rax, rdx
 inc rsi
 inc rcx
 jmp .parse

.parsed:
 test rcx, rcx
 jz .err1

cmp rax, 1
jle .zero_sum
mov rbx, rax
dec rbx
imul rbx, rax
shr rbx, 1
jmp .print

.zero_sum:
xor rbx, rbx

.print:
mov rax, rbx
lea rdi, [rel buffer+31]
mov byte [rdi], 10
test rax, rax
jz .zero_case
mov rcx, 10

.loop:
xor rdx, rdx
div rcx
add dl, '0'
dec rdi
mov [rdi], dl
test rax, rax
jnz .loop
jmp .write

.zero_case:
dec rdi
mov byte [rdi], '0'

.write:
lea rsi, [rel buffer+32]
sub rsi, rdi
mov rdx, rsi
mov rsi, rdi
mov rdi, 1
mov rax, 1
syscall
    
xor rdi, rdi
mov rax, 60
syscall

.err1:
mov rdi, 1
mov rax, 60
syscall

.err2:
 mov rdi, 2
mov rax, 60
syscall

section .bss
    buffer resb 32
