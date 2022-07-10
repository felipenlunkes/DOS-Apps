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

marca_proc:

    mov eax, 0
	cpuid
	
	mov [processador_global], ebx
	mov [processador_global + 4 ], edx
	mov [processador_global + 8 ], ecx 
	
	ret

;;************************************************************
