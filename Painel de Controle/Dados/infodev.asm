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
;;  Informações de desnvolvimento e dados do aplicativo para debug
;;
;;                     Seção de dados, somente
;;
;;********************************************************************

section .data align=8

DATA_BUILD db __DATE__
HORA_BUILD db __TIME__
ESPACAMENTO1 times 10 db " "
DIA_BUILD db "Dia ",__DATE__," as ",__TIME__,0
ESPACAMENTO2 times 10 db " "
BANNER_BUILD db "Painel de controle compilado, sob serie ", BUILD_INFO, " em ", __DATE__, " as ", __TIME__, " horas.",0

