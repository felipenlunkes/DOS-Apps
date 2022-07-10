;;********************************************************************
;;
;;                   Sistema Operacional PX-DOS�
;; 
;;          Copyright � 2013-2016 Felipe Miguel Nery Lunkes
;;                   Todos os direitos reservados
;;
;;
;;         Ajuda e introdu��o para PX-DOS� 0.9.0 e superiores
;;
;;
;;
;;********************************************************************
;;
;; S�mbolos e estruturas �teis ao programa e o gerenciamento de dados
;;
;;                     Se��o de dados, somente
;;
;;********************************************************************

section .data align=8

;; Vari�veis, contantes e dados relativos ao programa principal
;; Podem conter dados relativos � sinalizadores de vers�o, direitos
;; autorais e informa��es repetidas em todo o programa, em todas as interfaces

BUILD db "003",0
BUILD_INFO equ "003"
VERSAO_AJUDA db "0.5.5",0
REVISAO_AJUDA db " RC1",0
COMPATIBILIDADE_AJUDA db "PX-DOS(R) 0.9.0+",0
COPYRIGHT db "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes",0
DIREITOS_RESERVADOS db "Todos os direitos reservados.",0

;; Vari�veis, contantes e dados relativos a fun��o de verifica��o do
;; processador principal do computador, e restritos apenas a ela 

processador_global times 13 db 0 ;; Pode ser utilizada em outras fun��es

