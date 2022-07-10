;;********************************************************************
;;
;;                   Sistema Operacional PX-DOS®
;; 
;;          Copyright © 2013-2016 Felipe Miguel Nery Lunkes
;;                   Todos os direitos reservados
;;
;;
;;         Ajuda e introdução para PX-DOS® 0.9.0 e superiores
;;
;;
;;
;;********************************************************************
;;
;;             Funções para detecção da versão do sistema
;;
;;
;;********************************************************************
	
detectar_sistema_atual:

mov ah, 13h
int 90h

call paraString

mov si, ax
call escrever

print ".",0

jmp subver

;;************************************************************

subver:

mov ah, 13h
int 90h

cmp bx, SUBVERSAO

mov ax, bx
call paraString

mov si, ax
call escrever

print ".",0

jmp revisao

;;************************************************************

revisao:

mov ah, 13h
int 90h

mov ax, cx
call paraString

mov si, ax
call escrever

ret

;;************************************************************