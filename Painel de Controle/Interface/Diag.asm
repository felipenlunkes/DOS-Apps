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
;;                 Interface da página de diagnóstico
;;
;;
;;********************************************************************

PovoarInterfaceDiag:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_DIAG
mov cx, RODAPE_DIAG
mov ah, POS_TITULO_DIAG
mov al, POS_RODAPE_DIAG

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 24
call adaptar_pagina

print "Carregando opcoes disponiveis...",0

mov ax, 20
call delay

mov ah, 03 ;; Sempre linha + 1
call limpar_linha

.opcoes:

mov ah, 02
mov al, 04
call adaptar_pagina

print "[A] - Verificar o monitor de seu computador",0

mov ah, 03
mov al, 04
call adaptar_pagina

print "[B] - Testar o mouse de seu computador",0

mov ah, 04
mov al, 04
call adaptar_pagina

print "[C] - Testar o audio de seu computador",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "[V] - Voltar ao menu anterior...",0

mov ah, 07
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

.loop:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, AMai
jz near PovoarInterfaceVideo

cmp al, AMin
jz near PovoarInterfaceVideo

cmp al, BMai
jz PovoarInterfaceMouse

cmp al, BMin
jz PovoarInterfaceMouse

cmp al, CMai
jz PovoarInterfaceAudio

cmp al, CMin
jz PovoarInterfaceAudio

cmp al, VMai
jz PovoarInterfaceInfo

cmp al, VMin
jz PovoarInterfaceInfo

cmp al, CTRLC
jz finalizar

jmp .loop

;;************************************************************

TITULO_DIAG db "Centro de Diagnostico de Hardware do PX-DOS PXDIAG(R)",0
RODAPE_DIAG db "Sistema",0
POS_TITULO_DIAG equ 13
POS_RODAPE_DIAG equ 70
