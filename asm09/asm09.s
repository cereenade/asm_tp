section .rodata
digits: db "0123456789ABCDEF"

section .bss
buf: resb 64

section .text
global _start

_start:
 mov rdi, [rsp]
 lea rsi, [rsp+8]
 mov r12, 16

 cmp rdi, 2
 je .one_arg
 cmp rdi, 3
 jne .usage

 mov rbx, [rsi+8]
 cmp byte [rbx], '-'
 jne .usage
 cmp byte [rbx+1], 'b'
 jne .usage
 cmp byte [rbx+2], 0
 jne .usage
 mov r12, 2
 mov rbx, [rsi+16]
 jmp .parse

.one_arg:
 mov rbx, [rsi+8]

.parse:
 xor rax, rax
 xor rcx, rcx
 mov dl, [rbx]
 cmp dl, '-'
 jne .digits_loop
 mov rcx, 1
 inc rbx
 cmp byte [rbx], 0
 je .not_num

.digits_loop:
 movzx rdx, byte [rbx]
 test dl, dl
 je .done_parse
 cmp dl, '0'
 jb .not_num
 cmp dl, '9'
 ja .not_num
 sub dl, '0'
 imul rax, rax, 10
 add rax, rdx
 inc rbx
 jmp .digits_loop

.done_parse:
test rcx, rcx
je .positive
neg rax

.positive:
push rcx
mov r13, rax
test rax, rax
jns .abs_ok
neg rax

.abs_ok:

lea rsi, [buf+63]
mov rcx, 0

test rax, rax
jnz .conv
mov byte [rsi], '0'
dec rsi
inc rcx
jmp .after_conv

.conv:
xor rdx, rdx
div r12
mov dil, [digits+rdx]
mov [rsi], dil
dec rsi
inc rcx
test rax, rax
jnz .conv

.after_conv:
inc rsi
pop rax
test rax, rax
je .print
dec rsi
mov byte [rsi], '-'
inc rcx

.print:
mov rdx, rcx
mov rax, 1
mov rdi, 1
syscall

mov byte [buf+63], 10
mov rax, 1
mov     rdi, 1
lea     rsi, [buf+63]
mov     rdx, 1
syscall

xor rdi, rdi
jmp .exit

.not_num:
mov rdi, 1
jmp .exit

.usage:
mov rdi, 2

.exit:
mov rax, 60
syscall
