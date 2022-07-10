;;********************************************************************
;;
;;                   Sistema Operacional PX-DOS®
;; 
;;          Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;                   Todos os direitos reservados
;;
;;
;;         Ajuda e introdução para PX-DOS® 0.9.0 e superiores
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
mov al, 22
call adaptar_pagina

print "Seja bem vindo a Ajuda e Introducao!",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Utilize este aplicativo para tirar duvidas e explorar os recursos que o",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "PX-DOS(R) lhe oferece.",0

mov ah, 07
mov al, 02
call adaptar_pagina

print "Para comecar, escolha um dos topicos abaixo:",0

mov ah, 09
mov al, 04
call adaptar_pagina

print "[A] - Aplicativos",0

mov ah, 10
mov al, 04
call adaptar_pagina

print "[B] - Atualizacoes de Software",0

mov ah, 11
mov al, 04
call adaptar_pagina

print "[C] - Servicos do Sistema",0

mov ah, 12
mov al, 04
call adaptar_pagina

print "[D] - Recursos",0

mov ah, 13
mov al, 04
call adaptar_pagina

print "[E] - Informacoes",0

mov ah, 14
mov al, 04
call adaptar_pagina

print "[F] - Sobre este programa",0

mov ah, 16
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar a Ajuda e Introducao",0

call esconder_cursor

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, BMai
jz PovoarInterfaceAtualizar

cmp al, BMin
jz PovoarInterfaceAtualizar

cmp al, FMai
jz PovoarInterfaceSobre

cmp al, FMin
jz PovoarInterfaceSobre

cmp al, CTRLC
jz finalizar

jmp PovoarInterfacePrincipal

;;************************************************************

TITULO_INICIAL db "Ajuda e Introducao",0
RODAPE_INICIAL db "Sistema",0
POS_TITULO_INICIAL equ 31
POS_RODAPE_INICIAL equ 70
