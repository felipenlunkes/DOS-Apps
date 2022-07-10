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
;;            Módulo de detecção de processador instalado
;;
;;
;;********************************************************************


obterProcessador:

    mov eax, 80000002h	
	cpuid
	
	mov di, produto		
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd
	mov eax, edx
	stosd
	
	mov eax, 80000003h	
	cpuid
	
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd
	mov eax, edx
	stosd
	
	mov eax, 80000004h	
	cpuid
	
	stosd
	mov eax, ebx
	stosd
	mov eax, ecx
	stosd 
	mov eax, edx
	stosd
	mov si, produto		
	mov cx, 48
	
loop_CPU:	

    lodsb
	cmp al, ' '
	jae formatarNomeCPU
	mov al, '_'
	
formatarNomeCPU:	

    mov [si-1], al
	loop loop_CPU

	ret
	
;;************************************************************

NomeProcessador	db "Nome do Processador: ["

produto	db "abcdabcdabcdabcdABCDABCDABCDABCDabcdabcdabcdabcd]",0	