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

mov ax, cs
mov bx, ax
mov es, ax
mov fs, ax
mov gs, ax


jmp Verificar

;;************************************************************************************


%include "C:\Dev\ASM\teclado.s"
%include "C:\DEV\ASM\guiter.s"
%include "C:\Dev\ASM\pxdos.s"

;;************************************************************************************

Verificar:

call verificar_sistema

jmp inicio

;;************************************************************

inicio:

call clrscr

mov ax, 2
call pintartela

mov si, msg
call escrever

;;************************************************************************************

esperar_tecla:


        mov     ah, 1
        int     16h
        jz      esperar_tecla

mov     ah, 0
int     16h

;; Imprime a tecla

mov     ah, 0eh
int     10h

;; Pressione 'ESC' para sair:
  mov di, .titulo
  mov si, .rodape
  mov dx, .ajudasair
  
cmp al, 23h
jz sobre
  
cmp al, 1bh
jz simnao

cmp al, 4200h
jz serial



jmp     esperar_tecla

 .titulo db "Editor de texto do PX-DOS(R)",0
 .rodape db "Versao 1.5.0",0
 .ajudasair db "Tem certeza que deseja sair?",0

;;************************************************************************************

voltar_pxdos:

call clrscr

mov ah, 02h
int 90h

;;************************************************************************************

serial:

call clrscr

mov ax, 1
call pintartela

call iniciar_serial

print 10,13,10,13,"Enviar dados via Porta Serial COM1",10,13,10,13,0
print "Utilizando o Editor do PX-DOS(R), voce pode enviar dados via",10,13,0
print "Porta Serial para outro computador ou rede, incluindo terminais",10,13,0
print "Linux e Unix.",10,13,10,13,0
print "Mas cuidado!",10,13,10,13,0
print "Se o Driver Arena(R) para PX-DOS nao",10,13,0
print "estiver carregado, este programa e a sessao terminal poderao falhar!",10,13,10,13,0
print "Insira o texto a ser enviado e pressione [ENTER] para enviar...",10,13,10,13,0
print "> ",0

mov di, .EnviarCOM1
call ler

mov si, .EnviarCOM1
call transferir

print 10,13,"Pressione qualquer tecla para continuar...",10,13,0

mov ax, 0
int 16h

;; ESC

jmp inicio



.EnviarCOM1 times 64 db 0

 .titulo db "Editor de texto do PX-DOS(R)",0
 .rodape db "Versao 1.5.0",0
 .ajudasair db "Tem certeza que deseja sair?",0

 
;;************************************************************************************

sobre:

   
 
;;************************************************************************************

msg  db "Editor de texto para PX-DOS(R)...", 10,13
     db "",10,13
     db "|*****************************************************************|", 10,13
	 db "|                                                                 |", 10,13
     db "| [Enter] - Retorna ao inicio da linha.                           |", 10,13
     db "| [Ctrl]+[Enter] - Inicia nova linha em branco.                   |", 10,13
     db "| [#] - Exibe informacoes sobre este programa.                    |", 10,13
	 db "|                                                                 |", 10,13
	 db "| [F8] - Envia dados via Porta Serial (COM1).                     |", 10,13
     db "| Use a opcao de envio por Porta Serial apenas se a mesma estiver |", 10,13
	 db "| ativada e disponivel ( Driver Arena(R) )                        |", 10,13
	 db "|                                                                 |", 10,13
     db "| Pressione [ESC] para finalizar.                                 |", 10,13
	 db "|                                                                 |", 10,13
	 db "|*****************************************************************|",10,13,10,13,0

	 
	 
	  
	 
	 
	 
;;************************************************************************************
;;
;; Usa trechos do Driver de Porta Serial Arena(R) do PX-DOS(R)
;;
;;
;; Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes
;;
;;************************************************************************************
	 
;;************************************************************************************	 

iniciar_serial:  ;; Esse método é usado para inicializar uma Porta Serial


    mov ah, 0               ; Move o valor 0 para o registrador ah 
	                        ; A função 0 é usada para inicializar a Porta Serial COM1
    mov al, 0xe3            ; Parâmetros da porta serial
    mov dx, 0               ; Número da porta (COM 1) - Porta Serial 1
    int 0x14                ; Inicializar porta - Ativa a porta para receber e enviar dados
	
	ret
	
;;************************************************************************
	
transferir:  ;; Esse método é usado para transferir dados pela Porta Serial aberta

lodsb         ;; Carrega o próximo caractere à ser enviado

or al, al     ;; Compara o caractere com o fim da mensagem
jz .pronto    ;; Se igual ao fim, pula para .pronto

mov ah, 0x1   ;; Função de envio de caractere do BIOS por Porta Serial
int 0x14      ;; Chama o BIOS e executa a ação 

jmp transferir ;; Se não tiver acabado, volta à função e carrega o próximo caractere


.pronto: ;; Se tiver acabado...

call Status

ret      ;; Retorna a função que o chamou


;;************************************************************************
;;
;; Método antigo de transferência
;;
;;************************************************************************

;; transferir:  ;; Método usado para transferir os dados pela porta serial

;;   mov ah,0x1
;;   lodsb                   ; Carregar próximo caractere da mensagem
;;   int 0x14                ; Enviar caractere, usando uma função do BIOS
;;   loop transferir         ; Fica em loop enquanto a mensagem não acabar

;;   ret                     ;; Quando ele acaba, retorna ao método a quem ele chamou.
	                          ;; Algo como } em C e Java

;;************************************************************************

receber: ;; Recebe os dados enviados pela Porta Serial, em resposta

	mov ah, 2 ;; Define função 2 - Obter cracteres
	mov dx, 0 ;; Define Porta Serial 0 (COM1)
	
	int 0x14  ;; Chama o BIOS
	
	cmp al, '$' ;; Compara a resposta com '$'
	            ;; Se for igual, significa o fim da mensagem
	je .pronto  ;; Se for igual, vai até .pronto, para terminar
	
	mov [recebido + 1] , al ;; Se não, joga o valor para dentro da variável
	
	jmp receber ;; Volta a executar para receber o próximo caractere


	.pronto:
	
	ret ;; Retorna a função que o chamou
	
;;************************************************************************

Status:


    mov dx, 0			; Define para Porta COM1
	mov ax, 0
	mov ah, 03h			; Checa o Status
	int 14h

	bt ax, 8 ;; Dados enviados?
	jc .enviado
	
	.enviado:
	
	print 10,13,10,13,"Dados enviados com sucesso a Porta Serial (COM1).",10,13,10,13,0
	
	ret

;;************************************************************************
	
recebido times 64 db 0 ;; Variável em memória de tamanho 64

dw "\DRIVERS\ARENA.SIS",0
dw "ESPACO:PXDOS.Arena",0
	 

