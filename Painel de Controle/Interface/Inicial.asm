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
;;                         Montador de interface
;;
;;
;;********************************************************************

esculpir_dados: ;; Monta inicialmente a interface gráfica

call obterProcessador ;; Obtêm informações relativas ao processador instalado,
                      ;; antes da montagem da interface gráfica e do povoamento
					  ;; dela com as informações pertinentes

jmp PovoarInterfacePrincipal

