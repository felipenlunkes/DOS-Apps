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

mov ax, cs
mov bx, ax
mov es, ax

inicio:

jmp Verificar

%include "C:\Dev\ASM\gui.s"
%include "C:\Dev\ASM\pxdos.s"
%include "C:\Dev\ASM\teclado.s"
%include "C:\Dev\ASM\tempo.s"

;;************************************************************

Verificar:

call verificar_sistema

jmp montar_interface

;;************************************************************

montar_interface:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_INICIAL
mov cx, RODAPE_INICIAL
mov ah, POS_TITULO_INICIAL
mov al, POS_RODAPE_INICIAL

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 02
call adaptar_pagina

print "Seja bem vindo. A seguir, iremos verificar seu PC em busca de dispositivos",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "de entrada compativeis com o PX-DOS(R).",0

mov ah, 06
mov al, 34
call adaptar_pagina

print "Aguarde...",0

mov ax, 10
call delay

jmp verificar_mouse

;;************************************************************

verificar_mouse:

push ax
push bx
push cx
push dx
push es
	
mov ax, 0
int 33h

cmp ax, 0

jne mousefunciona

jmp semmouse

;;************************************************************

mousefunciona:

mov ah, 08
mov al, 02
call adaptar_pagina

print "Um mouse foi localizado conectado a este computador.",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "Isso quer dizer que ele ja pode ser utilizado, em apps compativeis.",0

mov ah, 15
mov al, 02
call adaptar_pagina

print "Pressione ESC para sair.",0

call identificar_tecla

cmp al, 1bh
je near parar

mov ax, 1
int 33h

jmp parar

;;************************************************************

semmouse:

mov ah, 08
mov al, 02
call adaptar_pagina

print "Infelizmente, nenhum mouse foi encontrado.",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "Procure utilizar um mouse e um driver compativeis.",0

mov ah, 15
mov al, 02
call adaptar_pagina

print "Pressione ESC para sair.",0

call identificar_tecla

cmp al, 1bh
je near parar

mov ax, 1
int 33h

jmp parar

;;************************************************************

parar:

call criar_dialogo

mov bx, TITULO_INICIAL
mov cx, RODAPE_INICIAL
mov ah, POS_TITULO_INICIAL
mov al, POS_RODAPE_INICIAL

call adaptar_interface

mov si, SAIR_MSG
mov al, 28
call criar_sim_nao

call esconder_cursor

call identificar_tecla


cmp al, NMin
jz montar_interface

cmp al, NMai
jz montar_interface

cmp al, SMin
jz fim

cmp al, SMai
jz fim

cmp al, 1bh
jz fim


jmp  parar

;;************************************************************

fim:

call matar_interface

mov ah, 02h
int 90h

TITULO_INICIAL db "Painel de Controle de Dispositivos de Entrada",0
SAIR_MSG db "Deseja realmente sair?",0
RODAPE_INICIAL db "Sistema",0
POS_TITULO_INICIAL equ 15
POS_RODAPE_INICIAL equ 70   
  
sim times 64 db 0	
bannerDOS db "Copyright (C) 2015-2016 Felipe Miguel Nery Lunkes",0
bannerNT db "Copyright © 2015-2016 Felipe Miguel Nery Lunkes",0	  

mensagem_erro db 10,13,"Versao incorreta do PX-DOS ou DOS",10,13,0