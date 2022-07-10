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
;;               Término da interface e do programa
;;
;;
;;********************************************************************
	
finalizar:

call criar_dialogo

mov bx, TITULO_INICIAL
mov cx, RODAPE_INICIAL
mov ah, POS_TITULO_INICIAL
mov al, POS_RODAPE_INICIAL

call adaptar_interface

mov si, SAIR_MSG
mov al, 28
call criar_sim_nao

call esconder_cursor

.fechar:

call identificar_tecla

cmp al, NMin
jz esculpir_dados

cmp al, NMai
jz esculpir_dados

cmp al, SMin
jz fim

cmp al, SMai
jz fim

cmp al, CTRLC
jz fim

cmp al, ESCAPE
jz fim


jmp     .fechar

;;************************************************************

fim:

call matar_interface

mov ah, 02h
mov bx, 01h
mov cx, Prog
int 90h

;;************************************************************

SAIR_MSG db "Deseja realmente sair?",0
Prog db "Painel de Controle do PX-DOS(R)",0