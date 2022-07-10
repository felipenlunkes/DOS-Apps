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

PovoarInterfaceHardware:

mov bx, TITULO_HARDWARE
mov cx, RODAPE_HARDWARE
mov ah, POS_TITULO_HARDWARE
mov al, POS_RODAPE_HARDWARE

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "A seguir, voce tera informacoes relevantes sobre o Hardware suportado e",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "reconhecido pelo PX-DOS(R). A anatomia de seu PC.",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "Analisando discos atualmente conectados ao computador...",0

mov ax, 20
call delay

mov ah, 06
call limpar_linha

mov ah, 05
mov al, 04
call adaptar_pagina

print "Discos disponiveis: ",0

call verificar_discos

mov ah, 06
mov al, 04
call adaptar_pagina

mov si, NomeProcessador
call escrever

mov ah, 07
mov al, 04
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

mov ah, 08
mov al, 04
call adaptar_pagina

print "Suporte a impressoras: ",0

call obterImpressoras

mov ah, 10
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

TITULO_HARDWARE db "Painel de Controle do PX-DOS(R): Informacoes de Hardware",0
RODAPE_HARDWARE db "Sistema",0
POS_TITULO_HARDWARE equ 10
POS_RODAPE_HARDWARE equ 70