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
;;            Verifica a existência de discos utilizáveis
;;
;;
;;******************************************************************** 

verificar_discos:

 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 00h 
 
 int 13h

 jc .erro
 
 print '[A:] '
 
 jmp .verb
 
 .erro:
  
  jmp .verb
  
  .verb:
  
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 01h 
 
 int 13h
 
 jc .erroB
 
 print '[B:] ',0
 
 jmp VERIFICAR_DISCOS
 
 .erroB:
 

 jmp VERIFICAR_DISCOS
 
;;**************************************************************************

VERIFICAR_DISCOS:

 
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 80h 
 
 int 13h

 jc .erroc
 
 print '[C:] '
 
 jmp .verd
 
 .erroc:
  
  jmp .verd
  
  .verd:
  
 mov AH, 02h
 mov AL, 01h
 mov CH, 01h
 mov CL, 01h
 xor bx, bx
 mov bx, 0x2000
 mov es, bx
 xor bx, bx
 mov DH, 00h
 mov DL, 81h 
 
 int 13h
 
 jc .erroD
 
 print '[D:]',0
 
 jmp Continuar
 
 .erroD:
 

 jmp Continuar
 
;;**************************************************************************

Continuar: ;; Fim da análise, voltar ao que chamou


ret

;;**************************************************************************