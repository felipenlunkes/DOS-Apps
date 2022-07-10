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
;;               Interface da página de informações
;;
;;
;;********************************************************************

PovoarInterfaceInfo:

mov bx, TITULO_INFO
mov cx, RODAPE_INFO
mov ah, POS_TITULO_INFO
mov al, POS_RODAPE_INFO

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "Use uma das opcoes abaixo para obter mais informacoes sobre seu",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "computador e acessar configuracoes importantes.",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "[A] - Informacoes completas do sistema operacional PX-DOS(R)",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "[B] - Informacoes detalhadas do Hardware de seu PC",0

mov ah, 07
mov al, 04
call adaptar_pagina

print "[C] - Sobre o Painel de Controle do PX-DOS(R)",0

mov ah, 08
mov al, 04
call adaptar_pagina

print "[D] - Informacoes tecnicas do sistema",0

mov ah, 09
mov al, 04
call adaptar_pagina

print "[E] - Central de diagnostico e Hardware (PXDiag)",0

mov ah, 10
mov al, 04
call adaptar_pagina

print "[F] - Uso de memoria",0

mov ah, 11
mov al, 04
call adaptar_pagina

print "[G] - Voltar ao menu anterior",0

mov ah, 13
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

;; À seguir, o teclado será questionado sobre o pressionamento de alguma tecla
.loop:

call identificar_tecla

;; Agora, o resultado reportado deve ser comparado com o banco de dados de teclas

cmp al, AMai
jz PovoarInterfaceSistema

cmp al, AMin
jz PovoarInterfaceSistema

cmp al, BMai
jz PovoarInterfaceHardware

cmp al, BMin
jz PovoarInterfaceHardware

cmp al, CMai
jz PovoarInterfaceSobre

cmp al, CMin
jz PovoarInterfaceSobre

cmp al, DMai
jz PovoarInterfaceAPPX

cmp al, DMin
jz PovoarInterfaceAPPX

cmp al, EMai
jz PovoarInterfaceDiag

cmp al, EMin
jz PovoarInterfaceDiag

cmp al, FMai
jz PovoarInterfaceMemoria

cmp al, FMin
jz PovoarInterfaceMemoria

cmp al, GMai
jz PovoarInterfacePrincipal

cmp al, GMin
jz PovoarInterfacePrincipal

cmp al, CTRLC
jz finalizar

cmp al, 1bh
jz finalizar

;; Caso nenhuma tecla válida para a operação tenha sido pressionada, volte ao início

jmp .loop


;;************************************************************

TITULO_INFO db "Painel de Controle do PX-DOS(R)",0
RODAPE_INFO db "Sistema",0
POS_TITULO_INFO equ 22
POS_RODAPE_INFO equ 70