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

;;**********************************************************************
;;
;; Editor de Textos para PX-DOS® 0.9.0
;;
;; Este aplicativo utiliza o formato APPX, do PX-DOS®.
;;
;; Copyright (C) 2016 Felipe Miguel Nery Lunkes
;; Todos os direitos reservados
;;
;;**********************************************************************

[BITS 16]

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão do cabeçalho APPX

section .text

jmp inicio

%include "C:\Dev\ASM\gui.s"
%include "C:\Dev\ASM\teclado.s"
%include "C:\Dev\ASM\tempo.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************

Verificar:

call verificar_sistema

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

jmp povoar_interface

;;************************************************************

povoar_interface:

mov ah, 02
mov al, 32
call adaptar_pagina

print "Seja bem vindo",0


mov ah, 05
mov al, 02
call adaptar_pagina

print "Insira, por favor, seu texto, logo abaixo.",0

mov ah, 06
mov al, 02
call adaptar_pagina

print "Voce tera um espaco de 64 letras para usar. Ao final,",0

mov ah, 07
mov al, 02
call adaptar_pagina

print "voce podera imprimir seu texto, com a ajuda de uma impressora compativel.",0


mov ah, 09
mov al, 02
call adaptar_pagina

print "Pressione [F8] para continuar, ou [ESC], para mais opcoes.",0


call verificar_tecla

cmp al, 1bh
jz opcoes

cmp al, 4200h
jz digitar

;;************************************************************

opcoes:

mov bx, TITULO_OPCOES
mov cx, RODAPE_OPCOES
mov ah, POS_TITULO_OPCOES
mov al, POS_RODAPE_OPCOES

call atualizar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "Programa de impressao de texto do PX-DOS(R)",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "Versao 0.9.0 - Build 001",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "Copyright (C) 2014-2016 Felipe Miguel Nery Lunkes",0

mov ah, 06
mov al, 02
call adaptar_pagina

print "Todos os direitos reservados.",0

mov ah, 08
mov al, 02
call adaptar_pagina

print "Use este programa para imprimir texto em uma impressora compativel com",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "o sistema e seu computador.",0

call esconder_cursor

call verificar_tecla

cmp al, 4200h
jz inicio

cmp al, 1bh
jz sair

;;************************************************************

sair:

call criar_dialogo

mov bx, TITULO_OPCOES
mov cx, RODAPE_OPCOES
mov ah, POS_TITULO_OPCOES
mov al, POS_RODAPE_OPCOES

call adaptar_interface

mov si, SAIR_MSG
mov al, 28
call criar_sim_nao

call esconder_cursor

call verificar_tecla

cmp al, NMin
jz inicio

cmp al, NMai
jz inicio

cmp al, SMin
jz fim

cmp al, SMai
jz fim

cmp al, 1bh
jz inicio


;;************************************************************

digitar:

mov ah, 11
mov al, 02
call adaptar_pagina

print "Seu texto:",0

mov ah, 13
mov al, 02
call adaptar_pagina

print "> ",0

mov di, texto
call ler

jmp imprimir

imprimir:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_INICIAL
mov cx, RODAPE_INICIAL
mov ah, POS_TITULO_INICIAL
mov al, POS_RODAPE_INICIAL

call adaptar_interface

mov ah, 02
mov al, 02
call adaptar_pagina


print "Aguarde... Estamos enviando seu texto a impressora compativel.",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "Caso uma impressora nao seja localizada, a impressao sera cancelada.",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Caso a impressora fique sem papel, aguardaremos a colocacao de papel na",0

mov ah, 05
mov al, 02
call adaptar_pagina

print "impressora.",0

mov ah, 07
mov al, 15
call adaptar_pagina

print "Obtendo informacoes da impressora...",0

mov ax, 2
call delay

print " [Pronto].",0

mov ah, 09
mov al, 32
call adaptar_pagina

print "Imprimindo...",0

call iniciar_impressora

mov si, texto
call imprimir_carac

mov ah, 11
mov al, 02
call adaptar_pagina

print "Pressione ENTER para retornar e continuar digitando ou",0

mov ah, 12
mov al, 02
call adaptar_pagina

print "pressione F8 para sair...",0

mov ax, 0
int 16h

cmp al, 4200h
jz fim

jmp inicio

;;************************************************************

fim:

call matar_interface

print 10,13,"Finalizando arquivo...",10,13,0

mov ax, 04
call delay

mov si, pxdos
call imprimir_carac


mov si, fimarquivo
call imprimir_carac

mov ah, 02h
int 90h

;;************************************************************

FIM:

mov ah, 02h
mov bx, 01h
int 90h

;;************************************************************

iniciar_impressora:

mov ah, 01h
mov dx, 0h
int 17h

jc near falha_impressora
ret

;; Driver para impressão de relatório do Computador

;;************************************************************

imprimir_carac:  ;; Esse método é usado para transferir dados para a impressora

lodsb         ;; Carrega o próximo caractere à ser enviado

or al, al     ;; Compara o caractere com o fim da mensagem
jz .pronto    ;; Se igual ao fim, pula para .pronto

mov dx, 0x0   ;; Porta Paralela a ser utilizada
mov ah, 0x00
int 0x17      ;; Chama o BIOS e executa a ação 

jc falha_impressora

jmp imprimir_carac ;; Se não tiver acabado, volta à função e carrega o próximo caractere


.pronto: ;; Se tiver acabado...

ret      ;; Retorna a função que o chamou

;;************************************************************

falha_impressora:

call clrscr

call ativar_interface

mov bx, TITULO_FALHA_IMPRESSORA
mov cx, RODAPE_FALHA_IMPRESSORA
mov ah, POS_TITULO_FALHA_IMPRESSORA
mov al, POS_RODAPE_FALHA_IMPRESSORA

call adaptar_interface

mov ah, 02
mov al, 02
call adaptar_pagina

print "Infelizmente, um erro ocorreu quando o arquivo estava sendo impresso.",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Este erro pode ter sido causado por:",0

mov ah, 05
mov al, 07
call adaptar_pagina

print "* - Impressora nao conectada.",0

mov ah, 06
mov al, 07
call adaptar_pagina

print "* - Impressora desconectada durante o processo.",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "Lembrando que a falta de papel nao acarreta em erros de impressao,",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "uma vez que o programa aguarda a recarga.",0

mov ah, 12
mov al, 02
call adaptar_pagina

print "Voce pode tentar de novo, ou sair e verificar o problema.",0

call esconder_cursor

call verificar_tecla

cmp al, 4200h
jz inicio

cmp al, 1bh
jz fim

ret

;;************************************************************

verificar_tecla:


mov     ah, 1
int     16h
jz      verificar_tecla

mov     ah, 0
int     16h

ret

;;************************************************************

section .data


mensagem db "E ai?",0

pxdos db 10,13,10,13,"Impresso via PX-DOS(R)",0

fimarquivo db 10,13,10,13,"Fim deste arquivo de texto.",10,13,10,13,0

ARENA: dw "HAL.SIS",0
POSLOC: dw "\DRIVERS\HAL.SIS",0
DESCLOC: dw "*\????????.???",0

texto times 64 db 0

TITULO_INICIAL db "Programa de impressao do PX-DOS(R)",0
RODAPE_INICIAL db "Pressione [ESC] para opcoes.              Impresoras: [Serial, Paralelo]",0
POS_TITULO_INICIAL equ 23
POS_RODAPE_INICIAL equ 4
TITULO_OPCOES db "Programa de impressao do PX-DOS(R)",0
RODAPE_OPCOES db "Pressione [F8] para voltar ou [ESC] para sair...",0
POS_RODAPE_OPCOES equ 30
POS_TITULO_OPCOES equ 23
TITULO_FALHA_IMPRESSORA db "Falha ao imprimir",0
RODAPE_FALHA_IMPRESSORA db "Pressione [F8] para voltar ou [ESC] para sair...",0
POS_RODAPE_FALHA_IMPRESSORA equ 30
POS_TITULO_FALHA_IMPRESSORA equ 28

SAIR_MSG db "Deseja realmente sair?",0