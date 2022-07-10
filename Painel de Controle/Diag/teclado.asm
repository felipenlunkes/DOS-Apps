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


teclado:

call clrscr

mov si, MSG_INICIAL_TECLADO
call escrever

mov di, MSG_RETORNO_TECLADO
call ler

mov si, MSG_ESPACO_TECLADO
call escrever

mov si, MSG_DIGITOU_TECLADO
call escrever

mov si, MSG_RETORNO_TECLADO
call escrever

mov si, MSG_ESPACO_TECLADO
call escrever

mov si, RETORNO_TECLADO
call escrever

mov ax, 0
int 16h

;; jmp alguma coisa

;;************************************************************