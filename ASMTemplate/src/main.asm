

section .data
    filename db '/home/zhero/labs/L2/Archi/hello.txt', 0
    message db 'Zahrawi say Hello', 0xA  ; Message with newline (0xA = \n)
    msg_len equ $ - message

section .text
    global main

main:
    
    enter 0,0
    ; Create file (syscall 85: creat)
    mov rax, 85             ; creat()
    mov rdi, filename       ; Filename: "hello.txt"
    mov rsi, 0644o          ; Permissions: rw-r--r--
    syscall
    
    ; Check for error (rax < 0)
    cmp rax, 0
    jl error_exit
    
    mov r8, rax             ; Save file descriptor in r8

    ; Write to file (syscall 1: write)
    mov rax, 1              ; write()
    mov rdi, r8             ; File descriptor
    mov rsi, message        ; Buffer: message to write
    mov rdx, msg_len        ; Number of bytes
    syscall
    
    ; Check for error
    cmp rax, 0
    jl error_exit
    
    ; Close file (syscall 3: close)
    mov rax, 3              ; close()
    mov rdi, r8             ; File descriptor
    syscall
    
    leave
    ; Exit successfully (syscall 60: exit)
    mov rax, 60             ; exit()
    xor rdi, rdi            ; Exit code 0
    syscall

error_exit:
    ; Exit with error code 1
    mov rax, 60             ; exit()
    mov rdi, 1              ; Exit code 1
    syscall