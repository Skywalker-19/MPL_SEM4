%macro read 2
      mov rax,0
      mov rdi,0
      mov rsi,%1
      mov rdx,%2
      syscall 
       %endmacro
 
 
 
 
       section .bss
               digitSpace resb 100
               digitSpacePos resb 8
               choice resb 1
 
 
        section .data
        array: dq 1,2,6,14
 
        count: equ 4
        count1: equ 4
        msg db 'Destination Array : ' ,10          
        len equ $-msg  
        msg2 db '1.Non-Overlapping without STRING ',10
        len2 equ $-msg2 
        msg3 db '2.Overlapping without STRING ',10
        len3 equ $-msg3
        msg4 db 'Original Array : ' ,10
        len4 equ $-msg4
 
      msg5 db '3.Non-Overlapping with STRING ',10
        len5 equ $-msg5
        msg6 db '4.Overlapping with STRING ',10
        len6 equ $-msg6
 
      des: dq 0,0,0,0  
 
     section .text
        global _start
        _start:
              mov rsi,array 
              mov rdi,des
              mov rdx, count
 
 
 
mov rax, 1
   mov rdi,1
   mov rsi, msg2            ;prints msg
   mov rdx, len2
   syscall
 
mov rax, 1
   mov rdi,1
   mov rsi, msg3           ;prints msg
   mov rdx, len3
   syscall
 
mov rax, 1
   mov rdi,1
   mov rsi, msg5           ;prints msg
   mov rdx, len5
   syscall
 
mov rax, 1
   mov rdi,1
   mov rsi, msg6           ;prints msg
   mov rdx, len6
   syscall
 
  read choice,2
  cmp byte[choice],31h
		je l10
 
		cmp byte[choice],32h
		je l11
 
cmp byte[choice],33h
		je l12
 
cmp byte[choice],34h
		je l13
 
 
;NON-OVERLAPPING
l12:
    mov rsi,array
    mov rdi,des
    mov rcx,count
    cld 
    rep movsq
    jmp pm
 
l10:
             mov rsi,array 
              mov rdi,des
              mov rdx, count
l1: 
mov rax, [rsi] 
mov [rdi], rax
add rsi,8
add rdi,8
dec rdx
   cmp rdx, 0
   jne l1 
 
   pm:
   mov rax, 1
   mov rdi,1
   mov rsi, msg4           ;prints msg
   mov rdx, len4
   syscall
 
  call printArray00
 
   mov rax, 1
   mov rdi,1
   mov rsi, msg            ;prints msg
   mov rdx, len
   syscall
 
   call printArray          ;calls print array function
 
 
jmp exit
 
 
;OVERLAPPING
 
l13:
    mov rsi,array
    mov rax,count
    mov rbx,8
    mul rbx
    mov rdi,array
    add rdi,rax
    mov rcx,count
    cld 
    rep movsq
    jmp pm2
 
 
            l11:
            mov rsi,array 
            mov rdx, count 
        l2: 
           mov rax,[rsi]
           push rax
           add rsi,8
           dec rdx
           cmp rdx, 0
           jne l2
 
       l3: 
       pop rax
       mov [rsi],rax
       add rsi,8
       inc rdx
       cmp rdx,count
       jne l3
 
       pm2:
       ;Displays the message
       mov rax, 1
       mov rdi,1
       mov rsi, msg4           ;prints msg
       mov rdx, len4
       syscall
 
 call printArray00 
 
      mov rax, 1
       mov rdi,1
       mov rsi, msg         ;prints msg
       mov rdx, len
       syscall
 
       call printArray2 
                ;calls print array function
 
jmp exit
 
exit: 
    nop
    mov rax, 60
    mov rdi, 0
    syscall
 
 
;PRINTING NON-OVERLAPPING ARRAY
 
printArray00:
 
    mov rsi, array            ;address array with rdx
    mov rdx, count1
    begin00: 
    mov rax,rsi
    push rsi
    push rdx
    call _printRAX  
 
 pop rdx
    pop rsi
 
    mov rax,[rsi]
    push rsi
    push rdx
    call _printRAX
    pop rdx
    pop rsi
    add rsi,8
    dec rdx
    jne begin00
 
    ret
 
    printArray:
 
    mov rsi, des            ;address array with rdx
    mov rdx, count
    begin: 
    mov rax,rsi
    push rsi
    push rdx
    call _printRAX  
 
pop rdx
    pop rsi
 
    mov rax,[rsi]
   push rsi
    push rdx
    call _printRAX
 
    pop rdx
    pop rsi
    add rsi,8
    dec rdx
    jne begin
 
    ret
 
 
_printRAX:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx
 
_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48
 
    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx
 
    pop rax
    cmp rax, 0
    jne _printRAXLoop
 
_printRAXLoop2:
    mov rcx, [digitSpacePos]
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall
 
    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx
 
    cmp rcx, digitSpace
    jge _printRAXLoop2
 
    ret
 
 
;PRINTING OVERLAPPING ARRAY
 
 
 
printArray2:
 
    ;add rsi,8
    mov rdx,count
    begin2: 
    mov rax,rsi
    push rsi
    push rdx
    call _printRAX2  
 
   pop rdx
    pop rsi  
 
    mov rax,[rsi]
   push rsi
    push rdx
    call _printRAX2 
 
    pop rdx
    pop rsi
    add rsi,8
    dec rdx
    jne begin2
 
    ret
 
_printRAX2:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx
 
_printRAXLoop3:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48
 
    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx
 
    pop rax
    cmp rax, 0
    jne _printRAXLoop3
 
_printRAXLoop4:
    mov rcx, [digitSpacePos]
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall
 
    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx
 
    cmp rcx, digitSpace
    jge _printRAXLoop4
 
    ret
 
 
 
 
 
 
 
printAdd:
    mov rsi, des            ;address array with rdx
    mov rdx, count
 
    begin99: 
    push rsi
    add rsi,8
    dec rdx
    jne begin99
 
    mov rdx,count
    print:
 
       pop rsi
       mov rbx,rsi
       mov rcx,[rsi]
 
       mov rax, 1
       mov rdi,1
       mov rsi, rcx          
       mov rdx, count
       syscall
 
 
       mov rax, 1
       mov rdi,1
       mov rsi, rbx           
       mov rdx, count
       syscall
 
       dec rdx
       jne begin99
       ret
 