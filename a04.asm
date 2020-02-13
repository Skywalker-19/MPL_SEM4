      

%macro print 2
    mov rax,01;
    mov rdi,01;
    mov rsi,%1;
    mov rdx,%2;
    syscall;
%endmacro

%macro read 2
      mov rax,0
      mov rdi,0
      mov rsi,%1
      mov rdx,%2
      syscall 
       %endmacro

         section .bss
               number1: resb 5
               number2: resb 5
               choice: resb 1
               outAscii: resb 16

    section .data
  
        
        msg db 'MULTIPLICATION OF TWO NUMBERS : ' ,10          
        len equ $-msg  
        msg2 db 'Enter 1st number - ',10
        len2 equ $-msg2 
        msg3 db 'Enter 2nd number - ',10
        len3 equ $-msg3
        msg4 db '1.Multiply two numbers Using SUCCESSIVE ADDITION METHOD - ',10
        len4 equ $-msg4
        msg5 db '2.Multiply two numbers Using ADD AND SHIFT METHOD (BOOTHS ALGORITHM)- ',10
        len5 equ $-msg5
        msg6 db '3.Exit : ' ,10
        len6 equ $-msg6
        msg7 db 'OUTPUT : ' ,10
        len7 equ $-msg7


menu:
mov rax, 1
   mov rdi,1
   mov rsi, msg           ;prints msg
   mov rdx, len
   syscall
  
mov rax, 1
   mov rdi,1
   mov rsi, msg4            ;prints msg
   mov rdx, len4
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
		je successive

    cmp byte[choice],32h
		je shift

  cmp byte[choice],33h
		je exit
  


      

     section .text
        global _start
        _start:
        call menu

   newline:  db 10d
    

successive:
     call accept
    
    xor rbx,rbx
    mov rsi,number1
    call atoh
    mov rcx,rax


    xor rax,rax 

    xor rsi,rsi
    mov rsi,number2
    call atoh
    xor rdx,rdx
    mov rdx,rax
    xor rax,rax

     sum:
         add rax,rdx
         dec rcx
         jnz sum


call HToA
jmp print_asc


shift:
      call accept

    mov rsi,number1
    call atoh
    mov rcx,rax


    xor rax,rax 

    xor rsi,rsi
    mov rsi,number2
    call atoh
    xor rbx,rbx
    mov rbx,rax
    
    xor rax,rax
    
         algo:
             ;mov rdx,rcx
             shr rcx,1
             jnc move
               add rax,rbx
             move:
                shl rbx,1
                ;mov rcx,rdx
                ;shr rcx,1
          add rcx,0h
          jnz algo

call HToA
jmp print_asc
            



exit: 
    nop
    mov rax, 60
    mov rdi, 0
    syscall


accept:
     mov rax, 1
     mov rdi,1
     mov rsi, msg2           ;prints msg
     mov rdx, len2
     syscall

  read number1,5
 
     mov rax, 1
     mov rdi,1
     mov rsi, msg3           ;prints msg
     mov rdx, len3
     syscall

  read number2,5

ret


atoh:;		//ASCII in inAscii ----> HEX in RAX

    xor rax,rax;
    begin1:
    cmp byte[rsi],0xA;	//Compare With New Line
    je done;
    rol rax,04d;
    mov bl,byte[rsi];
    cmp bl,39h;
    jbe sub30
    sub bl,07h;
    sub30:
    sub bl,30h;
    add al,bl;
    inc rsi;
    jmp begin1;

    done:
    ret

HToA:;		// HEX in RAX -----> ASCII in outAscii
    mov rsi,outAscii+15d;
    mov rcx,16d

    begin2:
    xor rdx,rdx;
    mov rbx,10h;	//16d
    div rbx;

    cmp dl,09h;
    jbe add30;
    add dl,07h;
    
    add30:
    add dl,30h;
    mov byte[rsi],dl;

    update:
    dec rsi;
    dec rcx;
    jnz begin2;

    ret

  
print_asc:
   mov rax, 1
   mov rdi,1
   mov rsi, msg7           ;prints msg
   mov rdx, len7
   syscall

   mov rax,1
   mov rdi,1
   mov rsi,outAscii
   mov rdx,16
   syscall
   
   mov rax, 1
   mov rdi,1
   mov rsi, newline            ;prints msg
   mov rdx, 1
   syscall

   mov rax, 1
   mov rdi,1
   mov rsi, newline            ;prints msg
   mov rdx, 1
   syscall

jmp menu

