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

%include "C:\Dev\ASM\APPX\appx.s" ;; Inclusão do cabeçalho APPX

section .text
	
	mov ax, cs
	mov bx, ax
	mov es, ax
		
	jmp Verificar

;;************************************************************
	
	%include "C:\Dev\Asm\som.s"
	%include "C:\Dev\Asm\teclado.s"
	%include "C:\DEV\ASM\gui.s"
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


	mov bl, preto_branco			; Desenha a tela para o teclado virtual
	mov dh, 04 ;; Linha de início
	mov dl, 20 ;; Coluna de início
	mov si, 39 ;; Coluna de término
	mov di, 21 ;; Linha de término
	
	call desenharbloco

	; Loops para criar o teclado

	mov dl, 24		
	
	mov dh, 6
	call movercursor

	mov ah, 0Eh
	mov al, 196

	mov cx, 31
	
.loop1:

	int 10h
	
	loop .loop1


	mov dl, 24		
	mov dh, 18
	
	call movercursor

	mov ah, 0Eh
	mov al, 196

	mov cx, 31
	
.loop2:

	int 10h
	
	loop .loop2



	mov dl, 23		; Esquina superior esquerda
	mov dh, 6
	
	call movercursor

	mov al, 218
	int 10h


	mov dl, 55		; Esquina superior direita
	mov dh, 6
	
	call movercursor

	mov al, 191
	int 10h


	mov dl, 23		
	mov dh, 18
	
	call movercursor

	mov al, 192
	int 10h


	mov dl, 55		
	mov dh, 18
	
	call movercursor

	mov al, 217
	int 10h


	mov dl, 23		
	mov dh, 7
	mov al, 179
	
.loop3:

	call movercursor
	
	int 10h
	inc dh
	
	cmp dh, 18
	jne .loop3


	mov dl, 55		
	mov dh, 7
	mov al, 179
	
.loop4:

	call movercursor
	
	int 10h
	
	inc dh
	
	cmp dh, 18
	jne .loop4


	mov dl, 23		; Separador das teclas
	
.grandeloop:

	add dl, 4
	mov dh, 7
	mov al, 179
	
.loop5:

	call movercursor
	int 10h
	inc dh
	
	cmp dh, 18
	jne .loop5
	
	cmp dl, 51
	jne .grandeloop


	mov al, 194		
	mov dh, 6
	mov dl, 27
	
.loop6:

	call movercursor
	int 10h
	
	add dl, 4
	
	cmp dl, 55
	jne .loop6


	mov al, 193		
	mov dh, 18
	mov dl, 27
	
.loop7:

	call movercursor
	int 10h
	
	add dl, 4
	
	cmp dl, 55
	jne .loop7


	; Agora, as teclas pretas

	mov bl, branco_preto

	mov dh, 6
	mov dl, 26
	mov si, 3
	mov di, 13
	call desenharbloco
	
	mov dh, 6
	mov dl, 30
	mov si, 3
	mov di, 13
	call desenharbloco
	
	mov dh, 6
	mov dl, 34
	mov si, 3
	mov di, 13
	call desenharbloco
	
	mov dh, 6
	mov dl, 38
	mov si, 3
	mov di, 13
	call desenharbloco
	
	mov dh, 6
	mov dl, 42
	mov si, 3
	mov di, 13
	call desenharbloco
	
	mov dh, 6
	mov dl, 46
	mov si, 3
	mov di, 13
	call desenharbloco

    mov dh, 6
	mov dl, 50
	mov si, 3
	mov di, 13
	call desenharbloco
	

	; Agora imprime as letras nas teclas
	
	mov ah, 0Eh

	mov dh, 17
	mov dl, 25
	call movercursor

	mov al, 'Q'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'W'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'E'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'R'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'T'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'Y'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'U'
	int 10h

	add dl, 4
	call movercursor
	
	mov al, 'I'
	int 10h

	
.novamente:

	call identificar_tecla

.semtecla:				; Procura as teclas e emite os sons

	cmp al, QMin
	jne .w
	
	mov ax, 4000
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.w:

	cmp al, WMin
	jne .e
	
	mov ax, 3600
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.e:

	cmp al, EMin
	jne .r
	
	mov ax, 3200
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente


.r:

	cmp al, RMin
	jne .t
	
	mov ax, 3000
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.t:

	cmp al, TMin
	jne .y
	
	mov ax, 2700
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.y:

	cmp al, YMin
	jne .u
	
	mov ax, 2400
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.u:

	cmp al, UMin
	jne .i
	
	mov ax, 2100
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.i:

	cmp al, IMin
	jne .espaco
	
	mov ax, 2000
	mov bx, 0
	
	call emitirsom
	
	jmp .novamente

.espaco:

	cmp al, ' '
	jne .sair
	
	call desligarsom
	
	jmp .novamente

.sair:

	cmp al, ZMin
	je .fim
	
	cmp al, ZMai
	je .fim
	
	jmp .agora

.agora:

	jmp .novamente

.fim:

	call desligarsom

	call matar_interface

	mov ah, 02h  ;; Função 02h - Função de finalizar o programa
	int 90h      ;; Chamada ao PX-DOS

;;************************************************************
	
movercursor:
 
	pusha

	mov bh, 0
	mov ah, 2
	int 10h				

	popa
	ret

;;************************************************************

desenharbloco:

	pusha

.mais:

	call movercursor		;; Mover para primeira posição

	mov ah, 09h			;; Cor selecionada
	mov bh, 0
	mov cx, si
	mov al, ' '
	int 10h

	inc dh				;; Passa a próxima linha

	mov ax, 0
	mov al, dh			;; Obtêm posição Y
	cmp ax, di			
	jne .mais			

	popa
	ret

;;************************************************************
	
section .data

TITULO_INICIAL db "Piano Virtual 'return PIANO;' para PX-DOS(R) versao 1.6.5 ",0
RODAPE_INICIAL db "Pressione [z] para sair e [espaco] para silenciar.",0
POS_TITULO_INICIAL equ 11
POS_RODAPE_INICIAL equ 28



