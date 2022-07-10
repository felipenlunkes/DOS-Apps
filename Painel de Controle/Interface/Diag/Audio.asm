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
;;           Interface da página de diagnóstico de Áudio
;;
;;
;;********************************************************************

PovoarInterfaceAudio:

call clrscr

call ativar_interface

call criar_interface

mov bx, TITULO_AUDIO
mov cx, RODAPE_AUDIO
mov ah, POS_TITULO_AUDIO
mov al, POS_RODAPE_AUDIO

call adaptar_interface

call esconder_cursor

mov ah, 02
mov al, 19
call adaptar_pagina

print "Aguarde enquanto o teste e preparado...",0

mov ax, 30
call delay

mov ah, 03
call limpar_linha

mov ah, 02
mov al, 30
call adaptar_pagina

print "Executando teste...",0

mov ax, 30
call delay

mov ah, 03
call limpar_linha

mov ah, 03 ;; Sempre linha + 1
call limpar_linha

.lista_de_acoes:

call Verificar_Audio

jc near .erroAudio

jmp .semErroAudio

.erroAudio:

mov ah, 02
mov al, 02
call adaptar_pagina

print "Foi encontrado um erro durante o teste de audio.",0

mov ah, 04
mov al, 04
call adaptar_pagina

print "[V] - Voltar ao menu anterior...",0

mov ah, 06
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop

.semErroAudio:

mov ah, 02
mov al, 02
call adaptar_pagina

print "Nenhum erro encontrado durante o teste.",0

mov ah, 03
mov al, 02
call adaptar_pagina

print "Entretanto, se voce nao conseguiu escutar os sons emitidos",0

mov ah, 04
mov al, 02
call adaptar_pagina

print "durante o teste, verifique os seguintes itens:",0

mov ah, 06
mov al, 05
call adaptar_pagina

print "- A caixa de som esta ligada corretamente ao computador?",0

mov ah, 07
mov al, 05
call adaptar_pagina

print "- A mesma esta em boas condicoes de funcionamento?",0

mov ah, 09
mov al, 04
call adaptar_pagina

print "[V] - Voltar ao menu anterior...",0

mov ah, 10
mov al, 04
call adaptar_pagina

print "[ESC] - Encerrar o Painel de Controle",0

call esconder_cursor

jmp .loop

.loop:

call identificar_tecla

cmp al, ESCAPE
jz finalizar

cmp al, VMai
jz PovoarInterfaceDiag

cmp al, VMin
jz PovoarInterfaceDiag

cmp al, CTRLC
jz finalizar

jmp .loop

;;************************************************************

TITULO_AUDIO db "Teste de Audio do Painel de Controle",0
RODAPE_AUDIO db "Sistema",0
POS_TITULO_AUDIO equ 22
POS_RODAPE_AUDIO equ 70
