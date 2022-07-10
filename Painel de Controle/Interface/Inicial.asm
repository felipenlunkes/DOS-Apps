;;********************************************************************
;;
;;                   Sistema Operacional PX-DOS�
;; 
;;          Copyright � 2013-2016 Felipe Miguel Nery Lunkes
;;                   Todos os direitos reservados
;;
;;
;;         Painel de controle para o PX-DOS� 0.9.0 e superiores
;;
;;
;;
;;********************************************************************
;;
;;                         Montador de interface
;;
;;
;;********************************************************************

esculpir_dados: ;; Monta inicialmente a interface gr�fica

call obterProcessador ;; Obt�m informa��es relativas ao processador instalado,
                      ;; antes da montagem da interface gr�fica e do povoamento
					  ;; dela com as informa��es pertinentes

jmp PovoarInterfacePrincipal

