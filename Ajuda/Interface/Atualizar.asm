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
;;          Interface da página de atualizações de software
;;
;;
;;********************************************************************

PovoarInterfaceAtualizar:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_ATUALIZAR
mov cx, RODAPE_ATUALIZAR
mov ah, POS_TITULO_ATUALIZAR
mov al, POS_RODAPE_ATUALIZAR

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 22
call adaptar_pagina

print "Atualizacoes de Software do Sistema",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "Voce recebera, regularmente, atualizacoes do PX-DOS(R) e de seus aplicativos,",0

mov ah, 05
mov al, 04
call adaptar_pagina

print "para aprimorar cada vez mais sua experiencia com o universo PX-DOS(R).",0

mov ah, 06
mov al, 02
call adaptar_pagina

print "A cada nova atualizacao, novos recursos, aplicativos e apimoramentos serao",0

mov ah, 07
mov al, 04
call adaptar_pagina

print "transportados para seu computador. O PX-DOS(R) estara sempre um passo a",0

mov ah, 08
mov al, 04
call adaptar_pagina

print "frente, para te surpreender.",0

mov ah, 10
mov al, 02
call adaptar_pagina

print "Voce sera noticiado sempre sobre novas atualizacoes de Software.",0

mov ah, 11
mov al, 04
call adaptar_pagina

print "Pode relaxar, o seu Sistema estara sempre pronto para voce!",0


mov ah, 15
mov al, 04
call adaptar_pagina

print "[V] - Voltar a pagina inicial da Ajuda e Introducao",0

mov ah, 16
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar a Ajuda e Introducao",0

call esconder_cursor

.loopAtualizar:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, VMai
jz PovoarInterfacePrincipal

cmp al, VMin
jz PovoarInterfacePrincipal

cmp al, CTRLC
jz finalizar

jmp .loopAtualizar

;;************************************************************

TITULO_ATUALIZAR db "Ajuda e Introducao",0
RODAPE_ATUALIZAR db "Atualizacoes de Software",0
POS_TITULO_ATUALIZAR equ 31
POS_RODAPE_ATUALIZAR equ 53
