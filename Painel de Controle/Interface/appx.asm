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
;;            Interface da informações sobre o formato APPX
;;
;;
;;********************************************************************

PovoarInterfaceAPPX:

mov bx, TITULO_APPX
mov cx, RODAPE_APPX
mov ah, POS_TITULO_APPX
mov al, POS_RODAPE_APPX

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "A seguir, voce tera informacoes tecnicas sobre o sistema, formatos de",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "arquivo executaveis e APIs para desenvolvimento.",0

mov ah, 05
mov al, 33
call adaptar_pagina

print "**********",0

mov ah, 07
mov al, 02
call adaptar_pagina

print "Sistema Operacional: Sistema Operacional PX-DOS(R)"

mov ah, 08
mov al, 02
call adaptar_pagina

print "Versao do Sistema Operacional: "

call detectar_sistema_atual

mov ah, 09
mov al, 02
call adaptar_pagina

print "API de programacao suportada: APPX(R) 2.0",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "Formato executavel: APPX(R) 2.0",0

mov ah, 15
mov al, 02
call adaptar_pagina

print "Pressione [V] para voltar ou [ESC] para sair...",0

call esconder_cursor

;; À seguir, o teclado será questionado sobre o pressionamento de alguma tecla

.loop:

call identificar_tecla

;; Agora, o resultado reportado deve ser comparado com o banco de dados de teclas


cmp al, VMai
jz PovoarInterfaceInfo

cmp al, VMin
jz PovoarInterfaceInfo

cmp al, CTRLC
jz finalizar

cmp al, ESCAPE
jz finalizar

;; Caso nenhuma tecla válida para a operação tenha sido pressionada, volte ao início

jmp .loop


;;************************************************************

TITULO_APPX db "Painel de Controle do PX-DOS(R): Informacoes Tecnicas",0
RODAPE_APPX db "Sistema",0
POS_TITULO_APPX equ 12
POS_RODAPE_APPX equ 70