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

PovoarInterfacePrincipal:

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
mov al, 24
call adaptar_pagina

print "Sobre o Sistema Operacional",0


mov ah, 04
mov al, 02
call adaptar_pagina

print "Nome do Sistema Operacional: PX-DOS(R)",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "Versao do Sistema Operacional: ",0

call detectar_sistema_atual

mov ah, 06
mov al, 02
call adaptar_pagina

print "Tipo de Sistema Operacional: 16 bits",0

mov ah, 08
mov al, 02
call adaptar_pagina

mov si, COPYRIGHT
call escrever

mov ah, 09
mov al, 02
call adaptar_pagina

mov si, DIREITOS_RESERVADOS
call escrever

mov ah, 11
mov al, 33
call adaptar_pagina

print "**********",0

mov ah, 13
mov al, 29
call adaptar_pagina

print "Sobre o Computador",0

mov ah, 15
mov al, 02
call adaptar_pagina

print "Processador instalado (considerando processador principal):",0

mov ah, 16
mov al, 04
call adaptar_pagina

print "1) ",0

mov si, NomeProcessador
call escrever

mov ah, 17
mov al, 08
call adaptar_pagina

print "Processador em 16 Bits, baseado em 32 Bits",0

mov ah, 18
mov al, 02
call adaptar_pagina

print "Memoria RAM total instalada e reconhecida: ",0

;; Por algum motivo, se não for feito aqui, e for feito em um procedimento,
;; algum erro ocorre de forma inesperada... :-(

cli

    pusha
	mov al,18h
	out 70h,al
	in al,71h
	mov ah,al
	mov al,17h
	out 70h,al
	in al,71h
	
	add ax,1024

sti
	
	call paraString
	
mov si, ax
call escrever

print " kbytes.",0

mov ah, 19
mov al, 02
call adaptar_pagina

print "Suporte a impressoras: ",0

call obterImpressoras

mov ah, 22
mov al, 02
call adaptar_pagina

print "Pressione [ESC] para sair e [I] para informacoes do PC e sistema.",0

call esconder_cursor

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, IMai
jz PovoarInterfaceInfo

cmp al, IMin
jz PovoarInterfaceInfo

cmp al, CTRLC
jz finalizar

jmp PovoarInterfacePrincipal

;;************************************************************

TITULO_INICIAL db "Informacoes do PX-DOS",0
RODAPE_INICIAL db "Sistema",0
POS_TITULO_INICIAL equ 28
POS_RODAPE_INICIAL equ 70
