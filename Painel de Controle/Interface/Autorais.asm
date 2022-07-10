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
;;              Interface da página de Direitos Autorais
;;
;;
;;********************************************************************

PovoarInterfaceAutorais:

mov bx, TITULO_AUTORAIS
mov cx, RODAPE_AUTORAIS
mov ah, POS_TITULO_AUTORAIS
mov al, POS_RODAPE_AUTORAIS

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "Painel de Controle do Sistema Operacional PX-DOS(R) versao ",0

mov si, VERSAO_PAINEL
call escrever

mov si, REVISAO_PAINEL
call escrever

mov ah, 04
mov al, 02
call adaptar_pagina

print "Copyright (C) 2012-2016 Felipe Miguel Nery Lunkes",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "Todos os direitos reservados.",0

mov ah, 07
mov al, 02
call adaptar_pagina

print "Sistema Operacional PX-DOS(R) e PX-DOS(R), assim como sua interface de",0

mov ah, 08
mov al, 02
call adaptar_pagina

print "usuario, funcoes e demais caracteristicas sao de propriedade de ",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "Felipe Miguel Nery Lunkes. E proibido qualquer processo de engenharia",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "reversa ou distribuicao, recaindo sobre estas situacoes as devidas punicoes",0

mov ah, 11
mov al, 02
call adaptar_pagina

print "legais.",0

mov ah, 14
mov al, 02
call adaptar_pagina

print "Pressione [V] para voltar ou [ESC] para sair...",0

call esconder_cursor

;; À seguir, o teclado será questionado sobre o pressionamento de alguma tecla

.opcoes:

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

jmp .opcoes


;;************************************************************

TITULO_AUTORAIS db "Painel de Controle do PX-DOS(R): Direitos Autorais",0
RODAPE_AUTORAIS db "Painel de Controle e Sistema Operacional PX-DOS(R)",0
POS_TITULO_AUTORAIS equ 15
POS_RODAPE_AUTORAIS equ 28