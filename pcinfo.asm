;;***********************************************************************
;;       ______
;;      /  __  \      Sistema Operacional PX-DOS®
;;     /  |__|  \     Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;    /  _____   \    Todos os direitos reservados.  
;;   /   /    \   \     
;;  /___/      \___\  Aplicativos do sistema
;;
;;
;; Compatível com PX-DOS® 0.9.0 ou superior   
;;
;;***********************************************************************

[BITS 16]

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão do cabeçalho APPX

push ax
mov ax,cs
mov ds,ax
mov es,ax
pop ax

jmp Verificar

%include "C:\Dev\Asm\teclado.s"
%include "C:\Dev\Asm\video.s"
%include "C:\Dev\Asm\pxdos.s"

;;************************************************************

Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

mov ax, 0
int 12h

mov si, copyright
call escrever

mov eax,80000002h	
	cpuid
	
	mov di,produto		
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000003h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	
	mov eax,80000004h	
	cpuid
	
	stosd
	mov eax,ebx
	stosd
	mov eax,ecx
	stosd
	mov eax,edx
	stosd
	mov si,produto		
	mov cx,48
	
loop_CPU:	

    lodsb
	cmp al,' '
	jae imprimir_CPU
	mov al,'_'
	
imprimir_CPU:	

    mov [si-1],al
	loop loop_CPU


mov ah, 03h
mov dx, prodmsg
int 90h

mov si, tipoproc
call escrever

mov si, tipoproc86
call escrever

mov si, fs_msg
call escrever

mov si, fat12
call escrever

mov si, tpc_msg
call escrever

mov si, tpcat
call escrever

mov si, memoria
call escrever

mov ax, 0
int 12h

call paraString

mov si, ax
call escrever

mov si, kbytes
call escrever

mov si, memoria_total
call escrever

 
    pusha
	mov al,18h
	out 70h,al
	in al,71h
	mov ah,al
	mov al,17h
	out 70h,al
	in al,71h
	
	add ax,1024
	
	call paraString
	
	
	
	mov si,ax
	call escrever
	mov si,kbytes
	call escrever

	mov si, espaco
	call escrever

mov ah, 02h
int 90h


section .data

memoria db "Memoria RAM disponivel para o PX-DOS(R) e aplicativos: ",0

espaco db "",10,13
       db "",10,13,0
	   
copyright db "",10,13
          db "Sistema Operacional PX-DOS(R)",10,13
          db "",10,13
          db "PCINFO - Utilidade de diagnostico de Hardware do PX-DOS(R)",10,13
          db "",10,13
          db "Copyright (C) 2016 Felipe Miguel Nery Lunkes",10,13
          db "",10,13,0   
		  
 processador times 13 db 0
 
fat12 db "FAT12",0

fat16 db "FAT16",0

fat32 db "FAT32",0

processador_msg db 10,13,"Processador instalado: ",0

fsdesconhecido db "Sistema de arquivos desconhecido.",0

fs_msg db 10,13,"Sistema de arquivos encontrado: ",0

tpc_msg db 10,13,"Tipo de computador: ",0

tpcat db "PC AT x86",10,13,0

fsns db "Sistema de arquivos nao suportado ou danificado.",0

fsd db "Sistema de arquivos danificado.",0 

tipoproc db 10,13,"Tipo do processador: ",0

tipoproc86 db "x86 em modo 16 Bits",0

tipoproc64 db "x64 em modo 16 Bits",0

tipoproc286 db "286 ou inferior",0

kbytes db " Kbytes.",0
megabytes db " Megabytes.",0
gigabytes db " Gigabytes.",0

memoria_total db 10,13,"Memoria RAM total reconhecida instalada: ",0

prodmsg	db "# Nome do Processador: ["
produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",13,10,"$"
