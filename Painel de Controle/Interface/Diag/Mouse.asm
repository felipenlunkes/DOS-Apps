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
;;           Interface da página de diagnóstico de Mouse
;;
;;
;;********************************************************************

PovoarInterfaceMouse:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_MOUSE
mov cx, RODAPE_MOUSE
mov ah, POS_TITULO_MOUSE
mov al, POS_RODAPE_MOUSE

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 12
call adaptar_pagina

print "Aguarde enquanto o sistema procura um Mouse instalado...",0

call Verificar_Mouse ;; Função que retornará a função de Mouse

mov ax, 30
call delay

mov ah, 03 ;; Sempre linha + 1
call limpar_linha

.lista_de_acoes:

jc near .semMouse

jmp .comMouse

.semMouse:

mov ah, 02
mov al, 02
call adaptar_pagina

print "O sistema nao conseguiu verificar a presenca de um Mouse",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "instalado em seu computador. Este erro pode ser causado",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "por diversos fatores, como a falta de um Driver PX-DOS(R)",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "carregado, Mouse nao conectado corretamente, BIOS desatualizada",0

mov ah, 06
mov al, 02
call adaptar_pagina

print "ou ainda que seu sistema PX-DOS(R) esteja desatualizado.",0

mov ah, 08
mov al, 04
call adaptar_pagina 

print "[V] - Voltar ao menu anterior...",0

mov ah, 10
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop


.comMouse:

mov ah, 02
mov al, 02
call adaptar_pagina

print "O sistema conseguiu verificar a presenca de um Mouse",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "instalado em seu computador.",0

mov ah, 05
mov al, 04
call adaptar_pagina 

print "[V] - Voltar ao menu anterior...",0

mov ah, 07
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop


call esconder_cursor

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

TITULO_MOUSE db "Teste de Mouse do Painel de Controle",0
RODAPE_MOUSE db "Sistema",0
POS_TITULO_MOUSE equ 22
POS_RODAPE_MOUSE equ 70
