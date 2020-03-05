
%include "macro.asm"

section .bss
     first_letter: resb 2
     filename: resb 64
     fileDescriptor: resq 1 
     command: resb 10;
	lenCommand resb 1;
      buffer: resb 8192;
       lenBuffer: equ $-buffer;
	
     
section .data
menu:
    msg1 db 'DOS COMMAND OPERATIONS : ' ,10          
    len1 equ $-msg1  
        msg2 db ' ENTER THE DATA - ',10
        len2 equ $-msg2 
msg7 db ' File not Present! ',10
        len7 equ $-msg7

section .text
    global _start

_start:
    print msg1,len1

    pop rbx
    pop rbx
    pop rbx

    mov rsi,first_letter
    call find_ascii

    xor rsi,rsi
    mov rsi,command
    call break_words

    cmp byte[first_letter],54h    ;54 is hexadecimal value of T of TYPE command
    je type
 

    

type:
   pop rbx
   mov rsi,filename
   call break_words
   
   FILE_OPEN filename
        cmp rax,-1d;        //-1 is returned to RAX in Case of File Opening Error
        jle error;          // jle is used for Signed Comparison
        mov [fileDescriptor],rax;   
       
        print filename,64
	
   FILE_READ [fileDescriptor],buffer,lenBuffer
   print buffer,lenBuffer
 
       print msg2,len2
        read buffer,lenBuffer

       FILE_WRITE [fileDescriptor],buffer,lenBuffer;
       print buffer,lenBuffer

exit:

		FILE_CLOSE [fileDescriptor];
		mov rax,60;
		mov rdi,00;
		syscall;

error:
        print msg7,len7;
        jmp exit        
        
    

break_words:
    
    l1:
    mov al,byte[rbx]
    mov byte[rsi],al
    inc rbx
    inc rsi
    inc rcx
    cmp byte[rbx],0h
    jne l1

ret
    
find_ascii:
       mov al,byte[rbx] 
       mov [rsi],al
ret
    
    


        

   

    


    
