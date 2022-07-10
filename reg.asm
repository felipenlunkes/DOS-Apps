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

%include "C:\Dev\Asm\APPX\appx.s" ;; Inclusão do cabeçalho APPX

section .text

push ax
push bx
push cx
push dx
push di
push si
push ss
push sp

mov ax, cs
mov es, ax
mov fs, ax

pop sp
pop ss
pop si
pop di
pop dx
pop cx
pop bx 
pop ax

jmp Verificar

%include "C:\Dev\ASM\video.s"
%include "C:\Dev\ASM\pxdos.s"
%include "C:\Dev\ASM\versao.s"

;;************************************************************

Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

push si

call obterProcessador

print 10,13,"Exibindo registradores 16 bits do processador:",10,13,0

mov si, NomeProcessador
call escrever

print 10,13,10,13,0


pop si

push ax
mov ax,cs
mov ds,ax
mov es,ax
pop ax


push axx
push ax
call parahexa

push bxx
push bx
call parahexa

push cxx
push cx
call parahexa

push dxx
push dx
call parahexa

push css
push cs
call parahexa

push dss
push ds
call parahexa

push sss
push ss
call parahexa

push ess
push es
call parahexa

push spp
push sp
call parahexa

push sii
push si
call parahexa

push dii
push di
call parahexa

push gss
push gs
call parahexa


push fss
push fs
call parahexa

mov ax, 0
int 12h

mov ah, 02h
int 90h

;;************************************************************

imprimir:	
	pusha
	mov bp,sp
	mov si,[bp+18] 
	
	cont:
	
		lodsb
		
		or al,al
		jz .pronto
		
		mov ah,0x0e
		mov bx,0
		mov bl,7
		int 10h
		
		jmp cont
		
	.pronto:
	
		mov sp,bp
		popa
		ret



;;************************************************************

parahexa:
	pusha
	mov bp,sp
	mov dx, [bp+20]
	push dx	
	call imprimir
	mov dx,[bp+18]

	mov cx,4
	mov si,hexc
	mov di,hex+2
	
	guardar:
	
	rol dx,4
	mov bx,15
	and bx,dx
	mov al, [si+bx]
	stosb
	loop guardar
	push hex
	call imprimir
	mov sp,bp
	popa
	ret

;;************************************************************
	
obterProcessador:

    mov eax, 80000002h	
	cpuid
	
	mov di, produto		
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd
	mov eax, edx
	stosd
	
	mov eax, 80000003h	
	cpuid
	
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd
	mov eax, edx
	stosd
	
	mov eax, 80000004h	
	cpuid
	
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd 
	mov eax, edx
	stosd
	mov si, produto		
	mov cx, 48
	
loop_CPU:	

    lodsb
	cmp al, ' '
	jae formatarNomeCPU
	mov al, '_'
	
formatarNomeCPU:	

    mov [si-1], al
	loop loop_CPU

	ret
	
;;************************************************************

	

section .data	
	
hex db "0x0000",10,13,0
hexc db "0123456789ABCDEF"
testt db "Ola!",10,13,0
css db "Registrador 8086 CS: ",0
dss db "Registrador 8086 DS: ",0
sss db "Registrador 8086 SS: ",0
ess db "Registrador 8086 ES: ",0
gss db "Registrador 8086 GS: ",0
fss db "Registrador 8086 FS: ",0
axx db 10,13,"Registrador 8086 AX: ",0
bxx db "Registrador 8086 BX: ",0
cxx db "Registrador 8086 CX: ",0
dxx db "Registrador 8086 DX: ",0
spp db "Registrador 8086 SP: ",0
bpp db "Registrador 8086 BP: ",0
sii db "Registrador 8086 SI: ",0
dii db "Registrador 8086 DI: ",0

NomeProcessador	db "Processador Principal [1]: ["

produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",0	