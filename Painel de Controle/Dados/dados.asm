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
;; Símbolos e estruturas úteis ao programa e o gerenciamento de dados
;;
;;                     Seção de dados, somente
;;
;;********************************************************************

section .data align=8

;; Variáveis, contantes e dados relativos ao programa principal
;; Podem conter dados relativos à sinalizadores de versão, direitos
;; autorais e informações repetidas em todo o programa, em todas as interfaces

BUILD db "252",0
BUILD_INFO equ "252"
VERSAO_PAINEL db "1.0",0
REVISAO_PAINEL db " RC1",0
COMPATIBILIDADE_PAINEL db "PX-DOS(R) 0.9.0+",0
COPYRIGHT db "Copyright (C) 2013-2016 Felipe Miguel Nery Lunkes",0
DIREITOS_RESERVADOS db "Todos os direitos reservados.",0

;; Variáveis, contantes e dados relativos a função de testes no teclado
;; do computador, e restritos apenas a ela 

MSG_INICIAL_TECLADO db "Teste de Teclado",10,13
             db "---*---*---*---*---*",10,13,10,13
			 db "Sistema Operacional PX-DOS. (C) 2013-2016 Felipe Miguel Nery Lunkes",10,13
             db 10,13, "Para testar o teclado, digite algo:  ",10,13,10,13
			 db "> ",0
			 
MSG_ESPACO_TECLADO db 10,13,10,13,0
RETORNO_TECLADO db "Pronto! Agora pressione ENTER para sair...",0
MSG_DIGITOU_TECLADO db "Mensagem digitada para realizar o teste:",10,13,10,13,0
MSG_RETORNO_TECLADO times 64 db 0			 

;; Variáveis, contantes e dados relativos a função de testes no mouse
;; do computador, e restritos apenas a ela 

MSG_ENTER_MOUSE db 10,13,"Pressione ENTER para continuar...",10,13,0
   
MSG_SEM_MOUSE  db "",10,13
          db "Mouse",10,13
		  db "---*---*",10,13,10,13
          db "Desculpe, mas seu mouse nao foi reconhecido, esta indisponivel ou",10,13
          db "danificado e nao pode ser inicializado com seguranca.",10,13
          db "",10,13,0
        
MSG_COM_MOUSE   db "",10,13
          db "Mouse",10,13
		  db "---*---*",10,13,10,13
          db "Mouse inicializado com sucesso.",10,13
          db "",10,13,0        

;; Variáveis, contantes e dados relativos a função de verificação do
;; processador principal do computador, e restritos apenas a ela 

processador_global times 13 db 0 ;; Pode ser utilizada em outras funções

