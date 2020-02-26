      
global filedescriptor,fword,buffer,lenText;
extern _Count

%include"macro.asm"

section .bss
               filename: resb 64
               fword:  resb 2
               choice: resb 1
               filedescriptor: resq 1;
               lenText: resq 1;
               buffer: resb 8192;
               lenBuffer: equ $-buffer;

section .data

        msg1 db 'FILE OPERATIONS : ' ,10          
        len1 equ $-msg1  
        msg2 db '1. Enter File Name - ',10
        len2 equ $-msg2 
        msg3 db '2. Number of Blank spaces ' ,10
        len3 equ $-msg3
        msg4 db '3. Number of lines ',10
        len4 equ $-msg4 
        msg5 db '4. Enter Character to find its Occurrence ',10
        len5 equ $-msg5
        msg6 db '5. Exit ',10
        len6 equ $-msg6
        msg7 db ' File not Present! ',10
        len7 equ $-msg7


section .text
  global _start
   
 _start:
        print msg1,len1
        print msg2,len2
        read filename,64
        
         dec rax
         mov [filename+rax],0

         print msg4,len4
         read fword,2
        
          FILE_OPEN filename
        cmp rax,-1d;        //-1 is returned to RAX in Case of File Opening Error
        jle error;          // jle is used for Signed Comparison
        mov [filedescriptor],rax;
        
        FILE_READ [filedescriptor],buffer,lenBuffer;
        mov [lenText],rax;      //String Length in RAX on SYS_READ call
        call _Count;
        jmp exit

        error:
        print msg7,len7;

        exit:

        FILE_CLOSE [filedescriptor]
        mov rax,60;
        mov rdi,0;
        syscall;



