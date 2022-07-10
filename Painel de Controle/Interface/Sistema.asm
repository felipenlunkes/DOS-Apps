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
;;           Interface da página de informações do PX-DOS®
;;
;;
;;********************************************************************

PovoarInterfaceSistema:

mov bx, TITULO_SISTEMA
mov cx, RODAPE_SISTEMA
mov ah, POS_TITULO_SISTEMA
mov al, POS_RODAPE_SISTEMA

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "A seguir, algumas informacoes importantes sobre o sistema que faz seu PC",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "funcionar da melhor maneira possivel: Sistema Operacional PX-DOS(R)",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "Nome do Sistema Operacional: PX-DOS(R)",0

mov ah, 07
mov al, 04
call adaptar_pagina

print "Versao do Sistema Operacional: ",0

call detectar_sistema_atual

mov ah, 08
mov al, 04
call adaptar_pagina

print "Tipo de Sistema: Sistema Operacional de 16 Bits",0

mov ah, 09
mov al, 04
call adaptar_pagina

print "Processo de ativacao: Ativado",0

mov ah, 11
mov al, 04
call adaptar_pagina

mov si, COPYRIGHT
call escrever

mov ah, 12
mov al, 04
call adaptar_pagina

mov si, DIREITOS_RESERVADOS
call escrever

mov ah, 15
mov al, 02
call adaptar_pagina

print "RC1*= Software em fase de testes",0

mov ah, 18
mov al, 02
call adaptar_pagina

print "PX-DOS(R) ",0

call detectar_sistema_atual

print ", PX-DOS(R) e sua interface de usuario sao protegidos",0

mov ah, 19
mov al, 02
call adaptar_pagina

print "por direitos de propriedade intelectual.",0

mov ah, 22
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

TITULO_SISTEMA db "Painel de Controle do PX-DOS(R): Sobre o PX-DOS(R)",0
RODAPE_SISTEMA db "Sistema",0
POS_TITULO_SISTEMA equ 12
POS_RODAPE_SISTEMA equ 70