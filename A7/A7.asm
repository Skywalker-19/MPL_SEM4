%include"macro.asm"

section .bss
               filename: resb 64
               fword:  resb 2
               fileDescriptor: resq 1
               lenText: resq 1;
               buffer: resb 8192;
               lenBuffer: equ $-buffer;
count: resq 1;

array: resb 20;
inAscii: resb 16;
outAscii: resb 4;
               
section .data

        msg1 db 'SORTING DATA IN FILES : ' ,10          
        len1 equ $-msg1  
        msg2 db ' Enter File Name - ',10
        len2 equ $-msg2 
        msg7 db ' File not Present! ',10
        len7 equ $-msg7

section .text
  global _start
   
 _start:
        print msg1,len1
        print msg2,len2
        read filename,64
         
         dec rax       ;LENGTH OF FILE+1
         mov byte[filename+rax],0   ;TO OPEN THE FILE A ZERO IS REQUIRED AT THE END
 
        FILE_OPEN filename
        cmp rax,-1d;        //-1 is returned to RAX in Case of File Opening Error
        jle error;          // jle is used for Signed Comparison
        mov [fileDescriptor],rax;        

           FILE_READ [fileDescriptor],buffer,lenBuffer
           mov [lenText],rax
           print buffer,[lenText]

                
         call _ProcessBuffer
         call _sort
         call _ProcessArray
         print buffer,[lenText]

         FILE_WRITE [fileDescriptor],buffer,[lenText];


exit:

		FILE_CLOSE [fileDescriptor];
		mov rax,60;
		mov rdi,00;
		syscall;

error:
        print msg7,len7;
        jmp exit



        
      _ProcessBuffer:
        mov rcx,[lenText];
	mov rsi,buffer;
	mov rdi,array;
	
	begin0:
	mov al,[rsi];
	mov [rdi],al;
	
	update0:
	inc rsi;	//Number
	;inc rsi;	//space
	inc rdi;
	inc byte[count];
	dec rcx;
	;dec rcx;
	jnz begin0;

	ret;

	   
       _sort:
        mov rsi,0h;		//i=0
	mov rcx,[count];
	dec rcx;
	outerLoop:
	mov rdi,0h;		//j=0
	
		innerLoop:
		mov rax,rdi;		//j in RDI
		inc rax;		//j+1 in RAX
		
		mov bl,byte[array+rdi];		//array[j]
		mov dl,byte[array+rax];		//array[j+1]
		
		cmp bl,dl;
		jbe updateInnerLoop
		
		swap:
		mov byte[array+rdi],dl;
		mov byte[array+rax],bl;
		
		updateInnerLoop:
		inc rdi;
		cmp rdi,rcx
		jb innerLoop
	
	updateOuterLoop:
	inc rsi;
	cmp rsi,rcx;
	jb outerLoop;
	
	ret;	

_ProcessArray:
	
	mov rsi,array;
	mov rdi,buffer;
	mov rcx,[count];
	
	begin1:
	mov al,[rsi];
	mov [rdi],al;
	
	update1:
	inc rsi;
        ;inc rdi
	inc rdi;
	dec rcx;
	jnz begin1
	
	ret
