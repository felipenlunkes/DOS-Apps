;;********************************************************************
;;
;;                   Sistema Operacional PX-DOS®
;; 
;;          Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;                   Todos os direitos reservados
;;
;;
;;         Painel de controle para o PX-DOS® 0.9.0 e superiores
;;
;;
;;
;;********************************************************************
;;
;;                 Interface da página principal
;;
;;
;;********************************************************************

PovoarInterfaceMemoria:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_MEMORIA
mov cx, RODAPE_MEMORIA
mov ah, POS_TITULO_MEMORIA
mov al, POS_RODAPE_MEMORIA

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 22
call adaptar_pagina

print "Detalhamento da memoria disponivel",0

mov ah, 04
mov al, 20
call adaptar_pagina

print "Tipo de memoria             Tamanho",0

mov ah, 05
mov al, 20
call adaptar_pagina

print "-----------------       ---------------",0 

mov ah, 06
mov al, 20
call adaptar_pagina

print "  Convencional            ",0

mov ax, 0
int 12h

call paraString

mov si, ax
call escrever

print " kbytes",0

mov ah, 07
mov al, 20
call adaptar_pagina

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

print " kbytes",0	

mov ah, 08
mov al, 20
call adaptar_pagina

print "    Utilizada             ",0

mov ah, 18h
mov bx, 02h
int 90h

call paraString

mov si, ax
call escrever

print " kbytes",0	


mov ah, 10
mov al, 25
call adaptar_pagina

print "Detalhamento de uso da memoria",0

print 10,13,10,13,0

mov ah, 18h
mov bx, 01h
int 90h

call esconder_cursor

.loop:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, VMai
jz PovoarInterfaceInfo

cmp al, VMin
jz PovoarInterfaceInfo

cmp al, CTRLC
jz finalizar

jmp .loop

;;************************************************************

TITULO_MEMORIA db "Uso da memoria pelo PX-DOS(R)",0
RODAPE_MEMORIA db "[V] - Voltar ao menu anterior | [ESC] - Encerrar o Painel de Controle ",0
POS_TITULO_MEMORIA equ 25
POS_RODAPE_MEMORIA equ 05
