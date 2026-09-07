global _start

section .data
    msg     db  "1337", 10
    msglen equ $ - msg

section .bss
	buf resb 4

section .text
 _start:

  mov rax, 0
  mov rdi, 0
  mov rsi, buf
  mov rdx, 4
  syscall

  cmp rax, 3
  jne fail
  cmp byte [buf], '4'
  jne fail
  cmp byte [buf+1], '2'
  jne fail

  mov rax, 1
  mov rdi, 1
  mov rsi, msg
  mov rdx, msglen
  syscall

 mov rax, 60
 mov rdi, 0
 syscall

fail:

  mov rax, 60
  mov rdi, 1
  syscall
