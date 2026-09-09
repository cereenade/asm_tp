section .bss
buf resb 64

section .text
	global _start

_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, buf
	mov edx, 64
	syscall

	cmp rax, 0
	jle .error

	mov rcx, rax
	mov rbx, 0
	mov r8, 0 
	mov r9, 0

	mov rax, 0
	mov al, [buf]
	cmp al, '-'
	je .skip_sign
	cmp al, '+'
	jne .loop

.skip_sign:
	inc rbx

.loop:
	cmp rbx, rcx
	jae .done
	mov rax, 0
	mov al, [buf + rbx]
	cmp al, 10
	je .newline
	cmp al, '0'
	jb .error
	cmp al, '9'
	ja .error
	mov r8, rax
	mov r9, 1
	inc rbx
	jmp .loop

.newline:
	inc rbx
	cmp rbx, rcx
	jne .error

.done:
	cmp r9, 0
	je .error
	and r8, 1
	mov rdi, r8
	jmp .exit

.error:
	mov rdi, 2

.exit:
	mov rax, 60
	syscall
