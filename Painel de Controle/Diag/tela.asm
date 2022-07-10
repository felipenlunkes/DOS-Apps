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
;;                 Diagnósticos diversos de Hardware
;;
;;
;;********************************************************************

Verificar_Monitor:

clc 

call clrscr

mov ax, 1
call pintartela

mov ax, 10
call delay

mov ax, 2
call pintartela

mov ax, 10
call delay

mov ax, 3
call pintartela

mov ax, 10
call delay

mov ax, 4
call pintartela

mov ax, 10
call delay

mov ax, 5
call pintartela

mov ax, 10
call delay

mov ax, 6
call pintartela

mov ax, 10
call delay

mov ax, 7
call pintartela

mov ax, 10
call delay

ret


;;************************************************************