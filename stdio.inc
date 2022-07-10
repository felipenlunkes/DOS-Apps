
%ifndef STDIO
%define STDIO

jmp STD_IO_FIM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           DRAW CHAR            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
draw_char:

;coloca um char na linha e coluna escolhidas. ah=linha, al=coluna
;char a ser desenhado em bl

  push ax
  push cx
  push bx
  push dx
  push si
  push ds
  
;verifica se precisa decrementar os valores de linha e coluna


  cmp ah,0
  jz draw_char_nao_decrementa_linha
  
  dec ah
  
draw_char_nao_decrementa_linha:

  cmp al,0
  jz draw_char_nao_decrementa_coluna
  
  dec al
  
draw_char_nao_decrementa_coluna:

  mov cx,bx   ; salva o char (e o atributo) a ser escrito
  mov bx,VIDEO
  mov ds,bx
  mov bx,ax   ;guarda um copia dos valores passados
  mov ax,2*LARGURA ; cada char no buffer de video ocupa 2 bytes
  mov dl,bh   ;pega o valor da LINHA passada
  xor dh,dh   ;zera a parte alta de dx. (precaucao)
  mul dx
  xor bh,bh   ;tira de bx, o valor da linha, ja que agora adicionaremos APENAS as colunas
  add ax,bx   ;a posicao escolhida estah agora em ax
  add ax,bx
  mov bx,cx   ;restaura o char e o atributo
  
  
  mov si,ax
  mov [ds:si],bx

  pop ds
  pop si
  pop dx
  pop bx
  pop cx
  pop ax
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           CLEAR SCREEN            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clear:

  pushad
  mov ah,00
  mov al,3
  int 10h
  popad
  ret

esconde_cursor:

  ret

mostra_cursor:

  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;           BIG ECHO                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;ah=linha,al=coluna,bx=inicio da msg(ponteiro),cl=atributo de cor!

draw_big_echo:

  pushad
  mov dx,cx
  
draw_big_echo_loop:

  mov cx,dx
  call draw_string         ;DESENHA A STRING
  
  push bx                  ;GUARDA NA PILHA O PONTEIRO
  
  call str_len             ;CALCULA O TAMANHO DA STRING (POR ISSO EMPILHEI BX, PORQUE STR_LEN MODIFICA BX E ELE ATUALMENTE EH MEU PONTEIRO PARA A STRING
  
  mov cx,bx                ;GUARDA O RESULTADO EM CX
  pop bx                   ;RESAURA O PONTEIRO
  add bx,cx                ;AVANCA "STR_LEN" POSICOES NA STRING
  inc bx                   ;PULA O CARACTERE '0', QUE SEPARA AS STRINGS
  mov byte cl,[bx]         ;PEGA MAIS UM CHAR
  
  cmp cl,'$'               ;'$' SIGNIFICA FIM DE TUDO! HORA DE VOLTAR PRA CASA...
  
  jz draw_big_echo_fim
  
  inc ah                   ;INCREMENTE A LINHA, ASSIM A PROXIMA PARTE DA STRING FICARAH EXATAMENTE DEBAIXO DA ANTERIOR  
  
  jmp draw_big_echo_loop
  
draw_big_echo_fim:

  popad
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            DRAW STRING           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

draw_string:

;parametros: ah=linha, al=coluna, bx=inico da string(ponteiro), cl=atributo!
  
  pushad
  mov dx,cx
  
draw_string_loop:
  
  mov byte cl,[bx]
  
  cmp cl,0
  jz draw_string_fim
  
  push bx
  mov bl,cl
  mov bh,dl
  
  call draw_char
  
  pop bx
  inc bx
  inc al
  
  jmp draw_string_loop

draw_string_fim:

  popad
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            ESCNUM             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;converte o numero em ax para uma string correspondente


;xor dx,dx   ;tem que zerar, senao dah DIVIDE OVERFLOW!
;mov ax,50h
;mov bx,0ah
;div bx    (divide ax/bx, ax=quociente e dx=resto)

binasc:   
              
  push bx
  push bp
  push dx

  mov bx,0ah
  xor bp,bp
  xor dx,dx
  
;ah = resto  al = quoc
;ax = quoc    dx = resto

div_loop:

  div bx
  
  cmp ax,0              ;quoc em al
  jz fim_div
  
  add dx,30h            ;resto em ah
  mov byte[Numero+bp],dl
  inc bp
  xor dx,dx
  
  jmp div_loop
  
fim_div:

  add dx,30h
  mov byte[Numero+bp],dl
  inc bp
  mov byte[Numero+bp],0h
  mov ax,0
  push ax
  xor bp,bp
  
inverte:

  mov al,[Numero+bp]
  
  cmp al,0
  jz fim_inverte
  mov ah,00h
  push ax
  inc bp
  
  jmp inverte
  
fim_inverte:

  xor bp,bp
  
desempilha:

  pop ax
  
  cmp ax,00h
  jz fim_desempilha
  
  mov byte[Numero+bp],al
  inc bp
  
  jmp desempilha
  
fim_desempilha:

  mov byte[Numero+bp],0h

;;;;;;;;;;

  pop bp
  pop bx
  pop dx
  ret

STD_IO_FIM:

%endif