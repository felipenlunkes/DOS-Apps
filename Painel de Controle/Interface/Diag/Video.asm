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
;;           Interface da página de diagnóstico de Vídeo
;;
;;
;;********************************************************************

PovoarInterfaceVideo:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_VIDEO
mov cx, RODAPE_VIDEO
mov ah, POS_TITULO_VIDEO
mov al, POS_RODAPE_VIDEO

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 19
call adaptar_pagina

print "Aguarde enquanto o teste e preparado...",0

mov ax, 30
call delay

mov ah, 03 ;; Sempre linha + 1
call limpar_linha

.lista_de_acoes:

call Verificar_Monitor

jc near .erroMonitor

jmp .semErroMonitor

.erroMonitor:

call ativar_interface

call criar_interface

mov bx, TITULO_VIDEO
mov cx, RODAPE_VIDEO
mov ah, POS_TITULO_VIDEO
mov al, POS_RODAPE_VIDEO

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 02
call adaptar_pagina

print "Foi encontrado um erro durante o teste de seu monitor.",0

mov ah, 04
mov al, 04
call adaptar_pagina

print "[V] - Voltar ao menu anterior...",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop

.semErroMonitor:

call ativar_interface

call criar_interface

mov bx, TITULO_VIDEO
mov cx, RODAPE_VIDEO
mov ah, POS_TITULO_VIDEO
mov al, POS_RODAPE_VIDEO

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 02
call adaptar_pagina

print "Nenhum erro encontrado durante o teste.",0

mov ah, 04
mov al, 04
call adaptar_pagina

print "[V] - Voltar ao menu anterior...",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop

.loop:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, VMai
jz PovoarInterfaceDiag

cmp al, VMin
jz PovoarInterfaceDiag

cmp al, CTRLC
jz finalizar

jmp .loop

;;************************************************************

TITULO_VIDEO db "Teste de Video do Painel de Controle",0
RODAPE_VIDEO db "Sistema",0
POS_TITULO_VIDEO equ 22
POS_RODAPE_VIDEO equ 70
