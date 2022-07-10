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

Verificar_Mouse:

clc

mov ax, 0
int 33h

cmp ax, 0

jne mousefunciona

stc

ret

mousefunciona:

clc

ret

;;************************************************************
