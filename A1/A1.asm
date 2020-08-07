     section .bss
              pcount resb 1
              ncount resb 1
 
        section .data
        array: dq 1,2,-4,7,-5,0,8,-9,6,-3
        count: equ 10
        newline : db 10
        pMsg db 'No. of positive elements : '           ;Ask the user to enter a number
        lenpMsg equ $-pMsg                              ;The length of the message
        nMsg db 'No. of negative elements : '           ;Ask the user to enter a number
        lennMsg equ $-nMsg                              ;The length of the message
 
 
     section .text
 
    global _start
    _start:
    mov rsi,array                                         ;copying base address of array in rsi
    mov r8,00h                                            ;initializing register for positive numbers
    mov r9,00h                                            ;initializing register for negative numbers
    mov rdx, count
 
     l11:
        mov rax,[rsi]
        add rax,0h                                             ;condition for js, checks sign bit
        js l1
        inc r8                                                 ;positive increment  
        jmp l
     l1:
        inc r9                                                 ;negative increment
     l:
        add rsi,8
        dec rdx
        jnz l11
        cmp rdx,10;                                             ;condition for comparing with 10
        jne convert1
        add r8,37h                                                   ;converting to ascii value
        mov [pcount],r8                                              ;storing no. of positive numbers in pcount
        add r9,37h
        mov [ncount],r9                                              ;positive increment  
 
 
   convert1:
   add r8,30h                                                   ;converting to ascii value
   mov [pcount],r8                                              ;storing no. of positive numbers in pcount
   add r9,30h
   mov [ncount],r9                                               ;storing no. of negative numbers in ncount
 
   mov rax,1                                                     ;Displaying messages....
   mov rdi,1
   mov rsi,pMsg
   mov rdx,lenpMsg
   syscall
 
   mov rax,1
   mov rdi,1
   mov rsi,pcount
   mov rdx,1
    syscall
 
      mov rax,1
   mov rdi,1
   mov rsi,newline
   mov rdx,1
    syscall
 
   mov rax,1
   mov rdi,1
   mov rsi,nMsg
   mov rdx,lennMsg
   syscall
 
   mov rax,1
   mov rdi,1
   mov rsi,ncount
   mov rdx,1
   syscall
 
 exit: 
    nop
    mov rax, 60
    mov rdi, 0
    syscall