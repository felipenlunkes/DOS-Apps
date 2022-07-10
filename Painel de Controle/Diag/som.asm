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

Verificar_Audio:

.sominit:

mov ax, 3600
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 4000
mov bx, 0
call emitirsom

mov ax, 03
call delay


mov ax, 3200
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 3600
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 4000
mov bx, 0
call emitirsom

mov ax, 03
call delay


mov ax, 3200
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 3600
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 4000
mov bx, 0
call emitirsom

mov ax, 03
call delay


mov ax, 3200
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 3600
mov bx, 0
call emitirsom

mov ax, 03
call delay

mov ax, 4000
mov bx, 0
call emitirsom

mov ax, 03
call delay


mov ax, 3200
mov bx, 0
call emitirsom

mov ax, 03
call delay

call desligarsom

ret

;;************************************************************ 