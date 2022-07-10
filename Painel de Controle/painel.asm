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

[BITS 16]

org 100h

%include "C:\Dev\ASM\APPX\APPX.s" ;; Inclui o cabeçalho necessário para o formato

[map symbols sections brief segments mapa.txt]

mov ax, cs ;; Copia para ax o endereço do segmento de código
mov bx, ax ;; Copia para bx
mov ds, ax ;; Transfere para ds (formato: um segmento único de dados/código, mistos)
mov es, ax ;; Transfere para es
mov gs, ax ;; Transfere para gs

jmp configurar

;;************************************************************

;; Bibliotecas de Desenvolvimento PX-DOS em Assembly (PXASM®)

%include "C:\Dev\ASM\gui.s"
%include "C:\Dev\ASM\teclado.s"
%include "C:\Dev\ASM\som.s"
%include "C:\Dev\ASM\tempo.s"
%include "C:\Dev\ASM\mem.s"
%include "C:\Dev\ASM\pxdos.s"

;; Arquivos com funções de diagnóstico de Software

%include "kernel\fechar.asm"
%include "kernel\versao.asm"

;; Arquivos com funções de diagnóstico de Hardware

%include "Procx86\Procx86.asm"
%include "Impressora\impressora.asm"

;; Arquivo com funções de leitura de disco (FAT 12/FAT 16 e RAW)

%include "Discos\discos.asm"

;; Funções e procedimento de diagnóstico e verificação de Hardware

%include "Diag\tela.asm"
%include "Diag\mouse.asm"
%include "Diag\teclado.asm"
%include "Diag\som.asm"
%include "Diag\Procx86.asm"

;; Interfaces do Aplicativo PX-DOS® (10 interfaces - 20/01/2016)

%include "interface\inicial.asm"
%include "interface\principal.asm"
%include "interface\info.asm"
%include "interface\detalhes.asm"
%include "interface\autorais.asm"
%include "interface\sistema.asm"
%include "interface\hardware.asm"
%include "interface\sobre.asm"
%include "interface\Memoria.asm"
%include "interface\appx.asm"
%include "interface\diag.asm"
%include "interface\Diag\Mouse.asm"
%include "interface\Diag\Video.asm"
%include "interface\Diag\Audio.asm"


;; Símbolos e estruturas úteis ao programa

%include "dados\dados.asm"
%include "dados\infodev.asm"

;; Arquivos com dados de despejo e erros do programa

%include "dados\erros.asm"

;;************************************************************

configurar:

push ax
push bx
push cx
push dx
push es
push gs
push ss
push sp

cli
std
cld
clc
sti

pop sp
pop ss
pop gs
pop es
pop dx
pop cx
pop bx
pop ax

jmp inicio

;;************************************************************

inicio:

call clrscr

call verificar_sistema ;; Caso o sistema não seja suportado, fechar

jmp esculpir_dados ;; Pular para a montagem inicial da interface gráfica

;;************************************************************
