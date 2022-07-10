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

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão de cabeçalho APPX

mov ax, cs
mov bx, ax
mov es, ax

jmp Verificar

%include "C:\Dev\Asm\video.s"
%include "C:\Dev\Asm\teclado.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************

Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

mov si, inicio_msg
call escrever

mov ah, 0x01
mov bx, 01h
int 90h

mov si, espaco_msg
call escrever


mov ah, 0x02
int 90h


inicio_msg db 10,13,10,13,"Sobre o PX-DOS(R):",10,13
      db "Exibe a versao do sistema operacional executado neste momento:",10,13
	  db 10,13,0

	  espaco_msg db 10,13,10,13,0
