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

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão do cabeçalho APPX
 
 cli
 clc
 cld
 
 mov ax, cs   ;; Ajusta a área de memória a ser executado o aplicativo  
 mov ds, ax  
 mov es, ax 
 mov fs, ax
 mov gs, ax
 
 clc
 sti
 
 jmp Verificar  
  
 %include "C:\DEV\ASM\gui.s"  
 %include "C:\Dev\ASM\teclado.s"
 %include "C:\Dev\ASM\pxdos.s"
 %include "C:\Dev\ASM\tempo.s"

;;************************************************************



Verificar:

call verificar_sistema ;; Caso o sistema não seja suportado, fechar

jmp inicio

;;************************************************************   
    
inicio:     ;; Processao principal do aplicativo ( Obrigatório )  
    
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

print "Aguarde. O sistema esta preparando as acoes disponiveis...",0 

mov ax, 09
call delay

mov ah, 03
call limpar_linha

mov ah, 02
mov al, 02
call adaptar_pagina

print "Aqui estao as opcoes de desligamento disponiveis:",0

mov ah, 04
mov al, 04
call adaptar_pagina

print "[R] - Reiniciar",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "[D] - Desligar",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "[S] - Sair e retornar ao PX-DOS(R)",0

mov ah, 09
mov al, 02
call adaptar_pagina

print "Selecione a opcao desejada." 

call esconder_cursor

jmp tecla

tecla:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, SMai
jz finalizar

cmp al, SMin
jz finalizar

cmp al, RMai
jz reiniciar

cmp al, RMin
jz reiniciar

cmp al, DMai
jz desligar

cmp al, DMin
jz desligar

cmp al, CTRLC
jz finalizar

jmp tecla ;; Caso nenhuma tecla válida seja pressionada...
   
      
 ;;******************************************************************  
    
desligar:

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

print "Aguarde. O sistema esta sendo finalizado...",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Nao desligue seu computador.",0

mov ax, 30
call delay

mov ah, 03
call limpar_linha

mov ah, 05
call limpar_linha
	
mov ah, 02
mov al, 02
call adaptar_pagina

print "Fazendo logoff e encerrando o PX-DOS(R)...",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "Aguarde, finalizando com seguranca...",0

call esconder_cursor

call parardiscos

mov ax, 50
call delay

mov ah, 017h ;; Chamada de desligamento do PX-DOS®
int 90h
	

;;****************************************************************  
    
reiniciar:

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

print "Aguarde. O sistema esta se preparando para reiniciar...",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Nao desligue seu computador.",0

mov ax, 08
call delay

mov ah, 03
call limpar_linha

mov ah, 05
call limpar_linha

mov ah, 02
mov al, 02
call adaptar_pagina

print "Pronto. O sistema esta pronto para ser reiniciado.",0

mov ah, 04
mov al, 02
call adaptar_pagina 

print "Em breve, ele sera reiniciado...",0

call esconder_cursor

mov ax, 15
call delay
	
jmp reinicio    

;;***************************************************************  


reinicio:

cli 
clc

sti

mov ah, 04h
int 90h

;;****************************************************************  	
   
parardiscos:

;; Obter parâmetros dos discos

mov ah, 08h
mov dl, 80h
mov ax, 0000h
mov di, ax
mov es, ax

int 13h

mov [parametros_disco], dl



    mov ah, 00h
	mov dl, 80h
	
	int 13h
	
	mov ah, 09h ;; Inicia o controlador
	mov dl, 80h
	
	int 13h
	
	
	
	mov ah, 48h ;; Obtêm parâmetros do disco
	mov dl, 80h
	
	int 13h
	
	
	mov ah, 00h
	mov dl, 00h
	
	int 13h
	
	mov ah, 00h
	mov dl, 80h
	
	int 13h
	
	int 13h
	
	mov ah, 10h
	mov dl, 80h
	
	int 13h
	
	mov ah, 11h
	mov dl, 80h
	
	int 13h
	
	mov ah, 01h
	
	int 13h
	

ret	

;;************************************************************

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
jz inicio

cmp al, NMai
jz inicio

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

 ;; Variaveis e constantes deverao ser declaradas abaixo.  
 
SAIR_MSG db "Deseja realmente sair?",0
parametros_disco times 4 db 0    

;;************************************************************

section .data 
    
Prog db "DESLIGAR PX-DOS(R)",0
TITULO_INICIAL db "Opcoes de desligamento do PX-DOS(R)",0
RODAPE_INICIAL db "Sistema",0
POS_TITULO_INICIAL equ 20
POS_RODAPE_INICIAL equ 70

;;************************************************************
;;
;; Nome de dispositivos para o sistema
;;
;;
;;************************************************************

section .text
	
APM: db "APM     ",0
ACPI: db "ACPI    ",0
HAL: db "\DRIVERS\HAL.SIS",0	

section .bss