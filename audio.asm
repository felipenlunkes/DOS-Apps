;;***********************************************************************
;;       ______
;;      /  __  \      Sistema Operacional PX-DOS®
;;     /  |__|  \     Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;    /  _____   \    Todos os direitos reservados.  
;;   /   /    \   \     
;;  /___/      \___\  Aplicativos do sistema
;;
;;
;; Compatível com PX-DOS® 0.9.0 ou superior   
;;
;;***********************************************************************

[BITS 16]

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão de cabeçalho APPX

section .text

push ax
mov ax,cs
mov ds,ax
mov es,ax
pop ax

jmp Verificar

%include "C:\Dev\ASM\gui.s"
%include "C:\Dev\ASM\som.s"
%include "C:\Dev\ASM\pxdos.s"
%include "C:\Dev\ASM\teclado.s"
%include "C:\Dev\ASM\tempo.s"

;;************************************************************

Verificar:

call verificar_sistema ;; Caso o sistema não seja suportado, fechar

jmp inicio

;;************************************************************

inicio:
	
call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_INICIAL
mov cx, RODAPE_INICIAL
mov ah, POS_TITULO_INICIAL
mov al, POS_RODAPE_INICIAL

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 02
call adaptar_pagina

print "Aguarde. O servico de audio esta sendo inicializado...",0 

mov ah, 04
mov al, 02
call adaptar_pagina

print "Testando som...",0

jmp emitirsomagr

;;************************************************************

emitirsomagr:

mov ax, 4000
mov bx, 8
call emitirsom

mov ax, 9
call delay

mov ax, 3000
mov bx, 8
call emitirsom

mov ax, 9
call delay

mov ax, 3200
mov bx, 8
call emitirsom

mov ax, 9
call delay

mov ax, 2700
mov bx, 8
call emitirsom

mov ax, 9
call delay

call desligarsom 

jmp final

;;************************************************************

final:

mov ah, 06
mov al, 02
call adaptar_pagina

print "O teste de som foi realizado com sucesso.",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "Pressione <R> para repetir o teste, e <S> para sair...",0

call esconder_cursor

jmp tecla

;;************************************************************

tecla:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, SMai
jz finalizar

cmp al, SMin
jz finalizar

cmp al, RMai
jz inicio

cmp al, RMin
jz inicio

cmp al, CTRLC
jz finalizar

jmp tecla ;; Caso nenhuma tecla válida seja pressionada...

;;*******************************************************************

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
jz final

cmp al, NMai
jz final

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
Prog db "AUDIO PX-DOS(R)",0

TITULO_INICIAL db "Interface de audio do PX-DOS(R)",0
RODAPE_INICIAL db "Sistema",0
POS_TITULO_INICIAL equ 23
POS_RODAPE_INICIAL equ 70

