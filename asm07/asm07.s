section .bss
	buf resb 32

section .text
global _start

_start:
xor eax, eax
xor edi, edi
lea rsi, [rel buf]
mov edx, 32
syscall

xor r8, r8
lea rsi, [rel buf]
mov rcx, rax

.parse:
test rcx, rcx
jz .check
movzx rax, byte [rsi]
cmp al, '0'
jb .check
cmp al, '9'
ja .check
sub al, '0'
imul r8, r8, 10
movzx rax, al
add r8, rax
inc rsi
dec rcx
jmp .parse

.check:
cmp r8, 2
jb .notprime
je .prime
test r8, 1
jz .notprime
mov rbx, 3

.loop:
mov rax, rbx
mul rbx
cmp rax, r8
ja .prime
mov rax, r8
xor rdx, rdx
div rbx
test rdx, rdx
jz .notprime
add rbx, 2
jmp .loop

.prime:
mov eax, 60
xor edi, edi
syscall

.notprime:
mov eax, 60
mov edi, 1
syscall 

