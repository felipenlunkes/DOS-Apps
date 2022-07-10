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
;;     Interface da página de informações do Painel de Controle
;;
;;
;;********************************************************************

PovoarInterfaceSobre:

mov bx, TITULO_SOBRE
mov cx, RODAPE_SOBRE
mov ah, POS_TITULO_SOBRE
mov al, POS_RODAPE_SOBRE

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "Informacoes sobre o Painel de Controle do PX-DOS(R)",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "Nome do Programa: Painel de Controle do PX-DOS(R)",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "Versao deste programa: ",0

mov si, VERSAO_PAINEL
call escrever

mov si, REVISAO_PAINEL
call escrever

mov ah, 07
mov al, 04
call adaptar_pagina

print "Build: ",0

mov si, BUILD
call escrever

mov ah, 08
mov al, 04
call adaptar_pagina

print "Compatibilidade: ",0

mov si, COMPATIBILIDADE_PAINEL
call escrever

mov ah, 10
mov al, 04
call adaptar_pagina

mov si, COPYRIGHT
call escrever

mov ah, 11
mov al, 04
call adaptar_pagina

mov si, DIREITOS_RESERVADOS
call escrever

mov ah, 14
mov al, 02
call adaptar_pagina

print "Pressione [V] para voltar, [A] para direitos autorais ou [ESC] para sair...",0

call esconder_cursor

;; À seguir, o teclado será questionado sobre o pressionamento de alguma tecla

.loop:

call identificar_tecla

;; Agora, o resultado reportado deve ser comparado com o banco de dados de teclas

cmp al, VMai
jz PovoarInterfaceInfo

cmp al, VMin
jz PovoarInterfaceInfo

cmp al, AMai
jz PovoarInterfaceAutorais

cmp al, AMin
jz PovoarInterfaceAutorais

cmp al, CTRLC
jz finalizar

cmp al, ESCAPE
jz finalizar

;; Caso nenhuma tecla válida para a operação tenha sido pressionada, volte ao início

jmp .loop


;;************************************************************

TITULO_SOBRE db "Painel de Controle do PX-DOS(R): Sobre este programa",0
RODAPE_SOBRE db "Sistema",0
POS_TITULO_SOBRE equ 10
POS_RODAPE_SOBRE equ 70