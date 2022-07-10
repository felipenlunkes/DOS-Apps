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
;;           Módulo de detecção de impressoras conectadas
;;
;;
;;********************************************************************

obterImpressoras:

mov ah, 01h
mov dx, 00h
int 17h

jc near .falha_impressora

mov ah, 01h
mov dx, 01h
int 17h

jc near .falha_impressora

mov ah, 01h
mov dx, 02h
int 17h

jc near .falha_impressora

mov ah, 01h
mov dx, 03h
int 17h

jc near .falha_impressora

print "[Sim]",0

ret

;;**************************************************************************************

.falha_impressora:

print "[Nao]",0

ret

;;**************************************************************************************