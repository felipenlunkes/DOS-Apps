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

;;*****************************************************************************
;;
;; Interpretador Assembly para PX-DOS
;;
;; Este interpretador recebe os OPCODES Assembly em Hexadecimal do usuário
;; e os executa diretamente na memória RAM
;;
;;
;; Copyright (C) 2016 Felipe Miguel Nery Lunkes
;;
;;*****************************************************************************

[BITS 16]

%include "C:\Dev\ASM\APPX\appx.s"



jmp Verificar

CODELOC	equ 36864

%include "C:\Dev\ASM\gui.s"
%include "C:\Dev\ASM\pxdos.s"
%include "C:\Dev\ASM\mem.s"
%include "C:\Dev\ASM\versao.s"
	

;;************************************************************


Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

mov ax, 1
call pintartela

mov si, msg_ajuda1		
call escrever

mov si, msg_ajuda2
call escrever

mov si, msg_ajuda3
call escrever

;;************************************************************

loop_prinicipal:

mov si, msg_ajuda4
call escrever

;;************************************************************

.sem_entrada:

call imprimir_linha

mov si, prompt			
call escrever

mov ax, entrada			
call ler

mov ax, entrada
call tamanho_string
cmp ax, 0
je .sem_entrada

mov si, entrada			
mov di, executar

;;************************************************************

.mais:

cmp byte [si], '$'	
je .pronto
	
cmp byte [si], ' '		
je .espaco
	
cmp byte [si], 'r'		
je .executarprograma
	
cmp byte [si], 'v'
je .sobre
	
cmp byte [si], 'a'
je .ajuda
	
cmp byte [si], 'x'		
jne .naosair
	
call imprimir_linha
	
ret

;;************************************************************
	
.naosair:

mov al, [si]
and al, 0F0h

cmp al, 40h
je .H_A_para_F

;;************************************************************
	
.H_1_para_9:

mov al, [si]
sub al, 30h
mov ah, al
sal ah, 4

jmp .H_fim

;;************************************************************
	
.H_A_para_F:

mov al, [si]
sub al, 37h
mov ah, al
sal ah, 4

;;************************************************************
	
.H_fim:

inc si
mov al, [si]
and al, 0F0h

cmp al, 40h
je .L_A_para_F

;;************************************************************
	
.L_1_para_9:

mov al, [si]
sub al, 30h

jmp .L_fim

;;************************************************************
	
.L_A_para_F:

mov al, [si]
sub al, 37h

;;************************************************************
	
.L_fim:

or al, ah
mov [di], al
inc di

;;************************************************************
	
.espaco:

inc si

jmp .mais

;;************************************************************
	
.sobre:

call clrscr

mov si, sobre_msg
call escrever

mov ax, 0
int 16h

call clrscr

jmp inicio

;;************************************************************

.ajuda:

call clrscr

mov si, ajuda_msg
call escrever

mov ax, 0
int 16h
call clrscr

jmp inicio



;;**********************************************************************

.pronto:

	mov byte [di], 0		

	mov si, executar			
	mov di, CODELOC
	mov cx, 255
	cld
	rep movsb

;;************************************************************

.executarprograma:

	call imprimir_linha

	call CODELOC			

	call imprimir_linha

	jmp loop_prinicipal

;;************************************************************

limpartela:

pusha

mov dx, 0			
call movercursor

mov ah, 6			
mov al, 0			
mov bh, 7			
mov cx, 0			
mov dh, 24			
mov dl, 79
int 10h

popa
ret

;;************************************************************
	
imprimir_linha:
	
pusha

mov ah, 0Eh			

mov al, 13
int 10h

mov al, 10
int 10h

popa
ret

;;************************************************************

tamanho_string:

pusha

mov bx, ax			

mov cx, 0			

.mais:

cmp byte [bx], 0		
je .pronto
	
inc bx				
inc cx

jmp .mais

.pronto:

mov word [.contador_temporario], cx	
popa

mov ax, [.contador_temporario]	
	
ret

.contador_temporario	dw 0

;;************************************************************

char_na_string:

pusha

mov cx, 1			
								
.mais:

cmp byte [si], al
je .pronto
	
cmp byte [si], 0
je .naoencontrado
	
inc si
inc cx

jmp .mais

.pronto:

mov [.tmp], cx
popa
mov ax, [.tmp]
ret

.naoencontrado:

popa
mov ax, 0
ret

.tmp	dw 0

;;************************************************************

ler:

pusha

mov di, ax			
mov cx, 0			

.mais:	
				
call lertecla

cmp al, 13			
je .pronto

cmp al, 8			
je .retornar			

cmp al, ' '			
jb .mais			

cmp al, '~'
ja .mais

jmp .semretornar

.retornar:

cmp cx, 0			
je .mais			

call obter_pos_cursor	
	
cmp dl, 0
je .apagar_inicio_da_linha

pusha
mov ah, 0Eh			
mov al, 8
int 10h		
		
mov al, 32
int 10h

mov al, 8
int 10h

popa

dec di							
dec cx				

jmp .mais

.apagar_inicio_da_linha:
	
dec dh				
mov dl, 79
call movercursor

mov al, ' '			
mov ah, 0Eh
int 10h

mov dl, 79			
call movercursor

dec di				
dec cx				

jmp .mais

.semretornar:
	
pusha
	
mov ah, 0Eh			
int 10h
popa

stosb				
inc cx	
			
cmp cx, 254			
jae near .pronto

jmp near .mais			

.pronto:
	
mov ax, 0
stosb

popa
ret

;;************************************************************

movercursor:

pusha

mov bh, 0
mov ah, 2
int 10h				

popa
ret

;;************************************************************

obter_pos_cursor:
	
pusha

mov bh, 0
mov ah, 3
int 10h				

mov [.tmp], dx
popa
mov dx, [.tmp]
ret

.tmp dw 0

;;************************************************************

lertecla:

pusha

mov ax, 0
mov ah, 10h			
int 16h

mov [.tmp_buf], ax		

popa				
mov ax, [.tmp_buf]

ret

.tmp_buf	dw 0

;;************************************************************

;;************************************************************
;;
;;     Mensagens e variáveis utilizadas pelo aplicativo
;;
;;
;;
;;
;;
;;************************************************************


entrada		times 255 db 0	
executar		times 255 db 0	

	msg_ajuda1	db 10,13,"Interpretador de Opcodes Assembly 8086+ do PX-DOS(R)",10,13
	            db       "                                     ",10,13,10,13
				db "Copyright (C) 2016 Felipe Miguel Nery Lunkes. Todos os direitos reservados.",10,13,0
				
	msg_ajuda2	db 'Este programa e compativel com processadores 8086 ou superiores.', 13, 10, 13, 10, 0
	
	msg_ajuda3	db 'Insira as instrucoes (Opcoes) em Hexadecimal, apenas.', 10, 13
	            db "Termine o bloco de instrucoes com '$'.",10,13,0
				
	msg_ajuda4	db 10,13,10,13,'Comandos: r = reexecutar codigo, a = ajuda, v = versao.', 10, 13

	            db 'Use B402 CD90$ para sair.',10,13,0

	prompt		db '- ', 0
	
	sobre_msg db 10,13,10,13,"Montador - Interpretador Assembly para PX-DOS(R)",10,13
	          db   10,13,"Versao 1.6.1 Beta para PX-DOS 0.9.0",10,13,10,13
			  db	  "Pressione ENTER para continuar...",10,13,0

    ajuda_msg db 10,13,10,13,"Use este montador para desenvolver programas",10,13
	          db "diretamente na Memoria RAM. Estes programas devem ser ",10,13
		      db "escritos em Hexadecimal e, apos todas as instrucoes, terminado com $.",10,13
			  db 10,13,"A seguir, o programa deve ser executado ao pressionar ENTER.",10,13,10,13
			  db "Pressione ENTER para continuar...",10,13,10,13,0
			  
;; Cabeçalho de Execução EPX

dw "PXAPP",0
db 0
db -1
db 32 ;; Tamanho da memória a ser alocada	