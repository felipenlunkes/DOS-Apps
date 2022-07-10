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

;;**************************************************************
;;
;;
;; Sistema de Gerenciamento de Hardware do PX-DOS®
;;
;; Sistema Operacional PX-DOS®
;; Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados.
;;
;; Compatível com PX-DOS® 0.9.0 ou superior, apenas.
;; Não compatível com versões anteriores.
;;
;; Sistema de Detecção de Memória RAM para PX-DOS®
;;
;;**************************************************************

%define .texto [SECTION .TEXT]
%define .dados [SECTION .DATA ALIGN=8]
%define .info [SECTION .INFO]
%define .comm [SECTION .COMMENT]
%define .bss [SECTION .BSS]

[BITS 16]

%include "C:\Dev\ASM\APPX\APPX.s" ;; Inclusão do cabeçalho APPX


xor ax, ax
xor bx, bx
xor cx, cx

jmp Verificar

%include "C:\Dev\ASM\video.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************

Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

print 10,13,"Tipo de memoria             Tamanho",10,13,0
print       "-----------------       ---------------",10,13,0 

print "  Convencional            ",0

mov ax, 0
int 12h

call paraString

mov si, ax
call escrever

print " kbytes",10,13,0

print "    Extendida             ",0

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

mov si, ax
call escrever

print " kbytes",10,13,0	

print "    Utilizada             ",0

mov ah, 18h
mov bx, 2h
int 90h

call paraString

mov si, ax
call escrever

print " kbytes",10,13,10,13,0	

mov ah, 18h
mov bx, 1h
int 90h

mov ah, 02h
mov bx, 1
int 90h

.dados

.info

nomeoriginal: db "MEM.EPX",0
nomeapp: db "Gerencimento de Memoria do PX-DOS(R)",0
autor: db "Felipe Miguel Nery Lunkes",0
copyright: db "Copyright 2013-2016 Felipe Miguel Nery Lunkes. Todos os direitos reservados.",0
